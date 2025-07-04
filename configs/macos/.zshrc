echo "running .zshrc"

DROPBOX="$HOME/Dropbox"
DESKTOP="$DROPBOX/Desktop"
DEV="$HOME/dev"
DROPBOX_DEV="$DROPBOX/dev"
NOTEBOOK="$DROPBOX/notebook"
CONFIG="$DEV/iansedano/config"
WTF="$DEV/iansedano/wtf"
POSH_CONFIG="$CONFIG/configs/common/posh.omp.json"
SNIPPETS="$WTF/snippets"
SCRIPTS="$CONFIG/scripts"
DOT_CONFIG="$HOME/.config"
IAN_CONFIG="$DOT_CONFIG/iansedano"
GIT_JOURNAL="$DEV/iansedano/git-journal"

source "$IAN_CONFIG/import_script.sh"
source "$DEV/iansedano/billy/scripts/bynderrc"

# ========================================
# User specific environment
# ========================================

export PATH="$HOME/.local/bin:$PATH"
export PATH="$HOME/bin:$PATH"
export PATH="$CONFIG/scripts:$PATH"
export PATH="$DEV/iansedano/billy/scripts:$PATH"

export SNIPPET_DIR="$SNIPPETS"

export VISUAL=nvim
export EDITOR=nvim

export PAGER="bat"
export MANPAGER="sh -c 'col -bx | bat -l man -p'"

# ========================================
# Prompt
# ========================================

autoload -U promptinit
promptinit
PS1='%F{cyan}%n%F{red}@%F{green}%m%F{magenta}:%~%F{red}$%f '

# Completion settings
autoload -Uz compinit && compinit
zstyle ':completion:*' menu select
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Za-z}'
bindkey '^I' menu-complete
bindkey '^[[Z' reverse-menu-complete
setopt HIST_IGNORE_ALL_DUPS

eval "$(oh-my-posh init zsh --config "$POSH_CONFIG")"

# ========================================
# direnv
# ========================================

eval "$(direnv hook zsh)"

# ========================================
# fzf
# ========================================

if command -v fzf >/dev/null; then
  source <(fzf --zsh)
fi

# ========================================
# Light and Dark Mode
# ========================================

light() {
  export BAT_THEME="gruvbox-light"
}

dark() {
  export BAT_THEME=""
}

# ========================================
# Shortcuts
# ========================================

alias desktop="cd $DESKTOP"
alias dev="cd $DEV"
alias dropdev="cd $DROPBOX_DEV"
alias config="cd $CONFIG"
alias notebook="cd $NOTEBOOK"
alias wtf="cd $WTF"

# ========================================
# Utils
# ========================================

alias ls='eza'
alias la='eza -lah --git'

alias mc='mc --nosubshell --nocolor'
alias gemma='ollama run gemma3:4b'

if [[ $(uname) == 'Darwin' ]]; then
  alias copy="pbcopy"
  alias paste="pbpaste"
elif [ "$XDG_SESSION_TYPE" = "x11" ]; then
  alias copy="xclip -selection clipboard"
  alias paste="xclip -selection clipboard -o"
fi

alias feh="feh --geometry 1680x1390 --scale-down --edit"

alias ..="cd .."

runbg() {
  nohup "$@" >/dev/null 2>&1 &
}
compdef '_files' runbg

clear() {
  printf '\033[2J\033[3J\033[1;1H'
}

uv-activate-script-venv() {
  script=$(uv python find --script "$1")
  parent_dir=$(dirname "$script")
  source "$parent_dir/activate"
}

# ========================================
# Notes & Snippets
# ========================================

# alias snips="cd $SNIPPETS"
# snip() {
#  read -r "name?Enter snippet name: "
#  nvim "$SNIPPETS/$(date '+%Y%m')-${name}.md"
#}
#alias snippets="ls $SNIPPETS"

note() {
  if [[ -z $1 ]]; then
    echo "Error: Provide note name"
    return 1
  fi
  nvim "$NOTEBOOK/0-unprocessed/$1.md"
}

todo() {
  if [[ -z $1 ]]; then
    nvim "$NOTEBOOK/TODO.md"
  else
    nvim "$NOTEBOOK/TODO-$1.md"
  fi
}

alias scratch="nvim $GIT_JOURNAL/SCRATCH.md"

mem() {
  nvim "$NOTEBOOK/mem.md"
}

journal() {
  nvim "$NOTEBOOK/journal/$(date '+%Y%m%d').md"
}

# ========================================
# JavaScript
# ========================================

export NVM_DIR="$HOME/.nvm"
[ -s "/opt/homebrew/opt/nvm/nvm.sh" ] && \. "/opt/homebrew/opt/nvm/nvm.sh"                                       # This loads nvm
[ -s "/opt/homebrew/opt/nvm/etc/bash_completion.d/nvm" ] && \. "/opt/homebrew/opt/nvm/etc/bash_completion.d/nvm" # This loads nvm bash_completion

# ========================================
# Python
# ========================================

alias venv="source venv/bin/activate"

# ========================================
# Java
# ========================================

# idea() {
# [[ -z $1 ]] && runbg idea.sh . || runbg idea.sh $1
# }
# compdef '_files' idea

[ -s "$HOMEBREW_PREFIX/opt/jabba/jabba.sh" ] && . "$HOMEBREW_PREFIX/opt/jabba/jabba.sh"
jabba use amazon-corretto@1.21.0-7.6.1

# ========================================
# Rust
# ========================================

[[ -x "$(command -v rustup)" ]] && source "$HOME/.cargo/env"

# ========================================
# zoxide (must be at end of file)
# ========================================

eval "$(zoxide init zsh)"

# pnpm
export PNPM_HOME="/Users/ian.currie/Library/pnpm"
case ":$PATH:" in
*":$PNPM_HOME:"*) ;;
*) export PATH="$PNPM_HOME:$PATH" ;;
esac
# pnpm end

### MANAGED BY RANCHER DESKTOP START (DO NOT EDIT)
export PATH="/Users/ian.currie/.rd/bin:$PATH"
### MANAGED BY RANCHER DESKTOP END (DO NOT EDIT)
