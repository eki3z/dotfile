#!/usr/bin/env bash

cd "$(dirname "${BASH_SOURCE[0]}")" && source "./utils.sh"

bash_install() {

  if ! brew list --version bash >/dev/null 2>&1; then
    print_in_yellow "   bash: install start ...\n\n"
    brew install bash
    print_result $? "bash installation"
  else
    print_success "bash is already installed."
  fi
}

zsh_install() {
  if ! cmd_exists "zsh" || ! brew list --version zsh >/dev/null 2>&1; then
    print_info "Installing zsh..."
    brew install zsh
    print_result $? "zsh installation"
  else
    print_success "zsh is already installed."
  fi
}

zsh_default() {
  local brew_zsh_path="/usr/local/bin/zsh"
  
  # On Apple Silicon, homebrew path is different
  if [[ "$(uname -m)" == "arm64" ]]; then
    brew_zsh_path="/opt/homebrew/bin/zsh"
  fi

  if [[ ! -x "$brew_zsh_path" ]]; then
    print_error "Homebrew zsh not found at $brew_zsh_path"
    return 1
  fi

  # Check if brew zsh is already in /etc/shells
  if ! grep -q "$brew_zsh_path" /etc/shells; then
    print_info "Adding $brew_zsh_path to /etc/shells..."
    echo "$brew_zsh_path" | sudo tee -a /etc/shells >/dev/null
  fi

  # Set zsh as the user login shell
  local current_shell
  current_shell=$(dscl . -read /Users/"$USER" UserShell | awk '{print $2}')
  
  if [[ "$current_shell" != "$brew_zsh_path" ]]; then
    print_info "Setting Homebrew zsh ($brew_zsh_path) as your default shell (password required)..."
    sudo chsh -s "$brew_zsh_path" "$USER"
    print_result $? "Set default shell to zsh"
  else
    print_success "Default shell is already Homebrew zsh."
  fi
}

zshrc_init() {
  if [ ! -e "$HOME/.zshrc" ]; then
    print_info "Initializing .zshrc..."
    # shellcheck disable=SC2016
    cat > "$HOME/.zshrc" <<EOF
## Uncomment line below to start zsh profiler
# ZSH_PROFILER="true"
source \$DOTFILE_HOME/.cache/init.zsh
EOF
    print_result $? ".zshrc initialization"
  else
    print_success ".zshrc already exists."
  fi
}

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

main() {
  print_in_purple "\n   Shell Setup Check\n\n"
  
  bash_install
  # macOS now defaults to zsh, so no need to install/set it manually
  # zsh_install
  # zsh_default
  zshrc_init
}

main
