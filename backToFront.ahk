#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases
#SingleInstance force  ; Ensures only one instance of the script is running
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability

; Display a startup notification
TrayTip, Hebrew-English Keyboard Translator, Press Ctrl+Shift+L to translate between Hebrew and English keyboard layouts., 3, 1

; Define the Hebrew-English character mappings
global HebrewToEnglish := {}
global EnglishToHebrew := {}

; Initialize the mapping tables
InitializeMappings()

; Define the hotkey: Ctrl+Shift+L
^+l::
    ; Get the currently selected text by copying it to clipboard
    ClipSaved := ClipboardAll  ; Save current clipboard content
    Clipboard := ""  ; Clear clipboard
    Send, ^c  ; Copy selected text
    ClipWait, 1  ; Wait for clipboard to contain data (timeout after 1 second)
    
    if ErrorLevel  ; If no text was selected or copy failed
    {
        TrayTip, Keyboard Translator, No text selected or failed to copy., 3, 2
        Clipboard := ClipSaved  ; Restore clipboard
        return
    }
    
    ; Get the text and translate it
    SelectedText := Clipboard
    
    ; Determine if the text is primarily Hebrew or English
    isHebrew := ContainsHebrew(SelectedText)
    
    if (isHebrew)
        TranslatedText := TranslateFromHebrew(SelectedText)
    else
        TranslatedText := TranslateToHebrew(SelectedText)
    
    ; Replace the selected text with translated text
    Clipboard := TranslatedText
    Send, ^v  ; Paste the translated text
    
    ; Wait a moment before restoring original clipboard
    Sleep, 100
    Clipboard := ClipSaved  ; Restore original clipboard
    ClipSaved := ""  ; Free the memory
return

; Function to check if text contains Hebrew characters
ContainsHebrew(text) {
    ; Check if the text contains Hebrew characters (Unicode range)
    Loop, Parse, text
    {
        charCode := Asc(A_LoopField)
        if (charCode >= 1488 && charCode <= 1514)  ; Hebrew Unicode range
            return true
    }
    return false
}

; Function to translate from Hebrew keyboard layout to English
TranslateFromHebrew(text) {
    result := ""
    Loop, Parse, text
    {
        char := A_LoopField
        if HebrewToEnglish.HasKey(char)
            result .= HebrewToEnglish[char]
        else
            result .= char
    }
    return result
}

; Function to translate from English keyboard layout to Hebrew
TranslateToHebrew(text) {
    result := ""
    Loop, Parse, text
    {
        char := A_LoopField
        if EnglishToHebrew.HasKey(char)
            result .= EnglishToHebrew[char]
        else
            result .= char
    }
    return result
}

; Initialize the Hebrew-English character mapping tables
InitializeMappings() {
    ; English to Hebrew mappings (qwerty to Hebrew keyboard layout)
    EnglishToHebrew["q"] := "/"
    EnglishToHebrew["w"] := "'"
    EnglishToHebrew["e"] := "ק"
    EnglishToHebrew["r"] := "ר"
    EnglishToHebrew["t"] := "א"
    EnglishToHebrew["y"] := "ט"
    EnglishToHebrew["u"] := "ו"
    EnglishToHebrew["i"] := "ן"
    EnglishToHebrew["o"] := "ם"
    EnglishToHebrew["p"] := "פ"
    EnglishToHebrew["a"] := "ש"
    EnglishToHebrew["s"] := "ד"
    EnglishToHebrew["d"] := "ג"
    EnglishToHebrew["f"] := "כ"
    EnglishToHebrew["g"] := "ע"
    EnglishToHebrew["h"] := "י"
    EnglishToHebrew["j"] := "ח"
    EnglishToHebrew["k"] := "ל"
    EnglishToHebrew["l"] := "ך"
    EnglishToHebrew[";"] := "ף"
    EnglishToHebrew["z"] := "ז"
    EnglishToHebrew["x"] := "ס"
    EnglishToHebrew["c"] := "ב"
    EnglishToHebrew["v"] := "ה"
    EnglishToHebrew["b"] := "נ"
    EnglishToHebrew["n"] := "מ"
    EnglishToHebrew["m"] := "צ"
    EnglishToHebrew[","] := "ת"
    EnglishToHebrew["."] := "ץ"
    EnglishToHebrew["/"] := "."
    
    ; Uppercase English letters
    EnglishToHebrew["Q"] := "/"
    EnglishToHebrew["W"] := "'"
    EnglishToHebrew["E"] := "ק"
    EnglishToHebrew["R"] := "ר"
    EnglishToHebrew["T"] := "א"
    EnglishToHebrew["Y"] := "ט"
    EnglishToHebrew["U"] := "ו"
    EnglishToHebrew["I"] := "ן"
    EnglishToHebrew["O"] := "ם"
    EnglishToHebrew["P"] := "פ"
    EnglishToHebrew["A"] := "ש"
    EnglishToHebrew["S"] := "ד"
    EnglishToHebrew["D"] := "ג"
    EnglishToHebrew["F"] := "כ"
    EnglishToHebrew["G"] := "ע"
    EnglishToHebrew["H"] := "י"
    EnglishToHebrew["J"] := "ח"
    EnglishToHebrew["K"] := "ל"
    EnglishToHebrew["L"] := "ך"
    EnglishToHebrew["Z"] := "ז"
    EnglishToHebrew["X"] := "ס"
    EnglishToHebrew["C"] := "ב"
    EnglishToHebrew["V"] := "ה"
    EnglishToHebrew["B"] := "נ"
    EnglishToHebrew["N"] := "מ"
    EnglishToHebrew["M"] := "צ"
    
    ; Create the reverse mapping (Hebrew to English)
    for engChar, hebChar in EnglishToHebrew
        HebrewToEnglish[hebChar] := engChar
}

; Add a tray menu item for exiting the script
Menu, Tray, NoStandard
Menu, Tray, Add, Exit, ExitScript
Menu, Tray, Default, Exit
Menu, Tray, Tip, Hebrew-English Translator (Ctrl+Shift+L)

ExitScript:
    ExitApp
return