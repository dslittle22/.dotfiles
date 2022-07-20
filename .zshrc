export HISTFILE="$ZDOTDIR/.zhistory" # History filepath
export HISTSIZE=1000 # Maximum events for internal history
export SAVEHIST=1000 # Maximum events in history file

# better autocomplete (e.g. git branches, fix capitalization errors)
autoload -Uz compinit && compinit 
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Za-z}'

# get version control system info
autoload -Uz vcs_info
precmd() { vcs_info }

setopt prompt_subst # allow substitution of prompt
zstyle ':vcs_info:*' enable git # only load stuff for git vcs
zstyle ':vcs_info:*' check-for-changes true # always check for changes
zstyle ':vcs_info:*' unstagedstr '*'
zstyle ':vcs_info:*' stagedstr '+'

# display when no action (e.g. rebase)
zstyle ':vcs_info:git:*' formats "%F{40}%b %F{220}%u%c%m%f"
# display on action
zstyle ':vcs_info:git:*' actionformats '%F{40}%b|%F{220}%u%c%F{1}(%a)%f'
# run hook below to check for untracked files
zstyle ':vcs_info:git*+set-message:*' hooks git-untracked

+vi-git-untracked() {
  if [[ $(git rev-parse --is-inside-work-tree 2> /dev/null) == 'true' ]] && \
      git status --porcelain | grep -m 1 '^??' &>/dev/null
  then
    hook_com[misc]='?'
  fi
}

# set prompt

# renders a question mark character for a certain error code
err="%(?..%F{red}? %?)%f"

# this will reevaluate whenever the terminal is resized to
# have the left and right prompts take up prompt_width_pct
# percent of the total width.
# https://unix.stackexchange.com/questions/369847/
# how-to-configure-zsh-prompt-so-that-its-length-is-proportional-to-terminal-width
export prompt_width_pct=30
function prompt_width_func() {
  echo $(( ${COLUMNS:-80} * prompt_width_pct / 100 ))
}
prompt_width='$(prompt_width_func)'

# the part in parenths, %(...), says: if the cwd is >= 4 # dirs,
# show dir1/.../last2/dirs. # the %${p_w}<..< says, if the whole string
# is longer than p_w, truncate it to ..rest-of-string.
dir="%B%F{4}%${prompt_width}<..<%(4~|%-1~/…/%2~|%3~)%f"

# shows arrow normally, pound sign if elevated privilages (sudo)
suffix='%(!.#.→) '

git_info='${vcs_info_msg_0_}'

PROMPT="${err}${dir} ${suffix}"
RPROMPT="%${prompt_width}<..<${git_info}"

if [ -n "$VIRTUAL_ENV" ]; then
  RPROMPT="🐍:(`basename \"$VIRTUAL_ENV\"`)$RPROMPT "
fi

# functions
mkcd () {
  mkdir "$1"
  cd "$1"
}

timezsh() {
  shell=${1-$SHELL}
  for i in $(seq 1 10); do /usr/bin/time $shell -i -c exit; done
}

# aliases
alias python="/opt/homebrew/bin/python3"
alias avenv="source venv/bin/activate"
alias dvenv="deactivate"
alias sz="source ${ZDOTDIR}/.zshrc"
alias vz="vim ${ZDOTDIR}/.zshrc"
alias gs="git status"
alias ga="git add ."
alias gd="git diff"
alias gcm="git commit -m"
alias gcam="git commit -am"
alias glo="git log --oneline"
alias gc="git checkout"
alias gb="git branch"
alias gsm="git stash --message"
alias gsl="git stash list"
alias gsp="git stash pop"
alias gsa="git stash apply"
alias gp="git pull"

# colorize output of ls, with some aliases
alias ls="ls -G"
alias ll="ls -lG"
alias la="ls -laG"
export CLICOLOR=1
export LSCOLORS=gxfxbEaEBxxEhEhBaDaCaD

export LESS=-R

# source brew plugins
source $(brew --prefix)/share/zsh-autosuggestions/zsh-autosuggestions.zsh
source $(brew --prefix)/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh


if [ -f ${ZDOTDIR}/.zshrc.local ]; then
  . "${ZDOTDIR}/.zshrc.local";
fi
