# Only switch to zsh for interactive shells
if [[ -n "$PS1" && -x "$(command -v zsh)" ]]; then
  exec zsh
fi
