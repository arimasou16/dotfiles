[[ -d ~/.bin ]] && export PATH="${HOME}/.bin:${PATH}"
[[ -d ~/.local/bin ]] && export PATH="$HOME/.local/bin:$PATH"
[[ -d ~/.deno ]] && export DENO_INSTALL="$HOME/.deno"
[[ -v DENO_INSTALL ]] && export PATH="$DENO_INSTALL/bin:$PATH"
[[ -d /usr/local/go ]] && export GOROOT=/usr/local/go
[[ -d /usr/local/go/bin ]] && export PATH="/usr/local/go/bin:$PATH"
[[ -d ~/go ]] && export GOPATH=$HOME/go
[[ -v GOPATH ]] && export PATH="$GOPATH/bin:$PATH"
[[ -d /usr/local/nvim-linux64/bin ]] && export PATH="/usr/local/nvim-linux64/bin:$PATH"
which nvim >/dev/null 2>&1
if [ $? -eq 0 ]; then
  export NVIM_LISTEN_ADDRESS=/tmp/nvimsocket
  export SUDO_EDITOR=$(which nvim)
  export EDITOR=$(which nvim)
fi
if [[ -f ~/.local/bin/kitty ]]; then
  export TERMINAL=$HOME/.local/bin/kitty
  export GLFW_IM_MODULE=ibus
fi
. "$HOME/.cargo/env"
yaskkserv2 --google-cache-filename=/home/arimasou16/.config/fcitx5/skk/yaskkserv2.cache /home/arimasou16/.config/fcitx5/skk/dictionary.yaskkserv2
