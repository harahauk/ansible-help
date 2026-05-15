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

# Determine package-manager
decide_packager () {
        # Default to dnf
        packager=dnf
        # Determine operating-system
        if [ -f "/etc/os-release" ]; then
          . /etc/os-release
        else
          echo "ERROR: Missing 'os-release'-file. Are you sure you are using Linux?"
        fi
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
                echo "ERROR: Your version of linux is not recognized by this script, so be sure to read the script and install your own packages.."
                echo "WARNING: This script will try to continue execution after you press <Enter>"
                echo "If you don't know what this entails please press <CTRL-C> (RECOMMENDED) or otherwise kill this session/terminal."
                read -n 1 -s -r -p ""
                ;;
		esac
        }
decide_packager
user=`whoami`
# Dependencies: Make sure python3 and sshpass are installed
if test "$user" != "root"
then
  echo "INFO: Escalating your session to install 'python3' and 'sshpass' using distribution package-manager:"
  sudo $packager python3-pip sshpass
else
  $packager python3-pip sshpass
fi
# If script is ran with unprivileged user, remove the content of the user-swapping variable
CHANGE_USER="$CHANGE_USER "
if [ -z "$SUDO_USER" ]; then
    CHANGE_USER=""
    SUDO_USER=$user
    echo "INFO: Unprivileged run detected, installation will continue as '$user'"
fi
# Installing 'pipx'
$CHANGE_USER pip install pipx
# TODO: Consistent if-syntax
if test "$?" -eq 1
then
  echo "ERROR: 'pipx'-installation appear to have failed. Assuming 'Broken packages-warning' - Will try to install 'pipx'-package using distribution package-manager:"
  sudo $packager pipx
fi
echo $?
# Use pipx to not break system packages
$CHANGE_USER pipx install ansible-core
$CHANGE_USER pipx ensurepath
# Add the most used collections of ansible-modules to the Ansible-installation
$CHANGE_USER /home/$SUDO_USER/.local/bin/ansible-galaxy collection install community.general
$CHANGE_USER /home/$SUDO_USER/.local/bin/ansible-galaxy collection install community.docker
$CHANGE_USER /home/$SUDO_USER/.local/bin/ansible-galaxy collection install ansible.posix
