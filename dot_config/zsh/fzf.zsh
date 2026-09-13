# ~/.config/zsh/fzf.zsh
#
# Ctrl-T   files/directories → insert into command line
# Meta-C   fuzzy directory search → cd

# --- Commands ---

if command -v fd >/dev/null 2>&1; then # macOS
  FZF_FD='fd'
elif command -v fdfind >/dev/null 2>&1; then # Ubuntu
  FZF_FD='fdfind'
fi

if command -v bat >/dev/null 2>&1; then # macOS
  FZF_BAT='bat'
elif command -v batcat >/dev/null 2>&1; then # Ubuntu
  FZF_BAT='batcat'
fi

# --- Search ---

# use fd/fdfind, include hidden items, strip cwd prefix
if [[ -n "$FZF_FD" ]]; then
  export FZF_DEFAULT_COMMAND="$FZF_FD --hidden --strip-cwd-prefix | sort"
  export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
fi

# --- Preview ---

# Render a preview with eza for folders and bat for files
export FZF_CTRL_T_OPTS="
  --no-sort --preview '
    if [[ -d {} ]]; then
      eza -ahl --icons --git {}
    elif [[ -n \"$FZF_BAT\" ]]; then
      $FZF_BAT --color=always --style=plain,numbers --line-range=:500 {}
    fi
  '
"

# --- UI ---

export FZF_DEFAULT_OPTS='
  --height=60%
  --layout=reverse
  --border=rounded
  --prompt="  "
  --pointer="  "
  --preview-window=right:65%:wrap:border-left
'

eval "$(fzf --zsh)"
