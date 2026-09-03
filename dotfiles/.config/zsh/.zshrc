# -----------------------------------------------------------------------------
# Core
# -----------------------------------------------------------------------------

[[ -o interactive ]] || return

typeset -gi ZSH_RICE_FIRST_SHELL=0
if [[ -z ${ZSH_RICE_ACTIVE:-} ]]; then
    export ZSH_RICE_ACTIVE=1
    ZSH_RICE_FIRST_SHELL=1
fi

typeset -g ZSH_CACHE_DIR="${XDG_CACHE_HOME:-$HOME/.cache}/zsh"
typeset -g ZSH_STATE_DIR="${XDG_STATE_HOME:-$HOME/.local/state}/zsh"
[[ -d $ZSH_CACHE_DIR ]] || mkdir -p -- "$ZSH_CACHE_DIR"
[[ -d $ZSH_STATE_DIR ]] || mkdir -p -- "$ZSH_STATE_DIR"

export EDITOR=nvim
export VISUAL=nvim
export PAGER=less
export LESS='-R -F -X'
export BAT_THEME=ansi
export GIT_PAGER=delta
export MANROFFOPT='-c'
export MANPAGER="sh -c 'col -bx | bat --language man --plain'"

setopt AUTO_CD
setopt AUTO_PUSHD
setopt PUSHD_IGNORE_DUPS
setopt PUSHD_SILENT
setopt CD_SILENT
setopt EXTENDED_GLOB
setopt INTERACTIVE_COMMENTS
setopt LONG_LIST_JOBS
setopt NO_BEEP
setopt PIPE_FAIL
setopt RC_QUOTES
setopt RM_STAR_WAIT

# -----------------------------------------------------------------------------
# History
# -----------------------------------------------------------------------------

HISTFILE="$ZSH_STATE_DIR/history"
HISTSIZE=100000
SAVEHIST=100000

setopt APPEND_HISTORY
setopt EXTENDED_HISTORY
setopt HIST_EXPIRE_DUPS_FIRST
setopt HIST_FIND_NO_DUPS
setopt HIST_IGNORE_ALL_DUPS
setopt HIST_IGNORE_SPACE
setopt HIST_REDUCE_BLANKS
setopt HIST_SAVE_NO_DUPS
setopt HIST_VERIFY
setopt SHARE_HISTORY

# -----------------------------------------------------------------------------
# Completion
# -----------------------------------------------------------------------------

fpath=(/usr/share/zsh/site-functions $fpath)
autoload -Uz compinit
zmodload zsh/complist

typeset -g ZSH_COMPDUMP="$ZSH_CACHE_DIR/zcompdump-$ZSH_VERSION"
if [[ -s $ZSH_COMPDUMP ]]; then
    compinit -C -d "$ZSH_COMPDUMP"
else
    compinit -d "$ZSH_COMPDUMP"
fi

zstyle ':completion:*' menu select
zstyle ':completion:*' group-name ''
zstyle ':completion:*' verbose yes
zstyle ':completion:*' use-cache yes
zstyle ':completion:*' cache-path "$ZSH_CACHE_DIR/completion"
zstyle ':completion:*' squeeze-slashes true
zstyle ':completion:*' complete-options true
zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}"
zstyle ':completion:*:descriptions' format '%F{#adc6ff}  󰋽 %d%f'
zstyle ':completion:*:messages' format '%F{#fff872}  󰋼 %d%f'
zstyle ':completion:*:warnings' format '%F{#ff7299}  󰅙 no matches%f'
zstyle ':completion:*' matcher-list \
    'm:{a-zA-Z}={A-Za-z}' \
    'r:|[._-]=* r:|=*' \
    'l:|=* r:|=*'
zstyle ':completion:*:*:kill:*:processes' command \
    'ps -u "$USER" -o pid,user,comm -w -w'

# -----------------------------------------------------------------------------
# Line editor and key bindings
# -----------------------------------------------------------------------------

bindkey -e
KEYTIMEOUT=1
WORDCHARS='*?_-.[]~=&;!#$%^(){}<>'

bindkey '^[[H' beginning-of-line
bindkey '^[[F' end-of-line
bindkey '^[[1;5D' backward-word
bindkey '^[[1;5C' forward-word
bindkey '^[[3~' delete-char
bindkey '^[[Z' reverse-menu-complete
bindkey -M menuselect '^[[Z' reverse-menu-complete
bindkey -M menuselect '^[[A' up-line-or-history
bindkey -M menuselect '^[[B' down-line-or-history
bindkey -M menuselect '^[[D' backward-char
bindkey -M menuselect '^[[C' forward-char

autoload -Uz edit-command-line
zle -N edit-command-line
bindkey '^X^E' edit-command-line

_toggle_sudo() {
    [[ -z $BUFFER ]] && zle up-history
    if [[ $BUFFER == sudo\ * ]]; then
        BUFFER="${BUFFER#sudo }"
        (( CURSOR = CURSOR > 5 ? CURSOR - 5 : 0 ))
    else
        BUFFER="sudo $BUFFER"
        (( CURSOR += 5 ))
    fi
}
zle -N _toggle_sudo
bindkey '\e\e' _toggle_sudo

# -----------------------------------------------------------------------------
# Modern command-line tools
# -----------------------------------------------------------------------------

export FZF_DEFAULT_OPTS="
    --height=45%
    --layout=reverse
    --border=rounded
    --info=inline-right
    --prompt='  '
    --pointer='◆'
    --marker='✓'
    --gutter=' '
    --color=fg:#c4c6d0,fg+:#e2e2e9,bg:#111318,bg+:#1e1f25
    --color=hl:#adc6ff,hl+:#b9ceff,info:#8e9099,marker:#7fff92
    --color=prompt:#debcdf,spinner:#fff872,pointer:#ff7299,border:#44474f
"
export FZF_CTRL_T_OPTS="
    --walker-skip=.git,node_modules,target,.cache
    --preview 'if [ -d {} ]; then eza --tree --level=2 --icons=always --color=always {}; else bat --color=always --style=numbers --line-range=:300 {}; fi'
    --preview-window=right,60%,border-left
"
export FZF_ALT_C_OPTS="
    --walker-skip=.git,node_modules,target,.cache
    --preview 'eza --tree --level=2 --icons=always --color=always {}'
    --preview-window=right,60%,border-left
"
export FZF_CTRL_R_OPTS="
    --preview-window=hidden
    --bind='ctrl-y:execute-silent(echo -n {2..} | wl-copy)+abort'
    --header='CTRL-Y copies the command'
"

_cached_shell_init() {
    local cache_key=$1 executable=$2
    shift 2

    local executable_path=${commands[$executable]}
    local cache_file="$ZSH_CACHE_DIR/init-${cache_key}.zsh"
    local cache_tmp="${cache_file}.tmp.$$"

    if [[ ! -s $cache_file || $executable_path -nt $cache_file ]]; then
        if command "$executable" "$@" >| "$cache_tmp"; then
            command mv -f -- "$cache_tmp" "$cache_file"
        else
            command rm -f -- "$cache_tmp"
            return 1
        fi
    fi

    source "$cache_file"
}

if (( $+commands[fzf] )); then
    _cached_shell_init fzf fzf --zsh
fi

if (( $+commands[zoxide] )); then
    _cached_shell_init zoxide zoxide init zsh
fi

if (( $+commands[direnv] )); then
    _cached_shell_init direnv direnv hook zsh
fi

# -----------------------------------------------------------------------------
# Plugins
# -----------------------------------------------------------------------------

ZSH_AUTOSUGGEST_USE_ASYNC=1
ZSH_AUTOSUGGEST_STRATEGY=(history completion)
ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE='fg=#44474f'
source /usr/share/zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh

HISTORY_SUBSTRING_SEARCH_ENSURE_UNIQUE=1
HISTORY_SUBSTRING_SEARCH_HIGHLIGHT_FOUND='fg=#102f60,bg=#adc6ff,bold'
HISTORY_SUBSTRING_SEARCH_HIGHLIGHT_NOT_FOUND='fg=#111318,bg=#ff7299,bold'
source /usr/share/zsh/plugins/zsh-history-substring-search/zsh-history-substring-search.zsh
bindkey '^[[A' history-substring-search-up
bindkey '^[[B' history-substring-search-down
bindkey '^P' history-substring-search-up
bindkey '^N' history-substring-search-down

# -----------------------------------------------------------------------------
# Quality-of-life functions and aliases
# -----------------------------------------------------------------------------

mkcd() {
    if (( $# != 1 )); then
        print -u2 'usage: mkcd <directory>'
        return 2
    fi
    command mkdir -p -- "$1" && builtin cd -- "$1"
}

autoload -Uz run-help
unalias run-help 2>/dev/null
alias help='run-help'

alias ls='eza --icons=auto --color=auto --group-directories-first'
alias l='eza --icons=auto --color=auto --group-directories-first'
alias ll='eza --long --all --header --git --icons=auto --color=auto --group-directories-first'
alias la='eza --all --icons=auto --color=auto --group-directories-first'
alias lt='eza --tree --level=2 --icons=auto --color=auto --group-directories-first'
alias tree='eza --tree --icons=auto --color=auto --group-directories-first'
alias cat='bat --paging=never --style=plain'
alias diff='delta'
alias grep='grep --color=auto'
alias ip='ip --color=auto'
alias c='clear'
alias cls='clear'
alias v='nvim'
alias vi='nvim'
alias vim='nvim'
alias ff='fastfetch'
alias update='yay -Syu'
alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'

alias g='git'
alias gs='git status --short --branch'
alias ga='git add'
alias gc='git commit'
alias gco='git checkout'
alias gd='git diff'
alias gl='git log --graph --decorate --pretty=oneline --abbrev-commit'
alias gp='git push'
alias gpl='git pull --rebase'

# -----------------------------------------------------------------------------
# Prompt and greeting
# -----------------------------------------------------------------------------

if (( $+commands[starship] )); then
    _cached_shell_init starship starship init zsh
fi

unfunction _cached_shell_init 2>/dev/null

if (( ZSH_RICE_FIRST_SHELL )) &&
   [[ -t 1 && -z ${SSH_CONNECTION:-} ]] &&
   (( $+commands[fastfetch] )); then
    fastfetch --config "${XDG_CONFIG_HOME:-$HOME/.config}/fastfetch/nike.jsonc"
fi

# Syntax highlighting must be sourced after every widget has been created.
ZSH_HIGHLIGHT_HIGHLIGHTERS=(main brackets)
typeset -gA ZSH_HIGHLIGHT_STYLES
ZSH_HIGHLIGHT_STYLES[command]='fg=#7fff92,bold'
ZSH_HIGHLIGHT_STYLES[alias]='fg=#7fff92,bold'
ZSH_HIGHLIGHT_STYLES[builtin]='fg=#7fff92'
ZSH_HIGHLIGHT_STYLES[function]='fg=#7fff92'
ZSH_HIGHLIGHT_STYLES[reserved-word]='fg=#debcdf,bold'
ZSH_HIGHLIGHT_STYLES[suffix-alias]='fg=#7fff92'
ZSH_HIGHLIGHT_STYLES[precommand]='fg=#debcdf,underline'
ZSH_HIGHLIGHT_STYLES[unknown-token]='fg=#ff7299,bold'
ZSH_HIGHLIGHT_STYLES[path]='fg=#adc6ff,underline'
ZSH_HIGHLIGHT_STYLES[path_pathseparator]='fg=#8e9099'
ZSH_HIGHLIGHT_STYLES[globbing]='fg=#debcdf'
ZSH_HIGHLIGHT_STYLES[single-hyphen-option]='fg=#fff872'
ZSH_HIGHLIGHT_STYLES[double-hyphen-option]='fg=#fff872'
ZSH_HIGHLIGHT_STYLES[single-quoted-argument]='fg=#b9ceff'
ZSH_HIGHLIGHT_STYLES[double-quoted-argument]='fg=#b9ceff'
ZSH_HIGHLIGHT_STYLES[dollar-quoted-argument]='fg=#b9ceff'
ZSH_HIGHLIGHT_STYLES[comment]='fg=#8e9099,italic'
ZSH_HIGHLIGHT_STYLES[redirection]='fg=#debcdf'
ZSH_HIGHLIGHT_STYLES[bracket-level-1]='fg=#adc6ff,bold'
ZSH_HIGHLIGHT_STYLES[bracket-level-2]='fg=#debcdf,bold'
ZSH_HIGHLIGHT_STYLES[bracket-level-3]='fg=#fff872,bold'
source /usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
