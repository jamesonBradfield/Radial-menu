# Radial-menu
This is just a simple radial menu I've made for navigating my most opened windows and such
It is pretty messy but it works for my use cases
### If you download this you will need autohotkey V2 to run the script
https://www.autohotkey.com/

### Heres the forum for where i got the radial menu
https://www.autohotkey.com/boards/viewtopic.php?f=83&t=99651


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
