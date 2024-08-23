#ショートカットキーを用いてPower Automateを実行
<#
Add-Type -TypeDefinition @"
using System;
using System.Runtime.InteropServices;

public class SendKeys {
    [DllImport("user32.dll")]
    public static extern void keybd_event(byte bVk, byte bScan, uint dwFlags, int dwExtraInfo);
    public const int KEYEVENTF_KEYUP = 0x0002;
    public const byte VK_CONTROL = 0x11;
    public const byte VK_MENU = 0x12;
    public const byte VK_SHIFT = 0x10;
    public const byte VK_F3 = 0x72;

    public static void SendShortcut() {
        keybd_event(VK_CONTROL, 0, 0, 0);
        keybd_event(VK_MENU, 0, 0, 0);
        keybd_event(VK_SHIFT, 0, 0, 0);
        keybd_event(VK_F3, 0, 0, 0);
        keybd_event(VK_F3, 0, KEYEVENTF_KEYUP, 0);
        keybd_event(VK_SHIFT, 0, KEYEVENTF_KEYUP, 0);
        keybd_event(VK_MENU, 0, KEYEVENTF_KEYUP, 0);
        keybd_event(VK_CONTROL, 0, KEYEVENTF_KEYUP, 0);
    }
}
"@

[SendKeys]::SendShortcut()
#>

# プロセスを開始
Start-Process "C:\CSharp.Hutzper.Library\Hutzper.Library.sln" -PassThru

# プロセスが起動し、ウィンドウが表示されるまで待機
$timeout = 60 # タイムアウトの秒数
$startTime = Get-Date
$windowTitle = "Hutzper.Library" # 確認したいウィンドウタイトル

while ((Get-Date) -lt $startTime.AddSeconds($timeout)) {
    $processList = Get-Process | Where-Object { $_.MainWindowTitle -eq $windowTitle }
    if ($processList) {
        Write-Output "プロセスの準備が完了しました。次の処理に進みます。"
        # F5 を送信
        [System.Windows.Forms.SendKeys]::SendWait("{F5}")
        break
    }
    Start-Sleep -Seconds 1
}

if (-Not $processList) {
    Write-Output "タイムアウトしました。ウィンドウタイトルが見つかりませんでした。"
}

# check_processを実行
# 現在のスクリプトのディレクトリを取得
$scriptDirectory = Split-Path -Parent $MyInvocation.MyCommand.Path
# 同じフォルダ内にある別のスクリプトを実行
& "$scriptDirectory\check_process.ps1"






