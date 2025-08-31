exec &> >(tee -a install-sudo.log)

dnf upgrade -y

rpmdomain="https://mirrors.rpmfusion.org/"
freerepo="free/fedora/rpmfusion-free-release-$(rpm -E %fedora)"
nonfreerepo="nonfree/fedora/rpmfusion-nonfree-release-$(rpm -E %fedora)"

dnf install -y "$rpmdomain$freerepo.noarch.rpm"
dnf install -y "$rpmdomain$nonfreerepo.noarch.rpm"
dnf install -y fedora-workstation-repositories # for chrome
dnf config-manager setopt google-chrome.enabled=1

terra_repo_url="https://terra.fyralabs.com/terra.repo"
terra_repo_id="terra"
if ! dnf repolist | grep -q "^${terra_repo_id}"; then
  dnf config-manager addrepo ${terra_repo_url}
fi

dnf upgrade -y

dnf copr enable atim/lazygit -y
# dnf copr enable lkiesow/intellij-idea-community # need to test this

packages=(
  # ==========
  # CLI Tools
  # ==========
  bat                 # cat replacement
  curl                # download
  lazygit             # git tui
  dos2unix            # Convert line endings
  entr                # Run command on file change
  eza                 # ls replacement (exa no longer)
  fd-find             # find replacement
  fzf                 # fuzzy finder
  git                 # version control
  diff-so-fancy       # nicer diff view
  ripgrep             # grep replacement
  openssh             # ssh
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
  ImageMagick         # Image manipulation
  libjpeg-turbo-utils # JPEG manipulation
  mycli               # MySQL CLI
  awscli2             # AWS CLI
  tldr
  uv
  ollama

  # ==========
  # X11 Tools
  # ==========
  xclip  # clipboard manager
  xinput # input device manager
  xsetroot
  xpad
  xrandr # change output properties
  scrot  # Screenshot tool

  # ==========
  # Desktop Environment
  # ==========
  i3                      # Window manager
  dunst                   # Notification daemon
  nautilus-dropbox        # Dropbox daemon
  rofi                    # Launcher
  alacritty               # Terminal emulator
  cascadiacode-nerd-fonts # Nerd font for terminal
  # yad   # Tray icons?

  # ==========
  # Desktop Apps
  # ==========
  meld                 # Diff tool
  google-chrome-stable # browser
  keepassxc            # Password manager
  gnumeric             # Superfast basic spreadsheet
  xournalpp            # Annotate PDFs and general drawing
  pinta                # Paint.net like app
  peek                 # Gif recorder
  feh                  # Image viewer
  zulucrypt            # Truecrypt replacement

  # ==========
  # Dev Tools
  # ==========
  ansible                # Install automation
  python3-ansible-lint   # Linting for ansible
  community-mysql-server # MySQL
  python3-pip            # Python package manager for system install

  # kamoso # Way to many deps... use vlc
  simplescreenrecorder
  screenkey
  obs-studio
  inkscape
  gimp
  vlc
  zeal      # Offline documentation
  flameshot # Screenshot tool
  switchdesk

  #######
  # Build tools (C, pyenv, etc)
  #######
  gcc-c++
  gcc
  make
  cmake
  clang
  clang-tools-extra
  zlib-devel
  bzip2
  bzip2-devel
  readline-devel
  sqlite
  sqlite-devel
  openssl-devel
  tk-devel
  libffi-devel
  xz-devel
  libuuid-devel
  gdbm-devel
  libnsl2-devel
  fuse-libs
)

for package in "${packages[@]}"; do
  echo "==== Attempting to install $package ===="
  dnf install -yq $package
done

rpm --import https://packages.microsoft.com/keys/microsoft.asc
echo -e \
"[code]\nname=Visual Studio Code\nbaseurl=https://packages.microsoft.com/yumrepos/vscode\nenabled=1\nautorefresh=1\ntype=rpm-md\ngpgcheck=1\ngpgkey=https://packages.microsoft.com/keys/microsoft.asc" \
| sudo tee /etc/yum.repos.d/vscode.repo > /dev/null

dnf check-update
dnf install -yq code

# Sublime Text
if ! dnf repolist | grep -q "sublime-text"; then
  rpm -v --import https://download.sublimetext.com/sublimehq-rpm-pub.gpg
  dnf config-manager addrepo --from-repofile=https://download.sublimetext.com/rpm/stable/x86_64/sublime-text.repo
fi

dnf install -yq sublime-text

