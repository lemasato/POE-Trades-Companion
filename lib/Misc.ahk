Get_CurrencyInfos(currency) {
/*		Compare the specified currency with poe.trade abridged currency names to retrieve the real currency name.
		When the string is plural, check if the full list of currencies contains its non-plural counterpart.
 */
 	global PROGRAM
	isCurrencyListed := False

	if RegExMatch(currency, "See Offer") {
		Return {Name:currency, Is_Listed:isCurrencyListed}
	}

	currency := RegExReplace(currency, "\d")
	AutoTrimStr(currency) ; Remove whitespaces
	lastChar := SubStr(currency, 0) ; Get last char
	if (lastChar = "s") ; poeapp adds an "s" for >1 currencies
		StringTrimRight, currencyWithoutS, currency, 1

	if !IsIn(currency, PROGRAM.DATA.CURRENCY_LIST) {
		currencyFullName := PROGRAM.DATA.POETRADE_CURRENCY_DATA[currency]
		if (currencyFullName)
			isCurrencyListed := True
	}
	else { ; Currency is in list
		currencyFullName := currency
		isCurrencyListed := True
	}
	if (!currencyFullName && currencyWithoutS) { ; Couldn't retrieve full name, and currency is possibly plural
		if IsIn(currencyWithoutS, PROGRAM.DATA.CURRENCY_LIST) ; Currency is in list, was most likely plural
		{
			currencyFullName := currencyWithoutS
			isCurrencyListed := True
		}
	}
	else if !(currencyFullName) { ; Unknown currency name
		AppendToLogs(A_ThisFunc "(currency=" currency "): Unknown currency name.")
	}

	currencyFullName := (currencyFullName)?(currencyFullName):(currency)
	Return {Name:currencyFullName, Is_Listed:isCurrencyListed}
	; return currencyFullName
}

Do_Action(actionType, actionContent="", isHotkey=False, uniqueNum="") {
	global PROGRAM, GuiTrades, GuiTrades_Controls
	static prevNum, ignoreFollowingActions
	activeTab := GuiTrades.Active_Tab

	tabContent := isHotkey ? "" : GUI_Trades.GetTabContent(activeTab)
	tabPID := isHotkey ? "" : tabContent.PID

	WRITE_SEND_ACTIONS := "SEND_MSG,SEND_TO_BUYER,SEND_TO_LAST_WHISPER"
						. ",INVITE_BUYER,TRADE_BUYER,KICK_BUYER"
						. ",CMD_AFK,CMD_AUTOREPLY,CMD_DND,CMD_HIDEOUT,CMD_OOS,CMD_REMAINING"

	WRITE_DONT_SEND_ACTIONS := "WRITE_MSG,WRITE_TO_BUYER,WRITE_TO_LAST_WHISPER,CMD_WHOIS"

	WRITE_GO_BACK_ACTIONS := "WRITE_THEN_GO_BACK"

	if (uniqueNum) && (uniqueNum = prevNum) && (ignoreFollowingActions) {
		prevNum := uniqueNum, ignoreFollowingActions := False
		AppendToLogs(A_thisFunc "(actionType=" actionType ", actionContent=" actionContent ", isHotkey=" isHotkey ", uniqueNum=" uniqueNum "): Action ignored.")
		Return
	}

	global ACTIONS_FORCED_CONTENT
	if (ACTIONS_FORCED_CONTENT[actionType]) && !(actionContent)
		actionContent := ACTIONS_FORCED_CONTENT[actionType]

	actionContent := Replace_TradeVariables(actionContent)

	if IsContaining(actionType, "CUSTOM_BUTTON_") {
		RegExMatch(actionType, "\D+", actionType_NoNum)
		RegExMatch(actionType, "\d+", actionType_NumOnly)

		GUI_Trades.DoTradeButtonAction(actionType_NumOnly, "Custom")

		; ControlClick,,% "ahk_id " GuiTrades.Handle " ahk_id " GuiTrades_Controls["hBTN_Custom" actionType_NumOnly],,,, NA
	}

	else if IsIn(actionType, WRITE_SEND_ACTIONS)
		Send_GameMessage("WRITE_SEND", actionContent, tabPID)
	else if IsIn(actionType, WRITE_DONT_SEND_ACTIONS) {
		Send_GameMessage("WRITE_DONT_SEND", actionContent, tabPID)
		ignoreFollowingActions := True
	}
	else if IsIn(actionType, WRITE_GO_BACK_ACTIONS) {
		Send_GameMessage("WRITE_GO_BACK", actionContent, tabPID)
		ignoreFollowingActions := True
	}

	else if (actionType = "COPY_ITEM_INFOS")
		GUI_Trades.CopyItemInfos(activeTab)
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

	else if (actionType = "SLEEP")
		Sleep %actionContent%
	else if (actionType = "SENDINPUT")
		SendInput,%actionContent%
	else if (actionType = "SENDINPUT_RAW")
		SendInput,{Raw}%actionContent%
	else if (actionType = "SENDEVENT")
		SendEvent,%actionContent%
	else if (actionType = "SENDEVENT_RAW")
		SendEvent,{Raw}%actionContent%
	else if (actionType = "IGNORE_SIMILAR_TRADE")
		GUI_Trades.AddActiveTrade_To_IgnoreList()
	else if (actionType = "SHOW_GRID")
		GUI_Trades.ShowActiveTabItemGrid()

	prevNum := uniqueNum
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

	return changelog
}

Set_Clipboard(str) {
	global PROGRAM
	global SET_CLIPBOARD_CONTENT

	Clipboard := ""
	Clipboard := str
	ClipWait, 10, 1
	if (ErrorLevel) {
		TrayNotifications.Show(PROGRAM.NAME, "Unable to clipboard the following content: " str
			.	"`nThis may be due to an external clipboard manager creating conflict.")
		return 1
	}
	SET_CLIPBOARD_CONTENT := str
}

Reset_Clipboard() {
	global SET_CLIPBOARD_CONTENT
	if (Clipboard = SET_CLIPBOARD_CONTENT)
		Clipboard := ""
}

Replace_TradeVariables(string) {
	global GuiTrades
	activeTab := GuiTrades.Active_Tab

	tabContent := Gui_Trades.GetTabContent(activeTab)

	string := StrReplace(string, "`%buyer`%", tabContent.Buyer)
	string := StrReplace(string, "`%buyerName`%", tabContent.Buyer)
	string := StrReplace(string, "`%item`%", tabContent.Item)
	string := StrReplace(string, "`%itemName`%", tabContent.Item)
	string := StrReplace(string, "`%price`%", tabContent.Price)
	string := StrReplace(string, "`%itemPrice`%", tabContent.Price)

	string := StrReplace(string, "`%lastWhisper`%", GuiTrades.Last_Whisper_Name)

	return string
}



Get_SkinAssetsAndSettings() {
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
				if IsIn(key, "Normal,Hover,Press,Active,Inactive,Background,Icon,Header,Tabs_Background,Tabs_Underline")
				|| (A_LoopField = "Trade_Verify" && IsIn(key, "Grey,Orange,Green,Red"))
					skinAssets[A_LoopField][key] := skinFolder "\" value
				else {
					skinAssets[A_LoopField][key] := value
				}
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

Declare_SkinAssetsAndSettings(_skinSettingsAll="") {
	global SKIN

	skinSettingsAll := _skinSettingsAll
	if !IsObject(_skinSettingsAll)
		skinSettingsAll := Get_SkinAssetsAndSettings()

	SKIN := {}
	SKIN := skinSettingsAll
}
