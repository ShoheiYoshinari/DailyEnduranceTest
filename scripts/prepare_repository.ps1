param (
    [string]$repoUrl,
    [string]$dir,
    [string]$branch
)

if (-Not (Test-Path $dir)) {
  git clone $repoUrl $dir
} else {
  Set-Location -Path $dir
  git fetch origin
  git checkout $branch
  git pull origin $branch
}
