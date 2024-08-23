# Add user32.dll to call the keybd_event function
Add-Type @"
using System;
using System.Runtime.InteropServices;

public class Keyboard {
    [DllImport("user32.dll", SetLastError = true)]
    public static extern void keybd_event(byte bVk, byte bScan, uint dwFlags, uint dwExtraInfo);

    public const int KEYEVENTF_KEYUP = 0x0002;
    public const int VK_CONTROL = 0x11;
    public const int VK_SHIFT = 0x10;
    public const int VK_MENU = 0x12; // Alt key
    public const int VK_F4 = 0x73;

    public static void SendKey(byte keyCode, bool keyDown) {
        keybd_event(keyCode, 0, keyDown ? 0 : KEYEVENTF_KEYUP, 0);
    }
}
"@

# Send Ctrl + Shift + Alt + F4
[Keyboard]::SendKey([Keyboard]::VK_CONTROL, $true)
[Keyboard]::SendKey([Keyboard]::VK_SHIFT, $true)
[Keyboard]::SendKey([Keyboard]::VK_MENU, $true)
[Keyboard]::SendKey([Keyboard]::VK_F4, $true)

# Release the keys
[Keyboard]::SendKey([Keyboard]::VK_F4, $false)
[Keyboard]::SendKey([Keyboard]::VK_MENU, $false)
[Keyboard]::SendKey([Keyboard]::VK_SHIFT, $false)
[Keyboard]::SendKey([Keyboard]::VK_CONTROL, $false)
