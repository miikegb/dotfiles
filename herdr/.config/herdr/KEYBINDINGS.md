# herdr keybindings

Prefix: `Ctrl+Space`. `prefix x` means press the prefix, release, then `x`.
Custom bindings follow tmux/zellij habits; the rest are herdr defaults. Source: `config.toml` next to this file.

## Moving between panes

| Key | Action |
|---|---|
| `Ctrl+h/j/k/l` | Move left/down/up/right; inside nvim, moves between splits first, then into the next herdr pane |
| `Alt+h/j/k/l` | Move to the next herdr pane directly (doesn't check for nvim) |
| `prefix ←/↓/↑/→` | Move to the next pane |
| `prefix ;` | Go back to the last pane |
| `prefix Tab` / `prefix Shift+Tab` | Cycle to the next/previous pane |

`Ctrl+h/j/k/l` needs smart-splits.nvim's herdr plugin, linked once:
`herdr plugin link ~/.local/share/nvim/lazy/smart-splits.nvim`

## Resizing panes

| Key | Action |
|---|---|
| `prefix h/j/k/l` | Resize one step (tmux style) |
| `Alt+Shift+h/j/k/l` | Resize without the prefix |
| `prefix r` | Resize mode: press h/j/k/l repeatedly |

## Moving panes

| Key | Action |
|---|---|
| `prefix Shift+h/j/k/l` | Swap the pane with its neighbour in that direction |

## Splitting, zooming and closing

| Key | Action |
|---|---|
| `prefix \|` or `prefix v` | Split side by side |
| `prefix -` | Split top/bottom |
| `prefix m` / `z` / `f` | Toggle zoom |
| `prefix x` | Close the pane |
| `prefix Shift+p` | Rename the pane |

## Tabs

| Key | Action |
|---|---|
| `prefix c` | New tab |
| `prefix n` / `prefix p` | Next/previous tab |
| `prefix 1`–`9` | Go to tab N |
| `Alt+i` / `Alt+o` | Move the tab left/right |
| `prefix Shift+t` | Rename the tab |
| `prefix Shift+x` | Close the tab |

## Workspaces and sessions

| Key | Action |
|---|---|
| `prefix w` | Workspace picker |
| `prefix g` | Goto |
| `prefix Shift+n` | New workspace |
| `prefix Shift+w` | Rename the workspace |
| `prefix Shift+d` | Close the workspace |
| `prefix b` | Show/hide the sidebar |
| `prefix q` | Detach |

In navigate mode, `h/j/k/l` move between panes and `↑/↓` move between workspaces.

## Other

| Key | Action |
|---|---|
| `prefix ?` | Help |
| `prefix s` | Settings |
| `prefix e` | Edit scrollback in `$EDITOR` |
| `prefix Shift+r` | Reload config |
