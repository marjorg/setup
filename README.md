# Dotfiles & Setup

1. [Mac Only] Log with Apple ID to enable installation of Mac App Store apps via CLI.
2. Execute this command: `/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/marjorg/setup/main/install.sh)"`

## Ansible Vault

- Edit vault: `ansible-vault edit vars/name.yml`
- View vault: `ansible-vault view vars/name.yml`
- Create vault with id: `ansible-vault create --vault-id=id@prompt vars/name.yml`
- With specific editor: `EDITOR="code --wait" *command*`

<!-- https://docs.github.com/en/authentication/connecting-to-github-with-ssh/generating-a-new-ssh-key-and-adding-it-to-the-ssh-agent -->
<!-- https://docs.github.com/en/authentication/managing-commit-signature-verification/generating-a-new-gpg-key -->
