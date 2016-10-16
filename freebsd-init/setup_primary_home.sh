#!/bin/sh

# Must run as primary_user
set -o errexit
set -o nounset

bootstrap_user="$1"

tag="[setup_primary_home]"

printf "$tag Starting: bootstrap_user=%s USER=%s ...\n" "$bootstrap_user" "$USER"

# Clean home directory
printf "$tag Cleaning home directory...\n"
cd
rm -rf * .[!.]*

# Setup ssh
printf "$tag Setting up ssh...\n"
mkdir .ssh
cp "/home/$bootstrap_user/authorized_keys" .ssh/authorized_keys

printf "$tag Done setting up primary home.\n"
