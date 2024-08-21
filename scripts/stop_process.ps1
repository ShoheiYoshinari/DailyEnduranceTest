# プロセス名を指定します
$processName = "Hutzper.Project.Mekiki"

# 指定したプロセスを取得します
$processes = Get-Process -Name $processName -ErrorAction SilentlyContinue

# プロセスが見つかった場合、終了します
if ($processes) {
    Write-Output "プロセス '$processName' が見つかりました。終了します..."
    foreach ($process in $processes) {
        try {
            Stop-Process -Id $process.Id -Force
            Write-Output "プロセス '$processName' (ID: $($process.Id)) を終了しました。"
        } catch {
            Write-Error "プロセス '$processName' (ID: $($process.Id)) を終了できませんでした: $_"
        }
    }
} else {
    Write-Output "プロセス '$processName' は実行中ではありません。"
}
