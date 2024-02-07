#!/usr/bin/env zsh

alias zprof='ZSH_PROFILER="true" exec zsh'

# SEE https://stackoverflow.com/a/60987764/13194984
# fix .zshenv $PATH order chaos , `set -x` to debug
[[ -f $HOME/.zshenv ]] && source "$HOME/.zshenv"
typeset -U PATH

#  ---------------------- Profiler Start --------------------------

[[ "$ZSH_PROFILER" == "true" ]] && zmodload zsh/zprof

# use emacs-style keybinds
bindkey -e
bindkey "^V" clear-screen

#  ------------------ Oh-My-Zsh Installation ----------------------
[[ -n $HTTP ]] && export ALL_PROXY=http://$HTTP

export ZSH=$HOME/.oh-my-zsh

if [[ ! -f $ZSH/oh-my-zsh.sh ]]; then
  echo "Installing OhMyZsh/ohmyzsh..."
  command mkdir -p $ZSH
  command git clone https://github.com/ohmyzsh/ohmyzsh.git $ZSH &&
    echo "Installation successful." || echo "The clone has failed."
fi

#  --------------------- Oh-My-Zsh Setting -------------------------

# Set name of the theme to load --- if set to "random", it will
# load a random theme each time oh-my-zsh is loaded, in which case,
# to know which specific one was loaded, run: echo $RANDOM_THEME
# See https://github.com/ohmyzsh/ohmyzsh/wiki/Themes
ZSH_THEME=""

# Set list of themes to pick from when loading at random
# Setting this variable when ZSH_THEME=random will cause zsh to load
# a theme from this variable instead of looking in $ZSH/themes/
# If set to an empty array, this variable will have no effect.
# ZSH_THEME_RANDOM_CANDIDATES=( "robbyrussell" "agnoster" )

# Uncomment the following line to use case-sensitive completion.
# CASE_SENSITIVE="true"

# Uncomment the following line to use hyphen-insensitive completion.
# Case-sensitive completion must be off. _ and - will be interchangeable.
# HYPHEN_INSENSITIVE="true"

# Uncomment one of the following lines to change the auto-update behavior
zstyle ':omz:update' mode disabled  # disable automatic updates
# zstyle ':omz:update' mode auto      # update automatically without asking
# zstyle ':omz:update' mode reminder  # just remind me to update when it's time

# Uncomment the following line to change how often to auto-update (in days).
# zstyle ':omz:update' frequency 10000

# Uncomment the following line if pasting URLs and other text is messed up.
# DISABLE_MAGIC_FUNCTIONS="true"

# Uncomment the following line to disable colors in ls.
# DISABLE_LS_COLORS="true"

# Uncomment the following line to disable auto-setting terminal title.
# DISABLE_AUTO_TITLE="true"

# Uncomment the following line to enable command auto-correction.
# ENABLE_CORRECTION="true"

# Uncomment the following line to display red dots whilst waiting for completion.
# You can also set it to another string to have that shown instead of the default red dots.
# e.g. COMPLETION_WAITING_DOTS="%F{yellow}waiting...%f"
# Caution: this setting can cause issues with multiline prompts in zsh < 5.7.1 (see #5765)
COMPLETION_WAITING_DOTS="true"

# Ignore insecure permissions
ZSH_DISABLE_COMPFIX="true"

# Uncomment the following line if you want to disable marking untracked files
# under VCS as dirty. This makes repository status check for large repositories
# much, much faster.
# DISABLE_UNTRACKED_FILES_DIRTY="true"

# Uncomment the following line if you want to change the command execution time
# stamp shown in the history command output.
# You can set one of the optional three formats:
# "mm/dd/yyyy"|"dd.mm.yyyy"|"yyyy-mm-dd"
# or set a custom format using the strftime function format specifications,
# see 'man strftime' for details.
HIST_STAMPS="yyyy-mm-dd"

# Would you like to use another custom folder than $ZSH/custom?
ZSH_CUSTOM="$ZSH/custom"

# Set cache dir
ZSH_CACHE_DIR="$CACHE_HOME/oh-my-zsh"

# Set compdump file
ZSH_COMPDUMP="$CACHE_HOME/.zcompdump"

# Which plugins would you like to load?
# Standard plugins can be found in $ZSH/plugins/
# Custom plugins may be added to $ZSH_CUSTOM/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.

plugins=(
  colored-man-pages
  copyfile
  copypath
  deno
  # direnv
  encode64
  extract
  fzf
  gh
  gitfast
  github
  git-flow-avh
  # gpg-agent
  jsontools
  rust
  sudo
  starship
  urltools
  vscode
  web-search
  pass
  qrcode
  mise
  ## custom plugins
  autoupdate
  evalcache
  fzf-collection
  z.lua
  zsh-completions
  fzf-tab
  zsh-autosuggestions
  fast-syntax-highlighting
  jq
)

# ---------------------- Plugin Install --------------------------

# function
plugin_ensure() {
  local repo=https://github.com/$1.git
  local dir=$ZSH_CUSTOM/plugins/${2:-$(echo "$repo" | sed -e 's|/$||' -e 's|:*/*\.git$||' -e 's|.*[/:]||g')}
  if [ ! -d $dir/.git ]; then
    echo "Installing $repo ..."
    command git clone $repo $dir &&
      echo "Installation successful." ||
      echo "The clone has failed."
  fi
}

plugin_ensure liuyinz/fzf-collection
plugin_ensure Aloxaf/fzf-tab
plugin_ensure reegnz/jq-zsh-plugin jq
plugin_ensure skywind3000/z.lua
plugin_ensure TamCore/autoupdate-oh-my-zsh-plugins autoupdate
plugin_ensure mroth/evalcache
plugin_ensure trapd00r/LS_COLORS
plugin_ensure zsh-users/zsh-autosuggestions
plugin_ensure zsh-users/zsh-completions
plugin_ensure zdharma-continuum/fast-syntax-highlighting

# ---------------------- Plugin Setting --------------------------
# mise installation
command -v mise >/dev/null || curl https://mise.run | sh

# zlua, for emacs use
export ZLUA_SCRIPT

# evalcache
ZSH_EVALCACHE_DIR=$ZSH_CACHE_DIR/.zsh-evalcache

# LS_COLORS
command -v dircolors >/dev/null && _evalcache dircolors -b $ZSH_CUSTOM/plugins/LS_COLORS/LS_COLORS 2>/dev/null

# autosuggestions
bindkey ",," autosuggest-accept
ZSH_AUTOSUGGEST_BUFFER_MAX_SIZE=20
ZSH_AUTOSUGGEST_USE_ASYNC=1
ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE='fg=8'

# autoupdate
ZSH_CUSTOM_AUTOUPDATE_QUIET=true

# # fzf-proxy
# [[ -n $HTTP ]] && export PROXYF_URLS="http://$HTTP,socks://$SOCKS"

command -v pip >/dev/null && _evalcache pip completion --zsh 2>/dev/null

# ----------------------- Oh-my-zsh End ---------------------------

source $ZSH/oh-my-zsh.sh

export ALL_PROXY=

#  -------------------------- Options ------------------------------

setopt print_exit_value
setopt PROMPT_SUBST
setopt AUTO_PUSHD

# match hidden file
setopt GLOB_DOTS

# hist
setopt hist_reduce_blanks
setopt bang_hist
setopt hist_save_no_dups

# Automatically update PATH entries
zstyle ':completion:*' rehash true

# Keep directories and files separated
zstyle ':completion:*' list-dirs-first true

omz_clean() {
  echo "remove $ZSH_EVALCACHE_DIR ..."
  rm "$ZSH_EVALCACHE_DIR"/init-*.sh
  echo "remove $ZSH_COMPDUMP ..."
  rm "$ZSH_COMPDUMP"
}

omz_update() {
  upgrade_oh_my_zsh_custom
  omz update
  omz_clean
  exec zsh
}

source ${${(%):-%x}:A:h}/user.sh

# ----------------------- Profiler End ---------------------------

# BUG zprof failed to be fixed
[[ "$ZSH_PROFILER" == "true" ]] && zprof | less
