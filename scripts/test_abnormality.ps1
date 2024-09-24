param (
    [Parameter(Mandatory = $true)]
    [object]$processSettings,

    [Parameter(Mandatory = $true)]
    [string]$logFilePath,

    [Parameter(Mandatory = $true)]
    [string]$resultsFilePath,

    [Parameter(Mandatory = $true)]
    [string]$logResultsFilePath,

    [Parameter(Mandatory = $true)]
    [string]$timestamp
)

$results = @()
$logResults = @()
foreach ($test in $processSettings.tests) {
  Write-Output "プロセス: $($test.name)"
  Write-Output "テスト時間: $($test.duration_minutes) 分"
  $startTime = Get-Date
  $endTime = $startTime.AddMinutes($test.duration_minutes)

  Write-Output "プロセス $($test.name) のテストを開始します"
  $processStopped = $false
  while ((Get-Date) -lt $endTime) {
    Start-Sleep -Seconds 5

    $logContent = Get-Content $logFilePath -Raw
    $logLines = $logContent -split "`n"
    $filteredLines = @()
    foreach ($line in $logLines) {
      if ($line -match "^\d{2}:\d{2}:\d{2}\.\d{3}") {
        $lineTimestamp = $matches[0]
        $lineTime = [datetime]::ParseExact($lineTimestamp, "HH:mm:ss.fff", $null)

        if ($lineTime -gt [datetime]::ParseExact($timestamp, "yyyyMMdd-HHmmss", $null)) {
          $filteredLines += $line
        }
      }
    }
    $logResults = $filteredLines

    $deadTime = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
    if ($filteredLines -match "異常") {
      Write-Output "$($deadTime): $($test.name)テスト中に異常を検知しました"
      $errorLines = $filteredLines | Select-String "異常" | ForEach-Object { $_.Line }
      $results += "$($test.name): Failure"
      $errorLines | Out-File -FilePath $resultsFilePath -Append
      $logResults | Out-File -FilePath $logResultsFilePath -Append
      Write-Output "結果が 'test_results_$($timestamp).txt' に保存されました"
      Write-Output "ログが 'log_results_$($timestamp).txt' に保存されました"

      # 異常をGitHub Actionsに通知し、ジョブを失敗させる
      Write-Host "::error::$($test.name)テスト中に異常が発生しました"
      exit 1  # 非ゼロ終了コードを返してGitHub Actionsにエラー通知
    } else {
      Write-Output "$($deadTime): $($test.name)は動作しています"
    }
  }
  if (-Not $processStopped) {
    Write-Output "$($test.name) のテストが成功しました"
    $results += "$($test.name): Success"
  }
}

$results | Out-File -FilePath $resultsFilePath -Append
Write-Output "結果が 'test_results_$($timestamp).txt' に保存されました"
$logResults | Out-File -FilePath $logResultsFilePath -Append
Write-Output "ログが 'log_results_$($timestamp).txt' に保存されました"
