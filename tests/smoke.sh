#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR=$(CDPATH= cd -- "$(dirname -- "$0")/.." && pwd)
TMP_HOME=$(mktemp -d)
trap 'rm -rf "$TMP_HOME"' EXIT

printf '%s\n' '# existing profile' > "$TMP_HOME/.bash_profile"
HOME="$TMP_HOME" bash "$ROOT_DIR/setup.sh" --capture-local
HOME="$TMP_HOME" bash "$ROOT_DIR/setup.sh" --integrate

grep -Fq '# existing profile' "$TMP_HOME/.bash_profile"
grep -Fq '# >>> mac-setup managed block >>>' "$TMP_HOME/.bash_profile"
test -f "$TMP_HOME/.config/mac-setup/captured/bash_profile"

before=$(wc -c < "$TMP_HOME/.bash_profile")
HOME="$TMP_HOME" bash "$ROOT_DIR/setup.sh" --integrate
after=$(wc -c < "$TMP_HOME/.bash_profile")
test "$before" -eq "$after"

bash -n "$ROOT_DIR/setup.sh"
printf '%s\n' 'smoke tests passed'
