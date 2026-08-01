#!/bin/bash

# Папка, куда будет клонироваться репозиторий
CLONE_DIR="$HOME/df"

# Клонируем репозиторий
echo "[*] Клонируем репозиторий..."
git clone https://github.com/ClickBuilder/df "$CLONE_DIR" || {
  echo "Ошибка при клонировании репозитория.";
  exit 1;
}

# Расположение файлов в целевых директориях
echo "[*] Копируем конфиги..."

# Hyprland
mkdir -p ~/.config/hypr
cp -r "$CLONE_DIR/hypr/"* ~/.config/hypr/

# Kitty
mkdir -p ~/.config/kitty
cp -r "$CLONE_DIR/kitty/"* ~/.config/kitty/

# Neovim
mkdir -p ~/.config/nvim
cp -r "$CLONE_DIR/nvim/"* ~/.config/nvim/

# Waybar
mkdir -p ~/.config/waybar
cp -r "$CLONE_DIR/waybar/"* ~/.config/waybar/

# Bash config
cp "$CLONE_DIR/.bash_profile" "$HOME/.bash_profile"
cp "$CLONE_DIR/.bashrc" "$HOME/.bashrc"


echo -e "\n✅ Установка завершена."

