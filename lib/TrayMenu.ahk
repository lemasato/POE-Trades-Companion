TrayMenu() {
	global PROGRAM, DEBUG

	Menu,Tray,DeleteAll
	if ( !A_IsCompiled && FileExist(A_ScriptDir "\resources\icon.ico") )
		Menu, Tray, Icon, %A_ScriptDir%\resources\icon.ico
	Menu,Tray,Tip,POE Trades Companion
	Menu,Tray,NoStandard
	if (DEBUG.settings.open_settings_gui) {
			Menu,Tray,Add,Recreate Settings GUI, Tray_CreateSettings
	}
	Menu,Tray,Add,Settings, Tray_OpenSettings
	Menu,Tray,Add,My Stats, Tray_OpenStats
	if (PROGRAM.IS_BETA = "True")
		Menu,Tray,Add,Beta tasks, Tray_OpenBetaTasks
	Menu,Tray,Add
	Menu,Tray,Add,Clickthrough?, Tray_ToggleClickthrough
	Menu,Tray,Add,Lock position?, Tray_ToggleLockPosition
	Menu,Tray,Add
	Menu,Tray,Add,Mode: Window, Tray_ModeWindow
	Menu,Tray,Add,Mode: Dock, Tray_ModeDock
	Menu,Tray,Add,Cycle Dock, Tray_CycleDock
	Menu,Tray,Add,Reset Position, Tray_ResetPosition
	Menu,Tray,Add
	Menu,Tray,Add,Reload, Tray_Reload
	Menu,Tray,Add,Close, Tray_Exit
	Menu,Tray,Icon

	; Pos lock check
	if (PROGRAM.SETTINGS.SETTINGS_MAIN.TradesGUI_Locked = "True")
		Menu, Tray, Check, Lock Position?
	else
		Menu, Tray, Uncheck, Lock Position?

	; Clickthrough check
	if (PROGRAM.SETTINGS.SETTINGS_MAIN.AllowClicksToPassThroughWhileInactive = "True") 
		Menu, Tray, Check, Clickthrough?
	else
		Menu, Tray, Uncheck, Clickthrough?

	; TradesGUI Mode check
	if (PROGRAM.SETTINGS.SETTINGS_MAIN.TradesGUI_Mode = "Window") 
		GUI_Trades.Use_WindowMode(True)
	else if (PROGRAM.SETTINGS.SETTINGS_MAIN.TradesGUI_Mode = "Dock")
		GUI_Trades.Use_DockMode(True)

	; Icons
	Menu, Tray, Icon,Settings,% PROGRAM.ICONS_FOLDER "\gear.ico"
	Menu, Tray, Icon,,% PROGRAM.ICONS_FOLDER "\qmark.ico"
	Menu, Tray, Icon,My Stats,% PROGRAM.ICONS_FOLDER "\chart.ico"
	Menu, Tray, Icon,Reload,% PROGRAM.ICONS_FOLDER "\refresh.ico"
	Menu, Tray, Icon,Close,% PROGRAM.ICONS_FOLDER "\x.ico"
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
	GUI_Settings.Show()
}
Tray_OpenStats() {
	GUI_MyStats.Show()
}
Tray_ModeWindow() {
	global PROGRAM

	GUI_Trades.Use_WindowMode()
	Declare_LocalSettings()
	TrayNotifications.Show(PROGRAM.NAME, "Window mode enabled."
		. "`nYou can now move the Trades window around freely.")
}
Tray_ModeDock() {
	global PROGRAM

	GUI_Trades.Use_DockMode()
	Declare_LocalSettings()
	TrayNotifications.Show(PROGRAM.NAME, "Dock mode enabled."
		. "`nThe Trades window will stay on the top right corner of your game window."
		. "`nIn case you are running multiple instances and Trades window is docking to the wrong game, try using the ""Cycle Dock"" tray option.")
}
Tray_CycleDock() {
	GUI_Trades.DockMode_Cycle()
}
Tray_ToggleClickthrough() {
	global PROGRAM, GuiSettings_Controls

	GUI_Settings.TabSettingsMain_ToggleClickthroughCheckbox()
	toggle := PROGRAM.SETTINGS.SETTINGS_MAIN.AllowClicksToPassThroughWhileInactive
	Menu, Tray,% toggle="True"?"Check":"Uncheck", Clickthrough?
}
Tray_ToggleLockPosition(toggle="") {
	global PROGRAM
	iniFile := PROGRAM.INI_FILE

	if ( (toggle = "") || (toggle = A_ThisMenuItem) ) && (PROGRAM.SETTINGS.SETTINGS_MAIN.TradesGUI_Locked = "True")
	|| (toggle = "Uncheck") {
		INI.Set(iniFile, "SETTINGS_MAIN", "TradesGUI_Locked", "False")
		PROGRAM.SETTINGS.SETTINGS_MAIN.TradesGUI_Locked := "False"
		Menu, Tray, Uncheck, Lock position?
	}
	else if ( (toggle = "") || (toggle = A_ThisMenuItem) ) && (PROGRAM.SETTINGS.SETTINGS_MAIN.TradesGUI_Locked = "False")
	|| (toggle = "Check") {
		INI.Set(iniFile, "SETTINGS_MAIN", "TradesGUI_Locked", "True")
		PROGRAM.SETTINGS.SETTINGS_MAIN.TradesGUI_Locked := "True"
		Menu, Tray, Check, Lock position?
	}

	if (PROGRAM.SETTINGS.SETTINGS_MAIN.TradesGUI_Mode = "Dock") && (toggle != "Check")
		Tray_ModeWindow()
}
Tray_ResetPosition() {
	Tray_ModeWindow()
}