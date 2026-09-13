# ~/.config/zsh/prompt.zsh

# --- zoxide ---

eval "$(zoxide init zsh)"

# --- atuin ---

eval "$(atuin init zsh)"

# --- fuck ---

eval "$(thefuck --alias)"

# --- starship ---

export STARSHIP_CONFIG="$XDG_CONFIG_HOME/starship/starship.toml"
eval "$(starship init zsh)"
