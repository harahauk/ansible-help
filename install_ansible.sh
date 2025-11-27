#!/bin/sh
##
# @author Harald Hauknes <harald@hauknes.org>
#
# This script gets you ready to use ansible, but it's a little rough around the edges still.
# It's advisable to just take inspiration from the script and execute the commands yourself.
##
decide_packager () {
        # Default to dnf
        packager=dnf
        # Determine operating-system
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
                echo "Will try to continue after you press <Enter>"
                echo "If you don't know what you are doing please press <CTRL-C> instead or otherwise kill this session:"
                read -n 1 -s -r -p ""
                ;;
		esac
        }
decide_packager
user=`whoami`
# Dependencies: Make sure python3 and sshpass are installed
if test "$user" != "root"
then
  echo "Escalating session to install 'python3' and 'sshpass':"
  sudo $packager python3-pip sshpass
else
  $packager python3-pip sshpass
fi
#TODO: Try the package first, not the other way around
#TODO: No reason to do it system-wide either, use the enviroment-variable sudouser to de-escalate
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

