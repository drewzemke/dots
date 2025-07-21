function fish_jj_prompt --description 'Write out the jj prompt'
    echo \(

    jj log --ignore-working-copy --no-graph --color always -r @ -T '
        separate(
            " ",
            bookmarks.join(", "),
            coalesce(
                surround(
                    "\"",
                    "\"",
                    if(
                        description.first_line().substr(0, 24).starts_with(description.first_line()),
                        description.first_line().substr(0, 24),
                        description.first_line().substr(0, 23) ++ "…"
                    )
                ),
                label(if(empty, "empty", "author"), "󰞋 ")
            ),
            change_id.shortest(),
            commit_id.shortest(),
            if(conflict, label("conflict", "󰅗 ")),
        )
    '

    # collect symbols to show after the log output
    set symbols ""

    set empty_changes "$(jj diff)"
    set outgoing_commits "$(jj out)"
    set fresh_commits "$(jj fresh)"
    
    # show a symbol if the current changes are empty
    test -z "$empty_changes" && set symbols $symbols' '(set_color green)󱗜  

    # show a symbol if there are new commits
    test -n "$fresh_commits" && set symbols $symbols' '(set_color cyan)󰩳 

    # show a symbol if there are commits ready to be pushed
    test -n "$outgoing_commits" && set symbols $symbols' '(set_color magenta)󰛃 

    # print all the symbols, plus an extra space if there were any
    # those big square symbols need extra space
    echo -n $symbols
    test -n "$symbols" && echo -n " "
    
    echo -n (set_color normal)\)
end
