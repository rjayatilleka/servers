#!/usr/local/bin/bash
# Must run as root

set -o errexit
set -o nounset

rm /etc/motd

pkg install -y git
pkg install -y neovim
pkg install -y fzf

#chsh -s /usr/local/bin/bash freebsd
