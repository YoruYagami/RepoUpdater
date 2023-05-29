# RepoUpdater

RepoUpdater is a bash script designed to automate the process of updating multiple git repositories at once. This is particularly useful when you have a large number of repositories that need to be kept up-to-date, such as when you are managing a big project or multiple projects.

## Features

- Update all repositories in a specified directory
- Update a specific repository in a directory
- Update repositories recursively in subdirectories
- Force update even when there are uncommitted changes
- Clean up repositories after update
- Customizable timeout for git pull
- Customizable logfile
- Colorful output
- Progress tracking

## Usage

The general syntax is as follows:

```bash
./repoupdater [-q] [-f] [-c] [-t timeout] [-l logfile] [repo_directory] [single_repo]

Explanation
-q - Quiet mode
-f - Force update even when there are uncommitted changes
-c - Clean up repositories after update
-t timeout - Set custom timeout for git pull
-l logfile - Set custom logfile
repo_directory - The directory that contains the repositories you want to update
single_repo - The specific repository you want to update
```
Please note that if repo_directory or single_repo is not specified, you will be prompted to enter it.

## Installation

```bash
  git clone https://github.com/YoruYagami/RepoUpdater.git
  cd RepoUpdater
  sudo chmod +x repoupdater.sh
  sudo ./repoupdater.sh
```