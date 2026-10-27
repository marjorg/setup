# Dotfiles & Setup

<!-- 1. Install Omarchy -->
<!-- 2. Connect to WiFi -->
<!-- 3. Update Omarchy -->
<!-- 4. Restart -->
<!-- 5. Remove preinstalls -->
<!-- 6. Remove dev envs -->
<!-- 7. Install -->
<!-- 8. Files -->
<!-- 9. Restart -->

`/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/marjorg/setup/main/setup.sh)"`

## Ubuntu

Only the file setup runs on Ubuntu. `install.sh` and `files.sh` are Omarchy-only. Install the prerequisites by hand first. `gomplate` isn't in Ubuntu's archive, so get the static binary from its [releases](https://github.com/hairyhenderson/gomplate/releases) and put it on `PATH`.

```sh
sudo apt-get install -y git gnupg openssh-client wl-clipboard
```

Run the bootstrap above, then the file-setup scripts in this order:

```sh
cd ~/dotfiles
./scripts/generate-ssh-key.sh
./scripts/generate-gpg-key.sh
./scripts/write-ssh-config.sh
./scripts/write-git-config.sh
./scripts/set-symlinks.sh
```

Pass `--name` and `--email` to the first one if you don't want to be prompted. `./scripts/copy-ssh-key.sh` and `./scripts/copy-gpg-key.sh` put the public keys on the clipboard for GitHub.
