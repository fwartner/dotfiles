# Shortcuts
alias copykey="pbcopy < $HOME/.ssh/id_ed25519.pub"
alias reload="exec $SHELL -l"
alias flushdns="dscacheutil -flushcache && sudo killall -HUP mDNSResponder"
alias c="clear"
alias shrug="echo '¯\_(ツ)_/¯' | pbcopy"

# Directories
alias library="cd $HOME/Library"
alias ..="cd .."
alias ...="cd ../.."
alias ....="cd ../../.."
alias .....="cd ../../../.."
alias ~="cd $HOME"
alias -- -="cd -"
alias si="cd $HOME/Development/Sites"
alias p="cd $HOME/Development/Projects"

# Laravel
alias art="php artisan"
alias fresh="php artisan migrate:fresh --seed"
alias seed="php artisan db:seed"

# PHP
alias composer="php -d memory_limit=-1 /usr/local/bin/composer"
alias cfresh="rm -rf vendor/ composer.lock && composer i"
alias c="php -d memory_limit=-1 /usr/local/bin/composer"
alias cu="php -d memory_limit=-1 /usr/local/bin/composer update"
alias cr="php -d memory_limit=-1 /usr/local/bin/composer require"
alias ci="php -d memory_limit=-1 /usr/local/bin/composer install"
alias cda="php -d memory_limit=-1 /usr/local/bin/composer dump-autoload -o"

# JS
alias nfresh="rm -rf node_modules/ package-lock.json && npm install"
alias watch="npm run watch"

# Vagrant
alias v="vagrant global-status"
alias vup="vagrant up"
alias vhalt="vagrant halt"
alias vssh="vagrant ssh"
alias vreload="vagrant reload"
alias vrebuild="vagrant destroy --force && vagrant up"

# Docker
alias docker-composer="docker-compose"

# Git
alias gst="git status"
alias gb="git branch"
alias gc="git checkout"
alias gl="git log --oneline --decorate --color"
alias amend="git add . && git commit --amend --no-edit"
alias commit="git add . && git commit -m"
alias diff="git diff"
alias force="git push --force"
alias nuke="git clean -df && git reset --hard"
alias pop="git stash pop"
alias pull="git pull"
alias push="git push"
alias resolve="git add . && git commit --no-edit"
alias stash="git stash -u"
alias unstage="git restore --staged ."
alias wip="commit wip"

# Misc
alias ping='prettyping --nolegend'
alias top="sudo htop"
alias hidedesktop="defaults write com.apple.finder CreateDesktop -bool false && killall Finder"
alias showdesktop="defaults write com.apple.finder CreateDesktop -bool true && killall Finder"
alias chromekill="ps ux | grep '[C]hrome Helper --type=renderer' | grep -v extension-process | tr -s ' ' | cut -d ' ' -f2 | xargs kill"
alias afk="/System/Library/CoreServices/Menu\ Extras/User.menu/Contents/Resources/CGSession -suspend"
alias localip="ifconfig -a | grep -o 'inet6\? \(addr:\)\?\s\?\(\(\([0-9]\+\.\)\{3\}[0-9]\+\)\|[a-fA-F0-9:]\+\)' | awk '{ sub(/inet6? (addr:)? ?/, \"\"); print }'"

alias intel="arch -x86_64"
