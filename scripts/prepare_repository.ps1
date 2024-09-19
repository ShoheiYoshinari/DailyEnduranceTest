param (
    [string]$repoUrl,
    [string]$dir,
    [string]$branch
)

if ($branch -eq 'main') {
  $branch = 'test_endurance'
}

if (-Not (Test-Path $dir)) {
  git clone $repoUrl $dir
} else {
  Set-Location -Path $dir
  git fetch origin
  git checkout $branch
  git pull origin $branch
}
