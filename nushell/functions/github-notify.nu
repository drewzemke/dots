# github notifications for zjstatus corner
#
# uses gh cli to fetch notifications, caches results to avoid API spam
# designed for non-blocking prompt integration

use corner-update.nu

const STATE_FILE = "/tmp/github-notifications.nuon"
const DEFAULT_CACHE_SECONDS = 60

def cache-duration [] {
  let secs = $env.GITHUB_NOTIFY_CACHE_SECONDS? | default $DEFAULT_CACHE_SECONDS | into int
  $"($secs)sec" | into duration
}

# map github notification reasons to short labels
def reason-label [reason: string, type: string] {
  match $reason {
    "review_requested" => "pr"
    "author" if $type == "PullRequest" => "pr"
    "ci_activity" => "ci"
    "mention" => "@"
    "team_mention" => "@"
    "comment" => "cmt"
    "subscribed" => "sub"
    "state_change" => "sub"
    _ => "other"
  }
}

# fetch notifications from github and update state
export def fetch [] {
  let notifications = try {
    gh api /notifications | from json
  } catch {
    []
  }

  # count by reason label
  let counts = $notifications
    | each {|n| reason-label $n.reason $n.subject.type }
    | uniq --count
    | reduce --fold {} {|row, acc|
        $acc | insert $row.value $row.count
      }

  # write state
  {
    fetched_at: (date now | format date "%+")
    counts: $counts
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

# refresh if stale (non-blocking, for prompt hook)
export def maybe-refresh [] {
  if (stale?) {
    # spawn detached so prompt doesn't wait
    # pass ZELLIJ_SESSION_NAME so background process can update corner
    let module = $"($env.HOME)/dots/nushell/functions/github-notify.nu"
    let session = $env.ZELLIJ_SESSION_NAME? | default ""
    sh -c $"ZELLIJ_SESSION_NAME='($session)' nu -c 'use ($module); github-notify fetch' >/dev/null 2>&1 &"
  }
}

# clear github notifications
export def clear [] {
  rm -f $STATE_FILE
  corner-update
}

# show current notification counts
export def show [] {
  if ($STATE_FILE | path exists) {
    open $STATE_FILE
  } else {
    { fetched_at: null, counts: {} }
  }
}
