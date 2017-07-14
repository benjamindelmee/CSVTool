#!/bin/bash

##
 # Add a column to a csv file.
 #
 # Author: DEB
##

HELP="\
Usage: $(basename $0) [options] COLUMN_NAME FILE
    -h              \t Display this information
    -v <value>      \t Fill the new column with <value> (default is empty)
    -s <separator>  \t Use <separator> to separate columns (default is pipe)
    -o <file>       \t Place the output into <file>"

# default values for options
value=""
separator="|"

while getopts "v:s:o:h" opt
do
  case $opt in
    "v")
      value="$OPTARG"
      ;;
    "s")
      separator="$OPTARG"
      ;;
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

if [[ $# -ne 2 ]]; then
  echo "Invalid option, use -h for help" >&2
  exit 1
else
  column_name="$1"
  file="$2"
fi

awk_script='
    NR == 1 { print COLNAME SEP $0 }
    NR != 1 { print VALUE SEP $0 }
'

if [[ $output ]]; then
  awk -v COLNAME=$column_name -v VALUE=$value -v SEP=$separator "$awk_script" $file > $output
else
  awk -v COLNAME=$column_name -v VALUE=$value -v SEP=$separator "$awk_script" $file
fi
