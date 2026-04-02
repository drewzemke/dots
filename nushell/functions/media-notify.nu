# now playing for zjstatus corner
#
# uses media.swift to query macOS MediaRemote, caches to avoid slow polls

use corner-update.nu

const STATE_FILE = "/tmp/now-playing.nuon"
def media-script [] { $"($env.HOME)/dots/macos/scripts/media.swift" }
const DEFAULT_CACHE_SECONDS = 15

def cache-duration [] {
  $"($DEFAULT_CACHE_SECONDS)sec" | into duration
}

# fetch now playing state and update cache
export def fetch [] {
  let raw = try {
    ^(media-script) state | str trim
  } catch {
    "idle"
  }

  let state = if $raw == "idle" {
    { playing: false, title: "", artist: "" }
  } else {
    let parts = $raw | split row "\t"
    {
      playing: ($parts.0 == "true")
      title: ($parts | get 1? | default "")
      artist: ($parts | get 2? | default "")
    }
  }

  {
    fetched_at: (date now | format date "%+")
    ...$state
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
    let module = $"($env.HOME)/dots/nushell/functions/media-notify.nu"
    let session = $env.ZELLIJ_SESSION_NAME? | default ""
    sh -c $"ZELLIJ_SESSION_NAME='($session)' nu -c 'use ($module); media-notify fetch' >/dev/null 2>&1 &"
  }
}

# clear now playing state
export def clear [] {
  rm -f $STATE_FILE
  corner-update
}
