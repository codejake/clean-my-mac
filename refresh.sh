#!/usr/bin/env bash

#
# Update and clean up Homebrew and its packages.
#
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

#
# Show the user the current login items.
#
function display_loginitems() {
    echo -e "\n[👀] Task: Showing Your Login Items"
    #osascript -e 'tell application "System Events" to get the name of every login item'
    #osascript -e 'tell application "System Events" to get properties of every login item'
    osascript -e 'tell application "System Events" to get {name, path} of every login item' | sed 's/[{}]//g' | awk -F', ' '{for(i=1;i<=NF/2;i++) print $i " -> " $(i+NF/2)}'
    echo ""
}

#
# Show the user what's in /Library/LaunchAgents and /Library/LaunchDaemons.
#
function display_library_launch_stuff() {
    echo -e "\n[👀] Task: Showing /Library/LaunchAgents"
    ls -1 /Library/LaunchAgents
    echo ""

    echo ""
    echo "[👀] Task: Showing /Library/LaunchDaemons"
    ls -1 /Library/LaunchDaemons
    echo ""
}

#
# Show the user what's in ~/Library/LaunchAgents and ~/Library/LaunchDaemons.
#
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

#
# Use Homebrew to update all App Store apps.
#
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

#
# Update Visual Studio Code extensions.
#
function update_vscode_extensions() {
    echo -e "\n[🔧] Task: Updating Visual Studio Code Extensions"
    
    # Check if code (Visual Studio Code CLI) is installed
    if ! hash code 2>/dev/null; then
        echo "Error: Visual Studio Code is not installed"
        return 1
    fi
    
    # Attempt to update Visual Studio Code extensions
    if ! code --update-extensions; then
        echo "Error: Failed to update Visual Studio Code extensions"
        return 1
    fi
    
    echo -e "\nVisual Studio Code extensions updated successfully"
}

#
# Flush the DNS cache and restart mDNSResponder.
#
function refresh_dns() {
    echo -e "\n[🔧] Task: Flushing DNS cache and restarting mDNSResponder (asks for password)"
    sudo dscacheutil -flushcache && sudo killall -HUP mDNSResponder >/dev/null 2>/dev/null
}

#
# Main
#

# The order matters.

clean_homebrew
update_app_store_apps
update_vscode_extensions
refresh_dns
display_loginitems
display_library_launch_stuff