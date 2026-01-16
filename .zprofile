# =============================================================================
# ZSH Profile - Loaded once at login
# =============================================================================

# Homebrew shell environment
eval "$(/opt/homebrew/bin/brew shellenv)"

# Python paths (if installed via system)
[[ -d "/Library/Frameworks/Python.framework/Versions/3.12/bin" ]] && \
    export PATH="/Library/Frameworks/Python.framework/Versions/3.12/bin:$PATH"
