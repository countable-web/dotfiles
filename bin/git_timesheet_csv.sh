#!/bin/bash
#
# A script to output git commits to a csv file
#

# Store our credentials in our home directory with a file called .
#Get commits for user from the past week
timesheet_file=./timesheet.csv
project_name=`basename $(git rev-parse --show-toplevel)`

commits=`git log --since="last week" \
          --date=format:'%b %d'\
          --author="$username" \
          --pretty=''$project_name',%ad,%s,%H'`
echo -e "$commits" > $timesheet_file
