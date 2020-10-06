if (!A_IsCompiled && A_ScriptName = "FileInstall_Cmds.ahk") {
	#Include %A_ScriptDir%/lib/Logs.ahk
	#Include %A_ScriptDir%/lib/WindowsSettings.ahk
	#Include %A_ScriptDir%/lib/third-party/Get_ResourceSize.ahk

	if (!PROGRAM)
		PROGRAM := {}

	Loop, %0% {
		paramAE := %A_Index%
		if RegExMatch(paramAE, "O)/(.*)=(.*)", foundAE)
			PROGRAM[foundAE.1] := foundAE.2
	}

	FileInstall_Cmds()
}
; --------------------------------

FileInstall_Cmds() {
global PROGRAM


if !(PROGRAM.MAIN_FOLDER) {
	Msgbox You cannot run this file manually!
ExitApp
}

if !InStr(FileExist(PROGRAM.MAIN_FOLDER ""), "D")
	FileCreateDir,% PROGRAM.MAIN_FOLDER ""

if (A_IsCompiled) {
	sourceFileSize := Get_ResourceSize("lib\third-party\curl.exe")
	FileGetSize, destFileSize, % PROGRAM.MAIN_FOLDER "\curl.exe"
}
else {
	FileGetSize, sourceFileSize, lib\third-party\curl.exe
	FileGetSize, destFileSize, % PROGRAM.MAIN_FOLDER "\curl.exe"
}
if (sourceFileSize != destFileSize)
	FileInstall, lib\third-party\curl.exe, % PROGRAM.MAIN_FOLDER "\curl.exe", 1
if (ErrorLevel) {
	AppendToLogs("Failed to extract file!"
	.	"`nSource: lib\third-party\curl.exe"
	.	"`nDest: " PROGRAM.MAIN_FOLDER "\curl.exe"
	.	"`nFlag: " 2)
	errorLog .= "`n`n""Failed to extract file!"
	.	"`nSource: lib\third-party\curl.exe"
	.	"`nDest: " PROGRAM.MAIN_FOLDER "\curl.exe"
	.	"`nFlag: " 2
}

; ----------------------------
if !InStr(FileExist(PROGRAM.MAIN_FOLDER ""), "D")
	FileCreateDir,% PROGRAM.MAIN_FOLDER ""

if (A_IsCompiled) {
	sourceFileSize := Get_ResourceSize("Wiki.url")
	FileGetSize, destFileSize, % PROGRAM.MAIN_FOLDER "\Wiki.url"
}
else {
	FileGetSize, sourceFileSize, Wiki.url
	FileGetSize, destFileSize, % PROGRAM.MAIN_FOLDER "\Wiki.url"
}
if (sourceFileSize != destFileSize)
	FileInstall, Wiki.url, % PROGRAM.MAIN_FOLDER "\Wiki.url", 1
if (ErrorLevel) {
	AppendToLogs("Failed to extract file!"
	.	"`nSource: Wiki.url"
	.	"`nDest: " PROGRAM.MAIN_FOLDER "\Wiki.url"
	.	"`nFlag: " 2)
	errorLog .= "`n`n""Failed to extract file!"
	.	"`nSource: Wiki.url"
	.	"`nDest: " PROGRAM.MAIN_FOLDER "\Wiki.url"
	.	"`nFlag: " 2
}

; ----------------------------
if !InStr(FileExist(PROGRAM.MAIN_FOLDER ""), "D")
	FileCreateDir,% PROGRAM.MAIN_FOLDER ""

if (A_IsCompiled) {
	sourceFileSize := Get_ResourceSize("GitHub.url")
	FileGetSize, destFileSize, % PROGRAM.MAIN_FOLDER "\GitHub.url"
}
else {
	FileGetSize, sourceFileSize, GitHub.url
	FileGetSize, destFileSize, % PROGRAM.MAIN_FOLDER "\GitHub.url"
}
if (sourceFileSize != destFileSize)
	FileInstall, GitHub.url, % PROGRAM.MAIN_FOLDER "\GitHub.url", 1
if (ErrorLevel) {
	AppendToLogs("Failed to extract file!"
	.	"`nSource: GitHub.url"
	.	"`nDest: " PROGRAM.MAIN_FOLDER "\GitHub.url"
	.	"`nFlag: " 2)
	errorLog .= "`n`n""Failed to extract file!"
	.	"`nSource: GitHub.url"
	.	"`nDest: " PROGRAM.MAIN_FOLDER "\GitHub.url"
	.	"`nFlag: " 2
}

; ----------------------------
if !InStr(FileExist(PROGRAM.DATA_FOLDER ""), "D")
	FileCreateDir,% PROGRAM.DATA_FOLDER ""

if (A_IsCompiled) {
	sourceFileSize := Get_ResourceSize("data\CurrencyNames.txt")
	FileGetSize, destFileSize, % PROGRAM.DATA_FOLDER "\CurrencyNames.txt"
}
else {
	FileGetSize, sourceFileSize, data\CurrencyNames.txt
	FileGetSize, destFileSize, % PROGRAM.DATA_FOLDER "\CurrencyNames.txt"
}
if (sourceFileSize != destFileSize)
	FileInstall, data\CurrencyNames.txt, % PROGRAM.DATA_FOLDER "\CurrencyNames.txt", 1
if (ErrorLevel) {
	AppendToLogs("Failed to extract file!"
	.	"`nSource: data\CurrencyNames.txt"
	.	"`nDest: " PROGRAM.DATA_FOLDER "\CurrencyNames.txt"
	.	"`nFlag: " 2)
	errorLog .= "`n`n""Failed to extract file!"
	.	"`nSource: data\CurrencyNames.txt"
	.	"`nDest: " PROGRAM.DATA_FOLDER "\CurrencyNames.txt"
	.	"`nFlag: " 2
}

; ----------------------------
if !InStr(FileExist(PROGRAM.DATA_FOLDER ""), "D")
	FileCreateDir,% PROGRAM.DATA_FOLDER ""

if (A_IsCompiled) {
	sourceFileSize := Get_ResourceSize("data\mapsData.json")
	FileGetSize, destFileSize, % PROGRAM.DATA_FOLDER "\mapsData.json"
}
else {
	FileGetSize, sourceFileSize, data\mapsData.json
	FileGetSize, destFileSize, % PROGRAM.DATA_FOLDER "\mapsData.json"
}
if (sourceFileSize != destFileSize)
	FileInstall, data\mapsData.json, % PROGRAM.DATA_FOLDER "\mapsData.json", 1
if (ErrorLevel) {
	AppendToLogs("Failed to extract file!"
	.	"`nSource: data\mapsData.json"
	.	"`nDest: " PROGRAM.DATA_FOLDER "\mapsData.json"
	.	"`nFlag: " 2)
	errorLog .= "`n`n""Failed to extract file!"
	.	"`nSource: data\mapsData.json"
	.	"`nDest: " PROGRAM.DATA_FOLDER "\mapsData.json"
	.	"`nFlag: " 2
}

; ----------------------------
if !InStr(FileExist(PROGRAM.DATA_FOLDER ""), "D")
	FileCreateDir,% PROGRAM.DATA_FOLDER ""

if (A_IsCompiled) {
	sourceFileSize := Get_ResourceSize("data\poeDotComCurrencyData.json")
	FileGetSize, destFileSize, % PROGRAM.DATA_FOLDER "\poeDotComCurrencyData.json"
}
else {
	FileGetSize, sourceFileSize, data\poeDotComCurrencyData.json
	FileGetSize, destFileSize, % PROGRAM.DATA_FOLDER "\poeDotComCurrencyData.json"
}
if (sourceFileSize != destFileSize)
	FileInstall, data\poeDotComCurrencyData.json, % PROGRAM.DATA_FOLDER "\poeDotComCurrencyData.json", 1
if (ErrorLevel) {
	AppendToLogs("Failed to extract file!"
	.	"`nSource: data\poeDotComCurrencyData.json"
	.	"`nDest: " PROGRAM.DATA_FOLDER "\poeDotComCurrencyData.json"
	.	"`nFlag: " 2)
	errorLog .= "`n`n""Failed to extract file!"
	.	"`nSource: data\poeDotComCurrencyData.json"
	.	"`nDest: " PROGRAM.DATA_FOLDER "\poeDotComCurrencyData.json"
	.	"`nFlag: " 2
}

; ----------------------------
if !InStr(FileExist(PROGRAM.DATA_FOLDER ""), "D")
	FileCreateDir,% PROGRAM.DATA_FOLDER ""

if (A_IsCompiled) {
	sourceFileSize := Get_ResourceSize("data\poeTradeCurrencyData.json")
	FileGetSize, destFileSize, % PROGRAM.DATA_FOLDER "\poeTradeCurrencyData.json"
}
else {
	FileGetSize, sourceFileSize, data\poeTradeCurrencyData.json
	FileGetSize, destFileSize, % PROGRAM.DATA_FOLDER "\poeTradeCurrencyData.json"
}
if (sourceFileSize != destFileSize)
	FileInstall, data\poeTradeCurrencyData.json, % PROGRAM.DATA_FOLDER "\poeTradeCurrencyData.json", 1
if (ErrorLevel) {
	AppendToLogs("Failed to extract file!"
	.	"`nSource: data\poeTradeCurrencyData.json"
	.	"`nDest: " PROGRAM.DATA_FOLDER "\poeTradeCurrencyData.json"
	.	"`nFlag: " 2)
	errorLog .= "`n`n""Failed to extract file!"
	.	"`nSource: data\poeTradeCurrencyData.json"
	.	"`nDest: " PROGRAM.DATA_FOLDER "\poeTradeCurrencyData.json"
	.	"`nFlag: " 2
}

; ----------------------------
if !InStr(FileExist(PROGRAM.DATA_FOLDER ""), "D")
	FileCreateDir,% PROGRAM.DATA_FOLDER ""

if (A_IsCompiled) {
	sourceFileSize := Get_ResourceSize("data\UniqueMaps.txt")
	FileGetSize, destFileSize, % PROGRAM.DATA_FOLDER "\UniqueMaps.txt"
}
else {
	FileGetSize, sourceFileSize, data\UniqueMaps.txt
	FileGetSize, destFileSize, % PROGRAM.DATA_FOLDER "\UniqueMaps.txt"
}
if (sourceFileSize != destFileSize)
	FileInstall, data\UniqueMaps.txt, % PROGRAM.DATA_FOLDER "\UniqueMaps.txt", 1
if (ErrorLevel) {
	AppendToLogs("Failed to extract file!"
	.	"`nSource: data\UniqueMaps.txt"
	.	"`nDest: " PROGRAM.DATA_FOLDER "\UniqueMaps.txt"
	.	"`nFlag: " 2)
	errorLog .= "`n`n""Failed to extract file!"
	.	"`nSource: data\UniqueMaps.txt"
	.	"`nDest: " PROGRAM.DATA_FOLDER "\UniqueMaps.txt"
	.	"`nFlag: " 2
}

; ----------------------------
if !InStr(FileExist(PROGRAM.MAIN_FOLDER ""), "D")
	FileCreateDir,% PROGRAM.MAIN_FOLDER ""

if (A_IsCompiled) {
	sourceFileSize := Get_ResourceSize("resources\changelog.txt")
	FileGetSize, destFileSize, % PROGRAM.MAIN_FOLDER "\changelog.txt"
}
else {
	FileGetSize, sourceFileSize, resources\changelog.txt
	FileGetSize, destFileSize, % PROGRAM.MAIN_FOLDER "\changelog.txt"
}
if (sourceFileSize != destFileSize)
	FileInstall, resources\changelog.txt, % PROGRAM.MAIN_FOLDER "\changelog.txt", 1
if (ErrorLevel) {
	AppendToLogs("Failed to extract file!"
	.	"`nSource: resources\changelog.txt"
	.	"`nDest: " PROGRAM.MAIN_FOLDER "\changelog.txt"
	.	"`nFlag: " 2)
	errorLog .= "`n`n""Failed to extract file!"
	.	"`nSource: resources\changelog.txt"
	.	"`nDest: " PROGRAM.MAIN_FOLDER "\changelog.txt"
	.	"`nFlag: " 2
}

; ----------------------------
if !InStr(FileExist(PROGRAM.MAIN_FOLDER ""), "D")
	FileCreateDir,% PROGRAM.MAIN_FOLDER ""

if (A_IsCompiled) {
	sourceFileSize := Get_ResourceSize("resources\changelog_beta.txt")
	FileGetSize, destFileSize, % PROGRAM.MAIN_FOLDER "\changelog_beta.txt"
}
else {
	FileGetSize, sourceFileSize, resources\changelog_beta.txt
	FileGetSize, destFileSize, % PROGRAM.MAIN_FOLDER "\changelog_beta.txt"
}
if (sourceFileSize != destFileSize)
	FileInstall, resources\changelog_beta.txt, % PROGRAM.MAIN_FOLDER "\changelog_beta.txt", 1
if (ErrorLevel) {
	AppendToLogs("Failed to extract file!"
	.	"`nSource: resources\changelog_beta.txt"
	.	"`nDest: " PROGRAM.MAIN_FOLDER "\changelog_beta.txt"
	.	"`nFlag: " 2)
	errorLog .= "`n`n""Failed to extract file!"
	.	"`nSource: resources\changelog_beta.txt"
	.	"`nDest: " PROGRAM.MAIN_FOLDER "\changelog_beta.txt"
	.	"`nFlag: " 2
}

; ----------------------------
if !InStr(FileExist(PROGRAM.MAIN_FOLDER ""), "D")
	FileCreateDir,% PROGRAM.MAIN_FOLDER ""

if (A_IsCompiled) {
	sourceFileSize := Get_ResourceSize("resources\icon.ico")
	FileGetSize, destFileSize, % PROGRAM.MAIN_FOLDER "\icon.ico"
}
else {
	FileGetSize, sourceFileSize, resources\icon.ico
	FileGetSize, destFileSize, % PROGRAM.MAIN_FOLDER "\icon.ico"
}
if (sourceFileSize != destFileSize)
	FileInstall, resources\icon.ico, % PROGRAM.MAIN_FOLDER "\icon.ico", 1
if (ErrorLevel) {
	AppendToLogs("Failed to extract file!"
	.	"`nSource: resources\icon.ico"
	.	"`nDest: " PROGRAM.MAIN_FOLDER "\icon.ico"
	.	"`nFlag: " 2)
	errorLog .= "`n`n""Failed to extract file!"
	.	"`nSource: resources\icon.ico"
	.	"`nDest: " PROGRAM.MAIN_FOLDER "\icon.ico"
	.	"`nFlag: " 2
}

; ----------------------------
if !InStr(FileExist(PROGRAM.FONTS_FOLDER ""), "D")
	FileCreateDir,% PROGRAM.FONTS_FOLDER ""

if (A_IsCompiled) {
	sourceFileSize := Get_ResourceSize("resources\fonts\Consolas.ttf")
	FileGetSize, destFileSize, % PROGRAM.FONTS_FOLDER "\Consolas.ttf"
}
else {
	FileGetSize, sourceFileSize, resources\fonts\Consolas.ttf
	FileGetSize, destFileSize, % PROGRAM.FONTS_FOLDER "\Consolas.ttf"
}
if (sourceFileSize != destFileSize)
	FileInstall, resources\fonts\Consolas.ttf, % PROGRAM.FONTS_FOLDER "\Consolas.ttf", 1
if (ErrorLevel) {
	AppendToLogs("Failed to extract file!"
	.	"`nSource: resources\fonts\Consolas.ttf"
	.	"`nDest: " PROGRAM.FONTS_FOLDER "\Consolas.ttf"
	.	"`nFlag: " 2)
	errorLog .= "`n`n""Failed to extract file!"
	.	"`nSource: resources\fonts\Consolas.ttf"
	.	"`nDest: " PROGRAM.FONTS_FOLDER "\Consolas.ttf"
	.	"`nFlag: " 2
}

; ----------------------------
if !InStr(FileExist(PROGRAM.FONTS_FOLDER ""), "D")
	FileCreateDir,% PROGRAM.FONTS_FOLDER ""

if (A_IsCompiled) {
	sourceFileSize := Get_ResourceSize("resources\fonts\Fontin-Regular.ttf")
	FileGetSize, destFileSize, % PROGRAM.FONTS_FOLDER "\Fontin-Regular.ttf"
}
else {
	FileGetSize, sourceFileSize, resources\fonts\Fontin-Regular.ttf
	FileGetSize, destFileSize, % PROGRAM.FONTS_FOLDER "\Fontin-Regular.ttf"
}
if (sourceFileSize != destFileSize)
	FileInstall, resources\fonts\Fontin-Regular.ttf, % PROGRAM.FONTS_FOLDER "\Fontin-Regular.ttf", 1
if (ErrorLevel) {
	AppendToLogs("Failed to extract file!"
	.	"`nSource: resources\fonts\Fontin-Regular.ttf"
	.	"`nDest: " PROGRAM.FONTS_FOLDER "\Fontin-Regular.ttf"
	.	"`nFlag: " 2)
	errorLog .= "`n`n""Failed to extract file!"
	.	"`nSource: resources\fonts\Fontin-Regular.ttf"
	.	"`nDest: " PROGRAM.FONTS_FOLDER "\Fontin-Regular.ttf"
	.	"`nFlag: " 2
}

; ----------------------------
if !InStr(FileExist(PROGRAM.FONTS_FOLDER ""), "D")
	FileCreateDir,% PROGRAM.FONTS_FOLDER ""

if (A_IsCompiled) {
	sourceFileSize := Get_ResourceSize("resources\fonts\Fontin-SmallCaps.ttf")
	FileGetSize, destFileSize, % PROGRAM.FONTS_FOLDER "\Fontin-SmallCaps.ttf"
}
else {
	FileGetSize, sourceFileSize, resources\fonts\Fontin-SmallCaps.ttf
	FileGetSize, destFileSize, % PROGRAM.FONTS_FOLDER "\Fontin-SmallCaps.ttf"
}
if (sourceFileSize != destFileSize)
	FileInstall, resources\fonts\Fontin-SmallCaps.ttf, % PROGRAM.FONTS_FOLDER "\Fontin-SmallCaps.ttf", 1
if (ErrorLevel) {
	AppendToLogs("Failed to extract file!"
	.	"`nSource: resources\fonts\Fontin-SmallCaps.ttf"
	.	"`nDest: " PROGRAM.FONTS_FOLDER "\Fontin-SmallCaps.ttf"
	.	"`nFlag: " 2)
	errorLog .= "`n`n""Failed to extract file!"
	.	"`nSource: resources\fonts\Fontin-SmallCaps.ttf"
	.	"`nDest: " PROGRAM.FONTS_FOLDER "\Fontin-SmallCaps.ttf"
	.	"`nFlag: " 2
}

; ----------------------------
if !InStr(FileExist(PROGRAM.FONTS_FOLDER ""), "D")
	FileCreateDir,% PROGRAM.FONTS_FOLDER ""

if (A_IsCompiled) {
	sourceFileSize := Get_ResourceSize("resources\fonts\Segoe UI.ttf")
	FileGetSize, destFileSize, % PROGRAM.FONTS_FOLDER "\Segoe UI.ttf"
}
else {
	FileGetSize, sourceFileSize, resources\fonts\Segoe UI.ttf
	FileGetSize, destFileSize, % PROGRAM.FONTS_FOLDER "\Segoe UI.ttf"
}
if (sourceFileSize != destFileSize)
	FileInstall, resources\fonts\Segoe UI.ttf, % PROGRAM.FONTS_FOLDER "\Segoe UI.ttf", 1
if (ErrorLevel) {
	AppendToLogs("Failed to extract file!"
	.	"`nSource: resources\fonts\Segoe UI.ttf"
	.	"`nDest: " PROGRAM.FONTS_FOLDER "\Segoe UI.ttf"
	.	"`nFlag: " 2)
	errorLog .= "`n`n""Failed to extract file!"
	.	"`nSource: resources\fonts\Segoe UI.ttf"
	.	"`nDest: " PROGRAM.FONTS_FOLDER "\Segoe UI.ttf"
	.	"`nFlag: " 2
}

; ----------------------------
if !InStr(FileExist(PROGRAM.FONTS_FOLDER ""), "D")
	FileCreateDir,% PROGRAM.FONTS_FOLDER ""

if (A_IsCompiled) {
	sourceFileSize := Get_ResourceSize("resources\fonts\Settings.ini")
	FileGetSize, destFileSize, % PROGRAM.FONTS_FOLDER "\Settings.ini"
}
else {
	FileGetSize, sourceFileSize, resources\fonts\Settings.ini
	FileGetSize, destFileSize, % PROGRAM.FONTS_FOLDER "\Settings.ini"
}
if (sourceFileSize != destFileSize)
	FileInstall, resources\fonts\Settings.ini, % PROGRAM.FONTS_FOLDER "\Settings.ini", 1
if (ErrorLevel) {
	AppendToLogs("Failed to extract file!"
	.	"`nSource: resources\fonts\Settings.ini"
	.	"`nDest: " PROGRAM.FONTS_FOLDER "\Settings.ini"
	.	"`nFlag: " 2)
	errorLog .= "`n`n""Failed to extract file!"
	.	"`nSource: resources\fonts\Settings.ini"
	.	"`nDest: " PROGRAM.FONTS_FOLDER "\Settings.ini"
	.	"`nFlag: " 2
}

; ----------------------------
if !InStr(FileExist(PROGRAM.FONTS_FOLDER ""), "D")
	FileCreateDir,% PROGRAM.FONTS_FOLDER ""

if (A_IsCompiled) {
	sourceFileSize := Get_ResourceSize("resources\fonts\TC_Symbols.ttf")
	FileGetSize, destFileSize, % PROGRAM.FONTS_FOLDER "\TC_Symbols.ttf"
}
else {
	FileGetSize, sourceFileSize, resources\fonts\TC_Symbols.ttf
	FileGetSize, destFileSize, % PROGRAM.FONTS_FOLDER "\TC_Symbols.ttf"
}
if (sourceFileSize != destFileSize)
	FileInstall, resources\fonts\TC_Symbols.ttf, % PROGRAM.FONTS_FOLDER "\TC_Symbols.ttf", 1
if (ErrorLevel) {
	AppendToLogs("Failed to extract file!"
	.	"`nSource: resources\fonts\TC_Symbols.ttf"
	.	"`nDest: " PROGRAM.FONTS_FOLDER "\TC_Symbols.ttf"
	.	"`nFlag: " 2)
	errorLog .= "`n`n""Failed to extract file!"
	.	"`nSource: resources\fonts\TC_Symbols.ttf"
	.	"`nDest: " PROGRAM.FONTS_FOLDER "\TC_Symbols.ttf"
	.	"`nFlag: " 2
}

; ----------------------------
if !InStr(FileExist(PROGRAM.ICONS_FOLDER ""), "D")
	FileCreateDir,% PROGRAM.ICONS_FOLDER ""

if (A_IsCompiled) {
	sourceFileSize := Get_ResourceSize("resources\icons\chart.ico")
	FileGetSize, destFileSize, % PROGRAM.ICONS_FOLDER "\chart.ico"
}
else {
	FileGetSize, sourceFileSize, resources\icons\chart.ico
	FileGetSize, destFileSize, % PROGRAM.ICONS_FOLDER "\chart.ico"
}
if (sourceFileSize != destFileSize)
	FileInstall, resources\icons\chart.ico, % PROGRAM.ICONS_FOLDER "\chart.ico", 1
if (ErrorLevel) {
	AppendToLogs("Failed to extract file!"
	.	"`nSource: resources\icons\chart.ico"
	.	"`nDest: " PROGRAM.ICONS_FOLDER "\chart.ico"
	.	"`nFlag: " 2)
	errorLog .= "`n`n""Failed to extract file!"
	.	"`nSource: resources\icons\chart.ico"
	.	"`nDest: " PROGRAM.ICONS_FOLDER "\chart.ico"
	.	"`nFlag: " 2
}

; ----------------------------
if !InStr(FileExist(PROGRAM.ICONS_FOLDER ""), "D")
	FileCreateDir,% PROGRAM.ICONS_FOLDER ""

if (A_IsCompiled) {
	sourceFileSize := Get_ResourceSize("resources\icons\gear.ico")
	FileGetSize, destFileSize, % PROGRAM.ICONS_FOLDER "\gear.ico"
}
else {
	FileGetSize, sourceFileSize, resources\icons\gear.ico
	FileGetSize, destFileSize, % PROGRAM.ICONS_FOLDER "\gear.ico"
}
if (sourceFileSize != destFileSize)
	FileInstall, resources\icons\gear.ico, % PROGRAM.ICONS_FOLDER "\gear.ico", 1
if (ErrorLevel) {
	AppendToLogs("Failed to extract file!"
	.	"`nSource: resources\icons\gear.ico"
	.	"`nDest: " PROGRAM.ICONS_FOLDER "\gear.ico"
	.	"`nFlag: " 2)
	errorLog .= "`n`n""Failed to extract file!"
	.	"`nSource: resources\icons\gear.ico"
	.	"`nDest: " PROGRAM.ICONS_FOLDER "\gear.ico"
	.	"`nFlag: " 2
}

; ----------------------------
if !InStr(FileExist(PROGRAM.ICONS_FOLDER ""), "D")
	FileCreateDir,% PROGRAM.ICONS_FOLDER ""

if (A_IsCompiled) {
	sourceFileSize := Get_ResourceSize("resources\icons\POE.ico")
	FileGetSize, destFileSize, % PROGRAM.ICONS_FOLDER "\POE.ico"
}
else {
	FileGetSize, sourceFileSize, resources\icons\POE.ico
	FileGetSize, destFileSize, % PROGRAM.ICONS_FOLDER "\POE.ico"
}
if (sourceFileSize != destFileSize)
	FileInstall, resources\icons\POE.ico, % PROGRAM.ICONS_FOLDER "\POE.ico", 1
if (ErrorLevel) {
	AppendToLogs("Failed to extract file!"
	.	"`nSource: resources\icons\POE.ico"
	.	"`nDest: " PROGRAM.ICONS_FOLDER "\POE.ico"
	.	"`nFlag: " 2)
	errorLog .= "`n`n""Failed to extract file!"
	.	"`nSource: resources\icons\POE.ico"
	.	"`nDest: " PROGRAM.ICONS_FOLDER "\POE.ico"
	.	"`nFlag: " 2
}

; ----------------------------
if !InStr(FileExist(PROGRAM.ICONS_FOLDER ""), "D")
	FileCreateDir,% PROGRAM.ICONS_FOLDER ""

if (A_IsCompiled) {
	sourceFileSize := Get_ResourceSize("resources\icons\qmark.ico")
	FileGetSize, destFileSize, % PROGRAM.ICONS_FOLDER "\qmark.ico"
}
else {
	FileGetSize, sourceFileSize, resources\icons\qmark.ico
	FileGetSize, destFileSize, % PROGRAM.ICONS_FOLDER "\qmark.ico"
}
if (sourceFileSize != destFileSize)
	FileInstall, resources\icons\qmark.ico, % PROGRAM.ICONS_FOLDER "\qmark.ico", 1
if (ErrorLevel) {
	AppendToLogs("Failed to extract file!"
	.	"`nSource: resources\icons\qmark.ico"
	.	"`nDest: " PROGRAM.ICONS_FOLDER "\qmark.ico"
	.	"`nFlag: " 2)
	errorLog .= "`n`n""Failed to extract file!"
	.	"`nSource: resources\icons\qmark.ico"
	.	"`nDest: " PROGRAM.ICONS_FOLDER "\qmark.ico"
	.	"`nFlag: " 2
}

; ----------------------------
if !InStr(FileExist(PROGRAM.ICONS_FOLDER ""), "D")
	FileCreateDir,% PROGRAM.ICONS_FOLDER ""

if (A_IsCompiled) {
	sourceFileSize := Get_ResourceSize("resources\icons\refresh.ico")
	FileGetSize, destFileSize, % PROGRAM.ICONS_FOLDER "\refresh.ico"
}
else {
	FileGetSize, sourceFileSize, resources\icons\refresh.ico
	FileGetSize, destFileSize, % PROGRAM.ICONS_FOLDER "\refresh.ico"
}
if (sourceFileSize != destFileSize)
	FileInstall, resources\icons\refresh.ico, % PROGRAM.ICONS_FOLDER "\refresh.ico", 1
if (ErrorLevel) {
	AppendToLogs("Failed to extract file!"
	.	"`nSource: resources\icons\refresh.ico"
	.	"`nDest: " PROGRAM.ICONS_FOLDER "\refresh.ico"
	.	"`nFlag: " 2)
	errorLog .= "`n`n""Failed to extract file!"
	.	"`nSource: resources\icons\refresh.ico"
	.	"`nDest: " PROGRAM.ICONS_FOLDER "\refresh.ico"
	.	"`nFlag: " 2
}

; ----------------------------
if !InStr(FileExist(PROGRAM.ICONS_FOLDER ""), "D")
	FileCreateDir,% PROGRAM.ICONS_FOLDER ""

if (A_IsCompiled) {
	sourceFileSize := Get_ResourceSize("resources\icons\x.ico")
	FileGetSize, destFileSize, % PROGRAM.ICONS_FOLDER "\x.ico"
}
else {
	FileGetSize, sourceFileSize, resources\icons\x.ico
	FileGetSize, destFileSize, % PROGRAM.ICONS_FOLDER "\x.ico"
}
if (sourceFileSize != destFileSize)
	FileInstall, resources\icons\x.ico, % PROGRAM.ICONS_FOLDER "\x.ico", 1
if (ErrorLevel) {
	AppendToLogs("Failed to extract file!"
	.	"`nSource: resources\icons\x.ico"
	.	"`nDest: " PROGRAM.ICONS_FOLDER "\x.ico"
	.	"`nFlag: " 2)
	errorLog .= "`n`n""Failed to extract file!"
	.	"`nSource: resources\icons\x.ico"
	.	"`nDest: " PROGRAM.ICONS_FOLDER "\x.ico"
	.	"`nFlag: " 2
}

; ----------------------------
if !InStr(FileExist(PROGRAM.IMAGES_FOLDER ""), "D")
	FileCreateDir,% PROGRAM.IMAGES_FOLDER ""

if (A_IsCompiled) {
	sourceFileSize := Get_ResourceSize("resources\imgs\Discord.png")
	FileGetSize, destFileSize, % PROGRAM.IMAGES_FOLDER "\Discord.png"
}
else {
	FileGetSize, sourceFileSize, resources\imgs\Discord.png
	FileGetSize, destFileSize, % PROGRAM.IMAGES_FOLDER "\Discord.png"
}
if (sourceFileSize != destFileSize)
	FileInstall, resources\imgs\Discord.png, % PROGRAM.IMAGES_FOLDER "\Discord.png", 1
if (ErrorLevel) {
	AppendToLogs("Failed to extract file!"
	.	"`nSource: resources\imgs\Discord.png"
	.	"`nDest: " PROGRAM.IMAGES_FOLDER "\Discord.png"
	.	"`nFlag: " 2)
	errorLog .= "`n`n""Failed to extract file!"
	.	"`nSource: resources\imgs\Discord.png"
	.	"`nDest: " PROGRAM.IMAGES_FOLDER "\Discord.png"
	.	"`nFlag: " 2
}

; ----------------------------
if !InStr(FileExist(PROGRAM.IMAGES_FOLDER ""), "D")
	FileCreateDir,% PROGRAM.IMAGES_FOLDER ""

if (A_IsCompiled) {
	sourceFileSize := Get_ResourceSize("resources\imgs\Discord_big.png")
	FileGetSize, destFileSize, % PROGRAM.IMAGES_FOLDER "\Discord_big.png"
}
else {
	FileGetSize, sourceFileSize, resources\imgs\Discord_big.png
	FileGetSize, destFileSize, % PROGRAM.IMAGES_FOLDER "\Discord_big.png"
}
if (sourceFileSize != destFileSize)
	FileInstall, resources\imgs\Discord_big.png, % PROGRAM.IMAGES_FOLDER "\Discord_big.png", 1
if (ErrorLevel) {
	AppendToLogs("Failed to extract file!"
	.	"`nSource: resources\imgs\Discord_big.png"
	.	"`nDest: " PROGRAM.IMAGES_FOLDER "\Discord_big.png"
	.	"`nFlag: " 2)
	errorLog .= "`n`n""Failed to extract file!"
	.	"`nSource: resources\imgs\Discord_big.png"
	.	"`nDest: " PROGRAM.IMAGES_FOLDER "\Discord_big.png"
	.	"`nFlag: " 2
}

; ----------------------------
if !InStr(FileExist(PROGRAM.IMAGES_FOLDER ""), "D")
	FileCreateDir,% PROGRAM.IMAGES_FOLDER ""

if (A_IsCompiled) {
	sourceFileSize := Get_ResourceSize("resources\imgs\Discord_big_forums.png")
	FileGetSize, destFileSize, % PROGRAM.IMAGES_FOLDER "\Discord_big_forums.png"
}
else {
	FileGetSize, sourceFileSize, resources\imgs\Discord_big_forums.png
	FileGetSize, destFileSize, % PROGRAM.IMAGES_FOLDER "\Discord_big_forums.png"
}
if (sourceFileSize != destFileSize)
	FileInstall, resources\imgs\Discord_big_forums.png, % PROGRAM.IMAGES_FOLDER "\Discord_big_forums.png", 1
if (ErrorLevel) {
	AppendToLogs("Failed to extract file!"
	.	"`nSource: resources\imgs\Discord_big_forums.png"
	.	"`nDest: " PROGRAM.IMAGES_FOLDER "\Discord_big_forums.png"
	.	"`nFlag: " 2)
	errorLog .= "`n`n""Failed to extract file!"
	.	"`nSource: resources\imgs\Discord_big_forums.png"
	.	"`nDest: " PROGRAM.IMAGES_FOLDER "\Discord_big_forums.png"
	.	"`nFlag: " 2
}

; ----------------------------
if !InStr(FileExist(PROGRAM.IMAGES_FOLDER ""), "D")
	FileCreateDir,% PROGRAM.IMAGES_FOLDER ""

if (A_IsCompiled) {
	sourceFileSize := Get_ResourceSize("resources\imgs\DonatePaypal.png")
	FileGetSize, destFileSize, % PROGRAM.IMAGES_FOLDER "\DonatePaypal.png"
}
else {
	FileGetSize, sourceFileSize, resources\imgs\DonatePaypal.png
	FileGetSize, destFileSize, % PROGRAM.IMAGES_FOLDER "\DonatePaypal.png"
}
if (sourceFileSize != destFileSize)
	FileInstall, resources\imgs\DonatePaypal.png, % PROGRAM.IMAGES_FOLDER "\DonatePaypal.png", 1
if (ErrorLevel) {
	AppendToLogs("Failed to extract file!"
	.	"`nSource: resources\imgs\DonatePaypal.png"
	.	"`nDest: " PROGRAM.IMAGES_FOLDER "\DonatePaypal.png"
	.	"`nFlag: " 2)
	errorLog .= "`n`n""Failed to extract file!"
	.	"`nSource: resources\imgs\DonatePaypal.png"
	.	"`nDest: " PROGRAM.IMAGES_FOLDER "\DonatePaypal.png"
	.	"`nFlag: " 2
}

; ----------------------------
if !InStr(FileExist(PROGRAM.IMAGES_FOLDER ""), "D")
	FileCreateDir,% PROGRAM.IMAGES_FOLDER ""

if (A_IsCompiled) {
	sourceFileSize := Get_ResourceSize("resources\imgs\flag_china.png")
	FileGetSize, destFileSize, % PROGRAM.IMAGES_FOLDER "\flag_china.png"
}
else {
	FileGetSize, sourceFileSize, resources\imgs\flag_china.png
	FileGetSize, destFileSize, % PROGRAM.IMAGES_FOLDER "\flag_china.png"
}
if (sourceFileSize != destFileSize)
	FileInstall, resources\imgs\flag_china.png, % PROGRAM.IMAGES_FOLDER "\flag_china.png", 1
if (ErrorLevel) {
	AppendToLogs("Failed to extract file!"
	.	"`nSource: resources\imgs\flag_china.png"
	.	"`nDest: " PROGRAM.IMAGES_FOLDER "\flag_china.png"
	.	"`nFlag: " 2)
	errorLog .= "`n`n""Failed to extract file!"
	.	"`nSource: resources\imgs\flag_china.png"
	.	"`nDest: " PROGRAM.IMAGES_FOLDER "\flag_china.png"
	.	"`nFlag: " 2
}

; ----------------------------
if !InStr(FileExist(PROGRAM.IMAGES_FOLDER ""), "D")
	FileCreateDir,% PROGRAM.IMAGES_FOLDER ""

if (A_IsCompiled) {
	sourceFileSize := Get_ResourceSize("resources\imgs\flag_france.png")
	FileGetSize, destFileSize, % PROGRAM.IMAGES_FOLDER "\flag_france.png"
}
else {
	FileGetSize, sourceFileSize, resources\imgs\flag_france.png
	FileGetSize, destFileSize, % PROGRAM.IMAGES_FOLDER "\flag_france.png"
}
if (sourceFileSize != destFileSize)
	FileInstall, resources\imgs\flag_france.png, % PROGRAM.IMAGES_FOLDER "\flag_france.png", 1
if (ErrorLevel) {
	AppendToLogs("Failed to extract file!"
	.	"`nSource: resources\imgs\flag_france.png"
	.	"`nDest: " PROGRAM.IMAGES_FOLDER "\flag_france.png"
	.	"`nFlag: " 2)
	errorLog .= "`n`n""Failed to extract file!"
	.	"`nSource: resources\imgs\flag_france.png"
	.	"`nDest: " PROGRAM.IMAGES_FOLDER "\flag_france.png"
	.	"`nFlag: " 2
}

; ----------------------------
if !InStr(FileExist(PROGRAM.IMAGES_FOLDER ""), "D")
	FileCreateDir,% PROGRAM.IMAGES_FOLDER ""

if (A_IsCompiled) {
	sourceFileSize := Get_ResourceSize("resources\imgs\flag_russia.png")
	FileGetSize, destFileSize, % PROGRAM.IMAGES_FOLDER "\flag_russia.png"
}
else {
	FileGetSize, sourceFileSize, resources\imgs\flag_russia.png
	FileGetSize, destFileSize, % PROGRAM.IMAGES_FOLDER "\flag_russia.png"
}
if (sourceFileSize != destFileSize)
	FileInstall, resources\imgs\flag_russia.png, % PROGRAM.IMAGES_FOLDER "\flag_russia.png", 1
if (ErrorLevel) {
	AppendToLogs("Failed to extract file!"
	.	"`nSource: resources\imgs\flag_russia.png"
	.	"`nDest: " PROGRAM.IMAGES_FOLDER "\flag_russia.png"
	.	"`nFlag: " 2)
	errorLog .= "`n`n""Failed to extract file!"
	.	"`nSource: resources\imgs\flag_russia.png"
	.	"`nDest: " PROGRAM.IMAGES_FOLDER "\flag_russia.png"
	.	"`nFlag: " 2
}

; ----------------------------
if !InStr(FileExist(PROGRAM.IMAGES_FOLDER ""), "D")
	FileCreateDir,% PROGRAM.IMAGES_FOLDER ""

if (A_IsCompiled) {
	sourceFileSize := Get_ResourceSize("resources\imgs\flag_taiwan.png")
	FileGetSize, destFileSize, % PROGRAM.IMAGES_FOLDER "\flag_taiwan.png"
}
else {
	FileGetSize, sourceFileSize, resources\imgs\flag_taiwan.png
	FileGetSize, destFileSize, % PROGRAM.IMAGES_FOLDER "\flag_taiwan.png"
}
if (sourceFileSize != destFileSize)
	FileInstall, resources\imgs\flag_taiwan.png, % PROGRAM.IMAGES_FOLDER "\flag_taiwan.png", 1
if (ErrorLevel) {
	AppendToLogs("Failed to extract file!"
	.	"`nSource: resources\imgs\flag_taiwan.png"
	.	"`nDest: " PROGRAM.IMAGES_FOLDER "\flag_taiwan.png"
	.	"`nFlag: " 2)
	errorLog .= "`n`n""Failed to extract file!"
	.	"`nSource: resources\imgs\flag_taiwan.png"
	.	"`nDest: " PROGRAM.IMAGES_FOLDER "\flag_taiwan.png"
	.	"`nFlag: " 2
}

; ----------------------------
if !InStr(FileExist(PROGRAM.IMAGES_FOLDER ""), "D")
	FileCreateDir,% PROGRAM.IMAGES_FOLDER ""

if (A_IsCompiled) {
	sourceFileSize := Get_ResourceSize("resources\imgs\flag_uk.png")
	FileGetSize, destFileSize, % PROGRAM.IMAGES_FOLDER "\flag_uk.png"
}
else {
	FileGetSize, sourceFileSize, resources\imgs\flag_uk.png
	FileGetSize, destFileSize, % PROGRAM.IMAGES_FOLDER "\flag_uk.png"
}
if (sourceFileSize != destFileSize)
	FileInstall, resources\imgs\flag_uk.png, % PROGRAM.IMAGES_FOLDER "\flag_uk.png", 1
if (ErrorLevel) {
	AppendToLogs("Failed to extract file!"
	.	"`nSource: resources\imgs\flag_uk.png"
	.	"`nDest: " PROGRAM.IMAGES_FOLDER "\flag_uk.png"
	.	"`nFlag: " 2)
	errorLog .= "`n`n""Failed to extract file!"
	.	"`nSource: resources\imgs\flag_uk.png"
	.	"`nDest: " PROGRAM.IMAGES_FOLDER "\flag_uk.png"
	.	"`nFlag: " 2
}

; ----------------------------
if !InStr(FileExist(PROGRAM.IMAGES_FOLDER ""), "D")
	FileCreateDir,% PROGRAM.IMAGES_FOLDER ""

if (A_IsCompiled) {
	sourceFileSize := Get_ResourceSize("resources\imgs\GitHub.png")
	FileGetSize, destFileSize, % PROGRAM.IMAGES_FOLDER "\GitHub.png"
}
else {
	FileGetSize, sourceFileSize, resources\imgs\GitHub.png
	FileGetSize, destFileSize, % PROGRAM.IMAGES_FOLDER "\GitHub.png"
}
if (sourceFileSize != destFileSize)
	FileInstall, resources\imgs\GitHub.png, % PROGRAM.IMAGES_FOLDER "\GitHub.png", 1
if (ErrorLevel) {
	AppendToLogs("Failed to extract file!"
	.	"`nSource: resources\imgs\GitHub.png"
	.	"`nDest: " PROGRAM.IMAGES_FOLDER "\GitHub.png"
	.	"`nFlag: " 2)
	errorLog .= "`n`n""Failed to extract file!"
	.	"`nSource: resources\imgs\GitHub.png"
	.	"`nDest: " PROGRAM.IMAGES_FOLDER "\GitHub.png"
	.	"`nFlag: " 2
}

; ----------------------------
if !InStr(FileExist(PROGRAM.IMAGES_FOLDER ""), "D")
	FileCreateDir,% PROGRAM.IMAGES_FOLDER ""

if (A_IsCompiled) {
	sourceFileSize := Get_ResourceSize("resources\imgs\GitHub_big.png")
	FileGetSize, destFileSize, % PROGRAM.IMAGES_FOLDER "\GitHub_big.png"
}
else {
	FileGetSize, sourceFileSize, resources\imgs\GitHub_big.png
	FileGetSize, destFileSize, % PROGRAM.IMAGES_FOLDER "\GitHub_big.png"
}
if (sourceFileSize != destFileSize)
	FileInstall, resources\imgs\GitHub_big.png, % PROGRAM.IMAGES_FOLDER "\GitHub_big.png", 1
if (ErrorLevel) {
	AppendToLogs("Failed to extract file!"
	.	"`nSource: resources\imgs\GitHub_big.png"
	.	"`nDest: " PROGRAM.IMAGES_FOLDER "\GitHub_big.png"
	.	"`nFlag: " 2)
	errorLog .= "`n`n""Failed to extract file!"
	.	"`nSource: resources\imgs\GitHub_big.png"
	.	"`nDest: " PROGRAM.IMAGES_FOLDER "\GitHub_big.png"
	.	"`nFlag: " 2
}

; ----------------------------
if !InStr(FileExist(PROGRAM.IMAGES_FOLDER ""), "D")
	FileCreateDir,% PROGRAM.IMAGES_FOLDER ""

if (A_IsCompiled) {
	sourceFileSize := Get_ResourceSize("resources\imgs\GitHub_big_forums.png")
	FileGetSize, destFileSize, % PROGRAM.IMAGES_FOLDER "\GitHub_big_forums.png"
}
else {
	FileGetSize, sourceFileSize, resources\imgs\GitHub_big_forums.png
	FileGetSize, destFileSize, % PROGRAM.IMAGES_FOLDER "\GitHub_big_forums.png"
}
if (sourceFileSize != destFileSize)
	FileInstall, resources\imgs\GitHub_big_forums.png, % PROGRAM.IMAGES_FOLDER "\GitHub_big_forums.png", 1
if (ErrorLevel) {
	AppendToLogs("Failed to extract file!"
	.	"`nSource: resources\imgs\GitHub_big_forums.png"
	.	"`nDest: " PROGRAM.IMAGES_FOLDER "\GitHub_big_forums.png"
	.	"`nFlag: " 2)
	errorLog .= "`n`n""Failed to extract file!"
	.	"`nSource: resources\imgs\GitHub_big_forums.png"
	.	"`nDest: " PROGRAM.IMAGES_FOLDER "\GitHub_big_forums.png"
	.	"`nFlag: " 2
}

; ----------------------------
if !InStr(FileExist(PROGRAM.IMAGES_FOLDER ""), "D")
	FileCreateDir,% PROGRAM.IMAGES_FOLDER ""

if (A_IsCompiled) {
	sourceFileSize := Get_ResourceSize("resources\imgs\POE.png")
	FileGetSize, destFileSize, % PROGRAM.IMAGES_FOLDER "\POE.png"
}
else {
	FileGetSize, sourceFileSize, resources\imgs\POE.png
	FileGetSize, destFileSize, % PROGRAM.IMAGES_FOLDER "\POE.png"
}
if (sourceFileSize != destFileSize)
	FileInstall, resources\imgs\POE.png, % PROGRAM.IMAGES_FOLDER "\POE.png", 1
if (ErrorLevel) {
	AppendToLogs("Failed to extract file!"
	.	"`nSource: resources\imgs\POE.png"
	.	"`nDest: " PROGRAM.IMAGES_FOLDER "\POE.png"
	.	"`nFlag: " 2)
	errorLog .= "`n`n""Failed to extract file!"
	.	"`nSource: resources\imgs\POE.png"
	.	"`nDest: " PROGRAM.IMAGES_FOLDER "\POE.png"
	.	"`nFlag: " 2
}

; ----------------------------
if !InStr(FileExist(PROGRAM.IMAGES_FOLDER ""), "D")
	FileCreateDir,% PROGRAM.IMAGES_FOLDER ""

if (A_IsCompiled) {
	sourceFileSize := Get_ResourceSize("resources\imgs\POE_big.png")
	FileGetSize, destFileSize, % PROGRAM.IMAGES_FOLDER "\POE_big.png"
}
else {
	FileGetSize, sourceFileSize, resources\imgs\POE_big.png
	FileGetSize, destFileSize, % PROGRAM.IMAGES_FOLDER "\POE_big.png"
}
if (sourceFileSize != destFileSize)
	FileInstall, resources\imgs\POE_big.png, % PROGRAM.IMAGES_FOLDER "\POE_big.png", 1
if (ErrorLevel) {
	AppendToLogs("Failed to extract file!"
	.	"`nSource: resources\imgs\POE_big.png"
	.	"`nDest: " PROGRAM.IMAGES_FOLDER "\POE_big.png"
	.	"`nFlag: " 2)
	errorLog .= "`n`n""Failed to extract file!"
	.	"`nSource: resources\imgs\POE_big.png"
	.	"`nDest: " PROGRAM.IMAGES_FOLDER "\POE_big.png"
	.	"`nFlag: " 2
}

; ----------------------------
if !InStr(FileExist(PROGRAM.IMAGES_FOLDER ""), "D")
	FileCreateDir,% PROGRAM.IMAGES_FOLDER ""

if (A_IsCompiled) {
	sourceFileSize := Get_ResourceSize("resources\imgs\Reddit.png")
	FileGetSize, destFileSize, % PROGRAM.IMAGES_FOLDER "\Reddit.png"
}
else {
	FileGetSize, sourceFileSize, resources\imgs\Reddit.png
	FileGetSize, destFileSize, % PROGRAM.IMAGES_FOLDER "\Reddit.png"
}
if (sourceFileSize != destFileSize)
	FileInstall, resources\imgs\Reddit.png, % PROGRAM.IMAGES_FOLDER "\Reddit.png", 1
if (ErrorLevel) {
	AppendToLogs("Failed to extract file!"
	.	"`nSource: resources\imgs\Reddit.png"
	.	"`nDest: " PROGRAM.IMAGES_FOLDER "\Reddit.png"
	.	"`nFlag: " 2)
	errorLog .= "`n`n""Failed to extract file!"
	.	"`nSource: resources\imgs\Reddit.png"
	.	"`nDest: " PROGRAM.IMAGES_FOLDER "\Reddit.png"
	.	"`nFlag: " 2
}

; ----------------------------
if !InStr(FileExist(PROGRAM.IMAGES_FOLDER ""), "D")
	FileCreateDir,% PROGRAM.IMAGES_FOLDER ""

if (A_IsCompiled) {
	sourceFileSize := Get_ResourceSize("resources\imgs\Reddit_big.png")
	FileGetSize, destFileSize, % PROGRAM.IMAGES_FOLDER "\Reddit_big.png"
}
else {
	FileGetSize, sourceFileSize, resources\imgs\Reddit_big.png
	FileGetSize, destFileSize, % PROGRAM.IMAGES_FOLDER "\Reddit_big.png"
}
if (sourceFileSize != destFileSize)
	FileInstall, resources\imgs\Reddit_big.png, % PROGRAM.IMAGES_FOLDER "\Reddit_big.png", 1
if (ErrorLevel) {
	AppendToLogs("Failed to extract file!"
	.	"`nSource: resources\imgs\Reddit_big.png"
	.	"`nDest: " PROGRAM.IMAGES_FOLDER "\Reddit_big.png"
	.	"`nFlag: " 2)
	errorLog .= "`n`n""Failed to extract file!"
	.	"`nSource: resources\imgs\Reddit_big.png"
	.	"`nDest: " PROGRAM.IMAGES_FOLDER "\Reddit_big.png"
	.	"`nFlag: " 2
}

; ----------------------------
if !InStr(FileExist(PROGRAM.SFX_FOLDER ""), "D")
	FileCreateDir,% PROGRAM.SFX_FOLDER ""

if (A_IsCompiled) {
	sourceFileSize := Get_ResourceSize("resources\sfx\MM_Tatl_Gleam.wav")
	FileGetSize, destFileSize, % PROGRAM.SFX_FOLDER "\MM_Tatl_Gleam.wav"
}
else {
	FileGetSize, sourceFileSize, resources\sfx\MM_Tatl_Gleam.wav
	FileGetSize, destFileSize, % PROGRAM.SFX_FOLDER "\MM_Tatl_Gleam.wav"
}
if (sourceFileSize != destFileSize)
	FileInstall, resources\sfx\MM_Tatl_Gleam.wav, % PROGRAM.SFX_FOLDER "\MM_Tatl_Gleam.wav", 1
if (ErrorLevel) {
	AppendToLogs("Failed to extract file!"
	.	"`nSource: resources\sfx\MM_Tatl_Gleam.wav"
	.	"`nDest: " PROGRAM.SFX_FOLDER "\MM_Tatl_Gleam.wav"
	.	"`nFlag: " 2)
	errorLog .= "`n`n""Failed to extract file!"
	.	"`nSource: resources\sfx\MM_Tatl_Gleam.wav"
	.	"`nDest: " PROGRAM.SFX_FOLDER "\MM_Tatl_Gleam.wav"
	.	"`nFlag: " 2
}

; ----------------------------
if !InStr(FileExist(PROGRAM.SFX_FOLDER ""), "D")
	FileCreateDir,% PROGRAM.SFX_FOLDER ""

if (A_IsCompiled) {
	sourceFileSize := Get_ResourceSize("resources\sfx\MM_Tatl_Hey.wav")
	FileGetSize, destFileSize, % PROGRAM.SFX_FOLDER "\MM_Tatl_Hey.wav"
}
else {
	FileGetSize, sourceFileSize, resources\sfx\MM_Tatl_Hey.wav
	FileGetSize, destFileSize, % PROGRAM.SFX_FOLDER "\MM_Tatl_Hey.wav"
}
if (sourceFileSize != destFileSize)
	FileInstall, resources\sfx\MM_Tatl_Hey.wav, % PROGRAM.SFX_FOLDER "\MM_Tatl_Hey.wav", 1
if (ErrorLevel) {
	AppendToLogs("Failed to extract file!"
	.	"`nSource: resources\sfx\MM_Tatl_Hey.wav"
	.	"`nDest: " PROGRAM.SFX_FOLDER "\MM_Tatl_Hey.wav"
	.	"`nFlag: " 2)
	errorLog .= "`n`n""Failed to extract file!"
	.	"`nSource: resources\sfx\MM_Tatl_Hey.wav"
	.	"`nDest: " PROGRAM.SFX_FOLDER "\MM_Tatl_Hey.wav"
	.	"`nFlag: " 2
}

; ----------------------------
if !InStr(FileExist(PROGRAM.SFX_FOLDER ""), "D")
	FileCreateDir,% PROGRAM.SFX_FOLDER ""

if (A_IsCompiled) {
	sourceFileSize := Get_ResourceSize("resources\sfx\Rhodesmas_Notif_1.wav")
	FileGetSize, destFileSize, % PROGRAM.SFX_FOLDER "\Rhodesmas_Notif_1.wav"
}
else {
	FileGetSize, sourceFileSize, resources\sfx\Rhodesmas_Notif_1.wav
	FileGetSize, destFileSize, % PROGRAM.SFX_FOLDER "\Rhodesmas_Notif_1.wav"
}
if (sourceFileSize != destFileSize)
	FileInstall, resources\sfx\Rhodesmas_Notif_1.wav, % PROGRAM.SFX_FOLDER "\Rhodesmas_Notif_1.wav", 1
if (ErrorLevel) {
	AppendToLogs("Failed to extract file!"
	.	"`nSource: resources\sfx\Rhodesmas_Notif_1.wav"
	.	"`nDest: " PROGRAM.SFX_FOLDER "\Rhodesmas_Notif_1.wav"
	.	"`nFlag: " 2)
	errorLog .= "`n`n""Failed to extract file!"
	.	"`nSource: resources\sfx\Rhodesmas_Notif_1.wav"
	.	"`nDest: " PROGRAM.SFX_FOLDER "\Rhodesmas_Notif_1.wav"
	.	"`nFlag: " 2
}

; ----------------------------
if !InStr(FileExist(PROGRAM.SFX_FOLDER ""), "D")
	FileCreateDir,% PROGRAM.SFX_FOLDER ""

if (A_IsCompiled) {
	sourceFileSize := Get_ResourceSize("resources\sfx\Rhodesmas_Notif_2.wav")
	FileGetSize, destFileSize, % PROGRAM.SFX_FOLDER "\Rhodesmas_Notif_2.wav"
}
else {
	FileGetSize, sourceFileSize, resources\sfx\Rhodesmas_Notif_2.wav
	FileGetSize, destFileSize, % PROGRAM.SFX_FOLDER "\Rhodesmas_Notif_2.wav"
}
if (sourceFileSize != destFileSize)
	FileInstall, resources\sfx\Rhodesmas_Notif_2.wav, % PROGRAM.SFX_FOLDER "\Rhodesmas_Notif_2.wav", 1
if (ErrorLevel) {
	AppendToLogs("Failed to extract file!"
	.	"`nSource: resources\sfx\Rhodesmas_Notif_2.wav"
	.	"`nDest: " PROGRAM.SFX_FOLDER "\Rhodesmas_Notif_2.wav"
	.	"`nFlag: " 2)
	errorLog .= "`n`n""Failed to extract file!"
	.	"`nSource: resources\sfx\Rhodesmas_Notif_2.wav"
	.	"`nDest: " PROGRAM.SFX_FOLDER "\Rhodesmas_Notif_2.wav"
	.	"`nFlag: " 2
}

; ----------------------------
if !InStr(FileExist(PROGRAM.SFX_FOLDER ""), "D")
	FileCreateDir,% PROGRAM.SFX_FOLDER ""

if (A_IsCompiled) {
	sourceFileSize := Get_ResourceSize("resources\sfx\Rhodesmas_Up_1.wav")
	FileGetSize, destFileSize, % PROGRAM.SFX_FOLDER "\Rhodesmas_Up_1.wav"
}
else {
	FileGetSize, sourceFileSize, resources\sfx\Rhodesmas_Up_1.wav
	FileGetSize, destFileSize, % PROGRAM.SFX_FOLDER "\Rhodesmas_Up_1.wav"
}
if (sourceFileSize != destFileSize)
	FileInstall, resources\sfx\Rhodesmas_Up_1.wav, % PROGRAM.SFX_FOLDER "\Rhodesmas_Up_1.wav", 1
if (ErrorLevel) {
	AppendToLogs("Failed to extract file!"
	.	"`nSource: resources\sfx\Rhodesmas_Up_1.wav"
	.	"`nDest: " PROGRAM.SFX_FOLDER "\Rhodesmas_Up_1.wav"
	.	"`nFlag: " 2)
	errorLog .= "`n`n""Failed to extract file!"
	.	"`nSource: resources\sfx\Rhodesmas_Up_1.wav"
	.	"`nDest: " PROGRAM.SFX_FOLDER "\Rhodesmas_Up_1.wav"
	.	"`nFlag: " 2
}

; ----------------------------
if !InStr(FileExist(PROGRAM.SFX_FOLDER ""), "D")
	FileCreateDir,% PROGRAM.SFX_FOLDER ""

if (A_IsCompiled) {
	sourceFileSize := Get_ResourceSize("resources\sfx\Rhodesmas_Up_2.wav")
	FileGetSize, destFileSize, % PROGRAM.SFX_FOLDER "\Rhodesmas_Up_2.wav"
}
else {
	FileGetSize, sourceFileSize, resources\sfx\Rhodesmas_Up_2.wav
	FileGetSize, destFileSize, % PROGRAM.SFX_FOLDER "\Rhodesmas_Up_2.wav"
}
if (sourceFileSize != destFileSize)
	FileInstall, resources\sfx\Rhodesmas_Up_2.wav, % PROGRAM.SFX_FOLDER "\Rhodesmas_Up_2.wav", 1
if (ErrorLevel) {
	AppendToLogs("Failed to extract file!"
	.	"`nSource: resources\sfx\Rhodesmas_Up_2.wav"
	.	"`nDest: " PROGRAM.SFX_FOLDER "\Rhodesmas_Up_2.wav"
	.	"`nFlag: " 2)
	errorLog .= "`n`n""Failed to extract file!"
	.	"`nSource: resources\sfx\Rhodesmas_Up_2.wav"
	.	"`nDest: " PROGRAM.SFX_FOLDER "\Rhodesmas_Up_2.wav"
	.	"`nFlag: " 2
}

; ----------------------------
if !InStr(FileExist(PROGRAM.SFX_FOLDER ""), "D")
	FileCreateDir,% PROGRAM.SFX_FOLDER ""

if (A_IsCompiled) {
	sourceFileSize := Get_ResourceSize("resources\sfx\Rhodesmas_Up_3.wav")
	FileGetSize, destFileSize, % PROGRAM.SFX_FOLDER "\Rhodesmas_Up_3.wav"
}
else {
	FileGetSize, sourceFileSize, resources\sfx\Rhodesmas_Up_3.wav
	FileGetSize, destFileSize, % PROGRAM.SFX_FOLDER "\Rhodesmas_Up_3.wav"
}
if (sourceFileSize != destFileSize)
	FileInstall, resources\sfx\Rhodesmas_Up_3.wav, % PROGRAM.SFX_FOLDER "\Rhodesmas_Up_3.wav", 1
if (ErrorLevel) {
	AppendToLogs("Failed to extract file!"
	.	"`nSource: resources\sfx\Rhodesmas_Up_3.wav"
	.	"`nDest: " PROGRAM.SFX_FOLDER "\Rhodesmas_Up_3.wav"
	.	"`nFlag: " 2)
	errorLog .= "`n`n""Failed to extract file!"
	.	"`nSource: resources\sfx\Rhodesmas_Up_3.wav"
	.	"`nDest: " PROGRAM.SFX_FOLDER "\Rhodesmas_Up_3.wav"
	.	"`nFlag: " 2
}

; ----------------------------
if !InStr(FileExist(PROGRAM.SFX_FOLDER ""), "D")
	FileCreateDir,% PROGRAM.SFX_FOLDER ""

if (A_IsCompiled) {
	sourceFileSize := Get_ResourceSize("resources\sfx\WW_MainMenu_CopyErase_Start.wav")
	FileGetSize, destFileSize, % PROGRAM.SFX_FOLDER "\WW_MainMenu_CopyErase_Start.wav"
}
else {
	FileGetSize, sourceFileSize, resources\sfx\WW_MainMenu_CopyErase_Start.wav
	FileGetSize, destFileSize, % PROGRAM.SFX_FOLDER "\WW_MainMenu_CopyErase_Start.wav"
}
if (sourceFileSize != destFileSize)
	FileInstall, resources\sfx\WW_MainMenu_CopyErase_Start.wav, % PROGRAM.SFX_FOLDER "\WW_MainMenu_CopyErase_Start.wav", 1
if (ErrorLevel) {
	AppendToLogs("Failed to extract file!"
	.	"`nSource: resources\sfx\WW_MainMenu_CopyErase_Start.wav"
	.	"`nDest: " PROGRAM.SFX_FOLDER "\WW_MainMenu_CopyErase_Start.wav"
	.	"`nFlag: " 2)
	errorLog .= "`n`n""Failed to extract file!"
	.	"`nSource: resources\sfx\WW_MainMenu_CopyErase_Start.wav"
	.	"`nDest: " PROGRAM.SFX_FOLDER "\WW_MainMenu_CopyErase_Start.wav"
	.	"`nFlag: " 2
}

; ----------------------------
if !InStr(FileExist(PROGRAM.SFX_FOLDER ""), "D")
	FileCreateDir,% PROGRAM.SFX_FOLDER ""

if (A_IsCompiled) {
	sourceFileSize := Get_ResourceSize("resources\sfx\WW_MainMenu_Letter.wav")
	FileGetSize, destFileSize, % PROGRAM.SFX_FOLDER "\WW_MainMenu_Letter.wav"
}
else {
	FileGetSize, sourceFileSize, resources\sfx\WW_MainMenu_Letter.wav
	FileGetSize, destFileSize, % PROGRAM.SFX_FOLDER "\WW_MainMenu_Letter.wav"
}
if (sourceFileSize != destFileSize)
	FileInstall, resources\sfx\WW_MainMenu_Letter.wav, % PROGRAM.SFX_FOLDER "\WW_MainMenu_Letter.wav", 1
if (ErrorLevel) {
	AppendToLogs("Failed to extract file!"
	.	"`nSource: resources\sfx\WW_MainMenu_Letter.wav"
	.	"`nDest: " PROGRAM.SFX_FOLDER "\WW_MainMenu_Letter.wav"
	.	"`nFlag: " 2)
	errorLog .= "`n`n""Failed to extract file!"
	.	"`nSource: resources\sfx\WW_MainMenu_Letter.wav"
	.	"`nDest: " PROGRAM.SFX_FOLDER "\WW_MainMenu_Letter.wav"
	.	"`nFlag: " 2
}

; ----------------------------
if !InStr(FileExist(PROGRAM.SFX_FOLDER ""), "D")
	FileCreateDir,% PROGRAM.SFX_FOLDER ""

if (A_IsCompiled) {
	sourceFileSize := Get_ResourceSize("resources\sfx\ZSS_Calibrate1.wav")
	FileGetSize, destFileSize, % PROGRAM.SFX_FOLDER "\ZSS_Calibrate1.wav"
}
else {
	FileGetSize, sourceFileSize, resources\sfx\ZSS_Calibrate1.wav
	FileGetSize, destFileSize, % PROGRAM.SFX_FOLDER "\ZSS_Calibrate1.wav"
}
if (sourceFileSize != destFileSize)
	FileInstall, resources\sfx\ZSS_Calibrate1.wav, % PROGRAM.SFX_FOLDER "\ZSS_Calibrate1.wav", 1
if (ErrorLevel) {
	AppendToLogs("Failed to extract file!"
	.	"`nSource: resources\sfx\ZSS_Calibrate1.wav"
	.	"`nDest: " PROGRAM.SFX_FOLDER "\ZSS_Calibrate1.wav"
	.	"`nFlag: " 2)
	errorLog .= "`n`n""Failed to extract file!"
	.	"`nSource: resources\sfx\ZSS_Calibrate1.wav"
	.	"`nDest: " PROGRAM.SFX_FOLDER "\ZSS_Calibrate1.wav"
	.	"`nFlag: " 2
}

; ----------------------------
if !InStr(FileExist(PROGRAM.SFX_FOLDER ""), "D")
	FileCreateDir,% PROGRAM.SFX_FOLDER ""

if (A_IsCompiled) {
	sourceFileSize := Get_ResourceSize("resources\sfx\ZSS_Calibrate2.wav")
	FileGetSize, destFileSize, % PROGRAM.SFX_FOLDER "\ZSS_Calibrate2.wav"
}
else {
	FileGetSize, sourceFileSize, resources\sfx\ZSS_Calibrate2.wav
	FileGetSize, destFileSize, % PROGRAM.SFX_FOLDER "\ZSS_Calibrate2.wav"
}
if (sourceFileSize != destFileSize)
	FileInstall, resources\sfx\ZSS_Calibrate2.wav, % PROGRAM.SFX_FOLDER "\ZSS_Calibrate2.wav", 1
if (ErrorLevel) {
	AppendToLogs("Failed to extract file!"
	.	"`nSource: resources\sfx\ZSS_Calibrate2.wav"
	.	"`nDest: " PROGRAM.SFX_FOLDER "\ZSS_Calibrate2.wav"
	.	"`nFlag: " 2)
	errorLog .= "`n`n""Failed to extract file!"
	.	"`nSource: resources\sfx\ZSS_Calibrate2.wav"
	.	"`nDest: " PROGRAM.SFX_FOLDER "\ZSS_Calibrate2.wav"
	.	"`nFlag: " 2
}

; ----------------------------
if !InStr(FileExist(PROGRAM.SFX_FOLDER ""), "D")
	FileCreateDir,% PROGRAM.SFX_FOLDER ""

if (A_IsCompiled) {
	sourceFileSize := Get_ResourceSize("resources\sfx\ZSS_Calibrate3.wav")
	FileGetSize, destFileSize, % PROGRAM.SFX_FOLDER "\ZSS_Calibrate3.wav"
}
else {
	FileGetSize, sourceFileSize, resources\sfx\ZSS_Calibrate3.wav
	FileGetSize, destFileSize, % PROGRAM.SFX_FOLDER "\ZSS_Calibrate3.wav"
}
if (sourceFileSize != destFileSize)
	FileInstall, resources\sfx\ZSS_Calibrate3.wav, % PROGRAM.SFX_FOLDER "\ZSS_Calibrate3.wav", 1
if (ErrorLevel) {
	AppendToLogs("Failed to extract file!"
	.	"`nSource: resources\sfx\ZSS_Calibrate3.wav"
	.	"`nDest: " PROGRAM.SFX_FOLDER "\ZSS_Calibrate3.wav"
	.	"`nFlag: " 2)
	errorLog .= "`n`n""Failed to extract file!"
	.	"`nSource: resources\sfx\ZSS_Calibrate3.wav"
	.	"`nDest: " PROGRAM.SFX_FOLDER "\ZSS_Calibrate3.wav"
	.	"`nFlag: " 2
}

; ----------------------------
if !InStr(FileExist(PROGRAM.SFX_FOLDER ""), "D")
	FileCreateDir,% PROGRAM.SFX_FOLDER ""

if (A_IsCompiled) {
	sourceFileSize := Get_ResourceSize("resources\sfx\ZSS_Calibrate4.wav")
	FileGetSize, destFileSize, % PROGRAM.SFX_FOLDER "\ZSS_Calibrate4.wav"
}
else {
	FileGetSize, sourceFileSize, resources\sfx\ZSS_Calibrate4.wav
	FileGetSize, destFileSize, % PROGRAM.SFX_FOLDER "\ZSS_Calibrate4.wav"
}
if (sourceFileSize != destFileSize)
	FileInstall, resources\sfx\ZSS_Calibrate4.wav, % PROGRAM.SFX_FOLDER "\ZSS_Calibrate4.wav", 1
if (ErrorLevel) {
	AppendToLogs("Failed to extract file!"
	.	"`nSource: resources\sfx\ZSS_Calibrate4.wav"
	.	"`nDest: " PROGRAM.SFX_FOLDER "\ZSS_Calibrate4.wav"
	.	"`nFlag: " 2)
	errorLog .= "`n`n""Failed to extract file!"
	.	"`nSource: resources\sfx\ZSS_Calibrate4.wav"
	.	"`nDest: " PROGRAM.SFX_FOLDER "\ZSS_Calibrate4.wav"
	.	"`nFlag: " 2
}

; ----------------------------
if !InStr(FileExist(PROGRAM.SKINS_FOLDER "\Dark Blue"), "D")
	FileCreateDir,% PROGRAM.SKINS_FOLDER "\Dark Blue"

if (A_IsCompiled) {
	sourceFileSize := Get_ResourceSize("resources\skins\Dark Blue\ArrowLeft.png")
	FileGetSize, destFileSize, % PROGRAM.SKINS_FOLDER "\Dark Blue\ArrowLeft.png"
}
else {
	FileGetSize, sourceFileSize, resources\skins\Dark Blue\ArrowLeft.png
	FileGetSize, destFileSize, % PROGRAM.SKINS_FOLDER "\Dark Blue\ArrowLeft.png"
}
if (sourceFileSize != destFileSize)
	FileInstall, resources\skins\Dark Blue\ArrowLeft.png, % PROGRAM.SKINS_FOLDER "\Dark Blue\ArrowLeft.png", 1
if (ErrorLevel) {
	AppendToLogs("Failed to extract file!"
	.	"`nSource: resources\skins\Dark Blue\ArrowLeft.png"
	.	"`nDest: " PROGRAM.SKINS_FOLDER "\Dark Blue\ArrowLeft.png"
	.	"`nFlag: " 2)
	errorLog .= "`n`n""Failed to extract file!"
	.	"`nSource: resources\skins\Dark Blue\ArrowLeft.png"
	.	"`nDest: " PROGRAM.SKINS_FOLDER "\Dark Blue\ArrowLeft.png"
	.	"`nFlag: " 2
}

; ----------------------------
if !InStr(FileExist(PROGRAM.SKINS_FOLDER "\Dark Blue"), "D")
	FileCreateDir,% PROGRAM.SKINS_FOLDER "\Dark Blue"

if (A_IsCompiled) {
	sourceFileSize := Get_ResourceSize("resources\skins\Dark Blue\ArrowLeftHover.png")
	FileGetSize, destFileSize, % PROGRAM.SKINS_FOLDER "\Dark Blue\ArrowLeftHover.png"
}
else {
	FileGetSize, sourceFileSize, resources\skins\Dark Blue\ArrowLeftHover.png
	FileGetSize, destFileSize, % PROGRAM.SKINS_FOLDER "\Dark Blue\ArrowLeftHover.png"
}
if (sourceFileSize != destFileSize)
	FileInstall, resources\skins\Dark Blue\ArrowLeftHover.png, % PROGRAM.SKINS_FOLDER "\Dark Blue\ArrowLeftHover.png", 1
if (ErrorLevel) {
	AppendToLogs("Failed to extract file!"
	.	"`nSource: resources\skins\Dark Blue\ArrowLeftHover.png"
	.	"`nDest: " PROGRAM.SKINS_FOLDER "\Dark Blue\ArrowLeftHover.png"
	.	"`nFlag: " 2)
	errorLog .= "`n`n""Failed to extract file!"
	.	"`nSource: resources\skins\Dark Blue\ArrowLeftHover.png"
	.	"`nDest: " PROGRAM.SKINS_FOLDER "\Dark Blue\ArrowLeftHover.png"
	.	"`nFlag: " 2
}

; ----------------------------
if !InStr(FileExist(PROGRAM.SKINS_FOLDER "\Dark Blue"), "D")
	FileCreateDir,% PROGRAM.SKINS_FOLDER "\Dark Blue"

if (A_IsCompiled) {
	sourceFileSize := Get_ResourceSize("resources\skins\Dark Blue\ArrowLeftPress.png")
	FileGetSize, destFileSize, % PROGRAM.SKINS_FOLDER "\Dark Blue\ArrowLeftPress.png"
}
else {
	FileGetSize, sourceFileSize, resources\skins\Dark Blue\ArrowLeftPress.png
	FileGetSize, destFileSize, % PROGRAM.SKINS_FOLDER "\Dark Blue\ArrowLeftPress.png"
}
if (sourceFileSize != destFileSize)
	FileInstall, resources\skins\Dark Blue\ArrowLeftPress.png, % PROGRAM.SKINS_FOLDER "\Dark Blue\ArrowLeftPress.png", 1
if (ErrorLevel) {
	AppendToLogs("Failed to extract file!"
	.	"`nSource: resources\skins\Dark Blue\ArrowLeftPress.png"
	.	"`nDest: " PROGRAM.SKINS_FOLDER "\Dark Blue\ArrowLeftPress.png"
	.	"`nFlag: " 2)
	errorLog .= "`n`n""Failed to extract file!"
	.	"`nSource: resources\skins\Dark Blue\ArrowLeftPress.png"
	.	"`nDest: " PROGRAM.SKINS_FOLDER "\Dark Blue\ArrowLeftPress.png"
	.	"`nFlag: " 2
}

; ----------------------------
if !InStr(FileExist(PROGRAM.SKINS_FOLDER "\Dark Blue"), "D")
	FileCreateDir,% PROGRAM.SKINS_FOLDER "\Dark Blue"

if (A_IsCompiled) {
	sourceFileSize := Get_ResourceSize("resources\skins\Dark Blue\ArrowRight.png")
	FileGetSize, destFileSize, % PROGRAM.SKINS_FOLDER "\Dark Blue\ArrowRight.png"
}
else {
	FileGetSize, sourceFileSize, resources\skins\Dark Blue\ArrowRight.png
	FileGetSize, destFileSize, % PROGRAM.SKINS_FOLDER "\Dark Blue\ArrowRight.png"
}
if (sourceFileSize != destFileSize)
	FileInstall, resources\skins\Dark Blue\ArrowRight.png, % PROGRAM.SKINS_FOLDER "\Dark Blue\ArrowRight.png", 1
if (ErrorLevel) {
	AppendToLogs("Failed to extract file!"
	.	"`nSource: resources\skins\Dark Blue\ArrowRight.png"
	.	"`nDest: " PROGRAM.SKINS_FOLDER "\Dark Blue\ArrowRight.png"
	.	"`nFlag: " 2)
	errorLog .= "`n`n""Failed to extract file!"
	.	"`nSource: resources\skins\Dark Blue\ArrowRight.png"
	.	"`nDest: " PROGRAM.SKINS_FOLDER "\Dark Blue\ArrowRight.png"
	.	"`nFlag: " 2
}

; ----------------------------
if !InStr(FileExist(PROGRAM.SKINS_FOLDER "\Dark Blue"), "D")
	FileCreateDir,% PROGRAM.SKINS_FOLDER "\Dark Blue"

if (A_IsCompiled) {
	sourceFileSize := Get_ResourceSize("resources\skins\Dark Blue\ArrowRightHover.png")
	FileGetSize, destFileSize, % PROGRAM.SKINS_FOLDER "\Dark Blue\ArrowRightHover.png"
}
else {
	FileGetSize, sourceFileSize, resources\skins\Dark Blue\ArrowRightHover.png
	FileGetSize, destFileSize, % PROGRAM.SKINS_FOLDER "\Dark Blue\ArrowRightHover.png"
}
if (sourceFileSize != destFileSize)
	FileInstall, resources\skins\Dark Blue\ArrowRightHover.png, % PROGRAM.SKINS_FOLDER "\Dark Blue\ArrowRightHover.png", 1
if (ErrorLevel) {
	AppendToLogs("Failed to extract file!"
	.	"`nSource: resources\skins\Dark Blue\ArrowRightHover.png"
	.	"`nDest: " PROGRAM.SKINS_FOLDER "\Dark Blue\ArrowRightHover.png"
	.	"`nFlag: " 2)
	errorLog .= "`n`n""Failed to extract file!"
	.	"`nSource: resources\skins\Dark Blue\ArrowRightHover.png"
	.	"`nDest: " PROGRAM.SKINS_FOLDER "\Dark Blue\ArrowRightHover.png"
	.	"`nFlag: " 2
}

; ----------------------------
if !InStr(FileExist(PROGRAM.SKINS_FOLDER "\Dark Blue"), "D")
	FileCreateDir,% PROGRAM.SKINS_FOLDER "\Dark Blue"

if (A_IsCompiled) {
	sourceFileSize := Get_ResourceSize("resources\skins\Dark Blue\ArrowRightPress.png")
	FileGetSize, destFileSize, % PROGRAM.SKINS_FOLDER "\Dark Blue\ArrowRightPress.png"
}
else {
	FileGetSize, sourceFileSize, resources\skins\Dark Blue\ArrowRightPress.png
	FileGetSize, destFileSize, % PROGRAM.SKINS_FOLDER "\Dark Blue\ArrowRightPress.png"
}
if (sourceFileSize != destFileSize)
	FileInstall, resources\skins\Dark Blue\ArrowRightPress.png, % PROGRAM.SKINS_FOLDER "\Dark Blue\ArrowRightPress.png", 1
if (ErrorLevel) {
	AppendToLogs("Failed to extract file!"
	.	"`nSource: resources\skins\Dark Blue\ArrowRightPress.png"
	.	"`nDest: " PROGRAM.SKINS_FOLDER "\Dark Blue\ArrowRightPress.png"
	.	"`nFlag: " 2)
	errorLog .= "`n`n""Failed to extract file!"
	.	"`nSource: resources\skins\Dark Blue\ArrowRightPress.png"
	.	"`nDest: " PROGRAM.SKINS_FOLDER "\Dark Blue\ArrowRightPress.png"
	.	"`nFlag: " 2
}

; ----------------------------
if !InStr(FileExist(PROGRAM.SKINS_FOLDER "\Dark Blue"), "D")
	FileCreateDir,% PROGRAM.SKINS_FOLDER "\Dark Blue"

FileInstall, resources\skins\Dark Blue\Assets.ini, % PROGRAM.SKINS_FOLDER "\Dark Blue\Assets.ini", 1
if (ErrorLevel) {
	AppendToLogs("Failed to extract file!"
	.	"`nSource: resources\skins\Dark Blue\Assets.ini"
	.	"`nDest: " PROGRAM.SKINS_FOLDER "\Dark Blue\Assets.ini"
	.	"`nFlag: " 1)
	errorLog .= "`n`n""Failed to extract file!"
	.	"`nSource: resources\skins\Dark Blue\Assets.ini"
	.	"`nDest: " PROGRAM.SKINS_FOLDER "\Dark Blue\Assets.ini"
	.	"`nFlag: " 1
}

; ----------------------------
if !InStr(FileExist(PROGRAM.SKINS_FOLDER "\Dark Blue"), "D")
	FileCreateDir,% PROGRAM.SKINS_FOLDER "\Dark Blue"

if (A_IsCompiled) {
	sourceFileSize := Get_ResourceSize("resources\skins\Dark Blue\Background.png")
	FileGetSize, destFileSize, % PROGRAM.SKINS_FOLDER "\Dark Blue\Background.png"
}
else {
	FileGetSize, sourceFileSize, resources\skins\Dark Blue\Background.png
	FileGetSize, destFileSize, % PROGRAM.SKINS_FOLDER "\Dark Blue\Background.png"
}
if (sourceFileSize != destFileSize)
	FileInstall, resources\skins\Dark Blue\Background.png, % PROGRAM.SKINS_FOLDER "\Dark Blue\Background.png", 1
if (ErrorLevel) {
	AppendToLogs("Failed to extract file!"
	.	"`nSource: resources\skins\Dark Blue\Background.png"
	.	"`nDest: " PROGRAM.SKINS_FOLDER "\Dark Blue\Background.png"
	.	"`nFlag: " 2)
	errorLog .= "`n`n""Failed to extract file!"
	.	"`nSource: resources\skins\Dark Blue\Background.png"
	.	"`nDest: " PROGRAM.SKINS_FOLDER "\Dark Blue\Background.png"
	.	"`nFlag: " 2
}

; ----------------------------
if !InStr(FileExist(PROGRAM.SKINS_FOLDER "\Dark Blue"), "D")
	FileCreateDir,% PROGRAM.SKINS_FOLDER "\Dark Blue"

if (A_IsCompiled) {
	sourceFileSize := Get_ResourceSize("resources\skins\Dark Blue\ButtonClipboard.png")
	FileGetSize, destFileSize, % PROGRAM.SKINS_FOLDER "\Dark Blue\ButtonClipboard.png"
}
else {
	FileGetSize, sourceFileSize, resources\skins\Dark Blue\ButtonClipboard.png
	FileGetSize, destFileSize, % PROGRAM.SKINS_FOLDER "\Dark Blue\ButtonClipboard.png"
}
if (sourceFileSize != destFileSize)
	FileInstall, resources\skins\Dark Blue\ButtonClipboard.png, % PROGRAM.SKINS_FOLDER "\Dark Blue\ButtonClipboard.png", 1
if (ErrorLevel) {
	AppendToLogs("Failed to extract file!"
	.	"`nSource: resources\skins\Dark Blue\ButtonClipboard.png"
	.	"`nDest: " PROGRAM.SKINS_FOLDER "\Dark Blue\ButtonClipboard.png"
	.	"`nFlag: " 2)
	errorLog .= "`n`n""Failed to extract file!"
	.	"`nSource: resources\skins\Dark Blue\ButtonClipboard.png"
	.	"`nDest: " PROGRAM.SKINS_FOLDER "\Dark Blue\ButtonClipboard.png"
	.	"`nFlag: " 2
}

; ----------------------------
if !InStr(FileExist(PROGRAM.SKINS_FOLDER "\Dark Blue"), "D")
	FileCreateDir,% PROGRAM.SKINS_FOLDER "\Dark Blue"

if (A_IsCompiled) {
	sourceFileSize := Get_ResourceSize("resources\skins\Dark Blue\ButtonClipboardHover.png")
	FileGetSize, destFileSize, % PROGRAM.SKINS_FOLDER "\Dark Blue\ButtonClipboardHover.png"
}
else {
	FileGetSize, sourceFileSize, resources\skins\Dark Blue\ButtonClipboardHover.png
	FileGetSize, destFileSize, % PROGRAM.SKINS_FOLDER "\Dark Blue\ButtonClipboardHover.png"
}
if (sourceFileSize != destFileSize)
	FileInstall, resources\skins\Dark Blue\ButtonClipboardHover.png, % PROGRAM.SKINS_FOLDER "\Dark Blue\ButtonClipboardHover.png", 1
if (ErrorLevel) {
	AppendToLogs("Failed to extract file!"
	.	"`nSource: resources\skins\Dark Blue\ButtonClipboardHover.png"
	.	"`nDest: " PROGRAM.SKINS_FOLDER "\Dark Blue\ButtonClipboardHover.png"
	.	"`nFlag: " 2)
	errorLog .= "`n`n""Failed to extract file!"
	.	"`nSource: resources\skins\Dark Blue\ButtonClipboardHover.png"
	.	"`nDest: " PROGRAM.SKINS_FOLDER "\Dark Blue\ButtonClipboardHover.png"
	.	"`nFlag: " 2
}

; ----------------------------
if !InStr(FileExist(PROGRAM.SKINS_FOLDER "\Dark Blue"), "D")
	FileCreateDir,% PROGRAM.SKINS_FOLDER "\Dark Blue"

if (A_IsCompiled) {
	sourceFileSize := Get_ResourceSize("resources\skins\Dark Blue\ButtonClipboardPress.png")
	FileGetSize, destFileSize, % PROGRAM.SKINS_FOLDER "\Dark Blue\ButtonClipboardPress.png"
}
else {
	FileGetSize, sourceFileSize, resources\skins\Dark Blue\ButtonClipboardPress.png
	FileGetSize, destFileSize, % PROGRAM.SKINS_FOLDER "\Dark Blue\ButtonClipboardPress.png"
}
if (sourceFileSize != destFileSize)
	FileInstall, resources\skins\Dark Blue\ButtonClipboardPress.png, % PROGRAM.SKINS_FOLDER "\Dark Blue\ButtonClipboardPress.png", 1
if (ErrorLevel) {
	AppendToLogs("Failed to extract file!"
	.	"`nSource: resources\skins\Dark Blue\ButtonClipboardPress.png"
	.	"`nDest: " PROGRAM.SKINS_FOLDER "\Dark Blue\ButtonClipboardPress.png"
	.	"`nFlag: " 2)
	errorLog .= "`n`n""Failed to extract file!"
	.	"`nSource: resources\skins\Dark Blue\ButtonClipboardPress.png"
	.	"`nDest: " PROGRAM.SKINS_FOLDER "\Dark Blue\ButtonClipboardPress.png"
	.	"`nFlag: " 2
}

; ----------------------------
if !InStr(FileExist(PROGRAM.SKINS_FOLDER "\Dark Blue"), "D")
	FileCreateDir,% PROGRAM.SKINS_FOLDER "\Dark Blue"

if (A_IsCompiled) {
	sourceFileSize := Get_ResourceSize("resources\skins\Dark Blue\ButtonInvite.png")
	FileGetSize, destFileSize, % PROGRAM.SKINS_FOLDER "\Dark Blue\ButtonInvite.png"
}
else {
	FileGetSize, sourceFileSize, resources\skins\Dark Blue\ButtonInvite.png
	FileGetSize, destFileSize, % PROGRAM.SKINS_FOLDER "\Dark Blue\ButtonInvite.png"
}
if (sourceFileSize != destFileSize)
	FileInstall, resources\skins\Dark Blue\ButtonInvite.png, % PROGRAM.SKINS_FOLDER "\Dark Blue\ButtonInvite.png", 1
if (ErrorLevel) {
	AppendToLogs("Failed to extract file!"
	.	"`nSource: resources\skins\Dark Blue\ButtonInvite.png"
	.	"`nDest: " PROGRAM.SKINS_FOLDER "\Dark Blue\ButtonInvite.png"
	.	"`nFlag: " 2)
	errorLog .= "`n`n""Failed to extract file!"
	.	"`nSource: resources\skins\Dark Blue\ButtonInvite.png"
	.	"`nDest: " PROGRAM.SKINS_FOLDER "\Dark Blue\ButtonInvite.png"
	.	"`nFlag: " 2
}

; ----------------------------
if !InStr(FileExist(PROGRAM.SKINS_FOLDER "\Dark Blue"), "D")
	FileCreateDir,% PROGRAM.SKINS_FOLDER "\Dark Blue"

if (A_IsCompiled) {
	sourceFileSize := Get_ResourceSize("resources\skins\Dark Blue\ButtonInviteHover.png")
	FileGetSize, destFileSize, % PROGRAM.SKINS_FOLDER "\Dark Blue\ButtonInviteHover.png"
}
else {
	FileGetSize, sourceFileSize, resources\skins\Dark Blue\ButtonInviteHover.png
	FileGetSize, destFileSize, % PROGRAM.SKINS_FOLDER "\Dark Blue\ButtonInviteHover.png"
}
if (sourceFileSize != destFileSize)
	FileInstall, resources\skins\Dark Blue\ButtonInviteHover.png, % PROGRAM.SKINS_FOLDER "\Dark Blue\ButtonInviteHover.png", 1
if (ErrorLevel) {
	AppendToLogs("Failed to extract file!"
	.	"`nSource: resources\skins\Dark Blue\ButtonInviteHover.png"
	.	"`nDest: " PROGRAM.SKINS_FOLDER "\Dark Blue\ButtonInviteHover.png"
	.	"`nFlag: " 2)
	errorLog .= "`n`n""Failed to extract file!"
	.	"`nSource: resources\skins\Dark Blue\ButtonInviteHover.png"
	.	"`nDest: " PROGRAM.SKINS_FOLDER "\Dark Blue\ButtonInviteHover.png"
	.	"`nFlag: " 2
}

; ----------------------------
if !InStr(FileExist(PROGRAM.SKINS_FOLDER "\Dark Blue"), "D")
	FileCreateDir,% PROGRAM.SKINS_FOLDER "\Dark Blue"

if (A_IsCompiled) {
	sourceFileSize := Get_ResourceSize("resources\skins\Dark Blue\ButtonInvitePress.png")
	FileGetSize, destFileSize, % PROGRAM.SKINS_FOLDER "\Dark Blue\ButtonInvitePress.png"
}
else {
	FileGetSize, sourceFileSize, resources\skins\Dark Blue\ButtonInvitePress.png
	FileGetSize, destFileSize, % PROGRAM.SKINS_FOLDER "\Dark Blue\ButtonInvitePress.png"
}
if (sourceFileSize != destFileSize)
	FileInstall, resources\skins\Dark Blue\ButtonInvitePress.png, % PROGRAM.SKINS_FOLDER "\Dark Blue\ButtonInvitePress.png", 1
if (ErrorLevel) {
	AppendToLogs("Failed to extract file!"
	.	"`nSource: resources\skins\Dark Blue\ButtonInvitePress.png"
	.	"`nDest: " PROGRAM.SKINS_FOLDER "\Dark Blue\ButtonInvitePress.png"
	.	"`nFlag: " 2)
	errorLog .= "`n`n""Failed to extract file!"
	.	"`nSource: resources\skins\Dark Blue\ButtonInvitePress.png"
	.	"`nDest: " PROGRAM.SKINS_FOLDER "\Dark Blue\ButtonInvitePress.png"
	.	"`nFlag: " 2
}

; ----------------------------
if !InStr(FileExist(PROGRAM.SKINS_FOLDER "\Dark Blue"), "D")
	FileCreateDir,% PROGRAM.SKINS_FOLDER "\Dark Blue"

if (A_IsCompiled) {
	sourceFileSize := Get_ResourceSize("resources\skins\Dark Blue\ButtonKick.png")
	FileGetSize, destFileSize, % PROGRAM.SKINS_FOLDER "\Dark Blue\ButtonKick.png"
}
else {
	FileGetSize, sourceFileSize, resources\skins\Dark Blue\ButtonKick.png
	FileGetSize, destFileSize, % PROGRAM.SKINS_FOLDER "\Dark Blue\ButtonKick.png"
}
if (sourceFileSize != destFileSize)
	FileInstall, resources\skins\Dark Blue\ButtonKick.png, % PROGRAM.SKINS_FOLDER "\Dark Blue\ButtonKick.png", 1
if (ErrorLevel) {
	AppendToLogs("Failed to extract file!"
	.	"`nSource: resources\skins\Dark Blue\ButtonKick.png"
	.	"`nDest: " PROGRAM.SKINS_FOLDER "\Dark Blue\ButtonKick.png"
	.	"`nFlag: " 2)
	errorLog .= "`n`n""Failed to extract file!"
	.	"`nSource: resources\skins\Dark Blue\ButtonKick.png"
	.	"`nDest: " PROGRAM.SKINS_FOLDER "\Dark Blue\ButtonKick.png"
	.	"`nFlag: " 2
}

; ----------------------------
if !InStr(FileExist(PROGRAM.SKINS_FOLDER "\Dark Blue"), "D")
	FileCreateDir,% PROGRAM.SKINS_FOLDER "\Dark Blue"

if (A_IsCompiled) {
	sourceFileSize := Get_ResourceSize("resources\skins\Dark Blue\ButtonKickHover.png")
	FileGetSize, destFileSize, % PROGRAM.SKINS_FOLDER "\Dark Blue\ButtonKickHover.png"
}
else {
	FileGetSize, sourceFileSize, resources\skins\Dark Blue\ButtonKickHover.png
	FileGetSize, destFileSize, % PROGRAM.SKINS_FOLDER "\Dark Blue\ButtonKickHover.png"
}
if (sourceFileSize != destFileSize)
	FileInstall, resources\skins\Dark Blue\ButtonKickHover.png, % PROGRAM.SKINS_FOLDER "\Dark Blue\ButtonKickHover.png", 1
if (ErrorLevel) {
	AppendToLogs("Failed to extract file!"
	.	"`nSource: resources\skins\Dark Blue\ButtonKickHover.png"
	.	"`nDest: " PROGRAM.SKINS_FOLDER "\Dark Blue\ButtonKickHover.png"
	.	"`nFlag: " 2)
	errorLog .= "`n`n""Failed to extract file!"
	.	"`nSource: resources\skins\Dark Blue\ButtonKickHover.png"
	.	"`nDest: " PROGRAM.SKINS_FOLDER "\Dark Blue\ButtonKickHover.png"
	.	"`nFlag: " 2
}

; ----------------------------
if !InStr(FileExist(PROGRAM.SKINS_FOLDER "\Dark Blue"), "D")
	FileCreateDir,% PROGRAM.SKINS_FOLDER "\Dark Blue"

if (A_IsCompiled) {
	sourceFileSize := Get_ResourceSize("resources\skins\Dark Blue\ButtonKickPress.png")
	FileGetSize, destFileSize, % PROGRAM.SKINS_FOLDER "\Dark Blue\ButtonKickPress.png"
}
else {
	FileGetSize, sourceFileSize, resources\skins\Dark Blue\ButtonKickPress.png
	FileGetSize, destFileSize, % PROGRAM.SKINS_FOLDER "\Dark Blue\ButtonKickPress.png"
}
if (sourceFileSize != destFileSize)
	FileInstall, resources\skins\Dark Blue\ButtonKickPress.png, % PROGRAM.SKINS_FOLDER "\Dark Blue\ButtonKickPress.png", 1
if (ErrorLevel) {
	AppendToLogs("Failed to extract file!"
	.	"`nSource: resources\skins\Dark Blue\ButtonKickPress.png"
	.	"`nDest: " PROGRAM.SKINS_FOLDER "\Dark Blue\ButtonKickPress.png"
	.	"`nFlag: " 2)
	errorLog .= "`n`n""Failed to extract file!"
	.	"`nSource: resources\skins\Dark Blue\ButtonKickPress.png"
	.	"`nDest: " PROGRAM.SKINS_FOLDER "\Dark Blue\ButtonKickPress.png"
	.	"`nFlag: " 2
}

; ----------------------------
if !InStr(FileExist(PROGRAM.SKINS_FOLDER "\Dark Blue"), "D")
	FileCreateDir,% PROGRAM.SKINS_FOLDER "\Dark Blue"

if (A_IsCompiled) {
	sourceFileSize := Get_ResourceSize("resources\skins\Dark Blue\ButtonOneThird.png")
	FileGetSize, destFileSize, % PROGRAM.SKINS_FOLDER "\Dark Blue\ButtonOneThird.png"
}
else {
	FileGetSize, sourceFileSize, resources\skins\Dark Blue\ButtonOneThird.png
	FileGetSize, destFileSize, % PROGRAM.SKINS_FOLDER "\Dark Blue\ButtonOneThird.png"
}
if (sourceFileSize != destFileSize)
	FileInstall, resources\skins\Dark Blue\ButtonOneThird.png, % PROGRAM.SKINS_FOLDER "\Dark Blue\ButtonOneThird.png", 1
if (ErrorLevel) {
	AppendToLogs("Failed to extract file!"
	.	"`nSource: resources\skins\Dark Blue\ButtonOneThird.png"
	.	"`nDest: " PROGRAM.SKINS_FOLDER "\Dark Blue\ButtonOneThird.png"
	.	"`nFlag: " 2)
	errorLog .= "`n`n""Failed to extract file!"
	.	"`nSource: resources\skins\Dark Blue\ButtonOneThird.png"
	.	"`nDest: " PROGRAM.SKINS_FOLDER "\Dark Blue\ButtonOneThird.png"
	.	"`nFlag: " 2
}

; ----------------------------
if !InStr(FileExist(PROGRAM.SKINS_FOLDER "\Dark Blue"), "D")
	FileCreateDir,% PROGRAM.SKINS_FOLDER "\Dark Blue"

if (A_IsCompiled) {
	sourceFileSize := Get_ResourceSize("resources\skins\Dark Blue\ButtonOneThirdHover.png")
	FileGetSize, destFileSize, % PROGRAM.SKINS_FOLDER "\Dark Blue\ButtonOneThirdHover.png"
}
else {
	FileGetSize, sourceFileSize, resources\skins\Dark Blue\ButtonOneThirdHover.png
	FileGetSize, destFileSize, % PROGRAM.SKINS_FOLDER "\Dark Blue\ButtonOneThirdHover.png"
}
if (sourceFileSize != destFileSize)
	FileInstall, resources\skins\Dark Blue\ButtonOneThirdHover.png, % PROGRAM.SKINS_FOLDER "\Dark Blue\ButtonOneThirdHover.png", 1
if (ErrorLevel) {
	AppendToLogs("Failed to extract file!"
	.	"`nSource: resources\skins\Dark Blue\ButtonOneThirdHover.png"
	.	"`nDest: " PROGRAM.SKINS_FOLDER "\Dark Blue\ButtonOneThirdHover.png"
	.	"`nFlag: " 2)
	errorLog .= "`n`n""Failed to extract file!"
	.	"`nSource: resources\skins\Dark Blue\ButtonOneThirdHover.png"
	.	"`nDest: " PROGRAM.SKINS_FOLDER "\Dark Blue\ButtonOneThirdHover.png"
	.	"`nFlag: " 2
}

; ----------------------------
if !InStr(FileExist(PROGRAM.SKINS_FOLDER "\Dark Blue"), "D")
	FileCreateDir,% PROGRAM.SKINS_FOLDER "\Dark Blue"

if (A_IsCompiled) {
	sourceFileSize := Get_ResourceSize("resources\skins\Dark Blue\ButtonOneThirdPress.png")
	FileGetSize, destFileSize, % PROGRAM.SKINS_FOLDER "\Dark Blue\ButtonOneThirdPress.png"
}
else {
	FileGetSize, sourceFileSize, resources\skins\Dark Blue\ButtonOneThirdPress.png
	FileGetSize, destFileSize, % PROGRAM.SKINS_FOLDER "\Dark Blue\ButtonOneThirdPress.png"
}
if (sourceFileSize != destFileSize)
	FileInstall, resources\skins\Dark Blue\ButtonOneThirdPress.png, % PROGRAM.SKINS_FOLDER "\Dark Blue\ButtonOneThirdPress.png", 1
if (ErrorLevel) {
	AppendToLogs("Failed to extract file!"
	.	"`nSource: resources\skins\Dark Blue\ButtonOneThirdPress.png"
	.	"`nDest: " PROGRAM.SKINS_FOLDER "\Dark Blue\ButtonOneThirdPress.png"
	.	"`nFlag: " 2)
	errorLog .= "`n`n""Failed to extract file!"
	.	"`nSource: resources\skins\Dark Blue\ButtonOneThirdPress.png"
	.	"`nDest: " PROGRAM.SKINS_FOLDER "\Dark Blue\ButtonOneThirdPress.png"
	.	"`nFlag: " 2
}

; ----------------------------
if !InStr(FileExist(PROGRAM.SKINS_FOLDER "\Dark Blue"), "D")
	FileCreateDir,% PROGRAM.SKINS_FOLDER "\Dark Blue"

if (A_IsCompiled) {
	sourceFileSize := Get_ResourceSize("resources\skins\Dark Blue\ButtonThreeThird.png")
	FileGetSize, destFileSize, % PROGRAM.SKINS_FOLDER "\Dark Blue\ButtonThreeThird.png"
}
else {
	FileGetSize, sourceFileSize, resources\skins\Dark Blue\ButtonThreeThird.png
	FileGetSize, destFileSize, % PROGRAM.SKINS_FOLDER "\Dark Blue\ButtonThreeThird.png"
}
if (sourceFileSize != destFileSize)
	FileInstall, resources\skins\Dark Blue\ButtonThreeThird.png, % PROGRAM.SKINS_FOLDER "\Dark Blue\ButtonThreeThird.png", 1
if (ErrorLevel) {
	AppendToLogs("Failed to extract file!"
	.	"`nSource: resources\skins\Dark Blue\ButtonThreeThird.png"
	.	"`nDest: " PROGRAM.SKINS_FOLDER "\Dark Blue\ButtonThreeThird.png"
	.	"`nFlag: " 2)
	errorLog .= "`n`n""Failed to extract file!"
	.	"`nSource: resources\skins\Dark Blue\ButtonThreeThird.png"
	.	"`nDest: " PROGRAM.SKINS_FOLDER "\Dark Blue\ButtonThreeThird.png"
	.	"`nFlag: " 2
}

; ----------------------------
if !InStr(FileExist(PROGRAM.SKINS_FOLDER "\Dark Blue"), "D")
	FileCreateDir,% PROGRAM.SKINS_FOLDER "\Dark Blue"

if (A_IsCompiled) {
	sourceFileSize := Get_ResourceSize("resources\skins\Dark Blue\ButtonThreeThirdHover.png")
	FileGetSize, destFileSize, % PROGRAM.SKINS_FOLDER "\Dark Blue\ButtonThreeThirdHover.png"
}
else {
	FileGetSize, sourceFileSize, resources\skins\Dark Blue\ButtonThreeThirdHover.png
	FileGetSize, destFileSize, % PROGRAM.SKINS_FOLDER "\Dark Blue\ButtonThreeThirdHover.png"
}
if (sourceFileSize != destFileSize)
	FileInstall, resources\skins\Dark Blue\ButtonThreeThirdHover.png, % PROGRAM.SKINS_FOLDER "\Dark Blue\ButtonThreeThirdHover.png", 1
if (ErrorLevel) {
	AppendToLogs("Failed to extract file!"
	.	"`nSource: resources\skins\Dark Blue\ButtonThreeThirdHover.png"
	.	"`nDest: " PROGRAM.SKINS_FOLDER "\Dark Blue\ButtonThreeThirdHover.png"
	.	"`nFlag: " 2)
	errorLog .= "`n`n""Failed to extract file!"
	.	"`nSource: resources\skins\Dark Blue\ButtonThreeThirdHover.png"
	.	"`nDest: " PROGRAM.SKINS_FOLDER "\Dark Blue\ButtonThreeThirdHover.png"
	.	"`nFlag: " 2
}

; ----------------------------
if !InStr(FileExist(PROGRAM.SKINS_FOLDER "\Dark Blue"), "D")
	FileCreateDir,% PROGRAM.SKINS_FOLDER "\Dark Blue"

if (A_IsCompiled) {
	sourceFileSize := Get_ResourceSize("resources\skins\Dark Blue\ButtonThreeThirdPress.png")
	FileGetSize, destFileSize, % PROGRAM.SKINS_FOLDER "\Dark Blue\ButtonThreeThirdPress.png"
}
else {
	FileGetSize, sourceFileSize, resources\skins\Dark Blue\ButtonThreeThirdPress.png
	FileGetSize, destFileSize, % PROGRAM.SKINS_FOLDER "\Dark Blue\ButtonThreeThirdPress.png"
}
if (sourceFileSize != destFileSize)
	FileInstall, resources\skins\Dark Blue\ButtonThreeThirdPress.png, % PROGRAM.SKINS_FOLDER "\Dark Blue\ButtonThreeThirdPress.png", 1
if (ErrorLevel) {
	AppendToLogs("Failed to extract file!"
	.	"`nSource: resources\skins\Dark Blue\ButtonThreeThirdPress.png"
	.	"`nDest: " PROGRAM.SKINS_FOLDER "\Dark Blue\ButtonThreeThirdPress.png"
	.	"`nFlag: " 2)
	errorLog .= "`n`n""Failed to extract file!"
	.	"`nSource: resources\skins\Dark Blue\ButtonThreeThirdPress.png"
	.	"`nDest: " PROGRAM.SKINS_FOLDER "\Dark Blue\ButtonThreeThirdPress.png"
	.	"`nFlag: " 2
}

; ----------------------------
if !InStr(FileExist(PROGRAM.SKINS_FOLDER "\Dark Blue"), "D")
	FileCreateDir,% PROGRAM.SKINS_FOLDER "\Dark Blue"

if (A_IsCompiled) {
	sourceFileSize := Get_ResourceSize("resources\skins\Dark Blue\ButtonTrade.png")
	FileGetSize, destFileSize, % PROGRAM.SKINS_FOLDER "\Dark Blue\ButtonTrade.png"
}
else {
	FileGetSize, sourceFileSize, resources\skins\Dark Blue\ButtonTrade.png
	FileGetSize, destFileSize, % PROGRAM.SKINS_FOLDER "\Dark Blue\ButtonTrade.png"
}
if (sourceFileSize != destFileSize)
	FileInstall, resources\skins\Dark Blue\ButtonTrade.png, % PROGRAM.SKINS_FOLDER "\Dark Blue\ButtonTrade.png", 1
if (ErrorLevel) {
	AppendToLogs("Failed to extract file!"
	.	"`nSource: resources\skins\Dark Blue\ButtonTrade.png"
	.	"`nDest: " PROGRAM.SKINS_FOLDER "\Dark Blue\ButtonTrade.png"
	.	"`nFlag: " 2)
	errorLog .= "`n`n""Failed to extract file!"
	.	"`nSource: resources\skins\Dark Blue\ButtonTrade.png"
	.	"`nDest: " PROGRAM.SKINS_FOLDER "\Dark Blue\ButtonTrade.png"
	.	"`nFlag: " 2
}

; ----------------------------
if !InStr(FileExist(PROGRAM.SKINS_FOLDER "\Dark Blue"), "D")
	FileCreateDir,% PROGRAM.SKINS_FOLDER "\Dark Blue"

if (A_IsCompiled) {
	sourceFileSize := Get_ResourceSize("resources\skins\Dark Blue\ButtonTradeHover.png")
	FileGetSize, destFileSize, % PROGRAM.SKINS_FOLDER "\Dark Blue\ButtonTradeHover.png"
}
else {
	FileGetSize, sourceFileSize, resources\skins\Dark Blue\ButtonTradeHover.png
	FileGetSize, destFileSize, % PROGRAM.SKINS_FOLDER "\Dark Blue\ButtonTradeHover.png"
}
if (sourceFileSize != destFileSize)
	FileInstall, resources\skins\Dark Blue\ButtonTradeHover.png, % PROGRAM.SKINS_FOLDER "\Dark Blue\ButtonTradeHover.png", 1
if (ErrorLevel) {
	AppendToLogs("Failed to extract file!"
	.	"`nSource: resources\skins\Dark Blue\ButtonTradeHover.png"
	.	"`nDest: " PROGRAM.SKINS_FOLDER "\Dark Blue\ButtonTradeHover.png"
	.	"`nFlag: " 2)
	errorLog .= "`n`n""Failed to extract file!"
	.	"`nSource: resources\skins\Dark Blue\ButtonTradeHover.png"
	.	"`nDest: " PROGRAM.SKINS_FOLDER "\Dark Blue\ButtonTradeHover.png"
	.	"`nFlag: " 2
}

; ----------------------------
if !InStr(FileExist(PROGRAM.SKINS_FOLDER "\Dark Blue"), "D")
	FileCreateDir,% PROGRAM.SKINS_FOLDER "\Dark Blue"

if (A_IsCompiled) {
	sourceFileSize := Get_ResourceSize("resources\skins\Dark Blue\ButtonTradePress.png")
	FileGetSize, destFileSize, % PROGRAM.SKINS_FOLDER "\Dark Blue\ButtonTradePress.png"
}
else {
	FileGetSize, sourceFileSize, resources\skins\Dark Blue\ButtonTradePress.png
	FileGetSize, destFileSize, % PROGRAM.SKINS_FOLDER "\Dark Blue\ButtonTradePress.png"
}
if (sourceFileSize != destFileSize)
	FileInstall, resources\skins\Dark Blue\ButtonTradePress.png, % PROGRAM.SKINS_FOLDER "\Dark Blue\ButtonTradePress.png", 1
if (ErrorLevel) {
	AppendToLogs("Failed to extract file!"
	.	"`nSource: resources\skins\Dark Blue\ButtonTradePress.png"
	.	"`nDest: " PROGRAM.SKINS_FOLDER "\Dark Blue\ButtonTradePress.png"
	.	"`nFlag: " 2)
	errorLog .= "`n`n""Failed to extract file!"
	.	"`nSource: resources\skins\Dark Blue\ButtonTradePress.png"
	.	"`nDest: " PROGRAM.SKINS_FOLDER "\Dark Blue\ButtonTradePress.png"
	.	"`nFlag: " 2
}

; ----------------------------
if !InStr(FileExist(PROGRAM.SKINS_FOLDER "\Dark Blue"), "D")
	FileCreateDir,% PROGRAM.SKINS_FOLDER "\Dark Blue"

if (A_IsCompiled) {
	sourceFileSize := Get_ResourceSize("resources\skins\Dark Blue\ButtonTwoThird.png")
	FileGetSize, destFileSize, % PROGRAM.SKINS_FOLDER "\Dark Blue\ButtonTwoThird.png"
}
else {
	FileGetSize, sourceFileSize, resources\skins\Dark Blue\ButtonTwoThird.png
	FileGetSize, destFileSize, % PROGRAM.SKINS_FOLDER "\Dark Blue\ButtonTwoThird.png"
}
if (sourceFileSize != destFileSize)
	FileInstall, resources\skins\Dark Blue\ButtonTwoThird.png, % PROGRAM.SKINS_FOLDER "\Dark Blue\ButtonTwoThird.png", 1
if (ErrorLevel) {
	AppendToLogs("Failed to extract file!"
	.	"`nSource: resources\skins\Dark Blue\ButtonTwoThird.png"
	.	"`nDest: " PROGRAM.SKINS_FOLDER "\Dark Blue\ButtonTwoThird.png"
	.	"`nFlag: " 2)
	errorLog .= "`n`n""Failed to extract file!"
	.	"`nSource: resources\skins\Dark Blue\ButtonTwoThird.png"
	.	"`nDest: " PROGRAM.SKINS_FOLDER "\Dark Blue\ButtonTwoThird.png"
	.	"`nFlag: " 2
}

; ----------------------------
if !InStr(FileExist(PROGRAM.SKINS_FOLDER "\Dark Blue"), "D")
	FileCreateDir,% PROGRAM.SKINS_FOLDER "\Dark Blue"

if (A_IsCompiled) {
	sourceFileSize := Get_ResourceSize("resources\skins\Dark Blue\ButtonTwoThirdHover.png")
	FileGetSize, destFileSize, % PROGRAM.SKINS_FOLDER "\Dark Blue\ButtonTwoThirdHover.png"
}
else {
	FileGetSize, sourceFileSize, resources\skins\Dark Blue\ButtonTwoThirdHover.png
	FileGetSize, destFileSize, % PROGRAM.SKINS_FOLDER "\Dark Blue\ButtonTwoThirdHover.png"
}
if (sourceFileSize != destFileSize)
	FileInstall, resources\skins\Dark Blue\ButtonTwoThirdHover.png, % PROGRAM.SKINS_FOLDER "\Dark Blue\ButtonTwoThirdHover.png", 1
if (ErrorLevel) {
	AppendToLogs("Failed to extract file!"
	.	"`nSource: resources\skins\Dark Blue\ButtonTwoThirdHover.png"
	.	"`nDest: " PROGRAM.SKINS_FOLDER "\Dark Blue\ButtonTwoThirdHover.png"
	.	"`nFlag: " 2)
	errorLog .= "`n`n""Failed to extract file!"
	.	"`nSource: resources\skins\Dark Blue\ButtonTwoThirdHover.png"
	.	"`nDest: " PROGRAM.SKINS_FOLDER "\Dark Blue\ButtonTwoThirdHover.png"
	.	"`nFlag: " 2
}

; ----------------------------
if !InStr(FileExist(PROGRAM.SKINS_FOLDER "\Dark Blue"), "D")
	FileCreateDir,% PROGRAM.SKINS_FOLDER "\Dark Blue"

if (A_IsCompiled) {
	sourceFileSize := Get_ResourceSize("resources\skins\Dark Blue\ButtonTwoThirdPress.png")
	FileGetSize, destFileSize, % PROGRAM.SKINS_FOLDER "\Dark Blue\ButtonTwoThirdPress.png"
}
else {
	FileGetSize, sourceFileSize, resources\skins\Dark Blue\ButtonTwoThirdPress.png
	FileGetSize, destFileSize, % PROGRAM.SKINS_FOLDER "\Dark Blue\ButtonTwoThirdPress.png"
}
if (sourceFileSize != destFileSize)
	FileInstall, resources\skins\Dark Blue\ButtonTwoThirdPress.png, % PROGRAM.SKINS_FOLDER "\Dark Blue\ButtonTwoThirdPress.png", 1
if (ErrorLevel) {
	AppendToLogs("Failed to extract file!"
	.	"`nSource: resources\skins\Dark Blue\ButtonTwoThirdPress.png"
	.	"`nDest: " PROGRAM.SKINS_FOLDER "\Dark Blue\ButtonTwoThirdPress.png"
	.	"`nFlag: " 2)
	errorLog .= "`n`n""Failed to extract file!"
	.	"`nSource: resources\skins\Dark Blue\ButtonTwoThirdPress.png"
	.	"`nDest: " PROGRAM.SKINS_FOLDER "\Dark Blue\ButtonTwoThirdPress.png"
	.	"`nFlag: " 2
}

; ----------------------------
if !InStr(FileExist(PROGRAM.SKINS_FOLDER "\Dark Blue"), "D")
	FileCreateDir,% PROGRAM.SKINS_FOLDER "\Dark Blue"

if (A_IsCompiled) {
	sourceFileSize := Get_ResourceSize("resources\skins\Dark Blue\ButtonWhisper.png")
	FileGetSize, destFileSize, % PROGRAM.SKINS_FOLDER "\Dark Blue\ButtonWhisper.png"
}
else {
	FileGetSize, sourceFileSize, resources\skins\Dark Blue\ButtonWhisper.png
	FileGetSize, destFileSize, % PROGRAM.SKINS_FOLDER "\Dark Blue\ButtonWhisper.png"
}
if (sourceFileSize != destFileSize)
	FileInstall, resources\skins\Dark Blue\ButtonWhisper.png, % PROGRAM.SKINS_FOLDER "\Dark Blue\ButtonWhisper.png", 1
if (ErrorLevel) {
	AppendToLogs("Failed to extract file!"
	.	"`nSource: resources\skins\Dark Blue\ButtonWhisper.png"
	.	"`nDest: " PROGRAM.SKINS_FOLDER "\Dark Blue\ButtonWhisper.png"
	.	"`nFlag: " 2)
	errorLog .= "`n`n""Failed to extract file!"
	.	"`nSource: resources\skins\Dark Blue\ButtonWhisper.png"
	.	"`nDest: " PROGRAM.SKINS_FOLDER "\Dark Blue\ButtonWhisper.png"
	.	"`nFlag: " 2
}

; ----------------------------
if !InStr(FileExist(PROGRAM.SKINS_FOLDER "\Dark Blue"), "D")
	FileCreateDir,% PROGRAM.SKINS_FOLDER "\Dark Blue"

if (A_IsCompiled) {
	sourceFileSize := Get_ResourceSize("resources\skins\Dark Blue\ButtonWhisperHover.png")
	FileGetSize, destFileSize, % PROGRAM.SKINS_FOLDER "\Dark Blue\ButtonWhisperHover.png"
}
else {
	FileGetSize, sourceFileSize, resources\skins\Dark Blue\ButtonWhisperHover.png
	FileGetSize, destFileSize, % PROGRAM.SKINS_FOLDER "\Dark Blue\ButtonWhisperHover.png"
}
if (sourceFileSize != destFileSize)
	FileInstall, resources\skins\Dark Blue\ButtonWhisperHover.png, % PROGRAM.SKINS_FOLDER "\Dark Blue\ButtonWhisperHover.png", 1
if (ErrorLevel) {
	AppendToLogs("Failed to extract file!"
	.	"`nSource: resources\skins\Dark Blue\ButtonWhisperHover.png"
	.	"`nDest: " PROGRAM.SKINS_FOLDER "\Dark Blue\ButtonWhisperHover.png"
	.	"`nFlag: " 2)
	errorLog .= "`n`n""Failed to extract file!"
	.	"`nSource: resources\skins\Dark Blue\ButtonWhisperHover.png"
	.	"`nDest: " PROGRAM.SKINS_FOLDER "\Dark Blue\ButtonWhisperHover.png"
	.	"`nFlag: " 2
}

; ----------------------------
if !InStr(FileExist(PROGRAM.SKINS_FOLDER "\Dark Blue"), "D")
	FileCreateDir,% PROGRAM.SKINS_FOLDER "\Dark Blue"

if (A_IsCompiled) {
	sourceFileSize := Get_ResourceSize("resources\skins\Dark Blue\ButtonWhisperPress.png")
	FileGetSize, destFileSize, % PROGRAM.SKINS_FOLDER "\Dark Blue\ButtonWhisperPress.png"
}
else {
	FileGetSize, sourceFileSize, resources\skins\Dark Blue\ButtonWhisperPress.png
	FileGetSize, destFileSize, % PROGRAM.SKINS_FOLDER "\Dark Blue\ButtonWhisperPress.png"
}
if (sourceFileSize != destFileSize)
	FileInstall, resources\skins\Dark Blue\ButtonWhisperPress.png, % PROGRAM.SKINS_FOLDER "\Dark Blue\ButtonWhisperPress.png", 1
if (ErrorLevel) {
	AppendToLogs("Failed to extract file!"
	.	"`nSource: resources\skins\Dark Blue\ButtonWhisperPress.png"
	.	"`nDest: " PROGRAM.SKINS_FOLDER "\Dark Blue\ButtonWhisperPress.png"
	.	"`nFlag: " 2)
	errorLog .= "`n`n""Failed to extract file!"
	.	"`nSource: resources\skins\Dark Blue\ButtonWhisperPress.png"
	.	"`nDest: " PROGRAM.SKINS_FOLDER "\Dark Blue\ButtonWhisperPress.png"
	.	"`nFlag: " 2
}

; ----------------------------
if !InStr(FileExist(PROGRAM.SKINS_FOLDER "\Dark Blue"), "D")
	FileCreateDir,% PROGRAM.SKINS_FOLDER "\Dark Blue"

if (A_IsCompiled) {
	sourceFileSize := Get_ResourceSize("resources\skins\Dark Blue\CloseTab.png")
	FileGetSize, destFileSize, % PROGRAM.SKINS_FOLDER "\Dark Blue\CloseTab.png"
}
else {
	FileGetSize, sourceFileSize, resources\skins\Dark Blue\CloseTab.png
	FileGetSize, destFileSize, % PROGRAM.SKINS_FOLDER "\Dark Blue\CloseTab.png"
}
if (sourceFileSize != destFileSize)
	FileInstall, resources\skins\Dark Blue\CloseTab.png, % PROGRAM.SKINS_FOLDER "\Dark Blue\CloseTab.png", 1
if (ErrorLevel) {
	AppendToLogs("Failed to extract file!"
	.	"`nSource: resources\skins\Dark Blue\CloseTab.png"
	.	"`nDest: " PROGRAM.SKINS_FOLDER "\Dark Blue\CloseTab.png"
	.	"`nFlag: " 2)
	errorLog .= "`n`n""Failed to extract file!"
	.	"`nSource: resources\skins\Dark Blue\CloseTab.png"
	.	"`nDest: " PROGRAM.SKINS_FOLDER "\Dark Blue\CloseTab.png"
	.	"`nFlag: " 2
}

; ----------------------------
if !InStr(FileExist(PROGRAM.SKINS_FOLDER "\Dark Blue"), "D")
	FileCreateDir,% PROGRAM.SKINS_FOLDER "\Dark Blue"

if (A_IsCompiled) {
	sourceFileSize := Get_ResourceSize("resources\skins\Dark Blue\CloseTabHover.png")
	FileGetSize, destFileSize, % PROGRAM.SKINS_FOLDER "\Dark Blue\CloseTabHover.png"
}
else {
	FileGetSize, sourceFileSize, resources\skins\Dark Blue\CloseTabHover.png
	FileGetSize, destFileSize, % PROGRAM.SKINS_FOLDER "\Dark Blue\CloseTabHover.png"
}
if (sourceFileSize != destFileSize)
	FileInstall, resources\skins\Dark Blue\CloseTabHover.png, % PROGRAM.SKINS_FOLDER "\Dark Blue\CloseTabHover.png", 1
if (ErrorLevel) {
	AppendToLogs("Failed to extract file!"
	.	"`nSource: resources\skins\Dark Blue\CloseTabHover.png"
	.	"`nDest: " PROGRAM.SKINS_FOLDER "\Dark Blue\CloseTabHover.png"
	.	"`nFlag: " 2)
	errorLog .= "`n`n""Failed to extract file!"
	.	"`nSource: resources\skins\Dark Blue\CloseTabHover.png"
	.	"`nDest: " PROGRAM.SKINS_FOLDER "\Dark Blue\CloseTabHover.png"
	.	"`nFlag: " 2
}

; ----------------------------
if !InStr(FileExist(PROGRAM.SKINS_FOLDER "\Dark Blue"), "D")
	FileCreateDir,% PROGRAM.SKINS_FOLDER "\Dark Blue"

if (A_IsCompiled) {
	sourceFileSize := Get_ResourceSize("resources\skins\Dark Blue\CloseTabPress.png")
	FileGetSize, destFileSize, % PROGRAM.SKINS_FOLDER "\Dark Blue\CloseTabPress.png"
}
else {
	FileGetSize, sourceFileSize, resources\skins\Dark Blue\CloseTabPress.png
	FileGetSize, destFileSize, % PROGRAM.SKINS_FOLDER "\Dark Blue\CloseTabPress.png"
}
if (sourceFileSize != destFileSize)
	FileInstall, resources\skins\Dark Blue\CloseTabPress.png, % PROGRAM.SKINS_FOLDER "\Dark Blue\CloseTabPress.png", 1
if (ErrorLevel) {
	AppendToLogs("Failed to extract file!"
	.	"`nSource: resources\skins\Dark Blue\CloseTabPress.png"
	.	"`nDest: " PROGRAM.SKINS_FOLDER "\Dark Blue\CloseTabPress.png"
	.	"`nFlag: " 2)
	errorLog .= "`n`n""Failed to extract file!"
	.	"`nSource: resources\skins\Dark Blue\CloseTabPress.png"
	.	"`nDest: " PROGRAM.SKINS_FOLDER "\Dark Blue\CloseTabPress.png"
	.	"`nFlag: " 2
}

; ----------------------------
if !InStr(FileExist(PROGRAM.SKINS_FOLDER "\Dark Blue"), "D")
	FileCreateDir,% PROGRAM.SKINS_FOLDER "\Dark Blue"

if (A_IsCompiled) {
	sourceFileSize := Get_ResourceSize("resources\skins\Dark Blue\Header.png")
	FileGetSize, destFileSize, % PROGRAM.SKINS_FOLDER "\Dark Blue\Header.png"
}
else {
	FileGetSize, sourceFileSize, resources\skins\Dark Blue\Header.png
	FileGetSize, destFileSize, % PROGRAM.SKINS_FOLDER "\Dark Blue\Header.png"
}
if (sourceFileSize != destFileSize)
	FileInstall, resources\skins\Dark Blue\Header.png, % PROGRAM.SKINS_FOLDER "\Dark Blue\Header.png", 1
if (ErrorLevel) {
	AppendToLogs("Failed to extract file!"
	.	"`nSource: resources\skins\Dark Blue\Header.png"
	.	"`nDest: " PROGRAM.SKINS_FOLDER "\Dark Blue\Header.png"
	.	"`nFlag: " 2)
	errorLog .= "`n`n""Failed to extract file!"
	.	"`nSource: resources\skins\Dark Blue\Header.png"
	.	"`nDest: " PROGRAM.SKINS_FOLDER "\Dark Blue\Header.png"
	.	"`nFlag: " 2
}

; ----------------------------
if !InStr(FileExist(PROGRAM.SKINS_FOLDER "\Dark Blue"), "D")
	FileCreateDir,% PROGRAM.SKINS_FOLDER "\Dark Blue"

if (A_IsCompiled) {
	sourceFileSize := Get_ResourceSize("resources\skins\Dark Blue\HeaderMin.png")
	FileGetSize, destFileSize, % PROGRAM.SKINS_FOLDER "\Dark Blue\HeaderMin.png"
}
else {
	FileGetSize, sourceFileSize, resources\skins\Dark Blue\HeaderMin.png
	FileGetSize, destFileSize, % PROGRAM.SKINS_FOLDER "\Dark Blue\HeaderMin.png"
}
if (sourceFileSize != destFileSize)
	FileInstall, resources\skins\Dark Blue\HeaderMin.png, % PROGRAM.SKINS_FOLDER "\Dark Blue\HeaderMin.png", 1
if (ErrorLevel) {
	AppendToLogs("Failed to extract file!"
	.	"`nSource: resources\skins\Dark Blue\HeaderMin.png"
	.	"`nDest: " PROGRAM.SKINS_FOLDER "\Dark Blue\HeaderMin.png"
	.	"`nFlag: " 2)
	errorLog .= "`n`n""Failed to extract file!"
	.	"`nSource: resources\skins\Dark Blue\HeaderMin.png"
	.	"`nDest: " PROGRAM.SKINS_FOLDER "\Dark Blue\HeaderMin.png"
	.	"`nFlag: " 2
}

; ----------------------------
if !InStr(FileExist(PROGRAM.SKINS_FOLDER "\Dark Blue"), "D")
	FileCreateDir,% PROGRAM.SKINS_FOLDER "\Dark Blue"

if (A_IsCompiled) {
	sourceFileSize := Get_ResourceSize("resources\skins\Dark Blue\Icon.ico")
	FileGetSize, destFileSize, % PROGRAM.SKINS_FOLDER "\Dark Blue\Icon.ico"
}
else {
	FileGetSize, sourceFileSize, resources\skins\Dark Blue\Icon.ico
	FileGetSize, destFileSize, % PROGRAM.SKINS_FOLDER "\Dark Blue\Icon.ico"
}
if (sourceFileSize != destFileSize)
	FileInstall, resources\skins\Dark Blue\Icon.ico, % PROGRAM.SKINS_FOLDER "\Dark Blue\Icon.ico", 1
if (ErrorLevel) {
	AppendToLogs("Failed to extract file!"
	.	"`nSource: resources\skins\Dark Blue\Icon.ico"
	.	"`nDest: " PROGRAM.SKINS_FOLDER "\Dark Blue\Icon.ico"
	.	"`nFlag: " 2)
	errorLog .= "`n`n""Failed to extract file!"
	.	"`nSource: resources\skins\Dark Blue\Icon.ico"
	.	"`nDest: " PROGRAM.SKINS_FOLDER "\Dark Blue\Icon.ico"
	.	"`nFlag: " 2
}

; ----------------------------
if !InStr(FileExist(PROGRAM.SKINS_FOLDER "\Dark Blue"), "D")
	FileCreateDir,% PROGRAM.SKINS_FOLDER "\Dark Blue"

if (A_IsCompiled) {
	sourceFileSize := Get_ResourceSize("resources\skins\Dark Blue\Maximize.png")
	FileGetSize, destFileSize, % PROGRAM.SKINS_FOLDER "\Dark Blue\Maximize.png"
}
else {
	FileGetSize, sourceFileSize, resources\skins\Dark Blue\Maximize.png
	FileGetSize, destFileSize, % PROGRAM.SKINS_FOLDER "\Dark Blue\Maximize.png"
}
if (sourceFileSize != destFileSize)
	FileInstall, resources\skins\Dark Blue\Maximize.png, % PROGRAM.SKINS_FOLDER "\Dark Blue\Maximize.png", 1
if (ErrorLevel) {
	AppendToLogs("Failed to extract file!"
	.	"`nSource: resources\skins\Dark Blue\Maximize.png"
	.	"`nDest: " PROGRAM.SKINS_FOLDER "\Dark Blue\Maximize.png"
	.	"`nFlag: " 2)
	errorLog .= "`n`n""Failed to extract file!"
	.	"`nSource: resources\skins\Dark Blue\Maximize.png"
	.	"`nDest: " PROGRAM.SKINS_FOLDER "\Dark Blue\Maximize.png"
	.	"`nFlag: " 2
}

; ----------------------------
if !InStr(FileExist(PROGRAM.SKINS_FOLDER "\Dark Blue"), "D")
	FileCreateDir,% PROGRAM.SKINS_FOLDER "\Dark Blue"

if (A_IsCompiled) {
	sourceFileSize := Get_ResourceSize("resources\skins\Dark Blue\MaximizeHover.png")
	FileGetSize, destFileSize, % PROGRAM.SKINS_FOLDER "\Dark Blue\MaximizeHover.png"
}
else {
	FileGetSize, sourceFileSize, resources\skins\Dark Blue\MaximizeHover.png
	FileGetSize, destFileSize, % PROGRAM.SKINS_FOLDER "\Dark Blue\MaximizeHover.png"
}
if (sourceFileSize != destFileSize)
	FileInstall, resources\skins\Dark Blue\MaximizeHover.png, % PROGRAM.SKINS_FOLDER "\Dark Blue\MaximizeHover.png", 1
if (ErrorLevel) {
	AppendToLogs("Failed to extract file!"
	.	"`nSource: resources\skins\Dark Blue\MaximizeHover.png"
	.	"`nDest: " PROGRAM.SKINS_FOLDER "\Dark Blue\MaximizeHover.png"
	.	"`nFlag: " 2)
	errorLog .= "`n`n""Failed to extract file!"
	.	"`nSource: resources\skins\Dark Blue\MaximizeHover.png"
	.	"`nDest: " PROGRAM.SKINS_FOLDER "\Dark Blue\MaximizeHover.png"
	.	"`nFlag: " 2
}

; ----------------------------
if !InStr(FileExist(PROGRAM.SKINS_FOLDER "\Dark Blue"), "D")
	FileCreateDir,% PROGRAM.SKINS_FOLDER "\Dark Blue"

if (A_IsCompiled) {
	sourceFileSize := Get_ResourceSize("resources\skins\Dark Blue\MaximizePress.png")
	FileGetSize, destFileSize, % PROGRAM.SKINS_FOLDER "\Dark Blue\MaximizePress.png"
}
else {
	FileGetSize, sourceFileSize, resources\skins\Dark Blue\MaximizePress.png
	FileGetSize, destFileSize, % PROGRAM.SKINS_FOLDER "\Dark Blue\MaximizePress.png"
}
if (sourceFileSize != destFileSize)
	FileInstall, resources\skins\Dark Blue\MaximizePress.png, % PROGRAM.SKINS_FOLDER "\Dark Blue\MaximizePress.png", 1
if (ErrorLevel) {
	AppendToLogs("Failed to extract file!"
	.	"`nSource: resources\skins\Dark Blue\MaximizePress.png"
	.	"`nDest: " PROGRAM.SKINS_FOLDER "\Dark Blue\MaximizePress.png"
	.	"`nFlag: " 2)
	errorLog .= "`n`n""Failed to extract file!"
	.	"`nSource: resources\skins\Dark Blue\MaximizePress.png"
	.	"`nDest: " PROGRAM.SKINS_FOLDER "\Dark Blue\MaximizePress.png"
	.	"`nFlag: " 2
}

; ----------------------------
if !InStr(FileExist(PROGRAM.SKINS_FOLDER "\Dark Blue"), "D")
	FileCreateDir,% PROGRAM.SKINS_FOLDER "\Dark Blue"

if (A_IsCompiled) {
	sourceFileSize := Get_ResourceSize("resources\skins\Dark Blue\Minimize.png")
	FileGetSize, destFileSize, % PROGRAM.SKINS_FOLDER "\Dark Blue\Minimize.png"
}
else {
	FileGetSize, sourceFileSize, resources\skins\Dark Blue\Minimize.png
	FileGetSize, destFileSize, % PROGRAM.SKINS_FOLDER "\Dark Blue\Minimize.png"
}
if (sourceFileSize != destFileSize)
	FileInstall, resources\skins\Dark Blue\Minimize.png, % PROGRAM.SKINS_FOLDER "\Dark Blue\Minimize.png", 1
if (ErrorLevel) {
	AppendToLogs("Failed to extract file!"
	.	"`nSource: resources\skins\Dark Blue\Minimize.png"
	.	"`nDest: " PROGRAM.SKINS_FOLDER "\Dark Blue\Minimize.png"
	.	"`nFlag: " 2)
	errorLog .= "`n`n""Failed to extract file!"
	.	"`nSource: resources\skins\Dark Blue\Minimize.png"
	.	"`nDest: " PROGRAM.SKINS_FOLDER "\Dark Blue\Minimize.png"
	.	"`nFlag: " 2
}

; ----------------------------
if !InStr(FileExist(PROGRAM.SKINS_FOLDER "\Dark Blue"), "D")
	FileCreateDir,% PROGRAM.SKINS_FOLDER "\Dark Blue"

if (A_IsCompiled) {
	sourceFileSize := Get_ResourceSize("resources\skins\Dark Blue\MinimizeHover.png")
	FileGetSize, destFileSize, % PROGRAM.SKINS_FOLDER "\Dark Blue\MinimizeHover.png"
}
else {
	FileGetSize, sourceFileSize, resources\skins\Dark Blue\MinimizeHover.png
	FileGetSize, destFileSize, % PROGRAM.SKINS_FOLDER "\Dark Blue\MinimizeHover.png"
}
if (sourceFileSize != destFileSize)
	FileInstall, resources\skins\Dark Blue\MinimizeHover.png, % PROGRAM.SKINS_FOLDER "\Dark Blue\MinimizeHover.png", 1
if (ErrorLevel) {
	AppendToLogs("Failed to extract file!"
	.	"`nSource: resources\skins\Dark Blue\MinimizeHover.png"
	.	"`nDest: " PROGRAM.SKINS_FOLDER "\Dark Blue\MinimizeHover.png"
	.	"`nFlag: " 2)
	errorLog .= "`n`n""Failed to extract file!"
	.	"`nSource: resources\skins\Dark Blue\MinimizeHover.png"
	.	"`nDest: " PROGRAM.SKINS_FOLDER "\Dark Blue\MinimizeHover.png"
	.	"`nFlag: " 2
}

; ----------------------------
if !InStr(FileExist(PROGRAM.SKINS_FOLDER "\Dark Blue"), "D")
	FileCreateDir,% PROGRAM.SKINS_FOLDER "\Dark Blue"

if (A_IsCompiled) {
	sourceFileSize := Get_ResourceSize("resources\skins\Dark Blue\MinimizePress.png")
	FileGetSize, destFileSize, % PROGRAM.SKINS_FOLDER "\Dark Blue\MinimizePress.png"
}
else {
	FileGetSize, sourceFileSize, resources\skins\Dark Blue\MinimizePress.png
	FileGetSize, destFileSize, % PROGRAM.SKINS_FOLDER "\Dark Blue\MinimizePress.png"
}
if (sourceFileSize != destFileSize)
	FileInstall, resources\skins\Dark Blue\MinimizePress.png, % PROGRAM.SKINS_FOLDER "\Dark Blue\MinimizePress.png", 1
if (ErrorLevel) {
	AppendToLogs("Failed to extract file!"
	.	"`nSource: resources\skins\Dark Blue\MinimizePress.png"
	.	"`nDest: " PROGRAM.SKINS_FOLDER "\Dark Blue\MinimizePress.png"
	.	"`nFlag: " 2)
	errorLog .= "`n`n""Failed to extract file!"
	.	"`nSource: resources\skins\Dark Blue\MinimizePress.png"
	.	"`nDest: " PROGRAM.SKINS_FOLDER "\Dark Blue\MinimizePress.png"
	.	"`nFlag: " 2
}

; ----------------------------
if !InStr(FileExist(PROGRAM.SKINS_FOLDER "\Dark Blue"), "D")
	FileCreateDir,% PROGRAM.SKINS_FOLDER "\Dark Blue"

if (A_IsCompiled) {
	sourceFileSize := Get_ResourceSize("resources\skins\Dark Blue\Preview.png")
	FileGetSize, destFileSize, % PROGRAM.SKINS_FOLDER "\Dark Blue\Preview.png"
}
else {
	FileGetSize, sourceFileSize, resources\skins\Dark Blue\Preview.png
	FileGetSize, destFileSize, % PROGRAM.SKINS_FOLDER "\Dark Blue\Preview.png"
}
if (sourceFileSize != destFileSize)
	FileInstall, resources\skins\Dark Blue\Preview.png, % PROGRAM.SKINS_FOLDER "\Dark Blue\Preview.png", 1
if (ErrorLevel) {
	AppendToLogs("Failed to extract file!"
	.	"`nSource: resources\skins\Dark Blue\Preview.png"
	.	"`nDest: " PROGRAM.SKINS_FOLDER "\Dark Blue\Preview.png"
	.	"`nFlag: " 2)
	errorLog .= "`n`n""Failed to extract file!"
	.	"`nSource: resources\skins\Dark Blue\Preview.png"
	.	"`nDest: " PROGRAM.SKINS_FOLDER "\Dark Blue\Preview.png"
	.	"`nFlag: " 2
}

; ----------------------------
if !InStr(FileExist(PROGRAM.SKINS_FOLDER "\Dark Blue"), "D")
	FileCreateDir,% PROGRAM.SKINS_FOLDER "\Dark Blue"

FileInstall, resources\skins\Dark Blue\Settings.ini, % PROGRAM.SKINS_FOLDER "\Dark Blue\Settings.ini", 1
if (ErrorLevel) {
	AppendToLogs("Failed to extract file!"
	.	"`nSource: resources\skins\Dark Blue\Settings.ini"
	.	"`nDest: " PROGRAM.SKINS_FOLDER "\Dark Blue\Settings.ini"
	.	"`nFlag: " 1)
	errorLog .= "`n`n""Failed to extract file!"
	.	"`nSource: resources\skins\Dark Blue\Settings.ini"
	.	"`nDest: " PROGRAM.SKINS_FOLDER "\Dark Blue\Settings.ini"
	.	"`nFlag: " 1
}

; ----------------------------
if !InStr(FileExist(PROGRAM.SKINS_FOLDER "\Dark Blue"), "D")
	FileCreateDir,% PROGRAM.SKINS_FOLDER "\Dark Blue"

if (A_IsCompiled) {
	sourceFileSize := Get_ResourceSize("resources\skins\Dark Blue\TabActive.png")
	FileGetSize, destFileSize, % PROGRAM.SKINS_FOLDER "\Dark Blue\TabActive.png"
}
else {
	FileGetSize, sourceFileSize, resources\skins\Dark Blue\TabActive.png
	FileGetSize, destFileSize, % PROGRAM.SKINS_FOLDER "\Dark Blue\TabActive.png"
}
if (sourceFileSize != destFileSize)
	FileInstall, resources\skins\Dark Blue\TabActive.png, % PROGRAM.SKINS_FOLDER "\Dark Blue\TabActive.png", 1
if (ErrorLevel) {
	AppendToLogs("Failed to extract file!"
	.	"`nSource: resources\skins\Dark Blue\TabActive.png"
	.	"`nDest: " PROGRAM.SKINS_FOLDER "\Dark Blue\TabActive.png"
	.	"`nFlag: " 2)
	errorLog .= "`n`n""Failed to extract file!"
	.	"`nSource: resources\skins\Dark Blue\TabActive.png"
	.	"`nDest: " PROGRAM.SKINS_FOLDER "\Dark Blue\TabActive.png"
	.	"`nFlag: " 2
}

; ----------------------------
if !InStr(FileExist(PROGRAM.SKINS_FOLDER "\Dark Blue"), "D")
	FileCreateDir,% PROGRAM.SKINS_FOLDER "\Dark Blue"

if (A_IsCompiled) {
	sourceFileSize := Get_ResourceSize("resources\skins\Dark Blue\TabHover.png")
	FileGetSize, destFileSize, % PROGRAM.SKINS_FOLDER "\Dark Blue\TabHover.png"
}
else {
	FileGetSize, sourceFileSize, resources\skins\Dark Blue\TabHover.png
	FileGetSize, destFileSize, % PROGRAM.SKINS_FOLDER "\Dark Blue\TabHover.png"
}
if (sourceFileSize != destFileSize)
	FileInstall, resources\skins\Dark Blue\TabHover.png, % PROGRAM.SKINS_FOLDER "\Dark Blue\TabHover.png", 1
if (ErrorLevel) {
	AppendToLogs("Failed to extract file!"
	.	"`nSource: resources\skins\Dark Blue\TabHover.png"
	.	"`nDest: " PROGRAM.SKINS_FOLDER "\Dark Blue\TabHover.png"
	.	"`nFlag: " 2)
	errorLog .= "`n`n""Failed to extract file!"
	.	"`nSource: resources\skins\Dark Blue\TabHover.png"
	.	"`nDest: " PROGRAM.SKINS_FOLDER "\Dark Blue\TabHover.png"
	.	"`nFlag: " 2
}

; ----------------------------
if !InStr(FileExist(PROGRAM.SKINS_FOLDER "\Dark Blue"), "D")
	FileCreateDir,% PROGRAM.SKINS_FOLDER "\Dark Blue"

if (A_IsCompiled) {
	sourceFileSize := Get_ResourceSize("resources\skins\Dark Blue\TabInactive.png")
	FileGetSize, destFileSize, % PROGRAM.SKINS_FOLDER "\Dark Blue\TabInactive.png"
}
else {
	FileGetSize, sourceFileSize, resources\skins\Dark Blue\TabInactive.png
	FileGetSize, destFileSize, % PROGRAM.SKINS_FOLDER "\Dark Blue\TabInactive.png"
}
if (sourceFileSize != destFileSize)
	FileInstall, resources\skins\Dark Blue\TabInactive.png, % PROGRAM.SKINS_FOLDER "\Dark Blue\TabInactive.png", 1
if (ErrorLevel) {
	AppendToLogs("Failed to extract file!"
	.	"`nSource: resources\skins\Dark Blue\TabInactive.png"
	.	"`nDest: " PROGRAM.SKINS_FOLDER "\Dark Blue\TabInactive.png"
	.	"`nFlag: " 2)
	errorLog .= "`n`n""Failed to extract file!"
	.	"`nSource: resources\skins\Dark Blue\TabInactive.png"
	.	"`nDest: " PROGRAM.SKINS_FOLDER "\Dark Blue\TabInactive.png"
	.	"`nFlag: " 2
}

; ----------------------------
if !InStr(FileExist(PROGRAM.SKINS_FOLDER "\Dark Blue"), "D")
	FileCreateDir,% PROGRAM.SKINS_FOLDER "\Dark Blue"

if (A_IsCompiled) {
	sourceFileSize := Get_ResourceSize("resources\skins\Dark Blue\TabJoinedActive.png")
	FileGetSize, destFileSize, % PROGRAM.SKINS_FOLDER "\Dark Blue\TabJoinedActive.png"
}
else {
	FileGetSize, sourceFileSize, resources\skins\Dark Blue\TabJoinedActive.png
	FileGetSize, destFileSize, % PROGRAM.SKINS_FOLDER "\Dark Blue\TabJoinedActive.png"
}
if (sourceFileSize != destFileSize)
	FileInstall, resources\skins\Dark Blue\TabJoinedActive.png, % PROGRAM.SKINS_FOLDER "\Dark Blue\TabJoinedActive.png", 1
if (ErrorLevel) {
	AppendToLogs("Failed to extract file!"
	.	"`nSource: resources\skins\Dark Blue\TabJoinedActive.png"
	.	"`nDest: " PROGRAM.SKINS_FOLDER "\Dark Blue\TabJoinedActive.png"
	.	"`nFlag: " 2)
	errorLog .= "`n`n""Failed to extract file!"
	.	"`nSource: resources\skins\Dark Blue\TabJoinedActive.png"
	.	"`nDest: " PROGRAM.SKINS_FOLDER "\Dark Blue\TabJoinedActive.png"
	.	"`nFlag: " 2
}

; ----------------------------
if !InStr(FileExist(PROGRAM.SKINS_FOLDER "\Dark Blue"), "D")
	FileCreateDir,% PROGRAM.SKINS_FOLDER "\Dark Blue"

if (A_IsCompiled) {
	sourceFileSize := Get_ResourceSize("resources\skins\Dark Blue\TabJoinedHover.png")
	FileGetSize, destFileSize, % PROGRAM.SKINS_FOLDER "\Dark Blue\TabJoinedHover.png"
}
else {
	FileGetSize, sourceFileSize, resources\skins\Dark Blue\TabJoinedHover.png
	FileGetSize, destFileSize, % PROGRAM.SKINS_FOLDER "\Dark Blue\TabJoinedHover.png"
}
if (sourceFileSize != destFileSize)
	FileInstall, resources\skins\Dark Blue\TabJoinedHover.png, % PROGRAM.SKINS_FOLDER "\Dark Blue\TabJoinedHover.png", 1
if (ErrorLevel) {
	AppendToLogs("Failed to extract file!"
	.	"`nSource: resources\skins\Dark Blue\TabJoinedHover.png"
	.	"`nDest: " PROGRAM.SKINS_FOLDER "\Dark Blue\TabJoinedHover.png"
	.	"`nFlag: " 2)
	errorLog .= "`n`n""Failed to extract file!"
	.	"`nSource: resources\skins\Dark Blue\TabJoinedHover.png"
	.	"`nDest: " PROGRAM.SKINS_FOLDER "\Dark Blue\TabJoinedHover.png"
	.	"`nFlag: " 2
}

; ----------------------------
if !InStr(FileExist(PROGRAM.SKINS_FOLDER "\Dark Blue"), "D")
	FileCreateDir,% PROGRAM.SKINS_FOLDER "\Dark Blue"

if (A_IsCompiled) {
	sourceFileSize := Get_ResourceSize("resources\skins\Dark Blue\TabJoinedInactive.png")
	FileGetSize, destFileSize, % PROGRAM.SKINS_FOLDER "\Dark Blue\TabJoinedInactive.png"
}
else {
	FileGetSize, sourceFileSize, resources\skins\Dark Blue\TabJoinedInactive.png
	FileGetSize, destFileSize, % PROGRAM.SKINS_FOLDER "\Dark Blue\TabJoinedInactive.png"
}
if (sourceFileSize != destFileSize)
	FileInstall, resources\skins\Dark Blue\TabJoinedInactive.png, % PROGRAM.SKINS_FOLDER "\Dark Blue\TabJoinedInactive.png", 1
if (ErrorLevel) {
	AppendToLogs("Failed to extract file!"
	.	"`nSource: resources\skins\Dark Blue\TabJoinedInactive.png"
	.	"`nDest: " PROGRAM.SKINS_FOLDER "\Dark Blue\TabJoinedInactive.png"
	.	"`nFlag: " 2)
	errorLog .= "`n`n""Failed to extract file!"
	.	"`nSource: resources\skins\Dark Blue\TabJoinedInactive.png"
	.	"`nDest: " PROGRAM.SKINS_FOLDER "\Dark Blue\TabJoinedInactive.png"
	.	"`nFlag: " 2
}

; ----------------------------
if !InStr(FileExist(PROGRAM.SKINS_FOLDER "\Dark Blue"), "D")
	FileCreateDir,% PROGRAM.SKINS_FOLDER "\Dark Blue"

if (A_IsCompiled) {
	sourceFileSize := Get_ResourceSize("resources\skins\Dark Blue\TabsBackground.png")
	FileGetSize, destFileSize, % PROGRAM.SKINS_FOLDER "\Dark Blue\TabsBackground.png"
}
else {
	FileGetSize, sourceFileSize, resources\skins\Dark Blue\TabsBackground.png
	FileGetSize, destFileSize, % PROGRAM.SKINS_FOLDER "\Dark Blue\TabsBackground.png"
}
if (sourceFileSize != destFileSize)
	FileInstall, resources\skins\Dark Blue\TabsBackground.png, % PROGRAM.SKINS_FOLDER "\Dark Blue\TabsBackground.png", 1
if (ErrorLevel) {
	AppendToLogs("Failed to extract file!"
	.	"`nSource: resources\skins\Dark Blue\TabsBackground.png"
	.	"`nDest: " PROGRAM.SKINS_FOLDER "\Dark Blue\TabsBackground.png"
	.	"`nFlag: " 2)
	errorLog .= "`n`n""Failed to extract file!"
	.	"`nSource: resources\skins\Dark Blue\TabsBackground.png"
	.	"`nDest: " PROGRAM.SKINS_FOLDER "\Dark Blue\TabsBackground.png"
	.	"`nFlag: " 2
}

; ----------------------------
if !InStr(FileExist(PROGRAM.SKINS_FOLDER "\Dark Blue"), "D")
	FileCreateDir,% PROGRAM.SKINS_FOLDER "\Dark Blue"

if (A_IsCompiled) {
	sourceFileSize := Get_ResourceSize("resources\skins\Dark Blue\TabWhisperActive.png")
	FileGetSize, destFileSize, % PROGRAM.SKINS_FOLDER "\Dark Blue\TabWhisperActive.png"
}
else {
	FileGetSize, sourceFileSize, resources\skins\Dark Blue\TabWhisperActive.png
	FileGetSize, destFileSize, % PROGRAM.SKINS_FOLDER "\Dark Blue\TabWhisperActive.png"
}
if (sourceFileSize != destFileSize)
	FileInstall, resources\skins\Dark Blue\TabWhisperActive.png, % PROGRAM.SKINS_FOLDER "\Dark Blue\TabWhisperActive.png", 1
if (ErrorLevel) {
	AppendToLogs("Failed to extract file!"
	.	"`nSource: resources\skins\Dark Blue\TabWhisperActive.png"
	.	"`nDest: " PROGRAM.SKINS_FOLDER "\Dark Blue\TabWhisperActive.png"
	.	"`nFlag: " 2)
	errorLog .= "`n`n""Failed to extract file!"
	.	"`nSource: resources\skins\Dark Blue\TabWhisperActive.png"
	.	"`nDest: " PROGRAM.SKINS_FOLDER "\Dark Blue\TabWhisperActive.png"
	.	"`nFlag: " 2
}

; ----------------------------
if !InStr(FileExist(PROGRAM.SKINS_FOLDER "\Dark Blue"), "D")
	FileCreateDir,% PROGRAM.SKINS_FOLDER "\Dark Blue"

if (A_IsCompiled) {
	sourceFileSize := Get_ResourceSize("resources\skins\Dark Blue\TabWhisperHover.png")
	FileGetSize, destFileSize, % PROGRAM.SKINS_FOLDER "\Dark Blue\TabWhisperHover.png"
}
else {
	FileGetSize, sourceFileSize, resources\skins\Dark Blue\TabWhisperHover.png
	FileGetSize, destFileSize, % PROGRAM.SKINS_FOLDER "\Dark Blue\TabWhisperHover.png"
}
if (sourceFileSize != destFileSize)
	FileInstall, resources\skins\Dark Blue\TabWhisperHover.png, % PROGRAM.SKINS_FOLDER "\Dark Blue\TabWhisperHover.png", 1
if (ErrorLevel) {
	AppendToLogs("Failed to extract file!"
	.	"`nSource: resources\skins\Dark Blue\TabWhisperHover.png"
	.	"`nDest: " PROGRAM.SKINS_FOLDER "\Dark Blue\TabWhisperHover.png"
	.	"`nFlag: " 2)
	errorLog .= "`n`n""Failed to extract file!"
	.	"`nSource: resources\skins\Dark Blue\TabWhisperHover.png"
	.	"`nDest: " PROGRAM.SKINS_FOLDER "\Dark Blue\TabWhisperHover.png"
	.	"`nFlag: " 2
}

; ----------------------------
if !InStr(FileExist(PROGRAM.SKINS_FOLDER "\Dark Blue"), "D")
	FileCreateDir,% PROGRAM.SKINS_FOLDER "\Dark Blue"

if (A_IsCompiled) {
	sourceFileSize := Get_ResourceSize("resources\skins\Dark Blue\TabWhisperInactive.png")
	FileGetSize, destFileSize, % PROGRAM.SKINS_FOLDER "\Dark Blue\TabWhisperInactive.png"
}
else {
	FileGetSize, sourceFileSize, resources\skins\Dark Blue\TabWhisperInactive.png
	FileGetSize, destFileSize, % PROGRAM.SKINS_FOLDER "\Dark Blue\TabWhisperInactive.png"
}
if (sourceFileSize != destFileSize)
	FileInstall, resources\skins\Dark Blue\TabWhisperInactive.png, % PROGRAM.SKINS_FOLDER "\Dark Blue\TabWhisperInactive.png", 1
if (ErrorLevel) {
	AppendToLogs("Failed to extract file!"
	.	"`nSource: resources\skins\Dark Blue\TabWhisperInactive.png"
	.	"`nDest: " PROGRAM.SKINS_FOLDER "\Dark Blue\TabWhisperInactive.png"
	.	"`nFlag: " 2)
	errorLog .= "`n`n""Failed to extract file!"
	.	"`nSource: resources\skins\Dark Blue\TabWhisperInactive.png"
	.	"`nDest: " PROGRAM.SKINS_FOLDER "\Dark Blue\TabWhisperInactive.png"
	.	"`nFlag: " 2
}

; ----------------------------
if !InStr(FileExist(PROGRAM.SKINS_FOLDER "\Dark Blue"), "D")
	FileCreateDir,% PROGRAM.SKINS_FOLDER "\Dark Blue"

if (A_IsCompiled) {
	sourceFileSize := Get_ResourceSize("resources\skins\Dark Blue\TradeVerifyGreen.png")
	FileGetSize, destFileSize, % PROGRAM.SKINS_FOLDER "\Dark Blue\TradeVerifyGreen.png"
}
else {
	FileGetSize, sourceFileSize, resources\skins\Dark Blue\TradeVerifyGreen.png
	FileGetSize, destFileSize, % PROGRAM.SKINS_FOLDER "\Dark Blue\TradeVerifyGreen.png"
}
if (sourceFileSize != destFileSize)
	FileInstall, resources\skins\Dark Blue\TradeVerifyGreen.png, % PROGRAM.SKINS_FOLDER "\Dark Blue\TradeVerifyGreen.png", 1
if (ErrorLevel) {
	AppendToLogs("Failed to extract file!"
	.	"`nSource: resources\skins\Dark Blue\TradeVerifyGreen.png"
	.	"`nDest: " PROGRAM.SKINS_FOLDER "\Dark Blue\TradeVerifyGreen.png"
	.	"`nFlag: " 2)
	errorLog .= "`n`n""Failed to extract file!"
	.	"`nSource: resources\skins\Dark Blue\TradeVerifyGreen.png"
	.	"`nDest: " PROGRAM.SKINS_FOLDER "\Dark Blue\TradeVerifyGreen.png"
	.	"`nFlag: " 2
}

; ----------------------------
if !InStr(FileExist(PROGRAM.SKINS_FOLDER "\Dark Blue"), "D")
	FileCreateDir,% PROGRAM.SKINS_FOLDER "\Dark Blue"

if (A_IsCompiled) {
	sourceFileSize := Get_ResourceSize("resources\skins\Dark Blue\TradeVerifyGrey.png")
	FileGetSize, destFileSize, % PROGRAM.SKINS_FOLDER "\Dark Blue\TradeVerifyGrey.png"
}
else {
	FileGetSize, sourceFileSize, resources\skins\Dark Blue\TradeVerifyGrey.png
	FileGetSize, destFileSize, % PROGRAM.SKINS_FOLDER "\Dark Blue\TradeVerifyGrey.png"
}
if (sourceFileSize != destFileSize)
	FileInstall, resources\skins\Dark Blue\TradeVerifyGrey.png, % PROGRAM.SKINS_FOLDER "\Dark Blue\TradeVerifyGrey.png", 1
if (ErrorLevel) {
	AppendToLogs("Failed to extract file!"
	.	"`nSource: resources\skins\Dark Blue\TradeVerifyGrey.png"
	.	"`nDest: " PROGRAM.SKINS_FOLDER "\Dark Blue\TradeVerifyGrey.png"
	.	"`nFlag: " 2)
	errorLog .= "`n`n""Failed to extract file!"
	.	"`nSource: resources\skins\Dark Blue\TradeVerifyGrey.png"
	.	"`nDest: " PROGRAM.SKINS_FOLDER "\Dark Blue\TradeVerifyGrey.png"
	.	"`nFlag: " 2
}

; ----------------------------
if !InStr(FileExist(PROGRAM.SKINS_FOLDER "\Dark Blue"), "D")
	FileCreateDir,% PROGRAM.SKINS_FOLDER "\Dark Blue"

if (A_IsCompiled) {
	sourceFileSize := Get_ResourceSize("resources\skins\Dark Blue\TradeVerifyOrange.png")
	FileGetSize, destFileSize, % PROGRAM.SKINS_FOLDER "\Dark Blue\TradeVerifyOrange.png"
}
else {
	FileGetSize, sourceFileSize, resources\skins\Dark Blue\TradeVerifyOrange.png
	FileGetSize, destFileSize, % PROGRAM.SKINS_FOLDER "\Dark Blue\TradeVerifyOrange.png"
}
if (sourceFileSize != destFileSize)
	FileInstall, resources\skins\Dark Blue\TradeVerifyOrange.png, % PROGRAM.SKINS_FOLDER "\Dark Blue\TradeVerifyOrange.png", 1
if (ErrorLevel) {
	AppendToLogs("Failed to extract file!"
	.	"`nSource: resources\skins\Dark Blue\TradeVerifyOrange.png"
	.	"`nDest: " PROGRAM.SKINS_FOLDER "\Dark Blue\TradeVerifyOrange.png"
	.	"`nFlag: " 2)
	errorLog .= "`n`n""Failed to extract file!"
	.	"`nSource: resources\skins\Dark Blue\TradeVerifyOrange.png"
	.	"`nDest: " PROGRAM.SKINS_FOLDER "\Dark Blue\TradeVerifyOrange.png"
	.	"`nFlag: " 2
}

; ----------------------------
if !InStr(FileExist(PROGRAM.SKINS_FOLDER "\Dark Blue"), "D")
	FileCreateDir,% PROGRAM.SKINS_FOLDER "\Dark Blue"

if (A_IsCompiled) {
	sourceFileSize := Get_ResourceSize("resources\skins\Dark Blue\TradeVerifyRed.png")
	FileGetSize, destFileSize, % PROGRAM.SKINS_FOLDER "\Dark Blue\TradeVerifyRed.png"
}
else {
	FileGetSize, sourceFileSize, resources\skins\Dark Blue\TradeVerifyRed.png
	FileGetSize, destFileSize, % PROGRAM.SKINS_FOLDER "\Dark Blue\TradeVerifyRed.png"
}
if (sourceFileSize != destFileSize)
	FileInstall, resources\skins\Dark Blue\TradeVerifyRed.png, % PROGRAM.SKINS_FOLDER "\Dark Blue\TradeVerifyRed.png", 1
if (ErrorLevel) {
	AppendToLogs("Failed to extract file!"
	.	"`nSource: resources\skins\Dark Blue\TradeVerifyRed.png"
	.	"`nDest: " PROGRAM.SKINS_FOLDER "\Dark Blue\TradeVerifyRed.png"
	.	"`nFlag: " 2)
	errorLog .= "`n`n""Failed to extract file!"
	.	"`nSource: resources\skins\Dark Blue\TradeVerifyRed.png"
	.	"`nDest: " PROGRAM.SKINS_FOLDER "\Dark Blue\TradeVerifyRed.png"
	.	"`nFlag: " 2
}

; ----------------------------
if !InStr(FileExist(PROGRAM.SKINS_FOLDER "\Dark Blue\Compact"), "D")
	FileCreateDir,% PROGRAM.SKINS_FOLDER "\Dark Blue\Compact"

if (A_IsCompiled) {
	sourceFileSize := Get_ResourceSize("resources\skins\Dark Blue\Compact\ArrowLeft.png")
	FileGetSize, destFileSize, % PROGRAM.SKINS_FOLDER "\Dark Blue\Compact\ArrowLeft.png"
}
else {
	FileGetSize, sourceFileSize, resources\skins\Dark Blue\Compact\ArrowLeft.png
	FileGetSize, destFileSize, % PROGRAM.SKINS_FOLDER "\Dark Blue\Compact\ArrowLeft.png"
}
if (sourceFileSize != destFileSize)
	FileInstall, resources\skins\Dark Blue\Compact\ArrowLeft.png, % PROGRAM.SKINS_FOLDER "\Dark Blue\Compact\ArrowLeft.png", 1
if (ErrorLevel) {
	AppendToLogs("Failed to extract file!"
	.	"`nSource: resources\skins\Dark Blue\Compact\ArrowLeft.png"
	.	"`nDest: " PROGRAM.SKINS_FOLDER "\Dark Blue\Compact\ArrowLeft.png"
	.	"`nFlag: " 2)
	errorLog .= "`n`n""Failed to extract file!"
	.	"`nSource: resources\skins\Dark Blue\Compact\ArrowLeft.png"
	.	"`nDest: " PROGRAM.SKINS_FOLDER "\Dark Blue\Compact\ArrowLeft.png"
	.	"`nFlag: " 2
}

; ----------------------------
if !InStr(FileExist(PROGRAM.SKINS_FOLDER "\Dark Blue\Compact"), "D")
	FileCreateDir,% PROGRAM.SKINS_FOLDER "\Dark Blue\Compact"

if (A_IsCompiled) {
	sourceFileSize := Get_ResourceSize("resources\skins\Dark Blue\Compact\ArrowLeftHover.png")
	FileGetSize, destFileSize, % PROGRAM.SKINS_FOLDER "\Dark Blue\Compact\ArrowLeftHover.png"
}
else {
	FileGetSize, sourceFileSize, resources\skins\Dark Blue\Compact\ArrowLeftHover.png
	FileGetSize, destFileSize, % PROGRAM.SKINS_FOLDER "\Dark Blue\Compact\ArrowLeftHover.png"
}
if (sourceFileSize != destFileSize)
	FileInstall, resources\skins\Dark Blue\Compact\ArrowLeftHover.png, % PROGRAM.SKINS_FOLDER "\Dark Blue\Compact\ArrowLeftHover.png", 1
if (ErrorLevel) {
	AppendToLogs("Failed to extract file!"
	.	"`nSource: resources\skins\Dark Blue\Compact\ArrowLeftHover.png"
	.	"`nDest: " PROGRAM.SKINS_FOLDER "\Dark Blue\Compact\ArrowLeftHover.png"
	.	"`nFlag: " 2)
	errorLog .= "`n`n""Failed to extract file!"
	.	"`nSource: resources\skins\Dark Blue\Compact\ArrowLeftHover.png"
	.	"`nDest: " PROGRAM.SKINS_FOLDER "\Dark Blue\Compact\ArrowLeftHover.png"
	.	"`nFlag: " 2
}

; ----------------------------
if !InStr(FileExist(PROGRAM.SKINS_FOLDER "\Dark Blue\Compact"), "D")
	FileCreateDir,% PROGRAM.SKINS_FOLDER "\Dark Blue\Compact"

if (A_IsCompiled) {
	sourceFileSize := Get_ResourceSize("resources\skins\Dark Blue\Compact\ArrowLeftPress.png")
	FileGetSize, destFileSize, % PROGRAM.SKINS_FOLDER "\Dark Blue\Compact\ArrowLeftPress.png"
}
else {
	FileGetSize, sourceFileSize, resources\skins\Dark Blue\Compact\ArrowLeftPress.png
	FileGetSize, destFileSize, % PROGRAM.SKINS_FOLDER "\Dark Blue\Compact\ArrowLeftPress.png"
}
if (sourceFileSize != destFileSize)
	FileInstall, resources\skins\Dark Blue\Compact\ArrowLeftPress.png, % PROGRAM.SKINS_FOLDER "\Dark Blue\Compact\ArrowLeftPress.png", 1
if (ErrorLevel) {
	AppendToLogs("Failed to extract file!"
	.	"`nSource: resources\skins\Dark Blue\Compact\ArrowLeftPress.png"
	.	"`nDest: " PROGRAM.SKINS_FOLDER "\Dark Blue\Compact\ArrowLeftPress.png"
	.	"`nFlag: " 2)
	errorLog .= "`n`n""Failed to extract file!"
	.	"`nSource: resources\skins\Dark Blue\Compact\ArrowLeftPress.png"
	.	"`nDest: " PROGRAM.SKINS_FOLDER "\Dark Blue\Compact\ArrowLeftPress.png"
	.	"`nFlag: " 2
}

; ----------------------------
if !InStr(FileExist(PROGRAM.SKINS_FOLDER "\Dark Blue\Compact"), "D")
	FileCreateDir,% PROGRAM.SKINS_FOLDER "\Dark Blue\Compact"

if (A_IsCompiled) {
	sourceFileSize := Get_ResourceSize("resources\skins\Dark Blue\Compact\ArrowRight.png")
	FileGetSize, destFileSize, % PROGRAM.SKINS_FOLDER "\Dark Blue\Compact\ArrowRight.png"
}
else {
	FileGetSize, sourceFileSize, resources\skins\Dark Blue\Compact\ArrowRight.png
	FileGetSize, destFileSize, % PROGRAM.SKINS_FOLDER "\Dark Blue\Compact\ArrowRight.png"
}
if (sourceFileSize != destFileSize)
	FileInstall, resources\skins\Dark Blue\Compact\ArrowRight.png, % PROGRAM.SKINS_FOLDER "\Dark Blue\Compact\ArrowRight.png", 1
if (ErrorLevel) {
	AppendToLogs("Failed to extract file!"
	.	"`nSource: resources\skins\Dark Blue\Compact\ArrowRight.png"
	.	"`nDest: " PROGRAM.SKINS_FOLDER "\Dark Blue\Compact\ArrowRight.png"
	.	"`nFlag: " 2)
	errorLog .= "`n`n""Failed to extract file!"
	.	"`nSource: resources\skins\Dark Blue\Compact\ArrowRight.png"
	.	"`nDest: " PROGRAM.SKINS_FOLDER "\Dark Blue\Compact\ArrowRight.png"
	.	"`nFlag: " 2
}

; ----------------------------
if !InStr(FileExist(PROGRAM.SKINS_FOLDER "\Dark Blue\Compact"), "D")
	FileCreateDir,% PROGRAM.SKINS_FOLDER "\Dark Blue\Compact"

if (A_IsCompiled) {
	sourceFileSize := Get_ResourceSize("resources\skins\Dark Blue\Compact\ArrowRightHover.png")
	FileGetSize, destFileSize, % PROGRAM.SKINS_FOLDER "\Dark Blue\Compact\ArrowRightHover.png"
}
else {
	FileGetSize, sourceFileSize, resources\skins\Dark Blue\Compact\ArrowRightHover.png
	FileGetSize, destFileSize, % PROGRAM.SKINS_FOLDER "\Dark Blue\Compact\ArrowRightHover.png"
}
if (sourceFileSize != destFileSize)
	FileInstall, resources\skins\Dark Blue\Compact\ArrowRightHover.png, % PROGRAM.SKINS_FOLDER "\Dark Blue\Compact\ArrowRightHover.png", 1
if (ErrorLevel) {
	AppendToLogs("Failed to extract file!"
	.	"`nSource: resources\skins\Dark Blue\Compact\ArrowRightHover.png"
	.	"`nDest: " PROGRAM.SKINS_FOLDER "\Dark Blue\Compact\ArrowRightHover.png"
	.	"`nFlag: " 2)
	errorLog .= "`n`n""Failed to extract file!"
	.	"`nSource: resources\skins\Dark Blue\Compact\ArrowRightHover.png"
	.	"`nDest: " PROGRAM.SKINS_FOLDER "\Dark Blue\Compact\ArrowRightHover.png"
	.	"`nFlag: " 2
}

; ----------------------------
if !InStr(FileExist(PROGRAM.SKINS_FOLDER "\Dark Blue\Compact"), "D")
	FileCreateDir,% PROGRAM.SKINS_FOLDER "\Dark Blue\Compact"

if (A_IsCompiled) {
	sourceFileSize := Get_ResourceSize("resources\skins\Dark Blue\Compact\ArrowRightPress.png")
	FileGetSize, destFileSize, % PROGRAM.SKINS_FOLDER "\Dark Blue\Compact\ArrowRightPress.png"
}
else {
	FileGetSize, sourceFileSize, resources\skins\Dark Blue\Compact\ArrowRightPress.png
	FileGetSize, destFileSize, % PROGRAM.SKINS_FOLDER "\Dark Blue\Compact\ArrowRightPress.png"
}
if (sourceFileSize != destFileSize)
	FileInstall, resources\skins\Dark Blue\Compact\ArrowRightPress.png, % PROGRAM.SKINS_FOLDER "\Dark Blue\Compact\ArrowRightPress.png", 1
if (ErrorLevel) {
	AppendToLogs("Failed to extract file!"
	.	"`nSource: resources\skins\Dark Blue\Compact\ArrowRightPress.png"
	.	"`nDest: " PROGRAM.SKINS_FOLDER "\Dark Blue\Compact\ArrowRightPress.png"
	.	"`nFlag: " 2)
	errorLog .= "`n`n""Failed to extract file!"
	.	"`nSource: resources\skins\Dark Blue\Compact\ArrowRightPress.png"
	.	"`nDest: " PROGRAM.SKINS_FOLDER "\Dark Blue\Compact\ArrowRightPress.png"
	.	"`nFlag: " 2
}

; ----------------------------
if !InStr(FileExist(PROGRAM.SKINS_FOLDER "\Dark Blue\Compact"), "D")
	FileCreateDir,% PROGRAM.SKINS_FOLDER "\Dark Blue\Compact"

FileInstall, resources\skins\Dark Blue\Compact\Assets.ini, % PROGRAM.SKINS_FOLDER "\Dark Blue\Compact\Assets.ini", 1
if (ErrorLevel) {
	AppendToLogs("Failed to extract file!"
	.	"`nSource: resources\skins\Dark Blue\Compact\Assets.ini"
	.	"`nDest: " PROGRAM.SKINS_FOLDER "\Dark Blue\Compact\Assets.ini"
	.	"`nFlag: " 1)
	errorLog .= "`n`n""Failed to extract file!"
	.	"`nSource: resources\skins\Dark Blue\Compact\Assets.ini"
	.	"`nDest: " PROGRAM.SKINS_FOLDER "\Dark Blue\Compact\Assets.ini"
	.	"`nFlag: " 1
}

; ----------------------------
if !InStr(FileExist(PROGRAM.SKINS_FOLDER "\Dark Blue\Compact"), "D")
	FileCreateDir,% PROGRAM.SKINS_FOLDER "\Dark Blue\Compact"

if (A_IsCompiled) {
	sourceFileSize := Get_ResourceSize("resources\skins\Dark Blue\Compact\Background.png")
	FileGetSize, destFileSize, % PROGRAM.SKINS_FOLDER "\Dark Blue\Compact\Background.png"
}
else {
	FileGetSize, sourceFileSize, resources\skins\Dark Blue\Compact\Background.png
	FileGetSize, destFileSize, % PROGRAM.SKINS_FOLDER "\Dark Blue\Compact\Background.png"
}
if (sourceFileSize != destFileSize)
	FileInstall, resources\skins\Dark Blue\Compact\Background.png, % PROGRAM.SKINS_FOLDER "\Dark Blue\Compact\Background.png", 1
if (ErrorLevel) {
	AppendToLogs("Failed to extract file!"
	.	"`nSource: resources\skins\Dark Blue\Compact\Background.png"
	.	"`nDest: " PROGRAM.SKINS_FOLDER "\Dark Blue\Compact\Background.png"
	.	"`nFlag: " 2)
	errorLog .= "`n`n""Failed to extract file!"
	.	"`nSource: resources\skins\Dark Blue\Compact\Background.png"
	.	"`nDest: " PROGRAM.SKINS_FOLDER "\Dark Blue\Compact\Background.png"
	.	"`nFlag: " 2
}

; ----------------------------
if !InStr(FileExist(PROGRAM.SKINS_FOLDER "\Dark Blue\Compact"), "D")
	FileCreateDir,% PROGRAM.SKINS_FOLDER "\Dark Blue\Compact"

if (A_IsCompiled) {
	sourceFileSize := Get_ResourceSize("resources\skins\Dark Blue\Compact\ButtonHideout.png")
	FileGetSize, destFileSize, % PROGRAM.SKINS_FOLDER "\Dark Blue\Compact\ButtonHideout.png"
}
else {
	FileGetSize, sourceFileSize, resources\skins\Dark Blue\Compact\ButtonHideout.png
	FileGetSize, destFileSize, % PROGRAM.SKINS_FOLDER "\Dark Blue\Compact\ButtonHideout.png"
}
if (sourceFileSize != destFileSize)
	FileInstall, resources\skins\Dark Blue\Compact\ButtonHideout.png, % PROGRAM.SKINS_FOLDER "\Dark Blue\Compact\ButtonHideout.png", 1
if (ErrorLevel) {
	AppendToLogs("Failed to extract file!"
	.	"`nSource: resources\skins\Dark Blue\Compact\ButtonHideout.png"
	.	"`nDest: " PROGRAM.SKINS_FOLDER "\Dark Blue\Compact\ButtonHideout.png"
	.	"`nFlag: " 2)
	errorLog .= "`n`n""Failed to extract file!"
	.	"`nSource: resources\skins\Dark Blue\Compact\ButtonHideout.png"
	.	"`nDest: " PROGRAM.SKINS_FOLDER "\Dark Blue\Compact\ButtonHideout.png"
	.	"`nFlag: " 2
}

; ----------------------------
if !InStr(FileExist(PROGRAM.SKINS_FOLDER "\Dark Blue\Compact"), "D")
	FileCreateDir,% PROGRAM.SKINS_FOLDER "\Dark Blue\Compact"

if (A_IsCompiled) {
	sourceFileSize := Get_ResourceSize("resources\skins\Dark Blue\Compact\ButtonHideoutHover.png")
	FileGetSize, destFileSize, % PROGRAM.SKINS_FOLDER "\Dark Blue\Compact\ButtonHideoutHover.png"
}
else {
	FileGetSize, sourceFileSize, resources\skins\Dark Blue\Compact\ButtonHideoutHover.png
	FileGetSize, destFileSize, % PROGRAM.SKINS_FOLDER "\Dark Blue\Compact\ButtonHideoutHover.png"
}
if (sourceFileSize != destFileSize)
	FileInstall, resources\skins\Dark Blue\Compact\ButtonHideoutHover.png, % PROGRAM.SKINS_FOLDER "\Dark Blue\Compact\ButtonHideoutHover.png", 1
if (ErrorLevel) {
	AppendToLogs("Failed to extract file!"
	.	"`nSource: resources\skins\Dark Blue\Compact\ButtonHideoutHover.png"
	.	"`nDest: " PROGRAM.SKINS_FOLDER "\Dark Blue\Compact\ButtonHideoutHover.png"
	.	"`nFlag: " 2)
	errorLog .= "`n`n""Failed to extract file!"
	.	"`nSource: resources\skins\Dark Blue\Compact\ButtonHideoutHover.png"
	.	"`nDest: " PROGRAM.SKINS_FOLDER "\Dark Blue\Compact\ButtonHideoutHover.png"
	.	"`nFlag: " 2
}

; ----------------------------
if !InStr(FileExist(PROGRAM.SKINS_FOLDER "\Dark Blue\Compact"), "D")
	FileCreateDir,% PROGRAM.SKINS_FOLDER "\Dark Blue\Compact"

if (A_IsCompiled) {
	sourceFileSize := Get_ResourceSize("resources\skins\Dark Blue\Compact\ButtonHideoutPress.png")
	FileGetSize, destFileSize, % PROGRAM.SKINS_FOLDER "\Dark Blue\Compact\ButtonHideoutPress.png"
}
else {
	FileGetSize, sourceFileSize, resources\skins\Dark Blue\Compact\ButtonHideoutPress.png
	FileGetSize, destFileSize, % PROGRAM.SKINS_FOLDER "\Dark Blue\Compact\ButtonHideoutPress.png"
}
if (sourceFileSize != destFileSize)
	FileInstall, resources\skins\Dark Blue\Compact\ButtonHideoutPress.png, % PROGRAM.SKINS_FOLDER "\Dark Blue\Compact\ButtonHideoutPress.png", 1
if (ErrorLevel) {
	AppendToLogs("Failed to extract file!"
	.	"`nSource: resources\skins\Dark Blue\Compact\ButtonHideoutPress.png"
	.	"`nDest: " PROGRAM.SKINS_FOLDER "\Dark Blue\Compact\ButtonHideoutPress.png"
	.	"`nFlag: " 2)
	errorLog .= "`n`n""Failed to extract file!"
	.	"`nSource: resources\skins\Dark Blue\Compact\ButtonHideoutPress.png"
	.	"`nDest: " PROGRAM.SKINS_FOLDER "\Dark Blue\Compact\ButtonHideoutPress.png"
	.	"`nFlag: " 2
}

; ----------------------------
if !InStr(FileExist(PROGRAM.SKINS_FOLDER "\Dark Blue\Compact"), "D")
	FileCreateDir,% PROGRAM.SKINS_FOLDER "\Dark Blue\Compact"

if (A_IsCompiled) {
	sourceFileSize := Get_ResourceSize("resources\skins\Dark Blue\Compact\ButtonKick.png")
	FileGetSize, destFileSize, % PROGRAM.SKINS_FOLDER "\Dark Blue\Compact\ButtonKick.png"
}
else {
	FileGetSize, sourceFileSize, resources\skins\Dark Blue\Compact\ButtonKick.png
	FileGetSize, destFileSize, % PROGRAM.SKINS_FOLDER "\Dark Blue\Compact\ButtonKick.png"
}
if (sourceFileSize != destFileSize)
	FileInstall, resources\skins\Dark Blue\Compact\ButtonKick.png, % PROGRAM.SKINS_FOLDER "\Dark Blue\Compact\ButtonKick.png", 1
if (ErrorLevel) {
	AppendToLogs("Failed to extract file!"
	.	"`nSource: resources\skins\Dark Blue\Compact\ButtonKick.png"
	.	"`nDest: " PROGRAM.SKINS_FOLDER "\Dark Blue\Compact\ButtonKick.png"
	.	"`nFlag: " 2)
	errorLog .= "`n`n""Failed to extract file!"
	.	"`nSource: resources\skins\Dark Blue\Compact\ButtonKick.png"
	.	"`nDest: " PROGRAM.SKINS_FOLDER "\Dark Blue\Compact\ButtonKick.png"
	.	"`nFlag: " 2
}

; ----------------------------
if !InStr(FileExist(PROGRAM.SKINS_FOLDER "\Dark Blue\Compact"), "D")
	FileCreateDir,% PROGRAM.SKINS_FOLDER "\Dark Blue\Compact"

if (A_IsCompiled) {
	sourceFileSize := Get_ResourceSize("resources\skins\Dark Blue\Compact\ButtonKickHover.png")
	FileGetSize, destFileSize, % PROGRAM.SKINS_FOLDER "\Dark Blue\Compact\ButtonKickHover.png"
}
else {
	FileGetSize, sourceFileSize, resources\skins\Dark Blue\Compact\ButtonKickHover.png
	FileGetSize, destFileSize, % PROGRAM.SKINS_FOLDER "\Dark Blue\Compact\ButtonKickHover.png"
}
if (sourceFileSize != destFileSize)
	FileInstall, resources\skins\Dark Blue\Compact\ButtonKickHover.png, % PROGRAM.SKINS_FOLDER "\Dark Blue\Compact\ButtonKickHover.png", 1
if (ErrorLevel) {
	AppendToLogs("Failed to extract file!"
	.	"`nSource: resources\skins\Dark Blue\Compact\ButtonKickHover.png"
	.	"`nDest: " PROGRAM.SKINS_FOLDER "\Dark Blue\Compact\ButtonKickHover.png"
	.	"`nFlag: " 2)
	errorLog .= "`n`n""Failed to extract file!"
	.	"`nSource: resources\skins\Dark Blue\Compact\ButtonKickHover.png"
	.	"`nDest: " PROGRAM.SKINS_FOLDER "\Dark Blue\Compact\ButtonKickHover.png"
	.	"`nFlag: " 2
}

; ----------------------------
if !InStr(FileExist(PROGRAM.SKINS_FOLDER "\Dark Blue\Compact"), "D")
	FileCreateDir,% PROGRAM.SKINS_FOLDER "\Dark Blue\Compact"

if (A_IsCompiled) {
	sourceFileSize := Get_ResourceSize("resources\skins\Dark Blue\Compact\ButtonKickPress.png")
	FileGetSize, destFileSize, % PROGRAM.SKINS_FOLDER "\Dark Blue\Compact\ButtonKickPress.png"
}
else {
	FileGetSize, sourceFileSize, resources\skins\Dark Blue\Compact\ButtonKickPress.png
	FileGetSize, destFileSize, % PROGRAM.SKINS_FOLDER "\Dark Blue\Compact\ButtonKickPress.png"
}
if (sourceFileSize != destFileSize)
	FileInstall, resources\skins\Dark Blue\Compact\ButtonKickPress.png, % PROGRAM.SKINS_FOLDER "\Dark Blue\Compact\ButtonKickPress.png", 1
if (ErrorLevel) {
	AppendToLogs("Failed to extract file!"
	.	"`nSource: resources\skins\Dark Blue\Compact\ButtonKickPress.png"
	.	"`nDest: " PROGRAM.SKINS_FOLDER "\Dark Blue\Compact\ButtonKickPress.png"
	.	"`nFlag: " 2)
	errorLog .= "`n`n""Failed to extract file!"
	.	"`nSource: resources\skins\Dark Blue\Compact\ButtonKickPress.png"
	.	"`nDest: " PROGRAM.SKINS_FOLDER "\Dark Blue\Compact\ButtonKickPress.png"
	.	"`nFlag: " 2
}

; ----------------------------
if !InStr(FileExist(PROGRAM.SKINS_FOLDER "\Dark Blue\Compact"), "D")
	FileCreateDir,% PROGRAM.SKINS_FOLDER "\Dark Blue\Compact"

if (A_IsCompiled) {
	sourceFileSize := Get_ResourceSize("resources\skins\Dark Blue\Compact\ButtonThanks.png")
	FileGetSize, destFileSize, % PROGRAM.SKINS_FOLDER "\Dark Blue\Compact\ButtonThanks.png"
}
else {
	FileGetSize, sourceFileSize, resources\skins\Dark Blue\Compact\ButtonThanks.png
	FileGetSize, destFileSize, % PROGRAM.SKINS_FOLDER "\Dark Blue\Compact\ButtonThanks.png"
}
if (sourceFileSize != destFileSize)
	FileInstall, resources\skins\Dark Blue\Compact\ButtonThanks.png, % PROGRAM.SKINS_FOLDER "\Dark Blue\Compact\ButtonThanks.png", 1
if (ErrorLevel) {
	AppendToLogs("Failed to extract file!"
	.	"`nSource: resources\skins\Dark Blue\Compact\ButtonThanks.png"
	.	"`nDest: " PROGRAM.SKINS_FOLDER "\Dark Blue\Compact\ButtonThanks.png"
	.	"`nFlag: " 2)
	errorLog .= "`n`n""Failed to extract file!"
	.	"`nSource: resources\skins\Dark Blue\Compact\ButtonThanks.png"
	.	"`nDest: " PROGRAM.SKINS_FOLDER "\Dark Blue\Compact\ButtonThanks.png"
	.	"`nFlag: " 2
}

; ----------------------------
if !InStr(FileExist(PROGRAM.SKINS_FOLDER "\Dark Blue\Compact"), "D")
	FileCreateDir,% PROGRAM.SKINS_FOLDER "\Dark Blue\Compact"

if (A_IsCompiled) {
	sourceFileSize := Get_ResourceSize("resources\skins\Dark Blue\Compact\ButtonThanksHover.png")
	FileGetSize, destFileSize, % PROGRAM.SKINS_FOLDER "\Dark Blue\Compact\ButtonThanksHover.png"
}
else {
	FileGetSize, sourceFileSize, resources\skins\Dark Blue\Compact\ButtonThanksHover.png
	FileGetSize, destFileSize, % PROGRAM.SKINS_FOLDER "\Dark Blue\Compact\ButtonThanksHover.png"
}
if (sourceFileSize != destFileSize)
	FileInstall, resources\skins\Dark Blue\Compact\ButtonThanksHover.png, % PROGRAM.SKINS_FOLDER "\Dark Blue\Compact\ButtonThanksHover.png", 1
if (ErrorLevel) {
	AppendToLogs("Failed to extract file!"
	.	"`nSource: resources\skins\Dark Blue\Compact\ButtonThanksHover.png"
	.	"`nDest: " PROGRAM.SKINS_FOLDER "\Dark Blue\Compact\ButtonThanksHover.png"
	.	"`nFlag: " 2)
	errorLog .= "`n`n""Failed to extract file!"
	.	"`nSource: resources\skins\Dark Blue\Compact\ButtonThanksHover.png"
	.	"`nDest: " PROGRAM.SKINS_FOLDER "\Dark Blue\Compact\ButtonThanksHover.png"
	.	"`nFlag: " 2
}

; ----------------------------
if !InStr(FileExist(PROGRAM.SKINS_FOLDER "\Dark Blue\Compact"), "D")
	FileCreateDir,% PROGRAM.SKINS_FOLDER "\Dark Blue\Compact"

if (A_IsCompiled) {
	sourceFileSize := Get_ResourceSize("resources\skins\Dark Blue\Compact\ButtonThanksPress.png")
	FileGetSize, destFileSize, % PROGRAM.SKINS_FOLDER "\Dark Blue\Compact\ButtonThanksPress.png"
}
else {
	FileGetSize, sourceFileSize, resources\skins\Dark Blue\Compact\ButtonThanksPress.png
	FileGetSize, destFileSize, % PROGRAM.SKINS_FOLDER "\Dark Blue\Compact\ButtonThanksPress.png"
}
if (sourceFileSize != destFileSize)
	FileInstall, resources\skins\Dark Blue\Compact\ButtonThanksPress.png, % PROGRAM.SKINS_FOLDER "\Dark Blue\Compact\ButtonThanksPress.png", 1
if (ErrorLevel) {
	AppendToLogs("Failed to extract file!"
	.	"`nSource: resources\skins\Dark Blue\Compact\ButtonThanksPress.png"
	.	"`nDest: " PROGRAM.SKINS_FOLDER "\Dark Blue\Compact\ButtonThanksPress.png"
	.	"`nFlag: " 2)
	errorLog .= "`n`n""Failed to extract file!"
	.	"`nSource: resources\skins\Dark Blue\Compact\ButtonThanksPress.png"
	.	"`nDest: " PROGRAM.SKINS_FOLDER "\Dark Blue\Compact\ButtonThanksPress.png"
	.	"`nFlag: " 2
}

; ----------------------------
if !InStr(FileExist(PROGRAM.SKINS_FOLDER "\Dark Blue\Compact"), "D")
	FileCreateDir,% PROGRAM.SKINS_FOLDER "\Dark Blue\Compact"

if (A_IsCompiled) {
	sourceFileSize := Get_ResourceSize("resources\skins\Dark Blue\Compact\ButtonWhisper.png")
	FileGetSize, destFileSize, % PROGRAM.SKINS_FOLDER "\Dark Blue\Compact\ButtonWhisper.png"
}
else {
	FileGetSize, sourceFileSize, resources\skins\Dark Blue\Compact\ButtonWhisper.png
	FileGetSize, destFileSize, % PROGRAM.SKINS_FOLDER "\Dark Blue\Compact\ButtonWhisper.png"
}
if (sourceFileSize != destFileSize)
	FileInstall, resources\skins\Dark Blue\Compact\ButtonWhisper.png, % PROGRAM.SKINS_FOLDER "\Dark Blue\Compact\ButtonWhisper.png", 1
if (ErrorLevel) {
	AppendToLogs("Failed to extract file!"
	.	"`nSource: resources\skins\Dark Blue\Compact\ButtonWhisper.png"
	.	"`nDest: " PROGRAM.SKINS_FOLDER "\Dark Blue\Compact\ButtonWhisper.png"
	.	"`nFlag: " 2)
	errorLog .= "`n`n""Failed to extract file!"
	.	"`nSource: resources\skins\Dark Blue\Compact\ButtonWhisper.png"
	.	"`nDest: " PROGRAM.SKINS_FOLDER "\Dark Blue\Compact\ButtonWhisper.png"
	.	"`nFlag: " 2
}

; ----------------------------
if !InStr(FileExist(PROGRAM.SKINS_FOLDER "\Dark Blue\Compact"), "D")
	FileCreateDir,% PROGRAM.SKINS_FOLDER "\Dark Blue\Compact"

if (A_IsCompiled) {
	sourceFileSize := Get_ResourceSize("resources\skins\Dark Blue\Compact\ButtonWhisperHover.png")
	FileGetSize, destFileSize, % PROGRAM.SKINS_FOLDER "\Dark Blue\Compact\ButtonWhisperHover.png"
}
else {
	FileGetSize, sourceFileSize, resources\skins\Dark Blue\Compact\ButtonWhisperHover.png
	FileGetSize, destFileSize, % PROGRAM.SKINS_FOLDER "\Dark Blue\Compact\ButtonWhisperHover.png"
}
if (sourceFileSize != destFileSize)
	FileInstall, resources\skins\Dark Blue\Compact\ButtonWhisperHover.png, % PROGRAM.SKINS_FOLDER "\Dark Blue\Compact\ButtonWhisperHover.png", 1
if (ErrorLevel) {
	AppendToLogs("Failed to extract file!"
	.	"`nSource: resources\skins\Dark Blue\Compact\ButtonWhisperHover.png"
	.	"`nDest: " PROGRAM.SKINS_FOLDER "\Dark Blue\Compact\ButtonWhisperHover.png"
	.	"`nFlag: " 2)
	errorLog .= "`n`n""Failed to extract file!"
	.	"`nSource: resources\skins\Dark Blue\Compact\ButtonWhisperHover.png"
	.	"`nDest: " PROGRAM.SKINS_FOLDER "\Dark Blue\Compact\ButtonWhisperHover.png"
	.	"`nFlag: " 2
}

; ----------------------------
if !InStr(FileExist(PROGRAM.SKINS_FOLDER "\Dark Blue\Compact"), "D")
	FileCreateDir,% PROGRAM.SKINS_FOLDER "\Dark Blue\Compact"

if (A_IsCompiled) {
	sourceFileSize := Get_ResourceSize("resources\skins\Dark Blue\Compact\ButtonWhisperPress.png")
	FileGetSize, destFileSize, % PROGRAM.SKINS_FOLDER "\Dark Blue\Compact\ButtonWhisperPress.png"
}
else {
	FileGetSize, sourceFileSize, resources\skins\Dark Blue\Compact\ButtonWhisperPress.png
	FileGetSize, destFileSize, % PROGRAM.SKINS_FOLDER "\Dark Blue\Compact\ButtonWhisperPress.png"
}
if (sourceFileSize != destFileSize)
	FileInstall, resources\skins\Dark Blue\Compact\ButtonWhisperPress.png, % PROGRAM.SKINS_FOLDER "\Dark Blue\Compact\ButtonWhisperPress.png", 1
if (ErrorLevel) {
	AppendToLogs("Failed to extract file!"
	.	"`nSource: resources\skins\Dark Blue\Compact\ButtonWhisperPress.png"
	.	"`nDest: " PROGRAM.SKINS_FOLDER "\Dark Blue\Compact\ButtonWhisperPress.png"
	.	"`nFlag: " 2)
	errorLog .= "`n`n""Failed to extract file!"
	.	"`nSource: resources\skins\Dark Blue\Compact\ButtonWhisperPress.png"
	.	"`nDest: " PROGRAM.SKINS_FOLDER "\Dark Blue\Compact\ButtonWhisperPress.png"
	.	"`nFlag: " 2
}

; ----------------------------
if !InStr(FileExist(PROGRAM.SKINS_FOLDER "\Dark Blue\Compact"), "D")
	FileCreateDir,% PROGRAM.SKINS_FOLDER "\Dark Blue\Compact"

if (A_IsCompiled) {
	sourceFileSize := Get_ResourceSize("resources\skins\Dark Blue\Compact\CloseTab.png")
	FileGetSize, destFileSize, % PROGRAM.SKINS_FOLDER "\Dark Blue\Compact\CloseTab.png"
}
else {
	FileGetSize, sourceFileSize, resources\skins\Dark Blue\Compact\CloseTab.png
	FileGetSize, destFileSize, % PROGRAM.SKINS_FOLDER "\Dark Blue\Compact\CloseTab.png"
}
if (sourceFileSize != destFileSize)
	FileInstall, resources\skins\Dark Blue\Compact\CloseTab.png, % PROGRAM.SKINS_FOLDER "\Dark Blue\Compact\CloseTab.png", 1
if (ErrorLevel) {
	AppendToLogs("Failed to extract file!"
	.	"`nSource: resources\skins\Dark Blue\Compact\CloseTab.png"
	.	"`nDest: " PROGRAM.SKINS_FOLDER "\Dark Blue\Compact\CloseTab.png"
	.	"`nFlag: " 2)
	errorLog .= "`n`n""Failed to extract file!"
	.	"`nSource: resources\skins\Dark Blue\Compact\CloseTab.png"
	.	"`nDest: " PROGRAM.SKINS_FOLDER "\Dark Blue\Compact\CloseTab.png"
	.	"`nFlag: " 2
}

; ----------------------------
if !InStr(FileExist(PROGRAM.SKINS_FOLDER "\Dark Blue\Compact"), "D")
	FileCreateDir,% PROGRAM.SKINS_FOLDER "\Dark Blue\Compact"

if (A_IsCompiled) {
	sourceFileSize := Get_ResourceSize("resources\skins\Dark Blue\Compact\CloseTabHover.png")
	FileGetSize, destFileSize, % PROGRAM.SKINS_FOLDER "\Dark Blue\Compact\CloseTabHover.png"
}
else {
	FileGetSize, sourceFileSize, resources\skins\Dark Blue\Compact\CloseTabHover.png
	FileGetSize, destFileSize, % PROGRAM.SKINS_FOLDER "\Dark Blue\Compact\CloseTabHover.png"
}
if (sourceFileSize != destFileSize)
	FileInstall, resources\skins\Dark Blue\Compact\CloseTabHover.png, % PROGRAM.SKINS_FOLDER "\Dark Blue\Compact\CloseTabHover.png", 1
if (ErrorLevel) {
	AppendToLogs("Failed to extract file!"
	.	"`nSource: resources\skins\Dark Blue\Compact\CloseTabHover.png"
	.	"`nDest: " PROGRAM.SKINS_FOLDER "\Dark Blue\Compact\CloseTabHover.png"
	.	"`nFlag: " 2)
	errorLog .= "`n`n""Failed to extract file!"
	.	"`nSource: resources\skins\Dark Blue\Compact\CloseTabHover.png"
	.	"`nDest: " PROGRAM.SKINS_FOLDER "\Dark Blue\Compact\CloseTabHover.png"
	.	"`nFlag: " 2
}

; ----------------------------
if !InStr(FileExist(PROGRAM.SKINS_FOLDER "\Dark Blue\Compact"), "D")
	FileCreateDir,% PROGRAM.SKINS_FOLDER "\Dark Blue\Compact"

if (A_IsCompiled) {
	sourceFileSize := Get_ResourceSize("resources\skins\Dark Blue\Compact\CloseTabPress.png")
	FileGetSize, destFileSize, % PROGRAM.SKINS_FOLDER "\Dark Blue\Compact\CloseTabPress.png"
}
else {
	FileGetSize, sourceFileSize, resources\skins\Dark Blue\Compact\CloseTabPress.png
	FileGetSize, destFileSize, % PROGRAM.SKINS_FOLDER "\Dark Blue\Compact\CloseTabPress.png"
}
if (sourceFileSize != destFileSize)
	FileInstall, resources\skins\Dark Blue\Compact\CloseTabPress.png, % PROGRAM.SKINS_FOLDER "\Dark Blue\Compact\CloseTabPress.png", 1
if (ErrorLevel) {
	AppendToLogs("Failed to extract file!"
	.	"`nSource: resources\skins\Dark Blue\Compact\CloseTabPress.png"
	.	"`nDest: " PROGRAM.SKINS_FOLDER "\Dark Blue\Compact\CloseTabPress.png"
	.	"`nFlag: " 2)
	errorLog .= "`n`n""Failed to extract file!"
	.	"`nSource: resources\skins\Dark Blue\Compact\CloseTabPress.png"
	.	"`nDest: " PROGRAM.SKINS_FOLDER "\Dark Blue\Compact\CloseTabPress.png"
	.	"`nFlag: " 2
}

; ----------------------------
if !InStr(FileExist(PROGRAM.SKINS_FOLDER "\Dark Blue\Compact"), "D")
	FileCreateDir,% PROGRAM.SKINS_FOLDER "\Dark Blue\Compact"

if (A_IsCompiled) {
	sourceFileSize := Get_ResourceSize("resources\skins\Dark Blue\Compact\Header.png")
	FileGetSize, destFileSize, % PROGRAM.SKINS_FOLDER "\Dark Blue\Compact\Header.png"
}
else {
	FileGetSize, sourceFileSize, resources\skins\Dark Blue\Compact\Header.png
	FileGetSize, destFileSize, % PROGRAM.SKINS_FOLDER "\Dark Blue\Compact\Header.png"
}
if (sourceFileSize != destFileSize)
	FileInstall, resources\skins\Dark Blue\Compact\Header.png, % PROGRAM.SKINS_FOLDER "\Dark Blue\Compact\Header.png", 1
if (ErrorLevel) {
	AppendToLogs("Failed to extract file!"
	.	"`nSource: resources\skins\Dark Blue\Compact\Header.png"
	.	"`nDest: " PROGRAM.SKINS_FOLDER "\Dark Blue\Compact\Header.png"
	.	"`nFlag: " 2)
	errorLog .= "`n`n""Failed to extract file!"
	.	"`nSource: resources\skins\Dark Blue\Compact\Header.png"
	.	"`nDest: " PROGRAM.SKINS_FOLDER "\Dark Blue\Compact\Header.png"
	.	"`nFlag: " 2
}

; ----------------------------
if !InStr(FileExist(PROGRAM.SKINS_FOLDER "\Dark Blue\Compact"), "D")
	FileCreateDir,% PROGRAM.SKINS_FOLDER "\Dark Blue\Compact"

if (A_IsCompiled) {
	sourceFileSize := Get_ResourceSize("resources\skins\Dark Blue\Compact\Header2.png")
	FileGetSize, destFileSize, % PROGRAM.SKINS_FOLDER "\Dark Blue\Compact\Header2.png"
}
else {
	FileGetSize, sourceFileSize, resources\skins\Dark Blue\Compact\Header2.png
	FileGetSize, destFileSize, % PROGRAM.SKINS_FOLDER "\Dark Blue\Compact\Header2.png"
}
if (sourceFileSize != destFileSize)
	FileInstall, resources\skins\Dark Blue\Compact\Header2.png, % PROGRAM.SKINS_FOLDER "\Dark Blue\Compact\Header2.png", 1
if (ErrorLevel) {
	AppendToLogs("Failed to extract file!"
	.	"`nSource: resources\skins\Dark Blue\Compact\Header2.png"
	.	"`nDest: " PROGRAM.SKINS_FOLDER "\Dark Blue\Compact\Header2.png"
	.	"`nFlag: " 2)
	errorLog .= "`n`n""Failed to extract file!"
	.	"`nSource: resources\skins\Dark Blue\Compact\Header2.png"
	.	"`nDest: " PROGRAM.SKINS_FOLDER "\Dark Blue\Compact\Header2.png"
	.	"`nFlag: " 2
}

; ----------------------------
if !InStr(FileExist(PROGRAM.SKINS_FOLDER "\Dark Blue\Compact"), "D")
	FileCreateDir,% PROGRAM.SKINS_FOLDER "\Dark Blue\Compact"

if (A_IsCompiled) {
	sourceFileSize := Get_ResourceSize("resources\skins\Dark Blue\Compact\Maximize.png")
	FileGetSize, destFileSize, % PROGRAM.SKINS_FOLDER "\Dark Blue\Compact\Maximize.png"
}
else {
	FileGetSize, sourceFileSize, resources\skins\Dark Blue\Compact\Maximize.png
	FileGetSize, destFileSize, % PROGRAM.SKINS_FOLDER "\Dark Blue\Compact\Maximize.png"
}
if (sourceFileSize != destFileSize)
	FileInstall, resources\skins\Dark Blue\Compact\Maximize.png, % PROGRAM.SKINS_FOLDER "\Dark Blue\Compact\Maximize.png", 1
if (ErrorLevel) {
	AppendToLogs("Failed to extract file!"
	.	"`nSource: resources\skins\Dark Blue\Compact\Maximize.png"
	.	"`nDest: " PROGRAM.SKINS_FOLDER "\Dark Blue\Compact\Maximize.png"
	.	"`nFlag: " 2)
	errorLog .= "`n`n""Failed to extract file!"
	.	"`nSource: resources\skins\Dark Blue\Compact\Maximize.png"
	.	"`nDest: " PROGRAM.SKINS_FOLDER "\Dark Blue\Compact\Maximize.png"
	.	"`nFlag: " 2
}

; ----------------------------
if !InStr(FileExist(PROGRAM.SKINS_FOLDER "\Dark Blue\Compact"), "D")
	FileCreateDir,% PROGRAM.SKINS_FOLDER "\Dark Blue\Compact"

if (A_IsCompiled) {
	sourceFileSize := Get_ResourceSize("resources\skins\Dark Blue\Compact\MaximizeHover.png")
	FileGetSize, destFileSize, % PROGRAM.SKINS_FOLDER "\Dark Blue\Compact\MaximizeHover.png"
}
else {
	FileGetSize, sourceFileSize, resources\skins\Dark Blue\Compact\MaximizeHover.png
	FileGetSize, destFileSize, % PROGRAM.SKINS_FOLDER "\Dark Blue\Compact\MaximizeHover.png"
}
if (sourceFileSize != destFileSize)
	FileInstall, resources\skins\Dark Blue\Compact\MaximizeHover.png, % PROGRAM.SKINS_FOLDER "\Dark Blue\Compact\MaximizeHover.png", 1
if (ErrorLevel) {
	AppendToLogs("Failed to extract file!"
	.	"`nSource: resources\skins\Dark Blue\Compact\MaximizeHover.png"
	.	"`nDest: " PROGRAM.SKINS_FOLDER "\Dark Blue\Compact\MaximizeHover.png"
	.	"`nFlag: " 2)
	errorLog .= "`n`n""Failed to extract file!"
	.	"`nSource: resources\skins\Dark Blue\Compact\MaximizeHover.png"
	.	"`nDest: " PROGRAM.SKINS_FOLDER "\Dark Blue\Compact\MaximizeHover.png"
	.	"`nFlag: " 2
}

; ----------------------------
if !InStr(FileExist(PROGRAM.SKINS_FOLDER "\Dark Blue\Compact"), "D")
	FileCreateDir,% PROGRAM.SKINS_FOLDER "\Dark Blue\Compact"

if (A_IsCompiled) {
	sourceFileSize := Get_ResourceSize("resources\skins\Dark Blue\Compact\MaximizePress.png")
	FileGetSize, destFileSize, % PROGRAM.SKINS_FOLDER "\Dark Blue\Compact\MaximizePress.png"
}
else {
	FileGetSize, sourceFileSize, resources\skins\Dark Blue\Compact\MaximizePress.png
	FileGetSize, destFileSize, % PROGRAM.SKINS_FOLDER "\Dark Blue\Compact\MaximizePress.png"
}
if (sourceFileSize != destFileSize)
	FileInstall, resources\skins\Dark Blue\Compact\MaximizePress.png, % PROGRAM.SKINS_FOLDER "\Dark Blue\Compact\MaximizePress.png", 1
if (ErrorLevel) {
	AppendToLogs("Failed to extract file!"
	.	"`nSource: resources\skins\Dark Blue\Compact\MaximizePress.png"
	.	"`nDest: " PROGRAM.SKINS_FOLDER "\Dark Blue\Compact\MaximizePress.png"
	.	"`nFlag: " 2)
	errorLog .= "`n`n""Failed to extract file!"
	.	"`nSource: resources\skins\Dark Blue\Compact\MaximizePress.png"
	.	"`nDest: " PROGRAM.SKINS_FOLDER "\Dark Blue\Compact\MaximizePress.png"
	.	"`nFlag: " 2
}

; ----------------------------
if !InStr(FileExist(PROGRAM.SKINS_FOLDER "\Dark Blue\Compact"), "D")
	FileCreateDir,% PROGRAM.SKINS_FOLDER "\Dark Blue\Compact"

if (A_IsCompiled) {
	sourceFileSize := Get_ResourceSize("resources\skins\Dark Blue\Compact\Minimize.png")
	FileGetSize, destFileSize, % PROGRAM.SKINS_FOLDER "\Dark Blue\Compact\Minimize.png"
}
else {
	FileGetSize, sourceFileSize, resources\skins\Dark Blue\Compact\Minimize.png
	FileGetSize, destFileSize, % PROGRAM.SKINS_FOLDER "\Dark Blue\Compact\Minimize.png"
}
if (sourceFileSize != destFileSize)
	FileInstall, resources\skins\Dark Blue\Compact\Minimize.png, % PROGRAM.SKINS_FOLDER "\Dark Blue\Compact\Minimize.png", 1
if (ErrorLevel) {
	AppendToLogs("Failed to extract file!"
	.	"`nSource: resources\skins\Dark Blue\Compact\Minimize.png"
	.	"`nDest: " PROGRAM.SKINS_FOLDER "\Dark Blue\Compact\Minimize.png"
	.	"`nFlag: " 2)
	errorLog .= "`n`n""Failed to extract file!"
	.	"`nSource: resources\skins\Dark Blue\Compact\Minimize.png"
	.	"`nDest: " PROGRAM.SKINS_FOLDER "\Dark Blue\Compact\Minimize.png"
	.	"`nFlag: " 2
}

; ----------------------------
if !InStr(FileExist(PROGRAM.SKINS_FOLDER "\Dark Blue\Compact"), "D")
	FileCreateDir,% PROGRAM.SKINS_FOLDER "\Dark Blue\Compact"

if (A_IsCompiled) {
	sourceFileSize := Get_ResourceSize("resources\skins\Dark Blue\Compact\MinimizeHover.png")
	FileGetSize, destFileSize, % PROGRAM.SKINS_FOLDER "\Dark Blue\Compact\MinimizeHover.png"
}
else {
	FileGetSize, sourceFileSize, resources\skins\Dark Blue\Compact\MinimizeHover.png
	FileGetSize, destFileSize, % PROGRAM.SKINS_FOLDER "\Dark Blue\Compact\MinimizeHover.png"
}
if (sourceFileSize != destFileSize)
	FileInstall, resources\skins\Dark Blue\Compact\MinimizeHover.png, % PROGRAM.SKINS_FOLDER "\Dark Blue\Compact\MinimizeHover.png", 1
if (ErrorLevel) {
	AppendToLogs("Failed to extract file!"
	.	"`nSource: resources\skins\Dark Blue\Compact\MinimizeHover.png"
	.	"`nDest: " PROGRAM.SKINS_FOLDER "\Dark Blue\Compact\MinimizeHover.png"
	.	"`nFlag: " 2)
	errorLog .= "`n`n""Failed to extract file!"
	.	"`nSource: resources\skins\Dark Blue\Compact\MinimizeHover.png"
	.	"`nDest: " PROGRAM.SKINS_FOLDER "\Dark Blue\Compact\MinimizeHover.png"
	.	"`nFlag: " 2
}

; ----------------------------
if !InStr(FileExist(PROGRAM.SKINS_FOLDER "\Dark Blue\Compact"), "D")
	FileCreateDir,% PROGRAM.SKINS_FOLDER "\Dark Blue\Compact"

if (A_IsCompiled) {
	sourceFileSize := Get_ResourceSize("resources\skins\Dark Blue\Compact\MinimizePress.png")
	FileGetSize, destFileSize, % PROGRAM.SKINS_FOLDER "\Dark Blue\Compact\MinimizePress.png"
}
else {
	FileGetSize, sourceFileSize, resources\skins\Dark Blue\Compact\MinimizePress.png
	FileGetSize, destFileSize, % PROGRAM.SKINS_FOLDER "\Dark Blue\Compact\MinimizePress.png"
}
if (sourceFileSize != destFileSize)
	FileInstall, resources\skins\Dark Blue\Compact\MinimizePress.png, % PROGRAM.SKINS_FOLDER "\Dark Blue\Compact\MinimizePress.png", 1
if (ErrorLevel) {
	AppendToLogs("Failed to extract file!"
	.	"`nSource: resources\skins\Dark Blue\Compact\MinimizePress.png"
	.	"`nDest: " PROGRAM.SKINS_FOLDER "\Dark Blue\Compact\MinimizePress.png"
	.	"`nFlag: " 2)
	errorLog .= "`n`n""Failed to extract file!"
	.	"`nSource: resources\skins\Dark Blue\Compact\MinimizePress.png"
	.	"`nDest: " PROGRAM.SKINS_FOLDER "\Dark Blue\Compact\MinimizePress.png"
	.	"`nFlag: " 2
}

; ----------------------------
if !InStr(FileExist(PROGRAM.SKINS_FOLDER "\Dark Blue\Compact"), "D")
	FileCreateDir,% PROGRAM.SKINS_FOLDER "\Dark Blue\Compact"

if (A_IsCompiled) {
	sourceFileSize := Get_ResourceSize("resources\skins\Dark Blue\Compact\Preview.png")
	FileGetSize, destFileSize, % PROGRAM.SKINS_FOLDER "\Dark Blue\Compact\Preview.png"
}
else {
	FileGetSize, sourceFileSize, resources\skins\Dark Blue\Compact\Preview.png
	FileGetSize, destFileSize, % PROGRAM.SKINS_FOLDER "\Dark Blue\Compact\Preview.png"
}
if (sourceFileSize != destFileSize)
	FileInstall, resources\skins\Dark Blue\Compact\Preview.png, % PROGRAM.SKINS_FOLDER "\Dark Blue\Compact\Preview.png", 1
if (ErrorLevel) {
	AppendToLogs("Failed to extract file!"
	.	"`nSource: resources\skins\Dark Blue\Compact\Preview.png"
	.	"`nDest: " PROGRAM.SKINS_FOLDER "\Dark Blue\Compact\Preview.png"
	.	"`nFlag: " 2)
	errorLog .= "`n`n""Failed to extract file!"
	.	"`nSource: resources\skins\Dark Blue\Compact\Preview.png"
	.	"`nDest: " PROGRAM.SKINS_FOLDER "\Dark Blue\Compact\Preview.png"
	.	"`nFlag: " 2
}

; ----------------------------
if !InStr(FileExist(PROGRAM.SKINS_FOLDER "\Dark Blue\Compact"), "D")
	FileCreateDir,% PROGRAM.SKINS_FOLDER "\Dark Blue\Compact"

FileInstall, resources\skins\Dark Blue\Compact\Settings.ini, % PROGRAM.SKINS_FOLDER "\Dark Blue\Compact\Settings.ini", 1
if (ErrorLevel) {
	AppendToLogs("Failed to extract file!"
	.	"`nSource: resources\skins\Dark Blue\Compact\Settings.ini"
	.	"`nDest: " PROGRAM.SKINS_FOLDER "\Dark Blue\Compact\Settings.ini"
	.	"`nFlag: " 1)
	errorLog .= "`n`n""Failed to extract file!"
	.	"`nSource: resources\skins\Dark Blue\Compact\Settings.ini"
	.	"`nDest: " PROGRAM.SKINS_FOLDER "\Dark Blue\Compact\Settings.ini"
	.	"`nFlag: " 1
}

; ----------------------------
if !InStr(FileExist(PROGRAM.SKINS_FOLDER "\Dark Blue\Compact"), "D")
	FileCreateDir,% PROGRAM.SKINS_FOLDER "\Dark Blue\Compact"

if (A_IsCompiled) {
	sourceFileSize := Get_ResourceSize("resources\skins\Dark Blue\Compact\ToolbarHideout.png")
	FileGetSize, destFileSize, % PROGRAM.SKINS_FOLDER "\Dark Blue\Compact\ToolbarHideout.png"
}
else {
	FileGetSize, sourceFileSize, resources\skins\Dark Blue\Compact\ToolbarHideout.png
	FileGetSize, destFileSize, % PROGRAM.SKINS_FOLDER "\Dark Blue\Compact\ToolbarHideout.png"
}
if (sourceFileSize != destFileSize)
	FileInstall, resources\skins\Dark Blue\Compact\ToolbarHideout.png, % PROGRAM.SKINS_FOLDER "\Dark Blue\Compact\ToolbarHideout.png", 1
if (ErrorLevel) {
	AppendToLogs("Failed to extract file!"
	.	"`nSource: resources\skins\Dark Blue\Compact\ToolbarHideout.png"
	.	"`nDest: " PROGRAM.SKINS_FOLDER "\Dark Blue\Compact\ToolbarHideout.png"
	.	"`nFlag: " 2)
	errorLog .= "`n`n""Failed to extract file!"
	.	"`nSource: resources\skins\Dark Blue\Compact\ToolbarHideout.png"
	.	"`nDest: " PROGRAM.SKINS_FOLDER "\Dark Blue\Compact\ToolbarHideout.png"
	.	"`nFlag: " 2
}

; ----------------------------
if !InStr(FileExist(PROGRAM.SKINS_FOLDER "\Dark Blue\Compact"), "D")
	FileCreateDir,% PROGRAM.SKINS_FOLDER "\Dark Blue\Compact"

if (A_IsCompiled) {
	sourceFileSize := Get_ResourceSize("resources\skins\Dark Blue\Compact\ToolbarHideoutHover.png")
	FileGetSize, destFileSize, % PROGRAM.SKINS_FOLDER "\Dark Blue\Compact\ToolbarHideoutHover.png"
}
else {
	FileGetSize, sourceFileSize, resources\skins\Dark Blue\Compact\ToolbarHideoutHover.png
	FileGetSize, destFileSize, % PROGRAM.SKINS_FOLDER "\Dark Blue\Compact\ToolbarHideoutHover.png"
}
if (sourceFileSize != destFileSize)
	FileInstall, resources\skins\Dark Blue\Compact\ToolbarHideoutHover.png, % PROGRAM.SKINS_FOLDER "\Dark Blue\Compact\ToolbarHideoutHover.png", 1
if (ErrorLevel) {
	AppendToLogs("Failed to extract file!"
	.	"`nSource: resources\skins\Dark Blue\Compact\ToolbarHideoutHover.png"
	.	"`nDest: " PROGRAM.SKINS_FOLDER "\Dark Blue\Compact\ToolbarHideoutHover.png"
	.	"`nFlag: " 2)
	errorLog .= "`n`n""Failed to extract file!"
	.	"`nSource: resources\skins\Dark Blue\Compact\ToolbarHideoutHover.png"
	.	"`nDest: " PROGRAM.SKINS_FOLDER "\Dark Blue\Compact\ToolbarHideoutHover.png"
	.	"`nFlag: " 2
}

; ----------------------------
if !InStr(FileExist(PROGRAM.SKINS_FOLDER "\Dark Blue\Compact"), "D")
	FileCreateDir,% PROGRAM.SKINS_FOLDER "\Dark Blue\Compact"

if (A_IsCompiled) {
	sourceFileSize := Get_ResourceSize("resources\skins\Dark Blue\Compact\ToolbarHideoutPress.png")
	FileGetSize, destFileSize, % PROGRAM.SKINS_FOLDER "\Dark Blue\Compact\ToolbarHideoutPress.png"
}
else {
	FileGetSize, sourceFileSize, resources\skins\Dark Blue\Compact\ToolbarHideoutPress.png
	FileGetSize, destFileSize, % PROGRAM.SKINS_FOLDER "\Dark Blue\Compact\ToolbarHideoutPress.png"
}
if (sourceFileSize != destFileSize)
	FileInstall, resources\skins\Dark Blue\Compact\ToolbarHideoutPress.png, % PROGRAM.SKINS_FOLDER "\Dark Blue\Compact\ToolbarHideoutPress.png", 1
if (ErrorLevel) {
	AppendToLogs("Failed to extract file!"
	.	"`nSource: resources\skins\Dark Blue\Compact\ToolbarHideoutPress.png"
	.	"`nDest: " PROGRAM.SKINS_FOLDER "\Dark Blue\Compact\ToolbarHideoutPress.png"
	.	"`nFlag: " 2)
	errorLog .= "`n`n""Failed to extract file!"
	.	"`nSource: resources\skins\Dark Blue\Compact\ToolbarHideoutPress.png"
	.	"`nDest: " PROGRAM.SKINS_FOLDER "\Dark Blue\Compact\ToolbarHideoutPress.png"
	.	"`nFlag: " 2
}

; ----------------------------
if !InStr(FileExist(PROGRAM.SKINS_FOLDER "\Dark Blue\Compact"), "D")
	FileCreateDir,% PROGRAM.SKINS_FOLDER "\Dark Blue\Compact"

if (A_IsCompiled) {
	sourceFileSize := Get_ResourceSize("resources\skins\Dark Blue\Compact\ToolbarSheet.png")
	FileGetSize, destFileSize, % PROGRAM.SKINS_FOLDER "\Dark Blue\Compact\ToolbarSheet.png"
}
else {
	FileGetSize, sourceFileSize, resources\skins\Dark Blue\Compact\ToolbarSheet.png
	FileGetSize, destFileSize, % PROGRAM.SKINS_FOLDER "\Dark Blue\Compact\ToolbarSheet.png"
}
if (sourceFileSize != destFileSize)
	FileInstall, resources\skins\Dark Blue\Compact\ToolbarSheet.png, % PROGRAM.SKINS_FOLDER "\Dark Blue\Compact\ToolbarSheet.png", 1
if (ErrorLevel) {
	AppendToLogs("Failed to extract file!"
	.	"`nSource: resources\skins\Dark Blue\Compact\ToolbarSheet.png"
	.	"`nDest: " PROGRAM.SKINS_FOLDER "\Dark Blue\Compact\ToolbarSheet.png"
	.	"`nFlag: " 2)
	errorLog .= "`n`n""Failed to extract file!"
	.	"`nSource: resources\skins\Dark Blue\Compact\ToolbarSheet.png"
	.	"`nDest: " PROGRAM.SKINS_FOLDER "\Dark Blue\Compact\ToolbarSheet.png"
	.	"`nFlag: " 2
}

; ----------------------------
if !InStr(FileExist(PROGRAM.SKINS_FOLDER "\Dark Blue\Compact"), "D")
	FileCreateDir,% PROGRAM.SKINS_FOLDER "\Dark Blue\Compact"

if (A_IsCompiled) {
	sourceFileSize := Get_ResourceSize("resources\skins\Dark Blue\Compact\ToolbarSheetHover.png")
	FileGetSize, destFileSize, % PROGRAM.SKINS_FOLDER "\Dark Blue\Compact\ToolbarSheetHover.png"
}
else {
	FileGetSize, sourceFileSize, resources\skins\Dark Blue\Compact\ToolbarSheetHover.png
	FileGetSize, destFileSize, % PROGRAM.SKINS_FOLDER "\Dark Blue\Compact\ToolbarSheetHover.png"
}
if (sourceFileSize != destFileSize)
	FileInstall, resources\skins\Dark Blue\Compact\ToolbarSheetHover.png, % PROGRAM.SKINS_FOLDER "\Dark Blue\Compact\ToolbarSheetHover.png", 1
if (ErrorLevel) {
	AppendToLogs("Failed to extract file!"
	.	"`nSource: resources\skins\Dark Blue\Compact\ToolbarSheetHover.png"
	.	"`nDest: " PROGRAM.SKINS_FOLDER "\Dark Blue\Compact\ToolbarSheetHover.png"
	.	"`nFlag: " 2)
	errorLog .= "`n`n""Failed to extract file!"
	.	"`nSource: resources\skins\Dark Blue\Compact\ToolbarSheetHover.png"
	.	"`nDest: " PROGRAM.SKINS_FOLDER "\Dark Blue\Compact\ToolbarSheetHover.png"
	.	"`nFlag: " 2
}

; ----------------------------
if !InStr(FileExist(PROGRAM.SKINS_FOLDER "\Dark Blue\Compact"), "D")
	FileCreateDir,% PROGRAM.SKINS_FOLDER "\Dark Blue\Compact"

if (A_IsCompiled) {
	sourceFileSize := Get_ResourceSize("resources\skins\Dark Blue\Compact\ToolbarSheetPress.png")
	FileGetSize, destFileSize, % PROGRAM.SKINS_FOLDER "\Dark Blue\Compact\ToolbarSheetPress.png"
}
else {
	FileGetSize, sourceFileSize, resources\skins\Dark Blue\Compact\ToolbarSheetPress.png
	FileGetSize, destFileSize, % PROGRAM.SKINS_FOLDER "\Dark Blue\Compact\ToolbarSheetPress.png"
}
if (sourceFileSize != destFileSize)
	FileInstall, resources\skins\Dark Blue\Compact\ToolbarSheetPress.png, % PROGRAM.SKINS_FOLDER "\Dark Blue\Compact\ToolbarSheetPress.png", 1
if (ErrorLevel) {
	AppendToLogs("Failed to extract file!"
	.	"`nSource: resources\skins\Dark Blue\Compact\ToolbarSheetPress.png"
	.	"`nDest: " PROGRAM.SKINS_FOLDER "\Dark Blue\Compact\ToolbarSheetPress.png"
	.	"`nFlag: " 2)
	errorLog .= "`n`n""Failed to extract file!"
	.	"`nSource: resources\skins\Dark Blue\Compact\ToolbarSheetPress.png"
	.	"`nDest: " PROGRAM.SKINS_FOLDER "\Dark Blue\Compact\ToolbarSheetPress.png"
	.	"`nFlag: " 2
}

; ----------------------------
if !InStr(FileExist(PROGRAM.SKINS_FOLDER "\Path of Exile"), "D")
	FileCreateDir,% PROGRAM.SKINS_FOLDER "\Path of Exile"

if (A_IsCompiled) {
	sourceFileSize := Get_ResourceSize("resources\skins\Path of Exile\ArrowLeft.png")
	FileGetSize, destFileSize, % PROGRAM.SKINS_FOLDER "\Path of Exile\ArrowLeft.png"
}
else {
	FileGetSize, sourceFileSize, resources\skins\Path of Exile\ArrowLeft.png
	FileGetSize, destFileSize, % PROGRAM.SKINS_FOLDER "\Path of Exile\ArrowLeft.png"
}
if (sourceFileSize != destFileSize)
	FileInstall, resources\skins\Path of Exile\ArrowLeft.png, % PROGRAM.SKINS_FOLDER "\Path of Exile\ArrowLeft.png", 1
if (ErrorLevel) {
	AppendToLogs("Failed to extract file!"
	.	"`nSource: resources\skins\Path of Exile\ArrowLeft.png"
	.	"`nDest: " PROGRAM.SKINS_FOLDER "\Path of Exile\ArrowLeft.png"
	.	"`nFlag: " 2)
	errorLog .= "`n`n""Failed to extract file!"
	.	"`nSource: resources\skins\Path of Exile\ArrowLeft.png"
	.	"`nDest: " PROGRAM.SKINS_FOLDER "\Path of Exile\ArrowLeft.png"
	.	"`nFlag: " 2
}

; ----------------------------
if !InStr(FileExist(PROGRAM.SKINS_FOLDER "\Path of Exile"), "D")
	FileCreateDir,% PROGRAM.SKINS_FOLDER "\Path of Exile"

if (A_IsCompiled) {
	sourceFileSize := Get_ResourceSize("resources\skins\Path of Exile\ArrowLeftHover.png")
	FileGetSize, destFileSize, % PROGRAM.SKINS_FOLDER "\Path of Exile\ArrowLeftHover.png"
}
else {
	FileGetSize, sourceFileSize, resources\skins\Path of Exile\ArrowLeftHover.png
	FileGetSize, destFileSize, % PROGRAM.SKINS_FOLDER "\Path of Exile\ArrowLeftHover.png"
}
if (sourceFileSize != destFileSize)
	FileInstall, resources\skins\Path of Exile\ArrowLeftHover.png, % PROGRAM.SKINS_FOLDER "\Path of Exile\ArrowLeftHover.png", 1
if (ErrorLevel) {
	AppendToLogs("Failed to extract file!"
	.	"`nSource: resources\skins\Path of Exile\ArrowLeftHover.png"
	.	"`nDest: " PROGRAM.SKINS_FOLDER "\Path of Exile\ArrowLeftHover.png"
	.	"`nFlag: " 2)
	errorLog .= "`n`n""Failed to extract file!"
	.	"`nSource: resources\skins\Path of Exile\ArrowLeftHover.png"
	.	"`nDest: " PROGRAM.SKINS_FOLDER "\Path of Exile\ArrowLeftHover.png"
	.	"`nFlag: " 2
}

; ----------------------------
if !InStr(FileExist(PROGRAM.SKINS_FOLDER "\Path of Exile"), "D")
	FileCreateDir,% PROGRAM.SKINS_FOLDER "\Path of Exile"

if (A_IsCompiled) {
	sourceFileSize := Get_ResourceSize("resources\skins\Path of Exile\ArrowLeftPress.png")
	FileGetSize, destFileSize, % PROGRAM.SKINS_FOLDER "\Path of Exile\ArrowLeftPress.png"
}
else {
	FileGetSize, sourceFileSize, resources\skins\Path of Exile\ArrowLeftPress.png
	FileGetSize, destFileSize, % PROGRAM.SKINS_FOLDER "\Path of Exile\ArrowLeftPress.png"
}
if (sourceFileSize != destFileSize)
	FileInstall, resources\skins\Path of Exile\ArrowLeftPress.png, % PROGRAM.SKINS_FOLDER "\Path of Exile\ArrowLeftPress.png", 1
if (ErrorLevel) {
	AppendToLogs("Failed to extract file!"
	.	"`nSource: resources\skins\Path of Exile\ArrowLeftPress.png"
	.	"`nDest: " PROGRAM.SKINS_FOLDER "\Path of Exile\ArrowLeftPress.png"
	.	"`nFlag: " 2)
	errorLog .= "`n`n""Failed to extract file!"
	.	"`nSource: resources\skins\Path of Exile\ArrowLeftPress.png"
	.	"`nDest: " PROGRAM.SKINS_FOLDER "\Path of Exile\ArrowLeftPress.png"
	.	"`nFlag: " 2
}

; ----------------------------
if !InStr(FileExist(PROGRAM.SKINS_FOLDER "\Path of Exile"), "D")
	FileCreateDir,% PROGRAM.SKINS_FOLDER "\Path of Exile"

if (A_IsCompiled) {
	sourceFileSize := Get_ResourceSize("resources\skins\Path of Exile\ArrowRight.png")
	FileGetSize, destFileSize, % PROGRAM.SKINS_FOLDER "\Path of Exile\ArrowRight.png"
}
else {
	FileGetSize, sourceFileSize, resources\skins\Path of Exile\ArrowRight.png
	FileGetSize, destFileSize, % PROGRAM.SKINS_FOLDER "\Path of Exile\ArrowRight.png"
}
if (sourceFileSize != destFileSize)
	FileInstall, resources\skins\Path of Exile\ArrowRight.png, % PROGRAM.SKINS_FOLDER "\Path of Exile\ArrowRight.png", 1
if (ErrorLevel) {
	AppendToLogs("Failed to extract file!"
	.	"`nSource: resources\skins\Path of Exile\ArrowRight.png"
	.	"`nDest: " PROGRAM.SKINS_FOLDER "\Path of Exile\ArrowRight.png"
	.	"`nFlag: " 2)
	errorLog .= "`n`n""Failed to extract file!"
	.	"`nSource: resources\skins\Path of Exile\ArrowRight.png"
	.	"`nDest: " PROGRAM.SKINS_FOLDER "\Path of Exile\ArrowRight.png"
	.	"`nFlag: " 2
}

; ----------------------------
if !InStr(FileExist(PROGRAM.SKINS_FOLDER "\Path of Exile"), "D")
	FileCreateDir,% PROGRAM.SKINS_FOLDER "\Path of Exile"

if (A_IsCompiled) {
	sourceFileSize := Get_ResourceSize("resources\skins\Path of Exile\ArrowRightHover.png")
	FileGetSize, destFileSize, % PROGRAM.SKINS_FOLDER "\Path of Exile\ArrowRightHover.png"
}
else {
	FileGetSize, sourceFileSize, resources\skins\Path of Exile\ArrowRightHover.png
	FileGetSize, destFileSize, % PROGRAM.SKINS_FOLDER "\Path of Exile\ArrowRightHover.png"
}
if (sourceFileSize != destFileSize)
	FileInstall, resources\skins\Path of Exile\ArrowRightHover.png, % PROGRAM.SKINS_FOLDER "\Path of Exile\ArrowRightHover.png", 1
if (ErrorLevel) {
	AppendToLogs("Failed to extract file!"
	.	"`nSource: resources\skins\Path of Exile\ArrowRightHover.png"
	.	"`nDest: " PROGRAM.SKINS_FOLDER "\Path of Exile\ArrowRightHover.png"
	.	"`nFlag: " 2)
	errorLog .= "`n`n""Failed to extract file!"
	.	"`nSource: resources\skins\Path of Exile\ArrowRightHover.png"
	.	"`nDest: " PROGRAM.SKINS_FOLDER "\Path of Exile\ArrowRightHover.png"
	.	"`nFlag: " 2
}

; ----------------------------
if !InStr(FileExist(PROGRAM.SKINS_FOLDER "\Path of Exile"), "D")
	FileCreateDir,% PROGRAM.SKINS_FOLDER "\Path of Exile"

if (A_IsCompiled) {
	sourceFileSize := Get_ResourceSize("resources\skins\Path of Exile\ArrowRightPress.png")
	FileGetSize, destFileSize, % PROGRAM.SKINS_FOLDER "\Path of Exile\ArrowRightPress.png"
}
else {
	FileGetSize, sourceFileSize, resources\skins\Path of Exile\ArrowRightPress.png
	FileGetSize, destFileSize, % PROGRAM.SKINS_FOLDER "\Path of Exile\ArrowRightPress.png"
}
if (sourceFileSize != destFileSize)
	FileInstall, resources\skins\Path of Exile\ArrowRightPress.png, % PROGRAM.SKINS_FOLDER "\Path of Exile\ArrowRightPress.png", 1
if (ErrorLevel) {
	AppendToLogs("Failed to extract file!"
	.	"`nSource: resources\skins\Path of Exile\ArrowRightPress.png"
	.	"`nDest: " PROGRAM.SKINS_FOLDER "\Path of Exile\ArrowRightPress.png"
	.	"`nFlag: " 2)
	errorLog .= "`n`n""Failed to extract file!"
	.	"`nSource: resources\skins\Path of Exile\ArrowRightPress.png"
	.	"`nDest: " PROGRAM.SKINS_FOLDER "\Path of Exile\ArrowRightPress.png"
	.	"`nFlag: " 2
}

; ----------------------------
if !InStr(FileExist(PROGRAM.SKINS_FOLDER "\Path of Exile"), "D")
	FileCreateDir,% PROGRAM.SKINS_FOLDER "\Path of Exile"

FileInstall, resources\skins\Path of Exile\Assets.ini, % PROGRAM.SKINS_FOLDER "\Path of Exile\Assets.ini", 1
if (ErrorLevel) {
	AppendToLogs("Failed to extract file!"
	.	"`nSource: resources\skins\Path of Exile\Assets.ini"
	.	"`nDest: " PROGRAM.SKINS_FOLDER "\Path of Exile\Assets.ini"
	.	"`nFlag: " 1)
	errorLog .= "`n`n""Failed to extract file!"
	.	"`nSource: resources\skins\Path of Exile\Assets.ini"
	.	"`nDest: " PROGRAM.SKINS_FOLDER "\Path of Exile\Assets.ini"
	.	"`nFlag: " 1
}

; ----------------------------
if !InStr(FileExist(PROGRAM.SKINS_FOLDER "\Path of Exile"), "D")
	FileCreateDir,% PROGRAM.SKINS_FOLDER "\Path of Exile"

if (A_IsCompiled) {
	sourceFileSize := Get_ResourceSize("resources\skins\Path of Exile\Background.png")
	FileGetSize, destFileSize, % PROGRAM.SKINS_FOLDER "\Path of Exile\Background.png"
}
else {
	FileGetSize, sourceFileSize, resources\skins\Path of Exile\Background.png
	FileGetSize, destFileSize, % PROGRAM.SKINS_FOLDER "\Path of Exile\Background.png"
}
if (sourceFileSize != destFileSize)
	FileInstall, resources\skins\Path of Exile\Background.png, % PROGRAM.SKINS_FOLDER "\Path of Exile\Background.png", 1
if (ErrorLevel) {
	AppendToLogs("Failed to extract file!"
	.	"`nSource: resources\skins\Path of Exile\Background.png"
	.	"`nDest: " PROGRAM.SKINS_FOLDER "\Path of Exile\Background.png"
	.	"`nFlag: " 2)
	errorLog .= "`n`n""Failed to extract file!"
	.	"`nSource: resources\skins\Path of Exile\Background.png"
	.	"`nDest: " PROGRAM.SKINS_FOLDER "\Path of Exile\Background.png"
	.	"`nFlag: " 2
}

; ----------------------------
if !InStr(FileExist(PROGRAM.SKINS_FOLDER "\Path of Exile"), "D")
	FileCreateDir,% PROGRAM.SKINS_FOLDER "\Path of Exile"

if (A_IsCompiled) {
	sourceFileSize := Get_ResourceSize("resources\skins\Path of Exile\ButtonClipboard.png")
	FileGetSize, destFileSize, % PROGRAM.SKINS_FOLDER "\Path of Exile\ButtonClipboard.png"
}
else {
	FileGetSize, sourceFileSize, resources\skins\Path of Exile\ButtonClipboard.png
	FileGetSize, destFileSize, % PROGRAM.SKINS_FOLDER "\Path of Exile\ButtonClipboard.png"
}
if (sourceFileSize != destFileSize)
	FileInstall, resources\skins\Path of Exile\ButtonClipboard.png, % PROGRAM.SKINS_FOLDER "\Path of Exile\ButtonClipboard.png", 1
if (ErrorLevel) {
	AppendToLogs("Failed to extract file!"
	.	"`nSource: resources\skins\Path of Exile\ButtonClipboard.png"
	.	"`nDest: " PROGRAM.SKINS_FOLDER "\Path of Exile\ButtonClipboard.png"
	.	"`nFlag: " 2)
	errorLog .= "`n`n""Failed to extract file!"
	.	"`nSource: resources\skins\Path of Exile\ButtonClipboard.png"
	.	"`nDest: " PROGRAM.SKINS_FOLDER "\Path of Exile\ButtonClipboard.png"
	.	"`nFlag: " 2
}

; ----------------------------
if !InStr(FileExist(PROGRAM.SKINS_FOLDER "\Path of Exile"), "D")
	FileCreateDir,% PROGRAM.SKINS_FOLDER "\Path of Exile"

if (A_IsCompiled) {
	sourceFileSize := Get_ResourceSize("resources\skins\Path of Exile\ButtonClipboardHover.png")
	FileGetSize, destFileSize, % PROGRAM.SKINS_FOLDER "\Path of Exile\ButtonClipboardHover.png"
}
else {
	FileGetSize, sourceFileSize, resources\skins\Path of Exile\ButtonClipboardHover.png
	FileGetSize, destFileSize, % PROGRAM.SKINS_FOLDER "\Path of Exile\ButtonClipboardHover.png"
}
if (sourceFileSize != destFileSize)
	FileInstall, resources\skins\Path of Exile\ButtonClipboardHover.png, % PROGRAM.SKINS_FOLDER "\Path of Exile\ButtonClipboardHover.png", 1
if (ErrorLevel) {
	AppendToLogs("Failed to extract file!"
	.	"`nSource: resources\skins\Path of Exile\ButtonClipboardHover.png"
	.	"`nDest: " PROGRAM.SKINS_FOLDER "\Path of Exile\ButtonClipboardHover.png"
	.	"`nFlag: " 2)
	errorLog .= "`n`n""Failed to extract file!"
	.	"`nSource: resources\skins\Path of Exile\ButtonClipboardHover.png"
	.	"`nDest: " PROGRAM.SKINS_FOLDER "\Path of Exile\ButtonClipboardHover.png"
	.	"`nFlag: " 2
}

; ----------------------------
if !InStr(FileExist(PROGRAM.SKINS_FOLDER "\Path of Exile"), "D")
	FileCreateDir,% PROGRAM.SKINS_FOLDER "\Path of Exile"

if (A_IsCompiled) {
	sourceFileSize := Get_ResourceSize("resources\skins\Path of Exile\ButtonClipboardPress.png")
	FileGetSize, destFileSize, % PROGRAM.SKINS_FOLDER "\Path of Exile\ButtonClipboardPress.png"
}
else {
	FileGetSize, sourceFileSize, resources\skins\Path of Exile\ButtonClipboardPress.png
	FileGetSize, destFileSize, % PROGRAM.SKINS_FOLDER "\Path of Exile\ButtonClipboardPress.png"
}
if (sourceFileSize != destFileSize)
	FileInstall, resources\skins\Path of Exile\ButtonClipboardPress.png, % PROGRAM.SKINS_FOLDER "\Path of Exile\ButtonClipboardPress.png", 1
if (ErrorLevel) {
	AppendToLogs("Failed to extract file!"
	.	"`nSource: resources\skins\Path of Exile\ButtonClipboardPress.png"
	.	"`nDest: " PROGRAM.SKINS_FOLDER "\Path of Exile\ButtonClipboardPress.png"
	.	"`nFlag: " 2)
	errorLog .= "`n`n""Failed to extract file!"
	.	"`nSource: resources\skins\Path of Exile\ButtonClipboardPress.png"
	.	"`nDest: " PROGRAM.SKINS_FOLDER "\Path of Exile\ButtonClipboardPress.png"
	.	"`nFlag: " 2
}

; ----------------------------
if !InStr(FileExist(PROGRAM.SKINS_FOLDER "\Path of Exile"), "D")
	FileCreateDir,% PROGRAM.SKINS_FOLDER "\Path of Exile"

if (A_IsCompiled) {
	sourceFileSize := Get_ResourceSize("resources\skins\Path of Exile\ButtonInvite.png")
	FileGetSize, destFileSize, % PROGRAM.SKINS_FOLDER "\Path of Exile\ButtonInvite.png"
}
else {
	FileGetSize, sourceFileSize, resources\skins\Path of Exile\ButtonInvite.png
	FileGetSize, destFileSize, % PROGRAM.SKINS_FOLDER "\Path of Exile\ButtonInvite.png"
}
if (sourceFileSize != destFileSize)
	FileInstall, resources\skins\Path of Exile\ButtonInvite.png, % PROGRAM.SKINS_FOLDER "\Path of Exile\ButtonInvite.png", 1
if (ErrorLevel) {
	AppendToLogs("Failed to extract file!"
	.	"`nSource: resources\skins\Path of Exile\ButtonInvite.png"
	.	"`nDest: " PROGRAM.SKINS_FOLDER "\Path of Exile\ButtonInvite.png"
	.	"`nFlag: " 2)
	errorLog .= "`n`n""Failed to extract file!"
	.	"`nSource: resources\skins\Path of Exile\ButtonInvite.png"
	.	"`nDest: " PROGRAM.SKINS_FOLDER "\Path of Exile\ButtonInvite.png"
	.	"`nFlag: " 2
}

; ----------------------------
if !InStr(FileExist(PROGRAM.SKINS_FOLDER "\Path of Exile"), "D")
	FileCreateDir,% PROGRAM.SKINS_FOLDER "\Path of Exile"

if (A_IsCompiled) {
	sourceFileSize := Get_ResourceSize("resources\skins\Path of Exile\ButtonInviteHover.png")
	FileGetSize, destFileSize, % PROGRAM.SKINS_FOLDER "\Path of Exile\ButtonInviteHover.png"
}
else {
	FileGetSize, sourceFileSize, resources\skins\Path of Exile\ButtonInviteHover.png
	FileGetSize, destFileSize, % PROGRAM.SKINS_FOLDER "\Path of Exile\ButtonInviteHover.png"
}
if (sourceFileSize != destFileSize)
	FileInstall, resources\skins\Path of Exile\ButtonInviteHover.png, % PROGRAM.SKINS_FOLDER "\Path of Exile\ButtonInviteHover.png", 1
if (ErrorLevel) {
	AppendToLogs("Failed to extract file!"
	.	"`nSource: resources\skins\Path of Exile\ButtonInviteHover.png"
	.	"`nDest: " PROGRAM.SKINS_FOLDER "\Path of Exile\ButtonInviteHover.png"
	.	"`nFlag: " 2)
	errorLog .= "`n`n""Failed to extract file!"
	.	"`nSource: resources\skins\Path of Exile\ButtonInviteHover.png"
	.	"`nDest: " PROGRAM.SKINS_FOLDER "\Path of Exile\ButtonInviteHover.png"
	.	"`nFlag: " 2
}

; ----------------------------
if !InStr(FileExist(PROGRAM.SKINS_FOLDER "\Path of Exile"), "D")
	FileCreateDir,% PROGRAM.SKINS_FOLDER "\Path of Exile"

if (A_IsCompiled) {
	sourceFileSize := Get_ResourceSize("resources\skins\Path of Exile\ButtonInvitePress.png")
	FileGetSize, destFileSize, % PROGRAM.SKINS_FOLDER "\Path of Exile\ButtonInvitePress.png"
}
else {
	FileGetSize, sourceFileSize, resources\skins\Path of Exile\ButtonInvitePress.png
	FileGetSize, destFileSize, % PROGRAM.SKINS_FOLDER "\Path of Exile\ButtonInvitePress.png"
}
if (sourceFileSize != destFileSize)
	FileInstall, resources\skins\Path of Exile\ButtonInvitePress.png, % PROGRAM.SKINS_FOLDER "\Path of Exile\ButtonInvitePress.png", 1
if (ErrorLevel) {
	AppendToLogs("Failed to extract file!"
	.	"`nSource: resources\skins\Path of Exile\ButtonInvitePress.png"
	.	"`nDest: " PROGRAM.SKINS_FOLDER "\Path of Exile\ButtonInvitePress.png"
	.	"`nFlag: " 2)
	errorLog .= "`n`n""Failed to extract file!"
	.	"`nSource: resources\skins\Path of Exile\ButtonInvitePress.png"
	.	"`nDest: " PROGRAM.SKINS_FOLDER "\Path of Exile\ButtonInvitePress.png"
	.	"`nFlag: " 2
}

; ----------------------------
if !InStr(FileExist(PROGRAM.SKINS_FOLDER "\Path of Exile"), "D")
	FileCreateDir,% PROGRAM.SKINS_FOLDER "\Path of Exile"

if (A_IsCompiled) {
	sourceFileSize := Get_ResourceSize("resources\skins\Path of Exile\ButtonKick.png")
	FileGetSize, destFileSize, % PROGRAM.SKINS_FOLDER "\Path of Exile\ButtonKick.png"
}
else {
	FileGetSize, sourceFileSize, resources\skins\Path of Exile\ButtonKick.png
	FileGetSize, destFileSize, % PROGRAM.SKINS_FOLDER "\Path of Exile\ButtonKick.png"
}
if (sourceFileSize != destFileSize)
	FileInstall, resources\skins\Path of Exile\ButtonKick.png, % PROGRAM.SKINS_FOLDER "\Path of Exile\ButtonKick.png", 1
if (ErrorLevel) {
	AppendToLogs("Failed to extract file!"
	.	"`nSource: resources\skins\Path of Exile\ButtonKick.png"
	.	"`nDest: " PROGRAM.SKINS_FOLDER "\Path of Exile\ButtonKick.png"
	.	"`nFlag: " 2)
	errorLog .= "`n`n""Failed to extract file!"
	.	"`nSource: resources\skins\Path of Exile\ButtonKick.png"
	.	"`nDest: " PROGRAM.SKINS_FOLDER "\Path of Exile\ButtonKick.png"
	.	"`nFlag: " 2
}

; ----------------------------
if !InStr(FileExist(PROGRAM.SKINS_FOLDER "\Path of Exile"), "D")
	FileCreateDir,% PROGRAM.SKINS_FOLDER "\Path of Exile"

if (A_IsCompiled) {
	sourceFileSize := Get_ResourceSize("resources\skins\Path of Exile\ButtonKickHover.png")
	FileGetSize, destFileSize, % PROGRAM.SKINS_FOLDER "\Path of Exile\ButtonKickHover.png"
}
else {
	FileGetSize, sourceFileSize, resources\skins\Path of Exile\ButtonKickHover.png
	FileGetSize, destFileSize, % PROGRAM.SKINS_FOLDER "\Path of Exile\ButtonKickHover.png"
}
if (sourceFileSize != destFileSize)
	FileInstall, resources\skins\Path of Exile\ButtonKickHover.png, % PROGRAM.SKINS_FOLDER "\Path of Exile\ButtonKickHover.png", 1
if (ErrorLevel) {
	AppendToLogs("Failed to extract file!"
	.	"`nSource: resources\skins\Path of Exile\ButtonKickHover.png"
	.	"`nDest: " PROGRAM.SKINS_FOLDER "\Path of Exile\ButtonKickHover.png"
	.	"`nFlag: " 2)
	errorLog .= "`n`n""Failed to extract file!"
	.	"`nSource: resources\skins\Path of Exile\ButtonKickHover.png"
	.	"`nDest: " PROGRAM.SKINS_FOLDER "\Path of Exile\ButtonKickHover.png"
	.	"`nFlag: " 2
}

; ----------------------------
if !InStr(FileExist(PROGRAM.SKINS_FOLDER "\Path of Exile"), "D")
	FileCreateDir,% PROGRAM.SKINS_FOLDER "\Path of Exile"

if (A_IsCompiled) {
	sourceFileSize := Get_ResourceSize("resources\skins\Path of Exile\ButtonKickPress.png")
	FileGetSize, destFileSize, % PROGRAM.SKINS_FOLDER "\Path of Exile\ButtonKickPress.png"
}
else {
	FileGetSize, sourceFileSize, resources\skins\Path of Exile\ButtonKickPress.png
	FileGetSize, destFileSize, % PROGRAM.SKINS_FOLDER "\Path of Exile\ButtonKickPress.png"
}
if (sourceFileSize != destFileSize)
	FileInstall, resources\skins\Path of Exile\ButtonKickPress.png, % PROGRAM.SKINS_FOLDER "\Path of Exile\ButtonKickPress.png", 1
if (ErrorLevel) {
	AppendToLogs("Failed to extract file!"
	.	"`nSource: resources\skins\Path of Exile\ButtonKickPress.png"
	.	"`nDest: " PROGRAM.SKINS_FOLDER "\Path of Exile\ButtonKickPress.png"
	.	"`nFlag: " 2)
	errorLog .= "`n`n""Failed to extract file!"
	.	"`nSource: resources\skins\Path of Exile\ButtonKickPress.png"
	.	"`nDest: " PROGRAM.SKINS_FOLDER "\Path of Exile\ButtonKickPress.png"
	.	"`nFlag: " 2
}

; ----------------------------
if !InStr(FileExist(PROGRAM.SKINS_FOLDER "\Path of Exile"), "D")
	FileCreateDir,% PROGRAM.SKINS_FOLDER "\Path of Exile"

if (A_IsCompiled) {
	sourceFileSize := Get_ResourceSize("resources\skins\Path of Exile\ButtonOneThird.png")
	FileGetSize, destFileSize, % PROGRAM.SKINS_FOLDER "\Path of Exile\ButtonOneThird.png"
}
else {
	FileGetSize, sourceFileSize, resources\skins\Path of Exile\ButtonOneThird.png
	FileGetSize, destFileSize, % PROGRAM.SKINS_FOLDER "\Path of Exile\ButtonOneThird.png"
}
if (sourceFileSize != destFileSize)
	FileInstall, resources\skins\Path of Exile\ButtonOneThird.png, % PROGRAM.SKINS_FOLDER "\Path of Exile\ButtonOneThird.png", 1
if (ErrorLevel) {
	AppendToLogs("Failed to extract file!"
	.	"`nSource: resources\skins\Path of Exile\ButtonOneThird.png"
	.	"`nDest: " PROGRAM.SKINS_FOLDER "\Path of Exile\ButtonOneThird.png"
	.	"`nFlag: " 2)
	errorLog .= "`n`n""Failed to extract file!"
	.	"`nSource: resources\skins\Path of Exile\ButtonOneThird.png"
	.	"`nDest: " PROGRAM.SKINS_FOLDER "\Path of Exile\ButtonOneThird.png"
	.	"`nFlag: " 2
}

; ----------------------------
if !InStr(FileExist(PROGRAM.SKINS_FOLDER "\Path of Exile"), "D")
	FileCreateDir,% PROGRAM.SKINS_FOLDER "\Path of Exile"

if (A_IsCompiled) {
	sourceFileSize := Get_ResourceSize("resources\skins\Path of Exile\ButtonOneThirdHover.png")
	FileGetSize, destFileSize, % PROGRAM.SKINS_FOLDER "\Path of Exile\ButtonOneThirdHover.png"
}
else {
	FileGetSize, sourceFileSize, resources\skins\Path of Exile\ButtonOneThirdHover.png
	FileGetSize, destFileSize, % PROGRAM.SKINS_FOLDER "\Path of Exile\ButtonOneThirdHover.png"
}
if (sourceFileSize != destFileSize)
	FileInstall, resources\skins\Path of Exile\ButtonOneThirdHover.png, % PROGRAM.SKINS_FOLDER "\Path of Exile\ButtonOneThirdHover.png", 1
if (ErrorLevel) {
	AppendToLogs("Failed to extract file!"
	.	"`nSource: resources\skins\Path of Exile\ButtonOneThirdHover.png"
	.	"`nDest: " PROGRAM.SKINS_FOLDER "\Path of Exile\ButtonOneThirdHover.png"
	.	"`nFlag: " 2)
	errorLog .= "`n`n""Failed to extract file!"
	.	"`nSource: resources\skins\Path of Exile\ButtonOneThirdHover.png"
	.	"`nDest: " PROGRAM.SKINS_FOLDER "\Path of Exile\ButtonOneThirdHover.png"
	.	"`nFlag: " 2
}

; ----------------------------
if !InStr(FileExist(PROGRAM.SKINS_FOLDER "\Path of Exile"), "D")
	FileCreateDir,% PROGRAM.SKINS_FOLDER "\Path of Exile"

if (A_IsCompiled) {
	sourceFileSize := Get_ResourceSize("resources\skins\Path of Exile\ButtonOneThirdPress.png")
	FileGetSize, destFileSize, % PROGRAM.SKINS_FOLDER "\Path of Exile\ButtonOneThirdPress.png"
}
else {
	FileGetSize, sourceFileSize, resources\skins\Path of Exile\ButtonOneThirdPress.png
	FileGetSize, destFileSize, % PROGRAM.SKINS_FOLDER "\Path of Exile\ButtonOneThirdPress.png"
}
if (sourceFileSize != destFileSize)
	FileInstall, resources\skins\Path of Exile\ButtonOneThirdPress.png, % PROGRAM.SKINS_FOLDER "\Path of Exile\ButtonOneThirdPress.png", 1
if (ErrorLevel) {
	AppendToLogs("Failed to extract file!"
	.	"`nSource: resources\skins\Path of Exile\ButtonOneThirdPress.png"
	.	"`nDest: " PROGRAM.SKINS_FOLDER "\Path of Exile\ButtonOneThirdPress.png"
	.	"`nFlag: " 2)
	errorLog .= "`n`n""Failed to extract file!"
	.	"`nSource: resources\skins\Path of Exile\ButtonOneThirdPress.png"
	.	"`nDest: " PROGRAM.SKINS_FOLDER "\Path of Exile\ButtonOneThirdPress.png"
	.	"`nFlag: " 2
}

; ----------------------------
if !InStr(FileExist(PROGRAM.SKINS_FOLDER "\Path of Exile"), "D")
	FileCreateDir,% PROGRAM.SKINS_FOLDER "\Path of Exile"

if (A_IsCompiled) {
	sourceFileSize := Get_ResourceSize("resources\skins\Path of Exile\ButtonThreeThird.png")
	FileGetSize, destFileSize, % PROGRAM.SKINS_FOLDER "\Path of Exile\ButtonThreeThird.png"
}
else {
	FileGetSize, sourceFileSize, resources\skins\Path of Exile\ButtonThreeThird.png
	FileGetSize, destFileSize, % PROGRAM.SKINS_FOLDER "\Path of Exile\ButtonThreeThird.png"
}
if (sourceFileSize != destFileSize)
	FileInstall, resources\skins\Path of Exile\ButtonThreeThird.png, % PROGRAM.SKINS_FOLDER "\Path of Exile\ButtonThreeThird.png", 1
if (ErrorLevel) {
	AppendToLogs("Failed to extract file!"
	.	"`nSource: resources\skins\Path of Exile\ButtonThreeThird.png"
	.	"`nDest: " PROGRAM.SKINS_FOLDER "\Path of Exile\ButtonThreeThird.png"
	.	"`nFlag: " 2)
	errorLog .= "`n`n""Failed to extract file!"
	.	"`nSource: resources\skins\Path of Exile\ButtonThreeThird.png"
	.	"`nDest: " PROGRAM.SKINS_FOLDER "\Path of Exile\ButtonThreeThird.png"
	.	"`nFlag: " 2
}

; ----------------------------
if !InStr(FileExist(PROGRAM.SKINS_FOLDER "\Path of Exile"), "D")
	FileCreateDir,% PROGRAM.SKINS_FOLDER "\Path of Exile"

if (A_IsCompiled) {
	sourceFileSize := Get_ResourceSize("resources\skins\Path of Exile\ButtonThreeThirdHover.png")
	FileGetSize, destFileSize, % PROGRAM.SKINS_FOLDER "\Path of Exile\ButtonThreeThirdHover.png"
}
else {
	FileGetSize, sourceFileSize, resources\skins\Path of Exile\ButtonThreeThirdHover.png
	FileGetSize, destFileSize, % PROGRAM.SKINS_FOLDER "\Path of Exile\ButtonThreeThirdHover.png"
}
if (sourceFileSize != destFileSize)
	FileInstall, resources\skins\Path of Exile\ButtonThreeThirdHover.png, % PROGRAM.SKINS_FOLDER "\Path of Exile\ButtonThreeThirdHover.png", 1
if (ErrorLevel) {
	AppendToLogs("Failed to extract file!"
	.	"`nSource: resources\skins\Path of Exile\ButtonThreeThirdHover.png"
	.	"`nDest: " PROGRAM.SKINS_FOLDER "\Path of Exile\ButtonThreeThirdHover.png"
	.	"`nFlag: " 2)
	errorLog .= "`n`n""Failed to extract file!"
	.	"`nSource: resources\skins\Path of Exile\ButtonThreeThirdHover.png"
	.	"`nDest: " PROGRAM.SKINS_FOLDER "\Path of Exile\ButtonThreeThirdHover.png"
	.	"`nFlag: " 2
}

; ----------------------------
if !InStr(FileExist(PROGRAM.SKINS_FOLDER "\Path of Exile"), "D")
	FileCreateDir,% PROGRAM.SKINS_FOLDER "\Path of Exile"

if (A_IsCompiled) {
	sourceFileSize := Get_ResourceSize("resources\skins\Path of Exile\ButtonThreeThirdPress.png")
	FileGetSize, destFileSize, % PROGRAM.SKINS_FOLDER "\Path of Exile\ButtonThreeThirdPress.png"
}
else {
	FileGetSize, sourceFileSize, resources\skins\Path of Exile\ButtonThreeThirdPress.png
	FileGetSize, destFileSize, % PROGRAM.SKINS_FOLDER "\Path of Exile\ButtonThreeThirdPress.png"
}
if (sourceFileSize != destFileSize)
	FileInstall, resources\skins\Path of Exile\ButtonThreeThirdPress.png, % PROGRAM.SKINS_FOLDER "\Path of Exile\ButtonThreeThirdPress.png", 1
if (ErrorLevel) {
	AppendToLogs("Failed to extract file!"
	.	"`nSource: resources\skins\Path of Exile\ButtonThreeThirdPress.png"
	.	"`nDest: " PROGRAM.SKINS_FOLDER "\Path of Exile\ButtonThreeThirdPress.png"
	.	"`nFlag: " 2)
	errorLog .= "`n`n""Failed to extract file!"
	.	"`nSource: resources\skins\Path of Exile\ButtonThreeThirdPress.png"
	.	"`nDest: " PROGRAM.SKINS_FOLDER "\Path of Exile\ButtonThreeThirdPress.png"
	.	"`nFlag: " 2
}

; ----------------------------
if !InStr(FileExist(PROGRAM.SKINS_FOLDER "\Path of Exile"), "D")
	FileCreateDir,% PROGRAM.SKINS_FOLDER "\Path of Exile"

if (A_IsCompiled) {
	sourceFileSize := Get_ResourceSize("resources\skins\Path of Exile\ButtonTrade.png")
	FileGetSize, destFileSize, % PROGRAM.SKINS_FOLDER "\Path of Exile\ButtonTrade.png"
}
else {
	FileGetSize, sourceFileSize, resources\skins\Path of Exile\ButtonTrade.png
	FileGetSize, destFileSize, % PROGRAM.SKINS_FOLDER "\Path of Exile\ButtonTrade.png"
}
if (sourceFileSize != destFileSize)
	FileInstall, resources\skins\Path of Exile\ButtonTrade.png, % PROGRAM.SKINS_FOLDER "\Path of Exile\ButtonTrade.png", 1
if (ErrorLevel) {
	AppendToLogs("Failed to extract file!"
	.	"`nSource: resources\skins\Path of Exile\ButtonTrade.png"
	.	"`nDest: " PROGRAM.SKINS_FOLDER "\Path of Exile\ButtonTrade.png"
	.	"`nFlag: " 2)
	errorLog .= "`n`n""Failed to extract file!"
	.	"`nSource: resources\skins\Path of Exile\ButtonTrade.png"
	.	"`nDest: " PROGRAM.SKINS_FOLDER "\Path of Exile\ButtonTrade.png"
	.	"`nFlag: " 2
}

; ----------------------------
if !InStr(FileExist(PROGRAM.SKINS_FOLDER "\Path of Exile"), "D")
	FileCreateDir,% PROGRAM.SKINS_FOLDER "\Path of Exile"

if (A_IsCompiled) {
	sourceFileSize := Get_ResourceSize("resources\skins\Path of Exile\ButtonTradeHover.png")
	FileGetSize, destFileSize, % PROGRAM.SKINS_FOLDER "\Path of Exile\ButtonTradeHover.png"
}
else {
	FileGetSize, sourceFileSize, resources\skins\Path of Exile\ButtonTradeHover.png
	FileGetSize, destFileSize, % PROGRAM.SKINS_FOLDER "\Path of Exile\ButtonTradeHover.png"
}
if (sourceFileSize != destFileSize)
	FileInstall, resources\skins\Path of Exile\ButtonTradeHover.png, % PROGRAM.SKINS_FOLDER "\Path of Exile\ButtonTradeHover.png", 1
if (ErrorLevel) {
	AppendToLogs("Failed to extract file!"
	.	"`nSource: resources\skins\Path of Exile\ButtonTradeHover.png"
	.	"`nDest: " PROGRAM.SKINS_FOLDER "\Path of Exile\ButtonTradeHover.png"
	.	"`nFlag: " 2)
	errorLog .= "`n`n""Failed to extract file!"
	.	"`nSource: resources\skins\Path of Exile\ButtonTradeHover.png"
	.	"`nDest: " PROGRAM.SKINS_FOLDER "\Path of Exile\ButtonTradeHover.png"
	.	"`nFlag: " 2
}

; ----------------------------
if !InStr(FileExist(PROGRAM.SKINS_FOLDER "\Path of Exile"), "D")
	FileCreateDir,% PROGRAM.SKINS_FOLDER "\Path of Exile"

if (A_IsCompiled) {
	sourceFileSize := Get_ResourceSize("resources\skins\Path of Exile\ButtonTradePress.png")
	FileGetSize, destFileSize, % PROGRAM.SKINS_FOLDER "\Path of Exile\ButtonTradePress.png"
}
else {
	FileGetSize, sourceFileSize, resources\skins\Path of Exile\ButtonTradePress.png
	FileGetSize, destFileSize, % PROGRAM.SKINS_FOLDER "\Path of Exile\ButtonTradePress.png"
}
if (sourceFileSize != destFileSize)
	FileInstall, resources\skins\Path of Exile\ButtonTradePress.png, % PROGRAM.SKINS_FOLDER "\Path of Exile\ButtonTradePress.png", 1
if (ErrorLevel) {
	AppendToLogs("Failed to extract file!"
	.	"`nSource: resources\skins\Path of Exile\ButtonTradePress.png"
	.	"`nDest: " PROGRAM.SKINS_FOLDER "\Path of Exile\ButtonTradePress.png"
	.	"`nFlag: " 2)
	errorLog .= "`n`n""Failed to extract file!"
	.	"`nSource: resources\skins\Path of Exile\ButtonTradePress.png"
	.	"`nDest: " PROGRAM.SKINS_FOLDER "\Path of Exile\ButtonTradePress.png"
	.	"`nFlag: " 2
}

; ----------------------------
if !InStr(FileExist(PROGRAM.SKINS_FOLDER "\Path of Exile"), "D")
	FileCreateDir,% PROGRAM.SKINS_FOLDER "\Path of Exile"

if (A_IsCompiled) {
	sourceFileSize := Get_ResourceSize("resources\skins\Path of Exile\ButtonTwoThird.png")
	FileGetSize, destFileSize, % PROGRAM.SKINS_FOLDER "\Path of Exile\ButtonTwoThird.png"
}
else {
	FileGetSize, sourceFileSize, resources\skins\Path of Exile\ButtonTwoThird.png
	FileGetSize, destFileSize, % PROGRAM.SKINS_FOLDER "\Path of Exile\ButtonTwoThird.png"
}
if (sourceFileSize != destFileSize)
	FileInstall, resources\skins\Path of Exile\ButtonTwoThird.png, % PROGRAM.SKINS_FOLDER "\Path of Exile\ButtonTwoThird.png", 1
if (ErrorLevel) {
	AppendToLogs("Failed to extract file!"
	.	"`nSource: resources\skins\Path of Exile\ButtonTwoThird.png"
	.	"`nDest: " PROGRAM.SKINS_FOLDER "\Path of Exile\ButtonTwoThird.png"
	.	"`nFlag: " 2)
	errorLog .= "`n`n""Failed to extract file!"
	.	"`nSource: resources\skins\Path of Exile\ButtonTwoThird.png"
	.	"`nDest: " PROGRAM.SKINS_FOLDER "\Path of Exile\ButtonTwoThird.png"
	.	"`nFlag: " 2
}

; ----------------------------
if !InStr(FileExist(PROGRAM.SKINS_FOLDER "\Path of Exile"), "D")
	FileCreateDir,% PROGRAM.SKINS_FOLDER "\Path of Exile"

if (A_IsCompiled) {
	sourceFileSize := Get_ResourceSize("resources\skins\Path of Exile\ButtonTwoThirdHover.png")
	FileGetSize, destFileSize, % PROGRAM.SKINS_FOLDER "\Path of Exile\ButtonTwoThirdHover.png"
}
else {
	FileGetSize, sourceFileSize, resources\skins\Path of Exile\ButtonTwoThirdHover.png
	FileGetSize, destFileSize, % PROGRAM.SKINS_FOLDER "\Path of Exile\ButtonTwoThirdHover.png"
}
if (sourceFileSize != destFileSize)
	FileInstall, resources\skins\Path of Exile\ButtonTwoThirdHover.png, % PROGRAM.SKINS_FOLDER "\Path of Exile\ButtonTwoThirdHover.png", 1
if (ErrorLevel) {
	AppendToLogs("Failed to extract file!"
	.	"`nSource: resources\skins\Path of Exile\ButtonTwoThirdHover.png"
	.	"`nDest: " PROGRAM.SKINS_FOLDER "\Path of Exile\ButtonTwoThirdHover.png"
	.	"`nFlag: " 2)
	errorLog .= "`n`n""Failed to extract file!"
	.	"`nSource: resources\skins\Path of Exile\ButtonTwoThirdHover.png"
	.	"`nDest: " PROGRAM.SKINS_FOLDER "\Path of Exile\ButtonTwoThirdHover.png"
	.	"`nFlag: " 2
}

; ----------------------------
if !InStr(FileExist(PROGRAM.SKINS_FOLDER "\Path of Exile"), "D")
	FileCreateDir,% PROGRAM.SKINS_FOLDER "\Path of Exile"

if (A_IsCompiled) {
	sourceFileSize := Get_ResourceSize("resources\skins\Path of Exile\ButtonTwoThirdPress.png")
	FileGetSize, destFileSize, % PROGRAM.SKINS_FOLDER "\Path of Exile\ButtonTwoThirdPress.png"
}
else {
	FileGetSize, sourceFileSize, resources\skins\Path of Exile\ButtonTwoThirdPress.png
	FileGetSize, destFileSize, % PROGRAM.SKINS_FOLDER "\Path of Exile\ButtonTwoThirdPress.png"
}
if (sourceFileSize != destFileSize)
	FileInstall, resources\skins\Path of Exile\ButtonTwoThirdPress.png, % PROGRAM.SKINS_FOLDER "\Path of Exile\ButtonTwoThirdPress.png", 1
if (ErrorLevel) {
	AppendToLogs("Failed to extract file!"
	.	"`nSource: resources\skins\Path of Exile\ButtonTwoThirdPress.png"
	.	"`nDest: " PROGRAM.SKINS_FOLDER "\Path of Exile\ButtonTwoThirdPress.png"
	.	"`nFlag: " 2)
	errorLog .= "`n`n""Failed to extract file!"
	.	"`nSource: resources\skins\Path of Exile\ButtonTwoThirdPress.png"
	.	"`nDest: " PROGRAM.SKINS_FOLDER "\Path of Exile\ButtonTwoThirdPress.png"
	.	"`nFlag: " 2
}

; ----------------------------
if !InStr(FileExist(PROGRAM.SKINS_FOLDER "\Path of Exile"), "D")
	FileCreateDir,% PROGRAM.SKINS_FOLDER "\Path of Exile"

if (A_IsCompiled) {
	sourceFileSize := Get_ResourceSize("resources\skins\Path of Exile\ButtonWhisper.png")
	FileGetSize, destFileSize, % PROGRAM.SKINS_FOLDER "\Path of Exile\ButtonWhisper.png"
}
else {
	FileGetSize, sourceFileSize, resources\skins\Path of Exile\ButtonWhisper.png
	FileGetSize, destFileSize, % PROGRAM.SKINS_FOLDER "\Path of Exile\ButtonWhisper.png"
}
if (sourceFileSize != destFileSize)
	FileInstall, resources\skins\Path of Exile\ButtonWhisper.png, % PROGRAM.SKINS_FOLDER "\Path of Exile\ButtonWhisper.png", 1
if (ErrorLevel) {
	AppendToLogs("Failed to extract file!"
	.	"`nSource: resources\skins\Path of Exile\ButtonWhisper.png"
	.	"`nDest: " PROGRAM.SKINS_FOLDER "\Path of Exile\ButtonWhisper.png"
	.	"`nFlag: " 2)
	errorLog .= "`n`n""Failed to extract file!"
	.	"`nSource: resources\skins\Path of Exile\ButtonWhisper.png"
	.	"`nDest: " PROGRAM.SKINS_FOLDER "\Path of Exile\ButtonWhisper.png"
	.	"`nFlag: " 2
}

; ----------------------------
if !InStr(FileExist(PROGRAM.SKINS_FOLDER "\Path of Exile"), "D")
	FileCreateDir,% PROGRAM.SKINS_FOLDER "\Path of Exile"

if (A_IsCompiled) {
	sourceFileSize := Get_ResourceSize("resources\skins\Path of Exile\ButtonWhisperHover.png")
	FileGetSize, destFileSize, % PROGRAM.SKINS_FOLDER "\Path of Exile\ButtonWhisperHover.png"
}
else {
	FileGetSize, sourceFileSize, resources\skins\Path of Exile\ButtonWhisperHover.png
	FileGetSize, destFileSize, % PROGRAM.SKINS_FOLDER "\Path of Exile\ButtonWhisperHover.png"
}
if (sourceFileSize != destFileSize)
	FileInstall, resources\skins\Path of Exile\ButtonWhisperHover.png, % PROGRAM.SKINS_FOLDER "\Path of Exile\ButtonWhisperHover.png", 1
if (ErrorLevel) {
	AppendToLogs("Failed to extract file!"
	.	"`nSource: resources\skins\Path of Exile\ButtonWhisperHover.png"
	.	"`nDest: " PROGRAM.SKINS_FOLDER "\Path of Exile\ButtonWhisperHover.png"
	.	"`nFlag: " 2)
	errorLog .= "`n`n""Failed to extract file!"
	.	"`nSource: resources\skins\Path of Exile\ButtonWhisperHover.png"
	.	"`nDest: " PROGRAM.SKINS_FOLDER "\Path of Exile\ButtonWhisperHover.png"
	.	"`nFlag: " 2
}

; ----------------------------
if !InStr(FileExist(PROGRAM.SKINS_FOLDER "\Path of Exile"), "D")
	FileCreateDir,% PROGRAM.SKINS_FOLDER "\Path of Exile"

if (A_IsCompiled) {
	sourceFileSize := Get_ResourceSize("resources\skins\Path of Exile\ButtonWhisperPress.png")
	FileGetSize, destFileSize, % PROGRAM.SKINS_FOLDER "\Path of Exile\ButtonWhisperPress.png"
}
else {
	FileGetSize, sourceFileSize, resources\skins\Path of Exile\ButtonWhisperPress.png
	FileGetSize, destFileSize, % PROGRAM.SKINS_FOLDER "\Path of Exile\ButtonWhisperPress.png"
}
if (sourceFileSize != destFileSize)
	FileInstall, resources\skins\Path of Exile\ButtonWhisperPress.png, % PROGRAM.SKINS_FOLDER "\Path of Exile\ButtonWhisperPress.png", 1
if (ErrorLevel) {
	AppendToLogs("Failed to extract file!"
	.	"`nSource: resources\skins\Path of Exile\ButtonWhisperPress.png"
	.	"`nDest: " PROGRAM.SKINS_FOLDER "\Path of Exile\ButtonWhisperPress.png"
	.	"`nFlag: " 2)
	errorLog .= "`n`n""Failed to extract file!"
	.	"`nSource: resources\skins\Path of Exile\ButtonWhisperPress.png"
	.	"`nDest: " PROGRAM.SKINS_FOLDER "\Path of Exile\ButtonWhisperPress.png"
	.	"`nFlag: " 2
}

; ----------------------------
if !InStr(FileExist(PROGRAM.SKINS_FOLDER "\Path of Exile"), "D")
	FileCreateDir,% PROGRAM.SKINS_FOLDER "\Path of Exile"

if (A_IsCompiled) {
	sourceFileSize := Get_ResourceSize("resources\skins\Path of Exile\CloseTab.png")
	FileGetSize, destFileSize, % PROGRAM.SKINS_FOLDER "\Path of Exile\CloseTab.png"
}
else {
	FileGetSize, sourceFileSize, resources\skins\Path of Exile\CloseTab.png
	FileGetSize, destFileSize, % PROGRAM.SKINS_FOLDER "\Path of Exile\CloseTab.png"
}
if (sourceFileSize != destFileSize)
	FileInstall, resources\skins\Path of Exile\CloseTab.png, % PROGRAM.SKINS_FOLDER "\Path of Exile\CloseTab.png", 1
if (ErrorLevel) {
	AppendToLogs("Failed to extract file!"
	.	"`nSource: resources\skins\Path of Exile\CloseTab.png"
	.	"`nDest: " PROGRAM.SKINS_FOLDER "\Path of Exile\CloseTab.png"
	.	"`nFlag: " 2)
	errorLog .= "`n`n""Failed to extract file!"
	.	"`nSource: resources\skins\Path of Exile\CloseTab.png"
	.	"`nDest: " PROGRAM.SKINS_FOLDER "\Path of Exile\CloseTab.png"
	.	"`nFlag: " 2
}

; ----------------------------
if !InStr(FileExist(PROGRAM.SKINS_FOLDER "\Path of Exile"), "D")
	FileCreateDir,% PROGRAM.SKINS_FOLDER "\Path of Exile"

if (A_IsCompiled) {
	sourceFileSize := Get_ResourceSize("resources\skins\Path of Exile\CloseTabHover.png")
	FileGetSize, destFileSize, % PROGRAM.SKINS_FOLDER "\Path of Exile\CloseTabHover.png"
}
else {
	FileGetSize, sourceFileSize, resources\skins\Path of Exile\CloseTabHover.png
	FileGetSize, destFileSize, % PROGRAM.SKINS_FOLDER "\Path of Exile\CloseTabHover.png"
}
if (sourceFileSize != destFileSize)
	FileInstall, resources\skins\Path of Exile\CloseTabHover.png, % PROGRAM.SKINS_FOLDER "\Path of Exile\CloseTabHover.png", 1
if (ErrorLevel) {
	AppendToLogs("Failed to extract file!"
	.	"`nSource: resources\skins\Path of Exile\CloseTabHover.png"
	.	"`nDest: " PROGRAM.SKINS_FOLDER "\Path of Exile\CloseTabHover.png"
	.	"`nFlag: " 2)
	errorLog .= "`n`n""Failed to extract file!"
	.	"`nSource: resources\skins\Path of Exile\CloseTabHover.png"
	.	"`nDest: " PROGRAM.SKINS_FOLDER "\Path of Exile\CloseTabHover.png"
	.	"`nFlag: " 2
}

; ----------------------------
if !InStr(FileExist(PROGRAM.SKINS_FOLDER "\Path of Exile"), "D")
	FileCreateDir,% PROGRAM.SKINS_FOLDER "\Path of Exile"

if (A_IsCompiled) {
	sourceFileSize := Get_ResourceSize("resources\skins\Path of Exile\CloseTabPress.png")
	FileGetSize, destFileSize, % PROGRAM.SKINS_FOLDER "\Path of Exile\CloseTabPress.png"
}
else {
	FileGetSize, sourceFileSize, resources\skins\Path of Exile\CloseTabPress.png
	FileGetSize, destFileSize, % PROGRAM.SKINS_FOLDER "\Path of Exile\CloseTabPress.png"
}
if (sourceFileSize != destFileSize)
	FileInstall, resources\skins\Path of Exile\CloseTabPress.png, % PROGRAM.SKINS_FOLDER "\Path of Exile\CloseTabPress.png", 1
if (ErrorLevel) {
	AppendToLogs("Failed to extract file!"
	.	"`nSource: resources\skins\Path of Exile\CloseTabPress.png"
	.	"`nDest: " PROGRAM.SKINS_FOLDER "\Path of Exile\CloseTabPress.png"
	.	"`nFlag: " 2)
	errorLog .= "`n`n""Failed to extract file!"
	.	"`nSource: resources\skins\Path of Exile\CloseTabPress.png"
	.	"`nDest: " PROGRAM.SKINS_FOLDER "\Path of Exile\CloseTabPress.png"
	.	"`nFlag: " 2
}

; ----------------------------
if !InStr(FileExist(PROGRAM.SKINS_FOLDER "\Path of Exile"), "D")
	FileCreateDir,% PROGRAM.SKINS_FOLDER "\Path of Exile"

if (A_IsCompiled) {
	sourceFileSize := Get_ResourceSize("resources\skins\Path of Exile\Header.png")
	FileGetSize, destFileSize, % PROGRAM.SKINS_FOLDER "\Path of Exile\Header.png"
}
else {
	FileGetSize, sourceFileSize, resources\skins\Path of Exile\Header.png
	FileGetSize, destFileSize, % PROGRAM.SKINS_FOLDER "\Path of Exile\Header.png"
}
if (sourceFileSize != destFileSize)
	FileInstall, resources\skins\Path of Exile\Header.png, % PROGRAM.SKINS_FOLDER "\Path of Exile\Header.png", 1
if (ErrorLevel) {
	AppendToLogs("Failed to extract file!"
	.	"`nSource: resources\skins\Path of Exile\Header.png"
	.	"`nDest: " PROGRAM.SKINS_FOLDER "\Path of Exile\Header.png"
	.	"`nFlag: " 2)
	errorLog .= "`n`n""Failed to extract file!"
	.	"`nSource: resources\skins\Path of Exile\Header.png"
	.	"`nDest: " PROGRAM.SKINS_FOLDER "\Path of Exile\Header.png"
	.	"`nFlag: " 2
}

; ----------------------------
if !InStr(FileExist(PROGRAM.SKINS_FOLDER "\Path of Exile"), "D")
	FileCreateDir,% PROGRAM.SKINS_FOLDER "\Path of Exile"

if (A_IsCompiled) {
	sourceFileSize := Get_ResourceSize("resources\skins\Path of Exile\HeaderMin.png")
	FileGetSize, destFileSize, % PROGRAM.SKINS_FOLDER "\Path of Exile\HeaderMin.png"
}
else {
	FileGetSize, sourceFileSize, resources\skins\Path of Exile\HeaderMin.png
	FileGetSize, destFileSize, % PROGRAM.SKINS_FOLDER "\Path of Exile\HeaderMin.png"
}
if (sourceFileSize != destFileSize)
	FileInstall, resources\skins\Path of Exile\HeaderMin.png, % PROGRAM.SKINS_FOLDER "\Path of Exile\HeaderMin.png", 1
if (ErrorLevel) {
	AppendToLogs("Failed to extract file!"
	.	"`nSource: resources\skins\Path of Exile\HeaderMin.png"
	.	"`nDest: " PROGRAM.SKINS_FOLDER "\Path of Exile\HeaderMin.png"
	.	"`nFlag: " 2)
	errorLog .= "`n`n""Failed to extract file!"
	.	"`nSource: resources\skins\Path of Exile\HeaderMin.png"
	.	"`nDest: " PROGRAM.SKINS_FOLDER "\Path of Exile\HeaderMin.png"
	.	"`nFlag: " 2
}

; ----------------------------
if !InStr(FileExist(PROGRAM.SKINS_FOLDER "\Path of Exile"), "D")
	FileCreateDir,% PROGRAM.SKINS_FOLDER "\Path of Exile"

if (A_IsCompiled) {
	sourceFileSize := Get_ResourceSize("resources\skins\Path of Exile\Icon.ico")
	FileGetSize, destFileSize, % PROGRAM.SKINS_FOLDER "\Path of Exile\Icon.ico"
}
else {
	FileGetSize, sourceFileSize, resources\skins\Path of Exile\Icon.ico
	FileGetSize, destFileSize, % PROGRAM.SKINS_FOLDER "\Path of Exile\Icon.ico"
}
if (sourceFileSize != destFileSize)
	FileInstall, resources\skins\Path of Exile\Icon.ico, % PROGRAM.SKINS_FOLDER "\Path of Exile\Icon.ico", 1
if (ErrorLevel) {
	AppendToLogs("Failed to extract file!"
	.	"`nSource: resources\skins\Path of Exile\Icon.ico"
	.	"`nDest: " PROGRAM.SKINS_FOLDER "\Path of Exile\Icon.ico"
	.	"`nFlag: " 2)
	errorLog .= "`n`n""Failed to extract file!"
	.	"`nSource: resources\skins\Path of Exile\Icon.ico"
	.	"`nDest: " PROGRAM.SKINS_FOLDER "\Path of Exile\Icon.ico"
	.	"`nFlag: " 2
}

; ----------------------------
if !InStr(FileExist(PROGRAM.SKINS_FOLDER "\Path of Exile"), "D")
	FileCreateDir,% PROGRAM.SKINS_FOLDER "\Path of Exile"

if (A_IsCompiled) {
	sourceFileSize := Get_ResourceSize("resources\skins\Path of Exile\Maximize.png")
	FileGetSize, destFileSize, % PROGRAM.SKINS_FOLDER "\Path of Exile\Maximize.png"
}
else {
	FileGetSize, sourceFileSize, resources\skins\Path of Exile\Maximize.png
	FileGetSize, destFileSize, % PROGRAM.SKINS_FOLDER "\Path of Exile\Maximize.png"
}
if (sourceFileSize != destFileSize)
	FileInstall, resources\skins\Path of Exile\Maximize.png, % PROGRAM.SKINS_FOLDER "\Path of Exile\Maximize.png", 1
if (ErrorLevel) {
	AppendToLogs("Failed to extract file!"
	.	"`nSource: resources\skins\Path of Exile\Maximize.png"
	.	"`nDest: " PROGRAM.SKINS_FOLDER "\Path of Exile\Maximize.png"
	.	"`nFlag: " 2)
	errorLog .= "`n`n""Failed to extract file!"
	.	"`nSource: resources\skins\Path of Exile\Maximize.png"
	.	"`nDest: " PROGRAM.SKINS_FOLDER "\Path of Exile\Maximize.png"
	.	"`nFlag: " 2
}

; ----------------------------
if !InStr(FileExist(PROGRAM.SKINS_FOLDER "\Path of Exile"), "D")
	FileCreateDir,% PROGRAM.SKINS_FOLDER "\Path of Exile"

if (A_IsCompiled) {
	sourceFileSize := Get_ResourceSize("resources\skins\Path of Exile\MaximizeHover.png")
	FileGetSize, destFileSize, % PROGRAM.SKINS_FOLDER "\Path of Exile\MaximizeHover.png"
}
else {
	FileGetSize, sourceFileSize, resources\skins\Path of Exile\MaximizeHover.png
	FileGetSize, destFileSize, % PROGRAM.SKINS_FOLDER "\Path of Exile\MaximizeHover.png"
}
if (sourceFileSize != destFileSize)
	FileInstall, resources\skins\Path of Exile\MaximizeHover.png, % PROGRAM.SKINS_FOLDER "\Path of Exile\MaximizeHover.png", 1
if (ErrorLevel) {
	AppendToLogs("Failed to extract file!"
	.	"`nSource: resources\skins\Path of Exile\MaximizeHover.png"
	.	"`nDest: " PROGRAM.SKINS_FOLDER "\Path of Exile\MaximizeHover.png"
	.	"`nFlag: " 2)
	errorLog .= "`n`n""Failed to extract file!"
	.	"`nSource: resources\skins\Path of Exile\MaximizeHover.png"
	.	"`nDest: " PROGRAM.SKINS_FOLDER "\Path of Exile\MaximizeHover.png"
	.	"`nFlag: " 2
}

; ----------------------------
if !InStr(FileExist(PROGRAM.SKINS_FOLDER "\Path of Exile"), "D")
	FileCreateDir,% PROGRAM.SKINS_FOLDER "\Path of Exile"

if (A_IsCompiled) {
	sourceFileSize := Get_ResourceSize("resources\skins\Path of Exile\MaximizePress.png")
	FileGetSize, destFileSize, % PROGRAM.SKINS_FOLDER "\Path of Exile\MaximizePress.png"
}
else {
	FileGetSize, sourceFileSize, resources\skins\Path of Exile\MaximizePress.png
	FileGetSize, destFileSize, % PROGRAM.SKINS_FOLDER "\Path of Exile\MaximizePress.png"
}
if (sourceFileSize != destFileSize)
	FileInstall, resources\skins\Path of Exile\MaximizePress.png, % PROGRAM.SKINS_FOLDER "\Path of Exile\MaximizePress.png", 1
if (ErrorLevel) {
	AppendToLogs("Failed to extract file!"
	.	"`nSource: resources\skins\Path of Exile\MaximizePress.png"
	.	"`nDest: " PROGRAM.SKINS_FOLDER "\Path of Exile\MaximizePress.png"
	.	"`nFlag: " 2)
	errorLog .= "`n`n""Failed to extract file!"
	.	"`nSource: resources\skins\Path of Exile\MaximizePress.png"
	.	"`nDest: " PROGRAM.SKINS_FOLDER "\Path of Exile\MaximizePress.png"
	.	"`nFlag: " 2
}

; ----------------------------
if !InStr(FileExist(PROGRAM.SKINS_FOLDER "\Path of Exile"), "D")
	FileCreateDir,% PROGRAM.SKINS_FOLDER "\Path of Exile"

if (A_IsCompiled) {
	sourceFileSize := Get_ResourceSize("resources\skins\Path of Exile\Minimize.png")
	FileGetSize, destFileSize, % PROGRAM.SKINS_FOLDER "\Path of Exile\Minimize.png"
}
else {
	FileGetSize, sourceFileSize, resources\skins\Path of Exile\Minimize.png
	FileGetSize, destFileSize, % PROGRAM.SKINS_FOLDER "\Path of Exile\Minimize.png"
}
if (sourceFileSize != destFileSize)
	FileInstall, resources\skins\Path of Exile\Minimize.png, % PROGRAM.SKINS_FOLDER "\Path of Exile\Minimize.png", 1
if (ErrorLevel) {
	AppendToLogs("Failed to extract file!"
	.	"`nSource: resources\skins\Path of Exile\Minimize.png"
	.	"`nDest: " PROGRAM.SKINS_FOLDER "\Path of Exile\Minimize.png"
	.	"`nFlag: " 2)
	errorLog .= "`n`n""Failed to extract file!"
	.	"`nSource: resources\skins\Path of Exile\Minimize.png"
	.	"`nDest: " PROGRAM.SKINS_FOLDER "\Path of Exile\Minimize.png"
	.	"`nFlag: " 2
}

; ----------------------------
if !InStr(FileExist(PROGRAM.SKINS_FOLDER "\Path of Exile"), "D")
	FileCreateDir,% PROGRAM.SKINS_FOLDER "\Path of Exile"

if (A_IsCompiled) {
	sourceFileSize := Get_ResourceSize("resources\skins\Path of Exile\MinimizeHover.png")
	FileGetSize, destFileSize, % PROGRAM.SKINS_FOLDER "\Path of Exile\MinimizeHover.png"
}
else {
	FileGetSize, sourceFileSize, resources\skins\Path of Exile\MinimizeHover.png
	FileGetSize, destFileSize, % PROGRAM.SKINS_FOLDER "\Path of Exile\MinimizeHover.png"
}
if (sourceFileSize != destFileSize)
	FileInstall, resources\skins\Path of Exile\MinimizeHover.png, % PROGRAM.SKINS_FOLDER "\Path of Exile\MinimizeHover.png", 1
if (ErrorLevel) {
	AppendToLogs("Failed to extract file!"
	.	"`nSource: resources\skins\Path of Exile\MinimizeHover.png"
	.	"`nDest: " PROGRAM.SKINS_FOLDER "\Path of Exile\MinimizeHover.png"
	.	"`nFlag: " 2)
	errorLog .= "`n`n""Failed to extract file!"
	.	"`nSource: resources\skins\Path of Exile\MinimizeHover.png"
	.	"`nDest: " PROGRAM.SKINS_FOLDER "\Path of Exile\MinimizeHover.png"
	.	"`nFlag: " 2
}

; ----------------------------
if !InStr(FileExist(PROGRAM.SKINS_FOLDER "\Path of Exile"), "D")
	FileCreateDir,% PROGRAM.SKINS_FOLDER "\Path of Exile"

if (A_IsCompiled) {
	sourceFileSize := Get_ResourceSize("resources\skins\Path of Exile\MinimizePress.png")
	FileGetSize, destFileSize, % PROGRAM.SKINS_FOLDER "\Path of Exile\MinimizePress.png"
}
else {
	FileGetSize, sourceFileSize, resources\skins\Path of Exile\MinimizePress.png
	FileGetSize, destFileSize, % PROGRAM.SKINS_FOLDER "\Path of Exile\MinimizePress.png"
}
if (sourceFileSize != destFileSize)
	FileInstall, resources\skins\Path of Exile\MinimizePress.png, % PROGRAM.SKINS_FOLDER "\Path of Exile\MinimizePress.png", 1
if (ErrorLevel) {
	AppendToLogs("Failed to extract file!"
	.	"`nSource: resources\skins\Path of Exile\MinimizePress.png"
	.	"`nDest: " PROGRAM.SKINS_FOLDER "\Path of Exile\MinimizePress.png"
	.	"`nFlag: " 2)
	errorLog .= "`n`n""Failed to extract file!"
	.	"`nSource: resources\skins\Path of Exile\MinimizePress.png"
	.	"`nDest: " PROGRAM.SKINS_FOLDER "\Path of Exile\MinimizePress.png"
	.	"`nFlag: " 2
}

; ----------------------------
if !InStr(FileExist(PROGRAM.SKINS_FOLDER "\Path of Exile"), "D")
	FileCreateDir,% PROGRAM.SKINS_FOLDER "\Path of Exile"

if (A_IsCompiled) {
	sourceFileSize := Get_ResourceSize("resources\skins\Path of Exile\Preview.png")
	FileGetSize, destFileSize, % PROGRAM.SKINS_FOLDER "\Path of Exile\Preview.png"
}
else {
	FileGetSize, sourceFileSize, resources\skins\Path of Exile\Preview.png
	FileGetSize, destFileSize, % PROGRAM.SKINS_FOLDER "\Path of Exile\Preview.png"
}
if (sourceFileSize != destFileSize)
	FileInstall, resources\skins\Path of Exile\Preview.png, % PROGRAM.SKINS_FOLDER "\Path of Exile\Preview.png", 1
if (ErrorLevel) {
	AppendToLogs("Failed to extract file!"
	.	"`nSource: resources\skins\Path of Exile\Preview.png"
	.	"`nDest: " PROGRAM.SKINS_FOLDER "\Path of Exile\Preview.png"
	.	"`nFlag: " 2)
	errorLog .= "`n`n""Failed to extract file!"
	.	"`nSource: resources\skins\Path of Exile\Preview.png"
	.	"`nDest: " PROGRAM.SKINS_FOLDER "\Path of Exile\Preview.png"
	.	"`nFlag: " 2
}

; ----------------------------
if !InStr(FileExist(PROGRAM.SKINS_FOLDER "\Path of Exile"), "D")
	FileCreateDir,% PROGRAM.SKINS_FOLDER "\Path of Exile"

FileInstall, resources\skins\Path of Exile\Settings.ini, % PROGRAM.SKINS_FOLDER "\Path of Exile\Settings.ini", 1
if (ErrorLevel) {
	AppendToLogs("Failed to extract file!"
	.	"`nSource: resources\skins\Path of Exile\Settings.ini"
	.	"`nDest: " PROGRAM.SKINS_FOLDER "\Path of Exile\Settings.ini"
	.	"`nFlag: " 1)
	errorLog .= "`n`n""Failed to extract file!"
	.	"`nSource: resources\skins\Path of Exile\Settings.ini"
	.	"`nDest: " PROGRAM.SKINS_FOLDER "\Path of Exile\Settings.ini"
	.	"`nFlag: " 1
}

; ----------------------------
if !InStr(FileExist(PROGRAM.SKINS_FOLDER "\Path of Exile"), "D")
	FileCreateDir,% PROGRAM.SKINS_FOLDER "\Path of Exile"

if (A_IsCompiled) {
	sourceFileSize := Get_ResourceSize("resources\skins\Path of Exile\TabActive.png")
	FileGetSize, destFileSize, % PROGRAM.SKINS_FOLDER "\Path of Exile\TabActive.png"
}
else {
	FileGetSize, sourceFileSize, resources\skins\Path of Exile\TabActive.png
	FileGetSize, destFileSize, % PROGRAM.SKINS_FOLDER "\Path of Exile\TabActive.png"
}
if (sourceFileSize != destFileSize)
	FileInstall, resources\skins\Path of Exile\TabActive.png, % PROGRAM.SKINS_FOLDER "\Path of Exile\TabActive.png", 1
if (ErrorLevel) {
	AppendToLogs("Failed to extract file!"
	.	"`nSource: resources\skins\Path of Exile\TabActive.png"
	.	"`nDest: " PROGRAM.SKINS_FOLDER "\Path of Exile\TabActive.png"
	.	"`nFlag: " 2)
	errorLog .= "`n`n""Failed to extract file!"
	.	"`nSource: resources\skins\Path of Exile\TabActive.png"
	.	"`nDest: " PROGRAM.SKINS_FOLDER "\Path of Exile\TabActive.png"
	.	"`nFlag: " 2
}

; ----------------------------
if !InStr(FileExist(PROGRAM.SKINS_FOLDER "\Path of Exile"), "D")
	FileCreateDir,% PROGRAM.SKINS_FOLDER "\Path of Exile"

if (A_IsCompiled) {
	sourceFileSize := Get_ResourceSize("resources\skins\Path of Exile\TabHover.png")
	FileGetSize, destFileSize, % PROGRAM.SKINS_FOLDER "\Path of Exile\TabHover.png"
}
else {
	FileGetSize, sourceFileSize, resources\skins\Path of Exile\TabHover.png
	FileGetSize, destFileSize, % PROGRAM.SKINS_FOLDER "\Path of Exile\TabHover.png"
}
if (sourceFileSize != destFileSize)
	FileInstall, resources\skins\Path of Exile\TabHover.png, % PROGRAM.SKINS_FOLDER "\Path of Exile\TabHover.png", 1
if (ErrorLevel) {
	AppendToLogs("Failed to extract file!"
	.	"`nSource: resources\skins\Path of Exile\TabHover.png"
	.	"`nDest: " PROGRAM.SKINS_FOLDER "\Path of Exile\TabHover.png"
	.	"`nFlag: " 2)
	errorLog .= "`n`n""Failed to extract file!"
	.	"`nSource: resources\skins\Path of Exile\TabHover.png"
	.	"`nDest: " PROGRAM.SKINS_FOLDER "\Path of Exile\TabHover.png"
	.	"`nFlag: " 2
}

; ----------------------------
if !InStr(FileExist(PROGRAM.SKINS_FOLDER "\Path of Exile"), "D")
	FileCreateDir,% PROGRAM.SKINS_FOLDER "\Path of Exile"

if (A_IsCompiled) {
	sourceFileSize := Get_ResourceSize("resources\skins\Path of Exile\TabInactive.png")
	FileGetSize, destFileSize, % PROGRAM.SKINS_FOLDER "\Path of Exile\TabInactive.png"
}
else {
	FileGetSize, sourceFileSize, resources\skins\Path of Exile\TabInactive.png
	FileGetSize, destFileSize, % PROGRAM.SKINS_FOLDER "\Path of Exile\TabInactive.png"
}
if (sourceFileSize != destFileSize)
	FileInstall, resources\skins\Path of Exile\TabInactive.png, % PROGRAM.SKINS_FOLDER "\Path of Exile\TabInactive.png", 1
if (ErrorLevel) {
	AppendToLogs("Failed to extract file!"
	.	"`nSource: resources\skins\Path of Exile\TabInactive.png"
	.	"`nDest: " PROGRAM.SKINS_FOLDER "\Path of Exile\TabInactive.png"
	.	"`nFlag: " 2)
	errorLog .= "`n`n""Failed to extract file!"
	.	"`nSource: resources\skins\Path of Exile\TabInactive.png"
	.	"`nDest: " PROGRAM.SKINS_FOLDER "\Path of Exile\TabInactive.png"
	.	"`nFlag: " 2
}

; ----------------------------
if !InStr(FileExist(PROGRAM.SKINS_FOLDER "\Path of Exile"), "D")
	FileCreateDir,% PROGRAM.SKINS_FOLDER "\Path of Exile"

if (A_IsCompiled) {
	sourceFileSize := Get_ResourceSize("resources\skins\Path of Exile\TabJoinedActive.png")
	FileGetSize, destFileSize, % PROGRAM.SKINS_FOLDER "\Path of Exile\TabJoinedActive.png"
}
else {
	FileGetSize, sourceFileSize, resources\skins\Path of Exile\TabJoinedActive.png
	FileGetSize, destFileSize, % PROGRAM.SKINS_FOLDER "\Path of Exile\TabJoinedActive.png"
}
if (sourceFileSize != destFileSize)
	FileInstall, resources\skins\Path of Exile\TabJoinedActive.png, % PROGRAM.SKINS_FOLDER "\Path of Exile\TabJoinedActive.png", 1
if (ErrorLevel) {
	AppendToLogs("Failed to extract file!"
	.	"`nSource: resources\skins\Path of Exile\TabJoinedActive.png"
	.	"`nDest: " PROGRAM.SKINS_FOLDER "\Path of Exile\TabJoinedActive.png"
	.	"`nFlag: " 2)
	errorLog .= "`n`n""Failed to extract file!"
	.	"`nSource: resources\skins\Path of Exile\TabJoinedActive.png"
	.	"`nDest: " PROGRAM.SKINS_FOLDER "\Path of Exile\TabJoinedActive.png"
	.	"`nFlag: " 2
}

; ----------------------------
if !InStr(FileExist(PROGRAM.SKINS_FOLDER "\Path of Exile"), "D")
	FileCreateDir,% PROGRAM.SKINS_FOLDER "\Path of Exile"

if (A_IsCompiled) {
	sourceFileSize := Get_ResourceSize("resources\skins\Path of Exile\TabJoinedHover.png")
	FileGetSize, destFileSize, % PROGRAM.SKINS_FOLDER "\Path of Exile\TabJoinedHover.png"
}
else {
	FileGetSize, sourceFileSize, resources\skins\Path of Exile\TabJoinedHover.png
	FileGetSize, destFileSize, % PROGRAM.SKINS_FOLDER "\Path of Exile\TabJoinedHover.png"
}
if (sourceFileSize != destFileSize)
	FileInstall, resources\skins\Path of Exile\TabJoinedHover.png, % PROGRAM.SKINS_FOLDER "\Path of Exile\TabJoinedHover.png", 1
if (ErrorLevel) {
	AppendToLogs("Failed to extract file!"
	.	"`nSource: resources\skins\Path of Exile\TabJoinedHover.png"
	.	"`nDest: " PROGRAM.SKINS_FOLDER "\Path of Exile\TabJoinedHover.png"
	.	"`nFlag: " 2)
	errorLog .= "`n`n""Failed to extract file!"
	.	"`nSource: resources\skins\Path of Exile\TabJoinedHover.png"
	.	"`nDest: " PROGRAM.SKINS_FOLDER "\Path of Exile\TabJoinedHover.png"
	.	"`nFlag: " 2
}

; ----------------------------
if !InStr(FileExist(PROGRAM.SKINS_FOLDER "\Path of Exile"), "D")
	FileCreateDir,% PROGRAM.SKINS_FOLDER "\Path of Exile"

if (A_IsCompiled) {
	sourceFileSize := Get_ResourceSize("resources\skins\Path of Exile\TabJoinedInactive.png")
	FileGetSize, destFileSize, % PROGRAM.SKINS_FOLDER "\Path of Exile\TabJoinedInactive.png"
}
else {
	FileGetSize, sourceFileSize, resources\skins\Path of Exile\TabJoinedInactive.png
	FileGetSize, destFileSize, % PROGRAM.SKINS_FOLDER "\Path of Exile\TabJoinedInactive.png"
}
if (sourceFileSize != destFileSize)
	FileInstall, resources\skins\Path of Exile\TabJoinedInactive.png, % PROGRAM.SKINS_FOLDER "\Path of Exile\TabJoinedInactive.png", 1
if (ErrorLevel) {
	AppendToLogs("Failed to extract file!"
	.	"`nSource: resources\skins\Path of Exile\TabJoinedInactive.png"
	.	"`nDest: " PROGRAM.SKINS_FOLDER "\Path of Exile\TabJoinedInactive.png"
	.	"`nFlag: " 2)
	errorLog .= "`n`n""Failed to extract file!"
	.	"`nSource: resources\skins\Path of Exile\TabJoinedInactive.png"
	.	"`nDest: " PROGRAM.SKINS_FOLDER "\Path of Exile\TabJoinedInactive.png"
	.	"`nFlag: " 2
}

; ----------------------------
if !InStr(FileExist(PROGRAM.SKINS_FOLDER "\Path of Exile"), "D")
	FileCreateDir,% PROGRAM.SKINS_FOLDER "\Path of Exile"

if (A_IsCompiled) {
	sourceFileSize := Get_ResourceSize("resources\skins\Path of Exile\TabsBackground.png")
	FileGetSize, destFileSize, % PROGRAM.SKINS_FOLDER "\Path of Exile\TabsBackground.png"
}
else {
	FileGetSize, sourceFileSize, resources\skins\Path of Exile\TabsBackground.png
	FileGetSize, destFileSize, % PROGRAM.SKINS_FOLDER "\Path of Exile\TabsBackground.png"
}
if (sourceFileSize != destFileSize)
	FileInstall, resources\skins\Path of Exile\TabsBackground.png, % PROGRAM.SKINS_FOLDER "\Path of Exile\TabsBackground.png", 1
if (ErrorLevel) {
	AppendToLogs("Failed to extract file!"
	.	"`nSource: resources\skins\Path of Exile\TabsBackground.png"
	.	"`nDest: " PROGRAM.SKINS_FOLDER "\Path of Exile\TabsBackground.png"
	.	"`nFlag: " 2)
	errorLog .= "`n`n""Failed to extract file!"
	.	"`nSource: resources\skins\Path of Exile\TabsBackground.png"
	.	"`nDest: " PROGRAM.SKINS_FOLDER "\Path of Exile\TabsBackground.png"
	.	"`nFlag: " 2
}

; ----------------------------
if !InStr(FileExist(PROGRAM.SKINS_FOLDER "\Path of Exile"), "D")
	FileCreateDir,% PROGRAM.SKINS_FOLDER "\Path of Exile"

if (A_IsCompiled) {
	sourceFileSize := Get_ResourceSize("resources\skins\Path of Exile\TabWhisperActive.png")
	FileGetSize, destFileSize, % PROGRAM.SKINS_FOLDER "\Path of Exile\TabWhisperActive.png"
}
else {
	FileGetSize, sourceFileSize, resources\skins\Path of Exile\TabWhisperActive.png
	FileGetSize, destFileSize, % PROGRAM.SKINS_FOLDER "\Path of Exile\TabWhisperActive.png"
}
if (sourceFileSize != destFileSize)
	FileInstall, resources\skins\Path of Exile\TabWhisperActive.png, % PROGRAM.SKINS_FOLDER "\Path of Exile\TabWhisperActive.png", 1
if (ErrorLevel) {
	AppendToLogs("Failed to extract file!"
	.	"`nSource: resources\skins\Path of Exile\TabWhisperActive.png"
	.	"`nDest: " PROGRAM.SKINS_FOLDER "\Path of Exile\TabWhisperActive.png"
	.	"`nFlag: " 2)
	errorLog .= "`n`n""Failed to extract file!"
	.	"`nSource: resources\skins\Path of Exile\TabWhisperActive.png"
	.	"`nDest: " PROGRAM.SKINS_FOLDER "\Path of Exile\TabWhisperActive.png"
	.	"`nFlag: " 2
}

; ----------------------------
if !InStr(FileExist(PROGRAM.SKINS_FOLDER "\Path of Exile"), "D")
	FileCreateDir,% PROGRAM.SKINS_FOLDER "\Path of Exile"

if (A_IsCompiled) {
	sourceFileSize := Get_ResourceSize("resources\skins\Path of Exile\TabWhisperHover.png")
	FileGetSize, destFileSize, % PROGRAM.SKINS_FOLDER "\Path of Exile\TabWhisperHover.png"
}
else {
	FileGetSize, sourceFileSize, resources\skins\Path of Exile\TabWhisperHover.png
	FileGetSize, destFileSize, % PROGRAM.SKINS_FOLDER "\Path of Exile\TabWhisperHover.png"
}
if (sourceFileSize != destFileSize)
	FileInstall, resources\skins\Path of Exile\TabWhisperHover.png, % PROGRAM.SKINS_FOLDER "\Path of Exile\TabWhisperHover.png", 1
if (ErrorLevel) {
	AppendToLogs("Failed to extract file!"
	.	"`nSource: resources\skins\Path of Exile\TabWhisperHover.png"
	.	"`nDest: " PROGRAM.SKINS_FOLDER "\Path of Exile\TabWhisperHover.png"
	.	"`nFlag: " 2)
	errorLog .= "`n`n""Failed to extract file!"
	.	"`nSource: resources\skins\Path of Exile\TabWhisperHover.png"
	.	"`nDest: " PROGRAM.SKINS_FOLDER "\Path of Exile\TabWhisperHover.png"
	.	"`nFlag: " 2
}

; ----------------------------
if !InStr(FileExist(PROGRAM.SKINS_FOLDER "\Path of Exile"), "D")
	FileCreateDir,% PROGRAM.SKINS_FOLDER "\Path of Exile"

if (A_IsCompiled) {
	sourceFileSize := Get_ResourceSize("resources\skins\Path of Exile\TabWhisperInactive.png")
	FileGetSize, destFileSize, % PROGRAM.SKINS_FOLDER "\Path of Exile\TabWhisperInactive.png"
}
else {
	FileGetSize, sourceFileSize, resources\skins\Path of Exile\TabWhisperInactive.png
	FileGetSize, destFileSize, % PROGRAM.SKINS_FOLDER "\Path of Exile\TabWhisperInactive.png"
}
if (sourceFileSize != destFileSize)
	FileInstall, resources\skins\Path of Exile\TabWhisperInactive.png, % PROGRAM.SKINS_FOLDER "\Path of Exile\TabWhisperInactive.png", 1
if (ErrorLevel) {
	AppendToLogs("Failed to extract file!"
	.	"`nSource: resources\skins\Path of Exile\TabWhisperInactive.png"
	.	"`nDest: " PROGRAM.SKINS_FOLDER "\Path of Exile\TabWhisperInactive.png"
	.	"`nFlag: " 2)
	errorLog .= "`n`n""Failed to extract file!"
	.	"`nSource: resources\skins\Path of Exile\TabWhisperInactive.png"
	.	"`nDest: " PROGRAM.SKINS_FOLDER "\Path of Exile\TabWhisperInactive.png"
	.	"`nFlag: " 2
}

; ----------------------------
if !InStr(FileExist(PROGRAM.SKINS_FOLDER "\Path of Exile"), "D")
	FileCreateDir,% PROGRAM.SKINS_FOLDER "\Path of Exile"

if (A_IsCompiled) {
	sourceFileSize := Get_ResourceSize("resources\skins\Path of Exile\TradeVerifyGreen.png")
	FileGetSize, destFileSize, % PROGRAM.SKINS_FOLDER "\Path of Exile\TradeVerifyGreen.png"
}
else {
	FileGetSize, sourceFileSize, resources\skins\Path of Exile\TradeVerifyGreen.png
	FileGetSize, destFileSize, % PROGRAM.SKINS_FOLDER "\Path of Exile\TradeVerifyGreen.png"
}
if (sourceFileSize != destFileSize)
	FileInstall, resources\skins\Path of Exile\TradeVerifyGreen.png, % PROGRAM.SKINS_FOLDER "\Path of Exile\TradeVerifyGreen.png", 1
if (ErrorLevel) {
	AppendToLogs("Failed to extract file!"
	.	"`nSource: resources\skins\Path of Exile\TradeVerifyGreen.png"
	.	"`nDest: " PROGRAM.SKINS_FOLDER "\Path of Exile\TradeVerifyGreen.png"
	.	"`nFlag: " 2)
	errorLog .= "`n`n""Failed to extract file!"
	.	"`nSource: resources\skins\Path of Exile\TradeVerifyGreen.png"
	.	"`nDest: " PROGRAM.SKINS_FOLDER "\Path of Exile\TradeVerifyGreen.png"
	.	"`nFlag: " 2
}

; ----------------------------
if !InStr(FileExist(PROGRAM.SKINS_FOLDER "\Path of Exile"), "D")
	FileCreateDir,% PROGRAM.SKINS_FOLDER "\Path of Exile"

if (A_IsCompiled) {
	sourceFileSize := Get_ResourceSize("resources\skins\Path of Exile\TradeVerifyGrey.png")
	FileGetSize, destFileSize, % PROGRAM.SKINS_FOLDER "\Path of Exile\TradeVerifyGrey.png"
}
else {
	FileGetSize, sourceFileSize, resources\skins\Path of Exile\TradeVerifyGrey.png
	FileGetSize, destFileSize, % PROGRAM.SKINS_FOLDER "\Path of Exile\TradeVerifyGrey.png"
}
if (sourceFileSize != destFileSize)
	FileInstall, resources\skins\Path of Exile\TradeVerifyGrey.png, % PROGRAM.SKINS_FOLDER "\Path of Exile\TradeVerifyGrey.png", 1
if (ErrorLevel) {
	AppendToLogs("Failed to extract file!"
	.	"`nSource: resources\skins\Path of Exile\TradeVerifyGrey.png"
	.	"`nDest: " PROGRAM.SKINS_FOLDER "\Path of Exile\TradeVerifyGrey.png"
	.	"`nFlag: " 2)
	errorLog .= "`n`n""Failed to extract file!"
	.	"`nSource: resources\skins\Path of Exile\TradeVerifyGrey.png"
	.	"`nDest: " PROGRAM.SKINS_FOLDER "\Path of Exile\TradeVerifyGrey.png"
	.	"`nFlag: " 2
}

; ----------------------------
if !InStr(FileExist(PROGRAM.SKINS_FOLDER "\Path of Exile"), "D")
	FileCreateDir,% PROGRAM.SKINS_FOLDER "\Path of Exile"

if (A_IsCompiled) {
	sourceFileSize := Get_ResourceSize("resources\skins\Path of Exile\TradeVerifyOrange.png")
	FileGetSize, destFileSize, % PROGRAM.SKINS_FOLDER "\Path of Exile\TradeVerifyOrange.png"
}
else {
	FileGetSize, sourceFileSize, resources\skins\Path of Exile\TradeVerifyOrange.png
	FileGetSize, destFileSize, % PROGRAM.SKINS_FOLDER "\Path of Exile\TradeVerifyOrange.png"
}
if (sourceFileSize != destFileSize)
	FileInstall, resources\skins\Path of Exile\TradeVerifyOrange.png, % PROGRAM.SKINS_FOLDER "\Path of Exile\TradeVerifyOrange.png", 1
if (ErrorLevel) {
	AppendToLogs("Failed to extract file!"
	.	"`nSource: resources\skins\Path of Exile\TradeVerifyOrange.png"
	.	"`nDest: " PROGRAM.SKINS_FOLDER "\Path of Exile\TradeVerifyOrange.png"
	.	"`nFlag: " 2)
	errorLog .= "`n`n""Failed to extract file!"
	.	"`nSource: resources\skins\Path of Exile\TradeVerifyOrange.png"
	.	"`nDest: " PROGRAM.SKINS_FOLDER "\Path of Exile\TradeVerifyOrange.png"
	.	"`nFlag: " 2
}

; ----------------------------
if !InStr(FileExist(PROGRAM.SKINS_FOLDER "\Path of Exile"), "D")
	FileCreateDir,% PROGRAM.SKINS_FOLDER "\Path of Exile"

if (A_IsCompiled) {
	sourceFileSize := Get_ResourceSize("resources\skins\Path of Exile\TradeVerifyRed.png")
	FileGetSize, destFileSize, % PROGRAM.SKINS_FOLDER "\Path of Exile\TradeVerifyRed.png"
}
else {
	FileGetSize, sourceFileSize, resources\skins\Path of Exile\TradeVerifyRed.png
	FileGetSize, destFileSize, % PROGRAM.SKINS_FOLDER "\Path of Exile\TradeVerifyRed.png"
}
if (sourceFileSize != destFileSize)
	FileInstall, resources\skins\Path of Exile\TradeVerifyRed.png, % PROGRAM.SKINS_FOLDER "\Path of Exile\TradeVerifyRed.png", 1
if (ErrorLevel) {
	AppendToLogs("Failed to extract file!"
	.	"`nSource: resources\skins\Path of Exile\TradeVerifyRed.png"
	.	"`nDest: " PROGRAM.SKINS_FOLDER "\Path of Exile\TradeVerifyRed.png"
	.	"`nFlag: " 2)
	errorLog .= "`n`n""Failed to extract file!"
	.	"`nSource: resources\skins\Path of Exile\TradeVerifyRed.png"
	.	"`nDest: " PROGRAM.SKINS_FOLDER "\Path of Exile\TradeVerifyRed.png"
	.	"`nFlag: " 2
}

; ----------------------------
if !InStr(FileExist(PROGRAM.SKINS_FOLDER "\Path of Exile\Compact"), "D")
	FileCreateDir,% PROGRAM.SKINS_FOLDER "\Path of Exile\Compact"

if (A_IsCompiled) {
	sourceFileSize := Get_ResourceSize("resources\skins\Path of Exile\Compact\ArrowLeft.png")
	FileGetSize, destFileSize, % PROGRAM.SKINS_FOLDER "\Path of Exile\Compact\ArrowLeft.png"
}
else {
	FileGetSize, sourceFileSize, resources\skins\Path of Exile\Compact\ArrowLeft.png
	FileGetSize, destFileSize, % PROGRAM.SKINS_FOLDER "\Path of Exile\Compact\ArrowLeft.png"
}
if (sourceFileSize != destFileSize)
	FileInstall, resources\skins\Path of Exile\Compact\ArrowLeft.png, % PROGRAM.SKINS_FOLDER "\Path of Exile\Compact\ArrowLeft.png", 1
if (ErrorLevel) {
	AppendToLogs("Failed to extract file!"
	.	"`nSource: resources\skins\Path of Exile\Compact\ArrowLeft.png"
	.	"`nDest: " PROGRAM.SKINS_FOLDER "\Path of Exile\Compact\ArrowLeft.png"
	.	"`nFlag: " 2)
	errorLog .= "`n`n""Failed to extract file!"
	.	"`nSource: resources\skins\Path of Exile\Compact\ArrowLeft.png"
	.	"`nDest: " PROGRAM.SKINS_FOLDER "\Path of Exile\Compact\ArrowLeft.png"
	.	"`nFlag: " 2
}

; ----------------------------
if !InStr(FileExist(PROGRAM.SKINS_FOLDER "\Path of Exile\Compact"), "D")
	FileCreateDir,% PROGRAM.SKINS_FOLDER "\Path of Exile\Compact"

if (A_IsCompiled) {
	sourceFileSize := Get_ResourceSize("resources\skins\Path of Exile\Compact\ArrowLeftHover.png")
	FileGetSize, destFileSize, % PROGRAM.SKINS_FOLDER "\Path of Exile\Compact\ArrowLeftHover.png"
}
else {
	FileGetSize, sourceFileSize, resources\skins\Path of Exile\Compact\ArrowLeftHover.png
	FileGetSize, destFileSize, % PROGRAM.SKINS_FOLDER "\Path of Exile\Compact\ArrowLeftHover.png"
}
if (sourceFileSize != destFileSize)
	FileInstall, resources\skins\Path of Exile\Compact\ArrowLeftHover.png, % PROGRAM.SKINS_FOLDER "\Path of Exile\Compact\ArrowLeftHover.png", 1
if (ErrorLevel) {
	AppendToLogs("Failed to extract file!"
	.	"`nSource: resources\skins\Path of Exile\Compact\ArrowLeftHover.png"
	.	"`nDest: " PROGRAM.SKINS_FOLDER "\Path of Exile\Compact\ArrowLeftHover.png"
	.	"`nFlag: " 2)
	errorLog .= "`n`n""Failed to extract file!"
	.	"`nSource: resources\skins\Path of Exile\Compact\ArrowLeftHover.png"
	.	"`nDest: " PROGRAM.SKINS_FOLDER "\Path of Exile\Compact\ArrowLeftHover.png"
	.	"`nFlag: " 2
}

; ----------------------------
if !InStr(FileExist(PROGRAM.SKINS_FOLDER "\Path of Exile\Compact"), "D")
	FileCreateDir,% PROGRAM.SKINS_FOLDER "\Path of Exile\Compact"

if (A_IsCompiled) {
	sourceFileSize := Get_ResourceSize("resources\skins\Path of Exile\Compact\ArrowLeftPress.png")
	FileGetSize, destFileSize, % PROGRAM.SKINS_FOLDER "\Path of Exile\Compact\ArrowLeftPress.png"
}
else {
	FileGetSize, sourceFileSize, resources\skins\Path of Exile\Compact\ArrowLeftPress.png
	FileGetSize, destFileSize, % PROGRAM.SKINS_FOLDER "\Path of Exile\Compact\ArrowLeftPress.png"
}
if (sourceFileSize != destFileSize)
	FileInstall, resources\skins\Path of Exile\Compact\ArrowLeftPress.png, % PROGRAM.SKINS_FOLDER "\Path of Exile\Compact\ArrowLeftPress.png", 1
if (ErrorLevel) {
	AppendToLogs("Failed to extract file!"
	.	"`nSource: resources\skins\Path of Exile\Compact\ArrowLeftPress.png"
	.	"`nDest: " PROGRAM.SKINS_FOLDER "\Path of Exile\Compact\ArrowLeftPress.png"
	.	"`nFlag: " 2)
	errorLog .= "`n`n""Failed to extract file!"
	.	"`nSource: resources\skins\Path of Exile\Compact\ArrowLeftPress.png"
	.	"`nDest: " PROGRAM.SKINS_FOLDER "\Path of Exile\Compact\ArrowLeftPress.png"
	.	"`nFlag: " 2
}

; ----------------------------
if !InStr(FileExist(PROGRAM.SKINS_FOLDER "\Path of Exile\Compact"), "D")
	FileCreateDir,% PROGRAM.SKINS_FOLDER "\Path of Exile\Compact"

if (A_IsCompiled) {
	sourceFileSize := Get_ResourceSize("resources\skins\Path of Exile\Compact\ArrowRight.png")
	FileGetSize, destFileSize, % PROGRAM.SKINS_FOLDER "\Path of Exile\Compact\ArrowRight.png"
}
else {
	FileGetSize, sourceFileSize, resources\skins\Path of Exile\Compact\ArrowRight.png
	FileGetSize, destFileSize, % PROGRAM.SKINS_FOLDER "\Path of Exile\Compact\ArrowRight.png"
}
if (sourceFileSize != destFileSize)
	FileInstall, resources\skins\Path of Exile\Compact\ArrowRight.png, % PROGRAM.SKINS_FOLDER "\Path of Exile\Compact\ArrowRight.png", 1
if (ErrorLevel) {
	AppendToLogs("Failed to extract file!"
	.	"`nSource: resources\skins\Path of Exile\Compact\ArrowRight.png"
	.	"`nDest: " PROGRAM.SKINS_FOLDER "\Path of Exile\Compact\ArrowRight.png"
	.	"`nFlag: " 2)
	errorLog .= "`n`n""Failed to extract file!"
	.	"`nSource: resources\skins\Path of Exile\Compact\ArrowRight.png"
	.	"`nDest: " PROGRAM.SKINS_FOLDER "\Path of Exile\Compact\ArrowRight.png"
	.	"`nFlag: " 2
}

; ----------------------------
if !InStr(FileExist(PROGRAM.SKINS_FOLDER "\Path of Exile\Compact"), "D")
	FileCreateDir,% PROGRAM.SKINS_FOLDER "\Path of Exile\Compact"

if (A_IsCompiled) {
	sourceFileSize := Get_ResourceSize("resources\skins\Path of Exile\Compact\ArrowRightHover.png")
	FileGetSize, destFileSize, % PROGRAM.SKINS_FOLDER "\Path of Exile\Compact\ArrowRightHover.png"
}
else {
	FileGetSize, sourceFileSize, resources\skins\Path of Exile\Compact\ArrowRightHover.png
	FileGetSize, destFileSize, % PROGRAM.SKINS_FOLDER "\Path of Exile\Compact\ArrowRightHover.png"
}
if (sourceFileSize != destFileSize)
	FileInstall, resources\skins\Path of Exile\Compact\ArrowRightHover.png, % PROGRAM.SKINS_FOLDER "\Path of Exile\Compact\ArrowRightHover.png", 1
if (ErrorLevel) {
	AppendToLogs("Failed to extract file!"
	.	"`nSource: resources\skins\Path of Exile\Compact\ArrowRightHover.png"
	.	"`nDest: " PROGRAM.SKINS_FOLDER "\Path of Exile\Compact\ArrowRightHover.png"
	.	"`nFlag: " 2)
	errorLog .= "`n`n""Failed to extract file!"
	.	"`nSource: resources\skins\Path of Exile\Compact\ArrowRightHover.png"
	.	"`nDest: " PROGRAM.SKINS_FOLDER "\Path of Exile\Compact\ArrowRightHover.png"
	.	"`nFlag: " 2
}

; ----------------------------
if !InStr(FileExist(PROGRAM.SKINS_FOLDER "\Path of Exile\Compact"), "D")
	FileCreateDir,% PROGRAM.SKINS_FOLDER "\Path of Exile\Compact"

if (A_IsCompiled) {
	sourceFileSize := Get_ResourceSize("resources\skins\Path of Exile\Compact\ArrowRightPress.png")
	FileGetSize, destFileSize, % PROGRAM.SKINS_FOLDER "\Path of Exile\Compact\ArrowRightPress.png"
}
else {
	FileGetSize, sourceFileSize, resources\skins\Path of Exile\Compact\ArrowRightPress.png
	FileGetSize, destFileSize, % PROGRAM.SKINS_FOLDER "\Path of Exile\Compact\ArrowRightPress.png"
}
if (sourceFileSize != destFileSize)
	FileInstall, resources\skins\Path of Exile\Compact\ArrowRightPress.png, % PROGRAM.SKINS_FOLDER "\Path of Exile\Compact\ArrowRightPress.png", 1
if (ErrorLevel) {
	AppendToLogs("Failed to extract file!"
	.	"`nSource: resources\skins\Path of Exile\Compact\ArrowRightPress.png"
	.	"`nDest: " PROGRAM.SKINS_FOLDER "\Path of Exile\Compact\ArrowRightPress.png"
	.	"`nFlag: " 2)
	errorLog .= "`n`n""Failed to extract file!"
	.	"`nSource: resources\skins\Path of Exile\Compact\ArrowRightPress.png"
	.	"`nDest: " PROGRAM.SKINS_FOLDER "\Path of Exile\Compact\ArrowRightPress.png"
	.	"`nFlag: " 2
}

; ----------------------------
if !InStr(FileExist(PROGRAM.SKINS_FOLDER "\Path of Exile\Compact"), "D")
	FileCreateDir,% PROGRAM.SKINS_FOLDER "\Path of Exile\Compact"

FileInstall, resources\skins\Path of Exile\Compact\Assets.ini, % PROGRAM.SKINS_FOLDER "\Path of Exile\Compact\Assets.ini", 1
if (ErrorLevel) {
	AppendToLogs("Failed to extract file!"
	.	"`nSource: resources\skins\Path of Exile\Compact\Assets.ini"
	.	"`nDest: " PROGRAM.SKINS_FOLDER "\Path of Exile\Compact\Assets.ini"
	.	"`nFlag: " 1)
	errorLog .= "`n`n""Failed to extract file!"
	.	"`nSource: resources\skins\Path of Exile\Compact\Assets.ini"
	.	"`nDest: " PROGRAM.SKINS_FOLDER "\Path of Exile\Compact\Assets.ini"
	.	"`nFlag: " 1
}

; ----------------------------
if !InStr(FileExist(PROGRAM.SKINS_FOLDER "\Path of Exile\Compact"), "D")
	FileCreateDir,% PROGRAM.SKINS_FOLDER "\Path of Exile\Compact"

if (A_IsCompiled) {
	sourceFileSize := Get_ResourceSize("resources\skins\Path of Exile\Compact\Background.png")
	FileGetSize, destFileSize, % PROGRAM.SKINS_FOLDER "\Path of Exile\Compact\Background.png"
}
else {
	FileGetSize, sourceFileSize, resources\skins\Path of Exile\Compact\Background.png
	FileGetSize, destFileSize, % PROGRAM.SKINS_FOLDER "\Path of Exile\Compact\Background.png"
}
if (sourceFileSize != destFileSize)
	FileInstall, resources\skins\Path of Exile\Compact\Background.png, % PROGRAM.SKINS_FOLDER "\Path of Exile\Compact\Background.png", 1
if (ErrorLevel) {
	AppendToLogs("Failed to extract file!"
	.	"`nSource: resources\skins\Path of Exile\Compact\Background.png"
	.	"`nDest: " PROGRAM.SKINS_FOLDER "\Path of Exile\Compact\Background.png"
	.	"`nFlag: " 2)
	errorLog .= "`n`n""Failed to extract file!"
	.	"`nSource: resources\skins\Path of Exile\Compact\Background.png"
	.	"`nDest: " PROGRAM.SKINS_FOLDER "\Path of Exile\Compact\Background.png"
	.	"`nFlag: " 2
}

; ----------------------------
if !InStr(FileExist(PROGRAM.SKINS_FOLDER "\Path of Exile\Compact"), "D")
	FileCreateDir,% PROGRAM.SKINS_FOLDER "\Path of Exile\Compact"

if (A_IsCompiled) {
	sourceFileSize := Get_ResourceSize("resources\skins\Path of Exile\Compact\ButtonHideout.png")
	FileGetSize, destFileSize, % PROGRAM.SKINS_FOLDER "\Path of Exile\Compact\ButtonHideout.png"
}
else {
	FileGetSize, sourceFileSize, resources\skins\Path of Exile\Compact\ButtonHideout.png
	FileGetSize, destFileSize, % PROGRAM.SKINS_FOLDER "\Path of Exile\Compact\ButtonHideout.png"
}
if (sourceFileSize != destFileSize)
	FileInstall, resources\skins\Path of Exile\Compact\ButtonHideout.png, % PROGRAM.SKINS_FOLDER "\Path of Exile\Compact\ButtonHideout.png", 1
if (ErrorLevel) {
	AppendToLogs("Failed to extract file!"
	.	"`nSource: resources\skins\Path of Exile\Compact\ButtonHideout.png"
	.	"`nDest: " PROGRAM.SKINS_FOLDER "\Path of Exile\Compact\ButtonHideout.png"
	.	"`nFlag: " 2)
	errorLog .= "`n`n""Failed to extract file!"
	.	"`nSource: resources\skins\Path of Exile\Compact\ButtonHideout.png"
	.	"`nDest: " PROGRAM.SKINS_FOLDER "\Path of Exile\Compact\ButtonHideout.png"
	.	"`nFlag: " 2
}

; ----------------------------
if !InStr(FileExist(PROGRAM.SKINS_FOLDER "\Path of Exile\Compact"), "D")
	FileCreateDir,% PROGRAM.SKINS_FOLDER "\Path of Exile\Compact"

if (A_IsCompiled) {
	sourceFileSize := Get_ResourceSize("resources\skins\Path of Exile\Compact\ButtonHideoutHover.png")
	FileGetSize, destFileSize, % PROGRAM.SKINS_FOLDER "\Path of Exile\Compact\ButtonHideoutHover.png"
}
else {
	FileGetSize, sourceFileSize, resources\skins\Path of Exile\Compact\ButtonHideoutHover.png
	FileGetSize, destFileSize, % PROGRAM.SKINS_FOLDER "\Path of Exile\Compact\ButtonHideoutHover.png"
}
if (sourceFileSize != destFileSize)
	FileInstall, resources\skins\Path of Exile\Compact\ButtonHideoutHover.png, % PROGRAM.SKINS_FOLDER "\Path of Exile\Compact\ButtonHideoutHover.png", 1
if (ErrorLevel) {
	AppendToLogs("Failed to extract file!"
	.	"`nSource: resources\skins\Path of Exile\Compact\ButtonHideoutHover.png"
	.	"`nDest: " PROGRAM.SKINS_FOLDER "\Path of Exile\Compact\ButtonHideoutHover.png"
	.	"`nFlag: " 2)
	errorLog .= "`n`n""Failed to extract file!"
	.	"`nSource: resources\skins\Path of Exile\Compact\ButtonHideoutHover.png"
	.	"`nDest: " PROGRAM.SKINS_FOLDER "\Path of Exile\Compact\ButtonHideoutHover.png"
	.	"`nFlag: " 2
}

; ----------------------------
if !InStr(FileExist(PROGRAM.SKINS_FOLDER "\Path of Exile\Compact"), "D")
	FileCreateDir,% PROGRAM.SKINS_FOLDER "\Path of Exile\Compact"

if (A_IsCompiled) {
	sourceFileSize := Get_ResourceSize("resources\skins\Path of Exile\Compact\ButtonHideoutPress.png")
	FileGetSize, destFileSize, % PROGRAM.SKINS_FOLDER "\Path of Exile\Compact\ButtonHideoutPress.png"
}
else {
	FileGetSize, sourceFileSize, resources\skins\Path of Exile\Compact\ButtonHideoutPress.png
	FileGetSize, destFileSize, % PROGRAM.SKINS_FOLDER "\Path of Exile\Compact\ButtonHideoutPress.png"
}
if (sourceFileSize != destFileSize)
	FileInstall, resources\skins\Path of Exile\Compact\ButtonHideoutPress.png, % PROGRAM.SKINS_FOLDER "\Path of Exile\Compact\ButtonHideoutPress.png", 1
if (ErrorLevel) {
	AppendToLogs("Failed to extract file!"
	.	"`nSource: resources\skins\Path of Exile\Compact\ButtonHideoutPress.png"
	.	"`nDest: " PROGRAM.SKINS_FOLDER "\Path of Exile\Compact\ButtonHideoutPress.png"
	.	"`nFlag: " 2)
	errorLog .= "`n`n""Failed to extract file!"
	.	"`nSource: resources\skins\Path of Exile\Compact\ButtonHideoutPress.png"
	.	"`nDest: " PROGRAM.SKINS_FOLDER "\Path of Exile\Compact\ButtonHideoutPress.png"
	.	"`nFlag: " 2
}

; ----------------------------
if !InStr(FileExist(PROGRAM.SKINS_FOLDER "\Path of Exile\Compact"), "D")
	FileCreateDir,% PROGRAM.SKINS_FOLDER "\Path of Exile\Compact"

if (A_IsCompiled) {
	sourceFileSize := Get_ResourceSize("resources\skins\Path of Exile\Compact\ButtonKick.png")
	FileGetSize, destFileSize, % PROGRAM.SKINS_FOLDER "\Path of Exile\Compact\ButtonKick.png"
}
else {
	FileGetSize, sourceFileSize, resources\skins\Path of Exile\Compact\ButtonKick.png
	FileGetSize, destFileSize, % PROGRAM.SKINS_FOLDER "\Path of Exile\Compact\ButtonKick.png"
}
if (sourceFileSize != destFileSize)
	FileInstall, resources\skins\Path of Exile\Compact\ButtonKick.png, % PROGRAM.SKINS_FOLDER "\Path of Exile\Compact\ButtonKick.png", 1
if (ErrorLevel) {
	AppendToLogs("Failed to extract file!"
	.	"`nSource: resources\skins\Path of Exile\Compact\ButtonKick.png"
	.	"`nDest: " PROGRAM.SKINS_FOLDER "\Path of Exile\Compact\ButtonKick.png"
	.	"`nFlag: " 2)
	errorLog .= "`n`n""Failed to extract file!"
	.	"`nSource: resources\skins\Path of Exile\Compact\ButtonKick.png"
	.	"`nDest: " PROGRAM.SKINS_FOLDER "\Path of Exile\Compact\ButtonKick.png"
	.	"`nFlag: " 2
}

; ----------------------------
if !InStr(FileExist(PROGRAM.SKINS_FOLDER "\Path of Exile\Compact"), "D")
	FileCreateDir,% PROGRAM.SKINS_FOLDER "\Path of Exile\Compact"

if (A_IsCompiled) {
	sourceFileSize := Get_ResourceSize("resources\skins\Path of Exile\Compact\ButtonKickHover.png")
	FileGetSize, destFileSize, % PROGRAM.SKINS_FOLDER "\Path of Exile\Compact\ButtonKickHover.png"
}
else {
	FileGetSize, sourceFileSize, resources\skins\Path of Exile\Compact\ButtonKickHover.png
	FileGetSize, destFileSize, % PROGRAM.SKINS_FOLDER "\Path of Exile\Compact\ButtonKickHover.png"
}
if (sourceFileSize != destFileSize)
	FileInstall, resources\skins\Path of Exile\Compact\ButtonKickHover.png, % PROGRAM.SKINS_FOLDER "\Path of Exile\Compact\ButtonKickHover.png", 1
if (ErrorLevel) {
	AppendToLogs("Failed to extract file!"
	.	"`nSource: resources\skins\Path of Exile\Compact\ButtonKickHover.png"
	.	"`nDest: " PROGRAM.SKINS_FOLDER "\Path of Exile\Compact\ButtonKickHover.png"
	.	"`nFlag: " 2)
	errorLog .= "`n`n""Failed to extract file!"
	.	"`nSource: resources\skins\Path of Exile\Compact\ButtonKickHover.png"
	.	"`nDest: " PROGRAM.SKINS_FOLDER "\Path of Exile\Compact\ButtonKickHover.png"
	.	"`nFlag: " 2
}

; ----------------------------
if !InStr(FileExist(PROGRAM.SKINS_FOLDER "\Path of Exile\Compact"), "D")
	FileCreateDir,% PROGRAM.SKINS_FOLDER "\Path of Exile\Compact"

if (A_IsCompiled) {
	sourceFileSize := Get_ResourceSize("resources\skins\Path of Exile\Compact\ButtonKickPress.png")
	FileGetSize, destFileSize, % PROGRAM.SKINS_FOLDER "\Path of Exile\Compact\ButtonKickPress.png"
}
else {
	FileGetSize, sourceFileSize, resources\skins\Path of Exile\Compact\ButtonKickPress.png
	FileGetSize, destFileSize, % PROGRAM.SKINS_FOLDER "\Path of Exile\Compact\ButtonKickPress.png"
}
if (sourceFileSize != destFileSize)
	FileInstall, resources\skins\Path of Exile\Compact\ButtonKickPress.png, % PROGRAM.SKINS_FOLDER "\Path of Exile\Compact\ButtonKickPress.png", 1
if (ErrorLevel) {
	AppendToLogs("Failed to extract file!"
	.	"`nSource: resources\skins\Path of Exile\Compact\ButtonKickPress.png"
	.	"`nDest: " PROGRAM.SKINS_FOLDER "\Path of Exile\Compact\ButtonKickPress.png"
	.	"`nFlag: " 2)
	errorLog .= "`n`n""Failed to extract file!"
	.	"`nSource: resources\skins\Path of Exile\Compact\ButtonKickPress.png"
	.	"`nDest: " PROGRAM.SKINS_FOLDER "\Path of Exile\Compact\ButtonKickPress.png"
	.	"`nFlag: " 2
}

; ----------------------------
if !InStr(FileExist(PROGRAM.SKINS_FOLDER "\Path of Exile\Compact"), "D")
	FileCreateDir,% PROGRAM.SKINS_FOLDER "\Path of Exile\Compact"

if (A_IsCompiled) {
	sourceFileSize := Get_ResourceSize("resources\skins\Path of Exile\Compact\ButtonThanks.png")
	FileGetSize, destFileSize, % PROGRAM.SKINS_FOLDER "\Path of Exile\Compact\ButtonThanks.png"
}
else {
	FileGetSize, sourceFileSize, resources\skins\Path of Exile\Compact\ButtonThanks.png
	FileGetSize, destFileSize, % PROGRAM.SKINS_FOLDER "\Path of Exile\Compact\ButtonThanks.png"
}
if (sourceFileSize != destFileSize)
	FileInstall, resources\skins\Path of Exile\Compact\ButtonThanks.png, % PROGRAM.SKINS_FOLDER "\Path of Exile\Compact\ButtonThanks.png", 1
if (ErrorLevel) {
	AppendToLogs("Failed to extract file!"
	.	"`nSource: resources\skins\Path of Exile\Compact\ButtonThanks.png"
	.	"`nDest: " PROGRAM.SKINS_FOLDER "\Path of Exile\Compact\ButtonThanks.png"
	.	"`nFlag: " 2)
	errorLog .= "`n`n""Failed to extract file!"
	.	"`nSource: resources\skins\Path of Exile\Compact\ButtonThanks.png"
	.	"`nDest: " PROGRAM.SKINS_FOLDER "\Path of Exile\Compact\ButtonThanks.png"
	.	"`nFlag: " 2
}

; ----------------------------
if !InStr(FileExist(PROGRAM.SKINS_FOLDER "\Path of Exile\Compact"), "D")
	FileCreateDir,% PROGRAM.SKINS_FOLDER "\Path of Exile\Compact"

if (A_IsCompiled) {
	sourceFileSize := Get_ResourceSize("resources\skins\Path of Exile\Compact\ButtonThanksHover.png")
	FileGetSize, destFileSize, % PROGRAM.SKINS_FOLDER "\Path of Exile\Compact\ButtonThanksHover.png"
}
else {
	FileGetSize, sourceFileSize, resources\skins\Path of Exile\Compact\ButtonThanksHover.png
	FileGetSize, destFileSize, % PROGRAM.SKINS_FOLDER "\Path of Exile\Compact\ButtonThanksHover.png"
}
if (sourceFileSize != destFileSize)
	FileInstall, resources\skins\Path of Exile\Compact\ButtonThanksHover.png, % PROGRAM.SKINS_FOLDER "\Path of Exile\Compact\ButtonThanksHover.png", 1
if (ErrorLevel) {
	AppendToLogs("Failed to extract file!"
	.	"`nSource: resources\skins\Path of Exile\Compact\ButtonThanksHover.png"
	.	"`nDest: " PROGRAM.SKINS_FOLDER "\Path of Exile\Compact\ButtonThanksHover.png"
	.	"`nFlag: " 2)
	errorLog .= "`n`n""Failed to extract file!"
	.	"`nSource: resources\skins\Path of Exile\Compact\ButtonThanksHover.png"
	.	"`nDest: " PROGRAM.SKINS_FOLDER "\Path of Exile\Compact\ButtonThanksHover.png"
	.	"`nFlag: " 2
}

; ----------------------------
if !InStr(FileExist(PROGRAM.SKINS_FOLDER "\Path of Exile\Compact"), "D")
	FileCreateDir,% PROGRAM.SKINS_FOLDER "\Path of Exile\Compact"

if (A_IsCompiled) {
	sourceFileSize := Get_ResourceSize("resources\skins\Path of Exile\Compact\ButtonThanksPress.png")
	FileGetSize, destFileSize, % PROGRAM.SKINS_FOLDER "\Path of Exile\Compact\ButtonThanksPress.png"
}
else {
	FileGetSize, sourceFileSize, resources\skins\Path of Exile\Compact\ButtonThanksPress.png
	FileGetSize, destFileSize, % PROGRAM.SKINS_FOLDER "\Path of Exile\Compact\ButtonThanksPress.png"
}
if (sourceFileSize != destFileSize)
	FileInstall, resources\skins\Path of Exile\Compact\ButtonThanksPress.png, % PROGRAM.SKINS_FOLDER "\Path of Exile\Compact\ButtonThanksPress.png", 1
if (ErrorLevel) {
	AppendToLogs("Failed to extract file!"
	.	"`nSource: resources\skins\Path of Exile\Compact\ButtonThanksPress.png"
	.	"`nDest: " PROGRAM.SKINS_FOLDER "\Path of Exile\Compact\ButtonThanksPress.png"
	.	"`nFlag: " 2)
	errorLog .= "`n`n""Failed to extract file!"
	.	"`nSource: resources\skins\Path of Exile\Compact\ButtonThanksPress.png"
	.	"`nDest: " PROGRAM.SKINS_FOLDER "\Path of Exile\Compact\ButtonThanksPress.png"
	.	"`nFlag: " 2
}

; ----------------------------
if !InStr(FileExist(PROGRAM.SKINS_FOLDER "\Path of Exile\Compact"), "D")
	FileCreateDir,% PROGRAM.SKINS_FOLDER "\Path of Exile\Compact"

if (A_IsCompiled) {
	sourceFileSize := Get_ResourceSize("resources\skins\Path of Exile\Compact\ButtonWhisper.png")
	FileGetSize, destFileSize, % PROGRAM.SKINS_FOLDER "\Path of Exile\Compact\ButtonWhisper.png"
}
else {
	FileGetSize, sourceFileSize, resources\skins\Path of Exile\Compact\ButtonWhisper.png
	FileGetSize, destFileSize, % PROGRAM.SKINS_FOLDER "\Path of Exile\Compact\ButtonWhisper.png"
}
if (sourceFileSize != destFileSize)
	FileInstall, resources\skins\Path of Exile\Compact\ButtonWhisper.png, % PROGRAM.SKINS_FOLDER "\Path of Exile\Compact\ButtonWhisper.png", 1
if (ErrorLevel) {
	AppendToLogs("Failed to extract file!"
	.	"`nSource: resources\skins\Path of Exile\Compact\ButtonWhisper.png"
	.	"`nDest: " PROGRAM.SKINS_FOLDER "\Path of Exile\Compact\ButtonWhisper.png"
	.	"`nFlag: " 2)
	errorLog .= "`n`n""Failed to extract file!"
	.	"`nSource: resources\skins\Path of Exile\Compact\ButtonWhisper.png"
	.	"`nDest: " PROGRAM.SKINS_FOLDER "\Path of Exile\Compact\ButtonWhisper.png"
	.	"`nFlag: " 2
}

; ----------------------------
if !InStr(FileExist(PROGRAM.SKINS_FOLDER "\Path of Exile\Compact"), "D")
	FileCreateDir,% PROGRAM.SKINS_FOLDER "\Path of Exile\Compact"

if (A_IsCompiled) {
	sourceFileSize := Get_ResourceSize("resources\skins\Path of Exile\Compact\ButtonWhisperHover.png")
	FileGetSize, destFileSize, % PROGRAM.SKINS_FOLDER "\Path of Exile\Compact\ButtonWhisperHover.png"
}
else {
	FileGetSize, sourceFileSize, resources\skins\Path of Exile\Compact\ButtonWhisperHover.png
	FileGetSize, destFileSize, % PROGRAM.SKINS_FOLDER "\Path of Exile\Compact\ButtonWhisperHover.png"
}
if (sourceFileSize != destFileSize)
	FileInstall, resources\skins\Path of Exile\Compact\ButtonWhisperHover.png, % PROGRAM.SKINS_FOLDER "\Path of Exile\Compact\ButtonWhisperHover.png", 1
if (ErrorLevel) {
	AppendToLogs("Failed to extract file!"
	.	"`nSource: resources\skins\Path of Exile\Compact\ButtonWhisperHover.png"
	.	"`nDest: " PROGRAM.SKINS_FOLDER "\Path of Exile\Compact\ButtonWhisperHover.png"
	.	"`nFlag: " 2)
	errorLog .= "`n`n""Failed to extract file!"
	.	"`nSource: resources\skins\Path of Exile\Compact\ButtonWhisperHover.png"
	.	"`nDest: " PROGRAM.SKINS_FOLDER "\Path of Exile\Compact\ButtonWhisperHover.png"
	.	"`nFlag: " 2
}

; ----------------------------
if !InStr(FileExist(PROGRAM.SKINS_FOLDER "\Path of Exile\Compact"), "D")
	FileCreateDir,% PROGRAM.SKINS_FOLDER "\Path of Exile\Compact"

if (A_IsCompiled) {
	sourceFileSize := Get_ResourceSize("resources\skins\Path of Exile\Compact\ButtonWhisperPress.png")
	FileGetSize, destFileSize, % PROGRAM.SKINS_FOLDER "\Path of Exile\Compact\ButtonWhisperPress.png"
}
else {
	FileGetSize, sourceFileSize, resources\skins\Path of Exile\Compact\ButtonWhisperPress.png
	FileGetSize, destFileSize, % PROGRAM.SKINS_FOLDER "\Path of Exile\Compact\ButtonWhisperPress.png"
}
if (sourceFileSize != destFileSize)
	FileInstall, resources\skins\Path of Exile\Compact\ButtonWhisperPress.png, % PROGRAM.SKINS_FOLDER "\Path of Exile\Compact\ButtonWhisperPress.png", 1
if (ErrorLevel) {
	AppendToLogs("Failed to extract file!"
	.	"`nSource: resources\skins\Path of Exile\Compact\ButtonWhisperPress.png"
	.	"`nDest: " PROGRAM.SKINS_FOLDER "\Path of Exile\Compact\ButtonWhisperPress.png"
	.	"`nFlag: " 2)
	errorLog .= "`n`n""Failed to extract file!"
	.	"`nSource: resources\skins\Path of Exile\Compact\ButtonWhisperPress.png"
	.	"`nDest: " PROGRAM.SKINS_FOLDER "\Path of Exile\Compact\ButtonWhisperPress.png"
	.	"`nFlag: " 2
}

; ----------------------------
if !InStr(FileExist(PROGRAM.SKINS_FOLDER "\Path of Exile\Compact"), "D")
	FileCreateDir,% PROGRAM.SKINS_FOLDER "\Path of Exile\Compact"

if (A_IsCompiled) {
	sourceFileSize := Get_ResourceSize("resources\skins\Path of Exile\Compact\CloseTab.png")
	FileGetSize, destFileSize, % PROGRAM.SKINS_FOLDER "\Path of Exile\Compact\CloseTab.png"
}
else {
	FileGetSize, sourceFileSize, resources\skins\Path of Exile\Compact\CloseTab.png
	FileGetSize, destFileSize, % PROGRAM.SKINS_FOLDER "\Path of Exile\Compact\CloseTab.png"
}
if (sourceFileSize != destFileSize)
	FileInstall, resources\skins\Path of Exile\Compact\CloseTab.png, % PROGRAM.SKINS_FOLDER "\Path of Exile\Compact\CloseTab.png", 1
if (ErrorLevel) {
	AppendToLogs("Failed to extract file!"
	.	"`nSource: resources\skins\Path of Exile\Compact\CloseTab.png"
	.	"`nDest: " PROGRAM.SKINS_FOLDER "\Path of Exile\Compact\CloseTab.png"
	.	"`nFlag: " 2)
	errorLog .= "`n`n""Failed to extract file!"
	.	"`nSource: resources\skins\Path of Exile\Compact\CloseTab.png"
	.	"`nDest: " PROGRAM.SKINS_FOLDER "\Path of Exile\Compact\CloseTab.png"
	.	"`nFlag: " 2
}

; ----------------------------
if !InStr(FileExist(PROGRAM.SKINS_FOLDER "\Path of Exile\Compact"), "D")
	FileCreateDir,% PROGRAM.SKINS_FOLDER "\Path of Exile\Compact"

if (A_IsCompiled) {
	sourceFileSize := Get_ResourceSize("resources\skins\Path of Exile\Compact\CloseTabHover.png")
	FileGetSize, destFileSize, % PROGRAM.SKINS_FOLDER "\Path of Exile\Compact\CloseTabHover.png"
}
else {
	FileGetSize, sourceFileSize, resources\skins\Path of Exile\Compact\CloseTabHover.png
	FileGetSize, destFileSize, % PROGRAM.SKINS_FOLDER "\Path of Exile\Compact\CloseTabHover.png"
}
if (sourceFileSize != destFileSize)
	FileInstall, resources\skins\Path of Exile\Compact\CloseTabHover.png, % PROGRAM.SKINS_FOLDER "\Path of Exile\Compact\CloseTabHover.png", 1
if (ErrorLevel) {
	AppendToLogs("Failed to extract file!"
	.	"`nSource: resources\skins\Path of Exile\Compact\CloseTabHover.png"
	.	"`nDest: " PROGRAM.SKINS_FOLDER "\Path of Exile\Compact\CloseTabHover.png"
	.	"`nFlag: " 2)
	errorLog .= "`n`n""Failed to extract file!"
	.	"`nSource: resources\skins\Path of Exile\Compact\CloseTabHover.png"
	.	"`nDest: " PROGRAM.SKINS_FOLDER "\Path of Exile\Compact\CloseTabHover.png"
	.	"`nFlag: " 2
}

; ----------------------------
if !InStr(FileExist(PROGRAM.SKINS_FOLDER "\Path of Exile\Compact"), "D")
	FileCreateDir,% PROGRAM.SKINS_FOLDER "\Path of Exile\Compact"

if (A_IsCompiled) {
	sourceFileSize := Get_ResourceSize("resources\skins\Path of Exile\Compact\CloseTabPress.png")
	FileGetSize, destFileSize, % PROGRAM.SKINS_FOLDER "\Path of Exile\Compact\CloseTabPress.png"
}
else {
	FileGetSize, sourceFileSize, resources\skins\Path of Exile\Compact\CloseTabPress.png
	FileGetSize, destFileSize, % PROGRAM.SKINS_FOLDER "\Path of Exile\Compact\CloseTabPress.png"
}
if (sourceFileSize != destFileSize)
	FileInstall, resources\skins\Path of Exile\Compact\CloseTabPress.png, % PROGRAM.SKINS_FOLDER "\Path of Exile\Compact\CloseTabPress.png", 1
if (ErrorLevel) {
	AppendToLogs("Failed to extract file!"
	.	"`nSource: resources\skins\Path of Exile\Compact\CloseTabPress.png"
	.	"`nDest: " PROGRAM.SKINS_FOLDER "\Path of Exile\Compact\CloseTabPress.png"
	.	"`nFlag: " 2)
	errorLog .= "`n`n""Failed to extract file!"
	.	"`nSource: resources\skins\Path of Exile\Compact\CloseTabPress.png"
	.	"`nDest: " PROGRAM.SKINS_FOLDER "\Path of Exile\Compact\CloseTabPress.png"
	.	"`nFlag: " 2
}

; ----------------------------
if !InStr(FileExist(PROGRAM.SKINS_FOLDER "\Path of Exile\Compact"), "D")
	FileCreateDir,% PROGRAM.SKINS_FOLDER "\Path of Exile\Compact"

if (A_IsCompiled) {
	sourceFileSize := Get_ResourceSize("resources\skins\Path of Exile\Compact\Header.png")
	FileGetSize, destFileSize, % PROGRAM.SKINS_FOLDER "\Path of Exile\Compact\Header.png"
}
else {
	FileGetSize, sourceFileSize, resources\skins\Path of Exile\Compact\Header.png
	FileGetSize, destFileSize, % PROGRAM.SKINS_FOLDER "\Path of Exile\Compact\Header.png"
}
if (sourceFileSize != destFileSize)
	FileInstall, resources\skins\Path of Exile\Compact\Header.png, % PROGRAM.SKINS_FOLDER "\Path of Exile\Compact\Header.png", 1
if (ErrorLevel) {
	AppendToLogs("Failed to extract file!"
	.	"`nSource: resources\skins\Path of Exile\Compact\Header.png"
	.	"`nDest: " PROGRAM.SKINS_FOLDER "\Path of Exile\Compact\Header.png"
	.	"`nFlag: " 2)
	errorLog .= "`n`n""Failed to extract file!"
	.	"`nSource: resources\skins\Path of Exile\Compact\Header.png"
	.	"`nDest: " PROGRAM.SKINS_FOLDER "\Path of Exile\Compact\Header.png"
	.	"`nFlag: " 2
}

; ----------------------------
if !InStr(FileExist(PROGRAM.SKINS_FOLDER "\Path of Exile\Compact"), "D")
	FileCreateDir,% PROGRAM.SKINS_FOLDER "\Path of Exile\Compact"

if (A_IsCompiled) {
	sourceFileSize := Get_ResourceSize("resources\skins\Path of Exile\Compact\Header2.png")
	FileGetSize, destFileSize, % PROGRAM.SKINS_FOLDER "\Path of Exile\Compact\Header2.png"
}
else {
	FileGetSize, sourceFileSize, resources\skins\Path of Exile\Compact\Header2.png
	FileGetSize, destFileSize, % PROGRAM.SKINS_FOLDER "\Path of Exile\Compact\Header2.png"
}
if (sourceFileSize != destFileSize)
	FileInstall, resources\skins\Path of Exile\Compact\Header2.png, % PROGRAM.SKINS_FOLDER "\Path of Exile\Compact\Header2.png", 1
if (ErrorLevel) {
	AppendToLogs("Failed to extract file!"
	.	"`nSource: resources\skins\Path of Exile\Compact\Header2.png"
	.	"`nDest: " PROGRAM.SKINS_FOLDER "\Path of Exile\Compact\Header2.png"
	.	"`nFlag: " 2)
	errorLog .= "`n`n""Failed to extract file!"
	.	"`nSource: resources\skins\Path of Exile\Compact\Header2.png"
	.	"`nDest: " PROGRAM.SKINS_FOLDER "\Path of Exile\Compact\Header2.png"
	.	"`nFlag: " 2
}

; ----------------------------
if !InStr(FileExist(PROGRAM.SKINS_FOLDER "\Path of Exile\Compact"), "D")
	FileCreateDir,% PROGRAM.SKINS_FOLDER "\Path of Exile\Compact"

if (A_IsCompiled) {
	sourceFileSize := Get_ResourceSize("resources\skins\Path of Exile\Compact\Maximize.png")
	FileGetSize, destFileSize, % PROGRAM.SKINS_FOLDER "\Path of Exile\Compact\Maximize.png"
}
else {
	FileGetSize, sourceFileSize, resources\skins\Path of Exile\Compact\Maximize.png
	FileGetSize, destFileSize, % PROGRAM.SKINS_FOLDER "\Path of Exile\Compact\Maximize.png"
}
if (sourceFileSize != destFileSize)
	FileInstall, resources\skins\Path of Exile\Compact\Maximize.png, % PROGRAM.SKINS_FOLDER "\Path of Exile\Compact\Maximize.png", 1
if (ErrorLevel) {
	AppendToLogs("Failed to extract file!"
	.	"`nSource: resources\skins\Path of Exile\Compact\Maximize.png"
	.	"`nDest: " PROGRAM.SKINS_FOLDER "\Path of Exile\Compact\Maximize.png"
	.	"`nFlag: " 2)
	errorLog .= "`n`n""Failed to extract file!"
	.	"`nSource: resources\skins\Path of Exile\Compact\Maximize.png"
	.	"`nDest: " PROGRAM.SKINS_FOLDER "\Path of Exile\Compact\Maximize.png"
	.	"`nFlag: " 2
}

; ----------------------------
if !InStr(FileExist(PROGRAM.SKINS_FOLDER "\Path of Exile\Compact"), "D")
	FileCreateDir,% PROGRAM.SKINS_FOLDER "\Path of Exile\Compact"

if (A_IsCompiled) {
	sourceFileSize := Get_ResourceSize("resources\skins\Path of Exile\Compact\MaximizeHover.png")
	FileGetSize, destFileSize, % PROGRAM.SKINS_FOLDER "\Path of Exile\Compact\MaximizeHover.png"
}
else {
	FileGetSize, sourceFileSize, resources\skins\Path of Exile\Compact\MaximizeHover.png
	FileGetSize, destFileSize, % PROGRAM.SKINS_FOLDER "\Path of Exile\Compact\MaximizeHover.png"
}
if (sourceFileSize != destFileSize)
	FileInstall, resources\skins\Path of Exile\Compact\MaximizeHover.png, % PROGRAM.SKINS_FOLDER "\Path of Exile\Compact\MaximizeHover.png", 1
if (ErrorLevel) {
	AppendToLogs("Failed to extract file!"
	.	"`nSource: resources\skins\Path of Exile\Compact\MaximizeHover.png"
	.	"`nDest: " PROGRAM.SKINS_FOLDER "\Path of Exile\Compact\MaximizeHover.png"
	.	"`nFlag: " 2)
	errorLog .= "`n`n""Failed to extract file!"
	.	"`nSource: resources\skins\Path of Exile\Compact\MaximizeHover.png"
	.	"`nDest: " PROGRAM.SKINS_FOLDER "\Path of Exile\Compact\MaximizeHover.png"
	.	"`nFlag: " 2
}

; ----------------------------
if !InStr(FileExist(PROGRAM.SKINS_FOLDER "\Path of Exile\Compact"), "D")
	FileCreateDir,% PROGRAM.SKINS_FOLDER "\Path of Exile\Compact"

if (A_IsCompiled) {
	sourceFileSize := Get_ResourceSize("resources\skins\Path of Exile\Compact\MaximizePress.png")
	FileGetSize, destFileSize, % PROGRAM.SKINS_FOLDER "\Path of Exile\Compact\MaximizePress.png"
}
else {
	FileGetSize, sourceFileSize, resources\skins\Path of Exile\Compact\MaximizePress.png
	FileGetSize, destFileSize, % PROGRAM.SKINS_FOLDER "\Path of Exile\Compact\MaximizePress.png"
}
if (sourceFileSize != destFileSize)
	FileInstall, resources\skins\Path of Exile\Compact\MaximizePress.png, % PROGRAM.SKINS_FOLDER "\Path of Exile\Compact\MaximizePress.png", 1
if (ErrorLevel) {
	AppendToLogs("Failed to extract file!"
	.	"`nSource: resources\skins\Path of Exile\Compact\MaximizePress.png"
	.	"`nDest: " PROGRAM.SKINS_FOLDER "\Path of Exile\Compact\MaximizePress.png"
	.	"`nFlag: " 2)
	errorLog .= "`n`n""Failed to extract file!"
	.	"`nSource: resources\skins\Path of Exile\Compact\MaximizePress.png"
	.	"`nDest: " PROGRAM.SKINS_FOLDER "\Path of Exile\Compact\MaximizePress.png"
	.	"`nFlag: " 2
}

; ----------------------------
if !InStr(FileExist(PROGRAM.SKINS_FOLDER "\Path of Exile\Compact"), "D")
	FileCreateDir,% PROGRAM.SKINS_FOLDER "\Path of Exile\Compact"

if (A_IsCompiled) {
	sourceFileSize := Get_ResourceSize("resources\skins\Path of Exile\Compact\Minimize.png")
	FileGetSize, destFileSize, % PROGRAM.SKINS_FOLDER "\Path of Exile\Compact\Minimize.png"
}
else {
	FileGetSize, sourceFileSize, resources\skins\Path of Exile\Compact\Minimize.png
	FileGetSize, destFileSize, % PROGRAM.SKINS_FOLDER "\Path of Exile\Compact\Minimize.png"
}
if (sourceFileSize != destFileSize)
	FileInstall, resources\skins\Path of Exile\Compact\Minimize.png, % PROGRAM.SKINS_FOLDER "\Path of Exile\Compact\Minimize.png", 1
if (ErrorLevel) {
	AppendToLogs("Failed to extract file!"
	.	"`nSource: resources\skins\Path of Exile\Compact\Minimize.png"
	.	"`nDest: " PROGRAM.SKINS_FOLDER "\Path of Exile\Compact\Minimize.png"
	.	"`nFlag: " 2)
	errorLog .= "`n`n""Failed to extract file!"
	.	"`nSource: resources\skins\Path of Exile\Compact\Minimize.png"
	.	"`nDest: " PROGRAM.SKINS_FOLDER "\Path of Exile\Compact\Minimize.png"
	.	"`nFlag: " 2
}

; ----------------------------
if !InStr(FileExist(PROGRAM.SKINS_FOLDER "\Path of Exile\Compact"), "D")
	FileCreateDir,% PROGRAM.SKINS_FOLDER "\Path of Exile\Compact"

if (A_IsCompiled) {
	sourceFileSize := Get_ResourceSize("resources\skins\Path of Exile\Compact\MinimizeHover.png")
	FileGetSize, destFileSize, % PROGRAM.SKINS_FOLDER "\Path of Exile\Compact\MinimizeHover.png"
}
else {
	FileGetSize, sourceFileSize, resources\skins\Path of Exile\Compact\MinimizeHover.png
	FileGetSize, destFileSize, % PROGRAM.SKINS_FOLDER "\Path of Exile\Compact\MinimizeHover.png"
}
if (sourceFileSize != destFileSize)
	FileInstall, resources\skins\Path of Exile\Compact\MinimizeHover.png, % PROGRAM.SKINS_FOLDER "\Path of Exile\Compact\MinimizeHover.png", 1
if (ErrorLevel) {
	AppendToLogs("Failed to extract file!"
	.	"`nSource: resources\skins\Path of Exile\Compact\MinimizeHover.png"
	.	"`nDest: " PROGRAM.SKINS_FOLDER "\Path of Exile\Compact\MinimizeHover.png"
	.	"`nFlag: " 2)
	errorLog .= "`n`n""Failed to extract file!"
	.	"`nSource: resources\skins\Path of Exile\Compact\MinimizeHover.png"
	.	"`nDest: " PROGRAM.SKINS_FOLDER "\Path of Exile\Compact\MinimizeHover.png"
	.	"`nFlag: " 2
}

; ----------------------------
if !InStr(FileExist(PROGRAM.SKINS_FOLDER "\Path of Exile\Compact"), "D")
	FileCreateDir,% PROGRAM.SKINS_FOLDER "\Path of Exile\Compact"

if (A_IsCompiled) {
	sourceFileSize := Get_ResourceSize("resources\skins\Path of Exile\Compact\MinimizePress.png")
	FileGetSize, destFileSize, % PROGRAM.SKINS_FOLDER "\Path of Exile\Compact\MinimizePress.png"
}
else {
	FileGetSize, sourceFileSize, resources\skins\Path of Exile\Compact\MinimizePress.png
	FileGetSize, destFileSize, % PROGRAM.SKINS_FOLDER "\Path of Exile\Compact\MinimizePress.png"
}
if (sourceFileSize != destFileSize)
	FileInstall, resources\skins\Path of Exile\Compact\MinimizePress.png, % PROGRAM.SKINS_FOLDER "\Path of Exile\Compact\MinimizePress.png", 1
if (ErrorLevel) {
	AppendToLogs("Failed to extract file!"
	.	"`nSource: resources\skins\Path of Exile\Compact\MinimizePress.png"
	.	"`nDest: " PROGRAM.SKINS_FOLDER "\Path of Exile\Compact\MinimizePress.png"
	.	"`nFlag: " 2)
	errorLog .= "`n`n""Failed to extract file!"
	.	"`nSource: resources\skins\Path of Exile\Compact\MinimizePress.png"
	.	"`nDest: " PROGRAM.SKINS_FOLDER "\Path of Exile\Compact\MinimizePress.png"
	.	"`nFlag: " 2
}

; ----------------------------
if !InStr(FileExist(PROGRAM.SKINS_FOLDER "\Path of Exile\Compact"), "D")
	FileCreateDir,% PROGRAM.SKINS_FOLDER "\Path of Exile\Compact"

if (A_IsCompiled) {
	sourceFileSize := Get_ResourceSize("resources\skins\Path of Exile\Compact\Preview.png")
	FileGetSize, destFileSize, % PROGRAM.SKINS_FOLDER "\Path of Exile\Compact\Preview.png"
}
else {
	FileGetSize, sourceFileSize, resources\skins\Path of Exile\Compact\Preview.png
	FileGetSize, destFileSize, % PROGRAM.SKINS_FOLDER "\Path of Exile\Compact\Preview.png"
}
if (sourceFileSize != destFileSize)
	FileInstall, resources\skins\Path of Exile\Compact\Preview.png, % PROGRAM.SKINS_FOLDER "\Path of Exile\Compact\Preview.png", 1
if (ErrorLevel) {
	AppendToLogs("Failed to extract file!"
	.	"`nSource: resources\skins\Path of Exile\Compact\Preview.png"
	.	"`nDest: " PROGRAM.SKINS_FOLDER "\Path of Exile\Compact\Preview.png"
	.	"`nFlag: " 2)
	errorLog .= "`n`n""Failed to extract file!"
	.	"`nSource: resources\skins\Path of Exile\Compact\Preview.png"
	.	"`nDest: " PROGRAM.SKINS_FOLDER "\Path of Exile\Compact\Preview.png"
	.	"`nFlag: " 2
}

; ----------------------------
if !InStr(FileExist(PROGRAM.SKINS_FOLDER "\Path of Exile\Compact"), "D")
	FileCreateDir,% PROGRAM.SKINS_FOLDER "\Path of Exile\Compact"

FileInstall, resources\skins\Path of Exile\Compact\Settings.ini, % PROGRAM.SKINS_FOLDER "\Path of Exile\Compact\Settings.ini", 1
if (ErrorLevel) {
	AppendToLogs("Failed to extract file!"
	.	"`nSource: resources\skins\Path of Exile\Compact\Settings.ini"
	.	"`nDest: " PROGRAM.SKINS_FOLDER "\Path of Exile\Compact\Settings.ini"
	.	"`nFlag: " 1)
	errorLog .= "`n`n""Failed to extract file!"
	.	"`nSource: resources\skins\Path of Exile\Compact\Settings.ini"
	.	"`nDest: " PROGRAM.SKINS_FOLDER "\Path of Exile\Compact\Settings.ini"
	.	"`nFlag: " 1
}

; ----------------------------
if !InStr(FileExist(PROGRAM.SKINS_FOLDER "\Path of Exile\Compact"), "D")
	FileCreateDir,% PROGRAM.SKINS_FOLDER "\Path of Exile\Compact"

if (A_IsCompiled) {
	sourceFileSize := Get_ResourceSize("resources\skins\Path of Exile\Compact\ToolbarHideout.png")
	FileGetSize, destFileSize, % PROGRAM.SKINS_FOLDER "\Path of Exile\Compact\ToolbarHideout.png"
}
else {
	FileGetSize, sourceFileSize, resources\skins\Path of Exile\Compact\ToolbarHideout.png
	FileGetSize, destFileSize, % PROGRAM.SKINS_FOLDER "\Path of Exile\Compact\ToolbarHideout.png"
}
if (sourceFileSize != destFileSize)
	FileInstall, resources\skins\Path of Exile\Compact\ToolbarHideout.png, % PROGRAM.SKINS_FOLDER "\Path of Exile\Compact\ToolbarHideout.png", 1
if (ErrorLevel) {
	AppendToLogs("Failed to extract file!"
	.	"`nSource: resources\skins\Path of Exile\Compact\ToolbarHideout.png"
	.	"`nDest: " PROGRAM.SKINS_FOLDER "\Path of Exile\Compact\ToolbarHideout.png"
	.	"`nFlag: " 2)
	errorLog .= "`n`n""Failed to extract file!"
	.	"`nSource: resources\skins\Path of Exile\Compact\ToolbarHideout.png"
	.	"`nDest: " PROGRAM.SKINS_FOLDER "\Path of Exile\Compact\ToolbarHideout.png"
	.	"`nFlag: " 2
}

; ----------------------------
if !InStr(FileExist(PROGRAM.SKINS_FOLDER "\Path of Exile\Compact"), "D")
	FileCreateDir,% PROGRAM.SKINS_FOLDER "\Path of Exile\Compact"

if (A_IsCompiled) {
	sourceFileSize := Get_ResourceSize("resources\skins\Path of Exile\Compact\ToolbarHideoutHover.png")
	FileGetSize, destFileSize, % PROGRAM.SKINS_FOLDER "\Path of Exile\Compact\ToolbarHideoutHover.png"
}
else {
	FileGetSize, sourceFileSize, resources\skins\Path of Exile\Compact\ToolbarHideoutHover.png
	FileGetSize, destFileSize, % PROGRAM.SKINS_FOLDER "\Path of Exile\Compact\ToolbarHideoutHover.png"
}
if (sourceFileSize != destFileSize)
	FileInstall, resources\skins\Path of Exile\Compact\ToolbarHideoutHover.png, % PROGRAM.SKINS_FOLDER "\Path of Exile\Compact\ToolbarHideoutHover.png", 1
if (ErrorLevel) {
	AppendToLogs("Failed to extract file!"
	.	"`nSource: resources\skins\Path of Exile\Compact\ToolbarHideoutHover.png"
	.	"`nDest: " PROGRAM.SKINS_FOLDER "\Path of Exile\Compact\ToolbarHideoutHover.png"
	.	"`nFlag: " 2)
	errorLog .= "`n`n""Failed to extract file!"
	.	"`nSource: resources\skins\Path of Exile\Compact\ToolbarHideoutHover.png"
	.	"`nDest: " PROGRAM.SKINS_FOLDER "\Path of Exile\Compact\ToolbarHideoutHover.png"
	.	"`nFlag: " 2
}

; ----------------------------
if !InStr(FileExist(PROGRAM.SKINS_FOLDER "\Path of Exile\Compact"), "D")
	FileCreateDir,% PROGRAM.SKINS_FOLDER "\Path of Exile\Compact"

if (A_IsCompiled) {
	sourceFileSize := Get_ResourceSize("resources\skins\Path of Exile\Compact\ToolbarHideoutPress.png")
	FileGetSize, destFileSize, % PROGRAM.SKINS_FOLDER "\Path of Exile\Compact\ToolbarHideoutPress.png"
}
else {
	FileGetSize, sourceFileSize, resources\skins\Path of Exile\Compact\ToolbarHideoutPress.png
	FileGetSize, destFileSize, % PROGRAM.SKINS_FOLDER "\Path of Exile\Compact\ToolbarHideoutPress.png"
}
if (sourceFileSize != destFileSize)
	FileInstall, resources\skins\Path of Exile\Compact\ToolbarHideoutPress.png, % PROGRAM.SKINS_FOLDER "\Path of Exile\Compact\ToolbarHideoutPress.png", 1
if (ErrorLevel) {
	AppendToLogs("Failed to extract file!"
	.	"`nSource: resources\skins\Path of Exile\Compact\ToolbarHideoutPress.png"
	.	"`nDest: " PROGRAM.SKINS_FOLDER "\Path of Exile\Compact\ToolbarHideoutPress.png"
	.	"`nFlag: " 2)
	errorLog .= "`n`n""Failed to extract file!"
	.	"`nSource: resources\skins\Path of Exile\Compact\ToolbarHideoutPress.png"
	.	"`nDest: " PROGRAM.SKINS_FOLDER "\Path of Exile\Compact\ToolbarHideoutPress.png"
	.	"`nFlag: " 2
}

; ----------------------------
if !InStr(FileExist(PROGRAM.SKINS_FOLDER "\Path of Exile\Compact"), "D")
	FileCreateDir,% PROGRAM.SKINS_FOLDER "\Path of Exile\Compact"

if (A_IsCompiled) {
	sourceFileSize := Get_ResourceSize("resources\skins\Path of Exile\Compact\ToolbarSheet.png")
	FileGetSize, destFileSize, % PROGRAM.SKINS_FOLDER "\Path of Exile\Compact\ToolbarSheet.png"
}
else {
	FileGetSize, sourceFileSize, resources\skins\Path of Exile\Compact\ToolbarSheet.png
	FileGetSize, destFileSize, % PROGRAM.SKINS_FOLDER "\Path of Exile\Compact\ToolbarSheet.png"
}
if (sourceFileSize != destFileSize)
	FileInstall, resources\skins\Path of Exile\Compact\ToolbarSheet.png, % PROGRAM.SKINS_FOLDER "\Path of Exile\Compact\ToolbarSheet.png", 1
if (ErrorLevel) {
	AppendToLogs("Failed to extract file!"
	.	"`nSource: resources\skins\Path of Exile\Compact\ToolbarSheet.png"
	.	"`nDest: " PROGRAM.SKINS_FOLDER "\Path of Exile\Compact\ToolbarSheet.png"
	.	"`nFlag: " 2)
	errorLog .= "`n`n""Failed to extract file!"
	.	"`nSource: resources\skins\Path of Exile\Compact\ToolbarSheet.png"
	.	"`nDest: " PROGRAM.SKINS_FOLDER "\Path of Exile\Compact\ToolbarSheet.png"
	.	"`nFlag: " 2
}

; ----------------------------
if !InStr(FileExist(PROGRAM.SKINS_FOLDER "\Path of Exile\Compact"), "D")
	FileCreateDir,% PROGRAM.SKINS_FOLDER "\Path of Exile\Compact"

if (A_IsCompiled) {
	sourceFileSize := Get_ResourceSize("resources\skins\Path of Exile\Compact\ToolbarSheetHover.png")
	FileGetSize, destFileSize, % PROGRAM.SKINS_FOLDER "\Path of Exile\Compact\ToolbarSheetHover.png"
}
else {
	FileGetSize, sourceFileSize, resources\skins\Path of Exile\Compact\ToolbarSheetHover.png
	FileGetSize, destFileSize, % PROGRAM.SKINS_FOLDER "\Path of Exile\Compact\ToolbarSheetHover.png"
}
if (sourceFileSize != destFileSize)
	FileInstall, resources\skins\Path of Exile\Compact\ToolbarSheetHover.png, % PROGRAM.SKINS_FOLDER "\Path of Exile\Compact\ToolbarSheetHover.png", 1
if (ErrorLevel) {
	AppendToLogs("Failed to extract file!"
	.	"`nSource: resources\skins\Path of Exile\Compact\ToolbarSheetHover.png"
	.	"`nDest: " PROGRAM.SKINS_FOLDER "\Path of Exile\Compact\ToolbarSheetHover.png"
	.	"`nFlag: " 2)
	errorLog .= "`n`n""Failed to extract file!"
	.	"`nSource: resources\skins\Path of Exile\Compact\ToolbarSheetHover.png"
	.	"`nDest: " PROGRAM.SKINS_FOLDER "\Path of Exile\Compact\ToolbarSheetHover.png"
	.	"`nFlag: " 2
}

; ----------------------------
if !InStr(FileExist(PROGRAM.SKINS_FOLDER "\Path of Exile\Compact"), "D")
	FileCreateDir,% PROGRAM.SKINS_FOLDER "\Path of Exile\Compact"

if (A_IsCompiled) {
	sourceFileSize := Get_ResourceSize("resources\skins\Path of Exile\Compact\ToolbarSheetPress.png")
	FileGetSize, destFileSize, % PROGRAM.SKINS_FOLDER "\Path of Exile\Compact\ToolbarSheetPress.png"
}
else {
	FileGetSize, sourceFileSize, resources\skins\Path of Exile\Compact\ToolbarSheetPress.png
	FileGetSize, destFileSize, % PROGRAM.SKINS_FOLDER "\Path of Exile\Compact\ToolbarSheetPress.png"
}
if (sourceFileSize != destFileSize)
	FileInstall, resources\skins\Path of Exile\Compact\ToolbarSheetPress.png, % PROGRAM.SKINS_FOLDER "\Path of Exile\Compact\ToolbarSheetPress.png", 1
if (ErrorLevel) {
	AppendToLogs("Failed to extract file!"
	.	"`nSource: resources\skins\Path of Exile\Compact\ToolbarSheetPress.png"
	.	"`nDest: " PROGRAM.SKINS_FOLDER "\Path of Exile\Compact\ToolbarSheetPress.png"
	.	"`nFlag: " 2)
	errorLog .= "`n`n""Failed to extract file!"
	.	"`nSource: resources\skins\Path of Exile\Compact\ToolbarSheetPress.png"
	.	"`nDest: " PROGRAM.SKINS_FOLDER "\Path of Exile\Compact\ToolbarSheetPress.png"
	.	"`nFlag: " 2
}

; ----------------------------
if !InStr(FileExist(PROGRAM.SKINS_FOLDER "\White"), "D")
	FileCreateDir,% PROGRAM.SKINS_FOLDER "\White"

if (A_IsCompiled) {
	sourceFileSize := Get_ResourceSize("resources\skins\White\ArrowLeft.png")
	FileGetSize, destFileSize, % PROGRAM.SKINS_FOLDER "\White\ArrowLeft.png"
}
else {
	FileGetSize, sourceFileSize, resources\skins\White\ArrowLeft.png
	FileGetSize, destFileSize, % PROGRAM.SKINS_FOLDER "\White\ArrowLeft.png"
}
if (sourceFileSize != destFileSize)
	FileInstall, resources\skins\White\ArrowLeft.png, % PROGRAM.SKINS_FOLDER "\White\ArrowLeft.png", 1
if (ErrorLevel) {
	AppendToLogs("Failed to extract file!"
	.	"`nSource: resources\skins\White\ArrowLeft.png"
	.	"`nDest: " PROGRAM.SKINS_FOLDER "\White\ArrowLeft.png"
	.	"`nFlag: " 2)
	errorLog .= "`n`n""Failed to extract file!"
	.	"`nSource: resources\skins\White\ArrowLeft.png"
	.	"`nDest: " PROGRAM.SKINS_FOLDER "\White\ArrowLeft.png"
	.	"`nFlag: " 2
}

; ----------------------------
if !InStr(FileExist(PROGRAM.SKINS_FOLDER "\White"), "D")
	FileCreateDir,% PROGRAM.SKINS_FOLDER "\White"

if (A_IsCompiled) {
	sourceFileSize := Get_ResourceSize("resources\skins\White\ArrowLeftHover.png")
	FileGetSize, destFileSize, % PROGRAM.SKINS_FOLDER "\White\ArrowLeftHover.png"
}
else {
	FileGetSize, sourceFileSize, resources\skins\White\ArrowLeftHover.png
	FileGetSize, destFileSize, % PROGRAM.SKINS_FOLDER "\White\ArrowLeftHover.png"
}
if (sourceFileSize != destFileSize)
	FileInstall, resources\skins\White\ArrowLeftHover.png, % PROGRAM.SKINS_FOLDER "\White\ArrowLeftHover.png", 1
if (ErrorLevel) {
	AppendToLogs("Failed to extract file!"
	.	"`nSource: resources\skins\White\ArrowLeftHover.png"
	.	"`nDest: " PROGRAM.SKINS_FOLDER "\White\ArrowLeftHover.png"
	.	"`nFlag: " 2)
	errorLog .= "`n`n""Failed to extract file!"
	.	"`nSource: resources\skins\White\ArrowLeftHover.png"
	.	"`nDest: " PROGRAM.SKINS_FOLDER "\White\ArrowLeftHover.png"
	.	"`nFlag: " 2
}

; ----------------------------
if !InStr(FileExist(PROGRAM.SKINS_FOLDER "\White"), "D")
	FileCreateDir,% PROGRAM.SKINS_FOLDER "\White"

if (A_IsCompiled) {
	sourceFileSize := Get_ResourceSize("resources\skins\White\ArrowLeftPress.png")
	FileGetSize, destFileSize, % PROGRAM.SKINS_FOLDER "\White\ArrowLeftPress.png"
}
else {
	FileGetSize, sourceFileSize, resources\skins\White\ArrowLeftPress.png
	FileGetSize, destFileSize, % PROGRAM.SKINS_FOLDER "\White\ArrowLeftPress.png"
}
if (sourceFileSize != destFileSize)
	FileInstall, resources\skins\White\ArrowLeftPress.png, % PROGRAM.SKINS_FOLDER "\White\ArrowLeftPress.png", 1
if (ErrorLevel) {
	AppendToLogs("Failed to extract file!"
	.	"`nSource: resources\skins\White\ArrowLeftPress.png"
	.	"`nDest: " PROGRAM.SKINS_FOLDER "\White\ArrowLeftPress.png"
	.	"`nFlag: " 2)
	errorLog .= "`n`n""Failed to extract file!"
	.	"`nSource: resources\skins\White\ArrowLeftPress.png"
	.	"`nDest: " PROGRAM.SKINS_FOLDER "\White\ArrowLeftPress.png"
	.	"`nFlag: " 2
}

; ----------------------------
if !InStr(FileExist(PROGRAM.SKINS_FOLDER "\White"), "D")
	FileCreateDir,% PROGRAM.SKINS_FOLDER "\White"

if (A_IsCompiled) {
	sourceFileSize := Get_ResourceSize("resources\skins\White\ArrowRight.png")
	FileGetSize, destFileSize, % PROGRAM.SKINS_FOLDER "\White\ArrowRight.png"
}
else {
	FileGetSize, sourceFileSize, resources\skins\White\ArrowRight.png
	FileGetSize, destFileSize, % PROGRAM.SKINS_FOLDER "\White\ArrowRight.png"
}
if (sourceFileSize != destFileSize)
	FileInstall, resources\skins\White\ArrowRight.png, % PROGRAM.SKINS_FOLDER "\White\ArrowRight.png", 1
if (ErrorLevel) {
	AppendToLogs("Failed to extract file!"
	.	"`nSource: resources\skins\White\ArrowRight.png"
	.	"`nDest: " PROGRAM.SKINS_FOLDER "\White\ArrowRight.png"
	.	"`nFlag: " 2)
	errorLog .= "`n`n""Failed to extract file!"
	.	"`nSource: resources\skins\White\ArrowRight.png"
	.	"`nDest: " PROGRAM.SKINS_FOLDER "\White\ArrowRight.png"
	.	"`nFlag: " 2
}

; ----------------------------
if !InStr(FileExist(PROGRAM.SKINS_FOLDER "\White"), "D")
	FileCreateDir,% PROGRAM.SKINS_FOLDER "\White"

if (A_IsCompiled) {
	sourceFileSize := Get_ResourceSize("resources\skins\White\ArrowRightHover.png")
	FileGetSize, destFileSize, % PROGRAM.SKINS_FOLDER "\White\ArrowRightHover.png"
}
else {
	FileGetSize, sourceFileSize, resources\skins\White\ArrowRightHover.png
	FileGetSize, destFileSize, % PROGRAM.SKINS_FOLDER "\White\ArrowRightHover.png"
}
if (sourceFileSize != destFileSize)
	FileInstall, resources\skins\White\ArrowRightHover.png, % PROGRAM.SKINS_FOLDER "\White\ArrowRightHover.png", 1
if (ErrorLevel) {
	AppendToLogs("Failed to extract file!"
	.	"`nSource: resources\skins\White\ArrowRightHover.png"
	.	"`nDest: " PROGRAM.SKINS_FOLDER "\White\ArrowRightHover.png"
	.	"`nFlag: " 2)
	errorLog .= "`n`n""Failed to extract file!"
	.	"`nSource: resources\skins\White\ArrowRightHover.png"
	.	"`nDest: " PROGRAM.SKINS_FOLDER "\White\ArrowRightHover.png"
	.	"`nFlag: " 2
}

; ----------------------------
if !InStr(FileExist(PROGRAM.SKINS_FOLDER "\White"), "D")
	FileCreateDir,% PROGRAM.SKINS_FOLDER "\White"

if (A_IsCompiled) {
	sourceFileSize := Get_ResourceSize("resources\skins\White\ArrowRightPress.png")
	FileGetSize, destFileSize, % PROGRAM.SKINS_FOLDER "\White\ArrowRightPress.png"
}
else {
	FileGetSize, sourceFileSize, resources\skins\White\ArrowRightPress.png
	FileGetSize, destFileSize, % PROGRAM.SKINS_FOLDER "\White\ArrowRightPress.png"
}
if (sourceFileSize != destFileSize)
	FileInstall, resources\skins\White\ArrowRightPress.png, % PROGRAM.SKINS_FOLDER "\White\ArrowRightPress.png", 1
if (ErrorLevel) {
	AppendToLogs("Failed to extract file!"
	.	"`nSource: resources\skins\White\ArrowRightPress.png"
	.	"`nDest: " PROGRAM.SKINS_FOLDER "\White\ArrowRightPress.png"
	.	"`nFlag: " 2)
	errorLog .= "`n`n""Failed to extract file!"
	.	"`nSource: resources\skins\White\ArrowRightPress.png"
	.	"`nDest: " PROGRAM.SKINS_FOLDER "\White\ArrowRightPress.png"
	.	"`nFlag: " 2
}

; ----------------------------
if !InStr(FileExist(PROGRAM.SKINS_FOLDER "\White"), "D")
	FileCreateDir,% PROGRAM.SKINS_FOLDER "\White"

FileInstall, resources\skins\White\Assets.ini, % PROGRAM.SKINS_FOLDER "\White\Assets.ini", 1
if (ErrorLevel) {
	AppendToLogs("Failed to extract file!"
	.	"`nSource: resources\skins\White\Assets.ini"
	.	"`nDest: " PROGRAM.SKINS_FOLDER "\White\Assets.ini"
	.	"`nFlag: " 1)
	errorLog .= "`n`n""Failed to extract file!"
	.	"`nSource: resources\skins\White\Assets.ini"
	.	"`nDest: " PROGRAM.SKINS_FOLDER "\White\Assets.ini"
	.	"`nFlag: " 1
}

; ----------------------------
if !InStr(FileExist(PROGRAM.SKINS_FOLDER "\White"), "D")
	FileCreateDir,% PROGRAM.SKINS_FOLDER "\White"

if (A_IsCompiled) {
	sourceFileSize := Get_ResourceSize("resources\skins\White\Background.png")
	FileGetSize, destFileSize, % PROGRAM.SKINS_FOLDER "\White\Background.png"
}
else {
	FileGetSize, sourceFileSize, resources\skins\White\Background.png
	FileGetSize, destFileSize, % PROGRAM.SKINS_FOLDER "\White\Background.png"
}
if (sourceFileSize != destFileSize)
	FileInstall, resources\skins\White\Background.png, % PROGRAM.SKINS_FOLDER "\White\Background.png", 1
if (ErrorLevel) {
	AppendToLogs("Failed to extract file!"
	.	"`nSource: resources\skins\White\Background.png"
	.	"`nDest: " PROGRAM.SKINS_FOLDER "\White\Background.png"
	.	"`nFlag: " 2)
	errorLog .= "`n`n""Failed to extract file!"
	.	"`nSource: resources\skins\White\Background.png"
	.	"`nDest: " PROGRAM.SKINS_FOLDER "\White\Background.png"
	.	"`nFlag: " 2
}

; ----------------------------
if !InStr(FileExist(PROGRAM.SKINS_FOLDER "\White"), "D")
	FileCreateDir,% PROGRAM.SKINS_FOLDER "\White"

if (A_IsCompiled) {
	sourceFileSize := Get_ResourceSize("resources\skins\White\ButtonClipboard.png")
	FileGetSize, destFileSize, % PROGRAM.SKINS_FOLDER "\White\ButtonClipboard.png"
}
else {
	FileGetSize, sourceFileSize, resources\skins\White\ButtonClipboard.png
	FileGetSize, destFileSize, % PROGRAM.SKINS_FOLDER "\White\ButtonClipboard.png"
}
if (sourceFileSize != destFileSize)
	FileInstall, resources\skins\White\ButtonClipboard.png, % PROGRAM.SKINS_FOLDER "\White\ButtonClipboard.png", 1
if (ErrorLevel) {
	AppendToLogs("Failed to extract file!"
	.	"`nSource: resources\skins\White\ButtonClipboard.png"
	.	"`nDest: " PROGRAM.SKINS_FOLDER "\White\ButtonClipboard.png"
	.	"`nFlag: " 2)
	errorLog .= "`n`n""Failed to extract file!"
	.	"`nSource: resources\skins\White\ButtonClipboard.png"
	.	"`nDest: " PROGRAM.SKINS_FOLDER "\White\ButtonClipboard.png"
	.	"`nFlag: " 2
}

; ----------------------------
if !InStr(FileExist(PROGRAM.SKINS_FOLDER "\White"), "D")
	FileCreateDir,% PROGRAM.SKINS_FOLDER "\White"

if (A_IsCompiled) {
	sourceFileSize := Get_ResourceSize("resources\skins\White\ButtonClipboardHover.png")
	FileGetSize, destFileSize, % PROGRAM.SKINS_FOLDER "\White\ButtonClipboardHover.png"
}
else {
	FileGetSize, sourceFileSize, resources\skins\White\ButtonClipboardHover.png
	FileGetSize, destFileSize, % PROGRAM.SKINS_FOLDER "\White\ButtonClipboardHover.png"
}
if (sourceFileSize != destFileSize)
	FileInstall, resources\skins\White\ButtonClipboardHover.png, % PROGRAM.SKINS_FOLDER "\White\ButtonClipboardHover.png", 1
if (ErrorLevel) {
	AppendToLogs("Failed to extract file!"
	.	"`nSource: resources\skins\White\ButtonClipboardHover.png"
	.	"`nDest: " PROGRAM.SKINS_FOLDER "\White\ButtonClipboardHover.png"
	.	"`nFlag: " 2)
	errorLog .= "`n`n""Failed to extract file!"
	.	"`nSource: resources\skins\White\ButtonClipboardHover.png"
	.	"`nDest: " PROGRAM.SKINS_FOLDER "\White\ButtonClipboardHover.png"
	.	"`nFlag: " 2
}

; ----------------------------
if !InStr(FileExist(PROGRAM.SKINS_FOLDER "\White"), "D")
	FileCreateDir,% PROGRAM.SKINS_FOLDER "\White"

if (A_IsCompiled) {
	sourceFileSize := Get_ResourceSize("resources\skins\White\ButtonClipboardPress.png")
	FileGetSize, destFileSize, % PROGRAM.SKINS_FOLDER "\White\ButtonClipboardPress.png"
}
else {
	FileGetSize, sourceFileSize, resources\skins\White\ButtonClipboardPress.png
	FileGetSize, destFileSize, % PROGRAM.SKINS_FOLDER "\White\ButtonClipboardPress.png"
}
if (sourceFileSize != destFileSize)
	FileInstall, resources\skins\White\ButtonClipboardPress.png, % PROGRAM.SKINS_FOLDER "\White\ButtonClipboardPress.png", 1
if (ErrorLevel) {
	AppendToLogs("Failed to extract file!"
	.	"`nSource: resources\skins\White\ButtonClipboardPress.png"
	.	"`nDest: " PROGRAM.SKINS_FOLDER "\White\ButtonClipboardPress.png"
	.	"`nFlag: " 2)
	errorLog .= "`n`n""Failed to extract file!"
	.	"`nSource: resources\skins\White\ButtonClipboardPress.png"
	.	"`nDest: " PROGRAM.SKINS_FOLDER "\White\ButtonClipboardPress.png"
	.	"`nFlag: " 2
}

; ----------------------------
if !InStr(FileExist(PROGRAM.SKINS_FOLDER "\White"), "D")
	FileCreateDir,% PROGRAM.SKINS_FOLDER "\White"

if (A_IsCompiled) {
	sourceFileSize := Get_ResourceSize("resources\skins\White\ButtonInvite.png")
	FileGetSize, destFileSize, % PROGRAM.SKINS_FOLDER "\White\ButtonInvite.png"
}
else {
	FileGetSize, sourceFileSize, resources\skins\White\ButtonInvite.png
	FileGetSize, destFileSize, % PROGRAM.SKINS_FOLDER "\White\ButtonInvite.png"
}
if (sourceFileSize != destFileSize)
	FileInstall, resources\skins\White\ButtonInvite.png, % PROGRAM.SKINS_FOLDER "\White\ButtonInvite.png", 1
if (ErrorLevel) {
	AppendToLogs("Failed to extract file!"
	.	"`nSource: resources\skins\White\ButtonInvite.png"
	.	"`nDest: " PROGRAM.SKINS_FOLDER "\White\ButtonInvite.png"
	.	"`nFlag: " 2)
	errorLog .= "`n`n""Failed to extract file!"
	.	"`nSource: resources\skins\White\ButtonInvite.png"
	.	"`nDest: " PROGRAM.SKINS_FOLDER "\White\ButtonInvite.png"
	.	"`nFlag: " 2
}

; ----------------------------
if !InStr(FileExist(PROGRAM.SKINS_FOLDER "\White"), "D")
	FileCreateDir,% PROGRAM.SKINS_FOLDER "\White"

if (A_IsCompiled) {
	sourceFileSize := Get_ResourceSize("resources\skins\White\ButtonInviteHover.png")
	FileGetSize, destFileSize, % PROGRAM.SKINS_FOLDER "\White\ButtonInviteHover.png"
}
else {
	FileGetSize, sourceFileSize, resources\skins\White\ButtonInviteHover.png
	FileGetSize, destFileSize, % PROGRAM.SKINS_FOLDER "\White\ButtonInviteHover.png"
}
if (sourceFileSize != destFileSize)
	FileInstall, resources\skins\White\ButtonInviteHover.png, % PROGRAM.SKINS_FOLDER "\White\ButtonInviteHover.png", 1
if (ErrorLevel) {
	AppendToLogs("Failed to extract file!"
	.	"`nSource: resources\skins\White\ButtonInviteHover.png"
	.	"`nDest: " PROGRAM.SKINS_FOLDER "\White\ButtonInviteHover.png"
	.	"`nFlag: " 2)
	errorLog .= "`n`n""Failed to extract file!"
	.	"`nSource: resources\skins\White\ButtonInviteHover.png"
	.	"`nDest: " PROGRAM.SKINS_FOLDER "\White\ButtonInviteHover.png"
	.	"`nFlag: " 2
}

; ----------------------------
if !InStr(FileExist(PROGRAM.SKINS_FOLDER "\White"), "D")
	FileCreateDir,% PROGRAM.SKINS_FOLDER "\White"

if (A_IsCompiled) {
	sourceFileSize := Get_ResourceSize("resources\skins\White\ButtonInvitePress.png")
	FileGetSize, destFileSize, % PROGRAM.SKINS_FOLDER "\White\ButtonInvitePress.png"
}
else {
	FileGetSize, sourceFileSize, resources\skins\White\ButtonInvitePress.png
	FileGetSize, destFileSize, % PROGRAM.SKINS_FOLDER "\White\ButtonInvitePress.png"
}
if (sourceFileSize != destFileSize)
	FileInstall, resources\skins\White\ButtonInvitePress.png, % PROGRAM.SKINS_FOLDER "\White\ButtonInvitePress.png", 1
if (ErrorLevel) {
	AppendToLogs("Failed to extract file!"
	.	"`nSource: resources\skins\White\ButtonInvitePress.png"
	.	"`nDest: " PROGRAM.SKINS_FOLDER "\White\ButtonInvitePress.png"
	.	"`nFlag: " 2)
	errorLog .= "`n`n""Failed to extract file!"
	.	"`nSource: resources\skins\White\ButtonInvitePress.png"
	.	"`nDest: " PROGRAM.SKINS_FOLDER "\White\ButtonInvitePress.png"
	.	"`nFlag: " 2
}

; ----------------------------
if !InStr(FileExist(PROGRAM.SKINS_FOLDER "\White"), "D")
	FileCreateDir,% PROGRAM.SKINS_FOLDER "\White"

if (A_IsCompiled) {
	sourceFileSize := Get_ResourceSize("resources\skins\White\ButtonKick.png")
	FileGetSize, destFileSize, % PROGRAM.SKINS_FOLDER "\White\ButtonKick.png"
}
else {
	FileGetSize, sourceFileSize, resources\skins\White\ButtonKick.png
	FileGetSize, destFileSize, % PROGRAM.SKINS_FOLDER "\White\ButtonKick.png"
}
if (sourceFileSize != destFileSize)
	FileInstall, resources\skins\White\ButtonKick.png, % PROGRAM.SKINS_FOLDER "\White\ButtonKick.png", 1
if (ErrorLevel) {
	AppendToLogs("Failed to extract file!"
	.	"`nSource: resources\skins\White\ButtonKick.png"
	.	"`nDest: " PROGRAM.SKINS_FOLDER "\White\ButtonKick.png"
	.	"`nFlag: " 2)
	errorLog .= "`n`n""Failed to extract file!"
	.	"`nSource: resources\skins\White\ButtonKick.png"
	.	"`nDest: " PROGRAM.SKINS_FOLDER "\White\ButtonKick.png"
	.	"`nFlag: " 2
}

; ----------------------------
if !InStr(FileExist(PROGRAM.SKINS_FOLDER "\White"), "D")
	FileCreateDir,% PROGRAM.SKINS_FOLDER "\White"

if (A_IsCompiled) {
	sourceFileSize := Get_ResourceSize("resources\skins\White\ButtonKickHover.png")
	FileGetSize, destFileSize, % PROGRAM.SKINS_FOLDER "\White\ButtonKickHover.png"
}
else {
	FileGetSize, sourceFileSize, resources\skins\White\ButtonKickHover.png
	FileGetSize, destFileSize, % PROGRAM.SKINS_FOLDER "\White\ButtonKickHover.png"
}
if (sourceFileSize != destFileSize)
	FileInstall, resources\skins\White\ButtonKickHover.png, % PROGRAM.SKINS_FOLDER "\White\ButtonKickHover.png", 1
if (ErrorLevel) {
	AppendToLogs("Failed to extract file!"
	.	"`nSource: resources\skins\White\ButtonKickHover.png"
	.	"`nDest: " PROGRAM.SKINS_FOLDER "\White\ButtonKickHover.png"
	.	"`nFlag: " 2)
	errorLog .= "`n`n""Failed to extract file!"
	.	"`nSource: resources\skins\White\ButtonKickHover.png"
	.	"`nDest: " PROGRAM.SKINS_FOLDER "\White\ButtonKickHover.png"
	.	"`nFlag: " 2
}

; ----------------------------
if !InStr(FileExist(PROGRAM.SKINS_FOLDER "\White"), "D")
	FileCreateDir,% PROGRAM.SKINS_FOLDER "\White"

if (A_IsCompiled) {
	sourceFileSize := Get_ResourceSize("resources\skins\White\ButtonKickPress.png")
	FileGetSize, destFileSize, % PROGRAM.SKINS_FOLDER "\White\ButtonKickPress.png"
}
else {
	FileGetSize, sourceFileSize, resources\skins\White\ButtonKickPress.png
	FileGetSize, destFileSize, % PROGRAM.SKINS_FOLDER "\White\ButtonKickPress.png"
}
if (sourceFileSize != destFileSize)
	FileInstall, resources\skins\White\ButtonKickPress.png, % PROGRAM.SKINS_FOLDER "\White\ButtonKickPress.png", 1
if (ErrorLevel) {
	AppendToLogs("Failed to extract file!"
	.	"`nSource: resources\skins\White\ButtonKickPress.png"
	.	"`nDest: " PROGRAM.SKINS_FOLDER "\White\ButtonKickPress.png"
	.	"`nFlag: " 2)
	errorLog .= "`n`n""Failed to extract file!"
	.	"`nSource: resources\skins\White\ButtonKickPress.png"
	.	"`nDest: " PROGRAM.SKINS_FOLDER "\White\ButtonKickPress.png"
	.	"`nFlag: " 2
}

; ----------------------------
if !InStr(FileExist(PROGRAM.SKINS_FOLDER "\White"), "D")
	FileCreateDir,% PROGRAM.SKINS_FOLDER "\White"

if (A_IsCompiled) {
	sourceFileSize := Get_ResourceSize("resources\skins\White\ButtonOneThird.png")
	FileGetSize, destFileSize, % PROGRAM.SKINS_FOLDER "\White\ButtonOneThird.png"
}
else {
	FileGetSize, sourceFileSize, resources\skins\White\ButtonOneThird.png
	FileGetSize, destFileSize, % PROGRAM.SKINS_FOLDER "\White\ButtonOneThird.png"
}
if (sourceFileSize != destFileSize)
	FileInstall, resources\skins\White\ButtonOneThird.png, % PROGRAM.SKINS_FOLDER "\White\ButtonOneThird.png", 1
if (ErrorLevel) {
	AppendToLogs("Failed to extract file!"
	.	"`nSource: resources\skins\White\ButtonOneThird.png"
	.	"`nDest: " PROGRAM.SKINS_FOLDER "\White\ButtonOneThird.png"
	.	"`nFlag: " 2)
	errorLog .= "`n`n""Failed to extract file!"
	.	"`nSource: resources\skins\White\ButtonOneThird.png"
	.	"`nDest: " PROGRAM.SKINS_FOLDER "\White\ButtonOneThird.png"
	.	"`nFlag: " 2
}

; ----------------------------
if !InStr(FileExist(PROGRAM.SKINS_FOLDER "\White"), "D")
	FileCreateDir,% PROGRAM.SKINS_FOLDER "\White"

if (A_IsCompiled) {
	sourceFileSize := Get_ResourceSize("resources\skins\White\ButtonOneThirdHover.png")
	FileGetSize, destFileSize, % PROGRAM.SKINS_FOLDER "\White\ButtonOneThirdHover.png"
}
else {
	FileGetSize, sourceFileSize, resources\skins\White\ButtonOneThirdHover.png
	FileGetSize, destFileSize, % PROGRAM.SKINS_FOLDER "\White\ButtonOneThirdHover.png"
}
if (sourceFileSize != destFileSize)
	FileInstall, resources\skins\White\ButtonOneThirdHover.png, % PROGRAM.SKINS_FOLDER "\White\ButtonOneThirdHover.png", 1
if (ErrorLevel) {
	AppendToLogs("Failed to extract file!"
	.	"`nSource: resources\skins\White\ButtonOneThirdHover.png"
	.	"`nDest: " PROGRAM.SKINS_FOLDER "\White\ButtonOneThirdHover.png"
	.	"`nFlag: " 2)
	errorLog .= "`n`n""Failed to extract file!"
	.	"`nSource: resources\skins\White\ButtonOneThirdHover.png"
	.	"`nDest: " PROGRAM.SKINS_FOLDER "\White\ButtonOneThirdHover.png"
	.	"`nFlag: " 2
}

; ----------------------------
if !InStr(FileExist(PROGRAM.SKINS_FOLDER "\White"), "D")
	FileCreateDir,% PROGRAM.SKINS_FOLDER "\White"

if (A_IsCompiled) {
	sourceFileSize := Get_ResourceSize("resources\skins\White\ButtonOneThirdPress.png")
	FileGetSize, destFileSize, % PROGRAM.SKINS_FOLDER "\White\ButtonOneThirdPress.png"
}
else {
	FileGetSize, sourceFileSize, resources\skins\White\ButtonOneThirdPress.png
	FileGetSize, destFileSize, % PROGRAM.SKINS_FOLDER "\White\ButtonOneThirdPress.png"
}
if (sourceFileSize != destFileSize)
	FileInstall, resources\skins\White\ButtonOneThirdPress.png, % PROGRAM.SKINS_FOLDER "\White\ButtonOneThirdPress.png", 1
if (ErrorLevel) {
	AppendToLogs("Failed to extract file!"
	.	"`nSource: resources\skins\White\ButtonOneThirdPress.png"
	.	"`nDest: " PROGRAM.SKINS_FOLDER "\White\ButtonOneThirdPress.png"
	.	"`nFlag: " 2)
	errorLog .= "`n`n""Failed to extract file!"
	.	"`nSource: resources\skins\White\ButtonOneThirdPress.png"
	.	"`nDest: " PROGRAM.SKINS_FOLDER "\White\ButtonOneThirdPress.png"
	.	"`nFlag: " 2
}

; ----------------------------
if !InStr(FileExist(PROGRAM.SKINS_FOLDER "\White"), "D")
	FileCreateDir,% PROGRAM.SKINS_FOLDER "\White"

if (A_IsCompiled) {
	sourceFileSize := Get_ResourceSize("resources\skins\White\ButtonThreeThird.png")
	FileGetSize, destFileSize, % PROGRAM.SKINS_FOLDER "\White\ButtonThreeThird.png"
}
else {
	FileGetSize, sourceFileSize, resources\skins\White\ButtonThreeThird.png
	FileGetSize, destFileSize, % PROGRAM.SKINS_FOLDER "\White\ButtonThreeThird.png"
}
if (sourceFileSize != destFileSize)
	FileInstall, resources\skins\White\ButtonThreeThird.png, % PROGRAM.SKINS_FOLDER "\White\ButtonThreeThird.png", 1
if (ErrorLevel) {
	AppendToLogs("Failed to extract file!"
	.	"`nSource: resources\skins\White\ButtonThreeThird.png"
	.	"`nDest: " PROGRAM.SKINS_FOLDER "\White\ButtonThreeThird.png"
	.	"`nFlag: " 2)
	errorLog .= "`n`n""Failed to extract file!"
	.	"`nSource: resources\skins\White\ButtonThreeThird.png"
	.	"`nDest: " PROGRAM.SKINS_FOLDER "\White\ButtonThreeThird.png"
	.	"`nFlag: " 2
}

; ----------------------------
if !InStr(FileExist(PROGRAM.SKINS_FOLDER "\White"), "D")
	FileCreateDir,% PROGRAM.SKINS_FOLDER "\White"

if (A_IsCompiled) {
	sourceFileSize := Get_ResourceSize("resources\skins\White\ButtonThreeThirdHover.png")
	FileGetSize, destFileSize, % PROGRAM.SKINS_FOLDER "\White\ButtonThreeThirdHover.png"
}
else {
	FileGetSize, sourceFileSize, resources\skins\White\ButtonThreeThirdHover.png
	FileGetSize, destFileSize, % PROGRAM.SKINS_FOLDER "\White\ButtonThreeThirdHover.png"
}
if (sourceFileSize != destFileSize)
	FileInstall, resources\skins\White\ButtonThreeThirdHover.png, % PROGRAM.SKINS_FOLDER "\White\ButtonThreeThirdHover.png", 1
if (ErrorLevel) {
	AppendToLogs("Failed to extract file!"
	.	"`nSource: resources\skins\White\ButtonThreeThirdHover.png"
	.	"`nDest: " PROGRAM.SKINS_FOLDER "\White\ButtonThreeThirdHover.png"
	.	"`nFlag: " 2)
	errorLog .= "`n`n""Failed to extract file!"
	.	"`nSource: resources\skins\White\ButtonThreeThirdHover.png"
	.	"`nDest: " PROGRAM.SKINS_FOLDER "\White\ButtonThreeThirdHover.png"
	.	"`nFlag: " 2
}

; ----------------------------
if !InStr(FileExist(PROGRAM.SKINS_FOLDER "\White"), "D")
	FileCreateDir,% PROGRAM.SKINS_FOLDER "\White"

if (A_IsCompiled) {
	sourceFileSize := Get_ResourceSize("resources\skins\White\ButtonThreeThirdPress.png")
	FileGetSize, destFileSize, % PROGRAM.SKINS_FOLDER "\White\ButtonThreeThirdPress.png"
}
else {
	FileGetSize, sourceFileSize, resources\skins\White\ButtonThreeThirdPress.png
	FileGetSize, destFileSize, % PROGRAM.SKINS_FOLDER "\White\ButtonThreeThirdPress.png"
}
if (sourceFileSize != destFileSize)
	FileInstall, resources\skins\White\ButtonThreeThirdPress.png, % PROGRAM.SKINS_FOLDER "\White\ButtonThreeThirdPress.png", 1
if (ErrorLevel) {
	AppendToLogs("Failed to extract file!"
	.	"`nSource: resources\skins\White\ButtonThreeThirdPress.png"
	.	"`nDest: " PROGRAM.SKINS_FOLDER "\White\ButtonThreeThirdPress.png"
	.	"`nFlag: " 2)
	errorLog .= "`n`n""Failed to extract file!"
	.	"`nSource: resources\skins\White\ButtonThreeThirdPress.png"
	.	"`nDest: " PROGRAM.SKINS_FOLDER "\White\ButtonThreeThirdPress.png"
	.	"`nFlag: " 2
}

; ----------------------------
if !InStr(FileExist(PROGRAM.SKINS_FOLDER "\White"), "D")
	FileCreateDir,% PROGRAM.SKINS_FOLDER "\White"

if (A_IsCompiled) {
	sourceFileSize := Get_ResourceSize("resources\skins\White\ButtonTrade.png")
	FileGetSize, destFileSize, % PROGRAM.SKINS_FOLDER "\White\ButtonTrade.png"
}
else {
	FileGetSize, sourceFileSize, resources\skins\White\ButtonTrade.png
	FileGetSize, destFileSize, % PROGRAM.SKINS_FOLDER "\White\ButtonTrade.png"
}
if (sourceFileSize != destFileSize)
	FileInstall, resources\skins\White\ButtonTrade.png, % PROGRAM.SKINS_FOLDER "\White\ButtonTrade.png", 1
if (ErrorLevel) {
	AppendToLogs("Failed to extract file!"
	.	"`nSource: resources\skins\White\ButtonTrade.png"
	.	"`nDest: " PROGRAM.SKINS_FOLDER "\White\ButtonTrade.png"
	.	"`nFlag: " 2)
	errorLog .= "`n`n""Failed to extract file!"
	.	"`nSource: resources\skins\White\ButtonTrade.png"
	.	"`nDest: " PROGRAM.SKINS_FOLDER "\White\ButtonTrade.png"
	.	"`nFlag: " 2
}

; ----------------------------
if !InStr(FileExist(PROGRAM.SKINS_FOLDER "\White"), "D")
	FileCreateDir,% PROGRAM.SKINS_FOLDER "\White"

if (A_IsCompiled) {
	sourceFileSize := Get_ResourceSize("resources\skins\White\ButtonTradeHover.png")
	FileGetSize, destFileSize, % PROGRAM.SKINS_FOLDER "\White\ButtonTradeHover.png"
}
else {
	FileGetSize, sourceFileSize, resources\skins\White\ButtonTradeHover.png
	FileGetSize, destFileSize, % PROGRAM.SKINS_FOLDER "\White\ButtonTradeHover.png"
}
if (sourceFileSize != destFileSize)
	FileInstall, resources\skins\White\ButtonTradeHover.png, % PROGRAM.SKINS_FOLDER "\White\ButtonTradeHover.png", 1
if (ErrorLevel) {
	AppendToLogs("Failed to extract file!"
	.	"`nSource: resources\skins\White\ButtonTradeHover.png"
	.	"`nDest: " PROGRAM.SKINS_FOLDER "\White\ButtonTradeHover.png"
	.	"`nFlag: " 2)
	errorLog .= "`n`n""Failed to extract file!"
	.	"`nSource: resources\skins\White\ButtonTradeHover.png"
	.	"`nDest: " PROGRAM.SKINS_FOLDER "\White\ButtonTradeHover.png"
	.	"`nFlag: " 2
}

; ----------------------------
if !InStr(FileExist(PROGRAM.SKINS_FOLDER "\White"), "D")
	FileCreateDir,% PROGRAM.SKINS_FOLDER "\White"

if (A_IsCompiled) {
	sourceFileSize := Get_ResourceSize("resources\skins\White\ButtonTradePress.png")
	FileGetSize, destFileSize, % PROGRAM.SKINS_FOLDER "\White\ButtonTradePress.png"
}
else {
	FileGetSize, sourceFileSize, resources\skins\White\ButtonTradePress.png
	FileGetSize, destFileSize, % PROGRAM.SKINS_FOLDER "\White\ButtonTradePress.png"
}
if (sourceFileSize != destFileSize)
	FileInstall, resources\skins\White\ButtonTradePress.png, % PROGRAM.SKINS_FOLDER "\White\ButtonTradePress.png", 1
if (ErrorLevel) {
	AppendToLogs("Failed to extract file!"
	.	"`nSource: resources\skins\White\ButtonTradePress.png"
	.	"`nDest: " PROGRAM.SKINS_FOLDER "\White\ButtonTradePress.png"
	.	"`nFlag: " 2)
	errorLog .= "`n`n""Failed to extract file!"
	.	"`nSource: resources\skins\White\ButtonTradePress.png"
	.	"`nDest: " PROGRAM.SKINS_FOLDER "\White\ButtonTradePress.png"
	.	"`nFlag: " 2
}

; ----------------------------
if !InStr(FileExist(PROGRAM.SKINS_FOLDER "\White"), "D")
	FileCreateDir,% PROGRAM.SKINS_FOLDER "\White"

if (A_IsCompiled) {
	sourceFileSize := Get_ResourceSize("resources\skins\White\ButtonTwoThird.png")
	FileGetSize, destFileSize, % PROGRAM.SKINS_FOLDER "\White\ButtonTwoThird.png"
}
else {
	FileGetSize, sourceFileSize, resources\skins\White\ButtonTwoThird.png
	FileGetSize, destFileSize, % PROGRAM.SKINS_FOLDER "\White\ButtonTwoThird.png"
}
if (sourceFileSize != destFileSize)
	FileInstall, resources\skins\White\ButtonTwoThird.png, % PROGRAM.SKINS_FOLDER "\White\ButtonTwoThird.png", 1
if (ErrorLevel) {
	AppendToLogs("Failed to extract file!"
	.	"`nSource: resources\skins\White\ButtonTwoThird.png"
	.	"`nDest: " PROGRAM.SKINS_FOLDER "\White\ButtonTwoThird.png"
	.	"`nFlag: " 2)
	errorLog .= "`n`n""Failed to extract file!"
	.	"`nSource: resources\skins\White\ButtonTwoThird.png"
	.	"`nDest: " PROGRAM.SKINS_FOLDER "\White\ButtonTwoThird.png"
	.	"`nFlag: " 2
}

; ----------------------------
if !InStr(FileExist(PROGRAM.SKINS_FOLDER "\White"), "D")
	FileCreateDir,% PROGRAM.SKINS_FOLDER "\White"

if (A_IsCompiled) {
	sourceFileSize := Get_ResourceSize("resources\skins\White\ButtonTwoThirdHover.png")
	FileGetSize, destFileSize, % PROGRAM.SKINS_FOLDER "\White\ButtonTwoThirdHover.png"
}
else {
	FileGetSize, sourceFileSize, resources\skins\White\ButtonTwoThirdHover.png
	FileGetSize, destFileSize, % PROGRAM.SKINS_FOLDER "\White\ButtonTwoThirdHover.png"
}
if (sourceFileSize != destFileSize)
	FileInstall, resources\skins\White\ButtonTwoThirdHover.png, % PROGRAM.SKINS_FOLDER "\White\ButtonTwoThirdHover.png", 1
if (ErrorLevel) {
	AppendToLogs("Failed to extract file!"
	.	"`nSource: resources\skins\White\ButtonTwoThirdHover.png"
	.	"`nDest: " PROGRAM.SKINS_FOLDER "\White\ButtonTwoThirdHover.png"
	.	"`nFlag: " 2)
	errorLog .= "`n`n""Failed to extract file!"
	.	"`nSource: resources\skins\White\ButtonTwoThirdHover.png"
	.	"`nDest: " PROGRAM.SKINS_FOLDER "\White\ButtonTwoThirdHover.png"
	.	"`nFlag: " 2
}

; ----------------------------
if !InStr(FileExist(PROGRAM.SKINS_FOLDER "\White"), "D")
	FileCreateDir,% PROGRAM.SKINS_FOLDER "\White"

if (A_IsCompiled) {
	sourceFileSize := Get_ResourceSize("resources\skins\White\ButtonTwoThirdPress.png")
	FileGetSize, destFileSize, % PROGRAM.SKINS_FOLDER "\White\ButtonTwoThirdPress.png"
}
else {
	FileGetSize, sourceFileSize, resources\skins\White\ButtonTwoThirdPress.png
	FileGetSize, destFileSize, % PROGRAM.SKINS_FOLDER "\White\ButtonTwoThirdPress.png"
}
if (sourceFileSize != destFileSize)
	FileInstall, resources\skins\White\ButtonTwoThirdPress.png, % PROGRAM.SKINS_FOLDER "\White\ButtonTwoThirdPress.png", 1
if (ErrorLevel) {
	AppendToLogs("Failed to extract file!"
	.	"`nSource: resources\skins\White\ButtonTwoThirdPress.png"
	.	"`nDest: " PROGRAM.SKINS_FOLDER "\White\ButtonTwoThirdPress.png"
	.	"`nFlag: " 2)
	errorLog .= "`n`n""Failed to extract file!"
	.	"`nSource: resources\skins\White\ButtonTwoThirdPress.png"
	.	"`nDest: " PROGRAM.SKINS_FOLDER "\White\ButtonTwoThirdPress.png"
	.	"`nFlag: " 2
}

; ----------------------------
if !InStr(FileExist(PROGRAM.SKINS_FOLDER "\White"), "D")
	FileCreateDir,% PROGRAM.SKINS_FOLDER "\White"

if (A_IsCompiled) {
	sourceFileSize := Get_ResourceSize("resources\skins\White\ButtonWhisper.png")
	FileGetSize, destFileSize, % PROGRAM.SKINS_FOLDER "\White\ButtonWhisper.png"
}
else {
	FileGetSize, sourceFileSize, resources\skins\White\ButtonWhisper.png
	FileGetSize, destFileSize, % PROGRAM.SKINS_FOLDER "\White\ButtonWhisper.png"
}
if (sourceFileSize != destFileSize)
	FileInstall, resources\skins\White\ButtonWhisper.png, % PROGRAM.SKINS_FOLDER "\White\ButtonWhisper.png", 1
if (ErrorLevel) {
	AppendToLogs("Failed to extract file!"
	.	"`nSource: resources\skins\White\ButtonWhisper.png"
	.	"`nDest: " PROGRAM.SKINS_FOLDER "\White\ButtonWhisper.png"
	.	"`nFlag: " 2)
	errorLog .= "`n`n""Failed to extract file!"
	.	"`nSource: resources\skins\White\ButtonWhisper.png"
	.	"`nDest: " PROGRAM.SKINS_FOLDER "\White\ButtonWhisper.png"
	.	"`nFlag: " 2
}

; ----------------------------
if !InStr(FileExist(PROGRAM.SKINS_FOLDER "\White"), "D")
	FileCreateDir,% PROGRAM.SKINS_FOLDER "\White"

if (A_IsCompiled) {
	sourceFileSize := Get_ResourceSize("resources\skins\White\ButtonWhisperHover.png")
	FileGetSize, destFileSize, % PROGRAM.SKINS_FOLDER "\White\ButtonWhisperHover.png"
}
else {
	FileGetSize, sourceFileSize, resources\skins\White\ButtonWhisperHover.png
	FileGetSize, destFileSize, % PROGRAM.SKINS_FOLDER "\White\ButtonWhisperHover.png"
}
if (sourceFileSize != destFileSize)
	FileInstall, resources\skins\White\ButtonWhisperHover.png, % PROGRAM.SKINS_FOLDER "\White\ButtonWhisperHover.png", 1
if (ErrorLevel) {
	AppendToLogs("Failed to extract file!"
	.	"`nSource: resources\skins\White\ButtonWhisperHover.png"
	.	"`nDest: " PROGRAM.SKINS_FOLDER "\White\ButtonWhisperHover.png"
	.	"`nFlag: " 2)
	errorLog .= "`n`n""Failed to extract file!"
	.	"`nSource: resources\skins\White\ButtonWhisperHover.png"
	.	"`nDest: " PROGRAM.SKINS_FOLDER "\White\ButtonWhisperHover.png"
	.	"`nFlag: " 2
}

; ----------------------------
if !InStr(FileExist(PROGRAM.SKINS_FOLDER "\White"), "D")
	FileCreateDir,% PROGRAM.SKINS_FOLDER "\White"

if (A_IsCompiled) {
	sourceFileSize := Get_ResourceSize("resources\skins\White\ButtonWhisperPress.png")
	FileGetSize, destFileSize, % PROGRAM.SKINS_FOLDER "\White\ButtonWhisperPress.png"
}
else {
	FileGetSize, sourceFileSize, resources\skins\White\ButtonWhisperPress.png
	FileGetSize, destFileSize, % PROGRAM.SKINS_FOLDER "\White\ButtonWhisperPress.png"
}
if (sourceFileSize != destFileSize)
	FileInstall, resources\skins\White\ButtonWhisperPress.png, % PROGRAM.SKINS_FOLDER "\White\ButtonWhisperPress.png", 1
if (ErrorLevel) {
	AppendToLogs("Failed to extract file!"
	.	"`nSource: resources\skins\White\ButtonWhisperPress.png"
	.	"`nDest: " PROGRAM.SKINS_FOLDER "\White\ButtonWhisperPress.png"
	.	"`nFlag: " 2)
	errorLog .= "`n`n""Failed to extract file!"
	.	"`nSource: resources\skins\White\ButtonWhisperPress.png"
	.	"`nDest: " PROGRAM.SKINS_FOLDER "\White\ButtonWhisperPress.png"
	.	"`nFlag: " 2
}

; ----------------------------
if !InStr(FileExist(PROGRAM.SKINS_FOLDER "\White"), "D")
	FileCreateDir,% PROGRAM.SKINS_FOLDER "\White"

if (A_IsCompiled) {
	sourceFileSize := Get_ResourceSize("resources\skins\White\CloseTab.png")
	FileGetSize, destFileSize, % PROGRAM.SKINS_FOLDER "\White\CloseTab.png"
}
else {
	FileGetSize, sourceFileSize, resources\skins\White\CloseTab.png
	FileGetSize, destFileSize, % PROGRAM.SKINS_FOLDER "\White\CloseTab.png"
}
if (sourceFileSize != destFileSize)
	FileInstall, resources\skins\White\CloseTab.png, % PROGRAM.SKINS_FOLDER "\White\CloseTab.png", 1
if (ErrorLevel) {
	AppendToLogs("Failed to extract file!"
	.	"`nSource: resources\skins\White\CloseTab.png"
	.	"`nDest: " PROGRAM.SKINS_FOLDER "\White\CloseTab.png"
	.	"`nFlag: " 2)
	errorLog .= "`n`n""Failed to extract file!"
	.	"`nSource: resources\skins\White\CloseTab.png"
	.	"`nDest: " PROGRAM.SKINS_FOLDER "\White\CloseTab.png"
	.	"`nFlag: " 2
}

; ----------------------------
if !InStr(FileExist(PROGRAM.SKINS_FOLDER "\White"), "D")
	FileCreateDir,% PROGRAM.SKINS_FOLDER "\White"

if (A_IsCompiled) {
	sourceFileSize := Get_ResourceSize("resources\skins\White\CloseTabHover.png")
	FileGetSize, destFileSize, % PROGRAM.SKINS_FOLDER "\White\CloseTabHover.png"
}
else {
	FileGetSize, sourceFileSize, resources\skins\White\CloseTabHover.png
	FileGetSize, destFileSize, % PROGRAM.SKINS_FOLDER "\White\CloseTabHover.png"
}
if (sourceFileSize != destFileSize)
	FileInstall, resources\skins\White\CloseTabHover.png, % PROGRAM.SKINS_FOLDER "\White\CloseTabHover.png", 1
if (ErrorLevel) {
	AppendToLogs("Failed to extract file!"
	.	"`nSource: resources\skins\White\CloseTabHover.png"
	.	"`nDest: " PROGRAM.SKINS_FOLDER "\White\CloseTabHover.png"
	.	"`nFlag: " 2)
	errorLog .= "`n`n""Failed to extract file!"
	.	"`nSource: resources\skins\White\CloseTabHover.png"
	.	"`nDest: " PROGRAM.SKINS_FOLDER "\White\CloseTabHover.png"
	.	"`nFlag: " 2
}

; ----------------------------
if !InStr(FileExist(PROGRAM.SKINS_FOLDER "\White"), "D")
	FileCreateDir,% PROGRAM.SKINS_FOLDER "\White"

if (A_IsCompiled) {
	sourceFileSize := Get_ResourceSize("resources\skins\White\CloseTabPress.png")
	FileGetSize, destFileSize, % PROGRAM.SKINS_FOLDER "\White\CloseTabPress.png"
}
else {
	FileGetSize, sourceFileSize, resources\skins\White\CloseTabPress.png
	FileGetSize, destFileSize, % PROGRAM.SKINS_FOLDER "\White\CloseTabPress.png"
}
if (sourceFileSize != destFileSize)
	FileInstall, resources\skins\White\CloseTabPress.png, % PROGRAM.SKINS_FOLDER "\White\CloseTabPress.png", 1
if (ErrorLevel) {
	AppendToLogs("Failed to extract file!"
	.	"`nSource: resources\skins\White\CloseTabPress.png"
	.	"`nDest: " PROGRAM.SKINS_FOLDER "\White\CloseTabPress.png"
	.	"`nFlag: " 2)
	errorLog .= "`n`n""Failed to extract file!"
	.	"`nSource: resources\skins\White\CloseTabPress.png"
	.	"`nDest: " PROGRAM.SKINS_FOLDER "\White\CloseTabPress.png"
	.	"`nFlag: " 2
}

; ----------------------------
if !InStr(FileExist(PROGRAM.SKINS_FOLDER "\White"), "D")
	FileCreateDir,% PROGRAM.SKINS_FOLDER "\White"

if (A_IsCompiled) {
	sourceFileSize := Get_ResourceSize("resources\skins\White\Header.png")
	FileGetSize, destFileSize, % PROGRAM.SKINS_FOLDER "\White\Header.png"
}
else {
	FileGetSize, sourceFileSize, resources\skins\White\Header.png
	FileGetSize, destFileSize, % PROGRAM.SKINS_FOLDER "\White\Header.png"
}
if (sourceFileSize != destFileSize)
	FileInstall, resources\skins\White\Header.png, % PROGRAM.SKINS_FOLDER "\White\Header.png", 1
if (ErrorLevel) {
	AppendToLogs("Failed to extract file!"
	.	"`nSource: resources\skins\White\Header.png"
	.	"`nDest: " PROGRAM.SKINS_FOLDER "\White\Header.png"
	.	"`nFlag: " 2)
	errorLog .= "`n`n""Failed to extract file!"
	.	"`nSource: resources\skins\White\Header.png"
	.	"`nDest: " PROGRAM.SKINS_FOLDER "\White\Header.png"
	.	"`nFlag: " 2
}

; ----------------------------
if !InStr(FileExist(PROGRAM.SKINS_FOLDER "\White"), "D")
	FileCreateDir,% PROGRAM.SKINS_FOLDER "\White"

if (A_IsCompiled) {
	sourceFileSize := Get_ResourceSize("resources\skins\White\HeaderMin.png")
	FileGetSize, destFileSize, % PROGRAM.SKINS_FOLDER "\White\HeaderMin.png"
}
else {
	FileGetSize, sourceFileSize, resources\skins\White\HeaderMin.png
	FileGetSize, destFileSize, % PROGRAM.SKINS_FOLDER "\White\HeaderMin.png"
}
if (sourceFileSize != destFileSize)
	FileInstall, resources\skins\White\HeaderMin.png, % PROGRAM.SKINS_FOLDER "\White\HeaderMin.png", 1
if (ErrorLevel) {
	AppendToLogs("Failed to extract file!"
	.	"`nSource: resources\skins\White\HeaderMin.png"
	.	"`nDest: " PROGRAM.SKINS_FOLDER "\White\HeaderMin.png"
	.	"`nFlag: " 2)
	errorLog .= "`n`n""Failed to extract file!"
	.	"`nSource: resources\skins\White\HeaderMin.png"
	.	"`nDest: " PROGRAM.SKINS_FOLDER "\White\HeaderMin.png"
	.	"`nFlag: " 2
}

; ----------------------------
if !InStr(FileExist(PROGRAM.SKINS_FOLDER "\White"), "D")
	FileCreateDir,% PROGRAM.SKINS_FOLDER "\White"

if (A_IsCompiled) {
	sourceFileSize := Get_ResourceSize("resources\skins\White\Icon.ico")
	FileGetSize, destFileSize, % PROGRAM.SKINS_FOLDER "\White\Icon.ico"
}
else {
	FileGetSize, sourceFileSize, resources\skins\White\Icon.ico
	FileGetSize, destFileSize, % PROGRAM.SKINS_FOLDER "\White\Icon.ico"
}
if (sourceFileSize != destFileSize)
	FileInstall, resources\skins\White\Icon.ico, % PROGRAM.SKINS_FOLDER "\White\Icon.ico", 1
if (ErrorLevel) {
	AppendToLogs("Failed to extract file!"
	.	"`nSource: resources\skins\White\Icon.ico"
	.	"`nDest: " PROGRAM.SKINS_FOLDER "\White\Icon.ico"
	.	"`nFlag: " 2)
	errorLog .= "`n`n""Failed to extract file!"
	.	"`nSource: resources\skins\White\Icon.ico"
	.	"`nDest: " PROGRAM.SKINS_FOLDER "\White\Icon.ico"
	.	"`nFlag: " 2
}

; ----------------------------
if !InStr(FileExist(PROGRAM.SKINS_FOLDER "\White"), "D")
	FileCreateDir,% PROGRAM.SKINS_FOLDER "\White"

if (A_IsCompiled) {
	sourceFileSize := Get_ResourceSize("resources\skins\White\Maximize.png")
	FileGetSize, destFileSize, % PROGRAM.SKINS_FOLDER "\White\Maximize.png"
}
else {
	FileGetSize, sourceFileSize, resources\skins\White\Maximize.png
	FileGetSize, destFileSize, % PROGRAM.SKINS_FOLDER "\White\Maximize.png"
}
if (sourceFileSize != destFileSize)
	FileInstall, resources\skins\White\Maximize.png, % PROGRAM.SKINS_FOLDER "\White\Maximize.png", 1
if (ErrorLevel) {
	AppendToLogs("Failed to extract file!"
	.	"`nSource: resources\skins\White\Maximize.png"
	.	"`nDest: " PROGRAM.SKINS_FOLDER "\White\Maximize.png"
	.	"`nFlag: " 2)
	errorLog .= "`n`n""Failed to extract file!"
	.	"`nSource: resources\skins\White\Maximize.png"
	.	"`nDest: " PROGRAM.SKINS_FOLDER "\White\Maximize.png"
	.	"`nFlag: " 2
}

; ----------------------------
if !InStr(FileExist(PROGRAM.SKINS_FOLDER "\White"), "D")
	FileCreateDir,% PROGRAM.SKINS_FOLDER "\White"

if (A_IsCompiled) {
	sourceFileSize := Get_ResourceSize("resources\skins\White\MaximizeHover.png")
	FileGetSize, destFileSize, % PROGRAM.SKINS_FOLDER "\White\MaximizeHover.png"
}
else {
	FileGetSize, sourceFileSize, resources\skins\White\MaximizeHover.png
	FileGetSize, destFileSize, % PROGRAM.SKINS_FOLDER "\White\MaximizeHover.png"
}
if (sourceFileSize != destFileSize)
	FileInstall, resources\skins\White\MaximizeHover.png, % PROGRAM.SKINS_FOLDER "\White\MaximizeHover.png", 1
if (ErrorLevel) {
	AppendToLogs("Failed to extract file!"
	.	"`nSource: resources\skins\White\MaximizeHover.png"
	.	"`nDest: " PROGRAM.SKINS_FOLDER "\White\MaximizeHover.png"
	.	"`nFlag: " 2)
	errorLog .= "`n`n""Failed to extract file!"
	.	"`nSource: resources\skins\White\MaximizeHover.png"
	.	"`nDest: " PROGRAM.SKINS_FOLDER "\White\MaximizeHover.png"
	.	"`nFlag: " 2
}

; ----------------------------
if !InStr(FileExist(PROGRAM.SKINS_FOLDER "\White"), "D")
	FileCreateDir,% PROGRAM.SKINS_FOLDER "\White"

if (A_IsCompiled) {
	sourceFileSize := Get_ResourceSize("resources\skins\White\MaximizePress.png")
	FileGetSize, destFileSize, % PROGRAM.SKINS_FOLDER "\White\MaximizePress.png"
}
else {
	FileGetSize, sourceFileSize, resources\skins\White\MaximizePress.png
	FileGetSize, destFileSize, % PROGRAM.SKINS_FOLDER "\White\MaximizePress.png"
}
if (sourceFileSize != destFileSize)
	FileInstall, resources\skins\White\MaximizePress.png, % PROGRAM.SKINS_FOLDER "\White\MaximizePress.png", 1
if (ErrorLevel) {
	AppendToLogs("Failed to extract file!"
	.	"`nSource: resources\skins\White\MaximizePress.png"
	.	"`nDest: " PROGRAM.SKINS_FOLDER "\White\MaximizePress.png"
	.	"`nFlag: " 2)
	errorLog .= "`n`n""Failed to extract file!"
	.	"`nSource: resources\skins\White\MaximizePress.png"
	.	"`nDest: " PROGRAM.SKINS_FOLDER "\White\MaximizePress.png"
	.	"`nFlag: " 2
}

; ----------------------------
if !InStr(FileExist(PROGRAM.SKINS_FOLDER "\White"), "D")
	FileCreateDir,% PROGRAM.SKINS_FOLDER "\White"

if (A_IsCompiled) {
	sourceFileSize := Get_ResourceSize("resources\skins\White\Minimize.png")
	FileGetSize, destFileSize, % PROGRAM.SKINS_FOLDER "\White\Minimize.png"
}
else {
	FileGetSize, sourceFileSize, resources\skins\White\Minimize.png
	FileGetSize, destFileSize, % PROGRAM.SKINS_FOLDER "\White\Minimize.png"
}
if (sourceFileSize != destFileSize)
	FileInstall, resources\skins\White\Minimize.png, % PROGRAM.SKINS_FOLDER "\White\Minimize.png", 1
if (ErrorLevel) {
	AppendToLogs("Failed to extract file!"
	.	"`nSource: resources\skins\White\Minimize.png"
	.	"`nDest: " PROGRAM.SKINS_FOLDER "\White\Minimize.png"
	.	"`nFlag: " 2)
	errorLog .= "`n`n""Failed to extract file!"
	.	"`nSource: resources\skins\White\Minimize.png"
	.	"`nDest: " PROGRAM.SKINS_FOLDER "\White\Minimize.png"
	.	"`nFlag: " 2
}

; ----------------------------
if !InStr(FileExist(PROGRAM.SKINS_FOLDER "\White"), "D")
	FileCreateDir,% PROGRAM.SKINS_FOLDER "\White"

if (A_IsCompiled) {
	sourceFileSize := Get_ResourceSize("resources\skins\White\MinimizeHover.png")
	FileGetSize, destFileSize, % PROGRAM.SKINS_FOLDER "\White\MinimizeHover.png"
}
else {
	FileGetSize, sourceFileSize, resources\skins\White\MinimizeHover.png
	FileGetSize, destFileSize, % PROGRAM.SKINS_FOLDER "\White\MinimizeHover.png"
}
if (sourceFileSize != destFileSize)
	FileInstall, resources\skins\White\MinimizeHover.png, % PROGRAM.SKINS_FOLDER "\White\MinimizeHover.png", 1
if (ErrorLevel) {
	AppendToLogs("Failed to extract file!"
	.	"`nSource: resources\skins\White\MinimizeHover.png"
	.	"`nDest: " PROGRAM.SKINS_FOLDER "\White\MinimizeHover.png"
	.	"`nFlag: " 2)
	errorLog .= "`n`n""Failed to extract file!"
	.	"`nSource: resources\skins\White\MinimizeHover.png"
	.	"`nDest: " PROGRAM.SKINS_FOLDER "\White\MinimizeHover.png"
	.	"`nFlag: " 2
}

; ----------------------------
if !InStr(FileExist(PROGRAM.SKINS_FOLDER "\White"), "D")
	FileCreateDir,% PROGRAM.SKINS_FOLDER "\White"

if (A_IsCompiled) {
	sourceFileSize := Get_ResourceSize("resources\skins\White\MinimizePress.png")
	FileGetSize, destFileSize, % PROGRAM.SKINS_FOLDER "\White\MinimizePress.png"
}
else {
	FileGetSize, sourceFileSize, resources\skins\White\MinimizePress.png
	FileGetSize, destFileSize, % PROGRAM.SKINS_FOLDER "\White\MinimizePress.png"
}
if (sourceFileSize != destFileSize)
	FileInstall, resources\skins\White\MinimizePress.png, % PROGRAM.SKINS_FOLDER "\White\MinimizePress.png", 1
if (ErrorLevel) {
	AppendToLogs("Failed to extract file!"
	.	"`nSource: resources\skins\White\MinimizePress.png"
	.	"`nDest: " PROGRAM.SKINS_FOLDER "\White\MinimizePress.png"
	.	"`nFlag: " 2)
	errorLog .= "`n`n""Failed to extract file!"
	.	"`nSource: resources\skins\White\MinimizePress.png"
	.	"`nDest: " PROGRAM.SKINS_FOLDER "\White\MinimizePress.png"
	.	"`nFlag: " 2
}

; ----------------------------
if !InStr(FileExist(PROGRAM.SKINS_FOLDER "\White"), "D")
	FileCreateDir,% PROGRAM.SKINS_FOLDER "\White"

if (A_IsCompiled) {
	sourceFileSize := Get_ResourceSize("resources\skins\White\Preview.png")
	FileGetSize, destFileSize, % PROGRAM.SKINS_FOLDER "\White\Preview.png"
}
else {
	FileGetSize, sourceFileSize, resources\skins\White\Preview.png
	FileGetSize, destFileSize, % PROGRAM.SKINS_FOLDER "\White\Preview.png"
}
if (sourceFileSize != destFileSize)
	FileInstall, resources\skins\White\Preview.png, % PROGRAM.SKINS_FOLDER "\White\Preview.png", 1
if (ErrorLevel) {
	AppendToLogs("Failed to extract file!"
	.	"`nSource: resources\skins\White\Preview.png"
	.	"`nDest: " PROGRAM.SKINS_FOLDER "\White\Preview.png"
	.	"`nFlag: " 2)
	errorLog .= "`n`n""Failed to extract file!"
	.	"`nSource: resources\skins\White\Preview.png"
	.	"`nDest: " PROGRAM.SKINS_FOLDER "\White\Preview.png"
	.	"`nFlag: " 2
}

; ----------------------------
if !InStr(FileExist(PROGRAM.SKINS_FOLDER "\White"), "D")
	FileCreateDir,% PROGRAM.SKINS_FOLDER "\White"

FileInstall, resources\skins\White\Settings.ini, % PROGRAM.SKINS_FOLDER "\White\Settings.ini", 1
if (ErrorLevel) {
	AppendToLogs("Failed to extract file!"
	.	"`nSource: resources\skins\White\Settings.ini"
	.	"`nDest: " PROGRAM.SKINS_FOLDER "\White\Settings.ini"
	.	"`nFlag: " 1)
	errorLog .= "`n`n""Failed to extract file!"
	.	"`nSource: resources\skins\White\Settings.ini"
	.	"`nDest: " PROGRAM.SKINS_FOLDER "\White\Settings.ini"
	.	"`nFlag: " 1
}

; ----------------------------
if !InStr(FileExist(PROGRAM.SKINS_FOLDER "\White"), "D")
	FileCreateDir,% PROGRAM.SKINS_FOLDER "\White"

if (A_IsCompiled) {
	sourceFileSize := Get_ResourceSize("resources\skins\White\TabActive.png")
	FileGetSize, destFileSize, % PROGRAM.SKINS_FOLDER "\White\TabActive.png"
}
else {
	FileGetSize, sourceFileSize, resources\skins\White\TabActive.png
	FileGetSize, destFileSize, % PROGRAM.SKINS_FOLDER "\White\TabActive.png"
}
if (sourceFileSize != destFileSize)
	FileInstall, resources\skins\White\TabActive.png, % PROGRAM.SKINS_FOLDER "\White\TabActive.png", 1
if (ErrorLevel) {
	AppendToLogs("Failed to extract file!"
	.	"`nSource: resources\skins\White\TabActive.png"
	.	"`nDest: " PROGRAM.SKINS_FOLDER "\White\TabActive.png"
	.	"`nFlag: " 2)
	errorLog .= "`n`n""Failed to extract file!"
	.	"`nSource: resources\skins\White\TabActive.png"
	.	"`nDest: " PROGRAM.SKINS_FOLDER "\White\TabActive.png"
	.	"`nFlag: " 2
}

; ----------------------------
if !InStr(FileExist(PROGRAM.SKINS_FOLDER "\White"), "D")
	FileCreateDir,% PROGRAM.SKINS_FOLDER "\White"

if (A_IsCompiled) {
	sourceFileSize := Get_ResourceSize("resources\skins\White\TabHover.png")
	FileGetSize, destFileSize, % PROGRAM.SKINS_FOLDER "\White\TabHover.png"
}
else {
	FileGetSize, sourceFileSize, resources\skins\White\TabHover.png
	FileGetSize, destFileSize, % PROGRAM.SKINS_FOLDER "\White\TabHover.png"
}
if (sourceFileSize != destFileSize)
	FileInstall, resources\skins\White\TabHover.png, % PROGRAM.SKINS_FOLDER "\White\TabHover.png", 1
if (ErrorLevel) {
	AppendToLogs("Failed to extract file!"
	.	"`nSource: resources\skins\White\TabHover.png"
	.	"`nDest: " PROGRAM.SKINS_FOLDER "\White\TabHover.png"
	.	"`nFlag: " 2)
	errorLog .= "`n`n""Failed to extract file!"
	.	"`nSource: resources\skins\White\TabHover.png"
	.	"`nDest: " PROGRAM.SKINS_FOLDER "\White\TabHover.png"
	.	"`nFlag: " 2
}

; ----------------------------
if !InStr(FileExist(PROGRAM.SKINS_FOLDER "\White"), "D")
	FileCreateDir,% PROGRAM.SKINS_FOLDER "\White"

if (A_IsCompiled) {
	sourceFileSize := Get_ResourceSize("resources\skins\White\TabInactive.png")
	FileGetSize, destFileSize, % PROGRAM.SKINS_FOLDER "\White\TabInactive.png"
}
else {
	FileGetSize, sourceFileSize, resources\skins\White\TabInactive.png
	FileGetSize, destFileSize, % PROGRAM.SKINS_FOLDER "\White\TabInactive.png"
}
if (sourceFileSize != destFileSize)
	FileInstall, resources\skins\White\TabInactive.png, % PROGRAM.SKINS_FOLDER "\White\TabInactive.png", 1
if (ErrorLevel) {
	AppendToLogs("Failed to extract file!"
	.	"`nSource: resources\skins\White\TabInactive.png"
	.	"`nDest: " PROGRAM.SKINS_FOLDER "\White\TabInactive.png"
	.	"`nFlag: " 2)
	errorLog .= "`n`n""Failed to extract file!"
	.	"`nSource: resources\skins\White\TabInactive.png"
	.	"`nDest: " PROGRAM.SKINS_FOLDER "\White\TabInactive.png"
	.	"`nFlag: " 2
}

; ----------------------------
if !InStr(FileExist(PROGRAM.SKINS_FOLDER "\White"), "D")
	FileCreateDir,% PROGRAM.SKINS_FOLDER "\White"

if (A_IsCompiled) {
	sourceFileSize := Get_ResourceSize("resources\skins\White\TabJoinedActive.png")
	FileGetSize, destFileSize, % PROGRAM.SKINS_FOLDER "\White\TabJoinedActive.png"
}
else {
	FileGetSize, sourceFileSize, resources\skins\White\TabJoinedActive.png
	FileGetSize, destFileSize, % PROGRAM.SKINS_FOLDER "\White\TabJoinedActive.png"
}
if (sourceFileSize != destFileSize)
	FileInstall, resources\skins\White\TabJoinedActive.png, % PROGRAM.SKINS_FOLDER "\White\TabJoinedActive.png", 1
if (ErrorLevel) {
	AppendToLogs("Failed to extract file!"
	.	"`nSource: resources\skins\White\TabJoinedActive.png"
	.	"`nDest: " PROGRAM.SKINS_FOLDER "\White\TabJoinedActive.png"
	.	"`nFlag: " 2)
	errorLog .= "`n`n""Failed to extract file!"
	.	"`nSource: resources\skins\White\TabJoinedActive.png"
	.	"`nDest: " PROGRAM.SKINS_FOLDER "\White\TabJoinedActive.png"
	.	"`nFlag: " 2
}

; ----------------------------
if !InStr(FileExist(PROGRAM.SKINS_FOLDER "\White"), "D")
	FileCreateDir,% PROGRAM.SKINS_FOLDER "\White"

if (A_IsCompiled) {
	sourceFileSize := Get_ResourceSize("resources\skins\White\TabJoinedHover.png")
	FileGetSize, destFileSize, % PROGRAM.SKINS_FOLDER "\White\TabJoinedHover.png"
}
else {
	FileGetSize, sourceFileSize, resources\skins\White\TabJoinedHover.png
	FileGetSize, destFileSize, % PROGRAM.SKINS_FOLDER "\White\TabJoinedHover.png"
}
if (sourceFileSize != destFileSize)
	FileInstall, resources\skins\White\TabJoinedHover.png, % PROGRAM.SKINS_FOLDER "\White\TabJoinedHover.png", 1
if (ErrorLevel) {
	AppendToLogs("Failed to extract file!"
	.	"`nSource: resources\skins\White\TabJoinedHover.png"
	.	"`nDest: " PROGRAM.SKINS_FOLDER "\White\TabJoinedHover.png"
	.	"`nFlag: " 2)
	errorLog .= "`n`n""Failed to extract file!"
	.	"`nSource: resources\skins\White\TabJoinedHover.png"
	.	"`nDest: " PROGRAM.SKINS_FOLDER "\White\TabJoinedHover.png"
	.	"`nFlag: " 2
}

; ----------------------------
if !InStr(FileExist(PROGRAM.SKINS_FOLDER "\White"), "D")
	FileCreateDir,% PROGRAM.SKINS_FOLDER "\White"

if (A_IsCompiled) {
	sourceFileSize := Get_ResourceSize("resources\skins\White\TabJoinedInactive.png")
	FileGetSize, destFileSize, % PROGRAM.SKINS_FOLDER "\White\TabJoinedInactive.png"
}
else {
	FileGetSize, sourceFileSize, resources\skins\White\TabJoinedInactive.png
	FileGetSize, destFileSize, % PROGRAM.SKINS_FOLDER "\White\TabJoinedInactive.png"
}
if (sourceFileSize != destFileSize)
	FileInstall, resources\skins\White\TabJoinedInactive.png, % PROGRAM.SKINS_FOLDER "\White\TabJoinedInactive.png", 1
if (ErrorLevel) {
	AppendToLogs("Failed to extract file!"
	.	"`nSource: resources\skins\White\TabJoinedInactive.png"
	.	"`nDest: " PROGRAM.SKINS_FOLDER "\White\TabJoinedInactive.png"
	.	"`nFlag: " 2)
	errorLog .= "`n`n""Failed to extract file!"
	.	"`nSource: resources\skins\White\TabJoinedInactive.png"
	.	"`nDest: " PROGRAM.SKINS_FOLDER "\White\TabJoinedInactive.png"
	.	"`nFlag: " 2
}

; ----------------------------
if !InStr(FileExist(PROGRAM.SKINS_FOLDER "\White"), "D")
	FileCreateDir,% PROGRAM.SKINS_FOLDER "\White"

if (A_IsCompiled) {
	sourceFileSize := Get_ResourceSize("resources\skins\White\TabsBackground.png")
	FileGetSize, destFileSize, % PROGRAM.SKINS_FOLDER "\White\TabsBackground.png"
}
else {
	FileGetSize, sourceFileSize, resources\skins\White\TabsBackground.png
	FileGetSize, destFileSize, % PROGRAM.SKINS_FOLDER "\White\TabsBackground.png"
}
if (sourceFileSize != destFileSize)
	FileInstall, resources\skins\White\TabsBackground.png, % PROGRAM.SKINS_FOLDER "\White\TabsBackground.png", 1
if (ErrorLevel) {
	AppendToLogs("Failed to extract file!"
	.	"`nSource: resources\skins\White\TabsBackground.png"
	.	"`nDest: " PROGRAM.SKINS_FOLDER "\White\TabsBackground.png"
	.	"`nFlag: " 2)
	errorLog .= "`n`n""Failed to extract file!"
	.	"`nSource: resources\skins\White\TabsBackground.png"
	.	"`nDest: " PROGRAM.SKINS_FOLDER "\White\TabsBackground.png"
	.	"`nFlag: " 2
}

; ----------------------------
if !InStr(FileExist(PROGRAM.SKINS_FOLDER "\White"), "D")
	FileCreateDir,% PROGRAM.SKINS_FOLDER "\White"

if (A_IsCompiled) {
	sourceFileSize := Get_ResourceSize("resources\skins\White\TabWhisperActive.png")
	FileGetSize, destFileSize, % PROGRAM.SKINS_FOLDER "\White\TabWhisperActive.png"
}
else {
	FileGetSize, sourceFileSize, resources\skins\White\TabWhisperActive.png
	FileGetSize, destFileSize, % PROGRAM.SKINS_FOLDER "\White\TabWhisperActive.png"
}
if (sourceFileSize != destFileSize)
	FileInstall, resources\skins\White\TabWhisperActive.png, % PROGRAM.SKINS_FOLDER "\White\TabWhisperActive.png", 1
if (ErrorLevel) {
	AppendToLogs("Failed to extract file!"
	.	"`nSource: resources\skins\White\TabWhisperActive.png"
	.	"`nDest: " PROGRAM.SKINS_FOLDER "\White\TabWhisperActive.png"
	.	"`nFlag: " 2)
	errorLog .= "`n`n""Failed to extract file!"
	.	"`nSource: resources\skins\White\TabWhisperActive.png"
	.	"`nDest: " PROGRAM.SKINS_FOLDER "\White\TabWhisperActive.png"
	.	"`nFlag: " 2
}

; ----------------------------
if !InStr(FileExist(PROGRAM.SKINS_FOLDER "\White"), "D")
	FileCreateDir,% PROGRAM.SKINS_FOLDER "\White"

if (A_IsCompiled) {
	sourceFileSize := Get_ResourceSize("resources\skins\White\TabWhisperHover.png")
	FileGetSize, destFileSize, % PROGRAM.SKINS_FOLDER "\White\TabWhisperHover.png"
}
else {
	FileGetSize, sourceFileSize, resources\skins\White\TabWhisperHover.png
	FileGetSize, destFileSize, % PROGRAM.SKINS_FOLDER "\White\TabWhisperHover.png"
}
if (sourceFileSize != destFileSize)
	FileInstall, resources\skins\White\TabWhisperHover.png, % PROGRAM.SKINS_FOLDER "\White\TabWhisperHover.png", 1
if (ErrorLevel) {
	AppendToLogs("Failed to extract file!"
	.	"`nSource: resources\skins\White\TabWhisperHover.png"
	.	"`nDest: " PROGRAM.SKINS_FOLDER "\White\TabWhisperHover.png"
	.	"`nFlag: " 2)
	errorLog .= "`n`n""Failed to extract file!"
	.	"`nSource: resources\skins\White\TabWhisperHover.png"
	.	"`nDest: " PROGRAM.SKINS_FOLDER "\White\TabWhisperHover.png"
	.	"`nFlag: " 2
}

; ----------------------------
if !InStr(FileExist(PROGRAM.SKINS_FOLDER "\White"), "D")
	FileCreateDir,% PROGRAM.SKINS_FOLDER "\White"

if (A_IsCompiled) {
	sourceFileSize := Get_ResourceSize("resources\skins\White\TabWhisperInactive.png")
	FileGetSize, destFileSize, % PROGRAM.SKINS_FOLDER "\White\TabWhisperInactive.png"
}
else {
	FileGetSize, sourceFileSize, resources\skins\White\TabWhisperInactive.png
	FileGetSize, destFileSize, % PROGRAM.SKINS_FOLDER "\White\TabWhisperInactive.png"
}
if (sourceFileSize != destFileSize)
	FileInstall, resources\skins\White\TabWhisperInactive.png, % PROGRAM.SKINS_FOLDER "\White\TabWhisperInactive.png", 1
if (ErrorLevel) {
	AppendToLogs("Failed to extract file!"
	.	"`nSource: resources\skins\White\TabWhisperInactive.png"
	.	"`nDest: " PROGRAM.SKINS_FOLDER "\White\TabWhisperInactive.png"
	.	"`nFlag: " 2)
	errorLog .= "`n`n""Failed to extract file!"
	.	"`nSource: resources\skins\White\TabWhisperInactive.png"
	.	"`nDest: " PROGRAM.SKINS_FOLDER "\White\TabWhisperInactive.png"
	.	"`nFlag: " 2
}

; ----------------------------
if !InStr(FileExist(PROGRAM.SKINS_FOLDER "\White"), "D")
	FileCreateDir,% PROGRAM.SKINS_FOLDER "\White"

if (A_IsCompiled) {
	sourceFileSize := Get_ResourceSize("resources\skins\White\TradeVerifyGreen.png")
	FileGetSize, destFileSize, % PROGRAM.SKINS_FOLDER "\White\TradeVerifyGreen.png"
}
else {
	FileGetSize, sourceFileSize, resources\skins\White\TradeVerifyGreen.png
	FileGetSize, destFileSize, % PROGRAM.SKINS_FOLDER "\White\TradeVerifyGreen.png"
}
if (sourceFileSize != destFileSize)
	FileInstall, resources\skins\White\TradeVerifyGreen.png, % PROGRAM.SKINS_FOLDER "\White\TradeVerifyGreen.png", 1
if (ErrorLevel) {
	AppendToLogs("Failed to extract file!"
	.	"`nSource: resources\skins\White\TradeVerifyGreen.png"
	.	"`nDest: " PROGRAM.SKINS_FOLDER "\White\TradeVerifyGreen.png"
	.	"`nFlag: " 2)
	errorLog .= "`n`n""Failed to extract file!"
	.	"`nSource: resources\skins\White\TradeVerifyGreen.png"
	.	"`nDest: " PROGRAM.SKINS_FOLDER "\White\TradeVerifyGreen.png"
	.	"`nFlag: " 2
}

; ----------------------------
if !InStr(FileExist(PROGRAM.SKINS_FOLDER "\White"), "D")
	FileCreateDir,% PROGRAM.SKINS_FOLDER "\White"

if (A_IsCompiled) {
	sourceFileSize := Get_ResourceSize("resources\skins\White\TradeVerifyGrey.png")
	FileGetSize, destFileSize, % PROGRAM.SKINS_FOLDER "\White\TradeVerifyGrey.png"
}
else {
	FileGetSize, sourceFileSize, resources\skins\White\TradeVerifyGrey.png
	FileGetSize, destFileSize, % PROGRAM.SKINS_FOLDER "\White\TradeVerifyGrey.png"
}
if (sourceFileSize != destFileSize)
	FileInstall, resources\skins\White\TradeVerifyGrey.png, % PROGRAM.SKINS_FOLDER "\White\TradeVerifyGrey.png", 1
if (ErrorLevel) {
	AppendToLogs("Failed to extract file!"
	.	"`nSource: resources\skins\White\TradeVerifyGrey.png"
	.	"`nDest: " PROGRAM.SKINS_FOLDER "\White\TradeVerifyGrey.png"
	.	"`nFlag: " 2)
	errorLog .= "`n`n""Failed to extract file!"
	.	"`nSource: resources\skins\White\TradeVerifyGrey.png"
	.	"`nDest: " PROGRAM.SKINS_FOLDER "\White\TradeVerifyGrey.png"
	.	"`nFlag: " 2
}

; ----------------------------
if !InStr(FileExist(PROGRAM.SKINS_FOLDER "\White"), "D")
	FileCreateDir,% PROGRAM.SKINS_FOLDER "\White"

if (A_IsCompiled) {
	sourceFileSize := Get_ResourceSize("resources\skins\White\TradeVerifyOrange.png")
	FileGetSize, destFileSize, % PROGRAM.SKINS_FOLDER "\White\TradeVerifyOrange.png"
}
else {
	FileGetSize, sourceFileSize, resources\skins\White\TradeVerifyOrange.png
	FileGetSize, destFileSize, % PROGRAM.SKINS_FOLDER "\White\TradeVerifyOrange.png"
}
if (sourceFileSize != destFileSize)
	FileInstall, resources\skins\White\TradeVerifyOrange.png, % PROGRAM.SKINS_FOLDER "\White\TradeVerifyOrange.png", 1
if (ErrorLevel) {
	AppendToLogs("Failed to extract file!"
	.	"`nSource: resources\skins\White\TradeVerifyOrange.png"
	.	"`nDest: " PROGRAM.SKINS_FOLDER "\White\TradeVerifyOrange.png"
	.	"`nFlag: " 2)
	errorLog .= "`n`n""Failed to extract file!"
	.	"`nSource: resources\skins\White\TradeVerifyOrange.png"
	.	"`nDest: " PROGRAM.SKINS_FOLDER "\White\TradeVerifyOrange.png"
	.	"`nFlag: " 2
}

; ----------------------------
if !InStr(FileExist(PROGRAM.SKINS_FOLDER "\White"), "D")
	FileCreateDir,% PROGRAM.SKINS_FOLDER "\White"

if (A_IsCompiled) {
	sourceFileSize := Get_ResourceSize("resources\skins\White\TradeVerifyRed.png")
	FileGetSize, destFileSize, % PROGRAM.SKINS_FOLDER "\White\TradeVerifyRed.png"
}
else {
	FileGetSize, sourceFileSize, resources\skins\White\TradeVerifyRed.png
	FileGetSize, destFileSize, % PROGRAM.SKINS_FOLDER "\White\TradeVerifyRed.png"
}
if (sourceFileSize != destFileSize)
	FileInstall, resources\skins\White\TradeVerifyRed.png, % PROGRAM.SKINS_FOLDER "\White\TradeVerifyRed.png", 1
if (ErrorLevel) {
	AppendToLogs("Failed to extract file!"
	.	"`nSource: resources\skins\White\TradeVerifyRed.png"
	.	"`nDest: " PROGRAM.SKINS_FOLDER "\White\TradeVerifyRed.png"
	.	"`nFlag: " 2)
	errorLog .= "`n`n""Failed to extract file!"
	.	"`nSource: resources\skins\White\TradeVerifyRed.png"
	.	"`nDest: " PROGRAM.SKINS_FOLDER "\White\TradeVerifyRed.png"
	.	"`nFlag: " 2
}

; ----------------------------
if !InStr(FileExist(PROGRAM.SKINS_FOLDER "\White\Compact"), "D")
	FileCreateDir,% PROGRAM.SKINS_FOLDER "\White\Compact"

if (A_IsCompiled) {
	sourceFileSize := Get_ResourceSize("resources\skins\White\Compact\ArrowLeft.png")
	FileGetSize, destFileSize, % PROGRAM.SKINS_FOLDER "\White\Compact\ArrowLeft.png"
}
else {
	FileGetSize, sourceFileSize, resources\skins\White\Compact\ArrowLeft.png
	FileGetSize, destFileSize, % PROGRAM.SKINS_FOLDER "\White\Compact\ArrowLeft.png"
}
if (sourceFileSize != destFileSize)
	FileInstall, resources\skins\White\Compact\ArrowLeft.png, % PROGRAM.SKINS_FOLDER "\White\Compact\ArrowLeft.png", 1
if (ErrorLevel) {
	AppendToLogs("Failed to extract file!"
	.	"`nSource: resources\skins\White\Compact\ArrowLeft.png"
	.	"`nDest: " PROGRAM.SKINS_FOLDER "\White\Compact\ArrowLeft.png"
	.	"`nFlag: " 2)
	errorLog .= "`n`n""Failed to extract file!"
	.	"`nSource: resources\skins\White\Compact\ArrowLeft.png"
	.	"`nDest: " PROGRAM.SKINS_FOLDER "\White\Compact\ArrowLeft.png"
	.	"`nFlag: " 2
}

; ----------------------------
if !InStr(FileExist(PROGRAM.SKINS_FOLDER "\White\Compact"), "D")
	FileCreateDir,% PROGRAM.SKINS_FOLDER "\White\Compact"

if (A_IsCompiled) {
	sourceFileSize := Get_ResourceSize("resources\skins\White\Compact\ArrowLeftHover.png")
	FileGetSize, destFileSize, % PROGRAM.SKINS_FOLDER "\White\Compact\ArrowLeftHover.png"
}
else {
	FileGetSize, sourceFileSize, resources\skins\White\Compact\ArrowLeftHover.png
	FileGetSize, destFileSize, % PROGRAM.SKINS_FOLDER "\White\Compact\ArrowLeftHover.png"
}
if (sourceFileSize != destFileSize)
	FileInstall, resources\skins\White\Compact\ArrowLeftHover.png, % PROGRAM.SKINS_FOLDER "\White\Compact\ArrowLeftHover.png", 1
if (ErrorLevel) {
	AppendToLogs("Failed to extract file!"
	.	"`nSource: resources\skins\White\Compact\ArrowLeftHover.png"
	.	"`nDest: " PROGRAM.SKINS_FOLDER "\White\Compact\ArrowLeftHover.png"
	.	"`nFlag: " 2)
	errorLog .= "`n`n""Failed to extract file!"
	.	"`nSource: resources\skins\White\Compact\ArrowLeftHover.png"
	.	"`nDest: " PROGRAM.SKINS_FOLDER "\White\Compact\ArrowLeftHover.png"
	.	"`nFlag: " 2
}

; ----------------------------
if !InStr(FileExist(PROGRAM.SKINS_FOLDER "\White\Compact"), "D")
	FileCreateDir,% PROGRAM.SKINS_FOLDER "\White\Compact"

if (A_IsCompiled) {
	sourceFileSize := Get_ResourceSize("resources\skins\White\Compact\ArrowLeftPress.png")
	FileGetSize, destFileSize, % PROGRAM.SKINS_FOLDER "\White\Compact\ArrowLeftPress.png"
}
else {
	FileGetSize, sourceFileSize, resources\skins\White\Compact\ArrowLeftPress.png
	FileGetSize, destFileSize, % PROGRAM.SKINS_FOLDER "\White\Compact\ArrowLeftPress.png"
}
if (sourceFileSize != destFileSize)
	FileInstall, resources\skins\White\Compact\ArrowLeftPress.png, % PROGRAM.SKINS_FOLDER "\White\Compact\ArrowLeftPress.png", 1
if (ErrorLevel) {
	AppendToLogs("Failed to extract file!"
	.	"`nSource: resources\skins\White\Compact\ArrowLeftPress.png"
	.	"`nDest: " PROGRAM.SKINS_FOLDER "\White\Compact\ArrowLeftPress.png"
	.	"`nFlag: " 2)
	errorLog .= "`n`n""Failed to extract file!"
	.	"`nSource: resources\skins\White\Compact\ArrowLeftPress.png"
	.	"`nDest: " PROGRAM.SKINS_FOLDER "\White\Compact\ArrowLeftPress.png"
	.	"`nFlag: " 2
}

; ----------------------------
if !InStr(FileExist(PROGRAM.SKINS_FOLDER "\White\Compact"), "D")
	FileCreateDir,% PROGRAM.SKINS_FOLDER "\White\Compact"

if (A_IsCompiled) {
	sourceFileSize := Get_ResourceSize("resources\skins\White\Compact\ArrowRight.png")
	FileGetSize, destFileSize, % PROGRAM.SKINS_FOLDER "\White\Compact\ArrowRight.png"
}
else {
	FileGetSize, sourceFileSize, resources\skins\White\Compact\ArrowRight.png
	FileGetSize, destFileSize, % PROGRAM.SKINS_FOLDER "\White\Compact\ArrowRight.png"
}
if (sourceFileSize != destFileSize)
	FileInstall, resources\skins\White\Compact\ArrowRight.png, % PROGRAM.SKINS_FOLDER "\White\Compact\ArrowRight.png", 1
if (ErrorLevel) {
	AppendToLogs("Failed to extract file!"
	.	"`nSource: resources\skins\White\Compact\ArrowRight.png"
	.	"`nDest: " PROGRAM.SKINS_FOLDER "\White\Compact\ArrowRight.png"
	.	"`nFlag: " 2)
	errorLog .= "`n`n""Failed to extract file!"
	.	"`nSource: resources\skins\White\Compact\ArrowRight.png"
	.	"`nDest: " PROGRAM.SKINS_FOLDER "\White\Compact\ArrowRight.png"
	.	"`nFlag: " 2
}

; ----------------------------
if !InStr(FileExist(PROGRAM.SKINS_FOLDER "\White\Compact"), "D")
	FileCreateDir,% PROGRAM.SKINS_FOLDER "\White\Compact"

if (A_IsCompiled) {
	sourceFileSize := Get_ResourceSize("resources\skins\White\Compact\ArrowRightHover.png")
	FileGetSize, destFileSize, % PROGRAM.SKINS_FOLDER "\White\Compact\ArrowRightHover.png"
}
else {
	FileGetSize, sourceFileSize, resources\skins\White\Compact\ArrowRightHover.png
	FileGetSize, destFileSize, % PROGRAM.SKINS_FOLDER "\White\Compact\ArrowRightHover.png"
}
if (sourceFileSize != destFileSize)
	FileInstall, resources\skins\White\Compact\ArrowRightHover.png, % PROGRAM.SKINS_FOLDER "\White\Compact\ArrowRightHover.png", 1
if (ErrorLevel) {
	AppendToLogs("Failed to extract file!"
	.	"`nSource: resources\skins\White\Compact\ArrowRightHover.png"
	.	"`nDest: " PROGRAM.SKINS_FOLDER "\White\Compact\ArrowRightHover.png"
	.	"`nFlag: " 2)
	errorLog .= "`n`n""Failed to extract file!"
	.	"`nSource: resources\skins\White\Compact\ArrowRightHover.png"
	.	"`nDest: " PROGRAM.SKINS_FOLDER "\White\Compact\ArrowRightHover.png"
	.	"`nFlag: " 2
}

; ----------------------------
if !InStr(FileExist(PROGRAM.SKINS_FOLDER "\White\Compact"), "D")
	FileCreateDir,% PROGRAM.SKINS_FOLDER "\White\Compact"

if (A_IsCompiled) {
	sourceFileSize := Get_ResourceSize("resources\skins\White\Compact\ArrowRightPress.png")
	FileGetSize, destFileSize, % PROGRAM.SKINS_FOLDER "\White\Compact\ArrowRightPress.png"
}
else {
	FileGetSize, sourceFileSize, resources\skins\White\Compact\ArrowRightPress.png
	FileGetSize, destFileSize, % PROGRAM.SKINS_FOLDER "\White\Compact\ArrowRightPress.png"
}
if (sourceFileSize != destFileSize)
	FileInstall, resources\skins\White\Compact\ArrowRightPress.png, % PROGRAM.SKINS_FOLDER "\White\Compact\ArrowRightPress.png", 1
if (ErrorLevel) {
	AppendToLogs("Failed to extract file!"
	.	"`nSource: resources\skins\White\Compact\ArrowRightPress.png"
	.	"`nDest: " PROGRAM.SKINS_FOLDER "\White\Compact\ArrowRightPress.png"
	.	"`nFlag: " 2)
	errorLog .= "`n`n""Failed to extract file!"
	.	"`nSource: resources\skins\White\Compact\ArrowRightPress.png"
	.	"`nDest: " PROGRAM.SKINS_FOLDER "\White\Compact\ArrowRightPress.png"
	.	"`nFlag: " 2
}

; ----------------------------
if !InStr(FileExist(PROGRAM.SKINS_FOLDER "\White\Compact"), "D")
	FileCreateDir,% PROGRAM.SKINS_FOLDER "\White\Compact"

FileInstall, resources\skins\White\Compact\Assets.ini, % PROGRAM.SKINS_FOLDER "\White\Compact\Assets.ini", 1
if (ErrorLevel) {
	AppendToLogs("Failed to extract file!"
	.	"`nSource: resources\skins\White\Compact\Assets.ini"
	.	"`nDest: " PROGRAM.SKINS_FOLDER "\White\Compact\Assets.ini"
	.	"`nFlag: " 1)
	errorLog .= "`n`n""Failed to extract file!"
	.	"`nSource: resources\skins\White\Compact\Assets.ini"
	.	"`nDest: " PROGRAM.SKINS_FOLDER "\White\Compact\Assets.ini"
	.	"`nFlag: " 1
}

; ----------------------------
if !InStr(FileExist(PROGRAM.SKINS_FOLDER "\White\Compact"), "D")
	FileCreateDir,% PROGRAM.SKINS_FOLDER "\White\Compact"

if (A_IsCompiled) {
	sourceFileSize := Get_ResourceSize("resources\skins\White\Compact\Background.png")
	FileGetSize, destFileSize, % PROGRAM.SKINS_FOLDER "\White\Compact\Background.png"
}
else {
	FileGetSize, sourceFileSize, resources\skins\White\Compact\Background.png
	FileGetSize, destFileSize, % PROGRAM.SKINS_FOLDER "\White\Compact\Background.png"
}
if (sourceFileSize != destFileSize)
	FileInstall, resources\skins\White\Compact\Background.png, % PROGRAM.SKINS_FOLDER "\White\Compact\Background.png", 1
if (ErrorLevel) {
	AppendToLogs("Failed to extract file!"
	.	"`nSource: resources\skins\White\Compact\Background.png"
	.	"`nDest: " PROGRAM.SKINS_FOLDER "\White\Compact\Background.png"
	.	"`nFlag: " 2)
	errorLog .= "`n`n""Failed to extract file!"
	.	"`nSource: resources\skins\White\Compact\Background.png"
	.	"`nDest: " PROGRAM.SKINS_FOLDER "\White\Compact\Background.png"
	.	"`nFlag: " 2
}

; ----------------------------
if !InStr(FileExist(PROGRAM.SKINS_FOLDER "\White\Compact"), "D")
	FileCreateDir,% PROGRAM.SKINS_FOLDER "\White\Compact"

if (A_IsCompiled) {
	sourceFileSize := Get_ResourceSize("resources\skins\White\Compact\ButtonHideout.png")
	FileGetSize, destFileSize, % PROGRAM.SKINS_FOLDER "\White\Compact\ButtonHideout.png"
}
else {
	FileGetSize, sourceFileSize, resources\skins\White\Compact\ButtonHideout.png
	FileGetSize, destFileSize, % PROGRAM.SKINS_FOLDER "\White\Compact\ButtonHideout.png"
}
if (sourceFileSize != destFileSize)
	FileInstall, resources\skins\White\Compact\ButtonHideout.png, % PROGRAM.SKINS_FOLDER "\White\Compact\ButtonHideout.png", 1
if (ErrorLevel) {
	AppendToLogs("Failed to extract file!"
	.	"`nSource: resources\skins\White\Compact\ButtonHideout.png"
	.	"`nDest: " PROGRAM.SKINS_FOLDER "\White\Compact\ButtonHideout.png"
	.	"`nFlag: " 2)
	errorLog .= "`n`n""Failed to extract file!"
	.	"`nSource: resources\skins\White\Compact\ButtonHideout.png"
	.	"`nDest: " PROGRAM.SKINS_FOLDER "\White\Compact\ButtonHideout.png"
	.	"`nFlag: " 2
}

; ----------------------------
if !InStr(FileExist(PROGRAM.SKINS_FOLDER "\White\Compact"), "D")
	FileCreateDir,% PROGRAM.SKINS_FOLDER "\White\Compact"

if (A_IsCompiled) {
	sourceFileSize := Get_ResourceSize("resources\skins\White\Compact\ButtonHideoutHover.png")
	FileGetSize, destFileSize, % PROGRAM.SKINS_FOLDER "\White\Compact\ButtonHideoutHover.png"
}
else {
	FileGetSize, sourceFileSize, resources\skins\White\Compact\ButtonHideoutHover.png
	FileGetSize, destFileSize, % PROGRAM.SKINS_FOLDER "\White\Compact\ButtonHideoutHover.png"
}
if (sourceFileSize != destFileSize)
	FileInstall, resources\skins\White\Compact\ButtonHideoutHover.png, % PROGRAM.SKINS_FOLDER "\White\Compact\ButtonHideoutHover.png", 1
if (ErrorLevel) {
	AppendToLogs("Failed to extract file!"
	.	"`nSource: resources\skins\White\Compact\ButtonHideoutHover.png"
	.	"`nDest: " PROGRAM.SKINS_FOLDER "\White\Compact\ButtonHideoutHover.png"
	.	"`nFlag: " 2)
	errorLog .= "`n`n""Failed to extract file!"
	.	"`nSource: resources\skins\White\Compact\ButtonHideoutHover.png"
	.	"`nDest: " PROGRAM.SKINS_FOLDER "\White\Compact\ButtonHideoutHover.png"
	.	"`nFlag: " 2
}

; ----------------------------
if !InStr(FileExist(PROGRAM.SKINS_FOLDER "\White\Compact"), "D")
	FileCreateDir,% PROGRAM.SKINS_FOLDER "\White\Compact"

if (A_IsCompiled) {
	sourceFileSize := Get_ResourceSize("resources\skins\White\Compact\ButtonHideoutPress.png")
	FileGetSize, destFileSize, % PROGRAM.SKINS_FOLDER "\White\Compact\ButtonHideoutPress.png"
}
else {
	FileGetSize, sourceFileSize, resources\skins\White\Compact\ButtonHideoutPress.png
	FileGetSize, destFileSize, % PROGRAM.SKINS_FOLDER "\White\Compact\ButtonHideoutPress.png"
}
if (sourceFileSize != destFileSize)
	FileInstall, resources\skins\White\Compact\ButtonHideoutPress.png, % PROGRAM.SKINS_FOLDER "\White\Compact\ButtonHideoutPress.png", 1
if (ErrorLevel) {
	AppendToLogs("Failed to extract file!"
	.	"`nSource: resources\skins\White\Compact\ButtonHideoutPress.png"
	.	"`nDest: " PROGRAM.SKINS_FOLDER "\White\Compact\ButtonHideoutPress.png"
	.	"`nFlag: " 2)
	errorLog .= "`n`n""Failed to extract file!"
	.	"`nSource: resources\skins\White\Compact\ButtonHideoutPress.png"
	.	"`nDest: " PROGRAM.SKINS_FOLDER "\White\Compact\ButtonHideoutPress.png"
	.	"`nFlag: " 2
}

; ----------------------------
if !InStr(FileExist(PROGRAM.SKINS_FOLDER "\White\Compact"), "D")
	FileCreateDir,% PROGRAM.SKINS_FOLDER "\White\Compact"

if (A_IsCompiled) {
	sourceFileSize := Get_ResourceSize("resources\skins\White\Compact\ButtonKick.png")
	FileGetSize, destFileSize, % PROGRAM.SKINS_FOLDER "\White\Compact\ButtonKick.png"
}
else {
	FileGetSize, sourceFileSize, resources\skins\White\Compact\ButtonKick.png
	FileGetSize, destFileSize, % PROGRAM.SKINS_FOLDER "\White\Compact\ButtonKick.png"
}
if (sourceFileSize != destFileSize)
	FileInstall, resources\skins\White\Compact\ButtonKick.png, % PROGRAM.SKINS_FOLDER "\White\Compact\ButtonKick.png", 1
if (ErrorLevel) {
	AppendToLogs("Failed to extract file!"
	.	"`nSource: resources\skins\White\Compact\ButtonKick.png"
	.	"`nDest: " PROGRAM.SKINS_FOLDER "\White\Compact\ButtonKick.png"
	.	"`nFlag: " 2)
	errorLog .= "`n`n""Failed to extract file!"
	.	"`nSource: resources\skins\White\Compact\ButtonKick.png"
	.	"`nDest: " PROGRAM.SKINS_FOLDER "\White\Compact\ButtonKick.png"
	.	"`nFlag: " 2
}

; ----------------------------
if !InStr(FileExist(PROGRAM.SKINS_FOLDER "\White\Compact"), "D")
	FileCreateDir,% PROGRAM.SKINS_FOLDER "\White\Compact"

if (A_IsCompiled) {
	sourceFileSize := Get_ResourceSize("resources\skins\White\Compact\ButtonKickHover.png")
	FileGetSize, destFileSize, % PROGRAM.SKINS_FOLDER "\White\Compact\ButtonKickHover.png"
}
else {
	FileGetSize, sourceFileSize, resources\skins\White\Compact\ButtonKickHover.png
	FileGetSize, destFileSize, % PROGRAM.SKINS_FOLDER "\White\Compact\ButtonKickHover.png"
}
if (sourceFileSize != destFileSize)
	FileInstall, resources\skins\White\Compact\ButtonKickHover.png, % PROGRAM.SKINS_FOLDER "\White\Compact\ButtonKickHover.png", 1
if (ErrorLevel) {
	AppendToLogs("Failed to extract file!"
	.	"`nSource: resources\skins\White\Compact\ButtonKickHover.png"
	.	"`nDest: " PROGRAM.SKINS_FOLDER "\White\Compact\ButtonKickHover.png"
	.	"`nFlag: " 2)
	errorLog .= "`n`n""Failed to extract file!"
	.	"`nSource: resources\skins\White\Compact\ButtonKickHover.png"
	.	"`nDest: " PROGRAM.SKINS_FOLDER "\White\Compact\ButtonKickHover.png"
	.	"`nFlag: " 2
}

; ----------------------------
if !InStr(FileExist(PROGRAM.SKINS_FOLDER "\White\Compact"), "D")
	FileCreateDir,% PROGRAM.SKINS_FOLDER "\White\Compact"

if (A_IsCompiled) {
	sourceFileSize := Get_ResourceSize("resources\skins\White\Compact\ButtonKickPress.png")
	FileGetSize, destFileSize, % PROGRAM.SKINS_FOLDER "\White\Compact\ButtonKickPress.png"
}
else {
	FileGetSize, sourceFileSize, resources\skins\White\Compact\ButtonKickPress.png
	FileGetSize, destFileSize, % PROGRAM.SKINS_FOLDER "\White\Compact\ButtonKickPress.png"
}
if (sourceFileSize != destFileSize)
	FileInstall, resources\skins\White\Compact\ButtonKickPress.png, % PROGRAM.SKINS_FOLDER "\White\Compact\ButtonKickPress.png", 1
if (ErrorLevel) {
	AppendToLogs("Failed to extract file!"
	.	"`nSource: resources\skins\White\Compact\ButtonKickPress.png"
	.	"`nDest: " PROGRAM.SKINS_FOLDER "\White\Compact\ButtonKickPress.png"
	.	"`nFlag: " 2)
	errorLog .= "`n`n""Failed to extract file!"
	.	"`nSource: resources\skins\White\Compact\ButtonKickPress.png"
	.	"`nDest: " PROGRAM.SKINS_FOLDER "\White\Compact\ButtonKickPress.png"
	.	"`nFlag: " 2
}

; ----------------------------
if !InStr(FileExist(PROGRAM.SKINS_FOLDER "\White\Compact"), "D")
	FileCreateDir,% PROGRAM.SKINS_FOLDER "\White\Compact"

if (A_IsCompiled) {
	sourceFileSize := Get_ResourceSize("resources\skins\White\Compact\ButtonThanks.png")
	FileGetSize, destFileSize, % PROGRAM.SKINS_FOLDER "\White\Compact\ButtonThanks.png"
}
else {
	FileGetSize, sourceFileSize, resources\skins\White\Compact\ButtonThanks.png
	FileGetSize, destFileSize, % PROGRAM.SKINS_FOLDER "\White\Compact\ButtonThanks.png"
}
if (sourceFileSize != destFileSize)
	FileInstall, resources\skins\White\Compact\ButtonThanks.png, % PROGRAM.SKINS_FOLDER "\White\Compact\ButtonThanks.png", 1
if (ErrorLevel) {
	AppendToLogs("Failed to extract file!"
	.	"`nSource: resources\skins\White\Compact\ButtonThanks.png"
	.	"`nDest: " PROGRAM.SKINS_FOLDER "\White\Compact\ButtonThanks.png"
	.	"`nFlag: " 2)
	errorLog .= "`n`n""Failed to extract file!"
	.	"`nSource: resources\skins\White\Compact\ButtonThanks.png"
	.	"`nDest: " PROGRAM.SKINS_FOLDER "\White\Compact\ButtonThanks.png"
	.	"`nFlag: " 2
}

; ----------------------------
if !InStr(FileExist(PROGRAM.SKINS_FOLDER "\White\Compact"), "D")
	FileCreateDir,% PROGRAM.SKINS_FOLDER "\White\Compact"

if (A_IsCompiled) {
	sourceFileSize := Get_ResourceSize("resources\skins\White\Compact\ButtonThanksHover.png")
	FileGetSize, destFileSize, % PROGRAM.SKINS_FOLDER "\White\Compact\ButtonThanksHover.png"
}
else {
	FileGetSize, sourceFileSize, resources\skins\White\Compact\ButtonThanksHover.png
	FileGetSize, destFileSize, % PROGRAM.SKINS_FOLDER "\White\Compact\ButtonThanksHover.png"
}
if (sourceFileSize != destFileSize)
	FileInstall, resources\skins\White\Compact\ButtonThanksHover.png, % PROGRAM.SKINS_FOLDER "\White\Compact\ButtonThanksHover.png", 1
if (ErrorLevel) {
	AppendToLogs("Failed to extract file!"
	.	"`nSource: resources\skins\White\Compact\ButtonThanksHover.png"
	.	"`nDest: " PROGRAM.SKINS_FOLDER "\White\Compact\ButtonThanksHover.png"
	.	"`nFlag: " 2)
	errorLog .= "`n`n""Failed to extract file!"
	.	"`nSource: resources\skins\White\Compact\ButtonThanksHover.png"
	.	"`nDest: " PROGRAM.SKINS_FOLDER "\White\Compact\ButtonThanksHover.png"
	.	"`nFlag: " 2
}

; ----------------------------
if !InStr(FileExist(PROGRAM.SKINS_FOLDER "\White\Compact"), "D")
	FileCreateDir,% PROGRAM.SKINS_FOLDER "\White\Compact"

if (A_IsCompiled) {
	sourceFileSize := Get_ResourceSize("resources\skins\White\Compact\ButtonThanksPress.png")
	FileGetSize, destFileSize, % PROGRAM.SKINS_FOLDER "\White\Compact\ButtonThanksPress.png"
}
else {
	FileGetSize, sourceFileSize, resources\skins\White\Compact\ButtonThanksPress.png
	FileGetSize, destFileSize, % PROGRAM.SKINS_FOLDER "\White\Compact\ButtonThanksPress.png"
}
if (sourceFileSize != destFileSize)
	FileInstall, resources\skins\White\Compact\ButtonThanksPress.png, % PROGRAM.SKINS_FOLDER "\White\Compact\ButtonThanksPress.png", 1
if (ErrorLevel) {
	AppendToLogs("Failed to extract file!"
	.	"`nSource: resources\skins\White\Compact\ButtonThanksPress.png"
	.	"`nDest: " PROGRAM.SKINS_FOLDER "\White\Compact\ButtonThanksPress.png"
	.	"`nFlag: " 2)
	errorLog .= "`n`n""Failed to extract file!"
	.	"`nSource: resources\skins\White\Compact\ButtonThanksPress.png"
	.	"`nDest: " PROGRAM.SKINS_FOLDER "\White\Compact\ButtonThanksPress.png"
	.	"`nFlag: " 2
}

; ----------------------------
if !InStr(FileExist(PROGRAM.SKINS_FOLDER "\White\Compact"), "D")
	FileCreateDir,% PROGRAM.SKINS_FOLDER "\White\Compact"

if (A_IsCompiled) {
	sourceFileSize := Get_ResourceSize("resources\skins\White\Compact\ButtonWhisper.png")
	FileGetSize, destFileSize, % PROGRAM.SKINS_FOLDER "\White\Compact\ButtonWhisper.png"
}
else {
	FileGetSize, sourceFileSize, resources\skins\White\Compact\ButtonWhisper.png
	FileGetSize, destFileSize, % PROGRAM.SKINS_FOLDER "\White\Compact\ButtonWhisper.png"
}
if (sourceFileSize != destFileSize)
	FileInstall, resources\skins\White\Compact\ButtonWhisper.png, % PROGRAM.SKINS_FOLDER "\White\Compact\ButtonWhisper.png", 1
if (ErrorLevel) {
	AppendToLogs("Failed to extract file!"
	.	"`nSource: resources\skins\White\Compact\ButtonWhisper.png"
	.	"`nDest: " PROGRAM.SKINS_FOLDER "\White\Compact\ButtonWhisper.png"
	.	"`nFlag: " 2)
	errorLog .= "`n`n""Failed to extract file!"
	.	"`nSource: resources\skins\White\Compact\ButtonWhisper.png"
	.	"`nDest: " PROGRAM.SKINS_FOLDER "\White\Compact\ButtonWhisper.png"
	.	"`nFlag: " 2
}

; ----------------------------
if !InStr(FileExist(PROGRAM.SKINS_FOLDER "\White\Compact"), "D")
	FileCreateDir,% PROGRAM.SKINS_FOLDER "\White\Compact"

if (A_IsCompiled) {
	sourceFileSize := Get_ResourceSize("resources\skins\White\Compact\ButtonWhisperHover.png")
	FileGetSize, destFileSize, % PROGRAM.SKINS_FOLDER "\White\Compact\ButtonWhisperHover.png"
}
else {
	FileGetSize, sourceFileSize, resources\skins\White\Compact\ButtonWhisperHover.png
	FileGetSize, destFileSize, % PROGRAM.SKINS_FOLDER "\White\Compact\ButtonWhisperHover.png"
}
if (sourceFileSize != destFileSize)
	FileInstall, resources\skins\White\Compact\ButtonWhisperHover.png, % PROGRAM.SKINS_FOLDER "\White\Compact\ButtonWhisperHover.png", 1
if (ErrorLevel) {
	AppendToLogs("Failed to extract file!"
	.	"`nSource: resources\skins\White\Compact\ButtonWhisperHover.png"
	.	"`nDest: " PROGRAM.SKINS_FOLDER "\White\Compact\ButtonWhisperHover.png"
	.	"`nFlag: " 2)
	errorLog .= "`n`n""Failed to extract file!"
	.	"`nSource: resources\skins\White\Compact\ButtonWhisperHover.png"
	.	"`nDest: " PROGRAM.SKINS_FOLDER "\White\Compact\ButtonWhisperHover.png"
	.	"`nFlag: " 2
}

; ----------------------------
if !InStr(FileExist(PROGRAM.SKINS_FOLDER "\White\Compact"), "D")
	FileCreateDir,% PROGRAM.SKINS_FOLDER "\White\Compact"

if (A_IsCompiled) {
	sourceFileSize := Get_ResourceSize("resources\skins\White\Compact\ButtonWhisperPress.png")
	FileGetSize, destFileSize, % PROGRAM.SKINS_FOLDER "\White\Compact\ButtonWhisperPress.png"
}
else {
	FileGetSize, sourceFileSize, resources\skins\White\Compact\ButtonWhisperPress.png
	FileGetSize, destFileSize, % PROGRAM.SKINS_FOLDER "\White\Compact\ButtonWhisperPress.png"
}
if (sourceFileSize != destFileSize)
	FileInstall, resources\skins\White\Compact\ButtonWhisperPress.png, % PROGRAM.SKINS_FOLDER "\White\Compact\ButtonWhisperPress.png", 1
if (ErrorLevel) {
	AppendToLogs("Failed to extract file!"
	.	"`nSource: resources\skins\White\Compact\ButtonWhisperPress.png"
	.	"`nDest: " PROGRAM.SKINS_FOLDER "\White\Compact\ButtonWhisperPress.png"
	.	"`nFlag: " 2)
	errorLog .= "`n`n""Failed to extract file!"
	.	"`nSource: resources\skins\White\Compact\ButtonWhisperPress.png"
	.	"`nDest: " PROGRAM.SKINS_FOLDER "\White\Compact\ButtonWhisperPress.png"
	.	"`nFlag: " 2
}

; ----------------------------
if !InStr(FileExist(PROGRAM.SKINS_FOLDER "\White\Compact"), "D")
	FileCreateDir,% PROGRAM.SKINS_FOLDER "\White\Compact"

if (A_IsCompiled) {
	sourceFileSize := Get_ResourceSize("resources\skins\White\Compact\CloseTab.png")
	FileGetSize, destFileSize, % PROGRAM.SKINS_FOLDER "\White\Compact\CloseTab.png"
}
else {
	FileGetSize, sourceFileSize, resources\skins\White\Compact\CloseTab.png
	FileGetSize, destFileSize, % PROGRAM.SKINS_FOLDER "\White\Compact\CloseTab.png"
}
if (sourceFileSize != destFileSize)
	FileInstall, resources\skins\White\Compact\CloseTab.png, % PROGRAM.SKINS_FOLDER "\White\Compact\CloseTab.png", 1
if (ErrorLevel) {
	AppendToLogs("Failed to extract file!"
	.	"`nSource: resources\skins\White\Compact\CloseTab.png"
	.	"`nDest: " PROGRAM.SKINS_FOLDER "\White\Compact\CloseTab.png"
	.	"`nFlag: " 2)
	errorLog .= "`n`n""Failed to extract file!"
	.	"`nSource: resources\skins\White\Compact\CloseTab.png"
	.	"`nDest: " PROGRAM.SKINS_FOLDER "\White\Compact\CloseTab.png"
	.	"`nFlag: " 2
}

; ----------------------------
if !InStr(FileExist(PROGRAM.SKINS_FOLDER "\White\Compact"), "D")
	FileCreateDir,% PROGRAM.SKINS_FOLDER "\White\Compact"

if (A_IsCompiled) {
	sourceFileSize := Get_ResourceSize("resources\skins\White\Compact\CloseTabHover.png")
	FileGetSize, destFileSize, % PROGRAM.SKINS_FOLDER "\White\Compact\CloseTabHover.png"
}
else {
	FileGetSize, sourceFileSize, resources\skins\White\Compact\CloseTabHover.png
	FileGetSize, destFileSize, % PROGRAM.SKINS_FOLDER "\White\Compact\CloseTabHover.png"
}
if (sourceFileSize != destFileSize)
	FileInstall, resources\skins\White\Compact\CloseTabHover.png, % PROGRAM.SKINS_FOLDER "\White\Compact\CloseTabHover.png", 1
if (ErrorLevel) {
	AppendToLogs("Failed to extract file!"
	.	"`nSource: resources\skins\White\Compact\CloseTabHover.png"
	.	"`nDest: " PROGRAM.SKINS_FOLDER "\White\Compact\CloseTabHover.png"
	.	"`nFlag: " 2)
	errorLog .= "`n`n""Failed to extract file!"
	.	"`nSource: resources\skins\White\Compact\CloseTabHover.png"
	.	"`nDest: " PROGRAM.SKINS_FOLDER "\White\Compact\CloseTabHover.png"
	.	"`nFlag: " 2
}

; ----------------------------
if !InStr(FileExist(PROGRAM.SKINS_FOLDER "\White\Compact"), "D")
	FileCreateDir,% PROGRAM.SKINS_FOLDER "\White\Compact"

if (A_IsCompiled) {
	sourceFileSize := Get_ResourceSize("resources\skins\White\Compact\CloseTabPress.png")
	FileGetSize, destFileSize, % PROGRAM.SKINS_FOLDER "\White\Compact\CloseTabPress.png"
}
else {
	FileGetSize, sourceFileSize, resources\skins\White\Compact\CloseTabPress.png
	FileGetSize, destFileSize, % PROGRAM.SKINS_FOLDER "\White\Compact\CloseTabPress.png"
}
if (sourceFileSize != destFileSize)
	FileInstall, resources\skins\White\Compact\CloseTabPress.png, % PROGRAM.SKINS_FOLDER "\White\Compact\CloseTabPress.png", 1
if (ErrorLevel) {
	AppendToLogs("Failed to extract file!"
	.	"`nSource: resources\skins\White\Compact\CloseTabPress.png"
	.	"`nDest: " PROGRAM.SKINS_FOLDER "\White\Compact\CloseTabPress.png"
	.	"`nFlag: " 2)
	errorLog .= "`n`n""Failed to extract file!"
	.	"`nSource: resources\skins\White\Compact\CloseTabPress.png"
	.	"`nDest: " PROGRAM.SKINS_FOLDER "\White\Compact\CloseTabPress.png"
	.	"`nFlag: " 2
}

; ----------------------------
if !InStr(FileExist(PROGRAM.SKINS_FOLDER "\White\Compact"), "D")
	FileCreateDir,% PROGRAM.SKINS_FOLDER "\White\Compact"

if (A_IsCompiled) {
	sourceFileSize := Get_ResourceSize("resources\skins\White\Compact\Header.png")
	FileGetSize, destFileSize, % PROGRAM.SKINS_FOLDER "\White\Compact\Header.png"
}
else {
	FileGetSize, sourceFileSize, resources\skins\White\Compact\Header.png
	FileGetSize, destFileSize, % PROGRAM.SKINS_FOLDER "\White\Compact\Header.png"
}
if (sourceFileSize != destFileSize)
	FileInstall, resources\skins\White\Compact\Header.png, % PROGRAM.SKINS_FOLDER "\White\Compact\Header.png", 1
if (ErrorLevel) {
	AppendToLogs("Failed to extract file!"
	.	"`nSource: resources\skins\White\Compact\Header.png"
	.	"`nDest: " PROGRAM.SKINS_FOLDER "\White\Compact\Header.png"
	.	"`nFlag: " 2)
	errorLog .= "`n`n""Failed to extract file!"
	.	"`nSource: resources\skins\White\Compact\Header.png"
	.	"`nDest: " PROGRAM.SKINS_FOLDER "\White\Compact\Header.png"
	.	"`nFlag: " 2
}

; ----------------------------
if !InStr(FileExist(PROGRAM.SKINS_FOLDER "\White\Compact"), "D")
	FileCreateDir,% PROGRAM.SKINS_FOLDER "\White\Compact"

if (A_IsCompiled) {
	sourceFileSize := Get_ResourceSize("resources\skins\White\Compact\Header2.png")
	FileGetSize, destFileSize, % PROGRAM.SKINS_FOLDER "\White\Compact\Header2.png"
}
else {
	FileGetSize, sourceFileSize, resources\skins\White\Compact\Header2.png
	FileGetSize, destFileSize, % PROGRAM.SKINS_FOLDER "\White\Compact\Header2.png"
}
if (sourceFileSize != destFileSize)
	FileInstall, resources\skins\White\Compact\Header2.png, % PROGRAM.SKINS_FOLDER "\White\Compact\Header2.png", 1
if (ErrorLevel) {
	AppendToLogs("Failed to extract file!"
	.	"`nSource: resources\skins\White\Compact\Header2.png"
	.	"`nDest: " PROGRAM.SKINS_FOLDER "\White\Compact\Header2.png"
	.	"`nFlag: " 2)
	errorLog .= "`n`n""Failed to extract file!"
	.	"`nSource: resources\skins\White\Compact\Header2.png"
	.	"`nDest: " PROGRAM.SKINS_FOLDER "\White\Compact\Header2.png"
	.	"`nFlag: " 2
}

; ----------------------------
if !InStr(FileExist(PROGRAM.SKINS_FOLDER "\White\Compact"), "D")
	FileCreateDir,% PROGRAM.SKINS_FOLDER "\White\Compact"

if (A_IsCompiled) {
	sourceFileSize := Get_ResourceSize("resources\skins\White\Compact\Maximize.png")
	FileGetSize, destFileSize, % PROGRAM.SKINS_FOLDER "\White\Compact\Maximize.png"
}
else {
	FileGetSize, sourceFileSize, resources\skins\White\Compact\Maximize.png
	FileGetSize, destFileSize, % PROGRAM.SKINS_FOLDER "\White\Compact\Maximize.png"
}
if (sourceFileSize != destFileSize)
	FileInstall, resources\skins\White\Compact\Maximize.png, % PROGRAM.SKINS_FOLDER "\White\Compact\Maximize.png", 1
if (ErrorLevel) {
	AppendToLogs("Failed to extract file!"
	.	"`nSource: resources\skins\White\Compact\Maximize.png"
	.	"`nDest: " PROGRAM.SKINS_FOLDER "\White\Compact\Maximize.png"
	.	"`nFlag: " 2)
	errorLog .= "`n`n""Failed to extract file!"
	.	"`nSource: resources\skins\White\Compact\Maximize.png"
	.	"`nDest: " PROGRAM.SKINS_FOLDER "\White\Compact\Maximize.png"
	.	"`nFlag: " 2
}

; ----------------------------
if !InStr(FileExist(PROGRAM.SKINS_FOLDER "\White\Compact"), "D")
	FileCreateDir,% PROGRAM.SKINS_FOLDER "\White\Compact"

if (A_IsCompiled) {
	sourceFileSize := Get_ResourceSize("resources\skins\White\Compact\MaximizeHover.png")
	FileGetSize, destFileSize, % PROGRAM.SKINS_FOLDER "\White\Compact\MaximizeHover.png"
}
else {
	FileGetSize, sourceFileSize, resources\skins\White\Compact\MaximizeHover.png
	FileGetSize, destFileSize, % PROGRAM.SKINS_FOLDER "\White\Compact\MaximizeHover.png"
}
if (sourceFileSize != destFileSize)
	FileInstall, resources\skins\White\Compact\MaximizeHover.png, % PROGRAM.SKINS_FOLDER "\White\Compact\MaximizeHover.png", 1
if (ErrorLevel) {
	AppendToLogs("Failed to extract file!"
	.	"`nSource: resources\skins\White\Compact\MaximizeHover.png"
	.	"`nDest: " PROGRAM.SKINS_FOLDER "\White\Compact\MaximizeHover.png"
	.	"`nFlag: " 2)
	errorLog .= "`n`n""Failed to extract file!"
	.	"`nSource: resources\skins\White\Compact\MaximizeHover.png"
	.	"`nDest: " PROGRAM.SKINS_FOLDER "\White\Compact\MaximizeHover.png"
	.	"`nFlag: " 2
}

; ----------------------------
if !InStr(FileExist(PROGRAM.SKINS_FOLDER "\White\Compact"), "D")
	FileCreateDir,% PROGRAM.SKINS_FOLDER "\White\Compact"

if (A_IsCompiled) {
	sourceFileSize := Get_ResourceSize("resources\skins\White\Compact\MaximizePress.png")
	FileGetSize, destFileSize, % PROGRAM.SKINS_FOLDER "\White\Compact\MaximizePress.png"
}
else {
	FileGetSize, sourceFileSize, resources\skins\White\Compact\MaximizePress.png
	FileGetSize, destFileSize, % PROGRAM.SKINS_FOLDER "\White\Compact\MaximizePress.png"
}
if (sourceFileSize != destFileSize)
	FileInstall, resources\skins\White\Compact\MaximizePress.png, % PROGRAM.SKINS_FOLDER "\White\Compact\MaximizePress.png", 1
if (ErrorLevel) {
	AppendToLogs("Failed to extract file!"
	.	"`nSource: resources\skins\White\Compact\MaximizePress.png"
	.	"`nDest: " PROGRAM.SKINS_FOLDER "\White\Compact\MaximizePress.png"
	.	"`nFlag: " 2)
	errorLog .= "`n`n""Failed to extract file!"
	.	"`nSource: resources\skins\White\Compact\MaximizePress.png"
	.	"`nDest: " PROGRAM.SKINS_FOLDER "\White\Compact\MaximizePress.png"
	.	"`nFlag: " 2
}

; ----------------------------
if !InStr(FileExist(PROGRAM.SKINS_FOLDER "\White\Compact"), "D")
	FileCreateDir,% PROGRAM.SKINS_FOLDER "\White\Compact"

if (A_IsCompiled) {
	sourceFileSize := Get_ResourceSize("resources\skins\White\Compact\Minimize.png")
	FileGetSize, destFileSize, % PROGRAM.SKINS_FOLDER "\White\Compact\Minimize.png"
}
else {
	FileGetSize, sourceFileSize, resources\skins\White\Compact\Minimize.png
	FileGetSize, destFileSize, % PROGRAM.SKINS_FOLDER "\White\Compact\Minimize.png"
}
if (sourceFileSize != destFileSize)
	FileInstall, resources\skins\White\Compact\Minimize.png, % PROGRAM.SKINS_FOLDER "\White\Compact\Minimize.png", 1
if (ErrorLevel) {
	AppendToLogs("Failed to extract file!"
	.	"`nSource: resources\skins\White\Compact\Minimize.png"
	.	"`nDest: " PROGRAM.SKINS_FOLDER "\White\Compact\Minimize.png"
	.	"`nFlag: " 2)
	errorLog .= "`n`n""Failed to extract file!"
	.	"`nSource: resources\skins\White\Compact\Minimize.png"
	.	"`nDest: " PROGRAM.SKINS_FOLDER "\White\Compact\Minimize.png"
	.	"`nFlag: " 2
}

; ----------------------------
if !InStr(FileExist(PROGRAM.SKINS_FOLDER "\White\Compact"), "D")
	FileCreateDir,% PROGRAM.SKINS_FOLDER "\White\Compact"

if (A_IsCompiled) {
	sourceFileSize := Get_ResourceSize("resources\skins\White\Compact\MinimizeHover.png")
	FileGetSize, destFileSize, % PROGRAM.SKINS_FOLDER "\White\Compact\MinimizeHover.png"
}
else {
	FileGetSize, sourceFileSize, resources\skins\White\Compact\MinimizeHover.png
	FileGetSize, destFileSize, % PROGRAM.SKINS_FOLDER "\White\Compact\MinimizeHover.png"
}
if (sourceFileSize != destFileSize)
	FileInstall, resources\skins\White\Compact\MinimizeHover.png, % PROGRAM.SKINS_FOLDER "\White\Compact\MinimizeHover.png", 1
if (ErrorLevel) {
	AppendToLogs("Failed to extract file!"
	.	"`nSource: resources\skins\White\Compact\MinimizeHover.png"
	.	"`nDest: " PROGRAM.SKINS_FOLDER "\White\Compact\MinimizeHover.png"
	.	"`nFlag: " 2)
	errorLog .= "`n`n""Failed to extract file!"
	.	"`nSource: resources\skins\White\Compact\MinimizeHover.png"
	.	"`nDest: " PROGRAM.SKINS_FOLDER "\White\Compact\MinimizeHover.png"
	.	"`nFlag: " 2
}

; ----------------------------
if !InStr(FileExist(PROGRAM.SKINS_FOLDER "\White\Compact"), "D")
	FileCreateDir,% PROGRAM.SKINS_FOLDER "\White\Compact"

if (A_IsCompiled) {
	sourceFileSize := Get_ResourceSize("resources\skins\White\Compact\MinimizePress.png")
	FileGetSize, destFileSize, % PROGRAM.SKINS_FOLDER "\White\Compact\MinimizePress.png"
}
else {
	FileGetSize, sourceFileSize, resources\skins\White\Compact\MinimizePress.png
	FileGetSize, destFileSize, % PROGRAM.SKINS_FOLDER "\White\Compact\MinimizePress.png"
}
if (sourceFileSize != destFileSize)
	FileInstall, resources\skins\White\Compact\MinimizePress.png, % PROGRAM.SKINS_FOLDER "\White\Compact\MinimizePress.png", 1
if (ErrorLevel) {
	AppendToLogs("Failed to extract file!"
	.	"`nSource: resources\skins\White\Compact\MinimizePress.png"
	.	"`nDest: " PROGRAM.SKINS_FOLDER "\White\Compact\MinimizePress.png"
	.	"`nFlag: " 2)
	errorLog .= "`n`n""Failed to extract file!"
	.	"`nSource: resources\skins\White\Compact\MinimizePress.png"
	.	"`nDest: " PROGRAM.SKINS_FOLDER "\White\Compact\MinimizePress.png"
	.	"`nFlag: " 2
}

; ----------------------------
if !InStr(FileExist(PROGRAM.SKINS_FOLDER "\White\Compact"), "D")
	FileCreateDir,% PROGRAM.SKINS_FOLDER "\White\Compact"

if (A_IsCompiled) {
	sourceFileSize := Get_ResourceSize("resources\skins\White\Compact\Preview.png")
	FileGetSize, destFileSize, % PROGRAM.SKINS_FOLDER "\White\Compact\Preview.png"
}
else {
	FileGetSize, sourceFileSize, resources\skins\White\Compact\Preview.png
	FileGetSize, destFileSize, % PROGRAM.SKINS_FOLDER "\White\Compact\Preview.png"
}
if (sourceFileSize != destFileSize)
	FileInstall, resources\skins\White\Compact\Preview.png, % PROGRAM.SKINS_FOLDER "\White\Compact\Preview.png", 1
if (ErrorLevel) {
	AppendToLogs("Failed to extract file!"
	.	"`nSource: resources\skins\White\Compact\Preview.png"
	.	"`nDest: " PROGRAM.SKINS_FOLDER "\White\Compact\Preview.png"
	.	"`nFlag: " 2)
	errorLog .= "`n`n""Failed to extract file!"
	.	"`nSource: resources\skins\White\Compact\Preview.png"
	.	"`nDest: " PROGRAM.SKINS_FOLDER "\White\Compact\Preview.png"
	.	"`nFlag: " 2
}

; ----------------------------
if !InStr(FileExist(PROGRAM.SKINS_FOLDER "\White\Compact"), "D")
	FileCreateDir,% PROGRAM.SKINS_FOLDER "\White\Compact"

FileInstall, resources\skins\White\Compact\Settings.ini, % PROGRAM.SKINS_FOLDER "\White\Compact\Settings.ini", 1
if (ErrorLevel) {
	AppendToLogs("Failed to extract file!"
	.	"`nSource: resources\skins\White\Compact\Settings.ini"
	.	"`nDest: " PROGRAM.SKINS_FOLDER "\White\Compact\Settings.ini"
	.	"`nFlag: " 1)
	errorLog .= "`n`n""Failed to extract file!"
	.	"`nSource: resources\skins\White\Compact\Settings.ini"
	.	"`nDest: " PROGRAM.SKINS_FOLDER "\White\Compact\Settings.ini"
	.	"`nFlag: " 1
}

; ----------------------------
if !InStr(FileExist(PROGRAM.SKINS_FOLDER "\White\Compact"), "D")
	FileCreateDir,% PROGRAM.SKINS_FOLDER "\White\Compact"

if (A_IsCompiled) {
	sourceFileSize := Get_ResourceSize("resources\skins\White\Compact\ToolbarHideout.png")
	FileGetSize, destFileSize, % PROGRAM.SKINS_FOLDER "\White\Compact\ToolbarHideout.png"
}
else {
	FileGetSize, sourceFileSize, resources\skins\White\Compact\ToolbarHideout.png
	FileGetSize, destFileSize, % PROGRAM.SKINS_FOLDER "\White\Compact\ToolbarHideout.png"
}
if (sourceFileSize != destFileSize)
	FileInstall, resources\skins\White\Compact\ToolbarHideout.png, % PROGRAM.SKINS_FOLDER "\White\Compact\ToolbarHideout.png", 1
if (ErrorLevel) {
	AppendToLogs("Failed to extract file!"
	.	"`nSource: resources\skins\White\Compact\ToolbarHideout.png"
	.	"`nDest: " PROGRAM.SKINS_FOLDER "\White\Compact\ToolbarHideout.png"
	.	"`nFlag: " 2)
	errorLog .= "`n`n""Failed to extract file!"
	.	"`nSource: resources\skins\White\Compact\ToolbarHideout.png"
	.	"`nDest: " PROGRAM.SKINS_FOLDER "\White\Compact\ToolbarHideout.png"
	.	"`nFlag: " 2
}

; ----------------------------
if !InStr(FileExist(PROGRAM.SKINS_FOLDER "\White\Compact"), "D")
	FileCreateDir,% PROGRAM.SKINS_FOLDER "\White\Compact"

if (A_IsCompiled) {
	sourceFileSize := Get_ResourceSize("resources\skins\White\Compact\ToolbarHideoutHover.png")
	FileGetSize, destFileSize, % PROGRAM.SKINS_FOLDER "\White\Compact\ToolbarHideoutHover.png"
}
else {
	FileGetSize, sourceFileSize, resources\skins\White\Compact\ToolbarHideoutHover.png
	FileGetSize, destFileSize, % PROGRAM.SKINS_FOLDER "\White\Compact\ToolbarHideoutHover.png"
}
if (sourceFileSize != destFileSize)
	FileInstall, resources\skins\White\Compact\ToolbarHideoutHover.png, % PROGRAM.SKINS_FOLDER "\White\Compact\ToolbarHideoutHover.png", 1
if (ErrorLevel) {
	AppendToLogs("Failed to extract file!"
	.	"`nSource: resources\skins\White\Compact\ToolbarHideoutHover.png"
	.	"`nDest: " PROGRAM.SKINS_FOLDER "\White\Compact\ToolbarHideoutHover.png"
	.	"`nFlag: " 2)
	errorLog .= "`n`n""Failed to extract file!"
	.	"`nSource: resources\skins\White\Compact\ToolbarHideoutHover.png"
	.	"`nDest: " PROGRAM.SKINS_FOLDER "\White\Compact\ToolbarHideoutHover.png"
	.	"`nFlag: " 2
}

; ----------------------------
if !InStr(FileExist(PROGRAM.SKINS_FOLDER "\White\Compact"), "D")
	FileCreateDir,% PROGRAM.SKINS_FOLDER "\White\Compact"

if (A_IsCompiled) {
	sourceFileSize := Get_ResourceSize("resources\skins\White\Compact\ToolbarHideoutPress.png")
	FileGetSize, destFileSize, % PROGRAM.SKINS_FOLDER "\White\Compact\ToolbarHideoutPress.png"
}
else {
	FileGetSize, sourceFileSize, resources\skins\White\Compact\ToolbarHideoutPress.png
	FileGetSize, destFileSize, % PROGRAM.SKINS_FOLDER "\White\Compact\ToolbarHideoutPress.png"
}
if (sourceFileSize != destFileSize)
	FileInstall, resources\skins\White\Compact\ToolbarHideoutPress.png, % PROGRAM.SKINS_FOLDER "\White\Compact\ToolbarHideoutPress.png", 1
if (ErrorLevel) {
	AppendToLogs("Failed to extract file!"
	.	"`nSource: resources\skins\White\Compact\ToolbarHideoutPress.png"
	.	"`nDest: " PROGRAM.SKINS_FOLDER "\White\Compact\ToolbarHideoutPress.png"
	.	"`nFlag: " 2)
	errorLog .= "`n`n""Failed to extract file!"
	.	"`nSource: resources\skins\White\Compact\ToolbarHideoutPress.png"
	.	"`nDest: " PROGRAM.SKINS_FOLDER "\White\Compact\ToolbarHideoutPress.png"
	.	"`nFlag: " 2
}

; ----------------------------
if !InStr(FileExist(PROGRAM.SKINS_FOLDER "\White\Compact"), "D")
	FileCreateDir,% PROGRAM.SKINS_FOLDER "\White\Compact"

if (A_IsCompiled) {
	sourceFileSize := Get_ResourceSize("resources\skins\White\Compact\ToolbarSheet.png")
	FileGetSize, destFileSize, % PROGRAM.SKINS_FOLDER "\White\Compact\ToolbarSheet.png"
}
else {
	FileGetSize, sourceFileSize, resources\skins\White\Compact\ToolbarSheet.png
	FileGetSize, destFileSize, % PROGRAM.SKINS_FOLDER "\White\Compact\ToolbarSheet.png"
}
if (sourceFileSize != destFileSize)
	FileInstall, resources\skins\White\Compact\ToolbarSheet.png, % PROGRAM.SKINS_FOLDER "\White\Compact\ToolbarSheet.png", 1
if (ErrorLevel) {
	AppendToLogs("Failed to extract file!"
	.	"`nSource: resources\skins\White\Compact\ToolbarSheet.png"
	.	"`nDest: " PROGRAM.SKINS_FOLDER "\White\Compact\ToolbarSheet.png"
	.	"`nFlag: " 2)
	errorLog .= "`n`n""Failed to extract file!"
	.	"`nSource: resources\skins\White\Compact\ToolbarSheet.png"
	.	"`nDest: " PROGRAM.SKINS_FOLDER "\White\Compact\ToolbarSheet.png"
	.	"`nFlag: " 2
}

; ----------------------------
if !InStr(FileExist(PROGRAM.SKINS_FOLDER "\White\Compact"), "D")
	FileCreateDir,% PROGRAM.SKINS_FOLDER "\White\Compact"

if (A_IsCompiled) {
	sourceFileSize := Get_ResourceSize("resources\skins\White\Compact\ToolbarSheetHover.png")
	FileGetSize, destFileSize, % PROGRAM.SKINS_FOLDER "\White\Compact\ToolbarSheetHover.png"
}
else {
	FileGetSize, sourceFileSize, resources\skins\White\Compact\ToolbarSheetHover.png
	FileGetSize, destFileSize, % PROGRAM.SKINS_FOLDER "\White\Compact\ToolbarSheetHover.png"
}
if (sourceFileSize != destFileSize)
	FileInstall, resources\skins\White\Compact\ToolbarSheetHover.png, % PROGRAM.SKINS_FOLDER "\White\Compact\ToolbarSheetHover.png", 1
if (ErrorLevel) {
	AppendToLogs("Failed to extract file!"
	.	"`nSource: resources\skins\White\Compact\ToolbarSheetHover.png"
	.	"`nDest: " PROGRAM.SKINS_FOLDER "\White\Compact\ToolbarSheetHover.png"
	.	"`nFlag: " 2)
	errorLog .= "`n`n""Failed to extract file!"
	.	"`nSource: resources\skins\White\Compact\ToolbarSheetHover.png"
	.	"`nDest: " PROGRAM.SKINS_FOLDER "\White\Compact\ToolbarSheetHover.png"
	.	"`nFlag: " 2
}

; ----------------------------
if !InStr(FileExist(PROGRAM.SKINS_FOLDER "\White\Compact"), "D")
	FileCreateDir,% PROGRAM.SKINS_FOLDER "\White\Compact"

if (A_IsCompiled) {
	sourceFileSize := Get_ResourceSize("resources\skins\White\Compact\ToolbarSheetPress.png")
	FileGetSize, destFileSize, % PROGRAM.SKINS_FOLDER "\White\Compact\ToolbarSheetPress.png"
}
else {
	FileGetSize, sourceFileSize, resources\skins\White\Compact\ToolbarSheetPress.png
	FileGetSize, destFileSize, % PROGRAM.SKINS_FOLDER "\White\Compact\ToolbarSheetPress.png"
}
if (sourceFileSize != destFileSize)
	FileInstall, resources\skins\White\Compact\ToolbarSheetPress.png, % PROGRAM.SKINS_FOLDER "\White\Compact\ToolbarSheetPress.png", 1
if (ErrorLevel) {
	AppendToLogs("Failed to extract file!"
	.	"`nSource: resources\skins\White\Compact\ToolbarSheetPress.png"
	.	"`nDest: " PROGRAM.SKINS_FOLDER "\White\Compact\ToolbarSheetPress.png"
	.	"`nFlag: " 2)
	errorLog .= "`n`n""Failed to extract file!"
	.	"`nSource: resources\skins\White\Compact\ToolbarSheetPress.png"
	.	"`nDest: " PROGRAM.SKINS_FOLDER "\White\Compact\ToolbarSheetPress.png"
	.	"`nFlag: " 2
}

; ----------------------------
if !InStr(FileExist(PROGRAM.TRANSLATIONS_FOLDER ""), "D")
	FileCreateDir,% PROGRAM.TRANSLATIONS_FOLDER ""

if (A_IsCompiled) {
	sourceFileSize := Get_ResourceSize("resources\translations\chinese_simplified.json")
	FileGetSize, destFileSize, % PROGRAM.TRANSLATIONS_FOLDER "\chinese_simplified.json"
}
else {
	FileGetSize, sourceFileSize, resources\translations\chinese_simplified.json
	FileGetSize, destFileSize, % PROGRAM.TRANSLATIONS_FOLDER "\chinese_simplified.json"
}
if (sourceFileSize != destFileSize)
	FileInstall, resources\translations\chinese_simplified.json, % PROGRAM.TRANSLATIONS_FOLDER "\chinese_simplified.json", 1
if (ErrorLevel) {
	AppendToLogs("Failed to extract file!"
	.	"`nSource: resources\translations\chinese_simplified.json"
	.	"`nDest: " PROGRAM.TRANSLATIONS_FOLDER "\chinese_simplified.json"
	.	"`nFlag: " 2)
	errorLog .= "`n`n""Failed to extract file!"
	.	"`nSource: resources\translations\chinese_simplified.json"
	.	"`nDest: " PROGRAM.TRANSLATIONS_FOLDER "\chinese_simplified.json"
	.	"`nFlag: " 2
}

; ----------------------------
if !InStr(FileExist(PROGRAM.TRANSLATIONS_FOLDER ""), "D")
	FileCreateDir,% PROGRAM.TRANSLATIONS_FOLDER ""

if (A_IsCompiled) {
	sourceFileSize := Get_ResourceSize("resources\translations\chinese_traditional.json")
	FileGetSize, destFileSize, % PROGRAM.TRANSLATIONS_FOLDER "\chinese_traditional.json"
}
else {
	FileGetSize, sourceFileSize, resources\translations\chinese_traditional.json
	FileGetSize, destFileSize, % PROGRAM.TRANSLATIONS_FOLDER "\chinese_traditional.json"
}
if (sourceFileSize != destFileSize)
	FileInstall, resources\translations\chinese_traditional.json, % PROGRAM.TRANSLATIONS_FOLDER "\chinese_traditional.json", 1
if (ErrorLevel) {
	AppendToLogs("Failed to extract file!"
	.	"`nSource: resources\translations\chinese_traditional.json"
	.	"`nDest: " PROGRAM.TRANSLATIONS_FOLDER "\chinese_traditional.json"
	.	"`nFlag: " 2)
	errorLog .= "`n`n""Failed to extract file!"
	.	"`nSource: resources\translations\chinese_traditional.json"
	.	"`nDest: " PROGRAM.TRANSLATIONS_FOLDER "\chinese_traditional.json"
	.	"`nFlag: " 2
}

; ----------------------------
if !InStr(FileExist(PROGRAM.TRANSLATIONS_FOLDER ""), "D")
	FileCreateDir,% PROGRAM.TRANSLATIONS_FOLDER ""

if (A_IsCompiled) {
	sourceFileSize := Get_ResourceSize("resources\translations\english.json")
	FileGetSize, destFileSize, % PROGRAM.TRANSLATIONS_FOLDER "\english.json"
}
else {
	FileGetSize, sourceFileSize, resources\translations\english.json
	FileGetSize, destFileSize, % PROGRAM.TRANSLATIONS_FOLDER "\english.json"
}
if (sourceFileSize != destFileSize)
	FileInstall, resources\translations\english.json, % PROGRAM.TRANSLATIONS_FOLDER "\english.json", 1
if (ErrorLevel) {
	AppendToLogs("Failed to extract file!"
	.	"`nSource: resources\translations\english.json"
	.	"`nDest: " PROGRAM.TRANSLATIONS_FOLDER "\english.json"
	.	"`nFlag: " 2)
	errorLog .= "`n`n""Failed to extract file!"
	.	"`nSource: resources\translations\english.json"
	.	"`nDest: " PROGRAM.TRANSLATIONS_FOLDER "\english.json"
	.	"`nFlag: " 2
}

; ----------------------------
if !InStr(FileExist(PROGRAM.TRANSLATIONS_FOLDER ""), "D")
	FileCreateDir,% PROGRAM.TRANSLATIONS_FOLDER ""

if (A_IsCompiled) {
	sourceFileSize := Get_ResourceSize("resources\translations\french.json")
	FileGetSize, destFileSize, % PROGRAM.TRANSLATIONS_FOLDER "\french.json"
}
else {
	FileGetSize, sourceFileSize, resources\translations\french.json
	FileGetSize, destFileSize, % PROGRAM.TRANSLATIONS_FOLDER "\french.json"
}
if (sourceFileSize != destFileSize)
	FileInstall, resources\translations\french.json, % PROGRAM.TRANSLATIONS_FOLDER "\french.json", 1
if (ErrorLevel) {
	AppendToLogs("Failed to extract file!"
	.	"`nSource: resources\translations\french.json"
	.	"`nDest: " PROGRAM.TRANSLATIONS_FOLDER "\french.json"
	.	"`nFlag: " 2)
	errorLog .= "`n`n""Failed to extract file!"
	.	"`nSource: resources\translations\french.json"
	.	"`nDest: " PROGRAM.TRANSLATIONS_FOLDER "\french.json"
	.	"`nFlag: " 2
}

; ----------------------------
if !InStr(FileExist(PROGRAM.TRANSLATIONS_FOLDER ""), "D")
	FileCreateDir,% PROGRAM.TRANSLATIONS_FOLDER ""

if (A_IsCompiled) {
	sourceFileSize := Get_ResourceSize("resources\translations\russian.json")
	FileGetSize, destFileSize, % PROGRAM.TRANSLATIONS_FOLDER "\russian.json"
}
else {
	FileGetSize, sourceFileSize, resources\translations\russian.json
	FileGetSize, destFileSize, % PROGRAM.TRANSLATIONS_FOLDER "\russian.json"
}
if (sourceFileSize != destFileSize)
	FileInstall, resources\translations\russian.json, % PROGRAM.TRANSLATIONS_FOLDER "\russian.json", 1
if (ErrorLevel) {
	AppendToLogs("Failed to extract file!"
	.	"`nSource: resources\translations\russian.json"
	.	"`nDest: " PROGRAM.TRANSLATIONS_FOLDER "\russian.json"
	.	"`nFlag: " 2)
	errorLog .= "`n`n""Failed to extract file!"
	.	"`nSource: resources\translations\russian.json"
	.	"`nDest: " PROGRAM.TRANSLATIONS_FOLDER "\russian.json"
	.	"`nFlag: " 2
}

; ----------------------------
if !InStr(FileExist(PROGRAM.CURRENCY_IMGS_FOLDER ""), "D")
	FileCreateDir,% PROGRAM.CURRENCY_IMGS_FOLDER ""

if (A_IsCompiled) {
	sourceFileSize := Get_ResourceSize("resources\currency_imgs\Ancient Orb.png")
	FileGetSize, destFileSize, % PROGRAM.CURRENCY_IMGS_FOLDER "\Ancient Orb.png"
}
else {
	FileGetSize, sourceFileSize, resources\currency_imgs\Ancient Orb.png
	FileGetSize, destFileSize, % PROGRAM.CURRENCY_IMGS_FOLDER "\Ancient Orb.png"
}
if (sourceFileSize != destFileSize)
	FileInstall, resources\currency_imgs\Ancient Orb.png, % PROGRAM.CURRENCY_IMGS_FOLDER "\Ancient Orb.png", 1
if (ErrorLevel) {
	AppendToLogs("Failed to extract file!"
	.	"`nSource: resources\currency_imgs\Ancient Orb.png"
	.	"`nDest: " PROGRAM.CURRENCY_IMGS_FOLDER "\Ancient Orb.png"
	.	"`nFlag: " 2)
	errorLog .= "`n`n""Failed to extract file!"
	.	"`nSource: resources\currency_imgs\Ancient Orb.png"
	.	"`nDest: " PROGRAM.CURRENCY_IMGS_FOLDER "\Ancient Orb.png"
	.	"`nFlag: " 2
}

; ----------------------------
if !InStr(FileExist(PROGRAM.CURRENCY_IMGS_FOLDER ""), "D")
	FileCreateDir,% PROGRAM.CURRENCY_IMGS_FOLDER ""

if (A_IsCompiled) {
	sourceFileSize := Get_ResourceSize("resources\currency_imgs\Ancient Reliquary Key.png")
	FileGetSize, destFileSize, % PROGRAM.CURRENCY_IMGS_FOLDER "\Ancient Reliquary Key.png"
}
else {
	FileGetSize, sourceFileSize, resources\currency_imgs\Ancient Reliquary Key.png
	FileGetSize, destFileSize, % PROGRAM.CURRENCY_IMGS_FOLDER "\Ancient Reliquary Key.png"
}
if (sourceFileSize != destFileSize)
	FileInstall, resources\currency_imgs\Ancient Reliquary Key.png, % PROGRAM.CURRENCY_IMGS_FOLDER "\Ancient Reliquary Key.png", 1
if (ErrorLevel) {
	AppendToLogs("Failed to extract file!"
	.	"`nSource: resources\currency_imgs\Ancient Reliquary Key.png"
	.	"`nDest: " PROGRAM.CURRENCY_IMGS_FOLDER "\Ancient Reliquary Key.png"
	.	"`nFlag: " 2)
	errorLog .= "`n`n""Failed to extract file!"
	.	"`nSource: resources\currency_imgs\Ancient Reliquary Key.png"
	.	"`nDest: " PROGRAM.CURRENCY_IMGS_FOLDER "\Ancient Reliquary Key.png"
	.	"`nFlag: " 2
}

; ----------------------------
if !InStr(FileExist(PROGRAM.CURRENCY_IMGS_FOLDER ""), "D")
	FileCreateDir,% PROGRAM.CURRENCY_IMGS_FOLDER ""

if (A_IsCompiled) {
	sourceFileSize := Get_ResourceSize("resources\currency_imgs\Annulment Shard.png")
	FileGetSize, destFileSize, % PROGRAM.CURRENCY_IMGS_FOLDER "\Annulment Shard.png"
}
else {
	FileGetSize, sourceFileSize, resources\currency_imgs\Annulment Shard.png
	FileGetSize, destFileSize, % PROGRAM.CURRENCY_IMGS_FOLDER "\Annulment Shard.png"
}
if (sourceFileSize != destFileSize)
	FileInstall, resources\currency_imgs\Annulment Shard.png, % PROGRAM.CURRENCY_IMGS_FOLDER "\Annulment Shard.png", 1
if (ErrorLevel) {
	AppendToLogs("Failed to extract file!"
	.	"`nSource: resources\currency_imgs\Annulment Shard.png"
	.	"`nDest: " PROGRAM.CURRENCY_IMGS_FOLDER "\Annulment Shard.png"
	.	"`nFlag: " 2)
	errorLog .= "`n`n""Failed to extract file!"
	.	"`nSource: resources\currency_imgs\Annulment Shard.png"
	.	"`nDest: " PROGRAM.CURRENCY_IMGS_FOLDER "\Annulment Shard.png"
	.	"`nFlag: " 2
}

; ----------------------------
if !InStr(FileExist(PROGRAM.CURRENCY_IMGS_FOLDER ""), "D")
	FileCreateDir,% PROGRAM.CURRENCY_IMGS_FOLDER ""

if (A_IsCompiled) {
	sourceFileSize := Get_ResourceSize("resources\currency_imgs\Apprentice Cartographer's Seal.png")
	FileGetSize, destFileSize, % PROGRAM.CURRENCY_IMGS_FOLDER "\Apprentice Cartographer's Seal.png"
}
else {
	FileGetSize, sourceFileSize, resources\currency_imgs\Apprentice Cartographer's Seal.png
	FileGetSize, destFileSize, % PROGRAM.CURRENCY_IMGS_FOLDER "\Apprentice Cartographer's Seal.png"
}
if (sourceFileSize != destFileSize)
	FileInstall, resources\currency_imgs\Apprentice Cartographer's Seal.png, % PROGRAM.CURRENCY_IMGS_FOLDER "\Apprentice Cartographer's Seal.png", 1
if (ErrorLevel) {
	AppendToLogs("Failed to extract file!"
	.	"`nSource: resources\currency_imgs\Apprentice Cartographer's Seal.png"
	.	"`nDest: " PROGRAM.CURRENCY_IMGS_FOLDER "\Apprentice Cartographer's Seal.png"
	.	"`nFlag: " 2)
	errorLog .= "`n`n""Failed to extract file!"
	.	"`nSource: resources\currency_imgs\Apprentice Cartographer's Seal.png"
	.	"`nDest: " PROGRAM.CURRENCY_IMGS_FOLDER "\Apprentice Cartographer's Seal.png"
	.	"`nFlag: " 2
}

; ----------------------------
if !InStr(FileExist(PROGRAM.CURRENCY_IMGS_FOLDER ""), "D")
	FileCreateDir,% PROGRAM.CURRENCY_IMGS_FOLDER ""

if (A_IsCompiled) {
	sourceFileSize := Get_ResourceSize("resources\currency_imgs\Apprentice Cartographer's Sextant.png")
	FileGetSize, destFileSize, % PROGRAM.CURRENCY_IMGS_FOLDER "\Apprentice Cartographer's Sextant.png"
}
else {
	FileGetSize, sourceFileSize, resources\currency_imgs\Apprentice Cartographer's Sextant.png
	FileGetSize, destFileSize, % PROGRAM.CURRENCY_IMGS_FOLDER "\Apprentice Cartographer's Sextant.png"
}
if (sourceFileSize != destFileSize)
	FileInstall, resources\currency_imgs\Apprentice Cartographer's Sextant.png, % PROGRAM.CURRENCY_IMGS_FOLDER "\Apprentice Cartographer's Sextant.png", 1
if (ErrorLevel) {
	AppendToLogs("Failed to extract file!"
	.	"`nSource: resources\currency_imgs\Apprentice Cartographer's Sextant.png"
	.	"`nDest: " PROGRAM.CURRENCY_IMGS_FOLDER "\Apprentice Cartographer's Sextant.png"
	.	"`nFlag: " 2)
	errorLog .= "`n`n""Failed to extract file!"
	.	"`nSource: resources\currency_imgs\Apprentice Cartographer's Sextant.png"
	.	"`nDest: " PROGRAM.CURRENCY_IMGS_FOLDER "\Apprentice Cartographer's Sextant.png"
	.	"`nFlag: " 2
}

; ----------------------------
if !InStr(FileExist(PROGRAM.CURRENCY_IMGS_FOLDER ""), "D")
	FileCreateDir,% PROGRAM.CURRENCY_IMGS_FOLDER ""

if (A_IsCompiled) {
	sourceFileSize := Get_ResourceSize("resources\currency_imgs\Armourer's Scrap.png")
	FileGetSize, destFileSize, % PROGRAM.CURRENCY_IMGS_FOLDER "\Armourer's Scrap.png"
}
else {
	FileGetSize, sourceFileSize, resources\currency_imgs\Armourer's Scrap.png
	FileGetSize, destFileSize, % PROGRAM.CURRENCY_IMGS_FOLDER "\Armourer's Scrap.png"
}
if (sourceFileSize != destFileSize)
	FileInstall, resources\currency_imgs\Armourer's Scrap.png, % PROGRAM.CURRENCY_IMGS_FOLDER "\Armourer's Scrap.png", 1
if (ErrorLevel) {
	AppendToLogs("Failed to extract file!"
	.	"`nSource: resources\currency_imgs\Armourer's Scrap.png"
	.	"`nDest: " PROGRAM.CURRENCY_IMGS_FOLDER "\Armourer's Scrap.png"
	.	"`nFlag: " 2)
	errorLog .= "`n`n""Failed to extract file!"
	.	"`nSource: resources\currency_imgs\Armourer's Scrap.png"
	.	"`nDest: " PROGRAM.CURRENCY_IMGS_FOLDER "\Armourer's Scrap.png"
	.	"`nFlag: " 2
}

; ----------------------------
if !InStr(FileExist(PROGRAM.CURRENCY_IMGS_FOLDER ""), "D")
	FileCreateDir,% PROGRAM.CURRENCY_IMGS_FOLDER ""

if (A_IsCompiled) {
	sourceFileSize := Get_ResourceSize("resources\currency_imgs\Blacksmith's Whetstone.png")
	FileGetSize, destFileSize, % PROGRAM.CURRENCY_IMGS_FOLDER "\Blacksmith's Whetstone.png"
}
else {
	FileGetSize, sourceFileSize, resources\currency_imgs\Blacksmith's Whetstone.png
	FileGetSize, destFileSize, % PROGRAM.CURRENCY_IMGS_FOLDER "\Blacksmith's Whetstone.png"
}
if (sourceFileSize != destFileSize)
	FileInstall, resources\currency_imgs\Blacksmith's Whetstone.png, % PROGRAM.CURRENCY_IMGS_FOLDER "\Blacksmith's Whetstone.png", 1
if (ErrorLevel) {
	AppendToLogs("Failed to extract file!"
	.	"`nSource: resources\currency_imgs\Blacksmith's Whetstone.png"
	.	"`nDest: " PROGRAM.CURRENCY_IMGS_FOLDER "\Blacksmith's Whetstone.png"
	.	"`nFlag: " 2)
	errorLog .= "`n`n""Failed to extract file!"
	.	"`nSource: resources\currency_imgs\Blacksmith's Whetstone.png"
	.	"`nDest: " PROGRAM.CURRENCY_IMGS_FOLDER "\Blacksmith's Whetstone.png"
	.	"`nFlag: " 2
}

; ----------------------------
if !InStr(FileExist(PROGRAM.CURRENCY_IMGS_FOLDER ""), "D")
	FileCreateDir,% PROGRAM.CURRENCY_IMGS_FOLDER ""

if (A_IsCompiled) {
	sourceFileSize := Get_ResourceSize("resources\currency_imgs\Blessed Orb.png")
	FileGetSize, destFileSize, % PROGRAM.CURRENCY_IMGS_FOLDER "\Blessed Orb.png"
}
else {
	FileGetSize, sourceFileSize, resources\currency_imgs\Blessed Orb.png
	FileGetSize, destFileSize, % PROGRAM.CURRENCY_IMGS_FOLDER "\Blessed Orb.png"
}
if (sourceFileSize != destFileSize)
	FileInstall, resources\currency_imgs\Blessed Orb.png, % PROGRAM.CURRENCY_IMGS_FOLDER "\Blessed Orb.png", 1
if (ErrorLevel) {
	AppendToLogs("Failed to extract file!"
	.	"`nSource: resources\currency_imgs\Blessed Orb.png"
	.	"`nDest: " PROGRAM.CURRENCY_IMGS_FOLDER "\Blessed Orb.png"
	.	"`nFlag: " 2)
	errorLog .= "`n`n""Failed to extract file!"
	.	"`nSource: resources\currency_imgs\Blessed Orb.png"
	.	"`nDest: " PROGRAM.CURRENCY_IMGS_FOLDER "\Blessed Orb.png"
	.	"`nFlag: " 2
}

; ----------------------------
if !InStr(FileExist(PROGRAM.CURRENCY_IMGS_FOLDER ""), "D")
	FileCreateDir,% PROGRAM.CURRENCY_IMGS_FOLDER ""

if (A_IsCompiled) {
	sourceFileSize := Get_ResourceSize("resources\currency_imgs\Blessing of Chayula.png")
	FileGetSize, destFileSize, % PROGRAM.CURRENCY_IMGS_FOLDER "\Blessing of Chayula.png"
}
else {
	FileGetSize, sourceFileSize, resources\currency_imgs\Blessing of Chayula.png
	FileGetSize, destFileSize, % PROGRAM.CURRENCY_IMGS_FOLDER "\Blessing of Chayula.png"
}
if (sourceFileSize != destFileSize)
	FileInstall, resources\currency_imgs\Blessing of Chayula.png, % PROGRAM.CURRENCY_IMGS_FOLDER "\Blessing of Chayula.png", 1
if (ErrorLevel) {
	AppendToLogs("Failed to extract file!"
	.	"`nSource: resources\currency_imgs\Blessing of Chayula.png"
	.	"`nDest: " PROGRAM.CURRENCY_IMGS_FOLDER "\Blessing of Chayula.png"
	.	"`nFlag: " 2)
	errorLog .= "`n`n""Failed to extract file!"
	.	"`nSource: resources\currency_imgs\Blessing of Chayula.png"
	.	"`nDest: " PROGRAM.CURRENCY_IMGS_FOLDER "\Blessing of Chayula.png"
	.	"`nFlag: " 2
}

; ----------------------------
if !InStr(FileExist(PROGRAM.CURRENCY_IMGS_FOLDER ""), "D")
	FileCreateDir,% PROGRAM.CURRENCY_IMGS_FOLDER ""

if (A_IsCompiled) {
	sourceFileSize := Get_ResourceSize("resources\currency_imgs\Blessing of Esh.png")
	FileGetSize, destFileSize, % PROGRAM.CURRENCY_IMGS_FOLDER "\Blessing of Esh.png"
}
else {
	FileGetSize, sourceFileSize, resources\currency_imgs\Blessing of Esh.png
	FileGetSize, destFileSize, % PROGRAM.CURRENCY_IMGS_FOLDER "\Blessing of Esh.png"
}
if (sourceFileSize != destFileSize)
	FileInstall, resources\currency_imgs\Blessing of Esh.png, % PROGRAM.CURRENCY_IMGS_FOLDER "\Blessing of Esh.png", 1
if (ErrorLevel) {
	AppendToLogs("Failed to extract file!"
	.	"`nSource: resources\currency_imgs\Blessing of Esh.png"
	.	"`nDest: " PROGRAM.CURRENCY_IMGS_FOLDER "\Blessing of Esh.png"
	.	"`nFlag: " 2)
	errorLog .= "`n`n""Failed to extract file!"
	.	"`nSource: resources\currency_imgs\Blessing of Esh.png"
	.	"`nDest: " PROGRAM.CURRENCY_IMGS_FOLDER "\Blessing of Esh.png"
	.	"`nFlag: " 2
}

; ----------------------------
if !InStr(FileExist(PROGRAM.CURRENCY_IMGS_FOLDER ""), "D")
	FileCreateDir,% PROGRAM.CURRENCY_IMGS_FOLDER ""

if (A_IsCompiled) {
	sourceFileSize := Get_ResourceSize("resources\currency_imgs\Blessing of Tul.png")
	FileGetSize, destFileSize, % PROGRAM.CURRENCY_IMGS_FOLDER "\Blessing of Tul.png"
}
else {
	FileGetSize, sourceFileSize, resources\currency_imgs\Blessing of Tul.png
	FileGetSize, destFileSize, % PROGRAM.CURRENCY_IMGS_FOLDER "\Blessing of Tul.png"
}
if (sourceFileSize != destFileSize)
	FileInstall, resources\currency_imgs\Blessing of Tul.png, % PROGRAM.CURRENCY_IMGS_FOLDER "\Blessing of Tul.png", 1
if (ErrorLevel) {
	AppendToLogs("Failed to extract file!"
	.	"`nSource: resources\currency_imgs\Blessing of Tul.png"
	.	"`nDest: " PROGRAM.CURRENCY_IMGS_FOLDER "\Blessing of Tul.png"
	.	"`nFlag: " 2)
	errorLog .= "`n`n""Failed to extract file!"
	.	"`nSource: resources\currency_imgs\Blessing of Tul.png"
	.	"`nDest: " PROGRAM.CURRENCY_IMGS_FOLDER "\Blessing of Tul.png"
	.	"`nFlag: " 2
}

; ----------------------------
if !InStr(FileExist(PROGRAM.CURRENCY_IMGS_FOLDER ""), "D")
	FileCreateDir,% PROGRAM.CURRENCY_IMGS_FOLDER ""

if (A_IsCompiled) {
	sourceFileSize := Get_ResourceSize("resources\currency_imgs\Blessing of Uul-Netol.png")
	FileGetSize, destFileSize, % PROGRAM.CURRENCY_IMGS_FOLDER "\Blessing of Uul-Netol.png"
}
else {
	FileGetSize, sourceFileSize, resources\currency_imgs\Blessing of Uul-Netol.png
	FileGetSize, destFileSize, % PROGRAM.CURRENCY_IMGS_FOLDER "\Blessing of Uul-Netol.png"
}
if (sourceFileSize != destFileSize)
	FileInstall, resources\currency_imgs\Blessing of Uul-Netol.png, % PROGRAM.CURRENCY_IMGS_FOLDER "\Blessing of Uul-Netol.png", 1
if (ErrorLevel) {
	AppendToLogs("Failed to extract file!"
	.	"`nSource: resources\currency_imgs\Blessing of Uul-Netol.png"
	.	"`nDest: " PROGRAM.CURRENCY_IMGS_FOLDER "\Blessing of Uul-Netol.png"
	.	"`nFlag: " 2)
	errorLog .= "`n`n""Failed to extract file!"
	.	"`nSource: resources\currency_imgs\Blessing of Uul-Netol.png"
	.	"`nDest: " PROGRAM.CURRENCY_IMGS_FOLDER "\Blessing of Uul-Netol.png"
	.	"`nFlag: " 2
}

; ----------------------------
if !InStr(FileExist(PROGRAM.CURRENCY_IMGS_FOLDER ""), "D")
	FileCreateDir,% PROGRAM.CURRENCY_IMGS_FOLDER ""

if (A_IsCompiled) {
	sourceFileSize := Get_ResourceSize("resources\currency_imgs\Blessing of Xoph.png")
	FileGetSize, destFileSize, % PROGRAM.CURRENCY_IMGS_FOLDER "\Blessing of Xoph.png"
}
else {
	FileGetSize, sourceFileSize, resources\currency_imgs\Blessing of Xoph.png
	FileGetSize, destFileSize, % PROGRAM.CURRENCY_IMGS_FOLDER "\Blessing of Xoph.png"
}
if (sourceFileSize != destFileSize)
	FileInstall, resources\currency_imgs\Blessing of Xoph.png, % PROGRAM.CURRENCY_IMGS_FOLDER "\Blessing of Xoph.png", 1
if (ErrorLevel) {
	AppendToLogs("Failed to extract file!"
	.	"`nSource: resources\currency_imgs\Blessing of Xoph.png"
	.	"`nDest: " PROGRAM.CURRENCY_IMGS_FOLDER "\Blessing of Xoph.png"
	.	"`nFlag: " 2)
	errorLog .= "`n`n""Failed to extract file!"
	.	"`nSource: resources\currency_imgs\Blessing of Xoph.png"
	.	"`nDest: " PROGRAM.CURRENCY_IMGS_FOLDER "\Blessing of Xoph.png"
	.	"`nFlag: " 2
}

; ----------------------------
if !InStr(FileExist(PROGRAM.CURRENCY_IMGS_FOLDER ""), "D")
	FileCreateDir,% PROGRAM.CURRENCY_IMGS_FOLDER ""

if (A_IsCompiled) {
	sourceFileSize := Get_ResourceSize("resources\currency_imgs\Cartographer's Chisel.png")
	FileGetSize, destFileSize, % PROGRAM.CURRENCY_IMGS_FOLDER "\Cartographer's Chisel.png"
}
else {
	FileGetSize, sourceFileSize, resources\currency_imgs\Cartographer's Chisel.png
	FileGetSize, destFileSize, % PROGRAM.CURRENCY_IMGS_FOLDER "\Cartographer's Chisel.png"
}
if (sourceFileSize != destFileSize)
	FileInstall, resources\currency_imgs\Cartographer's Chisel.png, % PROGRAM.CURRENCY_IMGS_FOLDER "\Cartographer's Chisel.png", 1
if (ErrorLevel) {
	AppendToLogs("Failed to extract file!"
	.	"`nSource: resources\currency_imgs\Cartographer's Chisel.png"
	.	"`nDest: " PROGRAM.CURRENCY_IMGS_FOLDER "\Cartographer's Chisel.png"
	.	"`nFlag: " 2)
	errorLog .= "`n`n""Failed to extract file!"
	.	"`nSource: resources\currency_imgs\Cartographer's Chisel.png"
	.	"`nDest: " PROGRAM.CURRENCY_IMGS_FOLDER "\Cartographer's Chisel.png"
	.	"`nFlag: " 2
}

; ----------------------------
if !InStr(FileExist(PROGRAM.CURRENCY_IMGS_FOLDER ""), "D")
	FileCreateDir,% PROGRAM.CURRENCY_IMGS_FOLDER ""

if (A_IsCompiled) {
	sourceFileSize := Get_ResourceSize("resources\currency_imgs\Chaos Orb.png")
	FileGetSize, destFileSize, % PROGRAM.CURRENCY_IMGS_FOLDER "\Chaos Orb.png"
}
else {
	FileGetSize, sourceFileSize, resources\currency_imgs\Chaos Orb.png
	FileGetSize, destFileSize, % PROGRAM.CURRENCY_IMGS_FOLDER "\Chaos Orb.png"
}
if (sourceFileSize != destFileSize)
	FileInstall, resources\currency_imgs\Chaos Orb.png, % PROGRAM.CURRENCY_IMGS_FOLDER "\Chaos Orb.png", 1
if (ErrorLevel) {
	AppendToLogs("Failed to extract file!"
	.	"`nSource: resources\currency_imgs\Chaos Orb.png"
	.	"`nDest: " PROGRAM.CURRENCY_IMGS_FOLDER "\Chaos Orb.png"
	.	"`nFlag: " 2)
	errorLog .= "`n`n""Failed to extract file!"
	.	"`nSource: resources\currency_imgs\Chaos Orb.png"
	.	"`nDest: " PROGRAM.CURRENCY_IMGS_FOLDER "\Chaos Orb.png"
	.	"`nFlag: " 2
}

; ----------------------------
if !InStr(FileExist(PROGRAM.CURRENCY_IMGS_FOLDER ""), "D")
	FileCreateDir,% PROGRAM.CURRENCY_IMGS_FOLDER ""

if (A_IsCompiled) {
	sourceFileSize := Get_ResourceSize("resources\currency_imgs\Chayula's Breachstone.png")
	FileGetSize, destFileSize, % PROGRAM.CURRENCY_IMGS_FOLDER "\Chayula's Breachstone.png"
}
else {
	FileGetSize, sourceFileSize, resources\currency_imgs\Chayula's Breachstone.png
	FileGetSize, destFileSize, % PROGRAM.CURRENCY_IMGS_FOLDER "\Chayula's Breachstone.png"
}
if (sourceFileSize != destFileSize)
	FileInstall, resources\currency_imgs\Chayula's Breachstone.png, % PROGRAM.CURRENCY_IMGS_FOLDER "\Chayula's Breachstone.png", 1
if (ErrorLevel) {
	AppendToLogs("Failed to extract file!"
	.	"`nSource: resources\currency_imgs\Chayula's Breachstone.png"
	.	"`nDest: " PROGRAM.CURRENCY_IMGS_FOLDER "\Chayula's Breachstone.png"
	.	"`nFlag: " 2)
	errorLog .= "`n`n""Failed to extract file!"
	.	"`nSource: resources\currency_imgs\Chayula's Breachstone.png"
	.	"`nDest: " PROGRAM.CURRENCY_IMGS_FOLDER "\Chayula's Breachstone.png"
	.	"`nFlag: " 2
}

; ----------------------------
if !InStr(FileExist(PROGRAM.CURRENCY_IMGS_FOLDER ""), "D")
	FileCreateDir,% PROGRAM.CURRENCY_IMGS_FOLDER ""

if (A_IsCompiled) {
	sourceFileSize := Get_ResourceSize("resources\currency_imgs\Chayula's Charged Breachstone.png")
	FileGetSize, destFileSize, % PROGRAM.CURRENCY_IMGS_FOLDER "\Chayula's Charged Breachstone.png"
}
else {
	FileGetSize, sourceFileSize, resources\currency_imgs\Chayula's Charged Breachstone.png
	FileGetSize, destFileSize, % PROGRAM.CURRENCY_IMGS_FOLDER "\Chayula's Charged Breachstone.png"
}
if (sourceFileSize != destFileSize)
	FileInstall, resources\currency_imgs\Chayula's Charged Breachstone.png, % PROGRAM.CURRENCY_IMGS_FOLDER "\Chayula's Charged Breachstone.png", 1
if (ErrorLevel) {
	AppendToLogs("Failed to extract file!"
	.	"`nSource: resources\currency_imgs\Chayula's Charged Breachstone.png"
	.	"`nDest: " PROGRAM.CURRENCY_IMGS_FOLDER "\Chayula's Charged Breachstone.png"
	.	"`nFlag: " 2)
	errorLog .= "`n`n""Failed to extract file!"
	.	"`nSource: resources\currency_imgs\Chayula's Charged Breachstone.png"
	.	"`nDest: " PROGRAM.CURRENCY_IMGS_FOLDER "\Chayula's Charged Breachstone.png"
	.	"`nFlag: " 2
}

; ----------------------------
if !InStr(FileExist(PROGRAM.CURRENCY_IMGS_FOLDER ""), "D")
	FileCreateDir,% PROGRAM.CURRENCY_IMGS_FOLDER ""

if (A_IsCompiled) {
	sourceFileSize := Get_ResourceSize("resources\currency_imgs\Chayula's Enriched Breachstone.png")
	FileGetSize, destFileSize, % PROGRAM.CURRENCY_IMGS_FOLDER "\Chayula's Enriched Breachstone.png"
}
else {
	FileGetSize, sourceFileSize, resources\currency_imgs\Chayula's Enriched Breachstone.png
	FileGetSize, destFileSize, % PROGRAM.CURRENCY_IMGS_FOLDER "\Chayula's Enriched Breachstone.png"
}
if (sourceFileSize != destFileSize)
	FileInstall, resources\currency_imgs\Chayula's Enriched Breachstone.png, % PROGRAM.CURRENCY_IMGS_FOLDER "\Chayula's Enriched Breachstone.png", 1
if (ErrorLevel) {
	AppendToLogs("Failed to extract file!"
	.	"`nSource: resources\currency_imgs\Chayula's Enriched Breachstone.png"
	.	"`nDest: " PROGRAM.CURRENCY_IMGS_FOLDER "\Chayula's Enriched Breachstone.png"
	.	"`nFlag: " 2)
	errorLog .= "`n`n""Failed to extract file!"
	.	"`nSource: resources\currency_imgs\Chayula's Enriched Breachstone.png"
	.	"`nDest: " PROGRAM.CURRENCY_IMGS_FOLDER "\Chayula's Enriched Breachstone.png"
	.	"`nFlag: " 2
}

; ----------------------------
if !InStr(FileExist(PROGRAM.CURRENCY_IMGS_FOLDER ""), "D")
	FileCreateDir,% PROGRAM.CURRENCY_IMGS_FOLDER ""

if (A_IsCompiled) {
	sourceFileSize := Get_ResourceSize("resources\currency_imgs\Chayula's Pure Breachstone.png")
	FileGetSize, destFileSize, % PROGRAM.CURRENCY_IMGS_FOLDER "\Chayula's Pure Breachstone.png"
}
else {
	FileGetSize, sourceFileSize, resources\currency_imgs\Chayula's Pure Breachstone.png
	FileGetSize, destFileSize, % PROGRAM.CURRENCY_IMGS_FOLDER "\Chayula's Pure Breachstone.png"
}
if (sourceFileSize != destFileSize)
	FileInstall, resources\currency_imgs\Chayula's Pure Breachstone.png, % PROGRAM.CURRENCY_IMGS_FOLDER "\Chayula's Pure Breachstone.png", 1
if (ErrorLevel) {
	AppendToLogs("Failed to extract file!"
	.	"`nSource: resources\currency_imgs\Chayula's Pure Breachstone.png"
	.	"`nDest: " PROGRAM.CURRENCY_IMGS_FOLDER "\Chayula's Pure Breachstone.png"
	.	"`nFlag: " 2)
	errorLog .= "`n`n""Failed to extract file!"
	.	"`nSource: resources\currency_imgs\Chayula's Pure Breachstone.png"
	.	"`nDest: " PROGRAM.CURRENCY_IMGS_FOLDER "\Chayula's Pure Breachstone.png"
	.	"`nFlag: " 2
}

; ----------------------------
if !InStr(FileExist(PROGRAM.CURRENCY_IMGS_FOLDER ""), "D")
	FileCreateDir,% PROGRAM.CURRENCY_IMGS_FOLDER ""

if (A_IsCompiled) {
	sourceFileSize := Get_ResourceSize("resources\currency_imgs\Chromatic Orb.png")
	FileGetSize, destFileSize, % PROGRAM.CURRENCY_IMGS_FOLDER "\Chromatic Orb.png"
}
else {
	FileGetSize, sourceFileSize, resources\currency_imgs\Chromatic Orb.png
	FileGetSize, destFileSize, % PROGRAM.CURRENCY_IMGS_FOLDER "\Chromatic Orb.png"
}
if (sourceFileSize != destFileSize)
	FileInstall, resources\currency_imgs\Chromatic Orb.png, % PROGRAM.CURRENCY_IMGS_FOLDER "\Chromatic Orb.png", 1
if (ErrorLevel) {
	AppendToLogs("Failed to extract file!"
	.	"`nSource: resources\currency_imgs\Chromatic Orb.png"
	.	"`nDest: " PROGRAM.CURRENCY_IMGS_FOLDER "\Chromatic Orb.png"
	.	"`nFlag: " 2)
	errorLog .= "`n`n""Failed to extract file!"
	.	"`nSource: resources\currency_imgs\Chromatic Orb.png"
	.	"`nDest: " PROGRAM.CURRENCY_IMGS_FOLDER "\Chromatic Orb.png"
	.	"`nFlag: " 2
}

; ----------------------------
if !InStr(FileExist(PROGRAM.CURRENCY_IMGS_FOLDER ""), "D")
	FileCreateDir,% PROGRAM.CURRENCY_IMGS_FOLDER ""

if (A_IsCompiled) {
	sourceFileSize := Get_ResourceSize("resources\currency_imgs\Divine Orb.png")
	FileGetSize, destFileSize, % PROGRAM.CURRENCY_IMGS_FOLDER "\Divine Orb.png"
}
else {
	FileGetSize, sourceFileSize, resources\currency_imgs\Divine Orb.png
	FileGetSize, destFileSize, % PROGRAM.CURRENCY_IMGS_FOLDER "\Divine Orb.png"
}
if (sourceFileSize != destFileSize)
	FileInstall, resources\currency_imgs\Divine Orb.png, % PROGRAM.CURRENCY_IMGS_FOLDER "\Divine Orb.png", 1
if (ErrorLevel) {
	AppendToLogs("Failed to extract file!"
	.	"`nSource: resources\currency_imgs\Divine Orb.png"
	.	"`nDest: " PROGRAM.CURRENCY_IMGS_FOLDER "\Divine Orb.png"
	.	"`nFlag: " 2)
	errorLog .= "`n`n""Failed to extract file!"
	.	"`nSource: resources\currency_imgs\Divine Orb.png"
	.	"`nDest: " PROGRAM.CURRENCY_IMGS_FOLDER "\Divine Orb.png"
	.	"`nFlag: " 2
}

; ----------------------------
if !InStr(FileExist(PROGRAM.CURRENCY_IMGS_FOLDER ""), "D")
	FileCreateDir,% PROGRAM.CURRENCY_IMGS_FOLDER ""

if (A_IsCompiled) {
	sourceFileSize := Get_ResourceSize("resources\currency_imgs\Divine Vessel.png")
	FileGetSize, destFileSize, % PROGRAM.CURRENCY_IMGS_FOLDER "\Divine Vessel.png"
}
else {
	FileGetSize, sourceFileSize, resources\currency_imgs\Divine Vessel.png
	FileGetSize, destFileSize, % PROGRAM.CURRENCY_IMGS_FOLDER "\Divine Vessel.png"
}
if (sourceFileSize != destFileSize)
	FileInstall, resources\currency_imgs\Divine Vessel.png, % PROGRAM.CURRENCY_IMGS_FOLDER "\Divine Vessel.png", 1
if (ErrorLevel) {
	AppendToLogs("Failed to extract file!"
	.	"`nSource: resources\currency_imgs\Divine Vessel.png"
	.	"`nDest: " PROGRAM.CURRENCY_IMGS_FOLDER "\Divine Vessel.png"
	.	"`nFlag: " 2)
	errorLog .= "`n`n""Failed to extract file!"
	.	"`nSource: resources\currency_imgs\Divine Vessel.png"
	.	"`nDest: " PROGRAM.CURRENCY_IMGS_FOLDER "\Divine Vessel.png"
	.	"`nFlag: " 2
}

; ----------------------------
if !InStr(FileExist(PROGRAM.CURRENCY_IMGS_FOLDER ""), "D")
	FileCreateDir,% PROGRAM.CURRENCY_IMGS_FOLDER ""

if (A_IsCompiled) {
	sourceFileSize := Get_ResourceSize("resources\currency_imgs\Eber's Key.png")
	FileGetSize, destFileSize, % PROGRAM.CURRENCY_IMGS_FOLDER "\Eber's Key.png"
}
else {
	FileGetSize, sourceFileSize, resources\currency_imgs\Eber's Key.png
	FileGetSize, destFileSize, % PROGRAM.CURRENCY_IMGS_FOLDER "\Eber's Key.png"
}
if (sourceFileSize != destFileSize)
	FileInstall, resources\currency_imgs\Eber's Key.png, % PROGRAM.CURRENCY_IMGS_FOLDER "\Eber's Key.png", 1
if (ErrorLevel) {
	AppendToLogs("Failed to extract file!"
	.	"`nSource: resources\currency_imgs\Eber's Key.png"
	.	"`nDest: " PROGRAM.CURRENCY_IMGS_FOLDER "\Eber's Key.png"
	.	"`nFlag: " 2)
	errorLog .= "`n`n""Failed to extract file!"
	.	"`nSource: resources\currency_imgs\Eber's Key.png"
	.	"`nDest: " PROGRAM.CURRENCY_IMGS_FOLDER "\Eber's Key.png"
	.	"`nFlag: " 2
}

; ----------------------------
if !InStr(FileExist(PROGRAM.CURRENCY_IMGS_FOLDER ""), "D")
	FileCreateDir,% PROGRAM.CURRENCY_IMGS_FOLDER ""

if (A_IsCompiled) {
	sourceFileSize := Get_ResourceSize("resources\currency_imgs\Engineer's Orb.png")
	FileGetSize, destFileSize, % PROGRAM.CURRENCY_IMGS_FOLDER "\Engineer's Orb.png"
}
else {
	FileGetSize, sourceFileSize, resources\currency_imgs\Engineer's Orb.png
	FileGetSize, destFileSize, % PROGRAM.CURRENCY_IMGS_FOLDER "\Engineer's Orb.png"
}
if (sourceFileSize != destFileSize)
	FileInstall, resources\currency_imgs\Engineer's Orb.png, % PROGRAM.CURRENCY_IMGS_FOLDER "\Engineer's Orb.png", 1
if (ErrorLevel) {
	AppendToLogs("Failed to extract file!"
	.	"`nSource: resources\currency_imgs\Engineer's Orb.png"
	.	"`nDest: " PROGRAM.CURRENCY_IMGS_FOLDER "\Engineer's Orb.png"
	.	"`nFlag: " 2)
	errorLog .= "`n`n""Failed to extract file!"
	.	"`nSource: resources\currency_imgs\Engineer's Orb.png"
	.	"`nDest: " PROGRAM.CURRENCY_IMGS_FOLDER "\Engineer's Orb.png"
	.	"`nFlag: " 2
}

; ----------------------------
if !InStr(FileExist(PROGRAM.CURRENCY_IMGS_FOLDER ""), "D")
	FileCreateDir,% PROGRAM.CURRENCY_IMGS_FOLDER ""

if (A_IsCompiled) {
	sourceFileSize := Get_ResourceSize("resources\currency_imgs\Esh's Breachstone.png")
	FileGetSize, destFileSize, % PROGRAM.CURRENCY_IMGS_FOLDER "\Esh's Breachstone.png"
}
else {
	FileGetSize, sourceFileSize, resources\currency_imgs\Esh's Breachstone.png
	FileGetSize, destFileSize, % PROGRAM.CURRENCY_IMGS_FOLDER "\Esh's Breachstone.png"
}
if (sourceFileSize != destFileSize)
	FileInstall, resources\currency_imgs\Esh's Breachstone.png, % PROGRAM.CURRENCY_IMGS_FOLDER "\Esh's Breachstone.png", 1
if (ErrorLevel) {
	AppendToLogs("Failed to extract file!"
	.	"`nSource: resources\currency_imgs\Esh's Breachstone.png"
	.	"`nDest: " PROGRAM.CURRENCY_IMGS_FOLDER "\Esh's Breachstone.png"
	.	"`nFlag: " 2)
	errorLog .= "`n`n""Failed to extract file!"
	.	"`nSource: resources\currency_imgs\Esh's Breachstone.png"
	.	"`nDest: " PROGRAM.CURRENCY_IMGS_FOLDER "\Esh's Breachstone.png"
	.	"`nFlag: " 2
}

; ----------------------------
if !InStr(FileExist(PROGRAM.CURRENCY_IMGS_FOLDER ""), "D")
	FileCreateDir,% PROGRAM.CURRENCY_IMGS_FOLDER ""

if (A_IsCompiled) {
	sourceFileSize := Get_ResourceSize("resources\currency_imgs\Esh's Charged Breachstone.png")
	FileGetSize, destFileSize, % PROGRAM.CURRENCY_IMGS_FOLDER "\Esh's Charged Breachstone.png"
}
else {
	FileGetSize, sourceFileSize, resources\currency_imgs\Esh's Charged Breachstone.png
	FileGetSize, destFileSize, % PROGRAM.CURRENCY_IMGS_FOLDER "\Esh's Charged Breachstone.png"
}
if (sourceFileSize != destFileSize)
	FileInstall, resources\currency_imgs\Esh's Charged Breachstone.png, % PROGRAM.CURRENCY_IMGS_FOLDER "\Esh's Charged Breachstone.png", 1
if (ErrorLevel) {
	AppendToLogs("Failed to extract file!"
	.	"`nSource: resources\currency_imgs\Esh's Charged Breachstone.png"
	.	"`nDest: " PROGRAM.CURRENCY_IMGS_FOLDER "\Esh's Charged Breachstone.png"
	.	"`nFlag: " 2)
	errorLog .= "`n`n""Failed to extract file!"
	.	"`nSource: resources\currency_imgs\Esh's Charged Breachstone.png"
	.	"`nDest: " PROGRAM.CURRENCY_IMGS_FOLDER "\Esh's Charged Breachstone.png"
	.	"`nFlag: " 2
}

; ----------------------------
if !InStr(FileExist(PROGRAM.CURRENCY_IMGS_FOLDER ""), "D")
	FileCreateDir,% PROGRAM.CURRENCY_IMGS_FOLDER ""

if (A_IsCompiled) {
	sourceFileSize := Get_ResourceSize("resources\currency_imgs\Esh's Enriched Breachstone.png")
	FileGetSize, destFileSize, % PROGRAM.CURRENCY_IMGS_FOLDER "\Esh's Enriched Breachstone.png"
}
else {
	FileGetSize, sourceFileSize, resources\currency_imgs\Esh's Enriched Breachstone.png
	FileGetSize, destFileSize, % PROGRAM.CURRENCY_IMGS_FOLDER "\Esh's Enriched Breachstone.png"
}
if (sourceFileSize != destFileSize)
	FileInstall, resources\currency_imgs\Esh's Enriched Breachstone.png, % PROGRAM.CURRENCY_IMGS_FOLDER "\Esh's Enriched Breachstone.png", 1
if (ErrorLevel) {
	AppendToLogs("Failed to extract file!"
	.	"`nSource: resources\currency_imgs\Esh's Enriched Breachstone.png"
	.	"`nDest: " PROGRAM.CURRENCY_IMGS_FOLDER "\Esh's Enriched Breachstone.png"
	.	"`nFlag: " 2)
	errorLog .= "`n`n""Failed to extract file!"
	.	"`nSource: resources\currency_imgs\Esh's Enriched Breachstone.png"
	.	"`nDest: " PROGRAM.CURRENCY_IMGS_FOLDER "\Esh's Enriched Breachstone.png"
	.	"`nFlag: " 2
}

; ----------------------------
if !InStr(FileExist(PROGRAM.CURRENCY_IMGS_FOLDER ""), "D")
	FileCreateDir,% PROGRAM.CURRENCY_IMGS_FOLDER ""

if (A_IsCompiled) {
	sourceFileSize := Get_ResourceSize("resources\currency_imgs\Esh's Pure Breachstone.png")
	FileGetSize, destFileSize, % PROGRAM.CURRENCY_IMGS_FOLDER "\Esh's Pure Breachstone.png"
}
else {
	FileGetSize, sourceFileSize, resources\currency_imgs\Esh's Pure Breachstone.png
	FileGetSize, destFileSize, % PROGRAM.CURRENCY_IMGS_FOLDER "\Esh's Pure Breachstone.png"
}
if (sourceFileSize != destFileSize)
	FileInstall, resources\currency_imgs\Esh's Pure Breachstone.png, % PROGRAM.CURRENCY_IMGS_FOLDER "\Esh's Pure Breachstone.png", 1
if (ErrorLevel) {
	AppendToLogs("Failed to extract file!"
	.	"`nSource: resources\currency_imgs\Esh's Pure Breachstone.png"
	.	"`nDest: " PROGRAM.CURRENCY_IMGS_FOLDER "\Esh's Pure Breachstone.png"
	.	"`nFlag: " 2)
	errorLog .= "`n`n""Failed to extract file!"
	.	"`nSource: resources\currency_imgs\Esh's Pure Breachstone.png"
	.	"`nDest: " PROGRAM.CURRENCY_IMGS_FOLDER "\Esh's Pure Breachstone.png"
	.	"`nFlag: " 2
}

; ----------------------------
if !InStr(FileExist(PROGRAM.CURRENCY_IMGS_FOLDER ""), "D")
	FileCreateDir,% PROGRAM.CURRENCY_IMGS_FOLDER ""

if (A_IsCompiled) {
	sourceFileSize := Get_ResourceSize("resources\currency_imgs\Eternal Orb.png")
	FileGetSize, destFileSize, % PROGRAM.CURRENCY_IMGS_FOLDER "\Eternal Orb.png"
}
else {
	FileGetSize, sourceFileSize, resources\currency_imgs\Eternal Orb.png
	FileGetSize, destFileSize, % PROGRAM.CURRENCY_IMGS_FOLDER "\Eternal Orb.png"
}
if (sourceFileSize != destFileSize)
	FileInstall, resources\currency_imgs\Eternal Orb.png, % PROGRAM.CURRENCY_IMGS_FOLDER "\Eternal Orb.png", 1
if (ErrorLevel) {
	AppendToLogs("Failed to extract file!"
	.	"`nSource: resources\currency_imgs\Eternal Orb.png"
	.	"`nDest: " PROGRAM.CURRENCY_IMGS_FOLDER "\Eternal Orb.png"
	.	"`nFlag: " 2)
	errorLog .= "`n`n""Failed to extract file!"
	.	"`nSource: resources\currency_imgs\Eternal Orb.png"
	.	"`nDest: " PROGRAM.CURRENCY_IMGS_FOLDER "\Eternal Orb.png"
	.	"`nFlag: " 2
}

; ----------------------------
if !InStr(FileExist(PROGRAM.CURRENCY_IMGS_FOLDER ""), "D")
	FileCreateDir,% PROGRAM.CURRENCY_IMGS_FOLDER ""

if (A_IsCompiled) {
	sourceFileSize := Get_ResourceSize("resources\currency_imgs\Exalted Orb.png")
	FileGetSize, destFileSize, % PROGRAM.CURRENCY_IMGS_FOLDER "\Exalted Orb.png"
}
else {
	FileGetSize, sourceFileSize, resources\currency_imgs\Exalted Orb.png
	FileGetSize, destFileSize, % PROGRAM.CURRENCY_IMGS_FOLDER "\Exalted Orb.png"
}
if (sourceFileSize != destFileSize)
	FileInstall, resources\currency_imgs\Exalted Orb.png, % PROGRAM.CURRENCY_IMGS_FOLDER "\Exalted Orb.png", 1
if (ErrorLevel) {
	AppendToLogs("Failed to extract file!"
	.	"`nSource: resources\currency_imgs\Exalted Orb.png"
	.	"`nDest: " PROGRAM.CURRENCY_IMGS_FOLDER "\Exalted Orb.png"
	.	"`nFlag: " 2)
	errorLog .= "`n`n""Failed to extract file!"
	.	"`nSource: resources\currency_imgs\Exalted Orb.png"
	.	"`nDest: " PROGRAM.CURRENCY_IMGS_FOLDER "\Exalted Orb.png"
	.	"`nFlag: " 2
}

; ----------------------------
if !InStr(FileExist(PROGRAM.CURRENCY_IMGS_FOLDER ""), "D")
	FileCreateDir,% PROGRAM.CURRENCY_IMGS_FOLDER ""

if (A_IsCompiled) {
	sourceFileSize := Get_ResourceSize("resources\currency_imgs\Exalted Shard.png")
	FileGetSize, destFileSize, % PROGRAM.CURRENCY_IMGS_FOLDER "\Exalted Shard.png"
}
else {
	FileGetSize, sourceFileSize, resources\currency_imgs\Exalted Shard.png
	FileGetSize, destFileSize, % PROGRAM.CURRENCY_IMGS_FOLDER "\Exalted Shard.png"
}
if (sourceFileSize != destFileSize)
	FileInstall, resources\currency_imgs\Exalted Shard.png, % PROGRAM.CURRENCY_IMGS_FOLDER "\Exalted Shard.png", 1
if (ErrorLevel) {
	AppendToLogs("Failed to extract file!"
	.	"`nSource: resources\currency_imgs\Exalted Shard.png"
	.	"`nDest: " PROGRAM.CURRENCY_IMGS_FOLDER "\Exalted Shard.png"
	.	"`nFlag: " 2)
	errorLog .= "`n`n""Failed to extract file!"
	.	"`nSource: resources\currency_imgs\Exalted Shard.png"
	.	"`nDest: " PROGRAM.CURRENCY_IMGS_FOLDER "\Exalted Shard.png"
	.	"`nFlag: " 2
}

; ----------------------------
if !InStr(FileExist(PROGRAM.CURRENCY_IMGS_FOLDER ""), "D")
	FileCreateDir,% PROGRAM.CURRENCY_IMGS_FOLDER ""

if (A_IsCompiled) {
	sourceFileSize := Get_ResourceSize("resources\currency_imgs\Fragment of the Chimera.png")
	FileGetSize, destFileSize, % PROGRAM.CURRENCY_IMGS_FOLDER "\Fragment of the Chimera.png"
}
else {
	FileGetSize, sourceFileSize, resources\currency_imgs\Fragment of the Chimera.png
	FileGetSize, destFileSize, % PROGRAM.CURRENCY_IMGS_FOLDER "\Fragment of the Chimera.png"
}
if (sourceFileSize != destFileSize)
	FileInstall, resources\currency_imgs\Fragment of the Chimera.png, % PROGRAM.CURRENCY_IMGS_FOLDER "\Fragment of the Chimera.png", 1
if (ErrorLevel) {
	AppendToLogs("Failed to extract file!"
	.	"`nSource: resources\currency_imgs\Fragment of the Chimera.png"
	.	"`nDest: " PROGRAM.CURRENCY_IMGS_FOLDER "\Fragment of the Chimera.png"
	.	"`nFlag: " 2)
	errorLog .= "`n`n""Failed to extract file!"
	.	"`nSource: resources\currency_imgs\Fragment of the Chimera.png"
	.	"`nDest: " PROGRAM.CURRENCY_IMGS_FOLDER "\Fragment of the Chimera.png"
	.	"`nFlag: " 2
}

; ----------------------------
if !InStr(FileExist(PROGRAM.CURRENCY_IMGS_FOLDER ""), "D")
	FileCreateDir,% PROGRAM.CURRENCY_IMGS_FOLDER ""

if (A_IsCompiled) {
	sourceFileSize := Get_ResourceSize("resources\currency_imgs\Fragment of the Hydra.png")
	FileGetSize, destFileSize, % PROGRAM.CURRENCY_IMGS_FOLDER "\Fragment of the Hydra.png"
}
else {
	FileGetSize, sourceFileSize, resources\currency_imgs\Fragment of the Hydra.png
	FileGetSize, destFileSize, % PROGRAM.CURRENCY_IMGS_FOLDER "\Fragment of the Hydra.png"
}
if (sourceFileSize != destFileSize)
	FileInstall, resources\currency_imgs\Fragment of the Hydra.png, % PROGRAM.CURRENCY_IMGS_FOLDER "\Fragment of the Hydra.png", 1
if (ErrorLevel) {
	AppendToLogs("Failed to extract file!"
	.	"`nSource: resources\currency_imgs\Fragment of the Hydra.png"
	.	"`nDest: " PROGRAM.CURRENCY_IMGS_FOLDER "\Fragment of the Hydra.png"
	.	"`nFlag: " 2)
	errorLog .= "`n`n""Failed to extract file!"
	.	"`nSource: resources\currency_imgs\Fragment of the Hydra.png"
	.	"`nDest: " PROGRAM.CURRENCY_IMGS_FOLDER "\Fragment of the Hydra.png"
	.	"`nFlag: " 2
}

; ----------------------------
if !InStr(FileExist(PROGRAM.CURRENCY_IMGS_FOLDER ""), "D")
	FileCreateDir,% PROGRAM.CURRENCY_IMGS_FOLDER ""

if (A_IsCompiled) {
	sourceFileSize := Get_ResourceSize("resources\currency_imgs\Fragment of the Minotaur.png")
	FileGetSize, destFileSize, % PROGRAM.CURRENCY_IMGS_FOLDER "\Fragment of the Minotaur.png"
}
else {
	FileGetSize, sourceFileSize, resources\currency_imgs\Fragment of the Minotaur.png
	FileGetSize, destFileSize, % PROGRAM.CURRENCY_IMGS_FOLDER "\Fragment of the Minotaur.png"
}
if (sourceFileSize != destFileSize)
	FileInstall, resources\currency_imgs\Fragment of the Minotaur.png, % PROGRAM.CURRENCY_IMGS_FOLDER "\Fragment of the Minotaur.png", 1
if (ErrorLevel) {
	AppendToLogs("Failed to extract file!"
	.	"`nSource: resources\currency_imgs\Fragment of the Minotaur.png"
	.	"`nDest: " PROGRAM.CURRENCY_IMGS_FOLDER "\Fragment of the Minotaur.png"
	.	"`nFlag: " 2)
	errorLog .= "`n`n""Failed to extract file!"
	.	"`nSource: resources\currency_imgs\Fragment of the Minotaur.png"
	.	"`nDest: " PROGRAM.CURRENCY_IMGS_FOLDER "\Fragment of the Minotaur.png"
	.	"`nFlag: " 2
}

; ----------------------------
if !InStr(FileExist(PROGRAM.CURRENCY_IMGS_FOLDER ""), "D")
	FileCreateDir,% PROGRAM.CURRENCY_IMGS_FOLDER ""

if (A_IsCompiled) {
	sourceFileSize := Get_ResourceSize("resources\currency_imgs\Fragment of the Phoenix.png")
	FileGetSize, destFileSize, % PROGRAM.CURRENCY_IMGS_FOLDER "\Fragment of the Phoenix.png"
}
else {
	FileGetSize, sourceFileSize, resources\currency_imgs\Fragment of the Phoenix.png
	FileGetSize, destFileSize, % PROGRAM.CURRENCY_IMGS_FOLDER "\Fragment of the Phoenix.png"
}
if (sourceFileSize != destFileSize)
	FileInstall, resources\currency_imgs\Fragment of the Phoenix.png, % PROGRAM.CURRENCY_IMGS_FOLDER "\Fragment of the Phoenix.png", 1
if (ErrorLevel) {
	AppendToLogs("Failed to extract file!"
	.	"`nSource: resources\currency_imgs\Fragment of the Phoenix.png"
	.	"`nDest: " PROGRAM.CURRENCY_IMGS_FOLDER "\Fragment of the Phoenix.png"
	.	"`nFlag: " 2)
	errorLog .= "`n`n""Failed to extract file!"
	.	"`nSource: resources\currency_imgs\Fragment of the Phoenix.png"
	.	"`nDest: " PROGRAM.CURRENCY_IMGS_FOLDER "\Fragment of the Phoenix.png"
	.	"`nFlag: " 2
}

; ----------------------------
if !InStr(FileExist(PROGRAM.CURRENCY_IMGS_FOLDER ""), "D")
	FileCreateDir,% PROGRAM.CURRENCY_IMGS_FOLDER ""

if (A_IsCompiled) {
	sourceFileSize := Get_ResourceSize("resources\currency_imgs\Gemcutter's Prism.png")
	FileGetSize, destFileSize, % PROGRAM.CURRENCY_IMGS_FOLDER "\Gemcutter's Prism.png"
}
else {
	FileGetSize, sourceFileSize, resources\currency_imgs\Gemcutter's Prism.png
	FileGetSize, destFileSize, % PROGRAM.CURRENCY_IMGS_FOLDER "\Gemcutter's Prism.png"
}
if (sourceFileSize != destFileSize)
	FileInstall, resources\currency_imgs\Gemcutter's Prism.png, % PROGRAM.CURRENCY_IMGS_FOLDER "\Gemcutter's Prism.png", 1
if (ErrorLevel) {
	AppendToLogs("Failed to extract file!"
	.	"`nSource: resources\currency_imgs\Gemcutter's Prism.png"
	.	"`nDest: " PROGRAM.CURRENCY_IMGS_FOLDER "\Gemcutter's Prism.png"
	.	"`nFlag: " 2)
	errorLog .= "`n`n""Failed to extract file!"
	.	"`nSource: resources\currency_imgs\Gemcutter's Prism.png"
	.	"`nDest: " PROGRAM.CURRENCY_IMGS_FOLDER "\Gemcutter's Prism.png"
	.	"`nFlag: " 2
}

; ----------------------------
if !InStr(FileExist(PROGRAM.CURRENCY_IMGS_FOLDER ""), "D")
	FileCreateDir,% PROGRAM.CURRENCY_IMGS_FOLDER ""

if (A_IsCompiled) {
	sourceFileSize := Get_ResourceSize("resources\currency_imgs\Glassblower's Bauble.png")
	FileGetSize, destFileSize, % PROGRAM.CURRENCY_IMGS_FOLDER "\Glassblower's Bauble.png"
}
else {
	FileGetSize, sourceFileSize, resources\currency_imgs\Glassblower's Bauble.png
	FileGetSize, destFileSize, % PROGRAM.CURRENCY_IMGS_FOLDER "\Glassblower's Bauble.png"
}
if (sourceFileSize != destFileSize)
	FileInstall, resources\currency_imgs\Glassblower's Bauble.png, % PROGRAM.CURRENCY_IMGS_FOLDER "\Glassblower's Bauble.png", 1
if (ErrorLevel) {
	AppendToLogs("Failed to extract file!"
	.	"`nSource: resources\currency_imgs\Glassblower's Bauble.png"
	.	"`nDest: " PROGRAM.CURRENCY_IMGS_FOLDER "\Glassblower's Bauble.png"
	.	"`nFlag: " 2)
	errorLog .= "`n`n""Failed to extract file!"
	.	"`nSource: resources\currency_imgs\Glassblower's Bauble.png"
	.	"`nDest: " PROGRAM.CURRENCY_IMGS_FOLDER "\Glassblower's Bauble.png"
	.	"`nFlag: " 2
}

; ----------------------------
if !InStr(FileExist(PROGRAM.CURRENCY_IMGS_FOLDER ""), "D")
	FileCreateDir,% PROGRAM.CURRENCY_IMGS_FOLDER ""

if (A_IsCompiled) {
	sourceFileSize := Get_ResourceSize("resources\currency_imgs\Harbinger's Orb.png")
	FileGetSize, destFileSize, % PROGRAM.CURRENCY_IMGS_FOLDER "\Harbinger's Orb.png"
}
else {
	FileGetSize, sourceFileSize, resources\currency_imgs\Harbinger's Orb.png
	FileGetSize, destFileSize, % PROGRAM.CURRENCY_IMGS_FOLDER "\Harbinger's Orb.png"
}
if (sourceFileSize != destFileSize)
	FileInstall, resources\currency_imgs\Harbinger's Orb.png, % PROGRAM.CURRENCY_IMGS_FOLDER "\Harbinger's Orb.png", 1
if (ErrorLevel) {
	AppendToLogs("Failed to extract file!"
	.	"`nSource: resources\currency_imgs\Harbinger's Orb.png"
	.	"`nDest: " PROGRAM.CURRENCY_IMGS_FOLDER "\Harbinger's Orb.png"
	.	"`nFlag: " 2)
	errorLog .= "`n`n""Failed to extract file!"
	.	"`nSource: resources\currency_imgs\Harbinger's Orb.png"
	.	"`nDest: " PROGRAM.CURRENCY_IMGS_FOLDER "\Harbinger's Orb.png"
	.	"`nFlag: " 2
}

; ----------------------------
if !InStr(FileExist(PROGRAM.CURRENCY_IMGS_FOLDER ""), "D")
	FileCreateDir,% PROGRAM.CURRENCY_IMGS_FOLDER ""

if (A_IsCompiled) {
	sourceFileSize := Get_ResourceSize("resources\currency_imgs\Inya's Key.png")
	FileGetSize, destFileSize, % PROGRAM.CURRENCY_IMGS_FOLDER "\Inya's Key.png"
}
else {
	FileGetSize, sourceFileSize, resources\currency_imgs\Inya's Key.png
	FileGetSize, destFileSize, % PROGRAM.CURRENCY_IMGS_FOLDER "\Inya's Key.png"
}
if (sourceFileSize != destFileSize)
	FileInstall, resources\currency_imgs\Inya's Key.png, % PROGRAM.CURRENCY_IMGS_FOLDER "\Inya's Key.png", 1
if (ErrorLevel) {
	AppendToLogs("Failed to extract file!"
	.	"`nSource: resources\currency_imgs\Inya's Key.png"
	.	"`nDest: " PROGRAM.CURRENCY_IMGS_FOLDER "\Inya's Key.png"
	.	"`nFlag: " 2)
	errorLog .= "`n`n""Failed to extract file!"
	.	"`nSource: resources\currency_imgs\Inya's Key.png"
	.	"`nDest: " PROGRAM.CURRENCY_IMGS_FOLDER "\Inya's Key.png"
	.	"`nFlag: " 2
}

; ----------------------------
if !InStr(FileExist(PROGRAM.CURRENCY_IMGS_FOLDER ""), "D")
	FileCreateDir,% PROGRAM.CURRENCY_IMGS_FOLDER ""

if (A_IsCompiled) {
	sourceFileSize := Get_ResourceSize("resources\currency_imgs\Jeweller's Orb.png")
	FileGetSize, destFileSize, % PROGRAM.CURRENCY_IMGS_FOLDER "\Jeweller's Orb.png"
}
else {
	FileGetSize, sourceFileSize, resources\currency_imgs\Jeweller's Orb.png
	FileGetSize, destFileSize, % PROGRAM.CURRENCY_IMGS_FOLDER "\Jeweller's Orb.png"
}
if (sourceFileSize != destFileSize)
	FileInstall, resources\currency_imgs\Jeweller's Orb.png, % PROGRAM.CURRENCY_IMGS_FOLDER "\Jeweller's Orb.png", 1
if (ErrorLevel) {
	AppendToLogs("Failed to extract file!"
	.	"`nSource: resources\currency_imgs\Jeweller's Orb.png"
	.	"`nDest: " PROGRAM.CURRENCY_IMGS_FOLDER "\Jeweller's Orb.png"
	.	"`nFlag: " 2)
	errorLog .= "`n`n""Failed to extract file!"
	.	"`nSource: resources\currency_imgs\Jeweller's Orb.png"
	.	"`nDest: " PROGRAM.CURRENCY_IMGS_FOLDER "\Jeweller's Orb.png"
	.	"`nFlag: " 2
}

; ----------------------------
if !InStr(FileExist(PROGRAM.CURRENCY_IMGS_FOLDER ""), "D")
	FileCreateDir,% PROGRAM.CURRENCY_IMGS_FOLDER ""

if (A_IsCompiled) {
	sourceFileSize := Get_ResourceSize("resources\currency_imgs\Journeyman Cartographer's Seal.png")
	FileGetSize, destFileSize, % PROGRAM.CURRENCY_IMGS_FOLDER "\Journeyman Cartographer's Seal.png"
}
else {
	FileGetSize, sourceFileSize, resources\currency_imgs\Journeyman Cartographer's Seal.png
	FileGetSize, destFileSize, % PROGRAM.CURRENCY_IMGS_FOLDER "\Journeyman Cartographer's Seal.png"
}
if (sourceFileSize != destFileSize)
	FileInstall, resources\currency_imgs\Journeyman Cartographer's Seal.png, % PROGRAM.CURRENCY_IMGS_FOLDER "\Journeyman Cartographer's Seal.png", 1
if (ErrorLevel) {
	AppendToLogs("Failed to extract file!"
	.	"`nSource: resources\currency_imgs\Journeyman Cartographer's Seal.png"
	.	"`nDest: " PROGRAM.CURRENCY_IMGS_FOLDER "\Journeyman Cartographer's Seal.png"
	.	"`nFlag: " 2)
	errorLog .= "`n`n""Failed to extract file!"
	.	"`nSource: resources\currency_imgs\Journeyman Cartographer's Seal.png"
	.	"`nDest: " PROGRAM.CURRENCY_IMGS_FOLDER "\Journeyman Cartographer's Seal.png"
	.	"`nFlag: " 2
}

; ----------------------------
if !InStr(FileExist(PROGRAM.CURRENCY_IMGS_FOLDER ""), "D")
	FileCreateDir,% PROGRAM.CURRENCY_IMGS_FOLDER ""

if (A_IsCompiled) {
	sourceFileSize := Get_ResourceSize("resources\currency_imgs\Journeyman Cartographer's Sextant.png")
	FileGetSize, destFileSize, % PROGRAM.CURRENCY_IMGS_FOLDER "\Journeyman Cartographer's Sextant.png"
}
else {
	FileGetSize, sourceFileSize, resources\currency_imgs\Journeyman Cartographer's Sextant.png
	FileGetSize, destFileSize, % PROGRAM.CURRENCY_IMGS_FOLDER "\Journeyman Cartographer's Sextant.png"
}
if (sourceFileSize != destFileSize)
	FileInstall, resources\currency_imgs\Journeyman Cartographer's Sextant.png, % PROGRAM.CURRENCY_IMGS_FOLDER "\Journeyman Cartographer's Sextant.png", 1
if (ErrorLevel) {
	AppendToLogs("Failed to extract file!"
	.	"`nSource: resources\currency_imgs\Journeyman Cartographer's Sextant.png"
	.	"`nDest: " PROGRAM.CURRENCY_IMGS_FOLDER "\Journeyman Cartographer's Sextant.png"
	.	"`nFlag: " 2)
	errorLog .= "`n`n""Failed to extract file!"
	.	"`nSource: resources\currency_imgs\Journeyman Cartographer's Sextant.png"
	.	"`nDest: " PROGRAM.CURRENCY_IMGS_FOLDER "\Journeyman Cartographer's Sextant.png"
	.	"`nFlag: " 2
}

; ----------------------------
if !InStr(FileExist(PROGRAM.CURRENCY_IMGS_FOLDER ""), "D")
	FileCreateDir,% PROGRAM.CURRENCY_IMGS_FOLDER ""

if (A_IsCompiled) {
	sourceFileSize := Get_ResourceSize("resources\currency_imgs\Master Cartographer's Seal.png")
	FileGetSize, destFileSize, % PROGRAM.CURRENCY_IMGS_FOLDER "\Master Cartographer's Seal.png"
}
else {
	FileGetSize, sourceFileSize, resources\currency_imgs\Master Cartographer's Seal.png
	FileGetSize, destFileSize, % PROGRAM.CURRENCY_IMGS_FOLDER "\Master Cartographer's Seal.png"
}
if (sourceFileSize != destFileSize)
	FileInstall, resources\currency_imgs\Master Cartographer's Seal.png, % PROGRAM.CURRENCY_IMGS_FOLDER "\Master Cartographer's Seal.png", 1
if (ErrorLevel) {
	AppendToLogs("Failed to extract file!"
	.	"`nSource: resources\currency_imgs\Master Cartographer's Seal.png"
	.	"`nDest: " PROGRAM.CURRENCY_IMGS_FOLDER "\Master Cartographer's Seal.png"
	.	"`nFlag: " 2)
	errorLog .= "`n`n""Failed to extract file!"
	.	"`nSource: resources\currency_imgs\Master Cartographer's Seal.png"
	.	"`nDest: " PROGRAM.CURRENCY_IMGS_FOLDER "\Master Cartographer's Seal.png"
	.	"`nFlag: " 2
}

; ----------------------------
if !InStr(FileExist(PROGRAM.CURRENCY_IMGS_FOLDER ""), "D")
	FileCreateDir,% PROGRAM.CURRENCY_IMGS_FOLDER ""

if (A_IsCompiled) {
	sourceFileSize := Get_ResourceSize("resources\currency_imgs\Master Cartographer's Sextant.png")
	FileGetSize, destFileSize, % PROGRAM.CURRENCY_IMGS_FOLDER "\Master Cartographer's Sextant.png"
}
else {
	FileGetSize, sourceFileSize, resources\currency_imgs\Master Cartographer's Sextant.png
	FileGetSize, destFileSize, % PROGRAM.CURRENCY_IMGS_FOLDER "\Master Cartographer's Sextant.png"
}
if (sourceFileSize != destFileSize)
	FileInstall, resources\currency_imgs\Master Cartographer's Sextant.png, % PROGRAM.CURRENCY_IMGS_FOLDER "\Master Cartographer's Sextant.png", 1
if (ErrorLevel) {
	AppendToLogs("Failed to extract file!"
	.	"`nSource: resources\currency_imgs\Master Cartographer's Sextant.png"
	.	"`nDest: " PROGRAM.CURRENCY_IMGS_FOLDER "\Master Cartographer's Sextant.png"
	.	"`nFlag: " 2)
	errorLog .= "`n`n""Failed to extract file!"
	.	"`nSource: resources\currency_imgs\Master Cartographer's Sextant.png"
	.	"`nDest: " PROGRAM.CURRENCY_IMGS_FOLDER "\Master Cartographer's Sextant.png"
	.	"`nFlag: " 2
}

; ----------------------------
if !InStr(FileExist(PROGRAM.CURRENCY_IMGS_FOLDER ""), "D")
	FileCreateDir,% PROGRAM.CURRENCY_IMGS_FOLDER ""

if (A_IsCompiled) {
	sourceFileSize := Get_ResourceSize("resources\currency_imgs\Mirror of Kalandra.png")
	FileGetSize, destFileSize, % PROGRAM.CURRENCY_IMGS_FOLDER "\Mirror of Kalandra.png"
}
else {
	FileGetSize, sourceFileSize, resources\currency_imgs\Mirror of Kalandra.png
	FileGetSize, destFileSize, % PROGRAM.CURRENCY_IMGS_FOLDER "\Mirror of Kalandra.png"
}
if (sourceFileSize != destFileSize)
	FileInstall, resources\currency_imgs\Mirror of Kalandra.png, % PROGRAM.CURRENCY_IMGS_FOLDER "\Mirror of Kalandra.png", 1
if (ErrorLevel) {
	AppendToLogs("Failed to extract file!"
	.	"`nSource: resources\currency_imgs\Mirror of Kalandra.png"
	.	"`nDest: " PROGRAM.CURRENCY_IMGS_FOLDER "\Mirror of Kalandra.png"
	.	"`nFlag: " 2)
	errorLog .= "`n`n""Failed to extract file!"
	.	"`nSource: resources\currency_imgs\Mirror of Kalandra.png"
	.	"`nDest: " PROGRAM.CURRENCY_IMGS_FOLDER "\Mirror of Kalandra.png"
	.	"`nFlag: " 2
}

; ----------------------------
if !InStr(FileExist(PROGRAM.CURRENCY_IMGS_FOLDER ""), "D")
	FileCreateDir,% PROGRAM.CURRENCY_IMGS_FOLDER ""

if (A_IsCompiled) {
	sourceFileSize := Get_ResourceSize("resources\currency_imgs\Mirror Shard.png")
	FileGetSize, destFileSize, % PROGRAM.CURRENCY_IMGS_FOLDER "\Mirror Shard.png"
}
else {
	FileGetSize, sourceFileSize, resources\currency_imgs\Mirror Shard.png
	FileGetSize, destFileSize, % PROGRAM.CURRENCY_IMGS_FOLDER "\Mirror Shard.png"
}
if (sourceFileSize != destFileSize)
	FileInstall, resources\currency_imgs\Mirror Shard.png, % PROGRAM.CURRENCY_IMGS_FOLDER "\Mirror Shard.png", 1
if (ErrorLevel) {
	AppendToLogs("Failed to extract file!"
	.	"`nSource: resources\currency_imgs\Mirror Shard.png"
	.	"`nDest: " PROGRAM.CURRENCY_IMGS_FOLDER "\Mirror Shard.png"
	.	"`nFlag: " 2)
	errorLog .= "`n`n""Failed to extract file!"
	.	"`nSource: resources\currency_imgs\Mirror Shard.png"
	.	"`nDest: " PROGRAM.CURRENCY_IMGS_FOLDER "\Mirror Shard.png"
	.	"`nFlag: " 2
}

; ----------------------------
if !InStr(FileExist(PROGRAM.CURRENCY_IMGS_FOLDER ""), "D")
	FileCreateDir,% PROGRAM.CURRENCY_IMGS_FOLDER ""

if (A_IsCompiled) {
	sourceFileSize := Get_ResourceSize("resources\currency_imgs\Mortal Grief.png")
	FileGetSize, destFileSize, % PROGRAM.CURRENCY_IMGS_FOLDER "\Mortal Grief.png"
}
else {
	FileGetSize, sourceFileSize, resources\currency_imgs\Mortal Grief.png
	FileGetSize, destFileSize, % PROGRAM.CURRENCY_IMGS_FOLDER "\Mortal Grief.png"
}
if (sourceFileSize != destFileSize)
	FileInstall, resources\currency_imgs\Mortal Grief.png, % PROGRAM.CURRENCY_IMGS_FOLDER "\Mortal Grief.png", 1
if (ErrorLevel) {
	AppendToLogs("Failed to extract file!"
	.	"`nSource: resources\currency_imgs\Mortal Grief.png"
	.	"`nDest: " PROGRAM.CURRENCY_IMGS_FOLDER "\Mortal Grief.png"
	.	"`nFlag: " 2)
	errorLog .= "`n`n""Failed to extract file!"
	.	"`nSource: resources\currency_imgs\Mortal Grief.png"
	.	"`nDest: " PROGRAM.CURRENCY_IMGS_FOLDER "\Mortal Grief.png"
	.	"`nFlag: " 2
}

; ----------------------------
if !InStr(FileExist(PROGRAM.CURRENCY_IMGS_FOLDER ""), "D")
	FileCreateDir,% PROGRAM.CURRENCY_IMGS_FOLDER ""

if (A_IsCompiled) {
	sourceFileSize := Get_ResourceSize("resources\currency_imgs\Mortal Hope.png")
	FileGetSize, destFileSize, % PROGRAM.CURRENCY_IMGS_FOLDER "\Mortal Hope.png"
}
else {
	FileGetSize, sourceFileSize, resources\currency_imgs\Mortal Hope.png
	FileGetSize, destFileSize, % PROGRAM.CURRENCY_IMGS_FOLDER "\Mortal Hope.png"
}
if (sourceFileSize != destFileSize)
	FileInstall, resources\currency_imgs\Mortal Hope.png, % PROGRAM.CURRENCY_IMGS_FOLDER "\Mortal Hope.png", 1
if (ErrorLevel) {
	AppendToLogs("Failed to extract file!"
	.	"`nSource: resources\currency_imgs\Mortal Hope.png"
	.	"`nDest: " PROGRAM.CURRENCY_IMGS_FOLDER "\Mortal Hope.png"
	.	"`nFlag: " 2)
	errorLog .= "`n`n""Failed to extract file!"
	.	"`nSource: resources\currency_imgs\Mortal Hope.png"
	.	"`nDest: " PROGRAM.CURRENCY_IMGS_FOLDER "\Mortal Hope.png"
	.	"`nFlag: " 2
}

; ----------------------------
if !InStr(FileExist(PROGRAM.CURRENCY_IMGS_FOLDER ""), "D")
	FileCreateDir,% PROGRAM.CURRENCY_IMGS_FOLDER ""

if (A_IsCompiled) {
	sourceFileSize := Get_ResourceSize("resources\currency_imgs\Mortal Ignorance.png")
	FileGetSize, destFileSize, % PROGRAM.CURRENCY_IMGS_FOLDER "\Mortal Ignorance.png"
}
else {
	FileGetSize, sourceFileSize, resources\currency_imgs\Mortal Ignorance.png
	FileGetSize, destFileSize, % PROGRAM.CURRENCY_IMGS_FOLDER "\Mortal Ignorance.png"
}
if (sourceFileSize != destFileSize)
	FileInstall, resources\currency_imgs\Mortal Ignorance.png, % PROGRAM.CURRENCY_IMGS_FOLDER "\Mortal Ignorance.png", 1
if (ErrorLevel) {
	AppendToLogs("Failed to extract file!"
	.	"`nSource: resources\currency_imgs\Mortal Ignorance.png"
	.	"`nDest: " PROGRAM.CURRENCY_IMGS_FOLDER "\Mortal Ignorance.png"
	.	"`nFlag: " 2)
	errorLog .= "`n`n""Failed to extract file!"
	.	"`nSource: resources\currency_imgs\Mortal Ignorance.png"
	.	"`nDest: " PROGRAM.CURRENCY_IMGS_FOLDER "\Mortal Ignorance.png"
	.	"`nFlag: " 2
}

; ----------------------------
if !InStr(FileExist(PROGRAM.CURRENCY_IMGS_FOLDER ""), "D")
	FileCreateDir,% PROGRAM.CURRENCY_IMGS_FOLDER ""

if (A_IsCompiled) {
	sourceFileSize := Get_ResourceSize("resources\currency_imgs\Mortal Rage.png")
	FileGetSize, destFileSize, % PROGRAM.CURRENCY_IMGS_FOLDER "\Mortal Rage.png"
}
else {
	FileGetSize, sourceFileSize, resources\currency_imgs\Mortal Rage.png
	FileGetSize, destFileSize, % PROGRAM.CURRENCY_IMGS_FOLDER "\Mortal Rage.png"
}
if (sourceFileSize != destFileSize)
	FileInstall, resources\currency_imgs\Mortal Rage.png, % PROGRAM.CURRENCY_IMGS_FOLDER "\Mortal Rage.png", 1
if (ErrorLevel) {
	AppendToLogs("Failed to extract file!"
	.	"`nSource: resources\currency_imgs\Mortal Rage.png"
	.	"`nDest: " PROGRAM.CURRENCY_IMGS_FOLDER "\Mortal Rage.png"
	.	"`nFlag: " 2)
	errorLog .= "`n`n""Failed to extract file!"
	.	"`nSource: resources\currency_imgs\Mortal Rage.png"
	.	"`nDest: " PROGRAM.CURRENCY_IMGS_FOLDER "\Mortal Rage.png"
	.	"`nFlag: " 2
}

; ----------------------------
if !InStr(FileExist(PROGRAM.CURRENCY_IMGS_FOLDER ""), "D")
	FileCreateDir,% PROGRAM.CURRENCY_IMGS_FOLDER ""

if (A_IsCompiled) {
	sourceFileSize := Get_ResourceSize("resources\currency_imgs\Mortal Set.png")
	FileGetSize, destFileSize, % PROGRAM.CURRENCY_IMGS_FOLDER "\Mortal Set.png"
}
else {
	FileGetSize, sourceFileSize, resources\currency_imgs\Mortal Set.png
	FileGetSize, destFileSize, % PROGRAM.CURRENCY_IMGS_FOLDER "\Mortal Set.png"
}
if (sourceFileSize != destFileSize)
	FileInstall, resources\currency_imgs\Mortal Set.png, % PROGRAM.CURRENCY_IMGS_FOLDER "\Mortal Set.png", 1
if (ErrorLevel) {
	AppendToLogs("Failed to extract file!"
	.	"`nSource: resources\currency_imgs\Mortal Set.png"
	.	"`nDest: " PROGRAM.CURRENCY_IMGS_FOLDER "\Mortal Set.png"
	.	"`nFlag: " 2)
	errorLog .= "`n`n""Failed to extract file!"
	.	"`nSource: resources\currency_imgs\Mortal Set.png"
	.	"`nDest: " PROGRAM.CURRENCY_IMGS_FOLDER "\Mortal Set.png"
	.	"`nFlag: " 2
}

; ----------------------------
if !InStr(FileExist(PROGRAM.CURRENCY_IMGS_FOLDER ""), "D")
	FileCreateDir,% PROGRAM.CURRENCY_IMGS_FOLDER ""

if (A_IsCompiled) {
	sourceFileSize := Get_ResourceSize("resources\currency_imgs\Offering to the Goddess.png")
	FileGetSize, destFileSize, % PROGRAM.CURRENCY_IMGS_FOLDER "\Offering to the Goddess.png"
}
else {
	FileGetSize, sourceFileSize, resources\currency_imgs\Offering to the Goddess.png
	FileGetSize, destFileSize, % PROGRAM.CURRENCY_IMGS_FOLDER "\Offering to the Goddess.png"
}
if (sourceFileSize != destFileSize)
	FileInstall, resources\currency_imgs\Offering to the Goddess.png, % PROGRAM.CURRENCY_IMGS_FOLDER "\Offering to the Goddess.png", 1
if (ErrorLevel) {
	AppendToLogs("Failed to extract file!"
	.	"`nSource: resources\currency_imgs\Offering to the Goddess.png"
	.	"`nDest: " PROGRAM.CURRENCY_IMGS_FOLDER "\Offering to the Goddess.png"
	.	"`nFlag: " 2)
	errorLog .= "`n`n""Failed to extract file!"
	.	"`nSource: resources\currency_imgs\Offering to the Goddess.png"
	.	"`nDest: " PROGRAM.CURRENCY_IMGS_FOLDER "\Offering to the Goddess.png"
	.	"`nFlag: " 2
}

; ----------------------------
if !InStr(FileExist(PROGRAM.CURRENCY_IMGS_FOLDER ""), "D")
	FileCreateDir,% PROGRAM.CURRENCY_IMGS_FOLDER ""

if (A_IsCompiled) {
	sourceFileSize := Get_ResourceSize("resources\currency_imgs\Orb of Alchemy.png")
	FileGetSize, destFileSize, % PROGRAM.CURRENCY_IMGS_FOLDER "\Orb of Alchemy.png"
}
else {
	FileGetSize, sourceFileSize, resources\currency_imgs\Orb of Alchemy.png
	FileGetSize, destFileSize, % PROGRAM.CURRENCY_IMGS_FOLDER "\Orb of Alchemy.png"
}
if (sourceFileSize != destFileSize)
	FileInstall, resources\currency_imgs\Orb of Alchemy.png, % PROGRAM.CURRENCY_IMGS_FOLDER "\Orb of Alchemy.png", 1
if (ErrorLevel) {
	AppendToLogs("Failed to extract file!"
	.	"`nSource: resources\currency_imgs\Orb of Alchemy.png"
	.	"`nDest: " PROGRAM.CURRENCY_IMGS_FOLDER "\Orb of Alchemy.png"
	.	"`nFlag: " 2)
	errorLog .= "`n`n""Failed to extract file!"
	.	"`nSource: resources\currency_imgs\Orb of Alchemy.png"
	.	"`nDest: " PROGRAM.CURRENCY_IMGS_FOLDER "\Orb of Alchemy.png"
	.	"`nFlag: " 2
}

; ----------------------------
if !InStr(FileExist(PROGRAM.CURRENCY_IMGS_FOLDER ""), "D")
	FileCreateDir,% PROGRAM.CURRENCY_IMGS_FOLDER ""

if (A_IsCompiled) {
	sourceFileSize := Get_ResourceSize("resources\currency_imgs\Orb of Alteration.png")
	FileGetSize, destFileSize, % PROGRAM.CURRENCY_IMGS_FOLDER "\Orb of Alteration.png"
}
else {
	FileGetSize, sourceFileSize, resources\currency_imgs\Orb of Alteration.png
	FileGetSize, destFileSize, % PROGRAM.CURRENCY_IMGS_FOLDER "\Orb of Alteration.png"
}
if (sourceFileSize != destFileSize)
	FileInstall, resources\currency_imgs\Orb of Alteration.png, % PROGRAM.CURRENCY_IMGS_FOLDER "\Orb of Alteration.png", 1
if (ErrorLevel) {
	AppendToLogs("Failed to extract file!"
	.	"`nSource: resources\currency_imgs\Orb of Alteration.png"
	.	"`nDest: " PROGRAM.CURRENCY_IMGS_FOLDER "\Orb of Alteration.png"
	.	"`nFlag: " 2)
	errorLog .= "`n`n""Failed to extract file!"
	.	"`nSource: resources\currency_imgs\Orb of Alteration.png"
	.	"`nDest: " PROGRAM.CURRENCY_IMGS_FOLDER "\Orb of Alteration.png"
	.	"`nFlag: " 2
}

; ----------------------------
if !InStr(FileExist(PROGRAM.CURRENCY_IMGS_FOLDER ""), "D")
	FileCreateDir,% PROGRAM.CURRENCY_IMGS_FOLDER ""

if (A_IsCompiled) {
	sourceFileSize := Get_ResourceSize("resources\currency_imgs\Orb of Annulment.png")
	FileGetSize, destFileSize, % PROGRAM.CURRENCY_IMGS_FOLDER "\Orb of Annulment.png"
}
else {
	FileGetSize, sourceFileSize, resources\currency_imgs\Orb of Annulment.png
	FileGetSize, destFileSize, % PROGRAM.CURRENCY_IMGS_FOLDER "\Orb of Annulment.png"
}
if (sourceFileSize != destFileSize)
	FileInstall, resources\currency_imgs\Orb of Annulment.png, % PROGRAM.CURRENCY_IMGS_FOLDER "\Orb of Annulment.png", 1
if (ErrorLevel) {
	AppendToLogs("Failed to extract file!"
	.	"`nSource: resources\currency_imgs\Orb of Annulment.png"
	.	"`nDest: " PROGRAM.CURRENCY_IMGS_FOLDER "\Orb of Annulment.png"
	.	"`nFlag: " 2)
	errorLog .= "`n`n""Failed to extract file!"
	.	"`nSource: resources\currency_imgs\Orb of Annulment.png"
	.	"`nDest: " PROGRAM.CURRENCY_IMGS_FOLDER "\Orb of Annulment.png"
	.	"`nFlag: " 2
}

; ----------------------------
if !InStr(FileExist(PROGRAM.CURRENCY_IMGS_FOLDER ""), "D")
	FileCreateDir,% PROGRAM.CURRENCY_IMGS_FOLDER ""

if (A_IsCompiled) {
	sourceFileSize := Get_ResourceSize("resources\currency_imgs\Orb of Augmentation.png")
	FileGetSize, destFileSize, % PROGRAM.CURRENCY_IMGS_FOLDER "\Orb of Augmentation.png"
}
else {
	FileGetSize, sourceFileSize, resources\currency_imgs\Orb of Augmentation.png
	FileGetSize, destFileSize, % PROGRAM.CURRENCY_IMGS_FOLDER "\Orb of Augmentation.png"
}
if (sourceFileSize != destFileSize)
	FileInstall, resources\currency_imgs\Orb of Augmentation.png, % PROGRAM.CURRENCY_IMGS_FOLDER "\Orb of Augmentation.png", 1
if (ErrorLevel) {
	AppendToLogs("Failed to extract file!"
	.	"`nSource: resources\currency_imgs\Orb of Augmentation.png"
	.	"`nDest: " PROGRAM.CURRENCY_IMGS_FOLDER "\Orb of Augmentation.png"
	.	"`nFlag: " 2)
	errorLog .= "`n`n""Failed to extract file!"
	.	"`nSource: resources\currency_imgs\Orb of Augmentation.png"
	.	"`nDest: " PROGRAM.CURRENCY_IMGS_FOLDER "\Orb of Augmentation.png"
	.	"`nFlag: " 2
}

; ----------------------------
if !InStr(FileExist(PROGRAM.CURRENCY_IMGS_FOLDER ""), "D")
	FileCreateDir,% PROGRAM.CURRENCY_IMGS_FOLDER ""

if (A_IsCompiled) {
	sourceFileSize := Get_ResourceSize("resources\currency_imgs\Orb of Binding.png")
	FileGetSize, destFileSize, % PROGRAM.CURRENCY_IMGS_FOLDER "\Orb of Binding.png"
}
else {
	FileGetSize, sourceFileSize, resources\currency_imgs\Orb of Binding.png
	FileGetSize, destFileSize, % PROGRAM.CURRENCY_IMGS_FOLDER "\Orb of Binding.png"
}
if (sourceFileSize != destFileSize)
	FileInstall, resources\currency_imgs\Orb of Binding.png, % PROGRAM.CURRENCY_IMGS_FOLDER "\Orb of Binding.png", 1
if (ErrorLevel) {
	AppendToLogs("Failed to extract file!"
	.	"`nSource: resources\currency_imgs\Orb of Binding.png"
	.	"`nDest: " PROGRAM.CURRENCY_IMGS_FOLDER "\Orb of Binding.png"
	.	"`nFlag: " 2)
	errorLog .= "`n`n""Failed to extract file!"
	.	"`nSource: resources\currency_imgs\Orb of Binding.png"
	.	"`nDest: " PROGRAM.CURRENCY_IMGS_FOLDER "\Orb of Binding.png"
	.	"`nFlag: " 2
}

; ----------------------------
if !InStr(FileExist(PROGRAM.CURRENCY_IMGS_FOLDER ""), "D")
	FileCreateDir,% PROGRAM.CURRENCY_IMGS_FOLDER ""

if (A_IsCompiled) {
	sourceFileSize := Get_ResourceSize("resources\currency_imgs\Orb of Chance.png")
	FileGetSize, destFileSize, % PROGRAM.CURRENCY_IMGS_FOLDER "\Orb of Chance.png"
}
else {
	FileGetSize, sourceFileSize, resources\currency_imgs\Orb of Chance.png
	FileGetSize, destFileSize, % PROGRAM.CURRENCY_IMGS_FOLDER "\Orb of Chance.png"
}
if (sourceFileSize != destFileSize)
	FileInstall, resources\currency_imgs\Orb of Chance.png, % PROGRAM.CURRENCY_IMGS_FOLDER "\Orb of Chance.png", 1
if (ErrorLevel) {
	AppendToLogs("Failed to extract file!"
	.	"`nSource: resources\currency_imgs\Orb of Chance.png"
	.	"`nDest: " PROGRAM.CURRENCY_IMGS_FOLDER "\Orb of Chance.png"
	.	"`nFlag: " 2)
	errorLog .= "`n`n""Failed to extract file!"
	.	"`nSource: resources\currency_imgs\Orb of Chance.png"
	.	"`nDest: " PROGRAM.CURRENCY_IMGS_FOLDER "\Orb of Chance.png"
	.	"`nFlag: " 2
}

; ----------------------------
if !InStr(FileExist(PROGRAM.CURRENCY_IMGS_FOLDER ""), "D")
	FileCreateDir,% PROGRAM.CURRENCY_IMGS_FOLDER ""

if (A_IsCompiled) {
	sourceFileSize := Get_ResourceSize("resources\currency_imgs\Orb of Fusing.png")
	FileGetSize, destFileSize, % PROGRAM.CURRENCY_IMGS_FOLDER "\Orb of Fusing.png"
}
else {
	FileGetSize, sourceFileSize, resources\currency_imgs\Orb of Fusing.png
	FileGetSize, destFileSize, % PROGRAM.CURRENCY_IMGS_FOLDER "\Orb of Fusing.png"
}
if (sourceFileSize != destFileSize)
	FileInstall, resources\currency_imgs\Orb of Fusing.png, % PROGRAM.CURRENCY_IMGS_FOLDER "\Orb of Fusing.png", 1
if (ErrorLevel) {
	AppendToLogs("Failed to extract file!"
	.	"`nSource: resources\currency_imgs\Orb of Fusing.png"
	.	"`nDest: " PROGRAM.CURRENCY_IMGS_FOLDER "\Orb of Fusing.png"
	.	"`nFlag: " 2)
	errorLog .= "`n`n""Failed to extract file!"
	.	"`nSource: resources\currency_imgs\Orb of Fusing.png"
	.	"`nDest: " PROGRAM.CURRENCY_IMGS_FOLDER "\Orb of Fusing.png"
	.	"`nFlag: " 2
}

; ----------------------------
if !InStr(FileExist(PROGRAM.CURRENCY_IMGS_FOLDER ""), "D")
	FileCreateDir,% PROGRAM.CURRENCY_IMGS_FOLDER ""

if (A_IsCompiled) {
	sourceFileSize := Get_ResourceSize("resources\currency_imgs\Orb of Horizons.png")
	FileGetSize, destFileSize, % PROGRAM.CURRENCY_IMGS_FOLDER "\Orb of Horizons.png"
}
else {
	FileGetSize, sourceFileSize, resources\currency_imgs\Orb of Horizons.png
	FileGetSize, destFileSize, % PROGRAM.CURRENCY_IMGS_FOLDER "\Orb of Horizons.png"
}
if (sourceFileSize != destFileSize)
	FileInstall, resources\currency_imgs\Orb of Horizons.png, % PROGRAM.CURRENCY_IMGS_FOLDER "\Orb of Horizons.png", 1
if (ErrorLevel) {
	AppendToLogs("Failed to extract file!"
	.	"`nSource: resources\currency_imgs\Orb of Horizons.png"
	.	"`nDest: " PROGRAM.CURRENCY_IMGS_FOLDER "\Orb of Horizons.png"
	.	"`nFlag: " 2)
	errorLog .= "`n`n""Failed to extract file!"
	.	"`nSource: resources\currency_imgs\Orb of Horizons.png"
	.	"`nDest: " PROGRAM.CURRENCY_IMGS_FOLDER "\Orb of Horizons.png"
	.	"`nFlag: " 2
}

; ----------------------------
if !InStr(FileExist(PROGRAM.CURRENCY_IMGS_FOLDER ""), "D")
	FileCreateDir,% PROGRAM.CURRENCY_IMGS_FOLDER ""

if (A_IsCompiled) {
	sourceFileSize := Get_ResourceSize("resources\currency_imgs\Orb of Regret.png")
	FileGetSize, destFileSize, % PROGRAM.CURRENCY_IMGS_FOLDER "\Orb of Regret.png"
}
else {
	FileGetSize, sourceFileSize, resources\currency_imgs\Orb of Regret.png
	FileGetSize, destFileSize, % PROGRAM.CURRENCY_IMGS_FOLDER "\Orb of Regret.png"
}
if (sourceFileSize != destFileSize)
	FileInstall, resources\currency_imgs\Orb of Regret.png, % PROGRAM.CURRENCY_IMGS_FOLDER "\Orb of Regret.png", 1
if (ErrorLevel) {
	AppendToLogs("Failed to extract file!"
	.	"`nSource: resources\currency_imgs\Orb of Regret.png"
	.	"`nDest: " PROGRAM.CURRENCY_IMGS_FOLDER "\Orb of Regret.png"
	.	"`nFlag: " 2)
	errorLog .= "`n`n""Failed to extract file!"
	.	"`nSource: resources\currency_imgs\Orb of Regret.png"
	.	"`nDest: " PROGRAM.CURRENCY_IMGS_FOLDER "\Orb of Regret.png"
	.	"`nFlag: " 2
}

; ----------------------------
if !InStr(FileExist(PROGRAM.CURRENCY_IMGS_FOLDER ""), "D")
	FileCreateDir,% PROGRAM.CURRENCY_IMGS_FOLDER ""

if (A_IsCompiled) {
	sourceFileSize := Get_ResourceSize("resources\currency_imgs\Orb of Scouring.png")
	FileGetSize, destFileSize, % PROGRAM.CURRENCY_IMGS_FOLDER "\Orb of Scouring.png"
}
else {
	FileGetSize, sourceFileSize, resources\currency_imgs\Orb of Scouring.png
	FileGetSize, destFileSize, % PROGRAM.CURRENCY_IMGS_FOLDER "\Orb of Scouring.png"
}
if (sourceFileSize != destFileSize)
	FileInstall, resources\currency_imgs\Orb of Scouring.png, % PROGRAM.CURRENCY_IMGS_FOLDER "\Orb of Scouring.png", 1
if (ErrorLevel) {
	AppendToLogs("Failed to extract file!"
	.	"`nSource: resources\currency_imgs\Orb of Scouring.png"
	.	"`nDest: " PROGRAM.CURRENCY_IMGS_FOLDER "\Orb of Scouring.png"
	.	"`nFlag: " 2)
	errorLog .= "`n`n""Failed to extract file!"
	.	"`nSource: resources\currency_imgs\Orb of Scouring.png"
	.	"`nDest: " PROGRAM.CURRENCY_IMGS_FOLDER "\Orb of Scouring.png"
	.	"`nFlag: " 2
}

; ----------------------------
if !InStr(FileExist(PROGRAM.CURRENCY_IMGS_FOLDER ""), "D")
	FileCreateDir,% PROGRAM.CURRENCY_IMGS_FOLDER ""

if (A_IsCompiled) {
	sourceFileSize := Get_ResourceSize("resources\currency_imgs\Orb of Transmutation.png")
	FileGetSize, destFileSize, % PROGRAM.CURRENCY_IMGS_FOLDER "\Orb of Transmutation.png"
}
else {
	FileGetSize, sourceFileSize, resources\currency_imgs\Orb of Transmutation.png
	FileGetSize, destFileSize, % PROGRAM.CURRENCY_IMGS_FOLDER "\Orb of Transmutation.png"
}
if (sourceFileSize != destFileSize)
	FileInstall, resources\currency_imgs\Orb of Transmutation.png, % PROGRAM.CURRENCY_IMGS_FOLDER "\Orb of Transmutation.png", 1
if (ErrorLevel) {
	AppendToLogs("Failed to extract file!"
	.	"`nSource: resources\currency_imgs\Orb of Transmutation.png"
	.	"`nDest: " PROGRAM.CURRENCY_IMGS_FOLDER "\Orb of Transmutation.png"
	.	"`nFlag: " 2)
	errorLog .= "`n`n""Failed to extract file!"
	.	"`nSource: resources\currency_imgs\Orb of Transmutation.png"
	.	"`nDest: " PROGRAM.CURRENCY_IMGS_FOLDER "\Orb of Transmutation.png"
	.	"`nFlag: " 2
}

; ----------------------------
if !InStr(FileExist(PROGRAM.CURRENCY_IMGS_FOLDER ""), "D")
	FileCreateDir,% PROGRAM.CURRENCY_IMGS_FOLDER ""

if (A_IsCompiled) {
	sourceFileSize := Get_ResourceSize("resources\currency_imgs\Pale Court Set.png")
	FileGetSize, destFileSize, % PROGRAM.CURRENCY_IMGS_FOLDER "\Pale Court Set.png"
}
else {
	FileGetSize, sourceFileSize, resources\currency_imgs\Pale Court Set.png
	FileGetSize, destFileSize, % PROGRAM.CURRENCY_IMGS_FOLDER "\Pale Court Set.png"
}
if (sourceFileSize != destFileSize)
	FileInstall, resources\currency_imgs\Pale Court Set.png, % PROGRAM.CURRENCY_IMGS_FOLDER "\Pale Court Set.png", 1
if (ErrorLevel) {
	AppendToLogs("Failed to extract file!"
	.	"`nSource: resources\currency_imgs\Pale Court Set.png"
	.	"`nDest: " PROGRAM.CURRENCY_IMGS_FOLDER "\Pale Court Set.png"
	.	"`nFlag: " 2)
	errorLog .= "`n`n""Failed to extract file!"
	.	"`nSource: resources\currency_imgs\Pale Court Set.png"
	.	"`nDest: " PROGRAM.CURRENCY_IMGS_FOLDER "\Pale Court Set.png"
	.	"`nFlag: " 2
}

; ----------------------------
if !InStr(FileExist(PROGRAM.CURRENCY_IMGS_FOLDER ""), "D")
	FileCreateDir,% PROGRAM.CURRENCY_IMGS_FOLDER ""

if (A_IsCompiled) {
	sourceFileSize := Get_ResourceSize("resources\currency_imgs\Perandus Coin.png")
	FileGetSize, destFileSize, % PROGRAM.CURRENCY_IMGS_FOLDER "\Perandus Coin.png"
}
else {
	FileGetSize, sourceFileSize, resources\currency_imgs\Perandus Coin.png
	FileGetSize, destFileSize, % PROGRAM.CURRENCY_IMGS_FOLDER "\Perandus Coin.png"
}
if (sourceFileSize != destFileSize)
	FileInstall, resources\currency_imgs\Perandus Coin.png, % PROGRAM.CURRENCY_IMGS_FOLDER "\Perandus Coin.png", 1
if (ErrorLevel) {
	AppendToLogs("Failed to extract file!"
	.	"`nSource: resources\currency_imgs\Perandus Coin.png"
	.	"`nDest: " PROGRAM.CURRENCY_IMGS_FOLDER "\Perandus Coin.png"
	.	"`nFlag: " 2)
	errorLog .= "`n`n""Failed to extract file!"
	.	"`nSource: resources\currency_imgs\Perandus Coin.png"
	.	"`nDest: " PROGRAM.CURRENCY_IMGS_FOLDER "\Perandus Coin.png"
	.	"`nFlag: " 2
}

; ----------------------------
if !InStr(FileExist(PROGRAM.CURRENCY_IMGS_FOLDER ""), "D")
	FileCreateDir,% PROGRAM.CURRENCY_IMGS_FOLDER ""

if (A_IsCompiled) {
	sourceFileSize := Get_ResourceSize("resources\currency_imgs\Portal Scroll.png")
	FileGetSize, destFileSize, % PROGRAM.CURRENCY_IMGS_FOLDER "\Portal Scroll.png"
}
else {
	FileGetSize, sourceFileSize, resources\currency_imgs\Portal Scroll.png
	FileGetSize, destFileSize, % PROGRAM.CURRENCY_IMGS_FOLDER "\Portal Scroll.png"
}
if (sourceFileSize != destFileSize)
	FileInstall, resources\currency_imgs\Portal Scroll.png, % PROGRAM.CURRENCY_IMGS_FOLDER "\Portal Scroll.png", 1
if (ErrorLevel) {
	AppendToLogs("Failed to extract file!"
	.	"`nSource: resources\currency_imgs\Portal Scroll.png"
	.	"`nDest: " PROGRAM.CURRENCY_IMGS_FOLDER "\Portal Scroll.png"
	.	"`nFlag: " 2)
	errorLog .= "`n`n""Failed to extract file!"
	.	"`nSource: resources\currency_imgs\Portal Scroll.png"
	.	"`nDest: " PROGRAM.CURRENCY_IMGS_FOLDER "\Portal Scroll.png"
	.	"`nFlag: " 2
}

; ----------------------------
if !InStr(FileExist(PROGRAM.CURRENCY_IMGS_FOLDER ""), "D")
	FileCreateDir,% PROGRAM.CURRENCY_IMGS_FOLDER ""

if (A_IsCompiled) {
	sourceFileSize := Get_ResourceSize("resources\currency_imgs\Regal Orb.png")
	FileGetSize, destFileSize, % PROGRAM.CURRENCY_IMGS_FOLDER "\Regal Orb.png"
}
else {
	FileGetSize, sourceFileSize, resources\currency_imgs\Regal Orb.png
	FileGetSize, destFileSize, % PROGRAM.CURRENCY_IMGS_FOLDER "\Regal Orb.png"
}
if (sourceFileSize != destFileSize)
	FileInstall, resources\currency_imgs\Regal Orb.png, % PROGRAM.CURRENCY_IMGS_FOLDER "\Regal Orb.png", 1
if (ErrorLevel) {
	AppendToLogs("Failed to extract file!"
	.	"`nSource: resources\currency_imgs\Regal Orb.png"
	.	"`nDest: " PROGRAM.CURRENCY_IMGS_FOLDER "\Regal Orb.png"
	.	"`nFlag: " 2)
	errorLog .= "`n`n""Failed to extract file!"
	.	"`nSource: resources\currency_imgs\Regal Orb.png"
	.	"`nDest: " PROGRAM.CURRENCY_IMGS_FOLDER "\Regal Orb.png"
	.	"`nFlag: " 2
}

; ----------------------------
if !InStr(FileExist(PROGRAM.CURRENCY_IMGS_FOLDER ""), "D")
	FileCreateDir,% PROGRAM.CURRENCY_IMGS_FOLDER ""

if (A_IsCompiled) {
	sourceFileSize := Get_ResourceSize("resources\currency_imgs\Sacrifice at Dawn.png")
	FileGetSize, destFileSize, % PROGRAM.CURRENCY_IMGS_FOLDER "\Sacrifice at Dawn.png"
}
else {
	FileGetSize, sourceFileSize, resources\currency_imgs\Sacrifice at Dawn.png
	FileGetSize, destFileSize, % PROGRAM.CURRENCY_IMGS_FOLDER "\Sacrifice at Dawn.png"
}
if (sourceFileSize != destFileSize)
	FileInstall, resources\currency_imgs\Sacrifice at Dawn.png, % PROGRAM.CURRENCY_IMGS_FOLDER "\Sacrifice at Dawn.png", 1
if (ErrorLevel) {
	AppendToLogs("Failed to extract file!"
	.	"`nSource: resources\currency_imgs\Sacrifice at Dawn.png"
	.	"`nDest: " PROGRAM.CURRENCY_IMGS_FOLDER "\Sacrifice at Dawn.png"
	.	"`nFlag: " 2)
	errorLog .= "`n`n""Failed to extract file!"
	.	"`nSource: resources\currency_imgs\Sacrifice at Dawn.png"
	.	"`nDest: " PROGRAM.CURRENCY_IMGS_FOLDER "\Sacrifice at Dawn.png"
	.	"`nFlag: " 2
}

; ----------------------------
if !InStr(FileExist(PROGRAM.CURRENCY_IMGS_FOLDER ""), "D")
	FileCreateDir,% PROGRAM.CURRENCY_IMGS_FOLDER ""

if (A_IsCompiled) {
	sourceFileSize := Get_ResourceSize("resources\currency_imgs\Sacrifice at Dusk.png")
	FileGetSize, destFileSize, % PROGRAM.CURRENCY_IMGS_FOLDER "\Sacrifice at Dusk.png"
}
else {
	FileGetSize, sourceFileSize, resources\currency_imgs\Sacrifice at Dusk.png
	FileGetSize, destFileSize, % PROGRAM.CURRENCY_IMGS_FOLDER "\Sacrifice at Dusk.png"
}
if (sourceFileSize != destFileSize)
	FileInstall, resources\currency_imgs\Sacrifice at Dusk.png, % PROGRAM.CURRENCY_IMGS_FOLDER "\Sacrifice at Dusk.png", 1
if (ErrorLevel) {
	AppendToLogs("Failed to extract file!"
	.	"`nSource: resources\currency_imgs\Sacrifice at Dusk.png"
	.	"`nDest: " PROGRAM.CURRENCY_IMGS_FOLDER "\Sacrifice at Dusk.png"
	.	"`nFlag: " 2)
	errorLog .= "`n`n""Failed to extract file!"
	.	"`nSource: resources\currency_imgs\Sacrifice at Dusk.png"
	.	"`nDest: " PROGRAM.CURRENCY_IMGS_FOLDER "\Sacrifice at Dusk.png"
	.	"`nFlag: " 2
}

; ----------------------------
if !InStr(FileExist(PROGRAM.CURRENCY_IMGS_FOLDER ""), "D")
	FileCreateDir,% PROGRAM.CURRENCY_IMGS_FOLDER ""

if (A_IsCompiled) {
	sourceFileSize := Get_ResourceSize("resources\currency_imgs\Sacrifice at Midnight.png")
	FileGetSize, destFileSize, % PROGRAM.CURRENCY_IMGS_FOLDER "\Sacrifice at Midnight.png"
}
else {
	FileGetSize, sourceFileSize, resources\currency_imgs\Sacrifice at Midnight.png
	FileGetSize, destFileSize, % PROGRAM.CURRENCY_IMGS_FOLDER "\Sacrifice at Midnight.png"
}
if (sourceFileSize != destFileSize)
	FileInstall, resources\currency_imgs\Sacrifice at Midnight.png, % PROGRAM.CURRENCY_IMGS_FOLDER "\Sacrifice at Midnight.png", 1
if (ErrorLevel) {
	AppendToLogs("Failed to extract file!"
	.	"`nSource: resources\currency_imgs\Sacrifice at Midnight.png"
	.	"`nDest: " PROGRAM.CURRENCY_IMGS_FOLDER "\Sacrifice at Midnight.png"
	.	"`nFlag: " 2)
	errorLog .= "`n`n""Failed to extract file!"
	.	"`nSource: resources\currency_imgs\Sacrifice at Midnight.png"
	.	"`nDest: " PROGRAM.CURRENCY_IMGS_FOLDER "\Sacrifice at Midnight.png"
	.	"`nFlag: " 2
}

; ----------------------------
if !InStr(FileExist(PROGRAM.CURRENCY_IMGS_FOLDER ""), "D")
	FileCreateDir,% PROGRAM.CURRENCY_IMGS_FOLDER ""

if (A_IsCompiled) {
	sourceFileSize := Get_ResourceSize("resources\currency_imgs\Sacrifice at Noon.png")
	FileGetSize, destFileSize, % PROGRAM.CURRENCY_IMGS_FOLDER "\Sacrifice at Noon.png"
}
else {
	FileGetSize, sourceFileSize, resources\currency_imgs\Sacrifice at Noon.png
	FileGetSize, destFileSize, % PROGRAM.CURRENCY_IMGS_FOLDER "\Sacrifice at Noon.png"
}
if (sourceFileSize != destFileSize)
	FileInstall, resources\currency_imgs\Sacrifice at Noon.png, % PROGRAM.CURRENCY_IMGS_FOLDER "\Sacrifice at Noon.png", 1
if (ErrorLevel) {
	AppendToLogs("Failed to extract file!"
	.	"`nSource: resources\currency_imgs\Sacrifice at Noon.png"
	.	"`nDest: " PROGRAM.CURRENCY_IMGS_FOLDER "\Sacrifice at Noon.png"
	.	"`nFlag: " 2)
	errorLog .= "`n`n""Failed to extract file!"
	.	"`nSource: resources\currency_imgs\Sacrifice at Noon.png"
	.	"`nDest: " PROGRAM.CURRENCY_IMGS_FOLDER "\Sacrifice at Noon.png"
	.	"`nFlag: " 2
}

; ----------------------------
if !InStr(FileExist(PROGRAM.CURRENCY_IMGS_FOLDER ""), "D")
	FileCreateDir,% PROGRAM.CURRENCY_IMGS_FOLDER ""

if (A_IsCompiled) {
	sourceFileSize := Get_ResourceSize("resources\currency_imgs\Sacrifice Set.png")
	FileGetSize, destFileSize, % PROGRAM.CURRENCY_IMGS_FOLDER "\Sacrifice Set.png"
}
else {
	FileGetSize, sourceFileSize, resources\currency_imgs\Sacrifice Set.png
	FileGetSize, destFileSize, % PROGRAM.CURRENCY_IMGS_FOLDER "\Sacrifice Set.png"
}
if (sourceFileSize != destFileSize)
	FileInstall, resources\currency_imgs\Sacrifice Set.png, % PROGRAM.CURRENCY_IMGS_FOLDER "\Sacrifice Set.png", 1
if (ErrorLevel) {
	AppendToLogs("Failed to extract file!"
	.	"`nSource: resources\currency_imgs\Sacrifice Set.png"
	.	"`nDest: " PROGRAM.CURRENCY_IMGS_FOLDER "\Sacrifice Set.png"
	.	"`nFlag: " 2)
	errorLog .= "`n`n""Failed to extract file!"
	.	"`nSource: resources\currency_imgs\Sacrifice Set.png"
	.	"`nDest: " PROGRAM.CURRENCY_IMGS_FOLDER "\Sacrifice Set.png"
	.	"`nFlag: " 2
}

; ----------------------------
if !InStr(FileExist(PROGRAM.CURRENCY_IMGS_FOLDER ""), "D")
	FileCreateDir,% PROGRAM.CURRENCY_IMGS_FOLDER ""

if (A_IsCompiled) {
	sourceFileSize := Get_ResourceSize("resources\currency_imgs\Scroll of Wisdom.png")
	FileGetSize, destFileSize, % PROGRAM.CURRENCY_IMGS_FOLDER "\Scroll of Wisdom.png"
}
else {
	FileGetSize, sourceFileSize, resources\currency_imgs\Scroll of Wisdom.png
	FileGetSize, destFileSize, % PROGRAM.CURRENCY_IMGS_FOLDER "\Scroll of Wisdom.png"
}
if (sourceFileSize != destFileSize)
	FileInstall, resources\currency_imgs\Scroll of Wisdom.png, % PROGRAM.CURRENCY_IMGS_FOLDER "\Scroll of Wisdom.png", 1
if (ErrorLevel) {
	AppendToLogs("Failed to extract file!"
	.	"`nSource: resources\currency_imgs\Scroll of Wisdom.png"
	.	"`nDest: " PROGRAM.CURRENCY_IMGS_FOLDER "\Scroll of Wisdom.png"
	.	"`nFlag: " 2)
	errorLog .= "`n`n""Failed to extract file!"
	.	"`nSource: resources\currency_imgs\Scroll of Wisdom.png"
	.	"`nDest: " PROGRAM.CURRENCY_IMGS_FOLDER "\Scroll of Wisdom.png"
	.	"`nFlag: " 2
}

; ----------------------------
if !InStr(FileExist(PROGRAM.CURRENCY_IMGS_FOLDER ""), "D")
	FileCreateDir,% PROGRAM.CURRENCY_IMGS_FOLDER ""

if (A_IsCompiled) {
	sourceFileSize := Get_ResourceSize("resources\currency_imgs\Shaper Set.png")
	FileGetSize, destFileSize, % PROGRAM.CURRENCY_IMGS_FOLDER "\Shaper Set.png"
}
else {
	FileGetSize, sourceFileSize, resources\currency_imgs\Shaper Set.png
	FileGetSize, destFileSize, % PROGRAM.CURRENCY_IMGS_FOLDER "\Shaper Set.png"
}
if (sourceFileSize != destFileSize)
	FileInstall, resources\currency_imgs\Shaper Set.png, % PROGRAM.CURRENCY_IMGS_FOLDER "\Shaper Set.png", 1
if (ErrorLevel) {
	AppendToLogs("Failed to extract file!"
	.	"`nSource: resources\currency_imgs\Shaper Set.png"
	.	"`nDest: " PROGRAM.CURRENCY_IMGS_FOLDER "\Shaper Set.png"
	.	"`nFlag: " 2)
	errorLog .= "`n`n""Failed to extract file!"
	.	"`nSource: resources\currency_imgs\Shaper Set.png"
	.	"`nDest: " PROGRAM.CURRENCY_IMGS_FOLDER "\Shaper Set.png"
	.	"`nFlag: " 2
}

; ----------------------------
if !InStr(FileExist(PROGRAM.CURRENCY_IMGS_FOLDER ""), "D")
	FileCreateDir,% PROGRAM.CURRENCY_IMGS_FOLDER ""

if (A_IsCompiled) {
	sourceFileSize := Get_ResourceSize("resources\currency_imgs\Silver Coin.png")
	FileGetSize, destFileSize, % PROGRAM.CURRENCY_IMGS_FOLDER "\Silver Coin.png"
}
else {
	FileGetSize, sourceFileSize, resources\currency_imgs\Silver Coin.png
	FileGetSize, destFileSize, % PROGRAM.CURRENCY_IMGS_FOLDER "\Silver Coin.png"
}
if (sourceFileSize != destFileSize)
	FileInstall, resources\currency_imgs\Silver Coin.png, % PROGRAM.CURRENCY_IMGS_FOLDER "\Silver Coin.png", 1
if (ErrorLevel) {
	AppendToLogs("Failed to extract file!"
	.	"`nSource: resources\currency_imgs\Silver Coin.png"
	.	"`nDest: " PROGRAM.CURRENCY_IMGS_FOLDER "\Silver Coin.png"
	.	"`nFlag: " 2)
	errorLog .= "`n`n""Failed to extract file!"
	.	"`nSource: resources\currency_imgs\Silver Coin.png"
	.	"`nDest: " PROGRAM.CURRENCY_IMGS_FOLDER "\Silver Coin.png"
	.	"`nFlag: " 2
}

; ----------------------------
if !InStr(FileExist(PROGRAM.CURRENCY_IMGS_FOLDER ""), "D")
	FileCreateDir,% PROGRAM.CURRENCY_IMGS_FOLDER ""

if (A_IsCompiled) {
	sourceFileSize := Get_ResourceSize("resources\currency_imgs\Splinter of Chayula.png")
	FileGetSize, destFileSize, % PROGRAM.CURRENCY_IMGS_FOLDER "\Splinter of Chayula.png"
}
else {
	FileGetSize, sourceFileSize, resources\currency_imgs\Splinter of Chayula.png
	FileGetSize, destFileSize, % PROGRAM.CURRENCY_IMGS_FOLDER "\Splinter of Chayula.png"
}
if (sourceFileSize != destFileSize)
	FileInstall, resources\currency_imgs\Splinter of Chayula.png, % PROGRAM.CURRENCY_IMGS_FOLDER "\Splinter of Chayula.png", 1
if (ErrorLevel) {
	AppendToLogs("Failed to extract file!"
	.	"`nSource: resources\currency_imgs\Splinter of Chayula.png"
	.	"`nDest: " PROGRAM.CURRENCY_IMGS_FOLDER "\Splinter of Chayula.png"
	.	"`nFlag: " 2)
	errorLog .= "`n`n""Failed to extract file!"
	.	"`nSource: resources\currency_imgs\Splinter of Chayula.png"
	.	"`nDest: " PROGRAM.CURRENCY_IMGS_FOLDER "\Splinter of Chayula.png"
	.	"`nFlag: " 2
}

; ----------------------------
if !InStr(FileExist(PROGRAM.CURRENCY_IMGS_FOLDER ""), "D")
	FileCreateDir,% PROGRAM.CURRENCY_IMGS_FOLDER ""

if (A_IsCompiled) {
	sourceFileSize := Get_ResourceSize("resources\currency_imgs\Splinter of Esh.png")
	FileGetSize, destFileSize, % PROGRAM.CURRENCY_IMGS_FOLDER "\Splinter of Esh.png"
}
else {
	FileGetSize, sourceFileSize, resources\currency_imgs\Splinter of Esh.png
	FileGetSize, destFileSize, % PROGRAM.CURRENCY_IMGS_FOLDER "\Splinter of Esh.png"
}
if (sourceFileSize != destFileSize)
	FileInstall, resources\currency_imgs\Splinter of Esh.png, % PROGRAM.CURRENCY_IMGS_FOLDER "\Splinter of Esh.png", 1
if (ErrorLevel) {
	AppendToLogs("Failed to extract file!"
	.	"`nSource: resources\currency_imgs\Splinter of Esh.png"
	.	"`nDest: " PROGRAM.CURRENCY_IMGS_FOLDER "\Splinter of Esh.png"
	.	"`nFlag: " 2)
	errorLog .= "`n`n""Failed to extract file!"
	.	"`nSource: resources\currency_imgs\Splinter of Esh.png"
	.	"`nDest: " PROGRAM.CURRENCY_IMGS_FOLDER "\Splinter of Esh.png"
	.	"`nFlag: " 2
}

; ----------------------------
if !InStr(FileExist(PROGRAM.CURRENCY_IMGS_FOLDER ""), "D")
	FileCreateDir,% PROGRAM.CURRENCY_IMGS_FOLDER ""

if (A_IsCompiled) {
	sourceFileSize := Get_ResourceSize("resources\currency_imgs\Splinter of Tul.png")
	FileGetSize, destFileSize, % PROGRAM.CURRENCY_IMGS_FOLDER "\Splinter of Tul.png"
}
else {
	FileGetSize, sourceFileSize, resources\currency_imgs\Splinter of Tul.png
	FileGetSize, destFileSize, % PROGRAM.CURRENCY_IMGS_FOLDER "\Splinter of Tul.png"
}
if (sourceFileSize != destFileSize)
	FileInstall, resources\currency_imgs\Splinter of Tul.png, % PROGRAM.CURRENCY_IMGS_FOLDER "\Splinter of Tul.png", 1
if (ErrorLevel) {
	AppendToLogs("Failed to extract file!"
	.	"`nSource: resources\currency_imgs\Splinter of Tul.png"
	.	"`nDest: " PROGRAM.CURRENCY_IMGS_FOLDER "\Splinter of Tul.png"
	.	"`nFlag: " 2)
	errorLog .= "`n`n""Failed to extract file!"
	.	"`nSource: resources\currency_imgs\Splinter of Tul.png"
	.	"`nDest: " PROGRAM.CURRENCY_IMGS_FOLDER "\Splinter of Tul.png"
	.	"`nFlag: " 2
}

; ----------------------------
if !InStr(FileExist(PROGRAM.CURRENCY_IMGS_FOLDER ""), "D")
	FileCreateDir,% PROGRAM.CURRENCY_IMGS_FOLDER ""

if (A_IsCompiled) {
	sourceFileSize := Get_ResourceSize("resources\currency_imgs\Splinter of Uul-Netol.png")
	FileGetSize, destFileSize, % PROGRAM.CURRENCY_IMGS_FOLDER "\Splinter of Uul-Netol.png"
}
else {
	FileGetSize, sourceFileSize, resources\currency_imgs\Splinter of Uul-Netol.png
	FileGetSize, destFileSize, % PROGRAM.CURRENCY_IMGS_FOLDER "\Splinter of Uul-Netol.png"
}
if (sourceFileSize != destFileSize)
	FileInstall, resources\currency_imgs\Splinter of Uul-Netol.png, % PROGRAM.CURRENCY_IMGS_FOLDER "\Splinter of Uul-Netol.png", 1
if (ErrorLevel) {
	AppendToLogs("Failed to extract file!"
	.	"`nSource: resources\currency_imgs\Splinter of Uul-Netol.png"
	.	"`nDest: " PROGRAM.CURRENCY_IMGS_FOLDER "\Splinter of Uul-Netol.png"
	.	"`nFlag: " 2)
	errorLog .= "`n`n""Failed to extract file!"
	.	"`nSource: resources\currency_imgs\Splinter of Uul-Netol.png"
	.	"`nDest: " PROGRAM.CURRENCY_IMGS_FOLDER "\Splinter of Uul-Netol.png"
	.	"`nFlag: " 2
}

; ----------------------------
if !InStr(FileExist(PROGRAM.CURRENCY_IMGS_FOLDER ""), "D")
	FileCreateDir,% PROGRAM.CURRENCY_IMGS_FOLDER ""

if (A_IsCompiled) {
	sourceFileSize := Get_ResourceSize("resources\currency_imgs\Splinter of Xoph.png")
	FileGetSize, destFileSize, % PROGRAM.CURRENCY_IMGS_FOLDER "\Splinter of Xoph.png"
}
else {
	FileGetSize, sourceFileSize, resources\currency_imgs\Splinter of Xoph.png
	FileGetSize, destFileSize, % PROGRAM.CURRENCY_IMGS_FOLDER "\Splinter of Xoph.png"
}
if (sourceFileSize != destFileSize)
	FileInstall, resources\currency_imgs\Splinter of Xoph.png, % PROGRAM.CURRENCY_IMGS_FOLDER "\Splinter of Xoph.png", 1
if (ErrorLevel) {
	AppendToLogs("Failed to extract file!"
	.	"`nSource: resources\currency_imgs\Splinter of Xoph.png"
	.	"`nDest: " PROGRAM.CURRENCY_IMGS_FOLDER "\Splinter of Xoph.png"
	.	"`nFlag: " 2)
	errorLog .= "`n`n""Failed to extract file!"
	.	"`nSource: resources\currency_imgs\Splinter of Xoph.png"
	.	"`nDest: " PROGRAM.CURRENCY_IMGS_FOLDER "\Splinter of Xoph.png"
	.	"`nFlag: " 2
}

; ----------------------------
if !InStr(FileExist(PROGRAM.CURRENCY_IMGS_FOLDER ""), "D")
	FileCreateDir,% PROGRAM.CURRENCY_IMGS_FOLDER ""

if (A_IsCompiled) {
	sourceFileSize := Get_ResourceSize("resources\currency_imgs\Stacked Deck.png")
	FileGetSize, destFileSize, % PROGRAM.CURRENCY_IMGS_FOLDER "\Stacked Deck.png"
}
else {
	FileGetSize, sourceFileSize, resources\currency_imgs\Stacked Deck.png
	FileGetSize, destFileSize, % PROGRAM.CURRENCY_IMGS_FOLDER "\Stacked Deck.png"
}
if (sourceFileSize != destFileSize)
	FileInstall, resources\currency_imgs\Stacked Deck.png, % PROGRAM.CURRENCY_IMGS_FOLDER "\Stacked Deck.png", 1
if (ErrorLevel) {
	AppendToLogs("Failed to extract file!"
	.	"`nSource: resources\currency_imgs\Stacked Deck.png"
	.	"`nDest: " PROGRAM.CURRENCY_IMGS_FOLDER "\Stacked Deck.png"
	.	"`nFlag: " 2)
	errorLog .= "`n`n""Failed to extract file!"
	.	"`nSource: resources\currency_imgs\Stacked Deck.png"
	.	"`nDest: " PROGRAM.CURRENCY_IMGS_FOLDER "\Stacked Deck.png"
	.	"`nFlag: " 2
}

; ----------------------------
if !InStr(FileExist(PROGRAM.CURRENCY_IMGS_FOLDER ""), "D")
	FileCreateDir,% PROGRAM.CURRENCY_IMGS_FOLDER ""

if (A_IsCompiled) {
	sourceFileSize := Get_ResourceSize("resources\currency_imgs\Timeless Eternal Emblem.png")
	FileGetSize, destFileSize, % PROGRAM.CURRENCY_IMGS_FOLDER "\Timeless Eternal Emblem.png"
}
else {
	FileGetSize, sourceFileSize, resources\currency_imgs\Timeless Eternal Emblem.png
	FileGetSize, destFileSize, % PROGRAM.CURRENCY_IMGS_FOLDER "\Timeless Eternal Emblem.png"
}
if (sourceFileSize != destFileSize)
	FileInstall, resources\currency_imgs\Timeless Eternal Emblem.png, % PROGRAM.CURRENCY_IMGS_FOLDER "\Timeless Eternal Emblem.png", 1
if (ErrorLevel) {
	AppendToLogs("Failed to extract file!"
	.	"`nSource: resources\currency_imgs\Timeless Eternal Emblem.png"
	.	"`nDest: " PROGRAM.CURRENCY_IMGS_FOLDER "\Timeless Eternal Emblem.png"
	.	"`nFlag: " 2)
	errorLog .= "`n`n""Failed to extract file!"
	.	"`nSource: resources\currency_imgs\Timeless Eternal Emblem.png"
	.	"`nDest: " PROGRAM.CURRENCY_IMGS_FOLDER "\Timeless Eternal Emblem.png"
	.	"`nFlag: " 2
}

; ----------------------------
if !InStr(FileExist(PROGRAM.CURRENCY_IMGS_FOLDER ""), "D")
	FileCreateDir,% PROGRAM.CURRENCY_IMGS_FOLDER ""

if (A_IsCompiled) {
	sourceFileSize := Get_ResourceSize("resources\currency_imgs\Timeless Eternal Empire Splinter.png")
	FileGetSize, destFileSize, % PROGRAM.CURRENCY_IMGS_FOLDER "\Timeless Eternal Empire Splinter.png"
}
else {
	FileGetSize, sourceFileSize, resources\currency_imgs\Timeless Eternal Empire Splinter.png
	FileGetSize, destFileSize, % PROGRAM.CURRENCY_IMGS_FOLDER "\Timeless Eternal Empire Splinter.png"
}
if (sourceFileSize != destFileSize)
	FileInstall, resources\currency_imgs\Timeless Eternal Empire Splinter.png, % PROGRAM.CURRENCY_IMGS_FOLDER "\Timeless Eternal Empire Splinter.png", 1
if (ErrorLevel) {
	AppendToLogs("Failed to extract file!"
	.	"`nSource: resources\currency_imgs\Timeless Eternal Empire Splinter.png"
	.	"`nDest: " PROGRAM.CURRENCY_IMGS_FOLDER "\Timeless Eternal Empire Splinter.png"
	.	"`nFlag: " 2)
	errorLog .= "`n`n""Failed to extract file!"
	.	"`nSource: resources\currency_imgs\Timeless Eternal Empire Splinter.png"
	.	"`nDest: " PROGRAM.CURRENCY_IMGS_FOLDER "\Timeless Eternal Empire Splinter.png"
	.	"`nFlag: " 2
}

; ----------------------------
if !InStr(FileExist(PROGRAM.CURRENCY_IMGS_FOLDER ""), "D")
	FileCreateDir,% PROGRAM.CURRENCY_IMGS_FOLDER ""

if (A_IsCompiled) {
	sourceFileSize := Get_ResourceSize("resources\currency_imgs\Timeless Karui Emblem.png")
	FileGetSize, destFileSize, % PROGRAM.CURRENCY_IMGS_FOLDER "\Timeless Karui Emblem.png"
}
else {
	FileGetSize, sourceFileSize, resources\currency_imgs\Timeless Karui Emblem.png
	FileGetSize, destFileSize, % PROGRAM.CURRENCY_IMGS_FOLDER "\Timeless Karui Emblem.png"
}
if (sourceFileSize != destFileSize)
	FileInstall, resources\currency_imgs\Timeless Karui Emblem.png, % PROGRAM.CURRENCY_IMGS_FOLDER "\Timeless Karui Emblem.png", 1
if (ErrorLevel) {
	AppendToLogs("Failed to extract file!"
	.	"`nSource: resources\currency_imgs\Timeless Karui Emblem.png"
	.	"`nDest: " PROGRAM.CURRENCY_IMGS_FOLDER "\Timeless Karui Emblem.png"
	.	"`nFlag: " 2)
	errorLog .= "`n`n""Failed to extract file!"
	.	"`nSource: resources\currency_imgs\Timeless Karui Emblem.png"
	.	"`nDest: " PROGRAM.CURRENCY_IMGS_FOLDER "\Timeless Karui Emblem.png"
	.	"`nFlag: " 2
}

; ----------------------------
if !InStr(FileExist(PROGRAM.CURRENCY_IMGS_FOLDER ""), "D")
	FileCreateDir,% PROGRAM.CURRENCY_IMGS_FOLDER ""

if (A_IsCompiled) {
	sourceFileSize := Get_ResourceSize("resources\currency_imgs\Timeless Karui Splinter.png")
	FileGetSize, destFileSize, % PROGRAM.CURRENCY_IMGS_FOLDER "\Timeless Karui Splinter.png"
}
else {
	FileGetSize, sourceFileSize, resources\currency_imgs\Timeless Karui Splinter.png
	FileGetSize, destFileSize, % PROGRAM.CURRENCY_IMGS_FOLDER "\Timeless Karui Splinter.png"
}
if (sourceFileSize != destFileSize)
	FileInstall, resources\currency_imgs\Timeless Karui Splinter.png, % PROGRAM.CURRENCY_IMGS_FOLDER "\Timeless Karui Splinter.png", 1
if (ErrorLevel) {
	AppendToLogs("Failed to extract file!"
	.	"`nSource: resources\currency_imgs\Timeless Karui Splinter.png"
	.	"`nDest: " PROGRAM.CURRENCY_IMGS_FOLDER "\Timeless Karui Splinter.png"
	.	"`nFlag: " 2)
	errorLog .= "`n`n""Failed to extract file!"
	.	"`nSource: resources\currency_imgs\Timeless Karui Splinter.png"
	.	"`nDest: " PROGRAM.CURRENCY_IMGS_FOLDER "\Timeless Karui Splinter.png"
	.	"`nFlag: " 2
}

; ----------------------------
if !InStr(FileExist(PROGRAM.CURRENCY_IMGS_FOLDER ""), "D")
	FileCreateDir,% PROGRAM.CURRENCY_IMGS_FOLDER ""

if (A_IsCompiled) {
	sourceFileSize := Get_ResourceSize("resources\currency_imgs\Timeless Maraketh Emblem.png")
	FileGetSize, destFileSize, % PROGRAM.CURRENCY_IMGS_FOLDER "\Timeless Maraketh Emblem.png"
}
else {
	FileGetSize, sourceFileSize, resources\currency_imgs\Timeless Maraketh Emblem.png
	FileGetSize, destFileSize, % PROGRAM.CURRENCY_IMGS_FOLDER "\Timeless Maraketh Emblem.png"
}
if (sourceFileSize != destFileSize)
	FileInstall, resources\currency_imgs\Timeless Maraketh Emblem.png, % PROGRAM.CURRENCY_IMGS_FOLDER "\Timeless Maraketh Emblem.png", 1
if (ErrorLevel) {
	AppendToLogs("Failed to extract file!"
	.	"`nSource: resources\currency_imgs\Timeless Maraketh Emblem.png"
	.	"`nDest: " PROGRAM.CURRENCY_IMGS_FOLDER "\Timeless Maraketh Emblem.png"
	.	"`nFlag: " 2)
	errorLog .= "`n`n""Failed to extract file!"
	.	"`nSource: resources\currency_imgs\Timeless Maraketh Emblem.png"
	.	"`nDest: " PROGRAM.CURRENCY_IMGS_FOLDER "\Timeless Maraketh Emblem.png"
	.	"`nFlag: " 2
}

; ----------------------------
if !InStr(FileExist(PROGRAM.CURRENCY_IMGS_FOLDER ""), "D")
	FileCreateDir,% PROGRAM.CURRENCY_IMGS_FOLDER ""

if (A_IsCompiled) {
	sourceFileSize := Get_ResourceSize("resources\currency_imgs\Timeless Maraketh Splinter.png")
	FileGetSize, destFileSize, % PROGRAM.CURRENCY_IMGS_FOLDER "\Timeless Maraketh Splinter.png"
}
else {
	FileGetSize, sourceFileSize, resources\currency_imgs\Timeless Maraketh Splinter.png
	FileGetSize, destFileSize, % PROGRAM.CURRENCY_IMGS_FOLDER "\Timeless Maraketh Splinter.png"
}
if (sourceFileSize != destFileSize)
	FileInstall, resources\currency_imgs\Timeless Maraketh Splinter.png, % PROGRAM.CURRENCY_IMGS_FOLDER "\Timeless Maraketh Splinter.png", 1
if (ErrorLevel) {
	AppendToLogs("Failed to extract file!"
	.	"`nSource: resources\currency_imgs\Timeless Maraketh Splinter.png"
	.	"`nDest: " PROGRAM.CURRENCY_IMGS_FOLDER "\Timeless Maraketh Splinter.png"
	.	"`nFlag: " 2)
	errorLog .= "`n`n""Failed to extract file!"
	.	"`nSource: resources\currency_imgs\Timeless Maraketh Splinter.png"
	.	"`nDest: " PROGRAM.CURRENCY_IMGS_FOLDER "\Timeless Maraketh Splinter.png"
	.	"`nFlag: " 2
}

; ----------------------------
if !InStr(FileExist(PROGRAM.CURRENCY_IMGS_FOLDER ""), "D")
	FileCreateDir,% PROGRAM.CURRENCY_IMGS_FOLDER ""

if (A_IsCompiled) {
	sourceFileSize := Get_ResourceSize("resources\currency_imgs\Timeless Templar Emblem.png")
	FileGetSize, destFileSize, % PROGRAM.CURRENCY_IMGS_FOLDER "\Timeless Templar Emblem.png"
}
else {
	FileGetSize, sourceFileSize, resources\currency_imgs\Timeless Templar Emblem.png
	FileGetSize, destFileSize, % PROGRAM.CURRENCY_IMGS_FOLDER "\Timeless Templar Emblem.png"
}
if (sourceFileSize != destFileSize)
	FileInstall, resources\currency_imgs\Timeless Templar Emblem.png, % PROGRAM.CURRENCY_IMGS_FOLDER "\Timeless Templar Emblem.png", 1
if (ErrorLevel) {
	AppendToLogs("Failed to extract file!"
	.	"`nSource: resources\currency_imgs\Timeless Templar Emblem.png"
	.	"`nDest: " PROGRAM.CURRENCY_IMGS_FOLDER "\Timeless Templar Emblem.png"
	.	"`nFlag: " 2)
	errorLog .= "`n`n""Failed to extract file!"
	.	"`nSource: resources\currency_imgs\Timeless Templar Emblem.png"
	.	"`nDest: " PROGRAM.CURRENCY_IMGS_FOLDER "\Timeless Templar Emblem.png"
	.	"`nFlag: " 2
}

; ----------------------------
if !InStr(FileExist(PROGRAM.CURRENCY_IMGS_FOLDER ""), "D")
	FileCreateDir,% PROGRAM.CURRENCY_IMGS_FOLDER ""

if (A_IsCompiled) {
	sourceFileSize := Get_ResourceSize("resources\currency_imgs\Timeless Templar Splinter.png")
	FileGetSize, destFileSize, % PROGRAM.CURRENCY_IMGS_FOLDER "\Timeless Templar Splinter.png"
}
else {
	FileGetSize, sourceFileSize, resources\currency_imgs\Timeless Templar Splinter.png
	FileGetSize, destFileSize, % PROGRAM.CURRENCY_IMGS_FOLDER "\Timeless Templar Splinter.png"
}
if (sourceFileSize != destFileSize)
	FileInstall, resources\currency_imgs\Timeless Templar Splinter.png, % PROGRAM.CURRENCY_IMGS_FOLDER "\Timeless Templar Splinter.png", 1
if (ErrorLevel) {
	AppendToLogs("Failed to extract file!"
	.	"`nSource: resources\currency_imgs\Timeless Templar Splinter.png"
	.	"`nDest: " PROGRAM.CURRENCY_IMGS_FOLDER "\Timeless Templar Splinter.png"
	.	"`nFlag: " 2)
	errorLog .= "`n`n""Failed to extract file!"
	.	"`nSource: resources\currency_imgs\Timeless Templar Splinter.png"
	.	"`nDest: " PROGRAM.CURRENCY_IMGS_FOLDER "\Timeless Templar Splinter.png"
	.	"`nFlag: " 2
}

; ----------------------------
if !InStr(FileExist(PROGRAM.CURRENCY_IMGS_FOLDER ""), "D")
	FileCreateDir,% PROGRAM.CURRENCY_IMGS_FOLDER ""

if (A_IsCompiled) {
	sourceFileSize := Get_ResourceSize("resources\currency_imgs\Timeless Vaal Emblem.png")
	FileGetSize, destFileSize, % PROGRAM.CURRENCY_IMGS_FOLDER "\Timeless Vaal Emblem.png"
}
else {
	FileGetSize, sourceFileSize, resources\currency_imgs\Timeless Vaal Emblem.png
	FileGetSize, destFileSize, % PROGRAM.CURRENCY_IMGS_FOLDER "\Timeless Vaal Emblem.png"
}
if (sourceFileSize != destFileSize)
	FileInstall, resources\currency_imgs\Timeless Vaal Emblem.png, % PROGRAM.CURRENCY_IMGS_FOLDER "\Timeless Vaal Emblem.png", 1
if (ErrorLevel) {
	AppendToLogs("Failed to extract file!"
	.	"`nSource: resources\currency_imgs\Timeless Vaal Emblem.png"
	.	"`nDest: " PROGRAM.CURRENCY_IMGS_FOLDER "\Timeless Vaal Emblem.png"
	.	"`nFlag: " 2)
	errorLog .= "`n`n""Failed to extract file!"
	.	"`nSource: resources\currency_imgs\Timeless Vaal Emblem.png"
	.	"`nDest: " PROGRAM.CURRENCY_IMGS_FOLDER "\Timeless Vaal Emblem.png"
	.	"`nFlag: " 2
}

; ----------------------------
if !InStr(FileExist(PROGRAM.CURRENCY_IMGS_FOLDER ""), "D")
	FileCreateDir,% PROGRAM.CURRENCY_IMGS_FOLDER ""

if (A_IsCompiled) {
	sourceFileSize := Get_ResourceSize("resources\currency_imgs\Timeless Vaal Splinter.png")
	FileGetSize, destFileSize, % PROGRAM.CURRENCY_IMGS_FOLDER "\Timeless Vaal Splinter.png"
}
else {
	FileGetSize, sourceFileSize, resources\currency_imgs\Timeless Vaal Splinter.png
	FileGetSize, destFileSize, % PROGRAM.CURRENCY_IMGS_FOLDER "\Timeless Vaal Splinter.png"
}
if (sourceFileSize != destFileSize)
	FileInstall, resources\currency_imgs\Timeless Vaal Splinter.png, % PROGRAM.CURRENCY_IMGS_FOLDER "\Timeless Vaal Splinter.png", 1
if (ErrorLevel) {
	AppendToLogs("Failed to extract file!"
	.	"`nSource: resources\currency_imgs\Timeless Vaal Splinter.png"
	.	"`nDest: " PROGRAM.CURRENCY_IMGS_FOLDER "\Timeless Vaal Splinter.png"
	.	"`nFlag: " 2)
	errorLog .= "`n`n""Failed to extract file!"
	.	"`nSource: resources\currency_imgs\Timeless Vaal Splinter.png"
	.	"`nDest: " PROGRAM.CURRENCY_IMGS_FOLDER "\Timeless Vaal Splinter.png"
	.	"`nFlag: " 2
}

; ----------------------------
if !InStr(FileExist(PROGRAM.CURRENCY_IMGS_FOLDER ""), "D")
	FileCreateDir,% PROGRAM.CURRENCY_IMGS_FOLDER ""

if (A_IsCompiled) {
	sourceFileSize := Get_ResourceSize("resources\currency_imgs\Timeworn Reliquary Key.png")
	FileGetSize, destFileSize, % PROGRAM.CURRENCY_IMGS_FOLDER "\Timeworn Reliquary Key.png"
}
else {
	FileGetSize, sourceFileSize, resources\currency_imgs\Timeworn Reliquary Key.png
	FileGetSize, destFileSize, % PROGRAM.CURRENCY_IMGS_FOLDER "\Timeworn Reliquary Key.png"
}
if (sourceFileSize != destFileSize)
	FileInstall, resources\currency_imgs\Timeworn Reliquary Key.png, % PROGRAM.CURRENCY_IMGS_FOLDER "\Timeworn Reliquary Key.png", 1
if (ErrorLevel) {
	AppendToLogs("Failed to extract file!"
	.	"`nSource: resources\currency_imgs\Timeworn Reliquary Key.png"
	.	"`nDest: " PROGRAM.CURRENCY_IMGS_FOLDER "\Timeworn Reliquary Key.png"
	.	"`nFlag: " 2)
	errorLog .= "`n`n""Failed to extract file!"
	.	"`nSource: resources\currency_imgs\Timeworn Reliquary Key.png"
	.	"`nDest: " PROGRAM.CURRENCY_IMGS_FOLDER "\Timeworn Reliquary Key.png"
	.	"`nFlag: " 2
}

; ----------------------------
if !InStr(FileExist(PROGRAM.CURRENCY_IMGS_FOLDER ""), "D")
	FileCreateDir,% PROGRAM.CURRENCY_IMGS_FOLDER ""

if (A_IsCompiled) {
	sourceFileSize := Get_ResourceSize("resources\currency_imgs\Tul's Breachstone.png")
	FileGetSize, destFileSize, % PROGRAM.CURRENCY_IMGS_FOLDER "\Tul's Breachstone.png"
}
else {
	FileGetSize, sourceFileSize, resources\currency_imgs\Tul's Breachstone.png
	FileGetSize, destFileSize, % PROGRAM.CURRENCY_IMGS_FOLDER "\Tul's Breachstone.png"
}
if (sourceFileSize != destFileSize)
	FileInstall, resources\currency_imgs\Tul's Breachstone.png, % PROGRAM.CURRENCY_IMGS_FOLDER "\Tul's Breachstone.png", 1
if (ErrorLevel) {
	AppendToLogs("Failed to extract file!"
	.	"`nSource: resources\currency_imgs\Tul's Breachstone.png"
	.	"`nDest: " PROGRAM.CURRENCY_IMGS_FOLDER "\Tul's Breachstone.png"
	.	"`nFlag: " 2)
	errorLog .= "`n`n""Failed to extract file!"
	.	"`nSource: resources\currency_imgs\Tul's Breachstone.png"
	.	"`nDest: " PROGRAM.CURRENCY_IMGS_FOLDER "\Tul's Breachstone.png"
	.	"`nFlag: " 2
}

; ----------------------------
if !InStr(FileExist(PROGRAM.CURRENCY_IMGS_FOLDER ""), "D")
	FileCreateDir,% PROGRAM.CURRENCY_IMGS_FOLDER ""

if (A_IsCompiled) {
	sourceFileSize := Get_ResourceSize("resources\currency_imgs\Tul's Charged Breachstone.png")
	FileGetSize, destFileSize, % PROGRAM.CURRENCY_IMGS_FOLDER "\Tul's Charged Breachstone.png"
}
else {
	FileGetSize, sourceFileSize, resources\currency_imgs\Tul's Charged Breachstone.png
	FileGetSize, destFileSize, % PROGRAM.CURRENCY_IMGS_FOLDER "\Tul's Charged Breachstone.png"
}
if (sourceFileSize != destFileSize)
	FileInstall, resources\currency_imgs\Tul's Charged Breachstone.png, % PROGRAM.CURRENCY_IMGS_FOLDER "\Tul's Charged Breachstone.png", 1
if (ErrorLevel) {
	AppendToLogs("Failed to extract file!"
	.	"`nSource: resources\currency_imgs\Tul's Charged Breachstone.png"
	.	"`nDest: " PROGRAM.CURRENCY_IMGS_FOLDER "\Tul's Charged Breachstone.png"
	.	"`nFlag: " 2)
	errorLog .= "`n`n""Failed to extract file!"
	.	"`nSource: resources\currency_imgs\Tul's Charged Breachstone.png"
	.	"`nDest: " PROGRAM.CURRENCY_IMGS_FOLDER "\Tul's Charged Breachstone.png"
	.	"`nFlag: " 2
}

; ----------------------------
if !InStr(FileExist(PROGRAM.CURRENCY_IMGS_FOLDER ""), "D")
	FileCreateDir,% PROGRAM.CURRENCY_IMGS_FOLDER ""

if (A_IsCompiled) {
	sourceFileSize := Get_ResourceSize("resources\currency_imgs\Tul's Enriched Breachstone.png")
	FileGetSize, destFileSize, % PROGRAM.CURRENCY_IMGS_FOLDER "\Tul's Enriched Breachstone.png"
}
else {
	FileGetSize, sourceFileSize, resources\currency_imgs\Tul's Enriched Breachstone.png
	FileGetSize, destFileSize, % PROGRAM.CURRENCY_IMGS_FOLDER "\Tul's Enriched Breachstone.png"
}
if (sourceFileSize != destFileSize)
	FileInstall, resources\currency_imgs\Tul's Enriched Breachstone.png, % PROGRAM.CURRENCY_IMGS_FOLDER "\Tul's Enriched Breachstone.png", 1
if (ErrorLevel) {
	AppendToLogs("Failed to extract file!"
	.	"`nSource: resources\currency_imgs\Tul's Enriched Breachstone.png"
	.	"`nDest: " PROGRAM.CURRENCY_IMGS_FOLDER "\Tul's Enriched Breachstone.png"
	.	"`nFlag: " 2)
	errorLog .= "`n`n""Failed to extract file!"
	.	"`nSource: resources\currency_imgs\Tul's Enriched Breachstone.png"
	.	"`nDest: " PROGRAM.CURRENCY_IMGS_FOLDER "\Tul's Enriched Breachstone.png"
	.	"`nFlag: " 2
}

; ----------------------------
if !InStr(FileExist(PROGRAM.CURRENCY_IMGS_FOLDER ""), "D")
	FileCreateDir,% PROGRAM.CURRENCY_IMGS_FOLDER ""

if (A_IsCompiled) {
	sourceFileSize := Get_ResourceSize("resources\currency_imgs\Tul's Pure Breachstone.png")
	FileGetSize, destFileSize, % PROGRAM.CURRENCY_IMGS_FOLDER "\Tul's Pure Breachstone.png"
}
else {
	FileGetSize, sourceFileSize, resources\currency_imgs\Tul's Pure Breachstone.png
	FileGetSize, destFileSize, % PROGRAM.CURRENCY_IMGS_FOLDER "\Tul's Pure Breachstone.png"
}
if (sourceFileSize != destFileSize)
	FileInstall, resources\currency_imgs\Tul's Pure Breachstone.png, % PROGRAM.CURRENCY_IMGS_FOLDER "\Tul's Pure Breachstone.png", 1
if (ErrorLevel) {
	AppendToLogs("Failed to extract file!"
	.	"`nSource: resources\currency_imgs\Tul's Pure Breachstone.png"
	.	"`nDest: " PROGRAM.CURRENCY_IMGS_FOLDER "\Tul's Pure Breachstone.png"
	.	"`nFlag: " 2)
	errorLog .= "`n`n""Failed to extract file!"
	.	"`nSource: resources\currency_imgs\Tul's Pure Breachstone.png"
	.	"`nDest: " PROGRAM.CURRENCY_IMGS_FOLDER "\Tul's Pure Breachstone.png"
	.	"`nFlag: " 2
}

; ----------------------------
if !InStr(FileExist(PROGRAM.CURRENCY_IMGS_FOLDER ""), "D")
	FileCreateDir,% PROGRAM.CURRENCY_IMGS_FOLDER ""

if (A_IsCompiled) {
	sourceFileSize := Get_ResourceSize("resources\currency_imgs\Unknown.png")
	FileGetSize, destFileSize, % PROGRAM.CURRENCY_IMGS_FOLDER "\Unknown.png"
}
else {
	FileGetSize, sourceFileSize, resources\currency_imgs\Unknown.png
	FileGetSize, destFileSize, % PROGRAM.CURRENCY_IMGS_FOLDER "\Unknown.png"
}
if (sourceFileSize != destFileSize)
	FileInstall, resources\currency_imgs\Unknown.png, % PROGRAM.CURRENCY_IMGS_FOLDER "\Unknown.png", 1
if (ErrorLevel) {
	AppendToLogs("Failed to extract file!"
	.	"`nSource: resources\currency_imgs\Unknown.png"
	.	"`nDest: " PROGRAM.CURRENCY_IMGS_FOLDER "\Unknown.png"
	.	"`nFlag: " 2)
	errorLog .= "`n`n""Failed to extract file!"
	.	"`nSource: resources\currency_imgs\Unknown.png"
	.	"`nDest: " PROGRAM.CURRENCY_IMGS_FOLDER "\Unknown.png"
	.	"`nFlag: " 2
}

; ----------------------------
if !InStr(FileExist(PROGRAM.CURRENCY_IMGS_FOLDER ""), "D")
	FileCreateDir,% PROGRAM.CURRENCY_IMGS_FOLDER ""

if (A_IsCompiled) {
	sourceFileSize := Get_ResourceSize("resources\currency_imgs\Uul-Netol's Breachstone.png")
	FileGetSize, destFileSize, % PROGRAM.CURRENCY_IMGS_FOLDER "\Uul-Netol's Breachstone.png"
}
else {
	FileGetSize, sourceFileSize, resources\currency_imgs\Uul-Netol's Breachstone.png
	FileGetSize, destFileSize, % PROGRAM.CURRENCY_IMGS_FOLDER "\Uul-Netol's Breachstone.png"
}
if (sourceFileSize != destFileSize)
	FileInstall, resources\currency_imgs\Uul-Netol's Breachstone.png, % PROGRAM.CURRENCY_IMGS_FOLDER "\Uul-Netol's Breachstone.png", 1
if (ErrorLevel) {
	AppendToLogs("Failed to extract file!"
	.	"`nSource: resources\currency_imgs\Uul-Netol's Breachstone.png"
	.	"`nDest: " PROGRAM.CURRENCY_IMGS_FOLDER "\Uul-Netol's Breachstone.png"
	.	"`nFlag: " 2)
	errorLog .= "`n`n""Failed to extract file!"
	.	"`nSource: resources\currency_imgs\Uul-Netol's Breachstone.png"
	.	"`nDest: " PROGRAM.CURRENCY_IMGS_FOLDER "\Uul-Netol's Breachstone.png"
	.	"`nFlag: " 2
}

; ----------------------------
if !InStr(FileExist(PROGRAM.CURRENCY_IMGS_FOLDER ""), "D")
	FileCreateDir,% PROGRAM.CURRENCY_IMGS_FOLDER ""

if (A_IsCompiled) {
	sourceFileSize := Get_ResourceSize("resources\currency_imgs\Uul-Netol's Charged Breachstone.png")
	FileGetSize, destFileSize, % PROGRAM.CURRENCY_IMGS_FOLDER "\Uul-Netol's Charged Breachstone.png"
}
else {
	FileGetSize, sourceFileSize, resources\currency_imgs\Uul-Netol's Charged Breachstone.png
	FileGetSize, destFileSize, % PROGRAM.CURRENCY_IMGS_FOLDER "\Uul-Netol's Charged Breachstone.png"
}
if (sourceFileSize != destFileSize)
	FileInstall, resources\currency_imgs\Uul-Netol's Charged Breachstone.png, % PROGRAM.CURRENCY_IMGS_FOLDER "\Uul-Netol's Charged Breachstone.png", 1
if (ErrorLevel) {
	AppendToLogs("Failed to extract file!"
	.	"`nSource: resources\currency_imgs\Uul-Netol's Charged Breachstone.png"
	.	"`nDest: " PROGRAM.CURRENCY_IMGS_FOLDER "\Uul-Netol's Charged Breachstone.png"
	.	"`nFlag: " 2)
	errorLog .= "`n`n""Failed to extract file!"
	.	"`nSource: resources\currency_imgs\Uul-Netol's Charged Breachstone.png"
	.	"`nDest: " PROGRAM.CURRENCY_IMGS_FOLDER "\Uul-Netol's Charged Breachstone.png"
	.	"`nFlag: " 2
}

; ----------------------------
if !InStr(FileExist(PROGRAM.CURRENCY_IMGS_FOLDER ""), "D")
	FileCreateDir,% PROGRAM.CURRENCY_IMGS_FOLDER ""

if (A_IsCompiled) {
	sourceFileSize := Get_ResourceSize("resources\currency_imgs\Uul-Netol's Enriched Breachstone.png")
	FileGetSize, destFileSize, % PROGRAM.CURRENCY_IMGS_FOLDER "\Uul-Netol's Enriched Breachstone.png"
}
else {
	FileGetSize, sourceFileSize, resources\currency_imgs\Uul-Netol's Enriched Breachstone.png
	FileGetSize, destFileSize, % PROGRAM.CURRENCY_IMGS_FOLDER "\Uul-Netol's Enriched Breachstone.png"
}
if (sourceFileSize != destFileSize)
	FileInstall, resources\currency_imgs\Uul-Netol's Enriched Breachstone.png, % PROGRAM.CURRENCY_IMGS_FOLDER "\Uul-Netol's Enriched Breachstone.png", 1
if (ErrorLevel) {
	AppendToLogs("Failed to extract file!"
	.	"`nSource: resources\currency_imgs\Uul-Netol's Enriched Breachstone.png"
	.	"`nDest: " PROGRAM.CURRENCY_IMGS_FOLDER "\Uul-Netol's Enriched Breachstone.png"
	.	"`nFlag: " 2)
	errorLog .= "`n`n""Failed to extract file!"
	.	"`nSource: resources\currency_imgs\Uul-Netol's Enriched Breachstone.png"
	.	"`nDest: " PROGRAM.CURRENCY_IMGS_FOLDER "\Uul-Netol's Enriched Breachstone.png"
	.	"`nFlag: " 2
}

; ----------------------------
if !InStr(FileExist(PROGRAM.CURRENCY_IMGS_FOLDER ""), "D")
	FileCreateDir,% PROGRAM.CURRENCY_IMGS_FOLDER ""

if (A_IsCompiled) {
	sourceFileSize := Get_ResourceSize("resources\currency_imgs\Uul-Netol's Pure Breachstone.png")
	FileGetSize, destFileSize, % PROGRAM.CURRENCY_IMGS_FOLDER "\Uul-Netol's Pure Breachstone.png"
}
else {
	FileGetSize, sourceFileSize, resources\currency_imgs\Uul-Netol's Pure Breachstone.png
	FileGetSize, destFileSize, % PROGRAM.CURRENCY_IMGS_FOLDER "\Uul-Netol's Pure Breachstone.png"
}
if (sourceFileSize != destFileSize)
	FileInstall, resources\currency_imgs\Uul-Netol's Pure Breachstone.png, % PROGRAM.CURRENCY_IMGS_FOLDER "\Uul-Netol's Pure Breachstone.png", 1
if (ErrorLevel) {
	AppendToLogs("Failed to extract file!"
	.	"`nSource: resources\currency_imgs\Uul-Netol's Pure Breachstone.png"
	.	"`nDest: " PROGRAM.CURRENCY_IMGS_FOLDER "\Uul-Netol's Pure Breachstone.png"
	.	"`nFlag: " 2)
	errorLog .= "`n`n""Failed to extract file!"
	.	"`nSource: resources\currency_imgs\Uul-Netol's Pure Breachstone.png"
	.	"`nDest: " PROGRAM.CURRENCY_IMGS_FOLDER "\Uul-Netol's Pure Breachstone.png"
	.	"`nFlag: " 2
}

; ----------------------------
if !InStr(FileExist(PROGRAM.CURRENCY_IMGS_FOLDER ""), "D")
	FileCreateDir,% PROGRAM.CURRENCY_IMGS_FOLDER ""

if (A_IsCompiled) {
	sourceFileSize := Get_ResourceSize("resources\currency_imgs\Vaal Orb.png")
	FileGetSize, destFileSize, % PROGRAM.CURRENCY_IMGS_FOLDER "\Vaal Orb.png"
}
else {
	FileGetSize, sourceFileSize, resources\currency_imgs\Vaal Orb.png
	FileGetSize, destFileSize, % PROGRAM.CURRENCY_IMGS_FOLDER "\Vaal Orb.png"
}
if (sourceFileSize != destFileSize)
	FileInstall, resources\currency_imgs\Vaal Orb.png, % PROGRAM.CURRENCY_IMGS_FOLDER "\Vaal Orb.png", 1
if (ErrorLevel) {
	AppendToLogs("Failed to extract file!"
	.	"`nSource: resources\currency_imgs\Vaal Orb.png"
	.	"`nDest: " PROGRAM.CURRENCY_IMGS_FOLDER "\Vaal Orb.png"
	.	"`nFlag: " 2)
	errorLog .= "`n`n""Failed to extract file!"
	.	"`nSource: resources\currency_imgs\Vaal Orb.png"
	.	"`nDest: " PROGRAM.CURRENCY_IMGS_FOLDER "\Vaal Orb.png"
	.	"`nFlag: " 2
}

; ----------------------------
if !InStr(FileExist(PROGRAM.CURRENCY_IMGS_FOLDER ""), "D")
	FileCreateDir,% PROGRAM.CURRENCY_IMGS_FOLDER ""

if (A_IsCompiled) {
	sourceFileSize := Get_ResourceSize("resources\currency_imgs\Volkuur's Key.png")
	FileGetSize, destFileSize, % PROGRAM.CURRENCY_IMGS_FOLDER "\Volkuur's Key.png"
}
else {
	FileGetSize, sourceFileSize, resources\currency_imgs\Volkuur's Key.png
	FileGetSize, destFileSize, % PROGRAM.CURRENCY_IMGS_FOLDER "\Volkuur's Key.png"
}
if (sourceFileSize != destFileSize)
	FileInstall, resources\currency_imgs\Volkuur's Key.png, % PROGRAM.CURRENCY_IMGS_FOLDER "\Volkuur's Key.png", 1
if (ErrorLevel) {
	AppendToLogs("Failed to extract file!"
	.	"`nSource: resources\currency_imgs\Volkuur's Key.png"
	.	"`nDest: " PROGRAM.CURRENCY_IMGS_FOLDER "\Volkuur's Key.png"
	.	"`nFlag: " 2)
	errorLog .= "`n`n""Failed to extract file!"
	.	"`nSource: resources\currency_imgs\Volkuur's Key.png"
	.	"`nDest: " PROGRAM.CURRENCY_IMGS_FOLDER "\Volkuur's Key.png"
	.	"`nFlag: " 2
}

; ----------------------------
if !InStr(FileExist(PROGRAM.CURRENCY_IMGS_FOLDER ""), "D")
	FileCreateDir,% PROGRAM.CURRENCY_IMGS_FOLDER ""

if (A_IsCompiled) {
	sourceFileSize := Get_ResourceSize("resources\currency_imgs\Xoph's Breachstone.png")
	FileGetSize, destFileSize, % PROGRAM.CURRENCY_IMGS_FOLDER "\Xoph's Breachstone.png"
}
else {
	FileGetSize, sourceFileSize, resources\currency_imgs\Xoph's Breachstone.png
	FileGetSize, destFileSize, % PROGRAM.CURRENCY_IMGS_FOLDER "\Xoph's Breachstone.png"
}
if (sourceFileSize != destFileSize)
	FileInstall, resources\currency_imgs\Xoph's Breachstone.png, % PROGRAM.CURRENCY_IMGS_FOLDER "\Xoph's Breachstone.png", 1
if (ErrorLevel) {
	AppendToLogs("Failed to extract file!"
	.	"`nSource: resources\currency_imgs\Xoph's Breachstone.png"
	.	"`nDest: " PROGRAM.CURRENCY_IMGS_FOLDER "\Xoph's Breachstone.png"
	.	"`nFlag: " 2)
	errorLog .= "`n`n""Failed to extract file!"
	.	"`nSource: resources\currency_imgs\Xoph's Breachstone.png"
	.	"`nDest: " PROGRAM.CURRENCY_IMGS_FOLDER "\Xoph's Breachstone.png"
	.	"`nFlag: " 2
}

; ----------------------------
if !InStr(FileExist(PROGRAM.CURRENCY_IMGS_FOLDER ""), "D")
	FileCreateDir,% PROGRAM.CURRENCY_IMGS_FOLDER ""

if (A_IsCompiled) {
	sourceFileSize := Get_ResourceSize("resources\currency_imgs\Xoph's Charged Breachstone.png")
	FileGetSize, destFileSize, % PROGRAM.CURRENCY_IMGS_FOLDER "\Xoph's Charged Breachstone.png"
}
else {
	FileGetSize, sourceFileSize, resources\currency_imgs\Xoph's Charged Breachstone.png
	FileGetSize, destFileSize, % PROGRAM.CURRENCY_IMGS_FOLDER "\Xoph's Charged Breachstone.png"
}
if (sourceFileSize != destFileSize)
	FileInstall, resources\currency_imgs\Xoph's Charged Breachstone.png, % PROGRAM.CURRENCY_IMGS_FOLDER "\Xoph's Charged Breachstone.png", 1
if (ErrorLevel) {
	AppendToLogs("Failed to extract file!"
	.	"`nSource: resources\currency_imgs\Xoph's Charged Breachstone.png"
	.	"`nDest: " PROGRAM.CURRENCY_IMGS_FOLDER "\Xoph's Charged Breachstone.png"
	.	"`nFlag: " 2)
	errorLog .= "`n`n""Failed to extract file!"
	.	"`nSource: resources\currency_imgs\Xoph's Charged Breachstone.png"
	.	"`nDest: " PROGRAM.CURRENCY_IMGS_FOLDER "\Xoph's Charged Breachstone.png"
	.	"`nFlag: " 2
}

; ----------------------------
if !InStr(FileExist(PROGRAM.CURRENCY_IMGS_FOLDER ""), "D")
	FileCreateDir,% PROGRAM.CURRENCY_IMGS_FOLDER ""

if (A_IsCompiled) {
	sourceFileSize := Get_ResourceSize("resources\currency_imgs\Xoph's Enriched Breachstone.png")
	FileGetSize, destFileSize, % PROGRAM.CURRENCY_IMGS_FOLDER "\Xoph's Enriched Breachstone.png"
}
else {
	FileGetSize, sourceFileSize, resources\currency_imgs\Xoph's Enriched Breachstone.png
	FileGetSize, destFileSize, % PROGRAM.CURRENCY_IMGS_FOLDER "\Xoph's Enriched Breachstone.png"
}
if (sourceFileSize != destFileSize)
	FileInstall, resources\currency_imgs\Xoph's Enriched Breachstone.png, % PROGRAM.CURRENCY_IMGS_FOLDER "\Xoph's Enriched Breachstone.png", 1
if (ErrorLevel) {
	AppendToLogs("Failed to extract file!"
	.	"`nSource: resources\currency_imgs\Xoph's Enriched Breachstone.png"
	.	"`nDest: " PROGRAM.CURRENCY_IMGS_FOLDER "\Xoph's Enriched Breachstone.png"
	.	"`nFlag: " 2)
	errorLog .= "`n`n""Failed to extract file!"
	.	"`nSource: resources\currency_imgs\Xoph's Enriched Breachstone.png"
	.	"`nDest: " PROGRAM.CURRENCY_IMGS_FOLDER "\Xoph's Enriched Breachstone.png"
	.	"`nFlag: " 2
}

; ----------------------------
if !InStr(FileExist(PROGRAM.CURRENCY_IMGS_FOLDER ""), "D")
	FileCreateDir,% PROGRAM.CURRENCY_IMGS_FOLDER ""

if (A_IsCompiled) {
	sourceFileSize := Get_ResourceSize("resources\currency_imgs\Xoph's Pure Breachstone.png")
	FileGetSize, destFileSize, % PROGRAM.CURRENCY_IMGS_FOLDER "\Xoph's Pure Breachstone.png"
}
else {
	FileGetSize, sourceFileSize, resources\currency_imgs\Xoph's Pure Breachstone.png
	FileGetSize, destFileSize, % PROGRAM.CURRENCY_IMGS_FOLDER "\Xoph's Pure Breachstone.png"
}
if (sourceFileSize != destFileSize)
	FileInstall, resources\currency_imgs\Xoph's Pure Breachstone.png, % PROGRAM.CURRENCY_IMGS_FOLDER "\Xoph's Pure Breachstone.png", 1
if (ErrorLevel) {
	AppendToLogs("Failed to extract file!"
	.	"`nSource: resources\currency_imgs\Xoph's Pure Breachstone.png"
	.	"`nDest: " PROGRAM.CURRENCY_IMGS_FOLDER "\Xoph's Pure Breachstone.png"
	.	"`nFlag: " 2)
	errorLog .= "`n`n""Failed to extract file!"
	.	"`nSource: resources\currency_imgs\Xoph's Pure Breachstone.png"
	.	"`nDest: " PROGRAM.CURRENCY_IMGS_FOLDER "\Xoph's Pure Breachstone.png"
	.	"`nFlag: " 2
}

; ----------------------------
if !InStr(FileExist(PROGRAM.CURRENCY_IMGS_FOLDER ""), "D")
	FileCreateDir,% PROGRAM.CURRENCY_IMGS_FOLDER ""

if (A_IsCompiled) {
	sourceFileSize := Get_ResourceSize("resources\currency_imgs\Yriel's Key.png")
	FileGetSize, destFileSize, % PROGRAM.CURRENCY_IMGS_FOLDER "\Yriel's Key.png"
}
else {
	FileGetSize, sourceFileSize, resources\currency_imgs\Yriel's Key.png
	FileGetSize, destFileSize, % PROGRAM.CURRENCY_IMGS_FOLDER "\Yriel's Key.png"
}
if (sourceFileSize != destFileSize)
	FileInstall, resources\currency_imgs\Yriel's Key.png, % PROGRAM.CURRENCY_IMGS_FOLDER "\Yriel's Key.png", 1
if (ErrorLevel) {
	AppendToLogs("Failed to extract file!"
	.	"`nSource: resources\currency_imgs\Yriel's Key.png"
	.	"`nDest: " PROGRAM.CURRENCY_IMGS_FOLDER "\Yriel's Key.png"
	.	"`nFlag: " 2)
	errorLog .= "`n`n""Failed to extract file!"
	.	"`nSource: resources\currency_imgs\Yriel's Key.png"
	.	"`nDest: " PROGRAM.CURRENCY_IMGS_FOLDER "\Yriel's Key.png"
	.	"`nFlag: " 2
}

; ----------------------------
if !InStr(FileExist(PROGRAM.CHEATSHEETS_FOLDER ""), "D")
	FileCreateDir,% PROGRAM.CHEATSHEETS_FOLDER ""

if (A_IsCompiled) {
	sourceFileSize := Get_ResourceSize("resources\cheatsheets\Betrayal.png")
	FileGetSize, destFileSize, % PROGRAM.CHEATSHEETS_FOLDER "\Betrayal.png"
}
else {
	FileGetSize, sourceFileSize, resources\cheatsheets\Betrayal.png
	FileGetSize, destFileSize, % PROGRAM.CHEATSHEETS_FOLDER "\Betrayal.png"
}
if (sourceFileSize != destFileSize)
	FileInstall, resources\cheatsheets\Betrayal.png, % PROGRAM.CHEATSHEETS_FOLDER "\Betrayal.png", 1
if (ErrorLevel) {
	AppendToLogs("Failed to extract file!"
	.	"`nSource: resources\cheatsheets\Betrayal.png"
	.	"`nDest: " PROGRAM.CHEATSHEETS_FOLDER "\Betrayal.png"
	.	"`nFlag: " 2)
	errorLog .= "`n`n""Failed to extract file!"
	.	"`nSource: resources\cheatsheets\Betrayal.png"
	.	"`nDest: " PROGRAM.CHEATSHEETS_FOLDER "\Betrayal.png"
	.	"`nFlag: " 2
}

; ----------------------------
if !InStr(FileExist(PROGRAM.CHEATSHEETS_FOLDER ""), "D")
	FileCreateDir,% PROGRAM.CHEATSHEETS_FOLDER ""

if (A_IsCompiled) {
	sourceFileSize := Get_ResourceSize("resources\cheatsheets\Delve.png")
	FileGetSize, destFileSize, % PROGRAM.CHEATSHEETS_FOLDER "\Delve.png"
}
else {
	FileGetSize, sourceFileSize, resources\cheatsheets\Delve.png
	FileGetSize, destFileSize, % PROGRAM.CHEATSHEETS_FOLDER "\Delve.png"
}
if (sourceFileSize != destFileSize)
	FileInstall, resources\cheatsheets\Delve.png, % PROGRAM.CHEATSHEETS_FOLDER "\Delve.png", 1
if (ErrorLevel) {
	AppendToLogs("Failed to extract file!"
	.	"`nSource: resources\cheatsheets\Delve.png"
	.	"`nDest: " PROGRAM.CHEATSHEETS_FOLDER "\Delve.png"
	.	"`nFlag: " 2)
	errorLog .= "`n`n""Failed to extract file!"
	.	"`nSource: resources\cheatsheets\Delve.png"
	.	"`nDest: " PROGRAM.CHEATSHEETS_FOLDER "\Delve.png"
	.	"`nFlag: " 2
}

; ----------------------------
if !InStr(FileExist(PROGRAM.CHEATSHEETS_FOLDER ""), "D")
	FileCreateDir,% PROGRAM.CHEATSHEETS_FOLDER ""

if (A_IsCompiled) {
	sourceFileSize := Get_ResourceSize("resources\cheatsheets\Essence.png")
	FileGetSize, destFileSize, % PROGRAM.CHEATSHEETS_FOLDER "\Essence.png"
}
else {
	FileGetSize, sourceFileSize, resources\cheatsheets\Essence.png
	FileGetSize, destFileSize, % PROGRAM.CHEATSHEETS_FOLDER "\Essence.png"
}
if (sourceFileSize != destFileSize)
	FileInstall, resources\cheatsheets\Essence.png, % PROGRAM.CHEATSHEETS_FOLDER "\Essence.png", 1
if (ErrorLevel) {
	AppendToLogs("Failed to extract file!"
	.	"`nSource: resources\cheatsheets\Essence.png"
	.	"`nDest: " PROGRAM.CHEATSHEETS_FOLDER "\Essence.png"
	.	"`nFlag: " 2)
	errorLog .= "`n`n""Failed to extract file!"
	.	"`nSource: resources\cheatsheets\Essence.png"
	.	"`nDest: " PROGRAM.CHEATSHEETS_FOLDER "\Essence.png"
	.	"`nFlag: " 2
}

; ----------------------------
if !InStr(FileExist(PROGRAM.CHEATSHEETS_FOLDER ""), "D")
	FileCreateDir,% PROGRAM.CHEATSHEETS_FOLDER ""

if (A_IsCompiled) {
	sourceFileSize := Get_ResourceSize("resources\cheatsheets\Incursion.png")
	FileGetSize, destFileSize, % PROGRAM.CHEATSHEETS_FOLDER "\Incursion.png"
}
else {
	FileGetSize, sourceFileSize, resources\cheatsheets\Incursion.png
	FileGetSize, destFileSize, % PROGRAM.CHEATSHEETS_FOLDER "\Incursion.png"
}
if (sourceFileSize != destFileSize)
	FileInstall, resources\cheatsheets\Incursion.png, % PROGRAM.CHEATSHEETS_FOLDER "\Incursion.png", 1
if (ErrorLevel) {
	AppendToLogs("Failed to extract file!"
	.	"`nSource: resources\cheatsheets\Incursion.png"
	.	"`nDest: " PROGRAM.CHEATSHEETS_FOLDER "\Incursion.png"
	.	"`nFlag: " 2)
	errorLog .= "`n`n""Failed to extract file!"
	.	"`nSource: resources\cheatsheets\Incursion.png"
	.	"`nDest: " PROGRAM.CHEATSHEETS_FOLDER "\Incursion.png"
	.	"`nFlag: " 2
}

; ----------------------------
if !InStr(FileExist(PROGRAM.CHEATSHEETS_FOLDER ""), "D")
	FileCreateDir,% PROGRAM.CHEATSHEETS_FOLDER ""

if (A_IsCompiled) {
	sourceFileSize := Get_ResourceSize("resources\cheatsheets\Heist.png")
	FileGetSize, destFileSize, % PROGRAM.CHEATSHEETS_FOLDER "\Heist.png"
}
else {
	FileGetSize, sourceFileSize, resources\cheatsheets\Heist.png
	FileGetSize, destFileSize, % PROGRAM.CHEATSHEETS_FOLDER "\Heist.png"
}
if (sourceFileSize != destFileSize)
	FileInstall, resources\cheatsheets\Heist.png, % PROGRAM.CHEATSHEETS_FOLDER "\Heist.png", 1
if (ErrorLevel) {
	AppendToLogs("Failed to extract file!"
	.	"`nSource: resources\cheatsheets\Heist.png"
	.	"`nDest: " PROGRAM.CHEATSHEETS_FOLDER "\Heist.png"
	.	"`nFlag: " 2)
	errorLog .= "`n`n""Failed to extract file!"
	.	"`nSource: resources\cheatsheets\Heist.png"
	.	"`nDest: " PROGRAM.CHEATSHEETS_FOLDER "\Heist.png"
	.	"`nFlag: " 2
}

; ----------------------------


if (errorLog)
	MsgBox, 4096, POE Trades Companion,% "One or multiple files failed to be extracted. Please check the logs file for details."
	.	PROGRAM.LOGS_FILE 

}
