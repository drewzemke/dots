#!/bin/sh
# background loop that updates zjstatus corner widgets
# args: <pid_file> <media_script> <gh_script> <army_script>

PID_FILE="$1"
MEDIA_SCRIPT="$2"
GH_SCRIPT="$3"
ARMY_SCRIPT="$4"

mkdir -p "$(dirname "$PID_FILE")"

# kill any previous loop for this session
if [ -f "$PID_FILE" ]; then
  old_pid=$(cat "$PID_FILE" 2>/dev/null)
  if [ -n "$old_pid" ] && kill -0 "$old_pid" 2>/dev/null; then
    kill "$old_pid" 2>/dev/null
    # wait briefly so the old process cleans up
    sleep 0.5
  fi
fi

echo $$ > "$PID_FILE"
trap 'rm -f "$PID_FILE"; exit' INT TERM

i=0
while true; do
  "$MEDIA_SCRIPT" fetch 2>/dev/null
  if [ $((i % 6)) -eq 0 ]; then
    "$GH_SCRIPT" fetch 2>/dev/null
  fi
  if [ $((i % 3)) -eq 0 ]; then
    "$ARMY_SCRIPT" fetch 2>/dev/null
  fi
  i=$((i + 1))
  sleep 5
done
