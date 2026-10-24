#!/bin/bash

echo "Backing up existing Vim config files..."

if [ -f ~/.vimrc ]; then
    mv ~/.vimrc ~/.vimrc.backup_$(date +%Y%m%d%H%M%S)
    echo "Backed up ~/.vimrc"
else
    echo "No ~/.vimrc found"
fi

if [ -d ~/.vim ]; then
    mv ~/.vim ~/.vim.backup_$(date +%Y%m%d%H%M%S)
    echo "Backed up ~/.vim directory"
else
    echo "No ~/.vim directory found"
fi

echo "Vim configs cleaned. You now have a fresh Vim environment."

echo "You can start Vim by running 'vim'."
