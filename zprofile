[[ -d ~/.bin ]] && export PATH="${HOME}/.bin:${PATH}"
[[ -d ~/.local/bin ]] && export PATH="$HOME/.local/bin:$PATH"
[[ -d ~/.deno ]] && export DENO_INSTALL="$HOME/.deno"
[[ -v DENO_INSTALL ]] && export PATH="$DENO_INSTALL/bin:$PATH"
[[ -d /usr/local/go ]] && export GOROOT=/usr/local/go
[[ -d /usr/local/go/bin ]] && export PATH="/usr/local/go/bin:$PATH"
[[ -d ~/go ]] && export GOPATH=$HOME/go
[[ -v GOPATH ]] && export PATH="$GOPATH/bin:$PATH"
[[ -d /usr/local/nvim-linux64/bin ]] && export PATH="/usr/local/nvim-linux64/bin:$PATH"
[[ -d ~/Android/Sdk/platform-tools/ ]] && export PATH="/home/arimasou16/Android/Sdk/platform-tools:$PATH"
which nvim >/dev/null 2>&1
if [ $? -eq 0 ]; then
  export NVIM_LISTEN_ADDRESS=/tmp/nvimsocket
  export SUDO_EDITOR=$(which nvim)
  export EDITOR=$(which nvim)
fi
if [[ -f ~/.local/bin/kitty ]]; then
  export TERMINAL=$HOME/.local/bin/kitty
  #export GLFW_IM_MODULE=ibus
fi
. "$HOME/.cargo/env"
yaskkserv2_make_dictionary --dictionary-filename=$HOME/.config/ibus-skk/dictionary.yaskkserv2 /usr/share/skk/SKK-JISYO.L $HOME/.config/ibus-skk/user.dict
yaskkserv2 --google-cache-filename=$HOME/.config/ibus-skk/yaskkserv2.cache $HOME/.config/ibus-skk/dictionary.yaskkserv2
[[ -d ~/Nextcloud/Public_Ubuntu/sh ]] && export PATH="$HOME/Nextcloud/Public_Ubuntu/sh:${PATH}"
[[ -f /usr/libexec/ibus-dconf ]] && ibus-daemon --config=/usr/libexec/ibus-dconf -drx
