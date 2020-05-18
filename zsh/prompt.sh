# Reference for colors: http://stackoverflow.com/questions/689765/how-can-i-change-the-color-of-my-prompt-in-zsh-different-from-normal-text

#autoload -U colors && colors

setopt PROMPT_SUBST

set_prompt() {


	# [
	PS1="%B%{%F{white}%}[%{%f%}"

	# Sudo
  if (! $_no_sudo)
    then
	  CAN_I_RUN_SUDO=$(sudo -n uptime 2>&1|grep "load"|wc -l)
	  if [ ${CAN_I_RUN_SUDO} -gt 0 ]
	  then
		  PS1+="%{%F{red}%}SUDO %{%f%}"
	  fi
  fi

  # Username
  PS1+="%{%F{026}%}%n%{%f%}"

  # Host
  PS1+="%{%F{026}%}@%{%f%}"
  PS1+="%{%F{026}%}%m:%{%f%}"

	# Path
	PS1+="%{%F{cyan}%}%~%{%f%}"

 
  #GIT
  if [ ! $_no_git ];
  then
	  if git rev-parse --is-inside-work-tree 2> /dev/null | grep -q 'true' ; then
		  PS1+=', '
		  PS1+="%{%F{208}%}$(git rev-parse --abbrev-ref HEAD 2> /dev/null)%{%f%}"
		  if [ $(git status --short 2> /dev/null 2> /dev/null | wc -l) -gt 0 ]; then 
			  PS1+="%{%F{red}%}+$(git status --short 2> /dev/null | wc -l | awk '{$1=$1};1')%{%f%}"
		  fi
	  fi
  fi


	# Timer
	if [[ $_elapsed[-1] -ne 0 ]]; then
		PS1+=', '
		PS1+="%{%F{magenta}%}$_elapsed[-1]s%{%f%}"
	fi

	# PID
	if [[ $! -ne 0 ]]; then
		PS1+=', '
		PS1+="%{%F{yellow}%}PID:$!%{%f%}"
	fi

	# Status Code
	PS1+="%(?.., %{%F{red}%}%?%{%f%})"

	PS1+="%{%F{white} ]%b%{%f%}: "
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
