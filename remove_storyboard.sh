#!/bin/bash

if [[ $# != 0 ]]; then
    echo "Usage: $0 (no args - or use remove_storyboard_helper.sh directly)"
    exit 1
fi

# test if we are in a git repository
git -C . rev-parse &> /dev/null
if [[ $? != 0 ]]; then
    echo "Expects to be run from within a git repository. Exiting."
    exit 1
fi

if [[ -n $(git status --porcelain) ]]; then
    echo "Please commit your changes before running this script."
    exit 1
fi

# - remove_storyboard_helper.sh is expected in the same directory
#   as remove_storyboard.sh (script_directory)
# - normalize the script directory (readlink -f not available under OS X,
#   therefore emulate it)
# - the -P option tells pwd to display the 'physical' path,
#   without symbolic links
script_directory="$(unset CDPATH && cd $(dirname $0) && pwd -P)"

"${script_directory}"/remove_storyboard_helper.sh .

if [[ $? != 0 ]]; then
    echo "remove_storyboard_helper.sh returned an error."
    exit 1
fi

git_command="git add .; git commit -m 'remove storyboard'"
echo "Copied to pasteboard: ${git_command}"
echo -n "${git_command}" | pbcopy



