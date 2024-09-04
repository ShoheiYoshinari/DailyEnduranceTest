# ソリューションファイルのパスを指定してプロセスを開始
Start-Process "C:\CSharp.Hutzper.Library\Hutzper.Library.sln"

# 30秒間待機
Start-Sleep -Seconds 30

# F5キーを送信して実行
Add-Type -AssemblyName System.Windows.Forms
[System.Windows.Forms.SendKeys]::SendWait("{F5}")
