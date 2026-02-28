#!/usr/bin/env bash

cd "$(dirname "${BASH_SOURCE[0]}")" && source "./utils.sh"

install_emacs() {

  if ! brew list --version emacs-head@30 >/dev/null 2>&1; then
    print_in_yellow "   emacs-head@30: install start ...\n\n"
    brew install emacs-head@30 \
      --with-cocoa \
      --with-xwidgets \
      --with-mailutils \
      --with-tree-sitter \
      --with-poll
  fi

  print_result $? "emacs-head@30: install done"

}

clone_emacs() {
  local emacs_dir="$HOME/.config/emacs"

  if [[ ! -d "$emacs_dir/.git" ]]; then
    [ -d "$emacs_dir" ] && mv "$emacs_dir" "$DOTCACHE/backup/"
    print_in_yellow "   emacs-head@30: clone start ...\n\n"
    command git clone https://github.com/liuyinz/emacs.d.git "$emacs_dir"
  fi

  print_result $? "emacs-head@30: clone done"

}

submodule_emacs() {
  local emacs_dir="$HOME/.config/emacs"

  print_in_yellow "   emacs-head@30: submodule start ...\n\n"
  git -C "$emacs_dir" submodule update --init --jobs "$(nproc)"
  print_result $? "emacs-head@30: submodule done"
}

main() {
  print_in_purple "\n   emacs-head@30: install check ...\n\n"
  install_emacs

  print_in_purple "\n   emacs-head@30: clone check ...\n\n"
  clone_emacs

  print_in_purple "\n   emacs-head@30: submodule check ...\n\n"
  submodule_emacs
}

main
