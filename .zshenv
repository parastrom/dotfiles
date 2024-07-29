. "$HOME/.cargo/env"
ZDOTDIR="$HOME/.config/zsh"
export DEBUGINFOD_URLS="https://debuginfod.archlinux.org"

# >>> conda initialize >>>
# !! Contents within this block are managed by 'conda init' !!
__conda_setup="$('$HOME/anaconda3/bin/conda' 'shell.bash' 'hook' 2> /dev/null)"
if [ $? -eq 0 ]; then
    eval "$__conda_setup"
else
    if [ -f "$HOME/anaconda3/etc/profile.d/conda.sh" ]; then
        . "$HOME/anaconda3/etc/profile.d/conda.sh"
    else
        export PATH="$HOME/anaconda3/bin:$PATH"
    fi
fi
unset __conda_setup
# <<< conda initialise <<<
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion
<<<<<<< HEAD

export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:/usr/local/cuda-12.1/lib64
export PATH="$HOME/.local/share/solana/install/active_release/bin:$PATH"
export PATH="$PATH:$HOME/.foundry/bin"
export PATH="$HOME/.avm/bin:$PATH"
=======
add_to_path "/usr/local/go/bin"
add_to_path "$HOME/bin"
add_to_path "/usr/local/bin"
add_to_path "/usr/bin"
add_to_path "/opt/nvim/nvim"
>>>>>>> 6835d38 (work changes)
