#!/bin/sh

# Must run as primary_user
set -o errexit
set -o nounset

bootstrap_user="$1"

tag="[setup_home]"

printf "$tag Starting: bootstrap_user=%s USER=%s ...\n" "$bootstrap_user" "$USER"

# Clean home directory
printf "$tag Cleaning home directory...\n"
cd
rm -rf .cshrc	.login_conf .mailrc	.rhosts .login .mail_aliases .profile .shrc

# Setup ssh
printf "$tag Setting up ssh...\n"
mkdir -p .ssh
src_ak="/home/$bootstrap_user/authorized_keys"
dest_ak="$HOME/.ssh/authorized_keys"
if ! ([ -f "$dest_ak" ] || cmp --silent "$src_ak" "$dest_ak"); then
  printf "$tag Adding authorized key...\n"
  cat "$src_ak" >> "$dest_ak"
fi

printf "$tag Done setting up primary home.\n"
