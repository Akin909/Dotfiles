#!/bin/zsh
#-------------------------------------------------------------------------------
# References:
#-------------------------------------------------------------------------------
# Color table - https://jonasjacek.github.io/colors/
# Wincent's dotfiles - https://github.com/wincent/wincent/blob/d6c52ed552/aspects/dotfiles/files/.zshrc
#-------------------------------------------------------------------------------
#               STARTUP TIMES
#-------------------------------------------------------------------------------
# zmodload zsh/zprof
# start_time="$(date +%s)"

# Create a hash table for globally stashing variables without polluting main
# scope with a bunch of identifiers.
typeset -A __DOTS

__DOTS[ITALIC_ON]=$'\e[3m'
__DOTS[ITALIC_OFF]=$'\e[23m'

#-------------------------------------------------------------------------------
#               Completion
#-------------------------------------------------------------------------------
# Init completions
autoload -Uz compinit
compinit

# Colorize completions using default `ls` colors.
zstyle ':completion:*' list-colors ''

# Enable keyboard navigation of completions in menu
# (not just tab/shift-tab but cursor keys as well):
zstyle ':completion:*' menu select

# persistent reshahing i.e puts new executables in the $path
# if no command is set typing in a line will cd by default
zstyle ':completion:*' rehash true

# Allow completion of ..<Tab> to ../ and beyond.
zstyle -e ':completion:*' special-dirs '[[ $PREFIX = (../)#(..) ]] && reply=(..)'

# Categorize completion suggestions with headings:
zstyle ':completion:*' group-name ''
# Style the group names
zstyle ':completion:*' format %F{default}%B%{$__DOTS[ITALIC_ON]%}- %F{yellow}%f%d -%{$__DOTS[ITALIC_OFF]%}%b%f

# Added by running `compinstall`
zstyle ':completion:*' expand suffix
zstyle ':completion:*' file-sort modification
zstyle ':completion:*' list-prompt %SAt %p: Hit TAB for more, or the character to insert%s
zstyle ':completion:*' list-suffixes true
# End of lines added by compinstall

# case insensitive path-completion
zstyle ':completion:*' matcher-list 'm:{[:lower:][:upper:]}={[:upper:][:lower:]}' 'm:{[:lower:][:upper:]}={[:upper:][:lower:]} l:|=* r:|=*' 'm:{[:lower:][:upper:]}={[:upper:][:lower:]} l:|=* r:|=*' 'm:{[:lower:][:upper:]}={[:upper:][:lower:]} l:|=* r:|=*'
#-------------------------------------------------------------------------------
#               Options
#-------------------------------------------------------------------------------
setopt AUTO_CD
setopt RM_STAR_WAIT
setopt CORRECT # command auto-correction
setopt COMPLETE_ALIASES
# set some history options
setopt APPEND_HISTORY
setopt EXTENDED_HISTORY
setopt HIST_EXPIRE_DUPS_FIRST
setopt HIST_IGNORE_ALL_DUPS
setopt HIST_IGNORE_DUPS
setopt HIST_IGNORE_SPACE
setopt HIST_REDUCE_BLANKS
setopt HIST_SAVE_NO_DUPS
setopt HIST_VERIFY
setopt AUTOPARAMSLASH # tab completing directory appends a slash
setopt SHARE_HISTORY # Share your history across all your terminal windows
# Keep a ton of history.
HISTSIZE=100000
SAVEHIST=100000
HISTFILE=~/.zsh_history
#-------------------------------------------------------------------------------
#               Vi-mode
#-------------------------------------------------------------------------------
bindkey -v # enables vi mode, using -e = emacs

# https://superuser.com/questions/151803/how-do-i-customize-zshs-vim-mode
# http://pawelgoscicki.com/archives/2012/09/vi-mode-indicator-in-zsh-prompt/
vim_ins_mode=""
vim_cmd_mode="%F{green} %f"
vim_mode=$vim_ins_mode

function zle-keymap-select {
  vim_mode="${${KEYMAP/vicmd/${vim_cmd_mode}}/(main|viins)/${vim_ins_mode}}"
  zle reset-prompt
}
zle -N zle-keymap-select

function zle-line-finish {
  vim_mode=$vim_ins_mode
}
zle -N zle-line-finish

# When you C-c in CMD mode and you'd be prompted with CMD mode indicator,
# while in fact you would be in INS mode Fixed by catching SIGINT (C-c),
# set vim_mode to INS and then repropagate the SIGINT,
# so if anything else depends on it, we will not break it
function TRAPINT() {
  vim_mode=$vim_ins_mode
  return $(( 128 + $1 ))
}
#-------------------------------------------------------------------------------
#               Prompt
#-------------------------------------------------------------------------------
# vcs_info is a zsh native module for getting git info into your
# prompt. It's not as fast as using git directly in some cases
# but easy and well documented.
# http://zsh.sourceforge.net/Doc/Release/User-Contributions.html
# %c - git staged
# %u - git untracked
# %b - git branch
# %r - git repo
autoload -Uz vcs_info
precmd_vcs_info() { vcs_info }
precmd_functions+=(precmd_vcs_info)

# Using named colors means that the prompt automatically adapts to how these
# are set by the current terminal theme
zstyle ':vcs_info:*' enable git
zstyle ':vcs_info:*' check-for-changes true
zstyle ':vcs_info:*' stagedstr "%F{green} ●%f"
zstyle ':vcs_info:*' unstagedstr "%F{red} ●%f"
zstyle ':vcs_info:*' use-simple true
zstyle ':vcs_info:git+set-message:*' hooks git-untracked git-stash
zstyle ':vcs_info:git*:*' actionformats '[%b|%a%m%c%u] '
zstyle ':vcs_info:git:*' formats "%F{249}(%f%F{blue}%{$__DOTS[ITALIC_ON]%}%b%{$__DOTS[ITALIC_OFF]%}%f%F{249})%f%c%u"

# this function adds a hook to the git vcs_info backend that depending
# on the output of the git command adds an indicator to the the vcs info
function +vi-git-untracked() {
  emulate -L zsh
  if [[ -n $(git ls-files --exclude-standard --others 2> /dev/null) ]]; then
    hook_com[unstaged]+="%F{blue} ●%f"
  fi
}

function +vi-git-stash() {
  emulate -L zsh
  if [[ -n $(git rev-list --walk-reflogs --count refs/stash 2> /dev/null) ]]; then
    hook_com[unstaged]+="%F{red} ≡%f"
  fi
}

# Multiline prompt source:
# https://gist.github.com/romkatv/2a107ef9314f0d5f76563725b42f7cab

# Usage: prompt-length TEXT [COLUMNS]
#
# If you run `print -P TEXT`, how many characters will be printed
# on the last line?
#
# Or, equivalently, if you set PROMPT=TEXT with prompt_subst
# option unset, on which column will the cursor be?
#
# The second argument specifies terminal width. Defaults to the
# real terminal width.
#
# Assumes that `%{%}` and `%G` don't lie.
#
# Examples:
#
#   prompt-length ''            => 0
#   prompt-length 'abc'         => 3
#   prompt-length $'abc\nxy'    => 2
#   prompt-length '❎'          => 2
#   prompt-length $'\t'         => 8
#   prompt-length $'\u274E'     => 2
#   prompt-length '%F{red}abc'  => 3
#   prompt-length $'%{a\b%Gb%}' => 1
#   prompt-length '%D'          => 8
#   prompt-length '%1(l..ab)'   => 2
#   prompt-length '%(!.a.)'     => 1 if root, 0 if not
function prompt-length() {
  emulate -L zsh
  local COLUMNS=${2:-$COLUMNS}
  local -i x y=$#1 m
  if (( y )); then
    while (( ${${(%):-$1%$y(l.1.0)}[-1]} )); do
      x=y
      (( y *= 2 ));
    done
    local xy
    while (( y > x + 1 )); do
      m=$(( x + (y - x) / 2 ))
      typeset ${${(%):-$1%$m(l.x.y)}[-1]}=$m
    done
  fi
  echo $x
}

# Usage: fill-line LEFT RIGHT
#
# Prints LEFT<spaces>RIGHT with enough spaces in the middle
# to fill a terminal line.
function fill-line() {
  emulate -L zsh
  local left_len=$(prompt-length $1)
  local right_len=$(prompt-length $2 9999)
  local pad_len=$((COLUMNS - left_len - right_len - ${ZLE_RPROMPT_INDENT:-1}))
  if (( pad_len < 1 )); then
    # Not enough space for the right part. Drop it.
    echo -E - ${1}
  else
    local pad=${(pl.$pad_len.. .)}  # pad_len spaces
    echo -E - ${1}${pad}${2}
  fi
}

# Sets PROMPT and RPROMPT.
#
# %F...%f - - foreground color
# toggle color based on success %F{%(?.green.red)}
# %F{a_color} - color specifier
# %B..%b - bold
# %* - reset highlight
#
# Requires: prompt_percent and no_prompt_subst.
function set-prompt() {
  emulate -L zsh
  # local git_branch="$(git rev-parse --abbrev-ref HEAD 2>/dev/null)"
  # git_branch=${git_branch//\%/%%}  # escape '%'

  # directory(branch)                     10:51
  # ❯  █
  #
  # Top left:     directory(gitbranch) ● ●
  # Top right:    Time
  # icon options =  ❯   
  # Bottom left:  ❯
  # Bottom right: empty


  local dots_prompt_icon="%F{green}❯ %f"
  local dots_prompt_failure_icon="%F{red}✘ %f"

  local top_left="%B%F{10}%1~%f%b${vcs_info_msg_0_}"
  local top_right="${vim_mode}%F{240}%*%f"
  local bottom_left="%(?.${dots_prompt_icon}.${dots_prompt_failure_icon})"

  PROMPT="$(fill-line "$top_left" "$top_right")"$'\n'$bottom_left
}

# Correction prompt
SPROMPT="correct %F{red}'%R'%f to %F{red}'%r'%f [%B%Uy%u%bes, %B%Un%u%bo, %B%Ue%u%bdit, %B%Ua%u%bbort]? "

setopt noprompt{bang,subst} prompt{cr,percent,sp}
autoload -Uz add-zsh-hook
add-zsh-hook precmd set-prompt
#-------------------------------------------------------------------------------
#           Plugins
#-------------------------------------------------------------------------------
# Enhancd can't be setup as a submodule because the init.sh script
# deletes the source files on load...
if [ -f ~/enhancd/init.sh ]; then
  source ~/enhancd/init.sh
else
  git clone https://github.com/b4b4r07/enhancd ~/enhancd
  source ~/enhancd/init.sh
fi

PLUGIN_DIR=$DOTFILES/zsh/plugins

source $PLUGIN_DIR/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
source $PLUGIN_DIR/zsh-autosuggestions/zsh-autosuggestions.zsh
source $PLUGIN_DIR/zsh-completions/zsh-completions.plugin.zsh
source $PLUGIN_DIR/alias-tips/alias-tips.plugin.zsh
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
#-------------------------------------------------------------------------------
#   LOCAL SCRIPTS
#-------------------------------------------------------------------------------
# source all zsh and sh files
for script in $DOTFILES/zsh/scripts/*; do
  source $script
done

# reference - https://unix.stackexchange.com/questions/252166/how-to-configure-zshrc-for-specfic-os
if [[ `uname` == 'Linux' ]]; then
  source "$DOTFILES/linux/functions.sh"
fi

fpath+=${ZDOTDIR:-~}/.zsh_functions

ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE='fg=241'
ZSH_AUTOSUGGEST_USE_ASYNC=1

eval "$(hub alias -s)" # Aliases 'hub' to git
eval $(thefuck --alias)

#-------------------------------------------------------------------------------
#               Mappings
#-------------------------------------------------------------------------------
export KEYTIMEOUT=1
bindkey ‘^R’ history-incremental-search-backward
bindkey '^P' up-history
bindkey '^N' down-history
bindkey '^U' autosuggest-accept

function -auto-ls-after-cd() {
  emulate -L zsh
  # Only in response to a user-initiated `cd`, not indirectly (eg. via another
  # function).
  if [ "$ZSH_EVAL_CONTEXT" = "toplevel:shfunc" ]; then
    ls -a
  fi
}
add-zsh-hook chpwd -auto-ls-after-cd
# STARTUP TIMES (CONTD)================================================
# end_time="$(date +%s)"
# Compares start time defined above with end time above and prints the
# difference
# echo load time: $((end_time - start_time)) seconds
# zprof
