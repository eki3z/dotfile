#!/usr/bin/env bash

cd "$(dirname "${BASH_SOURCE[0]}")" && source "./utils.sh"

_pip_cache="$DOTCACHE/requirements.txt"

pip_check() {
  if ! cmd_exists "pip3"; then
    print_error "pip3: " "cannot found"
    exit 1
  fi

  if [ ! -h "$_pip_cache" ]; then
    print_error "path: $_pip_cache not linked yet."
    exit 1
  fi
}

pip_install() {
  print_in_yellow "\n   pip: install start ...\n\n"
  pip3 install --user -r "$_pip_cache"
  print_result $? "pip: install done"
}

pip_freeze() {
  print_in_yellow "\n   pip: freeze start ...\n\n"
  local tmp_file
  tmp_file="$(mktemp)"
  pip3 freeze -r "$_pip_cache" >"$tmp_file" && mv "$tmp_file" "$_pip_cache"
  print_result $? "pip: freeze done"
}

main() {

  pip_check

  print_in_purple "\n   pip: option\n\n"

  select opt in install freeze; do
    case $opt in
      install)
        pip_install
        break
        ;;
      freeze)
        pip_freeze
        break
        ;;
    esac
  done
}

main
