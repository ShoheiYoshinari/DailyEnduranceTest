param (
    [Parameter(Mandatory=$true)]
    [int]$ProcessId,      # プロセス ID

    [Parameter(Mandatory=$true)]
    [TimeSpan]$Duration,  # トレースの期間 (TimeSpan オブジェクト)

    [Parameter(Mandatory=$true)]
    [string]$OutputFile   # 出力ファイルのパス
)

# dotnet-trace のコマンドを作成
$dotnetTraceCommand = "dotnet trace collect --process-id $ProcessId --duration $($Duration.TotalSeconds) --output $OutputFile"

Write-Host "Executing: $dotnetTraceCommand"

# dotnet-trace コマンドを実行
try {
    # dotnet-trace コマンドを非同期で実行
    Invoke-Expression $dotnetTraceCommand
    Write-Host "dotnet trace completed successfully."
} catch {
    Write-Host "Error occurred while executing dotnet trace: $_"
    exit 1
}