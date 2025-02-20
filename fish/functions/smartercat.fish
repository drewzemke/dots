#!/usr/bin/env fish
#
# smartercat
# AI assistant that can request files from your project to add to its context
function smartercat
    argparse 'v/verbose' -- $argv

    function get_input
        set input ""
        if test -n "$argv"
            echo "$argv" | while read -l line
                set input "$input$line\n"
            end
        else
            while read -l line
                set input "$input$line\n"
            end
        end
        set input (string trim -r -c \n "$input")
        echo $input
    end

    function get_files
        set -g filtered_files
        function traverse_dir
            set dir $argv[1]
            if test "$dir" != "." && git check-ignore -q $dir
                return
            end
            for entry in $dir/*
                if test -f $entry
                    if not git check-ignore -q $entry
                        set -g filtered_files $filtered_files $entry
                    end
                else if test -d $entry
                    traverse_dir $entry
                end
            end
        end

        traverse_dir "."
        string join \n $filtered_files | sort
    end

    # parse input
    set input (get_input $argv)
    if set -q _flag_verbose
        echo -e "input is: $input"
    end

    # get files from current dir
    set files (get_files)
    if set -q _flag_verbose
        echo "here are the files that will be passed in:"
        for file in $files
            echo $file
        end
    end

    # write the files to a temporary file so we can pass them in the sc context
    set tmp_dir /tmp/smartercat
    if not test -d $tmp_dir
        mkdir $tmp_dir
    end

    set tmp_file $tmp_dir/files
    rm $tmp_file
    for file in $files
        echo $file >> $tmp_file
    end

    # invoke sc with the appropriate profile
    set response (sc smartercat "$input" -c /tmp/smartercat/files)
    if set -q _flag_verbose
        printf "%s\n" $response
    end

    # if the response looks like "need(path1,path2,...)", parse those paths into a list
    set need_regex '^need\((.*)\)$'
    while string match -rq $need_regex -- "$response"
        set paths (string match -r $need_regex -- "$response")[2]
        set path_list (string split "," -- $paths)
        # trim whitespace from each path
        set path_list (string trim -- $path_list)

        if set -q _flag_verbose
            printf "sending these files:\n%s\n" "$path_list"
        end

        # invoke sc again
        set response (sc -e "" -c $path_list)
    end

    # all done, print the response
    printf "%s\n" $response
end
