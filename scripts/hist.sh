#!/usr/bin/env bash

cd "$(dirname "${BASH_SOURCE[0]}")" && source "./utils.sh"

_hist_cache="$DOTCACHE/.zsh_history"

hist_check() {
  if [ -z "$HISTFILE" ]; then
    print_error "HISTFILE: is empty."
    exit 1
  fi

  if [ -h "$_hist_cache" ]; then
    _hist_src=$(readlink "$_hist_cache")
  else
    print_error "path: $_hist_cache not linked yet."
    exit 1
  fi
}

hist_size() {
  wc -c <"$1" 2>/dev/null
}

hist_cleanup() {
  perl -i -lane '/:\d+;(.*)$/;$lines{$1}++ || print' "$HISTFILE"
}

hist_backup() {
  print_in_yellow "\n   hist: backup start ...\n\n"

  if [ "$HISTFILE" -nt "$_hist_src" ]; then
    if [ "$(hist_size "$HISTFILE")" -ge "$(hist_size "$_hist_src")" ]; then
      cp "$HISTFILE" "$_hist_src"
    fi
  fi

  print_result $? "hist: backup done"
}

hist_restore() {
  print_in_yellow "\n   hist: restore start ...\n\n"

  if [ "$(hist_size "$HISTFILE")" -le "$(hist_size "$_hist_src")" ]; then
    cp "$_hist_src" "$HISTFILE"
  fi

  print_result $? "hist: restore done"
}

#######################################
# hist_analyze
# Arguments:
#   Number: top most used command
# Outputs:
#   Analysis of commands history stats
#######################################

main() {

  hist_check

  hist_cleanup

  print_in_purple "\n hist: option\n\n"

  select opt in restore backup; do
    case $opt in
      restore)
        hist_restore
        break
        ;;
      backup)
        hist_backup
        break
        ;;
    esac
  done
}

main
