#!/bin/bash

for module in ./*; do
  if [ -f "$module" ]; then
    continue
  fi

  (cd "$module" && git pull origin master)
done
