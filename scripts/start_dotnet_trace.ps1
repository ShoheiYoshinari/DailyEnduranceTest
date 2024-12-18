param (
    [string]$ProcessId,
    [int]$Duration,
    [string]$OutputFile
)

# 分を dd:hh:mm:ss に変換
$days = [math]::Floor($tests.duration_minutes / 1440)
$hours = [math]::Floor(($tests.duration_minutes % 1440) / 60)
$minutes = $tests.duration_minutes % 60
$seconds = 0  # 秒は常に0と仮定
# 各部分を2桁の文字列にフォーマット
$daysStr = $days.ToString("00")
$hoursStr = $hours.ToString("00")
$minutesStr = $minutes.ToString("00")
$secondsStr = $seconds.ToString("00")
$duration =  "${daysStr}:${hoursStr}:${minutesStr}:${secondsStr}"
#  結果を表示
Write-Host $duration

Write-Host "Starting dotnet trace..."
dotnet trace collect --process-id $ProcessId --profile gc-collect --duration $Duration --output $OutputFile

if ($LASTEXITCODE -ne 0) {
    Write-Error "dotnet trace failed with exit code $LASTEXITCODE"
    exit 1
}

Write-Host "dotnet trace completed successfully. Output file: $OutputFile"
