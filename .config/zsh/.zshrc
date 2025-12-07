# History
HISTSIZE=50000
SAVEHIST=50000
HISTFILE=~/.cache/zsh/history
setopt EXTENDED_HISTORY HIST_REDUCE_BLANKS SHARE_HISTORY HIST_IGNORE_ALL_DUPS

# Completion (cached - only regenerate once per day)
autoload -Uz compinit
zstyle ':completion:*' menu select
zmodload zsh/complist
if [[ -n ~/.cache/zsh/zcompdump(#qN.mh+24) ]]; then
    compinit -d ~/.cache/zsh/zcompdump
else
    compinit -C -d ~/.cache/zsh/zcompdump
fi
_comp_options+=(globdots)

# vi mode
bindkey -v
export KEYTIMEOUT=1

# Change cursor shape for different vi modes.
function zle-keymap-select {
  if [[ ${KEYMAP} == vicmd ]] ||
     [[ $1 = 'block' ]]; then
    echo -ne '\e[1 q'
  elif [[ ${KEYMAP} == main ]] ||
       [[ ${KEYMAP} == viins ]] ||
       [[ ${KEYMAP} = '' ]] ||
       [[ $1 = 'beam' ]]; then
    echo -ne '\e[5 q'
  fi
}
zle -N zle-keymap-select
zle-line-init() {
    zle -K viins # initiate `vi insert` as keymap (can be removed if `bindkey -V` has been set elsewhere)
    echo -ne "\e[5 q"
}
zle -N zle-line-init
echo -ne '\e[5 q' # Use beam shape cursor on startup.
preexec() { echo -ne '\e[5 q' ;} # Use beam shape cursor for each new prompt.

# Use lf to switch directories and bind it to ctrl-o
lfcd () {
    tmp="$(mktemp)"
    lf -last-dir-path="$tmp" "$@"
    if [ -f "$tmp" ]; then
        dir="$(cat "$tmp")"
        rm -f "$tmp"
        [ -d "$dir" ] && [ "$dir" != "$(pwd)" ] && cd "$dir"
    fi
}

bindkey -s '^o' 'lfcd\n'

# Key binding for fzf history search
fzf-history-widget() {
  local selected
  selected=$(fc -rl 1 | sed 's/^[[:space:]]*[0-9]*[[:space:]]*//' | awk '!seen[$0]++' | fzf --no-sort --query="$LBUFFER")
  [[ -n "$selected" ]] && BUFFER=$selected && CURSOR=$#BUFFER
  zle redisplay
}
zle -N fzf-history-widget
bindkey '^r' fzf-history-widget

# Edit line in vim with ctrl-e:
export VISUAL=nvim
autoload edit-command-line; zle -N edit-command-line
bindkey '^e' edit-command-line

# Load aliases and shortcuts if existent.
[ -f "$HOME/.config/shortcutrc" ] && source "$HOME/.config/shortcutrc"
[ -f "$HOME/.config/aliasrc" ] && source "$HOME/.config/aliasrc"


export AWS_PROFILE=developer
export CRYPPRO_AWS_PROFILE=developer
export CRYPPRO_REGION=legacy
export DOTNET_SYSTEM_GLOBALIZATION_INVARIANT=1

# https://stackoverflow.com/questions/20357441/zsh-on-10-9-widgets-can-only-be-called-when-zle-is-active
TRAPWINCH() {
  zle && { zle reset-prompt; zle -R }
}

# Prompt & tools
eval "$(oh-my-posh --init --shell zsh --config ~/.poshthemes/pure.omp.json)"
eval "$(mise activate zsh)"

# Lazy conda - only load when needed
conda() {
  unfunction conda
  . "/home/andromeda/miniconda3/etc/profile.d/conda.sh"
  conda "$@"
}

# Load zsh-syntax-highlighting; should be last.
source /usr/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
