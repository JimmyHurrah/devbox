if status is-interactive
    # Commands to run in interactive sessions can go here
end

alias cat="bat -n"
devbox global shellenv --init-hook | source
zoxide init --cmd cd fish | source
