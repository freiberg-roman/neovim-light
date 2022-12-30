#!/bin/bash

# ### REQUIREMENTS ###
#
# font: Blex Mono Nerd Font (patched)

SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )

# link alacritty config

mkdir -p $HOME/.config/alacritty
rm $HOME/.config/alacritty/alacritty.yml  # in case it already exists
ln -s $SCRIPT_DIR/alacritty/alacritty.yml $HOME/.config/alacritty/alacritty.yml

# link alacritty config

mkdir -p $HOME/.config/nvim
rm $HOME/.config/nvim/init.vim  # in case it already exists
rm $HOME/.config/nvim/init.lua  # in case it already exists
rm -r $HOME/.config/nvim/lua # remove lua config
ln -s $SCRIPT_DIR/nvim/init.lua $HOME/.config/nvim/init.lua
ln -s $SCRIPT_DIR/nvim/lua $HOME/.config/nvim/lua
