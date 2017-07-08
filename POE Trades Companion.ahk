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

#Warn LocalSameAsGlobal
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
	global ProgramValues 				:= Object() ; Specific to the program's informations
	global ProgramFonts 				:= Object() ; Fonts private to the program
	global ProgramSettings 				:= Object() ; Settings from the local .ini
	global RunParameters 				:= Object() ; Run-time parameters

	global GameSettings 				:= Object() ; Settings from the game .ini

	global TradesGUI_Values 			:= Object() ; TradesGUI various infos
	global TradesGUI_Controls 			:= Object() ; TradesGUI controls handlers

	global Stats_TradeCurrencyNames 	:= Object() ; Abridged currency names from poe.trade
	global Stats_RealCurrencyNames 		:= Object() ; All currency full names

;	- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
	
	ProgramSettings.Screen_DPI 			:= Get_DPI_Factor() 

	Handle_CommandLine_Parameters()
	MyDocuments 						:= (RunParameters.MyDocuments)?(RunParameters.MyDocuments):(A_MyDocuments)

	ProgramValues.Name 					:= "POE Trades Companion"
	ProgramValues.Version 				:= "1.11.1"
	ProgramValues.Debug 				:= "0"

	ProgramValues.Updater_File 			:= "POE-TC-Updater.exe"
	ProgramValues.Updater_Link 			:= "https://raw.githubusercontent.com/lemasato/POE-Trades-Companion/master/Updater_v2.exe"
	ProgramValues.Updater_Link_Beta 	:= "https://raw.githubusercontent.com/lemasato/POE-Trades-Companion/dev/Updater_v2.exe"

	ProgramValues.Version_Link 			:= "https://raw.githubusercontent.com/lemasato/POE-Trades-Companion/master/version.txt"
	ProgramValues.Version_Link_Beta  	:= "https://raw.githubusercontent.com/lemasato/POE-Trades-Companion/dev/version.txt"

	ProgramValues.NewVersion_File		:= "POE-TC-NewVersion.exe"
	ProgramValues.NewVersion_Link 		:= "https://raw.githubusercontent.com/lemasato/POE-Trades-Companion/master/POE Trades Companion.exe"
	ProgramValues.NewVersion_Link_Beta	:= "https://raw.githubusercontent.com/lemasato/POE-Trades-Companion/dev/POE Trades Companion.exe"

	ProgramValues.Changelogs_Link 		:= "https://raw.githubusercontent.com/lemasato/POE-Trades-Companion/master/changelogs.txt"
	ProgramValues.Changelogs_Link_Beta	:= "https://raw.githubusercontent.com/lemasato/POE-Trades-Companion/dev/changelogs.txt"

	ProgramValues.Reddit 				:= "https://redd.it/57oo3h"
	ProgramValues.GGG 					:= "https://www.pathofexile.com/forum/view-thread/1755148/"
	ProgramValues.GitHub 				:= "https://github.com/lemasato/POE-Trades-Companion"
	ProgramValues.Paypal 				:= "https://www.paypal.com/cgi-bin/webscr?cmd=_s-xclick&hosted_button_id=BSWU76BLQBMCU"

	ProgramValues.Local_Folder 			:= MyDocuments "\AutoHotkey\" ProgramValues.Name
	ProgramValues.SFX_Folder 			:= ProgramValues.Local_Folder "\SFX"
	ProgramValues.Logs_Folder 			:= ProgramValues.Local_Folder "\Logs"
	ProgramValues.Skins_Folder 			:= ProgramValues.Local_Folder "\Skins"
	ProgramValues.Fonts_Folder 			:= ProgramValues.Local_Folder "\Fonts"
	ProgramValues.Fonts_Settings_File	:= ProgramValues.Fonts_Folder "\Settings.ini"
	ProgramValues.Data_Folder			:= ProgramValues.Local_Folder "\Data"
	ProgramValues.Others_Folder 		:= ProgramValues.Local_Folder "\Others"

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

	ProgramValues.Debug := (A_IsCompiled)?(0):(ProgramValues.Debug) ; Prevent from enabling debug on compiled executable
	if FileExist(A_ScriptDir "/ENABLE_DEBUG.txt") {
		FileRead, fileContent,% A_ScriptDir "/ENABLE_DEBUG.txt"
		fileContent := StrReplace(fileContent, "`n", "")
		ProgramValues.Debug := fileContent
	}
;	- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

	GroupAdd, POEGame, ahk_exe PathOfExile.exe
	GroupAdd, POEGame, ahk_exe PathOfExile_x64.exe
	GroupAdd, POEGame, ahk_exe PathOfExileSteam.exe
	GroupAdd, POEGame, ahk_exe PathOfExile_x64Steam.exe
	global POEGameArray := ["PathOfExile.exe", "PathOfExile_x64.exe", "PathOfExileSteam.exe", "PathOfExile_x64Steam.exe"]
	global POEGameList := "PathOfExile.exe,PathOfExile_x64.exe,PathOfExileSteam.exe,PathOfExile_x64Steam.exe"

;	- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

	FileRead, allCurrency,% ProgramValues.Data_Folder "\Resources\Data\Currency_All.txt"
	Loop, Parse, allCurrency, `n`r
	{
		if ( A_LoopField ) {
			Stats_RealCurrencyNames .= A_LoopField ","
		}
	}
	StringTrimRight, Stats_RealCurrencyNames, Stats_RealCurrencyNames, 1 ; Remove last comma

	FileRead, JSONFile,% ProgramValues.Data_Folder "\Resources\Data\currencyTradeNames.json"
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

;	Function Calls
	Run_As_Admin()
	Close_Previous_Program_Instance()
	Tray_Refresh()

	Update_Local_Settings()
	Set_Local_Settings()
	localSettings := Get_Local_Settings()
	Declare_Local_Settings(localSettings)

	settings := Get_Game_Settings()
	Declare_Game_Settings(settings)

	Delete_Old_Logs_Files(10)
	Extract_Sound_Files()
	Extract_Skin_Files()
	Extract_Font_Files()
	Extract_Data_Files()
	Extract_Others_Files()
	Manage_Font_Resources("LOAD")
	Check_Update()
	Do_Once()
	Enable_Hotkeys()

	; Pre-rendering Trades-GUI
	Gui_Trades("CREATE")
	Create_Tray_Menu()

	if ( ProgramValues["Debug"] ) {
		; trade / No qual / Level
		str := "2016/10/09 21:30:32 105384166 355 [INFO Client 6416] "
			str .= "@From iSellStuff: Hi, I would like to buy your level 1 0% Faster Attacks Support listed for 5 alteration in Legacy (stash tab """"Shop: Gems""""; position: left 10, top 11) Offering 1alch?"

		; trade / No qual / Level / Unpriced
		str .= "`n" "2016/10/09 21:30:32 105384166 355 [INFO Client 6416] "
			str .= "@From 22: Hi, I would like to buy your level 19 0% Faster Attacks Support in Beta Standard (stash tab """"Shop: poetrade 1""""; position: left 20, top 11)"

		; app / No qual / Level
		str .= "`n" "2016/10/09 21:30:32 105384166 355 [INFO Client 6416] "
			str .= " @From 33: wtb Faster Attacks Support (21/20%) listed for 1 Orb of Alteration in standard (stash """"Shop: poeapp 1""""; left 30, top 21)"

		; app / No qual / Level / Unpriced
		str .= "`n" "2016/10/09 21:30:32 105384166 355 [INFO Client 6416] "
			str .= " @From 44: wtb Faster Attacks Support (21/20%) in standard (stash """"Shop: poeapp 1""""; left 40, top 21)"
		Filter_Logs_Message(str)
	}

	Gui_Trades_Load_Pending_Backup()

	; Gui_Stats()
	; Gui_Settings()
	; Gui_About()
	Logs_Append("DUMP", localSettings)
	Monitor_Game_Logs()
}

;==================================================================================================================
;
;										LOGS MONITORING
;
;==================================================================================================================

Filter_Logs_Message(message) {
/*		Filter the logs message to retrieve the required informations we need
			and send them to the Trades GUI if it is a trade whisper.
 */
	global ProgramSettings, TradesGUI_Values

	Loop, Parse, message, `n ; For each new individual line since last check
	{
		; New RegEx pattern matches the trading message, but only from whispers and local chat (for debugging), and specifically ignores global/trade/guild/party chats
		if ( RegExMatch( A_LoopField, "^(?:[^ ]+ ){6}(\d+)\] (?=[^#$&%]).*@(?:From|De|От кого) (.*?): (.*)", subPat ) )
		{
			; Assigning the sub pattern variables
			gamePID := subPat1, whispNameFull := subPat2, whispMsg := subPat3
			whispNameFull := Gui_Trades_RemoveGuildPrefix(whispNameFull)
			whispName := whispNameFull.Name, whispGuild := whispNameFull.Guild
			TradesGUI_Values.Last_Whisper := whispName

			; Check existing tabs for same buyer, and add to the "Other:" slot
			tradesInfos := Gui_Trades_Manage_Trades("GET_ALL")
			Loop % tradesInfos.Max_Index {
				if (whispName = tradeInfos[A_Index "_Buyer"]) {
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
					setInfos := { OTHER:otherText, TabID:key }
					Gui_Trades_Set_Trades_Infos(setInfos)
				}
			}

			if !WinActive("ahk_pid " gamePID) {
				if ( ProgramSettings.Whisper_Tray ) {
					Show_Tray_Notification("Whisper from " whispName, whispMsg)
				}

				if ( ProgramSettings.Whisper_Flash ) {
					gameHwnd := WinExist("ahk_pid " gamePID)
					DllCall("FlashWindow", UInt, gameHwnd, Int, 1)
				}
			}

			; poeappRegExStr := "(.*)wtb (.*) listed for (.*) in (?:(.*)\(stash ""(.*)""; left (.*), top (.*)\)|Hardcore (.*?)\W|(.*?)\W)(.*)"
			; poetradeRegExStr := "(.*)Hi, I(?: would|'d) like to buy your (?:(.*) |(.*))(?:listed for (.*)|for my (.*)|)(?!:listed for|for my) in (?:(.*)\(stash tab ""(.*)""; position: left (.*), top (.*)\)|Hardcore (.*?)\W|(.*?)\W)(.*)"

			whisp := whispName ": " whispMsg "`n"
			poeappRegExStr := "(.*)wtb (.*) listed for (.*) in (?:(.*)\(stash ""(.*)""; left (.*), top (.*)\)|Hardcore (.*?)\W|(.*?)\W)(.*)" ; poeapp
			poetradeRegExStr := "(.*)Hi, I(?: would|'d) like to buy your (?:(.*) |(.*))(?:listed for (.*)|for my (.*)|) in (?:(.*)\(stash tab ""(.*)""; position: left (.*), top (.*)\)|Hardcore (.*?)\W|(.*?)\W)(.*)" ; poe.trade
			allRegExStr := {poeapp:poeappRegExStr, poetrade:poetradeRegExStr}
			for regExName, regExStr in allRegExStr {
				if RegExMatch(whisp, "i).*: " regExStr) {
					Break
				}
			}
			if RegExMatch(whisp, "i).*: " regExStr, subPat ) ; Matching pattern found
			{
				timeSinceLastTrade := 0

				if ( regExName = "poetrade" ) {
					tradeItem := (subPat2)?(subPat2):(subPat3)?(subPat3):("ERROR RETRIEVING ITEM")
					if RegExMatch(tradeItem, "level (.*) (.*)% (.*)", itemPat) {
						tradeItem := itemPat3 " (Lvl:" itemPat1 " / Qual:" itemPat2 "%)"
						itemPat1 := "", itemPat2 := "", itemPat3 := ""
					}
					tradePrice := (subPat4)?(subPat4):(subPat5)?(subPat5):("Unpriced Item (See Offer)")
					tradeStash := (subPat6)?(subPat6 " (Tab:" subPat7 " / Pos:" subPat8 ";" subPat9 ")"):(subPat10)?("Hardcore " subPat10):(subPat11)?(subPat11):("ERROR RETRIEVING LOCATION")
					tradeOther := (subPat11!=subPat6 && subPat11!=subPat10 && subPat11!=tradeStash)?(subPat1 subPat11):(subPat12 && subPat12!="`n")?(subPat12):("-")

					tradeItem = %tradeItem% ; Remove blank spaces
					tradePrice = %tradePrice%
					tradeStash = %tradeStash%
					tradeOther = %tradeOther%
				}
				else if ( regExName = "poeapp" ) {
					tradeItem := subPat2
					if RegExMatch(tradeItem, "(.*) \((.*)/(.*)%\)", itemPat) {
						tradeItem := itemPat1 " (Lvl:" itemPat2 " / Qual:" itemPat3 "%)"
						itemPat1 := "", itemPat2 := "", itemPat3 := ""
					}
					tradePrice := (subPat3)?(subPat3):("Unpriced Item (See Offer)")
					tradeStash := (subPat4)?(subPat4 " (Tab:" subpat5 " / Pos:" subPat6 ";" subPat7 ")"):(subPat8)?("Hardcore " subPat8):(subPat9)?(subPat9):("ERROR RETRIEVING LOCATION")								
					tradeOther := (subPat1 || subPat10 && subPat10 != "`n")?(subPat1 . subPat10):("-")

					tradeItem = %tradeItem% ; Remove blank spaces
					tradePrice = %tradePrice%
					tradeStash = %tradeStash%
					tradeOther = %tradeOther%
				}

				; Do not add the trade if the same is already in queue
				tradesExists := 0
				tradesInfos := Gui_Trades_Manage_Trades("GET_ALL")
				Loop % tradeInfos.Max_Index {
					buyerContent := tradesInfos[A_Index "_Buyer"], itemContent := tradesInfos[A_Index "_Item"], priceContent := tradesInfos[A_Index "_Price"], locationContent := tradesInfos[A_Index "_Location"], otherContent = tradesInfos[A_Index "_Other"]
					if (buyerContent=whispName && itemContent=tradeItem && priceContent=tradePrice && locationContent=tradeStash) {
						tradesExists := 1
					}
				}

				; Trade does not already exist
				if (tradesExists = 0) {
					newTradesInfos := {Buyer:whispName
									  ,Item:tradeItem
									  ,Price:tradePrice
									  ,Location:tradeStash
									  ,PID:gamePID
									  ,Time:A_Hour ":" A_Min
									  ,Other:tradeOther
									  ,Date:A_YYYY "-" A_MM "-" A_DD
									  ,Guild:whispGuild}
					messagesArray := Gui_Trades_Manage_Trades("ADD_NEW", newTradesInfos)
					Gui_Trades("UPDATE", messagesArray)

					if ( ProgramSettings.Trade_Toggle = 1 ) && FileExist(ProgramSettings.Trade_Sound_Path) { ; Play the sound set for trades
						SoundPlay,% ProgramSettings.Trade_Sound_Path
					}
					else if ( ProgramSettings.Whisper_Toggle = 1 ) && FileExist(ProgramSettings.Whisper_Sound_Path) { ; Play the sound set for whispers{
						SoundPlay,% ProgramSettings.Whisper_Sound_Path
					}
				}
			}
			else {
				if ( ProgramSettings.Whisper_Toggle = 1 ) && FileExist(ProgramSettings.Whisper_Sound_Path) { ; Play the sound set for whispers
					SoundPlay,% ProgramSettings.Whisper_Sound_Path
				}
			}
		}
	}
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
	static
	global RunParameters
	global POEGameArray

	if (mode = "CLOSE") {
		fileObj.Close()
		Return
	}

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
			Gui_Trades_Set_Position()
		}
	}
	Logs_Append(A_ThisFunc, {File:logsFile})

	fileObj := FileOpen(logsFile, "r")
	fileObj.pos := fileObj.length
	Loop {
		if !FileExist(logsFile) || ( fileObj.pos > fileObj.length ) || ( fileObj.pos = -1 ) {
			Logs_Append("Monitor_Game_Logs_Break", {Pos:fileObj.pos, Length:fileObj.length})
			Break
		}
		if ( fileObj.pos < fileObj.length ) {
			lastMessage := fileObj.Read() ; Stores the last message into a variable
			Filter_Logs_Message(lastMessage)
		}
		sleepTime := (timeSinceLastTrade>300)?(500):(100)
		timeSinceLastTrade += 1*(sleepTime/1000)
		Sleep %sleepTime%
	}
	Show_Tray_Notification("An issue with the logs file occured!", "It could be one of the following reasons: "
		. "`n- The file doesn't exist anymore."
		. "`n- Content from the file was deleted."
		. "`n- The file object used by the program was closed."
		. "`n`nThe logs monitoring function will be restarting in 5 seconds.")
	sleep 5000
	Restart_Monitor_Game_Logs()
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
	global ProgramValues, TradesGUI_Values, TradesGUI_Controls, ProgramSettings
	iniFilePath := ProgramValues.Ini_File
	programName := ProgramValues.Name
	programSkinFolderPath := ProgramValues.Skins_Folder

	activeSkin := ProgramSettings.Active_Skin
	guiScale := ProgramSettings.Scale_Multiplier

	IniRead, fontSizeAuto,% ProgramValues.Fonts_Settings_File,SIZE,% ProgramSettings.Font
	if !IsNum(fontSizeAuto)
		IniRead, fontSizeAuto,% ProgramValues.Fonts_Settings_File,SIZE,Default
	fontName := (ProgramSettings.Font="System")?(""):(ProgramSettings.Font)
	fontSize := (ProgramSettings.Font_Size_Mode="Custom")?(ProgramSettings.Font_Size_Custom)
			   :(fontSizeAuto*guiScale)
	IniRead, fontQualAuto,% ProgramValues.Fonts_Settings_File,QUALITY,% ProgramSettings.Font
	if !IsNum(fontQualAuto)
		IniRead, fontQualAuto,% ProgramValues.Fonts_Settings_File,QUALITY,Default
	fontQual := (ProgramSettings.Font_Quality_Mode="Custom")?(ProgramSettings.Font_Quality_Custom)
			   :(fontQualAuto)

	colorTitleActive := ProgramSettings.Font_Color_Title_Active
	colorTitleInactive := ProgramSettings.Font_Color_Title_Inactive
	colorTradesInfos1 := ProgramSettings.Font_Color_Trades_Infos_1
	colorTradesInfos2 := ProgramSettings.Font_Color_Trades_Infos_2
	colorTabs := ProgramSettings.Font_Color_Tabs
	colorButtons := ProgramSettings.Font_Color_Buttons
	colorTitleActive := (colorTitleActive="SYSTEM")?(""):(colorTitleActive)
	colorTitleInactive := (colorTitleInactive="SYSTEM")?(""):(colorTitleInactive)
	colorTradesInfos1 := (colorTradesInfos1="SYSTEM")?(""):(colorTradesInfos1)
	colorTradesInfos2 := (colorTradesInfos2="SYSTEM")?(""):(colorTradesInfos2)
	colorTabs := (colorTabs="SYSTEM")?(""):(colorTabs)
	colorButtons := (colorButtons="SYSTEM")?(""):(colorButtons)

	TradesGUI_Values.Max_Tabs_Per_Row := maxTabsRow := 7
	maxTabsStage1 := 25
	maxTabsStage2 := 50
	maxTabsStage3 := 75
	maxTabsStage4 := 100
	maxTabsStage5 := 255

	Loop 5 {
		local btnUnicodePos := ProgramSettings["Button_Unicode_" A_Index "_Position"]
		local useSmallerButtons := (btnUnicodePos != "Disabled")?(true):(false)
		if ( useSmallerButtons = true )
			Break
	}
	TradesGUI_Values.Use_Smaller_Buttons := useSmallerButtons
	btnUnicodePos := "", useSmallerButtons := ""

	exeNotFoundMsg := "Process not found, retrying in XX seconds...`n`nRight click on the tray icon,`nthen [Settings] to set your preferences."
	noTradeMsg := "No trade on queue!`n`nRight click on the tray icon,`nthen [Settings] to set your preferences."

	if ( mode = "CREATE" ) {

		Gui, Trades:Destroy
		Gui, Trades:New, +ToolWindow +AlwaysOnTop -Border +hwndGuiTradesHandler +LabelGui_Trades_ +LastFound -SysMenu -Caption
		Gui, Trades:Default
		Gui, Margin, 0, 0
		Gui, +OwnDialogs
		TradesGUI_Values.Handler := GuiTradesHandler

		tabHeight := Gui_Trades_Get_Tab_Height(), tabWidth := 390*guiScale
		guiWidth := 401*guiScale, guiHeight := Floor((tabHeight+31)*guiScale), guiHeightMin := 34*guiScale ; 30 = banner size, 1 = tab bottom line
		borderSize := 2
		TradesGUI_Values.Insert("Height_Full", guiHeight)
		TradesGUI_Values.Insert("Height_Minimized", guiHeightMin)

		maxTabsRendered := (!maxTabsRendered)?(maxTabsStage1):(maxTabsRendered)

		if ( maxTabsRendered > maxTabsStage2 ) { 
			Show_Tray_Notification(programName, "Current tabs limit reached." . "`nRendering more tabs")
		}

		txtCtrlSize := Get_Text_Control_Size("88:88", fontName, fontSize)
		timeSlotWidth := txtCtrlSize.W, txtCtrlSize := ""

/* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
 *									System TradesGUI													*
 * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
*/
		if ( activeSkin = "System" ) {
;			Header
			Gui, Font,S%fontSize% Q%fontQual%,% fontName
			Gui, Add, Picture,% "x" borderSize . " y" borderSize . " w" guiWidth-borderSize . " h" 30*guiScale . " +BackgroundTrans",% programSkinFolderPath "\" activeSkin "\Header.png"
			Gui, Add, Picture,% "x" borderSize+(10*guiScale) . " y" borderSize+(5*guiScale) . " w" 22*guiScale . " h" 22*guiScale . " +BackgroundTrans",% programSkinFolderPath "\" activeSkin "\icon.png"
			Gui, Add, Text,% "x" borderSize+(35*guiScale) . " y" borderSize+(2*guiScale) . " w" guiWidth-(100*guiScale) . " h" 28*guiScale+(2*guiScale) " hwndguiTradesTitleHandler gGui_Trades_Move c" colorTitleInactive . " BackgroundTrans +0x200",% programName " - Queued Trades: 0"
			Gui, Add, Text,% "x" guiWidth-(65*guiScale) . " yp" . " w" 65*guiScale . " hp" . " hwndguiTradesMinimizeHandler gGui_Trades_Minimize c" colorTitleInactive . " +BackgroundTrans +0x200",% "MINIMIZE"
			TradesGUI_Controls.Insert("Header", guiTradesHeader)
			TradesGUI_Controls.Insert("Header_Icon", guiTradesHeaderIcon)
			TradesGUI_Controls.Insert("Header_Title", guiTradesTitleHandler)
			TradesGUI_Controls.Insert("Header_Minimize", guiTradesMinimizeHandler)

;			Borders
			Gui, Add, Picture,% "x" 0 . " y" 0 . " w" guiWidth . " h" borderSize . " hwndguiTradesBorderTop",% programSkinFolderPath "\" activeSkin "\Border.png" ; Top
			Gui, Add, Picture,% "x" 0 . " y" 0 . " w" borderSize . " h" guiHeight . " hwndguiTradesBorderLeft",% programSkinFolderPath "\" activeSkin "\Border.png" ; Left
			Gui, Add, Picture,% "x" guiWidth-borderSize . " y" 0 . " w" borderSize . " h" guiHeight . " hwndguiTradesBorderRight",% programSkinFolderPath "\" activeSkin "\Border.png" ; Right
			Gui, Add, Picture,% "x" 0 . " y" guiHeight-borderSize . " w" guiWidth . " h" borderSize . " hwndguiTradesBorderBottom",% programSkinFolderPath "\" activeSkin "\Border.png" ; Bottom
			TradesGUI_Controls.Insert("Border_Top", guiTradesBorderTop)
			TradesGUI_Controls.Insert("Border_Left", guiTradesBorderLeft)
			TradesGUI_Controls.Insert("Border_Right", guiTradesBorderRight)
			TradesGUI_Controls.Insert("Border_Bottom", guiTradesBorderBottom)

			Gui, Add, Text,% "x" borderSize . " y" 70*guiScale . " w" guiWidth-borderSize . " hwndErrorMsgTextHandler" . " Center +BackgroundTrans c" colorTradesInfos1,% noTradeMsg
			Gui, Add, Tab3,% "x" borderSize . " y" 30*guiScale . " w" . guiWidth-borderSize " h" (tabHeight)*guiScale . "  vTab hwndTabHandler gGui_Trades_OnTabSwitch Section -Wrap",% "1"
			TradesGUI_Controls.Insert("Tab", TabHandler)

			Loop %maxTabsRendered% {
				index := A_Index
				Gui, Tab,%index%

;				Close button, time slot
				Gui, Add, Button,% "xs" +(372*guiScale) . " ys" +(25*guiScale) . " w" 20*guiScale . " h" 20*guiScale . " vBtnClose" index . " hwndBtnClose" index "Handler" . " gGui_Trades_Do_Action_Func +BackgroundTrans",X
				Gui, Add, Text,% "xp" -timeSlotWidth . " yp+3" . " w" timeSlotWidth . " h" 15*guiScale . " vTimeSlot" index . " hwndTimeSlot" index "Handler" . " +BackgroundTrans R1" . " c" colorTradesInfos2,% ""

;				Buyer / Item / ... Static Text
				Gui, Add, Text,% "xs" +(6*guiScale) . " ys" +(27*guiScale) . " w" 60*guiScale . " h" 15*guiScale . " hwndBuyerText" index "Handler" . " +BackgroundTrans" . " c" colorTradesInfos1,% "Buyer: "
				Gui, Add, Text,% "xp" . " yp+" 15*guiScale . " wp hp" . " hwndItemText" index "Handler" . " +BackgroundTrans" . " c" colorTradesInfos1,% "Item: "
				Gui, Add, Text,% "xp" . " yp+" 15*guiScale . " wp hp" . " hwndPriceText" index "Handler" . " +BackgroundTrans" . " c" colorTradesInfos1,% "Price: "
				Gui, Add, Text,% "xp" . " yp+" 15*guiScale . " wp hp" . " hwndLocationText" index "Handler" . " +BackgroundTrans" . " c" colorTradesInfos1,% "Location: "
				Gui, Add, Text,% "xp" . " yp+" 15*guiScale . " wp hp" . " hwndOtherText" index "Handler" . " +BackgroundTrans" . " c" colorTradesInfos1,% "Other: "

;				Buyer / Item / ... Slots
				Gui, Add, Text,% "xs" +(76*guiScale) . " ys" +(27*guiScale) . " w" 255*guiScale . " h" 15*guiScale . " vBuyerSlot" index . " hwndBuyerSlot" index "Handler" . " +BackgroundTrans +0x0100 R1" . " c" colorTradesInfos2,% ""
				Gui, Add, Text,% "xp" . " yp+" 15*guiScale . " w" 310*guiScale . " h" 15*guiScale . " vItemSlot" index . " hwndItemSlot" index "Handler" . " +BackgroundTrans +0x0100 R1" . " c" colorTradesInfos2,% ""
				Gui, Add, Text,% "xp" . " yp+" 15*guiScale . " wp hp" . " vPriceSlot" index . " hwndPriceSlot" index "Handler" . " +BackgroundTrans +0x0100 R1" . " c" colorTradesInfos2,% ""
				Gui, Add, Text,% "xp" . " yp+" 15*guiScale . " wp hp" . " vLocationSlot" index . " hwndLocationSlot" index "Handler" . " +BackgroundTrans +0x0100 R1" . " c" colorTradesInfos2,% ""
				Gui, Add, Text,% "xp" . " yp+" 15*guiScale . " wp hp" . " vOtherSlot" index . " hwndOtherSlot" index "Handler" . " +BackgroundTrans +0x100 R1" . " c" colorTradesInfos2,% ""
				Gui, Add, Text,% "xp" . " yp" . " w0" . " h0" . " vPIDSlot" index . " hwndPIDSlot" index "Handler +BackgroundTrans" . " c" colorTradesInfos2,% ""
				Gui, Add, Text,% "xp" . " yp" . " w0" . " h0" . " vDateSlot" index . " hwndDateSlot" index "Handler +BackgroundTrans" . " c" colorTradesInfos2,% ""
				Gui, Add, Text,% "xp" . " yp" . " w0" . " h0" . " vGuildSlot" index . " hwndGuildSlot" index "Handler +BackgroundTrans" . " c" colorTradesInfos2,% ""

				TradesGUI_Controls.Insert("Buyer_Slot_" index,BuyerSlot%index%Handler)
				TradesGUI_Controls.Insert("Item_Slot_" index,ItemSlot%index%Handler)
				TradesGUI_Controls.Insert("Price_Slot_" index,PriceSlot%index%Handler)
				TradesGUI_Controls.Insert("Location_Slot_" index,LocationSlot%index%Handler)
				TradesGUI_Controls.Insert("Other_Slot_" index,OtherSlot%index%Handler)
				TradesGUI_Controls.Insert("Time_Slot_" index,TimeSlot%index%Handler)
				TradesGUI_Controls.Insert("PID_Slot_" index,PIDSlot%index%Handler)
				TradesGUI_Controls.Insert("Date_Slot_" index,DateSlot%index%Handler)
				TradesGUI_Controls.Insert("Guild_Slot_" index,GuildSlot%index%Handler)

				hexCodes := ["41", "42", "45", "43", "44"] ; 41:Clip/42:Whis/43:Trade/44:Kick/45:Inv
				ctrlActions := ["Clipboard" , "Whisper", "Invite", "Trade", "Kick"]
				for key, element in hexCodes {
					btnPos := ProgramSettings["Button_Unicode_" A_Index "_Position"]
					if ( btnPos != "Disabled" ) {
						xpos := ((btnPos-1)*(40*guiScale))+(7*guiScale)
						ypos := "s+" 105*guiScale

						Gui, Font,% "S" 20*guiScale,% "TC-Symbols"
						Gui, Add, Button,% "x" xpos . " y" ypos . " w" 35*guiScale . " h" 23*guiScale . " vUnicodeBtn" A_Index "_" index . " hwndUnicodeBtn" A_Index "_" index "Handler" . " gGui_Trades_Do_Action_Func c" colorButtons,% ""
						handler := "UnicodeBtn" A_Index "_" index "Handler"
						ConvertesChars := Hex2Bin(nString, element) ; Convert hex code into its corresponding unicode character
		   				SetUnicodeText(nString, %handler%) ; Replace the control's content with the unicode character

		   				TradesGUI_Controls.Insert("Button_Unicode_" A_Index, %handler%)
	   					TradesGUI_Controls.Insert("Button_Unicode_" A_Index "_Action", ctrlActions[key])
		   			}
	   			}
	   			hexCodes := "", ctrlActions := "", element := "", xpos := "", ypos := "", handler := "", ConvertesChars := "", nString := ""
				Gui, Font ; Revert to system font
				Gui, Font,% "S" fontSize " Q" fontQual,% fontName

;				Custom Buttons.
				Loop 9 {
					btnSettingsSize := ProgramSettings["Button" A_Index "_SIZE"]
					btnSettingsHor := ProgramSettings["Button" A_Index "_H"]
					btnSettingsVer := ProgramSettings["Button" A_Index "_V"]
					btnSettingsAction := ProgramSettings["Button" A_Index "_Action"]
					btnSettingsName := ProgramSettings["Button" A_Index "_Label"]

					defaultBtnY := (TradesGUI_Values.Use_Smaller_Buttons)?(131):(106)

					btnH := 35*guiScale
					btnW := (btnSettingsSize="Small")?(127*guiScale):(btnSettingsSize="Medium")?(257*guiScale):(btnSettingsSize="Large")?(387*guiScale):("ERROR")
					btnX := (btnSettingsHor="Left")?("s+" 5*guiScale):(btnSettingsHor="Center")?("s+" 135*guiScale):(btnSettingsHor="Right")?("s+" 265*guiScale):("ERROR")
					btnY := (btnSettingsVer="Top")?("s+" defaultBtnY*guiScale):(btnSettingsVer="Middle")?("s+" (defaultBtnY*guiScale)+(btnH+(3*guiScale))):(btnSettingsVer="Bottom")?("s+" (defaultBtnY*guiScale)+(2*(btnH+(3*guiScale)))):("ERROR")
					
					btnName := btnSettingsName
					btnAction := RegExReplace(btnSettingsAction, "[ _+()]", "_")
					btnAction := RegExReplace(btnAction, "___", "_")
					btnAction := RegExReplace(btnAction, "__", "_")
					btnAction := RegExReplace(btnAction, "_", "", ,1,-1)

					if ( btnW != "ERROR" && btnX != "ERROR" && btnY != "ERROR" && btnAction != "" && btnAction != "ERROR" ) {
						Gui, Add, Button,% "x" btnX . " y" btnY . " w" btnW . " h" btnH . " vCustomBtn" A_Index "_" index  . " hwndCustomBtn" A_Index "_" index "Handler" . " gGui_Trades_Do_Action_Func" " +BackgroundTrans c" colorButtons,% btnName
					}
					TradesGUI_Controls.Insert("Button_Custom_" A_Index "_" index, CustomBtn%A_Index%_%index%Handler)
					TradesGUI_Controls.Insert("Button_Custom_" A_Index "_Action", btnAction)
				}
				btnSettingsSize := "", btnSettingsHor := "", btnSettingsVer := "", btnSettingsAction := "", btnSettingsName := ""
				btnW := "", btnH := "", btnX := "", btnY := "", btnName := "", btnAction := ""
			}
		}
			
/* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
 *									Skinned TradesGUI													*
 * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
*/
		else {
;			Header
			Gui, Color, Black ; Prevents the flickering from being too noticeable
			Gui, Font,S%fontSize% Q%fontQual%,% fontName
			Gui, Add, Picture,% "x" borderSize . " y" borderSize . " w" guiWidth-borderSize . " h" 30*guiScale . " +BackgroundTrans",% programSkinFolderPath "\" activeSkin "\Header.png"
			Gui, Add, Picture,% "x" borderSize+(10*guiScale) . " y" borderSize+(5*guiScale) . " w" 22*guiScale . " h" 22*guiScale . " +BackgroundTrans",% programSkinFolderPath "\" activeSkin "\icon.png"
			Gui, Add, Text,% "x" borderSize+(35*guiScale) . " y" borderSize+(2*guiScale) . " w" guiWidth-(100*guiScale) . " h" 28*guiScale+(2*guiScale) " hwndguiTradesTitleHandler gGui_Trades_Move c" colorTitleInactive . " +BackgroundTrans +0x200 ",% programName " - Queued Trades: 0"
			Gui, Add, Text,% "x" guiWidth-(65*guiScale) . " yp" . " w" 65*guiScale . " hp" " hwndguiTradesMinimizeHandler gGui_Trades_Minimize c" colorTitleInactive . " +BackgroundTrans +0x200",% "MINIMIZE"

;			Static pictures assets
			Gui, Add, Picture,% "x" borderSize . " y" 32*guiScale . " w" guiWidth-borderSize . " h" guiHeight-borderSize . " +BackgroundTrans",% programSkinFolderPath "\" activeSkin "\Background.png"
			Gui, Add, Picture,% "x" 0 . " y" 52*guiScale . " w" guiWidth . " h" 2*guiScale . " hwndTabUnderlineHandler" . " +BackgroundTrans Section",% programSkinFolderPath "\" activeSkin "\TabUnderline.png"
			Gui, Add, Picture,% "xs" +360*guiScale . " ys" -20*guiScale . " w" 20*guiScale . " h" 20*guiScale . " vGoLeft" . " hwndGoLeftHandler" . " gGui_Trades_Skinned_Arrow_Left +BackgroundTrans",% programSkinFolderPath "\" activeSkin "\ArrowLeft.png"
			Gui, Add, Picture,% "x" 380*guiScale . " yp" . " wp" . " hp" . " vGoRight" . " hwndGoRightHandler" . " gGui_Trades_Skinned_Arrow_Right +BackgroundTrans",% programSkinFolderPath "\" activeSkin "\ArrowRight.png"
			Gui, Add, Picture,% "x" 378*guiScale . " y" 55*guiScale . " w" 20*guiScale . " h" 20*guiScale . " vBtnClose1" . " hwndBtnClose1Handler" . " gGui_Trades_Do_Action_Func  +BackgroundTrans",% programSkinFolderPath "\" activeSkin "\Close.png"
			TradesGUI_Controls.Insert("Arrow_Left", GoLeftHandler)
			TradesGUI_Controls.Insert("Arrow_Right", GoRightHandler)
			TradesGUI_Controls.Insert("Button_Close", BtnClose1Handler)

;			Borders
			Gui, Add, Picture,% "x" 0 . " y" 0 . " w" guiWidth . " h" borderSize . " hwndguiTradesBorderTop",% programSkinFolderPath "\" activeSkin "\Border.png" ; Top
			Gui, Add, Picture,% "x" 0 . " y" 0 . " w" borderSize . " h" guiHeight . " hwndguiTradesBorderLeft Section",% programSkinFolderPath "\" activeSkin "\Border.png" ; Left
			Gui, Add, Picture,% "x" guiWidth-borderSize . " y" 0 . " w" borderSize . " h" guiHeight . " hwndguiTradesBorderRight",% programSkinFolderPath "\" activeSkin "\Border.png" ; Right
			Gui, Add, Picture,% "x" 0 . " y" guiHeight-borderSize . " w" guiWidth . " h" borderSize . " hwndguiTradesBorderBottom",% programSkinFolderPath "\" activeSkin "\Border.png" ; Bottom
			TradesGUI_Controls.Insert("Border_Top", guiTradesBorderTop)
			TradesGUI_Controls.Insert("Border_Left", guiTradesBorderLeft)
			TradesGUI_Controls.Insert("Border_Right", guiTradesBorderRight)
			TradesGUI_Controls.Insert("Border_Bottom", guiTradesBorderBottom)

;			Error message
			Gui, Add, Text,% "x" borderSize . " y" 70*guiScale . " w" guiWidth-borderSize . " hwndErrorMsgTextHandler" . " Center +BackgroundTrans c" colorTradesInfos1,% noTradeMsg

			Loop %maxTabsRendered% {
				index := A_Index, tabPos := A_Index, xposMult := 49
				xpos := (tabPos * xposMult) - xposMult + borderSize, ypos := 32

;				Tab Pictures
				Gui, Add, Picture,% "x" xpos*guiScale . " y" ypos*guiScale . " w" 48*guiScale . " h" 20*guiScale " hwndTabIMG" index "Handler" . " vTabIMG" index . " gGui_Trades_Skinned_OnTabSwitch +BackgroundTrans",% programSkinFolderPath "\" activeSkin "\TabInactive.png"
				Gui, Font,% "Bold Q" fontQual
				Gui, Add, Text,% "xp" . " yp+" 3*guiScale . " w" 48*guiScale . " h" 20*guiScale . " hwndTabTXT" index "Handler" . " vTabTXT" index . " gGui_Trades_Skinned_OnTabSwitch +BackgroundTrans 0x01 c" colorTabs,% index
				Gui, Font, Norm S%fontSize% Q%fontQual%

;				Buyer / Item / ... Static Text
				if ( index = 1 ) {
					Gui, Add, Text,% "xs" +6*guiScale . " y" 55*guiScale . " w" 60*guiScale . " h" 15*guiScale . " hwndBuyerText" index "Handler" . " +BackgroundTrans" . " c" colorTradesInfos1 " Section",% "Buyer: "
					Gui, Add, Text,% "xp" . " yp+" 15*guiScale . " wp" . " hp" . " hwndItemText" index "Handler" . " +BackgroundTrans" . " c" colorTradesInfos1,% "Item: "
					Gui, Add, Text,% "xp" . " yp+" 15*guiScale . " wp" . " hp" . " hwndPriceText" index "Handler" . " +BackgroundTrans" . " c" colorTradesInfos1,% "Price: "
					Gui, Add, Text,% "xp" . " yp+" 15*guiScale . " wp" . " hp" . " hwndLocationText" index "Handler" . " +BackgroundTrans" . " c" colorTradesInfos1,% "Location: "
					Gui, Add, Text,% "xp" . " yp+" 15*guiScale . " wp" . " hp" . " hwndOtherText" index "Handler" . " +BackgroundTrans" . " c" colorTradesInfos1,% "Other: "
				}

;				Buyer / Item / ... Slots
				Gui, Add, Text,% "xs" +75*guiScale . " ys" . " w" 255*guiScale . " h" 15*guiScale . " vBuyerSlot" index . " hwndBuyerSlot" index "Handler" . " +BackgroundTrans +0x0100 R1 c" colorTradesInfos2,% ""
				Gui, Add, Text,% "xp" . " yp+" 15*guiScale . " w" 310*guiScale . " hp" . " vItemSlot" index . " hwndItemSlot" index "Handler" . " +BackgroundTrans +0x0100 R1 c" colorTradesInfos2,% ""
				Gui, Add, Text,% "xp" . " yp+" 15*guiScale . " wp" . " hp" . " vPriceSlot" index . " hwndPriceSlot" index "Handler" . " +BackgroundTrans +0x0100 R1 c" colorTradesInfos2,% ""
				Gui, Add, Text,% "xp" . " yp+" 15*guiScale . " wp" . " hp" . " vLocationSlot" index . " hwndLocationSlot" index "Handler" . " +BackgroundTrans +0x0100 R1 c" colorTradesInfos2,% ""
				Gui, Add, Text,% "xp" . " yp+" 15*guiScale . " wp" . " hp" . " vOtherSlot" index . " hwndOtherSlot" index "Handler" . " +BackgroundTrans +0x100 R1 c" colorTradesInfos2,% ""
				Gui, Add, Text,% "x" (378*guiScale)-timeSlotWidth . " y" 57*guiScale " w" timeSlotWidth . " h" 15*guiScale . " vTimeSlot" index . " hwndTimeSlot" index "Handler" . " +BackgroundTrans R1 c" colorTradesInfos2,% ""
				Gui, Add, Text,% "xp" . " yp" . " w0" . " h0" . " vPIDSlot" index . " hwndPIDSlot" index "Handler",% ""
				Gui, Add, Text,% "xp" . " yp" . " w0" . " h0" . " vDateSlot" index . " hwndDateSlot" index "Handler",% ""
				Gui, Add, Text,% "xp" . " yp" . " w0" . " h0" . " vGuildSlot" index . " hwndGuildSlot" index "Handler",% ""

;				Hide the controls. They will be re-enabled later, based on the current amount of trade requests.
				GuiControl, Trades:Hide,% TabIMG%index%Handler
				GuiControl, Trades:Hide,% TabTXT%index%Handler
				TradesGUI_Controls.Insert("Tab_IMG_" index,TabIMG%index%Handler)
				TradesGUI_Controls.Insert("Tab_TXT_" index,TabTXT%index%Handler)

				GuiControl, Trades:Hide,BuyerSlot%index%
				GuiControl, Trades:Hide,ItemSlot%index%
				GuiControl, Trades:Hide,PriceSlot%index%
				GuiControl, Trades:Hide,LocationSlot%index%
				GuiControl, Trades:Hide,OtherSlot%index%
				GuiControl, Trades:Hide,TimeSlot%index%
				TradesGUI_Controls.Insert("Buyer_Slot_" index,BuyerSlot%index%Handler)
				TradesGUI_Controls.Insert("Item_Slot_" index,ItemSlot%index%Handler)
				TradesGUI_Controls.Insert("Price_Slot_" index,PriceSlot%index%Handler)
				TradesGUI_Controls.Insert("Location_Slot_" index,LocationSlot%index%Handler)
				TradesGUI_Controls.Insert("Other_Slot_" index,OtherSlot%index%Handler)
				TradesGUI_Controls.Insert("Time_Slot_" index,TimeSlot%index%Handler)
				TradesGUI_Controls.Insert("PID_Slot_" index,PIDSlot%index%Handler)
				TradesGUI_Controls.Insert("Date_Slot_" index,DateSlot%index%Handler)
				TradesGUI_Controls.Insert("Guild_Slot_" index,GuildSlot%index%Handler)
			}

			hexCodes := ["41", "42", "45", "43", "44"] ; 41:Clip/42:Whis/43:Trade/44:Kick/45:Inv
			ctrlActions := ["Clipboard" , "Whisper", "Invite", "Trade", "Kick"]
			for key, element in hexCodes {
				btnPos := ProgramSettings["Button_Unicode_" A_Index "_Position"]
				if ( btnPos != "Disabled" ) {

					btnX := ((btnPos-1)*(40*guiScale))+(7*guiScale)
					btnY := 135*guiScale
					btnW := 35*guiScale, btnH := 23*guiScale

					btnOrnaW := 6*guiScale, btnOrnaH := btnH
					btnOrnaLeftX := btnX, btnOrnaRightX := btnX+btnW-btnOrnaW
					btnOrnaLeftY := btnY, btnOrnaRightY := btnY

					btnTextX := btnX, btnTextY := btnY-(2*guiScale)
					btnTextW := btnW, btnTextH := btnH

					Gui, Font,% "S" 20*guiScale,% "TC-Symbols"

					Gui, Add, Picture,% "x" btnX . " y" btnY . " w" btnW . " h" btnH . " vUnicodeBtn" A_Index . " hwndUnicodeBtn" A_Index "Handler" . " gGui_Trades_Do_Action_Func +BackgroundTrans",% programSkinFolderPath "\" activeSkin "\ButtonBackground.png"
					Gui, Add, Picture,% "x" btnOrnaLeftX . " y" btnOrnaLeftY . " w" btnOrnaW . " h" btnOrnaH  . " hwndUnicodeBtn" A_Index "OrnamentLeftHandler" . " +BackgroundTrans",% programSkinFolderPath "\" activeSkin "\ButtonOrnamentLeft.png"
					Gui, Add, Picture,% "x" btnOrnaRightX . " y" btnOrnaRightY . " w" btnOrnaW . " h" btnOrnaH . " hwndUnicodeBtn" A_Index "OrnamentRightHandler" . " +BackgroundTrans",% programSkinFolderPath "\" activeSkin "\ButtonOrnamentRight.png"
					Gui, Add, Text,% "x" btnTextX . " y" btnTextY . " w" btnTextW . " h" btnTextH . " vUnicodeBtn" A_Index "TXT" . " hwndUnicodeBtn" A_Index "TXTHandler" . " gGui_Trades_Do_Action_Func Center +BackgroundTrans c" colorButtons,% ""
					handler := "UnicodeBtn" A_Index "TXTHandler"
					ConvertesChars := Hex2Bin(nString, element) ; Convert hex code into its corresponding unicode character
		   			SetUnicodeText(nString, %handler%) ; Replace the control's content with the unicode character

		   			handler :=  "UnicodeBtn" A_Index "Handler", TradesGUI_Controls.Insert("Button_Unicode_" A_Index, %handler% )
		   			handler :=  "UnicodeBtn" A_Index "OrnamentLeftHandler", TradesGUI_Controls.Insert("Button_Unicode_" A_Index "_OrnamentLeft", %handler%)
		   			handler := "UnicodeBtn" A_Index "OrnamentRightHandler", TradesGUI_Controls.Insert("Button_Unicode_" A_Index "_OrnamentRight", %handler%)
		   			handler := "UnicodeBtn" A_Index "TXTHandler"
		   			TradesGUI_Controls.Insert("Button_Unicode_" A_Index "_Action", ctrlActions[key])
		   			TradesGUI_Controls.Insert("Button_Unicode_" A_Index "_Text", %handler%)
		   		}
   			}
   			hexCodes := "", ctrlActions := "", element := "", xpos := "", ypos := "", handler := "", ConvertesChars := "", nString := ""
   			btnX := "", btnY := "", btnW := "", btnH := ""
   			btnOrnaW := "", btnOrnaH := "", btnOrnaLeftX := "", btnOrnaRightX := "", btnOrnaLeftY := "", btnOrnaRightY := ""
			btnTextX := "", btnTextY := "", btnTextW := "", btnTextH := ""
			Gui, Font ; Revert to system font
			Gui, Font,% "S" fontSize " Q" fontQual,% fontName

;			Custom Buttons.
			Loop 9 {
				btnSettingsSize := ProgramSettings["Button" A_Index "_SIZE"]
				btnSettingsHor := ProgramSettings["Button" A_Index "_H"]
				btnSettingsVer := ProgramSettings["Button" A_Index "_V"]
				btnSettingsAction := ProgramSettings["Button" A_Index "_Action"]
				btnSettingsName := ProgramSettings["Button" A_Index "_Label"]

				defaultBtnY := (TradesGUI_Values.Use_Smaller_Buttons)?(163*guiScale):(138*guiScale)

				btnH := 35*guiScale
				btnW := (btnSettingsSize="Small")?(127*guiScale):(btnSettingsSize="Medium")?(257*guiScale):(btnSettingsSize="Large")?(387*guiScale):("ERROR")
				btnX := (btnSettingsHor="Left")?(7*guiScale):(btnSettingsHor="Center")?(137*guiScale):(btnSettingsHor="Right")?(267*guiScale):("ERROR")
				btnY := (btnSettingsVer="Top")?(defaultBtnY):(btnSettingsVer="Middle")?(defaultBtnY+(40*guiScale)):(btnSettingsVer="Bottom")?(defaultBtnY+(80*guiScale)):("ERROR")

				btnOrnaW := 8*guiscale, btnOrnaH := btnH
				btnOrnaLeftX := btnX, btnOrnaRightX := btnX+btnW-btnOrnaW
				btnOrnaLeftY := btnY, btnOrnaRightY := btnY

				btnTextX := btnX, btnTextY := "p+" 10*guiScale, btnTextW := btnW, btnTextH := btnH

				btnName := btnSettingsName
				btnAction := RegExReplace(btnSettingsAction, "[ _+()]", "_")
				btnAction := RegExReplace(btnAction, "___", "_")
				btnAction := RegExReplace(btnAction, "__", "_")
				btnAction := RegExReplace(btnAction, "_", "", ,1,-1)

				if ( btnW != "ERROR" && btnX != "ERROR" && btnY != "ERROR" && btnAction != "" && btnAction != "ERROR" ) {
					Gui, Add, Picture,% "x" btnX . " y" btnY . " w" btnW . " h" btnH . " vCustomBtn" A_Index . " hwndCustomBtn" A_Index "Handler" . " +BackgroundTrans gGui_Trades_Do_Action_Func",% programSkinFolderPath "\" activeSkin "\ButtonBackground.png"
					Gui, Add, Picture,% "x" btnOrnaLeftX . " y" btnOrnaLeftY . " w" btnOrnaW . " h" btnOrnaH . " vCustomBtn" A_Index "OrnamentLeft" . " hwndCustomBtn" A_Index "OrnamentLeftHandler" . " +BackgroundTrans",% programSkinFolderPath "\" activeSkin "\ButtonOrnamentLeft.png"
					Gui, Add, Picture,% "x" btnOrnaRightX . " y" btnOrnaRightY . " w" btnOrnaW . " h" btnOrnaH . " vCustomBtn" A_Index "OrnamentRight" . " hwndCustomBtn" A_Index "OrnamentRightHandler" . " +BackgroundTrans",% programSkinFolderPath "\" activeSkin "\ButtonOrnamentRight.png"
					Gui, Add, Text,% "x" btnTextX . " y" btnTextY . " w" btnTextW . " vCustomBtn" A_Index . "TXT hwndCustomBtn" A_Index "TXTHandler" . " Center +BackgroundTrans c" colorButtons,% btnName

					TradesGUI_Controls.Insert("Button_Custom_" A_Index, CustomBtn%A_Index%Handler)
					TradesGUI_Controls.Insert("Button_Custom_" A_Index "_OrnamentLeft", CustomBtn%A_Index%OrnamentLeftHandler)
					TradesGUI_Controls.Insert("Button_Custom_" A_Index "_OrnamentRight", CustomBtn%A_Index%OrnamentRightHandler)
					TradesGUI_Controls.Insert("Button_Custom_" A_Index "_Text", CustomBtn%A_Index%TXTHandler)
					TradesGUI_Controls.Insert("Button_Custom_" A_Index "_Action", btnAction)
				}
			}
			btnSettingsSize := "", btnSettingsHor := "", btnSettingsVer := "", btnSettingsAction := "", btnSettingsName := ""
			btnW := "", btnH := "", btnX := "", btnY := "", btnName := "", btnAction := ""
			btnOrnaW := "", btnOrnaH := "", btnOrnaLeftX := "", btnOrnaRightX := "", btnOrnaLeftY := "", btnOrnaRightY := ""
			btnTextX := "", btnTextY := "", btnTextW := "", btnTextH := ""
		}
	}

/* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
*/

	if ( mode = "EXE_NOT_FOUND" ) {
		Loop {
			countDown := 10
			Loop % countDown+1 {
				exeNotFoundMsgReplaced := RegExReplace(exeNotFoundMsg, "XX", countDown)
				GuiControl, Trades:,% ErrorMsgTextHandler,% exeNotFoundMsgReplaced
				countDown--
				Sleep 1000
			}
			gameInstances := Get_All_Games_Instances()
			if ( gameInstances != "EXE_NOT_FOUND" ) {
				GuiControl, Trades:,% ErrorMsgTextHandler,% noTradeMsg
				Break
			}
		}
		gameInstances := ""
		Monitor_Game_Logs()
	}

	else if ( mode = "REMOVE_DUPLICATES" ) {
		tabToDel := tradeInfos[0]
		for key, element in tradeInfos {
			messagesArray := Gui_Trades_Manage_Trades("REMOVE_CURRENT", ,element)
			if ( tabToDel >= element ) ; our tabToDel moved to the left due to a lesser tab being deleted
				tabToDel--
			Gui_Trades("UPDATE", messagesArray)
			if ( activeSkin != "System" ) {
				GoSub Gui_Trades_Skinned_OnTabSwitch
			}
		}
	}

	if ( mode = "UPDATE" || mode = "CREATE" ) {

		tabsCount := tradeInfos.Max_Index
		tabsCount := (!tabsCount)?(0):(tabsCount)
		TradesGUI_Values.Tabs_Count := tabsCount

		tabsCountReduced := (previousTabsCount > tabsCount)?(1):(0), TradesGUI_Values.Tabs_Count_Reduced := tabsCountReduced
		tabsCountIncreased := (previousTabsCount < tabsCount)?(1):(0), TradesGUI_Values.Tabs_Count_Increased := tabsCountIncreased
		tabsCountChanged := (previousTabsCount != tabsCount)?(1):(0), TradesGUI_Values.Tabs_Count_Changed := tabsCountChanged

		if (activeSkin="System") {
			TradesGUI_Values.Active_Tab := Gui_Trades_Get_Tab_ID()
		}

		TradesGUI_Values.Previous_Active_Tab := (ProgramSettings.Trades_Select_Last_Tab && tabsCountIncreased)?(TradesGUI_Values.Active_Tab) ; Select last tab enabled. Last tab is now the current tab (before current tab is assigned to most recent tab)
										   :(TradesGUI_Values.Previous_Active_Tab) ; Leave it as it is
		TradesGUI_Values.Active_Tab := (!TradesGUI_Values.Active_Tab)?(1) ; Value previously unassigned, make sure to focus tab 1.
								      :(ProgramSettings.Trades_Select_Last_Tab && tabsCountIncreased)?(tabsCount) ; Assign to most recent tab.
						   			  :(TradesGUI_Values.Active_Tab) ; Leave it as it is

;		Update the fields with the trade infos
		tabsList := "", isGuiActive := false
		Loop % tradeInfos.Max_Index {
			isGuiActive := true
			tabsList .= "|" A_Index
			GuiControl, Trades:,% buyerSlot%A_Index%Handler,% tradeInfos[A_Index "_Buyer"]
			GuiControl, Trades:,% itemSlot%A_Index%Handler,% tradeInfos[A_Index "_Item"]
			GuiControl, Trades:,% priceSlot%A_Index%Handler,% tradeInfos[A_Index "_Price"]
			GuiControl, Trades:,% locationSlot%A_Index%Handler,% tradeInfos[A_Index "_Location"]
			GuiControl, Trades:,% PIDSlot%A_Index%Handler,% tradeInfos[A_Index "_PID"]
			GuiControl, Trades:,% TimeSlot%A_Index%Handler,% tradeInfos[A_Index "_Time"]
			GuiControl, Trades:,% OtherSlot%A_Index%Handler,% tradeInfos[A_Index "_Other"]
			GuiControl, Trades:,% DateSlot%A_Index%Handler,% tradeInfos[A_Index "_Date"]
			GuiControl, Trades:,% GuildSlot%A_Index%Handler,% tradeInfos[A_Index "_Guild"]
			if ( A_Index <= maxTabsRow && activeSkin != "System" ) {
				GuiControl, Trades:Show,% TabIMG%A_Index%Handler
				GuiControl, Trades:Show,% TabTXT%A_Index%Handler
			}
		}

;		Handle some GUI elements
		if (isGuiActive) {
			showState := "Show"
			GuiControl, Trades:Hide,% ErrorMsgTextHandler
			GuiControl, Trades: +c%colorTitleActive%,% guiTradesTitleHandler
			GuiControl, Trades: +c%colorTitleActive%,% guiTradesMinimizeHandler
		}
		else {
			showState := "Hide"
			GuiControl, Trades:,% ErrorMsgTextHandler,% noTradeMsg
			GuiControl, Trades:Show,% ErrorMsgTextHandler
			GuiControl, Trades: +c%colorTitleInactive%,% guiTradesTitleHandler
			GuiControl, Trades: +c%colorTitleInactive%,% guiTradesMinimizeHandler
		}
		clickThroughState := ( ProgramSettings.Trades_Click_Through && !isGuiActive )?("+"):("-")
		transparency := (!isGuiActive)?(ProgramSettings.Transparency):(ProgramSettings.Transparency_Active)
		Gui, Trades: +LastFound
		Gui, Trades: %clickThroughState%E0x20
		WinSet, Transparent,% transparency ; Using A_Gui instead of the Gui's handle fixes an issue where the transparency would not be applied with EXE_NOT_FOUND.
										   ; After testings, it creates another issue where it sets the transparency to the game's window
										   ; It seems that activating another window prior to applying the transparency allows us to use the handler.
										   ; Using +LastFound and WinSet without any specified window seems to be the most reliable way to detect the GUI handler.
		GuiControl, Trades:Text,% guiTradesTitleHandler,% programName " - Queued Trades: " tabsCount ; Update the title
		GuiControl, Trades:%showState%,Tab ; Only used when no skin is applied
		GuiControl, Trades:%showState%,% GoLeftHandler ; Only used for skins
		GuiControl, Trades:%showState%,% GoRightHandler ; Only used for skins
		GuiControl, Trades:%showState%,% TabUnderlineHandler ; Only used for skins

		if ( activeSkin != "System" ) { ; Remove the deleted tab image.
			tabDeleted := tabsCount+1
			GuiControl, Trades:Hide,% TabIMG%tabDeleted%Handler
			GuiControl, Trades:Hide,% TabTXT%tabDeleted%Handler

			Loop 9 { ; Hide or show the controls.
				GuiControl, Trades:%showState%,% CustomBtn%A_Index%Handler
				GuiControl, Trades:%showState%,% CustomBtn%A_Index%TXTHandler
				GuiControl, Trades:%showState%,% CustomBtn%A_Index%OrnamentLeftHandler
				GuiControl, Trades:%showState%,% CustomBtn%A_Index%OrnamentRightHandler

				GuiControl, Trades:%showState%,% UnicodeBtn%A_Index%Handler
				GuiControl, Trades:%showState%,% UnicodeBtn%A_Index%TXTHandler
				GuiControl, Trades:%showState%,% UnicodeBtn%A_Index%OrnamentLeftHandler
				GuiControl, Trades:%showState%,% UnicodeBtn%A_Index%OrnamentRightHandler

				GuiControl, Trades:%showState%,% BuyerText1Handler
				GuiControl, Trades:%showState%,% ItemText1Handler
				GuiControl, Trades:%showState%,% PriceText1Handler
				GuiControl, Trades:%showState%,% LocationText1Handler
				GuiControl, Trades:%showState%,% BtnClose1Handler
				GuiControl, Trades:%showState%,% OtherText1Handler
			}

			GoSub Gui_Trades_Skinned_OnTabSwitch
		}
		else {
			GuiControl, Trades:,Tab,% tabsList  ;	Apply the new list of tabs.
;			Select the correct tab after udpating
			if ( ProgramSettings.Trades_Select_Last_Tab ) && (!A_GuiEvent) { ; A_GuiEvent means we've just closed a tab. We do not want to activate the latest available tab.
				GuiControl, Trades:Choose,Tab,% tabsCount
				TradesGUI_Values.Active_Tab := tabsCount
			}
			else {
				GuiControl, Trades:Choose,Tab,% TradesGUI_Values.Active_Tab
				if ( ErrorLevel ) {
					TradesGUI_Values.Active_Tab--
					GuiControl, Trades:Choose,Tab,% TradesGUI_Values.Active_Tab
				}
			}
		}

		if (tabsCount >= maxTabsRendered-1 && maxTabsRendered != maxTabsStage5) { ;	Tabs limit almost reached.
			maxTabsRendered := (maxTabsRendered=maxTabsStage1)?(maxTabsStage2)
							  :(maxTabsRendered=maxTabsStage2)?(maxTabsStage3)
							  :(maxTabsRendered=maxTabsStage3)?(maxTabsStage4)
							  :(maxTabsRendered=maxTabsStage4)?(maxTabsStage5)
							  :(maxTabsStage2)
			if ( activeSkin="System")
				TradesGUI_Values.Active_Tab := Gui_Trades_Get_Tab_ID()

			TradesGUI_Values.Active_Tab := (!TradesGUI_Values.Active_Tab)?(1):(TradesGUI_Values.Active_Tab)
			TradesGUI_Values.Previous_Active_Tab := TradesGUI_Values.Active_Tab+1
			Gui_Trades_Redraw("CREATE", {noSplash:1})

			if ( activeSkin != "System" ) {
				Loop { ; Go back to the previously selected tab
					TradesGUI_Values.Active_Tab := (ProgramSettings.Trades_Select_Last_Tab = 1)?(tabsCount):(TradesGUI_Values.Active_Tab) ; Set the active tab to the latest available tab if Select_Last_Tab is enabled

					tabRanges := Gui_Trades_Skinned_Get_Tabs_Images_Range() 
					firstTab := tabRanges.First_Tab, lastTab := tabRanges.Last_Tab, num := TradesGUI_Values.Active_Tab
					if num between %firstTab% and %lastTab%
						Break
					Gui_Trades_Skinned_Arrow_Right()
				}
			}
			else {
				TradesGUI_Values.Active_Tab := (ProgramSettings.Trades_Select_Last_Tab)?(tabsCount):(TradesGUI_Values.Previous_Active_Tab-1)
				GuiControl, Trades:Choose,Tab,% TradesGUI_Values.Active_Tab
			}
		}
		if (tabsCount=0 && maxTabsRendered>maxTabsStage1) && (mode!="CREATE") { ; Tabs limit higher than default, and no tab on queue. We can reset to default limit.
			maxTabsRendered := maxTabsStage1
			Gui_Trades_Redraw("CREATE", {noSplash:1})
			TradesGUI_Values.Active_Tab := 0, TradesGUI_Values.Previous_Active_Tab := 0
		}

		if ( activeSkin != "System") {
			if ( ProgramSettings.Trades_Select_Last_Tab ) && ( tabsCountIncreased ) {
					Gui_Trades_Skinned_Arrow_Right(,,,1)
			}
		}

		if ( ProgramSettings.Trades_Auto_Minimize && !isGuiActive && !TradesGUI_Values.Is_Minimized && mode != "EXE_NOT_FOUND" ) {
			GoSub, Gui_Trades_Minimize
		}
		if ( ProgramSettings.Trades_Auto_UnMinimize && isGuiActive && TradesGUI_Values.Is_Minimized ) {
			GoSub, Gui_Trades_Minimize
		}

		if ( ProgramSettings.Clip_On_Tab_Switch )
			Gui_Trades_Clipboard_Item_Func()
	}
	if ( mode = "CREATE" ) {
		showWidth := guiWidth
		showHeight := guiHeight
		IniRead, showX,% iniFilePath,PROGRAM,X_POS
		IniRead, showY,% iniFilePath,PROGRAM,Y_POS
		showXDefault := A_ScreenWidth-(showWidth), showYDefault := 0 ; Top right
		showX := (IsNum(showX))?(showX):(showXDefault) ; Prevent unassigned or incorrect value
		showY := (IsNum(showY))?(showY):(showYDefault) ; Prevent unassigned or incorrect value
		Gui, Trades:Show,% "NoActivate w" showWidth " h" showHeight " x" showX " y" showY,% programName " - Queued Trades"
		if (ProgramSettings.Trades_Auto_Minimize)
			Gui_Trades_Minimize_Func("MIN", 1)
		OnMessage(0x200, "WM_MOUSEMOVE")
		OnMessage(0x201, "WM_LBUTTONDOWN")
		OnMessage(0x203, "WM_LBUTTONDBLCLK")
		OnMessage(0x204, "WM_RBUTTONDOWN")

		dpiFactor := ProgramSettings.Screen_DPI, showX := guiWidth-49
	}


	if ( ProgramSettings.Trades_GUI_Mode = "Overlay") {
		try	Gui_Trades_Set_Position()
	}

	Gui, Trades: +LastFound
	WinSet, Redraw
	WinSet, AlwaysOnTop, On
	IniWrite,% tabsCount,% iniFilePath,PROGRAM,Tabs_Number

	previousTabsCount := tabsCount
	sleep 10
	return

	Gui_Trades_OnTabSwitch:
;		Clipboard the item's infos on tab switch if the user enabled
		Gui, Trades:Submit, NoHide

		TradesGUI_Values.Active_Tab := Gui_Trades_Get_Tab_ID()
		if (  ProgramSettings.Clip_On_Tab_Switch )
			Gui_Trades_Clipboard_Item_Func()
	return

	Gui_Trades_Skinned_OnTabSwitch:
		Gui, Trades:Submit, NoHide

		if RegExMatch(A_GuiControl, "TabIMG|TabTXT") {
			RegExMatch(A_GuiControl, "\d+", btnID)
			GuiControlGet, tabID, Trades:,% TradesGUI_Controls["Tab_TXT_" btnID]
			TradesGUI_Values.Active_Tab := tabID
		}

		TradesGUI_Values.Active_Tab := ( TradesGUI_Values.Tabs_Count && (TradesGUI_Values.Tabs_Count < TradesGUI_Values.Active_Tab) )?(TradesGUI_Values.Tabs_Count)
									  :(TradesGUI_Values.Active_Tab)

		Gui_Trades_Skinned_Show_Tab_Content()
		if ( ProgramSettings.Clip_On_Tab_Switch )
			Gui_Trades_Clipboard_Item_Func()
		TradesGUI_Values.Previous_Active_Tab := TradesGUI_Values.Active_Tab
	Return

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
	Return 

	Gui_Trades_Size:
;		Declare the global GUI width and height
		TradesGUI_Values.Width := A_GuiWidth
		TradesGUI_Values.Height := A_GuiHeight
	return

	Gui_Trades_Close:
	Return
	Gui_Trades_Escape:
	Return
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

	FileDelete,% ProgramValues.Trades_Backup_File
}

Trades_GUI_Exists() {
/*		Returns the handler of the Trades GUI if a match is found.
 */
	global TradesGUI_Values
	return WinExist("ahk_id " TradesGUI_Values.Handler)
}

Gui_Trades_Minimize_Func(state="", skipAnimation="") {
	global TradesGUI_Values

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
		if ( TradesGUI_Values.Is_Minimized ) {
			tHeight := guiHeight
			Loop { ; Create the illusion of an animation
				if ( tHeight = guiHeightMin )
					Break
				tHeight := (guiHeightMin<tHeight)?(tHeight-30):(guiHeightMin)
				tHeight := (tHeight-30<guiHeightMin)?(guiHeightMin):(tHeight)
				Gui_Trades_Set_Height(tHeight)
				sleep 1 ; Smoothen up the animation
			}
		}
		else  {
			tHeight := guiHeightMin
			Loop {
				if ( tHeight = guiHeight )
					Break
				tHeight := (guiHeight>tHeight)?(tHeight+30):(guiHeight)
				tHeight := (tHeight+30>guiHeight)?(guiHeight):(tHeight)
				Gui_Trades_Set_Height(tHeight)
				sleep 1
			}
		}
	}
	sleep 10
	DetectHiddenWindows, %detectHiddenWin%
}

Gui_Trades_Skinned_Adjust_Tab_Range() {
/*		Clicks on the left/right arrows based
		on the difference between active tab and tab range
*/
	global TradesGUI_Values, TradesGUI_Controls

	activeTab := TradesGUI_Values.Active_Tab
	tabRange := Gui_Trades_Skinned_Get_Tabs_Images_Range()

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
				Gui_Trades_Skinned_Arrow_Right()
			else if (isLowerThanFirst)
				Gui_Trades_Skinned_Arrow_Left(7)
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
	if (selectTabID >= 1 && selectTabID <= tabsCount) {
		if (ProgramSettings.Active_Skin = "System") {
			GuiControl, Trades:Choose,% tabCtrl,% selectTabID
			TradesGUI_Values.Previous_Active_Tab := currentTabID
			TradesGUI_Values.Active_Tab := selectTabID
		}
		else {
			Gui_Trades_Skinned_Show_Tab_Content(selectTabID)
		}
	}
}


Gui_Trades_Set_Height(desiredHeight) {
/*		Move the bottom border and set the GUI height
*/
	global TradesGUI_Controls, TradesGUI_Values, ProgramSettings

	dpiFactor := ProgramSettings.Screen_DPI
	; tabHeight := Gui_Trades_Get_Tab_Height()
	guiHeightMin := TradesGUI_Values.Height_Minimized
	guiHeightFull := TradesGUI_Values.Height_Full
	guiScale := ProgramSettings.Scale_Multiplier
	
	GuiControlGet, borderSize, Trades:Pos,% TradesGUI_Controls.Border_Top
	; GuiControl, Trades:Move,% TradesGUI_Controls.Tab,h%tabHeight%
	; GuiControl, Trades:Move,% TradesGUI_Controls.Border_Left,h%desiredHeight%
	; GuiControl, Trades:Move,% TradesGUI_Controls.Border_Right,h%desiredHeight%
	GuiControl, Trades:Move,% TradesGUI_Controls.Border_Bottom,% "y" desiredHeight-borderSizeH
	WinMove,% "ahk_id " TradesGUI_Values.Handler, , , , ,% desiredHeight*dpiFactor
}

Gui_Trades_Skinned_Arrow_Left(CtrlHwnd="", GuiEvent="", EventInfo="") {
;		Only used when a skin is applied.
;		Simulates scrolling through tabs.
	global TradesGUI_Values, TradesGUI_Controls
	if ( TradesGUI_Values.Cancel_Action ) {
		TradesGUI_Values.Cancel_Action := 0
		Return
	}

	maxTabsRow := TradesGUI_Values.Max_Tabs_Per_Row
	tabsCount := TradesGUI_Values.Tabs_Count

	tabsRange := Gui_TradeS_Skinned_Get_Tabs_Images_Range()
	if ( tabsRange.First_Tab > 1 ) {
		index := maxTabsRow
		Loop %maxTabsRow% {
			index := A_Index
			txtContent := tabsRange.First_Tab+index-2
			GuiControl,Trades:,% TradesGUI_Controls["Tab_TXT_" index],% txtContent
		}
		Gui_Trades_Skinned_Set_Tab_Images_State("LEFT")
	}	
}

Gui_Trades_Skinned_Arrow_Right(CtrlHwnd="", GuiEvent="", EventInfo="", goFar=0) {
;		Only used when a skin is applied.
;		Simulates scrolling through tabs.
	global TradesGUI_Values, TradesGUI_Controls

	if ( TradesGUI_Values.Cancel_Action ) {
		TradesGUI_Values.Cancel_Action := 0
		Return
	}

	maxTabsRow := TradesGUI_Values.Max_Tabs_Per_Row
	tabsCount := TradesGUI_Values.Tabs_Count
	tabsRange := Gui_TradeS_Skinned_Get_Tabs_Images_Range()

	if (goFar) {
		Loop {
			tabsRange := Gui_TradeS_Skinned_Get_Tabs_Images_Range()
			lastTab := tabsRange.Last_Tab
			if (tabsCount && lastTab < TradesGUI_Values.Tabs_Count) {
				Gui_Trades_Skinned_Arrow_Right()
			}
			else Break
		}
	}
	if ( tabsCount > tabsRange.Last_Tab ) {
		index := maxTabsRow
		Loop %maxTabsRow% {
			index := A_Index
			txtContent := tabsRange.First_Tab+index
			GuiControl,Trades:,% TradesGUI_Controls["Tab_TXT_" index],% txtContent
		}
		Gui_Trades_Skinned_Set_Tab_Images_State("RIGHT")
	}
}

Gui_TradeS_Skinned_Get_Tabs_Images_Range() {
	global TradesGUI_Values, TradesGUI_Controls, ProgramSettings, ProgramValues

	GuiControlGet, lastTab, Trades:,% TradesGUI_Controls["Tab_TXT_" TradesGUI_Values.Max_Tabs_Per_Row]
	GuiControlGet, firstTab, Trades:,% TradesGUI_Controls["Tab_TXT_1"]

	return {Last_Tab:lastTab,First_Tab:firstTab}
}

Gui_Trades_Skinned_Set_Tab_Images_State(arrow="") {
	global TradesGUI_Values, TradesGUI_Controls, ProgramSettings, ProgramValues

	previousID := TradesGUI_Values.Previous_Active_Tab
	currentID := TradesGUI_Values.Active_Tab
	previousID := (previousID="")?(1):(previousID)

	tabsRange := Gui_TradeS_Skinned_Get_Tabs_Images_Range()

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
		Gui_Trades_Skinned_Arrow_Left() ; Hide the tab that has been removed
		Gui_Trades_Skinned_Arrow_Right() ; Stay in the same tabs range
	}
	TradesGUI_Values.Tabs_Count_Reduced := 0
	; else if (TradesGUI_Values.Tabs_Count_Reduced && tabsRange.Last_Tab = tabsCount) { 
		; TradesGUI_Values.Tabs_Count_Reduced := 0
	; }

}

Gui_Trades_Skinned_Show_Tab_Content(showTabID="") {
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
	Gui_Trades_Skinned_Set_Tab_Images_State()
	TradesGUI_Values.Previous_Active_Tab := showTabID
	Gui_Trades_Skinned_Adjust_Tab_Range()
}

Gui_Trades_Close_Tab() {
	global TradesGUI_Values, ProgramSettings

	countBeforeDeletion := TradesGUI_Values.Tabs_Count
	tradesMessages := Gui_Trades_Manage_Trades("REMOVE_CURRENT", ,TradesGUI_Values.Active_Tab)
	Gui_Trades("UPDATE", tradesMessages)
	if (ProgramSettings.Active_Skin != "System") {
		if (countBeforeDeletion = TradesGUI_Values.Active_Tab) {
			TradesGUI_Values.Active_Tab--
		}
		Gui_Trades_Skinned_Show_Tab_Content()
	}
}

Gui_Trades_Do_Action_Func(CtrlHwnd, GuiEvent, EventInfo) {
	global TradesGUI_Values, ProgramSettings, TradesGUI_Controls, ProgramValues

	if ( TradesGUI_Values.Cancel_Action ) {
		TradesGUI_Values.Cancel_Action := 0
		Return
	}

	GuiControlGet, varName, Name,% CtrlHwnd
	RegExMatch(varName, "\d+", varNum)
	RegExMatch(varName, "\D+", varAlpha)
	btnAction := (varAlpha="CustomBtn")?(TradesGUI_Controls["Button_Custom_" varNum "_Action"])
				:(varAlpha="UnicodeBtn")?(TradesGUI_Controls["Button_Unicode_" varNum "_Action"])
				:(varAlpha="BtnClose")?("Close_Tab")
				:(varAlpha)

	messages := Object()
	tabInfos := Gui_Trades_Get_Trades_Infos(TradesGUI_Values.Active_Tab)
	if (!tabInfos.Buyer && btnAction != "Close_Tab") {
		Show_Tray_Notification(ProgramValues.Name, "No buyer found for tab """ TradesGUI_Values.Active_Tab """`nOperation cancelled. Please report this issue.")
		Return
	}

	if btnAction contains Send_Message,Write_Message
	{
		if btnAction contains Write_Message
		{
			messages.Push(ProgramSettings["Button" varNum "_Message_1"])
			doNotSend := true
		}
		else {
			messages.Push(ProgramSettings["Button" varNum "_Message_1"], ProgramSettings["Button" varNum "_Message_2"], ProgramSettings["Button" varNum "_Message_3"])
			doNotSend := false
		}
		errorLvl := Send_InGame_Message(messages, tabInfos, {doNotSend:doNotSend})
		if (errorLvl)
			Return
	}

	if btnAction contains Close_Tab
	{
		if (RegExMatch(btnAction,"Send_Message"))  {
			if (ProgramSettings["Button" varNum "_Mark_Completed"]) {
				Gui_Trades_Statistics("ADD", tabInfos)
			}
			if (ProgramSettings.Support_Text_Toggle) {
				tabInfos := Gui_Trades_Get_Trades_Infos(TradesGUI_Values.Active_Tab) ; Retrieve the new PID in case it changed
				Send_InGame_Message({1:ProgramSettings.Support_Message}, tabInfos)
			}
		}
		Gui_Trades_Close_Tab()
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

			if (msg="ERROR") {
				Logs_Append(A_ThisFunc, {Var_Name:varName, Action:btnAction, Var_Alpha:varAlpha})
				Return
			}
			Send_InGame_Message({1:msg}, tabInfos, {doNotSend:doNotSend})
		}
	}

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
		SplashTextOn, 250, 40,% ProgramValues.Name,Please wait...`nCurrently re-creating the interface.
	allTrades := Gui_Trades_Manage_Trades("GET_ALL")
	if ( params.preview ) {
		if !(allTrades.Max_Index) {
			allTrades.1_Buyer := "iSellStuff"
			allTrades.1_Item		:= "level 1 Faster Attacks Support"
			allTrades.1_Price		:= "5 alteration"
			allTrades.1_Location	:= "Breach (stash tab ""Gems""; position: left 6, top 8)"
			allTrades.1_Other		:= "Offering 1 alch?"
			allTrades.1_Time		:= A_Hour ":" A_Min
			allTrades.1_PID			:= 0
			allTrades.1_Date		:= A_YYYY "-" A_MM "-" A_DD
			allTrades.1_Guild		:= ""
		}
	}
	Gui_Trades(msg)
	Gui_Trades("UPDATE", allTrades)
	SplashTextOff
}

Gui_Trades_Get_Tab_ID() {
/*		Only used when no skin is applied.
 *		Returns the currently active tab ID.
*/
	Global TradesGUI_Controls

	GuiControlGet, tabID, Trades:,% TradesGUI_Controls.Tab
	return tabID
}

Gui_Trades_Check_Duplicate(currentActiveTab) {
/*			Create a list containing all the duplicates tab ID
 *			Sort them in reverse, then include them in an array and returns it.
*/
	duplicates := currentActiveTab
	messagesArray := Gui_Trades_Manage_Trades("GET_ALL")
	maxIndex := messagesArray.MaxIndex
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
	duplicatesID := Object()
	Loop, Parse, duplicates, |
		duplicatesID.Push(A_LoopField)
	
	return duplicatesID
}


Gui_Trades_Get_Tab_Height() {
/*			Returns a number based on the lowest custom button to determine the GUI height
*/
	global ProgramSettings, TradesGUI_Values

	activeSkin := ProgramSettings.Active_Skin
	isSkinSystem := (activeSkin="System")?(true):(false)

	useSmallerButtons := TradesGUI_Values.Use_Smaller_Buttons
	sbHeightDiff := (useSmallerButtons)?(25):(0)

	tabHeightNoRow := (isSkinSystem)?(109):(109), tabHeightNoRow += sbHeightDiff
	tabHeightOneRow := (isSkinSystem)?(147):(149), tabHeightOneRow += sbHeightDiff
	tabHeightTwoRow := (isSkinSystem)?(185):(189), tabHeightTwoRow += sbHeightDiff
	tabHeightThreeRow := (isSkinSystem)?(223):(228), tabHeightThreeRow += sbHeightDiff
	tabHeight := tabHeightNoRow

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
	Gui_Trades_Redraw("CREATE", {noSplash:1})
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
				,TabID:tabID}

	return tabInfos
}

Gui_Trades_Statistics(mode, tabInfos="") {
	global ProgramValues

	historyFile := ProgramValues.Trades_History_File

	if (mode="ADD") {
		if (ProgramValues.Debug)
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

	if ( newPID ) {
		; Replace the PID for all trades matching the same PID
		allTrades := Gui_Trades_Manage_Trades("GET_ALL")
		Loop % allTrades.Max_Index {
			if ( allTrades[A_Index "_PID"] = oldPID ) {
				GuiControl,Trades:,% TradesGUI_Controls["PID_Slot_" key],% newPID
			}
		}
	}

	else if ( other ) {
		GuiControl,Trades:,% TradesGUI_Controls["Other_Slot_" tabID],% other
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

	if ( mode = "GET_ALL" || mode = "ADD_NEW") {
	;	___BUYERS___	
		Loop {
			bcount := A_Index
			GuiControlGet, content, Trades:,% TradesGUI_Controls["Buyer_Slot_" A_Index]
			if ( content ) {
				returnArray.Insert(A_Index "_Buyer", content)
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

		returnArray.Insert("Max_Index", bCount)
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
	static
	global TradesGUI_Values, ProgramSettings

	if ( ProgramSettings.Dock_Mode != "Overlay" )
		Return

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
		Gui, Trades:Show, % "x" xpos " y" ypos " NoActivate"
	}
	else {
		xpos := ( ( (A_ScreenWidth/dpiFactor) - TradesGUI_Values.Width ) * dpiFactor )
		Gui, Trades:Show, % "x" xpos " y0" " NoActivate"
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
	global ProgramSettings, ProgramValues, ProgramFonts, TradesGUI_Values
	global Hotkey1_KEYHandler, Hotkey2_KEYHandler, Hotkey3_KEYHandler, Hotkey4_KEYHandler, Hotkey5_KEYHandler, Hotkey6_KEYHandler

	programName := ProgramValues.Name, iniFilePath := ProgramValues.Ini_File, programSFXFolderPath := ProgramValues.SFX_Folder

	guiCreated := 0
	
	Gui, Settings:Destroy
	Gui, Settings:New, +AlwaysOnTop +SysMenu -MinimizeBox -MaximizeBox +OwnDialogs +LabelGui_Settings_ hwndSettingsHandler,% programName " - Settings"
	Gui, Settings:Default

	tabsList := "Settings|Customization|Customization Appearance|Customization Custom Buttons|Customization Smaller Buttons|Hotkeys|Hotkeys Basic|Hotkeys Advanced|Hotkeys Special"

	guiXWorkArea := 150, guiYWorkArea := 10
	Gui, Add, TreeView, x10 y10 h380 w130 -0x4 -Buttons gGui_Settings_TreeView
    P1 := TV_Add("Settings","", "Expand")
    P2 := TV_Add("Customization","","Expand")
    P2C1 := TV_Add("Appearance", P2, "Expand")
    P2C2 := TV_Add("Custom Buttons", P2, "Expand")
    P2C3 := TV_Add("Smaller Buttons", P2, "Expand")
    P3 := TV_Add("Hotkeys","","Expand")
    P3C1 := TV_Add("Basic", P3, "Expand")
    P3C2 := TV_Add("Advanced", P3, "Expand")
    P3C3 := TV_Add("Special", P3, "Expand")

	Gui, Add, Text,% "x" guiXWorkarea . " y" 360,% "Settings will be saved upon closing this window."
	Gui, Add, Link,% "x" guiXWorkarea . " y" 375 . " vWikiBtn gGui_Settings_Btn_WIKI",% "Keep the cursor above a control to know more about it. You may also <a href="""">Visit the Wiki</a>"

	Gui, Add, Tab2, x10 y10 w0 h0 vTab hwndTabHandler,% tabsList
;---------------------------
	Gui, Tab, Settings
;	Settings Tab
	Gui, Add, GroupBox,% "x" GuiXWorkArea " y" GuiYWorkArea-5 " w430 h55" . " c000000 Section Center",About this tab:
		Gui, Add, Text,xs+10 ys+20 BackgroundTrans,Main settings about how should the tool behave.
;		Trades GUI
		Gui, Add, GroupBox,% " x" guiXWorkArea . " ys+60" . " w430 h280" . " c000000",Main interface
		Gui, Add, Radio, xp+10 yp+20 vShowAlways hwndShowAlwaysHandler,Always show
		Gui, Add, Radio, xp yp+15 vShowInGame hwndShowInGameHandler,Only show while in game

		Gui, Add, Checkbox, xp yp+30 hwndClipTabHandler vClipTab,Clipboard item on tab switch
		Gui, Add, Checkbox,% " xp" . " yp+15 hwndSelectLastTabHandler vSelectLastTab",Focus newly created tabs

		Gui, Add, Checkbox, xp yp+30 hwndAutoMinimizeHandler vAutoMinimize,Minimize when inactive
		Gui, Add, Checkbox, xp yp+15 hwndAutoUnMinimizeHandler vAutoUnMinimize,Un-Minimize when active
;			Transparency
			Gui, Add, GroupBox,% " x" guiXWorkArea+215 . " y" guiYWorkArea+185 " w205 h140" . " c000000",Transparency
			Gui, Add, Checkbox, xp+30 yp+25 hwndClickThroughHandler vClickThrough,Click-through while inactive
			Gui, Add, Text, xp yp+20,Inactive (no trade on queue)
			Gui, Add, Slider, xp+10 yp+15 hwndShowTransparencyHandler gGui_Settings_Transparency vShowTransparency AltSubmit ToolTip Range0-100
			Gui, Add, Text, xp-10 yp+30,Active (trades are on queue)
			Gui, Add, Slider, xp+10 yp+15 hwndShowTransparencyActiveHandler gGui_Settings_Transparency vShowTransparencyActive AltSubmit ToolTip Range30-100

; ;		Notifications
;			 Trade Sound Group
			Gui, Add, GroupBox,% "x" guiXWorkarea+215 . " y" guiYWorkArea+70 . " w205 h110" . " c000000",Notifications
			Gui, Add, Checkbox, xp+10 yp+20 vNotifyTradeToggle hwndNotifyTradeToggleHandler,Trade
			Gui, Add, Edit, xp+65 yp-2 w70 h17 vNotifyTradeSound hwndNotifyTradeSoundHandler ReadOnly
			Gui, Add, Button, xp+75 yp-2 h20 vNotifyTradeBrowse gGui_Settings_Notifications_Browse,Browse
;			Whisper Sound Group
			Gui, Add, Checkbox,% "xp-140 yp+25" . " vNotifyWhisperToggle hwndNotifyWhisperToggleHandler",Whisper
			Gui, Add, Edit, xp+65 yp-2 w70 h17 vNotifyWhisperSound hwndNotifyWhisperSoundHandler ReadOnly
			Gui, Add, Button, xp+75 yp-2 h20 vNotifyWhisperBrowse gGui_Settings_Notifications_Browse,Browse
;			Whisper Tray Notification
			Gui, Add, Checkbox,% "xp-140"   " yp+29 vNotifyWhisperTray hwndNotifyWhisperTrayHandler",Show tray notifications
			Gui, Add, Checkbox,% "xp"  " yp+14 vNotifyWhisperFlash hwndNotifyWhisperFlashHandler",Flash the taskbar icon
; ;		Support
		Gui, Add, GroupBox,% "x" guiXWorkArea+10 " y" guiYWorkArea+240 . " w200 h85" . " c000000",Support
		Gui, Add, Checkbox, xp+90 yp+20 vMessageSupportToggle hwndMessageSupportToggleHandler
		Gui, Add, Text, gGUI_Settings_Tick_Case vMessageSupportToggleText xp-55 yp+18,% "Send an additional message`n   containing the thread-id`n     upon closing a trade"

;	-----------------------
	Gui, Tab, Customization

	Gui, Add, GroupBox,% "x" GuiXWorkArea " y" GuiYWorkArea-5 " w430 h55" . " c000000 Section Center",Appearance:
		Gui, Add, Text,xs+10 ys+20 BackgroundTrans,Choose a skin preset or customize it to your liking.

	Gui, Add, GroupBox, x%GuiXWorkArea% yp+40 w430 h55 c000000 Section Center,Custom Buttons:
		Gui, Add, Text,xp+10 yp+20 BackgroundTrans,Rename and define button's actions or positions.

	Gui, Add, GroupBox, x%GuiXWorkArea% yp+40 w430 h55 c000000 Section Center,Smaller Buttons:
		Gui, Add, Text,xp+10 yp+20 BackgroundTrans,Choose to bind the buttons to an hotkey.
;	--------------------
	Gui, Tab, Customization Appearance
	Gui, Add, GroupBox,% "x" guiXWorkarea . " y" guiYWorkArea-5 . " w430 h55" . " c000000",Preset
		presetsList := "User Defined"
		Loop, Files,% ProgramValues.Skins_Folder "\*", D
		{
			presetsList .= "|" A_LoopFileName
		}
		Sort, presetsList,D|
		Gui, Add, DropDownList,% "x" guiXWorkarea+10 . " y" guiYWorkArea+15 . " w400" . " vActivePreset hwndActivePresetHandler gGui_Settings_Presets",% presetsList

	Gui, Add, GroupBox,% "x" guiXWorkArea . " y" guiYWorkArea+55 . " w430 h85" . " c000000",Skin

		skinsList := ""
		Loop, Files,% ProgramValues.Skins_Folder "\*", D
		{
			IniRead, skinName,% A_LoopFileFullPath "\Settings.ini",CUSTOMIZATION_APPEARANCE,Active_Skin
			if ( skinName && skinName != "ERROR" )
				skinsList .= skinName "|"
		}
		Sort, skinsList,D|
		Sleep 1
		Gui, Add, ListBox,% "xp+10" . " yp+20" . " w190" . " vSelectedSkin hwndSelectedSkinHandler R4" . " gGui_Settings_Set_Custom_Preset",% skinsList

		scalingList := "50%|75%|100%|125%|150%|175%|200%"
		Gui, Add, Text,% "xp+200" . " yp+3",Scale: 
		Gui, Add, DropDownList,% "xp+40" . " yp-3" . " w145" . " vSkinScaling hwndSkinScalingHandler" . " gGui_Settings_Set_Custom_Preset",% scalingList

	Gui, Add, GroupBox,% "x" guiXWorkArea . " y" guiYWorkArea+145 . " w430 h85" . " c000000",Font

		fontsList := "System"
		for fontFile, fontTitle in ProgramFonts {
			if fontTitle not in TC-Symbols
				fontsList .= "|" fontTitle
		}
		Sort, fontsList,D|
		Sleep 1
		Gui, Add, ListBox,% "xp+10" . " yp+20" . " w190" . " vSelectedFont hwndSelectedFontHandler R4" . " gGui_Settings_Set_Custom_Preset",% fontsList
		Gui, Add, Text,% "xp+200" . " yp+3",Size:
		Gui, Add, DropDownList,% "xp+40" . " yp-3" . " w100" . " vFontSize hwndFontSizeHandler" . " gGui_Settings_Set_Custom_Preset",% "Automatic|Custom"
		Gui, Add, Edit,% "xp+100" . " yp" . " w50" . " ReadOnly"
		Gui, Add, UpDown, vFontSizeCustom hwndFontSizeCustomHandler gGui_Settings_Set_Custom_Preset

		Gui, Add, Text,% "xp-140" . " yp+33",Quality:
		Gui, Add, DropDownList,% "xp+40" . " yp-3" . " w100" . " vFontQuality hwndFontQualityHandler" . " gGui_Settings_Set_Custom_Preset",% "Automatic|Custom"
		Gui, Add, Edit,% "xp+100" . " yp" . " w50" . " ReadOnly"
		Gui, Add, UpDown, vFontQualityCustom hwndFontQualityCustomHandler gGui_Settings_Set_Custom_Preset

	Gui, Add, GroupBox,% "x" guiXWorkArea . " y" guiYWorkArea+235 . " w430 h75" . " c000000",Font Colors

		Gui, Add, Text,% "xp+10" . " yp+23",Title (Active):
		Gui, Add, Edit,% "xp+75" . " yp-3" . " w60" . " vTitleActiveColor" . " hwndTitleActiveColorHandler" . " Limit6",% ""
		Gui, Add, Text,% "xp-75" . " yp+28",Title (Inactive):
		Gui, Add, Edit,% "xp+75" . " yp-3" . " w60" . " vTitleInactiveColor" . " hwndTitleInactiveColorHandler" . " Limit6",% ""

		Gui, Add, Text,% "xp+65" . " yp-22",Trade Infos (1):
		Gui, Add, Edit,% "xp+75" . " yp-3" . " w60" . " vTradesInfos1Color" . " hwndTradesInfos1ColorHandler" . " Limit6",% ""
		Gui, Add, Text,% "xp-75" . " yp+28",Trade Infos (2):
		Gui, Add, Edit,% "xp+75" . " yp-3" . " w60" . " vTradesInfos2Color" . " hwndTradesInfos2ColorHandler" . " Limit6",% ""

		Gui, Add, Text,% "xp+65" . " yp-22",Tabs:
		Gui, Add, Edit,% "xp+75" . " yp-3" . " w60" . " vTabsColor" . " hwndTabsColorHandler" . " Limit6",% ""
		Gui, Add, Text,% "xp-75" . " yp+28",Buttons:
		Gui, Add, Edit,% "xp+75" . " yp-3" . " w60" . " vButtonsColor" . " hwndButtonsColorHandler" . " Limit6",% ""

		Gui, Add, Link,% "x" guiXWorkArea + 80 . " y" guiYWorkArea+235,% "(Use <a href=""http://hslpicker.com/"">HSL Color Picker</a> to retrieve the 6 characters code starting with #) "

;	-------------------------
	Gui, Tab, Customization Custom Buttons
	DynamicGUIHandlersArray := Object()

		Gui, Add, GroupBox,% "x" guiXWorkarea . " y" guiYWorkArea-5 . " w430 h110" . " c000000",Buttons
	Loop 9 {
		index := A_Index
		xpos := (index=1||index=4||index=7)?(guiXWorkArea+32):(index=2||index=5||index=8)?(guiXWorkArea+152):(index=3||index=6||index=9)?(guiXWorkArea+272):("ERROR")
		ypos := (index=1||index=2||index=3)?(guiYWorkArea+20):(index=4||index=5||index=6)?(guiYWorkArea+45):(index=7||index=8||index=9)?(guiYWorkArea+70):("ERROR")
		Gui, Add, Button, x%xpos% y%ypos% w120 h25 vTradesBtn%index% hwndTradesBtn%index%Handler gGui_Settings_Custom_Label,% "Custom " index

		Gui, Add, GroupBox,% "x" guiXWorkArea . " y" guiYWorkArea+110 . " w430 h85" . " c000000",Positioning
			Gui, Add, Text,% "xp+10" . " yp+20" . " hwndTradesHPOS" index "TextHandler",Horizontal:
			Gui, Add, ListBox, w70 xp+55 yp vTradesHPOS%index% hwndTradesHPOS%index%Handler gGui_Settings_Trades_Preview R3,% "Left|Center|Right"
			Gui, Add, Text, xp+75 yp hwndTradesVPOS%index%TextHandler,Vertical:
			Gui, Add, ListBox, w70 xp+45 yp vTradesVPOS%index% hwndTradesVPOS%index%Handler gGui_Settings_Trades_Preview R3,% "Top|Middle|Bottom"
			Gui, Add, Text, xp+75 yp hwndTradesSIZE%index%TextHandler,Size:
			Gui, Add, ListBox, w70 xp+30 yp vTradesSIZE%index% hwndTradesSIZE%index%Handler gGui_Settings_Trades_Preview R4,% "Disabled|Small|Medium|Large"

		Gui, Add, GroupBox,% "x" guiXWorkarea . " y" guiYWorkArea+200 . " w430 h110" . " c000000",Behaviour
			Gui, Add, Text,% "xp+10" . " yp+20" . " hwndTradesLabel" index "TextHandler",Label:
			Gui, Add, Edit, xp+50 yp-3 w160 vTradesLabel%index% hwndTradesLabel%index%Handler gGui_Settings_Custom_Label,
			Gui, Add, Text, xp+170 yp+3 vTradesHK%index%Text hwndTradesHK%index%TextHandler,Hotkey:
			Gui, Add, Hotkey, xp+50 yp-3 vTradesHK%index% hwndTradesHK%index%Handler,

			Gui, Add, Text,% "xp-270" . " yp+33" . " hwndTradesAction" index "TextHandler",Action:
			Gui, Add, DropDownList, xp+50 yp-3 w160 vTradesAction%index% hwndTradesAction%index%Handler gGui_Settings_Custom_Label,% "Clipboard Item|Send Message|Send Message + Close Tab|Write Message"
			Gui, Add, CheckBox,xp+170 yp vTradesMarkCompleted%index% hwndTradesMarkCompleted%index%Handler Center,Save the trade infos locally?`n(for personnal statistics purposes)

			Gui, Add, Edit,% "x" guiXWorkarea+10 . " yp+30 w50" . " hwndTradesMsgEditID" index "Handler" . " ReadOnly Limit1",1|2|3
			Gui, Add, UpDown,% " vTradesMsgID" index " hwndTradesMsgID" index "Handler" . " Range1-3 gGui_Settings_Cycle_Messages"
			Gui, Add, Edit, xp+50 yp w355 vTradesMsg1_%index% hwndTradesMsg1_%index%Handler,
			Gui, Add, Edit, xp yp w355 vTradesMsg2_%index% hwndTradesMsg2_%index%Handler,
			Gui, Add, Edit, xp yp w355 vTradesMsg3_%index% hwndTradesMsg3_%index%Handler,

		GuiControl,Settings:Hide,% TradesHPOS%index%Handler
		GuiControl,Settings:Hide,% TradesHPOS%index%TextHandler
		GuiControl,Settings:Hide,% TradesVPOS%index%Handler
		GuiControl,Settings:Hide,% TradesVPOS%index%TextHandler
		GuiControl,Settings:Hide,% TradesSIZE%index%Handler
		GuiControl,Settings:Hide,% TradesSIZE%index%TextHandler
		GuiControl,Settings:Hide,% TradesLabel%index%Handler
		GuiControl,Settings:Hide,% TradesLabel%index%TextHandler
		GuiControl,Settings:Hide,% TradesHK%index%Handler
		GuiControl,Settings:Hide,% TradesHK%index%TextHandler		
		GuiControl,Settings:Hide,% TradesAction%index%Handler
		GuiControl,Settings:Hide,% TradesAction%index%TextHandler
		GuiControl,Settings:Hide,% TradesMarkCompleted%index%Handler
		GuiControl,Settings:Hide,% TradesMsgEditID%index%Handler
		GuiControl,Settings:Hide,% TradesMsgID%index%Handler
		GuiControl,Settings:Hide,% TradesMsg1_%index%Handler
		GuiControl,Settings:Hide,% TradesMsg2_%index%Handler
		GuiControl,Settings:Hide,% TradesMsg3_%index%Handler

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
	Gui, Tab, Customization Smaller Buttons

	Gui, Add, GroupBox,% "x" GuiXWorkArea " y" GuiYWorkArea-5 " w430 h55" . " c000000 Section Center",About this tab:
		Gui, Add, Text,xs+10 ys+15 BackgroundTrans,Allows to bind hotkeys to these buttons.
		Gui, Add, Text,xp yp+15 BackgroundTrans,Disabling all Custom Buttons will effectively show only this row.

	hexCodes := ["41", "42", "45", "43", "44"] ; 41:Clip/42:Whis/43:Trade/44:Kick/45:Inv
	ctrlActions := ["Clipboard" , "Whisper", "Invite", "Trade", "Kick"]
	for key, element in hexCodes {
		xpos := (Mod(A_Index,2)!=0)?(guiXWorkarea)
			   :(370)
		ypos := (A_Index=1)?(GuiYWorkArea+55)
			   :(Mod(A_Index,2)!=0 && A_Index!=1)?(ypos+80)
			   :(ypos)
		width := 210, height := 80

		Gui, Font,% "S" 20,% "TC-Symbols"
		Gui, Add, GroupBox,% "x" xpos " y" ypos " w" width " h" height . " c000000 hwndUnicodeBtn" A_Index "Handler",% ""
			handler := "UnicodeBtn" A_Index "Handler"
			ConvertesChars := Hex2Bin(nString, element) ; Convert hex code into its corresponding unicode character
		   	SetUnicodeText(nString, %handler%) ; Replace the control's content with the unicode character
		   	Gui, Font
		   	Gui, Add, Text,% "xp+50 yp+7",% "(" ctrlActions[key] ")"
		   	Gui, Add, Text,% "x" xpos+10 " yp+22",Position: 
		   	Gui, Add, DropDownList,% "xp+60" " yp-2" " w" width-80 " R6" " vUnicodeBtn" A_Index "Position" " hwndUnicodeBtn" A_Index "PositionHandler" " gGui_Settings_Trades_Preview",% "Disabled|1|2|3|4|5"
		   	Gui, Add, CheckBox,% "x" xpos+10 " yp+27" . " vUnicodeBtn" A_Index "HotkeyToggle" " hwndUnicodeBtn" A_Index "HotkeyToggleHandler", Hotkey:
		   	Gui, Add, Hotkey,% "xp+60" " yp-3" " w" width-80 . " vUnicodeBtn" A_Index "Hotkey" " hwndUnicodeBtn" A_Index "HotkeyHandler"
		   	index := A_Index
	}
	key := "", element := "", hexCodes := "", xpos := "", ypos := "", handler := "", ConvertesChars := "", nString := ""

;------------------------------
;	Hotkeys Tab
	Gui, Tab, Hotkeys

	Gui, Add, GroupBox,% "x" GuiXWorkArea " y" GuiYWorkArea-5 " w430 h55" . " c000000 Section Center",Basic:
		Gui, Add, Text,xs+10 ys+15 BackgroundTrans,Allows to bind an hotkey to send a single message or command.
		Gui, Add, Text,xp yp+15 BackgroundTrans,Some keys such as Space or Escape can only be bound in Advanced.

	Gui, Add, GroupBox, x%GuiXWorkArea% yp+30 w430 h55 c000000 Section Center,Advanced:
		Gui, Add, Text,xs+10 ys+15 BackgroundTrans,Allows to bind an hotkey to send multiple messages.
		Gui, Add, Text,xp yp+15 BackgroundTrans,Please refer to the Wiki to find out how to correctly set them up.

	Gui, Add, GroupBox, x%GuiXWorkArea% yp+30 w430 h55 c000000 Section Center,Special:
		Gui, Add, Text,xs+10 ys+15 BackgroundTrans,Allows to bind an hotkey to special actions.

;------------------------------
	Gui, Tab, Hotkeys Basic

	Gui, Add, GroupBox,% "x" GuiXWorkArea " y" GuiYWorkArea-5 " w430 h55" . " c000000 Section Center",About this tab:
		Gui, Add, Text,xs+10 ys+15 BackgroundTrans,Allows to bind an hotkey to send a single message or command.
		Gui, Add, Text,xp yp+15 BackgroundTrans,Some keys such as Space or Escape can only be bound in Advanced.

	xpos := guiXWorkArea, ypos := guiYWorkArea+55
	Loop 8 {
		btnID := A_Index
		if (btnID > 1 && btnID <= 4) || (btnID > 5)
			ypos += 70
		else if (btnID = 5)
			xpos := guiXWorkArea+220, ypos := guiYWorkArea+55
		Gui, Add, GroupBox, x%xpos% y%ypos% w210 h70 hwndHotkey%btnID%_GroupBox c000000
		Gui, Add, Checkbox, xp+10 yp+31 vHotkey%btnID%_Toggle hwndHotkey%btnID%_ToggleHandler
		Gui, Add, Edit, xp+30 yp-17 w150 vHotkey%btnID%_Text hwndHotkey%btnID%_TextHandler,
		Gui, Add, Hotkey, xp yp+25 w150 vHotkey%btnID%_KEY hwndHotkey%btnID%_KEYHandler,
	}
;-----------------------------------
	Gui, Tab, Hotkeys Advanced

	Gui, Add, GroupBox,% "x" GuiXWorkArea " y" GuiYWorkArea-5 " w430 h55" . " c000000 Section Center",About this tab:
		Gui, Add, Text,xs+10 ys+15 BackgroundTrans,Allows to bind an hotkey to send multiple messages.
		Gui, Add, Text,xp yp+15 BackgroundTrans,Please refer to the Wiki to find out how to correctly set them up.

	xpos := guiXWorkArea, ypos := guiYWorkArea+55
	Loop 16 {
		btnID := A_Index
		if ( btnID > 1 && btnID <= 8 ) || ( btnID > 9 )
			ypos += 35
		else if ( btnID = 9 )
			xpos := guiXWorkArea+220, ypos := guiYWorkArea+55
		Gui, Add, GroupBox, x%xpos% y%ypos% w210 h35 c000000
		Gui, Add, Checkbox, xp+7 yp+13 w15 h15 vHotkeyAdvanced%btnID%_Toggle hwndHotkeyAdvanced%btnID%_ToggleHandler
		Gui, Add, Edit, xp+30 yp-3 w60 vHotkeyAdvanced%btnID%_KEY hwndHotkeyAdvanced%btnID%_KEYHandler
		Gui, Add, Edit, xp+65 yp w100 gGui_Settings_Hotkeys_Tooltip vHotkeyAdvanced%btnID%_Text hwndHotkeyAdvanced%btnID%_TextHandler
	}
;-----------------------------------
	Gui, Tab, Hotkeys Special

	Gui, Add, GroupBox, x%GuiXWorkArea% y%GuiYWorkArea% w430 h55 c000000 Section Center,About this tab:
		Gui, Add, Text,xs+10 ys+15 BackgroundTrans,Allows to bind an hotkey to special actions.

	ctrlNames := ["Choose Next Tab" , "Choose Previous Tab", "Close Current Tab", "Toggle Minimize State"]
	ctrlVars := ["ChooseNextTab", "ChoosePrevTab", "CloseCurrentTab", "ToggleMinimize"]
	for key, element in ctrlNames {
		xpos := (Mod(A_Index,2)!=0)?(guiXWorkarea)
			   :(370)
		ypos := (A_Index=1)?(GuiYWorkArea+55)
			   :(Mod(A_Index,2)!=0 && A_Index!=1)?(ypos+60)
			   :(ypos)
		width := 210, height := 60

		Gui, Add, GroupBox,% "x" xpos " y" ypos " w" width " h" height . " c000000",% ctrlNames[A_Index]
		   	Gui, Add, CheckBox,% "x" xpos+10 " yp+25 w15 h15" . " v" ctrlVars[A_Index] "HotkeyToggle" " hwnd" ctrlVars[A_Index] "HotkeyToggleHandler"
		   	Gui, Add, Text,% "x" xpos+27 " yp+1",Hotkey:
		   	Gui, Add, Hotkey,% "xp+45" " yp-3" " w" width-80 . " v" ctrlVars[A_Index] "Hotkey" " hwnd" ctrlVars[A_Index] "HotkeyHandler"
	}



;-----------------------------------

	GoSub, Gui_Settings_Set_Preferences
	Gui, Trades: -E0x20
	Gui, Show
	GuiControl, Settings:Choose,% TabHandler,1
	guiCreated := 1
return

	Gui_Settings_Cycle_Messages:
		Gui, Settings:Submit, NoHide

		btnID := RegExReplace(A_GuiControl, "\D")
		ctrlHandler := DynamicGUIHandlersArray["MsgID" btnId]
		GuiControlGet, currentMsgID,,% ctrlHandler

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
		Gui, Settings:Submit, NoHide
		if ( A_GuiControl != "ActivePreset" ) {
			GuiControl, Settings:Choose,% ActivePresetHandler,User Defined
		}

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

;		Enable or disable the control.
		state := (FontSize="Custom")?("Enable"):("Disable")
		GuiControl, Settings:%state%,% FontSizeCustomHandler
		state := (FontQuality="Custom")?("Enable"):("Disable")
		GuiControl, Settings:%state%,% FontQualityCustomHandler
		state := (SelectedSkin="System")?("Disable"):("Enable")
		GuiControl, Settings:%state%,% ButtonsColorHandler
		GuiControl, Settings:%state%,% TabsColorHandler

		if ( A_GuiControl!="ActivePreset")
			GoSub Gui_Settings_Trades_Preview
	Return

	Gui_Settings_Presets:
		Gui, Settings:Submit, NoHide
		ActivePresetSettings := Gui_Settings_Get_Settings_Arrays()
		INI_Keys := ActivePresetSettings.CUSTOMIZATION_APPEARANCE_KeysArray
		ControlsHandlers := ActivePresetSettings.CUSTOMIZATION_APPEARANCE_HandlersArray

		for key, element in INI_Keys {
			skinSettingsFile := (ActivePreset="User Defined")?(ProgramValues[("Ini_File")]):(ProgramValues.Skins_Folder "\" ActivePreset "\Settings.ini")
			
			IniRead, value,% skinSettingsFile,% "CUSTOMIZATION_APPEARANCE",% element
			ctrlName := ControlsHandlers[key]
			ctrlHandler := (ctrlName="ActivePreset")?(ActivePresetHandlerHandler)
						  :(ctrlName="SelectedSkin")?(SelectedSkinHandler)
						  :(ctrlName="SkinScaling")?(SkinScalingHandler)
						  :(ctrlName="SelectedFont")?(SelectedFontHandler)
						  :(ctrlName="FontSize")?(FontSizeHandler)
						  :(ctrlName="FontSizeCustom")?(FontSizeCustomHandler)
						  :(ctrlName="FontQuality")?(FontQualityHandler)
						  :(ctrlName="FontQualityCustom")?(FontQualityCustomHandler)
						  :(ctrlName="TitleActiveColor")?(TitleActiveColorHandler)
						  :(ctrlName="TitleInactiveColor")?(TitleInactiveColorHandler)
						  :(ctrlName="TradesInfos1Color")?(TradesInfos1ColorHandler)
						  :(ctrlName="TradesInfos2Color")?(TradesInfos2ColorHandler)
						  :(ctrlName="TabsColor")?(TabsColorHandler)
						  :(ctrlName="ButtonsColor")?(ButtonsColorHandler)
						  :("ERROR")

			GuiControl, Settings:-g,% ctrlHandler ; Prevent from triggeting the gLabel
			if element in Font_Size_Custom,Font_Quality_Custom,Font_Color_Title_Active,Font_Color_Title_Inactive,Font_Color_Trades_Infos_1,Font_Color_Trades_Infos_2,Font_Color_Tabs,Font_Color_Buttons
			{
				GuiControl, Settings:,% ctrlHandler,% value
			}
			else if ( element = "Scale_Multiplier" ) {
				value := value*100
				value := Round(value, 0)
				GuiControl, Settings:Choose,% ctrlHandler,% value "%"
			}
			else
				GuiControl, Settings:Choose,% ctrlHandler,% value

			GuiControl, Settings:+gGui_Settings_Set_Custom_Preset,% ctrlHandler ; Re-enable gLabel
		}
		GoSub, Gui_Settings_Set_Custom_Preset
		GoSub, Gui_Settings_Trades_Preview
	Return

	Gui_Settings_TreeView:
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
	Return

	Gui_Settings_Trades_Preview:
		Gui, Settings:+Disabled

		GoSub, Gui_Settings_Btn_Apply

		Backup_isMin := TradesGUI_Values.Is_Minimized, Backup_autoMin := ProgramSettings.Trades_Auto_Minimize
		TradesGUI_Values.Is_Minimized := 0, ProgramSettings.Trades_Auto_Minimize := 0

		Gui_Trades_Redraw("CREATE", {preview:1})

		TradesGUI_Values.Is_Minimized := Backup_isMin, ProgramSettings.Trades_Auto_Minimize := Backup_autoMin
		Backup_isMin := "", Backup_autoMin := ""

		Gui, Settings:-Disabled
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
			if ( A_GuiControl = "NotifyWhisperBrowse" ) {
				GuiControl, Settings:,% NotifyWhisperSoundHandler,% soundFileName
				whispersSoundFile := soundFile
			}
		}
	return
	
	Gui_Settings_Btn_Apply:
		Gui, +OwnDialogs
		Gui, Submit, NoHide
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
		IniWrite,% TitleActiveColor,% iniFilePath,CUSTOMIZATION_APPEARANCE,Font_Color_Title_Active
		IniWrite,% TitleInactiveColor,% iniFilePath,CUSTOMIZATION_APPEARANCE,Font_Color_Title_Inactive
		IniWrite,% TradesInfos1Color,% iniFilePath,CUSTOMIZATION_APPEARANCE,Font_Color_Trades_Infos_1
		IniWrite,% TradesInfos2Color,% iniFilePath,CUSTOMIZATION_APPEARANCE,Font_Color_Trades_Infos_2
		IniWrite,% TabsColor,% iniFilePath,CUSTOMIZATION_APPEARANCE,Font_Color_Tabs
		IniWrite,% ButtonsColor,% iniFilePath,CUSTOMIZATION_APPEARANCE,Font_Color_Buttons
;	Declare the new settings
		Disable_Hotkeys()
		settingsArray := Get_Local_Settings()
		Declare_Local_Settings(settingsArray)
		settings := Get_Game_Settings()
		Declare_Game_Settings(settings)
		Enable_Hotkeys()
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
				else if ( keyName = "Dock_Mode" ) { ; Make sure only one goes through
					GuiControl, Settings:, % Dock%var%Handler,1
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
					if keyName in Active_Skin,Font,Font_Size_Mode,Font_Size_Custom,Font_Quality_Mode,Font_Quality_Custom,Active_Preset,Font_Color_Title_Active,Font_Color_Title_Inactive,Font_Color_Trades_Infos_1,Font_Color_Trades_Infos_2,Font_Color_Tabs,Font_Color_Buttons
					{
						if keyName in Font_Size_Custom,Font_Quality_Custom,Font_Color_Title_Active,Font_Color_Title_Inactive,Font_Color_Trades_Infos_1,Font_Color_Trades_Infos_2,Font_Color_Tabs,Font_Color_Buttons
						{
							GuiControl, Settings:-g,% %handler%Handler ; Prevent from triggeting the gLabel
							GuiControl, Settings:,% %handler%Handler,% var
							GuiControl, Settings:+gGui_Settings_Set_Custom_Preset,% %handler%Handler ; Re-enable gLabel
						}
						else {
							if ( keyName = "Active_Skin" ) {
								state := (var="System")?("Disable"):("Enable")
								GuiControl, Settings:%state%,% ButtonsColorHandler
								GuiControl, Settings:%state%,% TabsColorHandler
							}
							GuiControl, Settings:ChooseString,% %handler%Handler,% var
							if ( keyName = "Font_Size_Mode" ) {
								state := (var="Custom")?("Enable"):("Disable")
								GuiControl, Settings:%state%,% FontSizeCustomHandler
							}
							if (keyName = "Font_Quality_Mode") {
								state := (var="Custom")?("Enable"):("Disable")
								GuiControl, Settings:%state%,% FontQualityCustomHandler
							}
						}
					}
					else if (keyName = "Scale_Multiplier")
					{
						var := var*100
						var := Round(var, 0)
						GuiControl, Settings:ChooseString,% %handler%Handler,% var "%"
					}
				}
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
		}
return

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
	returnArray.NOTIFICATIONS_HandlersArray.Insert(0, "NotifyTradeToggle", "NotifyTradeSound", "NotifyWhisperToggle", "NotifyWhisperSound", "NotifyWhisperTray", "NotifyWhisperFlash")
	returnArray.NOTIFICATIONS_HandlersKeysArray := Object()
	returnArray.NOTIFICATIONS_HandlersKeysArray.Insert(0, "Trade_Toggle", "Trade_Sound", "Whisper_Toggle", "Whisper_Sound", "Whisper_Tray", "Whisper_Flash")
	returnArray.NOTIFICATIONS_KeysArray := Object()
	returnArray.NOTIFICATIONS_KeysArray.Insert(0, "Trade_Toggle", "Trade_Sound", "Trade_Sound_Path", "Whisper_Toggle", "Whisper_Sound", "Whisper_Sound_Path", "Whisper_Tray", "Whisper_Flash")
	returnArray.NOTIFICATIONS_DefaultValues := Object()
	returnArray.NOTIFICATIONS_DefaultValues.Insert(0, "1", "WW_MainMenu_Letter.wav", programSFXFolderPath "\WW_MainMenu_Letter.wav", "0", "None", "", "1", "0")

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
				  :(index=2)?("Send Message")
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
	returnArray.CUSTOMIZATION_APPEARANCE_HandlersArray.Insert(0, "ActivePreset", "SelectedSkin", "SkinScaling", "SelectedFont", "FontSize", "FontSizeCustom", "FontQuality", "FontQualityCustom", "TitleActiveColor", "TitleInactiveColor", "TradesInfos1Color", "TradesInfos2Color", "TabsColor", "ButtonsColor")
	returnArray.CUSTOMIZATION_APPEARANCE_HandlersKeysArray.Insert(0, "Active_Preset", "Active_Skin", "Scale_Multiplier", "Font", "Font_Size_Mode", "Font_Size_Custom", "Font_Quality_Mode", "Font_Quality_Custom", "Font_Color_Title_Active", "Font_Color_Title_Inactive", "Font_Color_Trades_Infos_1", "Font_Color_Trades_Infos_2", "Font_Color_Tabs", "Font_Color_Buttons")
	returnArray.CUSTOMIZATION_APPEARANCE_KeysArray.Insert(0, "Active_Preset", "Active_Skin", "Scale_Multiplier", "Font", "Font_Size_Mode", "Font_Size_Custom", "Font_Quality_Mode", "Font_Quality_Custom", "Font_Color_Title_Active", "Font_Color_Title_Inactive", "Font_Color_Trades_Infos_1", "Font_Color_Trades_Infos_2", "Font_Color_Tabs", "Font_Color_Buttons")
	returnArray.CUSTOMIZATION_APPEARANCE_DefaultValues.Insert(0, "System", "System", "1", "System", "Automatic", "8", "Automatic", "5", "FFFF00", "FFFFFF", "SYSTEM", "SYSTEM" , "SYSTEM", "SYSTEM")

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

	ShowInGame_TT := ShowAlways_TT := "Decide when should the GUI show."
	. "`nAlways show:" A_Tab . A_Tab "The interface will always appear."
	. "`nOnly show while in game:" A_Tab "The interface will only appear when the game's window is active."

	ClickThrough_TT := "Clicks will go through the interface while it is inactive,"
	. "`nallowing you to click any window behind it."
	ShowTransparency_TT := "Transparency of the interface when no trades are on queue."
	. "`nSetting the value to 0% will effectively make it invisible."
	. "`nWhile moving the slider, you can see a preview of the result."
	. "`nUpon releasing the slider, it will revert back to its default transparency based on the current active/inactive state."
	ShowTransparencyActive_TT := "Transparency of the GUI when trades are on queue."
	. "`nThe minimal value is set to 30% to make sure you can still see the window."
	. "`nWhile moving the slider, you can see a preview of the result."
	. "`nUpon releasing the slider, it will revert back to its default transparency based on the current active/inactive state."

	SelectLastTab_TT := "Always focus the new tab upon receiving a new trade whisper."

	AutoMinimize_TT := "Automatically minimize the Trades GUI when no trades are on queue."
	AutoUnMinimize_TT := "Automatically un-minimize the Trades GUI upon receiving a trade whisper."
	
	NotifyTradeBrowse_TT := NotifyTradeSound_TT := NotifyTradeToggle_TT := "Play a sound when you receive a trade whisper."
	. "`nTick the case to enable."
	. "`nClick on [Browse] to select a sound file."
	
	NotifyWhisperBrowse_TT := NotifyWhisperSound_TT := NotifyWhisperToggle_TT := "Play a sound when you receive a regular whisper"
	. "`nTick the case to enable."
	. "`nClick on [Browse] to select a sound file."
	
	NotifyWhisperTray_TT := "Show a tray notification when you receive"
	. "`na whisper while the game window is not active."

	NotifyWhisperFlash_TT := "Make the game's window flash when you receive"
	. "`na whisper while the game window is not active."
	
	ClipTab_TT := "Automatically put the tab's item in clipboard"
	. "`nso you can easily CTRL+F CTRL+V in your stash to search for the item."

	MessageSupportToggle_TT := ":)`n`nOnly triggers for ""Send Message + Close Tab"" buttons.", MessageSupportToggleText_TT := "(:`n`nOnly triggers for ""Send Message + Close Tab"" buttons."

	Hotkey_Toggle_TT := "Tick the case to enable this hotkey."
	Hotkey_Text_TT := "Message that will be sent upon pressing this hotkey."
	Hotkey_KEY_TT := "Hotkey to trigger this custom command/message."
	Hotkey_CTRL_TT := "Enable CTRL as a modifier for this hotkey."
	Hotkey_ALT_TT := "Enable ALT as a modifier for this hotkey."
	Hotkey_SHIFT_TT := "Enable SHIFT as a modifier for this hotkey."

	HotkeyAdvanced_TT := Hotkey_Toggle_TT
	HotkeyAdvanced_KEY_TT := Hotkey_KEY_TT
	HotkeyAdvanced_Text_TT := Hotkey_Text_TT

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
	. "`nWrite Message:" A_Tab . A_Tab "Write a single message in chat, without sending it."

	TradesMarkCompleted_TT := "Store the trade's infos in a local file."
	. "`nCan only be used with Send Message + Close Tab."

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

	defaultGUI := A_DefaultGui
	Gui, Stats:Destroy
	Gui, Stats:New, +HwndGuiStatsHandler +SysMenu -MinimizeBox -MaximizeBox +Resize +OwnDialogs +MinSize670x360 +LabelGui_Stats_,% ProgramValues.Name " - My Stats"
	Gui, Stats:Default
	Gui, Margin, 0, 0
	Gui, Font,,Segoe UI
	Gui, Add, GroupBox,% "x10 y10 w" guiWidth-20 " h100 hwndFilteringGroupBoxHandler c000000 Section", Filtering Options
	Gui, Add, Text,xs+15 ys+25,Buyer:
	Gui, Add, DropDownList,xp+50 yp-2 w150 vBuyersFilter hwndBuyersFilterHandler gGui_Stats_Filter
	Gui, Add, Text,xs+15 ys+55,Guild:
	Gui, Add, DropDownList,xp+50 yp-2 w150 vGuildsFilter hwndGuildsFilterHandler gGui_Stats_Filter
	Gui, Add, Text,xs+225 ys+25,Item:
	Gui, Add, DropDownList,xp+50 yp-2 w150 vItemsFilter hwndItemsFilterHandler gGui_Stats_Filter
	Gui, Add, Text,xs+225 ys+55,Currency:
	Gui, Add, DropDownList,xp+50 yp-2 w150 vCurrenciesFilter hwndCurrenciesFilterHandler gGui_Stats_Filter
	Gui, Add, Text,xs+430 ys+25,League:
	Gui, Add, DropDownList,xp+50 yp-2 w150 vLeaguesFilter hwndLeaguesFilterHandler gGui_Stats_Filter
	Gui, Add, Text,xs+430 ys+55,Tab:
	Gui, Add, DropDownList,xp+50 yp-2 w150 vTabsFilter hwndTabsFilterHandler gGui_Stats_Filter
	Gui, Add, ListView, x0 y120 w%guiWidth% hwndListV h300 gGui_Stats_OnListViewClick AltSubmit,#|Date (YYYY-MM-DD)|Time|Guild|Buyer|Item|Price|League|Tab|Other
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

	Gui, Show, AutoSize NoActivate
    Gui, %defaultGUI%:Default
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
    	Gui Stats:+OwnDialogs

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
	static
	global ProgramValues

	IniRead, updateBeta,% ProgramValues.Ini_File,PROGRAM,Update_Beta, 0
	IniRead, autoUpdate,% ProgramValues.Ini_File,PROGRAM,AutoUpdate, 0
	IniRead, prevUpdateTime,% ProgramValues.Ini_File,PROGRAM,LastUpdate,% A_Now

	changeslogsLink := (updateBeta)?(ProgramValues.Changelogs_Link_Beta):(ProgramValues.Changelogs_Link)
	versionLink := (updateBeta)?(ProgramValues.Version_Link_Beta):(ProgramValues.Version_Link)

;	Delete files remaining from updating
	if FileExist(ProgramValues.Updater_File)
		FileDelete,% ProgramValues.Updater_File
	if FileExist(ProgramValues.NewVersion_File)
		FileDelete,% ProgramValues.NewVersion_File

	ComObjError(0)

;	Changelogs file
	whr := ComObjCreate("WinHttp.WinHttpRequest.5.1")
	whr.Open("GET", changeslogsLink, true) ; Using true above and WaitForResponse allows the script to r'emain responsive.
	whr.Send()
	whr.WaitForResponse(10) ; 10 seconds
	changelogsOnline := whr.ResponseText
	changelogsOnline = %changelogsOnline%
	if ( changelogsOnline ) && !( RegExMatch(changelogsOnline, "Not(Found| Found)") ){
		FileRead, changelogsLocal,% ProgramValues.Changelogs_File
		if ( changelogsLocal != changelogsOnline ) {
			FileDelete, % ProgramValues.Changelogs_File
			UrlDownloadToFile, % changeslogsLink,% ProgramValues.Changelogs_File
		}
	}
	
;	Version number file
	whr := ComObjCreate("WinHttp.WinHttpRequest.5.1")
	whr.Open("GET", versionLink, true)
	whr.Send()
	whr.WaitForResponse(10)
	versionOnline := whr.ResponseText
	versionOnline = %versionOnline%
	if ( versionOnline ) && !( RegExMatch(versionOnline, "Not(Found| Found)") ) { ; couldn't reach the file, cancel update
		StringReplace, versionOnline, versionOnline, `n,,1 ; remove the 2nd white line
		versionOnline = %versionOnline% ; remove any whitespace
	}
	newVersion := (versionOnline)?(versionOnline):(ProgramValues.Version)
	newVersion = %newVersion% ; Avoid a strange issue that would add 0's after decimal

	ProgramValues.Version_Latest := newVersion
	if ( newVersion != ProgramValues.Version ) {
		ProgramValues.Update_Available := 1
		if (autoUpdate=1) {
			timeDif := A_Now
			EnvSub, timeDif, %prevUpdateTime%, Seconds
			if (timeDif > 61 || !timeDif) { ; !timeDif means prevUpdateTime was not in YYYYMMDDHH24MISS format 
				Show_Tray_Notification(newVersion " is available!", "Auto-updating is enabled. Downloading the updater...")
				Download_Updater()
			}
		}
		else {
			Show_Tray_Notification(newVersion " is available!", "Left click on this notification to run the automatic download.`nRight click to dismiss it.", {Is_Update:1, Fade_Timer:10000})
		}
	}
	SetTimer, Check_Update, -1800000
}

;==================================================================================================================
;
;												ABOUT GUI
;
;==================================================================================================================

Gui_About(params="") {
	static
	global ProgramValues

	iniFilePath := ProgramValues.Ini_File, programName := ProgramValues.Name
	verCurrent := ProgramValues.Version, verLatest := ProgramValues.Version_Latest

	isUpdateAvailable := (verLatest && verCurrent != verLatest)?(1):(0)

	IniRead, updateBeta,% iniFilePath,PROGRAM,Update_Beta
	IniRead, autoUpdate,% iniFilePath,PROGRAM,AutoUpdate

	Gui, About:Destroy
	Gui, About:New, +HwndaboutGuiHandler +AlwaysOnTop +SysMenu -MinimizeBox -MaximizeBox +OwnDialogs +LabelGui_About_,% programName " by lemasato v" verCurrent
	Gui, About:Default
	Gui, Font, ,Consolas

	groupText := (isUpdateAvailable)?("Update v" verLatest " available."):("No update available.")
	Gui, Add, GroupBox, w500 h80 xm Section c000000 hwndUpdateAvailableTextHandler,% groupText
	Gui, Add, Text, xs+20 ys+20,% "Current version: " A_Tab verCurrent
	Gui, Add, Text, xs+20 ys+35 hwndLastestVersionTextHandler,% "Latest version: " A_Tab verLatest
	if ( isUpdateAvailable ) {
		GuiControl, About:+cGreen +Redraw,% UpdateAvailableTextHandler
		GuiControl, About:+cGreen +Redraw,% LastestVersionTextHandler
		Gui, Add, Button,x+25 yp-5 w80 h20 gGui_About_Update,Update
	}
	Gui, Add, CheckBox,xs+20 ys+55 vUpdateAutomatically,Enable automatic updates
	Gui, Add, CheckBox,xp+200 yp vUpdateBeta,Enable BETA (Requires reloading)
	if ( autoUpdate = 1 )
		GuiControl, About:,UpdateAutomatically,1
	if ( updateBeta = 1 )
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
	Gui, Add, DropDownList, xm Section w500 gVersion_Change AltSubmit vVerNum hwndVerNumHandler R10,%allVersions%
	Gui, Add, Edit, Section xs vChangesText hwndChangesTextHandler wp R15 ReadOnly,An internet connection is required
	GuiControl, Choose,%VerNumHandler%,1
	GoSub, Version_Change
	Gui, Add, Text, xm Section ,See on:
	Gui, Add, Link, gGitHub_Link ys,% "<a href="""">GitHub</a>"
	Gui, Add, Text, ys,% "-"
	Gui, Add, Link, gReddit_Link ys,% "<a href="""">Reddit</a>"
	Gui, Add, Text, ys,% "-"
	Gui, Add, Link, gGGG_Link ys,% "<a href="""">GGG</a>"
	Gui, Add, Picture,% "gPaypal_Link xs+" 500-74 " ys-3 w74 h21",% ProgramValues.Others_Folder "\DonatePaypal.png"

	Gui, Show, AutoSize
	return
	
	Version_Change:
		Gui, Submit, NoHide
		GuiControl, ,%ChangesTextHandler%,% allChanges[verNum]
		Gui, Show, AutoSize
	return

	Reddit_Link:
		Run,% ProgramValues.Reddit
	Return

	Github_Link:
		Run,% ProgramValues.GitHub
	Return

	GGG_Link:
		Run,% ProgramValues.GGG
	Return

	Paypal_Link:
		Run,% ProgramValues.Paypal
	Return

	Gui_About_Update:
		Download_Updater()
	Return

	Gui_About_Close:
		Gui, About:Submit
		IniWrite,% UpdateAutomatically,% iniFilePath,PROGRAM,AutoUpdate
		IniWrite,% UpdateBeta,% iniFilePath,PROGRAM,Update_Beta
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
	global ProgramValues

	iniFile := ProgramValues.Ini_File
/* 	Hotkeys_Mode
	In 1.10, this setting was removed.
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
				if !(exists)
					Break
				IniWrite, 0, % iniFile, HOTKEYS_ADVANCED, HK%A_Index%_ADV_Toggle
			}
		}
		else if ( hotkeysMode = "Advanced" ) {
			Loop {
				IniRead, exists,% iniFile, HOTKEYS, HK%A_Index%_Toggle
				if !(exists)
					Break
				IniWrite, 0, % iniFile, HOTKEYS, HK%A_Index%_Toggle
			}
		}
		IniDelete,% iniFile, SETTINGS, Hotkeys_Mode
	}
/*	CTRL / ALT / SHIFT States
	In 1.10, this setting was removed.
	Previously, those modifiers would be treated as separate checkboxes.
	Now, it is handled by the hotkey control.
		For this reason, based on the modifiers, we have to modify the original hotkey.
*/
	Loop {
		IniRead, modCtrl,% iniFile, HOTKEYS, HK%A_Index%_CTRL
		IniRead, modAlt,% iniFile, HOTKEYS, HK%A_Index%_ALT
		IniRead, modShift,% iniFile, HOTKEYS, HK%A_Index%_SHIFT

		if !(IsNum(modCtrl))
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
			if ( var = "ERROR" ) {
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
		if ( hotkeyType = "TradesGUI_Custom" )
			ControlClick,,% "ahk_id " TradesGUI_Controls["Button_Custom_" hotkeyID]
		else if ( hotkeyType = "TradesGUI_Unicode" )
			ControlClick,,% "ahk_id " TradesGUI_Controls["Button_Unicode_" hotkeyID]
		WM_Messages_Set_State(1)
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
		Gui, Add, Text, x10 yp+30,Executable:
		WinGet, pName, ProcessName,ahk_id %element%
		Gui, Add, Edit, xp+55 yp-3 ReadOnly w150,% pName
		Gui, Add, Button,xp+155 yp-2 gGUI_Replace_PID_Continue vContinue%index%,Continue with this one
		Gui, Add, Text, x10 yp+32,Path:
		WinGet, pPath, ProcessPath,ahk_id %element%
		Gui, Add, Edit, xp+55 yp-3 ReadOnly,% pPath
		if ( index != handlersArray.MaxIndex() ) ; Put a 10px margin if it's not the last element
			Gui, Add, Text, w0 h0 xp yp+10
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
		Gui, Add, Text, x10 yp+30,Executable:
		WinGet, pName, ProcessName,ahk_id %element%
		Gui, Add, Edit, xp+55 yp-3 ReadOnly w150,% pName
		Gui, Add, Button,xp+155 yp-2 gGUI_Multiple_Instances_Continue vContinue%index%,Continue with this one
		Gui, Add, Text, x10 yp+32,Path:
		WinGet, pPath, ProcessPath,ahk_id %element%
		Gui, Add, Edit, xp+55 yp-3 ReadOnly,% pPath
		if ( index != handlersArray.MaxIndex() ) ; Put a 10px margin if it's not the last element
			Gui, Add, Text, w0 h0 xp yp+10
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

	RegExMatch(A_GuiControl, "\D+", btnType)
	RegExMatch(A_GuiControl, "\d+", btnID)

	if ( A_Gui = "Trades" ) {
		if (btnType = "BtnClose") {
			Menu, TradesCloseBtn, Add, Close similar trades, Gui_Trades_Close_Similar
			Menu, TradesCloseBtn, Show
		}
	}
	return

	Gui_Trades_Close_Similar:
;		Check for other trades with different buyer but same item/price/location
 		tabToDel := TradesGUI_Values.Active_Tab
 		duplicatesID := Gui_Trades_Check_Duplicate(tabToDel)
 		if ( duplicatesID.MaxIndex() ) {
 			duplicatesInfos := Gui_Trades_Get_Trades_Infos(duplicatesID[0])
			Gui_Trades("REMOVE_DUPLICATES", duplicatesID)	
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
	global TradesGUI_Values, ProgramValues, TradesGUI_Controls, ProgramSettings

	programSkinFolderPath := ProgramValues.Skins_Folder

	lastButton := TradesGUI_Values.Last_Hovered_Button
	lastPngFilePrefix := TradesGUI_Values.TradesGUI_Last_PNG
	RegExMatch(A_GuiControl, "\D+", btnType)
	RegExMatch(A_GuiControl, "\d+", btnID)

	if (A_GUI = "Trades") {

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
		if btnType in BuyerSlot,ItemSlot,PriceSlot,LocationSlot,OtherSlot
		{
			CoordMode, ToolTip, Screen
			GuiControlGet, content,Trades:,% btnHandler
			ctrlPos := Get_Control_Coords("Trades", btnHandler)
			WinGetPos, tradesXPOS, tradesYPOS
			ToolTip, % content,% tradesXPOS+ctrlPOS.X,% tradesYPOS+ctrlPOS.Y
			MouseGetPos, mouseX, mouseY
			global Remove_ToolTip_OnMouseMove_Values := {X:mouseX, Y:mouseY, Treshold_X:100, Treshold_Y:10}
			SetTimer, Remove_Tooltip_OnMouseMove, 100
		}
		if !A_GuiControl ; No control hovered, reset the value
			TradesGUI_Values.Last_Hovered_Button := ""
	}

	else if ( A_GUI = "Settings" ) {
		timer := (ProgramValues.Debug)?(-100):(-1000)
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

	if (btnID)
		lastBtnID := btnID
	if (pngFilePrefix)
		TradesGUI_Values.Insert("TradesGUI_Last_PNG", pngFilePrefix) ; __TO_BE_INSPECTED__ Usused leftover?
	if (A_GuiControl)
		TradesGUI_Values.Insert("Trades_GUI_Hover_Control", A_GuiControl) ; __TO_BE_INSPECTED__ Usused leftover?
}

WM_LBUTTONDOWN(wParam, lParam, msg, hwnd) {
	global TradesGUI_Values, ProgramValues, TradesGUI_Controls, ProgramSettings

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
}

ShellMessage(wParam,lParam) {
/*			Triggered upon activating a window
 *			Is used to correctly position the Trades GUI while in Overlay mode
*/
	global ProgramValues, ProgramSettings, TradesGUI_Values
	global POEGameList

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

		WinGet, winEXE, ProcessName, ahk_id %lParam%
		WinGet, winID, ID, ahk_id %lParam%
		if ( ProgramSettings.Show_Mode = "InGame" ) {

			if ( TradesGUI_Values.Width ) { ; TradesGUI exists
				if POEGameList not contains %winEXE%
				{
					Gui, Trades:Show, NoActivate Hide
				}
				else {
					Gui, Trades:Show, NoActivate
				}
			}
		}
		else
			Gui, Trades:Show, NoActivate ; Always Shwo

		if ( ProgramSettings.Gui_Trades_Mode = "Overlay")
			Gui_Trades_Set_Position() ; Re-position the GUI

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

Do_Once() {
/*			
 *			Things that only need to be done ONCE
*/
	global ProgramValues

	iniFilePath := ProgramValues.Ini_File

;	Open the changelog menu
	IniRead, state,% iniFilePath,PROGRAM,Show_Changelogs
	if ( state = 1 ) {
		Gui_About()
		IniWrite, 0,% iniFilePath,PROGRAM,Show_Changelogs
	}
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

	if ( funcName = "DUMP" ) {
		dpiFactor := ProgramSettings.Screen_DPI

		FileAppend,% ">>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>`n",% logsFile
		FileAppend,% ">>> OS SECTION `n",% logsFile
		FileAppend,% ">>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>`n",% logsFile	
		OSbits := (A_Is64bitOS)?("64bits"):("32bits")
		FileAppend,% "Type: " A_OSType "`n",% logsFile
		FileAppend,% "Version: " A_OSVersion "(" OSbits ")`n",% logsFile
		FileAppend,% "DPI: " dpiFactor "`n",% logsFile
		FileAppend,% "`n",% logsFile

		FileAppend,% ">>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>`n",% logsFile
		FileAppend,% ">>> TOOL SECTION `n",% logsFile
		FileAppend,% ">>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>`n",% logsFile
		FileAppend,% "Version: " ProgramValues.Version "`n",% logsFile
		FileAppend,% "Local_Folder: " ProgramValues.Local_Folder "`n",% logsFile
		FileAppend,% "Game_Folder: " ProgramValues.Game_Folder "`n",% logsFile
		FileAppend,% "`n",% logsFile

		FileAppend,% ">>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>`n",% logsFile
		FileAppend,% ">>> PROGRAM SECTION `n",% logsFile
		FileAppend,% ">>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>`n",% logsFile
		IniRead, content,% iniFilePath,PROGRAM
		FileAppend,% content "`n",% logsFile
		FileAppend,% "`n",% logsFile

		FileAppend,% ">>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>`n",% logsFile
		FileAppend,% ">>> GAME SETTINGS `n",% logsFile
		FileAppend,% ">>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>`n",% logsFile
		for key, element in GameSettings {
			FileAppend,% key ": """ element """`n",% logsFile
		}
		FileAppend,% "`n",% logsFile

		FileAppend,% ">>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>`n",% logsFile
		FileAppend,% ">>> LOCAL SETTINGS `n",% logsFile
		FileAppend,% ">>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>`n",% logsFile
		for key, element in params.KEYS {
			FileAppend,% params.KEYS[A_Index] ": """ params.VALUES[A_Index] """`n",% logsFile
		}
		FileAppend,% "<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<`n",% logsFile
		FileAppend,% "<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<`n",% logsFile
		FileAppend,% "`n",% logsFile
	}

	else {
		FileAppend,% "[" A_YYYY "-" A_MM "-" A_DD "_" A_Hour ":" A_Min ":" A_Sec "] ",% logsFile

		if ( funcName = "DEBUG" ) {
			FileAppend,% params.String,% logsFile
		}

		else if ( funcName = "GUI_Multiple_Instances" ) {			
			FileAppend,% "Multiple instances found. Handler: " params.Handler " - Path: " params.Path,% logsFile
		}
		else if ( funcName = "GUI_Multiple_Instances_Return" ) {
			FileAppend,% "Multiple instances found (Return). Handler: " params.Handler,% logsFile
		}

		else if ( funcName = "Monitor_Game_Logs" ) {
			FileAppend,% "Monitoring game logs file: " params.File,% logsFile
		}
		else if ( funcName = "Monitor_Game_Logs_Break" ) {
			FileAppend,% "ERROR: Restarting logs monitoring. Pointer Position: " params.Pos " - File Length: " params.Length,% logsFile
		}

		else if ( funcName = "Gui_Trades_Set_Position" ) {
			FileAppend,% "Setting Trades GUI Position: x" params.X " y" params.Y,% logsFile
		}

		else if (funcName = "ShellMessage" ) {
			FileAppend,% "Trades GUI Hidden: Show_Mode: " params.Show_Mode " - Dock_Window ID: " params.Dock_Window " - Current Win ID: " params.Current_Win_ID "."
		}

		else if ( funcName = "Gui_Trades_Cycle_Func" ) {
			FileAppend,% "Docking Trades GUI to ID: " params.Dock_Window " - Total matchs found: " params.Total_Matchs,% logsFile
		}

		else if ( funcName = "GUI_Replace_PID_Return" ) {
			FileAppend,% "Replacing Trades GUI tab PID with: " params.PID,% logsFile
		}

		else if ( funcName = "Gui_Trades_Do_Action_Func" ) {
			FileAppend,% "ERROR: Matching aciton not found for button: Name: " params.Var_Name ", Alpha: " params.Var_Alpha ", Action: " params.Action,% logsFile
		}

		else if ( funcName = "Gui_Stats_Get_Currency_Name" ) {
			FileAppend,% "ERROR: Unknown currency type: """ params.Currency """"
		}

		else if ( funcName = "Gui_Trades_Select_Tab" ) {
			FileAppend,% "ERROR: Could not select tab """ params.Tab_ID """. Action occured: " params.Action ""
		}
	}

	FileAppend,% "`n",% logsFile
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

	chatVK := GameSettings.Chat_VK
	if (!chatVK) {
		MsgBox, 4096,% programName " - Operation Cancelled.",% "Could not detect the chat key!"
		. "`nPlease send me an archive containing the Logs folder."
		. "`nYou can find links to GitHub / GGG / Reddit in the [About?] tray menu."
		. "`n`n(The local folder containing the Logs folder will open upon closing this box)."
		Run, % ProgramValues.Local_Folder
		Return 1
	}

	Loop 3 { ; Include the trade variable content into the variables.
		StringReplace, message%A_Index%, message%A_Index%, `%buyerName`%, %buyerName%, 1
		StringReplace, message%A_Index%, message%A_Index%, `%itemName`%, %itemName%, 1
		StringReplace, message%A_Index%, message%A_Index%, `%itemPrice`%, %itemPrice%, 1
		StringReplace, message%A_Index%, message%A_Index%, `%lastWhisper`%,% TradesGUI_Values.Last_Whisper, 1
	}

	if ( specialEvent.isHotkey ) {
		messageToSend := message1
		if ( specialEvent.isAdvanced ) {
			SendInput,%messageToSend%
		}
		else {
			firstChar := SubStr(messageToSend, 1, 1) ; Returns abc

			SendInput,{VK%chatVK%}
			Sleep 10

			if firstChar not in /,`%,&,#,@
				SendInput, /{BackSpace} ; Send in local chat
			SendInput,{Raw}%messageToSend%
			SendInput,{Enter}
		}
		Return
	}
	else {
		if !WinExist("ahk_pid " gamePID " ahk_group POEGame") {
			PIDArray := Get_Matching_Windows_Infos("PID")
			handlersArray := Get_Matching_Windows_Infos("ID")
			if ( handlersArray.MaxIndex() = "" ) {
				Show_Tray_Notification(programName, "The PID assigned to the tab does not belong to a POE instance, and no POE instance was found!`n`nPlease click the button again after restarting the game.")
				Return 1
			}
			else {
				newPID := GUI_Replace_PID(handlersArray, PIDArray)
				setInfos := Object(), setInfos.NewPID := newPID, setInfos.OldPID := gamePID, setInfos.TabID := tabInfos.TabID
				Gui_Trades_Set_Trades_Infos(setInfos)
				gamePID := newPID
			}
		}
		titleMatchMode := A_TitleMatchMode
		SetTitleMatchMode, RegEx
		WinActivate,[a-zA-Z0-9_] ahk_pid %gamePID%
		WinWaitActive,[a-zA-Z0-9_] ahk_pid %gamePID%, ,5
		if (!ErrorLevel) {
			Loop 3 {
				messageToSend := message%A_Index%
				if ( !messagetoSend )
					Break
				else {
					Sleep 10
					if chatVK in 0x1,0x2,0x4,0x5,0x6,0x9C,0x9D,0x9E,0x9F ; Mouse buttons
					{
						keyDelay := A_KeyDelay, keyDuration := A_KeyDuration
						SetKeyDelay, 10, 10
						ControlSend, ,{VK%keyVK%}, [a-zA-Z0-9_] ahk_pid %gamePID% ; Mouse buttons tend to activate the window under the cursor.
																				  ; Therefore, we need to send the key to the actual game window.
  						SetKeyDelay,% keyDelay,% keyDuration
						Sleep 10
					}
					else
						SendInput,{VK%chatVK%}

					firstChar := SubStr(messageToSend, 1, 1) ; Returns abc
					if firstChar not in /,`%,&,#,@
						SendInput,/{BackSpace}
					SendInput,{Raw}%messageToSend%
					if !( specialEvent.doNotSend )
						SendInput,{Enter}
					Sleep 10
				}
			}
		}

		BlockInput, Off
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


Extract_Font_Files() {
/*			Include the Resources into the compiled executable
 *			Extract the Resources into their specified folder
*/
	global ProgramValues, ProgramFonts

	programFontFolderPath := ProgramValues.Fonts_Folder

	FileInstall, C:\Users\Masato\Documents\GitHub\POE-Trades-Companion\Resources\Fonts\Fontin-SmallCaps.ttf,% programFontFolderPath "\Fontin-SmallCaps.ttf", 1
	FileInstall, C:\Users\Masato\Documents\GitHub\POE-Trades-Companion\Resources\Fonts\Consolas.ttf,% programFontFolderPath "\Consolas.ttf", 1
	FileInstall, C:\Users\Masato\Documents\GitHub\POE-Trades-Companion\Resources\Fonts\TC-Symbols.otf,% programFontFolderPath "\TC-Symbols.otf", 1
	FileInstall, C:\Users\Masato\Documents\GitHub\POE-Trades-Companion\Resources\Fonts\Segoe UI.ttf,% programFontFolderPath "\Segoe UI.ttf", 1
	FileInstall, C:\Users\Masato\Documents\GitHub\POE-Trades-Companion\Resources\Fonts\Settings.ini,% programFontFolderPath "\Settings.ini", 1
}

Extract_Skin_Files() {
/*			Include the default skins into the compiled executable
 *			Extracts the included skins into the skins Folder
*/
	global ProgramValues
	skinFolder := ProgramValues.Skins_Folder

;	System Skin
	if !( InStr(FileExist(skinFolder "\System"), "D") )
		FileCreateDir, % skinFolder "\System"
	FileInstall, C:\Users\Masato\Documents\GitHub\POE-Trades-Companion\Resources\Skins\System\Settings.ini,% skinFolder "\System\Settings.ini", 1
	FileInstall, C:\Users\Masato\Documents\GitHub\POE-Trades-Companion\Resources\Skins\System\Header.png,% skinFolder "\System\Header.png", 1
	FileInstall, C:\Users\Masato\Documents\GitHub\POE-Trades-Companion\Resources\Skins\System\Border.png,% skinFolder "\System\Border.png", 1
	FileInstall, C:\Users\Masato\Documents\GitHub\POE-Trades-Companion\Resources\Skins\System\Icon.png,% skinFolder "\System\Icon.png", 1

;	Path of Exile Skin
	if !( InStr(FileExist(skinFolder "\Path of Exile"), "D") )
		FileCreateDir, % skinFolder "\Path of Exile"
	FileInstall, C:\Users\Masato\Documents\GitHub\POE-Trades-Companion\Resources\Skins\Path Of Exile\Settings.ini,% skinFolder "\Path Of Exile\Settings.ini", 1
	FileInstall, C:\Users\Masato\Documents\GitHub\POE-Trades-Companion\Resources\Skins\Path Of Exile\ArrowLeft.png,% skinFolder "\Path Of Exile\ArrowLeft.png", 1
	FileInstall, C:\Users\Masato\Documents\GitHub\POE-Trades-Companion\Resources\Skins\Path Of Exile\ArrowLeftHover.png,% skinFolder "\Path Of Exile\ArrowLeftHover.png", 1
	FileInstall, C:\Users\Masato\Documents\GitHub\POE-Trades-Companion\Resources\Skins\Path Of Exile\ArrowLeftPress.png,% skinFolder "\Path Of Exile\ArrowLeftPress.png", 1
	FileInstall, C:\Users\Masato\Documents\GitHub\POE-Trades-Companion\Resources\Skins\Path Of Exile\ArrowRight.png,% skinFolder "\Path Of Exile\ArrowRight.png", 1
	FileInstall, C:\Users\Masato\Documents\GitHub\POE-Trades-Companion\Resources\Skins\Path Of Exile\ArrowRightHover.png,% skinFolder "\Path Of Exile\ArrowRightHover.png", 1
	FileInstall, C:\Users\Masato\Documents\GitHub\POE-Trades-Companion\Resources\Skins\Path Of Exile\ArrowRightPress.png,% skinFolder "\Path Of Exile\ArrowRightPress.png", 1
	FileInstall, C:\Users\Masato\Documents\GitHub\POE-Trades-Companion\Resources\Skins\Path Of Exile\Background.png,% skinFolder "\Path Of Exile\Background.png", 1
	FileInstall, C:\Users\Masato\Documents\GitHub\POE-Trades-Companion\Resources\Skins\Path Of Exile\ButtonBackground.png,% skinFolder "\Path Of Exile\ButtonBackground.png", 1
	FileInstall, C:\Users\Masato\Documents\GitHub\POE-Trades-Companion\Resources\Skins\Path Of Exile\ButtonBackgroundHover.png,% skinFolder "\Path Of Exile\ButtonBackgroundHover.png", 1
	FileInstall, C:\Users\Masato\Documents\GitHub\POE-Trades-Companion\Resources\Skins\Path Of Exile\ButtonBackgroundPress.png,% skinFolder "\Path Of Exile\ButtonBackgroundPress.png", 1
	FileInstall, C:\Users\Masato\Documents\GitHub\POE-Trades-Companion\Resources\Skins\Path Of Exile\ButtonOrnamentLeft.png,% skinFolder "\Path Of Exile\ButtonOrnamentLeft.png", 1
	FileInstall, C:\Users\Masato\Documents\GitHub\POE-Trades-Companion\Resources\Skins\Path Of Exile\ButtonOrnamentRight.png,% skinFolder "\Path Of Exile\ButtonOrnamentRight.png", 1
	FileInstall, C:\Users\Masato\Documents\GitHub\POE-Trades-Companion\Resources\Skins\Path Of Exile\Close.png,% skinFolder "\Path Of Exile\Close.png", 1
	FileInstall, C:\Users\Masato\Documents\GitHub\POE-Trades-Companion\Resources\Skins\Path Of Exile\CloseHover.png,% skinFolder "\Path Of Exile\CloseHover.png", 1
	FileInstall, C:\Users\Masato\Documents\GitHub\POE-Trades-Companion\Resources\Skins\Path Of Exile\ClosePress.png,% skinFolder "\Path Of Exile\ClosePress.png", 1
	FileInstall, C:\Users\Masato\Documents\GitHub\POE-Trades-Companion\Resources\Skins\Path Of Exile\TabActive.png,% skinFolder "\Path Of Exile\TabActive.png", 1
	FileInstall, C:\Users\Masato\Documents\GitHub\POE-Trades-Companion\Resources\Skins\Path Of Exile\TabInactive.png,% skinFolder "\Path Of Exile\TabInactive.png", 1
	FileInstall, C:\Users\Masato\Documents\GitHub\POE-Trades-Companion\Resources\Skins\Path Of Exile\TabUnderline.png,% skinFolder "\Path Of Exile\TabUnderline.png", 1
	FileInstall, C:\Users\Masato\Documents\GitHub\POE-Trades-Companion\Resources\Skins\Path Of Exile\Header.png,% skinFolder "\Path Of Exile\Header.png", 1
	FileInstall, C:\Users\Masato\Documents\GitHub\POE-Trades-Companion\Resources\Skins\Path Of Exile\Border.png,% skinFolder "\Path Of Exile\Border.png", 1
	FileInstall, C:\Users\Masato\Documents\GitHub\POE-Trades-Companion\Resources\Skins\Path of Exile\Icon.png,% skinFolder "\Path of Exile\Icon.png", 1
}

Extract_Sound_Files() {
/*			Include the SFX into the compiled executable
 *			Extracts the included SFX into the SFX Folder
*/
	global ProgramValues
	sfxFolder := ProgramValues.SFX_Folder

	FileInstall, C:\Users\Masato\Documents\GitHub\POE-Trades-Companion\Resources\SFX\MM_Tatl_Gleam.wav,% sfxFolder "\MM_Tatl_Gleam.wav", 0
	FileInstall, C:\Users\Masato\Documents\GitHub\POE-Trades-Companion\Resources\SFX\MM_Tatl_Hey.wav,% sfxFolder "\MM_Tatl_Hey.wav", 0
	FileInstall, C:\Users\Masato\Documents\GitHub\POE-Trades-Companion\Resources\SFX\WW_MainMenu_CopyErase_Start.wav,% sfxFolder "\WW_MainMenu_CopyErase_Start.wav", 0
	FileInstall, C:\Users\Masato\Documents\GitHub\POE-Trades-Companion\Resources\SFX\WW_MainMenu_Letter.wav,% sfxFolder "\WW_MainMenu_Letter.wav", 0
}

Extract_Data_Files() {
	global ProgramValues
	dataFolder := ProgramValues.Data_Folder

	FileInstall, C:\Users\Masato\Documents\GitHub\POE-Trades-Companion\Resources\Data\Currency_All.txt,% dataFolder "\Currency_All.txt", 1
	FileInstall, C:\Users\Masato\Documents\GitHub\POE-Trades-Companion\Resources\Data\currencyTradeNames.json,% dataFolder "\currencyTradeNames.json", 1
}

Extract_Others_Files() {
/*			Include any other file that does not belong to the others
			Extracts the included files into the specified folder
*/
	global ProgramValues
	othersFolder := ProgramValues.Others_Folder

	FileInstall, C:\Users\Masato\Documents\GitHub\POE-Trades-Companion\Resources\Others\DonatePaypal.png,% othersFolder "\DonatePaypal.png", 1
	FileInstall, C:\Users\Masato\Documents\GitHub\POE-Trades-Companion\Resources\Others\icon.png,% othersFolder "\icon.png", 1
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
	static
	global ProgramValues, TradesGUI_Values, ProgramSettings

	programName := ProgramValues.Name
	nextID := TradesGUI_Values.Dock_Window_Num
	nextID += 1

	if ( ProgramSettings.Trades_GUI_Mode != "Overlay" )
		Return

	if !Trades_GUI_Exists() {
		Show_Tray_Notification(programName, "Couldn't find the Trades GUI!`nOperation Canceled.")
		Return
	}
	matchHandlers := Get_Matching_Windows_Infos("ID")
	TradesGUI_Values.Dock_Window_Num := nextID
	if ( TradesGUI_Values.Dock_Window_Num > matchHandlers.MaxIndex() ) {
		TradesGUI_Values.Dock_Window_Num := 0
	}
	TradesGUI_Values.Insert("Dock_Window", matchHandlers[TradesGUI_Values["Dock_Window_Num"]])
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
	global ProgramValues, ProgramSettings

	programName := ProgramValues.Name, programVersion := ProgramValues.Version

	Menu, Tray, NoStandard
	Menu, Tray, DeleteAll
	Menu, Tray, Tip,% programName " v" programVersion
	if ( ProgramValues.Debug ) {
		Menu, Debug, Add,Open game folder,Open_Game_Folder
		Menu, Debug, Add,Open local folder,Open_Local_Folder
		Menu, Debug, Add,Delete local settings (+Reload),Delete_Local_Folder
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
	Return

	Delete_Local_Folder:
		FileRemoveDir,% ProgramValues.Local_Folder, 1
		Reload_Func()
	Return

	Open_Game_Folder:
		Run,% ProgramValues.Game_Folder,,UseErrorLevel
		if (A_LastError) {
			ErrorMsg := Get_System_Error_Codes(A_LastError)
		}
	Return

	Open_Local_Folder:
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
	global ProgramValues, ProgramSettings, RunParameters

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
	if !ProgramValues.Debug {
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

	defaultGui := A_DefaultGUI

	if (condition = "Previous_Instance_Close") {
		SetTimer, GUI_Beautiful_Warning_Instance_WaitClose, 1000
	}

	static WarnTextHandler

	Gui, BeautifulWarn:Destroy
	Gui, BeautifulWarn:New, +AlwaysOnTop +ToolWindow -Caption -Border +LabelGui_Beautiful_Warning_ hwndGuiBeautifulWarningHandler,% ProgramValues.Name
	Gui, BeautifulWarn:Default
	Gui, Margin, 0, 0
	Gui, Color,% backgroundCol
	Gui, Font,% "S" guiFontSize,% guiFontName
	Gui, Add, Progress,% "x0" . " y0" . " h" borderSize . " w" guiWidth . " Background" borderColor ; Top
	Gui, Add, Text,% "x" xOffset " ym+5 w" guiWidth-(xOffset*2) " c" warnTitleColor " Center BackgroundTrans Section",% ProgramValues.Name
	if (warnTitle) {
		Gui, Add, Text,% "x" xOffset " w" guiWidth-(xOffset*2) " c" warnTitleColor "  Center BackgroundTrans Section",% warnTitle
		Gui, Add, Progress,% "x" xOffset . " y+5 h" borderSize . " w" guiWidth-(xOffset*2) . " Background" borderColor " Section" ; Underline
	}
	Gui, Add, Progress,% "x" guiWidth-borderSize . " y0" . " h" guiHeight . " w" borderSize . " Background" borderColor ; Right
	Gui, Add, Progress,% "x0" . " y" guiHeight-borderSize . " h" borderSize . " w" guiWidth . " Background" borderColor ; Bot
	Gui, Add, Progress,% "x0" . " y0" . " h" guiHeight . " w" borderSize . " Background" borderColor ; Left
	Gui, Add, Text,% "x" xOffset " ys+" yOffset " w" guiWidth-(xOffset*2) " hwndWarnTextHandler c" warnTextColor " Center BackgroundTrans",% warnText
	if (condition = "Reload_Timer") {
		GoSub GUI_Beautiful_Warning_Reload_Timer
		SetTimer, GUI_Beautiful_Warning_Reload_Timer, 1000
	}

	Gui, Add, Text,x0 y0 w%guiWidth% h%guiHeight% BackgroundTrans gGUI_Beautiful_Warning_OnLeftClick,% ""
	Gui, Show, w%guiWidth% h%guiHeight%
	Gui, %defaultGUI%:Default

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
	Gui, AdminWarn:Default
	Gui, Font, ,Consolas
	Gui, Font, Bold
	Gui, Add, GroupBox, xm ym cRed w460 h140 Center Section c000000,% "IMPORTANT INFORMATIONS, PLEASE READ"
	Gui, Add, Text,xs+15 ys+25 Center,% ProgramValues.Name " was unable to start with admin rights previously."
	. "`nTry right clicking the executable and choose ""Run as Administrator""."
	. "`n`nIf for some reason you prefer not to use admin elevation, please use"
	. "`nthe shorcut that has been placed in the same folder as the executable."
	. "`nPlease be aware that unexpected behaiour may happen."
	. "`n`nThe tool will exit upon closing this window."
	Gui, Add, Button, xs w460 h30 Disabled vUnlockBtn gGui_AdminWarn_Accept,% "This button will be unlocked in 10..."
	Gui, Show
	WinWait,% "ahk_id " GuiAdminWarnHandler
	count := 10
	Loop %count% {
		Sleep 1000
		count--
		GuiControl, , UnlockBtn,% "This button will be unlocked in " count "..."
	}
	GuiControl, , UnlockBtn,% "Alright, got it!"
	GuiControl, Enable, UnlockBtn
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
	allTrades := Gui_Trades_Manage_Trades("GET_ALL")
	FileDelete,% ProgramValues.Trades_Backup_File
	for key, element in allTrades {
		if (key = "Max_Index")
			element--
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
		if A_LoopFileExt in otf,otc,ttf,ttc
		{
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
	Gui, GetTextSize:Font, S%fontSize%,% fontName
	if (maxWidth) 
		Gui, GetTextSize:Add, Text,x0 y0 +Wrap w%maxWidth% hwndTxtHandler,% txt
	else 
		Gui, GetTextSize:Add, Text,x0 y0 hwndTxtHandler,% txt
	coords := Get_Control_Coords("GetTextSize", TxtHandler)
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

Show_Tray_Notification(title, msg, params="") {
/*		Show a notification.
 *		Look based on w10 traytip.
*/
	static
	global ProgramValues, ProgramSettings

	local defaultGUI := A_DefaultGUI

	Is_Update := params.Is_Update

	guiWidthMax := 350, guiHeightMax := 150
	guiFontName := "Segoe UI", guiFontSize := "9", guiTitleFontSize := "10"
	textSize := Get_Text_Control_Size(msg, guiFontName, guiFontSize, guiWidthMax)

	guiWidth := (textSize.W > guiWidthMax)?(guiWidthMax):(textSize.W)
	guiHeight := (textSize.H > guiHeightMax)?(guiHeightMax):(textSize.H)
	guiHeight += 50, guiWidth += 20 ; Fitting size
	borderSize := 1
	fadeTimer := (params.Fade_Timer)?(params.Fade_Timer):(5000)

	showX := A_ScreenWidth, showY := A_ScreenHeight-guiHeight-60
	showW := 0, showH := guiHeight

	Gui, TrayNotification:Destroy
	Gui, TrayNotification:New, +ToolWindow +AlwaysOnTop -Border +LastFound -SysMenu -Caption +LabelGui_TrayNotification_
	Gui, TrayNotification:Default
	Gui, Margin, 0, 0
	Gui, Color, 1f1f1f

	Gui, Add, Progress, x0 y0 w%guiWidth% h%borderSize% Background484848 ; Top
	Gui, Add, Progress, x0 y0 w%borderSize% h%guiHeight% Background484848 ; Left
	; Gui, Add, Progress,% "x" guiWidth-borderSize " y0" " w" borderSize " h" guiHeight " Background484848" ; Right
	Gui, Add, Progress,% "x" 0 " y" guiHeight-borderSize " w" guiWidth " h" borderSize " Background484848" ; Bottom
	Gui, Add, Text,% "x0 y0 w" guiWidth " h" guiHeight " BackgroundTrans gGui_TrayNotification_OnLeftClick",% ""

	Gui, Add, Picture, x5 y5 w32 h32,% ProgramValues.Others_Folder "\icon.png"
	Gui, Font, S%guiTitleFontSize% Bold,% guiFontName
	Gui, Add, Text,% "xp+35" " yp+10" " w" guiWidth-20 " BackgroundTrans cFFFFFF gGui_TrayNotification_OnLeftClick",% title
	Gui, Font, S%guiFontSize% Norm,% guiFontName
	Gui, Add, Text,% "x10" " yp+25" " w" guiWidth-25 " R3 BackgroundTrans ca5a5a5 gGui_TrayNotification_OnLeftClick",% msg
	Gui, Show,% "x" showX " y" showY " w" showW " h" showH " NoActivate"
	Loop {
		showW += 25
		showW := (showW > guiWidth)?(guiWidth):(showW)
		showX := A_ScreenWidth-showW
		Gui, Show,% "x" showX " w" showW " NoActivate"
		Sleep 1
		if (showW = guiWidth)
			Break
	}

	SetTimer, Fade_Tray_Notification, -%fadeTimer%
	Gui, %defaultGUI%:Default
	Return

	Gui_TrayNotification_ContextMenu: ; Launched whenever the user right-clicks anywhere in the window except the title bar and menu bar.
		Gui, TrayNotification:Destroy
	Return

	Gui_TrayNotification_OnLeftClick:
		Gui, TrayNotification:Destroy
		if (Is_Update) {
			Download_Updater()
		}
	Return
}

Download_Updater() {
	global ProgramValues

	Gui_Trades_Save_Pending_Backup()

	IniRead,updateBeta,% ProgramValues.Ini_File,PROGRAM,Update_Beta

	updaterLink := (updateBeta)?(ProgramValues.Updater_Link_Beta):(ProgramValues.Updater_Link)
	newVersionLink := (updateBeta)?(ProgramValues.NewVersion_Link_Beta):(ProgramValues.NewVersion_Link)
	fileName := (updateBeta)?(ProgramValues.Name " (Beta).exe"):(ProgramValues.Name ".exe")

	IniWrite,% A_Now,% ProgramValues.Ini_File,PROGRAM,LastUpdate
	UrlDownloadToFile,% updaterLink,% ProgramValues.Updater_File
	Sleep 10
	Run,% ProgramValues.Updater_File 
	. " /Name=""" ProgramValues.Name  """"
	. " /File_Name=""" fileName """"
	. " /Local_Folder=""" ProgramValues.Local_Folder """"
	. " /Ini_File=""" ProgramValues.Ini_File """"
	. " /NewVersion_Link=""" newVersionLink """"
	ExitApp
}

Fade_Tray_Notification() {
	transparency := 255

	Gui, TrayNotification:+LastFound

	Loop {
		transparency -= 5
		WinSet, Transparent,% transparency
		if !(transparency)
			Break
		Sleep 1
	}
	Gui, TrayNotification:Destroy
}


#Include %A_ScriptDir%/Resources/AHK/
#Include BinaryEncodingDecoding.ahk
#Include JSON.ahk
; #Include %A_ScriptDir%/Resources/AHK/BetaFuncs.ahk