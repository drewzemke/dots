#!/usr/bin/env fish

set repo_name (set_color yellow)(basename (pwd))
set run_status (gh run list --event push --json conclusion --jq '.[] | select(.conclusion != "skipped") | .conclusion' | head -n 1)

switch $run_status
    case failure startup_failure
        echo $repo_name (set_color red)\u25CF
    case cancelled
        echo $repo_name (set_color white)\u2296
    case success
        echo $repo_name (set_color green)\u25CF 
    case ''
        echo $repo_name (set_color white)\u25CB
end

# unicode symbol reference
# \u25CF filled circle
# \u25CB open solid circle
# \u2296 circle with a line through it
