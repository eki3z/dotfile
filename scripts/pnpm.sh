cd "$(dirname "${BASH_SOURCE[0]}")" && source "./utils.sh"

_pnpm_cache="$dotcache/Pnpmfile"

pnpm_check() {
  if ! cmd_exists "pnpm"; then
    print_error "pnpm: " "cannot found"
    exit 1
  fi
}

pnpm_install() {
  print_in_yellow "\n   pnpm: install start ...\n\n"

  if [ ! -h "$_pnpm_cache" ]; then
    print_error "path: $_pnpm_cache not linked yet."
    exit 1
  fi

  cat "$_pnpm_cache" | xargs pnpm add --global
  print_result $? "pnpm: install done"
}

pnpm_dump() {
  print_in_yellow "\n   pnpm: dump start ...\n\n"
  pnpm list --global --json \
    | jq -r '.[] | .dependencies | values[] | "\(.from)@\(.version)"' \
      >"$_pnpm_cache"
  print_result $? "pnpm: dump done"
}

main() {

  pnpm_check

  print_in_purple "\n   pnpm: option\n\n"

  select opt in install dump; do
    case $opt in
      install)
        pnpm_install
        break
        ;;
      dump)
        pnpm_dump
        break
        ;;
    esac
  done
}

main
