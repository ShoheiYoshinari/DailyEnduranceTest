param (
    [string]$ProcessId,
    [int]$Duration,
    [string]$OutputFile
)

# 入力されたDuration (分) を秒単位に変換
$durationInSeconds = $Duration * 60

# 結果を表示
Write-Host "Duration for dotnet trace: $durationInSeconds seconds"

Write-Host "Starting dotnet trace..."
dotnet trace collect --process-id $ProcessId --profile gc-collect --duration $durationInSeconds --output $OutputFile

if ($LASTEXITCODE -ne 0) {
    Write-Error "dotnet trace failed with exit code $LASTEXITCODE"
    exit 1
}

Write-Host "dotnet trace completed successfully. Output file: $OutputFile"
