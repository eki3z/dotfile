#!/usr/bin/env bash

# SEE https://stackoverflow.com/a/53772163

cd "$(dirname "${BASH_SOURCE[0]}")" || exit 1
source "./utils.sh"

SOURCE_DIR="$(cd ../source && pwd)"
CONFIG_FILE="../links.conf"

declare -a sets_to_link=("BASE")

# Function to read configuration and populate arrays
read_config() {
  local current_section=""

  if [ ! -f "$CONFIG_FILE" ]; then
    print_error "Configuration file not found: $CONFIG_FILE"
    exit 1
  fi

  while IFS= read -r line || [ -n "$line" ]; do
    # Skip comments and empty lines
    [[ "$line" =~ ^#.*$ ]] || [[ -z "$line" ]] && continue

    # Check for section headers [SECTION_NAME]
    if [[ "$line" =~ ^\[(.*)\]$ ]]; then
      current_section="${BASH_REMATCH[1]}"
      # Declare the array globally using declare -ga (Bash 4+)
      declare -ga "$current_section"
      continue
    fi

    # Add line to current section array if section is defined
    if [ -n "$current_section" ]; then
      # Use nameref to append to the dynamically named array (Bash 4.3+)
      local -n current_array="$current_section"
      current_array+=("$line")
    fi
  done <"$CONFIG_FILE"
}

# Load configuration immediately
read_config

# Dynamically get all defined sets (arrays) that match our expected pattern or logic
# For simplicity, we can hardcode the known sets or derive them.
# Given the previous logic used 'sets_all', let's reconstruct it.
# We can grep the config file for sections to populate sets_all dynamically.
declare -a sets_all
while IFS= read -r line; do
  if [[ "$line" =~ ^\[(.*)\]$ ]]; then
    sets_all+=("${BASH_REMATCH[1]}")
  fi
done <"$CONFIG_FILE"

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
# TARGET    SOURCE    STATUS
#  No        No        Lack
#  Yes       Yes       Same/Cover/Keep
#  No        Yes       New
#  Yes       No        New
#######################################

create_symlinks() {

  for set in "${sets_to_link[@]}"; do

    print_in_yellow "\n   $set\n\n"
    printf "   %-9s %-50s        %s\n" "Status" "Target" "Source"

    # Use nameref for cleaner array access (Bash 4.3+)
    local -n mappings="$set"

    for i in "${mappings[@]}"; do
      local source target cmd info

      # Use parameter expansion instead of regex for better performance and compatibility
      # Split by " -> "
      target="${i%% -> *}"
      local source_rel="${i#* -> }"

      # Basic validation: ensure the split actually happened
      if [[ "$target" == "$i" ]] || [[ "$source_rel" == "$i" ]]; then
        continue
      fi

      # Handle variable expansion manually for common variables
      # We do this because we're reading lines from a file, so variables aren't auto-expanded
      target="${target//\$dotcache/$dotcache}"
      target="${target/#\~/$HOME}"

      # Replace $HOME with ~ for pretty printing
      # Note: We must ensure HOME is not empty and properly escaped if needed,
      # but standard expansion ${target/#$HOME/~} usually works.
      # If it fails, it might be due to trailing slashes or exact match issues.
      local target_pretty="${target/#$HOME/\~}"

      source="$SOURCE_DIR/$source_rel"

      cmd="ln -fs \"$source\" \"$target\""
      info="$(printf "%-50s  ->    %s" "$target_pretty" "$source_rel")"

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
