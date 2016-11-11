#!/bin/bash

last=$(($(date +%s%N)/1000000))

inotifywait -r -e modify -e create . -m | awk '{ print $3; fflush() }' |

while read file; do

  new=$(($(date +%s%N)/1000000))
  since=$(expr $new - $last)
  last=$new

  # debounce
  if [[ $since -ge 1 ]]; then
    ext=${file#*.}
    if [ $ext == "coffee" ]; then
      echo "compiling $file"
      coffee -c $file
    fi
    if [ $ext == "styl" ]; then
      echo "compiling $file"
      stylus $file
    fi
  fi

done
