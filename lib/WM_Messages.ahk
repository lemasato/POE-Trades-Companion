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
	global GUITRADES_TOOLTIP

	; = = TRADES GUI = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = =
	if (A_Gui = "Trades") {
		underMouseCtrl := Get_UnderMouse_CtrlHwnd()
		if (underMouseCtrl = GuiTrades_Controls["hTEXT_TradeInfos" GuiTrades.Active_Tab]) {
			tabContent := Gui_Trades.GetTabContent(GuiTrades.Active_Tab)
			if (tabContent.Other) {
				infosTextPos := Get_ControlCoords("Trades", GuiTrades_Controls["hTEXT_TradeInfos" GuiTrades.Active_Tab])
				GUITRADES_TOOLTIP := True
				ShowToolTip(tabContent.Other, infosTextPos.X, infosTextPos.Y+infosTextPos.H, 20, 20, {Mouse:"Client", ToolTip:"Client"})
			}
		}
		else if (underMouseCtrl = GuiTrades_Controls["hIMG_TradeVerify" GuiTrades.Active_Tab]) {
			tabContent := GUI_Trades.GetTabContent(GuiTrades.Active_Tab)
			GUI_Trades.VerifyItemPrice(tabContent)
		}
	}

	; = = SETTINGS GUI = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = =
	if (A_Gui = "Settings") {
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
}

WM_LBUTTONUP() {
	global MOUSEDRAG_CTRL, MOUSEDRAG_ENABLED, GUITRADES_TOOLTIP

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
}

WM_MOUSEMOVE() {
	/* Settings: Allow dragging custom buttons
	*/
	global PROGRAM, DEBUG
	global GuiTrades, GuiTrades_Controls
	global GuiSettings, GuiSettings_Controls
	global MOUSEDRAG_CTRL
	static _mouseX, _mouseY, _prevMouseX, _prevMouseY, _prevInfos
	static curControl, prevControl

	resDPI := Get_DpiFactor()

	MouseGetPos, _mouseX, _mouseY
	if (_mouseX = _prevMouseX) && (_mouseY = _prevMouseY)
		Return

	if (A_Gui = "Trades") {
		underMouseCtrl := Get_UnderMouse_CtrlHwnd()
		; tooltip % GuiTrades_Controls["hIMG_TradeVerify" GuiTrades.Active_Tab]
		if (underMouseCtrl = GuiTrades_Controls["hIMG_TradeVerify" GuiTrades.Active_Tab]) {
			infos := StrReplace( Gui_Trades.GetTabContent(GuiTrades.Active_Tab).TradeVerifyInfos, "\n", "`n")
			ShowToolTip(infos, , , 5, 5)
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

		timer := (DEBUG.SETTINGS.instant_settings_tooltips)?(-100):(-1000)
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
				SetTimer, WM_MOUSEMOVE_DisplayToolTip,% timer
			Else
				Gosub, WM_MOUSEMOVE_RemoveToolTip
			prevControl := curControl
		}
		return
		
		WM_MOUSEMOVE_DisplayToolTip:
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

	; tooltip % GuiSettings.CustomButtons_IsSlotTaken[7] "`n" GuiSettings.CustomButtons_IsSlotTaken[8] "`n" GuiSettings.CustomButtons_IsSlotTaken[9] 

	_prevInfos := currentButtonInfos
	_prevMouseX := _mouseX, _prevMouseY := _mouseY
}