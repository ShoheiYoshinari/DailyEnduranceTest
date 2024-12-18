param (
    [string]$ProcessId,
    [int]$Duration,
    [string]$OutputFile
)

Write-Host "Starting dotnet trace..."
dotnet trace collect --process-id $ProcessId --profile gc-collect --duration $Duration --output $OutputFile
Write-Host "dotnet trace completed."
