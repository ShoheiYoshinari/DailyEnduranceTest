param (
    [string]$Action
)

$processName = "mspaint"

$currentTime = Get-Date

if ($Action -eq "start") {
    # MS Paint プロセスを開始
    Start-Process "mspaint.exe"
    Write-Output "[$currentTime] MS Paint プロセスを開始しました。"
} elseif ($Action -eq "stop") {
    # MS Paint プロセスを終了
    $processes = Get-Process -Name $processName -ErrorAction SilentlyContinue
    if ($processes) {
        Stop-Process -Name $processName -Force
        Write-Output "[$currentTime] MS Paint プロセスを終了しました。"
    } else {
        Write-Output "[$currentTime] MS Paint プロセスは実行されていません。"
        exit 1  # エラーコードを返す
    }
} elseif ($Action -eq "check") {
    # プロセスの状態を確認
    $processes = Get-Process -Name $processName -ErrorAction SilentlyContinue
    if ($processes) {
        Write-Output "[$currentTime] MS Paint プロセスは実行中です。"
    } else {
        Write-Output "[$currentTime] MS Paint プロセスは終了しています。"
        exit 1  # エラーコードを返す
    }
} else {
    Write-Output "[$currentTime] 無効なアクションです。'start', 'stop', または 'check' を指定してください。"
    exit 1
}
