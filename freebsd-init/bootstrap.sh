#!/bin/sh
# Must run as root

set -o errexit
set -o nounset

# Update package management tool
pkg update
pkg upgrade -y pkg

# Install bash
pkg install -y bash
mount -t fdescfs fdesc /dev/fd
printf "fdesc /dev/fd   fdescfs   rw  0 0" >> /etc/fstab

# Make ramith user
pw groupadd ramith
pw useradd -n ramith -c "Ramith Jayatilleka" -g ramith -G wheel -m
chsh -s /usr/local/bin/bash ramith

# Clean home directory
rm -rf /home/ramith/*

# Setup authorized_keys file (does not copy key)
mkdir /home/ramith/.ssh
touch /home/ramith/.ssh/authorized_keys
