#!/bin/bash

dir="$1"

# No directory has been provided, use current
if [ -z "$dir" ]
then
  dir="`pwd`"
fi

# Make sure directory ends with "/"
if [[ $dir != */ ]]
then
  dir="$dir/*"
else
  dir="$dir*"
fi

# Loop all sub-directories
for f in $dir
do
  # Only interested in directories
  [ -d "${f}" ] || continue

  echo -en "\033[0;34m"
  echo -en "${f} - "
  echo -en "\033[0m"

  # Check if directory is a git repository
  if [ -d "$f/.git" ]
  then
    mod=0
    cd $f
    echo -en "\033[0;33m"
    echo "$(git status)"
    echo -en "\033[0m"

    cd ../
  else
    echo -en "\033[0;31m"
    echo "Not a git repository"
    echo -en "\033[0m"
  fi

  echo
done
