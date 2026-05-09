#!/usr/bin/env bash
set -euo pipefail

PROFILE="${1:-base}"

install_extensions() {
  local file="$1"

  if [[ ! -f "$file" ]]; then
    echo "Extension file not found: $file"
    exit 1
  fi

  while IFS= read -r extension || [[ -n "$extension" ]]; do
    extension="$(echo "$extension" | xargs)"

    if [[ -z "$extension" || "$extension" =~ ^# ]]; then
      continue
    fi

    echo "Installing extension: $extension"
    code --install-extension "$extension" --force
  done < "$file"
}

require_code_cli() {
  if ! command -v code >/dev/null 2>&1; then
    echo "The 'code' command was not found."
    echo "Open VS Code, run: Shell Command: Install 'code' command in PATH"
    exit 1
  fi
}

require_code_cli

echo "Installing base extensions..."
install_extensions "./extensions/base.txt"

case "$PROFILE" in
  base)
    ;;
  webstorm)
    echo "Installing WebStorm-like extensions..."
    install_extensions "./extensions/webstorm.txt"
    ;;
  rider)
    echo "Installing Rider-like extensions..."
    install_extensions "./extensions/rider.txt"
    ;;
  pycharm)
    echo "Installing PyCharm-like extensions..."
    install_extensions "./extensions/pycharm.txt"
    ;;
  datagrip)
    echo "Installing DataGrip-like extensions..."
    install_extensions "./extensions/datagrip.txt"
    ;;
  all)
    echo "Installing all profile extensions..."
    install_extensions "./extensions/webstorm.txt"
    install_extensions "./extensions/rider.txt"
    install_extensions "./extensions/pycharm.txt"
    install_extensions "./extensions/datagrip.txt"
    ;;
  *)
    echo "Unknown profile: $PROFILE"
    echo "Usage: ./install.sh [base|webstorm|rider|pycharm|datagrip|all]"
    exit 1
    ;;
esac

echo "Done."