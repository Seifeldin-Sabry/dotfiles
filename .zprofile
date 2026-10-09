# =============================================================================
# ZSH Profile - Loaded once at login
# =============================================================================

# Homebrew (macOS Apple Silicon, macOS Intel, Linux)
for brew_bin in /opt/homebrew/bin/brew /usr/local/bin/brew /home/linuxbrew/.linuxbrew/bin/brew; do
    [[ -x $brew_bin ]] && eval "$($brew_bin shellenv)" && break
done
unset brew_bin
