#!/bin/bash

# A simple script to execute a curl command a given number of times.
#
# Usage:
# ./loop_curl.sh <count> <url>
#
# Example:
# ./loop_curl.sh 5 "http://localhost:8080"
# This will curl http://localhost:8080 five times.

# Check if both arguments are provided.
if [ "$#" -le 1 ]; then
    echo "Usage: $0 <count> <url>"
    exit 1
fi

# Assign arguments to variables for clarity.
COUNT=$1
URL=${2:-"http://localhost:8080/"}

echo "Running curl on '$URL' $COUNT times..."
echo "-------------------------------------"

# Loop from 1 to the specified count.
for i in $(seq 1 $COUNT)
do
   # Print which iteration we are on.
   echo "Request #$i"

   # Execute the curl command.
   # -s : Silent mode (don't show progress meter)
   # -o /dev/null : Discard the response body (we only care if the request succeeds)
   # -w "..." : Print specific timing information and the HTTP status code.
   curl -H "Authorization: Bearer $(gcloud auth print-identity-token)" "$URL"
 done

echo "-------------------------------------"
echo "Done."

