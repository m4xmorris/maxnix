# oh-my-zsh and settings
export ZSH="$HOME/.oh-my-zsh"
ZSH_THEME="robbyrussell"
plugins=(1password ansible argocd bgnotify brew docker kubectl kube-ps1 macos pre-commit terraform tailscale themes emoji fzf gh iterm2 git)
source $ZSH/oh-my-zsh.sh
source $HOMEBREW_PREFIX/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
source $HOMEBREW_PREFIX/share/zsh-autosuggestions/zsh-autosuggestions.zsh

# Env
export PATH="${KREW_ROOT:-$HOME/.krew}/bin:$PATH"
export PATH="$HOME/Repos/homescale/tools:$PATH"
RPROMPT='$(kube_ps1)'
KUBE_PS1_SYMBOL_ENABLE=false
KUBE_PS1_PREFIX=''
KUBE_PS1_SUFFIX=''
KUBE_PS1_KUBECONFIG_SYMLINK=true
KUBE_PS1_CTX_COLOR=magenta
function get_cluster_short() {
  echo "$1" | cut -d . -f1
}
KUBE_PS1_CLUSTER_FUNCTION=get_cluster_short

# Functions
function get_cluster_short() {
  echo "$1" | cut -d . -f1
}

ksw () {
	kubectl ctx
	kubectl ns
}

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
