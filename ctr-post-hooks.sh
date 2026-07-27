#!/bin/bash

set -uexo pipefail

# Commands in this script are ran in the local container image before anything else is ran. 
# This is used to apply ISO-specific changes, such as autologin and installer setup. 

# Copy files from /app/iso_files
rsync -rvK /app/iso_files/ /

# Refresh pacman database
pacman -Sy

# Apply autologin settings to GDM
tee -a /etc/gdm/custom.conf <<EOL
[daemon]
AutomaticLoginEnable=True
AutomaticLogin=liveuser
EOL

# Install preinstalled Flatpaks
flatpak preinstall -y

# Apply gschema overrides
glib-compile-schemas --strict /usr/share/glib-2.0/schemas

# Add deps for eleven
sudo pacman -S --noconfirm \
    meson \
    ninja \
    gtk4 \
    git \
    appstream \
    python-gobject \
    libadwaita

# Install Eleven
git clone https://github.com/apollo-linux/eleven.git eleven
cd eleven
INSTALL_PREFIX="/usr/" just setup-builddir
just install

# Start Eleven on startup
ln -s /usr/share/applications/dev.getapollo.Eleven.desktop /etc/xdg/autostart/dev.getapollo.Eleven.desktop