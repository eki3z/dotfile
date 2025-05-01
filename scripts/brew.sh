#!/usr/bin/env bash

cd "$(dirname "${BASH_SOURCE[0]}")" && source "./utils.sh"

_brew_cache="$HOME/$dotcache/Brewfile"

brewfile_check() {
  if [ ! -h "$_brew_cache" ]; then
    print_error "path: $_brew_cache not linked yet."
    exit 1
  fi
}

brew_install() {
  print_in_yellow "\n   brew: install start ...\n\n"

  # exclude emacs-head
  HOMEBREW_BUNDLE_BREW_SKIP="daviderestivo/emacs-head/emacs-head@28"

  brew bundle install --file "$_brew_cache"
  print_result $? "brew: install done"
}

brew_dump() {
  print_in_yellow "\n   brew: dump start ...\n\n"
  brew bundle dump --formula --cask --tap --force --file "$_brew_cache"
  print_result $? "brew: dump done"
}

main() {
  cd .. || return 1

  brewfile_check

  print_in_purple "\n   brew: bundle\n\n"

  select opt in install dump; do
    case $opt in
      install)
        brew_install
        break
        ;;
      dump)
        brew_dump
        break
        ;;
    esac
  done
}

main
