# ~/.config/zsh/aliases.zsh

# --- Navigating ---

alias -- -='cd -'
alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'
alias .....='cd ../../../..'

alias cdc='cd ~/Developer'
alias j='z'

if command -v batcat >/dev/null 2>&1; then # Ubuntu
  alias bat='batcat --paging=never'
  alias plainbat='batcat --paging=never --style=plain'
else
  alias bat='bat --paging=never'
  alias plainbat='bat --paging=never --style=plain'
fi

alias h='history -E'

alias ls='eza --icons=always'
alias ll='eza -ahl --time-style=long-iso --icons=always --git'
compdef eza=ls

# --- Tools ---

alias brewstart='brew update; brew upgrade; brew autoremove; echo; brew cleanup; killall BetterTouchTool; sleep 2; open -a BetterTouchTool'

alias diff='diff --color=auto'
alias df='df -h'
alias tree='eza --tree --icons --git'
alias pong='ping -c 5'

# --- Git ---

alias gs='git status -sb'
alias gd='git diff'
alias ga='git add'
alias gc='git commit'
alias gp='git push'
alias gu='git pull'
alias gi='git init'
alias gcl='git clone'
alias gl='git log --all --graph --pretty=format:'\''%C(magenta)%h %C(white) %an  %ar%C(auto) %D%n%s%n'\'''

alias gsh='git-shift-hours' # this one lives in .local/bin

# --- Docker ---

alias dps='docker ps --format '\''table {{.ID}}\t{{.Names}}\t{{.Image}}\t{{.Status}}'\'''
alias dcu='docker compose up'
alias dcd='docker compose down'
alias dcre='docker compose restart'
alias dce='docker compose exec'
alias dcud='docker compose up -d'
alias dsa='docker ps -aq | xargs docker stop'
alias dvpa='docker volume prune --all'
alias dspa='countdown 5; dspaf'
alias dspaf='dcd; echo && dvpa; echo && docker system prune -af'

# --- Helpers ---

if [[ "$OSTYPE" == darwin* ]]; then
  alias openthegate='sudo spctl --master-disable'
  alias unquarantine='sudo xattr -rd com.apple.quarantine' # /path/to.app

  alias flushdns='dscacheutil -flushcache; sudo killall -HUP mDNSResponder'

  alias killusb='sudo killall -STOP -c usbd'
  alias killbluetooth='sudo pkill bluetoothd'
  alias togglewifi='networksetup -setairportpower en0 off; sleep 1; networksetup -setairportpower en0 on'
fi

# --- Apps ---

if [[ "$OSTYPE" == darwin* ]]; then
  alias calc='numi-cli'
fi
