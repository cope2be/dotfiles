[[ ! -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]] || source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"

ZSH_CACHE_DIR="$XDG_CACHE_HOME/zsh"
mkdir -p "$ZSH_CACHE_DIR"

HISTFILE="$ZSH_CACHE_DIR/.zhist"
SAVEHIST=1000
HISTSIZE=1000

source "$ZDOTDIR/zaliases.zsh"

source $(brew --prefix)/share/powerlevel10k/powerlevel10k.zsh-theme

source $(brew --prefix)/share/zsh-autosuggestions/zsh-autosuggestions.zsh
source $(brew --prefix)/share/zsh-history-substring-search/zsh-history-substring-search.zsh
source $(brew --prefix)/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

bindkey -v

bindkey "^a" beginning-of-line
bindkey "^d" end-of-line

bindkey "^w" backward-kill-word
bindkey "^x" backward-delete-char

bindkey '^[[A' history-substring-search-up
bindkey '^[[B' history-substring-search-down

setopt appendhistory
setopt sharehistory

setopt hist_ignore_space
setopt hist_ignore_all_dups
setopt hist_save_no_dups
setopt hist_ignore_dups
setopt hist_find_no_dups

export FZF_DEFAULT_OPTS="
  --color=fg:#908caa,bg:#232136,hl:#ea9a97
  --color=fg+:#e0def4,bg+:#393552,hl+:#ea9a97
  --color=border:#44415a,header:#3e8fb0,gutter:#232136
  --color=spinner:#f6c177,info:#9ccfd8
  --color=pointer:#c4a7e7,marker:#eb6f92,prompt:#908caa"

eval "$(zoxide init --cmd cd zsh)"

autoload -Uz compinit
compinit -d "$ZSH_CACHE_DIR/.zcompdump-${ZSH_VERSION}"

zstyle ":completion:*" use-cache yes
zstyle ":completion:*" cache-path $ZSH_CACHE_DIR

zstyle ":completion:*" matcher-list "m:{a-z}={A-Za-z}"

[[ ! -f $ZDOTDIR/.p10k.zsh ]] || source $ZDOTDIR/.p10k.zsh
