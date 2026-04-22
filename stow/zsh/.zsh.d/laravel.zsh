# Laravel + Composer aliases and functions (works with Herd)

# Artisan
alias art='php artisan'
alias a='php artisan'
alias art:migrate='php artisan migrate'
alias art:fresh='php artisan migrate:fresh --seed'
alias art:tinker='php artisan tinker'
alias art:cache='php artisan config:cache && php artisan route:cache && php artisan view:cache'
alias art:clear='php artisan config:clear && php artisan route:clear && php artisan view:clear && php artisan cache:clear'

# Composer
alias cda='composer dump-autoload'

# Laravel Sail
alias sail='./vendor/bin/sail'

# Create new Laravel project and cd into it
newlaravel() {
  if [[ -z "$1" ]]; then
    echo "Usage: newlaravel <project-name>"
    return 1
  fi
  composer create-project laravel/laravel "$1" && cd "$1"
}

# Serve Laravel app (default port 8000)
laravel-serve() {
  php artisan serve --port "${1:-8000}"
}

# Artisan wrapper (for consistency)
artisan() {
  php artisan "$@"
}
