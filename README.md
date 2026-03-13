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

## Setup on a new machine

```bash
# Install stow
brew install stow    # macOS
# apt install stow   # Debian/Ubuntu

# Clone and stow
git clone https://github.com/miikegb/dotfiles.git ~/dotfiles
cd ~/dotfiles
stow nvim tmux ghostty yazi    # skip aerospace on Linux if not needed
```
