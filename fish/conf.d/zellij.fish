status is-interactive; or return

# detach through sh so fish doesn't track (and report on) the job
function __corner_daemon_ensure --on-event fish_prompt
    sh -c '~/dots/scripts/corner-daemon ensure >/dev/null 2>&1 &'
end
