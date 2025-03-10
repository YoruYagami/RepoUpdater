param(
    [Parameter(Position = 0)]
    [string]$RepoDirectory = ".",
    [Parameter(Position = 1)]
    [string]$SingleRepo
)

# Risolve il percorso assoluto della directory specificata
try {
    $RepoDirectory = (Resolve-Path $RepoDirectory).Path
} catch {
    Write-Host "The directory $RepoDirectory does not exist!" -ForegroundColor Red
    exit 1
}

function Update-Repo {
    param(
        [string]$repo
    )
    if (Test-Path (Join-Path $repo ".git")) {
        Push-Location $repo
        Write-Host "Updating $repo..." -ForegroundColor Green

        # Ottieni il branch corrente
        $currentBranch = git rev-parse --abbrev-ref HEAD 2>&1
        if ($LASTEXITCODE -ne 0 -or $currentBranch.Trim() -eq "" -or $currentBranch.Trim() -eq "HEAD" -or $currentBranch -match "^fatal:") {
            Write-Host "Could not determine a valid current branch for $repo. Skipping update." -ForegroundColor Yellow
        }
        else {
            # Verifica la presenza di una tracking branch
            $upstream = git rev-parse --abbrev-ref --symbolic-full-name "@{u}" 2>&1
            if ($LASTEXITCODE -ne 0 -or $upstream -match "^fatal:") {
                Write-Host "No tracking information for branch '$currentBranch' in $repo. Skipping update." -ForegroundColor Yellow
            }
            else {
                $pullOutput = git pull 2>&1
                if ($LASTEXITCODE -eq 0) {
                    if ($pullOutput.Trim() -eq "Already up to date.") {
                        Write-Host "No changes, skipping update." -ForegroundColor Yellow
                    }
                    else {
                        Write-Host "Repository updated:" -ForegroundColor Green
                        Write-Host $pullOutput
                    }
                }
                else {
                    Write-Host "Error updating!" -ForegroundColor Red
                    Write-Host $pullOutput
                }
            }
        }
        Pop-Location
    }
}

function Update-Recursive {
    param(
        [string]$dir
    )
    Push-Location $dir
    foreach ($child in Get-ChildItem -Directory) {
        $childPath = $child.FullName
        if (Test-Path (Join-Path $childPath ".git")) {
            Update-Repo $childPath
        }
        elseif ($child.PSIsContainer) {
            Update-Recursive $childPath
        }
    }
    Pop-Location
}

if ([string]::IsNullOrEmpty($SingleRepo)) {
    Update-Recursive $RepoDirectory
    Write-Host "All repositories updated!" -ForegroundColor Green
} else {
    $fullRepoPath = Join-Path $RepoDirectory $SingleRepo
    Update-Repo $fullRepoPath
    Write-Host "Selected repository updated!" -ForegroundColor Green
}
