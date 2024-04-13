#!/bin/bash

files=()

# Iterate over each argument
for arg in "$@"; do
    # Check if the argument is a valid file or directory
    if [ -e "$arg" ]; then
        # Add the file path to the array
        files+=("$arg")
    else
        echo "$arg does not exist."
    fi
done

echo "${files[@]}"

inotifywait -m -e create -e moved_to "${files[@]}" |
  while read path action file; do
    file_path=$path$file
    if [ -d $file_path ]; then
        killall -9 java;
        /config/tinyMediaManagerCMD.sh -scrapeUnscraped -rename
        /startapp.sh
    fi
  done