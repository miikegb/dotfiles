# --- fzf ---
# Rose Pine (main) colors, matching the Ghostty, Zellij and starship themes
export FZF_DEFAULT_OPTS="
  --color=fg:#908caa,bg:#191724,hl:#ebbcba
  --color=fg+:#e0def4,bg+:#26233a,hl+:#ebbcba
  --color=border:#403d52,header:#31748f,gutter:#191724
  --color=spinner:#f6c177,info:#9ccfd8
  --color=pointer:#c4a7e7,marker:#eb6f92,prompt:#908caa"
# Key bindings (ctrl-r, ctrl-t, alt-c) and fuzzy completion
source <(fzf --zsh)

export PATH="$HOME/.local/bin:$PATH"

# --- Completions ---
if type brew &>/dev/null; then
  FPATH="$(brew --prefix)/share/zsh-completions:$(brew --prefix)/share/zsh/site-functions:$FPATH"
fi
autoload -Uz compinit && compinit

# Nicer completion behavior
zstyle ':completion:*' menu select                  # arrow-key menu
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Z}' # case-insensitive

source "$(brew --prefix)/share/zsh-autosuggestions/zsh-autosuggestions.zsh"

# --- zoxide (z / zi) ---
command -v zoxide >/dev/null && eval "$(zoxide init zsh)"

# --- Aliases ---
[[ -f ~/.zsh_aliases ]] && source ~/.zsh_aliases
# Machine-specific aliases live outside the dotfiles repo and are picked up if present
[[ -f ~/.zsh_aliases.local ]] && source ~/.zsh_aliases.local

# --- Prompt ---
eval "$(starship init zsh)"

# Blank line between prompts, except before the first one in a new terminal
# and right after `clear` (aliases that expand to clear count too).
_prompt_blank_line_preexec() { local -a w; w=(${(z)2}); _prompt_last_cmd=$w[1] }
_prompt_blank_line() {
  if (( _prompt_seen )) && [[ $_prompt_last_cmd != clear ]]; then
    print
  fi
  _prompt_seen=1
  _prompt_last_cmd=
}
(( ${preexec_functions[(I)_prompt_blank_line_preexec]} )) || preexec_functions+=(_prompt_blank_line_preexec)
(( ${precmd_functions[(I)_prompt_blank_line]} )) || precmd_functions+=(_prompt_blank_line)

# --- Machine-specific config ---
# Not tracked in the dotfiles repo. Sourced late so it can override anything
# above and register completions (compinit has already run).
[[ -f ~/.zshrc.local ]] && source ~/.zshrc.local

# --- Syntax highlighting (keep at the very end) ---
source "$(brew --prefix)/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh"

# --- Conda (only if installed) ---
if [ -d "$HOME/miniconda3" ]; then
# >>> conda initialize >>>
# !! Contents within this block are managed by 'conda init' !!
__conda_setup="$("$HOME/miniconda3/bin/conda" 'shell.zsh' 'hook' 2> /dev/null)"
if [ $? -eq 0 ]; then
    eval "$__conda_setup"
else
    if [ -f "$HOME/miniconda3/etc/profile.d/conda.sh" ]; then
        . "$HOME/miniconda3/etc/profile.d/conda.sh"
    else
        export PATH="$HOME/miniconda3/bin:$PATH"
    fi
fi
unset __conda_setup
# <<< conda initialize <<<
fi

