#!/bin/sh
##
# @author Harald Hauknes <harald@hauknes.org>
#
# This script gets you ready to use ansible, but it's a little rough around the edges still.
# It's advisable to just take inspiration from the script and execute the commands yourself.
##
decide_packager () {
        # Set default
        packager=dnf
        # Source OS-info
        . /etc/os-release
        case "$ID" in
        "fedora" | "almalinux" | "rhel")
                echo "RHEL-based OS detected, will use 'dnf'"
                packager="dnf install -y"
                ;;
        "debian" | "ubuntu" | "kali")
                echo "Debian-based OS detected, will use 'apt'"
                packager="apt install -y"
                ;;
        *)
                echo "ERROR: Your version of linux is not recognized by this script, so be sure to read the script and install your own packages"
                echo "Will try to continue after you press <Enter>:"
                read -n 1 -s -r -p ""
                ;;
		esac
        }
decide_packager
user=`whoami`
# Python installed by dependencies
if test "$user" != "root"
then
  sudo $packager python3-pip sshpass
else
  $packager python3-pip sshpass
fi
#TODO: Try the package first, not the other way around
sudo pip install pipx
if test "$?" -eq 1
then
  echo Broken packages-warning? Will try to install pipx-package
  sudo $packager pipx
fi
echo $?
# Use pipx to not break system packages
# TODO: Try to de-escalate if ran as root?
pipx install ansible-core
pipx ensurepath
bash
#TODO: Manually add path first
ansible-galaxy collection install community.general

