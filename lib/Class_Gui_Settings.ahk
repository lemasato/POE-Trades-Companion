#MenuMaskKey vk07                 ;Requires AHK_L 38+
#If HK_CTRL := HotkeyCtrlHasFocus()
	*AppsKey::                       ;Add support for these special keys,
	*BackSpace::                     ;  which the hotkey control does not normally allow.
	*Delete::
	*Enter::
	*Escape::
	*Pause::
	*PrintScreen::
	*Space::
	*Tab::
	modifiers := ""
	if GetKeyState("Shift","P")
		modifiers .= "+"
	if GetKeyState("Ctrl","P")
		modifiers .= "^"
	if GetKeyState("Alt","P")
		modifiers .= "!"

	modLen := StrLen(modifiers)
	if (modLen)
		StringTrimLeft, hotkeyNoMods, A_ThisHotkey, %modLen%
	else hotkeyNoMods := A_ThisHotkey
	
	If IsIn(hotkeyNoMods, "*AppsKey,*BackSpace,*Delete,*Enter,*Escape,*Pause,*PrintScreen,*Space,*Tab")
		StringTrimLeft, hotkeyNoMods, hotkeyNoMods, 1

	if (hotkeyNoMods == "BackSpace" && HK_CTRL.Hwnd && !modifiers) {  ;if the control has text but no modifiers held,
		GuiControl, Settings:,% HK_CTRL.Hwnd                                       ;  allow BackSpace to clear that text.
		GUI_Settings.Hotkey_OnSpecialKeyPress(HK_CTRL.Hwnd, "")
	}
	else {                                                     ;Otherwise,
		GuiControl, Settings:,% HK_CTRL.Hwnd,% modifiers hotkeyNoMods  ;  show the hotkey.
		GUI_Settings.Hotkey_OnSpecialKeyPress(HK_CTRL.Hwnd, modifiers hotkeyNoMods)
	}

	return
#If

HotkeyCtrlHasFocus() {
	static bak, bak2

 	GuiControlGet, ctrlClassNN, Settings:Focus       ;ClassNN
 	if !(ctrlClassNN)
 		ctrlClassNN := bak

 	if InStr(ctrlClassNN,"hotkey") {
  		GuiControlGet, ctrlVar, Settings:FocusV     ;Associated variable
  		GuiControlGet, ctrlHwnd, Settings:Hwnd,% ctrlClassNN

  		if !(ctrlVar)
  			ctrlVar := bak2

  			bak2 := ctrlVar
  		Return, {Var:ctrlVar, Hwnd:ctrlHwnd, ClassNN:ctrlClassNN}
 	}
 	bak := ctrlClassNN
}

CaculateCenter(howManyElements, startingX, startingY, elementWidth, elementHeight, maxElementsPerRow, spaceWidth) {
	; Calculate the space between each
	spaceBetweenElements := (spaceWidth/howManyElements)

	While (maxElementsPerRow > maxElementsPerRow) { ; So that icons do not overlap
		maxElementsPerRow := (maxElementsPerRow)?(maxElementsPerRow-1):(howManyElements-1)
		spaceBetweenElements := (spaceWidth/maxElementsPerRow)
	}
	spaceBetweenElements := Round(spaceBetweenElements)
	firstElementX := (spaceWidth-(spaceBetweenElements*(maxElementsPerRow-1)+elementWidth))/2 ; We retrieve the blank space after the lastest icon in the row
																				 			  ;	then divide this space in two so icons are centered
	firstElementX := Round(firstElementX)
	firstElementX += startingX
	; Create the game icon buttons
	elementsPositions := {}
	Loop % howManyElements {
		thisRow++
		if (thisRow > maxElementsPerRow) { ; Draw a new row
			thisRow := 1, ypos += elementHeight
			divider := (remainingElements <= maxElementsPerRow)?(remainingElements):(maxElementsPerRow) ; Caculate the divider, so we can center the new row
			firstElementX := (spaceWidth-(spaceBetweenElements*(divider-1)+elementWidth))/2 ; Same thing as the firstElementX above
		}
		xpos := (thisRow=1)?(firstElementX)
			   :(xpos+spaceBetweenElements)
		ypos := (!ypos)?(startingY):(ypos)

		elementsPositions[A_Index] := {}
		elementsPositions[A_Index]["X"] := xpos
		elementsPositions[A_Index]["Y"] := ypos

		remainingElements--
	}

	Return elementsPositions
}

Class GUI_Settings {
	
	Create(whichTab="") {
		global PROGRAM, GAME
		global GuiSettings, GuiSettings_Controls, GuiSettings_Submit
		static guiCreated

		; Free ImageButton memory
		for key, value in GuiSettings_Controls
			if IsIn(key, "hBTN_CloseGUI")
			|| IsContaining(key, "hBTN_TabSettings,hBTN_TabCustomization,hBTN_TabHotkeys,hBTN_TabMisc")
				ImageButton.DestroyBtnImgList(value)
		
		; Initialize gui arrays
		Gui, Settings:Destroy
		Gui.New("Settings", "-Caption -Border +LabelGUI_Settings_ +HwndhGuiSettings", "Settings")
		; Gui.New("Settings", "+AlwaysOnTop +ToolWindow +LabelGUI_Settings_ +HwndhGuiSettings", "Settings")
		GuiSettings.Is_Created := False

		guiCreated := False
		guiFullHeight := 560, guiFullWidth := 700, borderSize := 1, borderColor := "Black"
		guiHeight := guiFullHeight-(2*borderSize), guiWidth := guiFullWidth-(2*borderSize)
		leftMost := borderSize, rightMost := guiWidth-borderSize
		upMost := borderSize, downMost := guiHeight-borderSize

		Style_Tab := [ [0, "0xEEEEEE", "", "Black", 0, , ""] ; normal
			, [0, "0xdbdbdb", "", "Black", 0] ; hover
			, [3, "0x44c6f6", "0x098ebe", "Black", 0]  ; press
			, [3, "0x44c6f6", "0x098ebe", "White", 0 ] ] ; default

		Style_RedBtn := [ [0, "0xff5c5c", "", "White", 0, , ""] ; normal
			, [0, "0xff5c5c", "", "White", 0] ; hover
			, [3, "0xe60000", "0xff5c5c", "Black", 0]  ; press
			, [3, "0xff5c5c", "0xe60000", "White", 0 ] ] ; default

		Style_Section := [ [0, "0xc9c9c9", "", "Black", 0, , ""] ; normal
			, [0, "0xc9c9c9", "", "White", 0] ; hover
			, [0, "0xc9c9c9", "", "White", 0]  ; press
			, [0, "0x89c5fd", "", "White", 0 ] ] ; default
		
		Style_ResetBtn := [ [0, "0xf9a231", "", "Black", 0, , ""] ; normal
			, [0, "0xf9a231", "", "Red", 0] ; hover
			, [3, "0xf9a231", "0xe7740e", "Red", 0]  ; press
			, [0, "0xe7740e", "", "Red", 0 ] ] ; default

		global ACTIONS_TEXT_NAME := { "":""
			, "SEND_MSG":"Send message"
			, "SEND_TO_LAST_WHISPER":"Send to last whisper"
			, "WRITE_MSG":"Write message"
			, "WRITE_THEN_GO_BACK":"Write and go back to {X}"
			, "WRITE_TO_LAST_WHISPER":"Write to last whisper received"

			, "SEND_TO_BUYER":"Send to buyer"
			, "WRITE_TO_BUYER":"Write to buyer"
			, "INVITE_BUYER":"Invite buyer to party"
			, "TRADE_BUYER":"Send trade to buyer"
			, "KICK_BUYER":"Kick buyer from party"

			, "SAVE_TRADE_STATS":"Save trade stats"
			, "COPY_ITEM_INFOS":"Copy tab item infos"
			, "GO_TO_NEXT_TAB":"Go to next tab"
			, "GO_TO_PREVIOUS_TAB":"Go to previous tab"
			, "CLOSE_TAB":"Close current tab"
			, "TOGGLE_MIN_MAX":"Toggle min/max"
			, "FORCE_MIN":"Force minimized"
			, "FORCE_MAX":"Force maximized"
			, "IGNORE_SIMILAR_TRADE":"Ignore tab item for 10mins"
			, "CLOSE_SIMILAR_TABS":"Close other tabs for same item"
			, "SHOW_GRID":"Show item location grid"

			, "CMD_AFK":"/afk"
			, "CMD_AUTOREPLY":"/autoreply"
			, "CMD_DND":"/dnd"
			, "CMD_HIDEOUT":"/hideout"
			, "CMD_OOS":"/oos"
			, "CMD_REMAINING":"/remaining"
			, "CMD_WHOIS":"/whois"

			, "SENDINPUT":"SendInput"
			, "SENDEVENT":"SendEvent"
			, "SLEEP":"Wait {X} milliseconds"
			, "":""}

		global ACTIONS_DEFAULT_CONTENT := { "":""
			, "SEND_MSG":"Send a message into chat."
			, "SEND_TO_LAST_WHISPER":"Send a message to your last whisper. (Uses the %lastWhisper% Trade Variable)"
			, "WRITE_MSG":"Write a message without sending it into chat."
			, "WRITE_THEN_GO_BACK":"Write a message and go back to {X} so you can write something in-between."
			, "WRITE_TO_LAST_WHISPER":"Write a message to your last whisper without sending it. (Uses the %lastWhisper% Trade Variable)"

			, "SEND_TO_BUYER":"Send a message to your buyer."
			, "WRITE_TO_BUYER":"Write a message to your buyer without sending it."
			, "INVITE_BUYER":"Invite your buyer to your party."
			, "TRADE_BUYER":"Send a trade request to your buyer."
			, "KICK_BUYER":"Kick your buyer out of your party."

			, "SAVE_TRADE_STATS":"Save the trade stats. You can see your saved stats from the Stats tray option."
			, "COPY_ITEM_INFOS":"Copy the tab's item infos, for usage with the in-game stash search."
			, "GO_TO_NEXT_TAB":"Select the next tab."
			, "GO_TO_PREVIOUS_TAB":"Select the previous tab"
			, "CLOSE_TAB":"Close the current tab"
			, "TOGGLE_MIN_MAX":"Toggle the GUI between minimized and maximized."
			, "FORCE_MIN":"Force the GUI to go into minimized form."
			, "FORCE_MAX":"Force the GUI to go into maximized form."
			, "IGNORE_SIMILAR_TRADE":"Ignore whispers for items with the same price and stash for 10 minutes."
			, "CLOSE_SIMILAR_TABS":"Close any other tab matching the same item, price and stash location."
			, "SHOW_GRID":"Show the item location grid."

			, "CMD_AFK":"Send the /afk command into chat. You can write anything next to the command to customize your AFK message."
			, "CMD_AUTOREPLY":"Send the /autoreply command into chat. You can write anything next to the command to customize your autoreply message"
			, "CMD_DND":"Send the /dnd command into chat. You can write anything next to the command to customize your DND message"
			, "CMD_HIDEOUT":"Send the /hideout command into chat."
			, "CMD_OOS":"Send the /oos command into chat."
			, "CMD_REMAINING":"Send the /remaining command into chat."
			, "CMD_WHOIS":"Send the /whois command into chat. You can write any name (or Trade Variable) next to the command."

			, "SENDINPUT":"Uses AutoHotKey SendInput command instead of directly sending the messages into chat."
			, "SENDINPUT_RAW":"Uses AutoHotKey SendInput command with the {Raw} parameter instead of directly sending the messages into chat."
			, "SENDEVENT":"Uses AutoHotKey SendEvent command instead of directly sending the messages into chat."
			, "SENDEVENT_RAW":"Uses AutoHotKey SendEvent command with the {Raw} parameter instead of directly sending the messages into chat."

			, "SLEEP":"Uses AutoHotkey Sleep command to add a delay before the next action."
			, "":""}

		global ACTIONS_FORCED_CONTENT := { "":""
			, "SEND_TO_LAST_WHISPER":"@%lastWhisper% "
			, "WRITE_TO_LAST_WHISPER":"@%lastWhisper% "
			, "SEND_TO_BUYER":"@%buyer% "
			, "WRITE_TO_BUYER":"@%buyer% "
			, "INVITE_BUYER":"/invite %buyer%"
			, "TRADE_BUYER":"/tradewith %buyer%"
			, "KICK_BUYER":"/kick %buyer%"

			, "CMD_AFK":"/afk "
			, "CMD_AUTOREPLY":"/autoreply "
			, "CMD_DND":"/dnd "
			, "CMD_HIDEOUT":"/hideout"
			, "CMD_OOS":"/oos"
			, "CMD_REMAINING":"/remaining"
			, "CMD_WHOIS":"/whois"
			, "":""}

		global ACTIONS_READONLY := "INVITE_BUYER,TRADE_BUYER,KICK_BUYER"
			. ",SAVE_TRADE_STATS,COPY_ITEM_INFOS,GO_TO_NEXT_TAB,GO_TO_PREVIOUS_TAB"
			. ",CLOSE_TAB,TOGGLE_MIN_MAX,FORCE_MIN,FORCE_MAX,CMD_OOS,CMD_REMAINING"
			. ",IGNORE_SIMILAR_TRADE,CLOSE_SIMILAR_TABS,SHOW_GRID"
		Loop 9
			ACTIONS_READONLY .= ",CUSTOM_BUTTON_" A_Index

		global ACTIONS_AVAILABLE := ""
		. "------------ Simple ------------"
		. "|" ACTIONS_TEXT_NAME.SEND_MSG
		. "|" ACTIONS_TEXT_NAME.SEND_TO_LAST_WHISPER
		. "|" ACTIONS_TEXT_NAME.WRITE_MSG
		. "|" ACTIONS_TEXT_NAME.WRITE_THEN_GO_BACK
		. "|" ACTIONS_TEXT_NAME.WRITE_TO_LAST_WHISPER
		. "| "
		. "|--------- Interactions ---------|"
		. "|" ACTIONS_TEXT_NAME.SEND_TO_BUYER
		. "|" ACTIONS_TEXT_NAME.WRITE_TO_BUYER
		. "|" ACTIONS_TEXT_NAME.INVITE_BUYER
		. "|" ACTIONS_TEXT_NAME.TRADE_BUYER
		. "|" ACTIONS_TEXT_NAME.KICK_BUYER
		. "| "
		. "|------------ Special ------------|"
		. "|" ACTIONS_TEXT_NAME.CLOSE_TAB
		. "|" ACTIONS_TEXT_NAME.SAVE_TRADE_STATS
		. "|" ACTIONS_TEXT_NAME.SHOW_GRID
		. "|" ACTIONS_TEXT_NAME.IGNORE_SIMILAR_TRADE
		. "|" ACTIONS_TEXT_NAME.CLOSE_SIMILAR_TABS
		. "|" ACTIONS_TEXT_NAME.COPY_ITEM_INFOS
		. "|" ACTIONS_TEXT_NAME.TOGGLE_MIN_MAX
		. "|" ACTIONS_TEXT_NAME.FORCE_MIN
		. "|" ACTIONS_TEXT_NAME.FORCE_MAX		
		. "|" ACTIONS_TEXT_NAME.GO_TO_NEXT_TAB
		. "|" ACTIONS_TEXT_NAME.GO_TO_PREVIOUS_TAB
		. "| "
		. "|--------- Commands ---------|"
		. "|" ACTIONS_TEXT_NAME.CMD_AFK
		. "|" ACTIONS_TEXT_NAME.CMD_AUTOREPLY
		. "|" ACTIONS_TEXT_NAME.CMD_DND
		. "|" ACTIONS_TEXT_NAME.CMD_HIDEOUT
		. "|" ACTIONS_TEXT_NAME.CMD_OOS
		. "|" ACTIONS_TEXT_NAME.CMD_REMAINING
		. "|" ACTIONS_TEXT_NAME.CMD_WHOIS
		. "| "
		. "|------- Miscellaneous -------|"
		. "|" ACTIONS_TEXT_NAME.SENDINPUT
		. "|" ACTIONS_TEXT_NAME.SENDEVENT
		. "|" ACTIONS_TEXT_NAME.SLEEP

		global COLORS_TYPES := { "":""
			, Border:"Border"
			, Title_No_Trades:"Title (No trades)"
			, Title_Trades:"Title (Trades on queue)"
			, Trade_Info_1:"Trade Infos"
			, Tab_Active:"Tab (Active)"
			, Tab_Inactive:"Tab (Inactive)"
			, Tab_Hover:"Tab (Hover)"
			, Tab_Press:"Tab (Press)"
			, Tab_Joined_Active:"Tab Joined (Active)"
			, Tab_Joined_Inactive:"Tab Joined (Inactive)"
			, Tab_Joined_Hover:"Tab Joined (Hover)"
			, Tab_Joined_Press:"Tab Joined (Press)"
			, Tab_Whisper_Active:"Tab Whisper (Active)"
			, Tab_Whisper_Inactive:"Tab Whisper (Inactive)"
			, Tab_Whisper_Hover:"Tab Whisper (Hover)"
			, Tab_Whisper_Press:"Tab Whisper (Press)"
			, Button_Normal:"Button (Normal)"
			, Button_Hover:"Button (Hover)"
			, Button_Press:"Button (Press)"
			, "":""}

		/* * * * * * *
		* 	CREATION
		*/

		Gui.Margin("Settings", 0, 0)
		Gui.Color("Settings", "White")
		Gui.Font("Settings", "Segoe UI", "8")
		Gui, Settings:Default ; Required for LV_ cmds

		; *	* Borders
		bordersPositions := [{X:0, Y:0, W:guiFullWidth, H:borderSize}, {X:0, Y:0, W:borderSize, H:guiFullHeight} ; Top and Left
			,{X:0, Y:downMost, W:guiFullWidth, H:borderSize}, {X:rightMost, Y:0, W:borderSize, H:guiFullHeight}] ; Bottom and Right

		Loop 4 ; Left/Right/Top/Bot borders
			Gui.Add("Settings", "Progress", "x" bordersPositions[A_Index]["X"] " y" bordersPositions[A_Index]["Y"] " w" bordersPositions[A_Index]["W"] " h" bordersPositions[A_Index]["H"] " Background" borderColor)

		; * * Title bar
		Gui.Add("Settings", "Text", "x" leftMost " y" upMost " w" guiWidth-(borderSize*2)-30 " h25 hwndhTEXT_HeaderGhost BackgroundTrans ", "") ; Title bar, allow moving
		Gui.Add("Settings", "Progress", "xp yp wp hp Background359cfc") ; Title bar background
		Gui.Add("Settings", "Text", "xp yp wp hp Center 0x200 cWhite BackgroundTrans ", "POE Trades Companion - Settings") ; Title bar text
		imageBtnLog .= Gui.Add("Settings", "ImageButton", "x+0 yp w30 hp hwndhBTN_CloseGUI", "X", Style_RedBtn, PROGRAM.FONTS["Segoe UI"], 8)
		__f := GUI_Settings.DragGui.bind(GUI_Settings, GuiSettings.Handle)
		GuiControl, Settings:+g,% GuiSettings_Controls.hTEXT_HeaderGhost,% __f
		__f := GUI_Settings.Close.bind(GUI_Settings)
		GuiControl, Settings:+g,% GuiSettings_Controls.hBTN_CloseGUI,% __f

		; * * Tab controls
		allTabs := {Settings:["Main"], Customization:["Skins", "Buttons"], Hotkeys:["Basic", "Advanced"], Misc:["Updating", "About"]} ; Tabs and sub-tabs
		for tabName, nothing in allTabs {
			for nothing, subTabName in allTabs[tabName]
				allTabsList .= "|" tabName A_Space subTabName
		}
		StringTrimLeft, allTabsList, allTabsList, 1
		Gui.Add("Settings", "Tab2", "x0 y0 w0 h0 vTab_AllTabs hwndhTab_AllTabs Choose1", allTabsList) ; Make our list of tabs
		Gui, Settings:Tab ; Whatever comes next will be on all tabs

		; * * Tab buttons
		tabSectionW := 130, tabSectionH := 40, tabButtonW := tabSectionW, tabButtonH := 30, tabFirstItemY := upMost+30
		leftMost2 := tabSectionW+20, upMost2 := tabFirstItemY
		rightMost2 := guiWidth-10, downMost2 := guiHeight-10

		GuiSettings.Tabs_Controls := {}
		imageBtnLog .= Gui.Add("Settings", "ImageButton", "x" leftMost " y" tabFirstItemY " w" tabSectionW " h" tabSectionH " hwndhBTN_SectionSettings", "Settings", Style_Section, PROGRAM.FONTS["Segoe UI"], 8)
		Loop % allTabs.Settings.MaxIndex() {
			imageBtnLog .= Gui.Add("Settings", "ImageButton", "xp y+0 w" tabButtonW " h" tabButtonH " hwndhBTN_TabSettings" A_Index, allTabs.Settings[A_Index], Style_Tab, PROGRAM.FONTS["Segoe UI"], 8)
			__f := GUI_Settings.OnTabBtnClick.bind(GUI_Settings, "Settings " allTabs.Settings[A_Index])
			GuiControl, Settings:+g,% GuiSettings_Controls["hBTN_TabSettings" A_Index],% __f
			GuiSettings.Tabs_Controls["Settings_" allTabs.Settings[A_Index]] := GuiSettings_Controls["hBTN_TabSettings" A_Index]
		}
		imageBtnLog .= Gui.Add("Settings", "ImageButton", "x" leftMost " y+10 w" tabSectionW " h" tabSectionH " hwndhBTN_SectionCustomization", "Customization", Style_Section, PROGRAM.FONTS["Segoe UI"], 8)
		Loop % allTabs.Customization.MaxIndex() {
			imageBtnLog .= Gui.Add("Settings", "ImageButton", "xp y+0 w" tabButtonW " h" tabButtonH " hwndhBTN_TabCustomization" A_Index, allTabs.Customization[A_Index], Style_Tab, PROGRAM.FONTS["Segoe UI"], 8)
			__f := GUI_Settings.OnTabBtnClick.bind(GUI_Settings, "Customization " allTabs.Customization[A_Index])
			GuiControl, Settings:+g,% GuiSettings_Controls["hBTN_TabCustomization" A_Index],% __f
			GuiSettings.Tabs_Controls["Customization_" allTabs.Customization[A_Index]] := GuiSettings_Controls["hBTN_TabCustomization" A_Index]
		}
		imageBtnLog .= Gui.Add("Settings", "ImageButton", "x" leftMost " y+10 w" tabSectionW " h" tabSectionH " hwndhBTN_SectionHotkeys", "Hotkeys", Style_Section, PROGRAM.FONTS["Segoe UI"], 8)
		Loop % allTabs.Hotkeys.MaxIndex() {
			imageBtnLog .= Gui.Add("Settings", "ImageButton", "xp y+0 w" tabButtonW " h" tabButtonH " hwndhBTN_TabHotkeys" A_Index, allTabs.Hotkeys[A_Index], Style_Tab, PROGRAM.FONTS["Segoe UI"], 8)
			__f := GUI_Settings.OnTabBtnClick.bind(GUI_Settings, "Hotkeys " allTabs.Hotkeys[A_Index])
			GuiControl, Settings:+g,% GuiSettings_Controls["hBTN_TabHotkeys" A_Index],% __f
			GuiSettings.Tabs_Controls["Hotkeys_" allTabs.Hotkeys[A_Index]] := GuiSettings_Controls["hBTN_TabHotkeys" A_Index]
		}
		imageBtnLog .= Gui.Add("Settings", "ImageButton", "x" leftMost " y+10 w" tabSectionW " h" tabSectionH " hwndhBTN_SectionMisc", "Misc", Style_Section, PROGRAM.FONTS["Segoe UI"], 8)
		Loop % allTabs.Misc.MaxIndex() {
			imageBtnLog .= Gui.Add("Settings", "ImageButton", "xp y+0 w" tabButtonW " h" tabButtonH " hwndhBTN_TabMisc" A_Index, allTabs.Misc[A_Index], Style_Tab, PROGRAM.FONTS["Segoe UI"], 8)
			__f := GUI_Settings.OnTabBtnClick.bind(GUI_Settings, "Misc " allTabs.Misc[A_Index])
			GuiControl, Settings:+g,% GuiSettings_Controls["hBTN_TabMisc" A_Index],% __f
			GuiSettings.Tabs_Controls["Misc_" allTabs.Misc[A_Index]] := GuiSettings_Controls["hBTN_TabMisc" A_Index]
		}


		Gui.Add("Settings", "ImageButton", "x" leftMost " y+35 w" tabSectionW " h" tabSectionH " hwndhBTN_ResetToDefaultSettings", "RESET SETTINGS`nTO DEFAULT", Style_ResetBtn, PROGRAM.FONTS["Segoe UI"], 8)
		__f := GUI_Settings.ResetToDefaultSettings.bind(GUI_Settings)
		GuiControl, Settings:+g,% GuiSettings_Controls.hBTN_ResetToDefaultSettings,% __f

		/* * * * * * * * * * *
		*	TAB SETTINGS MAIN
		*/
		Gui, Settings:Tab, Settings Main
		Gui.Add("Settings", "GroupBox", "x" leftMost2 " y" upMost2 " cBlack w525 h" guiHeight-80, "Settings Main" )

		; * * First group
		Gui.Add("Settings", "CheckBox", "x" leftMost2+10 " y" upMost2+20 "  BackgroundTrans hwndhCB_HideInterfaceWhenOutOfGame", "Hide the interface when not in game?")
		cbNotInGamePos := Get_ControlCoords("Settings", GuiSettings_Controls.hCB_HideInterfaceWhenOutOfGame)
		Gui.Add("Settings", "CheckBox", "xp y+5 hwndhCB_MinimizeInterfaceToBottomLeft", "Minimize interface to bottom left instead?" )
		Gui.Add("Settings", "CheckBox", "xp y+15 hwndhCB_CopyItemInfosOnTabChange", "Copy the item infos on tab change?")
		Gui.Add("Settings", "CheckBox", "xp y+1 hwndhCB_AutoFocusNewTabs", "Auto focus new tabs?")
		Gui.Add("Settings", "CheckBox", "xp y+15 hwndhCB_AutoMinimizeOnAllTabsClosed", "Auto minimize once all tabs are closed?")
		Gui.Add("Settings", "CheckBox", "xp y+1 hwndhCB_AutoMaximizeOnFirstNewTab", "Auto maximize on first new tab creation?")
		Gui.Add("Settings", "CheckBox", "xp y+12 hwndhCB_SendTradingWhisperUponCopyWhenHoldingCTRL", "Hold CTRL when copying trading`nwhisper to instantly send it in game?")
		secondRowX := cbNotInGamePos.X+cbNotInGamePos.W+45

		; * * Notifications
		Gui.Add("Settings", "Text", "xp y+17", "Play a sound notification when...")
		Gui.Add("Settings", "CheckBox", "x" leftMost2+25 " y+10 hwndhCB_TradingWhisperSFXToggle w160", "Trading whisper received?")
		Gui.Add("Settings", "Edit", "x+0 yp-4 w160 R1 ReadOnly hwndhEDIT_TradingWhisperSFXPath")
		Gui.Add("Settings", "Button", "x+0 yp-1 w75 hp+2 ReadOnly hwndhBTN_BrowseTradingWhisperSFX", "Browse file")
		Gui.Add("Settings", "CheckBox", "x" leftMost2+25 " y+5 w160 hwndhCB_RegularWhisperSFXToggle", "Regular whisper received?")
		Gui.Add("Settings", "Edit", "x+0 yp-4 w160 R1 ReadOnly hwndhEDIT_RegularWhisperSFXPath")
		Gui.Add("Settings", "Button", "x+0 yp-1 w75 hp+2 ReadOnly hwndhBTN_BrowseRegularWhisperSFX", "Browse file")
		Gui.Add("Settings", "CheckBox", "x" leftMost2+25 " y+5 w160 hwndhCB_BuyerJoinedAreaSFXToggle", "Buyer joined area?")
		Gui.Add("Settings", "Edit", "x+0 yp-4 w160 R1 ReadOnly hwndhEDIT_BuyerJoinedAreaSFXPath")
		Gui.Add("Settings", "Button", "x+0 yp-1 w75 hp+2 ReadOnly hwndhBTN_BrowseBuyerJoinedAreaSFX", "Browse file")
		; Gui.Add("Settings", "CheckBox", "x" leftMost2+10 " y+0 w110 hwndhCB_RegularWhisperSFXToggle", "Whiser received from buyer?")
		; Gui.Add("Settings", "Edit", "x+0 yp+2 w160 R1 ReadOnly hwndhEDIT_RegularWhisperSFXPath")
		; Gui.Add("Settings", "Button", "x+0 yp-1 w75 hp+2 ReadOnly hwndhBTN_BrowseRegularWhisperSFX", "Browse file")

		; Gui.Add("Settings", "Text", "x" leftMost2+10 " y+10", "Show a tray notification while tabbed for these chats:")
		; Gui.Add("Settings", "CheckBox", "x+5 yp", "Trading whisper")
		; Gui.Add("Settings", "CheckBox", "x+5 yp", "%")
		; Gui.Add("Settings", "CheckBox", "x+5 yp", "@")
		Gui.Add("Settings", "CheckBox", "x" leftMost2+10 " y+10 hwndhCB_ShowTabbedTrayNotificationOnWhisper Center", "Show a tray notification when receiving a`nwhisper while tabbed out of the game?")

		Gui.Add("Settings", "Text", "x" leftMost2+10 " y+17", "PushBullet notifications:")
		Gui.Add("Settings", "Text", "x" leftMost2+25 " y+7", "Token: ")
		Gui.Add("Settings", "Edit", "x+5 yp-3 w250 hwndhEDIT_PushBulletToken")
		Gui.Add("Settings", "Text", "x" leftMost2+25 " y+10", "Get PB notifications for:")
		Gui.Add("Settings", "CheckBox", "x+5 yp hwndhCB_PushBulletOnTradingWhisper", "Trading whispers")
		; Gui.Add("Settings", "CheckBox", "x+0 yp hwndhCB_PushBulletOnGlobalMessage", "#")
		Gui.Add("Settings", "CheckBox", "x+0 yp hwndhCB_PushBulletOnWhisperMessage", "Regular whispers")
		; Gui.Add("Settings", "CheckBox", "x+0 yp hwndhCB_PushBulletOnPartyMessage", "Party messages")
		; Gui.Add("Settings", "CheckBox", "x+0 yp hwndhCB_PushBulletOnTradeMessage", "$")
		Gui.Add("Settings", "CheckBox", "x" leftMost2+25 " y+7 hwndhCB_PushBulletOnlyWhenAfk", "Get PB notifications only when /afk?")
		
		; * * Accounts
		Gui.Add("Settings", "Text", "x" leftMost2+10 " y+20 Center", "POE accounts list. Case sensitive. Separate using a comma:")
		Gui.Add("Settings", "Edit", "xp y+5 w215 hwndhEDIT_PoeAccounts")

		; * * Msg mode
		; Gui.Add("Settings", "Text", "x" leftMost2+10 " y+20", "Message sending mode: ")
		Gui.Add("Settings", "DropDownList", "xp y+5 w100 HwndhDDL_SendMsgMode Hidden", "Clipboard|SendInput|SendEvent")
		; Gui.Add("Settings", "Text", "x+20 yp hwndhTXT_SendMessagesModeTip", "Choose a mode to have informations about how it works.")

		; * * Transparency
		Gui.Add("Settings", "Checkbox", "x" secondRowX " y" cbNotInGamePos.Y " hwndhCB_AllowClicksToPassThroughWhileInactive", "Allow clicks to pass through`nthe interface while no tabs remain?")
		Gui.Add("Settings", "Text", "x" secondRowX " y+10 Center", "Interface transparency`nNo tab remaining")
		Gui.Add("Settings", "Slider", "x+1 yp w120 AltSubmit ToolTip Range0-100 hwndhSLIDER_NoTabsTransparency")
		Gui.Add("Settings", "Text", "x" secondRowX " y+5 Center", "Interface transparency`nTabs still open")
		Gui.Add("Settings", "Slider", "x+1 yp w120 AltSubmit ToolTip Range30-100 hwndhSLIDER_TabsOpenTransparency")
		
		; * * Subroutines + User settings
		GuiSettings.TabSettingsMain_Controls := "hCB_HideInterfaceWhenOutOfGame,hCB_MinimizeInterfaceToBottomLeft,hCB_CopyItemInfosOnTabChange,hCB_AutoFocusNewTabs,hCB_AutoMinimizeOnAllTabsClosed,hCB_AutoMaximizeOnFirstNewTab,hCB_SendTradingWhisperUponCopyWhenHoldingCTRL"
		. ",hCB_TradingWhisperSFXToggle,hEDIT_TradingWhisperSFXPath,hBTN_BrowseTradingWhisperSFX,hCB_RegularWhisperSFXToggle,hEDIT_RegularWhisperSFXPath,hBTN_BrowseRegularWhisperSFX"
		. ",hCB_BuyerJoinedAreaSFXToggle,hEDIT_BuyerJoinedAreaSFXPath,hBTN_BrowseBuyerJoinedAreaSFX"
		. ",hSLIDER_NoTabsTransparency,hSLIDER_TabsOpenTransparency,hCB_AllowClicksToPassThroughWhileInactive,hCB_ShowTabbedTrayNotificationOnWhisper"
		; . ",hDDL_SendMsgMode,hTXT_SendMessagesModeTip"
		. ",hEDIT_PushBulletToken,hCB_PushBulletOnTradingWhisper,hCB_PushBulletOnPartyMessage,hCB_PushBulletOnWhisperMessage,hCB_PushBulletOnlyWhenAfk"
		. ",hEDIT_PoeAccounts"
		GUI_Settings.TabsSettingsMain_SetUserSettings()
		GUI_Settings.TabSettingsMain_EnableSubroutines()

		/* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * 
		*	TAB CUSTOMIZATION SKINS
		*/
		Gui, Settings:Tab, Customization Skins
		Gui.Add("Settings", "GroupBox", "x" leftMost2 " y" upMost2 " cBlack w525 h" guiHeight-80, "Customization Skins")

		; * * Preset
		Gui.Add("Settings", "Text", "xp yp+20 w525 Center BackgroundTrans","Preset: ")

		; * * Skin
		Gui.Add("Settings", "DropDownList", "xp+10 y+5 wp-20 hwndhDDL_SkinPreset")
		Gui.Add("Settings", "Text", "x" leftMost2+15 " y+20 w250 Center","Skin base:")
		Gui.Add("Settings", "ListBox", "x" leftMost2+15 " y+5 wp R5 hwndhLB_SkinBase")
		Gui.Add("Settings", "Text", "x+10 yp","Scaling size (`%):")
		Gui.Add("Settings", "Edit", "x+5 yp-3 w60 R1 ReadOnly hwndhEDIT_SkinScalingPercentage")
		Gui.Add("Settings", "UpDown", "Range5-200 hwndhUPDOWN_SkinScalingPercentage")

		; * * Font
		Gui.Add("Settings", "Text", "x" leftMost2+15 " y+70 w250 Center BackgroundTrans","Text font:")
		Gui.Add("Settings", "ListBox", "x" leftMost2+15 " y+5 w250 R5 hwndhLB_SkinFont")
		Gui.Add("Settings", "Checkbox", "x+10 yp hwndhCB_UseRecommendedFontSettings","Use recommended font settings?")
		Gui.Add("Settings", "Text", "xp y+10 hwndhTEXT_FontSize","Font size:")
		Gui.Add("Settings", "Edit", "xp+75 yp-3 w60 R1 ReadOnly hwndhEDIT_SkinFontSize")
		Gui.Add("Settings", "UpDown", "Range1-24 hwndhUPDOWN_SkinFontSize")
		fontSizeTextPos := Get_ControlCoords("Settings", GuiSettings_Controls.hTEXT_FontSize)
		Gui.Add("Settings", "Text", "x" fontSizeTextPos.X " y+10","Font quality:")
		Gui.Add("Settings", "Edit", "xp+75 yp-3 w60 R1 ReadOnly hwndhEDIT_SkinFontQuality")
		Gui.Add("Settings", "UpDown", "Range0-5 hwndhUPDOWN_SkinFontQuality")

		; * * Text colors
		Gui.Add("Settings", "Text", "x" leftMost2+15 " y+25","Text color:")
		Gui.Add("Settings", "DropDownList", "x+5 yp-3 w140 hwndhDDL_ChangeableFontColorTypes")
		ddlHeight := Get_ControlCoords("Settings", GuiSettings_Controls.hDDL_ChangeableFontColorTypes).H
		Gui.Add("Settings", "Progress", "x+5 yp w" ddlHeight " h" ddlHeight " BackgroundRed hwndhPROGRESS_ColorSquarePreview")
		Gui.Add("Settings", "Button", "x+5 yp-1  hwndhBTN_ShowColorPicker R1", "Show Color Picker")

		; Gui.Add("Settings", "Text", "x+0 yp-2 Center FontSize7", "<- Click on the square`n   to change the color")

		; * * Preview btn
		Gui.Add("Settings", "Button", "x" leftMost2+525-215-5 " y" upMost2+guiHeight-80-35 " w215 h30 hwndhBTN_RecreateTradesGUI", "Click here to apply your changes now")

		; * * Subroutines + User settings
		GuiSettings.TabCustomizationSkins_Controls := "hDDL_SkinPreset,hLB_SkinBase,hEDIT_SkinScalingPercentage,hLB_SkinFont,hCB_UseRecommendedFontSettings,"
		. "hTEXT_FontSize,hEDIT_SkinFontSize,hEDIT_SkinFontQuality,hDDL_ChangeableFontColorTypes,hPROGRESS_ColorSquarePreview,hBTN_ShowColorPicker,hBTN_RecreateTradesGUI"
		GUI_Settings.TabCustomizationSkins_SetUserSettings()
		GUI_Settings.TabCustomizationSkins_EnableSubroutines()

		/* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * 
		*	TAB CUSTOMIZATION BUTTONS
		*/
		Gui, Settings:Tab, Customization Buttons
		Gui.Add("Settings", "GroupBox", "x" leftMost2 " y" upMost2 " cBlack w525 h" guiHeight-80, "Customization Buttons")
		thisTabCtrlsList := ""

		; Custom Buttons: Determine positions and sizes
		custButWidthOneThird := 160, custButWidthTwoThird := (custButWidthOneThird*2)+5, custButWidthThreeThird := (custButWidthOneThird*3)+(5*2), custButHeight := 30
		GuiSettings.CUSTOM_BTN_MIN_X := leftMost2+5, GuiSettings.CUSTOM_BTN_MAX_X := GuiSettings.CUSTOM_BTN_MIN_X+((custButWidthOneThird+10)*2)
		GuiSettings.CUSTOM_BTN_MIN_Y := upMost2+5, GuiSettings.CUSTOM_BTN_MAX_Y := GuiSettings.CUSTOM_BTN_MIN_Y+(2*40)

		GuiSettings.CustomButtons_SlotPositions := {}
		custButFirstX := leftMost2+17, custButSecondX := custButFirstX+custButWidthOneThird+5, custButThirdX := custButSecondX+custButWidthOneThird+5
		custButFirstY := upMost2+60, custButSecondY := custButFirstY+custButHeight+5, custButThirdY := custButSecondY+custButHeight+5
		Loop 9 {
			slotX := IsIn(A_Index, "1,4,7") ? custButFirstX
				:  IsIn(A_Index, "2,5,8") ? custButSecondX
				: IsIn(A_Index, "3,6,9") ? custButThirdX
				: ""
			slotY := IsIn(A_Index, "1,2,3") ? custButFirstY
				:  IsIn(A_Index, "4,5,6") ? custButSecondY
				: IsIn(A_Index, "7,8,9") ? custButThirdY
				: ""
			GuiSettings.CustomButtons_SlotPositions[A_Index] := {X:slotX, Y:slotY}
		}
		GuiSettings.CustomButton_Width_OneThird := custButWidthOneThird, GuiSettings.CustomButton_Width_TwoThird := custButWidthTwoThird, GuiSettings.CustomButton_Width_ThreeThird := custButWidthThreeThird

		; Unicode Buttons: Determine positions and sizes
		uniButWidth := 45, uniButHeight := 25
		GuiSettings.UNICODE_BTN_MIN_X := GuiSettings.CUSTOM_BTN_MIN_X, GuiSettings.UNICODE_BTN_MAX_X := GuiSettings.UNICODE_BTN_MIN_X+((uniButWidth+10)*4)
		GuiSettings.UNICODE_BTN_MIN_Y := GuiSettings.CUSTOM_BTN_MAX_Y+50, GuiSettings.UNICODE_BTN_MAX_Y := GuiSettings.UNICODE_BTN_MIN_Y+uniButWidth

		uniButFirstX := custButFirstX, uniButFirstY := custButThirdY+custButHeight+5
		GuiSettings.UnicodeButtons_SlotPositions := {}
		Loop 5 {
			slotX := uniButFirstX+( (uniButWidth+5)*(A_Index-1) ), slotY := uniButFirstY
			GuiSettings.UnicodeButtons_SlotPositions[A_Index] := {X:slotX, Y:slotY}
		}

		; * * Top text
		Gui.Add("Settings", "Text", "xp yp+20 BackgroundTrans w525 Center", "Left click to set the button behaviour - Right click for sizing options`nDrag to change button slot (empty slot required)")

		; * * Custom buttons
		GuiSettings.CustomButtons_IsSlotTaken := {}
		Loop 9 {
			slotPos := GuiSettings.CustomButtons_SlotPositions[A_Index]
			Gui.Add("Settings", "Button", "x" slotPos.X " y" slotPos.Y " w" custButWidthOneThird " h" custButHeight " hwndhBTN_CustomBtn_" A_Index, A_Index ".")
			Gui.Add("Settings", "Text", "x" slotPos.X " y" slotPos.Y " w" custButWidthOneThird " h" custButHeight " hwndhTEXT_CustomBtnSlot_" A_Index " 0x200 Center Hidden", "[ + ]") ; 0x200= Center vertically

			btnCtrlHwnd := GuiSettings_Controls["hBTN_CustomBtn_" A_Index]
			textCtrlHwnd := GuiSettings_Controls["hTEXT_CustomBtnSlot_" A_Index]

			GuiSettings.CustomButtons_HandlesList .= A_Index!=1? "," btnCtrlHwnd : btnCtrlHwnd
			GuiSettings.CustomButtons_IsSlotTaken[A_Index] := True

			thisTabCtrlsList .= ",hBTN_CustomBtn_" A_Index ",hTEXT_CustomBtnSlot_" A_Index
		}

		; * * Special buttons
		GuiSettings.UnicodeButtons_IsSlotTaken := {}
		Gui.Font("Settings", "TC_Symbols", "10")
		Loop 5 {
			slotPos := GuiSettings.UnicodeButtons_SlotPositions[A_Index]
			Gui.Add("Settings", "Button", "x" slotPos.X " y" slotPos.Y " w" uniButWidth " h" uniButHeight " hwndhBTN_UnicodeBtn_" A_Index, A_Index-1) ; Minus one cuz tc_symbols starts at 0
			Gui.Add("Settings", "Text", "x" slotPos.X " y" slotPos.Y " w" uniButWidth " h" uniButHeight " hwndhTEXT_UnicodeBtnSlot_" A_Index " 0x200 Center", "[ + ]") ; 0x200= Center vertically

			btnCtrlHwnd := GuiSettings_Controls["hBTN_UnicodeBtn_" A_Index]
			textCtrlHwnd := GuiSettings_Controls["hTEXT_UnicodeBtnSlot_" A_Index]

			GuiSettings.UnicodeButtons_HandlesList .= A_Index!=1? "," btnCtrlHwnd : btnCtrlHwnd
			GuiSettings.UnicodeButtons_IsSlotTaken[A_Index] := True

			thisTabCtrlsList .= ",hBTN_UnicodeBtn_" A_Index ",hTEXT_UnicodeBtnSlot_" A_Index
		}
		Gui.Font("Settings", "Segoe UI", "8")

		; ** Actions list & buttons
		Gui.Add("Settings", "DropDownList", "x" leftMost2+15 " y+15 w175 R50 hwndhDDL_ActionType Disabled")
		Gui.Add("Settings", "Edit", "x+5 w320 hwndhEDIT_ActionContent Disabled")
		Gui.Add("Settings", "Button","x" leftMost2+15 " y+5 w245 hwndhBTN_SaveChangesToAction Disabled", "Save changes to action...")
		Gui.Add("Settings", "Button","x+10 yp wp hwndhBTN_AddAsNewAction Disabled", "Add as a new action")
		Gui.Add("Settings", "ListView", "x" leftMost2+15 " y+5 w500 hwndhLV_ButtonsActions -Multi AltSubmit +LV0x10000 R7 Disabled", "#|Type|Content")

		thisTabCtrlsList .= ",hDDL_ActionType,hEDIT_ActionContent,hBTN_SaveChangesToAction,hBTN_AddAsNewAction,hLV_ButtonsActions"

		Gui, Settings:Default
		Gui, Settings:ListView,% GuiSettings_Controls.hLV_ButtonsActions
		Loop, Parse, ACTIONS_AVAILABLE,% "|"
		{
			if (A_LoopField && A_LoopField != " " && !IsContaining(A_LoopField, "----")) {
				LV_Add("", loopIndex, A_LoopField, "")
				loopIndex++
			}
		}
		Loop 3
			LV_ModifyCol(A_Index, "AutoHdr NoSort")
		LV_ModifyCol(1, "Integer")
		LV_Delete()

		GuiSettings.TabCustomizationButtons_Controls := thisTabCtrlsList
		GUI_Settings.TabCustomizationButtons_SetAvailableActions()
		GUI_Settings.TabCustomizationButtons_SetUserSettings()
		GUI_Settings.TabCustomizationButtons_EnableSubroutines()

		/* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * 
		*	TAB HOTKEYS BASIC
		*/
		Gui, Settings:Tab, Hotkeys Basic
		
		thisTabCtrlsList := ""
		hotkeysCBHandles := [], hotkeysEDITHandles := [], hotkeysHKHandles := [], hotkeysDDLHandles := []
		collumnMax := 5, rowMax := 3	, hkIndex := 0, rowIndex := 0	, hotkeysWidth := 140, hkYPos := 0
		Loop % collumnMax {
			if (A_Index > 1)
				hkYPos += 80
			Loop % rowMax {
				; Create each hotkey group
				rowIndex := A_Index, hkIndex++
				Gui.Add("Settings", "DropDownList", "x0 y0 w" hotkeysWidth+20 " R50 hwndhDDL_HotkeyActionType" hkIndex)
				Gui.Add("Settings", "Checkbox", "x0 y0 w15 h15 hwndhCB_HotkeyToggle" hkIndex)
				Gui.Add("Settings", "Hotkey", "x0 y0 w" hotkeysWidth " R1 hwndhHK_HotkeyKeys" hkIndex)
				Gui.Add("Settings", "Edit", "x0 y0 wp+20 R1 hwndhEDIT_HotkeyActionContent" hkIndex)
				hotkeysDDLHandles.Push(GuiSettings_Controls["hDDL_HotkeyActionType" hkIndex])
				hotkeysCBHandles.Push(GuiSettings_Controls["hCB_HotkeyToggle" hkIndex])
				hotkeysHKHandles.Push(GuiSettings_Controls["hHK_HotkeyKeys" hkIndex])
				hotkeysEDITHandles.Push(GuiSettings_Controls["hEDIT_HotkeyActionContent" hkIndex])

				if ( thisTabCtrlsList && SubStr(thisTabCtrlsList, 0, 1) != ",")
					thisTabCtrlsList .= ","
				thisTabCtrlsList .= "hDDL_HotkeyActionType" hkIndex ",hCB_HotkeyToggle" hkIndex ",hHK_HotkeyKeys" hkIndex ",hEDIT_HotkeyActionContent" hkIndex ","

				if (A_Index = 1 && prevIndex > 1) 
					isNewRow := True

				if (A_Index = 1) { ; Calculate the positions, only needed once
					hotkeysPositions := CaculateCenter(rowMax, leftMost2, upMost2, hotkeysWidth, hotkeyHeight, rowMax, guiWidth-leftMost2)
					xPosDiff := hotkeysPositions.1.X-leftMost2
				}
				if (isNewRow) { ; If new row, add some y pos
					hotkeysPositions[rowIndex]["Y"] += hkYPos
				}
				; Correctly move hotkeys group accordingly
				GuiControl, Settings:Move,% hotkeysDDLHandles[hkIndex],% "x" hotkeysPositions[rowIndex]["X"]-xPosDiff " y" hotkeysPositions[rowIndex]["Y"]+14
				GuiControl, Settings:Move,% hotkeysCBHandles[hkIndex],% "x" hotkeysPositions[rowIndex]["X"]-18 " y" hotkeysPositions[rowIndex]["Y"]+38
				GuiControl, Settings:Move,% hotkeysHKHandles[hkIndex],% "x" hotkeysPositions[rowIndex]["X"]-xPosDiff+20 " y" hotkeysPositions[rowIndex]["Y"]+36
				GuiControl, Settings:Move,% hotkeysEDITHandles[hkIndex],% "x" hotkeysPositions[rowIndex]["X"]-xPosDiff " y" hotkeysPositions[rowIndex]["Y"]+58

				prevIndex := A_Index
			}
			StringTrimRight, thisTabCtrlsList, thisTabCtrlsList, 1
		}
		hkCtrlList := GuiSettings.TabHotkeysBasic_HotkeysCtrlList := ""
		for index, hkHandle in hotkeysHKHandles
			hkCtrlList .= hkHandle ","
		StringTrimRight, hkCtrlList, hkCtrlList, 1
		GuiSettings.TabHotkeysBasic_HotkeysCtrlList := hkCtrlList
		GuiSettings.TabHotkeysBasic_Max_Hotkeys_Count := hkIndex

		GUI_Settings.TabHotkeysBasic_UpdateActionsList()
		GUI_Settings.TabHotkeysBasic_SetTabSettings()
		GuiSettings.Hotkeys_Basic_TabControls := thisTabCtrlsList
		GUI_Settings.TabHotkeysBasic_EnableSubroutines()

		/* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * 
		*	TAB HOTKEYS ADVANCED
		*/
		Gui, Settings:Tab, Hotkeys Advanced

		Gui.Add("Settings", "GroupBox", "x" leftMost2 " y" upMost2 " cBlack w540 h" guiHeight-80, "Hotkeys Advanced")
		Gui.Add("Settings", "DropDownList", "x" leftMost2+20 " y" upMost2+20 " w430 R20 hwndhDDL_HotkeyAdvExistingList")
		Gui.Add("Settings", "Button", "x+5 yp-1 w30 R1 hwndhBTN_HotkeyAdvAddNewProfile", "+")
		Gui.Add("Settings", "Button", "x+5 yp w30 R1 hwndhBTN_HotkeyAdvDeleteCurrentProfile", "-")
		Gui.Add("Settings", "Edit", "x" leftMost2+20 " y+16 w260 hwndhEDIT_HotkeyAdvName")

		Gui.Add("Settings", "Hotkey", "x+5 yp w165 hwndhHK_HotkeyAdvHotkey")
		Gui.Add("Settings", "Edit", "xp yp wp hp Hidden hwndhEDIT_HotkeyAdvHotkey")
		Gui.Add("Settings", "Button", "x+0 yp hp hwndhBTN_ChangeHKType", "HK Type Switch")
		coords := Get_ControlCoords("Settings", GuiSettings_Controls.hBTN_ChangeHKType)
		GuiControl, Settings:Move,% GuiSettings_Controls.hHK_HotkeyAdvHotkey,% "w" 235-coords.W
		GuiControl, Settings:Move,% GuiSettings_Controls.hEDIT_HotkeyAdvHotkey,% "w" 235-coords.W
		coords := Get_ControlCoords("Settings", GuiSettings_Controls.hEDIT_HotkeyAdvHotkey)
		GuiControl, Settings:Move,% GuiSettings_Controls.hBTN_ChangeHKType,% "x" coords.X + coords.W + 1

		Gui.Add("Settings", "DropDownList", "x" leftMost2+20 " y+7 w200 R50 hwndhDDL_HotkeyAdvActionType")
		Gui.Add("Settings", "Edit", "x+5 yp w295 hwndhEDIT_HotkeyAdvActionContent")
		Gui.Add("Settings", "Button","x" leftMost2+20 " y+7 w245 hwndhBTN_HotkeyAdvSaveChangesToAction", "Save changes to action...")
		Gui.Add("Settings", "Button","x+10 yp wp hwndhBTN_HotkeyAdvAddAsNewAction", "Add as a new action")
		Gui.Add("Settings", "ListView", "x" leftMost2+20 " y+10 w500 hwndhLV_HotkeyAdvActionsList -Multi AltSubmit +LV0x10000 R8", "#|Type|Content")
		Gui, Settings:ListView,% GuiSettings_Controls.hLV_HotkeyAdvActionsList
		loopIndex := 1
		Loop, Parse, ACTIONS_AVAILABLE,% "|"
		{
			if (A_LoopField && A_LoopField != " " && !IsContaining(A_LoopField, "----")) {
				LV_Add("", loopIndex, A_LoopField, "")
				loopIndex++
			}
		}
		Loop 3
			LV_ModifyCol(A_Index, "AutoHdr NoSort")
		LV_ModifyCol(1, "Integer")
		LV_Delete()

		GUI_Settings.TabHotkeysAdvanced_UpdateActionsList()
		GUI_Settings.TabHotkeysAdvanced_UpdateRegisteredHotkeysList()
		GuiSettings.Hotkeys_Advanced_TabControls := "hDDL_HotkeyAdvExistingList,hEDIT_HotkeyAdvName,hHK_HotkeyAdvHotkey,hDDL_HotkeyAdvActionType"
			. ",hEDIT_HotkeyAdvActionContent,hBTN_HotkeyAdvSaveChangesToAction,hBTN_HotkeyAdvAddAsNewAction,hLV_HotkeyAdvActionsList"
			. ",hBTN_HotkeyAdvAddNewProfile,hBTN_HotkeyAdvDeleteCurrentProfile,hEDIT_HotkeyAdvHotkey,hBTN_ChangeHKType"
		GUI_Settings.TabHotkeysAdvanced_EnableSubroutines()

		/* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * 
		*	TAB MISC UPDATING
		*/
		Gui, Settings:Tab, Misc Updating

		Gui.Font("Settings", "Consolas", "8")

		Gui.Add("Settings", "GroupBox", "x" leftMost2 " y" upMost2 " cBlack w525 h115 hwndhGB_UpdateCheck", "You are up to date!")

		Gui.Add("Settings", "Text", "x" leftMost2+20 " y" upMost2+20 " hwndhTEXT_YourVersion", "Your version:")
		Gui.Add("Settings", "Text", "x+30 yp BackgroundTrans hwndhTEXT_ProgramVer")
		yourVerCoords := Get_ControlCoords("Settings", GuiSettings_Controls.hTEXT_YourVersion)
		programVerCoords := Get_ControlCoords("Settings", GuiSettings_Controls.hTEXT_ProgramVer)

		Gui.Add("Settings", "Text", "x" yourVerCoords.X " y+10", "Latest Stable:")
		Gui.Add("Settings", "Text", "x" programVerCoords.X " yp BackgroundTrans hwndhTEXT_LatestStableVer")
		Gui.Add("Settings", "Text", "x" yourVerCoords.X " y+5", "Latest BETA:")
		Gui.Add("Settings", "Text", "x" programVerCoords.X " yp BackgroundTrans hwndhTEXT_LatestBetaVer")
		Gui.Add("Settings", "Button", "x" yourVerCoords.X " y+10 R1 hwndhBTN_CheckForUpdates", "Check for updates manually")
		Gui.Add("Settings", "Text", "x+5 yp+7 hwndhTEXT_MinsAgo", "(x mins ago)")

		; Gui.Add("Settings", "Checkbox", "x400 y" upMost2+20 " hwndhCB_AllowToUpdateAutomaticallyOnStart", "Allow to update automatically on start?")
		; Gui.Add("Settings", "Checkbox", "xp y+5 hwndhCB_AllowPeriodicUpdateCheck", "Allow automatic update check every 2hours?")
		Gui.Add("Settings", "Text", "x380 y" upMost2+20 " ", "Check for updates: ")
		Gui.Add("Settings", "DropDownList", "x+5 yp-2 w155 hwndhDDL_CheckForUpdate", "Only on application start|On start + every 5 hours|On start + every day")
		Gui.Add("Settings", "Checkbox", "xp y+10 hwndhCB_UseBeta", "Use the BETA branch?")		
		Gui.Add("Settings", "Checkbox", "xp y+5 hwndhCB_DownloadUpdatesAutomatically", "Download updates`nautomatically?")
		
		ctrlSize := Get_ControlCoords("Settings", GuiSettings_Controls.hGB_UpdateCheck)
		Gui.Add("Settings", "Edit", "x" leftMost2 " y" upMost2+125 " w525 h" guiHeight-80-ctrlSize.H-ctrlSize.Y+15, Get_Changelog(removeTrails:=True) )

		Gui.Font("Settings", "Segoe UI", "8")

		GuiSettings.TabMiscUpdating_Controls := "hGB_UpdateCheck,hTEXT_LatestBetaVer,hTEXT_LatestStableVer,hTEXT_YourVersion,hBTN_CheckForUpdates,hTEXT_MinsAgo"
			. ",hDDL_CheckForUpdate,hCB_UseBeta,hBTN_CheckForUpdates,hCB_DownloadUpdatesAutomatically"
		GUI_Settings.TabMiscUpdating_SetUserSettings()
		GUI_Settings.TabMiscUpdating_EnableSubroutines()

		/* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * 
		*	TAB MISC ABOUT
		*/
		Gui, Settings:Tab, Misc About

		Gui.Add("Settings", "GroupBox", "x" leftMost2 " y" upMost2 " cBlack w525 h115 hwndhGB_About")
		Gui.Add("Settings", "Text", "x" leftMost2+10 " y" upMost2+15 " w505 Center hwndhTEXT_About" , "POE Trades Companion is a tool meant to enhance your trading experience. "
			. "`n`nUpon receiving a trading whisper (poe.trade / poeapp.com),"
			. "`nthe most important informations from the trade will be shown in a convenient interface."
			. "`n`nUp to nine custom buttons to interact with your buyer, five special smaller buttons to do the strict minimum, and many hotkeys are available to make trading more enjoyable.")

		ctrlSize := Get_ControlCoords("Settings", GuiSettings_Controls.hGB_About)
		Gui.Add("Settings", "Edit", "x" leftMost2 " y" upMost2+125 " w525 h" guiHeight-80-ctrlSize.H-ctrlSize.Y+15 " ReadOnly Center hwndhEDIT_HallOfFame", "Hall of Fame`nThank you for your support!`n`n" "[Hall of Fame loading]")

		GUI_Settings.TabMiscAbout_UpdateAllOfFame()

		/* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * 
		*	TAB - ALL
		*/
		Gui, Settings:Tab

		Gui.Add("Settings", "Picture", "x" guiWidth-120 " y" guiHeight-45 " hwndhIMG_Paypal", PROGRAM.IMAGES_FOLDER "\DonatePaypal.png")
		Gui.Add("Settings", "Picture", "xp-70 yp w40 h40 hwndhIMG_Discord", PROGRAM.IMAGES_FOLDER "\Discord.png")
		Gui.Add("Settings", "Picture", "xp-45 yp w40 h40 hwndhIMG_Reddit", PROGRAM.IMAGES_FOLDER "\Reddit.png")
		Gui.Add("Settings", "Picture", "xp-45 yp w40 h40 hwndhIMG_PoE", PROGRAM.IMAGES_FOLDER "\PoE.png")
		Gui.Add("Settings", "Picture", "xp-45 yp w40 h40 hwndhIMG_GitHub", PROGRAM.IMAGES_FOLDER "\GitHub.png")

		__f := GUI_Settings.OnPictureLinkClick.bind(GUI_Settings, "Paypal")
		GuiControl, Settings:+g,% GuiSettings_Controls["hIMG_Paypal"],% __f
		__f := GUI_Settings.OnPictureLinkClick.bind(GUI_Settings, "Discord")
		GuiControl, Settings:+g,% GuiSettings_Controls["hIMG_Discord"],% __f
		__f := GUI_Settings.OnPictureLinkClick.bind(GUI_Settings, "Reddit")
		GuiControl, Settings:+g,% GuiSettings_Controls["hIMG_Reddit"],% __f
		__f := GUI_Settings.OnPictureLinkClick.bind(GUI_Settings, "PoE")
		GuiControl, Settings:+g,% GuiSettings_Controls["hIMG_PoE"],% __f
		__f := GUI_Settings.OnPictureLinkClick.bind(GUI_Settings, "GitHub")
		GuiControl, Settings:+g,% GuiSettings_Controls["hIMG_GitHub"],% __f

		/* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * 
		*	SHOW
		*/

		Gui.Show("Settings", "h" guiHeight " w" guiWidth " NoActivate Hide")
		; Gui.Show("Settings", "h" guiHeight " w" guiWidth " x-" guiWidth+10 " y" 1010-guiHeight " NoActivate " param)
		detectHiddenWin := A_DetectHiddenWindows
		DetectHiddenWindows, On
		WinWait,% "ahk_id " GuiSettings.Handle
		DetectHiddenWindows, %detectHiddenWin%
		
		OnMessage(0x201, "WM_LBUTTONDOWN")
		OnMessage(0x202, "WM_LBUTTONUP")
		OnMessage(0x200, "WM_MOUSEMOVE")

		if (whichTab)
			Gui_Settings.OnTabBtnClick(whichTab)

		; Gui_Settings.OnTabBtnClick("Settings Main")
		; Gui_Settings.OnTabBtnClick("Customization Skins")
		; Gui_Settings.OnTabBtnClick("Customization Buttons")
		; Gui_Settings.OnTabBtnClick("Hotkeys Basic")
		; Gui_Settings.OnTabBtnClick("Hotkeys Advanced")
		; Gui_Settings.OnTabBtnClick("Misc Updating")
		; Gui_Settings.OnTabBtnClick("Misc About")
		; GUI_Settings.TabMiscAbout_UpdateAllOfFame()

		GuiSettings.Is_Created := True
		Return

		GUI_Settings_Close:
		Return

		GUI_Settings_ContextMenu:
			ctrlHwnd := Get_UnderMouse_CtrlHwnd()
			GuiControlGet, ctrlName, Settings:,% ctrlHwnd

			GUI_Settings.ContextMenu(ctrlHwnd, ctrlName)
		return
	}

	DragGui(GuiHwnd) {
		PostMessage, 0xA1, 2,,,% "ahk_id " GuiHwnd
	}

	Close() {
		Gui, Settings:Hide

		TrayNotifications.Show("Recreating the Trades window with the new skin settings.")

		UpdateHotkeys()

		Declare_SkinAssetsAndSettings()

		Gui_TradesMinimized.Create()
		Gui_Trades.RecreateGUI()
	}

	OnPictureLinkClick(picName) {
		global PROGRAM

		urlLink := picName="Paypal"?PROGRAM.LINK_SUPPORT
		: picName="Discord"?PROGRAM.LINK_DISCORD
		: picName="Reddit"?PROGRAM.LINK_REDDIT
		: picName="PoE"?PROGRAM.LINK_GGG
		: picName="GitHub"?PROGRAM.LINK_GITHUB
		: ""

		if (urlLink)
			Run,% urlLink
	}

	Show(whichTab="") {
		global GuiSettings

		hiddenWin := A_DetectHiddenWindows
		DetectHiddenWindows, On
		foundHwnd := WinExist("ahk_id " GuiSettings.Handle)
		DetectHiddenWindows, %hiddenWin%

		if (foundHwnd) {
			Gui, Settings:Show, xCenter yCenter
		}
		else {
			AppendToLogs("GUI_Settings.Show(" whichTab "): Non existent. Recreating.")
			GUI_Settings.Create()
			GUI_Settings.Show()
		}

		if (whichTab)
				Gui_Settings.OnTabBtnClick(whichTab)
			else
				Gui_Settings.OnTabBtnClick("Settings Main")
	}

	ResetToDefaultSettings() {
		global PROGRAM

		MsgBox(4096+48+4, "", "Are you sure to reset your settings to default?"
		. "`n" "Your current settings file will be kept and renamed, in case you ever wish to revert the changes."
		. "`n"
		. "`n" "Settings file can be found at:"
		. "`n" PROGRAM.INI_FILE
		. "`n"
		. "`n" PROGRAM.NAME " will have to reload if you choose to continue.")

		IfMsgBox, Yes
		{
			iniFile := PROGRAM.INI_FILE
			SplitPath, iniFile, fileName, folder
			FileMove,% PROGRAM.INI_FILE,% folder "\" A_Now "_" fileName, 1
			Reload()
		}
	}

	/* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * 
	*	TAB SETTINGS MAIN FUNCTIONS
	*/

	/* * Subroutines
	*/

	TabSettingsMain_EnableSubroutines() {
		GUI_Settings.TabSettingsMain_ToggleSubroutines("Enable")
	}

	TabSettingsMain_DisableSubroutines() {
		GUI_Settings.TabSettingsMain_ToggleSubroutines("Disable")
	}

	TabSettingsMain_ToggleSubroutines(enableOrDisable) {
		global GuiSettings, GuiSettings_Controls
		thisTabCtrls := GuiSettings.TabSettingsMain_Controls

		Loop, Parse, thisTabCtrls,% ","
		{
			loopedCtrl := A_LoopField
			isCheckbox := SubStr(loopedCtrl, 1, 3)="hCB" ? True : False

			if (enableOrDisable = "Disable")
				GuiControl, Settings:-g,% GuiSettings_Controls[loopedCtrl]
			else if (enableOrDisable = "Enable") {
				if (isCheckbox)
					__f := GUI_Settings.TabSettingsMain_OnCheckboxToggle.bind(Gui_Settings, loopedCtrl)
				else if IsIn(loopedCtrl, "hBTN_BrowseRegularWhisperSFX,hBTN_BrowseTradingWhisperSFX,hBTN_BrowseBuyerJoinedAreaSFX")
					__f := GUI_Settings.TabSettingsMain_OnSFXBrowse.bind(Gui_Settings, loopedCtrl)
				else if (loopedCtrl = "hSLIDER_NoTabsTransparency")
					__f := GUI_Settings.TabSettingsMain_OnTransparencySliderMove.bind(Gui_Settings, loopedCtrl)
				else if (loopedCtrl = "hSLIDER_TabsOpenTransparency")
					__f := GUI_Settings.TabSettingsMain_OnTransparencySliderMove.bind(Gui_Settings, loopedCtrl)
				else if (loopedCtrl = "hDDL_SendMsgMode") 
					__f := GUI_Settings.TabSettingsMain_OnSendMsgModeChange.bind(Gui_Settings)
				else if (loopedCtrl = "hEDIT_PushBulletToken")
					__f := GUI_Settings.TabSettingsMain_OnPushBulletTokenChange.bind(Gui_Settings)
				else if (loopedCtrl = "hEDIT_PoeAccounts")
					__f := GUI_Settings.TabSettingsMain_OnPoeAccountsListChange.bind(Gui_Settings)
				else 
					__f := 

				if (__f)
					GuiControl, Settings:+g,% GuiSettings_Controls[loopedCtrl],% __f 
			}
		}
	}

	/* * On change
	*/

	TabSettingsMain_OnPushBulletTokenChange() {
		global PROGRAM
		iniFile := PROGRAM.INI_FILE

		val := GUI_Settings.Submit("hEDIT_PushBulletToken")
		INI.Set(iniFile, "SETTINGS_MAIN", "PushBulletToken", val)
		Declare_LocalSettings()
	}
	TabSettingsMain_OnPoeAccountsListChange() {
		global PROGRAM
		iniFile := PROGRAM.INI_FILE

		val := GUI_Settings.Submit("hEDIT_PoeAccounts")
		INI.Set(iniFile, "SETTINGS_MAIN", "PoeAccounts", val)
		Declare_LocalSettings()
	}

	TabSettingsMain_ToggleClickthroughCheckbox() {
		global PROGRAM, GuiSettings_Controls
		iniFile := PROGRAM.INI_FILE
		ctrlName := "hCB_AllowClicksToPassThroughWhileInactive"
		iniKey := SubStr(ctrlName, 5)

		cbVal := GUI_Settings.Submit(ctrlName)
		trueFalse := cbVal=0?"False":cbVal=1?"True":cbVal

		newCbVal := !cbVal
		newTrueFalse := newCbVal=0?"False":newCbVal=1?"True":newCbVal

		GuiControl, Settings:,% GuiSettings_Controls[ctrlName],% newCbVal
		; INI.Set(iniFile, "SETTINGS_MAIN", iniKey, newTrueFalse)
		; Declare_LocalSettings()
		GUI_Settings.TabSettingsMain_OnCheckboxToggle(ctrlName)
	}

	TabSettingsMain_OnCheckboxToggle(CtrlName) {	
		global PROGRAM
		iniFile := PROGRAM.INI_FILE

		if IsIn(CtrlName, "hCB_HideInterfaceWhenOutOfGame,hCB_MinimizeInterfaceToBottomLeft,hCB_CopyItemInfosOnTabChange,hCB_AutoFocusNewTabs"
		. ",hCB_AutoMinimizeOnAllTabsClosed,hCB_AutoMaximizeOnFirstNewTab,hCB_TradingWhisperSFXToggle,hCB_BuyerJoinedAreaSFXToggle"
		. ",hCB_RegularWhisperSFXToggle,hCB_AllowClicksToPassThroughWhileInactive,hCB_ShowTabbedTrayNotificationOnWhisper,hCB_SendTradingWhisperUponCopyWhenHoldingCTRL"
		. ",hCB_PushBulletOnTradingWhisper,hCB_PushBulletOnPartyMessage,hCB_PushBulletOnWhisperMessage,hCB_PushBulletOnlyWhenAfk")
			iniKey := SubStr(CtrlName, 5)

		if !(iniKey) {
			MsgBox(4096, "","Invalid INI Key for control: " CtrlName)
			Return
		}

		val := GUI_Settings.Submit(CtrlName)
		trueFalse := val=0?"False":val=1?"True":val

		INI.Set(iniFile, "SETTINGS_MAIN", iniKey, trueFalse)
		Declare_LocalSettings()

		if (CtrlName = "hCB_AllowClicksToPassThroughWhileInactive") {
			if (trueFalse = "True") {
				GUI_Trades.Enable_ClickThrough()
				Menu, Tray, Check, Clickthrough?
			}
			else {
				GUI_Trades.Disable_ClickThrough()
				Menu, Tray, UnCheck, Clickthrough?
			}
		}
	}

	TabSettingsMain_OnSFXBrowse(CtrlName) {
		global PROGRAM, GuiSettings_Controls
		iniFile := PROGRAM.INI_FILE
		programName := PROGRAM.NAME

		FileSelectFile, soundFile, ,% PROGRAM.SFX_FOLDER,% PROGRAM.NAME " - Select an audio file",Audio (*.wav; *.mp3)
		if (!soundFile || ErrorLevel)
			Return

		EditBoxHwnd := CtrlName="hBTN_BrowseTradingWhisperSFX" ? GuiSettings_Controls.hEDIT_TradingWhisperSFXPath
			: CtrlName = "hBTN_BrowseRegularWhisperSFX" ? GuiSettings_Controls.hEDIT_RegularWhisperSFXPath
			: CtrlName = "hBTN_BrowseBuyerJoinedAreaSFX" ? GuiSettings_Controls.hEDIT_BuyerJoinedAreaSFXPath
			: ""

		GuiControl, %A_Gui%:,% EditBoxHwnd,% soundFile

		iniKey := (CtrlName = "hBTN_BrowseTradingWhisperSFX")?("TradingWhisperSFXPath")
		 : (CtrlName = "hBTN_BrowseRegularWhisperSFX")?("RegularWhisperSFXPath")
		 : (CtrlName = "hBTN_BrowseBuyerJoinedAreaSFX")?("BuyerJoinedAreaSFXPath")
		 : ("")

		if !(iniKey) {
			MsgBox(4096, "","Invalid INI Key for control: " CtrlName)
			Return
		}

		INI.Set(iniFile, "SETTINGS_MAIN", iniKey, soundFile)
		Declare_LocalSettings()
	}

	TabSettingsMain_OnTransparencySliderMove(CtrlName) {
		global PROGRAM, GuiTrades
		iniFile := PROGRAM.INI_FILE
		transValue := GUI_Settings.Submit(CtrlName)

		if IsIn(CtrlName, "hSLIDER_TabsOpenTransparency,hSLIDER_NoTabsTransparency")
			iniKey := SubStr(CtrlName, 9)

		if !(iniKey) {
			MsgBox(4096, "", "Invalid INI Key for control: " CtrlName)
			Return
		}

		INI.Set(iniFile, "SETTINGS_MAIN", iniKey, transValue)
		Declare_LocalSettings()

		Gui, Trades:+LastFound
		WinSet, Transparent,% (255/100)*transValue

		if IsIn(A_GuiControlEvent,"Normal,4") {
			if (GuiTrades.Tabs_Count > 0)
				transRevert := PROGRAM.SETTINGS.SETTINGS_MAIN.TabsOpenTransparency
			else if (GuiTrades.Tabs_Count = 0)
				transRevert := PROGRAM.SETTINGS.SETTINGS_MAIN.NoTabsTransparency
			else transRevert := 255

			Gui, Trades:+LastFound
			Winset, Transparent,% (255/100)*transRevert
		}
	}

	/* * Set user settings
	*/

	TabsSettingsMain_SetUserSettings() {
		global PROGRAM, GuiSettings, GuiSettings_Controls
		thisTabSettings := PROGRAM.SETTINGS.SETTINGS_MAIN

		for key, value in thisTabSettings {
			cbValue := value="True"?1 : value="False"?0 : value
			thisTabSettings[key] := cbValue
			; msgbox % key " - " value
		}

		; Checkboxes
		GuiControl, Settings:,% GuiSettings_Controls.hCB_HideInterfaceWhenOutOfGame,% thisTabSettings.HideInterfaceWhenOutOfGame
		GuiControl, Settings:,% GuiSettings_Controls.hCB_MinimizeInterfaceToBottomLeft,% thisTabSettings.MinimizeInterfaceToBottomLeft
		GuiControl, Settings:,% GuiSettings_Controls.hCB_CopyItemInfosOnTabChange,% thisTabSettings.CopyItemInfosOnTabChange
		GuiControl, Settings:,% GuiSettings_Controls.hCB_AutoFocusNewTabs,% thisTabSettings.AutoFocusNewTabs
		GuiControl, Settings:,% GuiSettings_Controls.hCB_AutoMinimizeOnAllTabsClosed,% thisTabSettings.AutoMinimizeOnAllTabsClosed
		GuiControl, Settings:,% GuiSettings_Controls.hCB_AutoMaximizeOnFirstNewTab,% thisTabSettings.AutoMaximizeOnFirstNewTab
		GuiControl, Settings:,% GuiSettings_Controls.hCB_SendTradingWhisperUponCopyWhenHoldingCTRL,% thisTabSettings.SendTradingWhisperUponCopyWhenHoldingCTRL
		; SFX
		GuiControl, Settings:,% GuiSettings_Controls.hCB_TradingWhisperSFXToggle,% thisTabSettings.TradingWhisperSFXToggle
		GuiControl, Settings:,% GuiSettings_Controls.hCB_RegularWhisperSFXToggle,% thisTabSettings.RegularWhisperSFXToggle
		GuiControl, Settings:,% GuiSettings_Controls.hCB_BuyerJoinedAreaSFXToggle,% thisTabSettings.BuyerJoinedAreaSFXToggle
		GuiControl, Settings:,% GuiSettings_Controls.hEDIT_TradingWhisperSFXPath,% thisTabSettings.TradingWhisperSFXPath
		GuiControl, Settings:,% GuiSettings_Controls.hEDIT_RegularWhisperSFXPath,% thisTabSettings.RegularWhisperSFXPath
		GuiControl, Settings:,% GuiSettings_Controls.hEDIT_BuyerJoinedAreaSFXPath,% thisTabSettings.BuyerJoinedAreaSFXPath
		GuiControl, Settings:,% GuiSettings_Controls.hCB_ShowTabbedTrayNotificationOnWhisper,% thisTabSettings.ShowTabbedTrayNotificationOnWhisper
		; Pushbullet
		GuiControl, Settings:,% GuiSettings_Controls.hEDIT_PushBulletToken,% thisTabSettings.PushBulletToken
		GuiControl, Settings:,% GuiSettings_Controls.hCB_PushBulletOnTradingWhisper,% thisTabSettings.PushBulletOnTradingWhisper
		GuiControl, Settings:,% GuiSettings_Controls.hCB_PushBulletOnPartyMessage,% thisTabSettings.PushBulletOnPartyMessage
		GuiControl, Settings:,% GuiSettings_Controls.hCB_PushBulletOnWhisperMessage,% thisTabSettings.PushBulletOnWhisperMessage
		GuiControl, Settings:,% GuiSettings_Controls.hCB_PushBulletOnlyWhenAfk,% thisTabSettings.PushBulletOnlyWhenAfk
		; Send Mode
		GuiControl, Settings:ChooseString,% GuiSettings_Controls.hDDL_SendMsgMode,% thisTabSettings.SendMsgMode
		GUI_Settings.TabSettingsMain_OnSendMsgModeChange()
		; Transparency
		GuiControl, Settings:,% GuiSettings_Controls.hCB_AllowClicksToPassThroughWhileInactive,% thisTabSettings.AllowClicksToPassThroughWhileInactive
		GuiControl, Settings:,% GuiSettings_Controls.hSLIDER_NoTabsTransparency,% thisTabSettings.NoTabsTransparency
		GuiControl, Settings:,% GuiSettings_Controls.hSLIDER_TabsOpenTransparency,% thisTabSettings.TabsOpenTransparency
		; Accounts
		GuiControl, Settings:,% GuiSettings_Controls.hEDIT_PoeAccounts,% thisTabSettings.PoeAccounts
	}

	TabSettingsMain_OnSendMsgModeChange() {
		global PROGRAM, GuiSettings, GuiSettings_Controls

		sMode := Gui_Settings.Submit("hDDL_SendMsgMode")
		INI.Set(PROGRAM.INI_FILE, "SETTINGS_MAIN", "SendMsgMode", sMode)

		tipMsg := sMode="SendInput"?"SendInput: This is the fastest."
			. "`nPresses all keys from the message individually."
			. "`n`nCaution:"
			. "`nYou may get kicked for ""Performing too many actions too quickly"""
			. "`nwhen using this mode due to the chat box not opening fast enough,"
			. "`nresulting in the key presses opening in-game panels / using flasks / etc."

			: sMode="SendEvent"?"SendEvent: Works similarly to SendInput."
			. "`nAdds a small delay between keypresses."

			: sMode="Clipboard"?"Clipboard: Recommended. The most reliable."
			. "`nPerforms slighly slower than SendInput."
			. "`nMakes use of the clipboard to send the message, keeping"
			. "`nyou completely safe from ""Performing too many actions too quickly""."

			: "Choose a mode to have informations about how it works."
		txtSize := Get_TextCtrlSize(tipMsg, GuiSettings.Font, GuiSettings.Font_Size)
		GuiControl, Settings:Move,% GuiSettings_Controls.hTXT_SendMessagesModeTip,% "w" txtSize.W " h" txtSize.H
		GuiControl, Settings:,% GuiSettings_Controls.hTXT_SendMessagesModeTip,% tipMsg

		Declare_LocalSettings()
	}

	/* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * 
	*	TAB CUSTOMIZATIONS SKIN FUNCTIONS
	*/

	/* * Subroutines
	*/

	TabCustomizationSkins_EnableSubroutines() {
		GUI_Settings.TabCustomizationSkins_ToggleSubroutines("Enable")
	}

	TabCustomizationSkins_DisableSubroutines() {
		GUI_Settings.TabCustomizationSkins_ToggleSubroutines("Disable")
	}

	TabCustomizationSkins_ToggleSubroutines(enableOrDisable) {
		global GuiSettings, GuiSettings_Controls
		thisTabCtrls := GuiSettings.TabCustomizationSkins_Controls

		Loop, Parse, thisTabCtrls,% ","
		{
			loopedCtrl := A_LoopField

			if (enableOrDisable = "Disable")
				GuiControl, Settings:-g,% GuiSettings_Controls[loopedCtrl]
			else if (enableOrDisable = "Enable") {
				if (loopedCtrl = "hDDL_SkinPreset")
					__f := GUI_Settings.TabCustomizationSkins_OnPresetChange.bind(GUI_Settings)
				else if (loopedCtrl = "hLB_SkinBase")
					__f := GUI_Settings.TabCustomizationSkins_OnSkinChange.bind(GUI_Settings)
				else if (loopedCtrl = "hLB_SkinFont")
					__f := GUI_Settings.TabCustomizationSkins_OnFontChange.bind(GUI_Settings)
				else if (loopedCtrl = "hCB_UseRecommendedFontSettings")
					__f := GUI_Settings.TabCustomizationSkins_OnRecommendedFontSettingsToggle.bind(GUI_Settings)
				else if (loopedCtrl = "hEDIT_SkinFontSize")
					__f := GUI_Settings.TabCustomizationSkins_OnFontSizeChange.bind(GUI_Settings)
				else if (loopedCtrl = "hEDIT_SkinFontQuality")
					__f := GUI_Settings.TabCustomizationSkins_OnFontQualityChange.bind(GUI_Settings)
				else if (loopedCtrl = "hEDIT_SkinScalingPercentage")
					__f := GUI_Settings.TabCustomizationSkins_OnScalePercentageChange.bind(GUI_Settings)
				else if (loopedCtrl = "hDDL_ChangeableFontColorTypes")
					__f := GUI_Settings.TabCustomizationsSkins_OnChangeableColorTypeChange.bind(GUI_Settings)
				else if (loopedCtrl = "hBTN_ShowColorPicker")
					__f := GUI_Settings.TabCustomizationSkins_ShowColorPicker.bind(GUI_Settings)
				else if (loopedCtrl = "hBTN_RecreateTradesGUI")
					__f := GUI_Settings.TabCustomizationSkins_RecreateTradesGUI.bind(GUI_Settings)
				else 
					__f := 

				if (__f)
					GuiControl, Settings:+g,% GuiSettings_Controls[loopedCtrl],% __f 
			}
		}
	}

	/* * GET
	*/

	TabCustomizationSkins_GetSkinDefaultSettings(skinName) {
		global PROGRAM

		skinFontSettings := Ini.Get(PROGRAM.SKINS_FOLDER "\" skinName "\Settings.ini", "FONT",,1)
		skinColorSettings := Ini.Get(PROGRAM.SKINS_FOLDER "\" skinName "\Settings.ini", "COLORS",,1)

		skinDefSettings := { Skin:skinName, Font:skinFontSettings.Name, FontSize:skinFontSettings.Size
			,FontQuality:skinFontSettings.Quality, ScalingPercentage:100, UseRecommendedFontSettings:True }
		for iniKey, iniValue in skinColorSettings
			skinDefSettings["Color_" iniKey] := iniValue

		Return skinDefSettings
	}

	TabCustomizationSkins_GetPresetSettings(presetName) {
		global PROGRAM

		if (presetName = "User Defined") { ; Get settings from user ini
			userDefSettings := PROGRAM.SETTINGS.SETTINGS_CUSTOMIZATION_SKINS_UserDefined
			; presetSettings := {	Name: userDefSettings.Name,	Skin: userDefSettings.Skin,	Font: userDefSettings.Font,	FontSize: userDefSettings.FontSize
				; , FontQuality: userDefSettings.FontQuality, ScalingPercentage: userDefSettings.ScalingPercentage, UseRecommendedFontSettings: userDefSettings.UseRecommendedFontSettings }
			presetSettings := {}
			for iniKey, iniValue in userDefSettings
				presetSettings[iniKey] := iniValue
		}
		else { ; Get settings from fonts folder ini
			skinFontSettings := Ini.Get(PROGRAM.SKINS_FOLDER "\" presetName "\Settings.ini", "FONT",,1)
			skinColorSettings := Ini.Get(PROGRAM.SKINS_FOLDER "\" presetName "\Settings.ini", "COLORS",,1)

			presetSettings := { Name:presetName, Skin:presetName, Font:skinFontSettings.Name, FontSize:skinFontSettings.Size
				,FontQuality:skinFontSettings.Quality, ScalingPercentage:100, UseRecommendedFontSettings:True }
			for iniKey, iniValue in skinColorSettings
				presetSettings["Color_" iniKey] := iniValue
		}

		Return presetSettings
	}

	TabCustomizationSkins_GetFontRecommendedSettings(_fontName="") {
		global PROGRAM
		fontName := _fontName

		if (fontName = "")
			fontName := GUI_Settings.Submit("hLB_SkinFont")

		fontSize := INI.Get(PROGRAM.FONTS_SETTINGS_FILE, "Size", fontName,1)
		fontQuality := INI.Get(PROGRAM.FONTS_SETTINGS_FILE, "Quality", fontName,1)
		
		if !IsNum(fontSize)
			fontSize := INI.Get(PROGRAM.FONTS_SETTINGS_FILE, "Size", "Default",1)
		if !IsNum(fontQuality)
			fontQuality := INI.Get(PROGRAM.FONTS_SETTINGS_FILE, "Quality", "Default",1)

		Return {Size:fontSize,Quality:fontQuality}
	}

	TabCustomizationSkins_GetAvailablePresets() {
		global PROGRAM

		availablePresets := "User Defined|"

		Loop,% PROGRAM.SKINS_FOLDER "\*", 1, 0
		{
			if FileExist(A_LoopFileFullPath "\Assets.ini")
				availablePresets .= A_LoopFileName "|"
		}
		StringTrimRight, availablePresets, availablePresets, 1

		return availablePresets
	}

	TabCustomizationSkins_GetAvailableSkins() {
		global PROGRAM

		Loop,% PROGRAM.SKINS_FOLDER "\*", 1, 0
		{
			if FileExist(A_LoopFileFullPath "\Assets.ini")
				availableSkins .= A_LoopFileName "|"
		}
		StringTrimRight, availableSkins, availableSkins, 1

		return availableSkins
	}

	TabCustomizationSkins_GetAvailableFonts() {
		global PROGRAM

		for fontTitle, fontHandle in PROGRAM.FONTS {
			if (fontTitle != "TC_Symbols")
				availableFonts .= fontTitle "|"
		}
		StringTrimRight, availableFonts, availableFonts, 1	

		return availableFonts
	}

	/* * SET
	*/

	TabCustomizationSkins_SetAvailablePresets(presetsList) {
		global GuiSettings_Controls
		GuiControl, Settings:,% GuiSettings_Controls.hDDL_SkinPreset,% "|" presetsList
	}

	TabCustomizationSkins_SetAvailableSkins(skinsList) {
		global GuiSettings_Controls
		GuiControl, Settings:,% GuiSettings_Controls.hLB_SkinBase,% "|" skinsList	
	}

	TabCustomizationSkins_SetAvailableFonts(fontsList) {
		global GuiSettings_Controls
		GuiControl, Settings:,% GuiSettings_Controls.hLB_SkinFont,% "|" fontsList	
	}

	TabCustomizationSkins_SetUserSettings() {
		global PROGRAM, GuiSettings, GuiSettings_Controls
		iniSettings := PROGRAM.SETTINGS.SETTINGS_CUSTOMIZATION_SKINS

		availablePresets := GUI_Settings.TabCustomizationSkins_GetAvailablePresets()
		availableSkins := GUI_Settings.TabCustomizationSkins_GetAvailableSkins()
		availableFonts := GUI_Settings.TabCustomizationSkins_GetAvailableFonts()

		GUI_Settings.TabCustomizationSkins_SetAvailablePresets(availablePresets)
		GUI_Settings.TabCustomizationSkins_SetAvailableSkins(availableSkins)
		GUI_Settings.TabCustomizationSkins_SetAvailableFonts(availableFonts)

		GUI_Settings.TabCustomizationSkins_SetPreset(iniSettings.Preset) ; This function will take care of choosing skin/font/etc based on preset
		GUI_Settings.TabCustomizationSkins_SetChangeableFontColorTypes()
	}

	TabCustomizationSkins_SetChangeableFontColorTypes() {
		global GuiSettings_Controls, COLORS_TYPES

		for iniKey, typeName in COLORS_TYPES {
			if (iniKey)
				typesList .= "|" typeName
		}

		GuiControl, Settings:,% GuiSettings_Controls.hDDL_ChangeableFontColorTypes,% typesList
		GuiControl, Settings:Choose,% GuiSettings_Controls.hDDL_ChangeableFontColorTypes, 1
		GUI_Settings.TabCustomizationsSkins_OnChangeableColorTypeChange()
	}

	TabCustomizationsSkins_OnChangeableColorTypeChange() {
		global GuiSettings_Controls, COLORS_TYPES
		colType := GUI_Settings.Submit("hDDL_ChangeableFontColorTypes")

		presetSettings := GUI_Settings.TabCustomizationSkins_GetPresetSettings(GUI_Settings.Submit("hDDL_SkinPreset"))
		typeShortName := GUI_Settings.Get_ColorTypeShortName_From_LongName(colType)
		GuiControl,% "Settings:+Background" presetSettings["Color_" typeShortName],% GuiSettings_Controls.hPROGRESS_ColorSquarePreview
	}

	Get_ColorTypeShortName_From_LongName(longName) {
		global COLORS_TYPES

		for sName, lName in COLORS_TYPES
			if (lName = longName)
				return sName
	}

	Get_ColorTypeLongName_From_ShortName(shortName) {
		global COLORS_TYPES
		return COLORS_TYPES[shortName]
	}

	TabCustomizationSkins_ShowColorPicker() {
		global PROGRAM, GuiSettings, GuiSettings_Controls
		iniFile := PROGRAM.INI_FILE

		colType := GUI_Settings.Submit("hDDL_ChangeableFontColorTypes")
		typeShortName := GUI_Settings.Get_ColorTypeShortName_From_LongName(colType)
		presetSettings := GUI_Settings.TabCustomizationSkins_GetPresetSettings(GUI_Settings.Submit("hDDL_SkinPreset"))
		
		Colors := []
		for settingType, settingValue in presetSettings {
			if ( SubStr(settingType, 1, 6) = "Color_") && !IsIn(settingValue, colorsList) {
				colorsList := !colorsList?settingValue : colorsList "," settingValue
				Colors.Push(settingValue)
			}
		}

	    MyColor := ChooseColor(presetSettings["Color_" typeShortName], GuiSettings.Handle, , , Colors*)
		GuiControl, Settings:+Background%MyColor%,% GuiSettings_Controls.hPROGRESS_ColorSquarePreview
		if (!ErrorLevel && MyColor != presetSettings["Color_" typeShortName]) {
			GuiControl, Settings:ChooseString,% GuiSettings_Controls.hDDL_SkinPreset,% "User Defined"
			INI.Set(iniFile, "SETTINGS_CUSTOMIZATION_SKINS_UserDefined", "Color_" typeShortName, MyColor)
			GUI_Settings.TabCustomizationSkins_SaveSettings()
			Declare_LocalSettings()
		}
	}

	TabCustomizationSkins_SaveDefaultSkinSettings_To_UserDefined(skinName) {
		global PROGRAM
		iniFile := PROGRAM.INI_FILE

		if !(skinName)
			skinName := Gui_Settings.Submit(hLB_SkinBase)

		skinDefSettings := Gui_Settings.TabCustomizationSkins_GetSkinDefaultSettings(skinName)

		skinDefSettings := Gui_Settings.TabCustomizationSkins_GetSkinDefaultSettings(GUI_Settings.Submit("hLB_SkinBase"))
		for key, value in skinDefSettings {
			if InStr(key, "Color_") {
				INI.Set(iniFile, "SETTINGS_CUSTOMIZATION_SKINS_UserDefined", key, skinDefSettings[key])
			}
		}
	}

	TabCustomizationSkins_SaveSettings(saveAsUserDefined=False) {
		global PROGRAM
		global GuiSettings, GuiSettings_Controls, GuiSettings_Submit
		iniFile := PROGRAM.INI_FILE

		GUI_Settings.Submit()
		sub := GuiSettings_Submit

		iniSection := (saveAsUserDefined)?("SETTINGS_CUSTOMIZATION_SKINS_UserDefined"):("SETTINGS_CUSTOMIZATION_SKINS")

		INI.Set(iniFile, iniSection, "Preset", sub.hDDL_SkinPreset)
		INI.Set(iniFile, iniSection, "Skin", sub.hLB_SkinBase)
		INI.Set(iniFile, iniSection, "Font", sub.hLB_SkinFont)
		INI.Set(iniFile, iniSection, "ScalingPercentage", sub.hEDIT_SkinScalingPercentage)
		INI.Set(iniFile, iniSection, "FontSize", sub.hEDIT_SkinFontSize)
		INI.Set(iniFile, iniSection, "FontQuality", sub.hEDIT_SkinFontQuality)
		toggle := sub.hCB_UseRecommendedFontSettings
		toggle := toggle=0?"False":toggle=1?"True":toggle
		INI.Set(iniFile, iniSection, "UseRecommendedFontSettings", toggle)

		if (saveAsUserDefined) {
			skinDefSettings := Gui_Settings.TabCustomizationSkins_GetSkinDefaultSettings(sub.hLB_SkinBase)
			userSkinSettings := Get_LocalSettings().SETTINGS_CUSTOMIZATION_SKINS_UserDefined
			for key, value in skinDefSettings {
				if InStr(key, "Color_") {
					presetVal := skinDefSettings[key], userVal := userSkinSettings[key]
					iniValue := IsHex(userVal) && (StrLen(userVal) = 8) ? userVal : presetVal
					
					INI.Set(iniFile, iniSection, key, iniValue)
				}
			}
		}

		Declare_LocalSettings()

		if (saveAsUserDefined=True)
			Return
		else if (sub.hDDL_SkinPreset = "User Defined")
			GUI_Settings.TabCustomizationSkins_SaveSettings(True)
	}

	TabCustomizationSkins_SetPreset(presetName="", presetSettings="") {
		global GuiSettings, GuiSettings_Controls

		; Prevent user from switching preset while we apply current settings
		GuiSettings.Is_Changing_Preset := True
		GUI_Settings.TabCustomizationSkins_DisableSubroutines()
		GuiControl, Settings:Disable,% GuiSettings_Controls.hDDL_SkinPreset

		; If no preset name specified, get current preset selected instead
		if (presetName = "")
			presetName := GUI_Settings.Submit("hDDL_SkinPreset")

		; If no settings specified, get preset's settings
		if !IsObject(presetSettings) {
			presetSettings := GUI_Settings.TabCustomizationSkins_GetPresetSettings(presetName)
			for key, element in currentPresetSettings {
				if (presetSettings[key] = "")
					presetSettings[key] := element
			}
		}

		; Choose the preset and apply its settings
		GuiControl, Settings:ChooseString,% GuiSettings_Controls.hDDL_SkinPreset,% presetName
		GUI_Settings.TabCustomizationSkins_SetSkin(presetSettings.Skin)
		GUI_Settings.TabCustomizationSkins_SetFont(presetSettings.Font)
		GUI_Settings.TabCustomizationSkins_SetFontSizeAndQuality(presetSettings.FontSize, presetSettings.FontQuality)
		GUI_Settings.TabCustomizationSkins_SetScalePercentage(presetSettings.ScalingPercentage)
		GUI_Settings.TabCustomizationSkins_SetRecommendedFontSettings(presetSettings.UseRecommendedFontSettings)
		GUI_Settings.TabCustomizationSkins_SetChangeableFontColorTypes()

		; Done applying settings
		; Sleep 100 ; Slight sleep to prevent subroutine from detecting IsChangingPreset change
		GUI_Settings.TabCustomizationSkins_EnableSubroutines()
		GuiControl, Settings:Enable,% GuiSettings_Controls["hDDL_SkinPreset"]
		GuiControl, Settings:Focus,% GuiSettings_Controls["hDDL_SkinPreset"]
		
		; Save newly applied settings
		GUI_Settings.TabCustomizationSkins_SaveSettings()
		GuiSettings.Is_Changing_Preset := False
	}

	TabCustomizationSkins_SetSkin(skinName) {
		global PROGRAM, GuiSettings, GuiSettings_Controls
		GuiControl, Settings:ChooseString,% GuiSettings_Controls.hLB_SkinBase,% skinName
	}

	TabCustomizationSkins_SetFont(fontName) {
		global PROGRAM, GuiSettings, GuiSettings_Controls
		GuiControl, Settings:ChooseString,% GuiSettings_Controls.hLB_SkinFont,% fontName
		GUI_Settings.TabCustomizationSkins_SetFontSettingsState(GUI_Settings.Submit("hCB_UseRecommendedFontSettings"))
	}

	TabCustomizationSkins_SetFontSizeAndQuality(fontSize, fontQual) {
		global PROGRAM, GuiSettings, GuiSettings_Controls
		GuiControl, Settings:,% GuiSettings_Controls.hEDIT_SkinFontSize,% fontSize
		GuiControl, Settings:,% GuiSettings_Controls.hEDIT_SkinFontQuality,% fontQual
	}

	TabCustomizationSkins_SetRecommendedFontSettings(checkState) {
		global PROGRAM, GuiSettings, GuiSettings_Controls
		checkState := checkState="True"?1 : checkState="False"?0 : checkState
		GuiControl, Settings:,% GuiSettings_Controls.hCB_UseRecommendedFontSettings,% checkState
		GUI_Settings.TabCustomizationSkins_SetFontSettingsState(GUI_Settings.Submit("hCB_UseRecommendedFontSettings"))
	}

	TabCustomizationSkins_SetScalePercentage(scalePercentage) {
		global PROGRAM, GuiSettings, GuiSettings_Controls
		GuiControl, Settings:,% GuiSettings_Controls.hEDIT_SkinScalingPercentage,% scalePercentage
	}

	TabCustomizationSkins_SetFontSettingsState(state) {
		global PROGRAM, GuiSettings_Controls 
		iniFile := PROGRAM.INI_FILE

		enableOrDisable := (state=1 || state = "Disable")?("Disable")
		: (state=0 || state = "Enable")?("Enable")
		: ("")

		if (state = "") {
			MsgBox(4096, "", "Invalid usage of " A_ThisFunc "`nParam: " state "`nenableOrDisable: " enableOrDisable)
			Return
		}

		GuiControl, Settings:%enableOrDisable%,% GuiSettings_Controls.hEDIT_SkinFontSize
		GuiControl, Settings:%enableOrDisable%,% GuiSettings_Controls.hEDIT_SkinFontQuality
		GuiControl, Settings:%enableOrDisable%,% GuiSettings_Controls.hUPDOWN_SkinFontSize
		GuiControl, Settings:%enableOrDisable%,% GuiSettings_Controls.hUPDOWN_SkinFontQuality

		if (state = "Disable") {
			selectedFont := GUI_Settings.Submit("hLB_SkinFont")
			fontSettings := GUI_Settings.TabCustomizationSkins_GetFontRecommendedSettings(selectedFont)
			GUI_Settings.TabCustomizationSkins_SetFontSizeAndQuality(selectedFont.Size, selectedFont.Quality)
		}
	}

	TabCustomizationSkins_RecreateTradesGUI() {
		TrayNotifications.Show("POE Trades Companion", "Recreating the Trades window with the new skin settings")
		UpdateHotkeys()
		Declare_SkinAssetsAndSettings()
		Gui_TradesMinimized.Create()
		Gui_Trades.RecreateGUI()
	}

	/* * On Change
	*/

	TabCustomizationSkins_OnFontChange() {
		global PROGRAM, GuiSettings, GuiSettings_Controls
		iniFile := PROGRAM.INI_FILE

		if (GuiSettings.Is_Changing_Preset)
			Return

		selectedFont := GUI_Settings.Submit("hLB_SkinFont")
		GuiControl, Settings:ChooseString,% GuiSettings_Controls.hDDL_SkinPreset,% "User Defined"

		fontSettings := GUI_Settings.TabCustomizationSkins_GetFontRecommendedSettings(selectedFont)
		GUI_Settings.TabCustomizationSkins_SetFontSizeAndQuality(fontSettings.Size, fontSettings.Quality)
		GUI_Settings.TabCustomizationSkins_SetFontSettingsState(GUI_Settings.Submit("hCB_UseRecommendedFontSettings"))

		GUI_Settings.TabCustomizationSkins_SaveSettings()
	}

	TabCustomizationSkins_OnSkinChange() {
		global PROGRAM, GuiSettings, GuiSettings_Controls
		iniFile := PROGRAM.INI_FILE

		if (GuiSettings.Is_Changing_Preset)
			Return

		GuiControl, Settings:ChooseString,% GuiSettings_Controls.hDDL_SkinPreset,% "User Defined"

		GUI_Settings.TabCustomizationSkins_SaveDefaultSkinSettings_To_UserDefined(GUI_Settings.Submit("hLB_SkinBase"))
		GUI_Settings.TabCustomizationSkins_SaveSettings()
		GUI_Settings.TabCustomizationSkins_SetChangeableFontColorTypes()
	}

	TabCustomizationSkins_OnPresetChange() {
		global PROGRAM, GuiSettings, GuiSettings_Controls

		if (GuiSettings.Is_Changing_Preset)
			Return

		selectedPreset := GUI_Settings.Submit("hDDL_SkinPreset")
		GUI_Settings.TabCustomizationSkins_SetPreset(selectedPreset)
		GUI_Settings.TabCustomizationSkins_SaveSettings()
	}

	TabCustomizationSkins_OnScalePercentageChange() {
		global PROGRAM, GuiSettings, GuiSettings_Controls
		iniFile := PROGRAM.INI_FILE

		if (GuiSettings.Is_Changing_Preset)
			Return

		scalePercent := GUI_Settings.Submit("hEDIT_SkinScalingPercentage")
		GuiControl, Settings:ChooseString,% GuiSettings_Controls.hDDL_SkinPreset,% "User Defined"

		GUI_Settings.TabCustomizationSkins_SaveSettings()
	}

	TabCustomizationSkins_OnFontQualityChange() {
		global PROGRAM, GuiSettings, GuiSettings_Controls
		iniFile := PROGRAM.INI_FILE

		if (GuiSettings.Is_Changing_Preset)
			Return

		fontQual := GUI_Settings.Submit("hEDIT_SkinFontQuality")
		GuiControl, Settings:ChooseString,% GuiSettings_Controls.hDDL_SkinPreset,% "User Defined"
		GUI_Settings.TabCustomizationSkins_SetFontSettingsState(GUI_Settings.Submit("hCB_UseRecommendedFontSettings"))

		GUI_Settings.TabCustomizationSkins_SaveSettings()
	}

	TabCustomizationSkins_OnFontSizeChange() {
		global PROGRAM, GuiSettings, GuiSettings_Controls
		iniFile := PROGRAM.INI_FILE

		if (GuiSettings.Is_Changing_Preset)
			Return

		fontSize := GUI_Settings.Submit("hEDIT_SkinFontSize")
		GuiControl, Settings:ChooseString,% GuiSettings_Controls.hDDL_SkinPreset,% "User Defined"
		GUI_Settings.TabCustomizationSkins_SetFontSettingsState(GUI_Settings.Submit("hCB_UseRecommendedFontSettings"))

		GUI_Settings.TabCustomizationSkins_SaveSettings()

	}

	TabCustomizationSkins_OnRecommendedFontSettingsToggle() {
		global PROGRAM, GuiSettings, GuiSettings_Controls
		iniFile := PROGRAM.INI_FILE

		if (GuiSettings.Is_Changing_Preset)
			Return

		cbState := GUI_Settings.Submit("hCB_UseRecommendedFontSettings")
		GuiControl, Settings:ChooseString,% GuiSettings_Controls.hDDL_SkinPreset,% "User Defined"
		GUI_Settings.TabCustomizationSkins_SetFontSettingsState(GUI_Settings.Submit("hCB_UseRecommendedFontSettings"))

		GUI_Settings.TabCustomizationSkins_SaveSettings()
	}

	/* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * 
	*	TAB CUSTOMIZATIONS BUTTON FUNCTIONS
	*/

	TabCustomizationButtons_DisableSubroutines() {
		GUI_Settings.TabCustomizationButtons_ToggleSubroutines("Disable")
	}
	TabCustomizationButtons_EnableSubroutines() {
		GUI_Settings.TabCustomizationButtons_ToggleSubroutines("Enable")
	}
	TabCustomizationButtons_ToggleSubroutines(enableOrDisable) {
		global GuiSettings, GuiSettings_Controls
		thisTabCtrls := GuiSettings.TabCustomizationButtons_Controls

		Loop, Parse, thisTabCtrls,% ","
		{
			loopedCtrl := A_LoopField

			RegExMatch(loopedCtrl, "\D+", loopedCtrl_NoNum)
			RegExMatch(loopedCtrl, "\d+", loopedCtrl_NumOnly)

			if (enableOrDisable = "Disable")
				GuiControl, Settings:-g,% GuiSettings_Controls[loopedCtrl]
			else if (enableOrDisable = "Enable") {
				if (loopedCtrl_NoNum = "hBTN_CustomBtn_")
					__f := GUI_Settings.TabCustomizationButtons_OnCustomButtonClick.bind(GUI_Settings, loopedCtrl_NumOnly)
				else if (loopedCtrl_NoNum = "hTEXT_CustomBtnSlot_")
					__f := GUI_Settings.TabCustomizationButtons_OnCustomButtonSlotClick.bind(GUI_Settings, loopedCtrl_NumOnly)
				else if (loopedCtrl_NoNum = "hBTN_UnicodeBtn_")
					__f := GUI_Settings.TabCustomizationButtons_OnUnicodeButtonClick.bind(GUI_Settings, loopedCtrl_NumOnly)
				else if (loopedCtrl_NoNum = "hTEXT_UnicodeBtnSlot_")
					__f := GUI_Settings.TabCustomizationButtons_OnUnicodeButtonSlotClick.bind(GUI_Settings, loopedCtrl_NumOnly)
				else if (loopedCtrl = "hDDL_ActionType")
					__f := GUI_Settings.TabCustomizationButtons_OnActionTypeChange.bind(GUI_Settings)
				else if (loopedCtrl = "hEDIT_ActionContent")
					__f := GUI_Settings.TabCustomizationButtons_OnActionContentChange.bind(GUI_Settings)
				else if (loopedCtrl = "hLV_ButtonsActions")
					__f := GUI_Settings.TabCustomizationButtons_OnActionsListClick.bind(GUI_Settings)
				else if (loopedCtrl = "hBTN_SaveChangesToAction")
					__f := GUI_Settings.TabCustomizationButtons_ShowSaveChangesMenu.bind(GUI_Settings)
				else if (loopedCtrl = "hBTN_AddAsNewAction")
					__f := GUI_Settings.TabCustomizationButtons_AddAction.bind(GUI_Settings, "Push", whichPos:="")
				else 
					__f := 

				if (__f)
					GuiControl, Settings:+g,% GuiSettings_Controls[loopedCtrl],% __f 
			}
		}
	}


	TabCustomizationButtons_SetUserSettings() {
		GUI_Settings.TabCustomizationButtons_CustomButton_UpdateSlots()
		GUI_Settings.TabCustomizationButtons_CustomButton_SetSlotSettings()
		GUI_Settings.TabCustomizationButtons_CustomButton_UpdateSlots()

		GUI_Settings.TabCustomizationButtons_UnicodeButton_UpdateSlots()
		GUI_Settings.TabCustomizationButtons_UnicodeButton_SetSlotSettings()
		GUI_Settings.TabCustomizationButtons_UnicodeButton_UpdateSlots()
	}

	Get_AvailableActions_With_CustomButtonsNames() {
		global PROGRAM, ACTIONS_AVAILABLE, ACTIONS_TEXT_NAME

		actionsList := ACTIONS_AVAILABLE
			. "| "
			. "|----- Custom Buttons -----"

		Loop 9 {
			btnName := PROGRAM.SETTINGS["SETTINGS_CUSTOM_BUTTON_" A_Index].Name
			btnEnabled := PROGRAM.SETTINGS["SETTINGS_CUSTOM_BUTTON_" A_Index].Enabled
			if (btnName && btnEnabled = "True") {
				ACTIONS_TEXT_NAME["CUSTOM_BUTTON_" A_Index] := btnName
				actionsList .= "|" btnName
			}
			else 
				ACTIONS_TEXT_NAME.Remove("CUSTOM_BUTTON_" A_Index)
			
		}

		Return actionsList
	}

	TabCustomizationButtons_SetAvailableActions() {
		global GuiSettings, GuiSettings_Controls, ACTIONS_AVAILABLE
		actionsList := ACTIONS_AVAILABLE
		GuiControl, Settings:,% GuiSettings_Controls.hDDL_ActionType,% "|" actionsList
		GuiControl, Settings:Choose,% GuiSettings_Controls.hDDL_ActionType,% " "
	}

	TabCustomizationButtons_OnActionTypeChange() {
		global GuiSettings_Controls
		global ACTIONS_READONLY, ACTIONS_FORCED_CONTENT

		actionType := GUI_Settings.Submit("hDDL_ActionType"), AutoTrimStr(actionType)
		CtrlHwnd := GuiSettings_Controls.hDDL_ActionType
		ActionContentCtrlHwnd := GuiSettings_Controls.hEDIT_ActionContent
		actionContent := GUI_Settings.Submit("hEDIT_ActionContent")

		actionShortName := GUI_Settings.Get_ActionShortName_From_LongName(actionType)
		contentPlaceholder := GUI_Settings.Get_ActionContentPlaceholder_From_ShortName(actionShortName)
		SetEditCueBanner(GuiSettings_Controls.hEDIT_ActionContent, contentPlaceholder)
		ShowToolTip(contentPlaceholder)

		if IsContaining(actionType, "----") || (!actionType) {
			GetKeyState, isUpArrowPressed, Up, P
			GetKeyState, isDownArrowPressed, Down, P

			GuiControl, Settings:+AltSubmit,% CtrlHwnd
			chosenItemNum := GUI_Settings.Submit("hDDL_ActionType")
			GuiControl, Settings:-AltSubmit,% CtrlHwnd

			if (isUpArrowPressed = "D") {
				if (chosenItemNum = 1)
					GuiControl, Settings:Choose,% CtrlHwnd,% 2
				else GuiControl, Settings:Choose,% CtrlHwnd,% chosenItemNum-1 ; TO_DO apparently bug, chose first space instead of closest one, though it works fine in custom button
			}
			else ; just go down
				GuiControl, Settings:Choose,% CtrlHwnd,% chosenItemNum+1

			Sleep 10

			actionType := GUI_Settings.Submit("hDDL_ActionType")
			GUI_Settings.TabCustomizationButtons_SetActionType(actionType)
			GUI_Settings.TabCustomizationButtons_OnActionTypeChange()
			Return
		}
		else {
			if (actionType)
				GuiControl, Settings:ChooseString,% CtrlHwnd,% actionType
		}

		if IsIn(actionShortName, ACTIONS_READONLY) {
			GuiControl, Settings:+ReadOnly,% ActionContentCtrlHwnd
		}
		else {
			GuiControl, Settings:-ReadOnly,% ActionContentCtrlHwnd
		}

		for sName, fContent in ACTIONS_FORCED_CONTENT {
			if (sName = actionShortName) {
				forcedContent := fContent
				Break
			}
		}
		if (forcedContent) {
			GUI_Settings.TabCustomizationButtons_SetActionContent(forcedContent)
		}
		else
			GUI_Settings.TabCustomizationButtons_SetActionContent("")
	}

	TabCustomizationButtons_SetActionType(actionType) {
		global GuiSettings_Controls
		GuiControl, Settings:Choose,% GuiSettings_Controls.hDDL_ActionType,% actionType
	}

	TabCustomizationButtons_OnActionContentChange() {
		global PROGRAM, GuiSettings, GuiSettings_Controls 

		actionType := GUI_Settings.Submit("hDDL_ActionType")
		actionContent := GUI_Settings.Submit("hEDIT_ActionContent")
		actionShortName := GUI_Settings.Get_ActionShortName_From_LongName(actionType)
		actionForcedContent := GUI_Settings.Get_ActionForcedContent_From_ActionShortName(actionShortName)

		GUI_Settings.TabCustomizationButtons_DisableSubroutines()

		if (actionForcedContent) {
			strL := StrLen(actionForcedContent)
			contentSubStr  := SubStr(actionContent, 1, strL)

			if (contentSubStr != actionForcedContent) {
				GUI_Settings.TabCustomizationButtons_SetActionContent(actionForcedContent)
				ShowToolTip("The string has to start with """ actionForcedContent """")
				tipWarn := True, actionContent := actionForcedContent
			}
			else if (actionShortName = "SLEEP") {
				AutoTrimStr(actionContent)

				if (actionContent) && ( !IsDigit(actionContent) || IsContaining(actionContent, ".") ) {
					GUI_Settings.TabCustomizationButtons_SetActionContent(100)
					ShowToolTip("This value can only be an integer.")
					tipWarn := True, actionContent := 100
				}
				else if IsDigit(actionContent) && (actionContent > 1000) {
					GUI_Settings.TabCustomizationButtons_SetActionContent(1000)
					ShowToolTip("Max value is 1000 milliseconds.")
					tipWarn := True, actionContent := 1000
				}
			}
		}

		if (!tipWarn) && (actionContent) && (actionContent != actionForcedContent)
			ShowToolTip(actionContent)

		GUI_Settings.TabCustomizationButtons_EnableSubroutines()
	}

	TabCustomizationButtons_SetActionContent(actionContent) {
		global GuiSettings_Controls
		GuiControl, Settings:,% GuiSettings_Controls.hEDIT_ActionContent,% actionContent
	}

	TabCustomizationButtons_ShowSaveChangesMenu() {
		global GuiSettings
		selected := GuiSettings.CustomButtons_LV_SelectedRow

		Gui, Settings:Default
		Gui, Settings:ListView,% GuiSettings_Controls.hLV_ButtonsActions

		try Menu, SaveChangesMenu, DeleteAll
		Menu, SaveChangesMenu, Add, Currently selected (%selected%), TabCustomizationButtons_ShowSaveChangesMenu_MenuHandler
		Loop % LV_GetCount()
			Menu, SaveChangesMenu, Add,% A_Index, TabCustomizationButtons_ShowSaveChangesMenu_MenuHandler
		Menu, SaveChangesMenu, Show
		return

		TabCustomizationButtons_ShowSaveChangesMenu_MenuHandler:
			RegExMatch(A_ThisMenuItem, "\d+", num)
			if IsNum(num)
				GUI_Settings.TabCustomizationButtons_AddAction("Replace", num)
			else
				Msgbox(4096, "", "An error occured when retrieveing the number from """ A_ThisMenuItem """")
		return
	}

	TabCustomizationButtons_AddAction(whatDo, whichPos) {
		global GuiSettings, GuiSettings_Controls

		Gui, Settings:Default
		Gui, Settings:ListView,% GuiSettings_Controls.hLV_ButtonsActions

		actionType := GUI_Settings.Submit("hDDL_ActionType"), AutoTrimStr(actionType)
		actionContent := GUI_Settings.Submit("hEDIT_ActionContent")
		actionShortName := GUI_Settings.Get_ActionShortName_From_LongName(actionType)

		lvCount := LV_GetCount(), LV_GetText(lastAction, lvCount, 2)
		lastActionShortName := GUI_Settings.Get_ActionShortName_From_LongName(lastAction)

		if (whatDo = "Replace" && whichPos < lvCount)
		&& IsIn(actionShortName, "WRITE_THEN_GO_BACK,WRITE_MSG,WRITE_TO_LAST_WHISPER,WRITE_TO_BUYER,CLOSE_TAB") {
			MsgBox(4096, "", "This action can only be set as the last action for this button. Please remove or re-order actions.")
			Return
		}
		
		if (!actionType) || IsContaining(actionType, "----")
			Return

		if (whatDo = "Replace") {
			LV_Modify(whichPos, "" , whichPos, actionType, actionContent)
		}
		else if (whatDo = "Push") {
			allActions := GUI_Settings.TabCustomizationButtons_GetCurrentButtonActionsList()
			newAllActions := GUI_Settings.TabCustomizationButtons_GetCurrentButtonActionsList()


			if (whichPos = "") {
				if IsIn(actionShortName, "WRITE_THEN_GO_BACK,WRITE_MSG,WRITE_TO_LAST_WHISPER,WRITE_TO_BUYER,CLOSE_TAB")
				&& IsIn(lastActionShortName, "WRITE_THEN_GO_BACK,WRITE_MSG,WRITE_TO_LAST_WHISPER,WRITE_TO_BUYER") {
					MsgBox(4096, "", "You may not add this action (" actionType ") because the last action (" lastAction ") does not send the message.")
					return
				}
				else if IsIn(actionShortName, "WRITE_THEN_GO_BACK,WRITE_MSG,WRITE_TO_LAST_WHISPER,WRITE_TO_BUYER,CLOSE_TAB")
				&& IsIn(lastActionShortName, "CLOSE_TAB") {
					MsgBox(4096, "", "You may not add this action (" actionType ") because the last action (" lastAction ") is closing the tab.")
					return
				}
				else if IsIn(lastActionShortName, "WRITE_THEN_GO_BACK,WRITE_MSG,WRITE_TO_LAST_WHISPER,WRITE_TO_BUYER,CLOSE_TAB")
					whichPos := lvCount
				else whichPos := lvCount+1
			}
				
			if (whichPos > lvCount) {
				newAllActions[whichPos] := {Num:whichPos, ActionType: actionType, ActionContent: actionContent}
			}
			else {
				for index, nothing in allActions {
					if (index >= whichPos) {
						diff := (index - whichPos) + 1
						newAllActions[index+diff] := allActions[index], newAllActions[index+diff].Num := index+diff
					}
				}
				newAllActions[whichPos] := {Num:whichPos, ActionType: actionType, ActionContent: actionContent}
			}

			Loop % LV_GetCount()
				LV_Delete()
			for index, nothing in newAllActions
				LV_Add("", newAllActions[index].Num, newAllActions[index].Actiontype, newAllActions[index].ActionContent)
		}
		else if (whatDo = "Remove") {
			Loop % lvCount {
				LV_GetText(retrievedRowNum, A_Index, 1)
				if (retrievedRowNum >= whichPos) {
					LV_GetText(retrievedRowType, retrievedRowNum, 2)
					LV_GetText(retrievedRowContent, retrievedRowNum, 3)
					LV_Modify(retrievedRowNum, "", retrievedRowNum-1, retrievedRowType, retrievedRowContent)
				}
			}
			LV_Delete(whichPos)
		}

		GUI_Settings.TabCustomizationButtons_SaveSelectedButtonActions()
	}

	TabCustomizationButtons_SaveSelectedButtonActions() {
		global PROGRAM, GuiSettings, GuiSettings_Controls
		iniFile := PROGRAM.INI_FILE

		if !(GuiSettings.CUSTOM_BUTTON_SELECTED) {
			MsgBox(4096, "", "Cannot save button settings because no button is selected.")
			return
		}

		Gui, Settings:Default
		Gui, Settings:ListView,% GuiSettings_Controls.hLV_ButtonsActions

		btnNum := GuiSettings.CUSTOM_BUTTON_SELECTED
		btnSection := "SETTINGS_CUSTOM_BUTTON_" btnNum
		btnInfos := GUI_Settings.TabCustomizationButtons_CustomButton_GetSlotInfos(GuiSettings_Controls["hBTN_CustomBtn_" btnNum])

		INI.Set(iniFile, btnSection, "Name", btnInfos.Name)
		INI.Set(iniFile, btnSection, "Size", btnInfos.Size)
		INI.Set(iniFile, btnSection, "Slot", btnInfos.Slot)
		INI.Set(iniFile, btnSection, "Enabled", btnInfos.Visible?"True":"False")

		Loop {
			iniLineExists := INI.Get(iniFile, btnSection, "Action_" A_Index "_Type")
			iniLineExists := (iniLineExists = "ERROR")?(False):(True)
			if (iniLineExists) {
				INI.Remove(iniFile, btnSection, "Action_" A_Index "_Type")
				INI.Remove(iniFile, btnSection, "Action_" A_Index "_Content")
			}
			else Break
		}
		Loop % LV_GetCount() {
			LV_GetText(retrievedRowType, A_Index, 2)
			LV_GetText(retrievedRowContent, A_Index, 3)
			acShort := GUI_Settings.Get_ActionShortName_From_LongName(retrievedRowType)

			INI.Set(iniFile, btnSection, "Action_" A_Index "_Type", acShort)
			INI.Set(iniFile, btnSection, "Action_" A_Index "_Content", """" retrievedRowContent """")
		}
		Declare_LocalSettings()
	}

	TabCustomizationButtons_OnActionsListClick(CtrlHwnd, GuiEvent, EventInfo, GuiEvent2="") {
		global GuiSettings, GuiSettings_Controls

		Gui, Settings:Default
		Gui, Settings:ListView,% GuiSettings_Controls.hLV_ButtonsActions

		thisFunc := "TabCustomizationButtons_OnActionsListClick"

		if GuiEvent in Normal,D,I,K
		{
			GoSub %thisFunc%_Get_Selected

			GUI_Settings.TabCustomizationButtons_DisableSubroutines()
			GUI_Settings.TabCustomizationButtons_SetActionType(actionType)
			if (ErrorLevel) {
				if (rowID = 0)
					Return
				Msgbox(4096, "", "Unknown action type: """ actionType """")
				GUI_Settings.TabCustomizationButtons_SetActionType(" ")
			}
			GUI_Settings.TabCustomizationButtons_SetActionContent(actionContent)
			GUI_Settings.TabCustomizationButtons_EnableSubroutines()
		}
		if (GuiEvent = "RightClick") {
			LV_RightClick := true
			GoSub %thisFunc%_Get_Selected

			try Menu, RClickMenu, DeleteAll
			Menu, RClickMenu, Add, Move up, TabCustomizationButtons_OnActionsListClick_Menu
			Menu, RClickMenu, Add, Move down, TabCustomizationButtons_OnActionsListClick_Menu
			Menu, RClickMenu, Add
			Menu, RClickMenu, Add, Remove this action, TabCustomizationButtons_OnActionsListClick_Menu
			Menu, RClickMenu, Show
		}
		Return

		TabCustomizationButtons_OnActionsListClick_Menu:
			Gui, Settings:Default
			Gui, Settings:ListView,% GuiSettings_Controls.hLV_ButtonsActions

			if (A_ThisMenu = "RClickMenu") {
				if (A_ThisMenuItem = "Remove this action")
					GUI_Settings.TabCustomizationButtons_AddAction("Remove", GuiSettings.CustomButtons_LV_SelectedRow)
				else if (A_ThisMenuItem = "Move up")
					GUI_Settings.TabCustomizationButtons_MoveAction("Up", rowID)
				else if (A_ThisMenuItem = "Move down")
					GUI_Settings.TabCustomizationButtons_MoveAction("Down", rowID)
			}
		Return

		TabCustomizationButtons_OnActionsListClick_Get_Selected:
		; LV_GetText(string, A_EventInfo) is unreliable. A_EventInfo will sometimes not contain the correct row ID.
		; LV_GetNext() seems to be the best alternative. Though, it rises an issue when no row is selected.
		;	Instead of retrieving a blank value, it will retrieve the same value as the previously selected row ID.
		;	As workaround, when the user does not select any row, we re-highlight the previously selected one.
			Gui, Settings:Default
			Gui, Settings:ListView,% GuiSettings_Controls.hLV_ButtonsActions

			rowID := LV_GetNext(0, "F")
			if (rowID = 0) {
				rowID := LV_GetCount()?LV_GetCount():0
			}
			LV_GetText(rowNum, rowID, 1)
			LV_GetText(actionType, rowID, 2)
			LV_GetText(actionContent, rowID, 3)

			LV_Modify(rowID, "+Select")

			if (actioncontent = "")
				actionContent := [""]

			GuiSettings.CustomButtons_LV_SelectedRow := rowID
		Return
	}

	TabCustomizationButtons_GetCurrentButtonActionsList() {
		global GuiSettings, GuiSettings_Controls

		Gui, Settings:Default
		Gui, Settings:ListView,% GuiSettings_Controls.hLV_ButtonsActions
		
		actions := {}
		Loop % LV_GetCount() {			
			LV_GetText(rowNum, A_Index, 1)
			LV_GetText(actionType, A_Index, 2)
			LV_GetText(actionContent, A_Index, 3)
			actions[A_Index] := {Num:rowNum, ActionType:actionType, ActionContent:actioncontent}
		}

		return actions
	}

	TabCustomizationButtons_MoveAction(side, acNum) {
		global GuiSettings_Controls

		Gui, Settings:Default
		Gui, Settings:ListView,% GuiSettings_Controls.hLV_ButtonsActions

		LV_GetText(lastActionNum, LV_GetCount(), 1)
		LV_GetText(lastActionType, LV_GetCount(), 2)
		lastActionShortName := GUI_Settings.Get_ActionShortName_From_LongName(lastActionType)

		if IsIn(lastActionShortName, "WRITE_THEN_GO_BACK,WRITE_MSG,WRITE_TO_LAST_WHISPER,WRITE_TO_BUYER")
		&& (lastActionNum = acNum+1) && (side = "Down") {
			MsgBox(4096, "", "You cannot move this action down because the last action """ lastActionType """ does not send the message.")
			Return
		}
		else if IsIn(lastActionShortName, "WRITE_THEN_GO_BACK,WRITE_MSG,WRITE_TO_LAST_WHISPER,WRITE_TO_BUYER")
		&& (lastActionNum = acNum) && (side = "Up") {
			MsgBox(4096, "", "You cannot move this action up because it does not send the message.")
			Return
		}
		else if (lastActionShortName = "CLOSE_TAB")
		&& (lastActionNum = acNum+1) && (side = "Down") {
			MsgBox(4096, "", "You cannot move this action down because the last action """ lastActionType """ closes the tab.")
			Return
		}	
		else if (lastActionShortName = "CLOSE_TAB")
		&& (lastActionNum = acNum) && (side = "Up") {
			MsgBox(4096, "", "You cannot move this action up because it closes the tab.")
			Return
		}
		else if ( (acNum = LV_GetCount()) && (side = "Down") )
		|| ( (acNum = 1) && (side = "Up") )
			return

		allActions := GUI_Settings.TabCustomizationButtons_GetCurrentButtonActionsList()
		newAllActions := GUI_Settings.TabCustomizationButtons_GetCurrentButtonActionsList()
		if (side = "Up") {
			newAllActions[acNum] := allActions[acNum-1]
			newAllActions[acNum-1] := allActions[acNum]
		}
		else if (side = "Down") {
			newAllActions[acNum] := allActions[acNum+1]
			newAllActions[acNum+1] := allActions[acNum]
		}
	
		Loop % LV_GetCount()
			LV_Delete()
		for index, nothing in newAllActions
			LV_Add("", index, newAllActions[index].Actiontype, newAllActions[index].ActionContent)
	}

	TabCustomizationButtons_UnicodeButton_SetSlotSettings() {
		global PROGRAM
		global GuiSettings, GuiSettings_Controls
		iniFile := PROGRAM.INI_FILE

		Loop 5 {
			btnHandle := GuiSettings_Controls["hBTN_UnicodeBtn_" A_Index]
			btnSettings := GUI_Settings.TabCustomizationButtons_GetUnicodeButtonSettings(A_Index)

			btnCoords := GuiSettings.UnicodeButtons_SlotPositions[btnSettings.Slot]

			if (btnSettings.Enabled = "True") {
				GUI_Settings.TabCustomizationButtons_UnicodeButton_Rename(btnHandle, "", btnSettings.Type)
				GuiControl, Settings:Move,% btnHandle,% "x" btnCoords.X " y" btnCoords.Y

				GuiSettings["UnicodeButtons_IsSlotTaken"][A_Index] = True
			}
			else {
				GUI_Settings.TabCustomizationButtons_UnicodeButton_Rename(btnHandle, "", btnSettings.Type)
				GuiControl, Settings:Hide,% btnHandle
				GuiSettings["UnicodeButtons_IsSlotTaken"][A_Index] = False
			}
		}
	}

	TabCustomizationButtons_CustomButton_SetSlotSettings() {
		global PROGRAM
		global GuiSettings, GuiSettings_Controls
		iniFile := PROGRAM.INI_FILE

		oneThird := GuiSettings.CustomButton_Width_OneThird
		twoThird := GuiSettings.CustomButton_Width_TwoThird
		threeThird := GuiSettings.CustomButton_Width_ThreeThird

		Loop 9 {
			btnHandle := GuiSettings_Controls["hBTN_CustomBtn_" A_Index]
			btnSettings := GUI_Settings.TabCustomizationButtons_GetCustomButtonSettings(A_Index)

			btnCoords := GuiSettings.CustomButtons_SlotPositions[btnSettings.Slot]
			btnWidth := (btnSettings.Size = "Small")?(oneThird)
				:(btnSettings.Size = "Medium")?(twoThird)
				:(btnSettings.Size = "Large")?(threeThird)
				:("UNKNOWN")

			if (btnSettings.Enabled = "True") {
				GUI_Settings.TabCustomizationButtons_CustomButton_Rename(btnHandle, btnSettings.Name)
				GuiControl, Settings:Move,% btnHandle,% "x" btnCoords.X " y" btnCoords.Y " w" btnWidth

				GuiSettings["CustomButtons_IsSlotTaken"][A_Index] = True
			}
			else {
				GUI_Settings.TabCustomizationButtons_CustomButton_Rename(btnHandle, btnSettings.Name)
				GuiControl, Settings:Hide,% btnHandle
				GuiSettings["CustomButtons_IsSlotTaken"][A_Index] = False
			}
		}
	}

	TabCustomizationButtons_OnUnicodeButtonSlotClick(btnNum) {
		global PROGRAM, GuiSettings, GuiSettings_Controls
		iniFile := PROGRAM.INI_FILE

		Loop 5 { ; 5 = max buttons limit
			GuiControlGet, isVisible, Settings:Visible,% GuiSettings_Controls["hBTN_UnicodeBtn_" A_Index]
			if (!isVisible) { ; Choose the first disabled button
				slotInfos := GUI_Settings.TabCustomizationButtons_UnicodeButton_GetSlotInfos(GuiSettings_Controls["hBTN_UnicodeBtn_" A_Index])

				slotX := GuiSettings["UnicodeButtons_SlotPositions"][btnNum]["X"], slotY := GuiSettings["UnicodeButtons_SlotPositions"][btnNum]["Y"]
				GuiControl, Settings:Move,% GuiSettings_Controls["hBTN_UnicodeBtn_" A_Index],% "x" slotX " y" slotY 
				GuiControl, Settings:Show,% GuiSettings_Controls["hBTN_UnicodeBtn_" A_Index]
				GuiSettings["UnicodeButtons_IsSlotTaken"][btnNum] := True

				specialChar := slotInfos.Name = "0" ? "Clipboard"
					: slotInfos.Name = "1" ? "Whisper"
					: slotInfos.Name = "2" ? "Invite"
					: slotInfos.Name = "3" ? "Trade"
					: slotInfos.Name = "4" ? "Kick"
					: ""

				INI.Set(iniFile, "SETTINGS_SPECIAL_BUTTON_" A_Index, "Enabled", "True")
				INI.Set(iniFile, "SETTINGS_SPECIAL_BUTTON_" A_Index, "Slot", btnNum)
				INI.Set(iniFile, "SETTINGS_SPECIAL_BUTTON_" A_Index, "Type", specialChar)
				Break
			}
		}
		Declare_LocalSettings()
		GUI_Settings.TabCustomizationButtons_UnicodeButton_UpdateSlots()
	}

	TabCustomizationButtons_OnCustomButtonSlotClick(btnNum) {
	/*	Add a button on the clicked slot
	*/
		global PROGRAM, GuiSettings, GuiSettings_Controls
		iniFile := PROGRAM.INI_FILE

		Loop 9 { ; 9 = max buttons limit
			GuiControlGet, isVisible, Settings:Visible,% GuiSettings_Controls["hBTN_CustomBtn_" A_Index]
			if (!isVisible) { ; Choose the first disabled button
				slotX := GuiSettings["CustomButtons_SlotPositions"][btnNum]["X"], slotY := GuiSettings["CustomButtons_SlotPositions"][btnNum]["Y"], slotW := GuiSettings.CustomButton_Width_OneThird
				GuiControl, Settings:Move,% GuiSettings_Controls["hBTN_CustomBtn_" A_Index],% "x" slotX " y" slotY " w" slotW 
				GuiControl, Settings:Show,% GuiSettings_Controls["hBTN_CustomBtn_" A_Index]
				GuiSettings["CustomButtons_IsSlotTaken"][btnNum] := True

				INI.Set(iniFile, "SETTINGS_CUSTOM_BUTTON_" A_Index, "Enabled", "True")
				INI.Set(iniFile, "SETTINGS_CUSTOM_BUTTON_" A_Index, "Size", "Small")
				INI.Set(iniFile, "SETTINGS_CUSTOM_BUTTON_" A_Index, "Slot", btnNum)

				Break
			}
		}

		Declare_LocalSettings()
		GuiSettings.CustomButtons_LV_SelectedRow := 0
		GUI_Settings.TabCustomizationButtons_CustomButton_UpdateSlots()

		GUI_Settings.TabHotkeysBasic_UpdateActionsList()
		GUI_Settings.TabHotkeysAdvanced_UpdateActionsList()
	}

	TabCustomizationButtons_OnCustomButtonClick(btnNum) {
	/*	Show the clicked button actions list
	*/
		global GuiSettings, GuiSettings_Controls

		Gui, Settings:Default
		Gui, Settings:ListView,% GuiSettings_Controls.hLV_ButtonsActions

		GUI_Settings.TabCustomizationButtons_CustomButton_UpdateSlots(CtrlHwnd)

		GuiControl, Settings:-Disabled,% GuiSettings_Controls.hDDL_ActionType
		GuiControl, Settings:-Disabled,% GuiSettings_Controls.hEDIT_ActionContent
		GuiControl, Settings:-Disabled,% GuiSettings_Controls.hBTN_SaveChangesToAction
		GuiControl, Settings:-Disabled,% GuiSettings_Controls.hBTN_AddAsNewAction
		GuiControl, Settings:-Disabled,% GuiSettings_Controls.hLV_ButtonsActions

		btnSettings := GUI_Settings.TabCustomizationButtons_GetCustomButtonSettings(btnNum)

		Loop % LV_GetCount()
			LV_Delete()
		Loop {
			actionType := btnSettings["Action_" A_Index "_Type"]
			actionContent := btnSettings["Action_" A_Index "_Content"]
			if (actionType) {
				acShort := GUI_Settings.Get_ActionLongName_From_ShortName(actionType)
				LV_Add("", A_Index, acShort, actionContent)
			}
			else break
		}

		GuiSettings.CUSTOM_BUTTON_SELECTED := btnNum
	}

	TabCustomizationButtons_GetUnicodeButtonSettings(btnID) {
		global PROGRAM
		iniFile := PROGRAM.INI_FILE

		btnSettings := PROGRAM.SETTINGS["SETTINGS_SPECIAL_BUTTON_" btnID]
		Return btnSettings
	}

	TabCustomizationButtons_GetCustomButtonSettings(btnID) {
		global PROGRAM
		iniFile := PROGRAM.INI_FILE

		btnSettings := PROGRAM.SETTINGS["SETTINGS_CUSTOM_BUTTON_" btnID]
		Return btnSettings
	}

	TabCustomizationButtons_UnicodeButton_GetSlotInfos(CtrlHwnd) {
		global GuiSettings, GuiSettings_Controls

		Gui, Settings:+OwnDialogs
		Loop 5 { ; 5 = max button slots
			hwnd := GuiSettings_Controls["hBTN_UnicodeBtn_" A_Index]
			if (CtrlHwnd = hwnd) {
				btnIndex := A_Index
				btnPos := Get_ControlCoords("Settings", CtrlHwnd)
				Break
			}
		}
		Loop 5 {
			slotX := GuiSettings.UnicodeButtons_SlotPositions[A_Index]["X"] 
			slotY := GuiSettings.UnicodeButtons_SlotPositions[A_Index]["Y"] 
			if (btnPos.X = slotX && btnPos.Y = slotY) {
				slotIndex := A_Index
				Break
			}
		}

		btnName := GUI_Settings.Submit("hBTN_UnicodeBtn_" btnIndex)
		GuiControlGet, isVisible, Settings:Visible,% CtrlHwnd

		Return {Visible:isVisible, Num:btnIndex, Slot:slotIndex, Name:btnName}
	}

	TabCustomizationButtons_CustomButton_GetSlotInfos(CtrlHwnd) {
		global GuiSettings, GuiSettings_Controls

		Gui, Settings:+OwnDialogs
		Loop 9 { ; 9 = max button slots
			hwnd := GuiSettings_Controls["hBTN_CustomBtn_" A_Index]
			if (CtrlHwnd = hwnd) {
				btnIndex := A_Index
				btnPos := Get_ControlCoords("Settings", CtrlHwnd)
				Break
			}
		}
		Loop 9 {
			slotX := GuiSettings.CustomButtons_SlotPositions[A_Index]["X"] 
			slotY := GuiSettings.CustomButtons_SlotPositions[A_Index]["Y"] 
			if (btnPos.X = slotX && btnPos.Y = slotY) {
				slotIndex := A_Index
				Break
			}
		}

		btnName := GUI_Settings.Submit("hBTN_CustomBtn_" btnIndex)
		GuiControlGet, isVisible, Settings:Visible,% CtrlHwnd

		btnSize := (btnPos.W = GuiSettings.CustomButton_Width_OneThird)?("Small")
		: (btnPos.W = GuiSettings.CustomButton_Width_TwoThird)?("Medium")
		: (btnPos.W = GuiSettings.CustomButton_Width_ThreeThird)?("Large")
		: ("UNKNOWN")

		possibleSlots := (btnSize = "Small")?(slotIndex)
		: (btnSize = "Medium")?(slotIndex "," slotIndex+1)
		: (btnSize = "Large")?(slotIndex "," slotIndex+1 "," slotIndex+2)
		: ("UNKNOWN")

		effectiveSlots := ""
		Loop, Parse, possibleSlots,% ","
		{
			if IsBetween(A_LoopField, 1, 9)
				effectiveSlots .= A_LoopField ","
		}
		StringTrimRight, effectiveSlots, effectiveSlots, 1

		Return {Visible:isVisible, Num:btnIndex, Slot:slotIndex, Size:btnSize, Slots:effectiveSlots, Name:btnName}
	}

	TabCustomizationButtons_CustomButton_UpdateSlots() {
		global GuiSettings, GuiSettings_Controls

		Loop 9 {
			btnHwnd := GuiSettings_Controls["hBTN_CustomBtn_" A_Index]
			slotInfos := GUI_Settings.TabCustomizationButtons_CustomButton_GetSlotInfos(btnHwnd)

			isSlotTaken := IsIn(A_Index, slotInfos.Slots)
			GuiSettings["CustomButtons_IsSlotTaken"][A_Index] := slotInfos.Visible

			if (slotInfos.Slots && slotInfos.Visible) {
				takenSlots := (takenSlots)?(takenSlots "," slotInfos.Slots):(slotInfos.Slots)
			}
		}
		Loop 9 {
			if IsIn(A_Index, takenSlots) {
				GuiSettings["CustomButtons_IsSlotTaken"][A_Index] := True
				GuiControl, Settings:Hide,% GuiSettings_Controls["hTEXT_CustomBtnSlot_" A_Index]
			}
			else {
				GuiSettings["CustomButtons_IsSlotTaken"][A_Index] := False
				GuiControl, Settings:Show,% GuiSettings_Controls["hTEXT_CustomBtnSlot_" A_Index]
			}
		}
	}

	TabCustomizationButtons_UnicodeButton_UpdateSlots() {
		global GuiSettings, GuiSettings_Controls

		Loop 5 {
			btnHwnd := GuiSettings_Controls["hBTN_UnicodeBtn_" A_Index]
			slotInfos := GUI_Settings.TabCustomizationButtons_UnicodeButton_GetSlotInfos(btnHwnd)

			isSlotTaken := IsIn(A_Index, slotInfos.Slot)
			GuiSettings["UnicodeButtons_IsSlotTaken"][A_Index] := slotInfos.Visible

			if (slotInfos.Slot && slotInfos.Visible) {
				takenSlots := (takenSlots)?(takenSlots "," slotInfos.Slot):(slotInfos.Slot)
			}
		}
		Loop 5 {
			if IsIn(A_Index, takenSlots) {
				GuiSettings["UnicodeButtons_IsSlotTaken"][A_Index] := True
				GuiControl, Settings:Hide,% GuiSettings_Controls["hTEXT_UnicodeBtnSlot_" A_Index]
				; GuiControl, Settings:Show,% GuiSettings_Controls["hBTN_CustomBtn_" A_Index]
			}
			else {
				GuiSettings["UnicodeButtons_IsSlotTaken"][A_Index] := False
				GuiControl, Settings:Show,% GuiSettings_Controls["hTEXT_UnicodeBtnSlot_" A_Index]
				; GuiControl, Settings:Hide,% GuiSettings_Controls["hBTN_CustomBtn_" A_Index]
			}
		}
	}

	TabCustomizationButtons_UnicodeButton_IsSlotAvailable(slotID, btnHandle) {
		global GuiSettings

		btnInfos := GUI_Settings.TabCustomizationButtons_UnicodeButton_GetSlotInfos(btnHandle)
		btnSlot := btnInfos.Slot

		isSlotTaken := GuiSettings["UnicodeButtons_IsSlotTaken"][slotID]
		slotIsUsedByButton := slotID = btnSlot ? True : False

		if (!isSlotTaken || slotIsUsedByButton)
			slotsAvailable := True
		else
			slotsAvailable := False
			
		_tip .= "Slot: " A_LoopField "`nTaken: " isSlotTaken "`nAvailable: " slotsAvailable "`nUsedByBtn: " slotIsUsedByButton "`n`n" 

		if (slotsAvailable)
			Return True
	}

	TabCustomizationButtons_CustomButton_IsSlotAvailable(slotID, btnHandle) {
		global GuiSettings

		btnInfos := GUI_Settings.TabCustomizationButtons_CustomButton_GetSlotInfos(btnHandle)
		btnSize := btnInfos.Size, btnUsedSlots := btnInfos.Slots

		if IsIn(slotID, "1,2,4,5,7,8") && (btnSize = "Medium") 
			canFit := True, needSlots := slotID "," slotID+1
		else if IsIn(slotID, "1,4,7") && (btnSize = "Large")
			canFit := True, needSlots := slotID "," slotID+1 "," slotID+2
		else if IsIn(slotID, "1,2,3,4,5,6,7,8,9") && (btnSize = "Small")
			canFit := True, needSlots := slotID
		else canFit := False

		Loop, Parse, needSlots,% ","
		{
			isSlotTaken := GuiSettings["CustomButtons_IsSlotTaken"][A_LoopField]
			slotIsUsedByButton := IsIn(A_LoopField, btnUsedSlots)

			if (isSlotTaken && !slotIsUsedByButton) {
				slotsAvailable := False
				Break
			}
			else if (!isSlotTaken && (!prevSlotTaken || slotsAvailable)) || (slotIsUsedByButton) {
				slotsAvailable := True
			}
			else slotsAvailable := False
			
			_tip .= "Slot: " A_LoopField "`nTaken: " isSlotTaken "`nAvailable: " slotsAvailable "`nUsedByBtn: " slotIsUsedByButton "`n`n" 

			prevSlotTaken := isSlotTaken
		}

		; tooltip % _tip "`nslotsAvailable: " slotsAvailable

		if (canFit && slotsAvailable)
			Return True
	}

		TabCustomizationButtons_UnicodeButton_Hide(CtrlHwnd) {
		global PROGRAM, GuiSettings
		iniFile := PROGRAM.INI_FILE

		num := GUI_Settings.TabCustomizationButtons_UnicodeButton_GetSlotInfos(CtrlHwnd).Num

		GuiControl, Settings:Hide,% CtrlHwnd
		GuiSettings.UnicodeButtons_IsSlotTaken[btnSlot] := False
		INI.Set(iniFile, "SETTINGS_SPECIAL_BUTTON_" num, "Enabled", "False")
	}

	TabCustomizationButtons_UnicodeButton_Rename(CtrlHwnd, _newName, _specialChar="") {
		global PROGRAM, GuiSettings
		iniFile := PROGRAM.INI_FILE

		newName := _specialChar = "Clipboard" ? "0"
					: _specialChar = "Whisper" ? "1"
					: _specialChar = "Invite" ? "2"
					: _specialChar = "Trade" ? "3"
					: _specialChar = "Kick" ? "4"
					: _newName

		specialChar := newName = "0" ? "Clipboard"
					: newName = "1" ? "Whisper"
					: newName = "2" ? "Invite"
					: newName = "3" ? "Trade"
					: newName = "4" ? "Kick"
					: _specialChar

		num := GUI_Settings.TabCustomizationButtons_UnicodeButton_GetSlotInfos(CtrlHwnd).Num

		GuiControl, Settings:,% CtrlHwnd,% newName
		INI.Set(iniFile, "SETTINGS_SPECIAL_BUTTON_" num, "Type", specialChar)
		Declare_LocalSettings()

		SetTimer, TabCustomizationButtons_UnicodeButton_Timer, -100
		Return

		TabCustomizationButtons_UnicodeButton_Timer:
			GUI_Settings.TabHotkeysBasic_UpdateActionsList()
			GUI_Settings.TabHotkeysAdvanced_UpdateActionsList()
		Return
	}

	TabCustomizationButtons_CustomButton_Rename(CtrlHwnd, newName) {
		global PROGRAM, GuiSettings
		iniFile := PROGRAM.INI_FILE

		GuiControl, Settings:,% CtrlHwnd,% newName

		num := GUI_Settings.TabCustomizationButtons_CustomButton_GetSlotInfos(ctrlhwnd).Num

		INI.Set(iniFile, "SETTINGS_CUSTOM_BUTTON_" num, "Name", newName)
		Declare_LocalSettings()

		SetTimer, TabCustomizationButtons_CustomButton_Timer, -100
		Return

		TabCustomizationButtons_CustomButton_Timer:
			GUI_Settings.TabHotkeysBasic_UpdateActionsList()
			GUI_Settings.TabHotkeysAdvanced_UpdateActionsList()
		Return
	}

	

	TabCustomizationButtons_CustomButton_Resize(CtrlHwnd, newSize) {
		global PROGRAM, GuiSettings
		iniFile := PROGRAM.INI_FILE

		sizeSmall := GuiSettings.CustomButton_Width_OneThird, sizeMedium := GuiSettings.CustomButton_Width_TwoThird, sizeLarge := GuiSettings.CustomButton_Width_ThreeThird
		slot := GUI_Settings.TabCustomizationButtons_CustomButton_GetSlotInfos(ctrlhwnd).Slot
		btnNum := GUI_Settings.TabCustomizationButtons_CustomButton_GetSlotInfos(ctrlhwnd).Num

		if (newSize = "Hide") {
			GuiControl, Settings:Hide,% CtrlHwnd
			
			GuiSettings.CustomButtons_IsSlotTaken[slot] := False
			INI.Set(iniFile, "SETTINGS_CUSTOM_BUTTON_" btnNum, "Enabled", "False")
		}
		else if IsIn(newSize, "Small,Medium,Large") {
			btnNewSize := (newSize="Small")?(sizeSmall):(newSize="Medium")?(sizeMedium):(newSize="Large")?(sizeLarge):("UNKNOWN")
			GuiControl, Settings:Move,% CtrlHwnd, w%btnNewSize%

			INI.Set(iniFile, "SETTINGS_CUSTOM_BUTTON_" btnNum, "Size", newSize)
			INI.Set(iniFile, "SETTINGS_CUSTOM_BUTTON_" btnNum, "Enabled", "True")
		}
		else {
			Msgbox %A_ThisFunc%: ERROR
		}

		Declare_LocalSettings()		
		GUI_Settings.TabCustomizationButtons_CustomButton_UpdateSlots()
	}


	/* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * 
	*	TAB HOTKEYS BASIC
	*/

	/* * * * * Subroutines toggle * * * * *
	*/
	TabHotkeysBasic_EnableSubroutines() {
		GUI_Settings.TabHotkeysBasic_ToggleSubroutines("Enable")
	}
	TabHotkeysBasic_DisableSubroutines() {
		GUI_Settings.TabHotkeysBasic_ToggleSubroutines("Disable")
	}
	TabHotkeysBasic_ToggleSubroutines(enableOrDisable) {
		global GuiSettings, GuiSettings_Controls
		thisTabCtrls := GuiSettings.Hotkeys_Basic_TabControls

		Loop, Parse, thisTabCtrls,% ","
		{
			loopedCtrl := A_LoopField

			RegExMatch(loopedCtrl, "\D+", loopedCtrl_NoNum)
			RegExMatch(loopedCtrl, "\d+", loopedCtrl_NumOnly)

			if (enableOrDisable = "Disable")
				GuiControl, Settings:-g,% GuiSettings_Controls[loopedCtrl]
			else if (enableOrDisable = "Enable") {
				if (loopedCtrl_NoNum = "hDDL_HotkeyActionType")
					__f := GUI_Settings.TabHotkeysBasic_OnHotkeyActionTypeChange.bind(GUI_Settings, loopedCtrl_NumOnly)
				else if (loopedCtrl_NoNum = "hCB_HotkeyToggle")
					__f := GUI_Settings.TabHotkeysBasic_OnHotkeyToggle.bind(GUI_Settings, loopedCtrl_NumOnly)
				else if (loopedCtrl_NoNum = "hHK_HotkeyKeys")
					__f := GUI_Settings.TabHotkeysBasic_OnHotkeyKeysChange.bind(GUI_Settings, loopedCtrl_NumOnly)
				else if (loopedCtrl_NoNum = "hEDIT_HotkeyActionContent")
					__f := GUI_Settings.TabHotkeysBasic_OnHotkeyActionContentChange.bind(GUI_Settings, loopedCtrl_NumOnly)
				else 
					__f := 

				if (__f)
					GuiControl, Settings:+g,% GuiSettings_Controls[loopedCtrl],% __f 
			}
		}
	}


	/* * * * * GET * * * * *
	*/

	/* * * * * SET * * * * *
	*/

	TabHotkeysBasic_SetCheckboxState(CtrlNum, state) {
		global GuiSettings_Controls
		state := state="True"?1 : state="False"?0 : state
		GuiControl, Settings:,% GuiSettings_Controls["hCB_HotkeyToggle" CtrlNum],% state
	}

	TabHotkeysBasic_SetActionType(CtrlNum, actionType) {
		global GuiSettings_Controls
		GuiControl, Settings:Choose,% GuiSettings_Controls["hDDL_HotkeyActionType" CtrlNum],% actionType
	}
	TabHotkeysBasic_SetActionContent(CtrlNum, actionContent) {
		global GuiSettings_Controls
		GuiControl, Settings:,% GuiSettings_Controls["hEDIT_HotkeyActionContent" CtrlNum],% actionContent
	}

	TabHotkeysBasic_SetHotkeyKeys(CtrlHwnd_Or_CtrlNum, keyStr="") {
		global GuiSettings_Controls
		isHex := IsHex(CtrlHwnd_Or_CtrlNum)
		isDigit := IsDigit(CtrlHwnd_Or_CtrlNum)

		if (isDigit) {
			CtrlHwnd := GuiSettings_Controls["hHK_HotkeyKeys" CtrlHwnd_Or_CtrlNum]
		}
		else if (isHex) {
			CtrlHwnd := CtrlHwnd_Or_CtrlNum
		}
		else
			MsgBox YOU SOULD NOT SEE THIS`nFunc: %A_ThisFunc%`nCtrl: %CtrlHwnd_Or_CtrlNum%

		GuiControl, Settings:,% CtrlHwnd,% keyStr
	}

	TabHotkeysBasic_SetTabSettings(dontUpdateList=False) {
		global PROGRAM, GuiSettings, GuiSettings_Controls

		Loop % GuiSettings.TabHotkeysBasic_Max_Hotkeys_Count {
			; Get every settings
			hkToggle := PROGRAM.SETTINGS["SETTINGS_HOTKEY_" A_Index]["Enabled"]
			hkType := PROGRAM.SETTINGS["SETTINGS_HOTKEY_" A_Index]["Type"]
			hkContent := PROGRAM.SETTINGS["SETTINGS_HOTKEY_" A_Index]["Content"]
			hkHotkey := PROGRAM.SETTINGS["SETTINGS_HOTKEY_" A_Index]["Hotkey"]
			hkLongName := GUI_Settings.Get_ActionLongName_From_ShortName(hkType)
			; Apply settings to controls
			GUI_Settings.TabHotkeysBasic_SetCheckboxState(A_Index, hkToggle)
			GUI_Settings.TabHotkeysBasic_SetActionType(A_Index, hkLongName)
			GUI_Settings.TabHotkeysBasic_SetActionContent(A_Index, hkContent)
			GUI_Settings.TabHotkeysBasic_SetHotkeyKeys(A_Index, hkHotkey)
		}
	}

	TabHotkeysBasic_UpdateActionsList() {
		global GuiSettings, GuiSettings_Controls
		actionsList := GUI_Settings.Get_AvailableActions_With_CustomButtonsNames()

		GUI_Settings.TabHotkeysBasic_DisableSubroutines()
		Loop % GuiSettings.TabHotkeysBasic_Max_Hotkeys_Count {
			GuiControl, Settings:,% GuiSettings_Controls["hDDL_HotkeyActionType" A_Index],% "|" actionsList
			GuiControl, Settings:ChooseString,% GuiSettings_Controls["hDDL_HotkeyActionType" A_Index],% " "
		}
		GUI_Settings.TabHotkeysBasic_SetTabSettings()
		GUI_Settings.TabHotkeysBasic_EnableSubroutines()
	}

	/* * * * * On Change * * * * *
	*/

	TabHotkeysBasic_OnHotkeyActionTypeChange(CtrlHwnd_Or_CtrlNum) {
		global PROGRAM, GuiSettings_Controls
		global ACTIONS_READONLY, ACTIONS_FORCED_CONTENT
		isHex := IsHex(CtrlHwnd_Or_CtrlNum)
		isDigit := IsDigit(CtrlHwnd_Or_CtrlNum)

		if (isDigit) {
			CtrlHwnd := GuiSettings_Controls["hDDL_HotkeyActionType" CtrlHwnd_Or_CtrlNum]
			CtrlName := Get_MatchingIndex_From_Object_Using_Value(GuiSettings_Controls, CtrlHwnd)
			CtrlNum := CtrlHwnd_Or_CtrlNum
		}
		else if (isHex) {
			CtrlHwnd := CtrlHwnd_Or_CtrlNum
			CtrlName := Get_MatchingIndex_From_Object_Using_Value(GuiSettings_Controls, CtrlHwnd)
			RegExMatch(CtrlName, "\d+", CtrlNum)
		}
		else
			MsgBox YOU SOULD NOT SEE THIS`nFunc: %A_ThisFunc%`nCtrl: %CtrlHwnd_Or_CtrlNum%

		actionType := GUI_Settings.Submit("hDDL_HotkeyActionType" CtrlNum)
		ActionContentCtrlHwnd := GuiSettings_Controls["hEDIT_HotkeyActionContent" CtrlNum]
		actionContent := GUI_Settings.Submit("hEDIT_HotkeyActionContent" CtrlNum)

		actionShortName := GUI_Settings.Get_ActionShortName_From_LongName(actionType)
		contentPlaceholder := GUI_Settings.Get_ActionContentPlaceholder_From_ShortName(actionShortName)
		SetEditCueBanner(GuiSettings_Controls["hEDIT_HotkeyActionContent" CtrlNum], contentPlaceholder)
		ShowToolTip(contentPlaceholder)

		if IsContaining(actionType, "----") {
			GetKeyState, isUpArrowPressed, Up, P
			GetKeyState, isDownArrowPressed, Down, P

			GuiControl, Settings:+AltSubmit,% CtrlHwnd
			chosenItemNum := GUI_Settings.Submit("hDDL_HotkeyActionType" CtrlNum)
			GuiControl, Settings:-AltSubmit,% CtrlHwnd

			if (isUpArrowPressed = "D")
				GuiControl, Settings:Choose,% CtrlHwnd,% chosenItemNum-1 ; TO_DO apparently bug, chose first space instead of closest one, though it works fine in custom button
			else ; just go down
				GuiControl, Settings:Choose,% CtrlHwnd,% chosenItemNum+1

			Sleep 10

			actionType := GUI_Settings.Submit("hDDL_HotkeyActionType" CtrlNum)
			GUI_Settings.TabHotkeysBasic_SetActionType(CtrlNum, actionType)
			GUI_Settings.TabHotkeysBasic_OnHotkeyActionTypeChange(CtrlNum)
			Return
		}
		else {
			if (actionType != " ")
				GuiControl, Settings:ChooseString,% CtrlHwnd,% actionType
		}

		if IsIn(actionShortName, ACTIONS_READONLY) {
			GuiControl, Settings:+ReadOnly,% ActionContentCtrlHwnd
		}
		else {
			GuiControl, Settings:-ReadOnly,% ActionContentCtrlHwnd
		}

		for sName, fContent in ACTIONS_FORCED_CONTENT {
			if (sName = actionShortName) {
				forcedContent := fContent
				Break
			}
		}
		if (forcedContent)
			GUI_Settings.TabHotkeysBasic_SetActionContent(CtrlNum, forcedContent)
		else
			GUI_Settings.TabHotkeysBasic_SetActionContent(CtrlNum, "")

		INI.Set(PROGRAM.Ini_File, "SETTINGS_HOTKEY_" CtrlNum, "Type", actionShortName)	
		Declare_LocalSettings()
	}

	TabHotkeysBasic_OnHotkeyKeysChange(CtrlHwnd_Or_CtrlNum) {
		global PROGRAM, GuiSettings, GuiSettings_Controls
		isHex := IsHex(CtrlHwnd_Or_CtrlNum)
		isDigit := IsDigit(CtrlHwnd_Or_CtrlNum)

		if (isDigit) {
			CtrlHwnd := GuiSettings_Controls["hHK_HotkeyKeys" CtrlHwnd_Or_CtrlNum]
			CtrlName := Get_MatchingIndex_From_Object_Using_Value(GuiSettings_Controls, CtrlHwnd)
			CtrlNum := CtrlHwnd_Or_CtrlNum
		}
		else if (isHex) {
			CtrlHwnd := CtrlHwnd_Or_CtrlNum
			CtrlName := Get_MatchingIndex_From_Object_Using_Value(GuiSettings_Controls, CtrlHwnd)
			RegExMatch(CtrlName, "\d+", CtrlNum)
		}
		else
			MsgBox YOU SOULD NOT SEE THIS`nFunc: %A_ThisFunc%`nCtrl: %CtrlHwnd_Or_CtrlNum%

		hkKeys := GUI_Settings.Submit(CtrlName)

		INI.Set(PROGRAM.Ini_File, "SETTINGS_HOTKEY_" CtrlNum, "Hotkey", hkKeys)	
		Declare_LocalSettings()
	}

	TabHotkeysBasic_OnHotkeyActionContentChange(CtrlHwnd_Or_CtrlNum) {
		global PROGRAM, GuiSettings, GuiSettings_Controls 
		isHex := IsHex(CtrlHwnd_Or_CtrlNum)
		isDigit := IsDigit(CtrlHwnd_Or_CtrlNum)

		if (isDigit) {
			CtrlHwnd := GuiSettings_Controls["hEDIT_HotkeyActionContent" CtrlHwnd_Or_CtrlNum]
			CtrlName := Get_MatchingIndex_From_Object_Using_Value(GuiSettings_Controls, CtrlHwnd)
			CtrlNum := CtrlHwnd_Or_CtrlNum
		}
		else if (isHex) {
			CtrlHwnd := CtrlHwnd_Or_CtrlNum
			CtrlName := Get_MatchingIndex_From_Object_Using_Value(GuiSettings_Controls, CtrlHwnd)
			RegExMatch(CtrlName, "\d+", CtrlNum)
		}
		else {
			MsgBox YOU SOULD NOT SEE THIS`nFunc: %A_ThisFunc%`nCtrl: %CtrlHwnd_Or_CtrlNum% 
			AppendToLogs("GUI_Settings.TabHotkeysBasic_OnHotkeyActionContentChange(CtrlHwnd_Or_CtrlNum): YOU APPARENTLY DID SEE THIS.")
		}

		actionType := GUI_Settings.Submit("hDDL_HotkeyActionType" CtrlNum)
		actionContent := GUI_Settings.Submit(CtrlName)
		actionShortName := GUI_Settings.Get_ActionShortName_From_LongName(actionType)
		actionForcedContent := GUI_Settings.Get_ActionForcedContent_From_ActionShortName(actionShortName)

		GUI_Settings.TabHotkeysBasic_DisableSubroutines()

		if (actionForcedContent) {
			strL := StrLen(actionForcedContent)
			contentSubStr  := SubStr(actionContent, 1, strL)

			if (contentSubStr != actionForcedContent) {
				GUI_Settings.TabHotkeysBasic_SetActionContent(CtrlNum, actionForcedContent)
				ShowToolTip("The string has to start with """ actionForcedContent """")
				tipWarn := True, actionContent := actionForcedContent
			}
			else if (actionShortName = "SLEEP") {
				AutoTrimStr(actionContent)

				if (actionContent) && ( !IsDigit(actionContent) || IsContaining(actionContent, ".") ) {
					GUI_Settings.TabHotkeysBasic_SetActionContent(CtrlNum, 100)
					ShowToolTip("This value can only be an integer.")
					tipWarn := True, actionContent := 100
				}
				else if IsDigit(actionContent) && (actionContent > 1000) {
					GUI_Settings.TabHotkeysBasic_SetActionContent(CtrlNum, 1000)
					ShowToolTip("Max value is 1000 milliseconds.")
					tipWarn := True, actionContent := 1000
				}
			}
		}

		if (!tipWarn) && (actionContent) && (actionContent != actionForcedContent)
			ShowToolTip(actionContent)

		INI.Set(PROGRAM.Ini_File, "SETTINGS_HOTKEY_" CtrlNum, "Content", """" actionContent """")	
		Declare_LocalSettings()

		GUI_Settings.TabHotkeysBasic_EnableSubroutines()
	}

	TabHotkeysBasic_OnHotkeyToggle(CtrlHwnd_Or_CtrlNum) {
		global PROGRAM, GuiSettings, GuiSettings_Controls 
		isHex := IsHex(CtrlHwnd_Or_CtrlNum)
		isDigit := IsDigit(CtrlHwnd_Or_CtrlNum)

		if (isDigit) {
			CtrlHwnd := GuiSettings_Controls["hEDIT_HotkeyActionContent" CtrlHwnd_Or_CtrlNum]
			CtrlName := Get_MatchingIndex_From_Object_Using_Value(GuiSettings_Controls, CtrlHwnd)
			CtrlNum := CtrlHwnd_Or_CtrlNum
		}
		else if (isHex) {
			CtrlHwnd := CtrlHwnd_Or_CtrlNum
			CtrlName := Get_MatchingIndex_From_Object_Using_Value(GuiSettings_Controls, CtrlHwnd)
			RegExMatch(CtrlName, "\d+", CtrlNum)
		}

		toggle := GUI_Settings.Submit("hCB_HotkeyToggle" CtrlNum)
		toggle := toggle=0?"False":toggle=1?"True":toggle

		INI.Set(PROGRAM.Ini_File, "SETTINGS_HOTKEY_" CtrlNum, "Enabled", toggle)	
		Declare_LocalSettings()
	}

	

	Get_ActionForcedContent_From_ActionShortName(actionShortName) {
		global ACTIONS_FORCED_CONTENT

		forcedContent := ""
		for sName, fContent in ACTIONS_FORCED_CONTENT {
			if (sName = actionShortName) {
				forcedContent := fContent
				Break
			}
		}
		return forcedContent
	}


	/* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * 
	*	TAB HOTKEYS ADVANCED
	*/

	/* * * * * Subroutines toggle * * * * *
	*/
	TabHotkeysAdvanced_EnableSubroutines() {
		GUI_Settings.TabHotkeysAdvanced_ToggleSubroutines("Enable")
	}
	TabHotkeysAdvanced_DisableSubroutines() {
		GUI_Settings.TabHotkeysAdvanced_ToggleSubroutines("Disable")
	}
	TabHotkeysAdvanced_ToggleSubroutines(enableOrDisable) {
		global GuiSettings, GuiSettings_Controls
		thisTabCtrls := GuiSettings.Hotkeys_Advanced_TabControls

		Loop, Parse, thisTabCtrls,% ","
		{
			loopedCtrl := A_LoopField

			if (enableOrDisable = "Disable")
				GuiControl, Settings:-g,% GuiSettings_Controls[loopedCtrl]
			else if (enableOrDisable = "Enable") {
				if (loopedCtrl = "hDDL_HotkeyAdvExistingList")
					__f := GUI_Settings.TabHotkeysAdvanced_OnHotkeyProfileChange.bind(GUI_Settings, "")

				else if (loopedCtrl = "hBTN_HotkeyAdvAddNewProfile")
					__f := GUI_Settings.TabHotkeysAdvanced_AddNewHotkeyProfile.bind(GUI_Settings)
				else if (loopedCtrl = "hBTN_HotkeyAdvDeleteCurrentProfile")
					__f := GUI_Settings.TabHotkeysAdvanced_DeleteCurrentHotkeyProfile.bind(GUI_Settings)
				else if (loopedCtrl = "hEDIT_HotkeyAdvName")
					__f := GUI_Settings.TabHotkeysAdvanced_OnHotkeyNameChange.bind(GUI_Settings, "")
				else if (loopedCtrl = "hHK_HotkeyAdvHotkey")
					__f := GUI_Settings.TabHotkeysAdvanced_OnHotkeyKeysChange.bind(GUI_Settings, "")
				else if (loopedCtrl = "hDDL_HotkeyAdvActionType")
					__f := GUI_Settings.TabHotkeysAdvanced_OnActionTypeChange.bind(GUI_Settings, "")
				else if (loopedCtrl = "hEDIT_HotkeyAdvActionContent")
					__f := GUI_Settings.TabHotkeysAdvanced_OnActionContentChange.bind(GUI_Settings, "")
				else if (loopedCtrl = "hBTN_HotkeyAdvSaveChangesToAction")
					__f := GUI_Settings.TabHotkeysAdvanced_ShowSaveChangesMenu.bind(GUI_Settings)
				else if (loopedCtrl = "hBTN_HotkeyAdvAddAsNewAction")
					__f := GUI_Settings.TabHotkeysAdvanced_AddAction.bind(GUI_Settings, "Push", whichPos:="")
				else if (loopedCtrl = "hLV_HotkeyAdvActionsList")
					__f := GUI_Settings.TabHotkeysAdvanced_OnListClick.bind(GUI_Settings)
				else if (loopedCtrl = "hEDIT_HotkeyAdvHotkey")
					__f := GUI_Settings.TabHotkeysAdvanced_OnHotkeyKeysChange.bind(GUI_Settings)
				else if (loopedCtrl = "hBTN_ChangeHKType")
					__f := GUI_Settings.TabHotkeysAdvanced_ShowHKTypeMenu.bind(GUI_Settings)
				else 
					__f := 

				if (__f)
					GuiControl, Settings:+g,% GuiSettings_Controls[loopedCtrl],% __f 
			}
		}
	}


	/* * * * * GET * * * * *
	*/
	TabHotkeysAdvanced_GetHotkeyProfiles() {
	/* Loop through settings to get all HK profiles
	*/
		global PROGRAM

		profiles := {}
		profileIndex := 0
		Loop {
			if !(PROGRAM.SETTINGS["SETTINGS_HOTKEY_ADV_" A_Index].Name)
				Break

			profileIndex := A_Index
			profiles[profileIndex] := {}

			profiles[profileIndex].Name := PROGRAM.SETTINGS["SETTINGS_HOTKEY_ADV_" profileIndex].Name
			profiles[profileIndex].Hotkey := PROGRAM.SETTINGS["SETTINGS_HOTKEY_ADV_" profileIndex].Hotkey
			profiles[profileIndex].Hotkey_Type := PROGRAM.SETTINGS["SETTINGS_HOTKEY_ADV_" profileIndex].Hotkey_Type
			profiles.Profiles_Count := profileIndex

			actionIndex := 0
			Loop {
				if !(PROGRAM.SETTINGS["SETTINGS_HOTKEY_ADV_" profileIndex]["Action_" A_Index "_Type"])
					Break

				actionIndex := A_Index

				profiles[profileIndex]["Action_" actionIndex "_Type"] := PROGRAM.SETTINGS["SETTINGS_HOTKEY_ADV_" profileIndex]["Action_" actionIndex "_Type"]
				profiles[profileIndex]["Action_" actionIndex "_Content"] := PROGRAM.SETTINGS["SETTINGS_HOTKEY_ADV_" profileIndex]["Action_" actionIndex "_Content"]
			}
			profiles[profileIndex]["Actions_Count"] := actionIndex
		}

		return profiles
	}

	TabHotkeysAdvanced_GetActiveHotkeyProfileInfos() {
	/* Get active profile infos
	*/
		global GuiSettings, GuiSettings_Controls

		profile := GUI_Settings.Submit("hDDL_HotkeyAdvExistingList")
		name := GUI_Settings.Submit("hEDIT_HotkeyAdvName")
		hkEasy := GUI_Settings.Submit("hHK_HotkeyAdvHotkey")
		hkManual := GUI_Settings.Submit("hEDIT_HotkeyAdvHotkey")
		acType := GUI_Settings.Submit("hDDL_HotkeyAdvActionType")
		acContent := GUI_Settings.Submit("hEDIT_HotkeyAdvActionContent")

		GuiControlGet, isHKEZVisible, Settings:Visible,% GuiSettings_Controls.hHK_HotkeyAdvHotkey
		GuiControlGet, isHKManualVisible, Settings:Visible,% GuiSettings_Controls.hEDIT_HotkeyAdvHotkey
		hk := isHKEZVisible ? hkEasy : hkManual, hkType := isHKEZVisible ? "Easy" : "Manual"

		GuiControl, Settings:+AltSubmit,% GuiSettings_Controls.hDDL_HotkeyAdvExistingList
		num := GUI_Settings.Submit("hDDL_HotkeyAdvExistingList")
		GuiControl, Settings:-AltSubmit,% GuiSettings_Controls.hDDL_HotkeyAdvExistingList

		return {Profile:profile, Name:name, Hotkey:hk, Hotkey_Type:hkType, Action_Type:acType, Action_Content: acContent, Num:num}
	}

	TabHotkeysAdvanced_GetMatchingProfile(hkName, hkKeys) {
	/*	Get the matching profile ID based on its name and keys
	*/
		global PROGRAM

		hkProfiles := GUI_Settings.TabHotkeysAdvanced_GetHotkeyProfiles()
		Loop % hkProfiles.Profiles_Count {
			if (hkProfiles[A_Index].Name = hkName) && (hkProfiles[A_Index].Hotkey = hkKeys) {
				matchingID := A_Index
				Break
			}
		}

		if !(matchingID) {
				MsgBox(4096, "", "No matching num ID found for Hotkey profile with infos:`nName: """ hkNAme """`nHotkey: """ hkKeys """`n`nPlease report the issue.")
				Return
			}
		else
			return matchindID
	}

	/* * * * * SET * * * * *
	*/

	TabHotkeysAdvanced_SetHotkeyName(hkName) {
		global GuiSettings_Controls
		GuiControl, Settings:,% GuiSettings_Controls.hEDIT_HotkeyAdvName,% hkName
	}
	TabHotkeysAdvanced_SetHotkeyKeys(hkKeys) {
		global GuiSettings_Controls
		GuiControl, Settings:,% GuiSettings_Controls.hHK_HotkeyAdvHotkey,% hkKeys
		GuiControl, Settings:,% GuiSettings_Controls.hEDIT_HotkeyAdvHotkey,% hkKeys
	}
	TabHotkeysAdvanced_SetActionType(actionType) {
		global GuiSettings_Controls
		GuiControl, Settings:Choose,% GuiSettings_Controls.hDDL_HotkeyAdvActionType,% actionType
	}

	TabHotkeysAdvanced_SetActionContent(actionContent) {
		global GuiSettings_Controls
		GuiControl, Settings:,% GuiSettings_Controls.hEDIT_HotkeyAdvActionContent,% actionContent
	}
	TabHotkeysAdvanced_SetHotkeyActionsList(actionsList) {
		global GuiSettings_Controls

		Gui, Settings:Default
		Gui, Settings:ListView,% GuiSettings_Controls.hLV_HotkeyAdvActionsList

		Loop % LV_GetCount()
			LV_Delete()
		Loop % actionsList.Actions_Count {
			acShort := GUI_Settings.Get_ActionLongName_From_ShortName(actionsList["Action_" A_Index "_Type"])
			LV_Add("", A_Index, acShort, actionsList["Action_" A_Index "_Content"])
		}
	}

	/* * * * * UPDATE * * * * *
	*/
	TabHotkeysAdvanced_UpdateActionsList() {
		global GuiSettings, GuiSettings_Controls
		actionsList := GUI_Settings.Get_AvailableActions_With_CustomButtonsNames()

		GUI_Settings.TabHotkeysAdvanced_DisableSubroutines()
		GuiControl, Settings:,% GuiSettings_Controls["hDDL_HotkeyAdvActionType"],% "|" actionsList
		GuiControl, Settings:ChooseString,% GuiSettings_Controls["hDDL_HotkeyAdvActionType"],% " "
		GUI_Settings.TabHotkeysAdvanced_UpdateRegisteredHotkeysList()
		GUI_Settings.TabHotkeysAdvanced_EnableSubroutines()
	}

	TabHotkeysAdvanced_UpdateRegisteredHotkeysList() {
		global GuiSettings_Controls

		GuiControl, Settings:+AltSubmit,% GuiSettings_Controls.hDDL_HotkeyAdvExistingList
		chosenItemNum := GUI_Settings.Submit("hDDL_HotkeyAdvExistingList")
		GuiControl, Settings:-AltSubmit,% GuiSettings_Controls.hDDL_HotkeyAdvExistingList

		hkProfiles := GUI_Settings.TabHotkeysAdvanced_GetHotkeyProfiles()
		hkList := "|"
		Loop % hkProfiles.Profiles_Count {
			hkStr := Transform_AHKHotkeyString_Into_ReadableHotkeyString(hkProfiles[A_Index].Hotkey)
			hkList .= hkProfiles[A_Index].Name " (Hotkey: " hkStr ")|"
		}
		if (hkList != "|")
			StringTrimRight, hkList, hkList, 1

		GuiControl, Settings:,% GuiSettings_Controls.hDDL_HotkeyAdvExistingList,% hkList

		if (hkList = "|") {
			GUI_Settings.TabHotkeysAdvanced_SetHotkeyName("")
			GUI_Settings.TabHotkeysAdvanced_SetHotkeyKeys("")
			GUI_Settings.TabHotkeysAdvanced_SetActionContent("")
			GUI_Settings.TabHotkeysAdvanced_SetHotkeyActionsList("")
			GUI_Settings.TabHotkeysAdvanced_SetHkType("Easy")
		}
		else if Isnum(chosenItemNum) { ; Avoid triggering when no item is selected
			GuiControl, Settings:Choose,% GuiSettings_Controls.hDDL_HotkeyAdvExistingList,% chosenItemNum
			if (ErrorLevel) {
				GuiControl, Settings:Choose,% GuiSettings_Controls.hDDL_HotkeyAdvExistingList,% chosenItemNum-1
				GUI_Settings.TabHotkeysAdvanced_OnHotkeyProfileChange("")
			}
		}
		else if !IsNum(chosenItemNum) ; actualyl a str
		 	GuiControl, Settings:ChooseString,% GuiSettings_Controls.hDDL_HotkeyAdvExistingList,% chosenItemNum
	}

	/* * * * * On Change * * * * *
	*/

	TabHotkeysAdvanced_OnHotkeyProfileChange(_which) {
		global PROGRAM, GuiSettings, GuiSettings_Controls
		iniFile := PROGRAM.INI_FILE

		which := _which
		if (which = "") {
			which := GUI_Settings.Submit("hDDL_HotkeyAdvExistingList")
		}

		RegExMatch(which, "O)(.*) \(Hotkey: (.*)\)$", hkNamePat)		
		hkProfiles := GUI_Settings.TabHotkeysAdvanced_GetHotkeyProfiles()
		Loop % hkProfiles.Profiles_Count {
			loopedHK := hkProfiles[A_Index]
			simplifiedHK := Transform_ReadableHotkeyString_Into_AHKHotkeyString(hkNamePat.2)
			if (loopedHK.Name = hkNamePat.1) && (loopedHK.Hotkey = simplifiedHK) {
				matchFound := True
				Break
			}
		}
		if (!matchFound) {
			MsgBox(4096, "", "ERROR: Could not find matching hotkey profile with name """ hkNamePat.1 """ and hotkey """ hkNamePat.2 """")
			Return
		}

		GUI_Settings.TabHotkeysAdvanced_DisableSubroutines()
		GUI_Settings.TabHotkeysAdvanced_SetHotkeyName(loopedHK.Name)
		GUI_Settings.TabHotkeysAdvanced_SetHotkeyKeys(loopedHK.Hotkey)
		GUI_Settings.TabHotkeysAdvanced_SetHotkeyActionsList(loopedHK)
		GUI_Settings.TabHotkeysAdvanced_EnableSubroutines()
		GUI_Settings.TabHotkeysAdvanced_SetHkType(loopedHK.Hotkey_Type)
	}

	TabHotkeysAdvanced_OnHotkeyNameChange() {
		global PROGRAM, GuiSettings, GuiSettings_Controls

		hkInfos := GUI_Settings.TabHotkeysAdvanced_GetActiveHotkeyProfileInfos()
		if !(hkInfos.Num > 0)
			Return

		hkName := hkInfos.Name
		hkName := IsSpace(hkInfos.Name) || hkInfos.Name = "" ? "[ Unnamed ]"
			: hkInfos.Name ; TO_DO; If field is empty, cant remove actions using contextmenu
						   ; Actually this is fine as it forces user to set a name
		AutoTrimStr(hkName)
	
		INI.Set(PROGRAM.Ini_File, "SETTINGS_HOTKEY_ADV_" hkInfos.Num, "Name", hkName)
		Declare_LocalSettings()

		GUI_Settings.TabHotkeysAdvanced_UpdateRegisteredHotkeysList()
	}
	TabHotkeysAdvanced_OnHotkeyKeysChange() {
		global PROGRAM, GuiSettings, GuiSettings_Controls

		hkInfos := GUI_Settings.TabHotkeysAdvanced_GetActiveHotkeyProfileInfos()
		if !(hkInfos.Num > 0)
			Return

		INI.Set(PROGRAM.Ini_File, "SETTINGS_HOTKEY_ADV_" hkInfos.Num, "Hotkey", hkInfos.Hotkey)	
		Declare_LocalSettings()

		if (hkInfos.Hotkey_Type = "Manual")
			GuiControl, Settings:,% GuiSettings_Controls.hHK_HotkeyAdvHotkey,% hkInfos.Hotkey
		else
			GuiControl, Settings:,% GuiSettings_Controls.hEDIT_HotkeyAdvHotkey,% hkInfos.Hotkey

		GUI_Settings.TabHotkeysAdvanced_UpdateRegisteredHotkeysList()
	}
	
	TabHotkeysAdvanced_OnActionTypeChange() {
		global GuiSettings_Controls
		global ACTIONS_READONLY, ACTIONS_FORCED_CONTENT

		hkInfos := GUI_Settings.TabHotkeysAdvanced_GetActiveHotkeyProfileInfos()
		if !(hkInfos.Num > 0)
			Return

		actionType := GUI_Settings.Submit("hDDL_HotkeyAdvActionType"), AutoTrimStr(actionType)
		CtrlHwnd := GuiSettings_Controls.hDDL_HotkeyAdvActionType
		ActionContentCtrlHwnd := GuiSettings_Controls.hEDIT_HotkeyAdvActionContent
		actionContent := GUI_Settings.Submit("hEDIT_HotkeyAdvActionContent")

		actionShortName := GUI_Settings.Get_ActionShortName_From_LongName(actionType)
		contentPlaceholder := GUI_Settings.Get_ActionContentPlaceholder_From_ShortName(actionShortName)
		SetEditCueBanner(GuiSettings_Controls.hEDIT_HotkeyAdvActionContent, contentPlaceholder)
		ShowToolTip(contentPlaceholder)

		if IsContaining(actionType, "----") || (!actionType) {
			GetKeyState, isUpArrowPressed, Up, P
			GetKeyState, isDownArrowPressed, Down, P

			GuiControl, Settings:+AltSubmit,% CtrlHwnd
			chosenItemNum := GUI_Settings.Submit("hDDL_HotkeyAdvActionType")
			GuiControl, Settings:-AltSubmit,% CtrlHwnd

			if (isUpArrowPressed = "D") {
				if (chosenItemNum = 1)
					GuiControl, Settings:Choose,% CtrlHwnd,% 2
				else GuiControl, Settings:Choose,% CtrlHwnd,% chosenItemNum-1 ; TO_DO apparently bug, chose first space instead of closest one, though it works fine in custom button
			}
			else ; just go down
				GuiControl, Settings:Choose,% CtrlHwnd,% chosenItemNum+1

			Sleep 10

			actionType := GUI_Settings.Submit("hDDL_HotkeyAdvActionType")
			GUI_Settings.TabHotkeysAdvanced_SetActionType(actionType)
			GUI_Settings.TabHotkeysAdvanced_OnActionTypeChange()
			Return
		}
		else {
			if (actionType)
				GuiControl, Settings:ChooseString,% CtrlHwnd,% actionType
		}

		if IsIn(actionShortName, ACTIONS_READONLY) {
			GuiControl, Settings:+ReadOnly,% ActionContentCtrlHwnd
		}
		else {
			GuiControl, Settings:-ReadOnly,% ActionContentCtrlHwnd
		}

		for sName, fContent in ACTIONS_FORCED_CONTENT {
			if (sName = actionShortName) {
				forcedContent := fContent
				Break
			}
		}
		if (forcedContent)
			GUI_Settings.TabHotkeysAdvanced_SetActionContent(forcedContent)
		else
			GUI_Settings.TabHotkeysAdvanced_SetActionContent("")
	}

	TabHotkeysAdvanced_OnActionContentChange() {
		global PROGRAM, GuiSettings, GuiSettings_Controls 

		actionType := GUI_Settings.Submit("hDDL_HotkeyAdvActionType")
		actionContent := GUI_Settings.Submit("hEDIT_HotkeyAdvActionContent")
		actionShortName := GUI_Settings.Get_ActionShortName_From_LongName(actionType)
		actionForcedContent := GUI_Settings.Get_ActionForcedContent_From_ActionShortName(actionShortName)

		GUI_Settings.TabHotkeysAdvanced_DisableSubroutines()

		if (actionForcedContent) {
			strL := StrLen(actionForcedContent)
			contentSubStr  := SubStr(actionContent, 1, strL)

			if (contentSubStr != actionForcedContent) {
				GUI_Settings.TabHotkeysAdvanced_SetActionContent(actionForcedContent)
				ShowToolTip("The string has to start with """ actionForcedContent """")
				tipWarn := True, actionContent := actionForcedContent
			}
			else if (actionShortName = "SLEEP") {
				AutoTrimStr(actionContent)

				if (actionContent) && ( !IsDigit(actionContent) || IsContaining(actionContent, ".") ) {
					GUI_Settings.TabHotkeysAdvanced_SetActionContent(100)
					ShowToolTip("This value can only be an integer.")
					tipWarn := True, actionContent := 100
				}
				else if IsDigit(actionContent) && (actionContent > 1000) {
					GUI_Settings.TabHotkeysAdvanced_SetActionContent(1000)
					ShowToolTip("Max value is 1000 milliseconds.")
					tipWarn := True, actionContent := 1000
				}
			}
		}

		if (!tipWarn) && (actionContent) && (actionContent != actionForcedContent)
			ShowToolTip(actionContent)

		GUI_Settings.TabHotkeysAdvanced_EnableSubroutines()
	}

	TabHotkeysAdvanced_OnListClick(CtrlHwnd, GuiEvent, EventInfo, GuiEvent2="") {
		global GuiSettings, GuiSettings_Controls

		hkInfos := GUI_Settings.TabHotkeysAdvanced_GetActiveHotkeyProfileInfos()
		if !(hkInfos.Num > 0)
			Return

		Gui, Settings:Default
		Gui, Settings:ListView,% GuiSettings_Controls.hLV_HotkeyAdvActionsList

		thisFunc := "TabHotkeysAdvanced_OnListClick"

		if GuiEvent in Normal,D,I,K
		{
			GoSub %thisFunc%_Get_Selected

			GUI_Settings.TabHotkeysAdvanced_SetActionType(actionType)
			if (ErrorLevel) {
				if (rowID = 0)
					Return
				Msgbox(4096, "", "Unknown action type: """ actionType """")
				GuiControl, Settings:ChooseString,% GuiSettings_Controls.hDDL_HotkeyAdvActionType,% " "
			}
			GUI_Settings.TabHotkeysAdvanced_SetActionContent(actionContent)
		}
		if (GuiEvent = "RightClick") {
			LV_RightClick := true
			GoSub %thisFunc%_Get_Selected

			try Menu, RClickMenu, DeleteAll
			Menu, RClickMenu, Add, Move up, TabHotkeysAdvanced_OnListClick_Menu
			Menu, RClickMenu, Add, Move down, TabHotkeysAdvanced_OnListClick_Menu
			Menu, RClickMenu, Add
			Menu, RClickMenu, Add, Remove this action, TabHotkeysAdvanced_OnListClick_Menu
			Menu, RClickMenu, Show
		}
		Return

		TabHotkeysAdvanced_OnListClick_Menu:
			Gui, Settings:Default
			Gui, Settings:ListView,% GuiSettings_Controls.hLV_ButtonsActions

			if (A_ThisMenu = "RClickMenu") {
				if (A_ThisMenuItem = "Remove this action")
					GUI_Settings.TabHotkeysAdvanced_AddAction("Remove", GuiSettings.HotkeysAdvanced_Selected_LV_Row)
				else if (A_ThisMenuItem = "Move up")
					GUI_Settings.TabHotkeysAdvanced_MoveAction("Up", rowID)
				else if (A_ThisMenuItem = "Move down")
					GUI_Settings.TabHotkeysAdvanced_MoveAction("Down", rowID)
			}
		Return

		TabHotkeysAdvanced_OnListClick_Get_Selected:
		; LV_GetText(string, A_EventInfo) is unreliable. A_EventInfo will sometimes not contain the correct row ID.
		; LV_GetNext() seems to be the best alternative. Though, it rises an issue when no row is selected.
		;	Instead of retrieving a blank value, it will retrieve the same value as the previously selected row ID.
		;	As workaround, when the user does not select any row, we re-highlight the previously selected one.
		
			Gui, Settings:Default
			Gui, Settings:ListView,% GuiSettings_Controls.hLV_HotkeyAdvActionsList

			hkInfos := GUI_Settings.TabHotkeysAdvanced_GetActiveHotkeyProfileInfos()
			if !(hkInfos.Num > 0)
				Return

			rowID := LV_GetNext(0, "F")
			if (rowID = 0) {
				rowID := LV_GetCount()?LV_GetCount():0
			}
			LV_GetText(rowNum, rowID, 1)
			LV_GetText(actionType, rowID, 2)
			LV_GetText(actionContent, rowID, 3)

			LV_Modify(rowID, "+Select")

			GuiSettings.HotkeysAdvanced_Selected_LV_Row := rowID
		Return
	}

	/* * * * * Misc * * * * *
	*/

	TabHotkeysAdvanced_ShowSaveChangesMenu() {
		global GuiSettings
		selected := GuiSettings.HotkeysAdvanced_Selected_LV_Row

		Gui, Settings:Default
		Gui, Settings:ListView,% GuiSettings_Controls.hLV_HotkeyAdvActionsList

		try Menu, HKAdv_SaveChangesMenu, DeleteAll
		Menu, HKAdv_SaveChangesMenu, Add, Currently selected (%selected%), TabHotkeysAdvanced_ShowSaveChangesMenu_MenuHandler
		Loop % LV_GetCount()
			Menu, HKAdv_SaveChangesMenu, Add,% A_Index, TabHotkeysAdvanced_ShowSaveChangesMenu_MenuHandler
		Menu, HKAdv_SaveChangesMenu, Show
		return

		TabHotkeysAdvanced_ShowSaveChangesMenu_MenuHandler:
			RegExMatch(A_ThisMenuItem, "\d+", num)
			if IsNum(num)
				GUI_Settings.TabHotkeysAdvanced_AddAction("Replace", num)
			else
				Msgbox(4096, "", "An error occured when retrieveing the number from """ A_ThisMenuItem """")
		return
	}

	TabHotkeysAdvanced_AddNewHotkeyProfile() {
		global PROGRAM, GuiSettings, GuiSettings_Controls
		iniFile := PROGRAM.INI_FILE

		InputBox, newHkProf,% PROGRAM.Name,% "Input a new profile name:", , 250, 150
		if (!newHKProf)
			Return

		Loop {
			loopIndex := A_Index
			if !(PROGRAM.SETTINGS["SETTINGS_HOTKEY_ADV_" loopIndex].Name)
				Break
		}
		INI.Set(iniFile, "SETTINGS_HOTKEY_ADV_" loopIndex, "Name", newHKProf)
		INI.Set(iniFile, "SETTINGS_HOTKEY_ADV_" loopIndex, "Hotkey", "")
		INI.Set(iniFile, "SETTINGS_HOTKEY_ADV_" loopIndex, "Hotkey_Type", "Easy")
		Declare_LocalSettings()

		GUI_Settings.TabHotkeysAdvanced_UpdateRegisteredHotkeysList()
		GUI_Settings.TabHotkeysAdvanced_DisableSubroutines()
		GuiControl, Settings:Choose,% GuiSettings_Controls.hDDL_HotkeyAdvExistingList,% loopIndex
		GUI_Settings.TabHotkeysAdvanced_EnableSubroutines()
		GUI_Settings.TabHotkeysAdvanced_OnHotkeyProfileChange("")
		Return				
	}
	
	TabHotkeysAdvanced_DeleteCurrentHotkeyProfile() {
		global GuiSettings, GuiSettings_Controls, PROGRAM
		iniFile := PROGRAM.INI_FILE

		selectedProfile := GUI_Settings.TabHotkeysAdvanced_GetActiveHotkeyProfileInfos()
		hkStr := Transform_AHKHotkeyString_Into_ReadableHotkeyString(selectedProfile.Hotkey)
		MsgBox(4096+48+4, "", selectedProfile.Name " (Hotkey: " hkStr ")"
		. "`nAre you sure you want to delete this hotkey profile?")
		IfMsgBox, Yes
		{
			hkProfiles := GUI_Settings.TabHotkeysAdvanced_GetHotkeyProfiles()
			
			diff := hkProfiles.Profiles_Count-selectedProfile.Num
			if (diff) {
				fromNum := selectedProfile.Num+1, toNum := selectedProfile.Num
				Loop % diff {
					INI.Rename(iniFile, "SETTINGS_HOTKEY_ADV_" fromNum, "", "SETTINGS_HOTKEY_ADV_" toNum)
					fromNum++, toNum++
				}
			}
			else {
				INI.Remove(iniFile, "SETTINGS_HOTKEY_ADV_" selectedProfile.Num)
			}

			Declare_LocalSettings()
			GUI_Settings.TabHotkeysAdvanced_UpdateRegisteredHotkeysList()
		}
	}

	TabHotkeysAdvanced_SaveSelectedHotkeyActions() {
		global GuiSettings, GuiSettings_Controls, PROGRAM
		iniFile := PROGRAM.INI_FILE

		Gui, Settings:Default
		Gui, Settings:ListView,% GuiSettings_Controls.hLV_HotkeyAdvActionsList
		hkInfos := GUI_Settings.TabHotkeysAdvanced_GetActiveHotkeyProfileInfos()
		iniSect := "SETTINGS_HOTKEY_ADV_" hkInfos.Num

		if !(hkInfos.Num > 0)
			Return

		Loop {
			iniLineExists := INI.Get(iniFile, iniSect, "Action_" A_Index "_Type")
			iniLineExists := (iniLineExists = "ERROR")?(False):(True)
			if (iniLineExists) {
				INI.Remove(iniFile, iniSect, "Action_" A_Index "_Type")
				INI.Remove(iniFile, iniSect, "Action_" A_Index "_Content")
			}
			else Break
		}
		Loop % LV_GetCount() {
			LV_GetText(retrievedRowType, A_Index, 2)
			LV_GetText(retrievedRowContent, A_Index, 3)
			acShort := GUI_Settings.Get_ActionShortName_From_LongName(retrievedRowType)

			INI.Set(iniFile, iniSect, "Action_" A_Index "_Type", acShort)
			INI.Set(iniFile, iniSect, "Action_" A_Index "_Content", """" retrievedRowContent """")
		}
		Declare_LocalSettings()
	}

	TabHotkeysAdvanced_AddAction(whatDo, whichPos) {
		global PROGRAM, GuiSettings, GuiSettings_Controls

		Gui, Settings:Default
		Gui, Settings:ListView,% GuiSettings_Controls.hLV_HotkeyAdvActionsList

		hkInfos := GUI_Settings.TabHotkeysAdvanced_GetActiveHotkeyProfileInfos()
		if !(hkInfos.Num > 0)
			Return

		actionType := GUI_Settings.Submit("hDDL_HotkeyAdvActionType"), AutoTrimStr(actionType)
		actionContent := GUI_Settings.Submit("hEDIT_HotkeyAdvActionContent")
		actionShortName := GUI_Settings.Get_ActionShortName_From_LongName(actionType)

		lvCount := LV_GetCount(), LV_GetText(lastAction, lvCount, 2)
		lastActionShortName := GUI_Settings.Get_ActionShortName_From_LongName(lastAction)

		if (whatDo = "Replace" && whichPos < lvCount)
		&& IsIn(actionShortName, "WRITE_THEN_GO_BACK,WRITE_MSG,WRITE_TO_LAST_WHISPER,WRITE_TO_BUYER,CLOSE_TAB") {
			MsgBox(4096, "", "This action can only be set as the last action for this button. Please remove or re-order actions.")
			Return
		}

		if (!actionType) || IsContaining(actionType, "----") || (!hkInfos.Name)
			Return

		if (whatDo = "Replace") {
			LV_Modify(whichPos, "" , whichPos, actionType, actionContent)
		}
		else if (whatDo = "Push") {
			allActions := GUI_Settings.TabHotkeysAdvanced_GetCurrentHotkeysActionsList()
			newAllActions := GUI_Settings.TabHotkeysAdvanced_GetCurrentHotkeysActionsList()

			if (whichPos = "") {
				if IsIn(actionShortName, "WRITE_THEN_GO_BACK,WRITE_MSG,WRITE_TO_LAST_WHISPER,WRITE_TO_BUYER,CLOSE_TAB")
				&& IsIn(lastActionShortName, "WRITE_THEN_GO_BACK,WRITE_MSG,WRITE_TO_LAST_WHISPER,WRITE_TO_BUYER") {
					MsgBox(4096, "", "You may not add this action (" actionType ") because the last action (" lastAction ") does not send the message.")
					return
				}
				else if IsIn(actionShortName, "WRITE_THEN_GO_BACK,WRITE_MSG,WRITE_TO_LAST_WHISPER,WRITE_TO_BUYER,CLOSE_TAB")
				&& IsIn(lastActionShortName, "CLOSE_TAB") {
					MsgBox(4096, "", "You may not add this action (" actionType ") because the last action (" lastAction ") is closing the tab.")
					return
				}
				else if IsIn(lastActionShortName, "WRITE_THEN_GO_BACK,WRITE_MSG,WRITE_TO_LAST_WHISPER,WRITE_TO_BUYER,CLOSE_TAB")
					whichPos := lvCount
				else whichPos := lvCount+1
			}
				
			if (whichPos > lvCount) {
				newAllActions[whichPos] := {Num:whichPos, ActionType: actionType, ActionContent: actionContent}
			}
			else {
				for index, nothing in allActions {
					if (index >= whichPos) {
						diff := (index - whichPos) + 1
						newAllActions[index+diff] := allActions[index], newAllActions[index+diff].Num := index+diff
					}
				}
				newAllActions[whichPos] := {Num:whichPos, ActionType: actionType, ActionContent: actionContent}
			}

			Loop % LV_GetCount()
				LV_Delete()
			for index, nothing in newAllActions
				LV_Add("", newAllActions[index].Num, newAllActions[index].Actiontype, newAllActions[index].ActionContent)
		}
		else if (whatDo = "Remove") {
			Loop % lvCount {
				LV_GetText(retrievedRowNum, A_Index, 1)
				if (retrievedRowNum >= whichPos) {
					LV_GetText(retrievedRowType, retrievedRowNum, 2)
					LV_GetText(retrievedRowContent, retrievedRowNum, 3)
					LV_Modify(retrievedRowNum, "", retrievedRowNum-1, retrievedRowType, retrievedRowContent)
				}
			}
			LV_Delete(whichPos)
		}

		GUI_Settings.TabHotkeysAdvanced_SaveSelectedHotkeyActions()
	}

	TabHotkeysAdvanced_GetCurrentHotkeysActionsList() {
		global GuiSettings, GuiSettings_Controls

		Gui, Settings:Default
		Gui, Settings:ListView,% GuiSettings_Controls.hLV_HotkeyAdvActionsList
		
		actions := {}
		Loop % LV_GetCount() {			
			LV_GetText(rowNum, A_Index, 1)
			LV_GetText(actionType, A_Index, 2)
			LV_GetText(actionContent, A_Index, 3)
			actions[A_Index] := {Num:rowNum, ActionType:actionType, ActionContent:actioncontent}
		}

		return actions
	}

	TabHotkeysAdvanced_MoveAction(side, acNum) {
		global GuiSettings_Controls

		Gui, Settings:Default
		Gui, Settings:ListView,% GuiSettings_Controls.hLV_HotkeyAdvActionsList

		LV_GetText(lastActionNum, LV_GetCount(), 1)
		LV_GetText(lastActionType, LV_GetCount(), 2)
		lastActionShortName := GUI_Settings.Get_ActionShortName_From_LongName(lastActionType)

		if IsIn(lastActionShortName, "WRITE_THEN_GO_BACK,WRITE_MSG,WRITE_TO_LAST_WHISPER,WRITE_TO_BUYER")
		&& (lastActionNum = acNum+1) && (side = "Down") {
			MsgBox(4096, "", "You cannot move this action down because the last action """ lastActionType """ does not send the message.")
			Return
		}
		else if IsIn(lastActionShortName, "WRITE_THEN_GO_BACK,WRITE_MSG,WRITE_TO_LAST_WHISPER,WRITE_TO_BUYER")
		&& (lastActionNum = acNum) && (side = "Up") {
			MsgBox(4096, "", "You cannot move this action up because it does not send the message.")
			Return
		}
		else if (lastActionShortName = "CLOSE_TAB")
		&& (lastActionNum = acNum+1) && (side = "Down") {
			MsgBox(4096, "", "You cannot move this action down because the last action """ lastActionType """ closes the tab.")
			Return
		}	
		else if (lastActionShortName = "CLOSE_TAB")
		&& (lastActionNum = acNum) && (side = "Up") {
			MsgBox(4096, "", "You cannot move this action up because it closes the tab.")
			Return
		}
		else if ( (acNum = LV_GetCount()) && (side = "Down") )
		|| ( (acNum = 1) && (side = "Up") )
			return

		allActions := GUI_Settings.TabHotkeysAdvanced_GetCurrentHotkeysActionsList()
		newAllActions := GUI_Settings.TabHotkeysAdvanced_GetCurrentHotkeysActionsList()
		if (side = "Up") {
			newAllActions[acNum] := allActions[acNum-1]
			newAllActions[acNum-1] := allActions[acNum]
		}
		else if (side = "Down") {
			newAllActions[acNum] := allActions[acNum+1]
			newAllActions[acNum+1] := allActions[acNum]
		}
	
		Loop % LV_GetCount()
			LV_Delete()
		for index, nothing in newAllActions
			LV_Add("", index, newAllActions[index].Actiontype, newAllActions[index].ActionContent)
	}

	TabHotkeysAdvanced_ShowHKTypeMenu() {
		global GuiSettings, TabHotkeysAdvanced_SetHkType, PROGRAM
		iniFile := PROGRAM.INI_FILE

		try Menu, HKTypeMenu, DeleteAll
		Menu, HKTypeMenu, Add, Easy (automatically detect key pressed), HkTypeMenu_Easy
		Menu, HKTypeMenu, Add, Manual (type key combination manually), HKTypeMenu_Manual
		Menu, HKTypeMenu, Show
		return

		HKTypeMenu_Easy:
			hkInfos := GUI_Settings.TabHotkeysAdvanced_GetActiveHotkeyProfileInfos()
			GUI_Settings.TabHotkeysAdvanced_SetHkType("Easy")
			if !IsNum(hkInfos.Num)
				return

			iniSect := "SETTINGS_HOTKEY_ADV_" hkInfos.Num
			INI.Set(iniFile, iniSect, "Hotkey_Type", "Easy")
		return
		HKTypeMenu_Manual:
			hkInfos := GUI_Settings.TabHotkeysAdvanced_GetActiveHotkeyProfileInfos()
			GUI_Settings.TabHotkeysAdvanced_SetHkType("Manual")
			if !IsNum(hkInfos.Num)
				return

			iniSect := "SETTINGS_HOTKEY_ADV_" hkInfos.Num
			INI.Set(iniFile, iniSect, "Hotkey_Type", "Manual")
		return
	}
	TabHotkeysAdvanced_SetHkType(which) {
		global GuiSettings_Controls

		if (which="Manual") {
			GuiControl, Settings:Show,% GuiSettings_Controls.hEDIT_HotkeyAdvHotkey
			GuiControl, Settings:Hide,% GuiSettings_Controls.hHK_HotkeyAdvHotkey
		}
		else { ; Easy
			GuiControl, Settings:Hide,% GuiSettings_Controls.hEDIT_HotkeyAdvHotkey
			GuiControl, Settings:Show,% GuiSettings_Controls.hHK_HotkeyAdvHotkey
		}
	}

	/* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * 
	*	Tab MISC UPDATING
	*/

	/* * * * * Subroutines toggle * * * * *
	*/
	TabMiscUpdating_EnableSubroutines() {
		GUI_Settings.TabMiscUpdating_ToggleSubroutines("Enable")
	}
	TabMiscUpdating_DisableSubroutines() {
		GUI_Settings.TabMiscUpdating_ToggleSubroutines("Disable")
	}
	TabMiscUpdating_ToggleSubroutines(enableOrDisable) {
		global GuiSettings, GuiSettings_Controls
		thisTabCtrls := GuiSettings.TabMiscUpdating_Controls

		Loop, Parse, thisTabCtrls,% ","
		{
			loopedCtrl := A_LoopField
			isCheckbox := SubStr(loopedCtrl, 1, 3)="hCB" ? True : False

			if (enableOrDisable = "Disable")
				GuiControl, Settings:-g,% GuiSettings_Controls[loopedCtrl]
			else if (enableOrDisable = "Enable") {
				if (loopedCtrl = "hBTN_CheckForUpdates")
					__f := GUI_Settings.TabMiscUpdating_CheckForUpdates.bind(GUI_Settings)
				else if (isCheckbox)
					__f := GUI_Settings.TabMiscUpdating_OnCheckboxToggle.bind(Gui_Settings, loopedCtrl)
				else 
					__f := 

				if (__f)
					GuiControl, Settings:+g,% GuiSettings_Controls[loopedCtrl],% __f 
			}
		}
	}

	TabMiscUpdating_SetUserSettings() {
		global PROGRAM, GuiSettings_Controls
		thisTabSettings := PROGRAM.SETTINGS.UPDATING

		GUI_Settings.TabMiscUpdating_UpdateVersionsText()
		; Set checkbox state
		for key, value in thisTabSettings {
			if IsIn(key, "AllowToUpdateAutomaticallyOnStart,AllowPeriodicUpdateCheck,UseBeta,DownloadUpdatesAutomatically") {
				cbValue := value="True"?1 : value="False"?0 : value
				thisTabSettings[key] := cbValue
			}
			if (key = "CheckForUpdatePeriodically") {
				ddlValue := value="OnStartOnly" ? "Only on application start"
					: value="OnStartAndEveryFiveHours" ? "On start + every 5 hours"
					: value="OnStartAndEveryDay" ? "On start + every day"
					: ""
				thisTabSettings[key] := ddlValue
			}
		}
		; GuiControl, Settings:,% GuiSettings_Controls.hCB_AllowToUpdateAutomaticallyOnStart ,% thisTabSettings.AllowToUpdateAutomaticallyOnStart
		; GuiControl, Settings:,% GuiSettings_Controls.hCB_AllowPeriodicUpdateCheck ,% thisTabSettings.AllowPeriodicUpdateCheck
		GuiControl, Settings:ChooseString,% GuiSettings_Controls.hDDL_CheckForUpdate,% thisTabSettings.CheckForUpdatePeriodically
		GuiControl, Settings:,% GuiSettings_Controls.hCB_UseBeta,% thisTabSettings.UseBeta
		GuiControl, Settings:,% GuiSettings_Controls.hCB_DownloadUpdatesAutomatically,% thisTabSettings.DownloadUpdatesAutomatically
	}

	TabMiscUpdating_UpdateVersionsText() {
		global PROGRAM, GuiSettings_Controls
		thisTabSettings := PROGRAM.SETTINGS.UPDATING

		; Get time diff since update check
		timeDiff := timeDiffS A_Now, lastTimeChecked := thisTabSettings.LastUpdateCheck
		timeDiffS -= lastTimeChecked, Seconds
		timeDiff -= lastTimeChecked, Minutes
		timeDiff := timeDiffS < 61 ? 1 : timeDiff
		; Set groupbox title
		isStableBetter := IsStableBetter(thisTabSettings.LatestStable, thisTabSettings.LatestBeta)
		updAvailable := isStableBetter ? thisTabSettings.LatestStable: thisTabSettings.LatestBeta
		if (updAvailable != PROGRAM.VERSION && updAvailable)
			GuiControl, Settings:,% GuiSettings_Controls.hGB_UpdateCheck,% updAvailable " is available!"
		else GuiControl, Settings:,% GuiSettings_Controls.hGB_UpdateCheck,% "You are up to date!"

		; Set field content
		GuiControl, Settings:,% GuiSettings_Controls.hTEXT_ProgramVer,% PROGRAM.VERSION
		GuiControl, Settings:,% GuiSettings_Controls.hTEXT_LatestStableVer,% thisTabSettings.LatestStable
		GuiControl, Settings:,% GuiSettings_Controls.hTEXT_LatestBetaVer,% thisTabSettings.LatestBeta
		GuiControl, Settings:,% GuiSettings_Controls.hTEXT_MinsAgo,% "(" timeDiff " mins ago)"
		; Update control size
		GuiControl, Settings:Move,% GuiSettings_Controls.hTEXT_ProgramVer,% "w" Get_TextCtrlSize(PROGRAM.VERSION, "Consolas", "8").W
		GuiControl, Settings:Move,% GuiSettings_Controls.hTEXT_LatestStableVer,% "w" Get_TextCtrlSize(thisTabSettings.LatestStable, "Consolas", "8").W
		GuiControl, Settings:Move,% GuiSettings_Controls.hTEXT_LatestBetaVer,% "w" Get_TextCtrlSize(thisTabSettings.LatestBeta, "Consolas", "8").W
		GuiControl, Settings:Move,% GuiSettings_Controls.hTEXT_MinsAgo,% "w" Get_TextCtrlSize("(" timeDiff " mins ago)", "Consolas", "8").W
	}

	TabMiscUpdating_OnCheckboxToggle(CtrlName) {
		global PROGRAM
		iniFile := PROGRAM.INI_FILE

		iniKey := SubStr(CtrlName, 5)

		val := GUI_Settings.Submit(CtrlName)
		val := val=0?"False":val=1?"True":val

		INI.Set(iniFile, "UPDATING", iniKey, val)
		Declare_LocalSettings()
	}

	TabMiscUpdating_CheckForUpdates() {
		global PROGRAM, GuiSettings_Controls
		thisTabSettings := PROGRAM.SETTINGS.UPDATING

		UpdateCheck(checkType:="forced", notifOrBox:="box")
		GUI_Settings.TabMiscUpdating_UpdateVersionsText()
	}

	/* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * 
	*	Tab MISC ABOUT
	*/

	TabMiscAbout_UpdateAllOfFame() {
		SetTimer, GUI_Setting_TabMiscAbout_UpdateAllOfFame_Timer, -10
		Return

		GUI_Setting_TabMiscAbout_UpdateAllOfFame_Timer:
			hof := GUI_Settings.TabMiscAbout_GetHallOfFame()
			GUI_Settings.TabMiscAbout_SetHallOfFame(hof)
		Return
	}

	TabMiscAbout_SetHallOfFame(hof) {
		global GuiSettings_Controls

		txt := "Hall of Fame`nThank you for your support!`n`n" hof
		GuiControl, Settings:,% GuiSettings_Controls.hEDIT_HallOfFame,% txt
	}

	TabMiscAbout_GetHallOfFame() {
		global PROGRAM

		postData := ""
		reqHeaders := []
		reqHeaders.Push("Content-Type: text/html; charset=UTF-8")
		url := "https://github.com/lemasato/POE-Trades-Companion/wiki/Support"
		html := cURL_Download(url, postData, reqHeaders, "", false, false, false, "", reqHeadersCurl)

		hallOfFame := ""
		if RegExMatch(html,"\<table\>(.*)\<\/table\>", match) {
			Loop, Parse, match,% "`n",% "`r"
			{
				if RegExMatch(A_LoopField,"\<td\>(.*?)\<\/td\>", name) {
					name := StrReplace(name, "<td>")
					name := StrReplace(name, "</td>")
					hallOfFame .= name "`n"
				}
			}
		}
		Sort, hallOfFame, D`n

		return hallOfFame		
	}

	/* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * 
	*	GENERAL FUNCTIONS
	*/

	Hotkey_OnSpecialKeyPress(CtrlHwnd, keyStr) {
		global GuiSettings, GuiSettings_Controls

		if (CtrlHwnd = GuiSettings_Controls.hHK_HotkeyAdvHotkey) {
			GUI_Settings.TabHotkeysAdvanced_SetHotkeyKeys(keyStr)
			GUI_Settings.TabHotkeysAdvanced_OnHotkeyKeysChange()
		}
		else if IsIn(CtrlHwnd, GuiSettings.TabHotkeysBasic_HotkeysCtrlList) {
			GUI_Settings.TabHotkeysBasic_SetHotkeyKeys(CtrlHwnd, keyStr)
			GUI_Settings.TabHotkeysBasic_OnHotkeyKeysChange(CtrlHwnd)
		}
		else {
			MsgBox YOU SOULD NOT SEE THIS`nFunc: %A_ThisFunc%`nCtrl: %CtrlHwnd_Or_CtrlNum%
		}
	}

	Get_ActionContentPlaceholder_From_ShortName(shortName) {
		global ACTIONS_DEFAULT_CONTENT
		return ACTIONS_DEFAULT_CONTENT[shortName]
	}

	Get_ActionLongName_From_ShortName(shortName) {
		global ACTIONS_TEXT_NAME

		return ACTIONS_TEXT_NAME[shortName]
	}

	Get_ActionShortName_From_LongName(longName) {
		global ACTIONS_TEXT_NAME

		for sName, lName in ACTIONS_TEXT_NAME
			if (lName = longName)
				return sName
	}

	OnTabBtnClick(ClickedTab) {
		global GuiSettings, GuiSettings_Controls
		static prevSection, newSection

		GuiControl, Settings:ChooseString,% GuiSettings_Controls.hTab_AllTabs,% ClickedTab

		ClickedTabNoSpace := StrReplace(ClickedTab, A_Space, "_")

		for tabName, handle in GuiSettings.Tabs_Controls {
			if (tabName = ClickedTabNoSpace)
				GuiControl, Settings:+Disabled,% handle
			else
				GuiControl, Settings:-Disabled,% handle
		}

		newSection := IsIn(ClickedTab, "Settings Main") ? GuiSettings_Controls.hBTN_SectionSettings
		:	IsIn(ClickedTab, "Customization Skins,Customization Buttons") ? GuiSettings_Controls.hBTN_SectionCustomization
		:	IsIn(ClickedTab, "Hotkeys Basic,Hotkeys Advanced") ? GuiSettings_Controls.hBTN_SectionHotkeys
		:	IsIn(ClickedTab, "Misc Updating,Misc About") ? GuiSettings_Controls.hBTN_SectionMisc
		: 	"ERROR"

		if (newSection != "ERROR") {
			if (newSection != prevSection) {
				GuiControl, Settings:+Disabled,% newSection
				GuiControl, Settings:-Disabled,% prevSection
			}
			prevSection := newSection
		}

		if (ClickedTab = "Customization Buttons") {
			GUI_Settings.TabCustomizationButtons_SetUserSettings()
		}

		; WinSet, Redraw, , A
	}

	Submit(CtrlName="") {
		global GuiSettings_Submit
		Gui.Submit("Settings")

		if (CtrlName) {
			Return GuiSettings_Submit[ctrlName]
		}
	}

	ContextMenu(CtrlHwnd, CtrlName) {
		global PROGRAM, GuiSettings
		iniFile := PROGRAM.INI_FILE

		; = = CUSTOMIZATION BUTTONS = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = =
		if IsIn(CtrlHwnd, GuiSettings.CustomButtons_HandlesList) {
			btnInfos := GUI_Settings.TabCustomizationButtons_CustomButton_GetSlotInfos(CtrlHwnd)
			btnSize := btnInfos.Size, btnSlot := btnInfos.Slot

			try Menu, CBMenu, DeleteAll
			Menu, CBMenu, Add,% CtrlName,Settings_ContextMenu_DoNothing
			Menu, CBMenu, Add
			Menu, CBMenu, Add, Rename, Settings_ContextMenu_Rename
			Menu, CBMenu, Add
			Menu, CBMenu, Add, Size: Small, Settings_ContextMenu_Resize
			Menu, CBMenu, Add, Size: Medium, Settings_ContextMenu_Resize
			Menu, CBMenu, Add, Size: Large, Settings_ContextMenu_Resize
			Menu, CBMenu, Add
			Menu, CBMenu, Add, Hide this button, Settings_ContextMenu_Resize

			Menu, CBMenu, Disable,% CtrlName

			if IsContaining(btnInfos.Slots, "3,6,9") {
				Menu, CBMenu, Disable, Size: Medium
				Menu, CBMenu, Disable, Size: Large
			}
			else if IsContaining(btnInfos.Slot, "2,5,8") {
				Menu, CBMenu, Disable, Size: Large
			}

			Menu, CBMenu, Show
		}
		else if IsIn(CtrlHwnd, GuiSettings.UnicodeButtons_HandlesList) {

			try Menu, UBMenu, DeleteAll
			Menu, UBMenu, Add, Clipboard, Settings_ContextMenu_SetSpecialButton
			Menu, UBMenu, Add, Whisper, Settings_ContextMenu_SetSpecialButton
			Menu, UBMenu, Add, Invite, Settings_ContextMenu_SetSpecialButton
			Menu, UBMenu, Add, Trade, Settings_ContextMenu_SetSpecialButton
			Menu, UBMenu, Add, Kick, Settings_ContextMenu_SetSpecialButton
			Menu, UBMenu, Add
			Menu, UBMenu, Add, Hide this button, Settings_ContextMenu_SetSpecialButton

			Menu, UBMenu, Show
		}
		Return

		Settings_ContextMenu_Rename:
			Gui, Settings:+OwnDialogs
			InputBox, newBtnName,% PROGRAM.NAME,% "Input the new button name for """ CtrlName """:", , 300, 150
			if (newBtnName && !ErrorLevel) {
				GUI_Settings.TabCustomizationButtons_CustomButton_Rename(CtrlHwnd, newBtnName)
			}
			try Menu, CBMenu, DeleteAll
		Return

		Settings_ContextMenu_Resize:
			menuItem := A_ThisMenuItem

			if (menuItem = "Hide this button") {
				GUI_Settings.TabCustomizationButtons_CustomButton_Resize(CtrlHwnd, "Hide")
			}
			else if IsIn(menuItem,"Size: Small,Size: Medium,Size: Large") {
				splitSize := StrSplit(menuItem, ": "), btnNewSize := splitSize.2
				GUI_Settings.TabCustomizationButtons_CustomButton_Resize(CtrlHwnd, btnNewSize)
			}
			try Menu, CBMenu, DeleteAll

			GUI_Settings.TabHotkeysAdvanced_UpdateActionsList()
			GUI_Settings.TabHotkeysBasic_UpdateActionsList()
		Return

		Settings_ContextMenu_SetSpecialButton:
			if IsIn(A_ThisMenuItem, "Clipboard,Whisper,Invite,Trade,Kick") {
				specialChar := A_ThisMenuItem = "Clipboard" ? "0"
					: A_ThisMenuItem = "Whisper" ? "1"
					: A_ThisMenuItem = "Invite" ? "2"
					: A_ThisMenuItem = "Trade" ? "3"
					: A_ThisMenuItem = "Kick" ? "4"
					: ""
				GUI_Settings.TabCustomizationButtons_UnicodeButton_Rename(CtrlHwnd, specialChar)
			}
			else {
				GUI_Settings.TabCustomizationButtons_UnicodeButton_Hide(CtrlHwnd)
			}

			GUI_Settings.TabCustomizationButtons_UnicodeButton_UpdateSlots()

			try Menu, CBMenu, DeleteAll
		Return

		Settings_ContextMenu_DoNothing:
			try Menu, CBMenu, DeleteAll
			GuiControl, Settings:,% CtrlHwnd,% A_ThisMenuItemPos-1
		Return
	}

	GetControlToolTip(ctrlN) {
		global DEBUG

		_tooltips := {"":""

		,	"hIMG_GitHub"	: "Visit the GitHub repository for this project."
		, 	"hIMG_PoE"		: "Visit the pathofexile.com thread for this project."
		, 	"hIMG_Reddit"	: "Visit my submitted Reddit posts."
		, 	"hIMG_Discord"	: "Invitation link to my Discord server."
		,	"hIMG_Paypal"	: "Support me through Paypal."
			.				  "`nYour name will forever be graved to the Hall of Fame, visible in the About tab."


		,	"hCB_HideInterfaceWhenOutOfGame": 				"Hides the interface when tabbed out of game."
		,	"hCB_MinimizeInterfaceToBottomLeft": 			"Minimize the interface to the bottom-left of its position instead of top-right."
		,	"hCB_CopyItemInfosOnTabChange": 				"Copies the tab's item infos upon changing tabs."
		,	"hCB_AutoFocusNewTabs": 						"When receiving a new trading whisper, activates the new tab."
		, 	"hCB_AutoMinimizeOnAllTabsClosed": 				"Puts the interface in its minimized state upon closing the last open tab."
		, 	"hCB_AutoMaximizeOnFirstNewTab": 				"Puts the interface in its maximized state upon creating the first tab."
		, 	"hCB_AllowClicksToPassThroughWhileInactive": 	"When no tabs remain, mouse clicks will go through the interface."
			. 												"`nMake sure to reduce the ""No tab remaining"" transparency for the best experience."
		, 	"hSLIDER_NoTabsTransparency": 					"Transparency of the interface when no tab are remaining."
			. 												 "`nBest to be used with the ""click through"" setting for the best experience."
		, 	"hSLIDER_TabsOpenTransparency": 				"Transparency of the interface while tabs are still open."
		,	"hCB_SendTradingWhisperUponCopyWhenHoldingCTRL":"Instantly send the whisper in-game if you are holding CTRL"
			.												"`nwhen clicking on the trading website copy whisper button."

		,	"hCB_TradingWhisperSFXToggle": 				"Play a custom sound when receiving a trading whisper."
		,	"hCB_RegularWhisperSFXToggle": 				"Play a custom sound when receiving a regular whisper."
		,	"hCB_BuyerJoinedAreaSFXToggle":				"Play a custom sound when a buyer joined your area."
		,	"hCB_ShowTabbedTrayNotificationOnWhisper": 	"While tabbed out of the game, shows a tray notification for whispers received."

		,	"hDDL_SendMsgMode": "!! ADVANCED USERS !!"
			.					"`nChooses the way in-game messages should be sent."

		,	"hEDIT_PushBulletToken":"Your PushBullet token."
			.						"`nCan be obtained by clicking ""Create Access Token"" at: https://www.pushbullet.com/#settings/account"
		, 	"hCB_PushBulletOnTradingWhisper":"Receive a PB notification upon receiving a trading whisper"
		, 	"hCB_PushBulletOnPartyMessage":"Receive a PB notification upon receiving a party message"
		, 	"hCB_PushBulletOnWhisperMessage":"Receive a PB notification upon receiving a regular whisper"
		, 	"hCB_PushBulletOnlyWhenAfk":"Receive a PB notification only if you are AFK."

		,	"hEDIT_PoeAccounts":"Your PoE accounts names."
			.					"`nUsed for the price verify feature."
			. 					"`n!! CASE SENSITIVE !!"


		,	"hDDL_SkinPreset":					"Choose among the skins presets here."
		, 	"hLB_SkinBase":						"!! ADVANCED USERS !!"
		, 	"hEDIT_SkinScalingPercentage":		"!! ADVANCED USERS !!"
			.							 	 	"`nIncreases or decreases the interface size."
		, 	"hLB_SkinFont":						"!! ADVANCED USERS !!"
		,	"hCB_UseRecommendedFontSettings":	"!! ADVANCED USERS !!"
		,	"hEDIT_SkinFontSize":				"!! ADVANCED USERS !!"
			.					 				"`nIncreases or decreases the font size."
		, 	"hEDIT_SkinFontQuality":			"!! ADVANCED USERS !!"
			.									"`nIncreases or decreases the font quality."
			.									"`nIf your font has rendering issues with a value of 5, try lower values."
		, 	"hDDL_ChangeableFontColorTypes":	"!! ADVANCED USERS !!"
		, 	"hBTN_ShowColorPicker":				"!! ADVENCED USERS !!"

		,	"hBTN_CustomBtn_1": "Click on this button to set his behaviour."
			.					   "`nRight click for sizing options."
			.					   "`nDrag to set its position."
		,	"hTEXT_CustomBtnSlot_1": "Empty button slot. Click to add a button here."
		,	"hBTN_UnicodeBtn_1": "Right click to change pre-defined action."
			.					 "`nDrag to set its position."
		,	"hDDL_ActionType":"Actions list. Choose one of the actions that should be performed."			
		,	"hEDIT_ActionContent":"Actions content. Set the message that should be sent with this action."
		,	"hBTN_ReplaceCurrentLine":"Replace the currently selected action in the list."
		,	"hBTN_AddActionAtCurrentLine":"Add the new action at the currently selected line of the list."
		,	"hBTN_AddActionAtEnd":"Add the new action at the end of the list."
		, 	"hBTN_SaveChangesToAction": "Show a menu to select which button to save the changes to."
		,	"hBTN_AddAsNewAction": "Add as a new action to the end of the list."
			.					   "`nIf the last action is ""Close tab"" or a ""Write Message"" action, it will be added before it."
		,	"hLV_ButtonsActions":"List of actions that will be performed upon clicking this button."


		,	"hDDL_HotkeyActionType1":"Actions list. Choose the action that should be performed."
		,	"hEDIT_HotkeyActionContent1":"Action content. Set the message that should be sent with this action."
		,	"hCB_HotkeyToggle1":"Toggle ON/OFF."
		,	"hHK_HotkeyKeys1":"Hotkey's keys."


		,	"hDDL_HotkeyAdvExistingList":"List of already registered hotkeys profiles."
		,	"hBTN_HotkeyAdvAddNewProfile":"Add a new hotkey profile."
		,	"hBTN_HotkeyAdvDeleteCurrentProfile":"Delete the currently selected hotkey profile."
		,	"hEDIt_HotkeyAdvName":"Hotkey profile name."
		,	"hHK_HotkeyAdvHotkey":"Hotkey profile keys."
		,	"hDDL_HotkeyAdvActionType":"Actions list. Choose one of the actions that should be performed."
		,	"hEDIT_HotkeyAdvActionContent":"Action content. Set the message that should be sent with this action."
		, 	"hBTN_HotkeyAdvSaveChangesToAction": "Show a menu to select which button to save the changes to."
		,	"hBTN_HotkeyAdvAddAsNewAction": "Add as a new action to the end of the list."
			.					   "`nIf the last action is ""Close tab"" or a ""Write Message"" action, it will be added before it."
		,	"hLV_HotkeyAdvActionsList":"List of actions that will be performed upon pressing this hotkey."

		
		,	"hDDL_CheckForUpdate": 					"Decides when to check for updates."
			.										"`nAutomatic update checks can only be done once every ~35 mins."
			.										"`nThis is done to avoid spamming the GitHub API."
		, 	"hCB_UseBeta": 							"Receive BETA udpates."
		, 	"hCB_DownloadUpdatesAutomatically": 	"Upgrades to the latest version on start."
		, 	"hBTN_CheckForUpdates":					"Force checking for updates."


		,	"hEDIT_HallOfFame":":)"

		, "":""}
		
		Loop 8 { ; Set same as first one
			_tooltips["hBTN_CustomBtn_" A_Index+1] := _tooltips["hBTN_CustomBtn_1"]
			_tooltips["hTEXT_CustomBtnSlot_" A_Index+1] := _tooltips["hTEXT_CustomBtnSlot_1"]
		}
		Loop 4 ; Set same as first one
			_tooltips["hBTN_UnicodeBtn_" A_Index+1] := _tooltips["hBTN_UnicodeBtn_1"]
		Loop 14 { ; Set same as first one
			_tooltips["hDDL_HotkeyActionType" A_Index+1] := _tooltips["hDDL_HotkeyActionType1"]
			_tooltips["hEDIT_HotkeyActionContent" A_Index+1] := _tooltips["hEDIT_HotkeyActionContent1"]
			_tooltips["hCB_HotkeyToggle" A_Index+1] := _tooltips["hCB_HotkeyToggle1"]
			_tooltips["hHK_HotkeyKeys" A_Index+1] := _tooltips["hHK_HotkeyKeys1"]
		}

		_tip := _tooltips[ctrlN]
		if (DEBUG.SETTINGS.instant_settings_tooltips)
			_tip := _tip? _tip "`n" ctrlN : "No tooltip for this control`n" ctrlN

		if (DEBUG.SETTINGS.settings_copy_ctrlname && ctrlN)
			Set_Clipboard(ctrlN)

		return _tip
	}

}
