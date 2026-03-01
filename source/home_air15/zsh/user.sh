#!/usr/bin/env bash

# Aliases
# default
# -----------------------
alias ls='gls -F --color --group-directories-first'
alias ll='gls -lhF --color --group-directories-first'
alias la='gls -AF --color --group-directories-first'
alias lla='gls -lhAF --color --group-directories-first'

alias du="du -h"
alias df="df -h"

alias ap='ALL_PROXY=http://$HTTP'
alias eap='export ALL_PROXY=http://$HTTP'
alias uap="export ALL_PROXY="

# App
# -----------------------
alias rt='trash'
alias lg='lazygit'
alias pc="proxychains4"
alias h="htop"
alias rg='rg --ignore-file=$XDG_CONFIG_HOME/rg/.rgignore'

#  ---------------------------- Git --------------------------------

alias gc='git commit'
alias gcm='git commit -m '
alias gcd='git commit --amend'
alias gcdn='git commit --amend --no-edit'

alias ge='git restore'

alias gst='git stash'
alias gsts='git stash show --stat -p'

## Branch
alias gb='git branch'
alias gbd='git branch -d'
alias gbu='git branch -u'
alias gba='git branch -vv -a'

alias gw='git switch'
alias gwc='git switch -c'

alias gm='git merge'
alias gmt='git mergetool'

alias gp='git push'
alias gpa='git push --all'
alias gpt='git push --tags'
alias gpp='git push --prune'
alias gpd='git push --delete'
alias gpu='git push --set-upstream'

alias gcl='git clone'
alias gclr='git clone --recurse-submodules'

alias gpl='git pull'
alias gplr='git pull --rebase --autostash -v'

# submodule
alias gsm='git submodule'
alias gsmf='git submodule foreach'

alias gs='git status -sb'
alias gbl='git blame -w --abbrev=6'
alias gslog='git shortlog -nc'

alias gl='git log --graph'
alias glt='git log --graph --stat'
alias gla='git log --graph --all'
alias glta='git log --graph --all --stat'

## Diff
alias gd='git diff'
alias gdc='git diff --cached'
alias gds='git diff --stat'
alias gdcs='git diff --stat --cached'
alias gdt='git difftool'

## Debug

## Worktree & Index
alias gclean='git clean -id'
alias grm='git rm -r -f'
alias grmc='git rm -r --cached'

alias gcp='git cherry-pick'
alias grv='git revert'
alias grvv='git revert HEAD'
alias grvn='git revert --no-commit'

# 优化巨型子模块项目的 Git 性能
# 用法:
#   goptmise
# 功能:
#   为当前仓库设置子模块相关的 Git 本地配置以提升性能
goptmise() {
  if ! git rev-parse --is-inside-work-tree >/dev/null 2>&1; then
    echo "Not a git repo."
    return 1
  fi

  git config --local status.ignoreSubmodules dirty
  git config --local diff.ignoreSubmodules dirty
  git config --local diff.submodule log
  git config --local status.submoduleSummary true
  echo "Done"
}

#######################################
# Rename a git branch locally and remotely (if tracked).
# Arguments:
#   $1 (optional): old_branch name (defaults to current branch if omitted)
#   $2 (required): new_branch name
# Usage:
#   grename new_name          # Rename current branch to new_name
#   grename old_name new_name # Rename old_name to new_name
#######################################
grename() {
  local old_branch new_branch

  if [[ -z "$1" ]]; then
    echo "Usage: grename [old_branch] new_branch"
    return 1
  fi

  if [[ -z "$2" ]]; then
    # If only one argument, rename current branch
    old_branch="$(git symbolic-ref --short HEAD)"
    new_branch="$1"
  else
    old_branch="$1"
    new_branch="$2"
  fi

  # Rename branch locally
  git branch -m "$old_branch" "$new_branch"

  # Check if the old branch was tracking a remote branch
  if git config "branch.${old_branch}.remote" >/dev/null 2>&1; then
    # Push the new branch and set upstream
    git push origin -u "$new_branch"
    # Delete the old remote branch
    git push origin --delete "$old_branch"
  fi
}

#######################################
# Rebuild all local branches to have a single initial commit.
# WARNING: This is a destructive operation that wipes all commit history!
# Arguments: None
#######################################
grebuild() {
  echo "WARNING: This will wipe ALL commit history from ALL local branches!"
  echo -n "Are you sure you want to proceed? [y/N] "
  read -r response
  if [[ ! "$response" =~ ^[yY]$ ]]; then
    echo "Aborted."
    return 1
  fi

  local current_branch
  current_branch=$(git symbolic-ref --short HEAD 2>/dev/null)

  git branch --format="%(refname:lstrip=2)" | while read -r branch; do
    echo "Rebuilding $branch..."
    git checkout "$branch" >/dev/null 2>&1 || continue
    git checkout --orphan "${branch}_temp" >/dev/null 2>&1
    git add -A
    git commit -m "Initial commit" >/dev/null 2>&1
    git branch -D "$branch" >/dev/null 2>&1
    git branch -m "$branch" >/dev/null 2>&1
  done

  echo "Running garbage collection..."
  git gc --aggressive --prune=all >/dev/null 2>&1

  # Restore original branch if possible
  if [[ -n "$current_branch" ]]; then
    git checkout "$current_branch" >/dev/null 2>&1
  fi

  echo "Done. Use 'git push -f --all' to update remote."
}

gpr-start() {
  gh repo fork --remote --remote-name "${1:-upstream}"
}

gpr-end() {
  git fetch origin
  gh delete-repo "$(git remote get-url "${1:-upstream}" \
    | sed -n 's/.*github.com\/\(.*\)\.git/\1/p')"
  git checkout origin/HEAD && git remote remove "${1:-upstream}"
}

# outcp() {
#   # setopt local_options local_traps
#   # unsetopt print_exit_value
#   trap 'echo "\nOutput copied!"' INT
#   tee << (eval "$@") >(pbcopy) 2>/dev/null && echo "\nOutput copied!"
# }

# Remove .DS_Store files recursively in a directory, default .
rmdsstore() {
  find "${@:-.}" -type f -name .DS_Store -delete
}

#######################################
# Analyze and visualize shell command history statistics.
# Displays the most frequently used commands with a color-coded bar chart.
#
# Arguments:
#   $1 (optional): Number of top commands to display (default: 30)
#
# Usage:
#   hist_stats      # Show top 30 commands
#   hist_stats 50   # Show top 50 commands
#######################################
hist_stats() {
  fc -l 1 \
    | perl -lane '
      $c = $F[1];
      if ($c eq "sudo") { $c = $F[2]; }
      if ($c ne "") {
        $h{$c}++;
        $total++;
      }
      END {
        foreach (keys %h) {
          printf "%s %.2f%% %d\n", $_, ($h{$_}*100/$total), $h{$_};
        }
      }' \
    | grep -v "\./" \
    | sort -nr -k 3 \
    | head -n "${1:-30}" \
    | perl -lane '
      BEGIN {
        $w=25;
        $rst="\033[0m";
        $blue="\033[1;34m";
        $grn="\033[32m";
        $gray="\033[90m";
      }
      if ($.==1) { $max=$F[2]; }
      $l = $max > 0 ? int($F[2]/$max*$w) : 0;
      printf "%s%-15s%s %s%7s%s %s%4d%s %s%s%s\n", 
        $blue, $F[0], $rst,
        $gray, $F[1], $rst,
        $gray, $F[2], $rst,
        $grn, "▄" x $l, $rst;
    '
}
