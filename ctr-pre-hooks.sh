#!/bin/bash

# Commands in this script are ran in the local container image before anything else is ran. This is used to apply ISO-specific changes, such as autologin and installer setup. 

# Set hostname to apollolive
rm -f /etc/hostname && echo apollolive > /etc/hostname

# Apply autologin settings to GDM
tee -a /etc/gdm/custom.conf <<EOL
[daemon]
AutomaticLoginEnable=True
AutomaticLogin=liveuser
EOL
