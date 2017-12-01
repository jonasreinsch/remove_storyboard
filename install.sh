#!/bin/bash

if [[ $# != 1 ]]; then
    echo "Usage: $0 SCRIPT_DIRECTORY (should be in your PATH)"
    exit 1
fi

script_directory=$1



if [[ ! -d "$script_directory" ]]; then
    echo "${script_directory} does not exist or is no directory"
    exit 1
fi

# - normalize the script directory (readlink -f not available under OS X,
#   therefore emulate it)
# - the -P option tells pwd to display the 'physical' path,
#   without symbolic links
# - we do this here in order to turn ~/bin/ into ~/bin
# - (possibly wrong) assumption: no symbolic links in $PATH
script_directory="$(unset CDPATH && cd "$script_directory" && pwd -P)"

# see https://stackoverflow.com/a/1397020
# without the above normalization, ~/bin/ won't be found here
if [[ ! ":$PATH:" == *":$script_directory:"* ]]; then
    echo "${script_directory} not in path"
    exit 1
fi

cp -v -i remove_storyboard_helper.sh "${script_directory}/remove_storyboard_helper.sh"
cp -v -i remove_storyboard.sh "${script_directory}/remove_storyboard"


