#!/bin/bash
while true; do
  git ls-files | entr -d debounce -d 60 sh -c '
    git add -A &&
    git commit -m "Auto-commit $(date)" &&
    git push ||
    >&2 echo "Failed to autocommit"
  '
  sleep 1 # debounce interval
done
