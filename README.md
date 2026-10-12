## Overview

Welcome to my dotfiles repository! This repository contains configuration files and scripts tailored to my preferences, allowing me to maintain a consistent environment across different machines.

### Chezmoi
This repo uses [Chezmoi](https://www.chezmoi.io) ([Github](https://github.com/twpayne/chezmoi)) which is a dotfile manager that helps users manage their configuration files (dotfiles) across different machines. It allows you to version control your configuration files, synchronize them across multiple devices, and easily apply changes.
 
## Contents

1. **dot_emacs.d:** Emacs configuration files and settings.
2. **dot_gitconfig.tmpl:** Git configuration file template.
3. **dot_gitignore_global:** Global Git ignore rules.
4. **dot_zshrc:** Zsh configuration file.
5. **private_dot_config:** Directory for private configuration files.
6. **private_Library:** Directory for private scripts or tools.
7. **run_onchange_darwin-install-packages.sh.tmpl:** Template script for installing packages on macOS.

## Getting Started

1. **Bootstrap a new Mac:**

   ```bash
   bootstrap="$(curl -fsSL https://raw.githubusercontent.com/kevynb/dotfiles/main/.bootstrap.sh)" && /bin/bash -c "$bootstrap"
   ```

   The script installs Homebrew if missing, loads its shell environment, and
   installs chezmoi if needed. It then initializes this repository, asks for your
   Git email and whether the machine is `personal` or `work`, and installs the
   base packages plus the selected profile. Existing Homebrew installations are
   reused, including installations that are not yet in `PATH`.

   If you already cloned the repository, run `/bin/bash .bootstrap.sh` from its
   root. Homebrew's installer may ask for your administrator password.

   To initialize and preview changes before applying them:

   ```bash
   bootstrap="$(curl -fsSL https://raw.githubusercontent.com/kevynb/dotfiles/main/.bootstrap.sh)" && /bin/bash -c "$bootstrap" -- --apply=false
   chezmoi diff
   chezmoi apply --dry-run --verbose
   chezmoi apply
   ```

   `--apply=false` still installs Homebrew and chezmoi if missing and saves
   your configuration, but leaves applying dotfiles and packages to you.
   On an already provisioned Mac, you can instead run `chezmoi init kevynb`, inspect `chezmoi diff`, and
   run `chezmoi apply` when ready.

2. **Customization:**
   - Adjust configurations in individual dotfiles.
   - Add private configurations to the `private_dot_config` directory.

3. **Synchronize Changes:**
   ```bash
   chezmoi cd
   git add -A
   git commit -m "chore(dotfiles): update configuration"
   git push
   ```

## Purpose

This dotfiles repository serves the following purposes:

- **Configuration Management:** Maintain a version-controlled history of personalized configurations for various tools and applications.
  
- **Portability:** Easily replicate the same development environment across different machines.

- **Consistency:** Ensure a consistent and efficient workflow by centralizing and managing configuration files.

## Howto use Chezmoi

### 1. **Adding a new File:**

 - Add a new configuration file to chezmoi and track it:
    ```bash
    chezmoi add ~/.config/newfile
    ```

### 2. **Adding a new Template file:**

 - Create a new template file in chezmoi for dynamic configuration:
 ```bash
 chezmoi add --template ~/.gitconfig
 ```

### 3. **Editing Configuration Files:**

- To edit a configuration file, simply open it using chezmoi. For example, to edit the Zsh configuration:
  ```bash
  chezmoi ~/.zshrc
  ```

### 4. **Viewing Diffs:**

- Check for differences between your local configuration and the tracked version using:
  ```bash
  chezmoi diff
  ```

### 5. **Applying Changes:**

- After editing, apply the changes to your dotfiles repository:
  ```bash
  chezmoi apply
  ```

### 6. **Updating Dotfiles:**

- Fetch the latest changes from the dotfiles repository and apply them:
  ```bash
  chezmoi update
  ```

### 7. **Pulling the latest changes without applying changes**
 - Pull the latest changes from your repo and see what would change, without actually applying the changes
 ```bash
 chezmoi git pull -- --autostash --rebase && chezmoi diff
 ```


### 8. **Ignoring Local Changes:**

- Temporarily ignore local changes to a specific file:
  ```bash
  chezmoi forget ~/.zshrc
  ```


## Configuration tidbits

### Machine specific variables

If you need to have machine-specific configuration, you can add variables in `.chezmoi.toml.tmpl`.
They will then be used in your templated files.
`promptStringOnce` and `promptChoiceOnce` ask for values that are not already
saved in your local `~/.config/chezmoi/chezmoi.toml`. The `email` and
`machineType` values are stored under `[data]`; the machine profile is local
to each machine, not committed to this repository.

On an existing machine, run `chezmoi init` once after updating this repository
to select a profile. Subsequent initialization reuses the saved choice.
To switch profiles, run `chezmoi edit-config`, change `data.machineType` to
`"personal"` or `"work"`, then preview with `chezmoi diff` and run
`chezmoi apply`. Missing or invalid profiles stop package template rendering.

### Installing packages on MacOS with Brew

The script `run_onchange_darwin-install-packages.sh.tmpl` reads
`.chezmoidata/packages.yaml` and renders one Brewfile using `packages.darwin.base`
plus either `packages.darwin.personal` or `packages.darwin.work`. Each set can
contain `brew_taps`, `brews`, `casks`, and `mas` entries; duplicates are removed.

- **Base:** shared tools and apps from the existing package list.
- **Personal:** `orcaslicer` and `wireshark-app`.
- **Work:** `aws-vpn-client`.

Homebrew must already be installed; use `.bootstrap.sh` on a new Mac. The package
script loads Homebrew's environment itself, without depending on `.zshrc`.
App Store entries may require signing in to the App Store first.

chezmoi runs the package script when its rendered contents change, including
changes to the selected package set. Changes confined to another profile do
not trigger it. Installation is additive: removing an entry or switching
profiles does not uninstall existing apps. No `brew bundle cleanup` is run.

This follows chezmoi's [declarative package installation recipe](https://www.chezmoi.io/user-guide/advanced/install-packages-declaratively/)
and uses [promptChoiceOnce](https://www.chezmoi.io/reference/templates/init-functions/promptChoiceOnce/)
to remember the machine profile.
