# Dotfiles

Minimal, fast macOS development environment.

## Quick Install

```bash
curl -fsSL https://raw.githubusercontent.com/Seifeldin-Sabry/dotfiles/main/install.sh | bash
```

Or manually:
```bash
git clone git@github.com:Seifeldin-Sabry/dotfiles.git ~/dotfiles
cd ~/dotfiles && ./install.sh
```

## What's Included

### Shell (Zinit + Turbo Mode)
- **Fast startup**: ~100ms vs ~1.8s before
- **Syntax highlighting**: Real-time command validation
- **Autosuggestions**: Fish-like history suggestions
- **Smart completions**: fzf-tab for fuzzy matching

### Productivity Plugins
- **zoxide**: Smart `cd` - type `z proj` to jump to `~/projects`
- **forgit**: Interactive git with fzf previews
- **you-should-use**: Reminds you of aliases you forgot

### Modern CLI Tools
| Tool | Replaces | Purpose |
|------|----------|---------|
| bat | cat | Syntax highlighting |
| eza | ls | Better file listing |
| fd | find | Faster file search |
| ripgrep | grep | Faster text search |
| fzf | - | Fuzzy finder |

### Dev Tools
- **fnm**: Fast Node Manager (replaces nvm)
- **pyenv**: Python version manager
- **direnv**: Directory-level environments
- **Docker**: Container runtime

## Files

```
~/dotfiles/
├── .zshrc        # Main shell config
├── .zprofile     # Login shell config
├── .gitconfig    # Git configuration
├── Brewfile      # Homebrew packages
├── install.sh    # Installation script
└── README.md
```

## Key Bindings

- `Ctrl+R` - Fuzzy history search
- `Ctrl+T` - Fuzzy file finder
- `Alt+C` - Fuzzy cd
- `Tab` - Fuzzy completion

## Git Aliases

```bash
gst   # git status
gco   # git checkout
gcb   # git checkout -b
gp    # git push
gl    # git pull
gd    # git diff
gcm   # git commit -m
glog  # git log --oneline --graph
```

## Customization

Add local customizations in `~/.zshrc.local` (not tracked):
```bash
# Custom aliases
alias myproject="cd ~/work/myproject"
```
