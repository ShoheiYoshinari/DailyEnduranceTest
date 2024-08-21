param (
    [string]$Action
)

switch ($Action.ToLower()) {
    "start" {
        Write-Output "[$(Get-Date)] MS Paintを起動します..."
        # 非同期でMS Paintを起動し、プロセスをデタッチ
        Start-Process "mspaint.exe" -WindowStyle Normal -PassThru | Out-Null
    }
    "stop" {
        $process = Get-Process -Name "mspaint" -ErrorAction SilentlyContinue
        if ($process) {
            Write-Output "[$(Get-Date)] MS Paintを終了します..."
            Stop-Process -Name "mspaint" -Force
        } else {
            Write-Output "[$(Get-Date)] MS Paintは実行されていません。"
            exit 1
        }
    }
    "check" {
        $process = Get-Process -Name "mspaint" -ErrorAction SilentlyContinue
        if ($process) {
            Write-Output "[$(Get-Date)] MS Paintは実行中です。"
        } else {
            Write-Output "[$(Get-Date)] MS Paintは実行されていません。"
            exit 1
        }
    }
    default {
        Write-Output "[$(Get-Date)] 無効なアクションが指定されました: $Action。'start'、'stop'、または 'check' を使用してください。"
        exit 1
    }
}
