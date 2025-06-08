#!/bin/sh

config="$HOME/dotfiles/.config/gtk-3.0/settings.ini"
if [ ! -f "$config" ]; then exit 1; fi

gnome_schema="org.gnome.desktop.interface"
gtk_theme="$(grep 'gtk-theme-name' "$config" | cut -d'=' -f2 | tr -d ' ')"
icon_theme="$(grep 'gtk-icon-theme-name' "$config" | cut -d'=' -f2 | tr -d ' ')"
cursor_theme="$(grep 'gtk-cursor-theme-name' "$config" | cut -d'=' -f2 | tr -d ' ')"
font_name="$(grep 'gtk-font-name' "$config" | cut -d'=' -f2 | tr -d ' ')"

gsettings set "$gnome_schema" gtk-theme "$gtk_theme"
gsettings set "$gnome_schema" icon-theme "$icon_theme"
gsettings set "$gnome_schema" cursor-theme "$cursor_theme"
gsettings set "$gnome_schema" font-name "$font_name"
