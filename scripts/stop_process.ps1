# Visual Studio のプロセスが実行中か確認します（プロセス名は適宜変更）
$processName = "Hutzper.Project.Mekiki"
$processes = Get-Process -Name $processName -ErrorAction SilentlyContinue

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
