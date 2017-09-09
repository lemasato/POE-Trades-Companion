/*
*	*	*	*	*	*	*	*	*	*	*	*	*	*	*	*	*	*	*	*	*	*	*	*	*	*	*	*	*	*	*	*	*	*	*	*	*	*	*	*	*
*					POE Trades Companion																															*
*					See all the information about the trade request upon receiving a poe.trade whisper															*
*																																								*
*					https://github.com/lemasato/POE-Trades-Companion/																								*
*					https://www.reddit.com/r/pathofexile/comments/57oo3h/																						*
*					https://www.pathofexile.com/forum/view-thread/1755148/																						*
*																																								*	
*	*	*	*	*	*	*	*	*	*	*	*	*	*	*	*	*	*	*	*	*	*	*	*	*	*	*	*	*	*	*	*	*	*	*	*	*	*	*	*	*
*/

#Warn LocalSameAsGlobal, StdOut
OnExit("Exit_Func")
#SingleInstance Off
#Persistent
#NoEnv
SetWorkingDir, %A_ScriptDir%
FileEncoding, UTF-8 ; Required for cyrillic characters
#KeyHistory 0
SetWinDelay, 0
DetectHiddenWindows, Off
ListLines, Off

Menu,Tray,Tip,POE Trades Companion
Menu,Tray,NoStandard
Menu,Tray,Add,Close,Exit_Func

;	Creating Window Switch Detect
Gui +LastFound 
Hwnd := WinExist()
DllCall( "RegisterShellHookWindow", UInt,Hwnd )
MsgNum := DllCall( "RegisterWindowMessage", Str,"SHELLHOOK" )
OnMessage( MsgNum, "ShellMessage")

Start_Script()
Return

Start_Script() {
/*
*/
;	Global objects declaration
	global DebugValues 					:= {} ; Debug values

	global ProgramValues 				:= {} ; Specific to the program's informations
	global ProgramFonts 				:= {} ; Fonts private to the program
	global ProgramSettings 				:= {} ; Settings from the local .ini
	global RunParameters 				:= {} ; Run-time parameters

	global GameSettings 				:= {} ; Settings from the game .ini

	global TradesGUI_Values 			:= {} ; TradesGUI various infos
	global TradesGUI_Controls 			:= {} ; TradesGUI controls handlers

	global Stats_TradeCurrencyNames 	:= {} ; Abridged currency names from poe.trade
	global Stats_RealCurrencyNames 		:= {} ; All currency full names

	global Trading_Leagues 				:= [] ; Contains trading leagues

;	- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
	; ProgramValues.Keep_Backup 			:= 1 	; Keep Trades_Backup.ini instead of deleting it on load.
	ProgramSettings.Screen_DPI 			:= Get_DPI_Factor() 

	Handle_CommandLine_Parameters()
	MyDocuments 						:= (RunParameters.MyDocuments)?(RunParameters.MyDocuments):(A_MyDocuments)

	ProgramValues.Name 					:= "POE Trades Companion"
	ProgramValues.Version 				:= "1.12.BETA_11"
	ProgramValues.Github_User 			:= "lemasato"
	ProgramValues.GitHub_Repo 			:= "POE-Trades-Companion"

	ProgramValues.Version_Link 			:= "https://raw.githubusercontent.com/lemasato/POE-Trades-Companion/master/version.txt"
	ProgramValues.Version_Link_Beta  	:= "https://raw.githubusercontent.com/lemasato/POE-Trades-Companion/dev/version.txt"

	ProgramValues.Download_FallBack			:= "https://raw.githubusercontent.com/lemasato/POE-Trades-Companion/master/POE Trades Companion.exe"
	ProgramValues.Download_FallBack_Beta	:= "https://raw.githubusercontent.com/lemasato/POE-Trades-Companion/dev/POE Trades Companion.exe"

	ProgramValues.NewVersion_File		:= A_ScriptDir "\POE-TC-NewVersion.exe"
	ProgramValues.Updater_File 			:= A_ScriptDir "\POE-TC-Updater.exe"
	ProgramValues.Updater_Link 			:= "https://raw.githubusercontent.com/lemasato/POE-Trades-Companion/master/Updater_v2.exe"
	ProgramValues.Updater_Link_Beta 	:= "https://raw.githubusercontent.com/lemasato/POE-Trades-Companion/dev/Updater_v2.exe"

	ProgramValues.Changelogs_Link 		:= "https://raw.githubusercontent.com/lemasato/POE-Trades-Companion/master/changelogs.txt"
	ProgramValues.Changelogs_Link_Beta	:= "https://raw.githubusercontent.com/lemasato/POE-Trades-Companion/dev/changelogs.txt"

	ProgramValues.Link_Reddit 			:= "https://redd.it/57oo3h"
	ProgramValues.Link_GGG 				:= "https://www.pathofexile.com/forum/view-thread/1755148/"
	ProgramValues.Link_GitHub 			:= "https://github.com/lemasato/POE-Trades-Companion"
	ProgramValues.Link_Support 			:= "https://github.com/lemasato/POE-Trades-Companion/wiki/Support"

	ProgramValues.Local_Folder 			:= MyDocuments "\AutoHotkey\" ProgramValues.Name
	ProgramValues.SFX_Folder 			:= ProgramValues.Local_Folder "\SFX"
	ProgramValues.Logs_Folder 			:= ProgramValues.Local_Folder "\Logs"
	ProgramValues.Skins_Folder 			:= ProgramValues.Local_Folder "\Skins"
	ProgramValues.Fonts_Folder 			:= ProgramValues.Local_Folder "\Fonts"
	ProgramValues.Data_Folder			:= ProgramValues.Local_Folder "\Data"
	ProgramValues.Others_Folder 		:= ProgramValues.Local_Folder "\Others"

	ProgramValues.Fonts_Settings_File	:= ProgramValues.Fonts_Folder "\Settings.ini"
	ProgramValues.Ini_File 				:= ProgramValues.Local_Folder "\Preferences.ini"
	ProgramValues.Logs_File 			:= ProgramValues.Logs_Folder "\" A_YYYY "-" A_MM "-" A_DD "_" A_Hour "-" A_Min "-" A_Sec ".txt"
	ProgramValues.Changelogs_File 		:= ProgramValues.Logs_Folder "\changelogs.txt"
	ProgramValues.Trades_History_File 	:= ProgramValues.Local_Folder "\Trades_History.ini" 
	ProgramValues.Trades_Backup_File	:= ProgramValues.Local_Folder "\Trades_Backup.ini"

	ProgramValues.Game_Folder 			:= MyDocuments "\my games\Path of Exile"
	ProgramValues.Game_Ini_File 		:= ProgramValues.Game_Folder "\production_Config.ini"
	ProgramValues.Game_Ini_File_Copy 	:= ProgramValues.Local_Folder "\production_Config.ini"

	ProgramSettings.Support_Message 	:= "@%buyerName% " ProgramValues.Name ": view-thread/1755148"

	ProgramValues.PID 					:= DllCall("GetCurrentProcessId")

	SetWorkingDir,% ProgramValues.Local_Folder

;	- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
	GroupAdd, POEGame, ahk_exe PathOfExile.exe
	GroupAdd, POEGame, ahk_exe PathOfExile_x64.exe
	GroupAdd, POEGame, ahk_exe PathOfExileSteam.exe
	GroupAdd, POEGame, ahk_exe PathOfExile_x64Steam.exe
	global POEGameArray := ["PathOfExile.exe", "PathOfExile_x64.exe", "PathOfExileSteam.exe", "PathOfExile_x64Steam.exe"]
	global POEGameList := "PathOfExile.exe,PathOfExile_x64.exe,PathOfExileSteam.exe,PathOfExile_x64Steam.exe"

;	- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

;	Debug options
	Load_Debug_JSON()

;	Data currency
	FileRead, allCurrency,% ProgramValues.Data_Folder "\Currency_All.txt"
	Loop, Parse, allCurrency, `n`r
	{
		if ( A_LoopField ) {
			Stats_RealCurrencyNames .= A_LoopField ","
		}
	}
	StringTrimRight, Stats_RealCurrencyNames, Stats_RealCurrencyNames, 1 ; Remove last comma

;	Data currency names converter
	FileRead, JSONFile,% ProgramValues.Data_Folder "\currencyTradeNames.json"
	parsedJSON := JSON.Load(JSONFile)
	Stats_TradeCurrencyNames := parsedJSON.currencyNames.eng

;	Directories Creation
	directories := ProgramValues.Local_Folder
			. "`n" ProgramValues.SFX_Folder
			. "`n" ProgramValues.Logs_Folder
			. "`n" ProgramValues.Skins_Folder
			. "`n" ProgramValues.Fonts_Folder
			. "`n" ProgramValues.Others_Folder
			. "`n" ProgramValues.Data_Folder
	Loop, Parse, directories,% "`r`n"
	{
		if (!InStr(FileExist(A_LoopField), "D")) {
			FileCreateDir, % A_LoopField
		}
	}

;	- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

	Run_As_Admin()
	Close_Previous_Program_Instance()
	Tray_Refresh()

	Update_Local_Settings() ; Updating local settings between versions

;	Extracting assets
	if !(DebugValues.settings.no_assets_extracting) {
		Extract_Assets()
	}

	Install_Font_Files()
	Manage_Font_Resources("LOAD")
	Update_Skin_Preset()

	Set_Local_Settings() ; Reset broken settings
	localSettings := Get_Local_Settings()
	Declare_Local_Settings(localSettings)

	settings := Get_Game_Settings()
	Declare_Game_Settings(settings)

	Create_Tray_Menu()
	Delete_Old_Logs_Files(10)
	Load_Skin_Assets()
	Enable_Hotkeys()
	Logs_Append("START", localSettings)

	if !(DebugValues.settings.no_online_check) {
		Check_Update()
		Get_Active_Trading_Leagues()
	}

;	Opening different GUIs
	if (DebugValues.settings.open_stats)
		Gui_Stats()
	if (DebugValues.settings.open_settings)
		Gui_Settings()
	if (DebugValues.settings.open_about)
		Gui_About()

	; Pre-rendering Trades-GUI
	if !( DebugValues.settings.no_prerender)
		Gui_Trades("CREATE")

	; Parse debug msgs
	if (DebugValues.settings.use_chat_logs) {
		Loop % DebugValues.chatlogs.MaxIndex()
			Filter_Logs_Message(DebugValues.chatlogs[A_Index])
	}

	Gui_Trades_Load_Pending_Backup()
	Monitor_Game_Logs()
	Tray_Notifications_Show(ProgramValues.Name, "Loaded and ready!"
												. "`nRight click on the tray icon to access the settings.")
}

Load_Debug_JSON() {
/*		Only works when using the ahk source
*/
	global DebugValues
	if (A_IsCompiled)
		Return

	FileRead, debugJSON,% A_ScriptDir "\Debug.json"
	parsed_debugJSON := JSON.Load(debugJSON)

	DebugValues.settings 		:= parsed_debugJSON.settings
	DebugValues.chatlogs 		:= parsed_debugJSON.chat_logs
}

Update_Skin_Preset() {
/*		Temporary solution (?)
		Retrieve the current preset and update the .ini file with the new settings
*/
	global ProgramValues

	IniRead, activePreset,% ProgramValues.Ini_File,CUSTOMIZATION_APPEARANCE,Active_Preset
	if (activePreset = "User Defined")
		Return


;	Applying font settings
	iniFile := ProgramValues.Ini_File
	skinSettingsFile := ProgramValues.Skins_Folder "\" activePreset "\Settings.ini"

	iniSect 			:= "CUSTOMIZATION_APPEARANCE"
	iniKeys 			:= ["Font","Font_Size_Custom","Font_Quality_Custom"]
	skinSect			:= "FONT"
	skinKeys			:= ["Name","Size","Quality"]

	for id, key in skinKeys {
		IniRead, value,% skinSettingsFile,% skinSect,% key
		IniWrite,% value,% iniFile,% iniSect,% iniKeys[id]
	}
	IniWrite,% "Automatic",% iniFile,% iniSect,% "Font_Size_Mode"
	IniWrite,% "Automatic",% iniFile,% iniSect,% "Font_Quality_Mode"

;	Applying colour settings
	iniSect 			:= "CUSTOMIZATION_APPEARANCE"
	iniKeys 			:= ["Color_Title_Active","Color_Title_Inactive","Color_Trades_Infos_1","Color_Trades_Infos_2","Color_Border"
						   ,"Color_Tab_Active","Color_Tab_Inactive","Color_Tab_Hover","Color_Tab_Press"
						   ,"Color_Tab_Joined_Active","Color_Tab_Joined_Inactive","Color_Tab_Joined_Hover","Color_Tab_Joined_Press"
						   ,"Color_Tab_Whisper_Active","Color_Tab_Whisper_Inactive","Color_Tab_Whisper_Hover","Color_Tab_Whisper_Press"
						   ,"Color_Button_Normal","Color_Button_Hover","Color_Button_Press"]
	skinSect 			:= "COLORS"
	skinKeys 			:= ["Title_Trades","Title_No_Trades","Trade_Info_1","Trade_Info_2","Border"
						   ,"Tab_Active","Tab_Inactive","Tab_Hover","Tab_Press"
						   ,"Tab_Joined_Active","Tab_Joined_Inactive","Tab_Joined_Hover","Tab_Joined_Press"
						   ,"Tab_Whisper_Active","Tab_Whisper_Inactive","Tab_Whisper_Hover","Tab_Whisper_Press"
						   ,"Button_Normal","Button_Hover","Button_Press"]
	for id, key in skinKeys {
		IniRead, value,% skinSettingsFile,% skinSect,% key
		IniWrite,% value,% iniFile,% iniSect,% iniKeys[id]
	}
}

;==================================================================================================================
;
;										LOGS MONITORING
;
;==================================================================================================================

Filter_Logs_Message(message) {
/*		Filter the logs message to retrieve the required informations we need
			and send them to the Trades GUI if it is a trading whisper.
 */
	global ProgramSettings, TradesGUI_Values, Trading_Leagues, programValues

	static poeTradeRegexStr 			:= "(.*)Hi, I would like to buy your (.*) listed for (.*) in (.*)" ; 1: Other, 2: Item, 3: Price, 4: League + Tab + Other
	static poeTradeUnpricedRegexStr 	:= "(.*)Hi, I would like to buy your (.*) in (.*)" ; 1: Other, 2: Item, 3: League + Tab + Other
	static poeTradeCurrencyRegexStr		:= "(.*)Hi, I'd like to buy your (.*) for my (.*) in (.*)" ; 1: Other, 2: Currency, 3: Price, 4: League + Tab + Other
	static poeTradeStashRegexStr 		:= "\(stash tab ""(.*)""; position: left (.*), top (.*)\)(.*)" ; 1: Tab, 2: Left, 3: Top, 4: Other
	static poTradeQualityRegExStr 		:= "level (.*) (.*)% (.*)" ; 1: Item level, 2: Item quality, 3: Item name

	static poeAppRegExStr 				:= "(.*)wtb (.*) listed for (.*) in (.*)" ; 1: Other, 2: Item, 3: Price, 4: League + Tab + Other
	static poeAppUnpricedRegexStr 		:= "(.*)wtb (.*) in (.*)" ; 1: Other, 2: Item, 3: League + Tab + Other
	static poeAppStashRegexStr 			:= "\(stash ""(.*); left (.*), top(.*)\)(.*)" ; 1: Tab, 2: Left, 3: Top, 4: Other
	static poeAppQualityRegExStr 		:= "(.*) \((.*)/(.*)%\)" ; 1: Item name, 2: Item level, 3: Item quality

	static allRegexStr := {"poeTradeRegexStr":poeTradeRegexStr
						  ,"poeTradeUnpricedRegexStr":poeTradeUnpricedRegexStr
						  ,"poeTradeCurrencyRegexStr":poeTradeCurrencyRegexStr
						  ,"poeAppRegExStr":poeAppRegExStr
						  ,"poeAppUnpricedRegexStr":poeAppUnpricedRegexStr}

	static areaRegexStr := ("^(?:[^ ]+ ){6}(\d+)\] : (.*?) (?:has) (joined|left) (?:the area.*)") 


	Loop, Parse, message, `n ; For each new individual line since last check
	{
		; New RegEx pattern matches the trading message, but only from whispers and local chat (for debugging), and specifically ignores global/trade/guild/party chats
		if ( RegExMatch( A_LoopField, "S)^(?:[^ ]+ ){6}(\d+)\] (?=[^#$&%]).*@(?:From|De|От кого|จาก) (.*?): (.*)", subPat ) ) { ; Whisper found
;			 Assigning the sub pattern variables
			gamePID := subPat1, whispNameFull := subPat2, whispMsg := subPat3
			whispNameFull := Gui_Trades_RemoveGuildPrefix(whispNameFull)
			whispName := whispNameFull.Name, whispGuild := whispNameFull.Guild
			TradesGUI_Values.Last_Whisper := whispName

			whispMsg := StrReplace(whispMsg, "`r", "")
			whispMsg := StrReplace(whispMsg, "`n", "")

;			Tray notitication & Flashing
			if !WinActive("ahk_pid " gamePID) {
				if ( ProgramSettings.Whisper_Tray ) {
					Tray_Notifications_Show("Whisper from " whispName, whispMsg)
				}

				if ( ProgramSettings.Whisper_Flash ) {
					gameHwnd := WinExist("ahk_pid " gamePID)
					DllCall("FlashWindow", UInt, gameHwnd, Int, 1)
				}
			}

			whisp := whispName ": " whispMsg "`n"

;			Retrieve the regEx pattern specific to the whisper type
			tradeRegExStr := tradeRegExName := ""	
			for regExName, regExStr in allRegExStr {
				if RegExMatch(whisp, "iS).*: " regExStr) { ; Match found
					tradeRegExStr := regExStr
					tradeRegExName := regExName
					Break
				}
			}
;			Match found. Retrieve the information from the whisper
			if (tradeRegExStr) { ; Trading whisper found
				if RegExMatch(whisp, "iS).*: " tradeRegExStr, whispPat ) {
					timeSinceLastTrade := 0

					if ( tradeRegExName = "poeTradeRegexStr" ) {
						whispOther 			:= whispPat1
						whispItem 			:= whispPat2
						whispPrice 			:= whispPat3
						endOfWhisper 		:= whispPat4
						whispPat1 := "", whispPat2 := "", whispPat3 := "", whispPat4 := ""

						for id, leagueName in Trading_Leagues {
							if RegExMatch(endOfWhisper, "S)" leagueName "(.*)", endOfWhisperPat) {
								whispLeague 		:= leagueName
								endOfWhisper 		:= endOfWhisperPat1
								endOfWhisperPat1 	:= ""
								Break
							}
						}
						if RegExMatch(endOfWhisper, "S)" poeTradeStashRegexStr, stashPat) {
							whispStash 		:= stashPat1
							whispStashLeft 	:= stashPat2
							whispStashTop 	:= stashPat3
							whispOther2 	:= stashPat4
							stashPat1 := "", stashPat2 := "", stashPat3 := "", stashPat4 := ""
						}
						else {
							whispOther2 	:= endOfWhisper
						}
						if RegExMatch(whispItem, "S)" poTradeQualityRegExStr, itemQualPat) {
							whispItemLevel 	:= itemQualPat1
							whispItemQual 	:= itemQualPat2
							whispItemName 	:= itemQualPat3
							itemQualPat1 := "", itemQualPat2 := "", itemQualPat3 := ""
						}

						newTradeItem 		:= (whispItemName)?(whispItemName " (Lvl:" whispItemLevel " / Qual:" whispItemQual "%)"):(whispItem)
						newTradePrice 		:= whispPrice
						newTradeLocation 	:= (whispStash)?(whispLeague " (Tab:" whispStash " / Pos:" whispStashLeft ";" whispStashTop ")"):(whispLeague)
						newTradeOther 		:= (whispOther && whispOther2)?(whispOther " " whispOther2):(whispOther . whispOther2)
					}
					else if ( tradeRegExName = "poeTradeUnpricedRegexStr") {
						whispOther 			:= whispPat1
						whispItem 			:= whispPat2
						endOfWhisper 		:= whispPat3
						whispPat1 := "", whispPat2 := "", whispPat3 := ""

						for id, leagueName in Trading_Leagues {
							if RegExMatch(endOfWhisper, "S)" leagueName "(.*)", endOfWhisperPat) {
								whispLeague 		:= leagueName
								endOfWhisper 		:= endOfWhisperPat1
								endOfWhisperPat1	:= ""
								Break
							}
						}

						if RegExMatch(endOfWhisper, "S)" poeTradeStashRegexStr, stashPat) {
							whispStash 		:= stashPat1
							whispStashLeft 	:= stashPat2
							whispStashTop 	:= stashPat3
							whispOther2 	:= stashPat4
							stashPat1 := "", stashPat2 := "", stashPat3 := "", stashPat4 := ""
						}
						else {
							whispOther2 	:= endOfWhisper
						}

						if RegExMatch(whispItem, "S)" poTradeQualityRegExStr, itemQualPat) {
							whispItemLevel 	:= itemQualPat1
							whispItemQual 	:= itemQualPat2
							whispItemName 	:= itemQualPat3
							itemQualPat1 := "", itemQualPat2 := "", itemQualPat3 := ""
						}

						newTradeItem 		:= (whispItemName)?(whispItemName " (Lvl:" whispItemLevel " / Qual:" whispItemQual "%)"):(whispItem)
						newTradePrice 		:= "Unpriced Item (See Offer)"
						newTradeLocation 	:= (whispStash)?(whispLeague " (Tab:" whispStash " / Pos:" whispStashLeft ";" whispStashTop ")"):(whispLeague)
						newTradeOther 		:= (whispOther && whispOther2)?(whispOther " " whispOther2):(whispOther . whispOther2)
					}
					else if ( tradeRegExName = "poeTradeCurrencyRegexStr" ) {
						whispOther 			:= whispPat1
						whispItem 			:= whispPat2
						whispPrice 			:= whispPat3
						endOfWhisper 		:= whispPat4
						whispPat1 := "", whispPat2 := "", whispPat3 := "", whispPat4 := ""

						for id, leagueName in Trading_Leagues {
							if RegExMatch(endOfWhisper, "S)" leagueName "(.*)", endOfWhisperPat) {
								whispLeague 		:= leagueName
								endOfWhisper 		:= endOfWhisperPat1
								endOfWhisperPat1 	:= ""
								Break
							}
						}

						if RegExMatch(endOfWhisper, "S)" poeTradeStashRegexStr, stashPat) {
							whispStash 		:= stashPat1
							whispStashLeft 	:= stashPat2
							whispStashTop 	:= stashPat3
							whispOther2 	:= stashPat4
							stashPat1 := "", stashPat2 := "", stashPat3 := "", stashPat4 := ""
						}
						else {
							whispOther2 	:= endOfWhisper
						}

						newTradeItem 		:= whispItem
						newTradePrice 		:= whispPrice
						newTradeLocation 	:= whispLeague
						newTradeOther 		:= (whispOther && whispOther2)?(whispOther " " whispOther2):(whispOther . whispOther2)
					}
					else if ( tradeRegExName = "poeAppRegExStr" ) {
						whispOther 			:= whispPat1
						whispItem 			:= whispPat2
						whispPrice 			:= whispPat3
						endOfWhisper 		:= whispPat4
						whispPat1 := "", whispPat2 := "", whispPat3 := "", whispPat4 := ""

						for id, leagueName in Trading_Leagues {
							if RegExMatch(endOfWhisper, "S)" leagueName "(.*)", endOfWhisperPat) {
								whispLeague 		:= leagueName
								endOfWhisper 		:= endOfWhisperPat1
								endOfWhisperPat1 	:= ""
								Break
							}
						}

						if RegExMatch(endOfWhisper, "S)" poeAppStashRegexStr, stashPat) {
							whispStash 		:= stashPat1
							whispStashLeft 	:= stashPat2
							whispStashTop 	:= stashPat3
							whispOther2 	:= stashPat4
							stashPat1 := "", stashPat2 := "", stashPat3 := "", stashPat4 := ""
						}
						else {
							whispOther2 	:= endOfWhisper
						}

						if RegExMatch(whispItem, "S)" poeAppQualityRegExStr, itemQualPat) {
							whispItemName 	:= itemQualPat1
							whispItemLevel 	:= itemQualPat2
							whispItemQual 	:= itemQualPat3
							itemQualPat1 := "", itemQualPat2 := "", itemQualPat3 := ""
						}

						newTradeItem 		:= (whispItemName)?(whispItemName " (Lvl:" whispItemLevel " / Qual:" whispItemQual "%)"):(whispItem)
						newTradePrice 		:= whispPrice
						newTradeLocation 	:= (whispStash)?(whispLeague " (Tab:" whispStash " / Pos:" whispStashLeft ";" whispStashTop ")"):(whispLeague)
						newTradeOther 		:= (whispOther && whispOther2)?(whispOther " " whispOther2):(whispOther . whispOther2)
					}
					else if ( tradeRegExName = "poeAppUnpricedRegexStr") {
						whispOther 			:= whispPat1
						whispItem 			:= whispPat2
						endOfWhisper 		:= whispPat3
						whispPat1 := "", whispPat2 := "", whispPat3 := ""

						for id, leagueName in Trading_Leagues {
							if RegExMatch(endOfWhisper, "S)" leagueName "(.*)", endOfWhisperPat) {
								whispLeague 		:= leagueName
								endOfWhisper 		:= endOfWhisperPat1
								endOfWhisperPat1 	:= ""
								Break
							}
						}

						if RegExMatch(endOfWhisper, "S)" poeAppStashRegexStr, stashPat) {
							whispStash 		:= stashPat1
							whispStashLeft 	:= stashPat2
							whispStashTop 	:= stashPat3
							whispOther2 	:= stashPat4
							stashPat1 := "", stashPat2 := "", stashPat3 := "", stashPat4 := ""
						}
						else {
							whispOther2 	:= endOfWhisper
						}

						if RegExMatch(whispItem, "S)" poeAppQualityRegExStr, itemQualPat) {
							whispItemName 	:= itemQualPat1
							whispItemLevel 	:= itemQualPat2
							whispItemQual 	:= itemQualPat3
							itemQualPat1 := "", itemQualPat2 := "", itemQualPat3 := ""
						}

						newTradeItem 		:= (whispItemName)?(whispItemName " (Lvl:" whispItemLevel " / Qual:" whispItemQual "%)"):(whispItem)
						newTradePrice 		:= "Unpriced Item (See Offer)"
						newTradeLocation 	:= (whispStash)?(whispLeague " (Tab:" whispStash " / Pos:" whispStashLeft ";" whispStashTop ")"):(whispLeague)
						newTradeOther 		:= (whispOther && whispOther2)?(whispOther " " whispOther2):(whispOther . whispOther2)
					}
				}

				newTradeItem 		= %newTradeItem%
				newTradePrice 		= %newTradePrice%
				newTradeLocation 	= %newTradeLocation%
				newTradeOther 		= %newTradeOther%
				newTradeOther 		:= StrReplace(newTradeOther, "`n", "")
				newTradeOther 		:= ( newTradeOther && (newTradeOther = "." || newTradeOther = "`n" || newTradeOther = " ") )?("-"):(!newTradeOther)?("-"):(newTradeOther)

;				Check if exact same trade is already in queue
				tradesExists := 0
				tradesInfos := Gui_Trades_Manage_Trades("GET_ALL")
				Loop % tradesInfos.Max_Index {
					buyerContent := tradesInfos[A_Index "_Buyer"], itemContent := tradesInfos[A_Index "_Item"], priceContent := tradesInfos[A_Index "_Price"], locationContent := tradesInfos[A_Index "_Location"], otherContent = tradesInfos[A_Index "_Other"]
					if (buyerContent=whispName && itemContent=newTradeItem && priceContent=newTradePrice && locationContent=newTradeLocation) {
						tradesExists := 1
					}
				}

;				Trade does not already exist. We can add it
				if (tradesExists = 0) {
					newTradesInfos := {Buyer:whispName
									  ,Item:newTradeItem
									  ,Price:newTradePrice
									  ,Location:newTradeLocation
									  ,PID:gamePID
									  ,Time:A_Hour ":" A_Min
									  ,Other:newTradeOther
									  ,Date:A_YYYY "-" A_MM "-" A_DD
									  ,Guild:whispGuild
									  ,InArea:0
									  ,NewMsg:0
									  ,WithdrawTally:0}
					messagesArray := Gui_Trades_Manage_Trades("ADD_NEW", newTradesInfos)
					Gui_Trades("UPDATE", messagesArray)

;					Play the trade received sound notification
					if ( ProgramSettings.Trade_Toggle = 1 ) && FileExist(ProgramSettings.Trade_Sound_Path) {
						SoundPlay,% ProgramSettings.Trade_Sound_Path
					}
;					Play the whisper received sound notification
					else if ( ProgramSettings.Whisper_Toggle = 1 ) && FileExist(ProgramSettings.Whisper_Sound_Path) {
						SoundPlay,% ProgramSettings.Whisper_Sound_Path
					}
				}
				whispName := "", whispGuild := "", newTradeItem := "", newTradePrice := "", newTradeLocation := "", newTradeOther := "", gamePID := ""
			} ; End of trading whisper found

			else { ; No trading whisper match found.
;				Check for existing tabs for the same guy
				tradesInfos := Gui_Trades_Manage_Trades("GET_ALL")
				Loop % tradesInfos.Max_Index {
					if (whispName = tradesInfos[A_Index "_Buyer"]) {
						otherContent := tradesInfos[A_Index "_Other"]
						if (otherContent != "-" && otherContent != "`n") { ; Already contains text, include previous text
							if otherContent not contains (Hover to see all messages) ; Only one message in the Other slot.
							{
								StringReplace, otherContent, otherContent,% "`n",% "",1 ; Remove blank lines
								otherContent := "[" tradesInfos[A_Index "_Time"] "] " otherContent ; Add timestamp
							}
							StringReplace, otherContent, otherContent,% "(Hover to see all messages)`n",% "",1
							otherText := "(Hover to see all messages)`n" otherContent "`n[" A_Hour ":" A_Min "] " whispMsg
						}
						else { ; Does not contains text, do not include previous text
							otherText := "(Hover to see all messages)`n" "[" A_Hour ":" A_Min "] " whispMsg
						}

						setInfos := { OTHER:otherText, TabID:A_Index }
						Gui_Trades_Set_Trades_Infos(setInfos)
						GUI_Trades_Set_NewMsg(A_Index)
						GUI_Trades_Update_Tab_Style(A_Index)
					}
				}

;				Play the whisper sound notification
				if ( ProgramSettings.Whisper_Toggle = 1 ) && FileExist(ProgramSettings.Whisper_Sound_Path) { ; Play the sound set for whispers
					SoundPlay,% ProgramSettings.Whisper_Sound_Path
				}
			}
		} ; End of whisper found

;		Check if a buyer has joined or left the area 
		if ( RegExMatch( A_LoopField, "S)" areaRegexStr, subPat ) ) {
			gamePID := subPat1, whispName := subPat2, areaStatus := subPat3
			TradesGUI_Values.Last_Whisper := whispName

			; Check if player has pending trade
			tradesInfos := Gui_Trades_Manage_Trades("GET_ALL")
			updateCount := 0
			Loop % tradesInfos.Max_Index {
				if (whispName = tradesInfos[A_Index "_Buyer"]) {

					; Check if the player is already in the area
					if ( areaStatus = "joined" && !tradesInfos[A_Index "_InArea"]) {
						; Set tab style
						GUI_Trades_Set_InArea(A_Index)
						GUI_Trades_Update_Tab_Style(A_Index)
						; Play a sound
						if ( ProgramSettings.JoinedArea_Toggle = 1 ) && FileExist(ProgramSettings.JoinedArea_Sound_Path) {
							SoundPlay,% ProgramSettings.JoinedArea_Sound_Path
						}
						; Flash the taskbar
						if !WinActive("ahk_pid " gamePID) {
							if ( ProgramSettings.Whisper_Flash ) {
								gameHwnd := WinExist("ahk_pid " gamePID)
								DllCall("FlashWindow", UInt, gameHwnd, Int, 1)
							}
						}
					}
					else if (areaStatus = "left" && tradesInfos[A_Index "_InArea"] = 1) {
						GUI_Trades_Set_InArea(A_Index, 0)
						GUI_Trades_Update_Tab_Style(A_Index)
					}
				}
			}
		} ; End of area joined
	} ; End of message parsing
}

Restart_Monitor_Game_Logs() {
	Gui_Trades_Save_Position()
	Monitor_Game_Logs("CLOSE")
	Monitor_Game_Logs()
}

Monitor_Game_Logs(mode="") {
;			Retrieve the logs file location by adding \Logs\Client.txt to the PoE executable path
;			Monitor the logs file, waiting for new whispers
;			Upon receiving a poe.trade whisper, pass the trades infos to Gui_Trades()
	global RunParameters, POEGameArray, TradesGUI_Values

	static logsFile, fileObj, sleepTime, timeSinceLastTrade, timer

;	Close file obj when an error occured
	if (mode = "CLOSE") {
		fileObj.Close()
		Return
	}

;	logsFile has not been created yet
	if (!logsFile || !FileExist(logsFile)) {
		if ( RunParameters.GamePath ) {
			WinGet, tempExeLocation, ProcessPath,% "ahk_id " element
			SplitPath,% RunParameters.GamePath, ,directory
			logsFile := directory "\logs\Client.txt"
		}
		else {
			r := Get_All_Games_Instances()
			if ( r = "EXE_NOT_FOUND" ) {
				Gui_Trades_Redraw("EXE_NOT_FOUND", {noSplash:1})
			}
			else {
				logsFile := r
				try Gui_Trades_Set_Position()
			}
		}
		Logs_Append(A_ThisFunc, {File:logsFile})
		fileObj := FileOpen(logsFile, "r")
		fileObj.Read()
	}

;	new line appeared
	if ( fileObj.pos < fileObj.length ) {
		newLogs := fileObj.Read()
		Filter_Logs_Message(newLogs)
	}
;	error occured with logs file
	else if ( !FileExist(logsFile) || (fileObj.pos > fileObj.length) || (fileObj.pos = -1) ) {
		SetTimer,%A_ThisFunc%, Delete
		Logs_Append("Monitor_Game_Logs_Break", {Pos:fileObj.pos, Length:fileObj.length})
		Tray_Notifications_Show("An issue with the logs file occured!", "It could be one of the following reasons: "
		. "`n- The file doesn't exist anymore."
		. "`n- Content from the file was deleted."
		. "`n- The file object used by the program was closed."
		. "`n`nThe logs monitoring function will be restarting in 5 seconds.")
		SetTimer, Restart_Monitor_Game_Logs, -5000
		Return
	}

;	set clever timer, based on when the latest trading whisper was received
	timeSinceLastTrade := A_Now
	EnvSub, timeSinceLastTrade,% TradesGUI_Values.Last_Trade_Time, Seconds
	timer := (!timer)?(400) ; Start at this value
			:( IsBetween(timeSinceLastTrade, 300, 3600) )?(400) ; when no trade received for 5mins
			:( timeSinceLastTrade > 3600 )?(600) ; when no trade received for over an hour
			:(200) ; Otherwise, this value
	SetTimer,% A_ThisFunc, -%timer%
	Return
}

;==================================================================================================================
;
;												TRADES GUI
;
;==================================================================================================================

Gui_Trades(mode="", tradeInfos="") {
;			Trades GUI. Each new item will be added in a new tab
;			Clicking on a button will do its corresponding action
;			Switching tab will clipboard the item's infos if the user enabled
;			Is transparent and click-through when there is no trade on queue
	static
	global ProgramValues, TradesGUI_Values, TradesGUI_Controls, ProgramSettings, SkinAssets

	activeSkin := ProgramSettings.Active_Skin
	scaleMult := ProgramSettings.Scale_Multiplier

	IniRead, fontSizeAuto,% ProgramValues.Fonts_Settings_File,SIZE,% ProgramSettings.Font
	if !IsNum(fontSizeAuto)
		IniRead, fontSizeAuto,% ProgramValues.Fonts_Settings_File,SIZE,Default
	fontName := (ProgramSettings.Font="System")?(""):(ProgramSettings.Font)
	fontSize := (ProgramSettings.Font_Size_Mode="Custom")?(ProgramSettings.Font_Size_Custom)
			   :(fontSizeAuto*scaleMult)
	IniRead, fontQualAuto,% ProgramValues.Fonts_Settings_File,QUALITY,% ProgramSettings.Font
	if !IsNum(fontQualAuto)
		IniRead, fontQualAuto,% ProgramValues.Fonts_Settings_File,QUALITY,Default
	fontQual := (ProgramSettings.Font_Quality_Mode="Custom")?(ProgramSettings.Font_Quality_Custom)
			   :(fontQualAuto)

	maxTabsRow := 8
	maxTabsStage1 := 26
	maxTabsStage2 := 51
	maxTabsStage3 := 76
	maxTabsStage4 := 101
	maxTabsStage5 := 251
	TradesGUI_Values["Max_Tabs_Per_Row"] := maxTabsRow

	Loop {
		local btnUnicodePos := ProgramSettings["Button_Unicode_" A_Index "_Position"]
		local useSmallerButtons := (btnUnicodePos != "Disabled")?(true):(false)
		if ( useSmallerButtons = true || btnUnicodePos = "ERROR" )
			Break
	}
	TradesGUI_Values.Use_Smaller_Buttons := useSmallerButtons
	btnUnicodePos := "", useSmallerButtons := ""

	if ( mode = "CREATE" ) {

		TradesGUI_Values.Created 	:= false

		colorTitleActive 			:= (ProgramSettings.Color_Title_Active = "000000")?("Black"):("0x" ProgramSettings.Color_Title_Active)
		colorTitleInactive 			:= (ProgramSettings.Color_Title_Inactive = "000000")?("Black"):("0x" ProgramSettings.Color_Title_Inactive)
		colorTradesInfos1 			:= (ProgramSettings.Color_Trades_Infos_1 = "000000")?("Black"):("0x" ProgramSettings.Color_Trades_Infos_1)
		colorTradesInfos2 			:= (ProgramSettings.Color_Trades_Infos_2 = "000000")?("Black"):("0x" ProgramSettings.Color_Trades_Infos_2)
		colorBorder 				:= (ProgramSettings.Color_Border = "000000")?("Black"):("0x" ProgramSettings.Color_Border)

		colorButtonNormal 			:= (ProgramSettings.Color_Button_Normal = "000000")?("Black"):("0x" ProgramSettings.Color_Button_Normal)
		colorButtonHover 			:= (ProgramSettings.Color_Button_Hover = "000000")?("Black"):("0x" ProgramSettings.Color_Button_Hover)
		colorButtonPress 			:= (ProgramSettings.Color_Button_Press = "000000")?("Black"):("0x" ProgramSettings.Color_Button_Press)

		colorTabActive 				:= (ProgramSettings.Color_Tab_Active = "000000")?("Black"):("0x" ProgramSettings.Color_Tab_Active)
		colorTabInactive 			:= (ProgramSettings.Color_Tab_Inactive = "000000")?("Black"):("0x" ProgramSettings.Color_Tab_Inactive)
		colorTabHover 				:= (ProgramSettings.Color_Tab_Hover = "000000")?("Black"):("0x" ProgramSettings.Color_Tab_Hover)
		colorTabPress 				:= (ProgramSettings.Color_Tab_Press = "000000")?("Black"):("0x" ProgramSettings.Color_Tab_Press)

		colorTabJoinedActive 		:= (ProgramSettings.Color_Tab_Joined_Active = "000000")?("Black"):("0x" ProgramSettings.Color_Tab_Joined_Active)
		colorTabJoinedInactive 		:= (ProgramSettings.Color_Tab_Joined_Inactive = "000000")?("Black"):("0x" ProgramSettings.Color_Tab_Joined_Inactive)
		colorTabJoinedHover 		:= (ProgramSettings.Color_Tab_Joined_Hover = "000000")?("Black"):("0x" ProgramSettings.Color_Tab_Joined_Hover)
		colorTabJoinedPress 		:= (ProgramSettings.Color_Tab_Joined_Press = "000000")?("Black"):("0x" ProgramSettings.Color_Tab_Joined_Press)

		colorTabWhisperActive 		:= (ProgramSettings.Color_Tab_Whisper_Active = "000000")?("Black"):("0x" ProgramSettings.Color_Tab_Whisper_Active)
		colorTabWhisperInactive 	:= (ProgramSettings.Color_Tab_Whisper_Inactive = "000000")?("Black"):("0x" ProgramSettings.Color_Tab_Whisper_Inactive)
		colorTabWhisperHover 		:= (ProgramSettings.Color_Tab_Whisper_Hover = "000000")?("Black"):("0x" ProgramSettings.Color_Tab_Whisper_Hover)
		colorTabWhisperPress 		:= (ProgramSettings.Color_Tab_Whisper_Press = "000000")?("Black"):("0x" ProgramSettings.Color_Tab_Whisper_Press)

		pngTransColor 				:= (SkinAssets.Misc_Transparency_Color = "000000")?("Black"):("0x" SkinAssets.Misc_Transparency_Color)

		IBStyle_Tab 				:=	[ [0, SkinAssets.Tab_Inactive, "", colorTabInactive, "", pngTransColor]			; normal
				              			, [0, SkinAssets.Tab_Hover, "", colorTabHover, "", pngTransColor]				; hover
				    	      			, [0, SkinAssets.Tab_Press, "", colorTabPress, "", pngTransColor]				; pressed
							  			, [0, SkinAssets.Tab_Active, "", colorTabActive, "", pngTransColor] ]			; disabled (defaulted)

		IBStyle_Tab_Joined 			:=	[ [0, SkinAssets.Tab_Joined_Inactive, "", colorTabJoinedInactive, "", pngTransColor]
				              			, [0, SkinAssets.Tab_Joined_Hover, "", colorTabJoinedHover, "", pngTransColor]
				    	      			, [0, SkinAssets.Tab_Joined_Press, "", colorTabJoinedPress, "", pngTransColor]
							  			, [0, SkinAssets.Tab_Joined_Active, "", colorTabJoinedActive, "", pngTransColor] ]

		IBStyle_Tab_Whisper 		:=	[ [0, SkinAssets.Tab_Whisper_Inactive, "", colorTabWhisperInactive, "", pngTransColor]
				              			, [0, SkinAssets.Tab_Whisper_Hover, "", colorTabWhisperHover, "", pngTransColor]
				    	      			, [0, SkinAssets.Tab_Whisper_Press, "", colorTabWhisperPress, "", pngTransColor]
							  			, [0, SkinAssets.Tab_Whisper_Active, "", colorTabWhisperActive, "", pngTransColor] ]

		IBStyle_Arrow_Left 			:=	[ [0, SkinAssets.Arrow_Left_Normal, "", colorButtonNormal, "", pngTransColor]
				              			, [0, SkinAssets.Arrow_Left_Hover, "", colorButtonHover, "", pngTransColor]
				    	      			, [0, SkinAssets.Arrow_Left_Press, "", colorButtonPress, "", pngTransColor] ]

		IBStyle_Arrow_Right 		:=	[ [0, SkinAssets.Arrow_Right_Normal, "", colorButtonNormal, "", pngTransColor]
				              			, [0, SkinAssets.Arrow_Right_Hover, "", colorButtonHover, "", pngTransColor]
				    	      			, [0, SkinAssets.Arrow_Right_Press, "", colorButtonPress, "", pngTransColor] ]

		IBStyle_Button_OneThird 	:=	[ [0, SkinAssets.Button_OneThird_Normal, "", colorButtonNormal, "", pngTransColor]
				              			, [0, SkinAssets.Button_OneThird_Hover, "", colorButtonHover, "", pngTransColor]
				    	      			, [0, SkinAssets.Button_OneThird_Press, "", colorButtonPress, "", pngTransColor] ]

		IBStyle_Button_TwoThird 	:=	[ [0, SkinAssets.Button_TwoThird_Normal, "", colorButtonNormal, "", pngTransColor]
				              			, [0, SkinAssets.Button_TwoThird_Hover, "", colorButtonHover, "", pngTransColor]
				    	      			, [0, SkinAssets.Button_TwoThird_Press, "", colorButtonPress, "", pngTransColor] ]

		IBStyle_Button_ThreeThird 	:=	[ [0, SkinAssets.Button_ThreeThird_Normal, "", colorButtonNormal, "", pngTransColor]
				              			, [0, SkinAssets.Button_ThreeThird_Hover, "", colorButtonHover, "", pngTransColor]
				    	      			, [0, SkinAssets.Button_ThreeThird_Press, "", colorButtonPress, "", pngTransColor] ]

		IBStyle_Button_Special 		:=	[ [0, SkinAssets.Button_Special_Normal, "", colorButtonNormal, "", pngTransColor]
				              			, [0, SkinAssets.Button_Special_Hover, "", colorButtonHover, "", pngTransColor]
				    	      			, [0, SkinAssets.Button_Special_Press, "", colorButtonPress, "", pngTransColor] ]

		IBStyle_Close_Tab 			:=	[ [0, SkinAssets.Close_Tab_Normal, "", colorButtonNormal, "", pngTransColor]
				              			, [0, SkinAssets.Close_Tab_Hover, "", colorButtonHover, "", pngTransColor]
				    	      			, [0, SkinAssets.Close_Tab_Press, "", colorButtonPress, "", pngTransColor] ]

		IBStyle_Minimize 			:=	[ [0, SkinAssets.Minimize_Normal, "", colorButtonNormal, "", pngTransColor]
				              			, [0, SkinAssets.Minimize_Hover, "", colorButtonHover, "", pngTransColor]
				    	      			, [0, SkinAssets.Minimize_Press, "", colorButtonPress, "", pngTransColor] ]

		IBStyle_Maximize 			:=	[ [0, SkinAssets.Maximize_Normal, "", colorButtonNormal, "", pngTransColor]
				              			, [0, SkinAssets.Maximize_Hover, "", colorButtonHover, "", pngTransColor]
				    	      			, [0, SkinAssets.Maximize_Press, "", colorButtonPress, "", pngTransColor] ]


		Gui, Trades:Destroy
		Gui, Trades:New, +ToolWindow +AlwaysOnTop -Border +hwndGuiTradesHandler +LabelGui_Trades_ +LastFound -SysMenu -Caption
		TradesGUI_Values.Handler := GuiTradesHandler

		Gui, Trades:Color, %pngTransColor%
		Gui, Trades:Margin, 0, 0
		Gui, Trades:+OwnDialogs

		tabHeight := Gui_Trades_Get_Tab_Height(), tabWidth := 390*scaleMult
		guiWidth := 401*scaleMult, guiHeight := Floor((tabHeight+39)*scaleMult), guiHeightMin := 31*scaleMult ; 30 = banner size, 1 = border

		borderSize := 1
		TradesGUI_Values.Insert("Height_Full", guiHeight)
		TradesGUI_Values.Insert("Height_Minimized", guiHeightMin)

		maxTabsRendered := (!maxTabsRendered)?(maxTabsStage1):(maxTabsRendered)

		TradesGUI_Values["Max_Tabs_Rendered"] := maxTabsRendered

;		Keep the size of whichever number is the largest in width
		timeSlotWidth := 0
		Loop 9 {
			txtCtrlSize := Get_Text_Control_Size(A_Index A_Index ":" A_Index A_Index, fontName, fontSize)
			this_timeSlotWidth := txtCtrlSize.W
			timeSlotWidth := (this_timeSlotWidth > timeSlotWidth)?(this_timeSlotWidth):(timeSlotWidth)
		}
		txtCtrlSize := "", this_timeSlotWidth := ""

;		Title text size
		txtCtrlSize := Get_Text_Control_Size("POE Trades Companion", fontName, fontSize)
		; titleTextWidth := txtCtrlSize.W
		titleTextHeight := txtCtrlSize.H
		txtCtrlSize := ""

		Gui, Trades:Font,S%fontSize% Q%fontQual%,% fontName
		Gui, Trades:Add, Tab2, x0 y0 w0 h0 -Wrap vTabCtrl hWndhTabCtrl,% ""
		TradesGUI_Controls["Tab"] := hTabCtrl

/* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
 * * * * * * * * * *			S K I N N I N G			* * * * * * * * * *
 * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
*/
; - - - - - Background and title bar
		Gui, Trades:Tab
		Gui, Trades:Add, Picture,% "x0 y0 hWndhBackground BackgroundTrans",% SkinAssets.Misc_Background
		Tile_Picture("Trades", hBackground, guiWidth, guiHeight) ; Fill the background
		Gui, Trades:Add, Picture,% "x" borderSize " y" borderSize " w" guiWidth-(borderSize*2) " h" (30*scaleMult) " BackgroundTrans Section",% SkinAssets.Misc_Header
		Gui, Trades:Add, Picture,% "x" borderSize+(2*scaleMult) " y" borderSize+(2*scaleMult) " w" 24*scaleMult " h" 24*scaleMult " +BackgroundTrans",% SkinAssets.Misc_Icon

		Gui, Trades:Add, Button,% "x" guiWidth-(20*scaleMult)-borderSize-4 " y" borderSize+4 " w20 h20 gGui_Trades_Minimize hwndhHeaderMinimize",% ""
		if !ImageButton.Create(hHeaderMinimize, IBStyle_Minimize*)
			MsgBox, 0, ImageButton Error Minimize, % ImageButton.LastError
		Gui, Trades:Add, Button,% "x" guiWidth-(20*scaleMult)-borderSize-4 " y" borderSize+4 " w20 h20 gGui_Trades_Minimize hwndhHeaderMaximize",% ""
		if !ImageButton.Create(hHeaderMaximize, IBStyle_Maximize*)
			MsgBox, 0, ImageButton Error Maximize, % ImageButton.LastError

		Gui, Trades:Add, Text,% "x" borderSize+(24*scaleMult) . " y" borderSize . " w" guiWidth-(borderSize+(32*scaleMult))-(borderSize-4+(20*scaleMult)) " h" (30-(2*scaleMult))*scaleMult " hWndhHeaderTitle gGui_Trades_Move c" colorTitleInactive . " BackgroundTrans +0x200 Center",% ProgramValues.Name

		TradesGUI_Controls["Header_Title"]		:= hHeaderTitle
		TradesGUI_Controls["Header_Minimize"]	:= hHeaderMinimize
		TradesGUI_Controls["Header_Maximize"]	:= hHeaderMaximize
; - - - - - Borders
		Gui, Trades:Tab
		Gui, Trades:Add, Progress,% "x" 0 . " y" 0 . " w" guiWidth . " h" borderSize . " hWndhBorderTop Background" colorBorder ; Top
		Gui, Trades:Add, Progress,% "x" 0 . " y" 0 . " w" borderSize . " h" guiHeight . " hWndhBorderLeft Background" colorBorder ; Left
		Gui, Trades:Add, Progress,% "x" guiWidth-borderSize . " y" 0 . " w" borderSize . " h" guiHeight . " hWndhBorderRight Background" colorBorder ; Right
		Gui, Trades:Add, Progress,% "x" 0 . " y" guiHeight-borderSize . " w" guiWidth . " h" borderSize . " hWndhBorderBottom Background" colorBorder ; Bottom

		TradesGUI_Controls["Border_Top"]		:= hBorderTop
		TradesGUI_Controls["Border_Left"]		:= hBorderLeft
		TradesGUI_Controls["Border_Right"]		:= hBorderRight
		TradesGUI_Controls["Border_Bottom"]		:= hBorderBottom

; - - - - - Tabs Background
		Gui, Trades:Add, Picture,% "x" borderSize*scaleMult " ys+" 30*scaleMult " w" (40*scaleMult)*maxTabsRow " h" 25*scaleMult " hwndhTabsBackground Hidden",% SkinAssets.Misc_Tabs_Background
		TradesGUI_Controls.Tabs_Background := hTabsBackground

; - - - - - Tabs
		Loop %maxTabsRendered% {
			btnPos := (A_Index=1)?("x" borderSize*scaleMult " ys+" 30*scaleMult " w" 40*scaleMult " h" 25*scaleMult):(A_Index > maxTabsRow)?("xp yp wp hp"):("xp+" 40*scaleMult " yp wp hp")
			
			; Default Tab
			Gui, Trades:Add, Button,%btnPos% gGui_Trades_SetActiveTab vTab%A_Index% hWndhTab%A_Index% Section,% A_Index
			if !ImageButton.Create(hTab%A_Index%, IBStyle_Tab*)
				MsgBox, 0, ImageButton Error Tab%A_Index% Default, % ImageButton.LastError

			GuiControl,Trades:Hide,% hTab%A_Index%
			TradesGUI_Controls["TabDefault_" A_Index] := hTab%A_Index%

			; Joined Tab
			btnPos := "xp yp wp hp"
			Gui, Trades:Add, Button,%btnPos% gGui_Trades_SetActiveTab vTabJoined%A_Index% hWndhTabJoined%A_Index% Section,% A_Index
			if !ImageButton.Create(hTabJoined%A_Index%, IBStyle_Tab_Joined*)
				MsgBox, 0, ImageButton Error Tab%A_Index% Joined, % ImageButton.LastError

			GuiControl,Trades:Hide,% hTabJoined%A_Index%
			TradesGUI_Controls["TabJoined_" A_Index] := hTabJoined%A_Index%

			; Whisper tab
			Gui, Trades:Add, Button,%btnPos% gGui_Trades_SetActiveTab vTabMsg%A_Index% hWndhTabMsg%A_Index% Section,% A_Index
			if !ImageButton.Create(hTabMsg%A_Index%, IBStyle_Tab_Whisper*)
				MsgBox, 0, ImageButton Error Tab%A_Index% Whisper, % ImageButton.LastError

			GuiControl,Trades:Hide,% hTabMsg%A_Index%
			TradesGUI_Controls["TabMsg_" A_Index] := hTabMsg%A_Index%

			TradesGUI_Controls["Tab_" A_Index] := hTab%A_Index%
		}

		Loop % maxTabsRow {
			btnPos := (A_Index=1)?("x" borderSize*scaleMult " yp w0 h0"):(A_Index > maxTabsRow)?("xp yp wp hp"):("xp+" 40*scaleMult " yp wp hp")

			Gui, Trades:Add, Text,%btnPos% hWndhTabSlot%A_Index%,% ""
			TradesGUI_Controls["Tab_Slot_" A_Index] := hTabSlot%A_Index%
		}

; - - - - - Left / Right arrows and Close
		Gui, Trades:Add, Button,% "xp+" 40*scaleMult " yp w" 25*scaleMult " h" 25*scaleMult " hWndhArrowLeft gGui_Trades_Arrow_Left BackgroundTrans",% (SkinAssets.Arrow_Left_Use_Character)?("<"):("")
		if !ImageButton.Create(hArrowLeft, IBStyle_Arrow_Left*)
			MsgBox, 0, ImageButton Error Left Arrow, % ImageButton.LastError
		Gui, Trades:Add, Button,% "xp+" 25*scaleMult " yp w" 25*scaleMult " h" 25*scaleMult " hWndhArrowRight gGui_Trades_Arrow_Right BackgroundTrans",% (SkinAssets.Arrow_Right_Use_Character)?(">"):("")
		if !ImageButton.Create(hArrowRight, IBStyle_Arrow_Right*)
			MsgBox, 0, ImageButton Error Right Arrow, % ImageButton.LastError

		Gui, Trades:Add, Button,% "xp+" 26*scaleMult " yp w" 27*scaleMult " h" 25*scaleMult " hWndhBtnCloseTab gGui_Trades_Close_Tab_Label Section",% (SkinAssets.Close_Tab_Use_Character)?("X"):("")
		if !ImageButton.Create(hBtnCloseTab, IBStyle_Close_Tab*)
			MsgBox, 0, ImageButton Error Close Tab, % ImageButton.LastError

		TradesGUI_Controls["Arrow_Left"]			:= hArrowLeft
		TradesGUI_Controls["Arrow_Right"]			:= hArrowRight
		TradesGUI_Controls["Close_Tab"]				:= hBtnCloseTab

; - - - - - Tab Underline
		Gui, Trades:Add, Picture,% "x" borderSize*scaleMult " yp+" 25*scaleMult " w" ((guiWidth-borderSize)*scaleMult)-(borderSize*scaleMult) " h" 2*scaleMult " hWndhTabsUnderline",% SkinAssets.Misc_Tabs_Underline
		TradesGUI_Controls["Tabs_Underline"]			:= hTabsUnderline

; - - - - - Tabs content
		Loop %maxTabsRendered% {
			GuiControl, Trades:, TabCtrl,% A_Index "|"
			Gui, Trades:Tab,% A_Index,,Exact

			; Text slots
			controlParams := " BackgroundTrans c" colorTradesInfos1
			Gui, Trades:Add, Text,% "x" 10 " ys+" 30*scaleMult " w80 R1 hwndBuyerText" A_Index "Handler " controlParams,% "Buyer:"
			Gui, Trades:Add, Text,% "xp yp+" 15*scaleMult " w80 R1 hwndItemText" A_Index "Handler " controlParams,% "Item:"
			Gui, Trades:Add, Text,% "xp yp+" 15*scaleMult " w80 R1 hwndPriceText" A_Index "Handler " controlParams,% "Price:"
			Gui, Trades:Add, Text,% "xp yp+" 15*scaleMult " w80 R1 hwndLocationText" A_Index "Handler " controlParams,% "Location:"
			Gui, Trades:Add, Text,% "xp yp+" 15*scaleMult " w80 R1 hwndOtherText" A_Index "Handler " controlParams,% "Other:"

			; Infos slots
			controlParams := " BackgroundTrans +0x0100 R1 c" colorTradesInfos2
			Gui, Trades:Add, Text,% "xp+" 80*scaleMult " ys+" 30*scaleMult " w" 255*scaleMult " vBuyerSlot" A_Index " hwndBuyerSlot" A_Index "Handler " controlParams " R1",% ""
			Gui, Trades:Add, Text,% "xp yp+" 15*scaleMult " w" 310*scaleMult " vItemSlot" A_Index " hwndItemSlot" A_Index "Handler " controlParams " R1",% ""
			Gui, Trades:Add, Text,% "xp yp+" 15*scaleMult " wp vPriceSlot" A_Index . " hwndPriceSlot" A_Index "Handler " controlParams " R1",% ""
			Gui, Trades:Add, Text,% "xp yp+" 15*scaleMult " wp vLocationSlot" A_Index . " hwndLocationSlot" A_Index "Handler " controlParams " R1",% ""
			Gui, Trades:Add, Text,% "xp yp+" 15*scaleMult " wp vOtherSlot" A_Index . " hwndOtherSlot" A_Index "Handler " controlParams " R1",% ""
			Gui, Trades:Add, Text,% "x" (guiWidth-timeSlotWidth)-(5*scaleMult) " ys+" 28*scaleMult " w" timeSlotWidth . " h15 vTimeSlot" A_Index " hwndTimeSlot" A_Index "Handler " controlParams " R1",% ""
			Gui, Trades:Add, Text,% "x0 y0 w0 h0 vPIDSlot" A_Index " hwndPIDSlot" A_Index "Handler",% ""
			Gui, Trades:Add, Text,% "x0 y0 w0 h0 vDateSlot" A_Index " hwndDateSlot" A_Index "Handler",% ""
			Gui, Trades:Add, Text,% "x0 y0 w0 h0 vGuildSlot" A_Index " hwndGuildSlot" A_Index "Handler",% ""
			Gui, Trades:Add, Text,% "x0 y0 w0 h0 vInAreaSlot" A_Index " hwndInAreaSlot" A_Index "Handler",% ""
			Gui, Trades:Add, Text,% "x0 y0 w0 h0 vNewMsgSlot" A_Index " hwndNewMsgSlot" A_Index "Handler",% ""
      Gui, Trades:Add, Text,% "x0 y0 w0 h0 vWithdrawTallySlot" A_Index " hwndWithdrawTallySlot" A_Index "Handler",% ""

			TradesGUI_Controls["Buyer_Slot_" A_Index] 			:= BuyerSlot%A_Index%Handler
			TradesGUI_Controls["Item_Slot_" A_Index] 			:= ItemSlot%A_Index%Handler
			TradesGUI_Controls["Price_Slot_" A_Index] 			:= PriceSlot%A_Index%Handler
			TradesGUI_Controls["Location_Slot_" A_Index] 		:= LocationSlot%A_Index%Handler
			TradesGUI_Controls["Other_Slot_" A_Index] 			:= OtherSlot%A_Index%Handler
			TradesGUI_Controls["Time_Slot_" A_Index] 			:= TimeSlot%A_Index%Handler
			TradesGUI_Controls["PID_Slot_" A_Index] 			:= PIDSlot%A_Index%Handler
			TradesGUI_Controls["Date_Slot_" A_Index] 			:= DateSlot%A_Index%Handler
			TradesGUI_Controls["Guild_Slot_" A_Index] 			:= GuildSlot%A_Index%Handler
			TradesGUI_Controls["InArea_Slot_" A_Index] 			:= InAreaSlot%A_Index%Handler
			TradesGUI_Controls["NewMsg_Slot_" A_Index] 			:= NewMsgSlot%A_Index%Handler
			TradesGUI_Controls["WithdrawTally_Slot_" A_Index] 			:= WithdrawTallySlot%A_Index%Handler
		}

; - - - - - TC_Symbols buttons
		Gui, Trades:Tab
		Gui, Trades:Font,% "S" 20*scaleMult,% "TC_Symbols"
		fontChars := {Clipboard:"0", Whisper:"1", Invite:"2", Trade:"3", Kick:"4"}
		fontCharsID := {1:"Clipboard",2:"Whisper",3:"Invite",4:"Trade",5:"Kick"}
		for btnID, btnType in fontCharsID {
			btnOrder := ProgramSettings["Button_Unicode_" btnID "_Position"]
			if ( btnOrder != "Disabled" ) {
				btnPos_X := ( (btnOrder-1)*(40)*scaleMult )+10,    btnPos_Y := 140,    btnPos_W := 35,    btnPos_H := 25
				btnOrnaLeftPos_X := btnPos_X,    btnOrnaLeftPos_Y := btnPos_Y,    btnOrnaLeftPos_W := 10,    btnOrnaLeftPos_H := btnPos_H
				btnOrnaRightPos_X := (btnPos_X+btnPos_W)-btnOrnaLeftPos_W,    btnOrnaRightPos_Y := btnOrnaLeftPos_Y,    btnOrnaRightPos_W :=btnOrnaLeftPos_W,    btnOrnaRightPos_H := btnOrnaLeftPos_H
				btnHandler := "UnicodeBtn" A_Index

				Gui, Trades:Add, Button,% "x" btnPos_X " y" btnPos_Y*scaleMult " w" btnPos_W*scaleMult " h" btnPos_H*scaleMult " hWnd" btnHandler " BackgroundTrans gGui_Trades_Do_Action_Func",% fontChars[btnType]
				if !ImageButton.Create(%btnHandler%, IBStyle_Button_Special*)
					MsgBox, 0, ImageButton Error Special Buttons, % ImageButton.LastError

		   		TradesGUI_Controls["Button_Unicode_" A_Index] 				:= %btnHandler%
		   		TradesGUI_Controls["Button_Unicode_" A_Index "_Action"] 	:= btnType
   			}
		}
		btnType := "", btnChar := "", fontChars := "", handler := ""
		btnPos_X := "", btnPos_Y := "", btnPos_W := "", btnPos_H := ""
		btnOrnaLeftPos_X := "", btnOrnaLeftPos_Y := "", btnOrnaLeftPos_W := "", btnOrnaLeftPos_H := ""
		btnOrnaRightPos_X := "", btnOrnaRightPos_Y := "", btnOrnaRightPos_W :="", btnOrnaRightPos_H := ""

; - - - - - Custom buttons
		Gui, Trades:Tab
		Gui, Trades:Font ; Revert to font
		Gui, Trades:Font,% "S" fontSize " Q" fontQual,% fontName
		Loop 9 {
			btnSettingsSize := ProgramSettings["Button" A_Index "_SIZE"]
			btnSettingsHor := ProgramSettings["Button" A_Index "_H"]
			btnSettingsVer := ProgramSettings["Button" A_Index "_V"]
			btnSettingsAction := ProgramSettings["Button" A_Index "_Action"]
			btnSettingsName := ProgramSettings["Button" A_Index "_Label"]

			defaultBtnY := (TradesGUI_Values.Use_Smaller_Buttons)?(170):(145)

			; guiWidth--
			btnX := (btnSettingsHor="Left")?( (guiWidth/3)*0 +10)
				   :(btnSettingsHor="Center")?( (guiWidth/3)*1 +5)
				   :(btnSettingsHor="Right")?( (guiWidth/3)*2 +0)
				   :("ERROR")
			btnY := (btnSettingsVer="Top")?(defaultBtnY)
				   :(btnSettingsVer="Middle")?(defaultBtnY+40)
				   :(btnSettingsVer="Bottom")?(defaultBtnY+80)
				   :("ERROR")
			btnW := (btnSettingsSize="Small")?( (guiWidth/3)*1 -10)
				   :(btnSettingsSize="Medium")?( (guiWidth/3)*2 -15)
				   :(btnSettingsSize="Large")?( (guiWidth/3)*3 -20)
				   :("ERROR")
			btnH := 35

			btnOrnaW := 8, btnOrnaH := btnH
			btnOrnaLeftX := btnX, btnOrnaRightX := btnX+btnW-btnOrnaW
			btnOrnaLeftY := btnY, btnOrnaRightY := btnY

			btnTextX := btnX, btnTextY := "p+" 10, btnTextW := btnW, btnTextH := btnH

			btnName := btnSettingsName
			btnAction := RegExReplace(btnSettingsAction, "[ _+()]", "_")
			btnAction := RegExReplace(btnAction, "___", "_")
			btnAction := RegExReplace(btnAction, "__", "_")
			btnAction := RegExReplace(btnAction, "_", "", ,1,-1)

			IBStyle := (btnSettingsSize="Small")?(IBStyle_Button_OneThird)
				   :(btnSettingsSize="Medium")?(IBStyle_Button_TwoThird)
				   :(btnSettingsSize="Large")?(IBStyle_Button_ThreeThird)
				   :(IBStyle_Button_OneThird)

			if ( btnW != "ERROR" && btnX != "ERROR" && btnY != "ERROR" && btnAction != "" && btnAction != "ERROR" ) {
				Gui, Trades:Add, Button,% "x" btnX " y" btnY*scaleMult " w" btnW " h" btnH*scaleMult " hWndhBtnCustom" A_Index " gGui_Trades_Do_Action_Func BackgroundTrans",% btnName
				if !ImageButton.Create(hBtnCustom%A_Index%, IBStyle*)
					MsgBox, 0, ImageButton Error Custom Buttons %btnSettingsSize%, % ImageButton.LastError

				TradesGUI_Controls["Button_Custom_" A_Index]				:= hBtnCustom%A_Index%
				TradesGUI_Controls["Button_Custom_" A_Index "_Action"]		:= btnAction
			}
		}
		btnSettingsSize := "", btnSettingsHor := "", btnSettingsVer := "", btnSettingsAction := "", btnSettingsName := ""
		btnW := "", btnH := "", btnX := "", btnY := "", btnName := "", btnAction := ""
		btnOrnaW := "", btnOrnaH := "", btnOrnaLeftX := "", btnOrnaRightX := "", btnOrnaLeftY := "", btnOrnaRightY := ""
		btnTextX := "", btnTextY := "", btnTextW := "", btnTextH := "", IBStyle := ""

; - - - - - Error messages
		noTradeMsg := "All trade request have been answered"
				    . "`nor no whisper has been received yet."
				    . "`n`nRight click on the tray icon,"
				    . "`nthen [Settings] to set your preferences."
		GuiControl, Trades:, TabCtrl,% "No Trades On Queue|"
		Gui, Trades:Tab,% "No Trades On Queue",,Exact
		Gui, Trades:Add, Text,x0 y55 w%guiWidth% Center BackgroundTrans hWndhNoTradeMsg c%colorTradesInfos1%,% noTradeMsg
		TradesGUI_Controls["No_Trade_Msg"] 		:= hNoTradeMsg

		noInstanceMsg := "No game instance could be found,"
					   . "`nretrying in XX seconds..."
					   . "`n`nRight click on the tray icon,"
					   . "`nthen [Settings] to set your preferences."
		GuiControl, Trades:, TabCtrl,% "Logs File Not Found|"
		Gui, Trades:Tab,% "Logs File Not Found",,Exact
		Gui, Trades:Add, Text,x0 y55 w%guiWidth% Center BackgroundTrans hWndhNoInstanceMsg c%colorTradesInfos1%,% noInstanceMsg
		TradesGUI_Controls["No_Instance_Msg"] 	:= hNoInstanceMsg

; - - - - -
		Gui, Trades:Tab
	}
/* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * 
* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * 
*/ 

	if ( mode = "EXE_NOT_FOUND" ) {
		if (TradesGUI_Values.Tabs_Count)
			Gui_Trades_SetActiveTab_Func(1)
		else 
			GuiControl, Trades:ChooseString,% TradesGUI_Controls["Tab"],% "|Logs File Not Found"
		gameInstances := Get_All_Games_Instances()
		While ( gameInstances = "EXE_NOT_FOUND" ) {
			countDown := 10
			Loop % countDown+1 {
				noInstanceMsgReplaced := RegExReplace(noInstanceMsg, "XX", countDown)
				GuiControl, Trades:,% TradesGUI_Controls["No_Instance_Msg"],% noInstanceMsgReplaced
				countDown--
				Sleep 1000
			}
			gameInstances := Get_All_Games_Instances()
			Sleep 10
		}
		if (TradesGUI_Values.Tabs_Count)
			Gui_Trades_SetActiveTab_Func(1)
		else
			GuiControl, Trades:ChooseString,% TradesGUI_Controls["Tab"],% "No Trades On Queue"
		countDown := "", gameInstances := ""
		Monitor_Game_Logs()
	}

	if ( mode = "UPDATE" || mode = "CREATE" ) {

; - - - - - Setting local and global values
		tabsCount 									:= (tradeInfos.Max_Index)?(tradeInfos.Max_Index):(0)
		tabsCountReduced 							:= (previousTabsCount > tabsCount)?(1):(0)
		tabsCountIncreased 							:= (previousTabsCount < tabsCount)?(1):(0)
		tabsCountChanged 							:= (previousTabsCount != tabsCount)?(1):(0)

		TradesGUI_Values.Active_Tab 				:= Gui_Trades_Get_Tab_ID()
		TradesGUI_Values.Tabs_Count 				:= tabsCount
		TradesGUI_Values.Tabs_Count_Reduced 		:= tabsCountReduced
		TradesGUI_Values.Tabs_Count_Increased 		:= tabsCountIncreased
		TradesGUI_Values.Tabs_Count_Changed 		:= tabsCountChanged

		if (mode = "UPDATE" && tabsCountIncreased)
			TradesGUI_Values.Last_Trade_Time := A_Now

; - - - - - No tab is activated, focus the first tab
		activeTabID := Gui_Trades_Get_Tab_ID()
		if (tabsCount) { ; Trading tabs exists
			if (activeTabID = "No Trades On Queue" || activeTabID = "Logs File Not Found") {
				Gui_Trades_SetActiveTab_Func(1)
			}
		}
		activeTabID := ""

; - - - - - Update the fields with the trade infos
		isGuiActive := false
		Loop % tradeInfos.Max_Index {
			isGuiActive := true
			GuiControl, Trades:,% buyerSlot%A_Index%Handler,% tradeInfos[A_Index "_Buyer"]
			GuiControl, Trades:,% itemSlot%A_Index%Handler,% tradeInfos[A_Index "_Item"]
			GuiControl, Trades:,% priceSlot%A_Index%Handler,% tradeInfos[A_Index "_Price"]
			GuiControl, Trades:,% locationSlot%A_Index%Handler,% tradeInfos[A_Index "_Location"]
			GuiControl, Trades:,% PIDSlot%A_Index%Handler,% tradeInfos[A_Index "_PID"]
			GuiControl, Trades:,% TimeSlot%A_Index%Handler,% tradeInfos[A_Index "_Time"]
			GuiControl, Trades:,% OtherSlot%A_Index%Handler,% tradeInfos[A_Index "_Other"]
			GuiControl, Trades:,% DateSlot%A_Index%Handler,% tradeInfos[A_Index "_Date"]
			GuiControl, Trades:,% GuildSlot%A_Index%Handler,% tradeInfos[A_Index "_Guild"]
			GuiControl, Trades:,% InAreaSlot%A_Index%Handler,% tradeInfos[A_Index "_InArea"]
			GuiControl, Trades:,% NewMsgSlot%A_Index%Handler,% tradeInfos[A_Index "_NewMsg"]
			GuiControl, Trades:,% WithdrawTallySlot%A_Index%Handler,% tradeInfos[A_Index "_WithdrawTally"]
			GuiControl, Trades:,% TradesGUI_Controls["Tab_" A_Index],% A_Index
			GUI_Trades_Update_Tab_Style(A_Index)
		}
		Gui_Trades_Adjust_Tabs() ; Hide or show tabs controls, based on tabsCount

; - - - - - Set title color and count, transparency and click-through
		if (isGuiActive) {
			showOrHide := "Show"
			GuiControl, Trades:Hide,% ErrorMsgTextHandler
			GuiControl, Trades: +c%colorTitleActive%,% TradesGUI_Controls.Header_Title
			; GuiControl, Trades: +c%colorTitleActive%,% TradesGUI_Controls.Header_Minimize
		}
		else {
			showOrHide := "Hide"
			GuiControl, Trades:,% ErrorMsgTextHandler,% noTradeMsg
			GuiControl, Trades:Show,% ErrorMsgTextHandler
			GuiControl, Trades: +c%colorTitleInactive%,% TradesGUI_Controls.Header_Title
			; GuiControl, Trades: +c%colorTitleInactive%,% TradesGUI_Controls.Header_Minimize
			GuiControl, Trades:ChooseString,% TradesGUI_Controls["Tab"],% "No Trades On Queue"
		}

		clickThroughState := ( ProgramSettings.Trades_Click_Through && !isGuiActive )?("+"):("-")
		transparency := (!isGuiActive)?(ProgramSettings.Transparency):(ProgramSettings.Transparency_Active)
		Gui, Trades: +LastFound
		Gui, Trades: %clickThroughState%E0x20
		WinSet, Transparent,% transparency ; Using A_Gui instead of the Gui's handle fixes an issue where the transparency would not be applied with EXE_NOT_FOUND.
										   ; After testings, it creates another issue where it sets the transparency to the game's window
										   ; It seems that activating another window prior to applying the transparency allows us to use the handler.
										   ; Using +LastFound and WinSet without any specified window seems to be the most reliable way to detect the GUI handler.
		local titleText := (tabsCount)?(ProgramValues.Name " - Queued Trades: " tabsCount):(ProgramValues.Name)
		GuiControl, Trades:Text,% TradesGUI_Controls["Header_Title"],% titleText ; Update the title

; - - - - - Hide or show controls, based on tabs count
		Loop 9 {
			GuiControl, Trades:%showOrHide%,% TradesGUI_Controls["Button_Custom_" A_Index]
			GuiControl, Trades:%showOrHide%,% TradesGUI_Controls["Button_Custom_" A_Index "_Ornament_Left"]
			GuiControl, Trades:%showOrHide%,% TradesGUI_Controls["Button_Custom_" A_Index "_Ornament_Right"]

			GuiControl, Trades:%showOrHide%,% TradesGUI_Controls["Button_Unicode_" A_Index]
			GuiControl, Trades:%showOrHide%,% TradesGUI_Controls["Button_Unicode_" A_Index "_Ornament_Left"]
			GuiControl, Trades:%showOrHide%,% TradesGUI_Controls["Button_Unicode_" A_Index "_Ornament_Right"]
		}
		GuiControl, Trades:%showOrHide%,% TradesGUI_Controls["Arrow_Left"]
		GuiControl, Trades:%showOrHide%,% TradesGUI_Controls["Arrow_Right"]
		GuiControl, Trades:%showOrHide%,% TradesGUI_Controls["Close_Tab"]
		GuiControl, Trades:%showOrHide%,% TradesGUI_Controls["Tabs_Underline"]
		GuiControl, Trades:%showOrHide%,% TradesGUI_Controls["Tabs_Background"]

; - - - - - Choose latest tab, if enabled
		if ( ProgramSettings.Trades_Select_Last_Tab ) && (!A_GuiEvent) { ; A_GuiEvent means we've just closed a tab. We do not want to activate the latest available tab.
			Gui_Trades_SetActiveTab_Func(tabsCount)
		}

; - - - - - Increase tabs limit
		if (tabsCount >= maxTabsRendered-1 && maxTabsRendered != maxTabsStage5) { ;	Tabs limit almost reached.
			currentTabsLimit := maxTabsRendered
			maxTabsRendered := (maxTabsRendered=maxTabsStage1)?(maxTabsStage2)
							  :(maxTabsRendered=maxTabsStage2)?(maxTabsStage3)
							  :(maxTabsRendered=maxTabsStage3)?(maxTabsStage4)
							  :(maxTabsRendered=maxTabsStage4)?(maxTabsStage5)
							  :(maxTabsStage2)
			nextTabsLimit := maxTabsRendered

			Tray_Notifications_Show(ProgramValues.Name, "Maximal tabs limit reached (" currentTabsLimit-1 ").`nRendering more tabs... (" nextTabsLimit-1 ")")
			currentTabsLimit := "", nextTabsLimit := ""
			previousTabID := Gui_Trades_Get_Tab_ID()
			Gui_Trades_Redraw("CREATE", {noSplash:1})
			Gui_Trades_SetActiveTab_Func(previousTabID)
		}
; - - - - - Reset tabs limit
		if (tabsCount=0 && maxTabsRendered>maxTabsStage1) && (mode!="CREATE") { ; Tabs limit higher than default, and no tab on queue. We can reset to default limit.
			Tray_Notifications_Show(ProgramValues.Name, "All tabs were closed.`nReverting to the default tabs limit... (" maxTabsStage1-1 ")")
			maxTabsRendered := maxTabsStage1
			Gui_Trades_Redraw("CREATE", {noSplash:1})
		}

; - - - - - Select newly added tab
		if ( ProgramSettings.Trades_Select_Last_Tab ) && ( tabsCountIncreased ) {
			Gui_Trades_SetActiveTab_Func(tabsCount)
		}

; - - - - - Auto (un)minimize & clipboard
		if ( ProgramSettings.Trades_Auto_Minimize && !isGuiActive && !TradesGUI_Values.Is_Minimized && mode != "EXE_NOT_FOUND" ) {
			GoSub, Gui_Trades_Minimize
		}
		if ( ProgramSettings.Trades_Auto_UnMinimize && isGuiActive && TradesGUI_Values.Is_Minimized ) {
			GoSub, Gui_Trades_Minimize
		}
		if ( ProgramSettings.Clip_On_Tab_Switch ) {
			Gui_Trades_Clipboard_Item_Func()
		}

	}

; - - - - - Show the GUI
	if ( mode = "CREATE" ) {
		showWidth := guiWidth
		showHeight := guiHeight
		IniRead, showX,% ProgramValues.Ini_File,PROGRAM,X_POS
		IniRead, showY,% ProgramValues.Ini_File,PROGRAM,Y_POS
		showXDefault := A_ScreenWidth-(showWidth), showYDefault := 0 ; Top right
		showX := (IsNum(showX))?(showX):(showXDefault) ; Prevent unassigned or incorrect value
		showY := (IsNum(showY))?(showY):(showYDefault) ; Prevent unassigned or incorrect value
		SystemParametersInfo(False)
		Gui, Trades:Show,% "NoActivate w" showWidth " h" showHeight " x" showX " y" showY
		GuiControl, Trades:ChooseString,% TradesGUI_Controls["Tab"],% "|No Trades On Queue"
		if (ProgramSettings.Trades_Auto_Minimize)
			Gui_Trades_Minimize_Func("MIN", 1)
		OnMessage(0x200, "WM_MOUSEMOVE")
		OnMessage(0x201, "WM_LBUTTONDOWN")
		OnMessage(0x203, "WM_LBUTTONDBLCLK")
		OnMessage(0x204, "WM_RBUTTONDOWN")

		dpiFactor := ProgramSettings.Screen_DPI, showX := guiWidth-49

		TradesGUI_Values.Created := true
	}

; - - - - - Adjust position, with Overlay mode
	if ( ProgramSettings.Trades_GUI_Mode = "Overlay") {
		try	Gui_Trades_Set_Position()
	}

	Gui, Trades: +LastFound
	WinSet, Redraw
	WinSet, AlwaysOnTop, On
	IniWrite,% tabsCount,% ProgramValues.Ini_File,PROGRAM,Tabs_Number

	previousTabsCount := tabsCount
	Sleep 10
	return

	Gui_Trades_Close_Tab_Label:
		Gui_Trades_Close_Tab()
	Return

	Gui_Trades_SetActiveTab:
		Gui, Trades:Submit, NoHide
		RegExMatch(A_GuiControl, "\d+", tabID)
		Gui_Trades_SetActiveTab_Func(tabID)

		tabID := ""
	return

	Gui_Trades_OnTabSwitch:
;		Clipboard the item's infos on tab switch if the user enabled
		Gui, Trades:Submit, NoHide

		TradesGUI_Values.Active_Tab := Gui_Trades_Get_Tab_ID()
		if ( ProgramSettings.Clip_On_Tab_Switch )
			Gui_Trades_Clipboard_Item_Func()
	return

	Gui_Trades_Minimize:
;		Switch between minimized and full-sized.
		Gui_Trades_Minimize_Func()
	Return

	Gui_Trades_Move:
;		Allows dragging the GUI when holding left click on the title bar.
		if ( ProgramSettings.Trades_GUI_Mode = "Window" ) {
			PostMessage, 0xA1, 2,,,% "ahk_id " TradesGUI_Values.Handler
		}
		KeyWait, LButton, Up
		Gui_Trades_Save_Position()
		Gui_Trades_RemoveButtonFocus()
	Return 

	Gui_Trades_Size:
;		Declare the global GUI width and height
		TradesGUI_Values.Width := A_GuiWidth
		TradesGUI_Values.Height := A_GuiHeight

		GuiControl, Trades:Move,% TradesGUI_Controls.Border_Bottom,% "y" A_GuiHeight-borderSize ; Bottom border
	return

	Gui_Trades_Close:
	Return
	Gui_Trades_Escape:
	Return
}

SystemParametersInfo(toggle := 0)                               ; https://msdn.microsoft.com/en-us/library/ms724947(v=vs.85).aspx
{
    static SPI_SETCLIENTAREAANIMATION := 0x1043
    if !(DllCall("user32\SystemParametersInfo", "uint", SPI_SETCLIENTAREAANIMATION, "uint", 0, "int", toggle, "uint", 0))
        throw Exception("SystemParametersInfo failed: " A_LastError, -1)
    return true
}

Gui_Trades_SetActiveTab_Func(tabID) {
/*		Allows selecting a specific tab
		Moving into its range
*/
	global TradesGUI_Controls, TradesGUI_Values, ProgramSettings

;	Choosing the tab
	GuiControl, Trades:ChooseString,% TradesGUI_Controls["Tab"],% "|" tabID
	Loop % TradesGUI_Values.Max_Tabs_Rendered {
		if (tabID = A_Index) {
			GuiControl, Trades:Disable,% TradesGUI_Controls["Tab_" A_Index] ; Disable will highlight the tab
		}
		else {
			GuiControl, Trades:Enable,% TradesGUI_Controls["TabJoined_" A_Index]
			GuiControl, Trades:Enable,% TradesGUI_Controls["TabMsg_" A_Index]
			GuiControl, Trades:Enable,% TradesGUI_Controls["TabDefault_" A_Index]
		}
	}

;	Putting the tab in range
	tabsRange := Gui_Trades_Get_Tabs_Range()
	if (tabsRange.First && tabsRange.Last) {
		While !( IsBetween(tabID, tabsRange.First, tabsRange.Last) ) {
			if (tabID > tabsRange.Last) {
				Gui_Trades_Arrow_Right()
			}
			else if (tabID < tabsRange.First) {
				Gui_Trades_Arrow_Left()
			}
			tabsRange := Gui_Trades_Get_Tabs_Range()
		}
	}

;	Clipboard the item
	TradesGUI_Values.Active_Tab := tabID
	if ( ProgramSettings.Clip_On_Tab_Switch ) {
		Gui_Trades_Clipboard_Item_Func()
	}

}

Gui_Trades_Adjust_Tabs() {
/*		Hide or show controls, based on tabs count
*/
	global TradesGUI_Values, TradesGUI_Controls

	maxTabsRow 		:= TradesGUI_Values.Max_Tabs_Per_Row
	tabsCount 		:= TradesGUI_Values.Tabs_Count
	tabsRange 		:= Gui_Trades_Get_Tabs_Range()

	if (tabsRange.First > 1)
		Return ; We do not want to show or hide tabs, if we are not on the start of the row
		
	Loop % maxTabsRow {
		if (IsBetween(A_Index, 1, tabsCount)) { ; Show tabs with a value between maxTabsRow and tabsCount
			GuiControl, Trades:Show,% TradesGUI_Controls["Tab_" A_Index]
		}
		else { ; Hide tabs higher than tabsCount
			GuiControl, Trades:Hide,% TradesGUI_Controls["Tab_" A_Index]
		}
	}
}

Gui_Trades_Close_Tab(tabID="") {
/*		Close the currently active tab, or a specified one
*/
	global TradesGUI_Values, ProgramSettings, DebugValues

	static debugIndex

	currentTabsCount 	:= TradesGUI_Values.Tabs_Count
	currentActiveTab 	:= Gui_Trades_Get_Tab_ID()
	tabsRange			:= Gui_Trades_Get_Tabs_Range()
	tabToClose 			:= (tabID)?(tabID):(TradesGUI_Values.Active_Tab)

	isNotInFirstRow := (tabsRange.Last = currentTabsCount)
	
	if (isNotInFirstRow) { ; Hide the tab, before removing it
		Gui_Trades_Arrow_Left()
	}
	tradesMessages := Gui_Trades_Manage_Trades("REMOVE_CURRENT", ,tabToClose)

/*	__TO_BE_FIXED__
 *	If you receive a new trading whisper at this very moment, it will not be added to the list
 *		until the GUI is updated again (by closing a tab, or receiving a new trading whisper)
 *	The reason behind this is very simple: though the whisper is successfully added to the list,
 *		"tradesMessages" does NOT contain it as it was created BEFORE receiving the whisper
 *	
 */
	if (DebugValues.settings.simulate_new_trade_while_tab_close) {
		debugIndex++
		Filter_Logs_Message("2016/10/09 21:44:07 105384166 355 [INFO Client 6416] @From ss3y" debugIndex ": wtb se2hqh (12/0%) listed for hyhgr2p2 in Hardcore")
	}

	Gui_Trades("UPDATE", tradesMessages)
	if (currentActiveTab = currentTabsCount) {
		Gui_Trades_SetActiveTab_Func(currentActiveTab-1)
	}
}

Tile_Picture(guiName, TilehWnd, desiredW, desiredH) {	
/*		Credits: dmatch - autohotkey.com/board/topic/24542-tiled-gui-background/?p=159043
		Allows to tile a picture to the defined sizes.
		
		Usage:
		Gui, Example:Add, Picture,x0 y0 hWndhTile,% pathToYourPicture
		Tile_Picture("Example", hTile, 500, 300)
*/
	global ProgramSettings
	
	picturePos := Get_Control_Coords(guiName, TileHwnd) ; Get size of the picture
	w := picturePos.W,    h := picturePos.H

	dpiFactor := ProgramSettings.Screen_DPI ; Size has to be multiplied by the current DPI setting
	desiredW := desiredW*dpiFactor, desiredH := desiredH*dpiFactor

	SendMessage,0x173,0,0,,ahk_id %TilehWnd% ; 0x173 is STM_GETIMAGE
	hBMCopy:=ErrorLevel
	
	hBM:=DllCall("CopyImage",uint,hBMCopy,uint,0,int,0,int,0,uint,0x2000) ; Get a copy of the picture
	hDC:=DllCall("GetDC",uint,TilehWnd,uint) ; Get device context for picture
	hCDC:=DllCall("CreateCompatibleDC",uint,hDC,uint) ; Create compatible device context to put picture in
	DllCall("SelectObject",uint,hCDC,uint,hBM) ; Put the picture in the CDC
	hCDC2:=DllCall("CreateCompatibleDC",uint,hDC,uint) ; Create compatible device context to hold tiled image
	hBM2:=DllCall("CreateCompatibleBitmap",uint,hDC,int,desiredW,int,desiredH,uint) ; Create an empty bitmap to trap the tiled image in
	DllCall("SelectObject",uint,hCDC2,uint,hBM2) ; Put the empty image in so can draw on it
	
	x := -1 * w,    y := 0
	
	Loop {
		x += w
		if (x >= desiredW) {
			x:=0,    y+=h
			if (y >= desiredH) {
				break
			}
		}
		DllCall("BitBlt",uint,hCDC2,int,x,int,y,int,w,int,h,uint,hCDC,int,0,int,0,uint,0xcc0020) ; Build the tiled image in the compatible heretofore empty bitmap
	}
	
	; Cleanup
	DllCall("ReleaseDC",uint,TilehWnd,uint,hDC)
	DllCall("DeleteObject",uint,hCDC)
	DllCall("DeleteObject",uint,hCDC2)
	DllCall("DeleteObject",uint,hBM)
	
	; Apply the tiled image to the original picture
	SendMessage, 0x172, 0, hBM2,, ahk_id %TilehWnd% ; 0x172 is STM_SETIMAGE message	
	if (ErrorLevel && hBM2 <> ErrorLevel) {
		DllCall("DeleteObject",uint,errorlevel)
	}
}

Gui_Trades_Load_Pending_Backup() {
/*		Read the backup file, and send those trades requests to the Trades GUI
 */
	global ProgramValues

	tempTrades := {}
	IniRead, allKeys,% ProgramValues.Trades_Backup_File,GENERAL
	IniRead, maxIndex,% ProgramValues.Trades_Backup_File,GENERAL,Max_Index, 0

;	Make sure the MaxIndex value is an actual trade
	IniRead, value,% ProgramValues.Trades_Backup_File,GENERAL,% maxIndex "_Buyer", 0
	while (!value && maxIndex) { 
		maxIndex--
		IniRead, value,% ProgramValues.Trades_Backup_File,GENERAL,% maxIndex "_Buyer", 0
	}

;	Parse the keys, retrieve all trade infos
	Loop, Parse, allKeys,% "`n`r"
	{
		keyAndValue := A_LoopField
		if RegExMatch(keyAndValue, "(.*)=(.*)", found) {
			keyName := found1, value := found2
			tempTrades.Insert(found1, found2)
			found1 := "", found2 := ""
		}
	}

;	Add each trade to the GUI
	Loop % maxIndex {
		outterIndex := A_Index
		thisTrade := {}
		for key, value in tempTrades {
			if RegExMatch(key, outterIndex "_(.*)", found) {
				thisTrade.Insert(found1, value)
				found1 := ""
			}
		}
		messagesArray := Gui_Trades_Manage_Trades("ADD_NEW", thisTrade)
		Gui_Trades("UPDATE", messagesArray)
	}

	if (ProgramValues.Keep_Backup)
		Return
	
	FileDelete,% ProgramValues.Trades_Backup_File
}

Trades_GUI_Exists() {
/*		Returns the handler of the Trades GUI if a match is found.
 */
	global TradesGUI_Values
	return WinExist("ahk_id " TradesGUI_Values.Handler)
}

Gui_Trades_Minimize_Func(state="", skipAnimation="") {
	global TradesGUI_Values, TradesGUI_Controls

	detectHiddenWin := A_DetectHiddenWindows
	DetectHiddenWindows, On

	guiHeight := TradesGUI_Values.Height_Full
	guiHeightMin := TradesGUI_Values.Height_Minimized

	if !Trades_GUI_Exists()
		Return

	if (skipAnimation) {
		height := (state="FULL")?(guiHeight)
				 :(state="MIN")?(guiHeightMin)
				 :("ERROR")
		if (height="ERROR")
			Return
		TradesGUI_Values.Is_Minimized := (state="FULL")?(0)
										:(state="MIN")?(1)
										:("ERROR")
		Gui_Trades_Set_Height(height)
	}
	else {
		TradesGUI_Values.Is_Minimized := !TradesGUI_Values.Is_Minimized
		SetTimer, Gui_Trades_Minimize_Animation, -10
	}

	if (TradesGUI_Values.Is_Minimized) {
		GuiControl,Trades:Show,% TradesGUI_Controls["Header_Maximize"]
		GuiControl,Trades:Hide,% TradesGUI_Controls["Header_Minimize"]
	}
	else {
		GuiControl,Trades:Show,% TradesGUI_Controls["Header_Minimize"]
		GuiControl,Trades:Hide,% TradesGUI_Controls["Header_Maximize"]		
	}
	Gui_Trades_RemoveButtonFocus()
	
	Sleep 10
	DetectHiddenWindows, %detectHiddenWin%
}

Gui_Trades_RemoveButtonFocus() {
	global TradesGUI_Values
	ControlFocus,,% "ahk_id " TradesGUI_Values.Handler ; Remove focus
}

Gui_Trades_Minimize_Animation() {
	global TradesGUI_Values
	static tHeight, doingAnimation

	guiHeight := TradesGUI_Values.Height_Full
	guiHeightMin := TradesGUI_Values.Height_Minimized
	animationStep := 36

	doingAnimation := (!doingAnimation)?(true):(doingAnimation)

	if (TradesGUI_Values.Is_Minimized) {
		tHeight := (guiHeightMin<tHeight)?(tHeight-animationStep):(guiHeightMin)
		tHeight := (tHeight-animationStep<guiHeightMin)?(guiHeightMin):(tHeight)

		Gui_Trades_Set_Height(tHeight)
		if (tHeight = guiHeightMin) {
			SetTimer,% A_ThisFunc, Delete
			doingAnimation := false
		}
	}
	else {
		tHeight := (guiHeight>tHeight)?(tHeight+animationStep):(guiHeight)
		tHeight := (tHeight+animationStep>guiHeight)?(guiHeight):(tHeight)

		Gui_Trades_Set_Height(tHeight)
		if (tHeight = guiHeight) {
			SetTimer,% A_ThisFunc, Delete
			doingAnimation := false
		}
	}
	if (doingAnimation) {
		SetTimer,% A_ThisFunc, -1
	}
}

Gui_Trades_Adjust_Tab_Range() {
/*		Clicks on the left/right arrows based
		on the difference between active tab and tab range
*/
	global TradesGUI_Values, TradesGUI_Controls

	activeTab := TradesGUI_Values.Active_Tab
	tabRange := Gui_Trades_Get_Tabs_Images_Range()

	firstID := tabRange.First_Tab
	lastID := tabRange.Last_Tab

	isLowerThanFirst := (activeTab < firstID)?(1):(0)
	isGreaterThanLast := (activeTab > lastID)?(1):(0)

	if (isGreaterThanLast || isLowerThanFirst) {
		diff := (isGreaterThanLast)?(activeTab-lastID)
			   :(isLowerThanFirst)?(firstID-activeTab)
			   :(0)
		Loop %diff% {
			if (isGreaterThanLast)
				Gui_Trades_Arrow_Right()
			else if (isLowerThanFirst)
				Gui_Trades_Arrow_Left(7)
		}
	}
}


Gui_Trades_Select_Tab(params="") {
/*		Allows the use of an hotkey to select the next or previous tab
*/
	global TradesGUI_Controls, TradesGUI_Values, ProgramSettings

	currentTabID := TradesGUI_Values.Active_Tab
	tabsCount := TradesGUI_Values.Tabs_Count
	tabCtrl := TradesGUI_Controls.Tab

	chooseNext := params.Choose_Next
	choosePrev := params.Choose_Prev
	chooseID := params.Choose_ID

	selectTabID := (chooseNext)?(currentTabID+1)
				  :(choosePrev)?(currentTabID-1)
				  :(chooseID)?(chooseID)
				  :("ERROR")

	if !(IsNum(selectTabID)) {
		selectAction := (chooseNext)?("Choose_Next")
					   :(choosePrev)?("Choose_Prev")
					   :(chooseID)?("Choose_ID")
					   :("UNKNOWN")
		Logs_Append(A_ThisFunc, {Tab_ID:selectTabID
								,Action:selectAction})
		Return
	}
	if IsBetween(selectTabID,1,tabsCount)
		Gui_Trades_SetActiveTab_Func(selectTabID)
}


Gui_Trades_Set_Height(desiredHeight) {
/*		Move the bottom border and set the GUI height
*/
	global TradesGUI_Controls, TradesGUI_Values, ProgramSettings

	dpiFactor := ProgramSettings.Screen_DPI
	; tabHeight := Gui_Trades_Get_Tab_Height()
	guiHeightMin := TradesGUI_Values.Height_Minimized
	guiHeightFull := TradesGUI_Values.Height_Full
	scaleMult := ProgramSettings.Scale_Multiplier

	winDelay := A_WinDelay
	SetWinDelay, -1	; Fix the slow animation issue with using compiled
	WinMove,% "ahk_id " TradesGUI_Values.Handler, , , , ,% desiredHeight*dpiFactor
	SetWinDelay, %winDelay%
}

Gui_Trades_Get_Tabs_Range() {
	global TradesGUI_Controls, TradesGUI_Values

	maxTabsPerRow 		:= TradesGUI_Values.Max_Tabs_Per_Row
	currentTabsCount 	:= TradesGUI_Values.Tabs_Count

	Loop %currentTabsCount% { ; Retrieve current shown tabs
		GuiControlGet, isVisible, Trades:Visible,% TradesGUI_Controls["Tab_" A_Index]
		firstVisible := (isVisible && !firstVisible)?(A_Index):(firstVisible) ; First visible = first tab returning "1"
		lastVisible := (!isVisible && firstVisible && !lastVisible)?(wasPreviousVisible):(lastVisible) ; Last visible = last tab returning "1"
		wasPreviousVisible := (isVisible)?(A_Index):(wasPreviousVisible)
	}
	lastVisible := (lastVisible)?(lastVisible):(wasPreviousVisible) ; Last visible = max tabs count

	return {First:firstVisible, Last:lastVisible}
}

Gui_Trades_Arrow_Left(val="") {
/*		Simulate scrolling through the tabs by:
		- Retrieving the first and last tab of the row, based on their Visible/Hidden state.
		- Remove one from these values, since we are moving left.
		- Showing the new "first tab of the row", and moving to the left subsequent tabs.
		- And finally hidding what was previously the "latest tab of the row"
*/
	global TradesGUI_Values, TradesGUI_Controls

	maxTabsPerRow 		:= TradesGUI_Values.Max_Tabs_Per_Row

	tabsRange := Gui_Trades_Get_Tabs_Range()
	firstVisible := tabsRange.First, lastVisible := tabsRange.Last

	if (firstVisible = 1) ; Cannot go left anymore
		Return

	newFirstVisible 	:= firstVisible-1 ; We're going left. Next first tab will be current minus one
	newLastVisible 		:= lastVisible-1

	tabMoving := newFirstVisible
	index := 1 ; Index is equal to first tab slot
	While (tabMoving != lastVisible) { ; As long as we have not moved all tabs
		if (A_Index=1) {
			GuiControl, Trades:Show,% TradesGUI_Controls["Tab_" newFirstVisible] ; New first tab has to be shown
		}
		tabSlotCoords := Get_Control_Coords("Trades", TradesGUI_Controls["Tab_Slot_" index]) ; Get the tab slot coords
		; Move each style of tab with default
		GuiControl, Trades:Move,% TradesGUI_Controls["TabDefault_" tabMoving],% "x" tabSlotCoords.X " y" tabSlotCoords.Y
		GuiControl, Trades:Move,% TradesGUI_Controls["TabMsg_" tabMoving],% "x" tabSlotCoords.X " y" tabSlotCoords.Y
		GuiControl, Trades:Move,% TradesGUI_Controls["TabJoined_" tabMoving],% "x" tabSlotCoords.X " y" tabSlotCoords.Y
		index++, tabMoving++ ; Move onto the next tab
	}
	GuiControl, Trades:Hide,% TradesGUI_Controls["Tab_" tabMoving] ; Hide the previously latest tab
}

Gui_Trades_Arrow_Right(goFar=0) {
/*		See Gui_Trades_Arrow_Left() for more informations
*/
	global TradesGUI_Values, TradesGUI_Controls

	maxTabsPerRow 		:= TradesGUI_Values.Max_Tabs_Per_Row

	tabsRange := Gui_Trades_Get_Tabs_Range()
	firstVisible := tabsRange.First, lastVisible := tabsRange.Last

	if (lastVisible = TradesGUI_Values.Tabs_Count) ; Cannot go right anymore
		Return

	newFirstVisible 	:= firstVisible+1 ; We're going right. Next first tab will be current plus one
	newLastVisible 		:= lastVisible+1

	tabMoving := newLastVisible
	index := maxTabsPerRow ; Index is equal to max tabs per row
	While (tabMoving != firstVisible) {
		if (A_Index=1) {
			GuiControl, Trades:Show,% TradesGUI_Controls["Tab_" newLastVisible] ; New last tab has to be shown
		}
		tabSlotCoords := Get_Control_Coords("Trades", TradesGUI_Controls["Tab_Slot_" index])
		; Move each style of tab with default
		GuiControl, Trades:Move,% TradesGUI_Controls["TabDefault_" tabMoving],% "x" tabSlotCoords.X " y" tabSlotCoords.Y
		GuiControl, Trades:Move,% TradesGUI_Controls["TabMsg_" tabMoving],% "x" tabSlotCoords.X " y" tabSlotCoords.Y
		GuiControl, Trades:Move,% TradesGUI_Controls["TabJoined_" tabMoving],% "x" tabSlotCoords.X " y" tabSlotCoords.Y
		index--, tabMoving--
	}
	GuiControl, Trades:Hide,% TradesGUI_Controls["Tab_" tabMoving] ; Hide the previously first tab
}

Gui_TradeS_Get_Tabs_Images_Range() {
	global TradesGUI_Values, TradesGUI_Controls, ProgramSettings, ProgramValues

	GuiControlGet, lastTab, Trades:,% TradesGUI_Controls["Tab_TXT_" TradesGUI_Values.Max_Tabs_Per_Row]
	GuiControlGet, firstTab, Trades:,% TradesGUI_Controls["Tab_TXT_1"]

	return {Last_Tab:lastTab,First_Tab:firstTab}
}

Gui_Trades_Set_Tab_Images_State(arrow="") {
	global TradesGUI_Values, TradesGUI_Controls, ProgramSettings, ProgramValues

	previousID := TradesGUI_Values.Previous_Active_Tab
	currentID := TradesGUI_Values.Active_Tab
	previousID := (previousID="")?(1):(previousID)

	tabsRange := Gui_TradeS_Get_Tabs_Images_Range()

	activeTabID := (arrow="LEFT")?(TradesGUI_Values.Active_Tab-tabsRange.First_Tab+1) ; Left arrow pressed
				  :(arrow="RIGHT")?(TradesGUI_Values.Active_Tab-tabsRange.First_Tab+1) ; Right arrow pressed
				  :(TradesGUI_Values.Tabs_Count_Reduced && TradesGUI_Values.Active_Tab > TradesGUI_Values.Max_Tabs_Per_Row)?(TradesGUI_Values.Active_Tab-tabsRange.First_Tab+1) ; 
				  :(currentID-tabsRange.First_Tab+1)
	inactiveTabID := (arrow="LEFT")?(TradesGUI_Values.Active_Tab-tabsRange.First_Tab)
					:(arrow="RIGHT")?(TradesGUI_Values.Active_Tab-(tabsRange.First_Tab)+2)
					:(TradesGUI_Values.Tabs_Count_Reduced)?(activeTabID+1)
					:(previousID-tabsRange.First_Tab+1)
	
	; tooltip % activeTabID "`n" inactiveTabID "`n" TradesGUI_Values.Active_Tab "`n" TradesGUI_Values.Previous_Active_Tab "`n" tabsRange.First_Tab "`n" TradesGUI_Values.Tabs_Count_Reduced "`n" A_GuiControl

	if (inactiveTabID > 0) ; Prevents from using a negative TabID due to the users selecting a tab, then moving with the arrows and selecting a new tab while the old one is out of range 
		GuiControl, Trades:,% TradesGUI_Controls["Tab_IMG_" inactiveTabID],% ProgramValues.Skins_Folder "\" ProgramSettings.Active_Skin "\TabInactive.png"
	if (activeTabID > 0)
		GuiControl, Trades:,% TradesGUI_Controls["Tab_IMG_" activeTabID],% ProgramValues.Skins_Folder "\" ProgramSettings.Active_Skin "\TabActive.png"

	if ( (TradesGUI_Values.Tabs_Count_Reduced && TradesGUI_Values.Active_Tab = TradesGUI_Values.Tabs_Count) || (TradesGUI_Values.Tabs_Count_Reduced && tabsRange.Last_Tab >= TradesGUI_Values.Tabs_Count) ) {
;		Highest tab deleted while active - Or tab deleted while fully (or minus one) scrolled to the right
		TradesGUI_Values.Tabs_Count_Reduced := 0
		Gui_Trades_Arrow_Left() ; Hide the tab that has been removed
		Gui_Trades_Arrow_Right() ; Stay in the same tabs range
	}
	TradesGUI_Values.Tabs_Count_Reduced := 0
	; else if (TradesGUI_Values.Tabs_Count_Reduced && tabsRange.Last_Tab = tabsCount) { 
		; TradesGUI_Values.Tabs_Count_Reduced := 0
	; }

}

Gui_Trades_Show_Tab_Content(showTabID="") {
	global TradesGUI_Values, TradesGUI_Controls, ProgramSettings, ProgramValues

	previousID := TradesGUI_Values.Previous_Active_Tab
	currentID := TradesGUI_Values.Active_Tab
	previousID := (previousID="")?(1):(previousID)

	showTabID := (showTabID)?(showTabID):(currentID)

;	Hide previous tab, show current tab
	Loop 2 {
		showState := (A_Index=1)?("Hide"):("Show")
		tabID := (A_Index=1)?(previousID):(showTabID)

		GuiControl, Trades:%showState%,% TradesGUI_Controls["Buyer_Slot_" tabID]
		GuiControl, Trades:%showState%,% TradesGUI_Controls["Item_Slot_" tabID]
		GuiControl, Trades:%showState%,% TradesGUI_Controls["Price_Slot_" tabID]
		GuiControl, Trades:%showState%,% TradesGUI_Controls["Location_Slot_" tabID]
		GuiControl, Trades:%showState%,% TradesGUI_Controls["Time_Slot_" tabID]
		GuiControl, Trades:%showState%,% TradesGUI_Controls["Other_Slot_" tabID]
	}

	TradesGUI_Values.Active_Tab := showTabID
	Gui_Trades_Set_Tab_Images_State()
	TradesGUI_Values.Previous_Active_Tab := showTabID
	Gui_Trades_Adjust_Tab_Range()
}

Gui_Trades_Do_Action_Func(CtrlHwnd, GuiEvent, EventInfo) {
	global TradesGUI_Values, ProgramSettings, TradesGUI_Controls, ProgramValues

	Thread, NoTimers

	if ( TradesGUI_Values.Cancel_Action ) {
		TradesGUI_Values.Cancel_Action := 0
		Return
	}

	if ( !TradesGUI_Values.Active_Tab || !TradesGUI_Values.Tabs_Count ) { ; User most likely used an hotkey while tabs count was 0
		Return
	}

	for keyName, ctrlHandler in TradesGUI_Controls {
		if (ctrlHandler = CtrlHwnd) {
			thisButton := keyName, 
			RegExMatch(thisButton, "\d+", btnID)
			btnAction := TradesGUI_Controls[thisButton "_Action"]
		}
	}

	if (!btnAction || btnAction = "ERROR") {
		Tray_Notifications_Show(ProgramValue.Name, "No action found for this button."
											.	"`nPlease report this issue including your logs files located in"
											.	"`n" ProgramValues.Logs_Folder)
		Logs_Append(A_ThisFunc, {Button:thisButton, Action:btnAction, Handler:CtrlHwnd})
		Return
	}

	messages := Object()
	tabInfos := Gui_Trades_Get_Trades_Infos(TradesGUI_Values.Active_Tab)
	if (!tabInfos.Buyer && btnAction != "Close_Tab") {
		Tray_Notifications_Show(ProgramValues.Name, "No buyer found for tab """ TradesGUI_Values.Active_Tab " - Count:""" TradesGUI_Values.Tabs_Count """`nOperation cancelled. Please report this issue.")
		Return
	}

	if btnAction contains Send_Message,Write_Message
	{
		if btnAction contains Write_Message
		{
			messages.Push(ProgramSettings["Button" btnID "_Message_1"])
			doNotSend := true
		}
		else {
			messages.Push(ProgramSettings["Button" btnID "_Message_1"], ProgramSettings["Button" btnID "_Message_2"], ProgramSettings["Button" btnID "_Message_3"])
			doNotSend := false
		}
		errorLvl := Send_InGame_Message(messages, tabInfos, {doNotSend:doNotSend})
		if (errorLvl)
			Return
	}

	if btnAction contains Close_Tab
	{
		if (RegExMatch(btnAction,"Send_Message"))  {
			if (ProgramSettings["Button" btnID "_Mark_Completed"]) {
				Gui_Trades_Statistics("ADD", tabInfos)
			}
			if (ProgramSettings.Support_Text_Toggle) {
				tabInfos := Gui_Trades_Get_Trades_Infos(TradesGUI_Values.Active_Tab) ; Retrieve the new PID in case it changed
				Send_InGame_Message({1:ProgramSettings.Support_Message}, tabInfos)
			}
		}
		Gui_Trades_Close_Tab()
	}
	if btnAction contains Minimize
	{
		if (RegExMatch(btnAction,"Send_Message"))
			if !(TradesGUI_Values.Is_Minimized)
				Gui_Trades_Minimize_Func("MIN")
	}
	else if btnAction in Clipboard_Item,Clipboard,Whisper,Trade,Invite,Kick
	{
		if (btnAction="Clipboard" || btnAction="Clipboard_Item") {
			Gui_Trades_Clipboard_Item_Func()
		}
		else {
			msg := (btnAction="Whisper")?("@%buyerName% ")
				  :(btnAction="Trade")?("/tradewith %buyerName%")
				  :(btnAction="Invite")?("/invite %buyerName%")
				  :(btnAction="Kick")?("/kick %buyerName%")
				  :("ERROR")
			doNotSend := (btnAction="Whisper")?(true):(false)
			Send_InGame_Message({1:msg}, tabInfos, {doNotSend:doNotSend})
		}
	}
	Gui_Trades_RemoveButtonFocus()

}

Gui_Trades_Clipboard_Item_Func(tabID="NONE") {
/*		Retrieve the specified tab's item.
		Change the clipboard content with a precise item search.
*/
	global TradesGUI_Values

	tabID := (tabID="NONE")?(TradesGUI_Values.Active_Tab):(tabID)

	tabInfos := Gui_Trades_Get_Trades_Infos(tabID)
	item := tabInfos.Item
	RegExMatch(item, "(.*?) \(Lvl:(.*?) \/ Qual:(.*?)%\)", itemPat)
	clipContent := (itemPat1 && itemPat2 && itemPat3)?("""" itemPat1 """" . A_Space . """Level: " itemPat2 """" . A_Space . """Quality: +" itemPat3 "%""")
				  :(itemPat1 && itemPat2 && !itemPat3)?("""" itemPat1 """" . A_Space . """Level: " itemPat2 """")
				  :(itemPat4)?(itemPat4)
				  :(item)
	if (clipContent)
		Clipboard := clipContent
}

Gui_Trades_Redraw(msg, params="") {
/*		Retrieve the current pending trades
		Re-create the Trades GUI
		Add the pending trades back to the GUI
*/
	global ProgramValues

	Gui_Trades_Save_Position()
	if ( !params.noSplash )
		SplashTextOn, 300, 20,% ProgramValues.Name,% "Re-drawing the interface..."
	allTrades := Gui_Trades_Manage_Trades("GET_ALL")
	if ( params.preview ) {
		if !(allTrades.Max_Index) {
			allTrades.1_Buyer 		:= "iSellStuff"
			allTrades.1_Item		:= "level 1 Faster Attacks Support"
			allTrades.1_Price		:= "5 alteration"
			allTrades.1_Location	:= "Breach (stash tab ""Gems""; position: left 6, top 8)"
			allTrades.1_Other		:= "Offering 1 alch?"
			allTrades.1_Time		:= A_Hour ":" A_Min
			allTrades.1_PID			:= 0
			allTrades.1_Date		:= A_YYYY "-" A_MM "-" A_DD
			allTrades.1_Guild		:= ""
			allTrades.Max_Index 	:= 1
		}
	}
	Load_Skin_Assets()
	Gui_Trades(msg)
	Gui_Trades("UPDATE", allTrades)
	SplashTextOff
	if ( params.preview )
		Gui_Trades_SetActiveTab_Func(1)
}

Gui_Trades_Get_Tab_ID() {
/*		Only used when no skin is applied.
 *		Returns the currently active tab ID.
*/
	global TradesGUI_Controls

	Gui, Trades:Submit, NoHide
	GuiControlGet, activeTabID, Trades:,% TradesGUI_Controls.Tab
	return activeTabID
}

Gui_Trades_Check_Duplicate(currentActiveTab) {
/*			Create a list containing all the duplicates tab ID
 *			Sort them in reverse, and returns
*/
	duplicates := currentActiveTab
	messagesArray := Gui_Trades_Manage_Trades("GET_ALL")
	maxIndex := messagesArray.Max_Index
	currentTabInfos := Gui_Trades_Get_Trades_Infos(currentActiveTab)
	arrayKey := 1
	Loop %maxIndex% {
		if (A_Index != currentActiveTab) {
			otherTabInfos := Gui_Trades_Get_Trades_Infos(A_Index)
			if (otherTabInfos.Item = currentTabInfos.Item && otherTabInfos.Price = currentTabInfos.Price && otherTabInfos.Location = currentTabInfos.Location) {
				duplicates .= "|" A_Index
				arrayKey++
			}
		}
	}
	Sort, duplicates, D| N R
	
	return duplicates
}


Gui_Trades_Get_Tab_Height() {
/*			Returns a number based on the lowest custom button to determine the GUI height
*/
	global ProgramSettings, TradesGUI_Values

	activeSkin := ProgramSettings.Active_Skin

	useSmallerButtons := TradesGUI_Values.Use_Smaller_Buttons
	sbHeightDiff := (useSmallerButtons)?(25):(0)

	tabHeightNoRow 			:= 109 + sbHeightDiff
	tabHeightOneRow 		:= 149 + sbHeightDiff
	tabHeightTwoRow 		:= 189 + sbHeightDiff
	tabHeightThreeRow 		:= 228 + sbHeightDiff
	tabHeight 				:= tabHeightNoRow

	Loop 9 {
		index := A_Index
		btnSize := ProgramSettings["Button" index "_SIZE"]
		btnVerticalPos := ProgramSettings["Button" index "_V"]
		if ( btnSize != "Disabled" ) {
			if ( btnVerticalPos = "Top"  && !isRowMiddle && !isRowBottom) {
				isRowTop := 1
			}
			else if ( btnVerticalPos = "Middle" && !isRowBottom ) {
				isRowMiddle := 1, isRowTop := 0
			}
			else if ( btnVerticalPos = "Bottom" ) {
				isRowBottom := 1, isRowTop := 0, isRowMiddle := 0
			}
		}
	}

	tabHeight := (isRowTop)?(tabHeightOneRow)
				:(isRowMiddle)?(tabHeightTwoRow)
				:(isRowBottom)?(tabHeightThreeRow)
				:(tabHeightNoRow)
	return tabHeight
}

GUI_Trades_Mode:
	Gui_Trades_Mode_Func(A_ThisMenuItem)
Return

Gui_Trades_Mode_Func(thisMenuItem) {
/*			Switch between Overlay and Window mode
*/
	global ProgramSettings, ProgramValues, TradesGUI_Values

	iniFilePath := ProgramValues.Ini_File

	if ( thisMenuItem = "Mode: Overlay") {
		Menu, Tray, UnCheck,% "Mode: Window"
		Menu, Tray, Check,% "Mode: Overlay"
		ProgramSettings.Insert("Trades_GUI_Mode", "Overlay")
		Gui_Trades_Save_Position(A_ScreenWidth-TradesGUI_Values.Width, 0)
	}
	else if ( thisMenuItem = "Mode: Window") {
		Menu, Tray, UnCheck,% "Mode: Overlay"
		Menu, Tray, Check,% "Mode: Window"
		ProgramSettings.Insert("Trades_GUI_Mode", "Window")
	}
	IniWrite,% ProgramSettings.Trades_GUI_Mode,% iniFilePath,SETTINGS,Trades_GUI_Mode
	; Gui_Trades_Redraw("CREATE", {noSplash:1})
}

Gui_Trades_Get_Trades_Infos(tabID){
/*			Returns the specified tab informations
*/
	global TradesGUI_Controls

	GuiControlGet, tabBuyer, Trades:,% TradesGUI_Controls["Buyer_Slot_" tabID]
	GuiControlGet, tabItem, Trades:,% TradesGUI_Controls["Item_Slot_" tabID]
	GuiControlGet, tabPrice, Trades:,% TradesGUI_Controls["Price_Slot_" tabID]
	GuiControlGet, tabLocation,Trades:,% TradesGUI_Controls["Location_Slot_" tabID]
	GuiControlGet, tabOther,Trades:,% TradesGUI_Controls["Other_Slot_" tabID]
	GuiControlGet, tabPID, Trades:,% TradesGUI_Controls["PID_Slot_" tabID]
	GuiControlGet, tabTime, Trades:,% TradesGUI_Controls["Time_Slot_" tabID]
	GuiControlGet, tabDate, Trades:,% TradesGUI_Controls["Date_Slot_" tabID]
	GuiControlGet, tabGuild, Trades:,% TradesGUI_Controls["Guild_Slot_" tabID]
	GuiControlGet, tabInArea, Trades:,% TradesGUI_Controls["InArea_Slot_" tabID]
	GuiControlGet, tabNewMsg, Trades:,% TradesGUI_Controls["NewMsg_Slot_" tabID]
	GuiControlGet, tabWithdrawTally, Trades:,% TradesGUI_Controls["WithdrawTally_Slot_" tabID]

	if RegExMatch(tabLocation, "(.*)\(Tab:(.*) / Pos:(.*)\)", tabLocationPat) 
		leagueName := tabLocationPat1, stashName := tabLocationPat2, stashPos := tabLocationPat3
	else
		leagueName := tabLocation

	if RegExMatch(tabItem, "(.*)\(Lvl:(.*) / Qual:(.*)\)", tabItemPat)
		itemName := tabItemPat1, itemLevel := tabItemPat2, itemQual := tabItemPat3
	else
		itemName := tabItem

	TabInfos := {Buyer:tabBuyer
				,Guild:tabGuild
				,Item:tabItem
				,Item_Name:itemName
				,Item_Level:itemLevel
				,Item_Quality:itemQual
				,Price:tabPrice
				,Location:tabLocation
				,Location_League:leagueName
				,Location_Tab:stashName
				,Location_Position:stashPos
				,Other:tabOther
				,PID:tabPID
				,Time:tabTime
				,Date_YYYYMMDD:tabDate
				,TabID:tabID
				,InArea:tabInArea
				,NewMsg:tabNewMsg
				,WithdrawTally:tabWithdrawTally}

	return tabInfos
}

Gui_Trades_Statistics(mode, tabInfos="") {
	global ProgramValues, DebugValues

	historyFile := ProgramValues.Trades_History_File

	if (mode="ADD") {
		if (DebugValues.settings.use_chat_logs || tabInfos.Buyer = "iSellStuff" )
			Return

		IniRead, index,% historyFile,% "GENERAL",% "Index"
		if !isNum(index) {
			index := 0
		}
		index++
		IniWrite,% index,% historyFile, % "GENERAL",% "Index"

		for key, element in tabInfos {
			element = %element% ; Blank spaces removal
			if ( element && element != "-" ) {
				if key in Buyer,Guild,Date_YYYYMMDD,Item,Item_Level,Item_Name,Item_Quality,Location,Location_League,Location_Position,Location_Tab,Price,Time
				{
					IniWrite,% element,% historyFile,% index,% key
				}
				else if (key="OTHER") {
					if (element && element!="-" && element !="`n") {
						Loop, Parse, element,`n
						{
							if (A_LoopField != "(Hover to see all messages)") {
								otherIndex++
								IniWrite,% A_LoopField,% historyFile,% index,% key "_" otherIndex
							}
						}
					}
				}
			}
		}
	}
	else if (mode="GET") {
		allStats := Object()
		IniRead, index,% historyFile,% "GENERAL",% "Index"
		allStats.Max_Index := index
		keys := ["Buyer","Guild","Date_YYYYMMDD","Item","Item_Level","Item_Name","Item_Quality","Location","Location_League","Location_Position","Location_Tab","Price","Time"]
		Loop %index% {
			outterIndex := A_Index
			for id, keyName in keys
			{
				IniRead, value,% historyFile,% outterIndex,% keyName
				if ( value && value != "ERROR" ) {
					allStats.Insert(outterIndex "_" keyName, value)
				}
			}
			Loop {
				keyName := "Other_" A_Index
				IniRead, value,% historyFile,% outterIndex,% keyName
				if ( value && value != "ERROR" ) {
					allStats.Insert(outterIndex "_" keyName, value)
				}
				else
					Break
			}
		}
		return allStats
	}
}

Gui_Trades_Set_Trades_Infos(setInfos){
/*			Overrides the specified tab content
*/
	global TradesGUI_Controls

	newPID := setInfos.NewPID, oldPID := setInfos.OldPID, other := setInfos.Other, tabID := setInfos.TabID
	newMsg := setInfos.NewMsg

	if ( newPID ) {
		; Replace the PID for all trades matching the same PID
		allTrades := Gui_Trades_Manage_Trades("GET_ALL")
		Loop % allTrades.Max_Index {
			if ( allTrades[A_Index "_PID"] = oldPID ) {
				GuiControl,Trades:,% TradesGUI_Controls["PID_Slot_" A_Index],% newPID
			}
		}
	}

	else if ( other ) {
		GuiControl,Trades:,% TradesGUI_Controls["Other_Slot_" tabID],% other
		GuiControl,Trades:,% TradesGUI_Controls["NewMsg_Slot_" tabID],% newMsg
	}
}

Gui_Trades_Manage_Trades(mode, newItemInfos="", activeTabID=""){
/*			GET_ALL retrieves all the currently existing tabs infos
 *			ADD_NEW add the provided infos to a new tab
 *			REMOVE_CURRENT deletes the currently active tab infos
*/
	global TradesGUI_Controls

	returnArray := Object()
	btnID := activeTabID

	actualTabsCount := 0

	if ( mode = "GET_ALL" || mode = "ADD_NEW") {
	;	___BUYERS___	
		Loop {
			bcount := A_Index
			GuiControlGet, content, Trades:,% TradesGUI_Controls["Buyer_Slot_" A_Index]
			if ( content ) {
				returnArray.Insert(A_Index "_Buyer", content)
				actualTabsCount++
			}
			else break
		}
		
	;	___ITEMS___
		Loop {
			icount := A_Index
			GuiControlGet, content, Trades:,% TradesGUI_Controls["Item_Slot_" A_Index]
			if ( content ) {
				returnArray.Insert(A_Index "_Item", content)
			}
			else break
		}
		
	;	___PRICES___
		Loop {
			pcount := A_Index
			GuiControlGet, content, Trades:,% TradesGUI_Controls["Price_Slot_" A_Index]
			if ( content ) {
				returnArray.Insert(A_Index "_Price", content)
			}
			else break
		}
		
	;	___LOCATIONS___
		Loop {
			lcount := A_Index
			GuiControlGet, content, Trades:,% TradesGUI_Controls["Location_Slot_" A_Index]
			if ( content ) {
				returnArray.Insert(A_Index "_Location", content)
			}
			else break
		}

	;	___GAMEPID___
		Loop {
			PIDCount := A_Index
			GuiControlGet, content, Trades:,% TradesGUI_Controls["PID_Slot_" A_Index]
			if ( content ) {
				returnArray.Insert(A_Index "_PID", content)
			}
			else break
		}

	;	___TIME___
		Loop {
			timeCount := A_Index
			GuiControlGet, content, Trades:,% TradesGUI_Controls["Time_Slot_" A_Index]
			if ( content ) {
				returnArray.Insert(A_Index "_Time", content)
			}
			else break
		}
	;	___OTHER___
		Loop {
			otherCount := A_Index
			GuiControlGet, content, Trades:,% TradesGUI_Controls["Other_Slot_" A_Index]
			if ( content ) {
				returnArray.Insert(A_Index "_Other", content)
			}
			else break
		}
	;	___DATE___
		Loop {
			datesCount := A_Index
			GuiControlGet, content, Trades:,% TradesGUI_Controls["Date_Slot_" A_Index]
			if ( content ) {
				returnArray.Insert(A_Index "_Date", content)
			}
			else break
		}
	;	__GUILD__
		Loop {
			guildsCount := A_Index
			GuiControlGet, content, Trades:,% TradesGUI_Controls["Guild_Slot_" A_Index]
			if ( content ) {
				returnArray.Insert(A_Index "_Guild", content)
			}
			else break
		}
	;	___InArea___
		Loop {
			inAreaCount := A_Index
			GuiControlGet, content, Trades:,% TradesGUI_Controls["InArea_Slot_" A_Index]
			if ( content != "") {
				returnArray.Insert(A_Index "_InArea", content)
			}
			else break
		}
	;	___NewMsg___
		Loop {
			newMsgCount := A_Index
			GuiControlGet, content, Trades:,% TradesGUI_Controls["NewMsg_Slot_" A_Index]
			if ( content != "" ) {
				returnArray.Insert(A_Index "_NewMsg", content)
			}
			else break
		}
	;	___WithdrawTally___
		Loop {
			withdrawTallyCount := A_Index
			GuiControlGet, content, Trades:,% TradesGUI_Controls["WithdrawTally_Slot_" A_Index]
			if ( content != "" ) {
				returnArray.Insert(A_Index "_WithdrawTally", content)
			}
			else break
		}
	
		returnArray.Insert("Max_Index", actualTabsCount)
	}

	if ( mode = "ADD_NEW") {
		returnArray.Insert(bCount "_Buyer", newItemInfos.Buyer)
		returnArray.Insert(iCount "_Item", newItemInfos.Item)
		returnArray.Insert(pCount "_Price", newItemInfos.Price)
		returnArray.Insert(lCount "_Location", newItemInfos.Location)
		returnArray.Insert(PIDCount "_PID", newItemInfos.PID)
		returnArray.Insert(timeCount "_Time", newItemInfos.Time)
		returnArray.Insert(otherCount "_Other", newItemInfos.Other)
		returnArray.Insert(datesCount "_Date", newItemInfos.Date)
		returnArray.Insert(guildsCount "_Guild", newItemInfos.Guild)
		returnArray.Insert(inAreaCount "_InArea", newItemInfos.InArea)
		returnArray.Insert(newMsgCount "_NewMsg", newItemInfos.NewMsg)
		returnArray.Insert(withdrawTallyCount "_WithdrawTally", newItemInfos.WithdrawTally)
		returnArray.Insert("Max_Index", bCount)
	}

	if ( mode = "REMOVE_CURRENT") {
	;	___BUYERS___
		Loop {
			if ( A_Index < btnID )
				counter := A_Index
			else if ( A_Index >= btnID )
				counter := A_Index+1
			GuiControlGet, content, Trades:,% TradesGUI_Controls["Buyer_Slot_" counter]
			if ( content ) {
				index := A_Index
				returnArray.Insert(index "_Buyer", content)
				returnArray.Insert("Max_Index", index)
			}
			else break
		}
		counter--
		GuiControl,Trades:,% TradesGUI_Controls["Buyer_Slot_" counter],% "" ; Empties the slot content

	;	___ITEMS___
		Loop {
			if ( A_Index < btnID )
				counter := A_Index
			else if ( A_Index >= btnID )
				counter := A_Index+1
			GuiControlGet, content, Trades:,% TradesGUI_Controls["Item_Slot_" counter]
			if ( content ) {
				index := A_Index
				returnArray.Insert(index "_Item", content)
			}
			else break
		}
		counter--
		GuiControl,Trades:,% TradesGUI_Controls["Item_Slot_" counter],% ""
		
	;	___PRICES___
		Loop {
			if ( A_Index < btnID )
				counter := A_Index
			else if ( A_Index >= btnID )
				counter := A_Index+1
			GuiControlGet, content, Trades:,% TradesGUI_Controls["Price_Slot_" counter]
			if ( content ) {
				index := A_Index
				returnArray.Insert(index "_Price", content)
			}
			else break
		}
		counter--
		GuiControl,Trades:,% TradesGUI_Controls["Price_Slot_" counter],% ""
		
	;	___LOCATIONS___
		Loop {
			if ( A_Index < btnID )
				counter := A_Index
			else if ( A_Index >= btnID )
				counter := A_Index+1
			GuiControlGet, content, Trades:,% TradesGUI_Controls["Location_Slot_" counter]
			if ( content ) {
				index := A_Index
				returnArray.Insert(index "_Location", content)
			}
			else break
		}
		counter--
		GuiControl,Trades:,% TradesGUI_Controls["Location_Slot_" counter],% ""

;	___GAMEPID___
		Loop {
			if ( A_Index < btnID )
				counter := A_Index
			else if ( A_Index >= btnID )
				counter := A_Index+1
			GuiControlGet, content, Trades:,% TradesGUI_Controls["PID_Slot_" counter]
			if ( content ) {
				index := A_Index
				returnArray.Insert(index "_PID", content)
			}
			else break
		}
		counter--
		GuiControl,Trades:,% TradesGUI_Controls["PID_Slot_" counter],% ""

;	___TIME___
		Loop {
			if ( A_Index < btnID )
				counter := A_Index
			else if ( A_Index >= btnID )
				counter := A_Index+1
			GuiControlGet, content, Trades:,% TradesGUI_Controls["Time_Slot_" counter]
			if ( content ) {
				index := A_Index
				returnArray.Insert(index "_Time", content)
			}
			else break
		}
		counter--
		GuiControl,Trades:,% TradesGUI_Controls["Time_Slot_" counter],% ""

;	___OTHER___
		Loop {
			if ( A_Index < btnID )
				counter := A_Index
			else if ( A_Index >= btnID )
				counter := A_Index+1
			GuiControlGet, content, Trades:,% TradesGUI_Controls["Other_Slot_" counter]
			if ( content ) {
				index := A_Index
				returnArray.Insert(index "_Other", content)
			}
			else break
		}
		counter--
		GuiControl,Trades:,% TradesGUI_Controls["Other_Slot_" counter],% ""

;	___DATES___
		Loop {
			if ( A_Index < btnID )
				counter := A_Index
			else if ( A_Index >= btnID )
				counter := A_Index+1
			GuiControlGet, content, Trades:,% TradesGUI_Controls["Date_Slot_" counter]
			if ( content ) {
				index := A_Index
				returnArray.Insert(index "_Date", content)
			}
			else break
		}
		counter--
		GuiControl,Trades:,% TradesGUI_Controls["Date_Slot_" counter],% ""

;	___GUILDS___
		Loop {
			if ( A_Index < btnID )
				counter := A_Index
			else if ( A_Index >= btnID )
				counter := A_Index+1
			GuiControlGet, content, Trades:,% TradesGUI_Controls["Guild_Slot_" counter]
			if ( content ) {
				index := A_Index
				returnArray.Insert(index "_Guild", content)
			}
			else break
		}
		counter--
		GuiControl,Trades:,% TradesGUI_Controls["Guild_Slot_" counter],% ""

;	___InArea___
		Loop {
			if ( A_Index < btnID )
				counter := A_Index
			else if ( A_Index >= btnID )
				counter := A_Index+1
			GuiControlGet, content, Trades:,% TradesGUI_Controls["InArea_Slot_" counter]
			if ( content != "") {
				index := A_Index
				returnArray.Insert(index "_InArea", content)
			}
			else break
		}
		counter--
		GuiControl,Trades:,% TradesGUI_Controls["InArea_Slot_" counter],% ""

;	___NewMsg___
		Loop {
			if ( A_Index < btnID )
				counter := A_Index
			else if ( A_Index >= btnID )
				counter := A_Index+1
			GuiControlGet, content, Trades:,% TradesGUI_Controls["NewMsg_Slot_" counter]
			if ( content != "") {
				index := A_Index
				returnArray.Insert(index "_NewMsg", content)
			}
			else break
		}
		counter--
		GuiControl,Trades:,% TradesGUI_Controls["NewMsg_Slot_" counter],% ""

;	___WithdrawTally___
		Loop {
			if ( A_Index < btnID )
				counter := A_Index
			else if ( A_Index >= btnID )
				counter := A_Index+1
			GuiControlGet, content, Trades:,% TradesGUI_Controls["WithdrawTally_Slot_" counter]
			if ( content != "") {
				index := A_Index
				returnArray.Insert(index "_WithdrawTally", content)
			}
			else break
		}
		counter--
		GuiControl,Trades:,% TradesGUI_Controls["WithdrawTally_Slot_" counter],% ""


	}

	return returnArray
}

Gui_Trades_RemoveGuildPrefix(name) {
/*			Remvove the guild prefix from the name, is there is one
*/
	if RegExMatch(name, "<(.*)>(.*)", namePat)
		guild := namePat1, name := namePat2
	name = %name% ; Removes whitespaces
	guild = %guild%

	return {Name:name, Guild:guild}
}

Gui_Trades_Set_Position(xpos="UNSPECIFIED", ypos="UNSPECIFIED"){
/*			Update the Trades GUI position
*/
	global TradesGUI_Values, ProgramSettings

	if ( ProgramSettings.Trades_GUI_Mode != "Overlay" )
		Return
	if !(TradesGUI_Values.Created)
		return

	dpiFactor := ProgramSettings.Screen_DPI

	if WinExist("ahk_id " TradesGUI_Values.Dock_Window) {
		WinGetPos, winX, winY, winWidth, winHeight,% "ahk_id " TradesGUI_Values.Dock_Window
		xpos := ( (winX+winWidth)-TradesGUI_Values.Width * dpiFactor ), ypos := winY
		WinGet, isMinMax, MinMax,% "ahk_id " TradesGUI_Values.Dock_Window ; -1: Min | 1: Max | 0: Neither
		xpos := (isMinMax=1)?(xpos-8):(isMinMax=-1)?(((A_ScreenWidth/dpiFactor) - TradesGUI_Values.Width ) * dpiFactor):(xpos)
		ypos := (isMinMax=1)?(ypos+8):(isMinMax=-1)?(0):(ypos)
		if xpos is not number
			xpos := ( ( (A_ScreenWidth/dpiFactor) - TradesGUI_Values.Width ) * dpiFactor )
		if ypos is not number
			ypos := 0
		Gui, Trades:Show,% "x" xpos " y" ypos " NoActivate"
	}
	else {
		xpos := ( ( (A_ScreenWidth/dpiFactor) - TradesGUI_Values.Width ) * dpiFactor )
		Gui, Trades:Show,% "x" xpos " y0" " NoActivate"
	}
	Logs_Append(A_ThisFunc, {X:xpos, Y:ypos})
}


;==================================================================================================================
;
;												SETTINGS GUI
;
;==================================================================================================================

Gui_Settings() {
	static
	global ProgramSettings, ProgramValues, ProgramFonts, TradesGUI_Values, GUISettingsHandler
	global Hotkey1_KEYHandler, Hotkey2_KEYHandler, Hotkey3_KEYHandler, Hotkey4_KEYHandler, Hotkey5_KEYHandler, Hotkey6_KEYHandler

	programName := ProgramValues.Name, iniFilePath := ProgramValues.Ini_File, programSFXFolderPath := ProgramValues.SFX_Folder

	guiCreated := 0

	Gui, Settings:Destroy
	Gui, Settings:New, +AlwaysOnTop +SysMenu -MinimizeBox -MaximizeBox +OwnDialogs +LabelGui_Settings_ hwndGUISettingsHandler,% programName " - Settings"

	Gui, Settings:Font, ,Segoe UI

	tabsList := "Settings|Customization|Customization Appearance|Customization Custom Buttons|Customization Smaller Buttons|Hotkeys|Hotkeys Basic|Hotkeys Advanced|Hotkeys Special"

	guiXWorkArea := 150, guiYWorkArea := 10
	Gui, Settings:Add, TreeView, x10 y10 h380 w130 -0x4 -Buttons gGui_Settings_OnTabSiwtch
    P1 := TV_Add("Settings","", "Expand")
    P2 := TV_Add("Customization","","Expand")
    P2C1 := TV_Add("Appearance", P2, "Expand")
    P2C2 := TV_Add("Custom Buttons", P2, "Expand")
    P2C3 := TV_Add("Smaller Buttons", P2, "Expand")
    P3 := TV_Add("Hotkeys","","Expand")
    P3C1 := TV_Add("Basic", P3, "Expand")
    P3C2 := TV_Add("Advanced", P3, "Expand")
    P3C3 := TV_Add("Special", P3, "Expand")

    Gui, Settings:Add, Button,% "x" GuiXWorkArea " y325 w430 h25 hWndhSettingsPreview gGui_Settings_Trades_Preview Hidden",% "Save and preview your changes"
	Gui, Settings:Add, Text,% "x" guiXWorkarea . " y" 360,% "Settings will be saved upon closing this window."
	Gui, Settings:Add, Link,% "x" guiXWorkarea . " y" 375 . " vWikiBtn gGui_Settings_Btn_WIKI",% "Keep the cursor above a control to know more about it. You may also <a href="""">Visit the Wiki</a>"

	Gui, Settings:Add, Tab2, x10 y10 w0 h0 vTab hwndTabHandler,% tabsList
;---------------------------
	Gui, Settings:Tab, Settings
;	Settings Tab
	Gui, Settings:Add, GroupBox,% "x" GuiXWorkArea " y" GuiYWorkArea-5 " w430 h55" . " c000000 Section Center",About this tab:
		Gui, Settings:Add, Text,xs+10 ys+20 BackgroundTrans,Main settings about how should the tool behave.
;		Trades GUI
		Gui, Settings:Add, GroupBox,% " x" guiXWorkArea . " ys+60" . " w190 h140" . " c000000",Trades GUI
		Gui, Settings:Add, Radio, xp+10 yp+20 vShowAlways hwndShowAlwaysHandler,Always show
		Gui, Settings:Add, Radio, xp yp+15 vShowInGame hwndShowInGameHandler,Only show while in game

		Gui, Settings:Add, Checkbox, xp yp+25 hwndClipTabHandler vClipTab,Clipboard item on tab switch
		Gui, Settings:Add, Checkbox,% " xp" . " yp+15 hwndSelectLastTabHandler vSelectLastTab",Focus newly created tabs

		Gui, Settings:Add, Checkbox, xp yp+25 hwndAutoMinimizeHandler vAutoMinimize,Minimize when inactive
		Gui, Settings:Add, Checkbox, xp yp+15 hwndAutoUnMinimizeHandler vAutoUnMinimize,Un-Minimize when active
;			Transparency
			Gui, Settings:Add, GroupBox,% " x" guiXWorkArea+200 . " ys+60 w220 h140" . " c000000",Transparency
			Gui, Settings:Add, Checkbox, xp+30 yp+25 hwndClickThroughHandler vClickThrough,Click-through while inactive
			Gui, Settings:Add, Text, xp+5 yp+20,Inactive (no trade on queue)
			Gui, Settings:Add, Slider, xp+10 yp+15 hwndShowTransparencyHandler gGui_Settings_Transparency vShowTransparency AltSubmit ToolTip Range0-100
			Gui, Settings:Add, Text, xp-10 yp+30,Active (trades are on queue)
			Gui, Settings:Add, Slider, xp+10 yp+15 hwndShowTransparencyActiveHandler gGui_Settings_Transparency vShowTransparencyActive AltSubmit ToolTip Range30-100

; ;		Notifications
;			 Trade Sound Group
			Gui, Settings:Add, GroupBox,% "x" guiXWorkarea . " ys+210 w220 h125" . " c000000",Notifications
			Gui, Settings:Add, Checkbox, xp+10 yp+20 vNotifyTradeToggle hwndNotifyTradeToggleHandler,Trade
			Gui, Settings:Add, Edit, xp+70 yp-2 w70 h17 vNotifyTradeSound hwndNotifyTradeSoundHandler ReadOnly
			Gui, Settings:Add, Button, xp+75 yp-2 h20 vNotifyTradeBrowse gGui_Settings_Notifications_Browse,Browse
;			Whisper Sound Group
			Gui, Settings:Add, Checkbox, xp-145 yp+25 vNotifyWhisperToggle hwndNotifyWhisperToggleHandler,Whisper
			Gui, Settings:Add, Edit, xp+70 yp-2 w70 h17 vNotifyWhisperSound hwndNotifyWhisperSoundHandler ReadOnly
			Gui, Settings:Add, Button, xp+75 yp-2 h20 vNotifyWhisperBrowse gGui_Settings_Notifications_Browse,Browse
;			Area joined Sound Group
			Gui, Settings:Add, Checkbox,xp-145 yp+25 vNotifyJoinedAreaToggle hwndNotifyJoinedAreaToggleHandler,Joined
			Gui, Settings:Add, Edit, xp+70 yp-2 w70 h17 vNotifyJoinedAreaSound hwndNotifyJoinedAreaSoundHandler  ReadOnly
			Gui, Settings:Add, Button, xp+75 yp-2 h20 vNotifyJoinedAreaBrowse hwndNotifyJoinedAreaBrowseHandler gGui_Settings_Notifications_Browse,Browse
;			Whisper Tray Notification
			Gui, Settings:Add, Checkbox,xp-145 yp+29 vNotifyWhisperTray hwndNotifyWhisperTrayHandler,Show tray notifications
			Gui, Settings:Add, Checkbox,xp yp+14 vNotifyWhisperFlash hwndNotifyWhisperFlashHandler,Flash the taskbar icon
;		Support
		Gui, Settings:Add, GroupBox,% "x" guiXWorkArea+230 " y" guiYWorkArea+205 . " w185 h125" . " c000000",Support
		Gui, Settings:Add, Checkbox, xp+75 yp+35 vMessageSupportToggle hwndMessageSupportToggleHandler
		Gui, Settings:Add, Text, gGUI_Settings_Tick_Case vMessageSupportToggleText xp-55 yp+18,% "Send an additional message`n   containing the thread-id`n     upon closing a trade"

;	-----------------------
	Gui, Settings:Tab, Customization

	Gui, Settings:Add, GroupBox,% "x" GuiXWorkArea " y" GuiYWorkArea-5 " w430 h55" . " c000000 Section Center",Appearance:
		Gui, Settings:Add, Text,xs+10 ys+20 BackgroundTrans,Choose a skin preset or customize it to your liking.

	Gui, Settings:Add, GroupBox, x%GuiXWorkArea% yp+40 w430 h55 c000000 Section Center,Custom Buttons:
		Gui, Settings:Add, Text,xp+10 yp+20 BackgroundTrans,Rename and define button's actions or positions.

	Gui, Settings:Add, GroupBox, x%GuiXWorkArea% yp+40 w430 h55 c000000 Section Center,Smaller Buttons:
		Gui, Settings:Add, Text,xp+10 yp+20 BackgroundTrans,Choose to bind the buttons to an hotkey.
;	--------------------
	Gui, Settings:Tab, Customization Appearance
	Gui, Settings:Add, GroupBox,% "x" guiXWorkarea . " y" guiYWorkArea-5 . " w430 h55" . " c000000",Preset
		presetsList := "User Defined"
		Loop, Files,% ProgramValues.Skins_Folder "\*", D
		{
			presetsList .= "|" A_LoopFileName
		}
		Sort, presetsList,D|
		Gui, Settings:Add, DropDownList,% "x" guiXWorkarea+10 . " y" guiYWorkArea+15 . " w400" . " vActivePreset hwndActivePresetHandler gGui_Settings_Presets",% presetsList

	Gui, Settings:Add, GroupBox,% "x" guiXWorkArea . " y" guiYWorkArea+55 . " w430 h85" . " c000000",Skin

		skinsList := ""
		Loop, Files,% ProgramValues.Skins_Folder "\*", D
		{
			SplitPath, A_LoopFileFullPath, skinName
				skinsList .= skinName "|"
		}
		Sort, skinsList,D|
		Sleep 1
		Gui, Settings:Add, ListBox,% "xp+10" . " yp+20" . " w190" . " vSelectedSkin hwndSelectedSkinHandler R4" . " gGui_Settings_Set_Custom_Preset",% skinsList

		scalingList := "50%|75%|100%|125%|150%|175%|200%"
		Gui, Settings:Add, Text,% "xp+205" . " yp+3",Scale: 
		Gui, Settings:Add, DropDownList,% "xp+40" . " yp-3" . " w145" . " vSkinScaling hwndSkinScalingHandler" . " gGui_Settings_Set_Custom_Preset",% scalingList

	Gui, Settings:Add, GroupBox,% "x" guiXWorkArea . " y" guiYWorkArea+145 . " w430 h85" . " c000000",Font

		fontsList := "System"
		for fontFile, fontTitle in ProgramFonts {
			if fontTitle not contains TC_Symbols
				fontsList .= "|" fontTitle
		}
		Sort, fontsList,D|
		Sleep 1
		Gui, Settings:Add, ListBox,% "xp+10" . " yp+20" . " w190" . " vSelectedFont hwndSelectedFontHandler R4" . " gGui_Settings_Set_Custom_Preset",% fontsList
		Gui, Settings:Add, Text,% "xp+200" . " yp+3",Size:
		Gui, Settings:Add, DropDownList,% "xp+45" . " yp-3" . " w100" . " vFontSize hwndFontSizeHandler" . " gGui_Settings_Set_Custom_Preset",% "Automatic|Custom"
		Gui, Settings:Add, Edit,% "xp+100" . " yp" . " w50" . " ReadOnly"
		Gui, Settings:Add, UpDown, vFontSizeCustom hwndFontSizeCustomHandler gGui_Settings_Set_Custom_Preset

		Gui, Settings:Add, Text,% "xp-145" . " yp+33",Quality:
		Gui, Settings:Add, DropDownList,% "xp+45" . " yp-3" . " w100" . " vFontQuality hwndFontQualityHandler" . " gGui_Settings_Set_Custom_Preset",% "Automatic|Custom"
		Gui, Settings:Add, Edit,% "xp+100" . " yp" . " w50" . " ReadOnly"
		Gui, Settings:Add, UpDown, vFontQualityCustom hwndFontQualityCustomHandler gGui_Settings_Set_Custom_Preset

	Gui, Settings:Add, GroupBox,% "x" guiXWorkArea . " y" guiYWorkArea+235 . " w430 h75" . " c000000",Colors

		Gui, Settings:Add, Text,% "xp+10 yp+23",% "Select an element:"
		Gui, Settings:Add, DropDownList,% "xp+100 yp-3 w150 vFontsColors hwndFontsColorsHandler gGui_Settings_Fonts_Color_DropDownList AltSubmit",% "Border|Button (Normal)|Button (Hover)|Button (Press)"
																						. "|Title (Active)|Title (Inactive)|Trade Infos (1)|Trade Infos (2)"
																						. "|Tab (Active)|Tab (Inactive)|Tab (Hover)|Tab (Press)"
																						. "|Tab Joined (Active)|Tab Joined (Inactive)|Tab Joined (Hover)|Tab Joined (Press)"
																						. "|Tab Whisper (Active)|Tab Whisper (Inactive)|Tab Whisper (Hover)|Tab Whisper (Press)"
		Loop {
			ctrlPos 	:= (A_Index=1)?("xp+160 yp w60 "):("xp yp wp ")
			ctrlVars 	:= ["BorderColor","ButtonNormalColor","ButtonHoverColor","ButtonPressColor"
					       ,"TitleActiveColor","TitleInactiveColor","TradesInfos1Color","TradesInfos2Color"
					       ,"TabActiveColor","TabInactiveColor","TabHoverColor","TabPressColor"
					       ,"TabJoinedActiveColor","TabJoinedInactiveColor","TabJoinedHoverColor","TabJoinedPressColor"
						   ,"TabWhisperActiveColor","TabWhisperInactiveColor","TabWhisperHoverColor","TabWhisperPressColor"]
			if (!ctrlVars[A_Index])
				Break
			Gui, Settings:Add, Edit,% ctrlPos " v" ctrlVars[A_Index] " hwnd" ctrlVars[A_Index] "Handler gGui_Settings_Fonts_Color_Preview Hidden Limit6"
		}
		ctrlPos := "", ctrlVars := ""
		Gui, Settings:Add, Progress,% "xp+70 yp w22 h22 Background000000 vFontsColorsPreview hwndFontsColorPreviewHandler Hidden"
		Gui, Settings:Add, Text,% "xp-330 yp+25 R2 w400 vFontsColorsTip hwndFontsColorsTipsHandler",% "Description of the selected element will appear here."

		Gui, Settings:Add, Link,% "x" guiXWorkArea + 80 . " y" guiYWorkArea+235,% "(<a href=""http://hslpicker.com/"">HSL Color Picker</a> - Get the 6 chars code starting with #) "

;	-------------------------
	Gui, Settings:Tab, Customization Custom Buttons
	DynamicGUIHandlersArray := Object()

		Gui, Settings:Add, GroupBox,% "x" guiXWorkarea . " y" guiYWorkArea-5 . " w430 h110" . " c000000",Buttons
	Loop 9 {
		index := A_Index
		xpos := (index=1||index=4||index=7)?(guiXWorkArea+32):(index=2||index=5||index=8)?(guiXWorkArea+152):(index=3||index=6||index=9)?(guiXWorkArea+272):("ERROR")
		ypos := (index=1||index=2||index=3)?(guiYWorkArea+20):(index=4||index=5||index=6)?(guiYWorkArea+45):(index=7||index=8||index=9)?(guiYWorkArea+70):("ERROR")
		Gui, Settings:Add, Button, x%xpos% y%ypos% w120 h25 vTradesBtn%index% hwndTradesBtn%index%Handler gGui_Settings_Custom_Label,% "Custom " index

		Gui, Settings:Add, GroupBox,% "x" guiXWorkArea . " y" guiYWorkArea+110 . " w430 h85" . " c000000",Positioning
			Gui, Settings:Add, Text,% "xp+10" . " yp+20" . " hwndTradesHPOS" index "TextHandler Hidden",Horizontal:
			Gui, Settings:Add, ListBox, w70 xp+55 yp vTradesHPOS%index% hwndTradesHPOS%index%Handler R3 Hidden,% "Left|Center|Right"
			Gui, Settings:Add, Text, xp+75 yp hwndTradesVPOS%index%TextHandler Hidden,Vertical:
			Gui, Settings:Add, ListBox, w70 xp+45 yp vTradesVPOS%index% hwndTradesVPOS%index%Handler R3 Hidden,% "Top|Middle|Bottom"
			Gui, Settings:Add, Text, xp+75 yp hwndTradesSIZE%index%TextHandler Hidden,Size:
			Gui, Settings:Add, ListBox, w70 xp+30 yp vTradesSIZE%index% hwndTradesSIZE%index%Handler R4 Hidden,% "Disabled|Small|Medium|Large"

		Gui, Settings:Add, GroupBox,% "x" guiXWorkarea . " y" guiYWorkArea+200 . " w430 h110" . " c000000",Behaviour
			Gui, Settings:Add, Text,% "xp+10" . " yp+20" . " hwndTradesLabel" index "TextHandler Hidden",Label:
			Gui, Settings:Add, Edit, xp+50 yp-3 w160 vTradesLabel%index% hwndTradesLabel%index%Handler gGui_Settings_Custom_Label Hidden,
			Gui, Settings:Add, Text, xp+170 yp+3 vTradesHK%index%Text hwndTradesHK%index%TextHandler Hidden,Hotkey:
			Gui, Settings:Add, Hotkey, xp+50 yp-3 vTradesHK%index% hwndTradesHK%index%Handler Hidden,

			Gui, Settings:Add, Text,% "xp-270" . " yp+33" . " hwndTradesAction" index "TextHandler Hidden",Action:
			Gui, Settings:Add, DropDownList, xp+50 yp-3 w160 vTradesAction%index% hwndTradesAction%index%Handler gGui_Settings_Custom_Label Hidden,% "Clipboard Item|Send Message|Send Message + Close Tab|Send Message + Minimize|Write Message"
			Gui, Settings:Add, CheckBox,xp+170 yp vTradesMarkCompleted%index% hwndTradesMarkCompleted%index%Handler Center Hidden,Save the trade infos locally?`n(for personnal statistics purposes)

			Gui, Settings:Add, Edit,% "x" guiXWorkarea+10 . " yp+30 w50" . " hwndTradesMsgEditID" index "Handler" . " ReadOnly Limit1 Hidden",1|2|3
			Gui, Settings:Add, UpDown,% " vTradesMsgID" index " hwndTradesMsgID" index "Handler" . " Range1-3 gGui_Settings_Cycle_Messages Hidden"
			Gui, Settings:Add, Edit, xp+50 yp w355 vTradesMsg1_%index% hwndTradesMsg1_%index%Handler Hidden,
			Gui, Settings:Add, Edit, xp yp w355 vTradesMsg2_%index% hwndTradesMsg2_%index%Handler Hidden,
			Gui, Settings:Add, Edit, xp yp w355 vTradesMsg3_%index% hwndTradesMsg3_%index%Handler Hidden,

		DynamicGUIHandlersArray["Btn" index] := TradesBtn%index%Handler
		DynamicGUIHandlersArray["HPOS" index] := TradesHPOS%index%Handler
		DynamicGUIHandlersArray["HPOSText" index] := TradesHPOS%index%TextHandler
		DynamicGUIHandlersArray["VPOS" index] := TradesVPOS%index%Handler
		DynamicGUIHandlersArray["VPOSText" index] := TradesVPOS%index%TextHandler
		DynamicGUIHandlersArray["SIZE" index] :=  TradesSIZE%index%Handler
		DynamicGUIHandlersArray["SIZEText" index] := TradesSIZE%index%TextHandler
		DynamicGUIHandlersArray["Label" index] := TradesLabel%index%Handler
		DynamicGUIHandlersArray["LabelText" index] := TradesLabel%index%TextHandler
		DynamicGUIHandlersArray["Action" index] := TradesAction%index%Handler
		DynamicGUIHandlersArray["ActionText" index] := TradesAction%index%TextHandler
		DynamicGUIHandlersArray["Hotkey" index] := TradesHK%index%Handler
		DynamicGUIHandlersArray["HotkeyText" index] := TradesHK%index%TextHandler
		DynamicGUIHandlersArray["MarkCompleted" index] := TradesMarkCompleted%index%Handler
		DynamicGUIHandlersArray["MsgEditID" index] := TradesMsgEditID%index%Handler
		DynamicGUIHandlersArray["MsgID" index] :=  TradesMsgID%index%Handler
		DynamicGUIHandlersArray["Msg1" index] := TradesMsg1_%index%Handler
		DynamicGUIHandlersArray["Msg2" index] := TradesMsg2_%index%Handler
		DynamicGUIHandlersArray["Msg3" index] := TradesMsg3_%index%Handler
	}
;------------------------------
;	Smaller Buttons
	Gui, Settings:Tab, Customization Smaller Buttons

	Gui, Settings:Add, GroupBox,% "x" GuiXWorkArea " y" GuiYWorkArea-5 " w430 h55" . " c000000 Section Center",About this tab:
		Gui, Settings:Add, Text,xs+10 ys+15 BackgroundTrans,Allows to bind hotkeys to these buttons.
		Gui, Settings:Add, Text,xp yp+15 BackgroundTrans,Disabling all Custom Buttons will effectively show only this row.

	hexCodes := ["0", "1", "2", "3", "4"]
	ctrlActions := ["Clipboard" , "Whisper", "Invite", "Trade", "Kick"]
	for key, element in hexCodes {
		xpos := (Mod(A_Index,2)!=0)?(guiXWorkarea)
			   :(370)
		ypos := (A_Index=1)?(GuiYWorkArea+55)
			   :(Mod(A_Index,2)!=0 && A_Index!=1)?(ypos+80)
			   :(ypos)
		width := 210, height := 80

		Gui, Settings:Font,% "S" 20,% "TC_Symbols"
		Gui, Settings:Add, GroupBox,% "x" xpos " y" ypos " w" width " h" height . " c000000 hwndUnicodeBtn" A_Index "Handler",% ""
			handler := "UnicodeBtn" A_Index "Handler"
			ConvertesChars := Hex2Bin(nString, element) ; Convert hex code into its corresponding unicode character
		   	SetUnicodeText(nString, %handler%) ; Replace the control's content with the unicode character
		   	Gui, Settings:Font
		   	Gui, Settings:Add, Text,% "xp+50 yp+7",% "(" ctrlActions[key] ")"
		   	Gui, Settings:Add, Text,% "x" xpos+10 " yp+22",Position: 
		   	Gui, Settings:Add, DropDownList,% "xp+60" " yp-2" " w" width-80 " R6" " vUnicodeBtn" A_Index "Position" " hwndUnicodeBtn" A_Index "PositionHandler",% "Disabled|1|2|3|4|5"
		   	Gui, Settings:Add, CheckBox,% "x" xpos+10 " yp+27" . " vUnicodeBtn" A_Index "HotkeyToggle" " hwndUnicodeBtn" A_Index "HotkeyToggleHandler", Hotkey:
		   	Gui, Settings:Add, Hotkey,% "xp+60" " yp-3" " w" width-80 . " vUnicodeBtn" A_Index "Hotkey" " hwndUnicodeBtn" A_Index "HotkeyHandler"
		   	index := A_Index
	}
	key := "", element := "", hexCodes := "", xpos := "", ypos := "", handler := "", ConvertesChars := "", nString := ""

;------------------------------
;	Hotkeys Tab
	Gui, Settings:Tab, Hotkeys

	Gui, Settings:Add, GroupBox,% "x" GuiXWorkArea " y" GuiYWorkArea-5 " w430 h55" . " c000000 Section Center",Basic:
		Gui, Settings:Add, Text,xs+10 ys+15 BackgroundTrans,Allows to bind an hotkey to send a single message or command.
		Gui, Settings:Add, Text,xp yp+15 BackgroundTrans,Some keys such as Space or Escape can only be bound in Advanced.

	Gui, Settings:Add, GroupBox, x%GuiXWorkArea% yp+30 w430 h55 c000000 Section Center,Advanced:
		Gui, Settings:Add, Text,xs+10 ys+15 BackgroundTrans,Allows to bind an hotkey to send multiple messages.
		Gui, Settings:Add, Text,xp yp+15 BackgroundTrans,Please refer to the Wiki to find out how to correctly set them up.

	Gui, Settings:Add, GroupBox, x%GuiXWorkArea% yp+30 w430 h55 c000000 Section Center,Special:
		Gui, Settings:Add, Text,xs+10 ys+15 BackgroundTrans,Allows to bind an hotkey to special actions.

;------------------------------
	Gui, Settings:Tab, Hotkeys Basic

	Gui, Settings:Add, GroupBox,% "x" GuiXWorkArea " y" GuiYWorkArea-5 " w430 h55" . " c000000 Section Center",About this tab:
		Gui, Settings:Add, Text,xs+10 ys+15 BackgroundTrans,Allows to bind an hotkey to send a single message or command.
		Gui, Settings:Add, Text,xp yp+15 BackgroundTrans,Some keys such as Space or Escape can only be bound in Advanced.

	xpos := guiXWorkArea, ypos := guiYWorkArea+55
	Loop 8 {
		btnID := A_Index
		if (btnID > 1 && btnID <= 4) || (btnID > 5)
			ypos += 70
		else if (btnID = 5)
			xpos := guiXWorkArea+220, ypos := guiYWorkArea+55
		Gui, Settings:Add, GroupBox, x%xpos% y%ypos% w210 h70 hwndHotkey%btnID%_GroupBox c000000
		Gui, Settings:Add, Checkbox, xp+10 yp+31 vHotkey%btnID%_Toggle hwndHotkey%btnID%_ToggleHandler
		Gui, Settings:Add, Edit, xp+30 yp-17 w150 vHotkey%btnID%_Text hwndHotkey%btnID%_TextHandler,
		Gui, Settings:Add, Hotkey, xp yp+25 w150 vHotkey%btnID%_KEY hwndHotkey%btnID%_KEYHandler,
	}
;-----------------------------------
	Gui, Settings:Tab, Hotkeys Advanced

	Gui, Settings:Add, GroupBox,% "x" GuiXWorkArea " y" GuiYWorkArea-5 " w430 h55" . " c000000 Section Center",About this tab:
		Gui, Settings:Add, Text,xs+10 ys+15 BackgroundTrans,Allows to bind an hotkey to send multiple messages.
		Gui, Settings:Add, Text,xp yp+15 BackgroundTrans,Please refer to the Wiki to find out how to correctly set them up.

	xpos := guiXWorkArea, ypos := guiYWorkArea+55
	Loop 16 {
		btnID := A_Index
		if ( btnID > 1 && btnID <= 8 ) || ( btnID > 9 )
			ypos += 35
		else if ( btnID = 9 )
			xpos := guiXWorkArea+220, ypos := guiYWorkArea+55
		Gui, Settings:Add, GroupBox, x%xpos% y%ypos% w210 h35 c000000
		Gui, Settings:Add, Checkbox, xp+7 yp+13 w15 h15 vHotkeyAdvanced%btnID%_Toggle hwndHotkeyAdvanced%btnID%_ToggleHandler
		Gui, Settings:Add, Edit, xp+30 yp-3 w60 vHotkeyAdvanced%btnID%_KEY hwndHotkeyAdvanced%btnID%_KEYHandler
		Gui, Settings:Add, Edit, xp+65 yp w100 gGui_Settings_Hotkeys_Tooltip vHotkeyAdvanced%btnID%_Text hwndHotkeyAdvanced%btnID%_TextHandler
	}
;-----------------------------------
	Gui, Settings:Tab, Hotkeys Special

	Gui, Settings:Add, GroupBox, x%GuiXWorkArea% y%GuiYWorkArea% w430 h55 c000000 Section Center,About this tab:
		Gui, Settings:Add, Text,xs+10 ys+15 BackgroundTrans,Allows to bind an hotkey to special actions.

	ctrlNames := ["Choose Next Tab" , "Choose Previous Tab", "Close Current Tab", "Toggle Minimize State"]
	ctrlVars := ["ChooseNextTab", "ChoosePrevTab", "CloseCurrentTab", "ToggleMinimize"]
	for key, element in ctrlNames {
		xpos := (Mod(A_Index,2)!=0)?(guiXWorkarea)
			   :(370)
		ypos := (A_Index=1)?(GuiYWorkArea+55)
			   :(Mod(A_Index,2)!=0 && A_Index!=1)?(ypos+60)
			   :(ypos)
		width := 210, height := 60

		Gui, Settings:Add, GroupBox,% "x" xpos " y" ypos " w" width " h" height . " c000000",% ctrlNames[A_Index]
		   	Gui, Settings:Add, CheckBox,% "x" xpos+10 " yp+25 w15 h15" . " v" ctrlVars[A_Index] "HotkeyToggle" " hwnd" ctrlVars[A_Index] "HotkeyToggleHandler"
		   	Gui, Settings:Add, Text,% "x" xpos+27 " yp+1",Hotkey:
		   	Gui, Settings:Add, Hotkey,% "xp+45" " yp-3" " w" width-80 . " v" ctrlVars[A_Index] "Hotkey" " hwnd" ctrlVars[A_Index] "HotkeyHandler"
	}



;-----------------------------------

	GoSub, Gui_Settings_Set_Preferences
	Gui, Trades: -E0x20
	Gui, Settings:Show
	GuiControl, Settings:Choose,% TabHandler,1
	guiCreated := 1
return

	Gui_Settings_Fonts_Color_Preview:
		Gui, Settings:Submit, NoHide

		if (isUserChangingPreset)
			Return

		ctrlVars := ["BorderColor","ButtonNormalColor","ButtonHoverColor","ButtonPressColor"
					,"TitleActiveColor","TitleInactiveColor","TradesInfos1Color","TradesInfos2Color"
					,"TabActiveColor","TabInactiveColor","TabHoverColor","TabPressColor"
					,"TabJoinedActiveColor","TabJoinedInactiveColor","TabJoinedHoverColor","TabJoinedPressColor"
					,"TabWhisperActiveColor","TabWhisperInactiveColor","TabWhisperHoverColor","TabWhisperPressColor"]
		ctrlHandlers := [BorderColorHandler,ButtonNormalColorHandler,ButtonHoverColorHandler,ButtonPressColorHandler
					,TitleActiveColorHandler,TitleInactiveColorHandler,TradesInfos1ColorHandler,TradesInfos2ColorHandler
					,TabActiveColorHandler,TabInactiveColorHandler,TabHoverColorHandler,TabPressColorHandler
					,TabJoinedActiveColorHandler,TabJoinedInactiveColorHandler,TabJoinedHoverColorHandler,TabJoinedPressColorHandler
					,TabWhisperActiveColorHandler,TabWhisperInactiveColorHandler,TabWhisperHoverColorHandler,TabWhisperPressColorHandler]

		for id, varName in ctrlVars {
			if (A_GuiControl = varName) {
				GuiControlGet, colorHex, Settings:,% ctrlHandlers[id]
				GuiControl, Settings:+Background%colorHex%,% FontsColorPreviewHandler
			}
		}

		ctrlHandlers := "", ctrlVars := "", colorHex := ""

		GoSub Gui_Settings_Set_Custom_Preset
	Return
	Gui_Settings_Fonts_Color_DropDownList:
		Gui, Settings:Submit, NoHide

		ctrlHandlers := [BorderColorHandler,ButtonNormalColorHandler,ButtonHoverColorHandler,ButtonPressColorHandler
					,TitleActiveColorHandler,TitleInactiveColorHandler,TradesInfos1ColorHandler,TradesInfos2ColorHandler
					,TabActiveColorHandler,TabInactiveColorHandler,TabHoverColorHandler,TabPressColorHandler
					,TabJoinedActiveColorHandler,TabJoinedInactiveColorHandler,TabJoinedHoverColorHandler,TabJoinedPressColorHandler
					,TabWhisperActiveColorHandler,TabWhisperInactiveColorHandler,TabWhisperHoverColorHandler,TabWhisperPressColorHandler]
		for id, handler in ctrlHandlers {
			GuiControlGet, isVisible,Settings:Visible,% handler
			if (isVisible)
				GuiControl, Settings:Hide,% handler
		}
		GuiControl, Settings:Show,% ctrlHandlers[FontsColors]
		GuiControl, Settings:Show,% FontsColorPreviewHandler

		GuiControlGet, colorHex, Settings:,% ctrlHandlers[FontsColors]
		GuiControl, Settings:+Background%colorHex%,% FontsColorPreviewHandler

;		Show the tip corresponding
		Tips := (FontsColors = "1")?("Colour for the window border.")
			   :(FontsColors = "2")?("Font colour on buttons.")
			   :(FontsColors = "3")?("Font colour for the currently hovered button.")
			   :(FontsColors = "4")?("Font colour for the currently pressed button.")
			   :(FontsColors = "5")?("Font colour for the title bar when you have active tabs.")
			   :(FontsColors = "6")?("Font colour for the title bar when no tabs are open.")
			   :(FontsColors = "7")?("Font colour for the Slot names.")
			   :(FontsColors = "8")?("Font colour for the informations in the Slots.")
			   :(FontsColors = "9")?("Font colour for the current active tab.")
			   :(FontsColors = "10")?("Font colour on inactive tabs.")
			   :(FontsColors = "11")?("Font colour for the currently hovered tab.")
			   :(FontsColors = "12")?("Font colour for the currently pressed tab.")
			   :(FontsColors = "13")?("Font colour for the current active tab.`nAnd for which the buyer has joined the area.")
			   :(FontsColors = "14")?("Font colour on inactive tabs.`nAnd for which the buyer has joined the area.")
			   :(FontsColors = "15")?("Font colour for the currently hovered tab.`nAnd for which the buyer has joined the area.")
			   :(FontsColors = "16")?("Font colour for the currently pressed tab.`nAnd for which the buyer has joined the area.")
			   :(FontsColors = "17")?("Font colour for the current active tab.`nAnd for which the buyer has sent you another whisper.")
			   :(FontsColors = "18")?("Font colour on inactive tabs.`nAnd for which the buyer has sent you another whisper.")
			   :(FontsColors = "19")?("Font colour for the currently hovered tab.`nAnd for which the buyer sent you another whisper.")
			   :(FontsColors = "20")?("Font colour for the currently pressed tab.`nAnd for which the buyer sent you another whisper.")
			   :("No description for this element has been found.")
		GuiControl, Settings:,% FontsColorsTipsHandler,% Tips

		ctrlHandlers := "", isVisible := "", colorHex := "", Tips := ""
	Return

	Gui_Settings_Cycle_Messages:
		Gui, Settings:Submit, NoHide

		btnID := RegExReplace(A_GuiControl, "\D")
		ctrlHandler := DynamicGUIHandlersArray["MsgID" btnId]
		GuiControlGet, currentMsgID,Settings:,% ctrlHandler

		GuiControl, Settings: Hide,% DynamicGUIHandlersArray["Msg1" btnID]
		GuiControl, Settings: Hide,% DynamicGUIHandlersArray["Msg2" btnID]
		GuiControl, Settings: Hide,% DynamicGUIHandlersArray["Msg3 "btnID]

		if ( currentMsgID = 1 )
			GuiControl, Settings: Show,% DynamicGUIHandlersArray["Msg1" btnID]
		else if ( currentMsgID = 2 )
			GuiControl, Settings: Show,% DynamicGUIHandlersArray["Msg2" btnID]
		else if ( currentMsgID = 3 )
			GuiControl, Settings: Show,% DynamicGUIHandlersArray["Msg3" btnID]
	Return

	Gui_Settings_Set_Custom_Preset:
	/*		Select "User Defined" preset upon changing any setting.
	*/
		if (isUserChangingPreset)
			Return

		; Unless we are changing the preset, set the preset to "User Defined"
		Gui, Settings:Submit, NoHide
		if ( A_GuiControl != "ActivePreset" ) {
			GuiControl, Settings:ChooseString,% ActivePresetHandler,User Defined
		}

		; Set auto font size/qual upon changing the font
		if ( A_GuiControl="SelectedFont" || A_GuiControl="FontSize" || A_GuiControl="FontQuality" ) {
			if (FontSize = "Automatic") {
				IniRead, fontSizeAuto,% ProgramValues.Fonts_Settings_File,SIZE,% SelectedFont
				if !IsNum(fontSizeAuto)
					IniRead, fontSizeAuto,% ProgramValues.Fonts_Settings_File,SIZE,Default
				GuiControl, Settings:,% FontSizeCustomHandler,% fontSizeAuto
			}
			if (FontQuality = "Automatic") {
				IniRead, fontQualAuto,% ProgramValues.Fonts_Settings_File,QUALITY,% SelectedFont
				if !IsNum(fontQualAuto)
					IniRead, fontQualAuto,% ProgramValues.Fonts_Settings_File,QUALITY,Default
				GuiControl, Settings:,% FontQualityCustomHandler,% fontQualAuto
			}
		}

		; Enable/Disable the control, preventing the user to change the value
		state := (FontSize="Custom")?("Enable"):("Disable")
		GuiControl, Settings:%state%,% FontSizeCustomHandler
		state := (FontQuality="Custom")?("Enable"):("Disable")
		GuiControl, Settings:%state%,% FontQualityCustomHandler
	Return

	Gui_Settings_Presets:
	/*		Apply the selected preset Settings
	*/
		if !isSettingPreferences
			Gui, Settings:Submit, NoHide

		isUserChangingPreset := true
		Sleep 10
		GuiControl, Settings:ChooseString,% SkinScalingHandler,% Floor(ProgramSettings.Scale_Multiplier*100) "%"
		if (ActivePreset="User Defined") {
			skinSettingsFile := ProgramValues.Ini_File
			keys 					:= ["Active_Skin","Font","Font_Size_Mode","Font_Size_Custom","Font_Quality_Mode","Font_Quality_Custom"
						   			   ,"Color_Title_Active","Color_Title_Inactive","Color_Trades_Infos_1","Color_Trades_Infos_2"
									   ,"Color_Border","Color_Button_Normal","Color_Button_Hover","Color_Button_Press"
									   ,"Color_Tab_Active","Color_Tab_Inactive","Color_Tab_Hover","Color_Tab_Press"
									   ,"Color_Tab_Joined_Active","Color_Tab_Joined_Inactive","Color_Tab_Joined_Hover","Color_Tab_Joined_Press"
									   ,"Color_Tab_Whisper_Active","Color_Tab_Whisper_Inactive","Color_Tab_Whisper_Hover","Color_Tab_Whisper_Press"]
			sect 					:= "CUSTOMIZATION_APPEARANCE"
			controlsUseChoose 		:= "Active_Skin,Font,Font_Size_Mode,Font_Quality_Mode"
			handlers 				:= [SelectedSkinHandler,SelectedFontHandler,FontSizeHandler,FontSizeCustomHandler,FontQualityHandler,FontQualityCustomHandler
						   			   ,TitleActiveColorHandler,TitleInactiveColorHandler,TradesInfos1ColorHandler,TradesInfos2ColorHandler
						   			   ,BorderColorHandler,ButtonNormalColorHandler,ButtonHoverColorHandler,ButtonPressColorHandler
						   			   ,TabActiveColorHandler,TabInactiveColorHandler,TabHoverColorHandler,TabPressColorHandler
						   			   ,TabJoinedActiveColorHandler,TabJoinedInactiveColorHandler,TabJoinedHoverColorHandler,TabJoinedPressColorHandler
						   			   ,TabWhisperActiveColorHandler,TabWhisperInactiveColorHandler,TabWhisperHoverColorHandler,TabWhisperPressColorHandler]
			

			for id, key in keys {
				IniRead, value,% skinSettingsFile,% sect,% key
				if key in %controlsUseChoose%
					GuiControl, Settings:ChooseString,% handlers[id],% value
				else
					GuiControl, Settings:,% handlers[id],% value
			}
		}
		else {
			skinSettingsFile := ProgramValues.Skins_Folder "\" ActivePreset "\Settings.ini"

			sect 				:= "FONT"
			keys				:= ["Name","Size","Quality"]
			controlsUseChoose 	:= "Name"
			handlers 			:= [SelectedFontHandler,FontSizeCustomHandler,FontQualityCustomHandler]

			for id, key in keys {
				IniRead, value,% skinSettingsFile,% sect,% key
				if key in %controlsUseChoose%
					GuiControl, Settings:ChooseString,% handlers[id],% value
				else
					GuiControl, Settings:,% handlers[id],% value
			}
			GuiControl, Settings:ChooseString,% SelectedSkinHandler,% ActivePreset
			GuiControl, Settings:ChooseString,% FontSizeHandler,% "Automatic"
			GuiControl, Settings:ChooseString,% FontQualityHandler,% "Automatic"

			sect 				:= "COLORS"
			keys 				:= ["Title_Trades","Title_No_Trades","Trade_Info_1","Trade_Info_2","Border"
								   ,"Tab_Active","Tab_Inactive","Tab_Hover","Tab_Press"
								   ,"Tab_Joined_Active","Tab_Joined_Inactive","Tab_Joined_Hover","Tab_Joined_Press"
								   ,"Tab_Whisper_Active","Tab_Whisper_Inactive","Tab_Whisper_Hover","Tab_Whisper_Press"
								   ,"Button_Normal","Button_Hover","Button_Press"]
			controlsUseChoose 	:= ""
			handlers 			:= [TitleActiveColorHandler,TitleInactiveColorHandler,TradesInfos1ColorHandler,TradesInfos2ColorHandler,BorderColorHandler
								  ,TabActiveColorHandler,TabInactiveColorHandler,TabHoverColorHandler,TabPressColorHandler
								  ,TabJoinedActiveColorHandler,TabJoinedInactiveColorHandler,TabJoinedHoverColorHandler,TabJoinedPressColorHandler
						   		  ,TabWhisperActiveColorHandler,TabWhisperInactiveColorHandler,TabWhisperHoverColorHandler,TabWhisperPressColorHandler
								  ,ButtonNormalColorHandler,ButtonHoverColorHandler,ButtonPressColorHandler]

			for id, key in keys {
				IniRead, value,% skinSettingsFile,% sect,% key
				if key in %controlsUseChoose%
					GuiControl, Settings:ChooseString,% handlers[id],% value
				else
					GuiControl, Settings:,% handlers[id],% value
			}
		}
		Sleep 10
		isUserChangingPreset := false
	Return

	Gui_Settings_OnTabSiwtch:
	  if (A_GuiEvent = "S") {
	  	evntinf := A_EventInfo
	  	tabName := (evntinf=P1)?("Settings")
	  			:(evntinf=P2)?("Customization")
	  			:(evntinf=P2C1)?("Customization Appearance")
	  			:(evntinf=P2C2)?("Customization Custom Buttons")
	  			:(evntinf=P2C3)?("Customization Smaller Buttons")
	  			:(evntinf=P3)?("Hotkeys")
	  			:(evntinf=P3C1)?("Hotkeys Basic")
	  			:(evntinf=P3C2)?("Hotkeys Advanced")
	  			:(evntinf=P3C3)?("Hotkeys Special")
	  			:("ERROR")
	      GuiControl, Settings:Choose,% TabHandler,% tabName
	  }
	  if tabName contains Customization
	  	GuiControl, Settings:Show,% hSettingsPreview
	  else 
	  	GuiControl, Settings:Hide,% hSettingsPreview
	Return

	Gui_Settings_Trades_Preview:
		GoSub, Gui_Settings_Btn_Apply

		Gui_Trades_Redraw("CREATE", {preview:1})
		Gui_Trades_Minimize_Func("FULL", 1)
	Return

	Gui_Settings_Custom_Label:
		Gui, Settings:Submit, NoHide
		RegExMatch(A_GuiControl, "\d+", btnID)
		RegExMatch(A_GuiControl, "\D+", btnType)
		actionContent := (btnID=1)?(TradesAction1):(btnID=2)?(TradesAction2):(btnID=3)?(TradesAction3):(btnID=4)?(TradesAction4):(btnID=5)?(TradesAction5):(btnID=6)?(TradesAction6):(btnID=7)?(TradesAction7):(btnID=8)?(TradesAction8):(btnID=9)?(TradesAction9):("ERROR")
		labelContent := (btnID=1)?(TradesLabel1):(btnID=2)?(TradesLabel2):(btnID=3)?(TradesLabel3):(btnID=4)?(TradesLabel4):(btnID=5)?(TradesLabel5):(btnID=6)?(TradesLabel6):(btnID=7)?(TradesLabel7):(btnID=8)?(TradesLabel8):(btnID=9)?(TradesLabel9):("ERROR")
		Gui_Settings_Custom_Label_Func(btnType, DynamicGUIHandlersArray, btnID, actionContent, labelContent)
	Return

	Gui_Settings_Btn_WIKI:
		Run, % "https://github.com/lemasato/POE-Trades-Companion/wiki"
	Return
	
	Gui_Settings_Hotkeys_Tooltip:
		if ( guiCreated = 0 )
			Return

		Gui, Settings:Submit, NoHide
		RegExMatch(A_GuiControl, "\d+", btnID)
		ctrlHandler := (btnID=1)?(HotkeyAdvanced1_TextHandler):(btnID=2)?(HotkeyAdvanced2_TextHandler):(btnID=3)?(HotkeyAdvanced3_TextHandler):(btnID=4)?(HotkeyAdvanced4_TextHandler):(btnID=5)?(HotkeyAdvanced5_TextHandler):(btnID=6)?(HotkeyAdvanced6_TextHandler):(btnID=7)?(HotkeyAdvanced7_TextHandler):(btnID=8)?(HotkeyAdvanced8_TextHandler):(btnID=9)?(HotkeyAdvanced9_TextHandler):(btnID=10)?(HotkeyAdvanced10_TextHandler):(btnID=11)?(HotkeyAdvanced11_TextHandler):(btnID=12)?(HotkeyAdvanced12_TextHandler):(btnID=13)?(HotkeyAdvanced13_TextHandler):(btnID=14)?(HotkeyAdvanced14_TextHandler):(btnID=15)?(HotkeyAdvanced15_TextHandler):(btnID=16)?(HotkeyAdvanced16_TextHandler):("ERROR")
		GuiControlGet, ctrlContent, Settings:,% ctrlHandler
		try 
			ToolTip,% ctrlContent
	Return


	GUI_Settings_Tick_Case:
		Gui, Settings: Submit, NoHide
		if ( A_GuiControl = "MessageSupportToggleText" ) {
			GuiControl, Settings:,% MessageSupportToggleHandler,% !MessageSupportToggle 
		}
	Return

	Gui_Settings_Transparency:
	;	Set the transparency
		Gui, Settings: Submit, NoHide
		trans := ( ShowTransparency / 100 ) * 255 ; ( value - percentage ) * max // Convert percentage to 0-255 range
		transActive := ( ShowTransparencyActive / 100 ) * 255 ; ( value - percentage ) * max // Convert percentage to 0-255 range
		Gui, Trades: +LastFound
		if ( A_GuiControl = "ShowTransparency" )
			WinSet, Transparent,% trans
		else
			WinSet, Transparent,% transActive
		if ( A_GuiControlEvent = "Normal" ) {
			IniRead, isActive,% iniFilePath,PROGRAM,Tabs_Number
			if ( isActive > 0 )
				Winset, Transparent,% transActive
			else
				Winset, Transparent,% trans
		}
	return
	
	Gui_Settings_Close:
		Gui, Settings: Hide ; Hide the window while settings are being saved
		GoSub Gui_Settings_Btn_Apply
		Gui, Settings: Destroy
		IniRead, isActive,% iniFilePath,PROGRAM,Tabs_Number
		if ( isActive = 0 && ProgramSettings.Trades_Click_Through = 1 )
			Gui, Trades: +E0x20

		Gui_Trades_Redraw("CREATE")
	return
	
	Gui_Settings_Notifications_Browse:
		FileSelectFile, soundFile, ,% programSFXFolderPath, Select an audio file (%programName%),Audio (*.wav; *.mp3)
		if ( soundFile ) {
			SplitPath, soundFile, soundFileName
			if ( A_GuiControl = "NotifyTradeBrowse" ) {
				GuiControl, Settings:,% NotifyTradeSoundHandler,% soundFileName
				tradesSoundFile := soundFile
			}
			else if ( A_GuiControl = "NotifyWhisperBrowse" ) {
				GuiControl, Settings:,% NotifyWhisperSoundHandler,% soundFileName
				whispersSoundFile := soundFile
			}
			else if ( A_GuiControl = "NotifyJoinedAreaBrowse" ) {
				GuiControl, Settings:,% NotifyJoinedAreaSoundHandler,% soundFileName
				joinedAreaSoundFile := soundFile
			}
		}
	return
	
	Gui_Settings_Btn_Apply:
		Gui, Settings:+OwnDialogs
		Gui, Settings:Submit, NoHide
		SplashTextOn, 300, 20,% ProgramValues.Name,% "Saving your settings..."
;	Trades GUI
		trans := ( ShowTransparency / 100 ) * 255 ; ( value - percentage ) * max // Convert percentage to 0-255 range
		transActive := ( ShowTransparencyActive / 100 ) * 255 ; ( value - percentage ) * max // Convert percentage to 0-255 range
		IniWrite,% trans,% iniFilePath,SETTINGS,Transparency
		IniWrite,% transActive,% iniFilePath,SETTINGS,Transparency_Active
		showMode := ( ShowAlways = 1 ) ? ( "Always" ) : ( ShowInGame = 1 ) ? ( "InGame" ) : ( "Always" )
		IniWrite,% showMode,% iniFilePath,SETTINGS,Show_Mode
		IniWrite,% AutoMinimize,% iniFilePath,SETTINGS,Trades_Auto_Minimize
		IniWrite,% AutoUnMinimize,% iniFilePath,SETTINGS,Trades_Auto_UnMinimize
		IniWrite,% ClickThrough,% iniFilePath,SETTINGS,Trades_Click_Through
		if ( ClickThrough )
			Gui, Trades: +E0x20
		else 
			Gui, Trades: -E0x20
		IniWrite,% SelectLastTab,% iniFilePath,SETTINGS,Trades_Select_Last_Tab
;	Clipboard
		IniWrite,% ClipTab,% iniFilePath,AUTO_CLIP,Clip_On_Tab_Switch
;	Notifications
		IniWrite,% NotifyTradeToggle,% iniFilePath,NOTIFICATIONS,Trade_Toggle
		IniWrite,% NotifyTradeSound,% iniFilePath,NOTIFICATIONS,Trade_Sound
		if ( tradesSoundFile )
			IniWrite,% tradesSoundFile,% iniFilePath,NOTIFICATIONS,Trade_Sound_Path

		IniWrite,% NotifyWhisperToggle,% iniFilePath,NOTIFICATIONS,Whisper_Toggle
		IniWrite,% NotifyWhisperSound,% iniFilePath,NOTIFICATIONS,Whisper_Sound
		if ( whispersSoundFile )
			IniWrite,% whispersSoundFile,% iniFilePath,NOTIFICATIONS,Whisper_Sound_Path

		IniWrite,% NotifyWhisperTray,% iniFilePath,NOTIFICATIONS,Whisper_Tray
		IniWrite,% NotifyWhisperFlash,% iniFilePath,NOTIFICATIONS,Whisper_Flash

		IniWrite,% NotifyJoinedAreaToggle,% iniFilePath,NOTIFICATIONS,JoinedArea_Toggle
		IniWrite,% NotifyJoinedAreaSound,% iniFilePath,NOTIFICATIONS,JoinedArea_Sound
		if ( joinedAreaSoundFile )
			IniWrite,% joinedAreaSoundFile,% iniFilePath,NOTIFICATIONS,JoinedArea_Sound_Path
;	Support Message
		IniWrite,% MessageSupportToggle,% iniFilePath,SETTINGS,Support_Text_Toggle
;	Hotkeys
		Loop 8 {
			index := A_Index
			KEY := "HK" index "_Toggle"
			CONTENT := (index=1)?(Hotkey1_Toggle):(index=2)?(Hotkey2_Toggle):(index=3)?(Hotkey3_Toggle):(index=4)?(Hotkey4_Toggle):(index=5)?(Hotkey5_Toggle):(index=6)?(Hotkey6_Toggle):(index=7)?(Hotkey7_Toggle):(index=8)?(Hotkey8_Toggle):("ERROR")
			IniWrite,% CONTENT,% iniFilePath,HOTKEYS,% KEY

			KEY := "HK" index "_KEY"
			CONTENT := (index=1)?(Hotkey1_KEY):(index=2)?(Hotkey2_KEY):(index=3)?(Hotkey3_KEY):(index=4)?(Hotkey4_KEY):(index=5)?(Hotkey5_KEY):(index=6)?(Hotkey6_KEY):(index=7)?(Hotkey7_KEY):(index=8)?(Hotkey8_KEY):("ERROR")
			IniWrite,% CONTENT,% iniFilePath,HOTKEYS,% KEY

			KEY := "HK" index "_Text"
			CONTENT := (index=1)?(Hotkey1_Text):(index=2)?(Hotkey2_Text):(index=3)?(Hotkey3_Text):(index=4)?(Hotkey4_Text):(index=5)?(Hotkey5_Text):(index=6)?(Hotkey6_Text):(index=7)?(Hotkey7_Text):(index=8)?(Hotkey8_Text):("ERROR")
			IniWrite,% """" CONTENT """",% iniFilePath,HOTKEYS,% KEY ; Quotes allows us to keep the spaces on IniRead
		}
;	Hotkeys Advanced
		Loop 16 {
			index := A_Index
			KEY := "HK" index "_ADV_Toggle"
			CONTENT := (index=1)?(HotkeyAdvanced1_Toggle):(index=2)?(HotkeyAdvanced2_Toggle):(index=3)?(HotkeyAdvanced3_Toggle):(index=4)?(HotkeyAdvanced4_Toggle):(index=5)?(HotkeyAdvanced5_Toggle):(index=6)?(HotkeyAdvanced6_Toggle):(index=7)?(HotkeyAdvanced7_Toggle):(index=8)?(HotkeyAdvanced8_Toggle):(index=9)?(HotkeyAdvanced9_Toggle):(index=10)?(HotkeyAdvanced10_Toggle):(index=11)?(HotkeyAdvanced11_Toggle):(index=12)?(HotkeyAdvanced12_Toggle):(index=13)?(HotkeyAdvanced13_Toggle):(index=14)?(HotkeyAdvanced14_Toggle):(index=15)?(HotkeyAdvanced15_Toggle):(index=16)?(HotkeyAdvanced16_Toggle):("ERROR")
			IniWrite,% CONTENT,% iniFilePath,HOTKEYS_ADVANCED,% KEY

			KEY := "HK" index "_ADV_KEY"
			CONTENT := (index=1)?(HotkeyAdvanced1_KEY):(index=2)?(HotkeyAdvanced2_KEY):(index=3)?(HotkeyAdvanced3_KEY):(index=4)?(HotkeyAdvanced4_KEY):(index=5)?(HotkeyAdvanced5_KEY):(index=6)?(HotkeyAdvanced6_KEY):(index=7)?(HotkeyAdvanced7_KEY):(index=8)?(HotkeyAdvanced8_KEY):(index=9)?(HotkeyAdvanced9_KEY):(index=10)?(HotkeyAdvanced10_KEY):(index=11)?(HotkeyAdvanced11_KEY):(index=12)?(HotkeyAdvanced12_KEY):(index=13)?(HotkeyAdvanced13_KEY):(index=14)?(HotkeyAdvanced14_KEY):(index=15)?(HotkeyAdvanced15_KEY):(index=16)?(HotkeyAdvanced16_KEY):("ERROR")
			IniWrite,% CONTENT,% iniFilePath,HOTKEYS_ADVANCED,% KEY

			KEY := "HK" index "_ADV_Text"
			CONTENT := (index=1)?(HotkeyAdvanced1_Text):(index=2)?(HotkeyAdvanced2_Text):(index=3)?(HotkeyAdvanced3_Text):(index=4)?(HotkeyAdvanced4_Text):(index=5)?(HotkeyAdvanced5_Text):(index=6)?(HotkeyAdvanced6_Text):(index=7)?(HotkeyAdvanced7_Text):(index=8)?(HotkeyAdvanced8_Text):(index=9)?(HotkeyAdvanced9_Text):(index=10)?(HotkeyAdvanced10_Text):(index=11)?(HotkeyAdvanced11_Text):(index=12)?(HotkeyAdvanced12_Text):(index=13)?(HotkeyAdvanced13_Text):(index=14)?(HotkeyAdvanced14_Text):(index=15)?(HotkeyAdvanced15_Text):(index=16)?(HotkeyAdvanced16_Text):("ERROR")
			IniWrite,% """" CONTENT """",% iniFilePath,HOTKEYS_ADVANCED,% KEY ; Quotes allows us to keep the spaces on IniRead
		}
;	Hotkeys Special
		Loop 4 {
			index := A_Index

			KEY := "HK_Special_" index "_Hotkey_Toggle"
			CONTENT := (index=1)?(ChooseNextTabHotkeyToggle):(index=2)?(ChoosePrevTabHotkeyToggle):(index=3)?(CloseCurrentTabHotkeyToggle):(index=4)?(ToggleMinimizeHotkeyToggle):("ERROR")
			IniWrite,% CONTENT,% iniFilePath,HOTKEYS_SPECIAL,% KEY

			KEY := "HK_Special_" index "_Hotkey"
			CONTENT := (index=1)?(ChooseNextTabHotkey):(index=2)?(ChoosePrevTabHotkey):(index=3)?(CloseCurrentTabHotkey):(index=4)?(ToggleMinimizeHotkey):("ERROR")
			IniWrite,% CONTENT,% iniFilePath,HOTKEYS_SPECIAL,% KEY
		}
;	Custom Buttons
		Loop 9 {
			index := A_Index

			KEY := "Button" index "_Hotkey"
			CONTENT := (index=1)?(TradesHK1):(index=2)?(TradesHK2):(index=3)?(TradesHK3):(index=4)?(TradesHK4):(index=5)?(TradesHK5):(index=6)?(TradesHK6):(index=7)?(TradesHK7):(index=8)?(TradesHK8):(index=9)?(TradesHK9):("ERROR")
			IniWrite,% CONTENT,% iniFilePath,CUSTOMIZATION_BUTTONS_ACTIONS,% KEY

			KEY := "Button" index "_Label"
			CONTENT := (index=1)?(TradesLabel1):(index=2)?(TradesLabel2):(index=3)?(TradesLabel3):(index=4)?(TradesLabel4):(index=5)?(TradesLabel5):(index=6)?(TradesLabel6):(index=7)?(TradesLabel7):(index=8)?(TradesLabel8):(index=9)?(TradesLabel9):("ERROR")
			IniWrite,% CONTENT,% iniFilePath,CUSTOMIZATION_BUTTONS_ACTIONS,% KEY

			KEY := "Button" index "_Action"
			CONTENT := (index=1)?(TradesAction1):(index=2)?(TradesAction2):(index=3)?(TradesAction3):(index=4)?(TradesAction4):(index=5)?(TradesAction5):(index=6)?(TradesAction6):(index=7)?(TradesAction7):(index=8)?(TradesAction8):(index=9)?(TradesAction9):("ERROR")
			IniWrite,% CONTENT,% iniFilePath,CUSTOMIZATION_BUTTONS_ACTIONS,% KEY

			KEY := "Button" index "_H"
			CONTENT := (index=1)?(TradesHPOS1):(index=2)?(TradesHPOS2):(index=3)?(TradesHPOS3):(index=4)?(TradesHPOS4):(index=5)?(TradesHPOS5):(index=6)?(TradesHPOS6):(index=7)?(TradesHPOS7):(index=8)?(TradesHPOS8):(index=9)?(TradesHPOS9):("ERROR")
			IniWrite,% CONTENT,% iniFilePath,CUSTOMIZATION_BUTTONS_ACTIONS,% KEY

			KEY := "Button" index "_V"
			CONTENT := (index=1)?(TradesVPOS1):(index=2)?(TradesVPOS2):(index=3)?(TradesVPOS3):(index=4)?(TradesVPOS4):(index=5)?(TradesVPOS5):(index=6)?(TradesVPOS6):(index=7)?(TradesVPOS7):(index=8)?(TradesVPOS8):(index=9)?(TradesVPOS9):("ERROR")
			IniWrite,% CONTENT,% iniFilePath,CUSTOMIZATION_BUTTONS_ACTIONS,% KEY

			KEY := "Button" index "_SIZE"
			CONTENT := (index=1)?(TradesSIZE1):(index=2)?(TradesSIZE2):(index=3)?(TradesSIZE3):(index=4)?(TradesSIZE4):(index=5)?(TradesSIZE5):(index=6)?(TradesSIZE6):(index=7)?(TradesSIZE7):(index=8)?(TradesSIZE8):(index=9)?(TradesSIZE9):("ERROR")
			IniWrite,% CONTENT,% iniFilePath,CUSTOMIZATION_BUTTONS_ACTIONS,% KEY

			KEY := "Button" index "_Mark_Completed"
			CONTENT := (index=1)?(TradesMarkCompleted1):(index=2)?(TradesMarkCompleted2):(index=3)?(TradesMarkCompleted3):(index=4)?(TradesMarkCompleted4):(index=5)?(TradesMarkCompleted5):(index=6)?(TradesMarkCompleted6):(index=7)?(TradesMarkCompleted7):(index=8)?(TradesMarkCompleted8):(index=9)?(TradesMarkCompleted9):("ERROR")
			IniWrite,% CONTENT,% iniFilePath,CUSTOMIZATION_BUTTONS_ACTIONS,% KEY

			KEY := "Button" index "_Message_1"
			CONTENT := (index=1)?(TradesMsg1_1):(index=2)?(TradesMsg1_2):(index=3)?(TradesMsg1_3):(index=4)?(TradesMsg1_4):(index=5)?(TradesMsg1_5):(index=6)?(TradesMsg1_6):(index=7)?(TradesMsg1_7):(index=8)?(TradesMsg1_8):(index=9)?(TradesMsg1_9):("ERROR")
			IniWrite,% """" CONTENT """",% iniFilePath,CUSTOMIZATION_BUTTONS_ACTIONS,% KEY ; Quotes allows us to keep the spaces on IniRead

			KEY := "Button" index "_Message_2"
			CONTENT := (index=1)?(TradesMsg2_1):(index=2)?(TradesMsg2_2):(index=3)?(TradesMsg2_3):(index=4)?(TradesMsg2_4):(index=5)?(TradesMsg2_5):(index=6)?(TradesMsg2_6):(index=7)?(TradesMsg2_7):(index=8)?(TradesMsg2_8):(index=9)?(TradesMsg2_9):("ERROR")
			IniWrite,% """" CONTENT """",% iniFilePath,CUSTOMIZATION_BUTTONS_ACTIONS,% KEY ; Quotes allows us to keep the spaces on IniRead

			KEY := "Button" index "_Message_3"
			CONTENT := (index=1)?(TradesMsg3_1):(index=2)?(TradesMsg3_2):(index=3)?(TradesMsg3_3):(index=4)?(TradesMsg3_4):(index=5)?(TradesMsg3_5):(index=6)?(TradesMsg3_6):(index=7)?(TradesMsg3_7):(index=8)?(TradesMsg3_8):(index=9)?(TradesMsg3_9):("ERROR")
			IniWrite,% """" CONTENT """",% iniFilePath,CUSTOMIZATION_BUTTONS_ACTIONS,% KEY ; Quotes allows us to keep the spaces on IniRead
		}
;	Unicode Buttons
		Loop 5 {
			index := A_Index
			SECT := "CUSTOMIZATION_BUTTONS_UNICODE"

			KEY := "Button_Unicode_" A_Index "_Position"
			CONTENT := (index=1)?(UnicodeBtn1Position):(index=2)?(UnicodeBtn2Position):(index=3)?(UnicodeBtn3Position):(index=4)?(UnicodeBtn4Position):(index=5)?(UnicodeBtn5Position):(index=6)?(UnicodeBtn6Position):("ERROR")
			IniWrite,% CONTENT,% iniFilePath,% SECT,% KEY

			KEY := "Button_Unicode_" A_Index "_Hotkey"
			CONTENT := (index=1)?(UnicodeBtn1Hotkey):(index=2)?(UnicodeBtn2Hotkey):(index=3)?(UnicodeBtn3Hotkey):(index=4)?(UnicodeBtn4Hotkey):(index=5)?(UnicodeBtn5Hotkey):(index=6)?(UnicodeBtn6Hotkey):("ERROR")
			IniWrite,% CONTENT,% iniFilePath,% SECT,% KEY

			KEY := "Button_Unicode_" A_Index "_Hotkey_Toggle"
			CONTENT := (index=1)?(UnicodeBtn1HotkeyToggle):(index=2)?(UnicodeBtn2HotkeyToggle):(index=3)?(UnicodeBtn3HotkeyToggle):(index=4)?(UnicodeBtn4HotkeyToggle):(index=5)?(UnicodeBtn5HotkeyToggle):(index=6)?(UnicodeBtn6HotkeyToggle):("ERROR")
			IniWrite,% CONTENT,% iniFilePath,% SECT,% KEY
		}
;	Appearance Tab
		IniWrite,% ActivePreset,% iniFilePath,CUSTOMIZATION_APPEARANCE,Active_Preset
		IniWrite,% SelectedSkin,% iniFilePath,CUSTOMIZATION_APPEARANCE,Active_Skin

		StringReplace, SkinScaling, SkinScaling,% "%",% "", 1
		SkinScaling := SkinScaling/100
		SkinScaling := Round(SkinScaling, 2)
		IniWrite,% SkinScaling,% iniFilePath,CUSTOMIZATION_APPEARANCE,Scale_Multiplier

		IniWrite,% SelectedFont,% iniFilePath,CUSTOMIZATION_APPEARANCE,Font
		IniWrite,% FontSize,% iniFilePath,CUSTOMIZATION_APPEARANCE,Font_Size_Mode
		IniWrite,% FontSizeCustom,% iniFilePath,CUSTOMIZATION_APPEARANCE,Font_Size_Custom
		IniWrite,% FontQuality,% iniFilePath,CUSTOMIZATION_APPEARANCE,Font_Quality_Mode
		IniWrite,% FontQualityCustom,% iniFilePath,CUSTOMIZATION_APPEARANCE,Font_Quality_Custom

		IniWrite,% BorderColor,% iniFilePath,CUSTOMIZATION_APPEARANCE,Color_Border
		IniWrite,% TitleActiveColor,% iniFilePath,CUSTOMIZATION_APPEARANCE,Color_Title_Active
		IniWrite,% TitleInactiveColor,% iniFilePath,CUSTOMIZATION_APPEARANCE,Color_Title_Inactive
		IniWrite,% TradesInfos1Color,% iniFilePath,CUSTOMIZATION_APPEARANCE,Color_Trades_Infos_1
		IniWrite,% TradesInfos2Color,% iniFilePath,CUSTOMIZATION_APPEARANCE,Color_Trades_Infos_2

		IniWrite,% ButtonNormalColor,% iniFilePath,CUSTOMIZATION_APPEARANCE,Color_Button_Normal
		IniWrite,% ButtonHoverColor,% iniFilePath,CUSTOMIZATION_APPEARANCE,Color_Button_Hover
		IniWrite,% ButtonPressColor,% iniFilePath,CUSTOMIZATION_APPEARANCE,Color_Button_Press

		IniWrite,% TabActiveColor,% iniFilePath,CUSTOMIZATION_APPEARANCE,Color_Tab_Active
		IniWrite,% TabInactiveColor,% iniFilePath,CUSTOMIZATION_APPEARANCE,Color_Tab_Inactive
		IniWrite,% TabHoverColor,% iniFilePath,CUSTOMIZATION_APPEARANCE,Color_Tab_Hover
		IniWrite,% TabPressColor,% iniFilePath,CUSTOMIZATION_APPEARANCE,Color_Tab_Press

		IniWrite,% TabJoinedActiveColor,% iniFilePath,CUSTOMIZATION_APPEARANCE,Color_Tab_Joined_Active
		IniWrite,% TabJoinedInactiveColor,% iniFilePath,CUSTOMIZATION_APPEARANCE,Color_Tab_Joined_Inactive
		IniWrite,% TabJoinedHoverColor,% iniFilePath,CUSTOMIZATION_APPEARANCE,Color_Tab_Joined_Hover
		IniWrite,% TabJoinedPressColor,% iniFilePath,CUSTOMIZATION_APPEARANCE,Color_Tab_Joined_Press

		IniWrite,% TabWhisperActiveColor,% iniFilePath,CUSTOMIZATION_APPEARANCE,Color_Tab_Whisper_Active
		IniWrite,% TabWhisperInactiveColor,% iniFilePath,CUSTOMIZATION_APPEARANCE,Color_Tab_Whisper_Inactive
		IniWrite,% TabWhisperHoverColor,% iniFilePath,CUSTOMIZATION_APPEARANCE,Color_Tab_Whisper_Hover
		IniWrite,% TabWhisperPressColor,% iniFilePath,CUSTOMIZATION_APPEARANCE,Color_Tab_Whisper_Press

;	Declare the new settings
		Disable_Hotkeys()
		settingsArray := Get_Local_Settings()
		Declare_Local_Settings(settingsArray)
		settings := Get_Game_Settings()
		Declare_Game_Settings(settings)
		Enable_Hotkeys()
		SplashTextOff
	return

	Gui_Settings_Size:
		GuiWidth := A_GuiWidth
		GuiHeight := A_GuiHeight
		sleep 10
	return
	
	Gui_Settings_Set_Preferences:
;	Trades GUI
		returnArray := Gui_Settings_Get_Settings_Arrays()
		sectionArray := returnArray.sectionArray
		SETTINGS_HandlersArray := returnArray.SETTINGS_HandlersArray
		SETTINGS_HandlersKeysArray := returnArray.SETTINGS_HandlersKeysArray
		AUTO_CLIP_HandlersArray := returnArray.AUTO_CLIP_HandlersArray
		AUTO_CLIP_HandlersKeysArray := returnArray.AUTO_CLIP_HandlersKeysArray
		HOTKEYS_HandlersArray := returnArray.HOTKEYS_HandlersArray
		HOTKEYS_HandlersKeysArray := returnArray.HOTKEYS_HandlersKeysArray
		NOTIFICATIONS_HandlersArray := returnArray.NOTIFICATIONS_HandlersArray
		NOTIFICATIONS_HandlersKeysArray := returnArray.NOTIFICATIONS_HandlersKeysArray
		HOTKEYS_ADVANCED_HandlersArray := returnArray.HOTKEYS_ADVANCED_HandlersArray
		HOTKEYS_ADVANCED_HandlersKeysArray := returnArray.HOTKEYS_ADVANCED_HandlersKeysArray
		CUSTOMIZATION_BUTTONS_ACTIONS_HandlersArray := returnArray.CUSTOMIZATION_BUTTONS_ACTIONS_HandlersArray
		CUSTOMIZATION_BUTTONS_ACTIONS_HandlersKeysArray := returnArray.CUSTOMIZATION_BUTTONS_ACTIONS_HandlersKeysArray
		CUSTOMIZATION_APPEARANCE_HandlersArray := returnArray.CUSTOMIZATION_APPEARANCE_HandlersArray
		CUSTOMIZATION_APPEARANCE_HandlersKeysArray := returnArray.CUSTOMIZATION_APPEARANCE_HandlersKeysArray
		CUSTOMIZATION_BUTTONS_UNICODE_HandlersArray := returnArray.CUSTOMIZATION_BUTTONS_UNICODE_HandlersArray
		CUSTOMIZATION_BUTTONS_UNICODE_HandlersKeysArray := returnArray.CUSTOMIZATION_BUTTONS_UNICODE_HandlersKeysArray
		HOTKEYS_SPECIAL_HandlersArray := returnArray.HOTKEYS_SPECIAL_HandlersArray
		HOTKEYS_SPECIAL_HandlersKeysArray := returnArray.HOTKEYS_SPECIAL_HandlersKeysArray

		isSettingPreferences := true
		Sleep 10

		for key, element in sectionArray
		{
			sectionName := element
			for key, element in %sectionName%_HandlersKeysArray
			{
				keyName := element
				handler := %sectionName%_HandlersArray[key]

				IniRead, var,% iniFilePath,% sectionName,% keyName
				if ( keyName = "Show_Mode" ) { ; Make sure only one goes through
					GuiControl, Settings:,% Show%var%Handler,1
				}
				else if ( keyName = "Transparency" || keyName = "Transparency_Active" ) { ; Convert to pecentage
					var := ((var - 0) * 100) / (255 - 0)
					GuiControl, Settings:,% %handler%Handler,% var
				}
				else if ( keyName = "Logs_Mode" ) { ; Make sure only one goes through
					GuiControl, Settings:,% Logs%var%Handler,1
				}
				else if ( sectionName = "CUSTOMIZATION_BUTTONS_ACTIONS" ) {
					if RegExMatch(keyName, "_(H|V|SIZE|Action)$") ; Ends with either
					{
						GuiControl, Settings:ChooseString,% %handler%Handler,% var
					}
					else {
						GuiControl, Settings:,% %handler%Handler,% var
						if RegExMatch(keyName, "_Mark_Completed$") {
							RegExMatch(keyName, "\d+", btnID)
							if ProgramSettings["Button" btnID "_Action"] != "Send Message + Close Tab"
								GuiControl, Settings:+Disabled,% %handler%Handler
						}
					}
				}
				else if ( sectionName = "CUSTOMIZATION_APPEARANCE" ) {
					if (keyName = "Active_Preset") {
						GuiControl, Settings:ChooseString,% %handler%Handler,% "|" var
					}
				}
				; 	if keyName in Active_Skin,Font,Font_Size_Mode,Font_Size_Custom,Font_Quality_Mode,Font_Quality_Custom,Active_Preset,Font_Color_Title_Active,Font_Color_Title_Inactive,Font_Color_Trades_Infos_1,Font_Color_Trades_Infos_2,Font_Color_Tabs,Font_Color_Buttons
				; 	{
				; 		if keyName in Font_Size_Custom,Font_Quality_Custom,Font_Color_Title_Active,Font_Color_Title_Inactive,Font_Color_Trades_Infos_1,Font_Color_Trades_Infos_2,Font_Color_Tabs,Font_Color_Buttons
				; 		{
				; 			isUserChangingPreset := true
				; 			Sleep 10
				; 			GuiControl, Settings:,% %handler%Handler,% var
				; 			Sleep 10
				; 			isUserChangingPreset := false
				; 		}
				; 		else {
				; 			GuiControl, Settings:ChooseString,% %handler%Handler,% var
				; 			if ( keyName = "Font_Size_Mode" ) {
				; 				state := (var="Custom")?("Enable"):("Disable")
				; 				GuiControl, Settings:%state%,% FontSizeCustomHandler
				; 			}
				; 			if (keyName = "Font_Quality_Mode") {
				; 				state := (var="Custom")?("Enable"):("Disable")
				; 				GuiControl, Settings:%state%,% FontQualityCustomHandler
				; 			}
				; 		}
				; 	}
				; 	else if (keyName = "Scale_Multiplier")
				; 	{
				; 		var := var*100
				; 		var := Round(var, 0)
				; 		GuiControl, Settings:ChooseString,% %handler%Handler,% var "%"
				; 	}
				; }
				else if ( sectionName = "CUSTOMIZATION_BUTTONS_UNICODE" ) {
					if keyName contains _Position
						GuiControl, Settings:ChooseString,% %handler%Handler,% var
					else
						GuiControl, Settings:,% %handler%Handler,% var
				}
				else if ( var != "ERROR" && var != "" ) { ; Everything else
					GuiControl, Settings:,% %handler%Handler,% var
			}
		}
		Sleep 10
		isSettingPreferences := false
	}
	Return
}

Gui_Settings_Custom_Label_Func(type, controlsArray, btnID, action, label) {
	global TradesGUI_Controls, ProgramSettings, TradesGUI_Values

	if ( type = "TradesBtn" ) {
		controlsToHide := "(?:HPOS|HPOSText|VPOS|VPOSText|SIZE|SIZEText|Label|LabelText|Hotkey|HotkeyText|MarkCompleted|Action|ActionText|MsgEditID|MsgID|Msg1|Msg2|Msg3)"
		controlsToShow := "(?:HPOS" btnID "|HPOSText" btnID "|VPOS" btnID "|VPOSText" btnID "|SIZE" btnID "|SIZEText" btnID "|Label" btnID "|LabelText" btnID "|Hotkey" btnID "|HotkeyText" btnID "|Action" btnID "|ActionText" btnID "|MarkCompleted" btnID ")"

		for key, element in controlsArray {
			if RegExMatch(key, controlsToHide) {
				GuiControl,Settings:Hide,% element
			}
			if RegExMatch(key, controlsToShow) {
				GuiControl,Settings:Show,% element
			}
		}
	}

	if ( type = "TradesLabel" ) {
		GuiControl,Settings:,% controlsArray["Btn" btnID],% label

		if ( ProgramSettings.Active_Skin = "System" ) {
			Loop % TradesGUI_Values.Tabs_Count {
				GuiControl,Trades:,% TradesGUI_Controls["Button_Custom_" btnID "_" A_Index],% label
			}
		}
		else {
			GuiControl,Trades:,% TradesGUI_Controls["Button_Custom_" btnID "_Text"],% label
		}
	}

	if ( type = "TradesAction" || type = "TradesBtn" ) {
		showOrHide := (action="Clipboard Item")?("Hide"):("Show")
		GuiControl,Settings:%showOrHide%,% controlsArray["MsgEditID" btnID]
		GuiControl,Settings:%showOrHide%,% controlsArray["MsgID" btnID]
		GuiControl,Settings:%showOrHide%,% controlsArray["Msg1" btnID]
	}

	if ( type = "TradesAction" ) {
		enableOrDisable := (action="Send Message + Close Tab")?("-Disabled"):("+Disabled")
		GuiControl,Settings:%enableOrDisable%,% controlsArray["MarkCompleted" btnID]
	}
}

Show_Tooltip(ctrlName, ctrlHandler) {
	RegExMatch(ctrlName, "\d+", btnID)
	GuiControlGet, ctrlVar, Settings:,% ctrlHandler
	ToolTip,% ctrlVar
}


Gui_Settings_Get_Settings_Arrays() {
;			Contains all the section/handlers/keys/defaut values for the Settings GUI
;			Return an array containing all those informations
	global ProgramValues

	programSFXFolderPath := ProgramValues.SFX_Folder

	returnArray := Object()
	returnArray.sectionArray := Object() ; contains all the .ini SECTIONS
	returnArray.sectionArray.Insert(0
	, "SETTINGS"
	, "AUTO_CLIP"
	, "HOTKEYS"
	, "NOTIFICATIONS"
	, "HOTKEYS_ADVANCED"
	, "CUSTOMIZATION_BUTTONS_ACTIONS"
	, "CUSTOMIZATION_APPEARANCE"
	, "CUSTOMIZATION_BUTTONS_UNICODE"
	, "HOTKEYS_SPECIAL")

	
	returnArray.SETTINGS_HandlersArray := Object() ; contains all the Gui_Settings HANDLERS from this SECTION
	returnArray.SETTINGS_HandlersArray.Insert(0, "ShowAlways", "ShowInGame", "ShowTransparency", "ShowTransparencyActive", "AutoMinimize", "AutoUnMinimize", "ClickThrough", "SelectLastTab", "MessageSupportToggle")
	returnArray.SETTINGS_HandlersKeysArray := Object() ; contains all the .ini KEYS for those HANDLERS
	returnArray.SETTINGS_HandlersKeysArray.Insert(0, "Show_Mode", "Show_Mode", "Transparency", "Transparency_Active", "Trades_Auto_Minimize", "Trades_Auto_UnMinimize", "Trades_Click_Through", "Trades_Select_Last_Tab", "Support_Text_Toggle")
	returnArray.SETTINGS_KeysArray := Object() ; contains all the individual .ini KEYS
	returnArray.SETTINGS_KeysArray.Insert(0, "Show_Mode", "Transparency", "Trades_GUI_Mode", "Transparency_Active", "Trades_Auto_Minimize", "Trades_Auto_UnMinimize", "Trades_Click_Through", "Trades_Select_Last_Tab", "Support_Text_Toggle")
	returnArray.SETTINGS_DefaultValues := Object() ; contains all the DEFAULT VALUES for the .ini KEYS
	returnArray.SETTINGS_DefaultValues.Insert(0, "Always", "255", "Window", "255", "1", "0", "0", "0", "0")
	
	returnArray.AUTO_CLIP_HandlersArray := Object()
	returnArray.AUTO_CLIP_HandlersArray.Insert(0, "ClipTab")
	returnArray.AUTO_CLIP_HandlersKeysArray := Object()
	returnArray.AUTO_CLIP_HandlersKeysArray.Insert(0, "Clip_On_Tab_Switch")
	returnArray.AUTO_CLIP_KeysArray := Object()
	returnArray.AUTO_CLIP_KeysArray.Insert(0, "Clip_On_Tab_Switch")
	returnArray.AUTO_CLIP_DefaultValues := Object()
	returnArray.AUTO_CLIP_DefaultValues.Insert(0, "1")
	
	returnArray.HOTKEYS_HandlersArray := Object()
	returnArray.HOTKEYS_HandlersKeysArray := Object()
	returnArray.HOTKEYS_KeysArray := Object()
	returnArray.HOTKEYS_DefaultValues := Object()
	keyID := 0
	Loop 8 {
		index := A_Index
		returnArray.HOTKEYS_HandlersArray.Insert(keyID, "Hotkey" index "_Toggle", "Hotkey" index "_Text", "Hotkey" index "_KEY")
		returnArray.HOTKEYS_HandlersKeysArray.Insert(keyID, "HK" index "_Toggle", "HK" index "_Text", "HK" index "_KEY")
		returnArray.HOTKEYS_KeysArray.Insert(keyID, "HK" index "_Toggle", "HK" index "_Text", "HK" index "_KEY")
		hkToggle := (index=1)?(1) : (0)
		hkTxtCmd := (index=1)?("/hideout") : (index=2)?("/kick YourName") : (index=3)?("/oos") : ("Insert Command or Message")
		hkKeyCmd := (index=1)?("F2") : ("")
		returnArray.HOTKEYS_DefaultValues.Insert(keyID, hkToggle, hkTxtCmd, hkKeyCmd, "0", "0", "0")
		keyID+=3
	}

	returnArray.NOTIFICATIONS_HandlersArray := Object()
	returnArray.NOTIFICATIONS_HandlersArray.Insert(0, "NotifyTradeToggle", "NotifyTradeSound", "NotifyWhisperToggle", "NotifyWhisperSound", "NotifyWhisperTray", "NotifyWhisperFlash", "NotifyJoinedAreaToggle", "NotifyJoinedAreaSound")
	returnArray.NOTIFICATIONS_HandlersKeysArray := Object()
	returnArray.NOTIFICATIONS_HandlersKeysArray.Insert(0, "Trade_Toggle", "Trade_Sound", "Whisper_Toggle", "Whisper_Sound", "Whisper_Tray", "Whisper_Flash", "JoinedArea_Toggle", "JoinedArea_Sound")
	returnArray.NOTIFICATIONS_KeysArray := Object()
	returnArray.NOTIFICATIONS_KeysArray.Insert(0, "Trade_Toggle", "Trade_Sound", "Trade_Sound_Path", "Whisper_Toggle", "Whisper_Sound", "Whisper_Sound_Path", "Whisper_Tray", "Whisper_Flash", "JoinedArea_Toggle", "JoinedArea_Sound", "JoinedArea_Sound_Path")
	returnArray.NOTIFICATIONS_DefaultValues := Object()
	returnArray.NOTIFICATIONS_DefaultValues.Insert(0, "1", "WW_MainMenu_Letter.wav", programSFXFolderPath "\WW_MainMenu_Letter.wav", "0", "", "", "1", "0", "0", "", "")

	returnArray.HOTKEYS_ADVANCED_HandlersArray := Object()
	returnArray.HOTKEYS_ADVANCED_HandlersKeysArray := Object()
	returnArray.HOTKEYS_ADVANCED_KeysArray := Object()
	returnArray.HOTKEYS_ADVANCED_DefaultValues := Object()
	keyID := 0
	Loop 16 {
		index := A_Index
		returnArray.HOTKEYS_ADVANCED_HandlersArray.Insert(keyID, "HotkeyAdvanced" index "_Toggle", "HotkeyAdvanced" index "_Text", "HotkeyAdvanced" index "_KEY")
		returnArray.HOTKEYS_ADVANCED_HandlersKeysArray.Insert(keyID, "HK" index "_ADV_Toggle", "HK" index "_ADV_Text", "HK" index "_ADV_KEY")
		returnArray.HOTKEYS_ADVANCED_KeysArray.Insert(keyID, "HK" index "_ADV_Toggle", "HK" index "_ADV_Text", "HK" index "_ADV_KEY")
		hkToggle := 0
		hkTxtCmd := (index=1)?("{Enter}/hideout{Enter}") : (index=2)?("{Enter}/kick YourCharacter{Enter}{Enter}/kick YourOtherCharacter{Enter}") : (index=3)?("{Enter}/oos{Enter}") : ("")
		hkKeyCmd := (index=1)?("F2") : ("")
		returnArray.HOTKEYS_ADVANCED_DefaultValues.Insert(keyID, hkToggle, hkTxtCmd, hkKeyCmd)
		keyID+=3
	}

	returnArray.CUSTOMIZATION_BUTTONS_ACTIONS_HandlersArray := Object()
	returnArray.CUSTOMIZATION_BUTTONS_ACTIONS_HandlersKeysArray := Object()
	returnArray.CUSTOMIZATION_BUTTONS_ACTIONS_KeysArray := Object()
	returnArray.CUSTOMIZATION_BUTTONS_ACTIONS_DefaultValues := Object()
	keyID := 0
	keyID2 := 0
	Loop 9 {
		index := A_Index
		returnArray.CUSTOMIZATION_BUTTONS_ACTIONS_HandlersArray.Insert(keyID
		,"TradesBtn" index
		,"TradesAction" index
		,"TradesHPOS" index
		,"TradesVPOS" index
		,"TradesSIZE" index
		,"TradesLabel" index
		,"TradesHK" index
		,"TradesMsg1_" index
		,"TradesMsg2_" index
		,"TradesMsg3_" index
		,"TradesMarkCompleted" index)

		returnArray.CUSTOMIZATION_BUTTONS_ACTIONS_HandlersKeysArray.Insert(keyID
		, "Button" index "_Label"
		, "Button" index "_Action"
		, "Button" index "_H"
		, "Button" index "_V"
		, "Button" index "_SIZE"
		, "Button" index "_Label"
		, "Button" index "_Hotkey"
		, "Button" index "_Message_1"
		, "Button" index "_Message_2"
		, "Button" index "_Message_3"
		, "Button" index "_Mark_Completed")

		returnArray.CUSTOMIZATION_BUTTONS_ACTIONS_KeysArray.Insert(keyID2
		, "Button" index "_Label"
		, "Button" index "_Action"
		, "Button" index "_H"
		, "Button" index "_V"
		, "Button" index "_SIZE"
		, "Button" index "_Label"
		, "Button" index "_Hotkey"
		, "Button" index "_Message_1"
		, "Button" index "_Message_2"
		, "Button" index "_Message_3"
		, "Button" index "_Mark_Completed")

		btnLabel := (index=1)?("Clipboard Item")
				 :(index=2)?("Ask to Wait")
				 :(index=3)?("Party Invite")
				 :(index=4)?("Thank You")
				 :(index=5)?("Sold It")
				 :(index=6)?("Still Interested?")
				 :(index=7)?("Trade Request")
				 :("[Undefined]")

		btnAction := (index=1)?("Clipboard Item")
				  :(index=2)?("Send Message + Minimize")
				  :(index=3)?("Send Message")
				  :(index=4)?("Send Message + Close Tab")
				  :(index=5)?("Send Message + Close Tab")
				  :(index=6)?("Send Message")
				  :(index=7)?("Send Message"):("")

		btnHotkey := ("")

		btnMsg1 := (index=1)?("")
				:(index=2)?("@%buyerName% Can you wait a moment? Currently busy. (%itemName% listed for %itemPrice%)")
				:(index=3)?("/invite %buyerName%")
				:(index=4)?("/kick %buyerName%")
				:(index=5)?("@%buyerName% Sorry! My %itemName% listed for %itemPrice% is not available anymore!")
				:(index=6)?("@%buyerName% I'm back! Do you still want to buy my %itemName% listed for %itemPrice%?")
				:(index=7)?("/tradewith %buyerName%")
				:("")
		btnMsg2 := (index=1)?("")
				:(index=2)?("")
				:(index=3)?("@%buyerName% My %itemName% listed for %itemPrice% is ready to be picked up!")
				:(index=4)?("@%buyerName% Thank you! Good luck and have fun!")
				:(index=5)?("")
				:(index=6)?("")
				:(index=7)?("")
				:("")
		btnMsg3 := (index=1)?("")
				:(index=2)?("")
				:(index=3)?("")
				:(index=4)?("")
				:(index=5)?("")
				:(index=6)?("")
				:(index=7)?("")
				:("")

		btnMarkCompleted := (index=4)?(1):(0)
		btnH := (index=1)?("Left"):(index=2)?("Center"):(index=3)?("Right"):(index=4)?("Left"):(index=5)?("Right"):(index=6)?:("")
		btnV := (index=1)?("Top"):(index=2)?("Top"):(index=3)?("Top"):(index=4)?("Middle"):(index=5)?("Middle"):(index=6)?:("")
		btnSIZE := (index=1)?("Small"):(index=2)?("Small"):(index=3)?("Small"):(index=4)?("Medium"):(index=5)?("Small"):("Disabled")
		returnArray.CUSTOMIZATION_BUTTONS_ACTIONS_DefaultValues.Insert(keyID2, btnLabel, btnAction, btnH, btnV, btnSIZE, btnLabel, btnHotkey, btnMsg1, btnMsg2, btnMsg3, btnMarkCompleted)
		keyID += 11
		keyID2 += 11
	}

	returnArray.CUSTOMIZATION_BUTTONS_UNICODE_HandlersArray := Object()
	returnArray.CUSTOMIZATION_BUTTONS_UNICODE_HandlersKeysArray := Object()
	returnArray.CUSTOMIZATION_BUTTONS_UNICODE_KeysArray := Object()
	returnArray.CUSTOMIZATION_BUTTONS_UNICODE_DefaultValues := Object()
	keyID := 0
	Loop 5 {
		index := A_Index
		returnArray.CUSTOMIZATION_BUTTONS_UNICODE_HandlersArray.Insert(keyID
		,"UnicodeBtn" index "Position"
		,"UnicodeBtn" index "HotkeyToggle"
		,"UnicodeBtn" index "Hotkey")

		returnArray.CUSTOMIZATION_BUTTONS_UNICODE_HandlersKeysArray.Insert(keyID
		, "Button_Unicode_" index "_Position"
		, "Button_Unicode_" index "_Hotkey_Toggle"
		, "Button_Unicode_" index "_Hotkey")

		returnArray.CUSTOMIZATION_BUTTONS_UNICODE_KeysArray.Insert(keyID
		, "Button_Unicode_" index "_Position"
		, "Button_Unicode_" index "_Hotkey_Toggle"
		, "Button_Unicode_" index "_Hotkey")

		returnArray.CUSTOMIZATION_BUTTONS_UNICODE_DefaultValues.Insert(keyID
		, index
		, 0
		, "")

		keyID += 2
	}

	returnArray.CUSTOMIZATION_APPEARANCE_HandlersArray := Object()
	returnArray.CUSTOMIZATION_APPEARANCE_HandlersKeysArray := Object()
	returnArray.CUSTOMIZATION_APPEARANCE_KeysArray := Object()
	returnArray.CUSTOMIZATION_APPEARANCE_DefaultValues := Object()
	returnArray.CUSTOMIZATION_APPEARANCE_HandlersArray.Insert(0, "ActivePreset", "SelectedSkin", "SkinScaling", "SelectedFont", "FontSize", "FontSizeCustom", "FontQuality", "FontQualityCustom"
															   , "TitleActiveColor", "TitleInactiveColor", "TradesInfos1Color", "TradesInfos2Color"
															   , "BorderColor","ButtonNormalColor","ButtonHoverColor","ButtonPressColor"
															   ,"TabActiveColor","TabInactiveColor","TabHoverColor","TabPressColor"
															   ,"TabJoinedActiveColor","TabJoinedInactiveColor","TabJoinedHoverColor","TabJoinedPressColor"
															   ,"TabWhisperActiveColor","TabWhisperInactiveColor","TabWhisperHoverColor","TabWhisperPressColor")
	returnArray.CUSTOMIZATION_APPEARANCE_HandlersKeysArray.Insert(0, "Active_Preset", "Active_Skin", "Scale_Multiplier", "Font", "Font_Size_Mode", "Font_Size_Custom", "Font_Quality_Mode", "Font_Quality_Custom"
																   ,"Color_Title_Active", "Color_Title_Inactive", "Color_Trades_Infos_1", "Color_Trades_Infos_2"
																   ,"Color_Border","Color_Button_Normal","Color_Button_Hover","Color_Button_Press"
																   ,"Color_Tab_Active","Color_Tab_Inactive","Color_Tab_Hover","Color_Tab_Press"
																   ,"Color_Tab_Joined_Active","Color_Tab_Joined_Inactive","Color_Tab_Joined_Hover","Color_Tab_Joined_Press"
																   ,"Color_Tab_Whisper_Active","Color_Tab_Whisper_Inactive","Color_Tab_Whisper_Hover","Color_Tab_Whisper_Press")
	returnArray.CUSTOMIZATION_APPEARANCE_KeysArray.Insert(0, "Active_Preset", "Active_Skin", "Scale_Multiplier", "Font", "Font_Size_Mode", "Font_Size_Custom", "Font_Quality_Mode", "Font_Quality_Custom"
														   ,"Color_Title_Active", "Color_Title_Inactive", "Color_Trades_Infos_1", "Color_Trades_Infos_2"
														   ,"Color_Border","Color_Button_Normal","Color_Button_Hover","Color_Button_Press"
														   ,"Color_Tab_Active","Color_Tab_Inactive","Color_Tab_Hover","Color_Tab_Press"
														   ,"Color_Tab_Joined_Active","Color_Tab_Joined_Inactive","Color_Tab_Joined_Hover","Color_Tab_Joined_Press"
														   ,"Color_Tab_Whisper_Active","Color_Tab_Whisper_Inactive","Color_Tab_Whisper_Hover","Color_Tab_Whisper_Press")
	returnArray.CUSTOMIZATION_APPEARANCE_DefaultValues.Insert(0, "White", "White", "1", "Segoe UI", "Automatic", "8", "Automatic", "5"
															   ,"FFFFFF", "000000", "000000", "000000"
															   ,"359cfc","000000","000000","000000"
															   ,"000000","000000","000000","000000"
															   ,"000000","000000","000000","000000"
															   ,"000000","000000","000000","000000")

							

	returnArray.HOTKEYS_SPECIAL_HandlersArray := Object()
	returnArray.HOTKEYS_SPECIAL_HandlersKeysArray := Object()	
	returnArray.HOTKEYS_SPECIAL_KeysArray := Object()
	returnArray.HOTKEYS_SPECIAL_DefaultValues := Object()

	returnArray.HOTKEYS_SPECIAL_HandlersArray.Insert(0
	, "ChooseNextTabHotkeyToggle"
	, "ChooseNextTabHotkey"
	, "ChoosePrevTabHotkeyToggle"
	, "ChoosePrevTabHotkey"
	, "CloseCurrentTabHotkeyToggle"
	, "CloseCurrentTabHotkey"
	, "ToggleMinimizeHotkeyToggle"
	, "ToggleMinimizeHotkey")

	keyID := 0
	Loop 4 {
		index := A_Index
		returnArray.HOTKEYS_SPECIAL_HandlersKeysArray.Insert(keyID
		, "HK_Special_" index "_Hotkey_Toggle"
		, "HK_Special_" index "_Hotkey")

		returnArray.HOTKEYS_SPECIAL_KeysArray.Insert(keyID
		, "HK_Special_" index "_Hotkey_Toggle"
		, "HK_Special_" index "_Hotkey")

		returnArray.HOTKEYS_SPECIAL_DefaultValues.Insert(keyID
		, "0"
		, "")

		keyID += 2
	}

	return returnArray
}

Get_Control_ToolTip(controlName) {
;			Retrieves the tooltip for the corresponding control
;			Return a variable conaining the tooltip content
	global ProgramValues

	btnType := RegExReplace(controlName, "\d")

	programName := ProgramValues.Name

; - - - - - - -
;	SETTINGS
; - - - - - - -
	ShowInGame_TT := ShowAlways_TT := "Decide when should the GUI show."
	. "`nAlways show:" A_Tab . A_Tab "Will always appear."
	. "`nOnly show while in game:" A_Tab "Will only appear while the game's window is active."

	ClickThrough_TT := "Clicks will go through the interface while no trades are on queue,"
	. "`nallowing you to click any window behind it."
	ShowTransparency_TT := "Transparency of the interface when no trades are on queue."
	. "`nSetting the value to 0% will effectively make it invisible."
	. "`n`nWhile moving the slider, you can see a preview of the result."
	. "`nUpon releasing the slider, it will revert back to its default transparency based on the current active/inactive state."
	ShowTransparencyActive_TT := "Transparency of the GUI when trades are on queue."
	. "`nThe minimal value is set to 30% to make sure you can still see the window."
	. "`n`nWhile moving the slider, you can see a preview of the result."
	. "`nUpon releasing the slider, it will revert back to its default transparency based on the current active/inactive state."

	SelectLastTab_TT := "Always focus the new tab upon receiving a new trading whisper."

	AutoMinimize_TT := "Minimize the Trades GUI when no trades are on queue."
	AutoUnMinimize_TT := "Un-minimize the Trades GUI upon receiving a trading whisper."
	
	NotifyTradeBrowse_TT := NotifyTradeSound_TT := NotifyTradeToggle_TT := "Play a sound upon receiving a trading whisper."
	. "`nTick the case to enable."
	. "`nClick on [Browse] to select a sound file."
	
	NotifyWhisperBrowse_TT := NotifyWhisperSound_TT := NotifyWhisperToggle_TT := "Play a sound upon receiving a whisper"
	. "`nTick the case to enable."
	. "`nClick on [Browse] to select a sound file."

	NotifyJoinedAreaBrowse_TT := NotifyJoinedAreaSound_TT := NotifyJoinedAreaToggle_TT := "Play a sound when one of your buyers has joined your area"
	. "`nTick the case to enable."
	. "`nClick on [Browse] to select a sound file."
	
	NotifyWhisperTray_TT := "Show a tray notification when you receive"
	. "`na whisper while the game window is not active."

	NotifyWhisperFlash_TT := "Make the game's taskbar icon flash when you receive a whisper"
	. "`nor a buyer joined your area while the game window is not active."
	
	ClipTab_TT := "Put the active tab's Item in your Clipboard"
	. "`nso you can easily CTRL+F CTRL+V in your stash to search for the item."

	MessageSupportToggle_TT := ":)`nOnly triggers for ""Send Message + Close Tab"" buttons.", MessageSupportToggleText_TT := "(:`nOnly triggers for ""Send Message + Close Tab"" buttons."

; - - - - - - - - - - - - - - - - - - -
;	Hotkeys: Basic, Advanced, Special
; - - - - - - - - - - - - - - - - - - -
	Hotkey_Toggle_TT := "Tick the case to enable this hotkey."
	Hotkey_Text_TT := "Message that will be sent upon pressing this hotkey."
	Hotkey_KEY_TT := "Hotkey to trigger this custom command/message."
	Hotkey_CTRL_TT := "Enable CTRL as a modifier for this hotkey."
	Hotkey_ALT_TT := "Enable ALT as a modifier for this hotkey."
	Hotkey_SHIFT_TT := "Enable SHIFT as a modifier for this hotkey."

	HotkeyAdvanced_Toggle_TT := Hotkey_Toggle_TT
	HotkeyAdvanced_KEY_TT := Hotkey_KEY_TT
	HotkeyAdvanced_Text_TT := Hotkey_Text_TT

	ChooseNextTabHotkeyToggle_TT := Hotkey_Toggle_TT
	ChoosePrevTabHotkeyToggle_TT := Hotkey_Toggle_TT
	CloseCurrentTabHotkeyToggle_TT := Hotkey_Toggle_TT
	ToggleMinimizeHotkeyToggle_TT := Hotkey_Toggle_TT

	ChooseNextTabHotkey_TT := "Hotkey to trigger this special action."
	ChoosePrevTabHotkey_TT := ChooseNextTabHotkey_TT
	CloseCurrentTabHotkey_TT := ChooseNextTabHotkey_TT
	ToggleMinimizeHotkey_TT := ChooseNextTabHotkey_TT

; - - - - - - - - - - - - - - -
;	Customization: Appearance
; - - - - - - - - - - - - - - -
	ActivePreset_TT := "Available presets."
	. "`nSelecting a preset will overwrite your settings for this tab."

	ActiveSkin_TT := "Available skins for the Trades GUI."
	SkinScaling_TT := "Scale multiplier used on the Trades GUI."
	. "`nA setting higher than 100% may make the GUI appear slightly blurry."

	SelectedFont_TT := "Available fonts for the Trades GUI."
	FontSize_TT := "Font size used for the Trades GUI."
	. "`nAutomatic means the font size will be set to the recommended size for this font."
	. "`nIt also means the size will be increased when using a non-default scale multiplier."
	FontQuality_TT := "Font quality used for the Trades GUI."
	. "`nWhen a font does not render correctly, change this setting."
	. "`nAutomatic means the font quality will be set to the recommended quality for this font."

	FontColors_TT := "Change the font colors for various elements."

; - - - - - - - - - - - - - - - - -
;	Customization: Custom Buttons
; - - - - - - - - - - - - - - - - -
	TradesHPOS_TT := "Horizontal position of the button."
	. "`nLeft:" A_Tab . A_Tab "The button will be positioned on the left side."
	. "`nCenter:" A_Tab . A_Tab "The button will be positioned on the center."
	. "`nRight:" A_Tab . A_Tab "The button will be positioned on the right side."
	TradesVPOS_TT := "Vertical position of the button."
	. "`nTop:" A_Tab . A_Tab "The button will be positioned on the top row."
	. "`nCenter:" A_Tab . A_Tab "The button will be positioned on the middle row."
	. "`nBottom:" A_Tab . A_Tab "The button will be positioned on the bottom row."
	TradesSIZE_TT := "Size of the button."
	. "`nDisabled:" A_Tab "The button will not appear."
	. "`nSmall:" A_Tab . A_Tab "The button will take one third of the row."
	. "`nMedium:" A_Tab "The button will take two third of the row."
	. "`nLarge:" A_Tab . A_Tab "The button will take the whole row."

	TradesLabel_TT := "Name of the button as it will appear on the interface."
	TradesAction_TT := "Action that will be triggered upon clicking the button."
	. "`nClipboard Item:" A_Tab . A_Tab "Put the current tab's item into the clipboard."
	. "`nSend Message:" A_Tab . A_Tab "Send all the messages you have set for this button."
	. "`nClose Tab:" A_Tab . A_Tab "Close the currently active tab."
	. "`nMinimize:" A_Tab A_TAb "Put the GUI into its minimized state."
	. "`nWrite Message:" A_Tab . A_Tab "Write a single message in chat, without sending it."
	TradesMarkCompleted_TT := "Store the trade's infos in a local file."
	. "`nCan only be used with Send Message + Close Tab."
	TradesHK_TT := "You can use an hotkey to trigger this button."
	. "`nFor the hotkey to work, the button must be shown on the GUI."
	TradesMSG__TT := TradesMsgID_TT := "Cycle between the messages that will be sent upon pressing this button."
	
	try
		controlTip := % %btnType%_TT
	if ( controlTip ) 
		return controlTip
	else 
		controlTip := btnType ; Used to get the control tooltip 
	return controlTip
}

;==================================================================================================================
;
;												STATS GUI
;
;==================================================================================================================

Gui_Stats() {
	static
	global ProgramValues, Remove_ToolTip_OnMouseMove_Values

	ProgramValues.Trades_History_File

	guiWidth := 820
	guiHeight := 500

	allStats := Gui_Trades_Statistics("GET")

	Gui, Stats:Destroy
	Gui, Stats:New, +HwndGuiStatsHandler +SysMenu -MinimizeBox -MaximizeBox +Resize +OwnDialogs +MinSize670x360 +LabelGui_Stats_,% ProgramValues.Name " - My Stats"
	Gui, Stats: Margin, 0, 0
	Gui, Stats: Font,,Segoe UI
	Gui, Stats: Add, GroupBox,% "x10 y10 w" guiWidth-20 " h100 hwndFilteringGroupBoxHandler c000000 Section", Filtering Options
	Gui, Stats: Add, Text,xs+15 ys+25,Buyer:
	Gui, Stats: Add, DropDownList,xp+50 yp-2 w150 vBuyersFilter hwndBuyersFilterHandler gGui_Stats_Filter
	Gui, Stats: Add, Text,xs+15 ys+55,Guild:
	Gui, Stats: Add, DropDownList,xp+50 yp-2 w150 vGuildsFilter hwndGuildsFilterHandler gGui_Stats_Filter
	Gui, Stats: Add, Text,xs+225 ys+25,Item:
	Gui, Stats: Add, DropDownList,xp+50 yp-2 w150 vItemsFilter hwndItemsFilterHandler gGui_Stats_Filter
	Gui, Stats: Add, Text,xs+225 ys+55,Currency:
	Gui, Stats: Add, DropDownList,xp+50 yp-2 w150 vCurrenciesFilter hwndCurrenciesFilterHandler gGui_Stats_Filter
	Gui, Stats: Add, Text,xs+430 ys+25,League:
	Gui, Stats: Add, DropDownList,xp+50 yp-2 w150 vLeaguesFilter hwndLeaguesFilterHandler gGui_Stats_Filter
	Gui, Stats: Add, Text,xs+430 ys+55,Tab:
	Gui, Stats: Add, DropDownList,xp+50 yp-2 w150 vTabsFilter hwndTabsFilterHandler gGui_Stats_Filter
	Gui, Stats: Add, ListView, x0 y120 w%guiWidth% hwndListV h300 gGui_Stats_OnListViewClick AltSubmit,#|Date (YYYY-MM-DD)|Time|Guild|Buyer|Item|Price|League|Tab|Other
;	keys := ["Buyer","Guild","Date_YYYYMMDD","Item","Item_Level","Item_Name","Item_Quality","Location","Location_League","Location_Position","Location_Tab","Other","Price","Time"]

	otherMsgs := {}
	Loop % allStats.Max_Index
	{
		outterIndex := A_Index
		otherMaxIndex := 0
		if (allStats[outterIndex "_Other_1"]) {
			Loop {
				if (allStats[outterIndex "_Other_" A_Index]) {
					otherStr .= allStats[outterIndex "_Other_" A_Index] "`n"
					otherMaxIndex++
				}
				Else
					Break
			}
		}
		otherMsgs.Insert(outterIndex "_Other_MaxIndex", otherMaxIndex)
		otherMsgs.Insert(outterIndex "_Other", otherStr)
		otherStr := ""

		LV_Add("", A_Index
				 , allStats[A_Index "_Date_YYYYMMDD"]
				 , allStats[A_Index "_Time"]
				 , allStats[A_Index "_Guild"]
				 , allStats[A_Index "_Buyer"]
				 , allStats[A_Index "_Item"]
				 , allStats[A_Index "_Price"]
				 , allStats[A_Index "_Location_League"]
				 , allStats[A_Index "_Location_Tab"]
				 , otherMsgs[A_Index "_Other_MaxIndex"] " Messages")
	}
	LV_ModifyCol(1,"Auto")
	LV_ModifyCol(2,"Auto")
	LV_ModifyCol(3,"Auto")
	LV_ModifyCol(4,"Auto")
	LV_ModifyCol(5,"Auto")
	LV_ModifyCol(6,"Auto")
	LV_ModifyCol(7,"Auto")
	LV_ModifyCol(8,"Auto")
	LV_ModifyCol(9,"AutoHdr")
	LV_ModifyCol(10,"AutoHdr")

	Gosub, Gui_Stats_Parse

	Gui, Stats: Show, AutoSize NoActivate
    Return

    Gui_Stats_OnListViewClick:
;	Credits to just me for the function
		If (A_GuiEvent = "Normal") {
			Row := A_EventInfo
			Column := LV_SubItemHitTest(ListV)
			LV_GetText(columnTitle, 0 ,Column)
			if (columnTitle = "Other") {
				LV_GetText(rowID, Row)
				MouseGetPos, mouseX, mouseY
				Remove_ToolTip_OnMouseMove_Values := {X:mouseX, Y:mouseY, Treshold_X:30, Treshold_Y:10}
				ToolTip,% otherMsgs[rowID "_Other"]
				SetTimer, Remove_Tooltip_OnMouseMove, 100
			}
   		}
    return

    Gui_Stats_Filter:
    	Gui, Stats:Submit, NoHide
    	Gui, Stats:+OwnDialogs

	    LV_Delete()
	    Loop % allStats.Max_Index
		{
			filteredBuyer 			:= (BuyersFilter="All")?(BuyersFilter)
									  :(allStats[A_Index "_Buyer"])
			filteredGuild			:= (GuildsFilter="All")?(GuildsFilter)
									  :(allStats[A_Index "_Guild"])

			filteredItem 			:= (ItemsFilter="All")?(ItemsFilter)
									  :(ItemsFilter="Gems" 	&& allStats[A_Index "_Item_Level"])?(ItemsFilter)
									  :(allStats[A_Index "_Item_Name"])
			filteredCurrency		:= (CurrenciesFilter="All")?(CurrenciesFilter)
									  :(allStats[A_Index "_Price"])
			currencyInfos := Gui_Stats_Get_Currency_Name(filteredCurrency) ; Convert to real currency name
			filteredCurrency := currencyInfos.Name


			filteredLeague 			:= (LeaguesFilter="All")?(LeaguesFilter)
									  :(allStats[A_Index "_Location_League"])
			filteredTab				:= (TabsFilter="All")?(TabsFilter)
									  :(allStats[A_Index "_Location_Tab"])

			if (BuyersFilter = filteredBuyer
				&& GuildsFilter = filteredGuild
				&& ItemsFilter = filteredItem
				&& CurrenciesFilter = filteredCurrency
				&& LeaguesFilter = filteredLeague
				&& TabsFilter = filteredTab) {

				LV_Add("", A_Index
						 , allStats[A_Index "_Date_YYYYMMDD"]
						 , allStats[A_Index "_Time"]
						 , allStats[A_Index "_Guild"]
						 , allStats[A_Index "_Buyer"]
						 , allStats[A_Index "_Item"]
						 , allStats[A_Index "_Price"]
						 , allStats[A_Index "_Location_League"]
						 , allStats[A_Index "_Location_Tab"]
						 , otherMsgs[A_Index "_Other_MaxIndex"] " Messages")
			}
		}
    Return

    Gui_Stats_Parse:
    	Loop % allStats.Max_Index
    	{
    		buyer := allStats[A_Index "_Buyer"]
    		if (buyer) {
	    		if buyer not in %onlyBuyers%
	    		{
	    			onlyBuyers .= "," buyer
	    		}
	    	}

    		guild := allStats [A_Index "_Guild"]
    		if (guild) {
	    		if guild not in %onlyGuilds%
	    		{
	    			onlyGuilds .= "," guild
	    		}
	    	}

    		item := allStats[A_Index "_Item_Name"]
    		if (item) {
	    		if item not in %onlyItems%
	    		{
	    			onlyItems .= "," item
	    		}
	    	}

    		currency := allStats[A_Index "_Price"]
    		if (currency) {
    			currencyInfos := Gui_Stats_Get_Currency_Name(currency)
    			currency := currencyInfos.Name
    			if (currencyInfos.Is_Listed) {
	    			if currency not in %onlyCurrency%
	    			{
	    				if (currencyInfos.Is_Listed)
		    				onlyCurrency .= "," currency
		    		}
		    	}
		    	else if !(currencyInfos.Is_Listed) {
		    		if currency not in %unlistedCurrency%
	    				unlistedCurrency .= "," currency
    			}
    		}

    		league := allStats[A_Index "_Location_League"]
    		if (league) {
    			if league not in %onlyLeagues%
    			{
	    			onlyLeagues .= "," league
    			}
    		}

    		tab := allStats[A_Index "_Location_Tab"]
    		if (tab) {
    			if tab not in %onlyTabs%
    			{
	    			onlyTabs .= "," tab
    			}
    		}
    	}

    	listToSort := "onlyCurrency,unlistedCurrency,onlyBuyers,onlyGuilds,onlyItems,onlyLeagues,onlyTabs"
    	Loop, Parse, listToSort,% ","
    	{
 			Sort, %A_LoopField%, Z D,
 			if (A_LoopField = "unlistedCurrency") {
 				%A_LoopField% := "- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -"
 							  . ",      Unknown Currencies      "
 							  . ",- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -"
 							  . "," %A_LoopField%
 			}
 			else {
 				%A_LoopField% := "All," %A_LoopField%
 			}
    	}    	
    	listToSort := ""

    	onlyCurrency .= "," unlistedCurrency
    	onlyBuyers := StrReplace(onlyBuyers, ",", "|")
    	onlyGuilds := StrReplace(onlyGuilds, ",", "|")
    	onlyItems := StrReplace(onlyItems, ",", "|")
    	onlyCurrency := StrReplace(onlyCurrency, ",", "|")
    	onlyLeagues := StrReplace(onlyLeagues, ",", "|")
    	onlyTabs := StrReplace(onlyTabs, ",", "|")
    	GuiControl, Stats:,% BuyersFilterHandler,% onlyBuyers
    	GuiControl, Stats:,% GuildsFilterHandler,% onlyGuilds
    	GuiControl, Stats:,% ItemsFilterHandler,% onlyItems
    	GuiControl, Stats:,% CurrenciesFilterHandler,% onlyCurrency
    	GuiControl, Stats:,% LeaguesFilterHandler,% onlyLeagues
    	GuiControl, Stats:,% TabsFilterHandler,% onlyTabs

	    GuiControl, Stats:ChooseString,% BuyersFilterHandler, All
	    GuiControl, Stats:ChooseString,% GuildsFilterHandler, All
		GuiControl, Stats:ChooseString,% ItemsFilterHandler, All
		GuiControl, Stats:ChooseString,% CurrenciesFilterHandler, All
		GuiControl, Stats:ChooseString,% LeaguesFilterHandler, All
		GuiControl, Stats:ChooseString,% TabsFilterHandler, All
    Return

    Gui_Stats_Size:
    	GuiControl, Stats:Move,% ListV,% "w" A_GuiWidth " h" A_GuiHeight-120
    	GuiControl, Stats:Move,% FilteringGroupBoxHandler,% "w" A_GuiWidth-20
    Return

    Gui_Stats_Close:
    	Gui, Stats:Destroy
    Return
    Gui_Stats_Cancel:
    	Gosub, Gui_Stats_Close
    Return
}

Gui_Stats_Get_Currency_Name(currency) {
/*		Compare the specified currency with poe.trade abridged currency names to retrieve the real currency name.
		When the string is plural, check if the full list of currencies contains its non-plural counterpart.
 */
	global Stats_RealCurrencyNames, Stats_TradeCurrencyNames
	if RegExMatch(currency, "See Offer") {
		isCurrencyListed := False
		Return {Name:currency, Is_Listed:isCurrencyListed}
	}

	currency := RegExReplace(currency, "\d")
	currency = %currency% ; Remove whitespaces
	lastChar := SubStr(currency, 0) ; Get last char
	if (lastChar = "s") ; poeapp adds an "s" for >1 currencies
		StringTrimRight, currencyWithoutS, currency, 1

	if currency not in %Stats_RealCurrencyNames%
	{
		currencyFullName := Stats_TradeCurrencyNames[currency]
		currencyFullName := StrReplace(currencyFullName, "_", " ")
		if (currencyFullName)
			isCurrencyListed := true
	}
	else { ; Currency is in list
		currencyFullName := currency
		isCurrencyListed := true
	}
	if (!currencyFullName && currencyWithoutS) { ; Couldn't retrieve full name, and currency is possibly plural
		if currencyWithoutS in %Stats_RealCurrencyNames% ; Currency is in list, was most likely plural
		{ 
			currencyFullName := currencyWithoutS
			isCurrencyListed := true
		}
	}
	else if !(currencyFullName) { ; Unknown currency name
		Logs_Append(A_ThisFunc, {Currency:currency})
	}

	currencyFullName := (currencyFullName)?(currencyFullName):(currency)
	Return {Name:currencyFullName, Is_Listed:isCurrencyListed}
}

;==================================================================================================================
;
;												UPDATE GUI
;
;==================================================================================================================

Check_Update() {
;			It works by downloading both the new version and the auto-updater
;			then closing the current instancie and renaming the new version
	global ProgramValues

	IniRead, isUsingBeta,% ProgramValues.Ini_File,PROGRAM,Update_Beta, 0
	IniRead, isAutoUpdateEnabled,% ProgramValues.Ini_File,PROGRAM,AutoUpdate, 0
	IniRead, lastTimeUpdated,% ProgramValues.Ini_File,PROGRAM,LastUpdate,% A_Now
	IniRead, lastTimeChecked,% ProgramValues.Ini_File,PROGRAM,LastUpdateCheck,% 1994042612310000

	changeslogsLink 		:= (isUsingBeta)?(ProgramValues.Changelogs_Link_Beta):(ProgramValues.Changelogs_Link)
	versionLinkStable 		:= ProgramValues.Version_Link
	versionLinkBeta 		:= ProgramValues.Version_Link_Beta
	currentVersion 			:= ProgramValues.Version

;	Delete files remaining from updating
	if FileExist(ProgramValues.Updater_File)
		FileDelete,% ProgramValues.Updater_File
	if FileExist(ProgramValues.NewVersion_File)
		FileDelete,% ProgramValues.NewVersion_File

	timeDif := A_Now
	timeDif -= lastTimeChecked, Minutes 
	if !(timeDif > 35) { ; Only check once every 30mins
		IniRead, valStableTag,% ProgramValues.Ini_File,PROGRAM,Version_Stable
		IniRead, valStableDL,% ProgramValues.Ini_File,PROGRAM,Version_Stable_DL
		IniRead, valBetaTag,% ProgramValues.Ini_File,PROGRAM,Version_Beta
		IniRead, valBetaDL,% ProgramValues.Ini_File,PROGRAM,Version_Beta_DL
		ProgramValues.Version_Latest 					:= valStableTag
		ProgramValues.Version_Latest_Download 			:= valStableDL
		ProgramValues.Version_Latest_Beta 				:= valBetaTag
		ProgramValues.Version_Latest_Beta_Download 		:= valBetaDL
		ProgramValues.Version_Online 					:= (isUsingBeta)?(valBetaTag):(valStableTag)
		ProgramValues.Version_Online_Download 			:= (isUsingBeta)?(valBetaDL):(valStableDL)

		isUpdateAvailable := (isUsingBeta && valBetaTag != "ERROR" && valBetaTag != currentVersion)?(true)
						    :(!isUsingBeta && valStableTag != "ERROR" && valStableTag != currentVersion)?(true)
						    :(false)	
		ProgramValues.Update_Available	:= isUpdateAvailable

		if (isUpdateAvailable)
			Tray_Notifications_Show(ProgramValues.Version_Online " is available!", "Left click on this notification to run the automatic download.`nRight click to dismiss it.", {Is_Update:1, Fade_Timer:20000})
		Return
	} 

;	Changelogs file
	Try {
		Changelogs_WinHttpReq := ComObjCreate("WinHttp.WinHttpRequest.5.1")
		Changelogs_WinHttpReq.SetTimeouts("10000", "10000", "10000", "10000")

		Changelogs_WinHttpReq.Open("GET", changeslogsLink, true) ; Using true above and WaitForResponse allows the script to r'emain responsive.
		Changelogs_WinHttpReq.Send()
		Changelogs_WinHttpReq.WaitForResponse(10) ; 10 seconds

		changelogsOnline := Changelogs_WinHttpReq.ResponseText
		changelogsOnline = %changelogsOnline%
		if ( changelogsOnline ) && !( RegExMatch(changelogsOnline, "Not(Found| Found)") ){
			try 
				FileRead, changelogsLocal,% ProgramValues.Changelogs_File
			catch e
				Logs_Append("DEBUG", {String:"[WARNING]: Failed to read file """ ProgramValues.Changelogs_File """. Does the file exist?"})
			if ( changelogsLocal != changelogsOnline ) {
				try
					FileDelete, % ProgramValues.Changelogs_File
				catch e
					Logs_Append("DEBUG", {String:"[WARNING]: Failed to delete file """ ProgramValues.Changelogs_File """. Does the file exist?"})
				UrlDownloadToFile, % changeslogsLink,% ProgramValues.Changelogs_File
			}
		}
	}
	Catch e {
;		Error Logging
		Logs_Append("WinHttpRequest", {Obj:e})
		Tray_Notifications_Show(ProgramValues.Name, "Failed to reach GitHub Changelogs file.`n`nThis will not interfer with the operations of the tool,`nbut changelogs will be unavailable until next launch.")
	}

; Version.txt master
	Try {
		Version_WinHttpReq := ComObjCreate("WinHttp.WinHttpRequest.5.1")
		Version_WinHttpReq.SetTimeouts("10000", "10000", "10000", "10000")

		Version_WinHttpReq.Open("GET", versionLinkStable, true)
		Version_WinHttpReq.Send()
		Version_WinHttpReq.WaitForResponse(10)

		stableOnline := Version_WinHttpReq.ResponseText
		stableOnline = %stableOnline%
		if (stableOnline) && !StringIn(stableOnline, "Not,Found,Error") {
			StringReplace, stableOnline, stableOnline,`n,1
			StringReplace, stableOnline, stableOnline,`r,1
			stableOnline = %stableOnline%
		}
		else 
			stableOnline := "ERROR"
	}
	Catch e {
;		Error Logging
		Logs_Append("WinHttpRequest", {Obj:e})
		Tray_Notifications_Show(ProgramValues.Name, "Failed to reach GitHub latest stable version file.`n`nThis will not interfer with the operations of the tool,`nbut updating to stable will be unavailable.")
	}
; Version.txt dev
	Try {
		Version_WinHttpReq := ComObjCreate("WinHttp.WinHttpRequest.5.1")
		Version_WinHttpReq.SetTimeouts("10000", "10000", "10000", "10000")

		Version_WinHttpReq.Open("GET", versionLinkBeta, true)
		Version_WinHttpReq.Send()
		Version_WinHttpReq.WaitForResponse(10)

		betaOnline := Version_WinHttpReq.ResponseText
		betaOnline = %betaOnline%
		if (betaOnline) && !StringIn(betaOnline, "Not,Found,Error") {
			StringReplace, betaOnline, betaOnline,`n,1
			StringReplace, betaOnline, betaOnline,`r,1
			betaOnline = %betaOnline%
		}
		else
			betaOnline := "ERROR"
	}
	Catch e {
;		Error Logging
		Logs_Append("WinHttpRequest", {Obj:e})
		Tray_Notifications_Show(ProgramValues.Name, "Failed to reach GitHub latest stable version file.`n`nThis will not interfer with the operations of the tool,`nbut updating to stable will be unavailable.")
	}

; Releases API Pre-Release
	Try {
		AllReleases_WinHttpReq := ComObjCreate("WinHttp.WinHttpRequest.5.1")
		AllReleases_WinHttpReq.SetTimeouts("10000", "10000", "10000", "10000")

		Loop 2 { ; 2 pages
			AllReleases_WinHttpReq.Open("GET", "https://api.github.com/repos/" ProgramValues.Github_User "/" ProgramValues.GitHub_Repo "/releases?page=" A_Index, true)
			AllReleases_WinHttpReq.Send()
			AllReleases_WinHttpReq.WaitForResponse(10)

			releasesJSON := AllReleases_WinHttpReq.ResponseText
			parsedReleases := JSON.Load(releasesJSON)
			Loop { ; All resutls from this page
				if !(parsedReleases[A_Index]["tag_name"]) {
					Break
				}
				if (parsedReleases[A_Index]["prerelease"] = true && !latestBetaTag) {
					latestBetaTag := parsedReleases[A_Index]["tag_name"]
					latestBetaDownload := parsedReleases[A_Index]["assets"][1]["browser_download_url"]
				}
				if (parsedReleases[A_Index]["prerelease"] = false && !latestReleaseTag) {
					latestReleaseTag := parsedReleases[A_Index]["tag_name"]
					latestReleaseDownload := parsedReleases[A_Index]["assets"][1]["browser_download_url"]
				}
				if (latestBetaTag && latestReleaseTag) {
					Break
				}
			}
			if (latestBetaTag && latestReleaseTag)
				Break
		}
	}
	Catch e {
		Logs_Append("WinHttpRequest", {Obj:e})
		Tray_Notifications_Show(ProgramValues.Name, "Failed to reach GitHub API.`n`nThis will not interfer with the operations of the tool,`nbut updating will be unavailable.")

		latestBetaTag 		:= "ERROR"
		latestBetaDownload 	:= ""
	}

;	Set version IDs
	if latestReleaseTag contains Not,Found,Error
		apiError := true
	else if !latestReleaseTag
		apiError := true

	dlFallback := "https://github.com/" ProgramValues.GitHub_User "/" ProgramValue.GitHub_Repo "/releases/download/" latestReleaseTag "/POE-Trades-Companion.exe"

	latestReleaseTag 			:= (apiError)?("ERROR"):(latestReleaseTag)
	latestReleaseTag 			:= (latestReleaseTag="ERROR" && stableOnline != "ERROR")?(stableOnline):(latestReleaseTag) ; version.txt fallback
	latestReleaseDownload 		:= (apiError)?("ERROR"):(latestReleaseDownload)
	latestReleaseDownload 		:= (latestReleaseDownload="ERROR")?(ProgramValues.Download_FallBack):(latestReleaseDownload) ; fallback download
	
	latestBetaTag 				:= (apiError)?("ERROR"):(latestBetaTag)
	latestBetaTag 				:= (latestBetaTag="ERROR" && betaOnline != "ERROR")?(betaOnline):(latestBetaTag)
	latestBetaDownload 			:= (apiError)?("ERROR"):(latestBetaDownload)
	latestBetaDownload 			:= (latestBetaDownload="ERROR")?(ProgramValues.Download_FallBack_Beta):(latestBetaDownload)

	isUpdateAvailable 			:= (isUsingBeta && latestBetaTag != "ERROR" && latestBetaTag != currentVersion)?(true)
								  :(!isUsingBeta && latestReleaseTag != "ERROR" && latestReleaseTag != currentVersion)?(true)
								  :(false)							  

	ProgramValues.Version_Latest 					:= latestReleaseTag
	ProgramValues.Version_Latest_Download 			:= latestReleaseDownload
	ProgramValues.Version_Latest_Beta				:= latestBetaTag
	ProgramValues.Version_Latest_Beta_Download 		:= latestBetaDownload

	ProgramValues.Version_Online 					:= (isUsingBeta)?(latestBetaTag):(latestReleaseTag)
	ProgramValues.Version_Online_Download 			:= (isUsingBeta)?(latestBetaDownload):(latestReleaseDownload)

	ProgramValues.Update_Available 					:= isUpdateAvailable

	IniWrite,% latestReleaseTag,% ProgramValues.Ini_File,PROGRAM,Version_Stable
	IniWrite,% """" latestReleaseDownload """",% ProgramValues.Ini_File,PROGRAM,Version_Stable_DL
	IniWrite,% latestBetaTag,% ProgramValues.Ini_File,PROGRAM,Version_Beta
	IniWrite,% """" latestBetaDownload """",% ProgramValues.Ini_File,PROGRAM,Version_Beta_DL
	IniWrite,% A_Now,% ProgramValues.Ini_File,PROGRAM,LastUpdateCheck

	if ( isUpdateAvailable ) {
		if (isAutoUpdateEnabled = 1) {
			timeDif := A_Now
			EnvSub, timeDif,% lastTimeUpdated, Seconds
			if (timeDif > 61 || !timeDif) { ; !timeDif means var was not in YYYYMMDDHH24MISS format 
				Tray_Notifications_Show(ProgramValues.Version_Online " is available!", "Auto-updating is enabled. Downloading the updater...")
				Download_Updater()
			}
		}
		else {
			Tray_Notifications_Show(ProgramValues.Version_Online " is available!", "Left click on this notification to run the automatic download.`nRight click to dismiss it.", {Is_Update:1, Fade_Timer:20000})
		}
	}
	SetTimer, Check_Update, -8400000
}

;==================================================================================================================
;
;												ABOUT GUI
;
;==================================================================================================================

Gui_About() {
/*		Lastest versions and changelogs
		Hall of Fame
*/
	static
	global ProgramValues

	iniFilePath := ProgramValues.Ini_File, programName := ProgramValues.Name
	verCurrent := ProgramValues.Version, verLatest := ProgramValues.Version_Latest
	isUpdateAvailable := ProgramValues.Update_Available, onlineVersionAvailable := ProgramValues.Version_Online

	IniRead, isUsingBeta,% iniFilePath,PROGRAM,Update_Beta
	IniRead, isAutoUpdateEnabled,% iniFilePath,PROGRAM,AutoUpdate

	guiWidth := 520
	guiHeight := 425

	tab1Width := guiWidth, tab1Height := guiheight
	tab2width := guiWidth, tab2Height := 350

	Gui, About:Destroy
	Gui, About:New, +HwndaboutGuiHandler +AlwaysOnTop +SysMenu -MinimizeBox -MaximizeBox +OwnDialogs +LabelGui_About_,% programName " by lemasato v" verCurrent
	Gui, About:Font, ,Consolas

	Gui, About:Add, Tab3,% "x0 y0 w" guiWidth+2 " h" guiHeight+1 " vTab hwndhTab gGui_About_OnTabSwitch",Updates|Hall of Fame
	Gui, About:Tab, Updates

	groupText := (isUpdateAvailable)?("Update v" onlineVersionAvailable " available."):("No update available.")
	Gui, About:Add, GroupBox, w500 h100 xm y+10 Section c000000 hwndUpdateAvailableTextHandler,% groupText
	Gui, About:Add, Text, xs+20 ys+20,% "Current version: " A_Tab A_Tab verCurrent

	Gui, About:Add, Button,x+20 yp-5 w80 h20 gGui_About_Check_Update,Check Update
	IniRead, lastTimeChecked,% iniFilePath,PROGRAM,LastUpdateCheck
	timeDif := A_Now
	timeDif -= lastTimeChecked, Minutes 
	Gui, About:Add, Text,x+5 yp+3,(%timeDif% mins ago)

	Gui, About:Add, Text, xs+20 ys+40 hwndLastestVersionTextHandler,% "Latest Version (Stable): " A_Tab ProgramValues.Version_Latest
	if (isUpdateAvailable && !isUsingBeta) {
		GuiControl, About:+cBlue +Redraw,% LastestVersionTextHandler
		Gui, About:Add, Button,x+25 yp-5 w80 h20 gGui_About_Update,Update
	}
	Gui, About:Add, Text, xs+20 ys+55 hwndLastestVersionBetaTextHandler,% "Latest Version (Beta): " A_Tab A_Tab ProgramValues.Version_Latest_Beta
	if (isUpdateAvailable && isUsingBeta) {
		GuiControl, About:+cBlue +Redraw,% LastestVersionBetaTextHandler
		Gui, About:Add, Button,x+25 yp-5 w80 h20 gGui_About_Update,Update
	}
	if ( isUpdateAvailable ) {
		GuiControl, About:+cBlue +Redraw,% UpdateAvailableTextHandler
	}
	Gui, About:Add, CheckBox,xs+20 ys+75 vUpdateAutomatically,Enable automatic updates
	Gui, About:Add, CheckBox,xp+200 yp vUpdateBeta,Enable BETA (Requires reloading)
	if ( isAutoUpdateEnabled = 1 )
		GuiControl, About:,UpdateAutomatically,1
	if ( isUsingBeta = 1 )
		GuiControl, About:,UpdateBeta,1

	FileRead, changelogText,% ProgramValues.Changelogs_File
	allChanges := Object()
	allVersions := ""
	Loop {
		if RegExMatch(changelogText, "sm)\\\\.*?--(.*?)--(.*?)//(.*)", subPat) {
			version%A_Index% := subPat1, changes%A_Index% := subPat2, changelogText := subPat3
			StringReplace, changes%A_Index%, changes%A_Index%,`n,% "",0			
			allVersions .= version%A_Index% "|"
			allChanges.Insert(changes%A_Index%)
		}
		else
			break
	}
	Gui, About:Add, DropDownList, xm y+20 Section w500 gVersion_Change AltSubmit vVerNum hwndVerNumHandler R10,%allVersions%
	Gui, About:Add, Edit, Section xs vChangesText hwndChangesTextHandler wp R15 ReadOnly,% "Retrieving the changelogs..."
	GuiControl, About:Choose,%VerNumHandler%,1
	
	Gui, About:Add, Text, xm y+35 Section ,See on:
	Gui, About:Add, Link, gGitHub_Link ys,% "<a href="""">GitHub</a>"
	Gui, About:Add, Text, ys,% "-"
	Gui, About:Add, Link, gReddit_Link ys,% "<a href="""">Reddit</a>"
	Gui, About:Add, Text, ys,% "-"
	Gui, About:Add, Link, gGGG_Link ys,% "<a href="""">GGG</a>"

	Gui, About:Add, Picture,% "gSupport_Link x400 ys-25 hwndhIMG_Paypal",% ProgramValues.Others_Folder "\DonatePaypal.png"
	local coords := Get_Control_Coords("About", hIMG_Paypal)
	GuiControl, About:Move,% hIMG_Paypal,% "x" guiWidth-coords.W-10

	Gui, About:Tab, Hall of Fame
	Gui, About:Add, GroupBox, w500 h50 xm y+10 Section c000000,% "The Hall of Fame"
	Gui, About:Add, Text, xp ys+20 wp Center BackgroundTrans,% "Thank you for your support!"
	Gui, About:Add, Edit, xm y+25 vEDIT_Supporters hwndhEDIT_Supporters w500 R15 ReadOnly,% "Retrieving the Hall of Fame..."

	Gui, About:Add, Text, xm y+35 Section ,See on:
	Gui, About:Add, Link, gGitHub_Link ys,% "<a href="""">GitHub</a>"
	Gui, About:Add, Text, ys,% "-"
	Gui, About:Add, Link, gReddit_Link ys,% "<a href="""">Reddit</a>"
	Gui, About:Add, Text, ys,% "-"
	Gui, About:Add, Link, gGGG_Link ys,% "<a href="""">GGG</a>"
	
	Gui, About:Add, Picture,% "gSupport_Link x400 ys-25 hwndhIMG_Paypal2",% ProgramValues.Others_Folder "\DonatePaypal.png"
	local coords := Get_Control_Coords("About", hIMG_Paypal2)
	GuiControl, About:Move,% hIMG_Paypal2,% "x" guiWidth-coords.W-10

	Gui, About:Show, w%guiWidth% h%guiHeight%

	GoSub, Version_Change
	GoSub Get_Donators
	return

	Gui_About_OnTabSwitch:
		Gui, About:Submit, NoHide
		if (Tab = "Updates")
			Gui, About:Show, w%tab1Width% h%tab1Height%
		else if (Tab = "Hall of Fame")
			Gui, About:Show, w%tab2Width% h%tab2Height%
	Return

	Get_Donators:
	Try {
;		Retrieve from online API
		local WinHttpReq := ComObjCreate("WinHttp.WinHttpRequest.5.1")
		WinHttpReq.SetTimeouts(10000, 10000, 10000, 10000)
		WinHttpReq.Open("GET", "https://github.com/lemasato/POE-Trades-Companion/wiki/Support", true) ; Using true above and WaitForResponse allows the script to r'emain responsive.
		WinHttpReq.Send()
		WinHttpReq.WaitForResponse(10) ; 10 seconds
		local html := WinHttpReq.ResponseText

		if RegExMatch(html,"\<table\>(.*)\<\/table\>", match) {
			Loop, Parse, match,`n
			{
				local supporter
				if RegExMatch(A_LoopField,"\<td\>(.*?)\<\/td\>", supporter) {
					supporter := StrReplace(supporter, "<td>")
					supporter := StrReplace(supporter, "</td>")
					local supporters .= supporter "`n"
				}
			}
		}
		Sort, supporters, D`n
		GuiControl, About:,% hEDIT_Supporters,% supporters
	}
	Catch e { ; Cannot reach. Use internal leagues instead.
		Logs_Append("WinHttpRequest", {Obj:e})
		Tray_Notifications_Show(ProgramValues.Name, "Failed to retrieve the Hall of Fame")
	}
	Return
	
	Version_Change:
		Gui, About:Submit, NoHide
		GuiControl, About:,%ChangesTextHandler%,% allChanges[verNum]
	return

	Reddit_Link:
		Run,% ProgramValues.Link_Reddit
	Return

	Github_Link:
		Run,% ProgramValues.Link_GitHub
	Return

	GGG_Link:
		Run,% ProgramValues.Link_GGG
	Return

	Support_Link:
		Run,% ProgramValues.Link_Support
	Return

	Gui_About_Check_Update:
		autoUpdateBak := isAutoUpdateEnabled
		IniWrite,% 1994042612310000,% iniFilePath,PROGRAM,LastUpdateCheck
		if (autoUpdateBak) {
			IniWrite,0,% iniFilePath,PROGRAM,AutoUpdate
			UpdateAutomatically := 0
		}
		GoSub Gui_About_Close
		Check_Update()
		Gui_About()
		if (autoUpdateBak)
			IniWrite,1,% iniFilePath,PROGRAM,AutoUpdate
		autoUpdateBak := 
	Return

	Gui_About_Update:
		Download_Updater()
	Return

	Gui_About_Close:
		Gui, About:Submit
		IniWrite,% UpdateAutomatically,% iniFilePath,PROGRAM,AutoUpdate
		IniWrite,% UpdateBeta,% iniFilePath,PROGRAM,Update_Beta
		if (isUsingBeta != UpdateBeta) ; Reset check update
			IniWrite,% 1994042612310000,% iniFilePath,PROGRAM,LastUpdateCheck
	Return
}

;==================================================================================================================
;											INI SETTINGS
;==================================================================================================================

Get_Game_Settings() {
	global ProgramValues

	gameFile := ProgramValues.Game_Ini_File
	gameFileCopy := ProgramValues.Game_Ini_File_Copy

	if !FileExist(gameFile) {
		String := "File Not Found: """ gameFile """"
		Logs_Append("DEBUG", {String:String})
	}

	FileRead, fileContent,% gameFile
	if !(fileContent || ErrorLevel) {
		String := "Unable to retrieve content from file: """ gameFile """"
		Logs_Append("DEBUG", {String:String})
	}

	File := FileOpen(gameFileCopy, "w", "UTF-16")
	File.Write(fileContent)
	if (ErrorLevel) {
		String := "Could not Write in file: " gameFileCopy
		Logs_Append("DEBUG", {String:String})
		doAlternative := 1
	}
	File.Close()

	if (doAlternative && fileContent) {
		fileEncode := A_FileEncoding
		FileEncoding,UTF-16

		FileDelete,% gameFileCopy
		FileAppend,% fileContent,% gameFileCopy

		FileEncoding,% fileEncode
	}

	IniRead, chatKeySC,% gameFileCopy,ACTION_KEYS,chat
	IniRead, fullscreen,% gameFileCopy,DISPLAY,fullscreen

	chatKeyVK := StringToHex(chr(chatKeySC+0))
	chatKeyName := GetKeyName("VK" chatKeyVK)

	returnObj := { "Chat_SC" : chatKeySC
				  ,"Chat_VK" : chatKeyVK
				  ,"Chat_Name" : chatKeyName
				  ,"Fullscreen" : fullscreen }

	return returnObj
}

Declare_Game_Settings(settings) {
	global GameSettings

	for key, value in settings {
		GameSettings.Insert(key, value)
	}
}

Update_Local_Settings() {
/*	Cross-release changes that need updating
*/
	global ProgramValues
	iniFile := ProgramValues.Ini_File

;	This setting is unreliable in cases where the user updates to 1.12 (or higher) then reverts back to pre-1.12 since the setting was only added as of 1.12
	IniRead, priorVer,% iniFile,% "PROGRAM",% "Version",% "UNKNOWN"
	priorVerNum := (priorVer="UNKNOWN")?(ProgramValues.Version):(priorVer)

	subVersions := StrSplit(priorVersionNum, ".")
	mainVer := subVersions[1], releaseVer := subVersions[2], patchVer := subVersions[3]

;	Example. This will handle changes that happened between 1.12 and current.
	if (releaseVer < 12) {

	}

	if (priorVer = "UNKNOWN") { ; Pre 1.12. Delete skin folders to remove old assets.
		FileRemoveDir,% ProgramValues.Skins_Folder "\System", 1
		FileRemoveDir,% ProgramValues.Skins_Folder "\Path of Exile", 1
	}



/* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * 
* * * * * * * * * * * * * *  		1.12					* * *
 * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * 
*/
/*	More customization was added. Keys changed.
	Previously, there was one single setting for Tabs and Buttons colours.
		Keys would start with the Font_Color_ prefix.
	Now, there are multiple colours available, based on the button state.
		Keys start with the Color_ prefix

	We delete those old Font_Color_ keys.
*/
	sect := "CUSTOMIZATION_APPEARANCE"
	keysToDel := ["Font_Color_Title_Active","Font_Color_Title_Inactive","Font_Color_Trades_Infos_1"
				 ,"Font_Color_Trades_Infos_2","Font_Color_Tabs","Font_Color_Buttons"]
	IniRead, activeColor,% iniFile,% sect,% "Font_Color_Title_Active"
	if (activeColor != "ERROR") {
		for index, keyName in keysToDel {
			IniDelete,% iniFile,% sect,% keyName
		}
	}

/*	System Skin
	1.12: System skin is removed, replaced with a new "White" skin.

	If the active preset or skin is System, or if updating from a pre-1.12 version:
	we delete the corresponding keys.
	We delete the System skin local folder.
*/
	sect := "CUSTOMIZATION_APPEARANCE"
	IniRead, activePreset,% iniFile,% sect,% "Active_Preset"
	IniRead, activeSkin,% iniFile,% sect,% "Active_Skin"
	if (activePreset = "System" || activeSkin = "System" || priorVer = "UKNOWN") {
		IniDelete,% iniFile,% sect,% "Active_Preset"
		IniDelete,% iniFile,% sect,% "Active_Skin"
	}
	if InStr(FileExist(ProgramValues.Skins_Folder "\System"), "D") {
		FileRemoveDir,% ProgramValues.Skins_Folder "\System", 1
	}

/* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * 
* * * * * * * * * * * * * *  		1.10					* * *
 * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * 
*/
/* 	Hotkeys_Mode
	1.10: This setting was removed.
	Previously, the hotkeys would share the same tab. Pressing on a "Switch" button would
		hide re-create the Settings with the selected mode.
	Now, both have their own tab, and the user can use Basic and Advanced hotkeys together.

	For this reason, based on the mode, we have to make sure the hotkey toggle is switched off.
*/
	IniRead, hotkeysMode,% iniFile, SETTINGS, Hotkeys_Mode
	if ( hotkeysMode && hotkeysMode != "ERROR" ) {
		if ( hotkeysMode = "Basic" ) {
			Loop {
				IniRead, exists,% iniFile, HOTKEYS_ADVANCED, HK%A_Index%_ADV_Toggle
				if (exists = "ERROR")
					Break
				IniWrite, 0, % iniFile, HOTKEYS_ADVANCED, HK%A_Index%_ADV_Toggle
			}
		}
		else if ( hotkeysMode = "Advanced" ) {
			Loop {
				IniRead, exists,% iniFile, HOTKEYS, HK%A_Index%_Toggle
				if (exists = "ERROR")
					Break
				IniWrite, 0, % iniFile, HOTKEYS, HK%A_Index%_Toggle
			}
		}
		IniDelete,% iniFile, SETTINGS, Hotkeys_Mode
	}

/*	CTRL / ALT / SHIFT States
	1.10: This setting was removed.
	Previously, those modifiers would be treated as separate checkboxes.
	Now, it is handled by the hotkey control.

	For this reason, based on the modifiers, we have to modify the original hotkey.
*/
	Loop {
		IniRead, modCtrl,% iniFile, HOTKEYS, HK%A_Index%_CTRL
		IniRead, modAlt,% iniFile, HOTKEYS, HK%A_Index%_ALT
		IniRead, modShift,% iniFile, HOTKEYS, HK%A_Index%_SHIFT

		if (modCtrl = "ERROR")
			Break

		modCtrl := (modCtrl=1)?("^"):("")
		modAlt := (modAlt=1)?("!"):("")
		modShift := (modShift=1)?("+"):("")
		modifiers := modCtrl modAlt modShift

		IniRead, hk,% iniFile, HOTKEYS, HK%A_Index%_KEY
		if ( hk != "ERROR" && hk != "" ) {
			IniWrite,% modifiers . hk,% iniFile, HOTKEYS, HK%A_Index%_KEY
		}
		IniDelete,% iniFile, HOTKEYS, HK%A_Index%_CTRL
		IniDelete,% iniFile, HOTKEYS, HK%A_Index%_ALT
		IniDelete,% iniFile, HOTKEYS, HK%A_Index%_SHIFT
	}

/*	Opening changelogs, after updating
*/
	IniRead, openChangelogs,% iniFile,PROGRAM,Show_Changelogs, 0
	if ( openChangelogs = 1 ) {
		Check_Update()
		Gui_About()
		IniWrite, 0,% iniFile,PROGRAM,Show_Changelogs
	}
}

Get_Local_Settings() {
;			Retrieve the INI settings
;			Return a big array containing arrays for each section containing the keys and their values
	global ProgramValues

	iniFilePath := ProgramValues.Ini_File
	
	returnArray := Object()
	returnArray := Gui_Settings_Get_Settings_Arrays()
	
	sectionArray := returnArray.sectionArray
	SETTINGS_KeysArray := returnArray.SETTINGS_KeysArray
	AUTO_CLIP_KeysArray := returnArray.AUTO_CLIP_KeysArray
	HOTKEYS_KeysArray := returnArray.HOTKEYS_KeysArray
	NOTIFICATIONS_KeysArray := returnArray.NOTIFICATIONS_KeysArray
	HOTKEYS_ADVANCED_KeysArray := returnArray.HOTKEYS_ADVANCED_KeysArray
	CUSTOMIZATION_BUTTONS_ACTIONS_KeysArray := returnArray.CUSTOMIZATION_BUTTONS_ACTIONS_KeysArray
	CUSTOMIZATION_APPEARANCE_KeysArray := returnArray.CUSTOMIZATION_APPEARANCE_KeysArray
	CUSTOMIZATION_BUTTONS_UNICODE_KeysArray := returnArray.CUSTOMIZATION_BUTTONS_UNICODE_KeysArray
	HOTKEYS_SPECIAL_KeysArray := returnArray.HOTKEYS_SPECIAL_KeysArray
	
	returnArray.KEYS := Object()
	returnArray.VALUES := Object()
	for key, element in sectionArray
	{
		sectionName := element
		for key, element in %sectionName%_KeysArray
		{
			keyName := element
			IniRead, var,% iniFilePath,% sectionName,% keyName
			returnArray.KEYS.Insert(keyName)
			returnArray.VALUES.Insert(var)
		}
	}
	return returnArray
} 

Set_Local_Settings(){
;			Set the default INI settings if they do not exist
	global ProgramValues

	iniFilePath := ProgramValues.Ini_File, programPID := ProgramValues.PID

;	Set the PID and filename, used for the auto updater
	IniWrite,% programPID,% iniFilePath,PROGRAM,PID
	IniWrite,% A_ScriptName,% iniFilePath,PROGRAM,FileName

	HiddenWindows := A_DetectHiddenWindows
	DetectHiddenWindows On
	WinGet, fileProcessName, ProcessName, ahk_pid %programPID%
	IniWrite,% fileProcessName,% iniFilePath,PROGRAM,FileProcessName
	DetectHiddenWindows, %HiddenWindows%

;	Set current version, used for Update_Local_Settings()
	IniWrite,% ProgramValues.Version,% iniFilePath,% "PROGRAM",% "Version"

;	Set beta state, if version contains BETA
	if ProgramValues.Version contains BETA
		IniWrite, 1,% iniFilePath,% "PROGRAM",% "Update_Beta"
	else
		IniWrite, 0,% iniFilePath,% "PROGRAM",% "Update_Beta"

;	Retrieve the settings arrays
	settingsArray := Gui_Settings_Get_Settings_Arrays()
	sectionArray := settingsArray.sectionArray
	SETTINGS_KeysArray := settingsArray.SETTINGS_KeysArray
	SETTINGS_DefaultValues := settingsArray.SETTINGS_DefaultValues
	AUTO_CLIP_KeysArray := settingsArray.AUTO_CLIP_KeysArray
	AUTO_CLIP_DefaultValues := settingsArray.AUTO_CLIP_DefaultValues
	HOTKEYS_KeysArray := settingsArray.HOTKEYS_KeysArray
	HOTKEYS_DefaultValues := settingsArray.HOTKEYS_DefaultValues
	NOTIFICATIONS_KeysArray := settingsArray.NOTIFICATIONS_KeysArray
	NOTIFICATIONS_DefaultValues := settingsArray.NOTIFICATIONS_DefaultValues
	HOTKEYS_ADVANCED_KeysArray := settingsArray.HOTKEYS_ADVANCED_KeysArray
	HOTKEYS_ADVANCED_DefaultValues := settingsArray.HOTKEYS_ADVANCED_DefaultValues
	CUSTOMIZATION_BUTTONS_ACTIONS_KeysArray := settingsArray.CUSTOMIZATION_BUTTONS_ACTIONS_KeysArray
	CUSTOMIZATION_BUTTONS_ACTIONS_DefaultValues := settingsArray.CUSTOMIZATION_BUTTONS_ACTIONS_DefaultValues
	CUSTOMIZATION_APPEARANCE_KeysArray := settingsArray.CUSTOMIZATION_APPEARANCE_KeysArray
	CUSTOMIZATION_APPEARANCE_DefaultValues := settingsArray.CUSTOMIZATION_APPEARANCE_DefaultValues
	CUSTOMIZATION_BUTTONS_UNICODE_KeysArray := settingsArray.CUSTOMIZATION_BUTTONS_UNICODE_KeysArray
	CUSTOMIZATION_BUTTONS_UNICODE_DefaultValues := settingsArray.CUSTOMIZATION_BUTTONS_UNICODE_DefaultValues
	HOTKEYS_SPECIAL_KeysArray := settingsArray.HOTKEYS_SPECIAL_KeysArray
	HOTKEYS_SPECIAL_DefaultValues := settingsArray.HOTKEYS_SPECIAL_DefaultValues
;	Set the value for each key
	for key, element in sectionArray
	{
		sectionName := element
		for key, element in %sectionName%_KeysArray
		{
			keyName := element
			value := %sectionName%_DefaultValues[key]
			IniRead, var,% iniFilePath,% sectionName,% keyName
			if ( var = "ERROR" || var = "0.00" ) {
				IniWrite,% value,% iniFilePath,% sectionName,% keyName
			}
		}
	}
}

Declare_Local_Settings(iniArray) {
;			Declare the settings to global variables
	global ProgramSettings

	for key, element in iniArray.KEYS {
		value := iniArray.VALUES[key]
		ProgramSettings.Insert(element, value) ;access value using: ProgramSettings["element"]
	}
}

;==================================================================================================================
;
;												HOTKEYS
;
;==================================================================================================================

Hotkeys_Basic_1:
	Hotkeys_Handler(A_ThisLabel)
Return
Hotkeys_Basic_2:
	Hotkeys_Handler(A_ThisLabel)
Return
Hotkeys_Basic_3:
	Hotkeys_Handler(A_ThisLabel)
Return
Hotkeys_Basic_4:
	Hotkeys_Handler(A_ThisLabel)
Return
Hotkeys_Basic_5:
	Hotkeys_Handler(A_ThisLabel)
Return
Hotkeys_Basic_6:
	Hotkeys_Handler(A_ThisLabel)
Return
Hotkeys_Basic_7:
	Hotkeys_Handler(A_ThisLabel)
Return
Hotkeys_Basic_8:
	Hotkeys_Handler(A_ThisLabel)
Return

Hotkeys_Advanced_1:
	Hotkeys_Handler(A_ThisLabel)
Return
Hotkeys_Advanced_2:
	Hotkeys_Handler(A_ThisLabel)
Return
Hotkeys_Advanced_3:
	Hotkeys_Handler(A_ThisLabel)
Return
Hotkeys_Advanced_4:
	Hotkeys_Handler(A_ThisLabel)
Return
Hotkeys_Advanced_5:
	Hotkeys_Handler(A_ThisLabel)
Return
Hotkeys_Advanced_6:
	Hotkeys_Handler(A_ThisLabel)
Return
Hotkeys_Advanced_7:
	Hotkeys_Handler(A_ThisLabel)
Return
Hotkeys_Advanced_8:
	Hotkeys_Handler(A_ThisLabel)
Return
Hotkeys_Advanced_9:
	Hotkeys_Handler(A_ThisLabel)
Return
Hotkeys_Advanced_10:
	Hotkeys_Handler(A_ThisLabel)
Return
Hotkeys_Advanced_11:
	Hotkeys_Handler(A_ThisLabel)
Return
Hotkeys_Advanced_12:
	Hotkeys_Handler(A_ThisLabel)
Return
Hotkeys_Advanced_13:
	Hotkeys_Handler(A_ThisLabel)
Return
Hotkeys_Advanced_14:
	Hotkeys_Handler(A_ThisLabel)
Return
Hotkeys_Advanced_15:
	Hotkeys_Handler(A_ThisLabel)
Return
Hotkeys_Advanced_16:
	Hotkeys_Handler(A_ThisLabel)
Return

Hotkeys_TradesGUI_Custom_1:
	Hotkeys_Handler(A_ThisLabel)
Return
Hotkeys_TradesGUI_Custom_2:
	Hotkeys_Handler(A_ThisLabel)
Return
Hotkeys_TradesGUI_Custom_3:
	Hotkeys_Handler(A_ThisLabel)
Return
Hotkeys_TradesGUI_Custom_4:
	Hotkeys_Handler(A_ThisLabel)
Return
Hotkeys_TradesGUI_Custom_5:
	Hotkeys_Handler(A_ThisLabel)
Return
Hotkeys_TradesGUI_Custom_6:
	Hotkeys_Handler(A_ThisLabel)
Return
Hotkeys_TradesGUI_Custom_7:
	Hotkeys_Handler(A_ThisLabel)
Return
Hotkeys_TradesGUI_Custom_8:
	Hotkeys_Handler(A_ThisLabel)
Return
Hotkeys_TradesGUI_Custom_9:
	Hotkeys_Handler(A_ThisLabel)
Return

Hotkeys_TradesGUI_Unicode_1:
	Hotkeys_Handler(A_ThisLabel)
Return
Hotkeys_TradesGUI_Unicode_2:
	Hotkeys_Handler(A_ThisLabel)
Return
Hotkeys_TradesGUI_Unicode_3:
	Hotkeys_Handler(A_ThisLabel)
Return
Hotkeys_TradesGUI_Unicode_4:
	Hotkeys_Handler(A_ThisLabel)
Return
Hotkeys_TradesGUI_Unicode_5:
	Hotkeys_Handler(A_ThisLabel)
Return
Hotkeys_TradesGUI_Unicode_6:
	Hotkeys_Handler(A_ThisLabel)
Return

Hotkeys_Special_1:
	Hotkeys_Handler(A_ThisLabel)
Return
Hotkeys_Special_2:
	Hotkeys_Handler(A_ThisLabel)
Return
Hotkeys_Special_3:
	Hotkeys_Handler(A_ThisLabel)
Return
Hotkeys_Special_4:
	Hotkeys_Handler(A_ThisLabel)
Return

Hotkeys_Handler(thisLabel) {

	global TradesGUI_Values, ProgramValues, TradesGUI_Controls, ProgramSettings

	iniFilePath := ProgramValues.Ini_File

	RegExMatch(thisLabel, "\d+", hotkeyID)
	RegExMatch(thisLabel, "\D+", labelType)

	hotkeyType := (labelType="Hotkeys_Basic_")?("Basic")
				 :(labelType="Hotkeys_Advanced_")?("Advanced")
				 :(labelType="Hotkeys_TradesGUI_Custom_")?("TradesGUI_Custom")
				 :(labelType="Hotkeys_TradesGUI_Unicode_")?("TradesGUI_Unicode")
				 :(labelType="Hotkeys_Special_")?("Special")
				 :("ERROR")

	if ( hotkeyType = "Basic" || hotkeyType = "Advanced" ) {
		tradesInfosArray := Object()
		tabID := TradesGUI_Values.Active_Tab
		if ( tabID ) {
			tabInfos := Gui_Trades_Get_Trades_Infos(tabID)
		}

		if ( hotkeyType = "Basic" ) {
			key := "HK" hotkeyID
			IniRead, textToSend,% iniFilePath,HOTKEYS,% key "_TEXT"
		}
		else if (hotkeyType = "Advanced" ) {
			key := "HK" hotkeyID
			IniRead, textToSend,% iniFilePath,HOTKEYS_ADVANCED,% key "_ADV_TEXT"
		}
		messages := [textToSend]

		isAdvanced := (hotkeyType="Advanced")?(1):(0)
		Send_InGame_Message(messages, tabInfos, {isHotkey:1, isAdvanced:isAdvanced})
	}
	else if ( hotkeyType = "TradesGUI_Custom" || hotkeyType = "TradesGUI_Unicode" ) {
		WM_Messages_Set_State(0)
		controlDelay := A_ControlDelay
		SetControlDelay -1
		if ( hotkeyType = "TradesGUI_Custom" ) {
			ControlClick,,% "ahk_id " TradesGUI_Values.Handler " ahk_id " TradesGUI_Controls["Button_Custom_" hotkeyID],,,, NA
			if (ErrorLevel) {
				Logs_Append(A_ThisFunc, {HK:A_ThisHotkey, What_Do:"Click Button: """ TradesGUI_Controls["Button_Custom_" hotkeyID] """"})
			}
		}
		else if ( hotkeyType = "TradesGUI_Unicode" ) {
			ControlClick,,% "ahk_id " TradesGUI_Values.Handler " ahk_id " TradesGUI_Controls["Button_Unicode_" hotkeyID]
			if (ErrorLevel) {
				Logs_Append(A_ThisFunc, {HK:A_ThisHotkey, What_Do:"Click Button: """ TradesGUI_Controls["Button_Unicode_" hotkeyID] """"})
			}
		}
		WM_Messages_Set_State(1)
		SetControlDelay %controlDelay%
	}
	else if ( hotkeyType = "Special" ){
		if (hotkeyID = 1)
			Gui_Trades_Select_Tab({Choose_Next:1})
		else if (hotkeyID = 2)
			Gui_Trades_Select_Tab({Choose_Prev:1})
		else if (hotkeyID = 3)
			Gui_Trades_Close_Tab()
		else if (hotkeyID = 4)
			Gui_Trades_Minimize_Func()
	}
}

Disable_Hotkeys() {
	;	Disable the current hotkeys
	;	Always run Enable_Hotkeys() after to retrieve and assign the new hotkeys
	global ProgramSettings

	titleMatchMode := A_TitleMatchMode
	SetTitleMatchMode, RegEx

;	Basic Hotkeys
	Loop 8 {
		index := A_Index
		if ( ProgramSettings["HK" index "_Toggle"] ) {
			userHotkey%index% := ProgramSettings["HK" index "_KEY"]
			Hotkey,IfWinActive,ahk_group POEGame
			if ( userHotkey%index% != "" && userHotkey%index% != "ERROR" ) {
				try {
					Hotkey,% userHotkey%index%,Off
				}
			}
		}
	}
;	Advanced Hotkeys
	Loop 16 {
		index := A_Index
		if ( ProgramSettings["HK" index "_ADV_Toggle"] ) {
			userHotkey%index% := ProgramSettings["HK" index "_ADV_KEY"]
			Hotkey,IfWinActive,ahk_group POEGame
			if ( userHotkey%index% != "" && userHotkey%index% != "ERROR" ) {
				try {
					Hotkey,% userHotkey%index%,Off
				}
			}
		}
	}		
;	Trades GUI Custom Buttons
	Loop 9 {
		index := A_Index
		if ( ProgramSettings["Button" index "_SIZE"] != "Disabled") {
			userHotkey%index% := ProgramSettings["Button" index "_Hotkey"]
			Hotkey,IfWinActive,ahk_group POEGame
			if ( userHotkey%index% != "" && userHotkey%index% != "ERROR" ) {
				try {
					Hotkey,% userHotkey%index%, Off
				}
			}
		}
	}
;	Trades GUI Unicode Buttons
	Loop 5 {
		index := A_Index
		if ( ProgramSettings["Button_Unicode_" index "_Hotkey_Toggle"] ) {
			userHotkey%index% := ProgramSettings["Button_Unicode_" index "_Hotkey"]
			Hotkey,IfWinActive,ahk_group POEGame
			if ( userHotkey%index% != "" && userHotkey%index% != "ERROR" ) {
				try {
					Hotkey,% userHotkey%index%, Off
				}
			}
		}
	}
;	Special Hotkeys
	Loop 4 {
		index := A_Index
		if ( ProgramSettings["HK_Special_" index "_Hotkey_Toggle"] ) {
			userHotkey%index% := ProgramSettings["HK_Special_" index "_Hotkey"]
			Hotkey,IfWinActive,ahk_group POEGame
			if ( userHotkey%index% != "" && userHotkey%index% != "ERROR" ) {
				try {
					Hotkey,% userHotkey%index%, Off
				}
			}
		}
	}
	SetTitleMatchMode, %titleMatchMode%	
}

Enable_Hotkeys() {
	;	Enable the hotkeys, based on its global VALUE_ content
	global ProgramSettings, ProgramValues

	programName := ProgramValues.Name, iniFilePath := ProgramValues.Ini_File

	titleMatchMode := A_TitleMatchMode
	SetTitleMatchMode, RegEx

;	Basic Hotkeys
	Loop 8 {
		index := A_Index
		if ( ProgramSettings["HK" index "_Toggle"] ) {
			userHotkey%index% := ProgramSettings["HK" index "_KEY"]
			Hotkey,IfWinActive,ahk_group POEGame
			if ( userHotkey%index% != "" && userHotkey%index% != "ERROR" ) {
				Hotkey,% userHotkey%index%,Hotkeys_Basic_%index%,On
			}
		}
	}
;	Advanced Hotkeys
	Loop 16 {
		index := A_Index
		if ( ProgramSettings["HK" index "_ADV_Toggle"] ) {
			userHotkey%index% := ProgramSettings["HK" index "_ADV_KEY"]
			Hotkey,IfWinActive,ahk_group POEGame
			if ( userHotkey%index% != "" && userHotkey%index% != "ERROR" ) {
				try	
					Hotkey,% userHotkey%index%,Hotkeys_Advanced_%index%,On
				catch {
					IniWrite,0,% iniFilePath,HOTKEYS_ADVANCED,% "HK" index "_ADV_Toggle"
					MsgBox, 4096,% programName,% "The following Hotkey is invalid: " userHotkey%index%
					. "`n`nThe Hotkey will be disabled."
					. "`nPlease refer to the WIKI."
				}
			}
		}
	}		
;	Trades GUI Custom Buttons
	Loop 9 {
		index := A_Index
		if ( ProgramSettings["Button" index "_SIZE"] != "Disabled" ) {
			userHotkey%index% := ProgramSettings["Button" index "_Hotkey"]
			Hotkey,IfWinActive,ahk_group POEGame
			if ( userHotkey%index% != "" && userHotkey%index% != "ERROR" ) {
				Hotkey,% userHotkey%index%,Hotkeys_TradesGUI_Custom_%index%,On
			}
		}
	}
;	Trades GUI Unicode Buttons
	Loop 5 {
		index := A_Index
		if ( ProgramSettings["Button_Unicode_" index "_Hotkey_Toggle"] ) {
			userHotkey%index% := ProgramSettings["Button_Unicode_" index "_Hotkey"]
			Hotkey,IfWinActive,ahk_group POEGame
			if ( userHotkey%index% != "" && userHotkey%index% != "ERROR" ) {
				Hotkey,% userHotkey%index%,Hotkeys_TradesGUI_Unicode_%index%,On
			}
		}
	}
;	Special Hotkeys
	Loop 4 {
		index := A_Index
		if ( ProgramSettings["HK_Special_" index "_Hotkey_Toggle"] ) {
			userHotkey%index% := ProgramSettings["HK_Special_" index "_Hotkey"]
			Hotkey,IfWinActive,ahk_group POEGame
			if ( userHotkey%index% != "" && userHotkey%index% != "ERROR" ) {
				Hotkey,% userHotkey%index%,Hotkeys_Special_%index%,On
			}
		}
	}
	SetTitleMatchMode, %titleMatchMode%
}

;==================================================================================================================
;
;												OTHERS GUI
;
;==================================================================================================================

GUI_Replace_PID(handlersArray, gamePIDArray) {
;		GUI used when clicking one of the Trades GUI buttons and the PID is not associated with POE anymore
;		Provided two array containing all the POE handlers and PID, it allows the user to choose which PID to use as a replacement
	static
	global ProgramValues

	programName := ProgramValues.Name

	Gui, ReplacePID:Destroy
	Gui, ReplacePID:New, +ToolWindow +AlwaysOnTop -SysMenu +hwndGUIInstancesHandler
	Gui, ReplacePID:Add, Text, x10 y10,% "The previous PID is no longer associated to a POE instance."
	Gui, ReplacePID:Add, Text, x10 y25,% "Please, select the new one you would like to use!"
	ypos := 30
	for key, element in handlersArray {
		index := A_Index - 1
		Gui, ReplacePID:Add, Text, x10 yp+30,Executable:
		WinGet, pName, ProcessName,ahk_id %element%
		Gui, ReplacePID:Add, Edit, xp+55 yp-3 ReadOnly w150,% pName
		Gui, ReplacePID:Add, Button,xp+155 yp-2 gGUI_Replace_PID_Continue vContinue%index%,Continue with this one
		Gui, ReplacePID:Add, Text, x10 yp+32,Path:
		WinGet, pPath, ProcessPath,ahk_id %element%
		Gui, ReplacePID:Add, Edit, xp+55 yp-3 ReadOnly,% pPath
		if ( index != handlersArray.MaxIndex() ) ; Put a 10px margin if it's not the last element
			Gui, ReplacePID:Add, Text, w0 h0 xp yp+10
	}
	Gui, ReplacePID:Show,NoActivate,% programName " - Replace PID"
	WinWait, ahk_id %GUIInstancesHandler%
	WinWaitClose, ahk_id %GUIInstancesHandler%
	return r

	GUI_Replace_PID_Continue:
		btnID := RegExReplace(A_GuiControl, "\D")
		r := gamePIDArray[btnID]
		Gui, ReplacePID:Destroy
		Logs_Append("GUI_Replace_PID_Return", {PID:r})
	Return
}

GUI_Multiple_Instances(handlersArray) {
;		GUI used when multiple instances of POE running in different folders have been found upon running the Monitor_Logs() function
;		Provided an array containing all the POE handlers, it allows the user to choose which logs file to monitor
	static
	global ProgramValues

	programName := ProgramValues.Name

	Gui, Instances:Destroy
	Gui, Instances:New, +ToolWindow +AlwaysOnTop -SysMenu +hwndGUIInstancesHandler
	Gui, Instances:Add, Text, x10 y10,% "Detected instances are using different logs file."
	Gui, Instances:Add, Text, x10 y25,% "Please, select the one you would like to use!"
	ypos := 30
	for key, element in handlersArray {
		index := A_Index - 1
		Gui, Instances:Add, Text, x10 yp+30,Executable:
		WinGet, pName, ProcessName,ahk_id %element%
		Gui, Instances:Add, Edit, xp+55 yp-3 ReadOnly w150,% pName
		Gui, Instances:Add, Button,xp+155 yp-2 gGUI_Multiple_Instances_Continue vContinue%index%,Continue with this one
		Gui, Instances:Add, Text, x10 yp+32,Path:
		WinGet, pPath, ProcessPath,ahk_id %element%
		Gui, Instances:Add, Edit, xp+55 yp-3 ReadOnly,% pPath
		if ( index != handlersArray.MaxIndex() ) ; Put a 10px margin if it's not the last element
			Gui, Instances:Add, Text, w0 h0 xp yp+10
		Logs_Append(A_ThisFunc, {Handler:element, Path:pPath})
	}
	Gui, Instances:Show,NoActivate,% programName " - Multiple instances found"
	WinWait, ahk_id %GUIInstancesHandler%
	WinWaitClose, ahk_id %GUIInstancesHandler%
	return r

	GUI_Multiple_Instances_Continue:
		btnID := RegExReplace(A_GuiControl, "\D")
		r := handlersArray[btnID]
		Gui, Instances:Destroy
		Logs_Append("GUI_Multiple_Instances_Return", {Handler:r})
	Return
}

;==================================================================================================================
;
;												WM_MESSAGES
;
;==================================================================================================================

WM_Messages_Set_State(state) {
/*		Disable/Enable the WM_Messages.
		This allows us to simulate clicking on a button without having to hover the GUI.
*/

	OnMessage(0x200, "WM_MOUSEMOVE", state)
	OnMessage(0x201, "WM_LBUTTONDOWN", state)
	OnMessage(0x203, "WM_LBUTTONDBLCLK", state)
	OnMessage(0x204, "WM_RBUTTONDOWN", state)
}

WM_RBUTTONDOWN(wParam, lParam, msg, hwnd) {
	global TradesGUI_Controls, TradesGUI_Values

	if ( A_Gui = "Trades" ) {
		if (hwnd = TradesGUI_Controls.Close_Tab) {
			Menu, TradesCloseBtn, Add, Close similar trades, Gui_Trades_Close_Similar
			Menu, TradesCloseBtn, Show
		}
	}
	return

	Gui_Trades_Close_Similar:
;		Check for other trades with different buyer but same item/price/location
 		tabToDel := Gui_Trades_Get_Tab_ID()
 		duplicatesID := Gui_Trades_Check_Duplicate(tabToDel)
 		Loop, Parse, duplicatesID,% "D|"
 		{
 			Gui_Trades_Close_Tab(A_LoopField)
 		}
	Return
}

Set_Mouse_Leave_Tracking(hwnd) {
/*			Allows to use WM_MouseLeave (0x2A3) with GUI that do not have a border.
 *			Credits: RHCP - autohotkey.com/board/topic/120763-wm-mousemove-how/?p=685998
 *
 *			Requires: 	Existing functions: WM_MOUSEMOVE(wParam, lParam, msg, hwnd)
 *											WM_MOUSELEAVE(wParam, lParam, msg, hwnd)
 *						A global variable shared between these two
 *
 *			Usage:		Inside WM_MOUSEMOVE: if !VALUE_Mouse_Tracking
 *											 VALUE_Mouse_Tracking := Set_Mouse_Leave_Tracking(hwnd)
 *
*/
	static v
	if !v
	{
		VarSetCapacity(v, size := A_Ptrsize = 8 ? 24 : 16, 0)
		NumPut(size, v, 0, "UInt")            ; cbSize
		NumPut(0x00000002, v, 4, "UInt")    ; dwFlags (TME_LEAVE)
		NumPut(hwnd, v, 8, "Ptr")          ; HWND
		NumPut(0, v, A_Ptrsize = 8 ? 16 : 12, "UInt")            ; dwHoverTime (ignored) 
	}
	return  DllCall("TrackMouseEvent", "Ptr", &v) ; Non-zero on success
}

WM_LBUTTONDBLCLK(wParam, lParam, msg, hwnd) {
/*			Blocks the default behaviour of placing in clipboard
 *				when double-clicking a static (text) control
 *
 *			Usage: 	OnMessage(0x203, "WM_LBUTTONDBLCLK") - Enabled
 *					OnMessage(0x203, "WM_LBUTTONDBLCLK", 0) - Disabled
 *
 *			Credits: Lexikos
 *			autohotkey.com/board/topic/94962-doubleclick-on-gui-pictures-puts-their-path-in-your-clipboard/?p=682595
*/
	WinGetClass class, ahk_id %hwnd%
	if (class = "Static") {
		if !A_Gui
			return 0  ; Just prevent Clipboard change.
		; Send a WM_COMMAND message to the Gui to trigger the control's g-label.
		Gui +LastFound
		id := DllCall("GetDlgCtrlID", "ptr", hwnd) ; Requires AutoHotkey v1.1.
		static STN_DBLCLK := 1
		PostMessage 0x111, id | (STN_DBLCLK << 16), hwnd
		if GetKeyState("LButton") ; LButton down
			WM_LBUTTONDOWN(wParam, lParam, msg, hwnd)
		; Return a value to prevent the default handling of this message.
		return 0
	}

}

WM_MOUSEMOVE(wParam, lParam, msg, hwnd) {
	static
	global TradesGUI_Values, ProgramValues, TradesGUI_Controls, ProgramSettings, DebugValues

	programSkinFolderPath := ProgramValues.Skins_Folder

	; lastButton := TradesGUI_Values.Last_Hovered_Button
	; lastPngFilePrefix := TradesGUI_Values.TradesGUI_Last_PNG

	if (A_GUI = "Trades") {

		RegExMatch(A_GuiControl, "\D+", btnType)
		RegExMatch(A_GuiControl, "\d+", btnID)

		btnHandler := (btnType="CustomBtn")?(TradesGUI_Controls["Button_Custom_" btnID])
				     :(btnType="GoRight")?(TradesGUI_Controls["Arrow_Right"])
				     :(btnType="GoLeft")?(TradesGUI_Controls["Arrow_Left"])
				     :(btntype="BuyerSlot")?(TradesGUI_Controls["Buyer_Slot_" btnID])
				     :(btntype="ItemSlot")?(TradesGUI_Controls["Item_Slot_" btnID])
				     :(btntype="PriceSlot")?(TradesGUI_Controls["Price_Slot_" btnID])
				     :(btntype="LocationSlot")?(TradesGUI_Controls["Location_Slot_" btnID])
				     :(btntype="OtherSlot")?(TradesGUI_Controls["Other_Slot_" btnID])
				     :(btntype="BtnClose")?(TradesGUI_Controls["Button_Close"])
				     :(btntype="UnicodeBtn")?(TradesGUI_Controls["Button_Unicode_" btnID])
				     :("ERROR")
				     
/*	Used for the pre 1.12 skinning system.
	Would switch the button asset based on hover/click state

		if (ProgramSettings.Active_Skin != "System") {
			if btnType in CustomBtn,BtnClose,GoRight,GoLeft,UnicodeBtn
			{
				if ( btnHandler != lastButton && btnHandler ) {
					pngFilePrefix := (btnType="CustomBtn")?("ButtonBackground")
									:(btnType="BtnClose")?("Close")
									:(btnType="GoRight")?("ArrowRight")
									:(btnType="GoLeft")?("ArrowLeft")
									:(btnType="UnicodeBtn")?("ButtonBackground")
									:("ERROR")
					if FileExist(programSkinFolderPath "\" ProgramSettings.Active_Skin "\" pngFilePrefix "Hover.png") && FileExist(programSkinFolderPath "\" ProgramSettings.Active_Skin "\" pngFilePrefix "Press.png") {
						GetKeyState, LButtonState, LButton
						if ( LButtonState = "D" && btnHandler = TradesGUI_Values.Current_Held_Button ) {
						 	GuiControl, Trades:,% btnHandler,% programSkinFolderPath "\" ProgramSettings.Active_Skin "\" pngFilePrefix "Press.png"
						}
						else {
							GuiControl, Trades:,% btnHandler,% programSkinFolderPath "\" ProgramSettings.Active_Skin "\" pngFilePrefix "Hover.png"
						}
						GuiControl, Trades:,% lastButton,% programSkinFolderPath "\" ProgramSettings.Active_Skin "\" lastPngFilePrefix ".png"
						lastPngFilePrefix := pngFilePrefix
					}
				}

				TradesGUI_Values.Last_Hovered_Button := btnHandler
				btnState := "Hover"
			}
			else if (btnState = "Hover") {
				GuiControl, Trades:,% lastButton,% programSkinFolderPath "\" ProgramSettings.Active_Skin "\" lastPngFilePrefix ".png"
				btnState := "Default"
				RegExMatch(TradesGUI_Values.Last_Hovered_Button, "\D+", lastbtnType)
				TradesGUI_Values.Insert.Last_Hovered_Button := ""
			}
		}
*/
		if btnType in BuyerSlot,ItemSlot,PriceSlot,LocationSlot,OtherSlot
		{
			if (btnType = "OtherSlot") {
				GuiControlGet, hasNewMsg, Trades:,% TradesGUI_Controls["NewMsg_Slot_" btnID]
				if (hasNewMsg) {
					GUI_Trades_Set_NewMsg(btnID, 0)
					GUI_Trades_Update_Tab_Style(btnId)
				}
			}
			CoordMode, ToolTip, Screen
			GuiControlGet, content,Trades:,% btnHandler
			ctrlPos := Get_Control_Coords("Trades", btnHandler)
			WinGetPos, tradesXPOS, tradesYPOS
			ToolTip, % content,% tradesXPOS+ctrlPOS.X,% tradesYPOS+ctrlPOS.Y
			MouseGetPos, mouseX, mouseY
			global Remove_ToolTip_OnMouseMove_Values := {X:mouseX, Y:mouseY, Treshold_X:100, Treshold_Y:10}
			SetTimer, Remove_Tooltip_OnMouseMove, 100
		}
		; if !A_GuiControl ; No control hovered, reset the value
			; TradesGUI_Values.Last_Hovered_Button := ""
	}

	else if ( A_GUI = "Settings" ) {
		timer := (DebugValues.settings.open_settings)?(-100):(-1000)
		curControl := A_GuiControl
		If ( curControl <> prevControl ) {
			controlTip := Get_Control_ToolTip(curControl)
			if ( controlTip )
				SetTimer, Display_ToolTip,% timer
			Else
				Gosub, Remove_ToolTip
			prevControl := curControl
		}
		return
		
		Display_ToolTip:
			controlTip := Get_Control_ToolTip(curControl)
			if ( controlTip ) {
				try
					ToolTip,% controlTip
				SetTimer, Remove_ToolTip, -20000
			}
			else {
				ToolTip,
			}
		return
		
		Remove_ToolTip:
			ToolTip
		return
	}

	Sleep 10

	; if (btnID)
	; 	lastBtnID := btnID
	; if (pngFilePrefix)
	; 	TradesGUI_Values.Insert("TradesGUI_Last_PNG", pngFilePrefix) ; __TO_BE_INSPECTED__ Usused leftover?
	; if (A_GuiControl)
	; 	TradesGUI_Values.Insert("Trades_GUI_Hover_Control", A_GuiControl) ; __TO_BE_INSPECTED__ Usused leftover?
}

WM_LBUTTONDOWN(wParam, lParam, msg, hwnd) {
	global TradesGUI_Values, ProgramValues, TradesGUI_Controls, ProgramSettings
	RegExMatch(A_GuiControl, "\D+", btnType)
	RegExMatch(A_GuiControl, "\d+", btnID)

	; Remove message notification when user clicks on other_slot
	if (btnType = "OtherSlot") {
		GUI_Trades_Set_NewMsg(btnID, 0)
		GUI_Trades_Update_Tab_Style(btnId)
	}
/*	Used for the pre 1.12 skinning system.
	Would switch the button asset based on hover/click state

	programSkinFolderPath := ProgramValues.Skins_Folder

	RegExMatch(A_GuiControl, "\D+", btnType)
	RegExMatch(A_GuiControl, "\d+", btnID)

	if (A_GUI = "Trades") {

		btnHandler := (btnType="CustomBtn")?(TradesGUI_Controls["Button_Custom_" btnID])
				     :(btntype="BtnClose")?(TradesGUI_Controls["Button_Close"])
				     :(btnType="GoRight")?(TradesGUI_Controls["Arrow_Right"])
				     :(btnType="GoLeft")?(TradesGUI_Controls["Arrow_Left"])
				     :(btnType="UnicodeBtn")?(TradesGUI_Controls["Button_Unicode_" btnID])
				     :("ERROR")

		if btnType in CustomBtn,BtnClose,GoRight,GoLeft,UnicodeBtn
		{
			pngFilePrefix := (btnType="CustomBtn")?("ButtonBackground")
							:(btnType="BtnClose")?("Close")
							:(btnType="GoRight")?("ArrowRight")
							:(btnType="GoLeft")?("ArrowLeft")
							:(btnType="UnicodeBtn")?("ButtonBackground")
							:("ERROR")
			if FileExist(programSkinFolderPath "\" ProgramSettings.Active_Skin "\" pngFilePrefix "Hover.png") && FileExist(programSkinFolderPath "\" ProgramSettings.Active_Skin "\" pngFilePrefix "Press.png") {
				GuiControl, Trades:,% btnHandler,% programSkinFolderPath "\" ProgramSettings.Active_Skin "\" pngFilePrefix "Press.png"
				TradesGUI_Values.Current_Held_Button := btnHandler
				KeyWait, LButton, U

;				Retrieve handlers of the button's assets
				MouseGetPos, , , , underMouseHandler, 2
				if btnType in CustomBtn,UnicodeBtn
				{
					prefix := (btnType="CustomBtn")?("Button_Custom_")
							 :(btnType="UnicodeBtn")?("Button_Unicode_")
							 :("ERROR")
					GuiControlGet, ClickedBtnHandler, Trades:Hwnd,% TradesGUI_Controls[prefix btnID]
					GuiControlGet, ClickedBtnOrnateLeftHandler, Trades:Hwnd,% TradesGUI_Controls[prefix btnID "_OrnamentLeft"]
					GuiControlGet, ClickedBtnOrnateRightHandler, Trades:Hwnd,% TradesGUI_Controls[prefix btnID "_OrnamentRight"]
					GuiControlGet, ClickedBtnTXTHandler, Trades:Hwnd,% TradesGUI_Controls[prefix btnID "_Text"]
					matchsList := ClickedBtnHandler "," ClickedBtnOrnateLeftHandler "," ClickedBtnOrnateRightHandler "," ClickedBtnTXTHandler
				}
				else {
					GuiControlGet, ClickedBtnHandler, Trades:Hwnd,% btnHandler
					matchsList := ClickedBtnHandler
				}
				
				if underMouseHandler in %matchsList% ; Button still under cursor after releasing click, revert to Hover state
					GuiControl, Trades:,% btnHandler,% programSkinFolderPath "\" ProgramSettings.Active_Skin "\" pngFilePrefix "Hover.png"
				else ; Button not anymore under cursor, cancel the button gLabel
					TradesGUI_Values.Cancel_Action := 1
			}
		}
	}
*/
}

ShellMessage(wParam,lParam) {
/*			Triggered upon activating a window
 *			Is used to correctly position the Trades GUI while in Overlay mode
*/
	global ProgramValues, ProgramSettings, TradesGUI_Values
	global POEGameList, GUISettingsHandler

	programSkinFolderPath := ProgramValues.Skins_Folder

	if ( wParam=4 or wParam=32772 ) { ; 4=HSHELL_WINDOWACTIVATED | 32772=HSHELL_RUDEAPPACTIVATED
		if WinActive("ahk_id" TradesGUI_Values.Handler) {
;		Prevent these keyboard presses from interacting with the Trades GUI
			Hotkey, IfWinActive,% "ahk_id " TradesGUI_Values.Handler
			Hotkey, NumpadEnter, DoNothing, 
			Hotkey, Escape, DoNothing, On
			Hotkey, Space, DoNothing, On
			Hotkey, Tab, DoNothing, On
			Hotkey, Enter, DoNothing, On
			Hotkey, Left, DoNothing, On
			Hotkey, Right, DoNothing, On
			Hotkey, Up, DoNothing, On
			Hotkey, Down, DoNothing, On
			Return ; returning prevents from triggering Gui_Trades_Set_Position while the GUI is active
		}

		if (!TradesGUI_Values.Created)
			Return

		WinGet, winEXE, ProcessName, ahk_id %lParam%
		WinGet, winID, ID, ahk_id %lParam%
		if ( ProgramSettings.Show_Mode = "InGame" ) {
			if ( TradesGUI_Values.Width ) { ; TradesGUI exists
				if POEGameList contains %winEXE%
				{
					Gui, Trades:Show, NoActivate
				}
				else if (winID = GUISettingsHandler ) { 
					Gui, Trades:Show, NoActivate
				}
				else {
					Gui, Trades:Show, NoActivate Hide
				}
			}
		}
		else
			Gui, Trades:Show, NoActivate ; Always Show

		if ( ProgramSettings.Trades_GUI_Mode = "Overlay")
			try Gui_Trades_Set_Position() ; Re-position the GUI

		Gui, Trades:+LastFound
		WinSet, AlwaysOnTop, On
	}
}

/******************************************************************************************************************
*
*	FGP by kon
*	https://autohotkey.com/boards/viewtopic.php?f=6&t=3806
*	
*	Example Usage:
	#NoEnv
	SetBatchLines, -1
	FileSelectFile, FilePath					; Select a file to use for this example.
	
	PropName := FGP_Name(0)						; Gets a property name based on the property number.
	PropNum  := FGP_Num("Size")					; Gets a property number based on the property name.
	PropVal1 := FGP_Value(FilePath, PropName)	; Gets a file property value by name.
	PropVal2 := FGP_Value(FilePath, PropNum)	; Gets a file property value by number.
	PropList := FGP_List(FilePath)				; Gets all of a file's non-blank properties.
	
	MsgBox, % PropName ":`t" PropVal1			; Display the results.
	. "`n" PropNum ":`t" PropVal2
	. "`n`nList:`n" PropList.CSV
*
*******************************************************************************************************************
*/

/*  FGP_Init()
 *		Gets an object containing all of the property numbers that have corresponding names. 
 *		Used to initialize the other functions.
 *	Returns
 *		An object with the following format:
 *			PropTable.Name["PropName"]	:= PropNum
 *			PropTable.Num[PropNum]		:= "PropName"
 */
FGP_Init() {
	static PropTable
	if (!PropTable) {
		PropTable := {Name: {}, Num: {}}, Gap := 0
		oShell := ComObjCreate("Shell.Application")
		oFolder := oShell.NameSpace(0)
		while (Gap < 11)
			if (PropName := oFolder.GetDetailsOf(0, A_Index - 1)) {
				PropTable.Name[PropName] := A_Index - 1
				PropTable.Num[A_Index - 1] := PropName
				Gap := 0
			}
			else
				Gap++
	}
	return PropTable
}


/*  FGP_Value(FilePath, Property)
 *		Gets a file property value.
 *	Parameters
 *		FilePath	- The full path of a file.
 *		Property	- Either the name or number of a property.
 *	Returns
 *		If succesful the file property value is returned. Otherwise:
 *		0			- The property is blank.
 *		-1			- The property name or number is not valid.
 */
FGP_Value(FilePath, Property) {
	static PropTable := FGP_Init()
	if ((PropNum := PropTable.Name[Property] != "" ? PropTable.Name[Property]
	: PropTable.Num[Property] ? Property : "") != "") {
		SplitPath, FilePath, FileName, DirPath
		oShell := ComObjCreate("Shell.Application")
		oFolder := oShell.NameSpace(DirPath)
		oFolderItem := oFolder.ParseName(FileName)
		if (PropVal := oFolder.GetDetailsOf(oFolderItem, PropNum))
			return PropVal
		return 0
	}
	return -1
}

;==================================================================================================================
;
;												MISC STUFF
;
;==================================================================================================================

IsBetween(value, first, last) {
   if value between %first% and %last%
      return true
   else
      return false
}

Load_Skin_Assets() {
	global ProgramValues, ProgramSettings, SkinAssets

	SkinAssets 			:= {}
	skinFolder 			:= ProgramValues.Skins_Folder "\" ProgramSettings.Active_Skin
	assetsFile 		 	:= skinFolder "\Assets.ini"
	sections := ["Arrow_Left","Arrow_Right","Button_OneThird","Button_TwoThird","Button_ThreeThird","Button_Special","Close_Tab","Minimize", "Maximize", "Tab","Tab_Joined","Tab_Whisper","Misc"]
	for id, sectName in sections {
		keysInThisSection := []
		IniRead, keysAndValue,% assetsFile,% sectName
		Loop, Parse, keysAndValue,% "D`n" 
		{
			RegExMatch(A_LoopField, "(.*?)=", keyPat)
			keysInThisSection.Push(keyPat1)
		}
		for id, keyName in keysInThisSection {
			IniRead, value,% assetsFile,% sectName,% keyName,false
			IniRead_Convert_TrueFalse(value)
			SplitPath, value, , , valueExt
			if (valueExt)
				SkinAssets[sectName "_" keyName] := skinFolder "\" value
			else
				SkinAssets[sectName "_" keyName] := value
		}
	}
}

IniRead_Convert_TrueFalse(ByRef value) {
/*		Converts a "True" or "False" string
*/
	value := (value="True")?(True):(value="False")?(False):(value)
}

Get_Active_Trading_Leagues() {
/*		Retrieves leagues from the API
		Parse them, to keep only non-solo or non-ssf leagues
		Return the resulting list
*/
	global ProgramValues, Trading_Leagues
	static timeOuts

	apiLink 			:= "http://api.pathofexile.com/leagues?type=main&compact=1"
	excludedWords 		:= "SSF,Solo"
	activeLeagues 		:= "Standard,Hardcore,Beta Standard,Beta Hardcore,Harbinger,Hardcore Harbinger" 
	tradingLeagues 		:= ["Standard","Hardcore","Beta Standard","Beta Hardcore","Harbinger","Hardcore Harbinger"] ; In case API is down or does not show them

	attempts++
	timeOuts := (attempts = 1)?(10000) ; 10s
			   :(attempts = 2)?(30000) ; 30s
			   :(60000) ; 60s
	nextAttempt := (IsBetween(attempts, 1, 2))?(300000) ; 5mins
				  :(IsBetween(attempts, 3, 4))?(600000) ; 10mins
				  :(1800000)
	if (attempts > 1) {
		Tray_Notifications_Show(ProgramValues.Name, "Now retrying to retrieve leagues from API...")
	}
	Try {
;		Retrieve from online API
		WinHttpReq := ComObjCreate("WinHttp.WinHttpRequest.5.1")
		WinHttpReq.SetTimeouts(timeOuts, timeOuts, timeOuts, timeOuts)
		WinHttpReq.Open("GET", apiLink, true) ; Using true above and WaitForResponse allows the script to r'emain responsive.
		WinHttpReq.Send()
		WinHttpReq.WaitForResponse(10) ; 10 seconds
		leaguesJSON := WinHttpReq.ResponseText
	}
	Catch e { ; Cannot reach. Use internal leagues instead.
;		Error logging
		floatFormat := A_FormatFloat ; Backup of state
		SetFormat,Float,0 ; remove decimal

		Logs_Append("WinHttpRequest", {Obj:e})
		Tray_Notifications_Show(ProgramValues.Name, "Failed to reach the Leagues API."
												.	"`nTemporary leagues such as races may fail to appear correctly."
												.	"`n`nRetrying in " (nextAttempt/1000)/60 "minutes...", {Fade_Timer:20000})
		SetTimer,% A_ThisFunc, -%nextAttempt%

		SetFormat,Float,%floatFormat% ; Restore state

		Trading_Leagues := tradingLeagues
		Return
	}
	if (attempts > 1) {
		Logs_Append("DEBUG", {String: "Successfully retrieved leagues from API on attempt " attempts})
		Tray_Notifications_Show(ProgramValues.Name, "Successfully retrieved leagues from API on attempt " attempts, {Fade_Timer:20000})
		attempts := 0
	}

;	Parse the leagues (JSON)
	parsedLeagues := JSON.Load(leaguesJSON)
	Loop % parsedLeagues.MaxIndex() {
		arrID 		:= parsedLeagues[A_Index]
		leagueName 	:= arrID.ID
		if leagueName not in %activeLeagues%
		{
 			activeLeagues .= "," leagueName
		}
	}

;	Remove SSF & Solo leagues
	tradingLeagues := []
	Loop, Parse, activeLeagues,% "D," 
	{
		if A_LoopField not contains %excludedWords%
		{
			tradingLeagues.Push(A_LoopField)
		}
	}

	Trading_Leagues := tradingLeagues
}


LV_SubitemHitTest(HLV) {
/*		Credits to just me
		autohotkey.com/board/topic/80265-solved-which-column-is-clicked-in-listview/?p=510061

		Allows to retrieve which column was clicked.
*/
   ; To run this with AHK_Basic change all DllCall types "Ptr" to "UInt", please.
   ; HLV - ListView's HWND
   Static LVM_SUBITEMHITTEST := 0x1039
   VarSetCapacity(POINT, 8, 0)
   ; Get the current cursor position in screen coordinates
   DllCall("User32.dll\GetCursorPos", "Ptr", &POINT)
   ; Convert them to client coordinates related to the ListView
   DllCall("User32.dll\ScreenToClient", "Ptr", HLV, "Ptr", &POINT)
   ; Create a LVHITTESTINFO structure (see below)
   VarSetCapacity(LVHITTESTINFO, 24, 0)
   ; Store the relative mouse coordinates
   NumPut(NumGet(POINT, 0, "Int"), LVHITTESTINFO, 0, "Int")
   NumPut(NumGet(POINT, 4, "Int"), LVHITTESTINFO, 4, "Int")
   ; Send a LVM_SUBITEMHITTEST to the ListView
   SendMessage, LVM_SUBITEMHITTEST, 0, &LVHITTESTINFO, , ahk_id %HLV%
   ; If no item was found on this position, the return value is -1
   If (ErrorLevel = -1)
      Return 0
   ; Get the corresponding subitem (column)
   Subitem := NumGet(LVHITTESTINFO, 16, "Int") + 1
   Return Subitem
}

Remove_Tooltip_OnMouseMove() {
/*		Credits to POE-TradeMacro for the original function
		https://github.com/PoE-TradeMacro/POE-TradeMacro
*/
	global Remove_ToolTip_OnMouseMove_Values
	RemoveTT := Remove_ToolTip_OnMouseMove_Values

	MouseGetPos, currentX, currentY

	mouseMovedH := (currentX - RemoveTT.X) ** 2 > RemoveTT.Treshold_X ** 2
	mouseMovedV := (currentY - RemoveTT.Y) ** 2 > RemoveTT.Treshold_Y ** 2
	if (mouseMovedV || mouseMovedH)	{
		SetTimer, Remove_Tooltip_OnMouseMove, Off
		Remove_ToolTip_OnMouseMove_Values := ""
		ToolTip
	}
	return
}

Get_All_Games_Instances() {
	global TradesGUI_Values

	WinGet windows, List
	matchHandlers := Get_Matching_Windows_Infos("ID")

	if ( matchHandlers.MaxIndex() = "" ) { ; No matching process found
		return "EXE_NOT_FOUND"
	}
	for key, element in matchHandlers {
		index := A_Index
		WinGet, tempExeLocation, ProcessPath,% "ahk_id " element
		SplitPath, tempExeLocation, ,tempExeDir
		tempLogsFile%index% := tempExeDir "\logs\Client.txt"
	}
	tempLogsFileBackup := tempLogsFile1
	Loop %index% {
		index := A_Index
			if ( tempLogsFileBackup = tempLogsFile%index% ) {
				logsFile := tempLogsFileBackup
				TradesGUI_Values.Insert("Dock_Window", matchHandlers[0])
			}
			Else
				multipleInstances := 1
		tempLogsFileBackup := tempLogsFile%index%
	}
	if ( multipleInstances = 1 ) {
		winHandler := GUI_Multiple_Instances(matchHandlers)
		WinGet, exeLocation, ProcessPath,% "ahk_id " winHandler
		SplitPath, exeLocation, ,exeDir
		logsFile := exeDir "\logs\Client.txt"
		TradesGUI_Values.Insert("Dock_Window", winHandler) ; assign global var after choosing the right instance
	}
	r := logsFile
	return r
}

Get_DPI_Factor() {
;			Credits to ANT-ilic
;			autohotkey.com/board/topic/6893-guis-displaying-differently-on-other-machines/?p=77893
;			Retrieves the current DPI value and returns it
;			If the key wasn't found or is set at 96, returns default setting
	RegRead, dpiValue, HKEY_CURRENT_USER, Control Panel\Desktop\WindowMetrics, AppliedDPI 
	dpiFactor := (ErrorLevel || dpiValue=96)?(1):(dpiValue/96)
	return dpiFactor
}


Logs_Append(funcName, params) {
	global ProgramValues, GameSettings, ProgramSettings

	programName := ProgramValues.Name
	programVersion := ProgramValues.Version
	iniFilePath := ProgramValues.Ini_File
	logsFile := ProgramValues.Logs_File

	if ( funcName = "START" ) {
		dpiFactor := ProgramSettings.Screen_DPI

		OSbits := (A_Is64bitOS)?("64bits"):("32bits")
		IniRead, programSectionContent,% iniFilePath,PROGRAM

		gameSettingsContent := ""
		for key, element in GameSettings {
			gameSettingsContent .= key ": """ element """`n"
		}

		paramsKeysContent := ""
		for key, element in params.KEYS {
			paramsKeysContent .= params.KEYS[A_Index] ": """ params.VALUES[A_Index] """`n"
		}

		appendToFile := ""
		appendToFile := ">>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>`n"
						. ">>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>`n"
						. ">>> OS SECTION `n"
						. ">>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>`n"
						. "Type: " A_OSType "`n"
						. "Version: " A_OSVersion "(" OSbits ")`n"
						. "DPI: " dpiFactor "`n"
						. "`n"
						. ">>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>`n"
						. ">>> TOOL SECTION `n"
						. ">>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>`n"
						. "Version: " ProgramValues.Version "`n"
						. "Local_Folder: " ProgramValues.Local_Folder "`n"
						. "Game_Folder: " ProgramValues.Game_Folder "`n"
						. "`n"
						. ">>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>`n"
						. ">>> PROGRAM SECTION `n"
						. ">>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>`n"
						. programSectionContent "`n"
						. "`n"
						. ">>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>`n"
						. ">>> GAME SETTINGS `n"
						. ">>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>`n"
						. gameSettingsContent 
						. "`n"
						. ">>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>`n"
						. ">>> LOCAL SETTINGS `n"
						. ">>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>`n"
						. paramsKeysContent
						. "<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<`n"
						. "<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<`n"
	}

	else {
		appendToFile := "[" A_YYYY "/" A_MM "/" A_DD " " A_Hour ":" A_Min ":" A_Sec "] "

		if ( funcName = "DEBUG_STRING" ) {
			appendToFile := params.String
		}

; - - - - - - - - - - - - - 
;		GUI LOGS
; - - - - - - - - - - - - - 
		else if ( funcName = "GUI_Multiple_Instances" ) {			
			appendToFile .= "Multiple instances found. Handler: " params.Handler " - Path: " params.Path
		}
		else if ( funcName = "GUI_Multiple_Instances_Return" ) {
			appendToFile .= "Multiple instances found (Return). Handler: " params.Handler
		}

		else if ( funcName = "GUI_Replace_PID_Return" ) {
			appendToFile .= "Replacing Trades GUI tab PID with: " params.PID
		}

		else if ( funcName = "Gui_Stats_Get_Currency_Name" ) {
			appendToFile .= "[WARNING] Unknown currency type: """ params.Currency """" "."
		}

		else if ( funcName = "Gui_Trades_Cycle_Func" ) {
			appendToFile .= "Docking Trades GUI to ID: " params.Dock_Window " - Total matchs found: " params.Total_Matchs
		}

		else if ( funcName = "Gui_Trades_Do_Action_Func" ) {
			appendToFile .= "[WARNING]: Matching action not found for button: Name: " params.Button ", Action: " params.Action ", Handler: " params.Handler "."
		}

		else if ( funcName = "Gui_Trades_Select_Tab" ) {
			appendToFile .= "[WARNING] Could not select tab """ params.Tab_ID """ with action: " params.Action "."
		}

		else if ( funcName = "Gui_Trades_Set_Position" ) {
			appendToFile .= "Fixing Trades GUI Position to: x" params.X " y" params.Y
		}

; - - - - - - - - - - - - - 
;		HOTKEYS
; - - - - - - - - - - - - - 
		else if (funcName = "Hotkeys_Handler") {
			appendToFile .= "[WARNING]: Failed to use HOTKEY: """ params.HK """ with ACTION: """ params.What_Do """"
		}

; - - - - - - - - - - - - - 
;		MONITOR GAME LOGS
; - - - - - - - - - - - - - 
		else if ( funcName = "Monitor_Game_Logs" ) {
			appendToFile .= "Monitoring game logs file: " params.File
		}
		else if ( funcName = "Monitor_Game_Logs_Break" ) {
			appendToFile .= "[WARNING]: Restarting logs monitoring. File: " params.File
						.	"`n Pointer Position: " params.Pos " - File Length: " params.Length
		}

; - - - - - - - - - - - - - 
;		MISC
; - - - - - - - - - - - - - 
		else if (funcName = "ShellMessage" ) {
			appendToFile .= "Trades GUI Hidden: Show_Mode: " params.Show_Mode " - Dock_Window ID: " params.Dock_Window " - Current Win ID: " params.Current_Win_ID "."
		}

		else if ( funcName = "WinHttpRequest") {
			httpObj := params.Obj
			appendToFile .= "[WARNING] WinHttpRequest Error Message: " httpObj.Message "`n"
		}

		else {
			appendToFile := ""
		}

	}

	if (appendToFile) {
		FileAppend,% appendToFile "`n",% logsFile
	}
}

Delete_Old_Logs_Files(daysOld) {
/*
 *			Delete logs files
 *			Keeps only the ammount specified
*/
	global ProgramValues
	logsPath := ProgramValues.Logs_Folder
	daysOld *= 1000000 ; Convert to YYYYMMDDHH24MISS
	nowTime := A_Now

	Loop, %logsPath%\*.txt
	{
		if ( A_LoopFileName != "changelog.txt" ) {
			FileGetTime, lastMod,% A_LoopFileFullPath, M
			if ( (nowTime-lastMod) >= daysOld)
				FileDelete,% A_LoopFileFullPath
		}
	}
}

Send_InGame_Message(allMessages, tabInfos="", specialEvent="") {
/*
 *			Sends a message in game
 *			Replaces all the %variables% into their actual content
*/
	global TradesGUI_Values, ProgramValues, GameSettings, ProgramSettings

	programName := ProgramValues.Name
	gameIniFile := ProgramValues.Game_Ini_File

	buyerName := tabInfos.Buyer, itemName := tabInfos.Item, itemPrice := tabInfos.Price, gamePID := tabInfos.PID, activeTab := tabInfos.TabID
	messageRaw1 := allMessages[1], messageRaw2 := allMessages[2], messageRaw3 := allMessages[3]
	message1 := allMessages[1], message2 := allMessages[2], message3 := allMessages[3]

	Thread, NoTimers

;	Retrieve the virtual key id for chat opening
	chatVK := GameSettings.Chat_VK
	if (!chatVK) {
		MsgBox, 4096,% programName " - Operation Cancelled.",% "Could not detect the chat key!"
		. "`nPlease send me an archive containing the Logs folder."
		. "`nYou can find links to GitHub / GGG / Reddit in the [About?] tray menu."
		. "`n`n(The local folder containing the Logs folder will open upon closing this box)."
		Run, % ProgramValues.Local_Folder
		Return 1
	}

;	Include the trade variables content
	Loop 3 {
		StringReplace, message%A_Index%, message%A_Index%, `%buyerName`%, %buyerName%, 1
		StringReplace, message%A_Index%, message%A_Index%, `%itemName`%, %itemName%, 1
		StringReplace, message%A_Index%, message%A_Index%, `%itemPrice`%, %itemPrice%, 1
		StringReplace, message%A_Index%, message%A_Index%, `%lastWhisper`%,% TradesGUI_Values.Last_Whisper, 1
	}

;	Hotkey press
	if ( specialEvent.isHotkey ) {
		messageToSend := message1
		; Advanced hotkey, send inputs as specified
		if ( specialEvent.isAdvanced ) {
			SendInput,%messageToSend%
		}
		; Regular hotkey, open chat and send input as raw
		else {
			firstChar := SubStr(messageToSend, 1, 1) ; Get first char, to compare if its a special chat command

			; Clip backup
			clipBackup := ClipboardAll
			Clipboard :=
			Sleep 10

			; Set msg as new clipboard
			Clipboard := messageToSend
			ClipWait, 2, 1
			Sleep 1

			SendEvent,{VK%chatVK%}

			if firstChar not in /,`%,&,#,@  ; Not a command. We send / then remove it to make sure chat is empty
				SendEvent, {/}{BackSpace}

			; Pasting the message, and send
			SendEvent,{Ctrl Down} ; Separating the inputs fixes an issue where ^v could fail (rarely, but stil happened)
			Sleep 10
			SendEvent,{v}
			Sleep 10
			SendEvent,{Ctrl Up}
			SendEvent,{Enter}

			Sleep 10
			Clipboard := clipBackup
		}
		Return
	}
;	Button press
	else {
		; if PID is not POE, need to replace it
		if !WinExist("ahk_pid " gamePID " ahk_group POEGame") {
			PIDArray := Get_Matching_Windows_Infos("PID")
			handlersArray := Get_Matching_Windows_Infos("ID")
			if ( handlersArray.MaxIndex() = "" ) {
				Tray_Notifications_Show(programName, "The PID assigned to the tab does not belong to a POE instance, and no POE instance was found!`n`nPlease click the button again after restarting the game.")
				Return 1
			}
			else {
				newPID := GUI_Replace_PID(handlersArray, PIDArray)
				setInfos := Object(), setInfos.NewPID := newPID, setInfos.OldPID := gamePID, setInfos.TabID := tabInfos.TabID
				Gui_Trades_Set_Trades_Infos(setInfos)
				gamePID := newPID
			}
		}
		; Activate game window
		titleMatchMode := A_TitleMatchMode
		SetTitleMatchMode, RegEx ; RegEx = Fix some case where specifying only the pid does not work
		WinActivate,[a-zA-Z0-9_] ahk_pid %gamePID%
		WinWaitActive,[a-zA-Z0-9_] ahk_pid %gamePID%, ,5
		if (!ErrorLevel) {
			; Backup clipboard
			clipBackup := ClipboardAll
			Clipboard :=
			Sleep 10

			Loop 3 {
				messageToSend := message%A_Index%
				if ( !messagetoSend ) {
					Break
				}
				else {
					firstChar := SubStr(messageToSend, 1, 1) ; Get first char, to compare if its a special chat command

					; Set msg as new clipboard
					Clipboard := messageToSend
					ClipWait, 2, 1
					Sleep 1

					; Opening the chat window
					if chatVK in 0x1,0x2,0x4,0x5,0x6,0x9C,0x9D,0x9E,0x9F ; Mouse buttons
					{
						keyDelay := A_KeyDelay, keyDuration := A_KeyDuration
						SetKeyDelay, 10, 10
						ControlSend, ,{VK%keyVK%}, [a-zA-Z0-9_] ahk_pid %gamePID% ; Mouse buttons tend to activate the window under the cursor.
																				  ; Therefore, we need to send the key to the actual game window.
  						SetKeyDelay,% keyDelay,% keyDuration
					}
					else
						SendEvent,{VK%chatVK%}

					; Clearing chat
					if firstChar not in /,`%,&,#,@ ; Not a command. We send / then remove it to make sure chat is empty
						SendEvent,{/}{BackSpace}

					; Pasting the message, and send
					SendEvent,{Ctrl Down} ; Separating the inputs fixes an issue where ^v could fail (rarely, but stil happened)
					Sleep 10
					SendEvent,{v}
					Sleep 10
					SendEvent,{Ctrl Up}
					if !( specialEvent.doNotSend )
						SendEvent,{Enter}
				}
			}
			; Restore clipboard
			Sleep 10
			Clipboard := clipBackup
		}
	}
}


StringToHex(String) {
;		Original script author ahklerner
;		autohotkey.com/board/topic/15831-convert-string-to-hex/?p=102873
	
	formatInteger := A_FormatInteger 	;Save the current Integer format
	SetFormat, Integer, Hex ; Set the format of integers to their Hex value
	
	;Parse the String
	Loop, Parse, String 
	{
		CharHex := Asc(A_LoopField) ; Get the ASCII value of the Character (will be converted to the Hex value by the SetFormat Line above)
		; StringTrimLeft, CharHex, CharHex, 2 ; Comment out the following line to leave the '0x' intact
		HexString .= CharHex . " " ; Build the return string
	}
	SetFormat, Integer,% formatInteger ; Set the integer format to what is was prior to the call
	
	HexString = %HexString% ; Remove blankspaces	
	Return HexString
}

Install_Font_Files() {
/*		Compare local and installed fonts file size
		If any font is not installed or is different, run FontReg.
*/
	global ProgramValues, RunParameters

	fontsFolder := ProgramValues.Fonts_Folder
	winFonts := A_WinDir "\Fonts"

	loc_FontFiles := []
	win_FontFiles := []

;	Get local fonts. Check if they're installed. Also check for duplicates (fontname_0.ttf)
	Loop, Files, %fontsFolder%\*.ttf
	{
		SplitPath, A_LoopFileName, , , , fileNameNoExt
		loc_FontFiles.Push(fileNameNoExt)
		if FileExist(winFonts "\" A_LoopFileName)
			win_FontFiles.Push(fileNameNoExt)
		Loop {
			fileNameDupe := fileNameNoExt "_" A_Index-1
			if !FileExist(winFonts "\" fileNameDupe ".ttf")
				break
			else
				win_FontFiles.Push(fileNameDupe)
		}
	}

;	Remove fonts that are already installed from fontsNeedInstall
	fontsNeedInstall := loc_FontFiles
	for locID, locFontFile in loc_FontFiles {
		for winID, winFontFile in win_FontFiles {
			if RegExMatch(winFontFile, locFontFile "_\d") || (locFontFile = winFontFile) {
				FileGetSize, locSize,% fontsFolder "\" locFontFile ".ttf"
				FileGetSize, winSize,% winFonts "\" winFontFile ".ttf"

				if (locSize = winSize){
					fontsNeedInstall[locID] := ""
				}
			}
		}
	}

;	Get font that need to be installed names and number
	fontsNeedInstall_Index := 0, fontsNeedsInstall_Names := ""
	for id, fontName in fontsNeedInstall {
		if (fontName)
			fontsNeedInstall_Index++, fontsNeedsInstall_Names .= fontName ","
	}

;	All fonts are already installed.
	if (!fontsNeedInstall_Index)
		Return

;	Not running as admin. We need UAC to install a font.
	if (!A_IsAdmin || RunParameters.NoAdmin) {
		MsgBox, 4096,% ProgramValues.Name " - Missing admin rights.",% "Fonts need to be installed on your system for the tool to work correctly."
										. "`nThe following fonts will be installed on your system (" fontsNeedInstall_Index "): " fontsNeedsInstall_Names
										. "`nPlease allow the next UAC prompt."
										. "`n(Rebooting may be neccessary after installing the fonts)"
	}

;	Run FontReg with /Copy to install fonts.
	try Run,% fontsFolder "/FontReg.exe /Copy",% fontsFolder
}

Extract_Assets() {
	global ProgramValues
	static 0 ; Bypass warning "local same as global" for var 0

	if (A_IsCompiled) {
		#Include, *i File_Install.ahk
		Return
	}

;	File location
	installFile := % A_ScriptDir "\File_Install.ahk"
	FileDelete,% installFile

;	Pass ProgramValues to file
	appendToFile .= "tempParams := {}`n"
				 .	"Loop, %0% {`n"
				 .	"	param := `%A_Index`%`n"
				 . 	"	if RegExMatch(param, ""/Fonts_Folder=(.*)"", found) {`n"
				 . 	"		tempParams.Fonts_Folder := found1`n"
				 . 	"	}`n"
				 . 	"	if RegExMatch(param, ""/SFX_Folder=(.*)"", found) {`n"
				 . 	"		tempParams.SFX_Folder := found1`n"
				 . 	"	}`n"
				 . 	"	if RegExMatch(param, ""/Others_Folder=(.*)"", found) {`n"
				 . 	"		tempParams.Others_Folder := found1`n"
				 . 	"	}`n"
				 . 	"	if RegExMatch(param, ""/Data_Folder=(.*)"", found) {`n"
				 . 	"		tempParams.Data_Folder := found1`n"
				 . 	"	}`n"
				 . 	"	if RegExMatch(param, ""/Skins_Folder=(.*)"", found) {`n"
				 . 	"		tempParams.Skins_Folder := found1`n"
				 . 	"	}`n"
				 .	"	ProgramValues := tempParams`n"
				 . 	"}`n"

;	FONTS
	resFolder := A_ScriptDir "\Resources\Fonts"
	allowedExt := "ttf,ini"
	allowedFiles := "FontReg.exe"
	appendToFile .= "`n; FONT`n"

	appendToFile .= "if !( InStr(FileExist(ProgramValues.Fonts_Folder), ""D"") )`n"
				  . "	FileCreateDir,`% ProgramValues.Fonts_Folder `n"
	Loop, Files,% resFolder "\*"
	{
		RegExMatch(A_LoopFileFullPath, "\\Resources\\(.*)", path)
		filePath := "Resources\" path1
		
		if A_LoopFileName in %allowedFiles%
			appendToFile .= "FileInstall, " filePath ",`% ProgramValues.Fonts_Folder """ "\" A_LoopFileName """" ", 1`n"
		else if A_LoopFileExt in %allowedExt%			
			appendToFile .= "FileInstall, " filePath ",`% ProgramValues.Fonts_Folder """ "\" A_LoopFileName """" ", 1`n"
	}

;	SFX
	resFolder := A_ScriptDir "\Resources\SFX"
	allowedExt := "wav,mp3"
	appendToFile .= "`n; SFX`n"

	appendToFile .= "if !( InStr(FileExist(ProgramValues.SFX_Folder), ""D"") )`n"
				  . "	FileCreateDir,`% ProgramValues.SFX_Folder `n"
	Loop, Files,% resFolder "\*"
	{
		RegExMatch(A_LoopFileFullPath, "\\Resources\\(.*)", path)
		filePath := "Resources\" path1

		if A_LoopFileExt in %allowedExt%
			appendToFile .= "FileInstall, " filePath ",`% ProgramValues.SFX_Folder """ "\" A_LoopFileName """" ", 1`n"
	}

;	DATA
	resFolder := A_ScriptDir "\Resources\Data"
	appendToFile .= "`n; DATA`n"

	appendToFile .= "if !( InStr(FileExist(ProgramValues.Data_Folder), ""D"") )`n"
				  . "	FileCreateDir,`% ProgramValues.Data_Folder `n"
	Loop, Files,% resFolder "\*"
	{
		RegExMatch(A_LoopFileFullPath, "\\Resources\\(.*)", path)
		filePath := "Resources\" path1

		appendToFile .= "FileInstall, " filePath ",`% ProgramValues.Data_Folder """ "\" A_LoopFileName """" ", 1`n"
	} 

;	OTHERS
	resFolder := A_ScriptDir "\Resources\Others"
	allowedFiles := "DonatePaypal.png,Icon.png"
	appendToFile .= "`n; OTHERS`n"

	appendToFile .= "if !( InStr(FileExist(ProgramValues.Others_Folder), ""D"") )`n"
				  . "	FileCreateDir,`% ProgramValues.Others_Folder `n"
	Loop, Files,% resFolder "\*"
	{
		RegExMatch(A_LoopFileFullPath, "\\Resources\\(.*)", path)
		filePath := "Resources\" path1

		if A_LoopFileName in %allowedFiles%
			appendToFile .= "FileInstall, " filePath ",`% ProgramValues.Others_Folder """ "\" A_LoopFileName """" ", 1`n"
	} 

;	SKINS
	skinNames := []
	resFolder := A_ScriptDir "\Resources\Skins"
	appendToFile .= "`n; SKINS`n"
	allowedExt := "png,ico,ini"
	excludedFolders := "_Old"

	appendToFile .= "if !( InStr(FileExist(ProgramValues.Skins_Folder), ""D"") )`n"
				  . "	FileCreateDir,`% ProgramValues.Skins_Folder `n"
	Loop, Files,% resFolder "\*", D
	{
		if A_LoopFileName not in %excludedFolders%
		skinNames.Push(A_LoopFileName)
	}
	for id, skinName in skinNames {
		appendToFile .= "`n" A_Tab "; " skinName "`n"

		appendToFile .= "if !( InStr(FileExist(ProgramValues.Skins_Folder ""\" skinName """), ""D"") )`n"
					  . "	FileCreateDir,`% ProgramValues.Skins_Folder ""\" skinName """`n"
		Loop, Files,% resFolder "\" skinName "\*"
		{
			RegExMatch(A_LoopFileFullPath, "\\Resources\\(.*)", path)
			filePath := "Resources\" path1

			if A_LoopFileExt in %allowedExt%
				appendToFile .= "FileInstall, " filePath ",`% ProgramValues.Skins_Folder ""\" skinName "\" A_LoopFileName """" ", 1`n"
		}
	}

;	ADD TO FILE
	FileAppend,% appendToFile "`n",% installFile
	Sleep 10
	RunWait,% installFile
		   . " /Fonts_Folder=" 	"""" ProgramValues.Fonts_Folder """"
		   . " /SFX_Folder=" 	"""" ProgramValues.SFX_Folder """"
		   . " /Data_Folder=" 	"""" ProgramValues.Data_Folder """"
		   . " /Others_Folder=" """" ProgramValues.Others_Folder """"
		   . " /Skins_Folder=" 	"""" ProgramValues.Skins_Folder """"
}

Close_Previous_Program_Instance() {
/*
 *			Prevents from running multiple instances of this program
 *			Works by reading the last PID and process name from the .ini
 *				, checking if there is an existing match
 *				and closing if a match is found
*/
	global ProgramValues, RunParameters

	if ( RunParameters.NoReplace = 1 ) {
		Return
	}

	iniFilePath := ProgramValues.Ini_File

	IniRead, lastPID,% iniFilePath,PROGRAM,PID
	IniRead, lastProcessName,% iniFilePath,PROGRAM,FileProcessName

	Process, Exist, %lastPID%
	existingPID := ErrorLevel
	if ( existingPID = 0 )
		Return ; No match found
	else {
		HiddenWindows := A_DetectHiddenWindows
		DetectHiddenWindows, On ; Required to access the process name
		WinGet, existingProcessName, ProcessName, ahk_pid %existingPID% ; Get process name from PID
		DetectHiddenWindows, %HiddenWindows%
		if ( existingProcessName = lastProcessName ) { ; Match found, close the previous instance
			if (A_IsAdmin) {
				Process, Close, %existingPID%
				Process, WaitClose, %existingPID%
			}
			else { ; Unable to close process due to lack of admin 
				funcParams := {	 Border_Color:"White"
								,Background_Color:"Red"
								,Title:"Missing admin rights, unable to close instance."
								,Title_Color:"White"
								,Text:"Previous instance detected."
								. "`nUnable to close it due to missing admin rights."
								. "`nPlease close it before continuing."
								. "`n`nThis window will be closed automatically."
								,Text_Color:"White"
								,Condition:"Previous_Instance_Close"}
				GUI_Beautiful_Warning(funcParams)
			}
		}
	}
}

GUI_Trades_Cycle:
	Gui_Trades_Cycle_Func()
Return

Gui_Trades_Cycle_Func() {
/*
 *			Retrieves the existing POE instances
 *				then cycle the Trades GUI through each instance
 *				for every time the user triggers the function
 *			Once the last match was reached
 *				we reset back to the first match
*/
	global ProgramValues, TradesGUI_Values, ProgramSettings

	programName := ProgramValues.Name
	nextID := TradesGUI_Values.Dock_Window_Num
	nextID += 1

	if ( ProgramSettings.Trades_GUI_Mode != "Overlay" )
		Return

	if !Trades_GUI_Exists() {
		Tray_Notifications_Show(programName, "Couldn't find the Trades GUI!`nOperation Canceled.")
		Return
	}
	matchHandlers := Get_Matching_Windows_Infos("ID")
	TradesGUI_Values.Dock_Window_Num := nextID
	if ( TradesGUI_Values.Dock_Window_Num > matchHandlers.MaxIndex() ) {
		TradesGUI_Values.Dock_Window_Num := 0
	}
	TradesGUI_Values.Insert("Dock_Window", matchHandlers[TradesGUI_Values["Dock_Window_Num"]])
	try
		Gui_Trades_Set_Position()

	Logs_Append(A_ThisFunc, {Dock_Window:TradesGUI_Values.Dock_Window, Total_Matchs:matchHandlers.MaxIndex() + 1})
}

Get_Matching_Windows_Infos(mode) {
/*
 *			Retrieves a list of all existing windows
 *				then returns an array containing only those matching the game
*/
	global POEGameList

	matchsArray := Object()
	matchsList := ""
	index := 0

	HiddenWindows := A_DetectHiddenWindows
	DetectHiddenWindows, Off

	WinGet, windows, List
	Loop %windows%
	{
		ExeID := windows%A_Index%
		WinGet, ExeName, ProcessName,% "ahk_id " ExeID
		WinGet, ExePID, PID,% "ahk_id " ExeID
		if ExeName in %POEGameList%
		{
			if ( mode = "ID" ) {
				if ExeID not in %matchsList%
					matchsList .= ExeID ","
			}
			else if ( mode = "PID" ){
				if ExePID not in %matchsList%
					matchsList .= ExePID ","
			}
		}
	}
	Loop, Parse, matchsList,% ","
	{
		if ( A_LoopField != "" ) {
			matchsArray.Insert(index, A_LoopField)
			index++
		}
	}
	DetectHiddenWindows, %HiddenWindows%
	return matchsArray
}

Create_Tray_Menu() {
/*
 *			Creates the Tray Menu
*/
	global ProgramValues, ProgramSettings, DebugValues

	programName := ProgramValues.Name, programVersion := ProgramValues.Version

	Menu, Tray, NoStandard
	Menu, Tray, DeleteAll
	Menu, Tray, Tip,% programName " v" programVersion
	if ( DebugValues.settings.show_tray_menu ) {
		Menu, Debug, Add,Reload debug JSON, Load_Debug_JSON
		Menu, Debug, Add,
		Menu, Debug, Add,Open game folder, Tray_Open_Game_Folder
		Menu, Debug, Add,Open local folder, Tray_Open_Local_Folder
		Menu, Debug, Add,
		Menu, Debug, Add,Delete Preferences file, Tray_Delete_Preferences
		Menu, Debug, Add,Delete entire local folder, Tray_Delete_Local_Folder
		Menu, Tray, Add, Debug,:Debug
	}
	Menu, Tray, Add,Settings, Gui_Settings
	Menu, Tray, Add,About?, Gui_About
	Menu, Tray, Add,
	Menu, Tray, Add,My Stats, Gui_Stats
	Menu, Tray, Add, 
	Menu, Tray, Add,Cycle Overlay,GUI_Trades_Cycle
	Menu, Tray, Add, 
	Menu, Tray, Add,Mode: Overlay,GUI_Trades_Mode
	Menu, Tray, Add,Mode: Window,GUI_Trades_Mode
	Menu, Tray, Add, 
	Menu, Tray, Add,Reload, Reload_Func
	Menu, Tray, Add,Close, Exit_Func
	Menu, Tray, Check,% "Mode: " ProgramSettings.Trades_GUI_Mode
	Menu, Tray, Icon
	if ( A_IconHidden ) {
		Menu, Tray, NoIcon
		Menu, Tray, Icon
	}
	if ( !A_IsCompiled && FileExist(A_ScriptDir "\icon.ico") )
		Menu, Tray, Icon,% A_ScriptDir "\icon.ico"
	Return

	Tray_Delete_Preferences:
		FileDelete,% ProgramValues.Ini_File
	Return

	Tray_Delete_Local_Folder:
		MsgBox, 4100, ,% "THIS WILL DELETE THE ENTIRE FOLDER`NMAKE SURE TO BACKUP YOUR FILES BEFORE CONTINUING.`N`NARE YOU SURE?"
		IfMsgBox, Yes
		{
			FileRemoveDir,% ProgramValues.Local_Folder, 1
			Reload_Func()
		}
	Return

	Tray_Open_Game_Folder:
		Run,% ProgramValues.Game_Folder,,UseErrorLevel
		if (A_LastError) {
			ErrorMsg := Get_System_Error_Codes(A_LastError)
		}
	Return

	Tray_Open_Local_Folder:
		Run,% ProgramValues.Local_Folder,,UseErrorLevel
		if (A_LastError) {
			ErrorMsg := Get_System_Error_Codes(A_LastError)
		}
	Return
}

Get_System_Error_Codes(Err) {
	global ProgramValues

	Msg := (Err=2)?("Code: " Err " (ERROR_FILE_NOT_FOUND) `nThe system cannot find the file specified.")
		  :(Err=3)?("Code: " Err " (ERROR_PATH_NOT_FOUND) `nThe system cannot find the path specified.")
		  :(Err=5)?("Code: " Err " (ERROR_ACCESS_DENIED) `nAccess is denied.")
		  :("Code: " Err " `nReport to Microsoft System Error Codes to get description of the error.")

	MsgBox, 4096,% ProgramValues.Name,% Msg
}


Run_As_Admin() {
/*			If not running with as admin, reload with admin rights. 
*/
	global ProgramValues, ProgramSettings, RunParameters, DebugValues

	programName := ProgramValues.Name

	IniWrite,% A_IsAdmin,% ProgramValues.Ini_File,PROGRAM,Is_Running_As_Admin

	if ( A_IsAdmin || RunParameters.NoAdmin ) {
		IniWrite, 0,% ProgramValues.Ini_File,PROGRAM,Run_As_Admin_Attempts
		Return
	}

	IniRead, attempts,% ProgramValues.Ini_File,PROGRAM,Run_As_Admin_Attempts
	attempts := (attempts=""||attempts="ERROR")?(0):(attempts)
	IniWrite,% attempts+1,% ProgramValues.Ini_File,PROGRAM,Run_As_Admin_Attempts
	if ( attempts ) {
		IniWrite, 0,% ProgramValues.Ini_File,PROGRAM,Run_As_Admin_Attempts
		FileCreateShortcut,% A_ScriptFullPath,% A_ScriptDir "\" programName " (No Admin).lnk",% A_ScriptDir,% "/NoAdmin"
		Gui_AdminWarn()
		ExitApp
	}
	if !(DebugValues.settings.no_admin_splash) { ; only show if disabled
		funcParams := {  Background_Color:"Green"
						,Border_Color:"White"
						,Title_Color:"White"
						,Text:"Reloading to request admin privilieges in XX...`nClick on this window to reload now."
						,Text_Color:"White"
						,Condition:"Reload_Timer"
						,Condition_Count:3
						,Close_On_Click:true}
		GUI_Beautiful_Warning(funcParams)
	}
	Reload_Func()
}

GUI_Beautiful_Warning(params) {
	global ProgramValues

	guiWidthBase := 350, guiHeightBase := 50, guiHeightNoUnderline := 30
	guiFontName := "Consolas", guiFontSize := "10 Bold"

	borderSize := 2, borderColor := params.Border_Color
	backgroundCol := params.Background_Color
	warnTitle := params.Title, warnTitleColor := params.Title_Color
	warnText := params.Text,warnTextColor := params.Text_Color

	condition := params.Condition, count := params.Condition_Count

	underlineExists := (warnTitle)?(true):(false)
	xOffset := 10, yOffset := (underlineExists)?(5):(20)

	txtSize := Get_Text_Control_Size(warnText, guiFontName, guiFontSize, guiWidthBase+xOffset)
	guiWidth := (txtSize.W > guiWidthBase)?(txtSize.W+xOffset):(guiWidthBase)
	guiHeight := (underlineExists)?(guiHeightBase + txtSize.H):(guiHeightNoUnderline + txtSize.H)

	closeOnClick := params.Close_On_Click

	if (condition = "Previous_Instance_Close") {
		SetTimer, GUI_Beautiful_Warning_Instance_WaitClose, 1000
	}

	static WarnTextHandler

	Gui, BeautifulWarn:Destroy
	Gui, BeautifulWarn:New, +AlwaysOnTop +ToolWindow -Caption -Border +LabelGui_Beautiful_Warning_ hwndGuiBeautifulWarningHandler,% ProgramValues.Name
	Gui, BeautifulWarn: Margin, 0, 0
	Gui, BeautifulWarn: Color,% backgroundCol
	Gui, BeautifulWarn: Font,% "S" guiFontSize,% guiFontName
	Gui, BeautifulWarn: Add, Progress,% "x0" . " y0" . " h" borderSize . " w" guiWidth . " Background" borderColor ; Top
	Gui, BeautifulWarn: Add, Text,% "x" xOffset " ym+5 w" guiWidth-(xOffset*2) " c" warnTitleColor " Center BackgroundTrans Section",% ProgramValues.Name
	if (warnTitle) {
		Gui, BeautifulWarn: Add, Text,% "x" xOffset " w" guiWidth-(xOffset*2) " c" warnTitleColor "  Center BackgroundTrans Section",% warnTitle
		Gui, BeautifulWarn: Add, Progress,% "x" xOffset . " y+5 h" borderSize . " w" guiWidth-(xOffset*2) . " Background" borderColor " Section" ; Underline
	}
	Gui, BeautifulWarn: Add, Progress,% "x" guiWidth-borderSize . " y0" . " h" guiHeight . " w" borderSize . " Background" borderColor ; Right
	Gui, BeautifulWarn: Add, Progress,% "x0" . " y" guiHeight-borderSize . " h" borderSize . " w" guiWidth . " Background" borderColor ; Bot
	Gui, BeautifulWarn: Add, Progress,% "x0" . " y0" . " h" guiHeight . " w" borderSize . " Background" borderColor ; Left
	Gui, BeautifulWarn: Add, Text,% "x" xOffset " ys+" yOffset " w" guiWidth-(xOffset*2) " hwndWarnTextHandler c" warnTextColor " Center BackgroundTrans",% warnText
	if (condition = "Reload_Timer") {
		GoSub GUI_Beautiful_Warning_Reload_Timer
		SetTimer, GUI_Beautiful_Warning_Reload_Timer, 1000
	}

	Gui, BeautifulWarn: Add, Text,x0 y0 w%guiWidth% h%guiHeight% BackgroundTrans gGUI_Beautiful_Warning_OnLeftClick,% ""
	Gui, BeautifulWarn: Show, w%guiWidth% h%guiHeight%

	WinWait,% "ahk_id " GuiBeautifulWarningHandler
	WinWaitClose,% "ahk_id " GuiBeautifulWarningHandler
	Return

	GUI_Beautiful_Warning_ContextMenu:
		GoSub GUI_Beautiful_Warning_OnLeftClick
	Return

	GUI_Beautiful_Warning_OnLeftClick:
		if (closeOnClick) {
			SetTimer, GUI_Beautiful_Warning_Reload_Timer, Off
			Gui, BeautifulWarn:Destroy
		}
	Return

	GUI_Beautiful_Warning_Reload_Timer:
		StringReplace,warnTextEdit, warnText,XX,%count%
		GuiControl, BeautifulWarn:,% WarnTextHandler,% warnTextEdit
		if (!count)
			Gui, BeautifulWarn:Destroy
		count--
	Return

	GUI_Beautiful_Warning_Instance_WaitClose:
		IniRead, lastPID,% ProgramValues.Ini_File,PROGRAM,PID
		IniRead, lastProcessName,% ProgramValues.Ini_File,PROGRAM,FileProcessName

		Process, Exist, %lastPID%
		existingPID := ErrorLevel

		HiddenWindows := A_DetectHiddenWindows
		DetectHiddenWindows, On ; Required to access the process name

		WinGet, existingProcessName, ProcessName, ahk_pid %existingPID% ; Get process name from PID
		DetectHiddenWindows, %HiddenWindows%
		if ( existingProcessName != lastProcessName ) { ; Match found, close the previous instance
			Gui,BeautifulWarn:+OwnDialogs
			SetTimer,% A_ThisLabel, Off
			Gui, BeautifulWarn:Destroy
		}
	Return

	GUI_Beautiful_Warning_Close:
		Gui, BeautifulWarn:Destroy
	Return
	GUI_Beautiful_Warning_Escape:
		GoSub GUI_Beautiful_Warning_Close
	Return
}

Gui_AdminWarn() {
	global ProgramValues
	static UnlockBtn

	Gui, AdminWarn:Destroy
	Gui, AdminWarn:New, +AlwaysOnTop -SysMenu -MinimizeBox -MaximizeBox +LabelGui_AdminWarn_ hwndGuiAdminWarnHandler,% ProgramValues.Name
	Gui, AdminWarn: Font, ,Consolas
	Gui, AdminWarn: Font, Bold
	Gui, AdminWarn: Add, GroupBox, xm ym cRed w460 h140 Center Section c000000,% "IMPORTANT INFORMATIONS, PLEASE READ"
	Gui, AdminWarn: Add, Text,xs+15 ys+25 Center,% ProgramValues.Name " was unable to start with admin rights previously."
	. "`nTry right clicking the executable and choose ""Run as Administrator""."
	. "`n`nIf for some reason you prefer not to use admin elevation, please use"
	. "`nthe shorcut that has been placed in the same folder as the executable."
	. "`nPlease be aware that unexpected behaiour may happen."
	. "`n`nThe tool will exit upon closing this window."
	Gui, AdminWarn: Add, Button, xs w460 h30 Disabled vUnlockBtn gGui_AdminWarn_Accept,% "This button will be unlocked in 10..."
	Gui, AdminWarn: Show
	WinWait,% "ahk_id " GuiAdminWarnHandler
	count := 10
	Loop %count% {
		Sleep 1000
		count--
		GuiControl, AdminWarn:, UnlockBtn,% "This button will be unlocked in " count "..."
	}
	GuiControl, AdminWarn:, UnlockBtn,% "Alright, got it!"
	GuiControl, AdminWarn:Enable, UnlockBtn
	WinWaitClose,% "ahk_id " GuiAdminWarnHandler
	Return

	Gui_AdminWarn_Accept:
		Gui, AdminWarn:Destroy
	Return
	Gui_AdminWarn_Close:
	Return
	Gui_AdminWarn_Escape:
	Return
}

Handle_CommandLine_Parameters() {
	global 0
	global RunParameters, ProgramValues, ProgramSettings

	programName := ProgramValues.Name

	Loop, %0% { ; Process cmdline parameters
		param := %A_Index%
		if ( param = "/NoReplace" ) {
			RunParameters.Insert("NoReplace", 1)
		}
		else if RegExMatch(param, "/GamePath=(.*)", found) {
			if FileExist(found1) {
				RunParameters.Insert("GamePath", found1)
				found1 := ""
			}
			else {
				MsgBox, 4096,% programName,% "The /GamePath parameter was detected but the specified file does not exist:"
				. "`n" found1
				. "`n`nIf you need help about Command Line Parameters, please check the WIKI here: https://github.com/lemasato/POE-Trades-Companion/wiki"
				. "`n`nThe program will now exit."
				ExitApp
			}
		}
		else if RegExMatch(param, "/PrefsFile=(.*)", found) {
			path := ProgramValues.Local_Folder "/" found1
			ProgramValues.Insert("Ini_File", path)
			found1 := "", path = ""
		}
		else if RegExMatch(param, "/GameINI=(.*)", found) {
			if FileExist(found1) {
				ProgramValues.Insert("Game_Ini_File", found1)
				found1 := ""
			}
			else {
				MsgBox, 4096,% programName,% "The /GameINI parameter was detected but the specified file does not exist:"
				. "`n" found1
				. "`n`nIf you need help about Command Line Parameters, please check the WIKI here: https://github.com/lemasato/POE-Trades-Companion/wiki"
				. "`n`nThe program will now exit."
				ExitApp
			}
		}
		else if RegExMatch(param, "/MyDocuments=(.*)", found) {
			RunParameters.Insert("MyDocuments", found1)
		}
		else if (param="/NoAdmin") {
			RunParameters.Insert("NoAdmin", 1)
		}
		else if RegExMatch(param, "/Screen_DPI=(.*)", found) {
			ProgramSettings.Insert("Screen_DPI", found1)
		}
	}
}


Tray_Refresh() {
/*		Remove any dead icon from the tray menu
 *		Should work both for W7 & W10
 */
	WM_MOUSEMOVE := 0x200
	detectHiddenWin := A_DetectHiddenWindows
	DetectHiddenWindows, On

	allTitles := ["ahk_class Shell_TrayWnd"
			, "ahk_class NotifyIconOverflowWindow"]
	allControls := ["ToolbarWindow321"
				,"ToolbarWindow322"
				,"ToolbarWindow323"
				,"ToolbarWindow324"]
	allIconSizes := [24,32]

	for id, title in allTitles {
		for id, controlName in allControls
		{
			for id, iconSize in allIconSizes
			{
				ControlGetPos, xTray,yTray,wdTray,htTray,% controlName,% title
				y := htTray - 10
				While (y > 0)
				{
					x := wdTray - iconSize/2
					While (x > 0)
					{
						point := (y << 16) + x
						PostMessage,% WM_MOUSEMOVE, 0,% point,% controlName,% title
						x -= iconSize/2
					}
					y -= iconSize/2
				}
			}
		}
	}

	DetectHiddenWindows, %detectHiddenWin%
}

Reload_Func() {
/*
 *		Reload the application, including the command-line parameters.
 * 
 *		Credits to art for the DllCall to reload in admin mode.
 *		https://autohotkey.com/board/topic/46526-run-as-administrator-xpvista7-a-isadmin-params-lib/?p=600596
*/
	global 0
	global RunParameters, ProgramSettings, ProgramValues


	Sleep 10
	Loop, %0%
	{
		param := RegExReplace(%A_Index%, "(.*)=(.*)", "$1=""$2""") ; Add quotation mark to the parameter. Missing quotation marks would incorectly parse the run parameters on next load.
		params .= A_Space . param
	}

	if !(A_IsAdmin) { ; Not running as admin
		dpiFactor := Get_DPI_Factor()
		params .= A_Space . "/MyDocuments=" """" A_MyDocuments """" ; Pass the current user MyDocuments as parameter
		params .= A_Space . "/Screen_DPI=" """" dpiFactor """" ; Pass the current user Win DPI as parameter
	}

	else { ; We are admin
		if (RunParameters.MyDocuments)
			params .= A_Space . "/MyDocuments=" """" RunParameters.MyDocuments """"
		if (ProgramSettings.Screen_DPI)
			params .= A_Space . "/Screen_DPI=" """" ProgramSettings.Screen_DPI """" ; Pass the current user Win DPI as parameter
	}

	if ( A_IsAdmin || RunParameters.NoAdmin ) {
		Gui_Trades_Save_Pending_Backup()
	}

	Exit_Func("Reload","")
	DllCall("shell32\ShellExecute" (A_IsUnicode ? "":"A"),uint,0,str,"RunAs",str,(A_IsCompiled ? A_ScriptFullPath
	: A_AhkPath),str,(A_IsCompiled ? "": """" . A_ScriptFullPath . """" . A_Space) params,str,A_WorkingDir,int,1)
	OnExit("Exit_Func", 0)
	ExitApp

	Sleep 10000
}

Gui_Trades_Save_Pending_Backup() {
/*		Save all pending trades in a file.
 */
	global ProgramValues

	if (ProgramValues.Keep_Backup)
		Return

	allTrades := Gui_Trades_Manage_Trades("GET_ALL")
	FileDelete,% ProgramValues.Trades_Backup_File
	for key, element in allTrades {
		IniWrite,% element,% ProgramValues.Trades_Backup_File,GENERAL,% key
	}
}

Gui_Trades_Save_Position(X="FALSE", Y="FALSE") {
;		Save the current X and Y positions of the Trades GUI.
;		Only if the GUI is in Winodw Mode.
	global ProgramSettings, ProgramValues, TradesGUI_Values

	iniFilePath := ProgramValues.Ini_File

	if (IsNum(X) && IsNum(Y)) {
		IniWrite,% X,% iniFilePath,PROGRAM,X_POS
		IniWrite,% Y,% iniFilePath,PROGRAM,Y_POS
	}
	else {
		if ( ProgramSettings.Trades_GUI_Mode = "Window" ) && Trades_GUI_Exists() {
			WinGetPos, xpos, ypos, , ,% "ahk_id " TradesGUI_Values.Handler
			if (IsNum(xpos) && IsNum(ypos)) {
				IniWrite,% xpos,% iniFilePath,PROGRAM,X_POS
				IniWrite,% ypos,% iniFilePath,PROGRAM,Y_POS
			}
		}
	}
}

Manage_Font_Resources(mode) {
	global ProgramValues, ProgramFonts

	fontsFolder := ProgramValues.Fonts_Folder

	Loop, Files, %fontsFolder%\*.*
	{
		if (A_LoopFileExt = "ttf") {
			if ( mode="LOAD") {
				DllCall( "GDI32.DLL\AddFontResourceEx", Str, A_LoopFileFullPath,UInt,(FR_PRIVATE:=0x10), Int,0)
				fontTitle := FGP_Value(A_LoopFileFullPath, 21)	; 21 = Title
				ProgramFonts.Insert(A_LoopFileName, fontTitle)
			}
			else if ( mode="UNLOAD") {
				DllCall( "GDI32.DLL\RemoveFontResourceEx",Str, A_LoopFileFullPath,UInt,(FR_PRIVATE:=0x10),Int,0)
			}
		}
	}
}

IsNum(str) {
	if str is number
		return true
	return false
}

Get_Control_Coords(guiName, ctrlHandler) {
/*		Retrieve a control's position and return them in an array.
		The reason of this function is because the variable content would be blank
			unless its sub-variables (coordsX, coordsY, ...) were set to global.
			(Weird AHK bug)
*/
	GuiControlGet, coords, %guiName%:Pos,% ctrlHandler
	return {X:coordsX,Y:coordsY,W:coordsW,H:coordsH}
}

Exit_Func(ExitReason, ExitCode) {
	Gui_Trades_Save_Position()
	Manage_Font_Resources("UNLOAD")

	if ExitReason not in Reload
		ExitApp
}

DoNothing:
return

StringIn(string, _list) {
	if string in %_list%
		return true
}

StringContains(string, match) {
	if string contains %match%
		return true
}

SetUnicodeText(ByRef ptrUnicodeText,hWnd) {
/*		Original function author: derRaphael (nli)
 *		autohotkey.com/board/topic/28591-displaying-non-supported-characters-and-letters-in-gui/?p=183128
 */
   static WM_SETTEXT := 0x0C
   DllCall("SendMessageW", "UInt",hWnd, "UInt",WM_SETTEXT, "UInt",0, "Uint",&ptrUnicodeText)
}

Get_Text_Control_Size(txt, fontName, fontSize, maxWidth="") {
/*		Create a control with the specified text to retrieve
 *		the space (width/height) it would normally take
*/
	Gui, GetTextSize:Destroy
	Gui, GetTextSize:Font, S%fontSize%,% fontName
	if (maxWidth) 
		Gui, GetTextSize:Add, Text,x0 y0 +Wrap w%maxWidth% hwndTxtHandler,% txt
	else 
		Gui, GetTextSize:Add, Text,x0 y0 hwndTxtHandler,% txt
	coords := Get_Control_Coords("GetTextSize", TxtHandler)
	; Gui, GetTextSize:Show, w500
	Gui, GetTextSize:Destroy

	return coords

/*	Alternative version, with auto sizing

	Gui, GetTextSize:Font, S%fontSize%,% fontName
	Gui, GetTextsize:Add, Text,x0 y0 hwndTxtHandlerAutoSize,% txt
	coordsAuto := Get_Control_Coords("GetTextSize", TxtHandlerAutoSize)
	if (maxWidth) {
		Gui, GetTextSize:Add, Text,x0 y0 +Wrap w%maxWidth% hwndTxtHandlerFixedSize,% txt
		coordsFixed := Get_Control_Coords("GetTextSize", TxtHandlerFixedSize)
	}
	Gui, GetTextSize:Destroy

	if (maxWidth > coords.Auto)
		coords := coordsAuto
	else
		coords := coordsFixed

	return coords
*/
}

/* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * 
 *			TRAY NOTIFICATIONS														*
 * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * 
*/

Tray_Notifications_Adjust(fromNum, creationOrder) {
	global TrayNotifications_Handles

	RegExMatch(fromNum, "\d", fromNum)

	Loop, Parse, creationOrder,% ","
	{
		reverse := A_LoopField "," reverse
	}

	Loop, Parse, reverse,% "," 
	{
		if (A_LoopField) {
			
			if (gotem) {
				
				WinGetPos, , pY, , pH,% "ahk_id " TrayNotifications_Handles[previous]
				WinGetPos, , tY, , tH,% "ahk_id " TrayNotifications_Handles[A_LoopField]
				formula := (previous = fromNum)?(pY-(tH-pH)):(py-tH-10)
				; msgbox Moving %A_Loopfield% to %previous% - %creationOrder% - %reverse%
				WinMove,% "ahk_id " TrayNotifications_Handles[A_LoopField], , ,% formula
			}
			if (A_LoopField = fromNum)
				gotEm := true
			else {
				newOrder .= A_Loopfield ","
			}

			previous := A_Loopfield
		}
	}

	creationOrder := StrReplace(creationOrder, fromNum, "", "")
	Loop, Parse, creationOrder,% ","
	{
		if (A_LoopField)
			finalOrder .= A_LoopField ","
	}

	Return finalOrder
}

Tray_Notifications_Show(title, msg, params="") {
/*		Show a notification.
 *		Look based on w10 traytip.
*/
	static
	global SkinAssets, ProgramSettings, ProgramValues
	global TrayNotifications_Handles

;	Monitor infos
	local MonitorCount, MonitorPrimary, MonitorWorkArea
	local MonitorWorkAreaTop, MonitorWorkAreaBottom, MonitorWorkAreaLeft, MonitorWorkAreaRight
	SysGet, MonitorCount, MonitorCount
	SysGet, MonitorPrimary, MonitorPrimary
	SysGet, MonitorWorkArea, MonitorWorkArea,% MonitorPrimary

	; Calculating GUI size, based on content
	titleWidthMax := 310, textWidthMax := 330
	guiFontName := "Segoe UI", guiFontSize := "9", guiTitleFontSize := "10"
	titleSize := Get_Text_Control_Size(title, guiFontName, guiTitleFontSize, titleWidthMax)
	textSize := Get_Text_Control_Size(msg, guiFontName, guiFontSize, textWidthMax)


	; Declaring gui size
	guiWidth 	:= 350
	guiHeight 	:= (titleSize.H+5) + (textSize.H+20) ; 5=top margin, 20=title/msg margin
	borderSize 	:= 1

	; Fixing DPI Size
	guiHeight := guiHeight * ProgramSettings.Screen_DPI
	
	; Get first avaialble notification to replace
	index := 1
	Loop 5 {
		local winHandle := TrayNotifications_Handles[A_Index]
		if WinExist("ahk_id " winHandle) {
			index++
		}
		else Break
	}
	; Create a list of order of creation, as long as we didnt reach the max of 5 notifications
	if !(index > 5) {
		creationOrder .= index ","
	}
	; We reached the max. So we replace the oldest available notification.
	else {
		index := SubStr(creationOrder,1,1)
		StringTrimLeft, creationOrder, creationOrder, 2
		creationOrder .= index ","
	}
	; Make sure the list doesn't go beyond 10 chars (5 number and 5 comma)
	len := StrLen(creationOrder)
	if (len > 10) {
		StringTrimRight, creationOrder, creationOrder,% len-10
	}

	; Parameters
	fadeTimer := (params.Fade_Timer)?(params.Fade_Timer):(8000)
	_label := (params.Is_Update)?("Gui_TrayNotification_OnLeftClick_Updater"):("Gui_TrayNotification_OnLeftClick")


	Gui, TrayNotification%index%:Destroy
	Gui, TrayNotification%index%:New, +ToolWindow +AlwaysOnTop -Border +LastFound -SysMenu -Caption +LabelGui_TrayNotification_ +hwndhGuiTrayNotification%index%

	if !(TrayNotifications_Handles)
		TrayNotifications_Handles := {}
	TrayNotifications_Handles[index] := hGuiTrayNotification%index%
	

	Gui, TrayNotification%index%:Margin, 0, 0
	Gui, TrayNotification%index%:Color, 1f1f1f

	Gui, TrayNotification%index%:Add, Progress, x0 y0 w%guiWidth% h%borderSize% Background484848 ; Top
	Gui, TrayNotification%index%:Add, Progress, x0 y0 w%borderSize% h%guiHeight% Background484848 ; Left
	Gui, TrayNotification%index%:Add, Progress,% "x" guiWidth-borderSize " y0" " w" borderSize " h" guiHeight " Background484848" ; Right
	Gui, TrayNotification%index%:Add, Progress,% "x" 0 " y" guiHeight-borderSize " w" guiWidth " h" borderSize " Background484848" ; Bottom
	Gui, TrayNotification%index%:Add, Text,% "x0 y0 w" guiWidth " h" guiHeight " BackgroundTrans g" _label,% ""

	Gui, TrayNotification%index%:Font, S%guiTitleFontSize% Bold,% guiFontName
	Gui, TrayNotification%index%:Add, Text,% "xm+35" " ym+9" " w" titleWidthMax " BackgroundTrans cFFFFFF",% title
	Gui, TrayNotification%index%:Font, S%guiFontSize% Norm,% guiFontName
	Gui, TrayNotification%index%:Add, Text,% "xm+10" " ym+35" " w" textWidthMax " BackgroundTrans ca5a5a5",% msg
	Gui, TrayNotification%index%:Add, Picture, x5 y5 w24 h24 hwndhIcon,% SkinAssets.Misc_Icon

	showX := MonitorWorkAreaRight-guiWidth-10
	showY := MonitorWorkAreaBottom-guiHeight-10
	showW := guiWidth, showH := guiHeight
	Gui, TrayNotification%index%:Show,% "x" showX " y" showY " w" showW " h" showH " NoActivate"

	Loop 5 {
		if (A_Index != index ) {
			local winHandle := TrayNotifications_Handles[A_Index]
			if WinExist("ahk_id " winHandle) {
				WinGetPos, , _y, , _h, ahk_id %winHandle%
				WinMove, ahk_id %winHandle%, , ,% _y-guiHeight-10
			}
		}
	}

	Tray_Notifications_Fade(index, true)
	SetTimer, Gui_TrayNotification_Fade_%index%, -%fadeTimer%
	Return

	Gui_TrayNotification_Fade_1:
		ret1 := Tray_Notifications_Fade(1)
		if (ret1) {
			SetTimer, %A_ThisLabel%, -50
		}
		else {
			creationOrder := Tray_Notifications_Adjust(1, creationOrder)
			Gui, TrayNotification1:Destroy
		}
	Return
	Gui_TrayNotification_Fade_2:
		ret2 := Tray_Notifications_Fade(2)
		if (ret2) {
			SetTimer, %A_ThisLabel%, -50
		}
		else {
			creationOrder := Tray_Notifications_Adjust(2, creationOrder)
			Gui, TrayNotification2:Destroy
		}
	Return
	Gui_TrayNotification_Fade_3:
		ret3 := Tray_Notifications_Fade(3)
		if (ret3) {
			SetTimer, %A_ThisLabel%, -50
		}
		else {
			creationOrder := Tray_Notifications_Adjust(3, creationOrder)
			Gui, TrayNotification3:Destroy
		}
	Return
	Gui_TrayNotification_Fade_4:
		ret4 := Tray_Notifications_Fade(4)
		if (ret4) {
			SetTimer, %A_ThisLabel%, -50
		}
		else {
			creationOrder := Tray_Notifications_Adjust(4, creationOrder)
			Gui, TrayNotification4:Destroy
		}
	Return
	Gui_TrayNotification_Fade_5:
		ret5 := Tray_Notifications_Fade(5)
		if (ret5) {
			SetTimer, %A_ThisLabel%, -50
		}
		else {
			creationOrder := Tray_Notifications_Adjust(5, creationOrder)
			Gui, TrayNotification5:Destroy
		}
	Return

	Gui_TrayNotification_ContextMenu: ; Launched whenever the user right-clicks anywhere in the window except the title bar and menu bar.
		creationOrder := Tray_Notifications_Adjust(A_Gui, creationOrder)
		Gui, %A_GUI%:Destroy
	Return

	Gui_TrayNotification_OnLeftClick:
		creationOrder := Tray_Notifications_Adjust(A_Gui, creationOrder)
		Gui, %A_Gui%:Destroy
	Return

	Gui_TrayNotification_OnLeftClick_Updater:
		creationOrder := Tray_Notifications_Adjust(A_Gui, creationOrder)
		Gui, %A_Gui%:Destroy
		Download_Updater()
	Return
}

Tray_Notifications_Fade(index="", start=false) {
	static

	if (start) {
		transparency%index% := 240 ; Set initial transparency
		; Return
	}

	transparency%index% := (0 > transparency%index%)?(0):(transparency%index%-15)
	
	Gui, TrayNotification%index%:+LastFound
	WinSet, Transparent,% transparency%index%
	return transparency%index%
}

Download_Updater() {
	global ProgramValues

	Gui_Trades_Save_Pending_Backup()

	IniRead, isUsingBeta,% ProgramValues.Ini_File,PROGRAM,Update_Beta, 0

	updaterLink 		:= (isUsingBeta)?(ProgramValues.Updater_Link_Beta):(ProgramValues.Updater_Link)
	newVersionLink 		:= ProgramValues.Version_Online_Download

	IniWrite,% A_Now,% ProgramValues.Ini_File,PROGRAM,LastUpdate
	UrlDownloadToFile,% updaterLink,% ProgramValues.Updater_File
	Sleep 10
	if (!ErrorLevel) {
		Run,% ProgramValues.Updater_File 
		. " /Name=""" ProgramValues.Name  """"
		. " /File_Name=""" A_ScriptDir "\" ProgramValues.Name ".exe" """"
		. " /Local_Folder=""" ProgramValues.Local_Folder """"
		. " /Ini_File=""" ProgramValues.Ini_File """"
		. " /NewVersion_Link=""" newVersionLink """"
		ExitApp
	}
	else {
		Tray_Notifications_Show("Failed to download the updater.", "There was an issue while downloading the updater.`nPlease try again later, or try updating manually.")
	}
}

; GUI_Trades_Set_NewMsg ,GUI_Trades_Set_InArea: Both default to 1
GUI_Trades_Set_NewMsg(tabId, value = 1) {
	global TradesGUI_Controls
	GuiControl,Trades:,% TradesGUI_Controls["NewMsg_Slot_" tabId],% value
}
GUI_Trades_Set_InArea(tabId, value = 1) {
	global TradesGUI_Controls
	GuiControl,Trades:,% TradesGUI_Controls["InArea_Slot_" tabId],% value
}
GUI_Trades_Inc_WithdrawTally(tabId, value) {
	global TradesGUI_Controls
	GuiControlGet, tabWithdrawTally, Trades:,% TradesGUI_Controls["WithdrawTally_Slot_" tabID]
	tabWithdrawTally := (tabWithdrawTally) ? tabWithdrawTally + value : value
	GuiControl,Trades:,% TradesGUI_Controls["WithdrawTally_Slot_" tabId],% tabWithdrawTally
}
Gui_Trades_Update_Tabs() {
	global TradesGui_Values, TradesGui_Controls, ProgramSettings
	tabsCount  := TradesGui_Values.Tabs_Count
	Loop %tabsCount% {
		GUI_Trades_Update_Tab_Style(A_Index)
	}
}

GUI_Trades_Update_Tab_Style(tabId) {
	Global TradesGUI_Controls, TradesGUI_Values, ProgramValues

	oldTab := TradesGUI_Controls["Tab_" tabID]
	GuiControlGet, isVisible, Trades:Visible,% oldTab

	tabInfos := Gui_Trades_Get_Trades_Infos(tabID)
	if (tabInfos.InArea = 1) {
		TradesGUI_Controls["Tab_" tabId] := TradesGUI_Controls["TabJoined_" tabId]
	} else	if (tabInfos.NewMsg = 1) {
		TradesGUI_Controls["Tab_" tabId] := TradesGUI_Controls["TabMsg_" tabId]
	} else {
		TradesGUI_Controls["Tab_" tabId] := TradesGUI_Controls["TabDefault_" tabId]
	}
	if (isVisible = 1) {
		GuiControl,Trades:Hide,% oldTab
		GuiControl,Trades:Show,% TradesGUI_Controls["Tab_" tabID]
	}

	if (tabId = TradesGUI_Values.Active_Tab) {
		Gui_Trades_SetActiveTab_Func(tabId)
	}
}

StackClick() {
	global TradesGUI_Values, ProgramSettings
	static lastAvailable

	clipboard = ; Clear CLipboard
	SendInput {Shift Up}^c

	; wait .01 second for the clipboard and do nothing if it fails 
	ClipWait, .1
	if (ErrorLevel) {
		return
	}
	clip := clipboard

	tabId := TradesGUI_Values.Active_Tab
	tabInfo := Gui_Trades_Get_Trades_Infos(tabId)
	item := Gui_Stats_Get_Currency_Name(tabInfo.item)

	if (item.name && RegExMatch(clip, "i)(?:" item.name ")[\s\S]*: (\d+(?:[,.]\d+)*)\/(\d+(?:[,.]\d+)*)", match)) {
		available := RegexReplace(match1, "[,.]")
		stackSize := RegexReplace(match2, "[,.]")

		RegExMatch(tabinfo.item, "\d+", required) ; get required amount
		withdrawn := tabInfo.withdrawTally
		amount := (available >= stackSize) ? stackSize : available

		; if available amount hasn't changed, it's likely the previous click hasn't gone through yet
		if (available = lastAvailable) {
			tipInfo := "Stack size hasn't changed since your last click. `n"
			tipInfo .= "This is normaly caused by latency issues but `n"
			tipInfo .= "could mean the macro has run into problems"
			Gosub showToolTip 
			return
		}
		; Don't do anything if we've already withdrawn all we need
		if ((required - withdrawn) <= 0) {
			tipInfo := "You've already withdrawn the required amount."
			Gosub showToolTip
			return
		}

		if ((withdrawn + amount) < required) {
			Gosub CtrlClick
		} else if ((withdrawn + amount) = required) {
			Gosub CtrlClick
			Gosub Finished
		} else {
			amount := required - withdrawn
			Gosub ShiftClickPlus
			Gosub Finished
		}
		GUI_Trades_Inc_WithdrawTally(tabId, amount)
		withdrawn := withdrawn + amount ;update for tooltip
		Gosub showToolTip
		; If transfering individual stacks, add a 250ms delay to account for lag and remove lastAvailable. Otherwise next click will do nothing
		if (available == stackSize) {
			sleep 250
			lastAvailable := 0
		} else {
			lastAvailable := available
		}
	} else {
		Gosub CtrlClick
	}
	return

	; Using these because ^{LButton} was finicky, sometimes including shifts or not executing properly
	CtrlClick:
		Gosub GetKeyStates
		SendInput {Ctrl Down}{Shift Up}{Lbutton Up}{Ctrl Up}
		Gosub ReturnKeyStates
		return
	ShiftClickPlus:
		Gosub GetKeyStates
		SendInput {Shift Down}{Ctrl Up}{LButton Up}{Shift Up}
		SendInput, %amount%{Enter}
		Gosub ReturnKeyStates
		return
	GetKeyStates:
		shiftState := (GetKeyState("Shift"))?("Down"):("Up")
		ctrlState := (GetKeyState("Shift"))?("Down"):("Up")
		Hotkey, *Shift, DoNothing, On
		Hotkey, *Ctrl, DoNothing, On
		sleep 10
		return
	ReturnKeyStates:
		sleep 10
		Hotkey, *Shift, DoNothing, Off
		Hotkey, *Ctrl, DoNothing, Off
		Send {Shift %shiftState%}{Ctrl %ctrlState%} ; Restore ctrl/shift state
		return
	Finished: 
		SoundPlay,% ProgramSettings.Whisper_Sound_Path
		lastAvailable := 0
		tipInfo := "Finished. You should have withdrawn the required amount."
		return
	ShowToolTip:
		tip := "POE Trades Companion `n"
		tip .= "===============================`n"
		tip .= item.Name "`n"
		tip .= "Required: " required " | Withdrawn: "  withdrawn "`n"
		if (tipInfo) {
			tip .= "===============================`n"
			tip .= tipInfo
		}
		mouseTooltip(tip)
		return
}

ShiftClickPlus() {
	global TradesGUI_Values, ProgramSettings

	clipboard = ; Clear CLipboard
	SendInput {Shift Up}^c

	; wait for clipboard to be populated and do nothing if it fails
	ClipWait, .2
	if (ErrorLevel) {
		return
	}
	clip := clipboard

	tabId := TradesGUI_Values.Active_Tab
	tabInfo := Gui_Trades_Get_Trades_Infos(tabId)
	item := Gui_Stats_Get_Currency_Name(tabInfo.item)

	if (item.name && RegExMatch(clip, "i)(?:" item.name ")[\s\S]*: (\d+(?:[,.]\d+)*)\/(\d+(?:[,.]\d+)*)", match)) {
		available := RegexReplace(match1, "[,.]")
		stackSize := RegexReplace(match2, "[,.]")

		;amount = remainder of required/stacksize
		RegExMatch(tabinfo.item, "\d+", required)
		amount := Mod(required, stackSize) 

		SendInput {Shift Down}{Ctrl Up}{LButton Up}{Shift Up}
		SendInput, %amount%{Enter}
	}
	return
}

mouseTooltip(tip, posX = 0, posY = 0) {
	static mouseX, mouseY
	MouseGetPos, mouseX, mouseY
	posX := (posX) ? posX : mouseX +20 ;So the tooltip isnt coverd by your mouse
	posY := (posY) ? posY : mouseY

	ToolTip ; Removes the old tooltip, otherwise I get underlined fonts for some reason
	ToolTip, % tip, posX, posY
	SetTimer, RemoveTT, 100
	return

	RemoveTT:
		MouseGetPos, currentX, currentY
		movedX := (currentX - mouseX) ** 2 > 100
		movedY := (currentY - mouseY) ** 2 > 100
		if (movedX || movedY)	{
			SetTimer, RemoveTT, Off
			ToolTip
		}
		return
}

#Include %A_ScriptDir%/Resources/AHK/
#Include BinaryEncodingDecoding.ahk
#Include JSON.ahk
#Include Class_ImageButton.ahk  
#Include BetaFuncs.ahk

#IfWinActive ahk_group POEGame
^+LButton::StackClick()