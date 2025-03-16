# Debian XFCE Desktop with XRDP (Dockerized)

## Overview
This repository offers a pre-configured Docker container with a Debian XFCE desktop environment and XRDP support. It allows users to access the GUI via Remote Desktop Protocol (RDP). The setup is ideal for those looking for a lightweight, flexible solution for GUI-based tasks in a containerized environment.

## Features
- Lightweight XFCE desktop environment
- Pre-installed Google Chrome
- Remote desktop access via XRDP
- Dynamic user creation with customizable username and password
- Simple, non-interactive installation process for seamless configuration

## Usage

## Instructions
Clone the repository:
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
