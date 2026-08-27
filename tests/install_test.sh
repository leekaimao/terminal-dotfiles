#!/bin/sh
set -eu

REPO_ROOT=$(CDPATH= cd -- "$(dirname -- "$0")/.." && pwd)
INSTALL_SCRIPT="$REPO_ROOT/install.sh"
DOCTOR_SCRIPT="$REPO_ROOT/doctor.sh"
TEST_BASE="${TMPDIR:-/tmp}"
TEST_TMP=$(mktemp -d "$TEST_BASE/terminal-dotfiles-test.XXXXXX")
TEST_HOME="$TEST_TMP/home with space"

cleanup() {
  case "$TEST_TMP" in
    "$TEST_BASE"/terminal-dotfiles-test.*) rm -rf -- "$TEST_TMP" ;;
    *) printf 'Refusing unsafe cleanup path: %s\n' "$TEST_TMP" >&2 ;;
  esac
}
trap cleanup EXIT HUP INT TERM

fail() {
  printf 'FAIL: %s\n' "$1" >&2
  exit 1
}

assert_file() {
  [ -f "$1" ] || fail "missing file: $1"
}

assert_contains() {
  grep -Fq "$2" "$1" || fail "$1 does not contain: $2"
}

assert_count() {
  actual=$(grep -Fc "$2" "$1" || true)
  [ "$actual" -eq "$3" ] || fail "$1 contains '$2' $actual times; expected $3"
}

[ -x "$INSTALL_SCRIPT" ] || fail "install.sh is not implemented or executable"
[ -x "$DOCTOR_SCRIPT" ] || fail "doctor.sh is not implemented or executable"

mkdir -p "$TEST_HOME/.config/ghostty"
printf 'legacy ghostty config\n' > "$TEST_HOME/.config/ghostty/config"
printf 'export KEEP_EXISTING_ZSHRC=1\n' > "$TEST_HOME/.zshrc"
printf '[user]\n    name = Keep Existing Identity\n' > "$TEST_HOME/.gitconfig"

if "$DOCTOR_SCRIPT" --home "$TEST_HOME" --skip-tools > "$TEST_TMP/pre-install-doctor.log" 2>&1; then
  fail "doctor unexpectedly passed before installation"
fi

"$INSTALL_SCRIPT" --dry-run --home "$TEST_HOME" > "$TEST_TMP/dry-run.log"
assert_contains "$TEST_TMP/dry-run.log" "DRY-RUN"
assert_contains "$TEST_HOME/.config/ghostty/config" "legacy ghostty config"
[ ! -e "$TEST_HOME/.config/atuin/config.toml" ] || fail "dry-run modified target home"

"$INSTALL_SCRIPT" --apply --home "$TEST_HOME" > "$TEST_TMP/apply.log"

assert_file "$TEST_HOME/.config/cmux/cmux.json"
assert_file "$TEST_HOME/.config/ghostty/config"
assert_file "$TEST_HOME/.config/atuin/config.toml"
assert_file "$TEST_HOME/.config/yazi/yazi.toml"
assert_file "$TEST_HOME/.config/yazi/theme.toml"
assert_file "$TEST_HOME/.config/yazi/package.toml"
assert_file "$TEST_HOME/Library/Application Support/lazygit/config.yml"
assert_file "$TEST_HOME/.config/btop/btop.conf"
assert_file "$TEST_HOME/.config/btop/themes/catppuccin_mocha.theme"
assert_file "$TEST_HOME/.config/git/delta.gitconfig"
assert_file "$TEST_HOME/.config/terminal-dotfiles/modern-terminal.zsh"
assert_file "$TEST_HOME/.p10k.zsh"
assert_file "$TEST_HOME/.zshrc"
assert_file "$TEST_HOME/.gitconfig"

assert_contains "$TEST_HOME/.config/ghostty/config" "theme = Catppuccin Mocha"
assert_contains "$TEST_HOME/.config/atuin/config.toml" "auto_sync = false"
assert_contains "$TEST_HOME/.zshrc" "export KEEP_EXISTING_ZSHRC=1"
assert_contains "$TEST_HOME/.gitconfig" "name = Keep Existing Identity"
assert_contains "$TEST_HOME/.zshrc" '.config/terminal-dotfiles/modern-terminal.zsh'
assert_contains "$TEST_HOME/.gitconfig" '.config/git/delta.gitconfig'
git_include=$(git config --file "$TEST_HOME/.gitconfig" --get-all include.path 2>/dev/null || true)
[ "$git_include" = '~/.config/git/delta.gitconfig' ] || fail ".gitconfig include is not valid Git configuration"

backup_file=$(find "$TEST_HOME/.terminal-config-backups" -type f -path '*/.config/ghostty/config' -print -quit)
[ -n "$backup_file" ] || fail "existing Ghostty config was not backed up"
assert_contains "$backup_file" "legacy ghostty config"

"$INSTALL_SCRIPT" --apply --home "$TEST_HOME" > "$TEST_TMP/reapply.log"
assert_count "$TEST_HOME/.zshrc" '.config/terminal-dotfiles/modern-terminal.zsh' 1
assert_count "$TEST_HOME/.gitconfig" '.config/git/delta.gitconfig' 1

"$DOCTOR_SCRIPT" --home "$TEST_HOME" --skip-tools > "$TEST_TMP/doctor.log"
assert_contains "$TEST_TMP/doctor.log" "Configuration check passed"

if "$INSTALL_SCRIPT" --unknown-option > "$TEST_TMP/invalid.log" 2>&1; then
  fail "unknown option unexpectedly succeeded"
fi

printf 'PASS: dry-run, backup, install, idempotence, and invalid-input checks\n'
