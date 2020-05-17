# Reference for colors: http://stackoverflow.com/questions/689765/how-can-i-change-the-color-of-my-prompt-in-zsh-different-from-normal-text

#autoload -U colors && colors

setopt PROMPT_SUBST

set_prompt() {


	# [
	PS1="%B%{%F{white}%}["

	# Sudo
  if (! $_no_sudo)
    then
	  CAN_I_RUN_SUDO=$(sudo -n uptime 2>&1|grep "load"|wc -l)
	  if [ ${CAN_I_RUN_SUDO} -gt 0 ]
	  then
		  PS1+="%{$fg_bold[red]%}SUDO %{$reset_color%}"
	  fi
  fi

  # Username
  PS1+="%{%F{026}%}%n"

  # Host
  PS1+="%{%F{026}%}@"
  PS1+="%{%F{026}%}%M:"

	# Path
	PS1+="%{%F{cyan}%}%~"

 
  #GIT
  if [ ! $_no_git ];
  then
	  if git rev-parse --is-inside-work-tree 2> /dev/null | grep -q 'true' ; then
		  PS1+=', '
		  PS1+="%{%F{208}%}$(git rev-parse --abbrev-ref HEAD 2> /dev/null)%{$reset_color%}"
		  if [ $(git status --short 2> /dev/null 2> /dev/null | wc -l) -gt 0 ]; then 
			  PS1+="%{$fg[red]%}+$(git status --short 2> /dev/null | wc -l | awk '{$1=$1};1')%{$reset_color%}"
		  fi
	  fi
  fi


	# Timer
	if [[ $_elapsed[-1] -ne 0 ]]; then
		PS1+=', '
		PS1+="%{$fg[magenta]%}$_elapsed[-1]s%{$reset_color%}"
	fi

	# PID
	if [[ $! -ne 0 ]]; then
		PS1+=', '
		PS1+="%{$fg[yellow]%}PID:$!%{$reset_color%}"
	fi

	# Status Code
	PS1+='%(?.., %{$fg[red]%}%?%{$reset_color%})'

	PS1+="%{%F{white} ]%{$reset_color%}: "
}

precmd_functions+=set_prompt

preexec () {
   (( ${#_elapsed[@]} > 1000 )) && _elapsed=(${_elapsed[@]: -1000})
   _start=$SECONDS
}

precmd () {
   (( _start >= 0 )) && _elapsed+=($(( SECONDS-_start )))
   _start=-1 
}
