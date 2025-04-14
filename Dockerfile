# Use the official Ubuntu 24.04 base image
FROM ubuntu:24.04

# Set environment variable to suppress interactive prompts during installation
ENV DEBIAN_FRONTEND=noninteractive

# Preconfigure keyboard layout to English (US)
RUN echo 'keyboard-configuration keyboard-configuration/layoutcode select us' | debconf-set-selections

# Update, Upgrade and Install packages
RUN apt-get update -y && apt-get upgrade -y

RUN apt-get install --no-install-recommends xfce4-session \
    xfwm4 xfce4-panel thunar zutty \
    xinit xserver-xorg xserver-xorg-core -y

RUN apt-get install -y \
    xrdp xorg dbus dbus-x11 x11-xserver-utils \
    sudo htop wget curl nano gnupg gdebi iproute2 net-tools dialog util-linux uuid-runtime \
    apt-transport-https openssh-server xdotool proxychains4

RUN apt-get install -y \
    ca-certificates fonts-liberation xdg-utils \
    libasound2t64 libatk-bridge2.0-0 libatk1.0-0 \
    libatspi2.0-0 libc6 libcairo2 libcups2 \
    libcurl4 libdbus-1-3 libexpat1 libgbm1 \
    libglib2.0-0 libgtk-3-0 libgtk-3-bin libgtk-4-1 \
    libnspr4 libnss3 libpango-1.0-0 libudev1 libuuid1 \
    libvulkan1 libx11-6 libxau6 libxcb-glx0 libxcb1 \
    libx11-xcb1 libxcb-icccm4 libxcb-image0 libxcb-shm0 \
    libxcb-keysyms1 libxcb-randr0 libxcb-render-util0 \
    libxcb-sync1 libxcb-xfixes0 libxcb-render0 libxcb-shape0 \
    libxcb-xinerama0 libxcb-xkb1 libxkbcommon-x11-0 libxkbcommon0 \
    libgl1 libappindicator3-1 libnotify4 libnotify-bin \
    libxcomposite1 libxdamage1 libxext6 libxfixes3 libxrandr2 \
    libxcb-util1 libxdmcp6 libbsd0

# Download and install the Wipter application
RUN wget -O /tmp/wipter.deb https://github.com/hoainv1807/Docker-Ubuntu-XFCE-XRDP/releases/download/wipter/wipter.deb && \
     gdebi --n /tmp/wipter.deb && \
     rm /tmp/wipter.deb

# Download Uprock and install
RUN wget -O /tmp/uprock_v0.0.8.deb https://github.com/hoainv1807/Docker-Ubuntu-XFCE-XRDP/releases/download/wipter/uprock_v0.0.8.deb
RUN gdebi --n /tmp/uprock_v0.0.8.deb && \
    rm /tmp/uprock_v0.0.8.deb

# Grass
COPY Grass.deb /tmp/
RUN apt install /tmp/Grass.deb -y && apt update && apt install -f -y && rm /tmp/Grass.deb
# Configure a passwordless default keyring to avoid authentication prompts
RUN mkdir -p /root/.local/share/keyrings && \
    touch /root/.local/share/keyrings/default.keyring && \
    echo -n "" > /root/.local/share/keyrings/default.keyring

# Move OpenSSH Server to 22222
RUN sed -i 's/#Port 22/Port 22222/' /etc/ssh/sshd_config && \
    sed -i 's/#PermitRootLogin prohibit-password/PermitRootLogin yes/' /etc/ssh/sshd_config && \
    echo "ListenAddress 0.0.0.0" >> /etc/ssh/sshd_config && \
    echo "ListenAddress ::" >> /etc/ssh/sshd_config && \
    mkdir -p /var/run/sshd

# Clean up unnecessary packages and cache to reduce image size
RUN apt-get autoclean && apt-get autoremove -y && apt-get autopurge -y && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# Configure XRDP to launch the XFCE desktop environment by default
RUN echo "startxfce4" > /etc/skel/.xsession

# Expose the XRDP service port
EXPOSE 3389 22222

# Copy entrypoint script to the image and make it executable
COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

# Set the entrypoint script as the default command to run at container startup
CMD ["/entrypoint.sh"]
