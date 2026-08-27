#!/bin/sh
set -eu

TARGET_HOME=${HOME:?HOME is not set}
SKIP_TOOLS=false
REPO_ROOT=$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)

usage() {
  cat <<'EOF'
Usage: ./doctor.sh [--home ABSOLUTE_PATH] [--skip-tools]

Checks installed files, Zsh syntax, required tools, and common secret formats.
EOF
}

while [ "$#" -gt 0 ]; do
  case "$1" in
    --home)
      shift
      [ "$#" -gt 0 ] || { printf 'Missing value for --home\n' >&2; exit 2; }
      TARGET_HOME=$1
      ;;
    --skip-tools) SKIP_TOOLS=true ;;
    -h|--help) usage; exit 0 ;;
    *) printf 'Unknown option: %s\n' "$1" >&2; usage >&2; exit 2 ;;
  esac
  shift
done

case "$TARGET_HOME" in
  /*) ;;
  *) printf -- '--home must be an absolute path: %s\n' "$TARGET_HOME" >&2; exit 2 ;;
esac

status=0

check_file() {
  if [ -f "$TARGET_HOME/$1" ]; then
    printf 'OK      %s\n' "$1"
  else
    printf 'MISSING %s\n' "$1" >&2
    status=1
  fi
}

for relative_path in \
  ".config/cmux/cmux.json" \
  ".config/ghostty/config" \
  ".p10k.zsh" \
  ".config/atuin/config.toml" \
  ".config/yazi/yazi.toml" \
  ".config/yazi/theme.toml" \
  ".config/yazi/package.toml" \
  "Library/Application Support/lazygit/config.yml" \
  ".config/btop/btop.conf" \
  ".config/btop/themes/catppuccin_mocha.theme" \
  ".config/git/delta.gitconfig" \
  ".config/terminal-dotfiles/modern-terminal.zsh" \
  ".zshrc" \
  ".gitconfig"
do
  check_file "$relative_path"
done

if command -v zsh >/dev/null 2>&1; then
  zsh -n "$TARGET_HOME/.p10k.zsh" || status=1
  zsh -n "$TARGET_HOME/.config/terminal-dotfiles/modern-terminal.zsh" || status=1
else
  printf 'MISSING zsh; syntax checks skipped\n' >&2
  status=1
fi

if [ "$SKIP_TOOLS" = false ]; then
  for tool in cmux fzf zoxide eza bat fd rg delta yazi btop lazygit atuin; do
    if command -v "$tool" >/dev/null 2>&1; then
      printf 'OK      command %s\n' "$tool"
    else
      printf 'MISSING command %s\n' "$tool" >&2
      status=1
    fi
  done
fi

if command -v rg >/dev/null 2>&1; then
  secret_files=$(rg -l '(AKIA[0-9A-Z]{16}|LTAI[A-Za-z0-9]{12,}|sk-[A-Za-z0-9_-]{20,}|gh[pousr]_[A-Za-z0-9]{20,}|Bearer[[:space:]]+[A-Za-z0-9._-]{16,})' "$REPO_ROOT/config" "$REPO_ROOT/Brewfile" 2>/dev/null || true)
  if [ -n "$secret_files" ]; then
    printf 'Potential secret formats found in:\n%s\n' "$secret_files" >&2
    status=1
  else
    printf 'OK      no common secret formats in tracked configuration\n'
  fi
fi

if [ "$status" -eq 0 ]; then
  printf 'Configuration check passed.\n'
else
  printf 'Configuration check failed.\n' >&2
fi

exit "$status"
