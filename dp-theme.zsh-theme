# Git-centric variation of the "fishy" theme.
# See screenshot at http://ompldr.org/vOHcwZg

# List colors using `spectrum_ls`

local git_color="$FG[243]"
local venv_color="$FG[248]"
local user_color="$FG[238]"
local error_color="$FG[124]"
local timer_color="$FG[242]"

# git_prompt_status
ZSH_THEME_GIT_PROMPT_ADDED=""
ZSH_THEME_GIT_PROMPT_MODIFIED=""
ZSH_THEME_GIT_PROMPT_DELETED=""
ZSH_THEME_GIT_PROMPT_RENAMED=""
ZSH_THEME_GIT_PROMPT_UNMERGED=""
ZSH_THEME_GIT_PROMPT_UNTRACKED=""
ZSH_THEME_GIT_PROMPT_STASHED=""

# git_remote_status
ZSH_THEME_GIT_PROMPT_AHEAD_REMOTE=""
ZSH_THEME_GIT_PROMPT_BEHIND_REMOTE=""
ZSH_THEME_GIT_PROMPT_DIVERGED_REMOTE=""

ZSH_THEME_GIT_PROMPT_PREFIX=" %{$git_color%}"
ZSH_THEME_GIT_PROMPT_SUFFIX="%{$reset_color%}"
ZSH_THEME_GIT_PROMPT_DIRTY="%{$FG[248]%}*%{$git_color%}"
ZSH_THEME_GIT_PROMPT_CLEAN=""

ZSH_THEME_VIRTUALENV_PREFIX=" %{$venv_color%}"
ZSH_THEME_VIRTUALENV_SUFFIX="%{$reset_color%}"

test $UID -eq 0 && user_color="$FG[124]"
# See spectrum_ls for colors

PROMPT='%{$user_color%}%~%{$reset_color%}'\
'$(direnv_python_prompt_info)'\
'$(git_prompt_info)'\
'%(?.%{$user_color%}.%{$error_color%})%(!.#.❯)%{$reset_color%} '

PROMPT2='%{$fg[red]%}\ %{$reset_color%}'

#RPROMPT='%(?..%{$fg_bold[red]%}exit %?%{$reset_color%})'

function prompt_human_time() {
  elapsed_seconds=$1
  time_string=" "
  local days=$(( $elapsed_seconds / 60 / 60 / 24 ))
  local hours=$(( $elapsed_seconds / 60 / 60 % 24 ))
  local minutes=$(( $elapsed_seconds / 60 % 60 ))
  local seconds=$(( $elapsed_seconds % 60 ))
  (( days > 0 )) && time_string+="${days}d "
  (( hours > 0 )) && time_string+="${hours}h "
  (( minutes > 0 )) && time_string+="${minutes}m "
  time_string+="${seconds}s"

  echo "${time_string}"
}

function preexec() {
  prompt_cmd_timestamp=${prompt_cmd_timestamp:-$SECONDS}
}

function precmd() {
  unset RPROMPT
  if [ $prompt_cmd_timestamp ]; then
    local elapsed_seconds=$(($SECONDS - $prompt_cmd_timestamp))
    if [ "$elapsed_seconds" -ge "${prompt_visible_exec_time:=5}" ]; then
      time_string=$(prompt_human_time $elapsed_seconds)
      export RPROMPT="%{$timer_color%}${time_string}%{$reset_color%}"
    fi
    unset prompt_cmd_timestamp
  fi
}
