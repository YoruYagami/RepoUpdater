# RepoUpdater

This is a bash script designed to update multiple git repositories located in a directory (or a subdirectory). It takes a path to a repository directory as an optional argument, and if no argument is provided, it defaults to the current directory.

The script first defines some colors for text output, and then loops through each directory in the specified repository directory. For each directory, it checks if it's a git repository (i.e., has a .git subdirectory). If so, it navigates into the directory and pulls the latest changes from the remote repository. If the pull succeeds, it outputs a message indicating that the repository is up to date; if it fails, it outputs an error message.

Once the script has finished updating all repositories (and subdirectories), it outputs a message indicating that all repositories have been updated.


## Run Locally

```bash
  git clone https://github.com/YoruYagami/repoupdater.git
```

Go to the project directory

```bash
  cd repoupdater
```

Change Permission

```bash
  chmod +x repoupdater.sh
```

Execute

```bash
  sudo ./repoupdater.sh
```
