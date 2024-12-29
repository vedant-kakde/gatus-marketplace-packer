#!/bin/bash
################################################
## Prerequisites
chmod +x /root/vultr-helper.sh
. /root/vultr-helper.sh
error_detect_on
install_cloud_init latest

################################################
## Install your app here.
set -e

port=8080
gatus_username=$(curl -H "METADATA-TOKEN: vultr" http://169.254.169.254/v1/internal/app-gatus_username)
gatus_password=$(curl -H "METADATA-TOKEN: vultr" http://169.254.169.254/v1/internal/app-gatus_password)
monitoring_url=$(curl -H "METADATA-TOKEN: vultr" http://169.254.169.254/v1/internal/app-monitoring_url)
monitoring_int=$(curl -H "METADATA-TOKEN: vultr" http://169.254.169.254/v1/internal/app-monitoring_int)

# Colors for output
GREEN='\033[0;32m'
RED='\033[0;31m'
NC='\033[0m'

echo -e "${GREEN}Starting Gatus setup...${NC}"

# Update system packages
echo -e "${GREEN}Updating system packages...${NC}"
sudo apt-get update -y
sudo apt-get upgrade -y

# Install Docker if not installed
if ! command -v docker &>/dev/null; then
    echo -e "${GREEN}Installing Docker...${NC}"
    curl -fsSL https://get.docker.com | sh
    
    # Enable and start Docker service
    sudo systemctl enable docker
    sudo systemctl start docker
    
    # Verify Docker is running
    sudo systemctl status docker --no-pager || { echo -e "${RED}Failed to start Docker service${NC}"; exit 1; }
fi

# Install required tools for password hashing
if ! command -v htpasswd &>/dev/null; then
    echo -e "${GREEN}Installing Apache Utils (htpasswd)...${NC}"
    sudo apt-get install apache2-utils -y
fi

# Check if required environment variables are set
if [[ -z "$gatus_username" || -z "$gatus_password" || -z "$monitoring_url" || -z "$monitoring_int" || -z "$port" ]]; then
    echo -e "${RED}Required environment variables are missing. Please ensure gatus_username, gatus_password, monitoring_url, monitoring_int are set.${NC}"
    exit 1
fi

# Generate bcrypt hash of the password in Base64 format
echo -e "${GREEN}Hashing the password...${NC}"
HASHED_PASSWORD=$(htpasswd -bnBC 10 "" "$gatus_password" | tr -d ':\n' | base64 | tr -d '\n')

# Fetch public IP
PUBLIC_IP=$(curl -4 ifconfig.me)

# Generate config.yaml
echo -e "${GREEN}Generating config.yaml...${NC}"

mkdir -p "$HOME/gatus-config"

cat <<EOF >"$HOME/gatus-config/config.yaml"
web:
  port: $port
  address: 0.0.0.0

security:
  basic:
    username: "$gatus_username"
    password-bcrypt-base64: "$HASHED_PASSWORD"

endpoints:
  - name: website
    url: "$monitoring_url"
    interval: "$monitoring_int"
    conditions:
      - "[STATUS] == 200"
EOF

# Run Gatus in Docker
echo -e "${GREEN}Starting Gatus in Docker...${NC}"
docker run -d --name gatus \
    -v "$HOME/gatus-config/config.yaml:/config/config.yaml" \
    -p $port:$port \
    --restart always \
    twinproduction/gatus

# Enable UFW if it is not already enabled
sudo ufw enable

# Allow traffic on port 8080 for TCP
sudo ufw allow 8080/tcp

# Reload the UFW to ensure changes are applied
sudo ufw reload

# Check the status of UFW and list rules
sudo ufw status verbose

# Output success message
echo -e "${GREEN}Gatus setup complete!${NC}"
echo -e "You can access the dashboard at: http://$PUBLIC_IP:$port"
echo -e "Username: ${gatus_username}"
echo -e "Password: ${gatus_password}"

################################################
## Prepare server snapshot for Marketplace
clean_system
