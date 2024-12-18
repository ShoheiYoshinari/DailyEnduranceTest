param (
    [string]$ProcessId,
    [int]$Duration,
    [string]$OutputFile
)

Write-Host "Starting dotnet trace..."
dotnet trace collect --process-id $ProcessId --profile gc-collect --duration $Duration --output $OutputFile

if ($LASTEXITCODE -ne 0) {
    Write-Error "dotnet trace failed with exit code $LASTEXITCODE"
    exit 1
}

Write-Host "dotnet trace completed successfully. Output file: $OutputFile"
