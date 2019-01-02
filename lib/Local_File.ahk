LocalSettings_VerifyEncoding() {
	global PROGRAM
	iniFile := PROGRAM.INI_FILE

	hINI := FileOpen(iniFile, "r")
	if (hINI.Encoding != "UTF-16") {
		AppendToLogs(A_ThisFunc "(): Wrong ini file encoding (" hINI.Encoding "). Making backup and creating new file with UTF-16 encoding.")
		data := hINI.Read()
		hINI.Close()   

		SplitPath, iniFile, , folder
		FileMove,% iniFile,% folder "\" A_Now "_Preferences.ini", 1

		hINI2 := FileOpen(iniFile, "w", "UTF-16")
		hINI2.Write(Data)
	}
}

Get_LocalSettings_DefaultValues() {
	global PROGRAM

	settings := {}

	settings.SECTIONS_ORDER := "GENERAL,UPDATING,SETTINGS_MAIN,SETTINGS_CUSTOMIZATION_SKINS,SETTINGS_CUSTOM_BUTTON_"
		. ",SETTINGS_SPECIAL_BUTTON_,SETTINGS_HOTKEY_,SETTINGS_HOTKEY_ADV_"

	settings.GENERAL 																	:= {}
	settings.GENERAL.IsFirstTimeRunning 												:= "True"
	settings.GENERAL.AddShowGridActionToInviteButtons									:= "True"
	settings.GENERAL.HasAskedForImport													:= "True"
	settings.GENERAL.RemoveCopyItemInfosIfGridActionExists								:= "True"

	settings.SETTINGS_MAIN 																:= {}
	settings.SETTINGS_MAIN.TradingWhisperSFXPath 										:= PROGRAM.SFX_FOLDER "\WW_MainMenu_Letter.wav" 
	settings.SETTINGS_MAIN.RegularWhisperSFXPath 										:= ""
	settings.SETTINGS_MAIN.BuyerJoinedAreaSFXPath 										:= ""
	settings.SETTINGS_MAIN.NoTabsTransparency 											:= "0"
	settings.SETTINGS_MAIN.TabsOpenTransparency 										:= "100"
	settings.SETTINGS_MAIN.HideInterfaceWhenOutOfGame 									:= "False"
	settings.SETTINGS_MAIN.CopyItemInfosOnTabChange 									:= "False"
	settings.SETTINGS_MAIN.AutoFocusNewTabs 											:= "False"
	settings.SETTINGS_MAIN.AutoMinimizeOnAllTabsClosed 									:= "True"
	settings.SETTINGS_MAIN.AutoMaximizeOnFirstNewTab 									:= "False"
	settings.SETTINGS_MAIN.SendTradingWhisperUponCopyWhenHoldingCTRL					:= "True"
	settings.SETTINGS_MAIN.TradingWhisperSFXToggle 										:= "True"
	settings.SETTINGS_MAIN.RegularWhisperSFXToggle 										:= "False"
	settings.SETTINGS_MAIN.BuyerJoinedAreaSFXToggle 									:= "False"
	settings.SETTINGS_MAIN.ShowTabbedTrayNotificationOnWhisper 							:= "True"
	settings.SETTINGS_MAIN.TradesGUI_Mode 												:= "Window"
	settings.SETTINGS_MAIN.Pos_X 														:= "0"
	settings.SETTINGS_MAIN.Pos_Y 														:= "0"
	settings.SETTINGS_MAIN.TradesGUI_Locked 											:= "False"
	settings.SETTINGS_MAIN.AllowClicksToPassThroughWhileInactive 						:= "True"
	settings.SETTINGS_MAIN.SendMsgMode 													:= "Clipboard"
	settings.SETTINGS_MAIN.PushBulletToken												:= ""
	settings.SETTINGS_MAIN.PushBulletOnTradingWhisper									:= "True"
	settings.SETTINGS_MAIN.PushBulletOnPartyMessage										:= "False"
	settings.SETTINGS_MAIN.PushBulletOnWhisperMessage									:= "False"
	settings.SETTINGS_MAIN.PushBulletOnlyWhenAfk										:= "True"
	settings.SETTINGS_MAIN.PoeAccounts													:= ""
	settings.SETTINGS_MAIN.MinimizeInterfaceToBottomLeft								:= "False"


	settings.SETTINGS_CUSTOMIZATION_SKINS 												:= {}
	settings.SETTINGS_CUSTOMIZATION_SKINS.UseRecommendedFontSettings 					:= "True"
	settings.SETTINGS_CUSTOMIZATION_SKINS.FontSize 										:= "10"
	settings.SETTINGS_CUSTOMIZATION_SKINS.Preset 										:= "Path of Exile"
	settings.SETTINGS_CUSTOMIZATION_SKINS.FontQuality 									:= "4"
	settings.SETTINGS_CUSTOMIZATION_SKINS.Skin 											:= "Path of Exile"
	settings.SETTINGS_CUSTOMIZATION_SKINS.Font 											:= "Fontin SmallCaps"
	settings.SETTINGS_CUSTOMIZATION_SKINS.ScalingPercentage 							:= "100"

	settings.SETTINGS_CUSTOMIZATION_SKINS.Color_Border									:= "0x715d46"
	settings.SETTINGS_CUSTOMIZATION_SKINS.Color_Title_No_Trades							:= "0xC18F55"
	settings.SETTINGS_CUSTOMIZATION_SKINS.Color_Title_Trades							:= "0xFFFFFF"
	settings.SETTINGS_CUSTOMIZATION_SKINS.Color_Trade_Info_1							:= "0xC18F55"
	settings.SETTINGS_CUSTOMIZATION_SKINS.Color_Trade_Info_2							:= "0xFFFFFF"
	settings.SETTINGS_CUSTOMIZATION_SKINS.Color_Tab_Active								:= "0xFFFFFF"
	settings.SETTINGS_CUSTOMIZATION_SKINS.Color_Tab_Inactive							:= "0xC18F55"
	settings.SETTINGS_CUSTOMIZATION_SKINS.Color_Tab_Hover								:= "0xFFFFFF"
	settings.SETTINGS_CUSTOMIZATION_SKINS.Color_Tab_Press								:= "0xC18F55"
	settings.SETTINGS_CUSTOMIZATION_SKINS.Color_Tab_Joined_Active						:= "0xFFFFFF"
	settings.SETTINGS_CUSTOMIZATION_SKINS.Color_Tab_Joined_Inactive						:= "0xC18F55"
	settings.SETTINGS_CUSTOMIZATION_SKINS.Color_Tab_Joined_Hover						:= "0xFFFFFF"
	settings.SETTINGS_CUSTOMIZATION_SKINS.Color_Tab_Joined_Press						:= "0xC18F55"
	settings.SETTINGS_CUSTOMIZATION_SKINS.Color_Tab_Whisper_Active						:= "0xFFFFFF"
	settings.SETTINGS_CUSTOMIZATION_SKINS.Color_Tab_Whisper_Inactive					:= "0xC18F55"
	settings.SETTINGS_CUSTOMIZATION_SKINS.Color_Tab_Whisper_Hover						:= "0xFFFFFF"
	settings.SETTINGS_CUSTOMIZATION_SKINS.Color_Tab_Whisper_Press						:= "0xC18F55"
	settings.SETTINGS_CUSTOMIZATION_SKINS.Color_Button_Normal							:= "0xC18F55"
	settings.SETTINGS_CUSTOMIZATION_SKINS.Color_Button_Hover							:= "0xFFFFFF"
	settings.SETTINGS_CUSTOMIZATION_SKINS.Color_Button_Press							:= "0xC18F55"

	curPreset := INI.Get(PROGRAM.INI_FILE, "SETTINGS_CUSTOMIZATION_SKINS", "Preset")
	if (curPreset = "User Defined")
		curSkin := INI.Get(PROGRAM.INI_FILE, "SETTINGS_CUSTOMIZATION_SKINS_UserDefined", "Skin")
	else 
		curSkin := INI.Get(PROGRAM.INI_FILE, "SETTINGS_CUSTOMIZATION_SKINS_UserDefined", "Skin")

	curSkin := (curSkin && curSkin != "" && curSkin != "ERROR") ? curSkin : settings.SETTINGS_CUSTOMIZATION_SKINS.Skin
	defSkinSettings := GUI_Settings.TabCustomizationSkins_GetSkinDefaultSettings(curSkin)

	for key, value in defSkinSettings {
		if (key = "UseRecommendedFontSettings")
			value := value = 0 ? "False" : "True"

		if (value != "" && value != "ERROR")
			settings.SETTINGS_CUSTOMIZATION_SKINS[key] := value
	}

	settings.SETTINGS_CUSTOMIZATION_SKINS_UserDefined := {}
	for key, value in settings.SETTINGS_CUSTOMIZATION_SKINS
		settings.SETTINGS_CUSTOMIZATION_SKINS_UserDefined[key] := value


	settings.SETTINGS_CUSTOM_BUTTON_1 													:= {}
	settings.SETTINGS_CUSTOM_BUTTON_1.Name												:= "Ask to wait"
	settings.SETTINGS_CUSTOM_BUTTON_1.Size												:= "Small"
	settings.SETTINGS_CUSTOM_BUTTON_1.Slot												:= "1"
	settings.SETTINGS_CUSTOM_BUTTON_1.Enabled											:= "True"
	settings.SETTINGS_CUSTOM_BUTTON_1.Action_1_Type										:= "SEND_TO_BUYER"
	settings.SETTINGS_CUSTOM_BUTTON_1.Action_1_Content									:= """@%buyer% Busy in map/lab/boss/rota/etc, will msg back asap! - (%item% for %price%)"""
	settings.SETTINGS_CUSTOM_BUTTON_1.Action_2_Type										:= "FORCE_MIN"
	settings.SETTINGS_CUSTOM_BUTTON_1.Action_2_Content									:= """"""

	settings.SETTINGS_CUSTOM_BUTTON_2 													:= {}
	settings.SETTINGS_CUSTOM_BUTTON_2.Name												:= "Still interested?"
	settings.SETTINGS_CUSTOM_BUTTON_2.Size												:= "Small"
	settings.SETTINGS_CUSTOM_BUTTON_2.Slot												:= "2"
	settings.SETTINGS_CUSTOM_BUTTON_2.Enabled											:= "True"
	settings.SETTINGS_CUSTOM_BUTTON_2.Action_1_Type										:= "SEND_TO_BUYER"
	settings.SETTINGS_CUSTOM_BUTTON_2.Action_1_Content									:= """@%buyer% Hey, still interested in my %item% listed for %price%"""

	settings.SETTINGS_CUSTOM_BUTTON_3 													:= {}
	settings.SETTINGS_CUSTOM_BUTTON_3.Name												:= "Invite to Party"
	settings.SETTINGS_CUSTOM_BUTTON_3.Size												:= "Small"
	settings.SETTINGS_CUSTOM_BUTTON_3.Slot												:= "3"
	settings.SETTINGS_CUSTOM_BUTTON_3.Enabled											:= "True"
	settings.SETTINGS_CUSTOM_BUTTON_3.Action_1_Type										:= "INVITE_BUYER"
	settings.SETTINGS_CUSTOM_BUTTON_3.Action_1_Content									:= """/invite %buyer%"""
	settings.SETTINGS_CUSTOM_BUTTON_3.Action_2_Type										:= "SEND_TO_BUYER"
	settings.SETTINGS_CUSTOM_BUTTON_3.Action_2_Content									:= """@%buyer% Ready to be picked up: %item% listed for %price%"""
	settings.SETTINGS_CUSTOM_BUTTON_3.Action_3_Type										:= "SHOW_GRID"
	settings.SETTINGS_CUSTOM_BUTTON_3.Action_3_Content									:= ""

	settings.SETTINGS_CUSTOM_BUTTON_4 													:= {}
	settings.SETTINGS_CUSTOM_BUTTON_4.Name												:= "Sold already"
	settings.SETTINGS_CUSTOM_BUTTON_4.Size												:= "Small"
	settings.SETTINGS_CUSTOM_BUTTON_4.Slot												:= "4"
	settings.SETTINGS_CUSTOM_BUTTON_4.Enabled											:= "True"
	settings.SETTINGS_CUSTOM_BUTTON_4.Action_1_Type										:= "SEND_TO_BUYER"
	settings.SETTINGS_CUSTOM_BUTTON_4.Action_1_Content									:= """@%buyer% Sorry, my %item% listed for %price% is sold"""
	settings.SETTINGS_CUSTOM_BUTTON_4.Action_2_Type										:= "IGNORE_SIMILAR_TRADE"
	settings.SETTINGS_CUSTOM_BUTTON_4.Action_2_Content									:= """"""
	settings.SETTINGS_CUSTOM_BUTTON_4.Action_3_Type										:= "CLOSE_TAB"
	settings.SETTINGS_CUSTOM_BUTTON_4.Action_3_Content									:= """"""

	settings.SETTINGS_CUSTOM_BUTTON_5 													:= {}
	settings.SETTINGS_CUSTOM_BUTTON_5.Name												:= "Thank you!"
	settings.SETTINGS_CUSTOM_BUTTON_5.Size												:= "Medium"
	settings.SETTINGS_CUSTOM_BUTTON_5.Slot												:= "5"
	settings.SETTINGS_CUSTOM_BUTTON_5.Enabled											:= "True"
	settings.SETTINGS_CUSTOM_BUTTON_5.Action_1_Type										:= "SEND_TO_BUYER"
	settings.SETTINGS_CUSTOM_BUTTON_5.Action_1_Content									:= """@%buyer% Thank you & good luck!"""
	settings.SETTINGS_CUSTOM_BUTTON_5.Action_2_Type										:= "KICK_BUYER"
	settings.SETTINGS_CUSTOM_BUTTON_5.Action_2_Content									:= """/kick %buyer%"""
	settings.SETTINGS_CUSTOM_BUTTON_5.Action_3_Type										:= "SAVE_TRADE_STATS"
	settings.SETTINGS_CUSTOM_BUTTON_5.Action_3_Content									:= """"""
	settings.SETTINGS_CUSTOM_BUTTON_5.Action_4_Type										:= "CLOSE_TAB"
	settings.SETTINGS_CUSTOM_BUTTON_5.Action_4_Content									:= """"""

	Loop 4 {
		index := 5+A_Index
		settings["SETTINGS_CUSTOM_BUTTON_" index]										:= {}
		settings["SETTINGS_CUSTOM_BUTTON_" index].Name 									:= "[ Untitled button ]"
		settings["SETTINGS_CUSTOM_BUTTON_" index].Size 									:= "Small"
		settings["SETTINGS_CUSTOM_BUTTON_" index].Slot 									:= index
		settings["SETTINGS_CUSTOM_BUTTON_" index].Enabled 								:= "False"
	}

	settings.SETTINGS_SPECIAL_BUTTON_1													:= {} 
	settings.SETTINGS_SPECIAL_BUTTON_1.Slot												:= "1"
	settings.SETTINGS_SPECIAL_BUTTON_1.Type												:= "Clipboard"
	settings.SETTINGS_SPECIAL_BUTTON_1.Enabled											:= "True"

	settings.SETTINGS_SPECIAL_BUTTON_2													:= {} 
	settings.SETTINGS_SPECIAL_BUTTON_2.Slot												:= "2"
	settings.SETTINGS_SPECIAL_BUTTON_2.Type												:= "Whisper"
	settings.SETTINGS_SPECIAL_BUTTON_2.Enabled											:= "True"

	settings.SETTINGS_SPECIAL_BUTTON_3													:= {} 
	settings.SETTINGS_SPECIAL_BUTTON_3.Slot												:= "3"
	settings.SETTINGS_SPECIAL_BUTTON_3.Type												:= "Invite"
	settings.SETTINGS_SPECIAL_BUTTON_3.Enabled											:= "True"

	settings.SETTINGS_SPECIAL_BUTTON_4													:= {} 
	settings.SETTINGS_SPECIAL_BUTTON_4.Slot												:= "4"
	settings.SETTINGS_SPECIAL_BUTTON_4.Type												:= "Trade"
	settings.SETTINGS_SPECIAL_BUTTON_4.Enabled											:= "True"

	settings.SETTINGS_SPECIAL_BUTTON_5													:= {} 
	settings.SETTINGS_SPECIAL_BUTTON_5.Slot												:= "5"
	settings.SETTINGS_SPECIAL_BUTTON_5.Type												:= "Kick"
	settings.SETTINGS_SPECIAL_BUTTON_5.Enabled											:= "True"

	settings.SETTINGS_HOTKEY_1 															:= {}
	settings.SETTINGS_HOTKEY_1.Enabled 													:= "True"
	settings.SETTINGS_HOTKEY_1.Hotkey 													:= "F2"
	settings.SETTINGS_HOTKEY_1.Type 													:= "SENDINPUT"
	settings.SETTINGS_HOTKEY_1.Content 													:= """{Enter}/hideout{Enter}"""

	settings.SETTINGS_HOTKEY_ADV_1														:= {}
	settings.SETTINGS_HOTKEY_ADV_1.Name 												:= "Kick myself out of party + hideout"
	settings.SETTINGS_HOTKEY_ADV_1.Hotkey 												:= ""
	settings.SETTINGS_HOTKEY_ADV_1.Action_1_Type 										:= "SENDINPUT"
	settings.SETTINGS_HOTKEY_ADV_1.Action_1_Content 									:= """{Enter}/kick MyMainChar{Enter}"""
	settings.SETTINGS_HOTKEY_ADV_1.Action_2_Type 										:= "SENDINPUT"
	settings.SETTINGS_HOTKEY_ADV_1.Action_2_Content 									:= """{Enter}/kick MySecondChar{Enter}"""
	settings.SETTINGS_HOTKEY_ADV_1.Action_3_Type 										:= "CMD_HIDEOUT"
	settings.SETTINGS_HOTKEY_ADV_1.Action_3_Content 									:= """/hideout"""

	hw := A_DetectHiddenWindows
	DetectHiddenWindows, On
	WinGet, fileProcessName, ProcessName,% "ahk_pid " DllCall("GetCurrentProcessId")
	DetectHiddenWindows, %hw%
	settings.UPDATING 																	:= {}
	settings.UPDATING.PID 																:= DllCall("GetCurrentProcessId")
	settings.UPDATING.FileName 															:= A_ScriptName
	settings.UPDATING.FileProcessName 													:= fileProcessName
	settings.UPDATING.ScriptHwnd 														:= A_ScriptHwnd
	settings.UPDATING.Version 															:= PROGRAM.VERSION
	settings.UPDATING.UseBeta															:= "False"
	settings.UPDATING.CheckForUpdatePeriodically 										:= "OnStartAndEveryFiveHours"
	settings.UPDATING.LastUpdateCheck 													:= "19940426000000"
	settings.UPDATING.DownloadUpdatesAutomatically 										:= "True"

	return settings
}

LocalSettings_IsValueValid(iniSect, iniKey, iniValue) {
	global PROGRAM

	isFirstTimeRunning := INI.Get(PROGRAM.INI_FILE, "GENERAL", "IsFirstTimeRunning")

	if (iniSect = "GENERAL") {
		if IsIn(iniKey, "IsFirstTimeRunning,AddShowGridActionToInviteButtons,HasAskedForImport,RemoveCopyItemInfosIfGridActionExists")
			isValueValid := IsIn(iniValue, "True,False") ? True : False	
	}

	if (iniSect = "SETTINGS_MAIN") {
		if (iniKey = "TradingWhisperSFXPath") {
			sfxToggle := INI.Get(PROGRAM.INI_FILE, iniSect, "TradingWhisperSFXToggle")
			isValueValid := FileExist(iniValue) || (!iniValue && sfxToggle="False") ? True : False	
		}
		else if (iniKey = "RegularWhisperSFXPath") {
			sfxToggle := INI.Get(PROGRAM.INI_FILE, iniSect, "RegularWhisperSFXToggle")
			isValueValid := FileExist(iniValue) || (!iniValue && sfxToggle="False") || (iniValue = "") ? True : False	
		}
		else if (iniKey = "BuyerJoinedAreaSFXPath") {
			sfxToggle := INI.Get(PROGRAM.INI_FILE, iniSect, "BuyerJoinedAreaSFXToggle")
			isValueValid := FileExist(iniValue) || (!iniValue && sfxToggle="False") || (iniValue = "") ? True : False	
		}
		else if (iniKey = "TradingWhisperSFXToggle")
			isValueValid := IsIn(iniValue, "True,False") ? True : False	
		else if (iniKey = "RegularWhisperSFXToggle")
			isValueValid := IsIn(iniValue, "True,False") ? True : False	
		else if (iniKey = "BuyerJoinedAreaSFXToggle")
			isValueValid := IsIn(iniValue, "True,False") ? True : False	

		else if (iniKey = "NoTabsTransparency")
			isValueValid := IsBetween(iniValue, 0, 100) ? True : False	
		else if (iniKey = "TabsOpenTransparency")
			isValueValid := IsBetween(iniValue, 30, 100) ? True : False	
		else if (iniKey = "HideInterfaceWhenOutOfGame")
			isValueValid := IsIn(iniValue, "True,False") ? True : False	
		else if (iniKey = "CopyItemInfosOnTabChange")
			isValueValid := IsIn(iniValue, "True,False") ? True : False	
		else if (iniKey = "AutoFocusNewTabs")
			isValueValid := IsIn(iniValue, "True,False") ? True : False	
		else if (iniKey = "AutoMinimizeOnAllTabsClosed")
			isValueValid := IsIn(iniValue, "True,False") ? True : False	
		else if (iniKey = "AutoMaximizeOnFirstNewTab")
			isValueValid := IsIn(iniValue, "True,False") ? True : False	
		else if (iniKey = "SendTradingWhisperUponCopyWhenHoldingCTRL")
			isValueValid := IsIn(iniValue, "True,False") ? True : False	
		else if (iniKey = "TradesGUI_Mode")
			isValueValid := IsIn(iniValue, "Window,Dock") ? True : False	
		else if (iniKey = "Pos_X")
			isValueValid := IsNum(iniValue) ? True : False	
		else if (iniKey = "Pos_Y")
			isValueValid := IsNum(iniValue) ? True : False	
		else if (iniKey = "TradesGUI_Locked")
			isValueValid := IsIn(iniValue, "True,False") ? True : False	
		else if (iniKey = "AllowClicksToPassThroughWhileInactive")
			isValueValid := IsIn(iniValue, "True,False") ? True : False	
		else if (iniKey = "SendMsgMode")
			isValueValid := IsIn(iniValue, "Clipboard,SendInput,SendEvent") ? True : False
		else if (iniKey = "ShowTabbedTrayNotificationOnWhisper")
			isValueValid := IsIn(iniValue, "True,False") ? True : False	
		else if (iniKey = "PushBulletOnlyWhenAfk")
			isValueValid := IsIn(iniValue, "True,False") ? True : False	
		else if IsIn(iniKey, "PushBulletOnTradingWhisper,PushBulletOnPartyMessage,PushBulletOnWhisperMessage")
			isValueValid := IsIn(iniValue, "True,False") ? True : False
		else if (iniKey = "PushBulletToken")
			isValueValid := True
		else if (iniKey = "PoeAccounts")
			isValueValid := True
		else if (iniKey = "MinimizeInterfaceToBottomLeft")
			isValueValid := IsIn(iniValue, "True,False") ? True : False	
	}

	else if IsIn(iniSect, "SETTINGS_CUSTOMIZATION_SKINS,SETTINGS_CUSTOMIZATION_SKINS_UserDefined") {
		if (iniKey = "UseRecommendedFontSettings")
			isValueValid := IsIn(iniValue, "True,False") ? True : False	
		else if (iniKey = "FontSize")
			isValueValid := IsNum(iniValue) ? True : False	
		else if (iniKey = "Preset") {
			skinsList := GUI_Settings.TabCustomizationSkins_GetAvailablePresets()
			skinsList := StrReplace(skinsList, "|", ",")
			isValueValid := IsIn(iniValue, skinsList) ? True : False	
		}
		else if (iniKey = "FontQuality")
			isValueValid := IsNum(iniValue) ? True : False	
		else if (iniKey = "Skin") {
			skinsList := GUI_Settings.TabCustomizationSkins_GetAvailablePresets()
			skinsList := StrReplace(skinsList, "|", ",")
			isValueValid := IsIn(iniValue, skinsList) ? True : False	
		}
		else if (iniKey = "Font") {
			fontsList := GUI_Settings.TabCustomizationSkins_GetAvailableFonts()
			fontsList := StrReplace(fontsList, "|", ",")
			isValueValid := IsIn(iniValue, fontsList) ? True : False	
		}
		else if (iniKey = "ScalingPercentage")
			isValueValid := IsNum(iniValue) ? True : False
		
		else if IsContaining(iniKey, "Color_") {
			isValueValid := IsHex(iniValue) && (StrLen(iniValue) = 8) ? True : False
		}
	}

	else if IsContaining(iniSect, "SETTINGS_CUSTOM_BUTTON_") {
		if (iniKey = "Name")
			isValueValid := iniValue ? True : False	
		else if (iniKey = "Size")
			isValueValid := IsIn(iniValue, "Small,Medium,Large") ? True : False	
		else if (iniKey = "Slot")
			isValueValid := IsBetween(iniValue, 1, 9) ? True : False	
		else if (iniKey = "Enabled")
			isValueValid := IsIn(iniValue, "True,False") ? True : False	
		else if RegExMatch(iniKey, "Action_.*_Type") ; TO_DO: Maybe check if the action is in our list?
			isValueValid := True
		else if RegExMatch(iniKey, "Action_.*_Content") ; TO_DO: Not sure
			isValueValid := True
	}

	else if IsContaining(iniSect, "SETTINGS_SPECIAL_BUTTON_") {
		if (iniKey = "Slot")
			isValueValid := IsBetween(iniValue, 1, 5) ? True : False
		else if (iniKey = "Type")
			isValueValid := IsIn(iniValue, "Clipboard,Whisper,Invite,Trade,Kick") ? True : False
		else if (iniKey = "Enabled")
			isValueValid := IsIn(iniValue, "True,False") ? True : False
	}

	else if IsContaining(iniSect, "SETTINGS_HOTKEY_") {
		/*
		if (iniKey = "Enabled")
			isValueValid := IsIn(iniValue, "True,False") ? True : False
		if (iniKey = "Hotkey")
			isValueValid := True
		if (iniKey = "Type") ; TO_DO: Maybe check if the action is in our list?
			isValueValid := True
		if (iniKey = "Content")
			isValueValid := True
		*/
		isValueValid := isFirstTimeRunning="True"?False:True
	}

	else if IsContaining(iniSect, "SETTINGS_HOTKEY_ADV_") {
		isValueValid := isFirstTimeRunning="True"?False:True
	}

	else if (iniSect = "UPDATING") {
		if (iniKey = "CheckForUpdatePeriodically")
			isValueValid := IsIn(iniValue, "OnStartOnly,OnStartAndEveryFiveHours,OnStartAndEveryDay") ? True : False
		; if (iniKey = "CheckForUpdateCondition")
		; 	isValueValid := True
		; else if (iniKey = "FileName")
		; 	isValueValid := True
		else if (iniKey = "LastUpdateCheck") {
			FormatTime, timeF, %iniValue%, yyyyMMddhhmmss
			isValueValid := (iniValue > A_Now || timeF > A_Now || StrLen(iniValue) != 14)?False : True
		}
		; else if (iniKey = "PID")
		; 	isValueValid := True
		else if IsIn(iniKey, "UseBeta,DownloadUpdatesAutomatically")
			isValueValid := IsIn(iniValue,"True,False") ? True : False
		; else if (iniKey = "Version")
		; 	isValueValid := True
		else
			isValueValid := True
	}

	if (isValueValid = "") {
		MsgBox %A_ThisFunc%(): Couldn't find if statement for:`niniSect: %iniSect%`niniKey: %iniKey%`niniValue: %iniValue%
	}

	return isValueValid
}

Restore_LocalSettings(iniSect, iniKey="") {
	global PROGRAM
	iniFile := PROGRAM.INI_FILE

	defSettings := Get_LocalSettings_DefaultValues()

	if (iniKey = "") { ; Replace entire section
		for key, value in PROGRAM.SETTINGS[iniSect]
			INI.Remove(iniFile, iniSect, key)

		for key, value in defSettings[iniSect]
			INI.Set(iniFile, iniSect, key, value)
	}
	else {
		INI.Set(iniFile, iniSect, iniKey, defSettings[iniSect][iniKey])
	}
}

Set_LocalSettings() {
	global PROGRAM
	iniFile := PROGRAM.INI_FILE

	if !FileExist(iniFile)
		FileAppend,`n,% iniFile

	settingsDefaultValues := Get_LocalSettings_DefaultValues()
	sectsOrder := settingsDefaultValues.SECTIONS_ORDER
	localSettings := Get_LocalSettings()

	isFirstTimeRunning := localSettings.GENERAL.IsFirstTimeRunning
	if !LocalSettings_IsValueValid("GENERAL", "IsFirstTimeRunning", isFirstTimeRunning) {
		Restore_LocalSettings("GENERAL", "IsFirstTimeRunning")
		isFirstTimeRunning := INI.Get(iniFile, "GENERAL", "IsFirstTimeRunning")
	}

	Restore_LocalSettings("UPDATING", "ScriptHwnd")
	Restore_LocalSettings("UPDATING", "FileProcessName")
	Restore_LocalSettings("UPDATING", "FileName")
	Restore_LocalSettings("UPDATING", "PID")

	Loop 5 {
		btnIndex := A_Index
		for key, value in localSettings["SETTINGS_CUSTOM_BUTTON_" A_Index]
			doesCustBtn%btnIndex%Exist := True
	}

	; Set the order to go through sections
	order := ""
	Loop, Parse, sectsOrder,% ","
	{
		loopedSect := A_LoopField
		for iniSect, nothing in settingsDefaultValues {
			if IsContaining(iniSect, loopedSect) && !IsIn(iniSect, order)
				order .= iniSect ","
		}
	}
	StringTrimRight, order, order, 1
	; Make sure each value is valid
	Loop, Parse, order,% ","
	{
		iniSect := A_LoopField
		for iniKey, defValue in settingsDefaultValues[iniSect] {
			iniValue := localSettings[iniSect][iniKey]
			isValueValid := LocalSettings_IsValueValid(iniSect, iniKey, iniValue)
			if RegExMatch(iniSect, "O)SETTINGS_CUSTOM_BUTTON_(.*)", iniSectPat) && IsBetween(iniSectPat.1, 1, 5) {
				iniSectNum := iniSectPat.1
				isValueValid := doesCustBtn%iniSectNum%Exist=True?True:False
			}

			if (!isValueValid) {
				if (IsFirstTimeRunning != "True" && !IsIn(iniKey, "IsFirstTimeRunning,AddShowGridActionToInviteButtons,RemoveCopyItemInfosIfGridActionExists"))
					warnMsg .= "Section: " iniSect "`nKey: " iniKey "`nValue: " iniValue "`nDefault value: " defValue "`n`n"
				Restore_LocalSettings(iniSect, iniKey)
			}
		}
	}
	; Show which values were restored to default
	if (warnMsg) {
		Gui, ErrorLog:New, +AlwaysOnTop +ToolWindow +hwndhGuiErrorLog
		Gui, ErrorLog:Add, Text, x10 y10,% "One or multiple ini entries were deemed invalid and were reset to their default value."
		Gui, ErrorLog:Add, Edit, xp y+5 w500 R25 ReadOnly,% warnMsg
		Gui, ErrorLog:Add, Link, xp y+5,% "If you need assistance, you can contact me on: "
		. "<a href=""" PROGRAM.LINK_GITHUB """>GitHub</a> - <a href=""" PROGRAM.LINK_REDDIT """>Reddit</a> - <a href=""" PROGRAM.LINK_GGG """>PoE Forums</a> - <a href=""" PROGRAM.LINK_DISCORD """>Discord</a>"
		Gui, ErrorLog:Show,xCenter yCenter,% PROGRAM.NAME " - Error log"
		WinWait, ahk_id %hGuiErrorLog%
		WinWaitClose, ahk_id %hGuiErrorLog%
	}
}

Get_LocalSettings() {
	global PROGRAM
	iniFile := PROGRAM.INI_FILE
	settingsObj := {}

	Loop, Parse,% INI.Get(iniFile), "`n"
	{
		settingsObj[A_LoopField] := {}

		arr := INI.Get(iniFile, A_LoopField,,1)
		for key, value in arr {
			isActionContent := RegExMatch(A_LoopField, "SETTINGS_CUSTOM_BUTTON_.*") && RegExMatch(key, "Action_.*_Content") ? True
				: RegExMatch(A_LoopField, "SETTINGS_HOTKEY_ADV_.*") && RegExMatch(key, "Action_.*_Content") ? True
				: RegExMatch(A_LoopField, "SETTINGS_HOTKEY_.*") && key="Content" ? True
				: False

			if (isActionContent) {
				StringTrimLeft, value, value, 1
				StringTrimRight, value, value, 1
			}
			settingsObj[A_LoopField][key] := value
		}
	}

	/*	No longer used
	PROGRAM.OS := {}
	PROGRAM.OS.RESOLUTION_DPI := Get_DpiFactor()
	*/

	return settingsObj
}

Update_LocalSettings() {
	global PROGRAM
	iniFile := PROGRAM.INI_FILE

	priorVer := Ini.Get(iniFile, "UPDATING", "Version", "UNKNOWN")
	priorVerNum := (priorVer="UNKNOWN")?(PROGRAM.Version):(priorVer)
	subVersions := StrSplit(priorVerNum, ".")
	mainVer := subVersions[1], releaseVer := subVersions[2], patchVer := subVersions[3]

	localSettings := Get_LocalSettings()

	Restore_LocalSettings("UPDATING", "Version")

	if (localSettings.GENERAL.AddShowGridActionToInviteButtons = "True") {
		AppendToLogs(A_ThisFunc "(): AddShowGridActionToInviteButtons detected as True."
		. "`n" "Adding SHOW_GRID action to all buttons containing the INVITE_BUYER action.")
		Loop {
			cbIndex := A_Index
			loopedSetting := localSettings["SETTINGS_CUSTOM_BUTTON_" cbIndex]
			if IsObject(loopedSetting) {
				hasInvite := False, hasGrid := False
				Loop {
					loopActionIndex := A_Index
					loopedActionContent := loopedSetting["Action_" loopActionIndex "_Content"]
					loopedActionType := loopedSetting["Action_" loopActionIndex "_Type"]

					if (!loopedActionType) || (loopedActionType = "") || (loopActionIndex > 50)
						Break
					
					else if IsContaining(loopedActionContent, "/invite %buyer%") || IsContaining(loopedActionContent, "/invite %buyerName%")
					|| (loopedActionType = "INVITE_BUYER")
						hasInvite := True

					else if (loopedActionType = "SHOW_GRID")
						hasGrid := True
				}
				if (hasInvite = True && hasGrid = False) {
					AppendToLogs(A_ThisFunc "(): Adding SHOW_GRID action to button with"
					. "`n" "ID: """ cbIndex """ - Action index: """ loopActionIndex """")
					INI.Set(iniFile, "SETTINGS_CUSTOM_BUTTON_" cbIndex, "Action_" loopActionIndex "_Content", "")
					INI.Set(iniFile, "SETTINGS_CUSTOM_BUTTON_" cbIndex, "Action_" loopActionIndex "_Type", "SHOW_GRID")
				}
			}
			else if (cbIndex > 20)
				Break
			else
				Break
		}
		AppendToLogs(A_ThisFunc "(): Finished adding SHOW_GRID action.")
		INI.Set(iniFile, "GENERAL", "AddShowGridActionToInviteButtons", "False")
	}

	if (localSettings.GENERAL.RemoveCopyItemInfosIfGridActionExists = "True") {
		AppendToLogs(A_ThisFunc "(): RemoveCopyItemInfosIfGridActionExists detected as True."
		. "`n" "Removing COPY_ITEM_INFOS action to all buttons containing the SHOW_GRID action.")
		Loop {
			cbIndex := A_Index
			loopedSetting := localSettings["SETTINGS_CUSTOM_BUTTON_" cbIndex]
			if IsObject(loopedSetting) {
				hasCopy := False, hasGrid := False
				Loop {
					loopActionIndex := A_Index
					loopedActionContent := loopedSetting["Action_" loopActionIndex "_Content"]
					loopedActionType := loopedSetting["Action_" loopActionIndex "_Type"]

					if (!loopedActionType) || (loopedActionType = "") || (loopActionIndex > 50) {
						loopActionIndex--
						Break
					}
					
					else if (loopedActionType = "COPY_ITEM_INFOS")
						hasCopy := True, copyActionIndex := loopActionIndex

					else if (loopedActionType = "SHOW_GRID")
						hasGrid := True, gridActionIndex:= loopActionIndex
				}
				if (hasCopy = True && hasGrid = True) {
					AppendToLogs(A_ThisFunc "(): Removing COPY_ITEM_INFOS action to button with"
					. "`n" "ID: """ cbIndex """ - Action index: """ loopActionIndex """. Action ID: """ copyActionIndex """")

					; Reduce action num by one, for every action after COPY_ITEM_INFOS
					startReplaceIndex := copyActionIndex
					Loop % loopActionIndex - copyActionIndex {
						INI.Set(iniFile, "SETTINGS_CUSTOM_BUTTON_" cbIndex, "Action_" startReplaceIndex "_Content", """" loopedSetting["Action_" startReplaceIndex+1 "_Content"] """")
						INI.Set(iniFile, "SETTINGS_CUSTOM_BUTTON_" cbIndex, "Action_" startReplaceIndex "_Type", loopedSetting["Action_" startReplaceIndex+1 "_Type"])
						startReplaceIndex++

						AppendToLogs(A_ThisFunc "(): Reducing action index by one for button with"
						. "`n" "ID: """ cbIndex """ - Action index: """ loopActionIndex """. Action ID: """ startReplaceIndex+1 """")
					}
					; Remove COPY_ITEM_INFOS action
					INI.Remove(iniFile, "SETTINGS_CUSTOM_BUTTON_" cbIndex, "Action_" loopActionIndex "_Content")
					INI.Remove(iniFile, "SETTINGS_CUSTOM_BUTTON_" cbIndex, "Action_" loopActionIndex "_Type")					
				}
			}
			else if (cbIndex > 20)
				Break
			else
				Break
		}
		AppendToLogs(A_ThisFunc "(): Finished removing COPY_ITEM_INFOS action to buttons with SHOW_GRID action.")
		INI.Set(iniFile, "GENERAL", "RemoveCopyItemInfosIfGridActionExists", "False")
	}
	
	if (localSettings.GENERAL.IsFirstTimeRunning = "True") {
		AppendToLogs(A_ThisFunc "(): IsFirstTimeRunning detected as True")
		
		if (PROGRAM.IS_BETA = "True")
			GUI_BetaTasks.Show()

		INI.Set(iniFile, "GENERAL", "IsFirstTimeRunning", "False")
	}
}

Declare_LocalSettings(settingsObj="") {
	global PROGRAM

	if (settingsObj = "")
		settingsObj := Get_LocalSettings()

	PROGRAM["SETTINGS"] := {}

	for iniSection, nothing in settingsObj {
		PROGRAM["SETTINGS"][iniSection] := {}
		for iniKey, iniValue in settingsObj[iniSection]
			PROGRAM["SETTINGS"][iniSection][iniKey] := iniValue
	}
}