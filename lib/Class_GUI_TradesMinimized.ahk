Class Gui_TradesMinimized {
	Create() {
		global PROGRAM, GAME, SKIN
		global GuiTradesMinimized, GuiTradesMinimized_Controls, GuiTradesMinimized_Submit
		static guiCreated, maxTabsToRender

		scaleMult := PROGRAM.SETTINGS.SETTINGS_CUSTOMIZATION_SKINS.ScalingPercentage / 100
		resDPI := PROGRAM.OS.RESOLUTION_DPI 

		; Free ImageButton memory
		for key, value in GuiTradesMinimized_Controls
			if IsIn(key, "hBTN_Minimize,hBTN_Maximize,hBTN_LeftArrow,hBTN_RightArrow,hBTN_CloseTab")
			|| IsContaining(key, "hBTN_TabDefault,hBTN_TabJoinedArea,hBTN_TabWhisperReceived,hBTN_Custom,hBTN_Special")
				ImageButton.DestroyBtnImgList(value)

		; Initialize gui arrays
		Gui, TradesMinimized:Destroy
		Gui.New("TradesMinimized", "+AlwaysOnTop +ToolWindow +LastFound -SysMenu -Caption -Border +LabelGUI_TradesMinimized_ +HwndhGuiTradesMinimized", "TradesMinimized")
		guiCreated := False

		; Font name and size
		if (PROGRAM.SETTINGS.SETTINGS_CUSTOMIZATION_SKINS.Preset = "User Defined") {
			settings_fontName := PROGRAM.SETTINGS.SETTINGS_CUSTOMIZATION_SKINS.UseRecommendedFontSettings="1"?SKIN.Settings.FONT.Name : PROGRAM.SETTINGS.SETTINGS_CUSTOMIZATION_SKINS_UserDefined.Font
			settings_fontSize := PROGRAM.SETTINGS.SETTINGS_CUSTOMIZATION_SKINS.UseRecommendedFontSettings="1"?SKIN.Settings.FONT.Size : PROGRAM.SETTINGS.SETTINGS_CUSTOMIZATION_SKINS_UserDefined.FontSize
			settings_fontQual := PROGRAM.SETTINGS.SETTINGS_CUSTOMIZATION_SKINS.UseRecommendedFontSettings="1"?SKIN.Settings.FONT.Quality : PROGRAM.SETTINGS.SETTINGS_CUSTOMIZATION_SKINS_UserDefined.FontQuality
		}
		else {
			settings_fontName := SKIN.Settings.FONT.Name
			settings_fontSize := SKIN.Settings.FONT.Size
			settings_fontQual := SKIN.Settings.FONT.Quality
		}

		; Gui size and positions
		borderSize := Floor(1*scaleMult)

		guiFullHeight := 30 ; only header bar
		guiFullHeight := guiFullHeight+(borderSize*2), guiFullWidth := scaleMult*(95+(2*borderSize))

		guiHeight := guiFullHeight-(2*borderSize), guiWidth := guiFullWidth-(2*borderSize)
		guiMinimizedHeight := (30*scaleMult)+(2*borderSize) ; 30 = Header_H
		leftMost := borderSize, rightMost := guiWidth-borderSize
		upMost := borderSize, downMost := guiHeight-borderSize	

		; Header pos
		Header_X := leftMost, Header_Y := upMost, Header_W := guiWidth, Header_H := scaleMult*30
		Icon_X := Header_X+(3*scaleMult), Icon_Y := Header_Y+(3*scaleMult), Icon_W := scaleMult*24, Icon_H := scaleMult*24
		MinMax_X := rightMost-((scaleMult*20)+3), MinMax_Y := Header_Y+(5*scaleMult), MinMax_W := scaleMult*20, MinMax_H := scaleMult*20
		Title_X := Icon_X+Icon_W+5, Title_Y := Header_Y, Title_W := MinMax_X-Title_X-5, Title_H := Header_H

		; Trade infos text pos + time slot auto size
		Loop 10 { ; from 0 to 9
			num := (A_Index=10)?("0"):(A_Index)
			txtCtrlSize := Get_TextCtrlSize("(" num num num ")", settings_fontName, settings_fontSize), thisW := txtCtrlSize.W, thisH := txtCtrlSize.H
			tabsCountWidth := (tabsCountWidth > thisW)?(tabsCountWidth):(thisW)
			tabsCountHeight := (tabsCountHeight > thisH)?(tabsCountHeight):(thisH)
		}
		TabsCount_X := (guiWidth-tabsCountWidth)-5, TimeSlot_Y := TabUnderline_Y+TabUnderline_H, TimeSlot_W := tabsCountWidth
		TradeVerify_W := 10*scaleMult, TradeVerify_H := TradeVerify_W, TradeVerify_X := TimeSlot_X-5-TradeVerify_W, TradeVerify_Y := TimeSlot_Y+3

		; Set required gui array variables
		GuiTradesMinimized.Tabs_Count := 0
		GuiTradesMinimized.Is_Created := False
		GuiTradesMinimized.Height := guiFullHeight
		GuiTradesMinimized.Width := guiFullWidth

		styles := Gui_Trades.Get_Styles()

		/* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * 
		*	CREATION
		*/

		Gui.Margin("TradesMinimized", 0, 0)
		Gui.Color("TradesMinimized", "White")
		Gui.Font("TradesMinimized", settings_fontName, settings_fontSize, settings_fontQual)

		; = = BORDERS = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = =
		bordersPositions := [{Position:"Top", X:0, Y:0, W:guiFullWidth, H:borderSize}, {Position:"Left", X:0, Y:0, W:borderSize, H:guiFullHeight} ; Top and Left
			,{Position:"Bottom", X:0, Y:guiFullHeight-borderSize, W:guiFullWidth, H:borderSize}, {Position:"Right", X:guiFullWidth-borderSize, Y:0, W:borderSize, H:guiFullHeight} ; Bottom and Right
			,{Position:"BottomMinimized", X:0, Y:guiMinimizedHeight-borderSize, W:guiFullWidth, H:borderSize}] ; Bottom when minimized

		Loop 4 
			Gui.Add("TradesMinimized", "Progress", "x" bordersPositions[A_Index]["X"] " y" bordersPositions[A_Index]["Y"] " w" bordersPositions[A_Index]["W"] " h" bordersPositions[A_Index]["H"] " hwndhPROGRESS_Border" bordersPositions[A_index]["Position"] " Background" SKIN.Settings.COLORS.Border)

		; = = TITLE BAR = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = =
		Gui.Add("TradesMinimized", "Picture", "x" Header_X " y" Header_Y " w" Header_W " h" Header_H " hwndhIMG_Header BackgroundTrans", SKIN.Assets.Misc.Header) ; Title bar
		Gui.Add("TradesMinimized", "Picture", "x" Icon_X " y" Icon_Y " w" Icon_W " h" Icon_H " BackgroundTrans", SKIN.Assets.Misc.Icon) ; Icon
		imageBtnLog .= Gui.Add("TradesMinimized", "ImageButton", "x" MinMax_X " y" MinMax_Y " w" MinMax_W " h" MinMax_H " BackgroundTrans hwndhBTN_Maximize", "", styles.Maximize, PROGRAM.FONTS[settings_fontName], settings_fontSize) ; Max
		Gui.Add("TradesMinimized", "Text", "x" Title_X " y" Title_Y " w" Title_W " h" Title_H " hwndhTEXT_Title Center BackgroundTrans +0x200 c" SKIN.Settings.COLORS.Title_No_Trades, "(0)")
		Gui.Add("TradesMinimized", "Text", "x" Header_X " y" Header_Y " w" Header_W " h" Header_H " hwndhTXT_HeaderGhost BackgroundTrans", "") ; Empty text ctrl to allow moving the gui by dragging the title bar

		__f := GUI_TradesMinimized.OnGuiMove.bind(GUI_TradesMinimized, GuiTradesMinimized.Handle)
		GuiControl, TradesMinimized:+g,% GuiTradesMinimized_Controls["hTXT_HeaderGhost"],% __f

		__f := GUI_TradesMinimized.Maximize.bind(GUI_TradesMinimized, False)
		GuiControl, TradesMinimized:+g,% GuiTradesMinimized_Controls["hBTN_Maximize"],% __f

		Gui.Show("TradesMinimized", "x0 y0 h" GuiTradesMinimized.Height " w" GuiTradesMinimized.Width " NoActivate Hide")
		GuiTradesMinimized.Is_Created := True
		Return

		Gui_TradesMinimized_ContextMenu:
			ctrlHwnd := Get_UnderMouse_CtrlHwnd()
			GuiControlGet, ctrlName, TradesMinimized:,% ctrlHwnd

			Gui_TradesMinimized.ContextMenu(ctrlHwnd, ctrlName)
		return
	}

	ContextMenu(CtrlHwnd, CtrlName) {
		global PROGRAM, GuiTradesMinimized, GuiTradesMinimized_Controls
		iniFile := PROGRAM.INI_FILE

		if IsIn(CtrlHwnd, GuiTradesMinimized_Controls.hTXT_HeaderGhost "," GuiTradesMinimized_Controls.hTEXT_Title) {
			try Menu, HeaderMenu, DeleteAll
			Menu, HeaderMenu, Add, Lock Position?, Gui_TradesMinimized_ContextMenu_LockPosition
			if (PROGRAM.SETTINGS.SETTINGS_MAIN.TradesGUI_Locked = "True")
				Menu, HeaderMenu, Check, Lock Position?
			Menu, HeaderMenu, Show
		}
		Return

		Gui_TradesMinimized_ContextMenu_LockPosition:
			Tray_ToggleLockPosition()
		Return
	}

	Show() {
		global PROGRAM, GuiTradesMinimized, GuiTrades

		resDPI := PROGRAM.OS.RESOLUTION_DPI

		; Get Trades GUI pos
		hiddenWin := A_DetectHiddenWindows
		DetectHiddenWindows, On
		WinGetPos, gtX, gtY, gtW, gtH,% "ahk_id " GuiTrades.Handle
		WinGetPos, gtmX, gtmY, gtmW, gtmH,% "ahk_id " GuiTradesMinimized.Handle
		foundHwnd := WinExist("ahk_id " GuiTradesMinimized.Handle) ; Check if this gui exists
		isTradesWinActive := WinActive("ahk_id " GuiTrades.Handle)
		DetectHiddenWindows, %hiddenWin%

		if !(foundHwnd) ; Not found, create it
			GUI_TradesMinimized.Create()

		if (PROGRAM.SETTINGS.SETTINGS_MAIN.MinimizeInterfaceToBottomLeft = "True")
			xpos := gtX, ypos := gtY+gtH-gtmH ; bottom left
		else
			xpos := gtX+gtW-GuiTradesMinimized.Width, ypos := gtY ; top right
		
		xpos := IsNum(xpos) ? xpos : IsNum( A_ScreenWidth-(GuiTrades.Width*resDPI) ) ? A_ScreenWidth-(GuiTrades.Width*resDPI) : 0
		ypos := IsNum(ypos) ? ypos : 0
		if (isTradesWinActive)
			Gui, TradesMinimized:Show, x%xpos% y%ypos%
		else Gui, TradesMinimized:Show, x%xpos% y%ypos% NoActivate
		Gui, Trades:Hide
	}

	Maximize() {
		global PROGRAM, GuiTrades, GuiTradesMinimized

		GuiTrades.Is_Maximized := True
		GuiTrades.Is_Minimized := False

		; Get Trades Min GUI pos
		hiddenWin := A_DetectHiddenWindows
		DetectHiddenWindows, On
		WinGetPos, gtmX, gtmY, gtmW, gtmH,% "ahk_id " GuiTradesMinimized.Handle
		WinGetPos, gtX, gtY, gtW, gtH,% "ahk_id " GuiTrades.Handle
		isTradesWinActive := WinActive("ahk_id " GuiTradesMinimized.Handle)
		DetectHiddenWindows, %hiddenWin%

		if (PROGRAM.SETTINGS.SETTINGS_MAIN.MinimizeInterfaceToBottomLeft = "True")
			xpos := gtmX, ypos := gtmY+gtmH-gtH ; bottom left
		else
			xpos := gtmX+gtmW-gtw, ypos := gtmY ; top right

		xpos := IsNum(xpos) ? xpos : IsNum( A_ScreenWidth-(GuiTrades.Width*resDPI) ) ? A_ScreenWidth-(GuiTrades.Width*resDPI) : 0
		ypos := IsNum(ypos) ? ypos : 0
		if (isTradesWinActive)
			Gui, Trades:Show, x%xpos% y%ypos%
		else Gui, Trades:Show, x%xpos% y%ypos% NoActivate
		Gui, TradesMinimized:Hide
	}

	OnGuiMove(GuiHwnd) {
		/*	Allow dragging the GUI 
		*/
		global PROGRAM
		if ( PROGRAM.SETTINGS.SETTINGS_MAIN.TradesGUI_Mode = "Window" && PROGRAM.SETTINGS.SETTINGS_MAIN.TradesGUI_Locked = "False" ) {
			PostMessage, 0xA1, 2,,,% "ahk_id " GuiHwnd
		}
		KeyWait, LButton, Up
		Gui_TradesMinimized.SavePosition()
		; Gui_Trades.RemoveButtonFocus()
	}

	SavePosition() {
		global PROGRAM, GuiTrades, GuiTradesMinimized

		WinGetPos, gtX, gtY, gtW, gtH,% "ahk_id " GuiTrades.Handle
		WinGetPos, gtmX, gtmY, gtmW, gtmH,% "ahk_id " GuiTradesMinimized.Handle

		if (PROGRAM.SETTINGS.SETTINGS_MAIN.MinimizeInterfaceToBottomLeft = "True")
			saveX := gtmX, saveY := gtmY+gtmH-gtH
		else
			saveX := gtX+gtmW-gtW, saveY := gtmY
		
		if !IsNum(saveX) || !IsNum(saveY)
			Return

		INI.Set(PROGRAM.INI_FILE, "SETTINGS_MAIN", "Pos_X", saveX)
		INI.Set(PROGRAM.INI_FILE, "SETTINGS_MAIN", "Pos_Y", saveY)
	}

	
}
