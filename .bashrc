# If not running interactively, don't do anything
[ -z "$PS1" ] && return

# From: https://www.turnkeylinux.org/blog/generic-shell-hooks
run_scripts()
{
    for script in "$1"/*; do

        # skip non-executable snippets
        [ -x "$script" ] || continue

        # execute $script in the context of the current shell
        . $script
    done
}

run_scripts ~/.bashrc.d
