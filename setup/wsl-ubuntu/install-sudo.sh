#!/usr/bin/env bash

apt update && apt full-upgrade -y

packages=(
  # ==========
  # CLI Tools
  # ==========
  bat                 # cat replacement
  curl                # download
  # lazygit             # git tui
  dos2unix            # Convert line endings
  entr                # Run command on file change
  # eza                 # ls replacement (exa no longer)
  fd-find             # find replacement
  fzf                 # fuzzy finder
  git                 # version control
  # diff-so-fancy       # nicer diff view
  ripgrep             # grep replacement
  tmux                # terminal multiplexer
  wget                # download
  mc                  # Midnight commander
  visidata            # Spreadsheet viewer
  sc                  # Spreadsheet calculator
  neovim              # Text editor
  nethogs             # Bandwidth monitor
  direnv              # Environment manager
  zoxide              # z autojump replacement
  qpdf                # PDF manipulation
  gh                  # Github CLI
  mycli               # MySQL CLI
  # uv
  tre-command
  tldr
  

  # ==========
  # X11 Tools
  # ==========
  xclip  # clipboard manager
  xinput # input device manager
  xsetroot
  xpad
  xrandr # change output properties
  scrot  # Screenshot tool

  #######
  # Build tools (C, pyenv, etc)
  #######
  gcc
  make
  cmake
  clang
  bzip2
  sqlite
)

for package in "${packages[@]}"; do
  echo "==== Attempting to install $package ===="
  apt install -y $package
done
