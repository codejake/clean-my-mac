#!/usr/bin/env bash

function clean_homebrew() {
    if hash brew 2>/dev/null; then
        echo -e "\n[🔧] Task: Cleaning Homebrew"
        brew update
        brew upgrade
        brew upgrade --cask
        brew outdated --cask | cut -f1 | xargs brew cask reinstall --cask
        brew cleanup
        brew autoremove
        echo ""

        echo "[👀] Informational: Looking at Homebrew health"
        brew doctor
        brew missing

        echo "[🔧] Task: Perform final Homebrew cleanup and scrub the cache"
        brew cleanup --scrub
    fi
}

function display_loginitems() {
    echo -e "\n[👀] Task: Showing Your Login Items"
    #osascript -e 'tell application "System Events" to get the name of every login item'
    #osascript -e 'tell application "System Events" to get properties of every login item'
    osascript -e 'tell application "System Events" to get {name, path} of every login item' | sed 's/[{}]//g' | awk -F', ' '{for(i=1;i<=NF/2;i++) print $i " -> " $(i+NF/2)}'
    echo ""
}

function display_library_launch_stuff() {
    echo -e "\n[👀] Task: Showing /Library/LaunchAgents"
    ls -1 /Library/LaunchAgents
    echo ""

    echo ""
    echo "[👀] Task: Showing /Library/LaunchDaemons"
    ls -1 /Library/LaunchDaemons
    echo ""
}

function display_user_launch_stuff() {
    if [ ! -d ~/Library/LaunchAgents ]; then
        echo -e "[👀] Task: Showing ~/Library/LaunchAgents"
        ls -1 ~/Library/LaunchAgents
        echo ""
    fi

    if [ ! -d ~/Library/LaunchDaemons ]; then
        echo "[👀] Task: Showing ~/Library/LaunchDaemons"
        ls -1 ~/Library/LaunchDaemons
        echo ""
    fi
}

function update_app_store_apps() {
    echo -e "\n[🔧] Task: Updating App Store Apps"
    
    # Check if mas (Mac App Store CLI) is installed
    if ! brew list mas &>/dev/null; then
        echo "Installing mas (Mac App Store CLI)..."
        if ! brew install mas; then
            echo "Error: Failed to install mas"
            return 1
        fi
    fi
    
    # Attempt to update App Store apps
    if ! mas upgrade; then
        echo "Error: Failed to update App Store apps"
        return 1
    fi
    
    echo -e "\nApp Store updates completed successfully"
}

#clean_homebrew
update_app_store_apps
display_loginitems
display_library_launch_stuff