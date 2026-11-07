# Local configuration

Personal configuration belongs under `~/.config/mac-setup/`, not in this repository.

Use `bash setup.sh --capture-local` to snapshot safe existing dotfiles, then review the
capture manually. Use `bash setup.sh --integrate` to add managed hooks without replacing
existing Bash or Zsh startup files.

Put workstation-specific exports and aliases in `~/.config/mac-setup/local.sh` and local
Homebrew packages in `~/.config/mac-setup/local/packages.txt`. Do not store credentials,
tokens, private keys, or secrets in either location.
