export XDG_CONFIG_HOME="$HOME/.config"
export TERM=xterm-256color
export PATH=$PATH:"$HOME/.local/bin"

IS_MAC=$(uname -s | grep -q Darwin && echo true || echo false)
IS_LINUX=$(uname -s | grep -q Linux && echo true || echo false)

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

if [[ "$IS_MAC" == true ]]; then
  # Homebrew, needs to be loaded before fzf, oh-my-posh, etc.
  eval "$(/opt/homebrew/bin/brew shellenv)"
fi

# fzf, a fuzzy finder
# Trigger with ctrl+r, needs to be loaded before the plugin for tab completion
if [[ "$IS_MAC" == true ]]; then
  # --zsh is not available < v0.48.0, which is not on apt for Ubuntu yet
  # https://github.com/junegunn/fzf?tab=readme-ov-file#setting-up-shell-integration
  source <(fzf --zsh)
elif [[ "$IS_LINUX" == true ]]; then
  # TODO
  # source /usr/share/fzf/completion.zsh
  # source /usr/share/fzf/key-bindings.zsh
fi

# Add zsh plugins
# More plugins can be found on:
# https://github.com/ohmyzsh/ohmyzsh/wiki/Plugins
zinit light zsh-users/zsh-syntax-highlighting
zinit light zsh-users/zsh-completions
zinit light zsh-users/zsh-autosuggestions
zinit light Aloxaf/fzf-tab # Adds fzf keybindings to tab completion

# Add snippets
zinit snippet OMZP::git # Adds git aliases and functions.
zinit snippet OMZP::aws # Adds AWS aliases and functions.
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

# Go
export GOPRIVATE=github.com/marjorg
# Homebrew manages this for MacOS
if [[ "$IS_LINUX" == true ]]; then
  export PATH=$PATH:/usr/local/go/bin
fi
# For binaries installed with go install
export PATH=$PATH:~/go/bin

# Rust
export PATH="$HOME/.cargo/bin:$PATH"

# Bun
export BUN_INSTALL="$HOME/.bun"
export PATH="$BUN_INSTALL/bin:$PATH"
[ -s "$HOME/.bun/_bun" ] && source "$HOME/.bun/_bun"

# NVM
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion
