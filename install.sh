#!/bin/bash
# =============================================================================
# Dotfiles Installation Script (macOS + Linux)
# =============================================================================
# Run: curl -fsSL https://raw.githubusercontent.com/Seifeldin-Sabry/dotfiles/main/install.sh | bash
# Or:  ./install.sh
# Safe to re-run.

set -e

DOTFILES_DIR="$HOME/dotfiles"
REPO_URL="https://github.com/Seifeldin-Sabry/dotfiles.git"
PNPM_GLOBALS=(adapty @gsd-build/sdk)

# -----------------------------------------------------------------------------
# 1. Linux prerequisites (Homebrew needs a compiler, git, curl; shell is zsh)
# -----------------------------------------------------------------------------
if [[ "$(uname)" == "Linux" ]] && command -v apt-get &> /dev/null; then
    echo "[1/7] Installing Linux prerequisites..."
    sudo apt-get update && sudo apt-get install -y build-essential procps curl file git zsh
else
    echo "[1/7] Prerequisites ✓"
fi

# -----------------------------------------------------------------------------
# 2. Homebrew
# -----------------------------------------------------------------------------
if ! command -v brew &> /dev/null; then
    echo "[2/7] Installing Homebrew..."
    NONINTERACTIVE=1 /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
fi
for brew_bin in /opt/homebrew/bin/brew /usr/local/bin/brew /home/linuxbrew/.linuxbrew/bin/brew; do
    [[ -x $brew_bin ]] && eval "$($brew_bin shellenv)" && break
done
echo "[2/7] Homebrew ✓"

# -----------------------------------------------------------------------------
# 3. Clone dotfiles
# -----------------------------------------------------------------------------
if [[ ! -d "$DOTFILES_DIR" ]]; then
    echo "[3/7] Cloning dotfiles..."
    git clone "$REPO_URL" "$DOTFILES_DIR"
else
    echo "[3/7] Dotfiles present ✓"
fi

# -----------------------------------------------------------------------------
# 4. Homebrew packages
# -----------------------------------------------------------------------------
echo "[4/7] Installing Homebrew packages..."
brew bundle --file="$DOTFILES_DIR/Brewfile"

# -----------------------------------------------------------------------------
# 5. Symlinks (existing real files backed up)
# -----------------------------------------------------------------------------
echo "[5/7] Linking dotfiles..."
mkdir -p "$HOME/.config/ghostty"
for file in .zshrc .zprofile .gitconfig .config/starship.toml .config/ghostty/config; do
    target="$HOME/$file"
    if [[ -e "$target" && ! -L "$target" ]]; then
        mv "$target" "$target.backup.$(date +%Y%m%d%H%M%S)"
    fi
    ln -sf "$DOTFILES_DIR/$file" "$target"
done

# -----------------------------------------------------------------------------
# 6. Node (fnm, latest LTS) + pnpm globals
# -----------------------------------------------------------------------------
echo "[6/7] Setting up Node + pnpm globals..."
eval "$(fnm env --shell bash)"
fnm install --lts
fnm default lts-latest
fnm use default
export PNPM_HOME="$HOME/.local/share/pnpm"
export PATH="$PNPM_HOME/bin:$PATH"
mkdir -p "$PNPM_HOME/bin"
pnpm add -g "${PNPM_GLOBALS[@]}"

# -----------------------------------------------------------------------------
# 7. Shell
# -----------------------------------------------------------------------------
echo "[7/7] Final setup..."
tldr --update
zsh_path="$(command -v zsh)"
if [[ "$SHELL" != "$zsh_path" ]]; then
    grep -qx "$zsh_path" /etc/shells || echo "$zsh_path" | sudo tee -a /etc/shells
    chsh -s "$zsh_path"
fi

echo ""
echo "Done. Next:"
echo "  1. Restart terminal"
echo "  2. gh auth login"
