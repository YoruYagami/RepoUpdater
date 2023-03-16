#!/bin/bash

# define colors for green and red text
GREEN='\033[0;32m'
RED='\033[0;31m'
NC='\033[0m' # No Color

# get the repository directory path from the first command line argument
REPO_DIRECTORY=$1

# if no path is provided, use the current directory
if [ -z "$REPO_DIRECTORY" ]; then
    REPO_DIRECTORY="."
fi

# change directory to the specified repo directory
cd $REPO_DIRECTORY

# loop through each directory in the repo directory
for d in */ ; do
    # check if it's a directory and has a .git subdirectory
    if [ -d "$d/.git" ]; then
        # navigate into the directory and pull the latest changes
        cd $d
        echo -e "${GREEN}Updating $d...${NC}"
        if git pull --quiet; then
            echo -e "${GREEN}Up to date!${NC}"
        else
            echo -e "${RED}Error updating!${NC}"
        fi
        # navigate back to the repo directory
        cd ..
    elif [ -d "$d" ]; then
        # navigate into the subdirectory and run the script recursively
        echo "Navigating into $d..."
        bash $(dirname $0)/$(basename $0) "$REPO_DIRECTORY/$d"
    fi
done

echo -e "${GREEN}All repositories updated!${NC}"
