mkdir -p ~/.config/fish
mkdir -p ~/.config/ghostty
mkdir -p ~/.config/helix

cp configs/config.fish ~/.config/fish/config.fish
cp configs/config.starship ~/.config/starship.toml
cp configs/config.ghostty ~/.config/ghostty/config
cp configs/config.helix ~/.config/helix/config.toml

sudo dnf install --nogpgcheck --repofrompath 'terra,https://repos.fyralabs.com/terra$releasever' terra-release

sudo dnf install ripgrep fish zoxide fzf helix onefetch ipython fastfetch git gh bat eza mpv ghostty -y
curl -sS https://starship.rs/install.sh | sh
curl -sL https://raw.githubusercontent.com/jorgebucaran/fisher/main/functions/fisher.fish | source && fisher install jorgebucaran/fisher
curl -fsSL https://bun.sh/install | bash

chsh -s /usr/bin/fish

echo "Shell has been installed"
