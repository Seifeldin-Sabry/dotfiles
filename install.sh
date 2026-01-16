#!/bin/bash
# =============================================================================
# Dotfiles Installation Script
# =============================================================================
# Run: curl -fsSL https://raw.githubusercontent.com/Seifeldin-Sabry/dotfiles/main/install.sh | bash
# Or:  ./install.sh

set -e

DOTFILES_DIR="$HOME/dotfiles"
REPO_URL="git@github.com:Seifeldin-Sabry/dotfiles.git"

echo "=============================================="
echo "        Dotfiles Installation Script          "
echo "=============================================="

# -----------------------------------------------------------------------------
# 1. Install Homebrew (if not installed)
# -----------------------------------------------------------------------------
if ! command -v brew &> /dev/null; then
    echo "[1/6] Installing Homebrew..."
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    eval "$(/opt/homebrew/bin/brew shellenv)"
else
    echo "[1/6] Homebrew already installed ✓"
fi

# -----------------------------------------------------------------------------
# 2. Clone dotfiles (if not present)
# -----------------------------------------------------------------------------
if [[ ! -d "$DOTFILES_DIR" ]]; then
    echo "[2/6] Cloning dotfiles..."
    git clone "$REPO_URL" "$DOTFILES_DIR"
else
    echo "[2/6] Dotfiles already cloned ✓"
    cd "$DOTFILES_DIR" && git pull
fi

# -----------------------------------------------------------------------------
# 3. Install Homebrew packages
# -----------------------------------------------------------------------------
echo "[3/6] Installing Homebrew packages..."
brew bundle --file="$DOTFILES_DIR/Brewfile" || true

# -----------------------------------------------------------------------------
# 4. Create symlinks
# -----------------------------------------------------------------------------
echo "[4/6] Creating symlinks..."

# Backup and link .zshrc
if [[ -f "$HOME/.zshrc" && ! -L "$HOME/.zshrc" ]]; then
    mv "$HOME/.zshrc" "$HOME/.zshrc.backup.$(date +%Y%m%d)"
fi
ln -sf "$DOTFILES_DIR/.zshrc" "$HOME/.zshrc"

# Backup and link .zprofile
if [[ -f "$HOME/.zprofile" && ! -L "$HOME/.zprofile" ]]; then
    mv "$HOME/.zprofile" "$HOME/.zprofile.backup.$(date +%Y%m%d)"
fi
ln -sf "$DOTFILES_DIR/.zprofile" "$HOME/.zprofile"

# Backup and link .gitconfig
if [[ -f "$HOME/.gitconfig" && ! -L "$HOME/.gitconfig" ]]; then
    mv "$HOME/.gitconfig" "$HOME/.gitconfig.backup.$(date +%Y%m%d)"
fi
ln -sf "$DOTFILES_DIR/.gitconfig" "$HOME/.gitconfig"

echo "   Symlinks created ✓"

# -----------------------------------------------------------------------------
# 5. Install Node.js via fnm
# -----------------------------------------------------------------------------
echo "[5/6] Setting up Node.js..."
if command -v fnm &> /dev/null; then
    eval "$(fnm env)"
    fnm install --lts
    fnm default lts-latest
    echo "   Node.js $(node --version) installed ✓"
fi

# -----------------------------------------------------------------------------
# 6. Final setup
# -----------------------------------------------------------------------------
echo "[6/6] Final setup..."

# Install fzf key bindings
if [[ -f "$(brew --prefix)/opt/fzf/install" ]]; then
    "$(brew --prefix)/opt/fzf/install" --key-bindings --completion --no-update-rc --no-bash --no-fish
fi

echo ""
echo "=============================================="
echo "            Installation Complete!            "
echo "=============================================="
echo ""
echo "Next steps:"
echo "  1. Restart your terminal (or run: source ~/.zshrc)"
echo "  2. Zinit will auto-install plugins on first load"
echo ""
echo "New commands to try:"
echo "  z <dir>      - Smart directory jumping"
echo "  Ctrl+R       - Fuzzy history search"
echo "  git forgit   - Interactive git (ga, gd, gl)"
echo "  cat file     - Syntax highlighted output (bat)"
echo "  ls           - Better listing (eza)"
echo ""
