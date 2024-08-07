param (
  [string]$Action,
  [datetime]$Time = (Get-Date)
)

# GitHubへの通知関数
function Notify-GitHub {
  param (
    [string]$Message
  )

  $repo = $env:GITHUB_REPOSITORY
  $token = $env:GITHUB_TOKEN
  $issue_number = 1 # 通知を送りたいIssue番号に変更
  $uri = "https://api.github.com/repos/$repo/issues/$issue_number/comments"

  $body = @{
    body = $Message
  } | ConvertTo-Json

  Invoke-RestMethod -Uri $uri -Method Post -Headers @{ Authorization = "token $token" } -Body $body -ContentType "application/json"
}

if ($Action -eq 'start' -or ($Time.Hour -eq 22)) {
  # 22時にプロセスを開始
  Start-Process "mspaint.exe"
  Notify-GitHub -Message "MS Paint プロセスを開始しました。"
} elseif ($Action -eq 'stop' -or ($Time.Hour -eq 6)) {
  # 6時にプロセスを終了
  Get-Process "mspaint" -ErrorAction SilentlyContinue | Stop-Process
  Notify-GitHub -Message "MS Paint プロセスを終了しました。"
} elseif ($Action -eq 'check') {
  # プロセスの状態を確認
  $process = Get-Process "mspaint" -ErrorAction SilentlyContinue

  if ($process) {
    Write-Output "MS Paintは実行中です。"
    exit 0
  } else {
    Write-Output "MS Paintは実行していません。"
    Notify-GitHub -Message "MS Paint プロセスが終了しています。"
    exit 1
  }
} else {
  Write-Output "無効なアクションが指定されました: $Action"
  exit 1
}
