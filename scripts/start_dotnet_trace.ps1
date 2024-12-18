param (
    [string]$ProcessId,
    [int]$Duration,
    [string]$OutputFile
)

# 結果を表示
Write-Host "Duration for dotnet trace: $durationInSeconds seconds"
Write-Host "Process ID: $ProcessId"
Write-Host "Output file: $OutputFile"

# 結果を表示
Write-Host "Duration for dotnet trace: $durationInSeconds seconds"

Write-Host "Starting dotnet trace..."
dotnet trace collect --process-id $ProcessId --profile gc-collect --duration $durationInSeconds --output $OutputFile

if ($LASTEXITCODE -ne 0) {
    Write-Error "dotnet trace failed with exit code $LASTEXITCODE"
    exit 1
}

Write-Host "dotnet trace completed successfully. Output file: $OutputFile"
