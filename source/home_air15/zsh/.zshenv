#!/usr/bin/env zsh

# uncomment line below to  debug zshenv
# set -x

## ---------------------------- Zsh --------------------------------

# default
export CONFIG_DIR=$HOME/.config
export DATA_DIR=$HOME/.local/share

# dotfile
export DOTFILE_HOME=$CONFIG_DIR/dotfile

# misc
export LANG=en_US.UTF-8
export LC_ALL=en_US.UTF-8
export TIME_STYLE="+%y-%m-%d %H:%M"
export PAGER="less --tabs=4"
export LESSHISTFILE=$DATA_DIR/.lesshst

# hist
export HISTFILE=$HOME/.zsh_history
export HISTSIZE=1000000000
export SAVEHIST=$HISTSIZE

# PATH
export PATH=$HOME/.config/emacs/etc/bin:$HOME/.local/bin:$PATH

export EDITOR="ec"
export GIT_PAGER="diff-so-fancy | less --tabs=4 -RFX"

# export HTTP_ADDR=${HTTP%:*}
# export HTTP_PORT=${HTTP#*:}
# export SOCKS_ADDR=${SOCKS%:*}
# export SOCKS_PORT=${SOCKS#*:}

#  --------------------------- Tool -------------------------------
export LSP_USE_PLISTS=true

# emacs enchant
export ENCHANT_CONFIG_DIR=$CONFIG_DIR/enchant/

# ssh
export SSH_KEY_PATH=$HOME/.ssh/id_ed25519

# pass
export PASSWORD_STORE_ENABLE_EXTENSIONS=true

# homebrew
export HOMEBREW_BAT=1
export HOMEBREW_NO_AUTO_UPDATE=1
export HOMEBREW_NO_INSTALL_UPGRADE=1
export HOMEBREW_NO_INSTALL_CLEANUP=1
export HOMEBREW_BUNDLE_BREW_SKIP="daviderestivo/emacs-head/emacs-head@30"

# tsinghua source
export HOMEBREW_API_DOMAIN="https://mirrors.tuna.tsinghua.edu.cn/homebrew-bottles/api"
export HOMEBREW_BOTTLE_DOMAIN="https://mirrors.tuna.tsinghua.edu.cn/homebrew-bottles"
export HOMEBREW_BREW_GIT_REMOTE="https://mirrors.tuna.tsinghua.edu.cn/git/homebrew/brew.git"
export HOMEBREW_CORE_GIT_REMOTE="https://mirrors.tuna.tsinghua.edu.cn/git/homebrew/homebrew-core.git"
export HOMEBREW_PIP_INDEX_URL="https://pypi.tuna.tsinghua.edu.cn/simple"

eval "$(/opt/homebrew/bin/brew shellenv)"


# gnu toolchain

for item in "coreutils" "findutils" "grep" "make" "gnu-time" "gnu-tar" "gnu-sed"
do
  export PATH=/opt/homebrew/opt/$item/libexec/gnubin:$PATH
done

# curl
export PATH=/opt/homebrew/opt/curl/bin:$PATH

# getopt
export PATH=/opt/homebrew/opt/gnu-getopt/bin:$PATH

# Ripgrep
export RIPGREP_CONFIG_PATH=$CONFIG_DIR/.ripgreprc

# proxychains-ng
export PROXYCHAINS_CONF_FILE=$CONFIG_DIR/proxychains.conf

# lazygit
# FIXME config dir failed
export XDG_CONFIG_HOME="$CONFIG_DIR"

# tealdeer
export TEALDEER_CONFIG_DIR=$CONFIG_DIR/tealdeer

# z.lua
export _ZL_DATA=$DATA_DIR/.zlua
export _ZL_ECHO=1
export _ZL_ADD_ONCE=0
export _ZL_MATCH_MODE=0
export _ZL_HYPHEN=1
export _ZL_ROOT_MARKERS=".git,.svn,.hg,.root,package.json"
# export _ZL_EXCLUDE_DIRS="$DATA_DIR"

## z.lua.plugin.zsh
export _ZL_ZSH_NO_FZF=0
export _ZL_NO_ALIASES=1

# fzf
export FZF_DEFAULT_COMMAND='rg --files'
export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
export FZF_DEFAULT_OPTS_FILE="$CONFIG_DIR/fzf/tokyo-night.fzfrc"

#  --------------------------- mise -------------------------------

#  --------------------------- Lang -------------------------------

# ccls
# export PATH=/opt/homebrew/opt/llvm/bin:$PATH

# clang
export PATH="/opt/homebrew/opt/llvm/bin:$PATH"
export LDFLAGS="-L/opt/homebrew/opt/llvm/lib"
export CPPFLAGS="-I/opt/homebrew/opt/llvm/include"

# rust
export PATH="$HOME/.cargo/bin:$PATH"
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

export TERM="xterm-256color"

# html
export HTML_TIDY="$HOME/.tidyrc"

# moonbit
export PATH="$HOME/.moon/bin:$PATH"

# flutter
export PATH="$HOME/code/dev/flutter/bin:$PATH"
