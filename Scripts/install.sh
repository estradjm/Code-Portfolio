#!/bin/bash

# Retrieves all git repos needed for the .vim configuration file that are called using Pathogen

# This requires the user to enter sudo credentials for dependency
echo -n "This installation requires sudo priveleges to install exuberant-ctags. Continue? (y/n)"

read answer
if echo "$answer" | grep -iq "^y";then

echo "Installing ctags..."
sudo apt-get install exuberant-ctags

echo "Installing terminator..."
sudo apt-get install terminator

echo "Creating directories needed if they do not exist..."
cd ~
mkdir -p .vim
cd .vim
mkdir -p syntax/
mkdir -p bundles/
mkdir -p autoload/

# Get Pathogen Plugin Installer
echo "Getting Pathogen plugin manager..."
cd autoload
curl -LSso ~/.vim/autoload/pathogen.vim https://tpo.pe/pathogen.vim 
cd ../

# Get all Plug-ins for Pathogen - comment out the ones that you do not want
echo "Getting all the plugins..."
cd bundles

#ctrlp
git clone git@github.com:scrooloose/nerdtree.git

#fontpatcher
git clone git@github.com:powerline/fontpatcher.git

#fonts
git clone git@github.com:powerline/fonts.git

#nerdcommenter
git clone git@github.com:scrooloose/nerdcommenter.git

#nerd-fonts
git clone git@github.com:ryanoasis/nerd-fonts.git

# Icons for nerd tree, airline, and powerline
git@github.com:ryanoasis/vim-devicons.git

#nerdtree
git clone git@github.com:scrooloose/nerdtree.git

#nerdtree-git-plugin
git clone git@github.com:Xuyuanp/nerdtree-git-plugin.git

#powerline
git clone git@github.com:powerline/powerline.git

#syntastic
git clone git@github.com:vim-syntastic/syntastic.git

#tagbar
git clone git://github.com/majutsushi/tagbar

#tcomment_vim
git clone git@github.com:tomtom/tcomment_vim.git

# dispatch
git clone git@github.com:tpope/vim-dispatch.giit

#fugitive
git clone git@github.com:tpope/vim-fugitive.git

#vimagit
git clone git@github.com:jreybert/vimagit.git

#vim-airline
git clone git@github.com:vim-airline/vim-airline.git  

#vim-airline-themes
git clone git@github.com:vim-airline/vim-airline-themes.git

#vim-colors-solarized
git clone git@github.com:altercation/vim-colors-solarized.git

#vim-git
git clone git@github.com:tpope/vim-git.git

#vim-gitgutter
git clone git@github.com:airblade/vim-gitgutter.git 

#vim-gutentags
git clone git@github.com:ludovicchabant/vim-gutentags.git

#vim-signify
git clone git@github.com:mhinz/vim-signify.git 

#vim-surround - quote, bracket, text sourroundings management
git clone git@github.com:tpope/vim-surround.git

#vim-tags
git clone git@github.com:szw/vim-tags.git

#vimtex
git clone git@github.com:lervag/vimtex.git

#vim-vhdl
git clone git@github.com:vim-scripts/VHDL-indent-93-syntax.git
git clone git@github.com:salinasv/vim-vhdl.git
git clone git@github.com:suoto/vim-hdl.git


#vundle
git clone git@github.com:VundleVim/Vundle.vim.git

#zenburn
git clone git@github.com:vim-scripts/Zenburn.git

# Get syntax stuffs
git clone git@github.com:vim-scripts/tcl.vim.git

cd ../

echo "Installing all plugins...."
vim +PluginInstall +qall 

echo "Install and configuration complete..."

else
	echo "Installation Aborted."
fi
