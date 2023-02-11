; This scripts creates a radial menu / pie menu
; The selected menu item is returned as a string.
; mbutton is used in this example to trigger the menu

#SingleInstance Force
#Requires AutoHotkey v2.0-beta.3
;#NoEnv

; Uncomment if Gdip.ahk is not in your standard library
#Include Gdip_All.ahk
;When on desktop Radial menu acts funny
PosX := 0
PosY := 0
;#region Input
^XButton1:: Reload

+mButton::
{
    ClickPosition()
    OpenAppRadial()
}
^mButton::
{
    ClickPosition()
    CheckContext()
}
mButton::
{
    ClickPosition()
    MsgBox(PosX)
    MsgBox(PosY)
    OpenBaseRadial()
}

ClickPosition(*)
{
    global PosX, PosY
    CoordMode("Mouse", "Screen")
    MouseGetPos(&PosX, &PosY)
    return
}
;#endregion
;#region openRadialsFunctions
OpenBaseRadial(*) {
    ; MouseMove(PosX, PosY, 0)
    Result := CreateBaseRadial()
    switch Result
    {
        case "Table": Run("AutoHtmlTable.ahk")
        case "Color": Run("v2ObsidianColor.ahk")
        case "Open App": OpenAppRadial()
        case "Context Menu": CheckContext()
        case "Windows": CheckContext()
        case "Close":    ;do nothing
        default:
            MsgBox(Result)
    }
}
OpenAppRadial(*) {
    ; MouseMove(PosX, PosY)
    openResult := CreateAppRadial()
    switch openResult
    {
        case "Open Eagle": OpenEagle()
        case "Open Obsidian": OpenObsidian()
        case "Open Discord": OpenDiscord()
        case "Open Google Chrome": OpenGoogleChrome()
        case "Open Visual Studio Code": OpenVScode()
        case "Back": OpenBaseRadial()
        default: MsgBox(openResult)
    }
}
;#endregion
;#region Context Menu Contextualization
CheckContext(*) {
    WindowProcess := WinGetProcessName("A")
    CreateContextMenu(WindowProcess)
    googleChromeResult := ""
}
CreateContextMenu(WindowProcess) {
    WindowProcess := "ahk_exe " . WindowProcess
    switch WindowProcess {
        case "ahk_exe chrome.exe": GoogleChromeHotkeys()
        case "ahk_exe Discord.exe": DiscordHotkeys()
        case "ahk_exe Obsidian.exe": ObsidianHotkeys()
        case "ahk_exe Eagle.exe":
        case "ahk_exe Code.exe": VsCodeHotkeys()

        default: MsgBox("this app is not supported yet")
    }
}
;#endregion
;#region Context Specific Hotkeys
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
GoogleChromeHotkeys() {
    googleChromeResult := CreateGoogleChromeRadial()
    switch googleChromeResult
    {
        case "Search All Open Tabs": SendInput("{Ctrl Down}{Shift Down}a{Ctrl Up}{Shift Up}")
        case "Open New Tab": SendInput("{Ctrl Down}t{Ctrl Up}")
        case "Close Tab": SendInput("{Ctrl Down}w{Ctrl Up}")
        case "Reopen last": SendInput("{Ctrl Down}{Shift Down}t{Ctrl Up}{Shift Up}")
        case "Address Bar": SendInput("{Alt Down}d{Alt Up}")
        case "Refresh": SendInput("{F5}")
        case "Back": OpenBaseRadial()
        default: MsgBox(googleChromeResult)
    }
}
VsCodeHotkeys() {
    VsCodeResult := CreateVsCodeRadial()
    switch VsCodeResult
    {
        case "Command Pallette": SendInput("{Ctrl Down}{Shift Down}p{Ctrl Up}{Shift Up}")
        case "Quick Open": SendInput("{Ctrl Down}p{Ctrl Up}")
        case "Close Sidebar": SendInput("{Ctrl Down}b{Ctrl Up}")
        case "Toggle Zen Mode": SendInput("{Ctrl Down}k{Ctrl Up}z")
        case "Comment": SendInput("{Shift Down}{Alt Down}a{Shift Up}{Alt Up}")
        case "Find": SendInput("{Ctrl Down}f{Ctrl Up}")
        case "Replace": SendInput("{Ctrl Down}h{Ctrl Up}")
        case "Show References": SendInput("{Shift Down}{F12}{Shift Up}")
        case "Copy Line Down": SendInput("{Shift Down}{Alt Down}{down}{Shift Up}{Alt Up}")
        case "Copy Line Up": SendInput("{Shift Down}{Alt Down}{up}{Shift Up}{Alt Up}")
        case "Back": OpenBaseRadial()
        default: MsgBox(VsCodeResult)
    }
}
ObsidianHotkeys() {
    ObsidianResult := CreateObsidianRadial()
    switch ObsidianResult
    {
        case "Open Daily Note": SendInput("{Ctrl Down}{F1}{Ctrl Up}")
        case "Open Tomorrows Daily Note": SendInput("{Ctrl Down}{Shift Down}{F1}{Ctrl Up}{Shift Up}")
        case "Pallette": SendInput("{Ctrl Down}p{Ctrl Up}")
        case "Show Todays Day Planner": SendInput("{Shift Down}{Alt Down}{Ctrl Down}p{Shift Up}{Alt Up}{Ctrl Up}")
        case "Show Timeline": SendInput("{Shift Down}{Alt Down}{Ctrl Down}t{Shift Up}{Alt Up}{Ctrl Up}")
        case "Find": SendInput("{Ctrl Down}f{Ctrl Up}")
        case "Show References": SendInput("{Shift Down}{F12}{Shift Up}")
        case "Back": OpenBaseRadial()
        default: MsgBox(ObsidianResult)
    }
}
;#endregion
;#region createRadialsFunctions
CreateAppRadial(*) {
    openRadial := Radial_Menu()
    openRadial.SetSections("8")
    ;openRadial.SetKey("mbutton")
    openRadial.SetKeySpecial("Ctrl")
    openRadial.Add("Open Obsidian", "C:\Users\Jamie\Desktop\AutoHotkey\Code\v2\Images\obsidianIcon.png", 1)
    ;openRadial.Add2("Open AltApp #2", "", 2)
    openRadial.Add("Open Discord", "C:\Users\Jamie\Desktop\AutoHotkey\Code\v2\Images\discordIcon.png", 2)
    openRadial.Add("Open Google Chrome", "C:\Users\Jamie\Desktop\AutoHotkey\Code\v2\Images\googleChromeIcon.png", 3)
    openRadial.Add("Open Visual Studio Code", "C:\Users\Jamie\Desktop\AutoHotkey\Code\v2\Images\vsCodeIcon.png", 4)
    openRadial.Add("", "", 5)
    openRadial.Add("", "", 6)
    openRadial.Add("Back", "C:\Users\Jamie\Desktop\AutoHotkey\Code\v2\Images\backIcon.png", 7)
    openRadial.Add("Open Eagle", "H:\Program Files (x86)\Eagle\resources\assets\icon.ico", 8)
    ;MouseMove(PosX, PosY, 0)
    Return openResult := openRadial.Show()
}

CreateBaseRadial(*) {
    GMenu := Radial_Menu()
    GMenu.SetSections("3")
    ;GMenu.SetKey("mbutton")
    GMenu.SetKeySpecial("Ctrl")
    ;GMenu.Add("", "", 1)
    ;GMenu.Add("", "", 2)
    ;GMenu.Add2("", "", 2)
    GMenu.Add("Open App", "Images\NewTabIcon.png", 2)
    GMenu.Add("Context Menu", "Images/pallette.png", 1)
    ;GMenu.Add("", "", 5)
    ;GMenu.Add2("", "Images/fbcp_asm_image.gif", 5)
    ;GMenu.Add("", "", 6)
    GMenu.Add("Windows", "Images\close.png", 3)
    GMenu.Add("Close", "Images\close.png", 4)
    ;GMenu.Add("", "", 8)
    ;MouseMove(PosX, PosY, 0)
    Return Result := GMenu.Show()
}
;#endregion
;#region contextBasedRadials
CreateGoogleChromeRadial(*) {
    GMenu := Radial_Menu()
    GMenu.SetSections("6")
    GMenu.SetKeySpecial("Ctrl")
    GMenu.Add("Open New Tab", "Images\NewTabIcon.png", 1)
    GMenu.Add2("Close Tab", "Images\CloseTab.png", 1)
    GMenu.Add("Reopen last", "Images\reopenTabIcon.png", 2)
    GMenu.Add("Address Bar", "Images\searchIcon.png", 3)
    GMenu.Add("Refresh", "Images/RefreshIcon.png", 4)
    ;GMenu.Add2("Save5se", "Images/fbcp_asm_image.gif", 4)
    ;GMenu.Add("Save6", "Images/smt_flat_wall_mt.gif", 5)
    ;GMenu.Add("Save8", "Images/smt_flat_wall_mt.gif", 6)
    GMenu.Add("Back", "Images\backIcon.png", 5)
    GMenu.Add("Search All Open Tabs", "Images\searchIcon.png", 6)
    ;MouseMove(PosX, PosY, 0)
    Return Result := GMenu.Show()
}
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
    ;MouseMove(PosX, PosY, 0)
    Return Result := GMenu.Show()
}
CreateVsCodeRadial(*) {
    GMenu := Radial_Menu()
    GMenu.SetSections("7")
    GMenu.SetKeySpecial("Ctrl")
    GMenu.Add("Command Pallette", "Images\pallette.png", 1)
    GMenu.Add2("Quick Open", "Images/bookIcon.png", 1)
    GMenu.Add("Toggle Sidebar", "Images\toggle.png", 2)
    GMenu.Add2("Toggle Zen Mode", "Images\zenModeIcon.png", 2)
    GMenu.Add("Comment", "", 3)
    GMenu.Add("Show References", "Images\deafenIcon.png", 4)
    GMenu.Add("Find", "Images\searchIcon.png", 5)
    GMenu.Add("Back", "Images\backIcon.png", 6)
    GMenu.Add2("Replace", "Images\RefreshIcon.png", 6)
    GMenu.Add("Copy Line Down", "Images\downIcon.png", 7)
    GMenu.Add2("Copy Line Up", "Images\upIcon.png", 7)
    ;MouseMove(PosX, PosY, 0)
    Return Result := GMenu.Show()
}
CreateObsidianRadial(*) {
    GMenu := Radial_Menu()
    GMenu.SetSections("6")
    GMenu.SetKeySpecial("Ctrl")
    GMenu.Add("Open Daily Note", "Images\NewTabIcon.png", 1)
    GMenu.Add2("Open Tomorrows Daily Note", "Images/bookIcon.png", 1)
    GMenu.Add("Pallette", "Images\pallette.png", 2)
    GMenu.Add("Show Todays Day Planner", "Images\commentIcon.png", 3)
    GMenu.Add2("Show Timeline", "Images\commentIcon.png", 3)
    GMenu.Add("Show References", "Images\deafenIcon.png", 4)
    GMenu.Add("Find", "Images\searchIcon.png", 5)
    GMenu.Add("Back", "Images\backIcon.png", 6)
    ;MouseMove(PosX, PosY, 0)
    Return Result := GMenu.Show()
}
;#endregion
;#region Open App Functions
OpenGoogleChrome(*) {
    if (WinExist("ahk_exe chrome.exe")) {
        WinActivate("ahk_exe chrome.exe")
    } else {
        Run("C:\Program Files (x86)\Google\Chrome\Application\chrome.exe")
    }
}
OpenDiscord(*) {
    if (WinExist("ahk_exe Discord.exe")) {
        WinActivate("ahk_exe Discord.exe")
    } else {
        Run("C:\Users\Jamie\AppData\Local\Discord\Update.exe --processStart Discord.exe")
    }
}
OpenObsidian(*) {
    if (ProcessExist("Obsidian.exe")) {
        WinActivate("ahk_exe Obsidian.exe")
    }
    else {
        Run("C:\Users\Jamie\AppData\Local\Obsidian\Obsidian.exe")    ;open from file path
    }
}
OpenEagle(*) {
    if (ProcessExist("Eagle.exe")) {
        WinActivate("ahk_exe Eagle.exe")
    }
    else {
        Run("H:\Program Files (x86)\Eagle\Eagle.exe")    ;open from file path
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
        static
        SectName := ""
        CoordMode "Mouse", "Screen"
        MouseGetPos(&PosX, &PosY)
        WinGetPos(&X_Win, &Y_Win, , , "A")
        R_1 := 80
        R_2 := R_1 * 0.2
        Offset := 2
        R_3 := R_1 + Offset * 2 + 10

        X_Gui := PosX - R_3
        Y_Gui := PosY - R_3
        X_Gui := PosX - R_3 + X_Win
        Y_Gui := PosY - R_3 + Y_Win
        Height_Gui := R_3 * 2
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
        Gui_Radial_Menu.Show("NA x" . X_Gui . " y" . Y_Gui . " w" . Width_Gui . " h" . Height_Gui)
        ; Get a handle to this window we have created in order to update it later
        hwnd1 := WinExist()
        ColorBackGround := "FCFCFC"
        ColorLineBackGround := "C6DFFC"
        ColorSelected := "C6DFFC"
        ColorLineSelected := "F5E5D6"

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

            This.Sect.%A_Index%.X_Bitmap := R_3 + (R_1 - 30) * cos(SectionAngle) - 8
            This.Sect.%A_Index%.Y_Bitmap := R_3 + (R_1 - 30) * sin(SectionAngle) - 8

            This.Sect.%A_Index%.PointsA := Gdip_GetPointsSection(R_3, R_3, R_1 + Offset * 2 + 10, R_1 + Offset * 2, This.Sections, Offset, A_Index)
            This.Sect.%A_Index%.Points := Gdip_GetPointsSection(R_3, R_3, R_1, R_2, This.Sections, Offset, A_Index)
        }

        ; Setting brushes and Pens
        pBrush := Gdip_BrushCreateSolid("0xFF" ColorBackGround)
        pBrushA := Gdip_BrushCreateSolid("0xFF" ColorSelected)
        pBrushC := Gdip_BrushCreateSolid("0X01" ColorBackGround)
        pPen := Gdip_CreatePen("0xFF" ColorLineBackGround, 1)
        pPenA := Gdip_CreatePen("0xD2" ColorLineSelected, 1)
        hdc := CreateCompatibleDC()

        G := Gdip_GraphicsFromHDC(hdc)
        Gdip_SetSmoothingMode(G, 4)

        RM_KeyState_D := 0
        Section_Mouse_Prev := -1
        X_Mouse_P := -1
        Y_Mouse_P := -1
        Gdip_FillEllipse(G, pBrushC, R_3 - R_1, R_3 - R_1, 2 * R_1, 2 * R_1)
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
                Section_Mouse := RM_GetSection(This.Sections, R_2, PosX, PosY)
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

                Section_Mouse := RM_GetSection(This.Sections, R_2, PosX, PosY)
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

            Section_Mouse := RM_GetSection(This.Sections, R_2, PosX, PosY)

            if (Center_Distance > R_1) {
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
                Gdip_FillEllipse(G, pBrushC, R_3 - R_1, R_3 - R_1, 2 * R_1, 2 * R_1)

                loop This.Sections {
                    Section := This.Sect.%A_Index%
                    SectionAngle := 2 * 3.141592653589793 / This.Sections * (A_Index - 1)
                    if (Section.Name = "") {
                        continue
                    }
                    If (A_Index = Section_Mouse) {
                        Gdip_FillPolygon(G, pBrushA, Section.Points)
                        Gdip_DrawLines(G, pPenA, Section.Points)
                        Gdip_FillPolygon(G, pBrushA, Section.PointsA)
                        Gdip_DrawLines(G, pPenA, Section.PointsA)
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
                UpdateLayeredWindow(hwnd1, hdc, X_Gui, Y_Gui, Width, Height)

                SelectObject(hdc, obm)    ; Select the object back into the hdc
                DeleteObject(hbm)    ; Now the bitmap may be deleted
                DeleteDC(hdc)    ; Also the device context related to the bitmap may be deleted
                Gdip_DeleteGraphics(G)    ; The graphics may now be deleted
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

Gdip_GetPointsSection(PosX, PosY, R_1, R_2, Sections, Offset, Section := "1") {
    Section := Section - 1
    SectionAngle := 2 * 3.141592653589793 / Sections
    R_2_Min := 4 * Offset / Sin(SectionAngle)
    R_2 := R_2 > R_2_Min ? R_2 : R_2_Min
    SweepAngle := ACos((R_1 * cos(SectionAngle / 2) + Offset * sin(SectionAngle / 2)) / R_1) * 2
    SweepAngle_2 := ACos((R_2 * cos(SectionAngle / 2) + Offset * sin(SectionAngle / 2)) / R_2) * 2

    Loop_Sections := round(R_1 * SweepAngle)
    StartAngle := -SweepAngle / 2 + SectionAngle * (Section)
    loop Loop_Sections {
        Angle := StartAngle + (A_Index - 1) * SweepAngle / (Loop_Sections - 1)
        X_Arc := round(PosX + R_1 * cos(Angle))
        Y_Arc := round(PosY + R_1 * sin(Angle))
        if (A_Index = 1) {
            Points := X_Arc "," Y_Arc
            X_Arc_Start := X_Arc
            Y_Arc_Start := Y_Arc
            continue
        }
        Points .= "|" X_Arc "," Y_Arc
    }

    Loop_Sections := round(R_2 * SweepAngle_2)
    StartAngle_2 := SweepAngle_2 / 2 + SectionAngle * (Section)
    loop Loop_Sections {
        Angle := StartAngle_2 - (A_Index - 1) * SweepAngle_2 / (Loop_Sections - 1)
        X_Arc := round(PosX + R_2 * cos(Angle))
        Y_Arc := round(PosY + R_2 * sin(Angle))
        Points .= "|" X_Arc "," Y_Arc
    }

    Points .= "|" X_Arc_Start "," Y_Arc_Start

    return Points
}

;#######################################################################

RM_GetSection(Sections, R_2, PosX, PosY) {

    CoordMode("Mouse", "Screen")
    WinGetPos(&X_Win, &Y_Win, , , "RM_Menu")
    MouseGetPos(&X_Mouse, &Y_Mouse)

    X_Rel := X_Mouse - PosX
    Y_Rel := Y_Mouse - PosY

    Distance_Center := Sqrt(X_Rel * X_Rel + Y_Rel * Y_Rel)
    Section_Mouse := ""
    X_Rel := X_Rel = 0 ? 0.01 : X_Rel    ; (correction to prevent X to be 0)
    Y_Rel := Y_Rel = 0 ? 0.01 : Y_Rel    ; (correction to prevent X to be 0)

    if (Distance_Center < R_2) {
        Section_Mouse := 0
    } else if (Distance_Center > R_2) {
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
