function fish_prompt
    if test -n "$SSH_TTY"
        echo -n (set_color green)"$USER"(set_color white)'@'(set_color cyan)(prompt_hostname)' '
    end

    if test -n "$IN_NIX_SHELL"
        # nix icon followed by a space (in unicode)
        echo -n (set_color white)\uf313" "\u0020
    end

    echo -n (set_color blue)(prompt_pwd)' '

    set_color -o
    if fish_is_root_user
        echo -n (set_color red)'# '
    end
    echo -n (set_color red)'❯'(set_color yellow)'❯'(set_color green)'❯ '
    set_color normal
end
