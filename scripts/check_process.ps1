# Visual Studio のプロセスが実行中か確認します（プロセス名は適宜変更）
$processName = "Hutzper.Project.Mekiki"
$process = Get-Process -Name $processName -ErrorAction SilentlyContinue

if ($process) {
    Write-Output "$processName は実行中です。"
} else {
    Write-Output "$processName は停止しています。"
    exit 1
}
