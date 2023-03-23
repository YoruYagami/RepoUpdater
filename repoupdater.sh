#!/bin/bash

if [ $(id -u) -ne 0 ]; then
    echo "This script must be run as root. Please run with sudo."
    exit 1
fi

# define colors for green and red text
GREEN='\033[0;32m'
RED='\033[0;31m'
NC='\033[0m' # No Color

function update_repo() {
    local repo=$1
    if [ -d "$repo/.git" ]; then
        pushd "$repo" > /dev/null
        echo -e "${GREEN}Updating $repo...${NC}"
        if git pull --quiet; then
            echo -e "${GREEN}Up to date!${NC}"
        else
            echo -e "${RED}Error updating!${NC}"
        fi
        popd > /dev/null
    fi
}

function update_recursive() {
    local dir=$1
    pushd "$dir" > /dev/null

    for d in */ ; do
        if [ -d "$d/.git" ]; then
            update_repo "$d"
        elif [ -d "$d" ]; then
            update_recursive "$(realpath "$d")"
        fi
    done

    popd > /dev/null
}

REPO_DIRECTORY=$1
SINGLE_REPO=$2

if [ -z "$REPO_DIRECTORY" ]; then
    REPO_DIRECTORY="."
fi

if [ -z "$SINGLE_REPO" ]; then
    update_recursive "$(realpath "$REPO_DIRECTORY")"
    echo -e "${GREEN}All repositories updated!${NC}"
else
    update_repo "$(realpath "$REPO_DIRECTORY/$SINGLE_REPO")"
    echo -e "${GREEN}Selected repository updated!${NC}"
fi
