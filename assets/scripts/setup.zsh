#!/usr/bin/env zsh

set -euo pipefail

# I will add support for Linux once I main a Linux in the future.
if [[ "$(uname -s)" != "Darwin" ]]; then
  print -u2 "This bootstrap currently supports macOS only."
  exit 1
fi

echo "You're about to setup your machine with @Qrivi's config and dotfiles."
echo
echo "For the setup to go smoothly:"
echo "- Make sure you're signed in to iCloud and the Mac App Store."
echo "- Give this terminal app Full Disk Access in System Settings > Privacy & Security."
echo "- Keep your chezmoi age-key passphrase nearby. A new Mac asks for it once."

printf '\nContinue? [Y/n] '
if ! read -r reply </dev/tty; then
  print -u2 "Unable to read your response."
  exit 1
fi

case "${reply:l}" in
  ''|y|yes) ;;
  *)
    echo "Bye!"
    exit 1
    ;;
esac

# Install Apple's command-line developer tools.
if xcode-select -p &> /dev/null; then
  echo "Xcode command line tools are already installed."
else
  printf '\n==> Installing Xcode command line tools...\n'
  xcode-select --install &> /dev/null || true

  integer attempts=0
  while ! xcode-select -p &> /dev/null; do
    (( ++attempts ))
    if (( attempts >= 360 )); then
      print -u2 "Timed out waiting for the Xcode command line tools after 30 minutes."
      exit 1
    fi
    sleep 5
  done
  echo "Xcode command line tools installed successfully."
fi

# Install Homebrew and load it into the current shell.
if command -v brew >/dev/null 2>&1; then
  echo "Homebrew is already installed."
else
  printf '\n==> Installing Homebrew...\n'
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
  echo "Homebrew installed successfully."
fi

if [[ -x /opt/homebrew/bin/brew ]]; then
  eval "$(/opt/homebrew/bin/brew shellenv)"
elif [[ -x /usr/local/bin/brew ]]; then
  eval "$(/usr/local/bin/brew shellenv)"
fi

# Install the tools required to initialize and decrypt the dotfiles.
if command -v chezmoi >/dev/null 2>&1 && command -v age >/dev/null 2>&1; then
  echo "Chezmoi and age are already installed."
else
  printf '\n==> Installing Chezmoi and age...\n'
  brew install chezmoi age
  echo "Chezmoi and age installed successfully."
fi

# Initialize a new source directory, or update an existing one.
if [ -d "$HOME/.local/share/chezmoi/.git" ]; then
  printf '\n==> Chezmoi is already initialized; pulling and applying the latest changes...\n'
  chezmoi init
  chezmoi update
  echo "Chezmoi updated successfully."
else
  printf '\n==> Initializing and applying the dotfiles...\n'
  chezmoi init --apply https://github.com/qrivi/dotfiles.git
  echo "Chezmoi initialized successfully."
fi
