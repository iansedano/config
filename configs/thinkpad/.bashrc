echo "running .bashrc"

DROPBOX="$HOME/Dropbox"
DESKTOP="$DROPBOX/Desktop"
DEV="$HOME/dev"
DROPBOX_DEV="$DROPBOX/dev"
NOTEBOOK="$DROPBOX/notebook"
CODESNIP="$DEV/CodeSnips-Notes"
POSH_CONFIG="$CODESNIP/configs/common/posh.omp.json"
SNIPPETS="$CODESNIP/snippets"
SCRIPTS="$CODESNIP/scripts"

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

if ! [[ "$PATH" =~ (^|:)"$CODESNIP/scripts"(:|$) ]]; then
  PATH="$CODESNIP/scripts:$PATH"
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
# direnv
# ========================================

eval "$(direnv hook bash)"

# ========================================
# fzf
# ========================================

if [ -x "$(command -v fzf)" ]; then
  source /usr/share/fzf/shell/key-bindings.bash
fi

# ========================================
# Light and Dark Mode
# ========================================

light() {
  export BAT_THEME="gruvbox-light"
  alacritty msg config "$(cat ~/.config/alacritty/light.toml)"
}

dark() {
  export BAT_THEME=""
  alacritty msg config "$(cat ~/.config/alacritty/alacritty.toml)"
}

# ========================================
# Shortcuts
# ========================================

alias desktop="cd \$DESKTOP"
alias dev="cd \$DEV"
alias dropdev="cd \$DROPBOX_DEV"
alias codesnip="cd \$CODESNIP"
alias notebook="cd \$NOTEBOOK"

# ========================================
# Utils
# ========================================

alias ls='eza'
alias la='eza -lah'

alias copy="xclip -selection clipboard"
alias paste="xclip -selection clipboard -o"

alias feh="feh --geometry 1680x1390 --scale-down --edit"

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
# Python
# ========================================

export PYENV_ROOT="$HOME/.pyenv"
export PATH="$PYENV_ROOT/bin:$PATH"
if command -v pyenv 1>/dev/null 2>&1; then
  eval "$(pyenv init -)"
fi

alias mkvenv="mkdir venv; echo 'venv' > .dbignore; dbignore; python -m venv venv; source venv/bin/activate"
alias venv="source venv/bin/activate"

# ========================================
# Java
# ========================================

idea() {
  if [[ -z $1 ]]; then
    runbg idea.sh $1
  else
    runbg idea.sh .
  fi
}
complete -c idea

[ -s "/home/cuse/.jabba/jabba.sh" ] && source "/home/cuse/.jabba/jabba.sh"

# ========================================
# Rust
# ========================================

# Check if rustup is installed
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
