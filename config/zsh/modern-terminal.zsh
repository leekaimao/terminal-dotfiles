# Safe, reusable terminal enhancements. Keep credentials in a separate local file.
export EDITOR="nvim"
export VISUAL="$EDITOR"

command -v zoxide >/dev/null && eval "$(zoxide init zsh)"
command -v fzf >/dev/null && source <(fzf --zsh)

export FZF_DEFAULT_COMMAND='fd --hidden --follow --type f --exclude .git'
export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
export FZF_ALT_C_COMMAND='fd --hidden --follow --type d --exclude .git'
export FZF_DEFAULT_OPTS='--height 45% --layout=reverse --border=rounded --info=inline --prompt="❯ " --pointer="◆" --marker="✓" --color=fg:#CDD6F4,bg:#1E1E2E,hl:#F38BA8,fg+:#CDD6F4,bg+:#313244,hl+:#F38BA8,info:#CBA6F7,prompt:#89B4FA,pointer:#F5E0DC,marker:#A6E3A1,spinner:#F5E0DC,header:#94E2D5,border:#6C7086'
export FZF_CTRL_T_OPTS="--preview 'bat --color=always --line-range :500 {}' --preview-window 'right,60%,border-left'"
export FZF_ALT_C_OPTS="--preview 'eza --tree --color=always --icons=always --level=2 {} | head -200' --preview-window 'right,60%,border-left'"

export BAT_THEME='Catppuccin Mocha'
command -v atuin >/dev/null && eval "$(atuin init zsh --disable-up-arrow --disable-ai)"

if command -v eza >/dev/null; then
  alias ls='eza --icons=auto --group-directories-first'
  alias ll='eza -lah --icons=auto --group-directories-first --git'
  alias la='eza -a --icons=auto --group-directories-first'
  alias tree='eza --tree --icons=auto --group-directories-first'
fi

if command -v bat >/dev/null; then
  alias preview='bat --paging=never'
fi

y() {
  local yazi_tmp yazi_cwd
  yazi_tmp="$(mktemp -t 'yazi-cwd.XXXXXX')"
  command yazi "$@" --cwd-file="$yazi_tmp"
  IFS= read -r -d '' yazi_cwd < "$yazi_tmp"
  [[ -n "$yazi_cwd" && "$yazi_cwd" != "$PWD" && -d "$yazi_cwd" ]] && builtin cd -- "$yazi_cwd"
  command rm -f -- "$yazi_tmp"
}

command -v lazygit >/dev/null && alias lg='lazygit'
command -v fastfetch >/dev/null && alias ff='fastfetch'

mdview() {
  if (( $# != 1 )); then
    print -u2 'usage: mdview <markdown-file>'
    return 2
  fi
  cmux markdown open "$1"
}

# Optional machine-local values. This file is intentionally ignored by Git.
[[ -r "$HOME/.config/terminal-dotfiles/local.zsh" ]] && source "$HOME/.config/terminal-dotfiles/local.zsh"
