# Use the official Debian base image
FROM debian:bullseye

# Set environment variables to disable interactive prompts
ENV DEBIAN_FRONTEND=noninteractive

# Preconfigure keyboard layout to English (US)
RUN echo 'keyboard-configuration keyboard-configuration/layoutcode select us' | debconf-set-selections

# Update and install necessary packages
RUN apt-get update -y && apt-get upgrade -y
RUN apt-get install -y xfce4 xfce4-goodies xfce4-notifyd xfce4-whiskermenu-plugin xfce4-netload-plugin xfce4-cpufreq-plugin
RUN apt-get install -y xorg dbus-x11 x11-xserver-utils xrdp sudo htop wget curl nano gnupg gdebi iproute2 net-tools rsync

# Install Firefox
RUN apt-get update -y && apt-get install -y firefox

# Add Google's PPA and install Google Chrome
RUN wget -q -O - https://dl.google.com/linux/linux_signing_key.pub | gpg --dearmor -o /usr/share/keyrings/google-chrome-keyring.gpg && \
    echo "deb [signed-by=/usr/share/keyrings/google-chrome-keyring.gpg] http://dl.google.com/linux/chrome/deb/ stable main" > /etc/apt/sources.list.d/google-chrome.list && \
    apt-get update -y && apt-get install -y google-chrome-stable && \

# Clean Up
RUN apt-get autoclean
RUN apt-get autoremove
RUN apt-get autopurge

# Configure XRDP
RUN echo "startxfce4" > /etc/skel/.xsession

# Expose XRDP port
EXPOSE 3389

# Add a script to dynamically create the user and set up XRDP at runtime
COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

# Run the entry point script
CMD ["/entrypoint.sh"]
