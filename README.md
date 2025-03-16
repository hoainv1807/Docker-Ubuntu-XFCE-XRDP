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

### 1. Build the Docker Image
Clone the repository and build the Docker image:
```bash
docker build -t debian-xfce-xrdp .
