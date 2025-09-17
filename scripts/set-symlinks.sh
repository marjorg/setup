#!/bin/bash

VSCODE_CONFIG_DIR="$HOME/.config/Code/User"
DOTFILES_VSCODE="$HOME/dotfiles/.config/Code/User"

ln -sf "$DOTFILES_VSCODE/settings.json" "$VSCODE_CONFIG_DIR/settings.json"
ln -sf "$DOTFILES_VSCODE/keybindings.json" "$VSCODE_CONFIG_DIR/keybindings.json"
