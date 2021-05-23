WM_NCCALCSIZE() {
	; Credits: Lexikos - autohotkey.com/board/topic/23969-resizable-window-border/?p=155480
	; Sizes the client area to fill the entire window.

    if A_Gui
        return 0
}

WM_NCACTIVATE() {
	; Credits: Lexikos - autohotkey.com/board/topic/23969-resizable-window-border/?p=155480
	; Prevents a border from being drawn when the window is activated.

    if A_Gui
        return 1
}

WM_NCHITTEST(wParam, lParam) {
	; Credits: Lexikos - autohotkey.com/board/topic/23969-resizable-window-border/?p=155480
	; Redefine where the sizing borders are.  This is necessary since
	; returning 0 for WM_NCCALCSIZE effectively gives borders zero size.

    static border_size = 6


    if !A_Gui
        return

    WinGetPos, gX, gY, gW, gH

    x := lParam<<48>>48, y := lParam<<32>>48

    hit_left    := x <  gX+border_size
    hit_right   := x >= gX+gW-border_size
    hit_top     := y <  gY+border_size
    hit_bottom  := y >= gY+gH-border_size

    if hit_top
    {
        if hit_left
            return 0xD
        else if hit_right
            return 0xE
        else
            return 0xC
    }
    else if hit_bottom
    {
        if hit_left
            return 0x10
        else if hit_right
            return 0x11
        else
            return 0xF
    }
    else if hit_left
        return 0xA
    else if hit_right
        return 0xB

    ; else let default hit-testing be done
}

WM_LBUTTONDOWN() {
	/*	Settings: Allow mouse drag for custom buttons
	*/
	global MOUSEDRAG_CTRL, MOUSEDRAG_ENABLED
	global GuiTrades, GuiTrades_Controls
	global GuiSettings_Controls, GuiSettings
	global GuiTradesBuyCompact, GuiTradesBuyCompact_Controls
	global GUITRADES_TOOLTIP
	global GUITRADESBUYCOMPACT_CLICKED_SEARCH

	; = = TRADES GUI = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = =
	if (A_Gui = "Trades") {
		underMouseCtrl := Get_UnderMouse_CtrlHwnd()
		if (underMouseCtrl = GuiTrades_Controls["hTEXT_TradeInfos" GuiTrades.Active_Tab]) {
			tabContent := Gui_Trades.GetTabContent(GuiTrades.Active_Tab)
			if (tabContent.OtherFull) {
				GUITRADES_TOOLTIP := True
				ShowToolTip( StrReplace(tabContent.OtherFull,"\n","`n") , , , 20, 20)
			}
		}
		else if (underMouseCtrl = GuiTrades_Controls["hIMG_TradeVerify" GuiTrades.Active_Tab]) {
			tabContent := GUI_Trades.GetTabContent(GuiTrades.Active_Tab)
			GUI_Trades.VerifyItemPrice(tabContent)
		}
	}

	; = = SETTINGS GUI = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = =
	else if (A_Gui = "Settings") {
		mouseCtrlHwnd := Get_UnderMouse_CtrlHwnd()

		; If it's a CustomButton, allow dragging
		if IsIn(mouseCtrlHwnd, GuiSettings["CustomButtons_HandlesList"])
		|| IsIn(mouseCtrlHwnd, GuiSettings["UnicodeButtons_HandlesList"]) {
			; Get the ctrl coords
			ctrlCoords := Get_ControlCoords(A_Gui, mouseCtrlHwnd)
			MOUSEDRAG_CTRL := {Handle:mouseCtrlHwnd}
			; Add coords to obj and enable mousedrag
			for key, element in ctrlCoords {
				MOUSEDRAG_CTRL[key] := element
			}
			MOUSEDRAG_ENABLED := True
		}
	}

	else if (A_Gui = "TradesBuyCompactSearch") {
		mouseCtrlHwnd := Get_UnderMouse_CtrlHwnd()
		if (mouseCtrlHwnd = GuiTradesBuyCompact_Controls.hTEXT_SearchBarFake) {
			GUITRADESBUYCOMPACT_CLICKED_SEARCH := True
		}
	}
}

ShowListLines:
ListLines
return

WM_LBUTTONUP() {
	global GuiTradesBuyCompact_Controls
	global MOUSEDRAG_CTRL, MOUSEDRAG_ENABLED, GUITRADES_TOOLTIP, GUITRADESBUYCOMPACT_CLICKED_SEARCH

	if (A_Gui = "Trades") {
		if (GUITRADES_TOOLTIP) {
			RemoveToolTip()
			GUITRADES_TOOLTIP := False
			GUI_Trades.UnSetTabStyleWhisperReceived(GUI_Trades.GetActiveTab())
		}
		; GUI_Trades.RemoveButtonFocus() ; Don't do this. It will prevent buttons from working.
	}

	; If mousedrag is enabled, disable
	if ( MOUSEDRAG_ENABLED ) {
		GUI_Settings.TabCustomizationButtons_CustomButton_UpdateSlots()
		MOUSEDRAG_ENABLED := False
		MOUSEDRAG_CTRL := ""
	}

	if (A_Gui = "TradesBuyCompactSearch") {
		mouseCtrlHwnd := Get_UnderMouse_CtrlHwnd()
		if (GUITRADESBUYCOMPACT_CLICKED_SEARCH && mouseCtrlHwnd = GuiTradesBuyCompact_Controls.hTEXT_SearchBarFake) {
			hw := A_DetectHiddenWindows
			DetectHiddenWindows, On
			WinActivate,% "ahk_id " GuiTradesBuyCompact_Controls.GuiTradesBuyCompactSearchHiddenHandle
			DetectHiddenWindows, %hw%
		}
	}
	GUITRADESBUYCOMPACT_CLICKED_SEARCH := False
}

WM_MOUSEMOVE() {
	/* Settings: Allow dragging custom buttons
	*/
	global PROGRAM, DEBUG
	global GuiTrades, GuiTrades_Controls
	global GuiSettings, GuiSettings_Controls
	global GuiTradesBuyCompact, GuiTradesBuyCompact_Controls
	global MOUSEDRAG_CTRL
	static _mouseX, _mouseY, _prevMouseX, _prevMouseY, _prevInfos
	static curControl, prevControl
	static ctrlToolTip, underMouseCtrl

	resDPI := Get_DpiFactor()

	MouseGetPos, _mouseX, _mouseY
	if (_mouseX = _prevMouseX) && (_mouseY = _prevMouseY)
		Return

	if (A_Gui = "Trades") {
		underMouseCtrl := Get_UnderMouse_CtrlHwnd(), activeTab := GuiTrades.Active_Tab
		tabInfos := GUI_Trades.GetTabContent(activeTab)

		ctrlToolTip := (underMouseCtrl = GuiTrades_Controls.hBTN_CloseTab) ? "Close this trade window"
			: (underMouseCtrl = GuiTrades_Controls.hBTN_Minimize) ? "Minimize this interface"
			: (underMouseCtrl = GuiTrades_Controls.hBTN_Maximize) ? "Maximize this interface"
		; 	: (underMouseCtrl = GuiTrades_Controls.hBTN_Hideout) ? "Go to your hideout"
		; 	: (underMouseCtrl = GuiTrades_Controls.hBTN_LeagueHelp) ? "See league informative sheets"
			: (underMouseCtrl = GuiTrades_Controls.hBTN_LeftArrow) ? "Scroll to the left"
			: (underMouseCtrl = GuiTrades_Controls.hBTN_RightArrow) ? "Scroll to the right"
			; : (underMouseCtrl = GuiTrades_Controls["hTEXT_TradeInfos" activeTab]) && (tabInfos.Other != tabInfos.OtherFull) ? StrReplace(tabInfos.OtherFull, "\n", "`n")
			: (underMouseCtrl = GuiTrades_Controls["hIMG_TradeVerify" activeTab]) ? StrReplace( tabInfos.TradeVerifyInfos, "\n", "`n")
			: ""

		If (underMouseCtrl != prevControl) {
			if (ctrlToolTip) {
				timer := (DEBUG.SETTINGS.instant_settings_tooltips)?(-10)
					; : IsIn(underMouseCtrl, GuiTrades_Controls["hTEXT_TradeInfos" activeTab]) ? -10
					: (-1000)
				SetTimer, WM_MOUSEMOVE_DisplayToolTip,% timer
			}

			prevControl := underMouseCtrl
		}

	}

	/* Moved to LBUTTONDOWN instead
	if (A_Gui = "Trades") {
		underMouseCtrl := Get_UnderMouse_CtrlHwnd()
		if (underMouseCtrl = GuiTrades_Controls["hTEXT_TradeInfos" GuiTrades.Active_Tab]) {
			tabContent := Gui_Trades.GetTabContent(GuiTrades.Active_Tab)
			if (tabContent.Visible.Other) {
				if WinActive("ahk_id " GuiTrades.Handle) {
					infosTextPos := Get_ControlCoords("Trades", GuiTrades_Controls["hTEXT_TradeInfos" GuiTrades.Active_Tab])
					ShowToolTip(tabContent.Visible.Other, infosTextPos.X, infosTextPos.Y+infosTextPos.H, 5, 5, {Mouse:"Client", ToolTip:"Client"})
				}
				else {

				}
			}
		}
		; else tooltip % underMouseCtrl "`n" GuiTrades_Controls["hTEXT_TradeInfos_" GuiTrades.Active_Tab]
	}
	*/

	; = = SETTINGS GUI = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = =
	if (A_Gui = "Settings") {
		if (MOUSEDRAG_CTRL) {
			Set_Format("Float", "0")
			MouseGetPos, mouseX, mouseY
			mouseX := mouseX - ((mouseX * resDPI) - mouseX)
			mouseY := mouseY - ((mouseY * resDPI) - mouseY)

			distance := 0, smallestDistance := 9999

			if IsIn(MOUSEDRAG_CTRL.Handle, GuiSettings["CustomButtons_HandlesList"]) {

				finalPos := {}, centerPos := {X: mouseX-(MOUSEDRAG_CTRL.W/2), Y:mouseY-(MOUSEDRAG_CTRL.H/2)}
				isBetweenX := IsBetween(centerPos.X, GuiSettings.CUSTOM_BTN_MIN_X, GuiSettings.CUSTOM_BTN_MAX_X), isBiggerX := (centerPos.X > GuiSettings.CUSTOM_BTN_MIN_X)?(True):(False)
				isBetweenY := IsBetween(centerPos.Y, GuiSettings.CUSTOM_BTN_MIN_Y, GuiSettings.CUSTOM_BTN_MAX_Y), isBiggerY := (centerPos.Y > GuiSettings.CUSTOM_BTN_MIN_Y)?(True):(False)
				ctrlCoords := Get_ControlCoords(A_Gui, MOUSEDRAG_CTRL.Handle)

				currentButtonInfos := GUI_Settings.TabCustomizationButtons_CustomButton_GetSlotInfos(MOUSEDRAG_CTRL.Handle)

				Loop % GuiSettings.CustomButtons_SlotPositions.MaxIndex() {
					isSlotTaken := GuiSettings.CustomButtons_IsSlotTaken[A_Index]
					slotX := GuiSettings["CustomButtons_SlotPositions"][A_Index]["X"]
					slotY := GuiSettings["CustomButtons_SlotPositions"][A_Index]["Y"]
					slotCenterX := slotX + (ctrlCoords.W/2)
					slotCenterY := slotY + (ctrlCoords.H/2)

					xDistance := Sqrt( (slotCenterX-mouseX)**2 )
					yDistance := Sqrt( (slotCenterY-mouseY)**2 )
					distance := Sqrt((slotCenterX-mouseX)**2 + (slotCenterY-mouseY)**2)
					; distance := Sqrt((mouseX-allowedX)**2 - (mouseY-allowedY)**2)
					if (distance < smallestDistance) && (distance < 50) && (yDistance < 10) {
						if (!isSlotTaken) || IsIn(A_Index, currentButtonInfos.Slots) {
							; tooltip % A_Index "`n" currentButtonInfos.Slots
							newSlotID := A_Index
							finalPos.X := slotX, finalPos.Y := slotY
							smallestDistance := distance, smallestID := A_Index
						}
					}

					distance%A_Index% := Sqrt((slotX-mouseX)**2 + (slotY-mouseY)**2)
				}
				Loop {
					if (distance%A_Index% != "")
						distanceStr .= distance%A_Index% "`n"
					else Break
				}

				if (finalPos.X != "" && finalPos.Y != "") {
					isSlotAvailable := GUI_Settings.TabCustomizationButtons_CustomButton_IsSlotAvailable(newSlotID, MOUSEDRAG_CTRL.Handle)
					; if (isSlotAvailable) || IsIn(newSlotID, currentButtonInfos.Slots) {
					if (isSlotAvailable) {
						GuiControl, Settings:Move,% MOUSEDRAG_CTRL.Handle,% "x" finalPos.X " y" finalPos.Y
						currentButtonInfos := GUI_Settings.TabCustomizationButtons_CustomButton_GetSlotInfos(MOUSEDRAG_CTRL.Handle)

						buttonSlots := currentButtonInfos.Slots
						prevButtonSlots := _prevInfos.Slots

						Loop, Parse, buttonSlots,% ","
						{
							if (A_Index = 1)
								INI.Set(PROGRAM.INI_FILE, "SETTINGS_CUSTOM_BUTTON_" currentButtonInfos.Num, "Slot", A_LoopField)
							GuiSettings.CustomButtons_IsSlotTaken[A_LoopField] := True
						}
						Loop, Parse, prevButtonSlots,% ","
							GuiSettings.CustomButtons_IsSlotTaken[A_LoopField] := False


					}
				}

				Gui_Settings.TabCustomizationButtons_CustomButton_UpdateSlots()
			}

			if IsIn(MOUSEDRAG_CTRL.Handle, GuiSettings["UnicodeButtons_HandlesList"]) {
				finalPos := {}, centerPos := {X: mouseX-(MOUSEDRAG_CTRL.W/2), Y:mouseY-(MOUSEDRAG_CTRL.H/2)}
				isBetweenX := IsBetween(centerPos.X, GuiSettings.UNICODE_BTN_MIN_X, GuiSettings.UNICODE_BTN_MAX_X), isBiggerX := (centerPos.X > GuiSettings.UNICODE_BTN_MIN_X)?(True):(False)
				isBetweenY := IsBetween(centerPos.Y, GuiSettings.UNICODE_BTN_MIN_Y, GuiSettings.UNICODE_BTN_MAX_Y), isBiggerY := (centerPos.Y > GuiSettings.UNICODE_BTN_MIN_Y)?(True):(False)
				ctrlCoords := Get_ControlCoords(A_Gui, MOUSEDRAG_CTRL.Handle)

				currentButtonInfos := GUI_Settings.TabCustomizationButtons_UnicodeButton_GetSlotInfos(MOUSEDRAG_CTRL.Handle)

				Loop % GuiSettings.UnicodeButtons_SlotPositions.MaxIndex() {
					isSlotTaken := GuiSettings.UnicodeButtons_IsSlotTaken[A_Index]
					slotX := GuiSettings["UnicodeButtons_SlotPositions"][A_Index]["X"]
					slotY := GuiSettings["UnicodeButtons_SlotPositions"][A_Index]["Y"]
					slotCenterX := slotX + (ctrlCoords.W/2)
					slotCenterY := slotY + (ctrlCoords.H/2)

					xDistance := Sqrt( (slotCenterX-mouseX)**2 )
					yDistance := Sqrt( (slotCenterY-mouseY)**2 )
					distance := Sqrt((slotCenterX-mouseX)**2 + (slotCenterY-mouseY)**2)


					; distance := Sqrt((mouseX-allowedX)**2 - (mouseY-allowedY)**2)
					if (distance < smallestDistance) && (distance < 30) && (yDistance < 30) {
						if (!isSlotTaken) || IsIn(A_Index, currentButtonInfos.Slots) {
							; tooltip % A_Index "`n" currentButtonInfos.Slots
							newSlotID := A_Index
							finalPos.X := slotX, finalPos.Y := slotY
							smallestDistance := distance, smallestID := A_Index
						}
					}

					distance%A_Index% := Sqrt((slotX-mouseX)**2 + (slotY-mouseY)**2)
				}
				Loop {
					if (distance%A_Index% != "")
						distanceStr .= distance%A_Index% "`n"
					else Break
				}

				if (finalPos.X != "" && finalPos.Y != "") {
					isSlotAvailable := GUI_Settings.TabCustomizationButtons_UnicodeButton_IsSlotAvailable(newSlotID, MOUSEDRAG_CTRL.Handle)
					if (isSlotAvailable) {
						GuiControl, Settings:Move,% MOUSEDRAG_CTRL.Handle,% "x" finalPos.X " y" finalPos.Y
						currentButtonInfos := GUI_Settings.TabCustomizationButtons_UnicodeButton_GetSlotInfos(MOUSEDRAG_CTRL.Handle)

						buttonSlot := currentButtonInfos.Slot
						prevButtonSlot := _prevInfos.Slot

						INI.Set(PROGRAM.INI_FILE, "SETTINGS_SPECIAL_BUTTON_" currentButtonInfos.Num, "Slot", buttonSlot)

						GuiSettings.UnicodeButtons_IsSlotTaken[buttonSlot] := True
						GuiSettings.UnicodeButtons_IsSlotTaken[prevButtonSlot] := False
					}
				}

				Gui_Settings.TabCustomizationButtons_UnicodeButton_UpdateSlots()
			}

			Set_Format("Float")
		}

		timer := (DEBUG.SETTINGS.instant_settings_tooltips)?(-10):(-1000)
		curControl := "", curControlHwnd := Get_UnderMouse_CtrlHwnd()
		for key, value in GuiSettings_Controls {
			if (curControlHwnd = GuiSettings_Controls[key]) {
				curControl := key
				Break
			}
		}
		If ( curControl != prevControl ) {
			controlTip := GUI_Settings.GetControlToolTip(curControl)
			if ( controlTip )
				SetTimer, WM_MOUSEMOVE_GuiSettings_DisplayToolTip,% timer
			Else
				Gosub, WM_MOUSEMOVE_RemoveToolTip
			prevControl := curControl
		}
		return
}

	else if IsIn(A_Gui, "TradesBuyCompact,TradesBuyCompactSearch") ||IsContaining(A_Gui, "TradesBuyCompact_Slot") {
		slotNum := RegExReplace(A_Gui, "\D")
		if (slotNum)
			slotInfos := GUI_TradesBuyCompact.GetSlotContent(slotNum)
		underMouseCtrl := Get_UnderMouse_CtrlHwnd()

		ctrlToolTip := (underMouseCtrl = GuiTradesBuyCompact["Slot" slotNum "_Controls"].hIMG_CurrencyIMG) ? GUI_TradesBuyCompact.GetSlotContent(slotNum).Currency
			: (underMouseCtrl = GuiTradesBuyCompact["Slot" slotNum "_Controls"].hTEXT_ItemName) && (slotInfos.ItemIsCut) ? slotInfos.Item
			: (underMouseCtrl = GuiTradesBuyCompact["Slot" slotNum "_Controls"].hTEXT_SellerName) && (slotInfos.SellerIsCut) ? slotInfos.Seller
			: (underMouseCtrl = GuiTradesBuyCompact["Slot" slotNum "_Controls"].hTEXT_AdditionalMsg) && (slotInfos.AdditionalMsg != slotInfos.AdditionalMsgFull) ? StrReplace(slotInfos.AdditionalMsgFull, "\n", "`n")
			: (underMouseCtrl = GuiTradesBuyCompact["Slot" slotNum "_Controls"].hBTN_Close) ? "Close this trade window"
			: (underMouseCtrl = GuiTradesBuyCompact["Slot" slotNum "_Controls"].hBTN_WhoisSeller) ? "Whois seller"
			: (underMouseCtrl = GuiTradesBuyCompact["Slot" slotNum "_Controls"].hBTN_WhisperSeller) ? "Whisper this seller"
			: (underMouseCtrl = GuiTradesBuyCompact["Slot" slotNum "_Controls"].hBTN_HideoutSeller) ? "Go to seller's hideout"
			: (underMouseCtrl = GuiTradesBuyCompact["Slot" slotNum "_Controls"].hBTN_KickSelfSeller) ? "Kick yourself from party"
			: (underMouseCtrl = GuiTradesBuyCompact["Slot" slotNum "_Controls"].hBTN_ThankSeller) ? "Thank the seller"
			: (underMouseCtrl = GuiTradesBuyCompact_Controls.hBTN_Minimize) ? "Minimize this interface"
			: (underMouseCtrl = GuiTradesBuyCompact_Controls.hBTN_Maximize) ? "Maximize this interface"
			: (underMouseCtrl = GuiTradesBuyCompact_Controls.hBTN_Hideout) ? "Go to your hideout"
			: (underMouseCtrl = GuiTradesBuyCompact_Controls.hBTN_LeagueHelp) ? "See league informative sheets"
			: (underMouseCtrl = GuiTradesBuyCompact_Controls.hEDIT_HiddenSearchBar || underMouseCtrl = GuiTradesBuyCompact_Controls.hTEXT_SearchBarFake) ? "Search by seller or item"
			: (underMouseCtrl = GuiTradesBuyCompact_Controls.hIMG_SearchBarCross) ? "Clear the searchbox"
			: (underMouseCtrl = GuiTradesBuyCompact_Controls.hBTN_LeftArrow) ? "Scroll upwards"
			: (underMouseCtrl = GuiTradesBuyCompact_Controls.hBTN_RightArrow) ? "Scroll downwards"
			: ""

		If (underMouseCtrl != prevControl) {
			if (ctrlToolTip) {
				timer := (DEBUG.SETTINGS.instant_settings_tooltips)?(-10)
					: IsIn(underMouseCtrl, GuiTradesBuyCompact["Slot" slotNum "_Controls"].hTEXT_SellerName "," GuiTradesBuyCompact["Slot" slotNum "_Controls"].hTEXT_AdditionalMsg "," GuiTradesBuyCompact["Slot" slotNum "_Controls"].hTEXT_ItemName "," GuiTradesBuyCompact["Slot" slotNum "_Controls"].hIMG_CurrencyIMG) ? -10
					: (-1000)
				SetTimer, WM_MOUSEMOVE_DisplayToolTip,% timer
			}

			prevControl := underMouseCtrl
		}
	}

	_prevInfos := currentButtonInfos
	_prevMouseX := _mouseX, _prevMouseY := _mouseY
	return

	WM_MOUSEMOVE_DisplayToolTip:
		if (Get_UnderMouse_CtrlHwnd() != underMouseCtrl)
			return

		try ShowToolTip(ctrlToolTip)
		SetTimer, WM_MOUSEMOVE_RemoveToolTip, -5000
	return

	WM_MOUSEMOVE_GuiSettings_DisplayToolTip:
		if (Get_UnderMouse_CtrlHwnd() != underMouseCtrl)
			return

		controlTip := GUI_Settings.GetControlToolTip(curControl)
		if ( controlTip ) {
			try
				ShowToolTip(controlTip)
			SetTimer, WM_MOUSEMOVE_RemoveToolTip, -20000
		}
		else {
			RemoveToolTip()
		}
	return

	WM_MOUSEMOVE_RemoveToolTip:
		RemoveToolTip()
	return
}

WM_MOUSEWHEEL(wParam, lParam) {
	WheelDelta := 120 << 16
	isWheelUp := WheelDelta=wParam?True:False

	if (A_Gui="TradesBuyCompact") {
		if (isWheelUp)
			GUI_TradesBuyCompact.ScrollUp()
		else
			GUI_TradesBuyCompact.ScrollDown()
	}
}

AHK_NOTIFYICON(wParam, lParam) {
	global CANCEL_TRAY_MENU
    if (lParam = 0x202) { ; WM_LBUTTONUP
		dblClkTime := DllCall("user32.dll\GetDoubleClickTime")
		dblClkTime := IsNum(dblClkTime)?dblClkTime:500
        SetTimer, AHK_NOTIFYICON_ShowTrayMenu,% "-" dblClkTime+20
        return 0
    }
	return

	AHK_NOTIFYICON_ShowTrayMenu:
	 	if (CANCEL_TRAY_MENU = True)
		 	CANCEL_TRAY_MENU := False
		else
			Menu, Tray, Show
	return
}
