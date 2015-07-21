# Alias definitions.

# force alias expansion to happen inside "sudo <command>"
alias sudo='sudo '
# loud rm so it's obvious when accidentally deleting lots of stuff...
alias rm='rm -v'
alias :wq='echo "lol, vim user..." ; sleep 1 ; exit'

alias df='df --si'
alias du='du --si'
alias du0='du --si --max-depth=0'
alias du1='du --si --max-depth=1'

# some more ls aliases (from default Ubuntu config)
#alias ll='ls -l'
#alias la='ls -A'
#alias l='ls -CF'

# Load more local aliases
if [ -f ~/.bash_aliases ]; then
    . ~/.bash_aliases
fi
