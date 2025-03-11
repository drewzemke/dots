#!/usr/bin/env fish

# set pane name
zellij action rename-pane "New Tab"

# prompt for tab/dir name
set prompt (set_color blue)"Name"(set_color normal)": "(set_color yellow)
read -P $prompt tab_name

# see if z knows something
set tab_name_split (string split " " $tab_name)
set zoxide_result (zoxide query $tab_name_split 2> /dev/null)

# open a new tab
if test -z $zoxide_result
    zellij action new-tab --layout default --name $tab_name
else
    zellij action new-tab --layout default --name $tab_name --cwd $zoxide_result
end
