# =============================================================================
# ZSH Configuration - Optimized for speed and productivity
# =============================================================================

# -----------------------------------------------------------------------------
# Homebrew (set in .zprofile; Linux terminals often skip login shells)
# -----------------------------------------------------------------------------
[[ -z $HOMEBREW_PREFIX ]] && source ~/.zprofile

# -----------------------------------------------------------------------------
# Zinit Plugin Manager
# -----------------------------------------------------------------------------
ZINIT_HOME="${XDG_DATA_HOME:-${HOME}/.local/share}/zinit/zinit.git"
if [[ ! -f $ZINIT_HOME/zinit.zsh ]]; then
    print -P "%F{33}Installing Zinit...%f"
    command mkdir -p "$(dirname $ZINIT_HOME)"
    command git clone https://github.com/zdharma-continuum/zinit.git "$ZINIT_HOME"
fi
source "${ZINIT_HOME}/zinit.zsh"

# -----------------------------------------------------------------------------
# Oh-My-Zsh Libraries (lightweight, no full OMZ)
# -----------------------------------------------------------------------------
zinit snippet OMZL::git.zsh
zinit snippet OMZL::history.zsh
zinit snippet OMZL::key-bindings.zsh
zinit snippet OMZL::completion.zsh
zinit snippet OMZL::directories.zsh

# -----------------------------------------------------------------------------
# Completions
# -----------------------------------------------------------------------------
zinit light zsh-users/zsh-completions

# -----------------------------------------------------------------------------
# Turbo Mode Plugins (load in background for instant prompt)
# -----------------------------------------------------------------------------
zinit wait lucid for \
    atinit"zicompinit; zicdreplay" \
    zdharma-continuum/fast-syntax-highlighting \
    atload"_zsh_autosuggest_start" \
    zsh-users/zsh-autosuggestions \
    zsh-users/zsh-history-substring-search \
    MichaelAquilina/zsh-you-should-use \
    wfxr/forgit \
    Aloxaf/fzf-tab

# Oh-My-Zsh plugins via snippets (turbo loaded)
zinit wait lucid for \
    OMZP::git \
    OMZP::docker \
    OMZP::colored-man-pages

# -----------------------------------------------------------------------------
# Tool Initializations
# -----------------------------------------------------------------------------

# fnm - Fast Node Manager
if command -v fnm &> /dev/null; then
    eval "$(fnm env --use-on-cd --version-file-strategy=recursive --shell zsh)"
fi

# pnpm - the only global package installer (globals survive Node switches)
export PNPM_HOME="$HOME/.local/share/pnpm"
export PATH="$PNPM_HOME/bin:$PATH"

# Block npm globals: they live inside one Node version and vanish on switch
npm() {
    if [[ " $* " == *" -g "* || " $* " == *" --global "* ]]; then
        echo "npm global blocked. Use: pnpm add -g <pkg>" >&2
        return 1
    fi
    command npm "$@"
}

# zoxide - Smart cd
if command -v zoxide &> /dev/null; then
    eval "$(zoxide init zsh --cmd z)"
    # Use 'zi' alternative since it conflicts with zinit
    alias cdi='__zoxide_zi'
fi

# direnv - Directory environments
if command -v direnv &> /dev/null; then
    eval "$(direnv hook zsh)"
fi

# thefuck - Command correction (lazy loaded - it's slow)
fuck() {
    eval "$(thefuck --alias)"
    fuck "$@"
}

# fzf - Fuzzy finder (Catppuccin Mocha colors)
command -v fzf &> /dev/null && source <(fzf --zsh)
export FZF_DEFAULT_OPTS=" \
--color=bg+:#313244,spinner:#f5e0dc,hl:#f38ba8 \
--color=fg:#cdd6f4,header:#f38ba8,info:#cba6f7,pointer:#f5e0dc \
--color=marker:#b4befe,fg+:#cdd6f4,prompt:#cba6f7,hl+:#f38ba8 \
--color=selected-bg:#45475a,border:#6c7086"

# bat (and delta) theme
export BAT_THEME="Catppuccin Mocha"

# -----------------------------------------------------------------------------
# History Settings
# -----------------------------------------------------------------------------
HISTSIZE=50000
SAVEHIST=50000
HISTFILE=~/.zsh_history
setopt HIST_IGNORE_ALL_DUPS
setopt HIST_SAVE_NO_DUPS
setopt HIST_REDUCE_BLANKS
setopt INC_APPEND_HISTORY
setopt SHARE_HISTORY

# -----------------------------------------------------------------------------
# Directory Navigation
# -----------------------------------------------------------------------------
setopt AUTO_CD
setopt AUTO_PUSHD
setopt PUSHD_IGNORE_DUPS
setopt PUSHD_SILENT

# -----------------------------------------------------------------------------
# Aliases
# -----------------------------------------------------------------------------

# Quick config edits
alias zshrc='${EDITOR:-vim} ~/.zshrc && source ~/.zshrc'

# Modern CLI replacements (if installed)
command -v bat &> /dev/null && alias cat="bat"
command -v eza &> /dev/null && alias ls="eza --icons" && alias ll="eza -l --icons --git" && alias la="eza -la --icons --git" && alias tree="eza --tree --icons"
alias lg="lazygit"
alias ff="fastfetch"

# Git shortcuts
alias g="git"
alias gst="git status"
alias gco="git checkout"
alias gcb="git checkout -b"
alias gp="git push"
alias gl="git pull"
alias gd="git diff"
alias gds="git diff --staged"
alias gcm="git commit -m"
alias gca="git commit --amend"
alias glog="git log --oneline --graph --decorate -10"

# Docker
alias d="docker"
alias dps="docker ps"
alias dc="docker compose"
alias dcu="docker compose up"
alias dcd="docker compose down"

# Shortcuts
alias c="clear"
alias ..="cd .."
alias ...="cd ../.."
alias ....="cd ../../.."

# -----------------------------------------------------------------------------
# Prompt (config: ~/.config/starship.toml, Catppuccin Powerline preset)
# -----------------------------------------------------------------------------
command -v starship &> /dev/null && eval "$(starship init zsh)"

# -----------------------------------------------------------------------------
# Additional PATH entries
# -----------------------------------------------------------------------------
export PATH="$HOME/.local/bin:$PATH"

# -----------------------------------------------------------------------------
# Optional Integrations (loaded if exist)
# -----------------------------------------------------------------------------

# iTerm2 shell integration
[[ -f ~/.iterm2_shell_integration.zsh ]] && source ~/.iterm2_shell_integration.zsh

# Google Cloud SDK
[[ -f ~/google-cloud-sdk/path.zsh.inc ]] && source ~/google-cloud-sdk/path.zsh.inc
[[ -f ~/google-cloud-sdk/completion.zsh.inc ]] && source ~/google-cloud-sdk/completion.zsh.inc

# JetBrains Toolbox
[[ -d "$HOME/Library/Application Support/JetBrains/Toolbox/scripts" ]] && \
    export PATH="$PATH:$HOME/Library/Application Support/JetBrains/Toolbox/scripts"

# Task Master
command -v task-master &> /dev/null && alias tm='task-master' && alias taskmaster='task-master'

# Machine-specific overrides (not tracked)
[[ -f ~/.zshrc.local ]] && source ~/.zshrc.local
