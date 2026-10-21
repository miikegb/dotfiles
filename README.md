# dotfiles

Config files managed with [GNU Stow](https://www.gnu.org/software/stow/).

## Packages

| Package    | Target              |
|------------|---------------------|
| nvim       | `~/.config/nvim`    |
| tmux       | `~/.config/tmux`    |
| ghostty    | `~/.config/ghostty` |
| aerospace  | `~/.config/aerospace` |
| yazi       | `~/.config/yazi`    |
| zellij     | `~/.config/zellij`  |
| starship   | `~/.config/starship.toml` |
| zsh        | `~/.zshrc`, `~/.zprofile`, `~/.zsh_aliases` (+ untracked `~/.zsh_aliases.local` and `~/.zshrc.local` for machine-specific config); inits `zoxide` (`z`/`zi`) when installed |

## Setup on a new machine

```bash
# Install stow
brew install stow    # macOS
# apt install stow   # Debian/Ubuntu

# Clone and stow
git clone https://github.com/miikegb/dotfiles.git ~/dotfiles
cd ~/dotfiles
stow nvim tmux ghostty yazi zellij herdr starship zsh    # skip aerospace on Linux if not needed
```

### Post-install

- **tmux plugins**: Open tmux and press `prefix + I` to install plugins via TPM
- **yazi flavors**: Run `ya pkg install` to install the flavors listed in `package.toml`
- **zellij**: The first Ctrl+h/j/k/l press asks to allow the `vim-zellij-navigator` plugin — accept it
- **zsh**: `~/.zshrc` expects these from Homebrew: `brew install fzf starship zoxide zsh-autosuggestions zsh-syntax-highlighting`
