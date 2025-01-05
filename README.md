# Publishing an Image-Based App on Vultr Marketplace Using Packer

This guide outlines the process of creating and publishing an image-based application on the Vultr Marketplace using Packer.

## Prerequisites

- [Packer](https://www.packer.io/) (version 1.7.0 or higher)
- [Vultr API Key](https://my.vultr.com/settings/#settingsapi)

## Project Structure

```
gatus-marketplace-packer/
├── README.md
├── cloud-init-template.yaml
├── vultr-helper.sh
├── helper.sh
└── gatus-latest.pkr.hcl
```

## Configuration Files

### 1. Packer Configuration (gatus-latest.pkr.hcl)

### 2. Cloud init Template (cloud-init-template.yaml)

### 3. Get snapshot ready for Marketplace (vultr-helper.sh)

### 4. Setup Script (helper.sh)

This script runs during the Packer build process

## Build Process

1. Initialize Packer with the Vultr plugin:
```bash
packer init gatus-latest.pkr.hcl
```

2. Set your Vultr API key:
```bash
export VULTR_API_KEY='your-api-key'
```

3. Build the image:
```bash
packer build gatus-latest.pkr.hcl
```

## Marketplace Integration

### Required Files for Submission

1. **General Information:**
   - App Name, App Name ID Format
   - Repo URL
   - Operating System
   - Category

2. **Screenshots/Images:**
   - App icon Small (At least 88px height, max width of 186px)
   - Appp icon Large (At least 236px height, at least 236px width)
   - Product screenshot(s) (minimum 1280x720px)

3. **Documentation:**
   - Installation guide
   - Usage instructions
   - Configuration options
   - Troubleshooting steps

### App Variables
App variables are used to deploy and configure the application.
   - `gatus_username`: Username for accessing the Gatus dashboard.
   - `gatus_password`: Password for accessing the Gatus dashboard.
   - `monitoring_url`: The URL of the service you want to monitor (e.g., `https://www.google.com`).
   - `monitoring_int`: The interval between monitoring checks (e.g., `30s`, `1m`, `5m`).

## Submission Process

1. Create a Vultr account if you haven't already
2. Contact Vultr marketplace team
3. Submit your app for review with required materials
4. Address any feedback from the review process
5. Await approval and publication

