## Features
1. Switching between **Dark/ light** theme based on the system settings.
2. Following the mouse movement smoothly **without flickering**.
3. (Optional)  Automatically close after a **timeout**.
4. `ClickMode`:  When `ClickMode` is enabled, you can **drag the ToolTip by holding the left button, and close it by double-clicking.**
## Examples
https://github.com/nperovic/ToolTipEx/assets/122501303/1d4405f9-00a4-427e-8fd1-c98b1507c1c0
```js
#Requires AutoHotkey v2

/* Following the mouse movement + Time-out */
Numpad1::{
    ToolTipEx("ABCABCABCABCABCABCABCABCABC`nABC`nABC`nABC`nABC`nABC`nABC`nABC`nABC`n",  5)
}

/* Count Down */
Numpad2:: {
    Loop 5 
        SetTimer ToolTipEx.Bind(6-A_Index, 1), A_Index * -1000
}

/* Click mode */
Numpad3::{
    ToolTipEx("ABCABCABCABCABCABCABCABCABC`nABC`nABC`nABC`nABC`nABC`nABC`nABC`nABC`n",,,, true)
}
```



