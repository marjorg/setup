
source "${HOME}/.profile"

### Added by Zinit's installer
if [[ ! -f $HOME/.local/share/zinit/zinit.git/zinit.zsh ]]; then
  print -P "%F{33} %F{220}Installing %F{33}ZDHARMA-CONTINUUM%F{220} Initiative Plugin Manager (%F{33}zdharma-continuum/zinit%F{220})…%f"
  command mkdir -p "$HOME/.local/share/zinit" && command chmod g-rwX "$HOME/.local/share/zinit"
  command git clone https://github.com/zdharma-continuum/zinit "$HOME/.local/share/zinit/zinit.git" && \
    print -P "%F{33} %F{34}Installation successful.%f%b" || \
    print -P "%F{160} The clone has failed.%f%b"
fi

source "$HOME/.local/share/zinit/zinit.git/zinit.zsh"
autoload -Uz _zinit
(( ${+_comps} )) && _comps[zinit]=_zinit

# fzf, a fuzzy finder
# Trigger with ctrl+r, needs to be loaded before the plugin for tab completion
  # --zsh is not available < v0.48.0, which is not on apt for Ubuntu yet
  # https://github.com/junegunn/fzf?tab=readme-ov-file#setting-up-shell-integration
#  source <(fzf --zsh)
  # TODO
  # source /usr/share/fzf/completion.zsh
  # source /usr/share/fzf/key-bindings.zsh

# Add zsh plugins
# More plugins can be found on:
# https://github.com/ohmyzsh/ohmyzsh/wiki/Plugins
zinit light zsh-users/zsh-syntax-highlighting
zinit light zsh-users/zsh-completions
zinit light zsh-users/zsh-autosuggestions
zinit light Aloxaf/fzf-tab # Adds fzf keybindings to tab completion

# Add snippets
zinit snippet OMZP::git # Adds git aliases and functions.
zinit snippet OMZP::sudo # Run current or previous command with sudo by pressing `esc` twice.
zinit snippet OMZP::command-not-found # Suggests packages for unknown commands.

# Load zsh-completions
autoload -U compinit && compinit

zinit cdreplay -q # Restoring the state of the working directories from the last session.

# Configure zsh-completions
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Za-z}' # Case-insensitive completion
zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}" # List colors
zstyle ':completion:*' menu no
zstyle ':fzf-tab:complete:cd:*' fzf-preview 'ls --color $realpath'

# Don't run oh-my-posh in Apple Terminal, as it is not supported
if [ "$TERM_PROGRAM" != "Apple_Terminal" ]; then
  eval "$(oh-my-posh init zsh --config $HOME/.config/ohmyposh/config.json)"
fi

# Keybindings
bindkey '^f' autosuggest-accept # Use auto suggestion with ctrl+f
bindkey '^[[1;5A' history-search-backward # Use ctrl+arrow-up to search history backward
bindkey '^[[1;5B' history-search-forward # Use ctrl+arrow-down to search history forward
bindkey "^[[1;3D" backward-word # Use Option + Left Arrow to move back a word
bindkey "^[[1;3C" forward-word # Use Option + Right Arrow to move forward a word

# Aliases
alias lg='lazygit'
alias ld='lazydocker'
alias vim='nvim'

# History
HISTSIZE=5000
SAVEHIST=5000 # Need to be same as HISTSIZE
HISTFILE=~/.zsh_history
HISTDUP=erase # Delete duplicates
setopt appendhistory # Append history instead of overwrite
setopt sharehistory # Share history across sessions
setopt hist_ignore_space # Ignore commands starting with space, useful for secrets
setopt hist_ignore_all_dups # Ignore all duplicates
setopt hist_save_no_dups # Do not save duplicates
setopt hist_ignore_dups # Ignore duplicates in history

# zoxide, smarter cd command
eval "$(zoxide init --cmd cd zsh)"
