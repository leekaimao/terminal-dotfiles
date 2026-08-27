#!/bin/sh
set -eu

MODE=dry-run
TARGET_HOME=${HOME:?HOME is not set}
REPO_ROOT=$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)
BACKUP_STAMP=$(date '+%Y%m%d-%H%M%S')
BACKUP_ROOT=

usage() {
  cat <<'EOF'
Usage: ./install.sh [--dry-run|--apply] [--home ABSOLUTE_PATH]

  --dry-run   Show planned changes without writing anything (default).
  --apply     Back up changed files and install the configuration.
  --home      Install into another home directory, useful for testing.
EOF
}

while [ "$#" -gt 0 ]; do
  case "$1" in
    --dry-run) MODE=dry-run ;;
    --apply) MODE=apply ;;
    --home)
      shift
      [ "$#" -gt 0 ] || { printf 'Missing value for --home\n' >&2; exit 2; }
      TARGET_HOME=$1
      ;;
    -h|--help) usage; exit 0 ;;
    *) printf 'Unknown option: %s\n' "$1" >&2; usage >&2; exit 2 ;;
  esac
  shift
done

case "$TARGET_HOME" in
  /*) ;;
  *) printf -- '--home must be an absolute path: %s\n' "$TARGET_HOME" >&2; exit 2 ;;
esac

backup_existing() {
  destination=$1
  relative_path=$2

  [ -e "$destination" ] || [ -L "$destination" ] || return 0
  [ -n "$BACKUP_ROOT" ] || BACKUP_ROOT="$TARGET_HOME/.terminal-config-backups/terminal-dotfiles-$BACKUP_STAMP"

  backup_path="$BACKUP_ROOT/$relative_path"
  mkdir -p "$(dirname -- "$backup_path")"
  cp -p "$destination" "$backup_path"
}

install_file() {
  source_file=$1
  relative_path=$2
  destination="$TARGET_HOME/$relative_path"

  [ -f "$source_file" ] || { printf 'Missing repository file: %s\n' "$source_file" >&2; exit 1; }

  if [ -f "$destination" ] && cmp -s "$source_file" "$destination"; then
    printf 'SKIP    %s\n' "$relative_path"
    return 0
  fi

  if [ "$MODE" = dry-run ]; then
    printf 'DRY-RUN %s\n' "$relative_path"
    return 0
  fi

  backup_existing "$destination" "$relative_path"
  mkdir -p "$(dirname -- "$destination")"
  cp "$source_file" "$destination"
  chmod 600 "$destination"
  printf 'INSTALL %s\n' "$relative_path"
}

ensure_line() {
  relative_path=$1
  required_line=$2
  destination="$TARGET_HOME/$relative_path"

  if [ -f "$destination" ] && grep -Fqx "$required_line" "$destination"; then
    printf 'SKIP    %s already configured\n' "$relative_path"
    return 0
  fi

  if [ "$MODE" = dry-run ]; then
    printf 'DRY-RUN append to %s\n' "$relative_path"
    return 0
  fi

  backup_existing "$destination" "$relative_path"
  mkdir -p "$(dirname -- "$destination")"
  touch "$destination"
  if [ -s "$destination" ]; then
    printf '\n' >> "$destination"
  fi
  printf '%s\n' "$required_line" >> "$destination"
  chmod 600 "$destination"
  printf 'UPDATE  %s\n' "$relative_path"
}

ensure_git_include() {
  relative_path=".gitconfig"
  destination="$TARGET_HOME/$relative_path"
  include_path='~/.config/git/delta.gitconfig'

  if [ -f "$destination" ] && git config --file "$destination" --get-all include.path 2>/dev/null | grep -Fxq "$include_path"; then
    printf 'SKIP    %s already configured\n' "$relative_path"
    return 0
  fi

  if [ "$MODE" = dry-run ]; then
    printf 'DRY-RUN append Git include to %s\n' "$relative_path"
    return 0
  fi

  backup_existing "$destination" "$relative_path"
  mkdir -p "$(dirname -- "$destination")"
  touch "$destination"
  if [ -s "$destination" ]; then
    printf '\n' >> "$destination"
  fi
  printf '[include]\n    path = %s\n' "$include_path" >> "$destination"
  chmod 600 "$destination"
  printf 'UPDATE  %s\n' "$relative_path"
}

install_file "$REPO_ROOT/config/cmux/cmux.json" ".config/cmux/cmux.json"
install_file "$REPO_ROOT/config/ghostty/config" ".config/ghostty/config"
install_file "$REPO_ROOT/config/powerlevel10k/.p10k.zsh" ".p10k.zsh"
install_file "$REPO_ROOT/config/atuin/config.toml" ".config/atuin/config.toml"
install_file "$REPO_ROOT/config/yazi/yazi.toml" ".config/yazi/yazi.toml"
install_file "$REPO_ROOT/config/yazi/theme.toml" ".config/yazi/theme.toml"
install_file "$REPO_ROOT/config/yazi/package.toml" ".config/yazi/package.toml"
install_file "$REPO_ROOT/config/lazygit/config.yml" "Library/Application Support/lazygit/config.yml"
install_file "$REPO_ROOT/config/btop/btop.conf" ".config/btop/btop.conf"
install_file "$REPO_ROOT/config/btop/themes/catppuccin_mocha.theme" ".config/btop/themes/catppuccin_mocha.theme"
install_file "$REPO_ROOT/config/git/delta.gitconfig" ".config/git/delta.gitconfig"
install_file "$REPO_ROOT/config/zsh/modern-terminal.zsh" ".config/terminal-dotfiles/modern-terminal.zsh"

ensure_line ".zshrc" '[[ -r "$HOME/.config/terminal-dotfiles/modern-terminal.zsh" ]] && source "$HOME/.config/terminal-dotfiles/modern-terminal.zsh"'
ensure_git_include

if [ "$MODE" = apply ]; then
  if [ -n "$BACKUP_ROOT" ]; then
    printf 'Backup: %s\n' "$BACKUP_ROOT"
  fi
  printf 'Installation complete. Run: exec zsh\n'
else
  printf 'No files changed. Re-run with --apply to install.\n'
fi
