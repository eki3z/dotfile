#!/usr/bin/env bash

# SEE https://stackoverflow.com/a/53772163

cd "$(dirname "${BASH_SOURCE[0]}")" || exit 1
source "./utils.sh"
source "../path.sh"

declare -a sets_to_link=("BASE")

select_set() {
  local COLUMNS=0
  select opt in "${sets_all[@]}" "Quit"; do
    if [ -n "$opt" ]; then
      case $opt in
        Quit)
          exit 0
          ;;
        BASE)
          return 0
          ;;
        SYS_*)
          sets_to_link+=("$opt")
          ;;
        *)
          local current_os
          case "$(uname -sr)" in
            Darwin*)
              current_os="SYS_mac"
              ;;
            Linux*Microsoft*)
              current_os="SYS_wsl"
              ;;
            Linux*)
              current_os="SYS_linux"
              ;;
            CYGWIN* | MINGW* | MSYS*)
              current_os="SYS_win"
              ;;
            *)
              print_error "System cannot be identified!" && exit 1
              ;;
          esac
          sets_to_link+=("$current_os" "$opt")
          ;;
      esac
      break
    fi
  done
}

#######################################
# create_symlinks
# Outputs:
# SOURCE    TARGET    STATUS
#  No        No        Lack
#  Yes       Yes       Same/Cover/Keep
#  Yes       No        New
#  No        Yes       New
#######################################

create_symlinks() {

  for set in "${sets_to_link[@]}"; do

    print_in_yellow "\n   $set\n\n"
    printf "   %-9s %-30s        %s\n" "Status" "Source" "Target"

    local IFS='^'
    local regexp='^(.*) <- (.*)$'

    for i in $(eval printf '%s^' \"\$\{"${set}"[@]\}\"); do
      local source target cmd info
      if [[ "$i" =~ $regexp ]]; then
        source="$(cd ../source && echo "$PWD/${BASH_REMATCH[1]}" || exit)"
        target="${BASH_REMATCH[2]}"
        target="${target/#\~/$HOME}"
        local target_pretty="${target/#$HOME/~}"

        cmd="ln -fs \"$source\" \"$target\""
        info="$(printf "%-30s  <-    %s" "${BASH_REMATCH[1]}" "$target_pretty")"

        if [ ! -e "$source" ] && [ ! -e "$target" ]; then
          print_error "Lack  $info"

        elif [ -e "$source" ] && [ -e "$target" ]; then

          if [ "$(readlink "$target")" == "$source" ]; then
            print_in_purple "   [✔] Same  $info\n"
          else
            ask_for_confirmation "\"$target_pretty\" exists, overwrite it?"
            if answer_is_yes; then
              mv "$target" "$dotcache/backup"
              execute "$cmd" "Cover $info"
            else
              print_error "Keep  $info"
            fi
          fi

        else
          mkdir -p "$(dirname "$source")" "$(dirname "$target")"
          [ ! -e "$source" ] && mv "$target" "$source"
          execute "$cmd" "New   $info"
        fi
      fi
    done
  done
}

main() {
  print_in_purple "\n   link: backup check ...\n\n"
  mkd "$dotcache/backup"

  print_in_purple "\n   link: select your choice ...\n\n"
  select_set

  print_in_purple "\n   link: symlink start ...\n\n"
  create_symlinks
}

main
