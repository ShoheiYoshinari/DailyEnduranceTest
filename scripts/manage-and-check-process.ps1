param (
    [string]$Action,
    [datetime]$Time
)

$processName = "mspaint"
$logDir = "C:\Logs"
$logFile = "$logDir\process_status.log"

# ログディレクトリが存在するか確認し、存在しない場合は作成
if (-not (Test-Path $logDir)) {
    New-Item -Path $logDir -ItemType Directory | Out-Null
}

$currentTime = Get-Date

if ($Action -eq "start") {
    # 22時にプロセスを開始
    Start-Process "mspaint.exe"
    Write-Output "[$currentTime] MS Paint プロセスを開始しました。" | Out-File -Append -FilePath $logFile
} elseif ($Action -eq "stop") {
    # 6時にプロセスを終了
    $processes = Get-Process -Name $processName -ErrorAction SilentlyContinue
    if ($processes) {
        Stop-Process -Name $processName -Force
        Write-Output "[$currentTime] MS Paint プロセスを終了しました。" | Out-File -Append -FilePath $logFile
    } else {
        Write-Output "[$currentTime] MS Paint プロセスは実行されていません。" | Out-File -Append -FilePath $logFile
    }
} elseif ($Action -eq "check") {
    # プロセスの状態を確認
    $processes = Get-Process -Name $processName -ErrorAction SilentlyContinue
    if ($processes) {
        Write-Output "[$currentTime] MS Paint プロセスは実行中です。" | Out-File -Append -FilePath $logFile
    } else {
        Write-Output "[$currentTime] MS Paint プロセスは終了しています。" | Out-File -Append -FilePath $logFile
        exit 1  # エラーコードを返す
    }
} else {
    Write-Output "[$currentTime] 無効なアクションです。'start', 'stop', または 'check' を指定してください。" | Out-File -Append -FilePath $logFile
    exit 1
}
