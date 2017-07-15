#!/bin/bash

##
 # Merge two or more csv file.
 #
 # Author: DEB
##

HELP="\
Usage: $(basename $0) [options] FILES...
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

if [[ $# -lt 2 ]]; then
  echo "Invalid option, use -h for help" >&2
  exit 1
fi

if [[ $output ]]; then
  head -n 1 "$1" > $output
else
  head -n 1 "$1"
fi

while [[ $# -gt 0 ]]
do
  if [[ $output ]]; then
    tail -n +2 "$1" >> $output
  else
    tail -n +2 "$1"
  fi
  shift
done
