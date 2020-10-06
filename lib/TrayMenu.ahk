TrayMenu() {
	global PROGRAM, DEBUG

	trans := PROGRAM.TRANSLATIONS.TrayMenu

	Menu,Tray,DeleteAll
	if ( !A_IsCompiled && FileExist(A_ScriptDir "\resources\icon.ico") )
		Menu, Tray, Icon, %A_ScriptDir%\resources\icon.ico
	Menu,Tray,Tip,POE Trades Companion
	Menu,Tray,NoStandard
	if (DEBUG.settings.open_settings_gui) {
			Menu,Tray,Add,Recreate Settings GUI, Tray_CreateSettings ; Recreate Settings GUI
	}
	Menu,Tray,Add,% trans.Settings, Tray_OpenSettings ; Settings
	Menu,Tray,Add,% trans.Stats, Tray_OpenStats ; My Stats
	; if (PROGRAM.IS_BETA = "True")
		; Menu,Tray,Add,Beta tasks, Tray_OpenBetaTasks 
	Menu,Tray,Add
	Menu,Tray,Add,Disable buy interface?, Tray_ToggleDisableBuyInterface
	Menu,TraySheetSub,Add,Betrayal, Tray_OpenSheet
	Menu,TraySheetSub,Add,Delve, Tray_OpenSheet
	Menu,TraySheetSub,Add,Essence, Tray_OpenSheet
	Menu,TraySheetSub,Add,Incursion, Tray_OpenSheet
	Menu,TraySheetSub,Add,Heist, Tray_OpenSheet
	Menu,Tray,Add,Leagues Sheets, :TraySheetSub
	Menu,Tray,Add
	Menu,Tray,Add,% trans.Clickthrough, Tray_ToggleClickthrough ; Clickthrough?
	Menu,Tray,Add,% trans.LockPosition, Tray_ToggleLockPosition ; Lock position?
	Menu,Tray,Add
	Menu,Tray,Add,% trans.ModeWindow, Tray_ModeWindow ; Mode: Window
	Menu,Tray,Add,% trans.ModeDock, Tray_ModeDock ; Mode: Dock
	Menu,Tray,Add,% trans.CycleDock, Tray_CycleDock ; Cycle Dock
	Menu,Tray,Add,% trans.ResetPosition, Tray_ResetPosition ; Reset Position
	Menu,Tray,Add
	Menu,Tray,Add,% trans.Reload, Tray_Reload ; Reload
	Menu,Tray,Add,% trans.Close, Tray_Exit ; Close
	Menu,Tray,Icon
	Menu,Tray,Default,% trans.Settings ; On Double click

	if (PROGRAM.SETTINGS.SETTINGS_MAIN.DisableBuyInterface = "True")
		Menu, Tray, Check, Disable buy interface?
	else
		Menu, Tray, Uncheck, Disable buy interface?

	; Pos lock check
	if (PROGRAM.SETTINGS.SETTINGS_MAIN.TradesGUI_Locked = "True")
		Menu, Tray, Check,% trans.LockPosition
	else
		Menu, Tray, Uncheck,% trans.LockPosition

	; Clickthrough check
	if (PROGRAM.SETTINGS.SETTINGS_MAIN.AllowClicksToPassThroughWhileInactive = "True") 
		Menu, Tray, Check,% trans.Clickthrough
	else
		Menu, Tray, Uncheck,% trans.Clickthrough

	; TradesGUI Mode check
	if (PROGRAM.SETTINGS.SETTINGS_MAIN.TradesGUI_Mode = "Window") 
		GUI_Trades.Use_WindowMode(True)
	else if (PROGRAM.SETTINGS.SETTINGS_MAIN.TradesGUI_Mode = "Dock")
		GUI_Trades.Use_DockMode(True)

	; Icons
	Menu, Tray, Icon,% trans.Settings,% PROGRAM.ICONS_FOLDER "\gear.ico"
	; Menu, Tray, Icon,,% PROGRAM.ICONS_FOLDER "\qmark.ico"
	Menu, Tray, Icon,% trans.Stats,% PROGRAM.ICONS_FOLDER "\chart.ico"
	Menu, Tray, Icon,% trans.Reload,% PROGRAM.ICONS_FOLDER "\refresh.ico"
	Menu, Tray, Icon,% trans.Close,% PROGRAM.ICONS_FOLDER "\x.ico"
}

Tray_ToggleDisableBuyInterface() {
	global PROGRAM
	iniFile := PROGRAM.INI_FILE

	isTrue := PROGRAM.SETTINGS.SETTINGS_MAIN.DisableBuyInterface="True"?True:False
	newToggle := isTrue?"False":"True"
	Menu, Tray,% newToggle="True"?"Check":"Uncheck", Disable buy interface?

	INI.Set(iniFile, "SETTINGS_MAIN", "DisableBuyInterface", newToggle)
	PROGRAM.SETTINGS.SETTINGS_MAIN.DisableBuyInterface := newToggle

	if (newToggle="True")
		GUI_TradesBuyCompact.Destroy()
	else
		GUI_TradesBuyCompact.RecreateGUI()
}
Tray_OpenSheet() {
	which := A_ThisMenuItem="Betrayal"?"Betrayal"
		: A_ThisMenuItem="Delve"?"Delve"
		: A_ThisMenuItem="Essence"?"Essence"
		: A_ThisMenuItem="Incursion"?"Incursion"
		: A_ThisMenuItem="Heist"?"Heist"
		: ""
	if (!which)
		return

	GUI_CheatSheet.Show(which)
}

Tray_OpenBetaTasks() {
	GUI_BetaTasks.Show()
}
Tray_GitHub() {
	global PROGRAM
	Run, % PROGRAM.LINK_GITHUB
}
Tray_Reload() {
	Reload()
}
Tray_Exit() {
	ExitApp
}
Tray_CreateSettings() {
	GUI_Settings.Create()
	GUI_Settings.Show()
}
Tray_OpenSettings() {
	global CANCEL_TRAY_MENU
	CANCEL_TRAY_MENU := True
	GUI_Settings.Show()
}
Tray_OpenStats() {
	GUI_MyStats.Show()
}
Tray_ModeWindow() {
	global PROGRAM

	GUI_Trades.Use_WindowMode()
	Tray_ToggleLockPosition("Uncheck")
	Declare_LocalSettings()
	TrayNotifications.Show(PROGRAM.TRANSLATIONS.TrayNotifications.ModeWindowEnabled_Title, PROGRAM.TRANSLATIONS.TrayNotifications.ModeWindowEnabled_Msg)
}
Tray_ModeDock() {
	global PROGRAM

	GUI_Trades.Use_DockMode()
	Tray_ToggleLockPosition("Check")
	Declare_LocalSettings()
	trayMsg := StrReplace(PROGRAM.TRANSLATIONS.TrayNotifications.ModeDockEnabled_Msg, "%cycleDock%", PROGRAM.TRANSLATIONS.TrayMenu.CycleDock)
	TrayNotifications.Show(PROGRAM.TRANSLATIONS.TrayNotifications.ModeDockEnabled_Title, trayMsg)
}
Tray_CycleDock() {
	GUI_Trades.DockMode_Cycle()
}
Tray_ToggleClickthrough() {
	global PROGRAM, GuiSettings_Controls

	GUI_Settings.TabSettingsMain_ToggleClickthroughCheckbox()
	toggle := PROGRAM.SETTINGS.SETTINGS_MAIN.AllowClicksToPassThroughWhileInactive
	Menu, Tray,% toggle="True"?"Check":"Uncheck",% PROGRAM.TRANSLATIONS.TrayMenu.Clickthrough
}
Tray_ToggleLockPosition(toggle="") {
	global PROGRAM
	iniFile := PROGRAM.INI_FILE

	if ( (toggle = "") || (toggle = A_ThisMenuItem) ) && (PROGRAM.SETTINGS.SETTINGS_MAIN.TradesGUI_Locked = "True")
	|| (toggle = "Uncheck") {
		INI.Set(iniFile, "SETTINGS_MAIN", "TradesGUI_Locked", "False")
		PROGRAM.SETTINGS.SETTINGS_MAIN.TradesGUI_Locked := "False"
		Menu, Tray, Uncheck,% PROGRAM.TRANSLATIONS.TrayMenu.LockPosition
	}
	else if ( (toggle = "") || (toggle = A_ThisMenuItem) ) && (PROGRAM.SETTINGS.SETTINGS_MAIN.TradesGUI_Locked = "False")
	|| (toggle = "Check") {
		INI.Set(iniFile, "SETTINGS_MAIN", "TradesGUI_Locked", "True")
		PROGRAM.SETTINGS.SETTINGS_MAIN.TradesGUI_Locked := "True"
		Menu, Tray, Check,% PROGRAM.TRANSLATIONS.TrayMenu.LockPosition
	}
}
Tray_ResetPosition() {
	Tray_ModeWindow()
}