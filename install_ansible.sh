#!/bin/sh

##
# @author Harald Hauknes <harald (at) hauknes.org>
#
# This script gets you ready to use Ansible and sources most of the installation outside of
# system packages. This is to get an updated version of Ansible and to not cause minimal
# interfere with existing configuration of the system.
# System packages installed by this script:
# - python3-pip
# - sshpass
# The rest of the installation is done with pipx to not break system packages.
##

## Color codes
C_NC="\e[0m"
C_RED="\e[31m"
C_GREEN="\e[32m"
C_YEL="\e[33m"
#
## Determine package-manager
decide_packager () {
   # Default to dnf
   packager=dnf
   # Determine operating-system
   if [ -f "/etc/os-release" ]; then
     . /etc/os-release
   else
     echo -e "$C_RED""ERROR$C_NC: Missing 'os-release'-file. Are you sure you are using Linux?"
   fi
   case "$ID" in
   "fedora" | "almalinux" | "rhel")
           echo -e "$C_GREEN""INFO$C_NC: RHEL-based OS detected, will use 'dnf'"
           packager="dnf install -y"
           ;;
   "debian" | "ubuntu" | "kali")
           echo -e "$C_GREEN""INFO$C_NC: Debian-based OS detected, will use 'apt'"
           packager="apt install -y"
           ;;
   *)
           echo -e "$C_RED""ERROR$C_NC: Your version of linux is not recognized by this script, so be sure to read the script and install your own packages.."
           echo -e "$C_RED""WARNING$C_NC: This script will try to continue execution after you press <Enter>"
           echo "  If you don't know what this entails please press <CTRL-C> (RECOMMENDED) or otherwise kill this session/terminal."
           read -n 1 -s -r -p ""
           ;;
   	esac
   }
decide_packager
#
## Dependencies: Make sure 'python3' and 'sshpass' is installed using the package-manager
user=`whoami`
if test "$user" != "root"
then
  echo -e "$C_GREEN""INFO$C_NC: Escalating your session to install 'python3' and 'sshpass' using distribution package-manager:"
  sudo $packager python3-pip sshpass
else
  $packager python3-pip sshpass
fi
#
# If script is ran with unprivileged user, remove the content of the user-swapping variable
CHANGE_USER="sudo -u $SUDO_USER "
if [ -z "$SUDO_USER" ]; then
    CHANGE_USER=""
    SUDO_USER=$user
    echo -e "$C_GREEN""INFO$C_NC: Unprivileged run detected, installation will continue as '$user'"
fi
# Installing 'pipx', used to not interfere with pip or packages installed via package-manager
$CHANGE_USER pip install pipx
# TODO: Consistent if-syntax
if test "$?" -eq 1
then
  echo -e "$C_RED""ERROR$C_NC: 'pipx'-installation appear to have failed. Assuming 'Broken packages-warning' - Will try to install 'pipx'-package using distribution package-manager:"
  sudo $packager pipx
fi
echo -e "$C_RED""DEBUG$C_NC: '$?'"
$CHANGE_USER /home/$SUDO_USER/.local/bin/pipx install ansible-core
# Add the most used collections of ansible-modules to the Ansible-installation
$CHANGE_USER /home/$SUDO_USER/.local/bin/ansible-galaxy collection install community.general
$CHANGE_USER /home/$SUDO_USER/.local/bin/ansible-galaxy collection install community.docker
$CHANGE_USER /home/$SUDO_USER/.local/bin/ansible-galaxy collection install ansible.posix
# Doubt this changes anything, but does not harm either
$CHANGE_USER /home/$SUDO_USER/.local/bin/pipx ensurepath
echo -e "$C_GREEN""INFO$C_NC: '$C_YEL""install_ansible.sh$C_NC' has finished, test commands like 'ansible', 'ansible-playbook' or 'ansible-galaxy' to verify installation success"
