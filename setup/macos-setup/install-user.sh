#!/bin/bash

# TODO:
# sc # (spreadsheet calculator)
# python3-ansible-lint
# community-mysql-server

formulae=(
  # ==========
  # CLI Tools
  # ==========
  bat           # cat replacement
  curl          # download
  lazygit       # git tui
  dos2unix      # Convert line endings
  entr          # Run command on file change
  eza           # ls replacement (exa no longer)
  fd            # find replacement
  fzf           # fuzzy finder
  git           # version control
  diff-so-fancy # nicer diff view
  ripgrep       # grep replacement
  openssh       # ssh
  tmux          # terminal multiplexer
  wget          # download
  mc            # Midnight commander
  neovim        # Text editor
  nethogs       # Bandwidth monitor
  direnv        # Environment manager
  zoxide        # z autojump replacement
  qpdf          # PDF manipulation
  gh            # Github CLI
  imagemagick   # Image manipulation
  libjpeg-turbo # JPEG manipulation
  # pipx                      # Python installer for standalone execs (use uv)
  oh-my-posh         # Prompt theme engine
  ansible            # Install automation
  saulpw/vs/visidata # cli spreadsheet
  gnumeric           # Lightweight, fast spreadsheet app
  pipx               # Python installer for standalone execs
  xonsh              # Python shell
  ruff               # Python linter and formatter
  tre-command        # Modern tree command
  saml2aws           # AWS SAML CLI
  awscli             # AWS CLI
  just               # Justfile runner (like Makefile)
  # autoenv                   # Directory based environment activation, not used because interferes with ZOxide
  docker
  docker-compose
  mkcert
  libpq                       # Postgres client
  kubectl                     # Kubernetes CLI
  kubectx                     # Kubernetes context switcher
  kubens                      # Kubernetes namespace switcher
  kubetail                    # Kubernetes log tailing
  derailed/k9s/k9s            # Kubernetes CLI UI
  metalbear-co/mirrord/mirrod # Kubernetes development proxy
  rancher-cli                 # Rancher CLI - Docker replacement
  flyway                      # Database migration tool
  watch                       # Run command at intervals
  tldr                        # alternative man pages

  # pyenv                     # Python version manager (using uv now)
  openssl  # SSL
  sqlite3  # SQLite
  xz       # Compression
  zlib     # Compression
  tcl-tk@8 # Tcl/Tk GUI Toolkit

  jabba      # Java version manager
  nvm        # Node version manager
  presenterm # Terminal presentation tool
  pnpm       # Node package manager
  duti       # Set default applications for file types
  kafka      # Apache Kafka CLI tools
  gpg        # GNU Privacy Guard
  uv         # Python package installer
  llm        # LLM CLI tool
)

casks=(
  dropbox               # File sync and backup
  visual-studio-code    # IDE
  sublime-text          # Fast, simple IDE
  font-cascadia-code-nf # Nerd font for terminal
  xournal++             # Notetaking, good for annotating PDFs
  meld                  # Diff GUI tool
  keepassxc             # Password manager GUI
  pinta                 # Paint.net like app
  inkscape              # Open source vector image app
  gimp                  # Open source Photoshop replacement
  vlc                   # Video player
  obs                   # OSS streaming, screen recording
  drawio                # Diagramming
  spotify               # Music player
  espanso               # Text expander
  gitahead              # Git client
  scroll-reverser       # Independent mouse settings for mouse and trackpad
  kitty                 # Terminal emulator
  karabiner-elements    # Keyboard remapper
  # docker
  maccy           # Clipboard manager
  shottr          # Screenshot tool
  intellij-idea   # Java IDE
  rancher         # Docker replacement
  postman         # API testing
  jordanbaird-ice # Menubar customizer
  tableplus       # Database GUI
)

#  ripcord                 # Light and fast app for Discord and Slack

exec &> >(tee -a install-user.log)

for formula in "${formulae[@]}"; do
  echo "==== Attempting to install $formula formula ===="
  brew install $formula
done

for cask in "${casks[@]}"; do
  echo "==== Attempting to install $cask cask ===="
  brew install --cask $casks
done

brew install --cask nikitabobko/tap/aerospace

# Autoraise - Raise windows on hover
brew tap dimentium/autoraise
brew install autoraise
brew services start autoraise

brew tap ankitpokhrel/jira-cli
brew install jira-cli

# pyenv update
# pyenv rehash
# LATEST_PYTHON=$(pyenv install --list | grep -E "^\s*[0-9]+\.[0-9]+\.[0-9]+$" | tail -1)
# pyenv install $LATEST_PYTHON

# pipx install black

# May need an exit and relog to work...
mkdir "$HOME/.nvm"
export NVM_DIR="$HOME/.nvm"
[ -s "/opt/homebrew/opt/nvm/nvm.sh" ] && \. "/opt/homebrew/opt/nvm/nvm.sh"                                       # This loads nvm
[ -s "/opt/homebrew/opt/nvm/etc/bash_completion.d/nvm" ] && \. "/opt/homebrew/opt/nvm/etc/bash_completion.d/nvm" # This loads nvm bash_completion
nvm install --lts

# Need to test if these work from the same script
#
npm install -g git-removed-branches
npm install -g @anthropic-ai/claude-code
npm install -g @openai/codex
