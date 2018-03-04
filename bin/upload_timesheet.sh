#!/bin/bash

# A simple cURL OAuth2 authenticator
# depends on Python's built-in json module to prettify output
#
# Usage:
# ./google-oauth2.sh create - authenticates a user
# ./google-oauth2.sh refresh <token> - gets a new token
#

# Store our credentials in our home directory with a file called .
my_creds=~/.timesheet/.creds
my_client_secret=~/.timesheet/.google_client_secret
my_timesheet=~/.timesheet/.sheet_id
client_id="853081442996-ppfu99poj9gdlf7p9e634hh5rr78d9ug.apps.googleusercontent.com"

echo "$my_creds"
# create your own client id/secret
# https://developers.google.com/identity/protocols/OAuth2InstalledApp#creatingcred

if [ ! -d ~/.timesheet/ ]; then
  mkdir -p ~/.timesheet/;
fi

if [ -s $my_creds ] && [ -s $my_client_secret ] && [ -s $my_timesheet ]; then
  # if we already have a token stored, use it
  . $my_creds
  timesheet_id=`cat $my_timesheet`
  client_secret=`
  time_now=`date +%s`
else
  echo "Please enter your Google Client Secret"
  echo
  read client_secret
  echo -e "$client_secret" > $my_client_secret

  echo "Please enter your Google Sheet ID"
  echo
  read timesheet_id
  echo -e "$timesheet_id" > $my_timesheet

  scope='https://www.googleapis.com/auth/spreadsheets'
  # Form the request URL
  # https://developers.google.com/identity/protocols/OAuth2InstalledApp#step-2-send-a-request-to-googles-oauth-20-server
  auth_url="https://accounts.google.com/o/oauth2/v2/auth?client_id=$client_id&scope=$scope&response_type=code&redirect_uri=urn:ietf:wg:oauth:2.0:oob"

  echo "Please go to:"
  echo
  echo "$auth_url"
  echo
  echo "after accepting, enter the code you are given:"
  open -a Google\ Chrome $auth_url
  read auth_code

  # exchange authorization code for access and refresh tokens
  # https://developers.google.com/identity/protocols/OAuth2InstalledApp#exchange-authorization-code
  auth_result=$(curl -s "https://www.googleapis.com/oauth2/v4/token" \
    -H "Content-Type: application/x-www-form-urlencoded" \
    -d code=$auth_code \
    -d client_id=$client_id \
    -d client_secret=$client_secret \
    -d redirect_uri=urn:ietf:wg:oauth:2.0:oob \
    -d grant_type=authorization_code)
  access_token=$(echo -e "$auth_result" | \
                 ggrep -Po '"access_token" *: *.*?[^\\]",' | \
                 awk -F'"' '{ print $4 }')
  refresh_token=$(echo -e "$auth_result" | \
                  ggrep -Po '"refresh_token" *: *.*?[^\\]",*' | \
                  awk -F'"' '{ print $4 }')
  expires_in=$(echo -e "$auth_result" | \
               ggrep -Po '"expires_in" *: *.*' | \
               awk -F' ' '{ print $3 }' | awk -F',' '{ print $1}')rep
  time_now=`date +%s`
  expires_at=$((time_now + expires_in - 60))
  echo -e "access_token=$access_token\nrefresh_token=$refresh_token\nexpires_at=$expires_at" > $my_creds
fi

# if our access token is expired, use the refresh token to get a new one
# https://developers.google.com/identity/protocols/OAuth2InstalledApp#offline
if [ $time_now -gt $expires_at ]; then
  refresh_result=$(curl -s "https://www.googleapis.com/oauth2/v4/token" \
   -H "Content-Type: application/x-www-form-urlencoded" \
   -d refresh_token=$refresh_token \
   -d client_id=$client_id \
   -d client_secret=$client_secret \
   -d grant_type=refresh_token)
  access_token=$(echo -e "$refresh_result" | \
                 ggrep -Po '"access_token" *: *.*?[^\\]",' | \
                 awk -F'"' '{ print $4 }')
  expires_in=$(echo -e "$refresh_result" | \
               ggrep -Po '"expires_in" *: *.*' | \
               awk -F' ' '{ print $3 }' | awk -F',' '{ print $1 }')
  time_now=`date +%s`
  expires_at=$(($time_now + $expires_in - 60))
  echo -e "access_token=$access_token\nrefresh_token=$refresh_token\nexpires_at=$expires_at" > $my_creds
fi

# Call google sheets api and update timesheet
username=`git config --get user.name`
curr_month=`date +%b | tr /a-z/ /A-Z/`
project_name=`basename $(git rev-parse --show-toplevel)`
echo "$project_name"

start_arr="{ \"values\": [ "

end_arr="[] ], \"majorDimension\": \"ROWS\", \"range\": \"$curr_month!B5:D5\"}"

#Get commits for user from the past week
commits=`git log --since="last week" \
          --date=format:'%b %d'\
          --author="$username" \
          --pretty='["'"wecan"'", "%ad","%s","%H"],'`

#Build json
json=$start_arr$commits$end_arr

#Build URI
uri="https://content-sheets.googleapis.com/v4/spreadsheets/$timesheet_id/values/$curr_month!B5:D5:append?responseValueRenderOption=FORMATTED_VALUE&insertDataOption=INSERT_ROWS&valueInputOption=USER_ENTERED&responseDateTimeRenderOption=SERIAL_NUMBER&includeValuesInResponse=true&alt=json"

echo "Uploading git commits to Google Sheet"
api_cmd="curl -X POST -H \"Authorization: Bearer $access_token\" -H \"Content-Type: application/json\" -d '$json' -sS '$uri'"
echo $api_cmd
eval $api_cmd
