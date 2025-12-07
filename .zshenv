# Set ZDOTDIR first
ZDOTDIR="$HOME/.config/zsh"

# Ensure PATH has unique entries (zsh builtin - more efficient than manual checks)
typeset -U PATH

# Build PATH - order matters (first = highest priority)
path=(
    $HOME/.local/bin
    $HOME/bin
    $HOME/.cargo/bin
    $HOME/miniconda3/bin
    $HOME/dev/cryp/bin
    $HOME/bat-extras/bin
    $HOME/.local/share/solana/install/active_release/bin
    /opt/nvim
    /usr/local/go/bin
    /usr/local/bin
    /usr/bin
    $path
)

export JAVA_HOME="/usr/lib/jvm/java-1.21.0-openjdk-amd64"
export PATH

# Source additional env files if they exist
[[ -f "$HOME/.local/bin/env" ]] && . "$HOME/.local/bin/env"
