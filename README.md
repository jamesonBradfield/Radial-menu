# Radial-menu
This is just a simple radial menu I've made for navigating my most opened windows and such
It is pretty messy but it works for my use cases
### If you download this you will need autohotkey V2 to run the script
https://www.autohotkey.com/

### Heres the forum for where i got the radial menu
https://www.autohotkey.com/boards/viewtopic.php?f=83&t=99651add this to the daily planner please
> [!ToDo]- Windows hotkeys to add to radial menu (2nd Work TIME)
> - [ ]   **Windows key** + **E** - Open File Explorer.
> - [ ]   **Windows key** + **D** open Windows Explorer tab
> - [ ]   **Windows key** + **Shift** + **S** - Take a screenshot using the Snip & Sketch. After pressing the keys, you can choose your preferred capture mode, including free form, rectangle, window, and full-screen (this includes all connected monitors).
> - [ ] **PrtScn** - Take a full-screen screenshot and copy it to the clipboard, so you can paste it somewhere else without saving it as a file. You can also go to the Settings app > Accessibility > Keyboard to set the PrtScn key to open the Snipping Tool (making it the same as **Windows key** + **Shift** + **S**)
> - [ ] **Windows key** + _**Tab**_ - Open Task View. This displays all your open apps as tiles so you can choose one to focus on. It also displays your virtual desktops and your timeline, including previously open apps and documents.

> [!ToDo]- schoolToDo(do this first)
> 
> - [ ] [Quiz 7: Video, Audio, and Image Techniques](https://protect-us.mimecast.com/s/-aHkClYkq5cOo6qw4uVTMER?domain=forms.office.com)
> - [ ] [Quiz 9: GUI HTML Editors and Mobile Websites](https://protect-us.mimecast.com/s/y6rRCmZ0rQU15kLo4u3Fkln?domain=forms.office.com)

> [!ToDo]- Break Time
> - [ ] Read agatha christie book(1 chapter) or(30 minutes)



# Radial-menu
This is just a simple radial menu I've made for navigating my most opened windows and such
It is pretty messy but it works for my use cases
### If you download this you will need autohotkey V2 to run the script
https://www.autohotkey.com/

### Heres the forum for where i got the radial menu
https://www.autohotkey.com/boards/viewtopic.php?f=83&t=99651
inside the code you will see some paths for chrome discord and such
just open your start menu and find the path to each executable you want to open

Documentation here (https://www.autohotkey.com/docs/v2/howto/RunPrograms.htm)
### using window spy
I would use Window Spy to check if the ahk_exe is the same as displayed 
it will give you the info autohotkey will see when you have each window "focused"
for example
![[Pasted image 20230210132648.png]]
here's an example window spy window you can see the ahk_exe matches the one in code

```ahk
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

        Run("C:\Users\Jamie\AppData\Local\Obsidian\Obsidian.exe")    ;open from file path

    }

}

OpenEagle(*) {

    if (ProcessExist("Eagle.exe")) {

        WinActivate("ahk_exe Eagle.exe")

    }

    else {

        Run("H:\Program Files (x86)\Eagle\Eagle.exe")    ;open from file path

    }

}

OpenVScode(*) {

    if (WinExist("ahk_exe Code.exe")) {

        WinActivate("ahk_exe Code.exe")

    }

    else {

        Run("C:\Users\Jamie\AppData\Local\Programs\Microsoft VS Code\Code.exe")    ;open from file path

    }

}
```
