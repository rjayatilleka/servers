#!/bin/sh

# Must run as primary_user
set -o errexit
set -o nounset

tag="[setup_env]"

printf "$tag Starting: USER=%s ...\n" "$USER"

# Install packages
printf "$tag Installing packages...\n"
sudo pkg install -y git neovim

# Setting up config home
printf "$tag Setting up .config/...\n"
cd
mkdir -p .config

# Cloning bashrc
printf "$tag Cloning bashrc...\n"
cd ~/.config
[ -d bashrc ] || git clone https://github.com/rjayatilleka/bashrc
cd
printf "echo \$HOSTNAME\nsource $HOME/.bashrc\n" > .bash_profile
printf "source $HOME/.config/bashrc/main.bash\n" > .bashrc

# Cloning vimrc
printf "$tag Cloning vimrc...\n"
cd ~/.config
[ -d nvim ] || git clone https://github.com/rjayatilleka/nvim-config nvim
cd nvim
sed -i'' -e "s/^Module 'plugins'\$/Module 'remote'/" init.vim

printf "$tag Done setting up primary env.\n"
