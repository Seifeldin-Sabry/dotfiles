# Dotfiles

Minimal, fast dev environment for macOS and Linux.

## Install

```bash
curl -fsSL https://raw.githubusercontent.com/Seifeldin-Sabry/dotfiles/main/install.sh | bash
```

Or manually:
```bash
git clone https://github.com/Seifeldin-Sabry/dotfiles.git ~/dotfiles
~/dotfiles/install.sh
```

Then `gh auth login` (git uses `gh` for GitHub credentials).

Safe to re-run. Linux: Debian/Ubuntu prerequisites via apt, then Homebrew.

## Node & packages

| Tool | Role |
|------|------|
| fnm | Node versions. Default = latest LTS. Auto-switches on `cd` via `.nvmrc` / `.node-version` / `engines.node` |
| pnpm | Project installs **and** the only global installer |
| npm | Projects only. `npm -g` is blocked by a shell wrapper |

Why: npm globals live inside one Node version and vanish when you switch.
pnpm globals live in `~/.local/share/pnpm`, independent of Node version.

Add a global: `pnpm add -g <pkg>`, then add it to `PNPM_GLOBALS` in `install.sh`.

## Files

```
~/dotfiles/
├── .zshrc        # Shell config (zinit, aliases, fnm, pnpm)
├── .zprofile     # Homebrew env (macOS + Linux)
├── .gitconfig    # Git config (delta pager, gh credentials)
├── .config/starship.toml
├── .config/ghostty/config  # Terminal font + theme (Ghostty, cmux)
├── Brewfile      # Essential packages only (hand-curated)
└── install.sh    # Bootstrap
```

## Shell

- Zinit turbo mode, fast startup
- Syntax highlighting, autosuggestions, fzf-tab completion
- zoxide (`z proj`, `cdi` interactive), forgit, you-should-use
- bat / eza replace cat / ls (eza with icons + git status)
- starship prompt (Catppuccin Powerline), Catppuccin Mocha across bat, delta, fzf
- delta git diffs (side-by-side), `lg` lazygit, `btop`, `ff` fastfetch, `tldr <cmd>`

Keys: `Ctrl+R` history, `Ctrl+T` files, `Alt+C` cd, `Tab` fuzzy complete.

Terminal (Ghostty / cmux): `.config/ghostty/config` sets JetBrainsMono Nerd Font + Catppuccin Mocha. Other terminals: set that font manually for icons.

## Local overrides (not tracked)

- `~/.zshrc.local` — machine-specific shell config
- `~/.gitconfig.local` — machine-specific git config (e.g. work email)
