param (
  [string]$Action,
  [datetime]$Time = (Get-Date)
)

# GitHubへの通知関数
function Send-GitHubNotification {
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

try {
  if ($Action -eq 'start' -or ($Time.Hour -eq 22)) {
    # 22時にプロセスを開始
    Start-Process "mspaint.exe" # 監視したいプロセスに変更
    Write-Output "MS Paint プロセスを開始しました。"
  } elseif ($Action -eq 'stop' -or ($Time.Hour -eq 6)) {
    # 6時にプロセスを終了
    Get-Process "mspaint" -ErrorAction SilentlyContinue | Stop-Process
    Write-Output "MS Paint プロセスを終了しました。"
  } elseif ($Action -eq 'check') {
    # プロセスの状態を確認
    $process = Get-Process "mspaint" -ErrorAction SilentlyContinue

    if ($process) {
      Write-Output "MS Paintは実行中です。"
    } else {
      throw "MS Paintは実行していません。"
    }
  } else {
    throw "無効なアクションが指定されました: $Action"
  }
} catch {
  Send-GitHubNotification -Message $_.Exception.Message
  exit 1
}
