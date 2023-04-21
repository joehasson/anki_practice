#!/bin/bash
# Exit with status code 1 if there are not exactly
# one inputs
if [ $# -ne 1 ]; then
    echo "Usage: $0 <test_file.c>"
    exit 1
fi

# Strip the file extension from the first input file name
executable_name=${1%.c}
gcc -o $executable_name $1 unity.c
./$executable_name
rm $executable_name

