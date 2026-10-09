# =============================================================================
# Brewfile - Essentials only (macOS + Linux)
# =============================================================================
# Install with: brew bundle --file=~/dotfiles/Brewfile
# Curated by hand. Not a mirror of everything installed.

# Core
brew "git"
brew "git-lfs"
brew "gh"                    # GitHub CLI + git credential helper
brew "gitleaks"              # Secret scanner

# Shell
brew "fzf"                   # Fuzzy finder
brew "bat"                   # Better cat
brew "eza"                   # Better ls
brew "fd"                    # Better find
brew "ripgrep"               # Better grep
brew "zoxide"                # Smart cd
brew "direnv"                # Directory environments
brew "jq"                    # JSON processor
brew "wget"
brew "starship"              # Prompt
brew "git-delta"             # Git diff pager
brew "lazygit"               # Git TUI
brew "btop"                  # Process monitor
brew "fastfetch"             # System info
brew "tealdeer"              # tldr pages

# Dev
brew "fnm"                   # Node version manager
brew "pnpm"                  # Package manager + global installs
brew "bun"
brew "uv"                    # Python versions + packages

# Containers (colima = Docker Desktop replacement)
brew "colima"
brew "docker"
brew "docker-compose"
brew "docker-buildx"

if OS.mac?
  cask "cmux"
  cask "raycast"
  cask "claude-code"
  cask "font-jetbrains-mono-nerd-font"   # Icons in prompt + eza; set as terminal font
end
