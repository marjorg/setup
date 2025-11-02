export XDG_CONFIG_HOME="$HOME/.config"
export TERM=xterm-256color
export PATH=$PATH:"$HOME/.local/bin"

# Go
export GOPRIVATE=github.com/marjorg
export PATH=$PATH:/usr/local/go/bin
# For binaries installed with go install
export PATH=$PATH:"$HOME/go/bin"

# Rust
export PATH="$HOME/.cargo/bin:$PATH"

# Bun
export BUN_INSTALL="$HOME/.bun"
export PATH="$BUN_INSTALL/bin:$PATH"
[ -s "$HOME/.bun/_bun" ] && source "$HOME/.bun/_bun"

# NVM
if [ -d "$HOME/.config/nvm" ]; then
  export NVM_DIR="$HOME/.config/nvm"
  [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
  [ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion
fi
