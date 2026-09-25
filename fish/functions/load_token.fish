# load a token into the env from a file in the home directory
function load_token -a name file
    set -q $name; and return
    set -gx $name (cat ~/$file)
end
