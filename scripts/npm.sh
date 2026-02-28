#!/usr/bin/env bash

cd "$(dirname "${BASH_SOURCE[0]}")" && source "./utils.sh"

_npm_cache="$dotcache/Npmfile"

npm_check() {
  if ! cmd_exists "npm"; then
    print_error "npm: " "cannot found"
    exit 1
  fi
}

npm_install() {
  print_in_yellow "\n   npm: install start ...\n\n"

  if [ ! -h "$_npm_cache" ]; then
    print_error "path: $_npm_cache not linked yet."
    exit 1
  fi

  xargs -n 1 npm install --global <"$_npm_cache"
  print_result $? "npm: install done"
}

npm_dump() {
  print_in_yellow "\n   npm: dump start ...\n\n"
  npm list --global --json \
    | jq -r '.dependencies | to_entries[] | "\(.key)@\(.value|.version)"' \
      >"$_npm_cache"
  print_result $? "npm: dump done"
}

main() {

  npm_check

  print_in_purple "\n   npm: option\n\n"

  select opt in install dump; do
    case $opt in
      install)
        npm_install
        break
        ;;
      dump)
        npm_dump
        break
        ;;
    esac
  done
}

main
