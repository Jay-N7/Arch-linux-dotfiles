# ~/.bashrc
# If not running interactively, don't do anything
[[ $- != *i* ]] && return

alias ls='ls --color=auto'
alias grep='grep --color=auto'


# Set the > symbol 
#PS1='[\W]\$ '
# PS1='❯ '

export GTK_ICON_THEME=Papirus
#[[ -f "$HOME/.cache/wal/colors.sh" ]] && source "$HOME/.cache/wal/colors.sh"
#[[ -f "$HOME/.cache/wal/sequences" ]] && cat "$HOME/.cache/wal/sequences"

# Starship
eval "$(starship init bash)" 


export SWAPPY_DIR="$HOME/Desktop/Screenshots"


# alias list
alias conda-activate='. ~/Downloads/miniconda3/bin/activate'
alias getmp3='~/scripts/getmp3.sh'
alias pls=sudo
alias hc='nvim ~/.config/hypr/hyprland.lua'
alias s='sudo pacman -S'
alias update='sudo ~/scripts/update_safely.sh'
alias nv=nvim
alias taildrop=' ~/./scripts/taildrop.sh' 
alias nfz="~/scripts/open_preview_fzf.sh"
alias v.="nvim ."
alias ll="exa -l --icons --group-directories-first"
alias hw="hyprctl dispatch workspace"
alias r="ranger"
alias update-dotfiles="~/scripts/update_arch_repo.sh"
alias cal="khal calendar"
alias v="vim"
alias bat='upower -i $(upower -e | grep BAT) | grep -E "state|percentage|energy-rate|time to"'
y() {
    local tmp="$(mktemp -t "yazi-cwd.XXXXXX")" cwd
    yazi "$@" --cwd-file="$tmp"
    IFS= read -r -d '' cwd < "$tmp"
    [ -n "$cwd" ] && [ "$cwd" != "$PWD" ] && builtin cd -- "$cwd"
    rm -f -- "$tmp"
}
# >>> conda initialize >>>
# !! Contents within this block are managed by 'conda init' !!
#__conda_setup="$('/home/archer/Downloads/miniconda3/bin/conda' 'shell.bash' 'hook' 2> /dev/null)"
#if [ $? -eq 0 ]; then
#    eval "$__conda_setup"
#else
#    if [ -f "/home/archer/Downloads/miniconda3/etc/profile.d/conda.sh" ]; then
#        . "/home/archer/Downloads/miniconda3/etc/profile.d/conda.sh"
#    else
#        export PATH="/home/archer/Downloads/miniconda3/bin:$PATH"
#    fi
#fi
#unset __conda_setup
# <<< conda initialize <<<

export PATH="$HOME/.local/bin:$PATH"
export EDITOR=nvim VISUAL=nvim
