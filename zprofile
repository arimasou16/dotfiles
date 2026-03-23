# PATH環境変数設定
[ -d ~/.bin ] && export PATH="${HOME}/.bin:${PATH}"
[ -d ~/.local/bin ] && export PATH="$HOME/.local/bin:$PATH"
# deno
[ -d ~/.deno ] && export DENO_INSTALL="$HOME/.deno"
[ -n "$DENO_INSTALL" ] && export PATH="$DENO_INSTALL/bin:$PATH"
# go
[ -d /usr/local/go ] && export GOROOT=/usr/local/go
[ -d /usr/local/go/bin ] && export PATH="/usr/local/go/bin:$PATH"
[ -d ~/go ] && export GOPATH=$HOME/go
[ -n "$GOPATH" ] && export PATH="$GOPATH/bin:$PATH"
[ -d ~/android_sdk/platform-tools ] && export PATH="$HOME/android_sdk/platform-tools:$PATH"
# nvim
[ -d /usr/local/nvim-linux64/bin ] && export PATH="/usr/local/nvim-linux64/bin:$PATH"
if command -v "nvim" > /dev/null 2>&1; then
#  export NVIM_LISTEN_ADDRESS=/tmp/nvimsocket
  export SUDO_EDITOR=$(command -v nvim)
  export EDITOR=$(command -v nvim)
fi
# kitty
if command -v "kitty" > /dev/null 2>&1; then
  export TERMINAL=$(command -v kitty)
  # fcitx5だとしても問題ない
  export GLFW_IM_MODULE=ibus
fi
# cargo
if [ -f "$HOME/.cargo/env" ]; then
  . "$HOME/.cargo/env"
fi
# IM判定
[ -f ~/.xinputrc ] && IM=$(awk '/run_im/ {print $2}' ~/.xinputrc 2> /dev/null)
if [ -z "$IM" ]; then
  if command -v "fcitx5" > /dev/null 2>&1; then
    IM=fcitx5
  else
    IM=ibus
  fi
fi
# yaskkserv2
if command -v "yaskkserv2" > /dev/null 2>&1; then
  if ! pgrep -x "yaskkserv2" > /dev/null 2>&1; then
    if [ "$IM" = "ibus" ]; then
      if [ -f /usr/share/skk/SKK-JISYO.L ]; then
        # 【改善4】ibus用のキャッシュ保存先ディレクトリを正しく指定（元のコメントアウトを参考に設定）
        yaskkserv2 --google-cache-filename="$HOME/.config/ibus-skk/yaskkserv2.cache" /usr/share/skk/SKK-JISYO.L >/dev/null 2>&1 &
      fi
    elif [ "$IM" = "fcitx5" ]; then
      if command -v "yaskkserv2_make_dictionary" > /dev/null 2>&1 && [ -f /usr/share/skk/SKK-JISYO.L ]; then
        # 【改善2】辞書ファイルが /tmp に存在しない時"だけ"作成する（ログイン負荷の軽減）
        if [ ! -f /tmp/dictionary.yaskkserv2 ]; then
          yaskkserv2_make_dictionary --dictionary-filename=/tmp/dictionary.yaskkserv2 /usr/share/skk/SKK-JISYO.L >/dev/null 2>&1
        fi
        yaskkserv2 --google-japanese-input=notfound --google-suggest --google-cache-filename=/tmp/yaskkserv2.cache /tmp/dictionary.yaskkserv2 >/dev/null 2>&1 &
      fi
    fi
  fi
fi
# ibus これをやると一部のターミナルでハングする
if [ -f /usr/libexec/ibus-dconf ] && [ "$IM" = "ibus" ]; then
  if ! pgrep -x "ibus-daemon" > /dev/null 2>&1; then
    ibus-daemon --config=/usr/libexec/ibus-dconf -drx >/dev/null 2>&1
  fi
fi
# Nextcloud/sh
[ -d ~/Nextcloud/Public_Ubuntu/sh ] && export PATH="$HOME/Nextcloud/Public_Ubuntu/sh:${PATH}"
# Seafile/sh
[ -d ~/Seafile/Public_Ubuntu/sh ] && export PATH="$HOME/Seafile/Public_Ubuntu/sh:${PATH}"
# docker
if command -v "docker" > /dev/null 2>&1; then
  export DOCKER_HOST=unix://$XDG_RUNTIME_DIR/docker.sock
  export DOCKER_CONFIG=${DOCKER_CONFIG:-$HOME/.docker}
fi
# nvm
if [ -d "$HOME/.nvm" ]; then
  export NVM_DIR="$HOME/.nvm"
  [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
  [ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion
fi
# tilix
if { [ -n "$TILIX_ID" ] || [ -n "$VTE_VERSION" ]; } && [ -f /etc/profile.d/vte.sh ]; then
    . /etc/profile.d/vte.sh
fi
# bitwarden
[ -S "$HOME/.bitwarden-ssh-agent.sock" ] && export SSH_AUTH_SOCK="$HOME/.bitwarden-ssh-agent.sock"
[ -S "$HOME/.var/app/com.bitwarden.desktop/data/.bitwarden-ssh-agent.sock" ] && export SSH_AUTH_SOCK="$HOME/.var/app/com.bitwarden.desktop/data/.bitwarden-ssh-agent.sock"
[ -S "$HOME/snap/bitwarden/current/.bitwarden-ssh-agent.sock" ] && export SSH_AUTH_SOCK="$HOME/snap/bitwarden/current/.bitwarden-ssh-agent.sock"
# .geminirc
[ -f ~/.geminirc ] && . ~/.geminirc
# Waylandセッションかどうか
if [ "$XDG_SESSION_TYPE" = "wayland" ] || [ -n "$WAYLAND_DISPLAY" ]; then
  if [ "$IM" = "ibus" ]; then
    export XMODIFIERS="@im=ibus"
  elif [ "$IM" = "fcitx5" ]; then
    export XMODIFIERS="@im=fcitx"
  fi
  export GTK_IM_MODULE=""
  export QT_IM_MODULE=""
fi
