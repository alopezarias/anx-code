#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
PROFILE="${1:-base}"
CODE_BIN=""
FAILED_EXTENSIONS=()
WARNED_EXTENSIONS=()

install_extensions() {
  local file="$1"
  local output

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

    if output=$("$CODE_BIN" --install-extension "$extension" 2>&1); then
      printf '%s\n' "$output"
      continue
    fi

    printf '%s\n' "$output"

    if [[ "$output" == *"already installed"* || "$output" == *"cannot be downgraded"* ]]; then
      echo "Skipping non-fatal extension conflict: $extension"
      WARNED_EXTENSIONS+=("$extension")
      continue
    fi

    FAILED_EXTENSIONS+=("$extension")
  done < "$file"
}

require_code_cli() {
  local candidates=()

  if command -v code >/dev/null 2>&1; then
    CODE_BIN="$(command -v code)"
    return
  fi

  candidates=(
    "/Applications/Visual Studio Code.app/Contents/Resources/app/bin/code"
    "$HOME/Applications/Visual Studio Code.app/Contents/Resources/app/bin/code"
    "/usr/share/code/bin/code"
    "/snap/bin/code"
  )

  for candidate in "${candidates[@]}"; do
    if [[ -x "$candidate" ]]; then
      CODE_BIN="$candidate"
      return
    fi
  done

  echo "Could not find the VS Code CLI."
  echo "Install VS Code or expose 'code' in PATH."
  exit 1
}

require_code_cli

echo "Installing base extensions..."
install_extensions "$SCRIPT_DIR/extensions/base.txt"

case "$PROFILE" in
  base)
    ;;
  webstorm)
    echo "Installing WebStorm-like extensions..."
    install_extensions "$SCRIPT_DIR/extensions/webstorm.txt"
    ;;
  rider)
    echo "Installing Rider-like extensions..."
    install_extensions "$SCRIPT_DIR/extensions/rider.txt"
    ;;
  pycharm)
    echo "Installing PyCharm-like extensions..."
    install_extensions "$SCRIPT_DIR/extensions/pycharm.txt"
    ;;
  datagrip)
    echo "Installing DataGrip-like extensions..."
    install_extensions "$SCRIPT_DIR/extensions/datagrip.txt"
    ;;
  all)
    echo "Installing all profile extensions..."
    install_extensions "$SCRIPT_DIR/extensions/webstorm.txt"
    install_extensions "$SCRIPT_DIR/extensions/rider.txt"
    install_extensions "$SCRIPT_DIR/extensions/pycharm.txt"
    install_extensions "$SCRIPT_DIR/extensions/datagrip.txt"
    ;;
  *)
    echo "Unknown profile: $PROFILE"
    echo "Usage: ./install.sh [base|webstorm|rider|pycharm|datagrip|all]"
    exit 1
    ;;
esac

if [[ ${#FAILED_EXTENSIONS[@]} -gt 0 ]]; then
  echo "Failed extensions: ${FAILED_EXTENSIONS[*]}"
  exit 1
fi

if [[ ${#WARNED_EXTENSIONS[@]} -gt 0 ]]; then
  echo "Skipped extensions with existing VS Code conflicts: ${WARNED_EXTENSIONS[*]}"
fi

echo "Done."
