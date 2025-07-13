function fish_jj_prompt --description 'Write out the jj prompt'
    jj log --ignore-working-copy --no-graph --color always -r @ -T '
        surround(
            " (",
            ")",
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
                    label(if(empty, "empty", "author"), "(no desc)")
                ),
                change_id.shortest(),
                commit_id.shortest(),
                if(conflict, label("conflict", "(C)")),
                if(empty, label("empty", "(E)")),
                if(divergent, "(D)"),
                if(hidden, "(H)"),
            )
        )
    '
end
