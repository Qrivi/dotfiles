# dotfiles

Personal macOS configuration managed with [chezmoi](https://www.chezmoi.io/).
It installs command-line tools and applications with Homebrew and the Mac App
Store, applies macOS defaults, configures the Dock, and restores encrypted files
with age.

## Install a new Mac

Before starting:

- Sign in to iCloud and the Mac App Store.
- Give the terminal Full Disk Access in **System Settings → Privacy & Security**.
- Have the age recovery passphrase available.

Run the bootstrap:

```zsh
zsh -c "$(curl -fsSL https://raw.githubusercontent.com/qrivi/dotfiles/main/assets/scripts/setup.zsh)"
```

The bootstrap installs the Xcode command-line tools, Homebrew, age, and
chezmoi. Chezmoi then asks for a machine profile and applies the repository.

Available profiles:

- `macos-base`: shared shell tools and desktop applications.
- `macos-work`: everything in `macos-base`, plus development and work tools.

The App Store step installs Xcode and other apps already acquired with the
signed-in Apple Account. Color Picker, CrystalFetch, the Microsoft apps,
OneDrive, and Sim Daltonism are limited to `macos-work`. It installs `mas`
temporarily and removes it afterwards if it was not already present. Duolingo
and the custom ntfy web app remain manual installs; the Dock includes them
when present.

## Encryption

The age identity is stored in the repository as `key.txt.age`, encrypted with a
recovery passphrase. On the first apply, it is decrypted to
`~/.config/chezmoi/key.txt` with mode `0600`. Later chezmoi operations use that
identity without asking for the recovery passphrase again.

Files with the `encrypted_` source attribute are ciphertext in Git and are
decrypted only when chezmoi builds the target state. The additional `private_`
attribute restricts the target file to the current user.

Keep the recovery passphrase somewhere independent of this repository. Losing
both the decrypted identity and that passphrase makes the encrypted files
unrecoverable.

## GnuPG key maintenance

Chezmoi manages the GnuPG configuration, age-encrypted secret-key and
ownertrust exports, and age-encrypted revocation certificates. On a new Mac,
the `run_onchange_after_05-import-gnupg-keys.zsh.tmpl` script imports the key
exports after GPG Suite has been installed.

After creating a new GPG key, first find its full primary-key fingerprint:

```zsh
gpg --list-secret-keys --with-subkey-fingerprints
```

GPG normally creates a certificate in `~/.gnupg/openpgp-revocs.d` at the same
time as the key. If it is missing, create one using the full fingerprint:

```zsh
gpg --output ~/.gnupg/openpgp-revocs.d/FINGERPRINT.rev \
  --generate-revocation FINGERPRINT
chmod 600 ~/.gnupg/openpgp-revocs.d/FINGERPRINT.rev
```

Choose reason `0` (no reason specified) and leave the optional description
blank. Creating this certificate does not revoke the key; it is an emergency
recovery artifact that must remain private.

Add the certificate to chezmoi with age encryption:

```zsh
chezmoi add --encrypt ~/.gnupg/openpgp-revocs.d/FINGERPRINT.rev
```

Then open the source repository and refresh both encrypted exports directly,
without writing plaintext exports to disk:

```zsh
chezmoi cd
gpg --batch --armor --export-secret-keys \
  | chezmoi encrypt --output=assets/gnupg/secret-keys.asc.age
gpg --batch --export-ownertrust \
  | chezmoi encrypt --output=assets/gnupg/ownertrust.txt.age
exit
```

Refresh the secret-key export in the same way after changing a key passphrase
or revoking a key. A passphrase change does not alter the fingerprint or public
key, but the encrypted export otherwise retains the old passphrase. A revoked
key is deliberately kept in the export because it may still be required to
decrypt historical data or verify old signatures.

## Normal workflow

Preview local changes:

```zsh
chezmoi diff
```

Apply source-state changes:

```zsh
chezmoi apply
```

Pull and apply changes from the remote:

```zsh
chezmoi update
```

Open the source repository:

```zsh
chezmoi cd
```

## Managed locations

```text
$HOME
├── .ai                 Global AI configuration for IntelliJ
├── .config             XDG application and shell configuration
├── .docker             Docker client configuration
├── .gnupg              GnuPG configuration, keys, trust, and recovery data
├── .ssh                SSH configuration and encrypted private keys
└── .zshenv             Entry point for the XDG-based Zsh configuration
```
