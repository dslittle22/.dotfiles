export HISTFILE="$ZDOTDIR/.zhistory" # History filepath
export HISTSIZE=100000 # Maximum events for internal history
export SAVEHIST=100000 # Maximum events in history file
export HISTFILESIZE=100000 # Maximum events in history file
setopt EXTENDED_HISTORY
setopt SHARE_HISTORY

eval "$(/opt/homebrew/bin/brew shellenv)"

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
zstyle ':vcs_info:git*+set-message:*' hooks git-untracked git-stashed

# this stuff is confusing. here's a link for some docs:
# https://opensource.apple.com/source/zsh/zsh-61/zsh/Misc/vcs_info-examples.auto.html
# hook_com[staged] is picked up because the %c in formats above refers to staged.
# hook_com[misc] is picked up by %m.

+vi-git-untracked() {
  if [[ $(git rev-parse --is-inside-work-tree 2> /dev/null) == 'true' ]] && \
      git status --porcelain | grep -m 1 '^??' &>/dev/null
  then
    hook_com[staged]='?'
  fi
}

+vi-git-stashed() {
  if [ "$(git stash list 2>/dev/null)" != "" ]
  then
    hook_com[misc]="S:$(git rev-list --walk-reflogs --count refs/stash)"
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
export prompt_width_pct=35
function prompt_width_func() {
  echo $(( ${COLUMNS:-80} * prompt_width_pct / 100 ))
}
prompt_width='$(prompt_width_func)'

# the part in parenths, %(...), says: if the cwd is >= 4 # dirs,
# show dir1/.../last2/dirs. # the %${p_w}<..< says, if the whole string
# is longer than p_w, truncate it to ..rest-of-string.
dir="%B%F{4}%${prompt_width}<…<%(4~|%-1~/…/%2~|%3~)%f"

# shows arrow normally, pound sign if elevated privilages (sudo)
suffix='%(!.#.→) '

git_info='${vcs_info_msg_0_}'

PROMPT="${err}${dir} ${suffix}"
RPROMPT="%F{40}%${prompt_width}<…<${git_info}"

if [ -n "$VIRTUAL_ENV" ]; then
  RPROMPT="🐍 `basename \"$VIRTUAL_ENV\"` $RPROMPT "
fi

# functions
mkcd () {
  mkdir "$1"
  cd "$1"
}

xman() {
open x-man-page://"${@}"
}

timezsh() {
  shell=${1-$SHELL}
  for i in $(seq 1 10); do /usr/bin/time $shell -i -c exit; done
}

git_pull_and_merge() {
  if [ -z "$1" ]; then
    echo "Pass in a branch name."
    return
  fi
  current_branch=$(git symbolic-ref --short HEAD 2>/dev/null);
  # current_branch=$(git symbolic-ref HEAD 2>/dev/null | cut -d"/" -f 3);
  git checkout "$1";
  git pull;
  git checkout "$current_branch";
  git merge "$1";
}

git_log_on_branch() {
  default=$(git symbolic-ref refs/remotes/origin/HEAD | sed 's@^refs/remotes/origin/@@')
  git log "$default".. --oneline --graph --decorate
}

function git_cleanup () {
	git fetch -p && git branch -vv | awk '/: gone]/{print $1}' | grep -v "\*" | xargs git branch -D
}


function git_cleanup_2() {
  TARGET_BRANCH=master && git checkout -q $TARGET_BRANCH && git for-each-ref refs/heads/ "--format=%(refname:short)" | while read branch; do mergeBase=$(git merge-base $TARGET_BRANCH $branch) && [[ $(git cherry $TARGET_BRANCH $(git commit-tree $(git rev-parse $branch\^{tree}) -p $mergeBase -m _)) == "-"* ]] && git branch -D $branch; done
}

function git_branch_backup() {
  # current_branch=$(git symbolic-ref --short HEAD 2>/dev/null);
  current_branch=$(git symbolic-ref --short HEAD);
  git switch -c bak/"$current_branch" && git switch -
}

function git_range_diff() {
    # Default values for optional parameters
    local branch="$1"
    local branch_backup="${2:-bak/$branch}"
    local base="${3:-master}"

    # Function usage
    if [ -z "$branch" ]; then
        echo "Usage: git_range_diff <branch> [branch_backup] [base]"
        echo "  branch: Branch to compare (required)"
        echo "  branch_backup: Backup branch (default: bak/<branch>)"
        echo "  base: Base branch for comparison (default: master)"
        return 1
    fi

    # Verify that branch exists
    if ! git rev-parse --verify "$branch" >/dev/null 2>&1; then
        echo "Error: Branch '$branch' does not exist"
        return 1
    fi

    # Verify that backup branch exists
    if ! git rev-parse --verify "$branch_backup" >/dev/null 2>&1; then
        echo "Error: Backup branch '$branch_backup' does not exist"
        return 1
    fi

    # Verify that base branch exists
    if ! git rev-parse --verify "$base" >/dev/null 2>&1; then
        echo "Error: Base branch '$base' does not exist"
        return 1
    fi

    # Run the range-diff command
    git range-diff "$base..$branch" "$base..$branch_backup"
}

# aliases
alias vim="nvim"
alias vi="nvim"
alias python="/opt/homebrew/bin/python3"
alias avenv="source env/bin/activate"
alias dvenv="deactivate"
alias mvenv="python3 -m venv env"
alias brewup="brew update && brew upgrade && brew cleanup"
alias sz="source ${ZDOTDIR}/.zshrc"
alias vz="vim ${ZDOTDIR}/.zshrc"
alias gs="git status"
alias ga="git add"
alias gaa="git add ."
alias gd="git diff"
alias gcm="git commit -m"
alias gcmm="git commit -m"
alias gacm="git add . && git commit -m"
alias gundo="git reset --soft HEAD~"
alias glo="git log --oneline --graph --decorate"
alias gblo=git_log_on_branch
alias gch="git checkout"
alias gb="git branch"
alias gst="git stash"
alias gsm="git stash --message"
alias gsl="git stash list"
alias gsp="git stash pop"
alias gsa="git stash apply"
alias gpul="git pull"
alias gpus="git push"
alias gpm="git_pull_and_merge"
alias gsw="git switch"
alias gsc="git switch -c"
alias gbak="git_branch_backup"
# colorize output of ls, with some aliases
alias ls="ls -GF"
alias lsl="ls -lGF"
alias lsla="ls -laGF"
alias lsls="ls -lsGF"
alias brewup="brew update && brew upgrade && brew cleanup"
alias gbd="git-branch-delete"
alias grs="git reset"
alias grss="git reset --soft"
alias grsh="git reset --hard"

export CLICOLOR=1
export LSCOLORS=gxfxbEaEBxxEhEhBaDaCaD
export LESS=-R

# source brew plugins
source $(brew --prefix)/share/zsh-autosuggestions/zsh-autosuggestions.zsh
source $(brew --prefix)/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh


[ -f "/Users/dannylittle/.ghcup/env" ] && source "/Users/dannylittle/.ghcup/env" # ghcup-env

fzf-history-widget() {
  local selected num
  setopt localoptions noglobsubst noposixbuiltins pipefail no_aliases 2> /dev/null

  local awk_filter='
  {
    ts = int($2)
    delta = systime() - ts
    delta_days = int(delta / 86400)
    if (delta < 0) {
      $2="+" (-delta_days) "d"
    } else if (delta_days < 1 && delta < 72000) {
      $2=strftime("%H:%M", ts)
    } else if (delta_days == 0) {
      $2="1d"
    } else {
      $2=delta_days "d"
    }
  line=$0; $1=""; $2=""
  if (!seen[$0]++) print line
  }'

selected=( $(fc -rl -i -t '%s' 1 | sed -E "s/^ *//" | gawk "$awk_filter" | FZF_DEFAULT_OPTS="--height ${FZF_TMUX_HEIGHT:-40%}
  $FZF_DEFAULT_OPTS --with-nth 2.. --bind=ctrl-r:toggle-sort $FZF_CTRL_R_OPTS --query=${(qqq)LBUFFER} --tiebreak=index --no-multi" fzf) )

  local ret=$?
  if [ -n "$selected" ]; then
    num=$selected[1]
    if [ -n "$num" ]; then
      zle vi-fetch-history -n $num
    fi
  fi
  zle reset-prompt
  return $ret
}

zle -N fzf-history-widget
bindkey '^R' fzf-history-widget


if [ -f ${ZDOTDIR}/.zshrc.local ]; then
  . "${ZDOTDIR}/.zshrc.local";
fi

GOPATH=$HOME/.go
