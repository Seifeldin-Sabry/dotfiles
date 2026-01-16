# =============================================================================
# ZSH Configuration - Optimized for speed and productivity
# =============================================================================

# -----------------------------------------------------------------------------
# Homebrew (static to avoid eval overhead)
# -----------------------------------------------------------------------------
export HOMEBREW_PREFIX="/opt/homebrew"
export HOMEBREW_CELLAR="/opt/homebrew/Cellar"
export HOMEBREW_REPOSITORY="/opt/homebrew"
export PATH="/opt/homebrew/bin:/opt/homebrew/sbin${PATH+:$PATH}"
export MANPATH="/opt/homebrew/share/man${MANPATH+:$MANPATH}:"
export INFOPATH="/opt/homebrew/share/info:${INFOPATH:-}"

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
    eval "$(fnm env --use-on-cd)"
fi

# zoxide - Smart cd
if command -v zoxide &> /dev/null; then
    eval "$(zoxide init zsh)"
fi

# pyenv - Python version manager (lazy loaded)
export PYENV_ROOT="$HOME/.pyenv"
export PATH="$PYENV_ROOT/bin:$PATH"
if command -v pyenv &> /dev/null; then
    eval "$(pyenv init --path)"
    # Defer full init for faster startup
    pyenv() {
        unfunction pyenv
        eval "$(command pyenv init -)"
        pyenv "$@"
    }
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

# fzf - Fuzzy finder (handled by zinit OMZP::fzf or manual setup)
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

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
command -v eza &> /dev/null && alias ls="eza" && alias ll="eza -l" && alias la="eza -la" && alias lt="eza --tree"
command -v fd &> /dev/null && alias find="fd"

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
# Prompt
# -----------------------------------------------------------------------------
autoload -Uz vcs_info
precmd() { vcs_info }
zstyle ':vcs_info:git:*' formats '%b'
setopt PROMPT_SUBST
PROMPT='%F{cyan}%~%f %F{yellow}${vcs_info_msg_0_}%f
%F{green}→%f '

# -----------------------------------------------------------------------------
# Additional PATH entries
# -----------------------------------------------------------------------------
export PATH="$HOME/.local/bin:$PATH"
export PATH="$HOME/Library/pnpm:$PATH"

# pnpm
export PNPM_HOME="$HOME/Library/pnpm"
case ":$PATH:" in
  *":$PNPM_HOME:"*) ;;
  *) export PATH="$PNPM_HOME:$PATH" ;;
esac

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
