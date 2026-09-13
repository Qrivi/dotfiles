#!/usr/bin/env zsh

if [[ -t 1 ]]; then
  readonly BLUE='\033[1;34m'
  readonly GREEN='\033[1;32m'
  readonly YELLOW='\033[1;33m'
  readonly RESET='\033[0m'
else
  readonly BLUE=''
  readonly GREEN=''
  readonly YELLOW=''
  readonly RESET=''
fi

step() { printf "\n%b==>%b %s\n" "$BLUE" "$RESET" "$1"; }
success() { printf "%b✓%b %s\n" "$GREEN" "$RESET" "$1"; }
info() { printf "%b→%b %s\n" "$YELLOW" "$RESET" "$1"; }
warning() { printf "%b⚠%b %s\n" "$YELLOW" "$RESET" "$1"; }
