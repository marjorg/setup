export XDG_CONFIG_HOME="$HOME/.config"

# Install Zinit if it is not installed
if [[ ! -f $HOME/.local/share/zinit/zinit.git/zinit.zsh ]]; then
    print -P "%F{33} %F{220}Installing %F{33}ZDHARMA-CONTINUUM%F{220} Initiative Plugin Manager (%F{33}zdharma-continuum/zinit%F{220})…%f"
    command mkdir -p "$HOME/.local/share/zinit" && command chmod g-rwX "$HOME/.local/share/zinit"
    command git clone https://github.com/zdharma-continuum/zinit "$HOME/.local/share/zinit/zinit.git" && \
        print -P "%F{33} %F{34}Installation successful.%f%b" || \
        print -P "%F{160} The clone has failed.%f%b"
fi

# Homebrew, needs to be loaded before fzf, oh-my-posh, etc.
eval "$(/opt/homebrew/bin/brew shellenv)"

# Initialize Zinit
source "$HOME/.local/share/zinit/zinit.git/zinit.zsh"
autoload -Uz _zinit
(( ${+_comps} )) && _comps[zinit]=_zinit

# fzf, a fuzzy finder
source <(fzf --zsh) # Trigger with ctrl+r, needs to be loaded before the plugin for tab completion

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

export TERM=xterm-256color

# Keybindings
bindkey '^f' autosuggest-accept # Use auto suggestion with ctrl+f (Also try out emacs mode with bindkey -e instead)
bindkey '^[[1;5A' history-search-backward # Use ctrl+arrow-up to search history backward
bindkey '^[[1;5B' history-search-forward # Use ctrl+arrow-down to search history forward
bindkey "^[[1;3D" backward-word # Use Option + Left Arrow to move back a word
bindkey "^[[1;3C" forward-word # Use Option + Right Arrow to move forward a word

# Aliases
alias ld='lazydocker'
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

# CocoaPods
export LANG=en_US.UTF-8

# NVM
export NVM_DIR="$HOME/.nvm"
[ -s "/opt/homebrew/opt/nvm/nvm.sh" ] && \. "/opt/homebrew/opt/nvm/nvm.sh"  # This loads nvm
[ -s "/opt/homebrew/opt/nvm/etc/bash_completion.d/nvm" ] && \. "/opt/homebrew/opt/nvm/etc/bash_completion.d/nvm"  # This loads nvm bash_completion


# PNPM
export PNPM_HOME="/Users/marius/Library/pnpm"
case ":$PATH:" in
  *":$PNPM_HOME:"*) ;;
  *) export PATH="$PNPM_HOME:$PATH" ;;
esac

# Android & Java
export JAVA_HOME="/opt/homebrew/opt/openjdk"
export PATH="$JAVA_HOME/bin:$PATH"
export CPPFLAGS="-I$JAVA_HOME/include"

export ANDROID_SDK_ROOT=/Users/marius/Library/Android/sdk
export ANDROID_HOME=$ANDROID_SDK_ROOT
export PATH=$PATH:$ANDROID_HOME/emulator
export PATH=$PATH:$ANDROID_HOME/tools
export PATH=$PATH:$ANDROID_HOME/tools/bin
export PATH=$PATH:$ANDROID_HOME/platform-tools
export PATH=$PATH:$ANDROID_SDK_ROOT/cmdline-tools/latest/bin

# Python
export PATH="$PATH:$HOME/Library/Python/3.9/bin"

# Go
export PATH=$PATH:$HOME/go/bin
export PATH="$PATH:$HOME/.local/bin:$(go env GOPATH)/bin"
export GOPRIVATE=github.com/marjorg

# Ngrok
if command -v ngrok &>/dev/null; then
  eval "$(ngrok completion)"
fi

# Deno
# Add deno completions to search path
if [[ ":$FPATH:" != *":/Users/marius/.zsh/completions:"* ]]; then export FPATH="/Users/marius/.zsh/completions:$FPATH"; fi
