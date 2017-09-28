autoload -Uz add-zsh-hook

local git_color="243"
local dirty_color="248"
local venv_color="248"
local user_color="238"
local error_color="124"

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

ZSH_THEME_GIT_PROMPT_PREFIX=" %F{$git_color}"
ZSH_THEME_GIT_PROMPT_SUFFIX="%f"
ZSH_THEME_GIT_PROMPT_DIRTY="%F{$dirty_color}*%F{$git_color%}"
ZSH_THEME_GIT_PROMPT_CLEAN=""

ZSH_THEME_VIRTUALENV_PREFIX=" %F{$venv_color}"
ZSH_THEME_VIRTUALENV_SUFFIX="%f"

test $UID -eq 0 && user_color="124"

PROMPT="%F{$user_color}%~%f"\
'$(direnv_python_prompt_info)'\
'$(git_prompt_info)'\
"%(?.%F{$user_color}.%F{$error_color})%(!.#.❯)%f "

PROMPT2='%F{red}\ %f'

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

function dp_theme_preexec() {
  prompt_cmd_timestamp=${prompt_cmd_timestamp:-$SECONDS}
}

function dp_theme_precmd() {
  local timer_color="242"
  unset RPROMPT
  if [ $prompt_cmd_timestamp ]; then
    local elapsed_seconds=$(($SECONDS - $prompt_cmd_timestamp))
    if [ "$elapsed_seconds" -ge "${prompt_visible_exec_time:=5}" ]; then
      time_string=$(prompt_human_time $elapsed_seconds)
      export RPROMPT="%F{$timer_color%}${time_string}%f"
    fi
    unset prompt_cmd_timestamp
  fi
}

add-zsh-hook preexec dp_theme_preexec
add-zsh-hook precmd dp_theme_precmd
