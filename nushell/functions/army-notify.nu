# army-of-daemons status for zjstatus corner
#
# runs `army status` and caches the result

use corner-update.nu

const STATE_FILE = "/tmp/army-status.nuon"
const DEFAULT_CACHE_SECONDS = 15

def cache-duration [] {
  $"($DEFAULT_CACHE_SECONDS)sec" | into duration
}

# fetch army status and update cache
export def fetch [] {
  let status = if (which army | is-not-empty) {
    try { ^army status | str trim } catch { "" }
  } else {
    ""
  }

  {
    fetched_at: (date now | format date "%+")
    status: $status
  } | save --force $STATE_FILE

  corner-update
}

# check if cache is stale
export def "stale?" [] {
  if not ($STATE_FILE | path exists) {
    return true
  }

  let state = try {
    open $STATE_FILE
  } catch {
    return true
  }

  let fetched = try {
    $state.fetched_at | into datetime
  } catch {
    return true
  }

  let age = (date now) - $fetched
  $age >= (cache-duration)
}

# refresh if stale (non-blocking)
export def maybe-refresh [] {
  if (stale?) {
    let module = $"($env.HOME)/dots/nushell/functions/army-notify.nu"
    let session = $env.ZELLIJ_SESSION_NAME? | default ""
    sh -c $"ZELLIJ_SESSION_NAME='($session)' nu -c 'use ($module); army-notify fetch' >/dev/null 2>&1 &"
  }
}

# clear state
export def clear [] {
  rm -f $STATE_FILE
  corner-update
}
