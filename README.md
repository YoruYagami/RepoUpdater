# RepoUpdater

RepoUpdater is a simple tool to update multiple Git repositories recursively. This repository includes both Bash and PowerShell versions that function identically to pull updates for your repositories.

## Features

- Recursively searches for Git repositories in a specified directory.
- Executes `git pull` on each repository.
- Provides clear output indicating whether each repository was updated or if there were no changes.
- Supports updating a single repository or all repositories within a given directory.

## Usage

Both scripts accept two optional parameters:
- **repo_directory:** The root directory to search for Git repositories (defaults to the current directory if not provided).
- **single_repo:** (Optional) The name of a single repository to update instead of updating all repositories.

### Bash Version

To run the Bash script (`repoupdater.sh`):

```bash
./repoupdater.sh [repo_directory] [single_repo]
```

### Powershell Version

```powershell
.\repoupdater.ps1 [repo_directory] [single_repo]
```

### Installation

Clone the repository:
```bash
git clone https://github.com/YoruYagami/repoupdater.git
```

Then, navigate to the repository directory and use the script that matches your environment.