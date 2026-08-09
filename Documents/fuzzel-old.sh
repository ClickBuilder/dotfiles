#!/bin/bash

declare -A apps=(
	[telegram]="Telegram"
  [firefox]="firefox"
  [kitty]="kitty -e bash -c 'fastfetch; exec bash'"
  [thunar]="thunar"
  [steam]="steam"
  [discord]="discord"
  [obsidian]="obsidian"
  [tor]="dex ~/tor-browser/start-tor-browser.desktop"
  [spotify]="spotify"
  [mumble]="mumble"
  [factorio]="steam -applaunch 427520"
  [dota2]="steam -applaunch 570"
  [chat-createtosurvive]="xdg-open 'steam://friends/message/76561198236305030'"
)

choice=$(printf "%s\n" "${!apps[@]}" | fuzzel --dmenu)

[ -n "$choice" ] && eval "${apps[$choice]}"
