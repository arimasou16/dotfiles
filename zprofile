# PATH環境変数設定
[[ -d ~/.bin ]] && export PATH="${HOME}/.bin:${PATH}"
[[ -d ~/.local/bin ]] && export PATH="$HOME/.local/bin:$PATH"
# deno
[[ -d ~/.deno ]] && export DENO_INSTALL="$HOME/.deno"
[[ -v DENO_INSTALL ]] && export PATH="$DENO_INSTALL/bin:$PATH"
# go
[[ -d /usr/local/go ]] && export GOROOT=/usr/local/go
[[ -d /usr/local/go/bin ]] && export PATH="/usr/local/go/bin:$PATH"
[[ -d ~/go ]] && export GOPATH=$HOME/go
[[ -v GOPATH ]] && export PATH="$GOPATH/bin:$PATH"
[[ -d ~/Android/Sdk/platform-tools/ ]] && export PATH="/home/arimasou16/Android/Sdk/platform-tools:$PATH"
# nvim
[[ -d /usr/local/nvim-linux64/bin ]] && export PATH="/usr/local/nvim-linux64/bin:$PATH"
if which "nvim" > /dev/null 2>&1; then
  export NVIM_LISTEN_ADDRESS=/tmp/nvimsocket
  export SUDO_EDITOR=$(which nvim)
  export EDITOR=$(which nvim)
fi
# kitty
if which "kitty" > /dev/null 2>&1; then
  export TERMINAL=$(which kitty)
  # fcitx5だとしても問題ない
  export GLFW_IM_MODULE=ibus
fi
# cargo
if type "cargo" > /dev/null 2>&1; then
  . "$HOME/.cargo/env"
fi
# IM判定
[[ -f ~/.xinputrc ]] && IM=$(awk '/run_im/ {print $2}' ~/.xinputrc 2> /dev/null)
if [[ -z "$IM" ]]; then
  if type "fcitx5" > /dev/null 2>&1; then
    IM=fcitx5
  else
    IM=ibus
  fi
fi
# yaskkserv2
if type "yaskkserv2" > /dev/null 2>&1; then
  if [[ "$IM" = "ibus" ]]; then
    yaskkserv2_make_dictionary --dictionary-filename=$HOME/.config/ibus-skk/dictionary.yaskkserv2 /usr/share/skk/SKK-JISYO.L $HOME/.config/ibus-skk/user.dict
    yaskkserv2 --google-cache-filename=$HOME/.config/ibus-skk/yaskkserv2.cache $HOME/.config/ibus-skk/dictionary.yaskkserv2
  fi
  if [[ "$IM" = "fcitx5" ]]; then
    yaskkserv2_make_dictionary --dictionary-filename=$HOME/.config/fcitx5/skk/dictionary.yaskkserv2 /usr/share/skk/SKK-JISYO.L $HOME/.config/fcitx5/skk/user.dict
    yaskkserv2 --google-cache-filename=$HOME/.config/fcitx5/skk/yaskkserv2.cache $HOME/.config/fcitx5/skk/dictionary.yaskkserv2
  fi
fi
# ibus これをやると一部のターミナルでハングする
[[ -f /usr/libexec/ibus-dconf ]] && [[ "$IM" = "ibus" ]] && ibus-daemon --config=/usr/libexec/ibus-dconf -drx
# Nextcloud/sh
[[ -d ~/Nextcloud/Public_Ubuntu/sh ]] && export PATH="$HOME/Nextcloud/Public_Ubuntu/sh:${PATH}"
# docker
if type "docker" > /dev/null 2>&1; then
  export DOCKER_HOST=unix://$XDG_RUNTIME_DIR/docker.sock
  export DOCKER_CONFIG=${DOCKER_CONFIG:-$HOME/.docker}
fi
# nvm
if type "nvm" > /dev/null 2>&1; then
  export NVM_DIR="$HOME/.nvm"
  [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
  [ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion
fi
# tilix
if [ $TILIX_ID ] || [ $VTE_VERSION ]; then
    source /etc/profile.d/vte.sh
fi
# bitwarden
[[ -f $HOME/.bitwarden-ssh-agent.sock ]] && export SSH_AUTH_SOCK=$HOME/.bitwarden-ssh-agent.sock
