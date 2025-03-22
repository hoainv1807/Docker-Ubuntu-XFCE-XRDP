# Ubuntu XFCE Desktop with XRDP (Dockerized)

## Overview
This project provides a Dockerized Ubuntu-based remote desktop environment leveraging XFCE4 as the desktop environment and XRDP for remote access. It comes equipped with pre-installed utilities and features dynamic user creation at runtime. An additional run.sh script is included to simplify container execution.

## Features
- Lightweight Desktop Environment: Utilizes XFCE4 for a minimal yet user-friendly experience.
- Remote Access: Configured XRDP on port 3389 (customizable).
- Pre-installed Utilities: Includes essential tools such as htop, curl, and more.
- Dynamic User Management: Define the username and password dynamically via environment variables.
- Quick Start: Includes a pre-defined run.sh script for effortless container deployment.
- Streamlined Package Management: Reduces image size with cleanup commands.
- Preloaded with Wipter, Uprock, Grass

## Usage
- Environment Variables
- The following environment variables are used for user customization:
  - USERNAME: Specifies the username for the remote desktop session.
  - PASSWORD: Specifies the password for the remote desktop session.


## Instructions
```
git clone https://github.com/hoainv1807/Docker-Ubuntu-XFCE-XRDP.git
cd Docker-Ubuntu-XFCE-XRDP
docker build -t ubuntu-xfce-xrdp . --no-cache

#### Run by bash file
chmod +x *.sh
nano run.sh
## Change 5001 to any port you like (xrdp)
## Change 4001 to anh port you like (ssh)
## Change the USERNAME and PASSWORD (xrdp login)

./run.sh

### Run by terminal
docker run -d --name Ubuntu-1 --shm-size 1g  --cpus 1   --restart always   --cap-add=SYS_ADMIN  -p 5001:3389  -p 4001:22222  -e USERNAME=TEST -e PASSWORD=TEST  ubuntu-xfce-xrdp
```

## File Structure
```
.
├── Dockerfile          # Builds the Debian-based image
├── entrypoint.sh       # Runtime script for user setup and XRDP services
├── run.sh              # Simplifies container execution
└── README.md           # Documentation for the project
```
