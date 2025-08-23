export ZSH="$HOME/.oh-my-zsh"
ZSH_THEME="robbyrussell"
plugins=(1password ansible argocd bgnotify brew docker kubectl kubectx macos pre-commit terraform tailscale themes emoji fzf gh iterm2 git)
source $ZSH/oh-my-zsh.sh

# Aliases
alias vim=nvim
alias kubectl=kubecolor
alias k=kubectl
alias racadm="docker run -v `pwd`:/mnt xfgavin/racadm"
alias kgp="k get pods"
alias kgn="k get nodes"
alias kgs="k get services"
alias kga="k get applications"
alias kdp="k delete pods"
alias ceph="k rook-ceph ceph"
alias dot="/usr/bin/git --git-dir=$HOME/.dot.git/ --work-tree=$HOME"
alias kill-all-mine="pkill -9 -u max"
alias l="ls -al"