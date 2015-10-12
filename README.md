# Remove Storyboard

When you create a new project with XCode, then this script

1. removes the file `Main.storyboard`
2. removes the reference to it in the `.pbxproj` file (i.e. it will disappear from the Project Navigator)
3. edits the `Info.plist` and deletes the `UIMainStoryboardFile` entry there
4. edits the `AppDelegate.swift` file so that the `ViewController` is set as root view controller via code

Usage:

    $ ./remove_storyboard.sh DIRECTORY_OF_NEWLY_CREATED_PROJECT
