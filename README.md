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

1. There is 2 ways to install this
    1. **Bootstrap automatically:**

    ```bash
    sh -c "$(curl -fsLS get.chezmoi.io)" -- init --apply kevynb
    ```
    2. **Clone the Repository and install manually:**

     ```bash
     git clone https://github.com/kevynb/dotfiles
     cd dotfiles
     chezmoi init --apply kevynb
     ```

2. **Customization:**
   - Adjust configurations in individual dotfiles.
   - Add private configurations to the `private_dot_config` directory.

3. **Synchronize Changes:**
   ```bash
   chezmoi cd
   git add -A
   git commit -m "My changes"
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
If you use the special keyword `promptStringOnce` you will be prompted what value to use when initializing the repo for the first time.
If you want to update it in the future, run `chezmoi init` again or edit `~/.local/share/chezmoi/.chezmoi.toml.tmpl`.
