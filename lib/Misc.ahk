Get_CurrencyInfos(currency, dontWriteLogs=False) {
/*		Compare the specified currency with poe.trade abridged currency names to retrieve the real currency name.
		When the string is plural, check if the full list of currencies contains its non-plural counterpart.
 */
 	global PROGRAM
	isCurrencyListed := False

	if RegExMatch(currency, "See Offer") {
		Return {Name:currency, Is_Listed:False}
	}
	else if (!currency || currency = "" || currency = " ")
		return {Name:currency, Is_Listed:False}

	currency := RegExReplace(currency, "\d")
	AutoTrimStr(currency) ; Remove whitespaces
	lastChar := SubStr(currency, 0) ; Get last char
	if (lastChar = "s") ; poeapp adds an "s" for >1 currencies
		StringTrimRight, currencyWithoutS, currency, 1

	if RegExMatch(currency, "O) Map$", pat) ; If ends with map
        StringTrimRight, currencyWithoutMap, currency,% StrLen(pat.0) ; Remove it from name

	currencyToCheckList := []
	currencyToCheckList.Push(currency)
	if (currencyWithoutS)
		currencyToCheckList.Push(currencyWithoutS)
	if (currencyWithoutMap)
		currencyToCheckList.Push(currencyWithoutMap)

	isCurrencyListed := False, currencyFullName := ""
	Loop % currencyToCheckList.MaxIndex() {
		thisCurrency := currencyToCheckList[A_Index]
		if !IsIn(thisCurrency, PROGRAM.DATA.CURRENCY_LIST) {
			currencyFullName := PROGRAM.DATA.POETRADE_CURRENCY_DATA[thisCurrency] ? PROGRAM.DATA.POETRADE_CURRENCY_DATA[thisCurrency]
				:	PROGRAM.DATA.POEDOTCOM_CURRENCY_DATA[thisCurrency] ? PROGRAM.DATA.POEDOTCOM_CURRENCY_DATA[thisCurrency]
				:	""
			isCurrencyListed := currencyFullName?True:False
		}
		else { ; Currency is in list
			isCurrencyListed := True, currencyFullName := thisCurrency
		}

		if (isCurrencyListed=True)
			Break
	}
	if (!currencyFullName && dontWriteLogs=False) ; Unknown currency name
		AppendToLogs(A_ThisFunc "(currency=" currency "): Unknown currency name.")

	Return {Name:currencyFullName, Is_Listed:isCurrencyListed}
}

Do_Action(actionType, actionContent="", isHotkey=False, uniqueNum="") {
	global PROGRAM, GuiTrades, GuiTrades_Controls
	static prevNum, ignoreFollowingActions, prevActionType, prevActionContent
	activeTab := GuiTrades.Active_Tab

	tabContent := isHotkey ? "" : GUI_Trades.GetTabContent(activeTab)
	tabPID := isHotkey ? "" : tabContent.PID

	WRITE_SEND_ACTIONS := "SEND_MSG,SEND_TO_BUYER,SEND_TO_LAST_WHISPER,SEND_TO_LAST_WHISPER_SENT"
						. ",INVITE_BUYER,TRADE_BUYER,KICK_BUYER,KICK_MYSELF,WHOIS_SELLER"
						. ",CMD_AFK,CMD_AUTOREPLY,CMD_DND,CMD_HIDEOUT,CMD_OOS,CMD_REMAINING"

	WRITE_DONT_SEND_ACTIONS := "WRITE_MSG,WRITE_TO_BUYER,WRITE_TO_LAST_WHISPER,WRITE_TO_LAST_WHISPER_SENT,CMD_WHOIS"

	WRITE_GO_BACK_ACTIONS := "WRITE_THEN_GO_BACK"

	if (uniqueNum) && (uniqueNum = prevNum) && (ignoreFollowingActions) {
		prevNum := uniqueNum, ignoreFollowingActions := False
		AppendToLogs(A_thisFunc "(actionType=" actionType ", actionContent=" actionContent ", isHotkey=" isHotkey ", uniqueNum=" uniqueNum "): Action ignored."
		. "`n" "ignoreFollowingActions=""" ignoreFollowingActions """, prevActionType=""" prevActionType """, prevActionContent=""" prevActionContent """.")
		Return
	}


	global ACTIONS_FORCED_CONTENT
	if (ACTIONS_FORCED_CONTENT[actionType]) && !(actionContent)
		actionContent := ACTIONS_FORCED_CONTENT[actionType]

	actionContentWithVariables := Replace_TradeVariables(actionContent)
	StringSplit, contentWords, actionContentWithVariables,% A_Space
	if ( SubStr(actionContentWithVariables, 1, 2) = "@ ") {
		trayMsg := StrReplace(PROGRAM.TRANSLATIONS.TrayNotifications.MessageCanceledVarEmpty_Msg, "%name%", contentWords1)
		trayMsg := StrReplace(trayMsg, "%variable%", actionContent)
		TrayNotifications.Show(PROGRAM.TRANSLATIONS.TrayNotifications.MessageCanceled_Title, trayMsg)
		return
	}
	else if ( SubStr(contentWords1, 2, 1) = "%" || SubStr(contentWords1, 0, 1) = "%" ) {
		trayMsg := StrReplace(PROGRAM.TRANSLATIONS.TrayNotifications.MessageCanceledVarTypo_Msg, "%variable%", actionContent)
		TrayNotifications.Show(PROGRAM.TRANSLATIONS.TrayNotifications.MessageCanceled_Title, trayMsg)
		return
	}

	if IsIn(prevActionType, "COPY_ITEM_INFOS,WRITE_SEND,WRITE_DONT_SEND,WRITE_GO_BACK,SENDINPUT,SENDINPUT_RAW,SENDEVENT,SENDEVENT_RAW") {
		; AppendToLogs(A_thisFunc "(actionType=" actionType ", actionContent=" actionContent ", isHotkey=" isHotkey ", uniqueNum=" uniqueNum "):"
		; . "Sleeping for 10ms due to previous action (" prevActionType ") being listed as using the clipboard.")
		Sleep 10
	}

	if IsContaining(actionType, "CUSTOM_BUTTON_") {
		RegExMatch(actionType, "\D+", actionType_NoNum)
		RegExMatch(actionType, "\d+", actionType_NumOnly)

		GUI_Trades.DoTradeButtonAction(actionType_NumOnly, "Custom")

		; ControlClick,,% "ahk_id " GuiTrades.Handle " ahk_id " GuiTrades_Controls["hBTN_Custom" actionType_NumOnly],,,, NA
	}

	else if IsIn(actionType, WRITE_SEND_ACTIONS) {
		if (actionType = "KICK_MYSELF") {
			if (!PROGRAM.SETTINGS.SETTINGS_MAIN.PoeAccounts)
				TrayNotifications.Show(PROGRAM.TRANSLATIONS.TrayNotifications.FailedToKickSelf_Title, PROGRAM.TRANSLATIONS.TrayNotifications.FailedToKickSelf_Msg)
			else
				Send_GameMessage("WRITE_SEND", actionContentWithVariables, tabPID)
		}
		else
			Send_GameMessage("WRITE_SEND", actionContentWithVariables, tabPID)
	}
	else if IsIn(actionType, WRITE_DONT_SEND_ACTIONS) {
		Send_GameMessage("WRITE_DONT_SEND", actionContentWithVariables, tabPID)
		ignoreFollowingActions := True
	}
	else if IsIn(actionType, WRITE_GO_BACK_ACTIONS) {
		Send_GameMessage("WRITE_GO_BACK", actionContentWithVariables, tabPID)
		ignoreFollowingActions := True
	}

	else if (actionType = "COPY_ITEM_INFOS")
		GoSub, GUI_Trades_CopyItemInfos_CurrentTab_Timer
	else if (actionType = "GO_TO_NEXT_TAB")
		GUI_Trades.SelectNextTab()
	else if (actionType = "GO_TO_PREVIOUS_TAB")
		GUI_Trades.SelectPreviousTab()
	else if (actionType = "CLOSE_TAB")
		GUI_Trades.RemoveTab(activeTab)
	else if (actionType = "TOGGLE_MIN_MAX")
		GUI_Trades.Toggle_MinMax()
	else if (actionType = "FORCE_MIN")
		GUI_Trades.Minimize()
	else if (actionType = "FORCE_MAX")
		GUI_Trades.Maximize()
	else if (actionType = "SAVE_TRADE_STATS")
		GUI_Trades.SaveStats(activeTab)
	else if (actionType = "SHOW_LEAGUE_SHEETS")
		GUI_TradesBuyCompact.HotBarButton("LeagueHelp")

	else if (actionType = "SLEEP")
		Sleep %actionContentWithVariables%
	else if (actionType = "SENDINPUT")
		SendInput,%actionContentWithVariables%
	else if (actionType = "SENDINPUT_RAW")
		SendInput,{Raw}%actionContentWithVariables%
	else if (actionType = "SENDEVENT")
		SendEvent,%actionContentWithVariables%
	else if (actionType = "SENDEVENT_RAW")
		SendEvent,{Raw}%actionContentWithVariables%
	else if (actionType = "IGNORE_SIMILAR_TRADE")
		GUI_Trades.AddActiveTrade_To_IgnoreList()
	else if (actionType = "CLOSE_SIMILAR_TABS")
		GUI_Trades.CloseOtherTabsForSameItem()
	else if (actionType = "SHOW_GRID")
		GUI_Trades.ShowActiveTabItemGrid()

	prevNum := uniqueNum, prevActionType := actionType, prevActionContent := actionContentWithVariables
}

Get_Changelog(removeTrails=False) {
	global PROGRAM

	if (PROGRAM.IS_BETA = "True")
		FileRead, changelog,% PROGRAM.CHANGELOG_FILE_BETA
	else
		FileRead, changelog,% PROGRAM.CHANGELOG_FILE

	if (removeTrails=True) {
		changelog := StrReplace(changelog, A_Tab, "")
		AutoTrimStr(changelog)
	}

	len := StrLen(changelog)
	if ( len > 60000 ) {
		trim := len - 60000
		StringTrimRight, changelog, changelog, %trim%
		changelog .= "`n`n`n[ Changelog file trimmed. See full changelog file GitHub ]"
	}

	return changelog
}

Set_Clipboard(str) {
	global PROGRAM
	global SET_CLIPBOARD_CONTENT

	Clipboard := ""
	Sleep 10
	Clipboard := str
	ClipWait, 2, 1
	if (ErrorLevel) {
		trayMsg := StrReplace(PROGRAM.TRANSLATIONS.TrayNotifications.ClipboardFailedToUpdate_Msg, "%message%", str)
		TrayNotifications.Show(PROGRAM.TRANSLATIONS.TrayNotifications.ClipboardFailedToUpdate_Title, trayMsg)
		return 1
	}
	SET_CLIPBOARD_CONTENT := str
	Sleep 20
}

Reset_Clipboard() {
	global SET_CLIPBOARD_CONTENT
	if (Clipboard = SET_CLIPBOARD_CONTENT)
		Clipboard := ""
}

Replace_TradeVariables(string) {
	global PROGRAM, GuiTrades
	static lastCharacterLogged, timeSinceRetrievedChar
	activeTab := GuiTrades.Active_Tab

	tabContent := Gui_Trades.GetTabContent(activeTab)

	string := StrReplace(string, "%buyer%", tabContent.Buyer)
	string := StrReplace(string, "%buyerName%", tabContent.Buyer)
	string := StrReplace(string, "%item%", tabContent.Item)
	string := StrReplace(string, "%itemName%", tabContent.Item)
	string := StrReplace(string, "%price%", tabContent.Price != ""?tabContent.Price : "[unpriced]")
	string := StrReplace(string, "%itemPrice%", tabContent.Price != ""?tabContent.Price : "[unpriced]")

	string := StrReplace(string, "%lastWhisper%", GuiTrades.Last_Whisper_Name)
	string := StrReplace(string, "%lastWhisperReceived%", GuiTrades.Last_Whisper_Name)
	string := StrReplace(string, "%lwr%", GuiTrades.Last_Whisper_Name)

	string := StrReplace(string, "%sentWhisper%", GuiTrades.Last_Whisper_Sent_Name)
	string := StrReplace(string, "%lastWhisperSent%", GuiTrades.Last_Whisper_Sent_Name)
	string := StrReplace(string, "%lws%", GuiTrades.Last_Whisper_Sent_Name)

	firstAcc := StrSplit(PROGRAM.SETTINGS.SETTINGS_MAIN.PoeAccounts, ",").1
	if IsContaining(string, "%myself%") {
		if (!lastCharacterLogged) {
			poeLoggedChar := PoeDotCom_GetCurrentlyLoggedCharacter(firstAcc)
		}
		lastCharacterLogged := poeLoggedChar?poeLoggedChar:lastCharacterLogged

		string := StrReplace(string, "%myself%", lastCharacterLogged)
	}

	return string
}

Get_TabsSkinAssetsAndSettings() {
	global PROGRAM
	iniFile := PROGRAM.INI_FILE

	presetName := INI.Get(iniFile, "SETTINGS_CUSTOMIZATION_SKINS",, 1).Preset
	skinName := INI.Get(iniFile, "SETTINGS_CUSTOMIZATION_SKINS",, 1).Skin
	skinFolder := PROGRAM.SKINS_FOLDER "\" skinName
	skinAssetsFile := PROGRAM.SKINS_FOLDER "\" skinName "\Assets.ini"
	skinSettingsFile := PROGRAM.SKINS_FOLDER "\" skinName "\Settings.ini"

	skinAssets := {}
	iniSections := Ini.Get(skinAssetsFile)
	Loop, Parse, iniSections, `n, `r
	{
		skinAssets[A_LoopField] := {}
		keysAndValues := INI.Get(skinAssetsFile, A_LoopField,, 1)

		for key, value in keysAndValues	{
			SplitPath, value, , , fileExt
			if IsIn(fileExt, "jpg,png,ico,jpeg,gif,bmp")
				skinAssets[A_LoopField][key] := skinFolder "\" value
			else
				skinAssets[A_LoopField][key] := value
		}
	}

	skinSettings := {}
	if (presetName = "User Defined") {
		userSkinSettings := INI.Get(iniFile, "SETTINGS_CUSTOMIZATION_SKINS_UserDefined",, 1)
		skinSettings.FONT := {}
		skinSettings.COLORS := {}

		skinSettings.FONT.Name := userSkinSettings.Font
		skinSettings.FONT.Size := userSkinSettings.FontSize
		skinSettings.FONT.Quality := userSkinSettings.FontQuality

		for iniKey, iniValue in userSkinSettings {
			iniKeySubStr := SubStr(iniKey, 1, 6)
			if (iniKeySubStr = "Color_" ) {
				iniKeyRestOfStr := SubStr(iniKey, 7)
				skinSettings.COLORS[iniKeyRestOfStr] := iniValue
			}
		}
	}
	else {
		skinSettingsFile := PROGRAM.SKINS_FOLDER "\" skinName "\Settings.ini"
		iniSections := INI.Get(skinSettingsFile)
		Loop, Parse, iniSections, `n, `r
		{
			skinSettings[A_LoopField] := {}
			keysAndValues := INI.Get(skinSettingsFile, A_LoopField,, 1)

			for key, value in keysAndValues {
				skinSettings[A_LoopField][key] := value
			}
		}
	}

	Skin := {}
	Skin.Preset := presetName
	Skin.Skin := skinName
	Skin.Skin_Folder := skinFolder
	Skin.Assets := skinAssets
	Skin.Settings := skinSettings

	return Skin
}

Get_CompactSkinAssetsAndSettings() {
	; TO_DO proper function when compact is fully released, with both incoming and outgoing whispers
	global PROGRAM
	iniFile := PROGRAM.INI_FILE

	presetName := INI.Get(iniFile, "SETTINGS_CUSTOMIZATION_SKINS",, 1).Preset
	skinName := INI.Get(iniFile, "SETTINGS_CUSTOMIZATION_SKINS",, 1).Skin
	skinFolder := PROGRAM.SKINS_FOLDER "\" skinName "\Compact"
	skinAssetsFile := PROGRAM.SKINS_FOLDER "\" skinName "\Compact\Assets.ini"
	skinSettingsFile := PROGRAM.SKINS_FOLDER "\" skinName "\Compact\Settings.ini"

	skinAssets := {}
	iniSections := Ini.Get(skinAssetsFile)
	Loop, Parse, iniSections, `n, `r
	{
		skinAssets[A_LoopField] := {}
		keysAndValues := INI.Get(skinAssetsFile, A_LoopField,, 1)

		for key, value in keysAndValues	{
			SplitPath, value, , , fileExt
			if IsIn(fileExt, "jpg,png,ico,jpeg,gif,bmp")
				skinAssets[A_LoopField][key] := skinFolder "\" value
			else
				skinAssets[A_LoopField][key] := value
		}
	}

	skinSettings := {}
	; if (presetName = "User Defined") {
	; 	userSkinSettings := INI.Get(iniFile, "SETTINGS_CUSTOMIZATION_SKINS_UserDefined",, 1)
	; 	skinSettings.FONT := {}
	; 	skinSettings.COLORS := {}

	; 	skinSettings.FONT.Name := userSkinSettings.Font
	; 	skinSettings.FONT.Size := userSkinSettings.FontSize
	; 	skinSettings.FONT.Quality := userSkinSettings.FontQuality

	; 	for iniKey, iniValue in userSkinSettings {
	; 		iniKeySubStr := SubStr(iniKey, 1, 6)
	; 		if (iniKeySubStr = "Color_" ) {
	; 			iniKeyRestOfStr := SubStr(iniKey, 7)
	; 			skinSettings.COLORS[iniKeyRestOfStr] := iniValue
	; 		}
	; 	}
	; }
	; else {
		skinSettingsFile := PROGRAM.SKINS_FOLDER "\" skinName "\Compact\Settings.ini"
		iniSections := INI.Get(skinSettingsFile)
		Loop, Parse, iniSections, `n, `r
		{
			skinSettings[A_LoopField] := {}
			keysAndValues := INI.Get(skinSettingsFile, A_LoopField,, 1)

			for key, value in keysAndValues {
				skinSettings[A_LoopField][key] := value
			}
		}
	; }

	Skin := {}
	Skin.Preset := presetName
	Skin.Skin := skinName
	Skin.Skin_Folder := skinFolder
	Skin.Assets := skinAssets
	Skin.Settings := skinSettings

	return Skin
}

Get_SkinAssetsAndSettings() {
	tabs := Get_TabsSkinAssetsAndSettings()
	compact := Get_CompactSkinAssetsAndSettings()
	return {Tabs:tabs,Compact:compact}
}

Declare_SkinAssetsAndSettings(_skinSettingsAll="") {
	; TO_DO proper func when compact is fully released
	global SKIN

	/* TO_DO temporarily disabled as bandaid, forcing to get skin settings no matter if param is passed or not
	skinSettingsAll := _skinSettingsAll
	if !IsObject(_skinSettingsAll)
		skinSettingsAll := Get_SkinAssetsAndSettings()
	*/
	skinSettings := Get_SkinAssetsAndSettings()

	SKIN := {}
	SKIN := skinSettings.Tabs
	SKIN.Compact := skinSettings.Compact
}
