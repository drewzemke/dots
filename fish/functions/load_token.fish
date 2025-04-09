#!/usr/bin/env fish
#
# load token into env (but only if it isn't already defined)
function load_token
    set -l token_name $argv[1]
    set -l file_path $argv[2]
    if test -z (eval "echo \$$token_name")
        set -gx $token_name (cat $file_path)
    end
end
