param (
    [string]$operation,
    [string]$projectPath,
    [string]$outputDir
)

if ([string]::IsNullOrEmpty($operation)) {
  $operation = 'build'
}

if ($operation -eq 'build') {
  dotnet build $projectPath -c Release
} elseif ($operation -eq 'publish') {
  dotnet publish $projectPath -c Release -o $outputDir
} else {
  throw "無効なオプションが指定されました。'build' または 'publish' を指定してください。"
}
