# ~/.bashrc: executed by bash(1) for non-login shells.
# see /usr/share/doc/bash/examples/startup-files (in the package bash-doc)
# for examples

# If not running interactively, don't do anything
[ -z "$PS1" ] && return

# The git prompt stuff got moved...
if [ -f /usr/share/git/git-prompt.sh ] ; then
    . /usr/share/git/git-prompt.sh
fi
# (Mac OS X, brew install git)
if [ -f /usr/local/etc/bash_completion.d/git-prompt.sh ] ; then
    . $(brew --prefix)/etc/bash_completion.d/git-prompt.sh
fi

function pretty_prompt {
    local USE_COLOR
    local HOST_COLOR
    local PATH_COLOR

    USE_COLOR="$1"
    HOST_COLOR="$2"
    PATH_COLOR="$3"

    # Invert user@host colors if running as root
    if [[ $UID -eq 0 ]]; then
        HOST_COLOR="$HOST_COLOR;7"
    fi

    local host_attrs
    local path_attrs
    local clear_attrs

    if [ "$USE_COLOR" = "color" ]; then
        host_attrs="\[\e[${HOST_COLOR}m\]"
        path_attrs="\[\e[${PATH_COLOR}m\]"
        clear_attrs="\[\e[0m\]"
    else
        host_attrs=""
        path_attrs=""
        clear_attrs=""
    fi

    PS1="\n[${host_attrs}\u@\h${clear_attrs}:${path_attrs}\w\$(__git_ps1)${clear_attrs}]\n$ "

    # If this is an xterm set the title to user@host:dir (branch)
    case "$TERM" in
        xterm*|rxvt*) PS1="\[\e]0;\u@\h:\w\$(__git_ps1)\a\]$PS1"
    esac
}

# don't put duplicate lines in the history. See bash(1) for more options
# ... or force ignoredups and ignorespace
HISTCONTROL=ignoredups:ignorespace

# append to the history file, don't overwrite it
shopt -s histappend

# for setting history length see HISTSIZE and HISTFILESIZE in bash(1)
HISTSIZE=1000
HISTFILESIZE=2000

# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize

# make less more friendly for non-text input files, see lesspipe(1)
[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

# enable color support of ls and also add handy aliases
if [ -x /usr/bin/dircolors ]; then
    test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
    alias ls='ls --color=auto'
    #alias dir='dir --color=auto'
    #alias vdir='vdir --color=auto'

    alias grep='grep --color=auto'
    alias fgrep='fgrep --color=auto'
    alias egrep='egrep --color=auto'
fi

# Alias definitions.
# You may want to put all your additions into a separate file like
# ~/.bash_aliases, instead of adding them here directly.
# See /usr/share/doc/bash-doc/examples in the bash-doc package.

if [ -f ~/.bash_aliases ]; then
    . ~/.bash_aliases
fi

# force alias expansion to happen inside "sudo <command>"
alias sudo='sudo '
# loud rm so it's obvious when accidentally deleting lots of stuff...
alias rm='rm -v'
alias :wq='echo "lol, vim user..." ; sleep 1 ; exit'

alias df='df --si'
alias du='du --si'
alias du0='du --si --max-depth=0'
alias du1='du --si --max-depth=1'

# some more ls aliases
#alias ll='ls -l'
#alias la='ls -A'
#alias l='ls -CF'

# enable programmable completion features (you don't need to enable
# this, if it's already enabled in /etc/bash.bashrc and /etc/profile
# sources /etc/bash.bashrc).
if [ -f /etc/bash_completion ] && ! shopt -oq posix; then
    . /etc/bash_completion
fi
# (Mac OS X, brew install bash-completion)
if [ "$(uname -s)" == "Darwin" ]; then
    . $(brew --prefix)/etc/bash_completion
fi

export EDITOR=/usr/bin/vim

# pretty prompt, uncolored - use "pretty_prompt color <host_color> <path_color>"
# to make it prettier
pretty_prompt

# use machine-specific config
if [ -f ~/.bashrc_local ]; then
    . ~/.bashrc_local
fi
