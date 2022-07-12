export HISTFILE="$ZDOTDIR/.zhistory" # History filepath
export HISTSIZE=1000 # Maximum events for internal history
export SAVEHIST=1000 # Maximum events in history file

autoload -Uz compinit && compinit # better autocomplete (e.g. git branches)

# get version control system info
autoload -Uz vcs_info
precmd() { vcs_info }

setopt prompt_subst # allow substitution of prompt
zstyle ':vcs_info:*' enable git # only load stuff for git vcs
zstyle ':vcs_info:*' check-for-changes true # always check for changes
zstyle ':vcs_info:*' unstagedstr '*'
zstyle ':vcs_info:*' stagedstr '+'
 
# display when no action (e.g. rebase)
zstyle ':vcs_info:git:*' formats 'on %F{6}%b %F{4}%u%c%m%f'
# display on action
zstyle ':vcs_info:git:*' actionformats 'on %F{6}%b|%F{4}%u%c%F{5}(%a)%f'
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
err='%(?..%F{red}? %?)%f'

# the part in parenths, %(...), says: if the cwd is >= 4
# dirs, show dir1/.../last2/dirs.
# the %32<..< says, if the whole string is longer than 32,
# truncate it to ..rest-of-string.
dir='%B%F{4}%32<..<%(4~|%-1~/…/%2~|%3~)%f'

# shows arrow normally, pound sign if elevated privilages (sudo)
suffix='%(!.#.→) '
PROMPT='${err}${dir} ${suffix}'
RPROMPT='%32>..>${vcs_info_msg_0_}'

if [ -n "$VIRTUAL_ENV" ]; then
  RPROMPT="🐍:(`basename \"$VIRTUAL_ENV\"`)$RPROMPT "
fi

# functions
mkcd () {
  mkdir "$1"
  cd "$1"
}

# aliases
alias python="/opt/homebrew/bin/python3"
alias avenv="source venv/bin/activate"
alias dvenv="deactivate"
alias sz="source ~/.zshrc"
alias vz="vim ~/.zshrc"
alias gs="git status"
alias ga="git add ."
alias gd="git diff"
alias gcm="git commit -m"
alias gcam="git commit -am"
alias glo="git log --oneline"
alias gc="git checkout"
alias gs="git stash"
alias gsm="git stash --message"
alias gsl="git stash --list"
alias gsp="git stash pop"
alias gsa="git stash apply"

# colorize output of ls, with some aliases
alias ls="ls -G"
alias ll="ls -lG"
alias la="ls -laG"
export CLICOLOR=1
export LSCOLORS=gxfxbEaEBxxEhEhBaDaCaD

# source brew plugins
source $(brew --prefix)/share/zsh-autosuggestions/zsh-autosuggestions.zsh
source $(brew --prefix)/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
