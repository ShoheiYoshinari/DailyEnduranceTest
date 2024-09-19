function Get-Timestamp {
    (Get-Date -Format "yyyyMMdd-HHmmss")
}
function Get-DateSuffix {
    (Get-Date -Format "yyyyMMdd")
}
$timestamp = Get-Timestamp
$dateSuffix = Get-DateSuffix
Write-Output "::set-output name=timestamp::$timestamp"
Write-Output "::set-output name=date_suffix::$dateSuffix"
