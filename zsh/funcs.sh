extract() {
  if [ -f $1 ] ; then
    case $1 in
      *.tar.gz)  tar xzf $1 ;;
      *.tar.bz2) tar xjf $1 ;;
      *.bz2)     bunzip2 $1 ;;
      *.rar)     rar x   $1 ;;
      *.gz)      gunzip  $1 ;;
      *.tar)     tar xf  $1 ;;
      *.tbz2)    tar xjf $1 ;;
      *.tgz)     tar xzf $1 ;;
      *.zip)     unzip   $1 ;;
      *.z)    uncompress $1 ;;
      *)      echo "'$1' cannot be extracted via extract()" ;;
    esac
  else
    echo "'$1' is not a valid file"
  fi
}


wttr() {
  local request="wttr.in/${37921}?F"
  [ "$1" = "n" ] || [ "$(tput cols)" -lt 125 ] && request+='?n'
  curl -H "Accept-Language: ${LANG%_*}" --compressed "$request"
}
