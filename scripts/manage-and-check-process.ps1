param (
  [string]$Action,
  [datetime]$Time = $(Get-Date)  # デフォルトで現在時刻を設定
)

if ($Action -eq 'start') {
  if ($Time.Hour -eq 22) {
    # 22時にプロセスを開始
    Start-Process "mspaint.exe" # 監視したいプロセスに変更
    Write-Output "MS Paint プロセスを開始しました。"
  } else {
    Write-Output "指定された時刻にプロセスを開始できません。"
  }
} elseif ($Action -eq 'stop') {
  if ($Time.Hour -eq 6) {
    # 6時にプロセスを終了
    Get-Process "mspaint" -ErrorAction SilentlyContinue | Stop-Process
    Write-Output "MS Paint プロセスを終了しました。"
  } else {
    Write-Output "指定された時刻にプロセスを終了できません。"
  }
} elseif ($Action -eq 'check') {
  # プロセスの状態を確認
  $process = Get-Process "mspaint" -ErrorAction SilentlyContinue
  if ($process) {
    Write-Output "MS Paintは実行中です。"
  } else {
    Write-Output "MS Paintは実行していません。"
  }
} else {
  Write-Output "無効なアクションが指定されました: $Action"
}
