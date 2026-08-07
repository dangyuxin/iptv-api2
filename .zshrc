# ==================================================
# PATH 环境变量
# ==================================================
export PATH="$HOME/bin:$HOME/.local/bin:/usr/local/bin:$PATH"

# ==================================================
# 历史记录
# ==================================================
HISTFILE="$HOME/.zsh_history"
HISTSIZE=100000
SAVEHIST=100000

setopt APPEND_HISTORY SHARE_HISTORY EXTENDED_HISTORY
setopt HIST_IGNORE_DUPS HIST_IGNORE_SPACE HIST_REDUCE_BLANKS
setopt HIST_FIND_NO_DUPS

# ==================================================
# 基础选项
# ==================================================
autoload -Uz colors && colors
setopt prompt_subst

# ==================================================
# 补全系统
# ==================================================
autoload -Uz compinit
compinit -d ~/.cache/zsh/zcompdump

zstyle ':completion:*' use-cache yes
zstyle ':completion:*' cache-path ~/.cache/zsh
zstyle ':completion:*' menu select
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Z}' 'r:|[._-]=* r:|=*'
zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}"
zstyle ':completion:*:descriptions' format '[%d]'

# ==================================================
# 插件加载（顺序：高亮 → 建议 → fzf‑tab）
# ==================================================
local plugin_dir="/usr/share/zsh/plugins"

source "${plugin_dir}/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh"
source "${plugin_dir}/zsh-autosuggestions/zsh-autosuggestions.zsh"
ZSH_AUTOSUGGEST_STRATEGY=(history completion)
source "${plugin_dir}/fzf-tab/fzf-tab.plugin.zsh"

# ==================================================
# fzf‑tab 配置
# ==================================================
zstyle ':fzf-tab:*' use-fzf-default-opts yes
zstyle ':fzf-tab:*' switch-group '<' '>'
zstyle ':fzf-tab:*' show-group full
zstyle ':fzf-tab:complete:cd:*' fzf-preview 'eza --color=always $realpath'
zstyle ':fzf-tab:complete:cd:*' fzf-list-command 'eza --color=always -1 $realpath'
# ==================================================
# 上下键历史搜索
# ==================================================
autoload -Uz up-line-or-beginning-search down-line-or-beginning-search
zle -N up-line-or-beginning-search
zle -N down-line-or-beginning-search
bindkey '^[[A' up-line-or-beginning-search
bindkey '^[[B' down-line-or-beginning-search

bindkey '^[[1;5C' forward-word
bindkey '^[[1;5D' backward-word
bindkey '^[1;5C' forward-word
bindkey '^[1;5D' backward-word

# ==================================================
# 别名（eza别名极度精简，公共参数交给环境变量）
# ==================================================
alias cl='clear'
alias vi='nvim'
alias vim='nvim'

export EZA_ICONS_AUTO=1
alias ls='eza'
alias ll='eza -lah'
alias la='eza -a'
alias lt='eza --tree'

(( $+commands[bat] )) && alias cat='bat'
(( $+commands[rg] )) && alias grep='rg'

# ==================================================
# Git提示符 OMZ风格：分支 + 红色圆点 • 作为脏标记
# ==================================================
git_prompt_info() {
  git rev-parse --is-inside-work-tree &>/dev/null || return
  local branch=$(git symbolic-ref --short HEAD 2>/dev/null)

  if [[ -n $(git status --porcelain 2>/dev/null) ]];then
    echo "%{$fg[yellow]%}‹${branch}%{$fg[red]%}•%{$fg[yellow]%}›%{$reset_color%}"
  else
    echo "%{$fg[yellow]%}‹${branch}›%{$reset_color%}"
  fi
}

# ==================================================
# Conda 环境提示符
# ==================================================
conda_prompt_info(){
  [[ -z $CONDA_DEFAULT_ENV || $CONDA_DEFAULT_ENV == "base" ]] && return
  echo "%{$fg[green]%}‹${CONDA_DEFAULT_ENV}›%{$reset_color%}"
}

# ==================================================
# Prompt
# ==================================================
local return_code="%(?..%{$fg[red]%}%? ↵%{$reset_color%})"
local user_host="%B%(!.%{$fg[red]%}.%{$fg[green]%})%n@%m%{$reset_color%}"
local current_dir="%B%{$fg[blue]%}%~%{$reset_color%}"
local user_symbol='%(!.#.$)'

PROMPT='╭─$(conda_prompt_info)'"${user_host}${current_dir}"'$(git_prompt_info)
╰─%B'"${user_symbol}"'%b '
RPROMPT="%B${return_code}%b"

# ==================================================
# 全局环境变量
# ==================================================
export EDITOR=nvim
