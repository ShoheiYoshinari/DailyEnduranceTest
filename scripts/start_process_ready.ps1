# 設定
$solutionPath = "C:\CSharp.Hutzper.Library\Hutzper.Library.sln"  # 開くソリューションファイルのパス
$timeout = 300  # 待機するタイムアウト時間（秒）
$interval = 10  # チェック間隔（秒）

# プロセスを開始
$process = Start-Process "devenv.exe" -ArgumentList $solutionPath -PassThru
$processId = $process.Id

# 待機ループ
$startTime = Get-Date
$ready = $false

while ((Get-Date) - $startTime -lt [TimeSpan]::FromSeconds($timeout)) {
    if (Get-Process -Id $processId -ErrorAction SilentlyContinue) {
        # プロセスが存在する場合、準備完了のチェックを追加
        # ここでは、ウィンドウタイトルやその他の条件で準備完了を確認することができます。
        $processWindow = (Get-Process -Id $processId).MainWindowTitle
        if ($processWindow -ne "") {
            $ready = $true
            break
        }
    }
    Start-Sleep -Seconds $interval
}

if ($ready) {
    Write-Output "プロセスが準備完了しました。"
} else {
    Write-Error "タイムアウト: プロセスが準備できませんでした。"
    exit 1  # エラーコード1でスクリプトを終了し、GitHub Actionsでエラーとして扱わせます。
}
