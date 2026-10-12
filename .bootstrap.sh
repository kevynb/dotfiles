#!/bin/bash
set -euo pipefail

if [[ "$(uname -s)" != Darwin ]]; then
    echo "This bootstrap script supports macOS only." >&2
    exit 1
fi

# Find Homebrew even when a fresh shell has not loaded its environment yet.
brew_bin="$(command -v brew || true)"
if [[ -z "$brew_bin" ]]; then
    for candidate in /opt/homebrew/bin/brew /usr/local/bin/brew; do
        if [[ -x "$candidate" ]]; then
            brew_bin="$candidate"
            break
        fi
    done
fi

if [[ -z "$brew_bin" ]]; then
    installer="$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    /bin/bash -c "$installer"
    case "$(uname -m)" in
        arm64) brew_bin=/opt/homebrew/bin/brew ;;
        *) brew_bin=/usr/local/bin/brew ;;
    esac
fi

brew_env="$("$brew_bin" shellenv)"
eval "$brew_env"

if ! command -v chezmoi >/dev/null 2>&1; then
    "$brew_bin" install chezmoi
fi

# Configuration prompts happen here, after Homebrew is available.
exec chezmoi init --apply https://github.com/kevynb/dotfiles.git "$@"
