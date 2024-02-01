#Requires AutoHotkey v2

/**
 * Creates a Pop-up Tooltip window that follows the mouse movement.
 * @param {string} [Text]  
 * If omitted, the existing tooltip (if any) will be hidden.  
 * Otherwise, this parameter is the text to display in the tooltip.
 * @param {number} [TimeOut=5]  
 * The tooltip will be hidden after the set number of seconds.  
 * If you do not want the tooltip to be hidden automatically after a timeout, set this parameter to 0.
 * @param {interger} [WhichToolTip]  
 * Omit this parameter if you don't need multiple tooltips to appear simultaneously.  
 * Otherwise, this is a number between 1 and 20 to indicate which tooltip window to operate upon.  
 * If unspecified, that number is 1 (the first).
 * @param {interger} Darkmode  
 * - `true` : Enable dark mode.  
 * - `false`: Disable dark mode.  
 * By default, this function will automatically detect whether the system has enabled dark mode.
 * @param {interger} [ClickMode=false]  
 * When the `ClickMode` is `true`, the following features will be enable:  
 * - Holding LButton to move the ToolTip.  
 * - Doble click to close the ToolTip.
 * Otherwise, the Tooltip will follow the mouse movement.
 * @returns {Integer}
 */
ToolTipEx(Text := "", TimeOut := 5, WhichToolTip?, Darkmode?, ClickMode := false) 
{
    static EnumCursorPos(hwnd) => (&x, &y) => (MouseGetPos(&x, &y), WinExist(hwnd))
    static flags            := (VerCompare(A_OSVersion, "6.2") < 0 ? 0 : 0x10000)
         , isDarkMode       := !RegRead("HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Themes\Personalize", "AppsUseLightTheme", 1)
         , WM_LBUTTONDOWN   := 0x0201
         , WM_NCLBUTTONDOWN := 0x00A1
         , WM_LBUTTONDBLCLK := 0x0203
         , _                := (OnMessage(WM_LBUTTONDOWN, OnClickEvent), OnMessage(WM_LBUTTONDBLCLK, OnClickEvent))

    if (ToolTip(), !Text)
        return

    ttw := ToolTip(Text?, , , WhichToolTip?)

    if timeout
        SetTimer(() => (WinExist(ttw) && WinClose()), -timeout * 1000)

    if (Darkmode ?? isDarkMode)
        DllCall("uxtheme\SetWindowTheme", "ptr", ttw, "ptr", StrPtr("DarkMode_Explorer"), "ptr", 0)

    if !ClickMode
        SetTimer(FollowMouse.Bind(ttw), -10)
        
    return ttw

    FollowMouse(hwnd)
    {
        SetWinDelay(-1)
        CoordMode("Mouse")

        anchorPt := Buffer(8),  winRect := Buffer(16),
        exclRect := Buffer(16), outRect := Buffer(16),
        winSize  := winRect.ptr + 8

        for x, y in EnumCursorPos(hwnd) {
            NumPut("int", x + 16, "int", y + 16, anchorPt)
            NumPut("int", x - 3, "int", y - 3, "int", x + 3, "int", y + 3, exclRect)
            DllCall("GetClientRect", "ptr", hwnd, "ptr", winRect)
            DllCall("CalculatePopupWindowPosition", "ptr", anchorPt, "ptr", winSize, "uint", flags, "ptr", exclRect, "ptr", outRect)
            try WinMove(NumGet(outRect, 0, 'int'), NumGet(outRect, 4, 'int'))
        }
    }

    OnClickEvent(wParam, lParam, msg, hwnd)
    {
        MouseGetPos(, , &win)
        if WinExist("ahk_class tooltips_class32 ahk_id" win) {
            switch msg {
            case WM_LBUTTONDOWN  : PostMessage(WM_NCLBUTTONDOWN, 2)
            case WM_LBUTTONDBLCLK: WinClose()
        }}
    }
}
