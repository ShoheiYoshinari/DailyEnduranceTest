# F5キーを送信するPowerShellスクリプト
Add-Type -TypeDefinition @"
using System;
using System.Runtime.InteropServices;

public class Keyboard {
    [DllImport("user32.dll", CharSet = CharSet.Auto)]
    public static extern void keybd_event(byte bVk, byte bScan, uint dwFlags, int dwExtraInfo);

    public const int KEYEVENTF_KEYUP = 0x0002;
    public const byte VK_F5 = 0x74;

    public static void SendF5() {
        keybd_event(VK_F5, 0, 0, 0); // F5キーを押す
        keybd_event(VK_F5, 0, KEYEVENTF_KEYUP, 0); // F5キーを放す
    }
}
"@

[Keyboard]::SendF5()
