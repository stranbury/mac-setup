#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR=$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)
CONFIG_DIR=${MAC_SETUP_CONFIG_DIR:-"$HOME/.config/mac-setup"}
CAPTURE_DIR="$CONFIG_DIR/captured"
MARKER="# >>> mac-setup managed block >>>"
MARKER_END="# <<< mac-setup managed block <<<"

usage() {
  cat <<'EOF'
Usage: bash setup.sh [command]

Commands:
  --capture-local   Copy safe local shell and Git settings to ~/.config/mac-setup/captured
  --unix            Install the portable Unix configuration and shell hooks
  --integrate       Add non-destructive hooks to Bash and Zsh startup files
  --local-packages  Install packages listed in local/packages.txt when Homebrew is available
  --install         Run the Unix, local integration, and macOS installers
EOF
}

backup_once() {
  local file=$1
  if [ -e "$file" ] && [ ! -e "$file.mac-setup-backup" ]; then
    cp -p "$file" "$file.mac-setup-backup"
  fi
}

append_hook() {
  local file=$1
  mkdir -p "$(dirname -- "$file")"
  touch "$file"
  if ! grep -Fq "$MARKER" "$file"; then
    backup_once "$file"
    cat >> "$file" <<EOF

$MARKER
export MAC_SETUP_ROOT="$ROOT_DIR"
if [ -f "\$MAC_SETUP_ROOT/unix/profile" ]; then
  . "\$MAC_SETUP_ROOT/unix/profile"
fi
if [ -f "$CONFIG_DIR/local.sh" ]; then
  . "$CONFIG_DIR/local.sh"
fi
$MARKER_END
EOF
  fi
}

capture_file() {
  local source=$1
  local target="$CAPTURE_DIR/$(basename -- "$source")"
  if [ -f "$source" ]; then
    cp -p "$source" "$target"
    chmod 600 "$target"
    printf 'Captured %s\n' "$source"
  fi
}

capture_local() {
  mkdir -p "$CAPTURE_DIR"
  capture_file "$HOME/.bash_profile"
  capture_file "$HOME/.bashrc"
  capture_file "$HOME/.zprofile"
  capture_file "$HOME/.zshrc"
  capture_file "$HOME/.aliases"
  capture_file "$HOME/.exports"
  capture_file "$HOME/.functions"
  capture_file "$HOME/.extra"
  capture_file "$HOME/.gitconfig"
  cat > "$CAPTURE_DIR/README" <<'EOF'
These files were captured from the workstation and are not tracked by Git.
Review them for credentials, tokens, private paths, and machine-specific data
before copying any values into local.sh or local/packages.txt.
EOF
  chmod 600 "$CAPTURE_DIR/README"
  printf 'Local configuration captured under %s\n' "$CAPTURE_DIR"
}

integrate() {
  mkdir -p "$CONFIG_DIR"
  if [ ! -f "$CONFIG_DIR/local.sh" ]; then
    printf '%s\n' '# Add workstation-specific exports and aliases here.' > "$CONFIG_DIR/local.sh"
    chmod 600 "$CONFIG_DIR/local.sh"
  fi
  append_hook "$HOME/.bash_profile"
  append_hook "$HOME/.zprofile"
  append_hook "$HOME/.zshrc"
  printf 'Integrated mac-setup hooks into Bash and Zsh startup files.\n'
}

install_unix() { integrate; }

install_local_packages() {
  if ! command -v brew >/dev/null 2>&1; then
    printf 'Homebrew is not installed; skipping local packages.\n'
    return 0
  fi
  if [ -f "$CONFIG_DIR/local/packages.txt" ]; then
    while IFS= read -r package; do
      case "$package" in ''|'#'*) continue ;; esac
      brew install "$package"
    done < "$CONFIG_DIR/local/packages.txt"
  fi
}

install_macos() {
  if [ "$(uname -s)" != "Darwin" ]; then
    printf 'macOS installation requires Darwin; skipping.\n'
    return 0
  fi
  [ -f "$ROOT_DIR/setup/brew" ] && bash "$ROOT_DIR/setup/brew"
  [ -f "$ROOT_DIR/setup/npm" ] && bash "$ROOT_DIR/setup/npm"
  [ -f "$ROOT_DIR/setup/cask" ] && bash "$ROOT_DIR/setup/cask"
}

command=${1:---help}
case "$command" in
  --capture-local) capture_local ;;
  --unix) install_unix ;;
  --integrate) integrate ;;
  --local-packages) install_local_packages ;;
  --install) install_unix; install_local_packages; install_macos ;;
  --help|-h) usage ;;
  *) usage >&2; exit 2 ;;
esac
