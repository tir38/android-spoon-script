#!/usr/bin/env bash

# constants
readonly DEFAULT_BRANCH="develop"
readonly PROJECT_LOCATION="/Users/jasonatwood/orion/obdroid"
readonly SPOON_RESULT_LOCATION="onbeep/build/spoon-output/debug" # relative to PROJECT_LOCATION or absolute
readonly UPLOAD_LOCATION="/Users/jasonatwood/Google Drive/spoon results"


# ----------------------
# DO NOT UPDATE ANY CODE BELOW
# ----------------------

# Define a timestamp function
timestamp() {
  date +"%Y-%m-%d_%H-%M-%S"
}

# ask for user input
echo "What branch do you want to test? (default is $DEFAULT_BRANCH)"
read -r branch_name
if test -z "$branch_name"
then
	branch_name=$DEFAULT_BRANCH
fi
echo "You selected branch: $branch_name"


printf "\\n--------- CDing into project ---------\\n"
cd $PROJECT_LOCATION || exit
pwd


printf "\\n--------- Pulling %s branch ---------\\n" "$branch_name"
git checkout $branch_name
git pull -f


printf "\\n--------- List of devices tests will run on ---------\\n"
adb devices


printf "\\n--------- Running Spoon ---------\\n"
./gradlew clean spoonDebug


printf "\\n--------- Results are ready ---------\\n"
open "$SPOON_RESULT_LOCATION/index.html"


printf "\\n--------- Uploading results ---------\\n"
# upload output to Google Drive, Dropbox, etc. 
# by copying files to EXISTING Google Drive, Dropbox folder
# and let their auto-sync functionality do the work for you

upload_directory="$UPLOAD_LOCATION/$USER/$(timestamp)_$branch_name"
mkdir -p "$upload_directory"
cp -R "$SPOON_RESULT_LOCATION" "$upload_directory"
printf "results uploaded to: %s\\n" "$upload_directory"

# code checked via https://www.shellcheck.net/

