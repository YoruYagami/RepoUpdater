#!/bin/bash

set -e

# define colors for green, yellow and red text
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m' # No Color

VERBOSE=1
FORCE=0
LOGFILE="update_git.log"
TIMEOUT=30
CLEANUP=0
TOTAL_REPOS=0
UPDATED_REPOS=0

usage() {
    echo "Usage: $0 [-q] [-f] [-c] [-t timeout] [-l logfile] [repo_directory] [single_repo]"
    echo "Options:"
    echo "  -q              Quiet mode"
    echo "  -f              Force update even when there are uncommitted changes"
    echo "  -c              Clean up repositories after update"
    echo "  -t timeout      Set custom timeout for git pull"
    echo "  -l logfile      Set custom logfile"
    exit 1
}

trap 'echo -e "${RED}Script interrupted by user${NC}"; exit 1' INT

if ! command -v git &> /dev/null; then
    echo -e "${RED}git command not found! Please install git.${NC}"
    exit 1
fi

while getopts "qfct:l:" opt; do
  case $opt in
    q)
      VERBOSE=0
      ;;
    f)
      FORCE=1
      ;;
    c)
      CLEANUP=1
      ;;
    t)
      TIMEOUT=$OPTARG
      ;;
    l)
      LOGFILE=$OPTARG
      ;;
    *)
      usage
      ;;
  esac
done

shift $((OPTIND -1))

if [ $(id -u) -ne 0 ]; then
    echo "This script must be run as root. Please run with sudo."
    exit 1
fi

function update_repo() {
    local repo=$1
    TOTAL_REPOS=$((TOTAL_REPOS + 1))
    if [ -d "$repo/.git" ]; then
        if [ $(git -C "$repo" status --porcelain | wc -l) -gt 0 ]; then
            echo -e "${RED}There are uncommitted changes in $repo, skipping...${NC}" | tee -a $LOGFILE
            return
        fi

        [ $VERBOSE -eq 1 ] && echo -e "${YELLOW}($UPDATED_REPOS/$TOTAL_REPOS) Updating $repo...${NC}" | tee -a $LOGFILE
        if timeout $TIMEOUT git -C "$repo" pull --quiet || [ $FORCE -eq 1 ]; then
            UPDATED_REPOS=$((UPDATED_REPOS + 1))
        else
            echo -e "${RED}($UPDATED_REPOS/$TOTAL_REPOS) Error updating!$(git -C "$repo" pull 2>&1)${NC}" | tee -a $LOGFILE
            return
        fi

        if [ $CLEANUP -eq 1 ]; then
            git -C "$repo" remote prune origin
            git -C "$repo" clean -f -d
        fi
    else
        echo -e "${RED}The directory $repo is not a Git repository!${NC}" | tee -a $LOGFILE
        exit 1
    fi
}

function update_recursive() {
    local dir=$1
    for d in $dir/* ; do
        if [ -d "$d/.git" ]; then
            update_repo "$d"
        elif [ -d "$d" ]; then
            update_recursive "$d"
        fi
    done
}

REPO_DIRECTORY=$1
SINGLE_REPO=$2

if [ -z "$REPO_DIRECTORY" ]; then
    read -p "Please enter the repository directory (. for current directory): " REPO_DIRECTORY
    REPO_DIRECTORY=${REPO_DIRECTORY:-"."}
fi

if [ ! -d "$REPO_DIRECTORY" ]; then
    echo -e "${RED}The directory $REPO_DIRECTORY does not exist!${NC}" | tee -a $LOGFILE
    exit 1
fi

if [ -z "$SINGLE_REPO" ]; then
    update_recursive "$(realpath "$REPO_DIRECTORY")"
    [ $VERBOSE -eq 1 ] && echo -e "${GREEN}All repositories updated!${NC}" | tee -a $LOGFILE
else
    update_repo "$(realpath "$REPO_DIRECTORY/$SINGLE_REPO")"
    [ $VERBOSE -eq 1 ] && echo -e "${GREEN}Selected repository updated!${NC}" | tee -a $LOGFILE
fi