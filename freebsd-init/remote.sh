# Run as root

pkg update
pkg upgrade -y pkg

pkg install -y bash
mount -t fdescfs fdesc /dev/fd
printf "fdesc /dev/fd   fdescfs   rw  0 0" >> /etc/fstab

pkg install -y vim

rm /etc/motd

chsh -s /usr/local/bin/bash freebsd
