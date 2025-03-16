# Debian XFCE Desktop with XRDP (Dockerized)

## Overview
This project provides a Dockerized Debian-based remote desktop environment leveraging XFCE4 as the desktop environment and XRDP for remote access. It comes equipped with pre-installed utilities such as Google Chrome and features dynamic user creation at runtime. An additional run.sh script is included to simplify container execution.

## Features
- Lightweight Desktop Environment: Utilizes XFCE4 for a minimal yet user-friendly experience.
- Remote Access: Configured XRDP on port 3389 (customizable).
- Pre-installed Utilities: Includes essential tools such as Google Chrome, htop, curl, and more.
- Dynamic User Management: Define the username and password dynamically via environment variables.
- Quick Start: Includes a pre-defined run.sh script for effortless container deployment.
- Streamlined Package Management: Reduces image size with cleanup commands.

## Usage
- Environment Variables
- The following environment variables are used for user customization:
  - USERNAME: Specifies the username for the remote desktop session.
  - PASSWORD: Specifies the password for the remote desktop session.


## Instructions
```
git clone https://github.com/techroy23/Docker-Debian-XFCE-XRDP/
cd Docker-Debian-XFCE-XRDP
docker build -t debian-xfce-xrdp . --no-cache

chmod +x run.sh
nano run.sh
## Change 50001 to any port you like
## Change the USERNAME and PASSWORD

./run.sh
```

## File Structure
```
.
├── Dockerfile          # Builds the Debian-based image
├── entrypoint.sh       # Runtime script for user setup and XRDP services
├── run.sh              # Simplifies container execution
└── README.md           # Documentation for the project
```
