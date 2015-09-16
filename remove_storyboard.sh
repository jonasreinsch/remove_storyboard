#!/bin/bash

if [[ $# != 1 ]]; then
    echo Usage: $0 PROJECT_DIRECTORY
    exit 1
fi

project_directory="$1"

if [[ ! -e "$project_directory" ]]; then
    echo $project_directory does not exist
    exit 1
fi

if [[ ! -d "$project_directory" ]]; then
    echo $project_directory exists, but is not a directory
    exit 1
fi

# normalize the project directory (readlink -f not available under OS X,
# therefore emulate it)
project_directory="$(unset CDPATH && cd "$project_directory" && pwd)"

project_name="$(basename $project_directory)"

info_plist_file="${project_directory}/${project_name}/Info.plist"

if [[ ! -e "$info_plist_file" ]]; then
    echo $info_plist_file does not exist
    exit 1
fi

if [[ ! -r "$info_plist_file" ]]; then
    echo $info_plist_file does exist, but is not readable
    exit 1
fi

project_file="${project_directory}/${project_name}.xcodeproj/project.pbxproj"

if [[ ! -e "$project_file" ]]; then
    echo $project_file does not exist
    exit 1
fi

if [[ ! -r "$project_file" ]]; then
    echo $project_file does exist, but is not readable
    exit 1
fi

storyboard_file="${project_directory}/${project_name}/Base.lproj/Main.storyboard"

if [[ ! -e "$storyboard_file" ]]; then
    echo $storyboard_file does not exist
    exit 1
fi

if [[ ! -r "$storyboard_file" ]]; then
    echo $storyboard_file does exist, but is not readable
    exit 1
fi

app_delegate_file="${project_directory}/${project_name}/AppDelegate.swift"

if [[ ! -e "$app_delegate_file" ]]; then
    echo $app_delegate_file does not exist
    exit 1
fi

if [[ ! -r "$app_delegate_file" ]]; then
    echo $app_delegate_file does exist, but is not readable
    exit 1
fi

project_file_tmp=$(mktemp "project_file.XXXXXX")

./remove_storyboard.pl "${project_file}" > "${project_file_tmp}"

mv "${project_file_tmp}" "${project_file}"

rm "${storyboard_file}"

PATTERN='// Override point for customization after application launch.'

read -r -d '' REPLACEMENT << EOM
        // Override point for customization after application launch.

        window = UIWindow(frame: UIScreen.mainScreen().bounds)
        if let window = window {
            window.rootViewController = ViewController()
            window.makeKeyAndVisible()
            window.backgroundColor = UIColor.whiteColor()
        }
EOM

perl -pi -E"s<$PATTERN><$REPLACEMENT>" "${app_delegate_file}"

/usr/libexec/PlistBuddy "$info_plist_file" -c "Delete UIMainStoryboardFile";
