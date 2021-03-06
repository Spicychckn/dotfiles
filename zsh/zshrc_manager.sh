time_out () { perl -e 'alarm shift; exec @ARGV' "$@"; }

# Run tmux if exists
if [ ! $_no_tmux ]; then
  if command -v tmux>/dev/null; then
    [ -z $TMUX ] && exec `tmux attach-session -t Dev || tmux new-session -s Dev`
  else 
    echo "tmux not installed. Run ./deploy to configure dependencies"
  fi
fi

echo "Updating configuration"
#(cd ~/dotfiles && time_out 3 git pull && time_out 3 git submodule update --init --recursive)
(cd ~/dotfiles && git pull && git submodule update --init --recursive)
source ~/dotfiles/zsh/zshrc.sh
