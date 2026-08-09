date +%d\|%m\|%y,\ %H:%M:%S
# If not running interactively, don't do anything
[[ $- != *i* ]] && return
alias \
	vik='nvim ~/.config/kitty/kitty.conf'\
	m='~/.dotfiles/m'\
	src='source ~/.bashrc'\
	sheets='~/go/bin/sheets budget.csv'\
	virc='nvim ~/.bashrc'\
	qute='qutebrowser'\
	vih='nvim ~/.config/hypr/hyprland.conf'\
	vii='nvim ~/.config/i3/config '\
	viib='nvim ~/.config/i3/binds'\
	vif='nvim ~/.config/fuzzel/launcher.sh'\
	ls='ls --color=auto' \
	grep='grep --color=auto' \
    ..='cd ..' \
	vicfg='nvim ~/.config/nvim/init.lua' \
	vi='nvim' \
	upd='sudo pacman -Syu' \
	get='sudo pacman -S' \
	gits='git status --untracked-files=no' \
	dm='~/scripts/dm.sh' \
	ms='~/scripts/ms.sh' \
    sm="sudo -E ~/scripts/sm.sh" \
    smcfg="nvim ~/.config/scripts/systemManagementOptions.conf" \
    vis="sudo -E nvim" \
    vic="nvim ~/.config/nvim/init.lua" \
    cdnvim="cd /home/wex/.config/nvim/" \
    gety="yay -S" \
    ref="sudo reflector --latest 20 --sort rate --save /etc/pacman.d/mirrorlist && sudo pacman -Syu" \
    cal="export LC_TIME=ru_RU.UTF-8 && cal -3 && unset LC_TIME" \
    wip="cd $HOME/scripts/wip && nvim main.sh" \
    wkill="hyprctl kill" \
    gm="$HOME/scripts/gm.sh" \
    links="$HOME/scripts/links.sh" \
    torrc="sudo nvim /etc/tor/torrc" \
    mc="cd $HOME/.local/share/PrismLauncher/instances/" \
    st="cd $HOME/.local/share/Steam/steamapps/common/" \
    todo="nvim $HOME/todo" \
    pipereload="systemctl --user restart pipewire pipewire-pulse" \
    dc="ddg-chat" \
    # an="anicli-ru" \
    tt="$HOME/scripts/twitch-title.sh" \
    # qemu="$HOME/scripts/wip/qemu.sh" \
    # qemuv="$HOME/scripts/wip/qemu.sh -v" \
    # yay='https_proxy=socks5://127.0.0.1:9050 http_proxy=socks5://127.0.0.1:9050 yay' \

set -o vi
PS1='[\u@\h \W]\$ '


export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion
export PATH="$HOME/.cargo/bin:$PATH"

export PATH="$HOME/.local/bin:$PATH"
