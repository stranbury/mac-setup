Setup
=====

- Download and install latest version of Xcode from Mac App Store
- Download and install Xcode Command Line Tools
- Set up Git/GitHub:
  - [Set Up Git](https://help.github.com/articles/set-up-git/)
  - [Generating SSH Keys](http://help.github.com/articles/generating-ssh-keys/)

Once those steps are complete, run the following commands:

```shell
sudo chown -R $USER:admin /usr/local /Library/Caches/Homebrew
git clone git@github.com:spartDev/mac-laptop-setup.git ~/.mac-laptop-setup
cd ~/.mac-laptop-setup
rake install
```
