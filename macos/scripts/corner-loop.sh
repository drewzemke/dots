#!/bin/sh
# background loop that updates zjstatus corner widgets
# args: <pid_file> <media_module> <gh_module>

PID_FILE="$1"
MEDIA_MOD="$2"
GH_MOD="$3"

mkdir -p "$(dirname "$PID_FILE")"
echo $$ > "$PID_FILE"
trap 'rm -f "$PID_FILE"; exit' INT TERM

i=0
while true; do
  nu -c "use $MEDIA_MOD; media-notify fetch" 2>/dev/null
  if [ $((i % 6)) -eq 0 ]; then
    nu -c "use $GH_MOD; github-notify fetch" 2>/dev/null
  fi
  i=$((i + 1))
  sleep 5
done
