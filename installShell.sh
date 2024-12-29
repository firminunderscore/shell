mkdir -p ~/.config/fish
cp config.fish ~/.config/fish/config.fish
cp starship.toml ~/.config/starship.toml
cp config.ghostty ~/.config/ghostty/config

sudo dnf enable copr enable firminunderscore/ghostty -y
sudo dnf install ripgrep fish zoxide fzf helix onefetch ipython fastfetch git gh bat eza mpv ghostty -y
curl -sS https://starship.rs/install.sh | sh
curl -sL https://raw.githubusercontent.com/jorgebucaran/fisher/main/functions/fisher.fish | source && fisher install jorgebucaran/fisher
curl -fsSL https://bun.sh/install | bash

chsh -s /usr/bin/fish

echo "Shell has been installed"
