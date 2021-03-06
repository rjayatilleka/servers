#!/bin/sh

# Must run as sudo
set -o errexit
set -o nounset

user="$1"
name="$2"

tag="[bootstrap]"

printf "$tag Starting: user=%s name=%s ...\n" "$user" "$name"

# Update package management tool
printf "$tag Updating pkg...\n"
pkg update
pkg upgrade -y pkg

# Install bash
printf "$tag Installing bash...\n"
pkg install -y bash
touch /etc/fstab
if ! (cut -f2 /etc/fstab | grep -q -E '^/dev/fd$'); then
  printf "$tag Mounting /dev/fd...\n"
  mount -t fdescfs fdesc /dev/fd
  printf "fdesc\t/dev/fd\tfdescfs\trw\t0\t0\n" >> /etc/fstab
fi

# Make primary user
printf "$tag Making primary user...\n"
if ! (grep -q "^${user}:" /etc/group); then
  pw groupadd "$user"
fi
if ! (grep -q "^${user}:" /etc/passwd); then
  pw useradd -n "$user" -c "$name" -g "$user" -G wheel -m
fi
chsh -s /usr/local/bin/bash "$user"

# Authorized keys readable
printf "$tag Making authorized key file available...\n"
chmod +r authorized_keys

# /usr/local/opt for custom software
printf "$tag Making /usr/local/opt...\n"
mkdir -p /usr/local/opt

# Remove MOTD
printf "$tag Removing MOTD...\n"
rm -f /etc/motd

printf "$tag Done with bootstrap.\n"
