echo "running .bashrc"

DEV="$HOME/dev"
CONFIG="$DEV/iansedano/config"
POSH_CONFIG="$CONFIG/configs/common/posh.omp.json"
SNIPPETS="$DEV/iansedano/wtf/snippets"
SCRIPTS="$CONFIG/scripts"

if [ -f /etc/bashrc ]; then
  . /etc/bashrc
fi

# ========================================
# History
# ========================================

export HISTFILESIZE=
export HISTSIZE=
export HISTTIMEFORMAT="[%F %T] "
export HISTFILE=~/.bash_eternal_history

# create histfile if doesn't exist
if [ ! -f $HISTFILE ]; then
  touch $HISTFILE
fi

# if histfile is greater than 1mb then warn
if [ $(stat -c %s $HISTFILE) -gt 1000000 ]; then
  echo "Warning: History file is greater than 1mb"
fi

# if histfile is greater than 10mb then warn
if [ $(stat -c %s $HISTFILE) -gt 10000000 ]; then
  echo "Warning: History file is greater than 10mb"
fi

# ========================================
# User specific environment
# ========================================

if ! [[ "$PATH" =~ "$HOME/.local/bin:$HOME/bin:" ]]; then
  PATH="$HOME/.local/bin:$HOME/bin:$PATH"
fi

if ! [[ "$PATH" =~ (^|:)"$CONFIG/scripts"(:|$) ]]; then
  PATH="$CONFIG/scripts:$PATH"
fi

export PATH

# ========================================
# Prompt
# ========================================

PS1='\[\033[1;36m\]\u\[\033[1;31m\]@\[\033[1;32m\]\h:\[\033[1;35m\]\w\[\033[1;31m\]\$\[\033[0m\] '
bind 'set completion-ignore-case on'
bind "TAB:menu-complete"
bind '"\e[Z": menu-complete-backward'
bind "set show-all-if-ambiguous off"

eval "$(oh-my-posh init bash --config "$POSH_CONFIG")"

# ========================================
# fzf
# ========================================

if [ -x "$(command -v fzf)" ]; then
  source /data/data/com.termux/files/usr/share/fzf
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

alias desktop="cd \$DESKTOP"
alias dev="cd \$DEV"
alias dropdev="cd \$DROPBOX_DEV"
alias config="cd \$CONFIG"
alias notebook="cd \$NOTEBOOK"

# ========================================
# Utils
# ========================================

alias ls='eza'
alias la='eza -lah'

alias copy="xclip -selection clipboard"
alias paste="xclip -selection clipboard -o"

alias ..="cd .."

runbg() {
  nohup "$@" >/dev/null 2>&1 &
}
complete -c runbg

# ========================================
# Notes & Snippets
# ========================================

alias snips="cd \$SNIPPETS"
snip() {
  read -p "Enter snippet name: " name
  nvim "$SNIPPETS/$(date '+%Y%m')-${name}.md"
}
alias snippets="ls \$SNIPPETS"

note() {
  if [[ -z $1 ]]; then
    echo "Error: Provide note name"
    return 1
  else
    nvim "$NOTEBOOK/0-unprocessed/$1.md"
  fi
}

todo() {
  if [[ -z $1 ]]; then
    nvim "$NOTEBOOK/TODO.md"
  else
    nvim "$NOTEBOOK/TODO-$1.md"
  fi
}

alias scratch="nvim \$NOTEBOOK/SCRATCH.md"

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
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"                   # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion" # This loads nvm bash_completion

# ========================================
# Java
# ========================================

# ========================================
# Rust
# ========================================

if [ -x "$(command -v rustup)" ]; then
  . "$HOME/.cargo/env"
fi

# ========================================
# Screenshots
# ========================================

alias screenshot="import png:- | xclip -selection clipboard -t image/png"

function manage_screenshots() {
  runbg "$SCRIPTS/screenshot-log.sh"
}

# ========================================
# zoxide (must be at end of file)
# =======================================

eval "$(zoxide init bash)"
