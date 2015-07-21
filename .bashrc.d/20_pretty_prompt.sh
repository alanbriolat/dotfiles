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

# pretty prompt, uncolored - use "pretty_prompt color <host_color> <path_color>"
# to make it prettier
pretty_prompt
