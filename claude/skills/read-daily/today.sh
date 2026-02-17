#!/bin/sh
cat ~/notes/daily/"$(date +%Y-%m-%d)".md 2>/dev/null || echo "(no daily note for today)"
