# Must have bashrc
#
# flatpaks
# flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo
# flatpak install --yes --quiet flathub com.jgraph.drawio.desktop
# flatpak install --yes --quiet flathub com.spotify.Client
# flatpak install --yes --quiet io.dbeaver.DBeaverCommunity

SCRIPT_PATH="$(realpath "${BASH_SOURCE[0]}")"
SCRIPT_DIR="$(dirname "$SCRIPT_PATH")"
SETUP_DIR="$(dirname "$SCRIPT_DIR")"
REPO_ROOT="$(dirname "$SETUP_DIR")"

# gh auth login
# cd
# mkdir dev && cd dev
# mkdir iansedano && cd iansedano
# gh clone config
# gh clone wtf
# gh clone git-journal


uv tool install i3-workspace-groups

mkdir --parents $HOME/.local/share/fonts
cp "$REPO_ROOT/fonts/Caskaydia Cove Nerd Font Complete.ttf" $HOME/.local/share/fonts/
fc-cache

# oh my posh
if ! command -v oh-my-posh >/dev/null 2>&1; then
  curl -s https://ohmyposh.dev/install.sh | bash -s
fi

# Jabba
curl -sL https://github.com/Jabba-Team/jabba/raw/main/install.sh | bash && . ~/.jabba/jabba.sh

# NVM
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.3/install.sh | bash # needs restart
nvm install --lts

# Rust
rustup-init

# Espanso (didn't work if not in ~/opt)
ESPANSO_URL='https://github.com/espanso/espanso/releases/download/v2.2.1/Espanso-X11.AppImage'
mkdir ~/opt
wget -O ~/opt/Espanso.AppImage $ESPANSO_URL
chmod u+x ~/opt/Espanso.AppImage
sudo ~/opt/Espanso.AppImage env-path register
espanso service register

# Reaper (check version)
# Downloads script and installs to /opt
# mkdir temp
# wget https://www.reaper.fm/files/6.x/reaper675_linux_x86_64.tar.xz -P temp
# tar xvf temp/reaper675_linux_x86_64.tar.xz -C temp
# ./temp/reaper_linux_x86_64/install-reaper.sh

# Manictime (check version) (didn't work from command line... maybe just do manually)
# sudo dnf install libX11-devel libappindicator-gtk3 libXScrnSaver gssntlmssp openssl-libs krb5-libs
# wget https://cdn.manictime.com/setup/linux/v1_4_3_0/ManicTime-arch.tar.gz -P temp
# tar xvf temp/ManicTime-arch.tar.gz -C temp
# ./temp/manictime/manictime # does not support root install (casing important)
