#!/bin/bash

# Puts all files where they need to be in the system and configures Conky.

# This requires the user to enter sudo credentials for dependency
echo -n "This installation requires sudo priveleges to install conky. Continue? (y/n)"

read answer
if echo "$answer" | grep -iq "^y";then

echo "Installing conky..."
sudo apt-get install conky

# Replacing conky config
echo "Replace .vimrc file..."
command cp -rfu .conky ~

echo "Creating directories needed if they do not exist..."
cd ~

mkdir -p .conky
cd .conky


cd ../

echo "Install and configuration complete..."

else
	echo "Installation Aborted."
fi
