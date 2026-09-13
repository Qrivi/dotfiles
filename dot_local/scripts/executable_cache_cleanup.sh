#!/usr/bin/env zsh

setopt NULL_GLOB

if [[ -z "$XDG_CACHE_HOME" ]]; then
  print -u2 "Error: XDG_CACHE_HOME is not set"
  exit 1
fi

case "$1" in
  "")
    dry_run=false
    ;;
  -n|--dry-run)
    dry_run=true
    ;;
  *)
    print -u2 "Usage: ${0:t} [-n|--dry-run]"
    exit 2
    ;;
esac

remove() {
  (( $# == 0 )) && return

  if $dry_run; then
    printf '🚮: %s\n' "$@"
  else
    rm -rf -- "$@"
  fi
}

# Everything respecting $XDG_CACHE_HOME
remove $XDG_CACHE_HOME/*(D)

# Android SDK cache
remove ~/.android/cache/*(D)

# Atuin logs
remove ~/.atuin/logs/*(D)

# AWS & Kiro cache
remove ~/.aws/cli/cache/*(D)
remove ~/.aws/sso/*(D)

# Azure logs
remove ~/.azure/logs/*(D)

# Bun package manager cache
remove ~/.bun/install/cache/*(D)

# Ruby Bundler cache
remove ~/.bundle/cache/*(D)

# Rust Cargo cache
remove ~/.cargo/registry/*(D)

# Unwanted garbage
remove ~/.clickshare_button

# JetBrains AI/Chatter logs
remove ~/.config/chatter/logs/*(D)

# Copilot logs
remove ~/.config/copilot/logs/*(D)

# Generated project data
for dir in node_modules .gradle .dart_tool .next .angular .DerivedData .turbo .astro .output .pnpm-store; do
  find ~/Developer -xdev -type d -name "$dir" -prune -print0 |
    while IFS= read -r -d $'\0' matched_path; do
        remove "$matched_path"
    done
done
