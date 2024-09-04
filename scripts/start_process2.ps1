# Visual Studioのパスを指定して、ソリューションファイルを開くジョブを開始
$job = Start-Job -ScriptBlock {
    $visualStudioPath = "C:\Program Files\Microsoft Visual Studio\2022\Community\Common7\IDE\devenv.exe"
    $solutionPath = "C:\CSharp.Hutzper.Library\Hutzper.Library.sln"
    Start-Process $visualStudioPath -ArgumentList $solutionPath

    # 30秒間待機
    Start-Sleep -Seconds 30

    # F5キーを送信して実行
    Add-Type -AssemblyName System.Windows.Forms
    [System.Windows.Forms.SendKeys]::SendWait("{F5}")
}

# ジョブ情報を出力
$job