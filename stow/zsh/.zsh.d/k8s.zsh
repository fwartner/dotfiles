# Kubernetes / Helm (conditional on installed tools)

(( ${+commands[kubectl]} )) || return 0

alias k='kubectl'
(( ${+commands[kubectx]} )) && alias kx='kubectx'
(( ${+commands[kubens]} )) && alias kn='kubens'
(( ${+commands[minikube]} )) && alias mkc='minikube'

# Switch namespace for current context
kns() {
  if [[ -z "$1" ]]; then
    echo "Usage: kns <namespace>"
    return 1
  fi
  kubectl config set-context --current --namespace="$1"
}

# Get first pod name matching pattern (optional namespace)
# Usage: kpod <pattern> [namespace]
kpod() {
  if [[ -z "$1" ]]; then
    echo "Usage: kpod <pattern> [namespace]"
    return 1
  fi
  local ns=()
  [[ -n "$2" ]] && ns=(-n "$2")
  kubectl get pods "${ns[@]}" -o name | grep -E "$1" | head -1
}
