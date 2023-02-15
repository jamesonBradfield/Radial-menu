; This scripts creates a radial menu / pie menu
; The selected menu item is returned as a string.
; mbutton is used in this example to trigger the menu
#SingleInstance Force
#Requires AutoHotkey v2.0-beta.3
; Uncomment if Gdip.ahk is not in your standard library
#Include Gdip_All.ahk


;#region variableDeclaration
PosX := 0
PosY := 0
ReturnColor := 0x00FF00
InsertTextLastInputValue := ""
activeWindowOnRadialOpen := ""
;#endregion

;#region InputSection
insertTextGui := Gui()
insertTextGui.Add("Text", , "Which Text would you like to insert")
insertTextGui.AddEdit("vName")
insertTextGui.Add("Checkbox", "vUseLastInputValue", "Use last input value?")
MyBtn := insertTextGui.Add("Button", "Default w80", "OK")
MyBtn.OnEvent("Click", InsertTextAtSelection)  ; Call MyBtn_Click when clicked.

InsertText(*) {
    insertTextGui.Show
}
InsertTextAtSelection(*) {
    global InsertTextLastInputValue,activeWindowOnRadialOpen
    MyInputValues := insertTextGui.Submit()
    if (MyInputValues.UseLastInputValue = 0) {
        InsertTextLastInputValue := MyInputValues.Name
        A_Clipboard := MyInputValues.Name
        WinActivate(activeWindowOnRadialOpen)
        ClipWait
        SendInput("{Ctrl Down}v{Ctrl Up}")
        Sleep(100)
        A_Clipboard := ""
    }else {
        A_Clipboard := InsertTextLastInputValue
        WinActivate(activeWindowOnRadialOpen)
        ClipWait
        SendInput("{Ctrl Down}v{Ctrl Up}")
        Sleep(100)
        A_Clipboard := ""
    }
}

^XButton1:: Reload
#mButton::
{
    GetMousePosition()
    OpenWindowManagementRadial()
}

+mButton::
{
    GetMousePosition()
    OpenAppRadial()
}
!mButton::
{
    GetMousePosition()
    CheckContext("Context Menu")
}
mButton::
{
    global activeWindowOnRadialOpen
    activeWindowOnRadialOpen := WinGetID("A")
    ; global defColor
    ; defColorString := Array()
    ; defColorString := FileRead("colors.txt")
    ; defColorString := StrSplit(defColorString, "`n")
    ; if (defColorString.Length != 0) {
    ;     defColor.Length :=defColorString.Length
    ;     loop defColorString.Length {
    ;         ;MsgBox(defColorString[A_Index])
    ;         defColor[A_Index] := str2hex(defColorString[A_Index])
    ;         MsgBox(defColor[A_Index])
    ;     }
    ; }
    ; FileAppend("","colors.txt")
    GetMousePosition()
    OpenBaseRadial()
}
; str2hex(str){
; 	loop parse, str
; 	    hex .= Format("{:x}", Ord(A_LoopField))
; 	return hex
; }
GetMousePosition(*)
{
    global PosX, PosY
    CoordMode("Mouse", "Screen")
    MouseGetPos(&PosX, &PosY)
    return
}
;#endregion

;this is just the basic way of creating radials 
;i would really like to make a gui radial creator so more people can easily make them
OpenBaseRadial(*) {
    global PosX, PosY
    MouseMove(PosX, PosY, 0)
    Result := CreateBaseRadial()
    switch Result
    {
        case "Table": Run("AutoHtmlTable.ahk")
        case "Color": Run("v2ObsidianColor.ahk")
        case "Open App": OpenAppRadial()
        case "Context Menu": CheckContext("Context Menu")
        case "Windows": OpenWindowManagementRadial()
        case "Settings": OpenSettingsMenu()
        case "Plugins": CheckContext("Plugins")
        case "Insert text": InsertText()
        case "Close":    ;do nothing
        default:
            MsgBox(Result)
    }
}
CreateBaseRadial(*) {
    GMenu := Radial_Menu()
    GMenu.SetRadialColors("2B3D55","334966","121922","000000")
    GMenu.SetSections("8")
    ;when this key is pressed the radial section will move to its second "Option" Syntax below
    GMenu.SetKeySpecial("Ctrl")
    ;RadialMenuName.Add2("OnSelectString", "SectionIcon", sectionNumber)
    
    ;GMenu.Add("", "", 1)
    ;GMenu.Add("", "", 2)
    ;GMenu.Add2("", "", 2)
    GMenu.Add("Context Menu", "Images/pallette.png", 1)
    GMenu.Add("Open App", "Images\NewTabIcon.png", 2)
    GMenu.Add("Windows", "Images\windowsIcon.png", 3)
    GMenu.Add("Plugins", "Images\extensionsIcon.png", 4)
    GMenu.Add("","",5)
    GMenu.Add("Close", "Images\close.png", 6)
    GMenu.Add2("Settings", "Images\settingsIcon.png", 6)
    GMenu.Add("","",7)
    GMenu.Add("Insert text","",8)
    ;GMenu.Add2("", "Images/fbcp_asm_image.gif", 5)
    ;GMenu.Add("", "", 6)
    GMenu.ResetRadialAlpha()
    ;GMenu.Add("", "", 8)
    Return Result := GMenu.Show()
}
OpenSettingsMenu(*) {
    global PosX, PosY
    MouseMove(PosX, PosY, 0)
    Result := CreateRadialFromFile("RadialCSVFiles\settingsRadial.csv")
    switch Result
    {
        case "Color Menu": OpenColorMenu()
        case "Back": OpenBaseRadial()    ;do nothing
        default:
            MsgBox(Result)
    }
}

;#region colorSelect
OpenColorMenu() {
    global defColor,ReturnColor
    ReturnColor := ColorSelect(0,WinGetID("A"), &defColor, 0)
    colorList := ""
    For k, v in defColor ; if user changes Custom Colors, they will be stored in defColor array
        If v
            colorList .=Format("0x{:06X}", v) "`r`n"
    SetColorValues(colorList)
}
SetColorValues(colorList) {
    colorList := StrSplit(colorList, "`n")
    if (colorList.Length != 0) {
        colorList.RemoveAt(colorList.Length)
        loop colorList.Length {
            ;gotta write the colors to file
            FileAppend(colorList[A_Index] . "`n","colors.txt")
        }
    }else {
        MsgBox("Shouldn't do anything no colors were added")
    }
}
; AHK v2
; originally posted by maestrith 
; https://autohotkey.com/board/topic/94083-ahk-11-font-and-color-dialogs/
; ===============================================================
; END Example
; ===============================================================

; =============================================================================================
; Parameters
; =============================================================================================
; Color           = Start color (0 = black) - Format = 0xRRGGBB
; hwnd            = Parent window
; custColorObj    = Array() to load/save custom colors, must be &VarRef
; disp            = 1=full / 0=basic ... full displays custom colors panel, basic does not
; =============================================================================================
; All params are optional.  With no hwnd the dialog will show at top left of screen.  Use an
; object serializer (like JSON) to save/load custom colors to/from disk.
; =============================================================================================

ColorSelect(Color := 0, hwnd := 0, &custColorObj := "",disp:=false) {
    Static p := A_PtrSize
    disp := disp ? 0x3 : 0x1 ; init disp / 0x3 = full panel / 0x1 = basic panel
    
    If (custColorObj.Length > 16)
        throw Error("Too many custom colors.  The maximum allowed values is 16.")
    
    Loop (16 - custColorObj.Length)
        custColorObj.Push(0) ; fill out custColorObj to 16 values
    
    CUSTOM := Buffer(16 * 4, 0) ; init custom colors obj
    CHOOSECOLOR := Buffer((p=4)?36:72,0) ; init dialog
    
    If (IsObject(custColorObj)) {
        Loop 16 {
            custColor := RGB_BGR(custColorObj[A_Index])
            NumPut "UInt", custColor, CUSTOM, (A_Index-1) * 4
        }
    }
    
    NumPut "UInt", CHOOSECOLOR.size, CHOOSECOLOR, 0             ; lStructSize
    NumPut "UPtr", hwnd,             CHOOSECOLOR, p             ; hwndOwner
    NumPut "UInt", RGB_BGR(color),   CHOOSECOLOR, 3 * p         ; rgbResult
    NumPut "UPtr", CUSTOM.ptr,       CHOOSECOLOR, 4 * p         ; lpCustColors
    NumPut "UInt", disp,             CHOOSECOLOR, 5 * p         ; Flags
    
    if !DllCall("comdlg32\ChooseColor", "UPtr", CHOOSECOLOR.ptr, "UInt")
        return -1
    
    custColorObj := []
    Loop 16 {
        newCustCol := NumGet(CUSTOM, (A_Index-1) * 4, "UInt")
        custColorObj.InsertAt(A_Index, RGB_BGR(newCustCol))
    }
    
    Color := NumGet(CHOOSECOLOR, 3 * A_PtrSize, "UInt")
    return Format("0x{:06X}",RGB_BGR(color))
    
    RGB_BGR(c) {
        return ((c & 0xFF) << 16 | c & 0xFF00 | c >> 16)
    }
}

; typedef struct tagCHOOSECOLORW {  offset      size    (x86/x64)
  ; DWORD        lStructSize;       |0      |   4
  ; HWND         hwndOwner;         |4 / 8  |   8 /16
  ; HWND         hInstance;         |8 /16  |   12/24
  ; COLORREF     rgbResult;         |12/24  |   16/28
  ; COLORREF     *lpCustColors;     |16/28  |   20/32
  ; DWORD        Flags;             |20/32  |   24/36
  ; LPARAM       lCustData;         |24/40  |   28/48 <-- padding for x64
  ; LPCCHOOKPROC lpfnHook;          |28/48  |   32/56
  ; LPCWSTR      lpTemplateName;    |32/56  |   36/64
  ; LPEDITMENU   lpEditInfo;        |36/64  |   40/72
; } CHOOSECOLORW, *LPCHOOSECOLORW;
;#endregion
;#region WindowManagementRadial
OpenWindowManagementRadial(*) {
    global PosX, PosY
    MouseMove(PosX, PosY)
    openResult := CreateRadialFromFile("RadialCSVFiles\windowManagementRadial.csv")
    switch openResult
    {
        case "Move Active Window To Left": SendInput("#{left}")
        case "Move Active Window To Right": SendInput("#{right}")
        case "Grow Window":SendInput("#{up}")
        case "Shrink Window": SendInput("#{up}")
        case "Center Window": CenterWindow(WinGetID("A"))
        case "Back": OpenBaseRadial()
        default: MsgBox(openResult)
    }
}
CenterWindow(WinTitle)
{
    WinGetPos ,, &Width, &Height, WinTitle
    WinMove (A_ScreenWidth/2)-(Width/2), (A_ScreenHeight/2)-(Height/2),,, WinTitle
}
;#endregion
;#region ContextRadial
CheckContext(sectionCalledFrom) {
    WindowProcess := WinGetProcessName("A")
    CreateContextMenu(WindowProcess,sectionCalledFrom)        
}
CreateContextMenu(WindowProcess,sectionCalledFrom) {
    WindowProcess := "ahk_exe " . WindowProcess
    global PosX, PosY
    MouseMove(PosX, PosY)
    if (sectionCalledFrom = "Context Menu") {
        switch WindowProcess {
            case "ahk_exe chrome.exe": GoogleChromeHotkeys()
            case "ahk_exe Discord.exe": DiscordHotkeys()
            case "ahk_exe Obsidian.exe": ObsidianHotkeys()
            case "ahk_exe Eagle.exe":
            case "ahk_exe Code.exe": VsCodeHotkeys()
            
            default: MsgBox("this app is not supported yet")
        }        
    }else if(sectionCalledFrom = "Plugins"){
        switch WindowProcess {
            case "ahk_exe chrome.exe":
            case "ahk_exe Discord.exe":
            case "ahk_exe Obsidian.exe":ObsidianPluginsHotkeys()
            case "ahk_exe Eagle.exe":
            case "ahk_exe Code.exe": VsCodePluginsHotkeys()
            default:
                }
            }
        }
        ;#endregion
;#region appRadial
        CreateRadialFromFile(fileName) {
            items := []
            loopCounter := 0
            Loop read, fileName
            {
                line := StrSplit(A_LoopReadLine, ",")
                if (line[3] = "add") {
                    loopCounter++
                }
                items.InsertAt(A_Index, line)
            }
            return openResult := CreateRadialMenu(loopCounter, "mbutton", "Ctrl", items)
        }
        CreateRadialMenu(sections, key, keySpecial, items) {
            GMenu := Radial_Menu()
            GMenu.SetSections(sections)
            if (key != "") {
                GMenu.SetKey(key)                
            }
            if (keySpecial != "") {
                GMenu.SetKeySpecial(keySpecial)                
            }
            Loop items.Length
            {
                item := items[A_Index]
                if (item[3] = "add2") {
                    GMenu.Add2(item[1], item[2], item[4])                    
                }
                else if (item[3] = "add") {
                    GMenu.Add(item[1], item[2], item[4])                    
                }
            }
            GMenu.ResetRadialAlpha()
            return GMenu.Show()
        }
        OpenAppRadial(*) {
            global PosX, PosY
            MouseMove(PosX, PosY)
            openResult := CreateRadialFromFile("RadialCSVFiles\appRadial.csv")
            switch openResult
            {
                case "Open Eagle": OpenEagle(0)
                case "Open Eagle and": OpenEagle(1)
                case "Open Obsidian": OpenObsidian(0)
                case "Open Obsidian and": OpenObsidian(1)
                case "Open Discord": OpenDiscord(0)
                case "Open Discord and": OpenDiscord(1)
                case "Open Google Chrome": OpenGoogleChrome(0)
                case "Open Google Chrome and": OpenGoogleChrome(1)
                case "Open Visual Studio Code": OpenVScode(0)
                case "Open Visual Studio Code and": OpenVScode(1)
                case "Back": OpenBaseRadial()
                default: MsgBox(openResult)
            }
        }
;#endregion
;#region googleChromeRadial
GoogleChromeHotkeys() {
    googleChromeResult := CreateRadialFromFile("RadialCSVFiles\googleChromeContextRadial.csv")
    switch googleChromeResult
    {
        case "Search All Open Tabs": SendInput("{Ctrl Down}{Shift Down}a{Ctrl Up}{Shift Up}")
        case "Open New Tab": SendInput("{Ctrl Down}t{Ctrl Up}")
        case "Close Tab": SendInput("{Ctrl Down}w{Ctrl Up}")
        case "Reopen last": SendInput("{Ctrl Down}{Shift Down}t{Ctrl Up}{Shift Up}")
        case "Address Bar": SendInput("{Alt Down}d{Alt Up}")
        case "Refresh": SendInput("{F5}")
        case "Find": SendInput("{Ctrl Down}f{Ctrl Up}")
        case "Back": OpenBaseRadial()
        default: MsgBox(googleChromeResult)
    }
}
OpenGoogleChrome(*) {
    if (WinExist("ahk_exe chrome.exe")) {
        WinActivate("ahk_exe chrome.exe")
    } else {
        Run("C:\Program Files (x86)\Google\Chrome\Application\chrome.exe")
    }
}
;#endregion
;#region DiscordRadial
CreateDiscordRadial(*) {
    GMenu := Radial_Menu()
    GMenu.SetSections("6")
    GMenu.SetKeySpecial("Ctrl")
    GMenu.Add("Quick Switcher", "Images\DiscordQuickSwitchIcon.png", 1)
    GMenu.Add2("Mark Server Read", "Images/bookIcon.png", 1)
    GMenu.Add("Toggle Last Server and DMs", "Images\messageIcon.png", 2)
    GMenu.Add("Toggle Mute", "Images\muteIcon.png", 3)
    GMenu.Add2("Toggle Deafen", "Images\deafenIcon.png", 3)
    GMenu.Add("Navigate Up", "Images/upIcon.png", 4)
    GMenu.Add2("Navigate Down", "Images/downIcon.png", 4)
    GMenu.Add("Back", "Images\backIcon.png", 5)
    GMenu.Add("Search In Channel", "Images\searchIcon.png", 6)
    GMenu.ResetRadialAlpha()
    Return Result := GMenu.Show()
}
DiscordHotkeys() {
    DiscordResult := CreateDiscordRadial()
    switch DiscordResult
    {
        case "Quick Switcher": SendInput("{Ctrl Down}k{Ctrl Up}")
        case "Search In Channel": SendInput("{Ctrl Down}f{Ctrl Up}")
        case "Toggle Mute": SendInput("{Ctrl Down}{Shift Down}m{Ctrl Up}{Shift Up}")
        case "Toggle Deafen": SendInput("{Ctrl Down}{Shift Down}m{Ctrl Up}{Shift Up}")
        case "Toggle Last Server and DMs": SendInput("{Ctrl Down}{Alt Down}{Right}{Ctrl Up}{Alt Up}")
        case "Navigate Up": SendInput("{Ctrl Down}{Alt Down}{Up}{Ctrl Up}{Alt Up}")
        case "Navigate Down": SendInput("{Ctrl Down}{Alt Down}{Down}{Ctrl Up}{Alt Up}")
        case "Mark Server Read": SendInput("{Shift Down}{Esc}{Shift Up}")
        case "Back": OpenBaseRadial()
        default: MsgBox(DiscordResult)
    }
}
OpenDiscord(*) {
    if (WinExist("ahk_exe Discord.exe")) {
        WinActivate("ahk_exe Discord.exe")
    } else {
        Run("C:\Users\Jamie\AppData\Local\Discord\Update.exe --processStart Discord.exe")
    }
}
;#endregion
;#region VsCodeRadial
CreateVsCodeRadial(*) {
    GMenu := Radial_Menu()
    GMenu.SetSections("8")
    GMenu.SetKeySpecial("Ctrl")
    GMenu.Add("Command Pallette", "Images\pallette.png", 1)
    GMenu.Add2("Quick Open", "Images/bookIcon.png", 1)
    GMenu.Add("Toggle Sidebar", "Images\toggle.png", 2)
    GMenu.Add2("Toggle Zen Mode", "Images\zenModeIcon.png", 2)
    GMenu.Add("Comment", "", 3)
    GMenu.Add("Show References", "Images\deafenIcon.png", 4)
    GMenu.Add("Find", "Images\searchIcon.png", 5)
    GMenu.Add2("Replace", "Images\RefreshIcon.png", 5)
    GMenu.Add("Back", "Images\backIcon.png", 6)
    GMenu.Add2("Close", "Images\close.png", 6)
    GMenu.Add("", "", 7)
    GMenu.Add("Copy Line Down", "Images\downIcon.png", 8)
    GMenu.Add2("Copy Line Up", "Images\upIcon.png", 8)
    GMenu.ResetRadialAlpha()
    Return Result := GMenu.Show()
}
VsCodeHotkeys() {
    ObsidianResult := CreateVsCodeRadial()
    switch ObsidianResult
    {
        case "Command Pallette": SendInput("{Ctrl Down}{Shift Down}p{Ctrl Up}{Shift Up}")
        case "Quick Open": SendInput("{Ctrl Down}p{Ctrl Up}")
        case "Toggle Sidebar": SendInput("{Ctrl Down}b{Ctrl Up}")
        case "Toggle Zen Mode": SendInput("{Ctrl Down}k{Ctrl Up}z")
        case "Comment": SendInput("{Shift Down}{Alt Down}a{Shift Up}{Alt Up}")
        case "Find": SendInput("{Ctrl Down}f{Ctrl Up}")
        case "Replace": SendInput("{Ctrl Down}h{Ctrl Up}")
        case "Show References": SendInput("{Shift Down}{F12}{Shift Up}")
        case "Copy Line Down": SendInput("{Shift Down}{Alt Down}{down}{Shift Up}{Alt Up}")
        case "Copy Line Up": SendInput("{Shift Down}{Alt Down}{up}{Shift Up}{Alt Up}")
        case "Back": OpenBaseRadial()
        case "Close":
        default: MsgBox(ObsidianResult)
    }
}
OpenVScode(*) {
    if (WinExist("ahk_exe Code.exe")) {
        WinActivate("ahk_exe Code.exe")
    }
    else {
        Run("C:\Users\Jamie\AppData\Local\Programs\Microsoft VS Code\Code.exe")    ;open from file path
    }
}
CreateVsCodePluginsRadial(*) {
    GMenu := Radial_Menu()
    GMenu.SetSections("8")
    GMenu.SetKeySpecial("Ctrl")
    GMenu.Add("Toggle Bookmarks", "Images\bookmarkIcon.png", 1)
    GMenu.Add2("Clear Bookmarks", "", 1)
    GMenu.Add("Next Bookmark", "", 2)
    GMenu.Add2("Prev Bookmark", "", 2)
    GMenu.Add("", "", 3)
    GMenu.Add("", "", 4)
    GMenu.Add("", "", 5)
    GMenu.Add("Back", "Images\backIcon.png", 6)
    GMenu.Add2("", "", 7)
    GMenu.Add("", "", 7)
    GMenu.Add("", "", 8)
    GMenu.ResetRadialAlpha()
    Return Result := GMenu.Show()
}
VsCodePluginsHotkeys() {
    ObsidianResult := CreateVsCodePluginsRadial()
    switch ObsidianResult
    {
        case "Toggle Bookmarks": SendInput("{Ctrl Down}{Alt Down}k{Ctrl Up}{Alt Up}")
        case "Clear Bookmarks": ClearBookmarks()
        case "Next Bookmark":SendInput("{Ctrl Down}{Alt Down}l{Ctrl Up}{Alt Up}")
        case "Prev Bookmark":SendInput("{Ctrl Down}{Alt Down}j{Ctrl Up}{Alt Up}")
        case "Back": OpenBaseRadial()
        case "Close":
        default: MsgBox(ObsidianResult)
    }
    ClearBookmarks() {
        SendInput("{Ctrl Down}{delete Down}{Ctrl Up}")
        KeyWait "control"
        SendInput("b")
    }
}
;#endregion
;#region ObsidianRadial
CreateObsidianRadial(*) {
    GMenu := Radial_Menu()
    GMenu.SetSections("5")
    GMenu.SetKeySpecial("Ctrl")
    GMenu.Add("Pallette", "Images\pallette.png", 1)
    GMenu.Add("Insert Callout", "Images\deafenIcon.png", 2)
    GMenu.Add2("Toggle Checkboxes", "Images\deafenIcon.png", 2)
    GMenu.Add("Open Daily Note", "Images\NewTabIcon.png", 3)
    GMenu.Add2("Open Tomorrows Daily Note", "Images/bookIcon.png", 3)
    GMenu.Add("Find", "Images\searchIcon.png", 4)
    GMenu.Add("Back", "Images\backIcon.png", 5)
    GMenu.ResetRadialAlpha()
    Return Result := GMenu.Show()
}
ObsidianHotkeys() {
    ObsidianResult := CreateObsidianRadial()
    switch ObsidianResult
    {
        case "Open Daily Note": SendInput("{Ctrl Down}{F1}{Ctrl Up}")
        case "Open Tomorrows Daily Note": SendInput("{Ctrl Down}{Shift Down}{F1}{Ctrl Up}{Shift Up}")
        case "Pallette": SendInput("{Ctrl Down}p{Ctrl Up}")
        case "Find": SendInput("{Ctrl Down}f{Ctrl Up}")
        case "Insert Callout": SendInput("{Ctrl Down}{Shift Down}{F2}{Shift Up}{Ctrl Up}")
        case "Toggle Checkboxes": SendInput("{Ctrl Down}l{Ctrl Up}")
        case "Back": OpenBaseRadial()
        default: MsgBox(ObsidianResult)
    }
}
CreateObsidianPluginsRadial(*) {
    GMenu := Radial_Menu()
    GMenu.SetSections("8")
    GMenu.SetKeySpecial("Ctrl")
    GMenu.Add("", "", 1)
    GMenu.Add2("", "", 1)
    GMenu.Add("", "", 2)
    GMenu.Add2("", "", 2)
    GMenu.Add("", "", 3)
    GMenu.Add2("", "", 3)
    GMenu.Add("Show Todays Day Planner", "Images\commentIcon.png", 4)
    GMenu.Add2("Show Timeline", "Images\commentIcon.png", 4)
    GMenu.Add("", "", 5)
    GMenu.Add2("", "", 5)
    GMenu.Add("Back", "Images\backIcon.png", 6)
    GMenu.Add("", "", 7)
    GMenu.Add("", "", 8)
    GMenu.Add2("", "", 8)
    GMenu.ResetRadialAlpha()
    Return Result := GMenu.Show()
}
ObsidianPluginsHotkeys(*) {
    ObsidianResult := CreateObsidianPluginsRadial()
    switch ObsidianResult
    {
        case "Back": OpenBaseRadial()
        case "Show Todays Day Planner": SendInput("{Shift Down}{Alt Down}{Ctrl Down}p{Shift Up}{Alt Up}{Ctrl Up}")
        case "Show Timeline": SendInput("{Shift Down}{Alt Down}{Ctrl Down}t{Shift Up}{Alt Up}{Ctrl Up}")
        case "Close":
        default: MsgBox(ObsidianResult)
    }
}
OpenObsidian(isAnd) {
    if (ProcessExist("Obsidian.exe")) {
        if (!isAnd) {
            WinActivate("ahk_exe Obsidian.exe")
        }else {
            WinActivate("ahk_exe Obsidian.exe")
            if(WinWaitActive("ahk_exe Obsidian.exe")){
                ObsidianHotkeys()
            }
        }
    }
    else {
        Run("C:\Users\Jamie\AppData\Local\Obsidian\Obsidian.exe")    ;open from file path
    }
}
;#endregion
;#region EagleRadial
/* eagle doesn't have any extra functions since we haven't made a context menu for it*/
OpenEagle(isAnd) {
    if (ProcessExist("Eagle.exe")) {
        if (!isAnd) {
            WinActivate("ahk_exe Eagle.exe")            
        }else {
            WinActivate("ahk_exe Eagle.exe")
            if (WinWaitActive("ahk_exe Eagle.exe")) {
                ;open command pallette
            }
        }
    }
    else {
        Run("H:\Program Files (x86)\Eagle\Eagle.exe")    ;open from file path
    }
}
;#endregion

;#region boilerPlate Radial menu code
Class Radial_Menu {
    ;when we create a new radial menu we need to populate some data even if it's null
    __New() {
        This.Sections := "4"
        This.RM_Key := "Capslock"
        This.Sect := Map()
        
        This.Sect_Name := Map()
        This.Sect_Img := Map()
        This.Sect_Name2 := Map()
        This.Sect_Img2 := Map()
        This.ColorBackGround := "2B3D55"
        This.ColorLineBackGround := "334966"
        This.ColorSelected := "121922"
        This.ColorLineSelected := "000000"
        This.ShowSfxPath := "sfx\219069__annabloom__click1.wav"
        This.RadialAlpha := 255
    }
    ;This is exactly what it looks like just a function to pass data into the class
    ResetRadialAlpha() {
        This.RadialAlpha := 0
    }
    ;This is exactly what it looks like just a function to pass data into the class
    SetRadialColors(ColorBackGround, ColorLineBackGround, ColorSelected, ColorLineSelected) {
        This.ColorBackGround := ColorBackGround
        This.ColorLineBackGround := ColorLineBackGround
        This.ColorSelected := ColorSelected
        This.ColorLineSelected := ColorLineSelected
    }
    ;This is exactly what it looks like just a function to pass data into the class
    SetShowClick(ShowSfxPath) {
        This.ShowSfxPath := ShowSfxPath
    }
    ;This is exactly what it looks like just a function to pass data into the class
    SetSections(Sections) {
        This.Sections := Sections
    }
    ;This is exactly what it looks like just a function to pass data into the class
    SetKey(RM_Key) {
        This.RM_Key := RM_Key
    }
    ;This is exactly what it looks like just a function to pass data into the class
    SetKeySpecial(RM_Key2) {
        This.RM_Key2 := RM_Key2
    }
    ;how we add "Sections" or "Clickable Pie" to our menu
    Add(SectionName, SectionImg, ArcNr) {
        ;if this.Sect(which we know is a empty map)doesn't have the property ArcNr -We will create it
        if !HasProp(This.Sect, ArcNr) {
            This.Sect.%ArcNr% := Map()
        }
        ;if the sectionImg passed through this func is something we set it to the class image
        if (SectionImg != "") {
            This.Sect.%ArcNr%.Img := SectionImg
        }
        ;this will set the names of each "Section" Or radial button
        This.Sect.%ArcNr%.Name := SectionName
        if (This.Sections < ArcNr) {
            This.Sections := ArcNr
        }
        ;arcNr now is 8 or whatever we set "Sections" To in our setSections func
    }
    ;Add2 seems to be an alternate button placed in the same space as Add just with a required key press for activation (basically the same stuff not worth commenting)
    Add2(SectionName2, SectionImg2, ArcNr) {
        if !HasProp(This.Sect, ArcNr) {
            This.Sect.%ArcNr% := Map()
        }
        if (SectionImg2 != "") {
            This.Sect.%ArcNr%.Img2 := SectionImg2
        }
        This.Sect.%ArcNr%.Name2 := SectionName2
        if (This.Sections < ArcNr) {
            This.Sections := ArcNr
        }
    }
    ;Show is called to build the visual elements of the pie (I think)
    Show() {
        ;global &PosX, &PosY
        global RadialAlpha
        static
        SectName := ""
        CoordMode "Mouse", "Screen"
        MouseGetPos(&PosX, &PosY)
        WinGetPos(&X_Win, &Y_Win, , , "A")
        SoundPlay(This.ShowSfxPath)
        outer_Radius := 80
        inner_Radius := outer_Radius * 0.34
        Offset := 2
        ;not sure what R_3 is
        R_3 := outer_Radius + Offset * 2 + 10

        X_Gui := PosX - R_3
        Y_Gui := PosY - R_3
        ;X_Gui := PosX - R_3 + X_Win
        ;Y_Gui := PosY - R_3 + Y_Win
        outerRadialSizeMult := 2
        ;this is not the limiting factor to us drawing bigger though it is one
        Height_Gui := R_3 * 2 * outerRadialSizeMult 
        Width_Gui := R_3 * 2
        Width := R_3 * 2
        height := R_3 * 2

        ; Destroying old menu if exists
        if WinExist("RM_Menu") {
            WinClose("RM_Menu")
        }

        ; Start gdi+
        global pToken
        If !pToken := Gdip_Startup() {
            MsgBox("Gdiplus failed to start.Please ensure you have gdiplus on your system", , 48)
            ExitApp
        }
        OnExit(ExitFunc)

        ; Create a layered window (+E0x80000 : must be used for UpdateLayeredWindow to work!) that is always on top (+AlwaysOnTop), has no taskbar entry or caption
        Gui_Radial_Menu := Gui("-Caption +E0x80000 +LastFound +AlwaysOnTop +ToolWindow +OwnDialogs")
        ; Show the window
        Gui_Radial_Menu.Title := "RM_Menu"
        Gui_Radial_Menu.Show("NA x" . X_Gui . " y" . Y_Gui . " w" . Width_Gui . " h" . Height_Gui )
        hwnd1 := WinExist()
        ; Get a handle to this window we have created in order to update it later

        Loop This.Sections {    ;Setting Bitmap images of sections

            if HasProp(This.Sect.%A_Index%, "Img") {
                if FileExist(This.Sect.%A_Index%.Img) {
                    This.Sect.%A_Index%.pBitmap := Gdip_CreateBitmapFromFile(This.Sect.%A_Index%.Img)
                } else if (This.Sect.%A_Index%.Img != "" and IsObject(This.Sect.%A_Index%.Img)) {
                    This.Sect.%A_Index%.pBitmap := Gdip_CreateBitmapFromHBITMAP(This.Sect.%A_Index%.Img)
                }

                if HasProp(This.Sect.%A_Index%, "pBitmap") {
                    This.Sect.%A_Index%.bWidth := Gdip_GetImageWidth(This.Sect.%A_Index%.pBitmap)
                    This.Sect.%A_Index%.bHeight := Gdip_GetImageHeight(This.Sect.%A_Index%.pBitmap)
                }
            }

            if HasProp(This.Sect.%A_Index%, "Img2") {
                if FileExist(This.Sect.%A_Index%.Img2) {
                    This.Sect.%A_Index%.pBitmap2 := Gdip_CreateBitmapFromFile(This.Sect.%A_Index%.Img2)
                } else if (This.Sect.%A_Index%.Img2 != "" and IsObject(This.Sect.%A_Index%.Img2)) {
                    This.Sect.%A_Index%.pBitmap2 := Gdip_CreateBitmapFromHBITMAP(This.Sect.%A_Index%.Img2)
                }
                if HasProp(This.Sect.%A_Index%, "pBitmap2") {
                    This.Sect.%A_Index%.bWidth2 := Gdip_GetImageWidth(This.Sect.%A_Index%.pBitmap2)
                    This.Sect.%A_Index%.bHeight2 := Gdip_GetImageHeight(This.Sect.%A_Index%.pBitmap2)
                }
            }
        }

        Counter := 0
        loop This.Sections {    ;Calculating Section Points
            SectionAngle := 2 * 3.141592653589793 / This.Sections * (A_Index - 1)

            This.Sect.%A_Index%.X_Bitmap := R_3 + (outer_Radius-20) * cos(SectionAngle) - 8
            This.Sect.%A_Index%.Y_Bitmap := R_3 + (outer_Radius-20) * sin(SectionAngle) - 8

            This.Sect.%A_Index%.PointsOuterRadial := Gdip_GetPointsSection(R_3, R_3,outer_Radius * 2, outer_Radius + Offset * 2 + 10, This.Sections, Offset, A_Index)
            This.Sect.%A_Index%.PointsOutline := Gdip_GetPointsSection(R_3, R_3, outer_Radius + Offset * 2 + 10, outer_Radius + Offset * 2, This.Sections, Offset, A_Index)
            This.Sect.%A_Index%.Points := Gdip_GetPointsSection(R_3, R_3, outer_Radius, inner_Radius, This.Sections, Offset, A_Index)
        }

        ; Setting brushes and Pens
        pBrush := Gdip_BrushCreateSolid("0xFF" This.ColorBackGround)
        ;MsgBox(This.ColorSelected)
        pBrushA := Gdip_BrushCreateSolid("0xFF" This.ColorSelected)
        pBrushC := Gdip_BrushCreateSolid("0X01" This.ColorBackGround)
        pPen := Gdip_CreatePen("0xFF" This.ColorLineBackGround, 1)
        pPenA := Gdip_CreatePen("0xD2" This.ColorLineSelected, 1)
        hdc := CreateCompatibleDC()

        G := Gdip_GraphicsFromHDC(hdc)
        Gdip_SetSmoothingMode(G, 2)

        RM_KeyState_D := 0
        Section_Mouse_Prev := -1
        X_Mouse_P := -1
        Y_Mouse_P := -1
        ;no idea what this does uncommented 2/14/2023
        ;Gdip_FillEllipse(G, pBrushC, R_3 - outer_Radius, R_3 - outer_Radius, 2 * outer_Radius, 2 * outer_Radius)
        loop {
            RM_KeyState := GetKeyState(This.RM_Key, "P")
            RM_KeyState2 := GetKeyState(This.RM_Key2, "P")

            if !WinExist("RM_Menu") {
                Exit
            }
            if (RM_KeyState = 1) {
                RM_KeyState_D := 1
            }
            ;if button isn't pressed but it was last loop do this
            if (RM_KeyState = 0 and RM_KeyState_D = 1) {
                ;get section mouse is over
                Section_Mouse := RM_GetSection(This.Sections, inner_Radius, PosX, PosY)
                ;if name exists set sectionName to that name if it doesn't set sectName to 0
                if (HasProp(This.Sect.%Section_Mouse%, "Name"))
                {
                    SectName := This.Sect.%Section_Mouse%.Name
                } else {
                    SectName := ""
                }
                ;SectName := HasProp(This.Sect.%Section_Mouse%, "Name") ? This.Sect.%Section_Mouse%.Name : ""
                if (Section_Mouse != 0) {
                    break
                }
                RM_KeyState_D := 0
            }
            if (GetKeyState("LButton")) {

                Section_Mouse := RM_GetSection(This.Sections, inner_Radius, PosX, PosY)
                SectName := Section_Mouse = 0 ? "" : HasProp(This.Sect.%Section_Mouse%, "Name") ? This.Sect.%Section_Mouse%.Name : ""
                break
            }
            if GetKeyState("Escape") {
                Section_Mouse := 0
                SectName := ""
                break
            }
            CoordMode("Mouse", "Screen")
            MouseGetPos(&X_Mouse, &Y_Mouse)
            X_Rel := X_Mouse - PosX
            Y_Rel := Y_Mouse - PosY
            Center_Distance := Sqrt(X_Rel * X_Rel + Y_Rel * Y_Rel)

            Section_Mouse := RM_GetSection(This.Sections, inner_Radius, PosX, PosY)

            if (Center_Distance > outer_Radius) {
                break
            }
            if (Section_Mouse = 0 or Section_Mouse = "") {
                ToolTip()
                SectName := ""
                SectName_N := ""
            }
            else {
                Counter++
                SectName_N := HasProp(This.Sect.%Section_Mouse%, "Name") ? This.Sect.%Section_Mouse%.Name : ""
                SectName2 := HasProp(This.Sect.%Section_Mouse%, "Name2") ? This.Sect.%Section_Mouse%.Name2 : ""
                if (HasProp(This, "RM_Key2") and GetKeyState(This.RM_Key2, "P") and SectName2 != "") {
                    SectName_N := SectName2
                }

                if ((X_Mouse_P != X_Mouse) or (Y_Mouse_P != Y_Mouse) or SectName_N != SectName or Counter > 500) {
                    SectName := SectName_N
                    MouseGetPos(&X_Mouse_P, &Y_Mouse_P)
                    if (Counter > 500) {
                        ToolTip(SectName_N)
                        Counter := 0
                    }

                }
            }
            if (Section_Mouse != Section_Mouse_Prev or A_Index = 1 or RM_KeyState2_Prev != RM_KeyState2) {    ; Update GDIP

                Gdip_GraphicsClear(G)
                hbm := CreateDIBSection(Height_Gui, Height_Gui)    ; Create a gdi bitmap with width and height of what we are going to draw into it. This is the entire drawing area for everything
                hdc := CreateCompatibleDC()    ; Get a device context compatible with the screen
                obm := SelectObject(hdc, hbm)    ; Select the bitmap into the device context
                G := Gdip_GraphicsFromHDC(hdc)    ; Get a pointer to the graphics of the bitmap, for use with drawing functions

                ; Set the smoothing mode to antialias = 4 to make shapes appear smother (only used for vector drawing and filling)
                Gdip_SetSmoothingMode(G, 4)
                ;no idea what this does uncommented 2/14/2023
                ;Gdip_FillEllipse(G, pBrushC, R_3 - outer_Radius, R_3 - outer_Radius, 2 * outer_Radius, 2 * outer_Radius)

                loop This.Sections {
                    Section := This.Sect.%A_Index%
                    SectionAngle := 2 * 3.141592653589793 / This.Sections * (A_Index - 1)
                    if (Section.Name = "") {
                        continue
                    }
                    ;draw selected stuff
                    If (A_Index = Section_Mouse) {
                        Gdip_FillPolygon(G, pBrushA, Section.Points)
                        Gdip_DrawLines(G, pPenA, Section.Points)
                        Gdip_FillPolygon(G, pBrushA, Section.PointsOutline)
                        Gdip_DrawLines(G, pPenA, Section.PointsOutline)
                        ;outer radial
                        ;Gdip_FillPolygon(G,pBrush,Section.PointsOuterRadial)
                        ;Gdip_DrawLines(G,pPen,Section.PointsOuterRadial)
                        ;draw other stuff
                    } else {
                        Gdip_FillPolygon(G, pBrush, Section.Points)
                        Gdip_DrawLines(G, pPen, Section.Points)
                    }
                    if (GetKeyState(This.RM_Key2, "P") and HasProp(Section, "pBitmap2")) {
                        Gdip_DrawImage(G, Section.pBitmap2, Section.X_Bitmap, Section.Y_Bitmap, 16, 16 * Section.bHeight2 / Section.bWidth2, 0, 0, Section.bWidth2, Section.bHeight2)
                    } else if HasProp(Section, "pBitmap") {
                        Gdip_DrawImage(G, Section.pBitmap, Section.X_Bitmap, Section.Y_Bitmap, 16, 16 * Section.bHeight / Section.bWidth, 0, 0, Section.bWidth, Section.bHeight)
                    }
                    if !HasProp(Section, "pBitmap") and HasProp(Section, "Name") and Section.Name != "" {
                        Gdip_TextToGraphics(G, Section.Name, "vCenter x" This.Sect.%A_Index%.X_Bitmap - 20 + 8 " y" This.Sect.%A_Index%.Y_Bitmap - 20 + 8, , 40, 40)
                    }
                }
                ; Update the specified window we have created (hwnd1) with a handle to our bitmap (hdc), specifying the x,y,w,h we want it positioned on our screen
                ; So this will position our gui at (0,0) with the Width and Height specified earlier
                ;figured out alpha but now we need to find out how to make it only fade in
                if (This.RadialAlpha != 255) {
                    BlockInput("MouseMove")
                    loop 255 {
                        UpdateLayeredWindow(hwnd1, hdc, X_Gui, Y_Gui, Width, Height, This.RadialAlpha)
                        This.RadialAlpha++
                        
                        if (mod(This.RadialAlpha, 20) = 0) {
                            Sleep(1)
                        }
                    }
                }
                BlockInput("MouseMoveOff")
                UpdateLayeredWindow(hwnd1, hdc, X_Gui, Y_Gui, Width, Height)
                SelectObject(hdc, obm)    ; Select the object back into the hdc
                DeleteObject(hbm)    ; Now the bitmap may be deleted
                DeleteDC(hdc)    ; Also the device context related to the bitmap may be deleted
                Gdip_DeleteGraphics(G)    ; The graphics may now be deleted
                SoundPlay(This.ShowSfxPath)
            }
            RM_KeyState2_Prev := RM_KeyState2
            Section_Mouse_Prev := Section_Mouse
        }

        Tooltip

        SelectObject(hdc, obm)    ; Select the object back into the hdc
        DeleteObject(hbm)    ; Now the bitmap may be deleted
        DeleteDC(hdc)    ; Also the device context related to the bitmap may be deleted
        Gdip_DeleteGraphics(G)    ; The graphics may now be deleted

        loop This.Sections {
            if HasProp(This.Sect.%A_Index%, "pBitmap") {
                Gdip_DisposeImage(This.Sect.%A_Index%.pBitmap)
            }
            if HasProp(This.Sect.%A_Index%, "pBitmap2") {
                Gdip_DisposeImage(This.Sect.%A_Index%.pBitmap2)
            }
        }

        Gdip_DeleteBrush(pBrushC)
        Gdip_DeleteBrush(pBrush)
        Gdip_DeleteBrush(pBrushA)
        Gdip_DeletePen(pPen)
        Gdip_DeletePen(pPenA)
        Gdip_Shutdown(pToken)

        Gui_Radial_Menu.Destroy()
        Return SectName
    }
    
}

;#######################################################################

ExitFunc(ExitReason, ExitCode)
{
    global
    ; gdi+ may now be shutdown on exiting the program
    Gdip_Shutdown(pToken)
}

Gdip_GetPointsSection(PosX, PosY, outer_Radius, inner_Radius, Sections, Offset, Section := "1") {
    Section := Section - 1
    SectionAngle := 2 * 3.141592653589793 / Sections
    inner_Radius_Min := 4 * Offset / Sin(SectionAngle)
    inner_Radius := inner_Radius > inner_Radius_Min ? inner_Radius : inner_Radius_Min
    SweepAngle := ACos((outer_Radius * cos(SectionAngle / 2) + Offset * sin(SectionAngle / 2)) / outer_Radius) * 2
    SweepAngle_2 := ACos((inner_Radius * cos(SectionAngle / 2) + Offset * sin(SectionAngle / 2)) / inner_Radius) * 2

    Loop_Sections := round(outer_Radius * SweepAngle)
    StartAngle := -SweepAngle / 2 + SectionAngle * (Section)
    loop Loop_Sections {
        Angle := StartAngle + (A_Index - 1) * SweepAngle / (Loop_Sections - 1)
        X_Arc := round(PosX + outer_Radius * cos(Angle))
        Y_Arc := round(PosY + outer_Radius * sin(Angle))
        if (A_Index = 1) {
            Points := X_Arc "," Y_Arc
            X_Arc_Start := X_Arc
            Y_Arc_Start := Y_Arc
            continue
        }
        Points .= "|" X_Arc "," Y_Arc
    }

    Loop_Sections := round(inner_Radius * SweepAngle_2)
    StartAngle_2 := SweepAngle_2 / 2 + SectionAngle * (Section)
    loop Loop_Sections {
        Angle := StartAngle_2 - (A_Index - 1) * SweepAngle_2 / (Loop_Sections - 1)
        X_Arc := round(PosX + inner_Radius * cos(Angle))
        Y_Arc := round(PosY + inner_Radius * sin(Angle))
        Points .= "|" X_Arc "," Y_Arc
    }

    Points .= "|" X_Arc_Start "," Y_Arc_Start

    return Points
}

;#######################################################################

RM_GetSection(Sections, inner_Radius, PosX, PosY) {

    CoordMode("Mouse", "Screen")
    WinGetPos(&X_Win, &Y_Win, , , "RM_Menu")
    MouseGetPos(&X_Mouse, &Y_Mouse)

    X_Rel := X_Mouse - PosX
    Y_Rel := Y_Mouse - PosY

    Distance_Center := Sqrt(X_Rel * X_Rel + Y_Rel * Y_Rel)
    Section_Mouse := ""
    X_Rel := X_Rel = 0 ? 0.01 : X_Rel    ; (correction to prevent X to be 0)
    Y_Rel := Y_Rel = 0 ? 0.01 : Y_Rel    ; (correction to prevent X to be 0)

    if (Distance_Center < inner_Radius) {
        Section_Mouse := 0
    } else if (Distance_Center > inner_Radius) {
        a := X_Rel = 0 ? (Y_Rel = 0 ? 0 : Y_Rel > 0 ? 90 : 270) : atan(Y_Rel / X_Rel) * 57.2957795130823209    ; 180/pi
        Angle := X_Rel < 0 ? 180 + a : a < 0 ? 360 + a : a
        Section_Mouse := 1 + round(Angle / 360 * Sections)
        if (Section_Mouse > Sections) {
            Section_Mouse := 1
        }
    }

    return Section_Mouse
}
;#endregion
