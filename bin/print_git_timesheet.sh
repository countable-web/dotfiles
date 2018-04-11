#!/bin/bash
#
# A script to upload git commitsto a timesheet in Google Docs
#

# Store our credentials in our home directory with a file called .
#Get commits for user from the past week

project_name=`basename $(git rev-parse --show-toplevel)`

commits=`git log --since="last week" \
          --date=format:'%b %d'\
          --author="$username" \
          --pretty=''$project_name',%ad,%s,%H'`
echo "$commits"



