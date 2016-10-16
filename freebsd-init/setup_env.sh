#!/bin/sh

# Must run as primary_user
set -o errexit
set -o nounset

tag="[setup_env]"

printf "$tag Starting: USER=%s ...\n" "$USER"

