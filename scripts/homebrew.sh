#!/usr/bin/env bash

cd "$(dirname "${BASH_SOURCE[0]}")" && source "./utils.sh"

get_homebrew_git_config_file_path() {

  local path=""

  if path="$(brew --repository 2>/dev/null)/.git/config"; then
    printf "%s" "$path"
    return 0
  else
    print_error "Homebrew (get config file path)"
    return 1
  fi

}

install_homebrew() {
  if ! cmd_exists "brew"; then
    print_info "Installing Homebrew..."
    ask_for_sudo
    # Use NONINTERACTIVE=1 to avoid prompts during installation
    # Use mirrors for faster installation in CN
    NONINTERACTIVE=1 /bin/bash -c "$(curl -fsSL https://mirrors.ustc.edu.cn/misc/brew-install.sh)"
    print_result $? "Homebrew installation"
  else
    print_success "Homebrew is already installed."
  fi
}

opt_out_of_analytics() {
  local path=""

  # Try to get the path of the `Homebrew` git config file.
  if ! path="$(get_homebrew_git_config_file_path)"; then
    return 1
  fi

  # Opt-out of Homebrew's analytics.
  # https://docs.brew.sh/Analytics
  if [ "$(git config --file="$path" --get homebrew.analyticsdisabled)" != "true" ]; then
    git config --file="$path" --replace-all homebrew.analyticsdisabled true &>/dev/null
    print_result $? "Homebrew (opt-out of analytics)"
  else
    print_success "Homebrew analytics already disabled."
  fi
}

main() {
  print_in_purple "\n   Homebrew Check\n\n"
  
  install_homebrew
  opt_out_of_analytics
}

main
