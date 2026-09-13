# ~/.config/zsh/plugins.zsh

ZPLUGINDIR="$XDG_DATA_HOME/zsh/plugins"

_zplugin_load() {
  local plugin_path="$ZPLUGINDIR/${2}"
  if [[ ! -d "$plugin_path" ]]; then
    mkdir -p "$ZPLUGINDIR"
    printf "\nInstalling ${2}...\n"
    git clone --depth=1 "https://github.com/${1}/${2}" "$plugin_path" \
      || { echo "ERROR: failed to install ${2}" >&2; return 1; }
  fi
  source "${plugin_path}/${2}.plugin.zsh"
}

_zplugin_maybe_update() {
  local stamp="$XDG_STATE_HOME/zsh/plugins-update-check"
  local now="$(date +%s)"
  local interval=$((30 * 24 * 60 * 60))

  if [[ ! -f "$stamp" ]] || (( now - $(<"$stamp") >= interval )); then
    printf 'Zsh plugins have not been checked for updates in 30 days. Update now? [y/N] '

    if read -q; then
      print
      zplugin-update
    else
      print
    fi

    mkdir -p "${stamp:h}"
    print "$now" > "$stamp"
  fi
}

zplugin-update() {
  local dir
  for dir in "${ZPLUGINDIR}"/*/; do
    printf "\nUpdating ${dir:t}...\n"
    git -C "$dir" pull --ff-only
  done
}

_zplugin_load zsh-users zsh-autosuggestions
_zplugin_load zdharma-continuum fast-syntax-highlighting

[[ -t 0 ]] && _zplugin_maybe_update
