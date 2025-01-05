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

**1. Packer Configuration (gatus-latest.pkr.hcl)**

**2. Cloud init Template (cloud-init-template.yaml)**

**3. Get snapshot ready for Marketplace (vultr-helper.sh)**

**4. Setup Script (helper.sh)**

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

## Marketplace App creation process

1. Create a Vultr account if you haven't already

2. Go to Marketplace and Create New App

![image](https://github.com/user-attachments/assets/56cc7c8a-8eef-4875-89a1-3f478ed944b1)

3. Fill in details and documentation of your app

![image](https://github.com/user-attachments/assets/008b5a0d-a212-4472-8894-416eaf9be1e6)

4. Add App variables

![image](https://github.com/user-attachments/assets/0f18dbcf-5361-4af2-a508-85dcdd3e3572)

5. Submit a App Instruction guide for the information page of the application

![image](https://github.com/user-attachments/assets/a0e4685b-1ed6-4298-b7eb-7326fe869318)

6. Build image of your app (mentioned build process above) it will create a snapshot

![image](https://github.com/user-attachments/assets/e1c62368-9017-4e9b-982b-27e1c4f8f863)

7. Go to Builds and Select Build App Image From A Snapshot, then select the snapshot

![image](https://github.com/user-attachments/assets/ab3ae080-e8f6-4adc-8f94-cf965c86f072)

8. Now click on Build App Image

![image](https://github.com/user-attachments/assets/0629f22c-3b52-44a4-a44f-9ec3522842ff)

9. Now deploy the app

![image](https://github.com/user-attachments/assets/e7a68936-487b-4c96-9f53-40fdfea30666)

10. Fill requested details to deploy the app (User-spupplied Variables - Required and Server hostnmae & Label - Optional)

![image](https://github.com/user-attachments/assets/0f046213-9684-432c-b73a-182972bc37b4)

![image](https://github.com/user-attachments/assets/c6d0391f-bc42-48b1-94dc-ece9123071df)

11. Click on Deploy Now

![image](https://github.com/user-attachments/assets/ea128636-7f4c-4961-884f-73c0e35b149e)

12. It will take some time to get the instance running

![image](https://github.com/user-attachments/assets/20407f40-88fa-4cd9-b7c7-9ab81f1b0aad)

Now click on View in Console

![image](https://github.com/user-attachments/assets/4c5f6712-0bc3-4a30-99c1-24b650508c98)

13. Now, you can see the url to access your app

![image](https://github.com/user-attachments/assets/8fd6b2dd-75d5-4a94-a8b4-29809dd62277)

![image](https://github.com/user-attachments/assets/a0faa465-6a4e-4cb6-951c-5c9517115ec9)

![image](https://github.com/user-attachments/assets/7a8e770b-4557-4e72-b769-c6218983478f)

14. Your application is deployed!

15. Now, if you want to re-configure the application:

You can find the config file here: /gatus-config/config.yaml

![image](https://github.com/user-attachments/assets/a507e2a7-d267-4fbc-858e-7bd3f5ab1841)

Update this config file according to your requirement and then stop the container and re-run
```bash
docker stop gatus
docker rm gatus
docker run -d --name gatus \
    -v "/gatus-config/config.yaml:/config/config.yaml" \
    -p 8080:8080 \
    --restart always \
    twinproduction/gatus
```

