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

# Make home dir (set owner and permissions)


