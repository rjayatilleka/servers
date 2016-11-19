#!/bin/sh
# THIS IS AN INTERACTIVE SCRIPT

set -o errexit
set -o nounset

# scp server conf to openvpn.conf
# scp easy rsa vars to vars

sudo pkg update
sudo pkg install openvpn

sudo rm -rf /usr/local/etc/openvpn
sudo mkdir /usr/local/etc/openvpn

sudo mv ~/server.conf /usr/local/etc/openvpn/openvpn.conf

sudo cp -r /usr/local/share/easy-rsa /usr/local/etc/openvpn/easy-rsa
sudo mv ~/easy-rsa.vars /usr/local/etc/openvpn/easy-rsa/vars

cd /usr/local/etc/openvpn/easy-rsa

sudo ./easyrsa.real init-pki
sudo ./easyrsa.real build-ca
sudo ./easyrsa.real build-server-full openvpn-server nopass
sudo ./easyrsa.real build-client-full anna
sudo ./easyrsa.real gen-dh

sudo mkdir /usr/local/etc/openvpn/keys

sudo cp \
  pki/dh.pem \
  pki/ca.crt \
  pki/issued/openvpn-server.crt \
  pki/private/openvpn-server.key \
  /usr/local/etc/openvpn/keys

sudo cp pki/ca.crt pki/issued/anna.crt pki/private/anna.key /tmp/
sudo chown `whoami` pki/ca.crt pki/issued/anna.crt pki/private/anna.key
