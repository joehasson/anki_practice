#!/bin/bash
# Exit with status code 1 if there are not exactly
# one inputs
if [ $# -ne 1 ]; then
    echo "Usage: $0 <test_file.c>"
    exit 1
fi

# Strip the file extension from the first input file name
executable_name=${1%.c}

# Compile the test file and the unity test framework
gcc -o $executable_name $1 unity.c

# Run the executable and save the exit code
./$executable_name
exit_code=$?

# Remove the executable
rm $executable_name

# Exit with the exit code from the executable
exit $exit_code

