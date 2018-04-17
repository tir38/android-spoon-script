#!/usr/bin/env bash

# constants
readonly DEFAULT_BRANCH="master"
readonly PROJECT_LOCATION="/Users/me/my_app"
readonly UPLOAD_LOCATION="/Users/me/Google Drive/spoon results"

declare -a modules=("app" 
		"android_library"
                )


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

printf "\\n--------- Running gradle clean ---------\\n"
./gradlew clean


# loop through each module
for i in "${modules[@]}"
do
  printf "\\n--------- Running spoon on module: %s ---------\\n" "$i"
  ./gradlew "$i":spoonDebug
done

printf "\\n--------- Uploading results ---------\\n"

base_upload_directory="$UPLOAD_LOCATION/$USER/$(timestamp)_$branch_name"
for i in "${modules[@]}"
do
  open "$PROJECT_LOCATION/$i/build/spoon-output/debug/index.html"

  # upload output to Google Drive, Dropbox, etc. 
  # by copying files to EXISTING Google Drive, Dropbox folder
  # and let their auto-sync functionality do the work for you

  upload_directory="$base_upload_directory/$i"
  mkdir -p "$upload_directory"
  cp -R "$PROJECT_LOCATION/$i/build/spoon-output/debug" "$upload_directory"
  printf "results uploaded to: %s\\n" "$upload_directory"

done

# code checked via https://www.shellcheck.net/

