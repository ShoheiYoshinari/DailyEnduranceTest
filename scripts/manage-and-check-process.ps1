param (
    [string]$Action
)

$processName = "mspaint"
$currentTime = Get-Date

if ($Action -eq "start") {
    Start-Process "mspaint.exe"
    Write-Output "[$currentTime] MS Paint プロセスを開始しました。"
} elseif ($Action -eq "stop") {
    $processes = Get-Process -Name $processName -ErrorAction SilentlyContinue
    if ($processes) {
        Stop-Process -Name $processName -Force
        Write-Output "[$currentTime] MS Paint プロセスを終了しました。"
    } else {
        Write-Output "[$currentTime] MS Paint プロセスは実行されていません。"
        exit 1
    }
} elseif ($Action -eq "check") {
    $processes = Get-Process -Name $processName -ErrorAction SilentlyContinue
    if ($processes) {
        Write-Output "[$currentTime] MS Paint プロセスは実行中です。"
    } else {
        Write-Output "[$currentTime] MS Paint プロセスは終了しています。"
        exit 1
    }
} else {
    Write-Output "[$currentTime] 無効なアクションです。'start', 'stop', または 'check' を指定してください。"
    exit 1
}
