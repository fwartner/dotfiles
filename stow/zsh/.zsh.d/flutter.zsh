# Flutter aliases and functions

alias f='flutter'
alias fg='flutter pub get'
alias fb='flutter build'
alias fr='flutter run'
alias fd='flutter devices'
alias fc='flutter clean'
alias fpg='flutter pub get'
alias fdoctor='flutter doctor -v'

# Run on default or specified device
frun() {
  if [[ -n "$1" ]]; then
    flutter run --device-id="$1"
  else
    flutter run
  fi
}

# Switch Flutter channel and show current
fchannel() {
  if [[ -z "$1" ]]; then
    flutter channel
    return
  fi
  flutter channel "$1" && flutter channel
}

# Create Flutter project and cd into it
fcreate() {
  if [[ -z "$1" ]]; then
    echo "Usage: fcreate <project-name>"
    return 1
  fi
  flutter create "$1" && cd "$1"
}
