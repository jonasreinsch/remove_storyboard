# Script to remove Xcode storyboard for iOS/Swift projects

When you create a new project with Xcode, then this script

1. removes the file `Main.storyboard`
2. removes the reference to it in the `.pbxproj` file (i.e. it will disappear from the Project Navigator)
3. edits the `Info.plist` and deletes the `UIMainStoryboardFile` entry there
4. edits the `AppDelegate.swift` file so that the `ViewController` is set as root view controller via code

## Installation:

    $ ./install.sh $YOUR_SCRIPT_DIRECTORY # should be in your $PATH

## Usage:

    $ cd $PROJECT_DIRECTORY
    $ remove_storyboard
