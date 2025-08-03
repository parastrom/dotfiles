# Load cargo environment
[ -f "$HOME/.cargo/env" ] && source "$HOME/.cargo/env"

# Set ZDOTDIR
ZDOTDIR="$HOME/.config/zsh"

# Conda initialization
__conda_setup="$('$HOME/miniconda3/bin/conda' 'shell.zsh' 'hook' 2> /dev/null)"
if [ $? -eq 0 ]; then
    eval "$__conda_setup"
else
    if [ -f "$HOME/miniconda3/etc/profile.d/conda.sh" ]; then
        . "$HOME/miniconda3/etc/profile.d/conda.sh"
    fi
fi
unset __conda_setup

# Define add_to_path function
add_to_path() {
    if [ -d "$1" ] && [[ ":$PATH:" != *":$1:"* ]]; then
        PATH="$1:$PATH"
    fi
}

# Ensure PATH has unique entries
typeset -U PATH

# Add directories to PATH
add_to_path "/opt/nvim/nvim"
add_to_path "/usr/bin"
add_to_path "/usr/local/bin"
add_to_path "$HOME/bin"
add_to_path "/usr/local/go/bin"
add_to_path "$HOME/miniconda3/bin"
add_to_path "/opt/nvim"
add_to_path "/usr/local/go/bin"
add_to_path "$HOME/dev/cryp/bin"
add_to_path "$HOME/bat-extras/bin"
add_to_path "$HOME/.local/bin"
add_to_path "$HOME/.local/share/solana/install/active_release/bin"
add_to_path "usr/bin/pg_config"


JAVA_HOME="/usr/lib/jvm/java-1.21.0-openjdk-amd64"

# Export the updated PATH
export PATH

. "$HOME/.local/bin/env"
