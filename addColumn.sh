#!/bin/bash

##
 # Author: Benjamin Delmée
##

HELP="\
Usage: $(basename $0) [options] COLUMN_NAME FILE
Add a new column to a CSV file.
The column is added at the end of each line.

Arguments:
    COLUMN_NAME     \t Name of the column to be added
    FILE            \t The column will be added to the FILE
Options:
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
    NR == 1 { print $0 SEP COLNAME }
    NR != 1 { print $0 SEP VALUE }
'

if [[ $output ]]; then
  awk -v COLNAME=$column_name -v VALUE=$value -v SEP=$separator "$awk_script" $file > $output
else
  awk -v COLNAME=$column_name -v VALUE=$value -v SEP=$separator "$awk_script" $file
fi
