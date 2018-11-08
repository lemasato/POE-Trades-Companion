ShellMessage_Enable() {
	ShellMessage_State(True)
}

ShellMessage_Disable() {
	ShellMessage_State(False)
}

ShellMessage_State(state) {
	Gui, ShellMsg:Destroy
	Gui, ShellMsg:New, +LastFound 

	Hwnd := WinExist()
	DllCall( "RegisterShellHookWindow", UInt,Hwnd )
	MsgNum := DllCall( "RegisterWindowMessage", Str,"SHELLHOOK" )
	OnMessage( MsgNum, "ShellMessage", state)
}

ShellMessage(wParam,lParam) {
/*			Triggered upon activating a window
 *			Is used to correctly position the Trades GUI while in Overlay mode
*/
	global PROGRAM, GuiTrades, GuiSettings, POEGameList

	if ( wParam=4 || wParam=32772 ||wParam=5 ) { ; 4=HSHELL_WINDOWACTIVATED | 32772=HSHELL_RUDEAPPACTIVATED | 5=HSHELL_GETMINRECT
		if WinActive("ahk_id" GuiTrades.Handle) {
;		Prevent these keyboard presses from interacting with the Trades GUI
			Hotkey, IfWinActive,% "ahk_id " GuiTrades.Handle
			Hotkey, NumpadEnter, DoNothing, On
			Hotkey, Escape, DoNothing, On
			Hotkey, Space, DoNothing, On
			Hotkey, Tab, DoNothing, On
			Hotkey, Enter, DoNothing, On
			Hotkey, Left, DoNothing, On
			Hotkey, Right, DoNothing, On
			Hotkey, Up, DoNothing, On
			Hotkey, Down, DoNothing, On
			Hotkey, IfWinActive
			Return ; returning prevents from triggering Gui_Trades_Set_Position while the GUI is active
		}

		if (GuiTrades.Is_Created) {
			if (PROGRAM.SETTINGS.SETTINGS_MAIN.HideInterfaceWhenOutOfGame = "True") {
				if (lParam) {
					WinGet, activeWinExe, ProcessName, ahk_id %lParam%
					WinGet, activeWinHwnd, ID, ahk_id %lParam%
				}
				else {
					WinGet, activeWinExe, ProcessName, A
					WinGet, activeWinHwnd, ID, A	
				}

				if (activeWinExe && IsIn(activeWinExe, POEGameList)) || (activeWinHwnd && GuiSettings.Handle && activeWinHwnd = GuiSettings.Handle) {
					Gui_Trades.SetTransparency_Automatic()
					if (GuiTrades.Is_Minimized)
						Gui, TradesMinimized:Show, NoActivate
					else Gui, Trades:Show, NoActivate
				}
				else {
					if (GuiTrades.Is_Minimized)
						Gui, TradesMinimized:Hide
					else Gui, Trades:Hide
				}
			}
			else {
				if (GuiTrades.Is_Minimized)
					Gui, TradesMinimized:Show, NoActivate
				else Gui, Trades:Show, NoActivate
			}

			if ( PROGRAM.SETTINGS.SETTINGS_MAIN.TradesGUI_Mode = "Dock")
				GUI_Trades.DockMode_SetPosition()

			WinGet, activePID, PID, ahk_id %lParam%
			if (activePID = GuiTrades.ItemGrid_PID) && ( GUI_ItemGrid.Exists())
				GUI_Trades.ShowActiveTabItemGrid() ; Recreate. In case window moved.
				; GUI_ItemGrid.Show() ; Just show at same pos.
			else if ( GUI_ItemGrid.Exists() ) {
				GUI_ItemGrid.Hide()
			}

			Gui, Trades:+LastFound
			WinSet, AlwaysOnTop, On
			Gui, TradesMinimized:+LastFound
			WinSet, AlwaysOnTop, On
		}

		WinGet, winPName, ProcessName, ahk_id %lParam%
		if IsIn(winPName, POEGameList)
			WinGet, LASTACTIVATED_GAMEPID, PID, ahk_id %lParam%
	}
}
