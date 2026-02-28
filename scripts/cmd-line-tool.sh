#!/usr/bin/env bash

cd "$(dirname "${BASH_SOURCE[0]}")" && source "./utils.sh"

are_command_line_tools_installed() {
  xcode-select --print-path &>/dev/null
}

install_command_line_tools() {
  if are_command_line_tools_installed; then
    print_success "Command Line Tools are already installed."
    return 0
  fi

  # If necessary, prompt user to install the `Xcode Command Line Tools`.
  print_info "Installing Command Line Tools..."
  xcode-select --install &>/dev/null

  # Wait until the `Xcode Command Line Tools` are installed.
  # We use a loop to check if the tools are installed because the `xcode-select --install` command returns immediately.
  # The `execute` function (from utils.sh) handles the spinner and logging.
  execute \
    "until are_command_line_tools_installed; do \
       sleep 5; \
     done" \
    "Command Line Tools Installation"
}

main() {
  
  print_in_purple "   Command Line Tools\n\n"
  
  install_command_line_tools
  # install_xcode
  # set_xcode_developer_directory
  # agree_with_xcode_licence
  
}

main
