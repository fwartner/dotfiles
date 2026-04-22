# Docker + Compose aliases and functions

# Docker
alias d='docker'
alias dps='docker ps'
alias dpsa='docker ps -a'
alias di='docker images'
alias dprune='docker system prune -f'

# Docker Compose (prefer 'docker compose' over legacy docker-compose)
if docker compose version &>/dev/null; then
  alias dc='docker compose'
  alias dco='docker compose'
else
  alias dc='docker-compose'
  alias dco='docker-compose'
fi
alias dcup='docker compose up -d'
alias dcdown='docker compose down'
alias dclogs='docker compose logs -f'
alias dcexec='docker compose exec'

# Exec into a container (default shell: sh)
dexec() {
  if [[ -z "$1" ]]; then
    echo "Usage: dexec <container> [cmd]"
    return 1
  fi
  docker exec -it "$1" "${2:-sh}"
}

# Stop all running containers
dstopall() {
  docker stop $(docker ps -q) 2>/dev/null || echo "No running containers"
}

# Remove stopped containers and unused images (optional: add -a for full cleanup)
dclean() {
  docker system prune -f
}
