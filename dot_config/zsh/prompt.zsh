# ~/.config/zsh/prompt.zsh

# --- zoxide ---

eval "$(zoxide init zsh)"

# --- atuin ---

eval "$(atuin init zsh)"

if ! atuin key >/dev/null 2>&1; then
  print -P "%F{yellow}⚠ Atuin is not logged in — history is not syncing.%f"
fi

# --- fuck ---

eval "$(thefuck --alias)"

# --- starship ---

export STARSHIP_CONFIG="$XDG_CONFIG_HOME/starship/starship.toml"
eval "$(starship init zsh)"
