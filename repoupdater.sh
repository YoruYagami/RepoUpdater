#!/bin/bash

# Definizione dei colori: verde, giallo, rosso e reset
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m' # No Color

function update_repo() {
    local repo="$1"
    if [ -d "$repo/.git" ]; then
        pushd "$repo" > /dev/null
        echo -e "${GREEN}Updating $repo...${NC}"
        pull_output=$(git pull 2>&1)
        exit_code=$?
        if [ $exit_code -eq 0 ]; then
            if echo "$pull_output" | grep -q "Already up to date."; then
                echo -e "${YELLOW}No changes, skipping update.${NC}"
            else
                echo -e "${GREEN}Repository updated:${NC}"
                echo "$pull_output"
            fi
        else
            echo -e "${RED}Error updating!${NC}"
            echo "$pull_output"
        fi
        popd > /dev/null
    fi
}

function update_recursive() {
    local dir="$1"
    pushd "$dir" > /dev/null
    for d in */ ; do
        if [ -d "$d/.git" ]; then
            update_repo "$(realpath "$d")"
        elif [ -d "$d" ]; then
            update_recursive "$(realpath "$d")"
        fi
    done
    popd > /dev/null
}

REPO_DIRECTORY="$1"
SINGLE_REPO="$2"

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
