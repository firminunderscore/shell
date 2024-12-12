mkdir -p ~/.config/fish
cp config.fish ~/.config/fish/config.fish
cp starship.toml ~/.config/starship.toml

sudo dnf install fish zoxide fzf helix onefetch ipython fastfetch git gh bat eza mpv
curl -sS https://starship.rs/install.sh | sh
curl -sL https://raw.githubusercontent.com/jorgebucaran/fisher/main/functions/fisher.fish | source && fisher install jorgebucaran/fisher
curl -fsSL https://bun.sh/install | bash

echo "Now, you should change your default shell with chsh -s /usr/bin/fish"
