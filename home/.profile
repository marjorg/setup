export XDG_CONFIG_HOME="$HOME/.config"
export TERM=xterm-256color
export PATH=$PATH:"$HOME/.local/bin"

# Go
export PATH=$PATH:/usr/local/go/bin
# For binaries installed with go install
export PATH=$PATH:"$HOME/go/bin"

# Rust
export PATH="$HOME/.cargo/bin:$PATH"

# Bun
export BUN_INSTALL="$HOME/.cache/.bun"
export PATH="$BUN_INSTALL/bin:$PATH"

# OpenCode reads ~/.agents/skills natively, so the ~/.claude/skills fallback only adds duplicates.
export OPENCODE_DISABLE_CLAUDE_CODE_SKILLS=1
