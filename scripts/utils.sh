#!/usr/bin/env bash

# Global constants
DOTCACHE="${DOTFILE_HOME:-$HOME/.config/dotfile}/.cache"
# Use tput for better portability, fallback to ANSI codes if tput fails
if tput setaf 1 &> /dev/null; then
  COLOR_RED=$(tput setaf 1)
  COLOR_GREEN=$(tput setaf 2)
  COLOR_YELLOW=$(tput setaf 3)
  COLOR_BLUE=$(tput setaf 4)
  COLOR_PURPLE=$(tput setaf 5)
  COLOR_CYAN=$(tput setaf 6)
  COLOR_WHITE=$(tput setaf 7)
  COLOR_GREY=$(tput setaf 8)
  COLOR_RESET=$(tput sgr0)
else
  COLOR_RED="\033[0;31m"
  COLOR_GREEN="\033[0;32m"
  COLOR_YELLOW="\033[0;33m"
  COLOR_BLUE="\033[0;34m"
  COLOR_PURPLE="\033[0;35m"
  COLOR_CYAN="\033[0;36m"
  COLOR_WHITE="\033[0;37m"
  COLOR_GREY="\033[0;90m"
  COLOR_RESET="\033[0m"
fi

answer_is_yes() {
  [[ "$REPLY" =~ ^[Yy]$ ]] \
    && return 0 \
    || return 1
}

ask() {
  print_question "$1"
  read -r
}

ask_for_confirmation() {
  print_question "$1 (y/n) "
  read -r -n 1
  printf "\n"
}

ask_for_sudo() {
  # Ask for the administrator password upfront.
  sudo -v &>/dev/null

  # Update existing `sudo` time stamp until this script has finished.
  # https://gist.github.com/cowboy/3118588
  while true; do
    sudo -n true
    sleep 60
    kill -0 "$$" || exit
  done &>/dev/null &
}

cmd_exists() {
  command -v "$1" &>/dev/null
}

kill_all_subprocesses() {
  local i=""
  for i in $(jobs -p); do
    kill "$i"
    wait "$i" &>/dev/null
  done
}

execute() {
  local -r CMDS="$1"
  local -r MSG="${2:-$1}"
  local -r TMP_FILE="$(mktemp /tmp/dotfiles_log.XXXXX)"

  local exitCode=0
  local cmdsPID=""

  # If the current process is ended, also end all its subprocesses.
  set_trap "EXIT" "kill_all_subprocesses"

  # Execute commands in background
  eval "$CMDS" \
    > /dev/null \
    2>"$TMP_FILE" &

  cmdsPID=$!

  # Show a spinner if the commands require more time to complete.
  show_spinner "$cmdsPID" "$CMDS" "$MSG"

  # Wait for the commands to no longer be executing
  # in the background, and then get their exit code.
  wait "$cmdsPID" &>/dev/null
  exitCode=$?

  # Print output based on what happened.
  print_result $exitCode "$MSG"

  if [ $exitCode -ne 0 ]; then
    print_error_stream <"$TMP_FILE"
  fi

  rm -rf "$TMP_FILE"

  return $exitCode
}

get_answer() {
  printf "%s" "$REPLY"
}

get_os() {
  local os=""
  local kernelName=""

  kernelName="$(uname -s)"

  if [ "$kernelName" == "Darwin" ]; then
    os="macos"
  elif [ "$kernelName" == "Linux" ] \
    && [ -e "/etc/os-release" ]; then
    os="$(
      . /etc/os-release
      printf "%s" "$ID"
    )"
  else
    os="$kernelName"
  fi

  printf "%s" "$os"
}

get_os_version() {
  local os=""
  local version=""

  os="$(get_os)"

  if [ "$os" == "macos" ]; then
    version="$(sw_vers -productVersion)"
  elif [ -e "/etc/os-release" ]; then
    version="$(
      . /etc/os-release
      printf "%s" "$VERSION_ID"
    )"
  fi

  printf "%s" "$version"
}

is_git_repository() {
  git rev-parse &>/dev/null
}

is_supported_version() {
  # shellcheck disable=SC2206
  declare -a v1=(${1//./ })
  # shellcheck disable=SC2206
  declare -a v2=(${2//./ })
  local i=""

  # Fill empty positions in v1 with zeros.
  for ((i = ${#v1[@]}; i < ${#v2[@]}; i++)); do
    v1[i]=0
  done

  for ((i = 0; i < ${#v1[@]}; i++)); do
    # Fill empty positions in v2 with zeros.
    if [[ -z ${v2[i]} ]]; then
      v2[i]=0
    fi

    if ((10#${v1[i]} < 10#${v2[i]})); then
      return 1
    elif ((10#${v1[i]} > 10#${v2[i]})); then
      return 0
    fi
  done
}

mkd() {
  if [ -n "$1" ]; then
    if [ -e "$1" ]; then
      if [ ! -d "$1" ]; then
        print_error "$1 - a file with the same name already exists!"
      else
        print_success "$1 (directory exists)"
      fi
    else
      if mkdir -p "$1"; then
        print_success "$1 (created)"
      else
        print_error "Failed to create directory $1"
      fi
    fi
  fi
}

print_error() {
  print_in_red "   [✖] $1 $2\n"
}

print_error_stream() {
  while read -r line; do
    print_error "↳ ERROR: $line"
  done
}

print_in_color() {
  printf "%b" \
    "$2" \
    "$1" \
    "$COLOR_RESET"
}

print_in_red() {
  print_in_color "$1" "$COLOR_RED"
}

print_in_green() {
  print_in_color "$1" "$COLOR_GREEN"
}

print_in_yellow() {
  print_in_color "$1" "$COLOR_YELLOW"
}

print_in_blue() {
  print_in_color "$1" "$COLOR_BLUE"
}

print_in_purple() {
  print_in_color "$1" "$COLOR_PURPLE"
}

print_in_cyan() {
  print_in_color "$1" "$COLOR_CYAN"
}

print_in_white() {
  print_in_color "$1" "$COLOR_WHITE"
}

print_in_grey() {
  print_in_color "$1" "$COLOR_GREY"
}

print_info() {
  print_in_purple "   [i] $1\n"
}

print_question() {
  print_in_yellow "   [?] $1"
}

print_result() {
  if [ "$1" -eq 0 ]; then
    print_success "$2"
  else
    print_error "$2"
  fi
  return "$1"
}

print_success() {
  print_in_green "   [✔] $1\n"
}

print_warning() {
  print_in_yellow "   [!] $1\n"
}

set_trap() {
  trap -p "$1" | grep "$2" &>/dev/null \
    || trap '$2' "$1"
}

skip_questions() {
  while :; do
    case $1 in
      -y | --yes) return 0 ;;
      *) break ;;
    esac
    shift 1
  done
  return 1
}

show_spinner() {
  local -r FRAMES='/-\|'
  # shellcheck disable=SC2034
  local -r NUMBER_OR_FRAMES=${#FRAMES}
  local -r CMDS="$2"
  local -r MSG="$3"
  local -r PID="$1"
  local i=0
  local frameText=""

  # Handle Travis CI environment
  if [ "$TRAVIS" != "true" ]; then
    printf "\n\n\n"
    tput cuu 3
    tput sc
  fi

  # Display spinner while the commands are being executed.
  while kill -0 "$PID" &>/dev/null; do
    frameText="   [${FRAMES:i++%NUMBER_OR_FRAMES:1}] $MSG"

    if [ "$TRAVIS" != "true" ]; then
      printf "%s\n" "$frameText"
    else
      printf "%s" "$frameText"
    fi

    sleep 0.2

    if [ "$TRAVIS" != "true" ]; then
      tput rc
    else
      printf "\r"
    fi
  done
}
