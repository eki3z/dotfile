#!/usr/bin/env zsh

# uncomment line below to  debug zshenv
# set -x

## ---------------------------- Zsh --------------------------------

# misc
export LANG=en_US.UTF-8
export LC_ALL=en_US.UTF-8
export TIME_STYLE="+%y-%m-%d %H:%M"
export PAGER="less --tabs=4"
export TERM="xterm-256color"

# hist
export HISTFILE="$HOME/.zsh_history"
export HISTSIZE=1000000000
export SAVEHIST=$HISTSIZE
export EDITOR="ec"
# export GIT_PAGER="diff-so-fancy | less --tabs=4 -RFX"

# ssh
export SSH_KEY_PATH="$HOME/.ssh/id_ed25519"

# unix style env
export XDG_CONFIG_HOME="$HOME/.config"
export XDG_CACHE_HOME="$HOME/.cache"
export XDG_DATA_HOME="$HOME/.local/share"
export XDG_STATE_HOME="$HOME/.local/state"
export XDG_BIN_HOME="$HOME/.local/bin"

export PATH="$XDG_BIN_HOME:$PATH"

# dotfile
export DOTFILE_HOME="$XDG_CONFIG_HOME/dotfile"

# export HTTP_ADDR=${HTTP%:*}
# export HTTP_PORT=${HTTP#*:}
# export SOCKS_ADDR=${SOCKS%:*}
# export SOCKS_PORT=${SOCKS#*:}

export TERM="xterm-256color"


#  --------------------------- Tool -------------------------------
# emacs
# export LSP_USE_PLISTS=true
export EMACS_HOME="$XDG_CONFIG_HOME/emacs"
export PATH="$EMACS_HOME/bin:$PATH"

# enchant
export ENCHANT_CONFIG_DIR="$XDG_CONFIG_HOME/enchant/"

# pass
export PASSWORD_STORE_ENABLE_EXTENSIONS=true

# homebrew
export HOMEBREW_NO_AUTO_UPDATE=1
export HOMEBREW_NO_INSTALL_UPGRADE=1
export HOMEBREW_NO_INSTALL_CLEANUP=1
export HOMEBREW_BUNDLE_BREW_SKIP="daviderestivo/emacs-head/emacs-head@31"

# tsinghua source
export HOMEBREW_API_DOMAIN="https://mirrors.tuna.tsinghua.edu.cn/homebrew-bottles/api"
export HOMEBREW_BOTTLE_DOMAIN="https://mirrors.tuna.tsinghua.edu.cn/homebrew-bottles"
export HOMEBREW_BREW_GIT_REMOTE="https://mirrors.tuna.tsinghua.edu.cn/git/homebrew/brew.git"
export HOMEBREW_CORE_GIT_REMOTE="https://mirrors.tuna.tsinghua.edu.cn/git/homebrew/homebrew-core.git"
export HOMEBREW_PIP_INDEX_URL="https://pypi.tuna.tsinghua.edu.cn/simple"

eval "$(/opt/homebrew/bin/brew shellenv)"

# gnu toolchain
for item in "coreutils" "findutils" "grep" "make" "gnu-time" "gnu-tar" "gnu-sed"; do
  export PATH=/opt/homebrew/opt/$item/libexec/gnubin:$PATH
done

# curl
export PATH=/opt/homebrew/opt/curl/bin:$PATH

# getopt
export PATH=/opt/homebrew/opt/gnu-getopt/bin:$PATH

# Ripgrep
export RIPGREP_CONFIG_PATH="$XDG_CONFIG_HOME/rg/.ripgreprc"

# tealdeer
export TEALDEER_CONFIG_DIR="$XDG_CONFIG_HOME/tealdeer"

# git-cliff
export GIT_CLIFF_CONFIG="$XDG_CONFIG_HOME/cliff.toml"

# z.lua
export _ZL_DATA="$XDG_DATA_HOME/.zlua"
export _ZL_ECHO=1
export _ZL_ADD_ONCE=0
export _ZL_MATCH_MODE=0
export _ZL_HYPHEN=1
export _ZL_ROOT_MARKERS=".git,.svn,.hg,.root,package.json"
# export _ZL_EXCLUDE_DIRS="$XDG_DATA_HOME"

## z.lua.plugin.zsh
export _ZL_ZSH_NO_FZF=0
export _ZL_NO_ALIASES=1

# fzf
export FZF_DEFAULT_COMMAND='rg --files'
export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
export FZF_DEFAULT_OPTS="
--header-first
--ansi
--reverse
--cycle
--multi
--sort
--no-unicode
--no-scrollbar
--marker='+ '
--separator=''
--info=inline
--margin=0,0,0,1
--height='60%'
--bind=change:first
--bind=btab:up+toggle
--bind=ctrl-n:down
--bind=ctrl-p:up
--bind=alt-n:next-history
--bind=alt-p:previous-history
--bind=ctrl-u:cancel
--bind=ctrl-l:jump
--bind=ctrl-t:toggle-all
--bind=ctrl-v:clear-selection
--color=dark
--color=fg:#a9b1d6:dim
--color=hl:#73daca:dim:bold
--color=bg+:#24304a
--color=fg+:#a9b1d6:underline:bold
--color=hl+:#a9b1d6:underline:bold
--color=pointer:#f7768e:bold
--color=gutter:#1a1b26
--color=marker:#f7768e:bold
--color=prompt:#7aa2f7:dim
--color=query:#73daca:bold
--color=spinner:#e0af68:dim
--color=info:#bb9af7:bold
--color=header:#7aa2f7:dim"

#  --------------------------- mise -------------------------------

#  --------------------------- Lang -------------------------------

# ccls
# export PATH=/opt/homebrew/opt/llvm/bin:$PATH

# clang
export PATH="/opt/homebrew/opt/llvm/bin:$PATH"
export LDFLAGS="-L/opt/homebrew/opt/llvm/lib"
export CPPFLAGS="-I/opt/homebrew/opt/llvm/include"

# rust
export CARGO_HOME="$HOME/.cargo"
export PATH="$CARGO_HOME/bin:$PATH"
export RUSTUP_DIST_SERVER="https://rsproxy.cn"
export RUSTUP_UPDATE_ROOT="https://rsproxy.cn/rustup"

# pnpm
export PNPM_HOME="$HOME/Library/pnpm"
export PATH="$PNPM_HOME:$PATH"

# Golang
# export GOPATH=$HOME/code/go
# export PATH=$GOPATH/bin:$PATH
export GO111MODULE=on
export GOPROXY=https://goproxy.cn

# html
export HTML_TIDY="$HOME/.tidyrc"

# moonbit
export PATH="$HOME/.moon/bin:$PATH"

# flutter
export PATH="$HOME/code/dev/flutter/bin:$PATH"
