#!/bin/sh
set -euo pipefail

# supply any argument to recreate the brewfile
print_usage() {
  printf "Usage: -b specifies creating a new brewfile."
}

newBrewfile='false'
while getopts 'b' flag; do
  case "${flag}" in
    b) newBrewfile='true' ;;
    *) print_usage
       exit 1 ;;
  esac
done

if "$newBrewfile" -eq 'true'; then
    brew bundle dump --force
fi


declare -a ExcludeFromWork=("iReal Pro" "Reeder" "Streaks" "yt-dlp" "node" "qbittorrent" "steam" "freedom" "Logic Pro" "Final Cut Pro" "GoodNotes")
declare -a ExcludeFromPersonal=("Okta Verify")

cp Brewfile Brewfile-work
cp Brewfile Brewfile-personal

for val in ${ExcludeFromWork[@]}; do
    sed -i '' '/'"$val"'/d' ./Brewfile-work
done

for val in ${ExcludeFromPersonal[@]}; do
    sed -i '' '/'"$val"'/d' ./Brewfile-personal
done
