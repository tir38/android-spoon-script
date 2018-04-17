## Shell script to run Spoon on a dedicated machine

Running [Spoon](http://square.github.io/spoon/) is great, but it's most helpful when it can run on a dedicated machine w/out interfering with your normal development work.

This script makes it easy to:

1. pull a specific branch of a git repo
2. run Spoon
3. upload results to Google Drive or Dropbox

Now it's easy for developers and non-developers alike to trigger a Spoon build and share results with the rest of the team.

## Prerequisites

1. Have Spoon already setup and running on your Android app
2. Have [Spoon Gradle Plugin for AGP 3.x](https://github.com/jaredsburrows/gradle-spoon-plugin) setup. This may also work with [Spoon Gradle Plugin for AGP 2.x](https://github.com/stanfy/spoon-gradle-plugin) but it is not tested.
2. A *nix machine with:
	* git installed
	* Android build tools installed
	* Google Drive or Dropbox desktop client setup and syncing
	* Test devices plugged in via USB
3. A shared folder on Google Drive or Dropbox for your team to use

## Setup

In the script, update the default values:

```
readonly DEFAULT_BRANCH="master"
readonly PROJECT_LOCATION="/Users/me/my_app"
readonly UPLOAD_LOCATION="/Users/me/Google Drive/spoon results"
declare -a modules=("app")
```

## Run

```
$./spoon_script.sh
```

You will be asked to type in the branch you want to test against, or just hit enter to continue with default value.

## Output

```
$./spoon_script.sh
What branch do you want to test? (default is master)

You selected branch: some_feature

--------- CDing into project ---------
/Users/me/my_app

--------- Pulling some_feature branch ---------
Already on 'some_feature'
Your branch is up to date with 'origin/some_feature'.
Already up to date.

--------- List of devices tests will run on ---------
List of devices attached
0261cc10672cb0ed	device


--------- Running gradle clean ---------
...

--------- Running spoon on module: app ---------
...

--------- Uploading results ---------
results uploaded to: /Users/me/Google Drive/spoon results/me/2018-04-17_12-56-17_some_feature/app

```

## Multiple Gradle Modules

The [Spoon Gradle Plugin for AGP 3.x](https://github.com/jaredsburrows/gradle-spoon-plugin) allows running Spoon on multiple Gradle modules. So you can specify multiple modules in this script and it will run Spoon on each and upload results for each.

```
declare -a modules=("app" 
		"android_library"
)
```

```
Google Drive/
├── spoon results/
│   ├── me
│   │   ├── 2018-04-17_12-56-17_some_branch
│   │   │   ├── android_library
│   │   │   │   ├── debug
│   │   │   │   │   ├── index.html
│   │   │   │   │   ├── ...
│   │   │   ├── app
│   │   │   │   ├── debug
│   │   │   │   │   ├── index.html
│   │   │   │   │   ├── ...
```
