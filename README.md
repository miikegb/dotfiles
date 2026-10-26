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
| theme      | `~/.local/bin/theme`, `~/.config/theme/themes/` (theme switcher, see below) |
| zsh        | `~/.zshrc`, `~/.zprofile`, `~/.zsh_aliases` (+ untracked `~/.zsh_aliases.local` and `~/.zshrc.local` for machine-specific config); inits `zoxide` (`z`/`zi`) when installed |

## Setup on a new machine

```bash
# Install stow
brew install stow    # macOS
# apt install stow   # Debian/Ubuntu

# Clone and stow
git clone https://github.com/miikegb/dotfiles.git ~/dotfiles
cd ~/dotfiles
stow nvim tmux ghostty yazi zellij herdr starship zsh theme    # skip aerospace on Linux if not needed
```

### Post-install

- **tmux plugins**: Open tmux and press `prefix + I` to install plugins via TPM
- **yazi flavors**: Run `ya pkg install` to install the flavors listed in `package.toml`
- **zellij**: The first Ctrl+h/j/k/l press asks to allow the `vim-zellij-navigator` plugin — accept it
- **zsh**: `~/.zshrc` expects these from Homebrew: `brew install fzf starship zoxide zsh-autosuggestions zsh-syntax-highlighting`

## Switching themes

`theme` changes the color theme of every tool at once: ghostty, nvim, herdr,
zellij, yazi, starship, tmux, fzf and VS Code (when its settings file exists).

```bash
theme                 # fzf picker with a preview of each theme
theme gruvbox-dark    # apply by name
theme list            # available themes, current one marked
theme -n one-dark     # dry run: show what would change
```

It edits the tracked config files in place (through the stow symlinks), so the
switch shows up in `git diff` and can be committed or reverted. Running tools
are reloaded where possible (herdr, tmux, open nvim instances); Ghostty needs
`⌘⇧,` and fzf picks up the new colors in the next shell.

Themes are INI files in `theme/.config/theme/themes/`. Each section names a
tool and holds that tool's theme identifier; leave a section out to skip the
tool for that theme. To add a theme, copy an existing file and fill in the
names each tool uses.
