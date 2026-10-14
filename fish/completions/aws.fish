# omit the current token so aws_completer returns all candidates and fish can fuzzy match
complete -c aws -f -a '(
    begin
        set -lx COMP_SHELL fish
        set -lx COMP_LINE (commandline -cp | string replace -r -- "\S*\$" "")
        aws_completer
    end
)'
