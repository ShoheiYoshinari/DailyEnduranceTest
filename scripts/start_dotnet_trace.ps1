param (
    [string]$ProcessId,
    [int]$Duration,          # Durationは分で渡される
    [string]$OutputFile
)

# 入力されたDuration (分) を秒単位に変換
$durationInSeconds = $Duration * 60

# DurationをTimeSpan形式で設定
$duration = New-TimeSpan -Seconds $durationInSeconds

Write-Host "Duration for dotnet trace: $duration"

Write-Host "Starting dotnet trace..."
dotnet trace collect --process-id $ProcessId --profile gc-collect --duration $duration --output $OutputFile

if ($LASTEXITCODE -ne 0) {
    Write-Error "dotnet trace failed with exit code $LASTEXITCODE"
    exit 1
}

Write-Host "dotnet trace completed successfully. Output file: $OutputFile"
