#!/bin/bash

##
 # Author: Benjamin Delmée
##

HELP="\
Usage: $(basename $0) [options] FILEs...
Merge multiple csv file.
Keep only the header of the first file.

Arguments:
    FILEs     \t List of the FILEs to be merged
Options:
    -h        \t Display this information
    -o <file> \t Place the output into <file>"

while getopts "o:h" opt
do
  case $opt in
    "o")
      output="$OPTARG"
      ;;
    "h")
      echo -e "$HELP"
      exit 0
      ;;
    "?")
      echo "Invalid option, use -h for help" >&2
      exit 1
  esac
done
shift $(($OPTIND - 1))

if [[ $# -lt 1 ]]; then
  echo "Invalid option, use -h for help" >&2
  exit 1
fi

# Print the header found in the first file
if [[ $output ]]; then
  head -n 1 "$1" > $output
else
  head -n 1 "$1"
fi

# Exclude the header and print the data of each file
while [[ $# -gt 0 ]]
do
  if [[ $output ]]; then
    sed '1d' "$1" >> $output
  else
    sed '1d' "$1"
  fi
  shift
done
