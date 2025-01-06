if status is-interactive
    # Commands to run in interactive sessions can go here
    zoxide init fish | source
    starship init fish | source
end

# Remove fish greeting message
set -g fish_greeting

export EDITOR=/usr/bin/hx
# export VISUAL=/usr/bin/code

# ----- MANUAL PAGER -----
# Custom pager for man pages using Bat for syntax highlighting
export MANPAGER="sh -c 'col -bx | bat -l man -p'"

# ----- ALIASES -----
# Shell-related aliases
alias config-fish="hx ~/.config/fish/config.fish" # Open fish config
alias config-starship="hx ~/.config/starship.toml" # Open Starship config
alias config-ghostty="hx ~/.config/ghostty/config"
alias reload='echo -e "\033[0;1;33mReloading ..." &&\
  source ~/.config/fish/config.fish &&\
  echo -e "\033[0;1;33mReloaded !"' # Reload fish config
alias sudoedit="sudo hx" # Edit files with sudo
alias sudoexit="sudo -k" # Reset sudo timestamp
alias cls="clear" # Clear the screen using the Windows command
alias rsync="rsync -razvhP" # Rsync with progress, archive, compress, verbose, and human-readable
alias khostedit="hx ~/.ssh/known_hosts" # Edit known hosts
alias ssh_config_edit="hx ~/.ssh/config" # Edit SSH config
alias font_reload="fc-cache -fv"

# ----- GIT ALIASES -----
# Shortcuts for common Git commands
alias gs="git status" # Git status
alias gf="git fetch" # Git fetch
alias gp="git pull" # Git pull
alias gl="git log --graph --all" # Git log with graph
alias go="onefetch" # Display repository info
alias gla="git shortlog -sne" # List contributors

# Function to add, commit, and push in one command
function acp # a(dd) c(ommit) p(ush)
    git add .
    git commit

    echo "Press y to push"
    read -l push
    if test $push = y
        git push
    end
end

# Function to create/switch to a new branch
function gc
    if test (count $argv) -eq 0
        echo "Usage: gc <branch-name>"
        return 1
    end

    set branch_name $argv[1]

    # Check if the branch exists
    if git rev-parse --verify $branch_name >/dev/null 2>&1
        echo "Switching to existing branch '$branch_name'..."
        git checkout $branch_name
    else
        echo "Branch '$branch_name' does not exist. Creating and switching to it..."
        git checkout -b $branch_name
    end
end

# Function to force reset to HEAD with confirmation
function ff # f(orfait)
    echo -e "\033[0;1;31mAre you sure you want to FF? (y/n)"
    read -l -n 1 -P "Press y to confirm and kill yourself: " response
    if test "$response" = y
        git reset --hard HEAD
        echo -e "\033[0;1;32mSuccesfully FFed!"
    else
        echo -e "\033[0;1;33mFF canceled. Good luck!"
    end
    echo -e "\033[0m"
end

# ----- Medias -----
# Function to play media with MPV
function play
    mpv $argv[1] &
    pidof mpv | disown
    exit
end

# Function to extract audio from YouTube in WAV format
function yt-dlpa
    if test (count $argv) -ne 1
        echo "Usage: extract_audio_wav <YouTube URL>"
        return 1
    end

    yt-dlp --extract-audio --audio-format mp3 $argv[1]
end

# ----- PYTHON ENVIRONMENT -----
# Abbreviation for IPython
abbr -a -g python ipython

# Function to initialize a Python virtual environment
function venvinit
    # Create virtual environment
    python3 -m venv .venv

    # Create Pyright config
    echo "{ \"venvPath\": \".\", \"venv\": \".venv\" }" >pyrightconfig.json

    # Activate virtual environment
    source .venv/bin/activate.fish

    # Install and upgrade basic packages
    pip install ipython
    pip install --upgrade pip

    # Install dependencies if requirements.txt exists
    if test -f "requirements.txt"
        echo -e "\033[0;1;33mrequirements.txt found. Do you want to install dependencies? (y/n)\033[0m"
        read -l install_deps

        if test $install_deps = y
            echo -e "\033[0;1;32mInstalling dependencies from requirements.txt...\033[0m"
            pip install -r requirements.txt
        else
            echo -e "\033[0;1;31mSkipping dependency installation.\033[0m"
        end
    else
        echo -e "\033[0;1;31mNo requirements.txt found.\033[0m"
    end

    # Final message
    echo -e "\033[0;1;32mInitialized!\033[0m"
end

# Function to activate the virtual environment
function venvstart
    # Check if .venv exists
    if test -d ".venv"
        source .venv/bin/activate.fish
        echo -e "\033[0;1;32mVenv Activated!\033[0m"
    else
        echo -e "\033[0;1;31mNo venv found. Initializing...\033[0m"
        venvinit
    end
end

# Function to deactivate the virtual environment
function venvstop
    # Check if .venv exists
    if test -d ".venv"
        deactivate
        echo -e "\033[0;1;32mVenv Deactivated!\033[0m"
    else
        echo -e "\033[0;1;31mNo venv found. \033[0m"
    end
end

# Function to remove the virtual environment
function venvremove
    # Check if .venv exists
    if test -d ".venv"
        # Check if the 'deactivate' command is available
        if type -q deactivate
            venvstop
        end

        rm -rf .venv
        echo -e "\033[0;1;32mVenv and related files removed successfully!\033[0m"
    else
        echo -e "\033[0;1;31mNo venv found to remove.\033[0m"
    end
end

# Function to clean Python cache and bytecode
function pyclean
    find . -type f -name '*.py[co]' -delete -o -type d -name __pycache__ -delete
    rm -rf .ruff_cache
end

# ----- FILE NAVIGATION & MANAGEMENT -----
# Aliases for file management commands
alias lal="eza -al --icons --git --group-directories-first" # List all files in list format
alias ll="eza -l --icons --git --group-directories-first" # List files in list format
alias ls="eza --icons --git --group-directories-first" # List files
alias lt="eza -TL 3 --icons --group-directories-first" # Tree
alias zz="cd .." # Go up one directory
alias rmd="rm -rfvI" # Remove files/directories with confirmation

# Abbreviations for commonly used commands
abbr -a -g cat bat # Use bat instead of cat
abbr -a -g cd z # Use z for cd
abbr -a -g grep rg # Use rg instead of grep

# Function to create and change into a new directory
function mkcd
    mkdir $argv[1]
    cd $argv[1]
end

# Function for a humorous output
function rose
    echo -e "Roses are \033[91mred"
    echo -e "\033[39mViolets are \033[94mblue"
    echo -e "\033[39mMissing semicolon on line 32"
end

# Cheat.sh
function cheat
    curl cheat.sh/$argv[1]
end

# ----- SYSTEM MANAGEMENT -----
function update
    echo ----------------------
    echo "Updating RPM packages"
    sudo dnf update --refresh
    echo ----------------------
    echo "Updating Flatpaks"
    flatpak update
    echo ----------------------
    echo "Updating BunJS"
    bun upgrade
    echo ----------------------
end

# ----- GitHub Copilot -----
function ghc
    if test (count $argv) -eq 0
        echo "Usage: ghc explain | suggest <arguments>"
        return 1
    end
    gh copilot $argv
end

# ----- BUN -----
# Set up Bun package manager
set --export BUN_INSTALL "$HOME/.bun"
set --export PATH $BUN_INSTALL/bin $PATH

# ---- Path -----
set -Ux fish_user_paths /home/firmin/.local/bin $fish_user_paths
