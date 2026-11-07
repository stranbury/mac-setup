# mac-setup

Portable Unix configuration with an optional macOS layer and private local overlay.

- Download and install latest version of Xcode from Mac App Store
- Download and install Xcode Command Line Tools
- Set up Git/GitHub:
  - [Set Up Git](https://help.github.com/articles/set-up-git/)
  - [Generating SSH Keys](http://help.github.com/articles/generating-ssh-keys/)

After cloning, run the portable setup first:

```shell
git clone https://github.com/stranbury/mac-setup.git ~/.mac-setup
cd ~/.mac-setup
bash setup.sh --capture-local
bash setup.sh --unix
bash setup.sh --integrate
```

The local capture is written to `~/.config/mac-setup/captured` and is never added to
this repository. Existing Bash and Zsh startup files remain authoritative; integration
adds a marked hook and creates a one-time `.mac-setup-backup` copy before editing.

For workstation-only Homebrew packages, copy `local/packages.txt.example` to
`~/.config/mac-setup/local/packages.txt` and run `bash setup.sh --local-packages`.

The legacy interactive installer remains available with `rake install`. The new
`--install` command runs the Unix layer and macOS package installers, but does not
apply the destructive settings in `setup/osx` automatically.

Run the portable smoke tests with:

```shell
bash tests/smoke.sh
```
