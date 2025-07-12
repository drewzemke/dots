function fish_vcs_prompt --description 'Print all vcs prompts'
    # Is jj installed and are we in a jj repo?
    if command -sq jj; and jj root --quiet &>/dev/null
       fish_jj_prompt $argv
       return
    end

    # otherwise fall back to git
    fish_git_prompt $argv
end
