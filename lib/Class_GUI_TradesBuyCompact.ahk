Class GUI_TradesBuyCompact {
	
	Create(_maxTabsToRender=50) {
		global PROGRAM, GAME, SKIN
		global GuiTradesBuyCompact, GuiTradesBuyCompact_Controls, GuiTradesBuyCompact_Submit
		static guiCreated, maxTabsToRender, borderSize

		if (PROGRAM.SETTINGS.SETTINGS_MAIN.DisableBuyInterface="True")
			return

		; GUI_TradesBuyCompact.DisableHotkeys()

		scaleMult := PROGRAM.SETTINGS.SETTINGS_CUSTOMIZATION_SKINS.ScalingPercentage / 100
		; AppendToLogs("TradesBuyCompact GUI: Creating with max tabs """ _maxTabsToRender """.")

		; Initialize gui arrays
		GUI_TradesBuyCompact.Destroy()
		Gui.New("TradesBuyCompact", "+AlwaysOnTop +ToolWindow +LastFound -SysMenu -Caption -Border +E0x08000000 +LabelGUI_TradesBuyCompact_ +HwndhGuiTradesBuyCompact", "POE TC - TradesBuyCompact")
		windowsDPI := GuiTradesBuyCompact.Windows_DPI := Get_DpiFactor()
		guiCreated := False

		; Font name and size
		if (PROGRAM.SETTINGS.SETTINGS_CUSTOMIZATION_SKINS.Preset = "User Defined") {
			settings_fontName := PROGRAM.SETTINGS.SETTINGS_CUSTOMIZATION_SKINS.UseRecommendedFontSettings="1"?SKIN.Compact.Settings.FONT.Name : PROGRAM.SETTINGS.SETTINGS_CUSTOMIZATION_SKINS_UserDefined.Font
			settings_fontSize := PROGRAM.SETTINGS.SETTINGS_CUSTOMIZATION_SKINS.UseRecommendedFontSettings="1"?SKIN.Compact.Settings.FONT.Size : PROGRAM.SETTINGS.SETTINGS_CUSTOMIZATION_SKINS_UserDefined.FontSize
			settings_fontQual := PROGRAM.SETTINGS.SETTINGS_CUSTOMIZATION_SKINS.UseRecommendedFontSettings="1"?SKIN.Compact.Settings.FONT.Quality : PROGRAM.SETTINGS.SETTINGS_CUSTOMIZATION_SKINS_UserDefined.FontQuality
		}
		else {
			settings_fontName := SKIN.Compact.Settings.FONT.Name
			settings_fontSize := SKIN.Compact.Settings.FONT.Size
			settings_fontQual := SKIN.Compact.Settings.FONT.Quality
		}

		twoTextLineSize := Get_TextCtrlSize("SomeText", settings_fontName, settings_fontSize, "", "R1").H*2, twoTextLineSize += ((10+12)*scaleMult) ; 10+12, based on ctrl pacing

		; Gui size and positions
		borderSize := Floor(1*scaleMult), borderSize := borderSize >= 1 ? borderSize : 1
		GuiTradesBuyCompact.Height_NoRow 		:= guiHeight_NoRow := borderSize+(30*scaleMult)+borderSize ; 1 border, 33 header, 1 border
		GuiTradesBuyCompact.Height_OneRow	 	:= guiHeight_OneRow := guiHeight_NoRow + (22*scaleMult) + twoTextLineSize + (borderSize*1) ; 22 header2
		GuiTradesBuyCompact.Height_TwoRow	 	:= guiHeight_TwoRow := guiHeight_OneRow + twoTextLineSize + (borderSize*2)
		GuiTradesBuyCompact.Height_ThreeRow 	:= guiHeight_ThreeRow := guiHeight_TwoRow + twoTextLineSize + (borderSize*2)
		GuiTradesBuyCompact.Height_FourRow 		:= guiHeight_FourRow := guiHeight_ThreeRow + twoTextLineSize + (borderSize*2)

		guiFullHeight := guiHeight_FourRow, guiFullWidth := scaleMult*(398+(2*borderSize))

		guiHeight := guiFullHeight-(2*borderSize), guiWidth := guiFullWidth-(2*borderSize)
		guiMinimizedHeight := (30*scaleMult)+(2*borderSize) ; 30 = Header_H
		leftMost := borderSize, rightMost := guiWidth+borderSize
		upMost := borderSize, downMost := guiHeight+borderSize

		; Tabs count
		maxTabsPerRow := 4
		maxTabsToRender := _maxTabsToRender

		; Header pos
		Header_X := leftMost, Header_Y := upMost, Header_W := guiWidth, Header_H := scaleMult*30
		Icon_X := Header_X+(3*scaleMult), Icon_Y := Header_Y+(3*scaleMult), Icon_W := scaleMult*24, Icon_H := scaleMult*24
		MinMax_X := rightMost-((scaleMult*22)+(3*scaleMult)), MinMax_Y := Header_Y+(4*scaleMult), MinMax_W := scaleMult*22, MinMax_H := scaleMult*22
		HideoutBtn_X := 15*scaleMult, HideoutBtn_Y := 5*scaleMult, HideoutBtn_W := 30*scaleMult, HideoutBtn_H := 22*scaleMult, SpaceBetweenBtns := 8*scaleMult
		Title_X := "_CUSTOM_", Title_Y := Header_Y, Title_W := "_CUSTOM_", Title_H := Header_H
		
		Header2_X := leftMost, Header2_Y := Header_Y+Header_H, Header2_H := scaleMult*22
		LeftArrow_W := scaleMult*25, LeftArrow_H := Header2_H, RightArrow_W := LeftArrow_W, RightArrow_H := LeftArrow_H
		Header2_W := Header_W-LeftArrow_W-RightArrow_W
		LeftArrow_X := rightMost-LeftArrow_W-RightArrow_W, LeftArrow_Y := Header2_Y, RightArrow_X := LeftArrow_X+LeftArrow_W, RightArrow_Y := Header2_Y
		SearchBox_X := leftMost+(10*scaleMult), SearchBox_Y := Header2_Y, SearchBox_W := (120*scaleMult), SearchBox_H := Header2_H
		; CloseTab_Y := RightArrow_Y, CloseTab_W := scaleMult*27, CloseTab_H := RightArrow_H

		 ; 1=dont stick to border
		
		; CloseTab_X := RightArrow_X+RightArrow_W

		; TabUnderline_X := leftMost, TabUnderline_Y := TabButton1_Y+TabButton1_H, TabUnderline_W := guiWidth, TabUnderline_H := 2 ; TO_DO why cant i scaleMult TabUnderline_H?

		; Background img
		BackgroundImg_X := leftMost, BackgroundImg_Y := Header_Y+Header_H
		BackgroundImg_W := Ceil( (guiWidth*windowsDPI) ), BackgroundImg_H := (guiHeight-Header_H)*windowsDPI

		; Trade infos text pos + time slot auto size
		; TradeInfos_X := leftMost+5, TradeInfos_Y := TabUnderline_Y+TabUnderline_H+5, TradeInfos_W := guiWidth-TradeInfos_X-5
		Loop 10 { ; from 0 to 9
			num := (A_Index=10)?("0"):(A_Index)
			txtCtrlSize := Get_TextCtrlSize(num num ":" num num, settings_fontName, settings_fontSize), thisW := txtCtrlSize.W, thisH := txtCtrlSize.H
			timeSlotWidth := (timeSlotWidth > thisW)?(timeSlotWidth):(thisW)
			timeSlotHeight := (timeSlotHeight > thisH)?(timeSlotHeight):(thisH)
		}
		; TimeSlot_X := (guiWidth-timeSlotWidth)-5, TimeSlot_Y := TabUnderline_Y+TabUnderline_H, TimeSlot_W := timeSlotWidth
		; TradeVerify_W := 10*scaleMult, TradeVerify_H := TradeVerify_W, TradeVerify_X := TimeSlot_X-5-TradeVerify_W, TradeVerify_Y := TimeSlot_Y+3
		; TO_DO Proper Scalemult?
		; Set TradeVerify_W same as TimeSlot_H? --Cant do. Height changes based on font type.

		; Set required gui array variables
		GuiTradesBuyCompact.Height_Maximized := guiMinimizedHeight
		GuiTradesBuyCompact.Height_Minimized := guiMinimizedHeight
		GuiTradesBuyCompact.Active_Tab := 0
		GuiTradesBuyCompact.Tabs_Count := 0
		GuiTradesBuyCompact.Tabs_Limit := maxTabsToRender
		GuiTradesBuyCompact.Max_Tabs_Per_Row := maxTabsPerRow
		GuiTradesBuyCompact.Is_Created := False
		GuiTradesBuyCompact.Height := guiMinimizedHeight
		GuiTradesBuyCompact.Width := guiFullWidth

		styles := GUI_TradesBuyCompact.Get_Styles() ; TO_DO
		/*
		global PROGRAM, GAME, SKIN
		global GuiTradesBuyCompact, GuiTradesBuyCompact_Controls, GuiTradesBuyCompact_Submit
		static guiCreated

		; Initialize gui arrays
		Gui, TradesBuyCompact:Destroy
		Gui.New("TradesBuyCompact", "-Caption +ToolWindow -Border +AlwaysOnTop +LabelGUI_TradesBuyCompact_ +HwndhGuiTradesBuyCompact", "POE TC - Buy Item")
		guiCreated := GuiTradesBuyCompact.Is_Created := False

		; Font name and size
		if (PROGRAM.SETTINGS.SETTINGS_CUSTOMIZATION_SKINS.Preset = "User Defined") {
			settings_fontName := PROGRAM.SETTINGS.SETTINGS_CUSTOMIZATION_SKINS.UseRecommendedFontSettings="1"?SKIN.Compact.Settings.FONT.Name : PROGRAM.SETTINGS.SETTINGS_CUSTOMIZATION_SKINS_UserDefined.Font
			settings_fontSize := PROGRAM.SETTINGS.SETTINGS_CUSTOMIZATION_SKINS.UseRecommendedFontSettings="1"?SKIN.Compact.Settings.FONT.Size : PROGRAM.SETTINGS.SETTINGS_CUSTOMIZATION_SKINS_UserDefined.FontSize
			settings_fontQual := PROGRAM.SETTINGS.SETTINGS_CUSTOMIZATION_SKINS.UseRecommendedFontSettings="1"?SKIN.Compact.Settings.FONT.Quality : PROGRAM.SETTINGS.SETTINGS_CUSTOMIZATION_SKINS_UserDefined.FontQuality
		}
		else {
			settings_fontName := SKIN.Compact.Settings.FONT.Name
			settings_fontSize := SKIN.Compact.Settings.FONT.Size
			settings_fontQual := SKIN.Compact.Settings.FONT.Quality
		}
		; settings_fontName := "Segoe UI"
		; settings_fontSize := "10"
		settings_fontQual := 5

		; Gui size and positions
		twoTextLineSize := Get_TextCtrlSize("SomeText", settings_fontName, settings_fontSize, "", "R1").H*2, twoTextLineSize += 10+12
		GuiTradesBuyCompact.Height_NoRow := guiHeight_NoRow := 1+25+20+1 ; 1 border, 25 header, 20 header 2, 1 border
		GuiTradesBuyCompact.Height_OneRow := guiHeight_OneRow := guiHeight_NoRow + twoTextLineSize
		GuiTradesBuyCompact.Height_TwoRow := guiHeight_TwoRow := guiHeight_OneRow + twoTextLineSize
		GuiTradesBuyCompact.Height_ThreeRow := guiHeight_ThreeRow := guiHeight_TwoRow + twoTextLineSize
		GuiTradesBuyCompact.Height_FourRow := guiHeight_FourRow := guiHeight_ThreeRow + twoTextLineSize + 3

		static borderSize
		guiFullHeight := guiHeight_FourRow, guiFullWidth := 400, borderSize := 1, borderColor := "Red"
		guiHeight := guiFullHeight-(2*borderSize), guiWidth := guiFullWidth-(2*borderSize)
		leftMost := borderSize, rightMost := guiWidth-borderSize
		upMost := borderSize, downMost := guiHeight-borderSize

		Loop 10 { ; from 0 to 9
			num := (A_Index=10)?("0"):(A_Index)
			txtCtrlSize := Get_TextCtrlSize(num num ":" num num, settings_fontName, settings_fontSize), thisW := txtCtrlSize.W, thisH := txtCtrlSize.H
			timeSlotWidth := (timeSlotWidth > thisW)?(timeSlotWidth):(thisW)
			timeSlotHeight := (timeSlotHeight > thisH)?(timeSlotHeight):(thisH)
		}

		GuiTradesBuyCompact.Tabs_Count := 0

		Header_X := leftMost, Header_Y := upMost, Header_W := guiWidth, Header_H := scaleMult*30
		Icon_X := Header_X+(3*scaleMult), Icon_Y := Header_Y+(3*scaleMult), Icon_W := scaleMult*24, Icon_H := scaleMult*24
		MinMax_X := rightMost-((scaleMult*20)+3), MinMax_Y := Header_Y+(5*scaleMult), MinMax_W := scaleMult*20, MinMax_H := scaleMult*20
		Title_X := Icon_X+Icon_W+5, Title_Y := Header_Y, Title_W := MinMax_X-Title_X-5, Title_H := Header_H

		GuiTradesBuyCompact.Style_Tab := Style_Tab := [ [0, "0xEEEEEE", "", "Black", 0, , ""] ; normal
			, [0, "0xdbdbdb", "", "Black", 0] ; hover
			, [3, "0x44c6f6", "0x098ebe", "Black", 0]  ; press
			, [3, "0x44c6f6", "0x098ebe", "White", 0 ] ] ; default

		GuiTradesBuyCompact.Style_RedBtn := Style_RedBtn := [ [0, "0xff5c5c", "", "White", 0, , ""] ; normal
			, [0, "0xff5c5c", "", "White", 0] ; hover
			, [3, "0xe60000", "0xff5c5c", "Black", 0]  ; press
			, [3, "0xff5c5c", "0xe60000", "White", 0 ] ] ; default

		Style_SystemButton := [ [0, "0xdddfdd", , "Black"] ; normal
			,  [0, "0x8fddfa"] ; hover
			,  [0, "0x44c6f6"] ] ; press

	    Style_WhiteButton := [ [0, "White", , "Black"] ; normal
			,  [0, "0xdddfdd"] ; hover
			,  [0, "0x8fddfa"] ; press
			,  [0, "0x8fddfa", , "White"] ] ; default
		*/

		/* * * * * * *
		* 	CREATION
		*/

		Gui.Margin("TradesBuyCompact", 0, 0)
		Gui.Color("TradesBuyCompact", SKIN.Compact.Assets.Misc.Transparency_Color)
		Gui.Font("TradesBuyCompact", settings_fontName, settings_fontSize, settings_fontQual)
		Gui, TradesBuyCompact:Default

		; = = BORDERS = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = =
		bordersPositions := [{Name:"Top", X:0, Y:0, W:guiFullWidth, H:borderSize}
							,{Name:"Left", X:0, Y:0, W:borderSize, H:guiFullHeight}
							,{Name:"Right", X:guiFullWidth-borderSize, Y:0, W:borderSize, H:guiFullHeight}
							,{Name:"Bottom_1", X:0, Y:Header_Y+Header_H, W:guiFullWidth, H:borderSize}
							,{Name:"Bottom_2", X:0, Y:guiHeight_OneRow-borderSize, W:guiFullWidth, H:borderSize}
							,{Name:"Bottom_3", X:0, Y:guiHeight_TwoRow-borderSize, W:guiFullWidth, H:borderSize}
							,{Name:"Bottom_4", X:0, Y:guiHeight_ThreeRow-borderSize, W:guiFullWidth, H:borderSize}
							,{Name:"Bottom_5", X:0, Y:guiHeight_FourRow-borderSize, W:guiFullWidth, H:borderSize}]

		Loop % bordersPositions.Count() {
			Gui.Add("TradesBuyCompact", "Progress", "x" bordersPositions[A_Index]["X"] " y" bordersPositions[A_Index]["Y"] " w" bordersPositions[A_Index]["W"] " h" bordersPositions[A_Index]["H"] " Background" SKIN.Compact.Settings.COLORS.Border " c" SKIN.Compact.Settings.COLORS.Border " hwndhPROGRESS_Border" bordersPositions[A_Index].Name, 100)
		}

		; = = HEADER BAR = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = =
		; Gui.Add("TradesBuyCompact", "Picture", "x" Header_X " y" Header_Y " w" Header_W " h" Header_H " hwndhIMG_Header BackgroundTrans", SKIN.Compact.Assets.Misc.Header) ; Title bar
		Gui.Add("TradesBuyCompact", "Picture", "x" Header_X " y" Header_Y " w" Header_W " h" Header_H " hwndhIMG_Header BackgroundTrans", SKIN.Compact.Assets.Misc.Header) ; Title bar
		; Gui.Add("TradesBuyCompact", "Picture", "x" Icon_X " y" Icon_Y " w" Icon_W " h" Icon_H " BackgroundTrans", SKIN.Compact.Assets.Misc.Icon) ; Icon
		imageBtnLog .= Gui.Add("TradesBuyCompact", "ImageButton", "x" MinMax_X " y" MinMax_Y " w" MinMax_W " h" MinMax_H " BackgroundTrans hwndhBTN_Minimize", "", styles.Minimize, PROGRAM.FONTS[settings_fontName], settings_fontSize) ; Min
		imageBtnLog .= Gui.Add("TradesBuyCompact", "ImageButton", "x" MinMax_X " y" MinMax_Y " w" MinMax_W " h" MinMax_H " BackgroundTrans hwndhBTN_Maximize Hidden", "", styles.Maximize, PROGRAM.FONTS[settings_fontName], settings_fontSize) ; Max
		imageBtnLog .= Gui.Add("TradesBuyCompact", "ImageButton", "x" HideoutBtn_X " y" HideoutBtn_Y " w" HideoutBtn_W " h" HideoutBtn_H " BackgroundTrans hwndhBTN_Hideout", "", Styles.Toolbar_Hideout, PROGRAM.FONTS[settings_fontName], settings_fontSize)
		imageBtnLog .= Gui.Add("TradesBuyCompact", "ImageButton", "x+" SpaceBetweenBtns " yp wp hp BackgroundTrans hwndhBTN_LeagueHelp", "", styles.Toolbar_Sheet, PROGRAM.FONTS[settings_fontName], settings_fontSize)
		imageBtnLog .= Gui.Add("TradesBuyCompact", "ImageButton", "x+" SpaceBetweenBtns " yp wp hp BackgroundTrans hwndhBTN_What2 Hidden", "", styles.Toolbar_Hideout, PROGRAM.FONTS[settings_fontName], settings_fontSize)
		imageBtnLog .= Gui.Add("TradesBuyCompact", "ImageButton", "x+" SpaceBetweenBtns " yp wp hp BackgroundTrans hwndhBTN_What3 Hidden", "", styles.Toolbar_Hideout, PROGRAM.FONTS[settings_fontName], settings_fontSize)

		lastBtnCoords := Get_ControlCoords("TradesBuyCompact", GuiTradesBuyCompact_Controls.hBTN_What3)
		minBtnCoords := Get_ControlCoords("TradesBuyCompact", GuiTradesBuyCompact_Controls.hBTN_Minimize)
		Gui.Add("TradesBuyCompact", "Text", "x" lastBtnCoords.X+lastBtnCoords.W+(3*scaleMult) " y" Title_Y " w" Header_W-(lastBtnCoords.X+lastBtnCoords.W+(3*scaleMult))-(Header_W-(minBtnCoords.X-minBtnCoords.W)) " h" Title_H " hwndhTEXT_Title Center BackgroundTrans +0x200 c" SKIN.Compact.Settings.COLORS.Title_No_Trades, PROGRAM.NAME)
		; titleCoords := Get_ControlCoords("TradesBuyCompact", GuiTradesBuyCompact_Controls.hTEXT_Title) ; Get coords to center on Y
		; GuiControl, Trades:Move,% GuiTradesBuyCompact_Controls.hTEXT_Title,% "y" Ceil( titleCoords.Y+(titleCoords.H/2) ) ; Center on Y based on text H

		Gui.Add("TradesBuyCompact", "Text", "x" Header_X " y" Header_Y " w" Header_W " h" Header_H " hwndhTXT_HeaderGhost BackgroundTrans", "") ; Empty text ctrl to allow moving the gui by dragging the title bar

		__f := GUI_TradesBuyCompact.OnGuiMove.bind(GUI_TradesBuyCompact, GuiTradesBuyCompact.Handle)
		GuiControl, TradesBuyCompact:+g,% GuiTradesBuyCompact_Controls["hTXT_HeaderGhost"],% __f
		__f := GUI_TradesBuyCompact.Minimize.bind(GUI_TradesBuyCompact, False)
		GuiControl, TradesBuyCompact:+g,% GuiTradesBuyCompact_Controls["hBTN_Minimize"],% __f
		__f := GUI_TradesBuyCompact.Maximize.bind(GUI_TradesBuyCompact, False)
		GuiControl, TradesBuyCompact:+g,% GuiTradesBuyCompact_Controls["hBTN_Maximize"],% __f

		__f := GUI_TradesBuyCompact.HotBarButton.bind(GUI_TradesBuyCompact, "Hideout")
		GuiControl, TradesBuyCompact:+g,% GuiTradesBuyCompact_Controls["hBTN_Hideout"],% __f
		__f := GUI_TradesBuyCompact.HotBarButton.bind(GUI_TradesBuyCompact, "LeagueHelp")
		GuiControl, TradesBuyCompact:+g,% GuiTradesBuyCompact_Controls["hBTN_LeagueHelp"],% __f
		__f := GUI_TradesBuyCompact.HotBarButton.bind(GUI_TradesBuyCompact, "What")
		GuiControl, TradesBuyCompact:+g,% GuiTradesBuyCompact_Controls["hBTN_What2"],% __f
		__f := GUI_TradesBuyCompact.HotBarButton.bind(GUI_TradesBuyCompact, "What")
		GuiControl, TradesBuyCompact:+g,% GuiTradesBuyCompact_Controls["hBTN_What3"],% __f
		; = = HEADER BAR 2 = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = =
		/*	Due to the fact that we want to use a skinned search box, we have to simulate it by:
			- Creating a child gui with the edit box, and set the transparency 1
			- Add a text control on the same exact location on the parent gui

			( this part only matters if using the +E0x08000000 style for parent gui)
			- Compare the control size for an edit box and a text control with the same text 
			  (an edit box and a text control will have difference in sizes due to the edit box borders which the text control doesnt have)
			  Based on the size difference, move the text control a bit

			- Due to the +E0x08000000 style, we can't focus the search box
			  We work around it by creating yet another gui (not child) with an edit box, which will be hidden
			- Using WM_LButtonDown and WM_LButtonUp, we detect when the user is clicking the child gui search box
			  and we focus our hidden gui edit box so we can type in
			- Anything typed in the hidden edit box will be reflected on our parent gui text control
		*/
		global GuiTradesBuyCompactSearch, GuiTradesBuyCompactSearch_Controls
		Gui.New("TradesBuyCompactSearch", "-Caption -Border +ToolWindow -SysMenu +AlwaysOnTop +LastFound +ParentTradesBuyCompact +E0x08000000 +HwndhGuiTradesBuyCompactSearch")
		Gui.Margin("TradesBuyCompactSearch", 0, 0)
		Gui.Color("TradesBuyCompactSearch", "White")
		Gui.Font("TradesBuyCompactSearch", settings_fontName, settings_fontSize, settings_fontQual)
		Gui.Add("TradesBuyCompactSearch", "Edit", "x" 0 " y" 0 " w" SearchBox_W " h" SearchBox_H " FontQuality5 BackgroundTrans hwndhEDIT_SearchBar cWhite Limit1")
		WinSet, Transparent, 1
		global GuiTradesBuyCompactSearchHidden, GuiTradesBuyCompactSearchHidden_Controls
		Gui.New("TradesBuyCompactSearchHidden", "-Caption -Border +ToolWindow -SysMenu +AlwaysOnTop +E0x08000000 +LastFound +HwndhGuiTradesBuyCompactSearchHidden")
		Gui.Margin("TradesBuyCompactSearchHidden", 0, 0)
		Gui.Color("TradesBuyCompactSearchHidden", "White")
		Gui.Font("TradesBuyCompactSearchHidden", settings_fontName, settings_fontSize, settings_fontQual)
		Gui.Add("TradesBuyCompactSearchHidden", "Edit", "x" 0 " y" 0 " w" SearchBox_W " h" SearchBox_H " FontQuality5 BackgroundTrans hwndhEDIT_HiddenSearchBar")

		one := Get_TextCtrlSize("EXTREMELY_UNNECESSARILY_LONG_SAMPLE_TEXT", settings_fontName, settings_fontSize, maxWidth:="", params="R1", ctrlType:="Text").W
		two := Get_TextCtrlSize("EXTREMELY_UNNECESSARILY_LONG_SAMPLE_TEXT", settings_fontName, settings_fontSize, maxWidth:="", params="R1", ctrlType:="Edit").W

		Gui.Add("TradesBuyCompact", "Picture", "x" Header2_X " y" Header2_Y " w" Header2_W " h" Header2_H " hwndhIMG_Header2 BackgroundTrans", SKIN.Compact.Assets.Misc.Header) ; Title bar
		Gui.Add("TradesBuyCompact", "Picture", "x" Header2_X " y" Header2_Y " w" Header2_W " h" Header2_H " hwndhIMG_Header2 BackgroundTrans", SKIN.Compact.Assets.Misc.Header2) ; Title bar
		Gui.Add("TradesBuyCompact", "Text", "x" SearchBox_X+( (two-one)/2 ) " y" SearchBox_Y " w" SearchBox_W-( (two-one)/2 ) " h" SearchBox_H " FontQuality5 BackgroundTrans +0x200 c" SKIN.Compact.Settings.COLORS.SearchBar_Empty " hwndhTEXT_SearchBarFake", "...")

		SearchBarCross_X := "_CUSTOM_", SearchBarCross_Y := SearchBox_Y, SearchBarCross_W := 21*scaleMult, SearchBarCross_H := 21*scaleMult
		
		; imageBtnLog .= Gui.Add("TradesBuyCompact", "ImageButton", "xp+" (SearchBox_W-( (two-one)/2 )) " yp w" 21 " h" 21 " hwndhBTN_SearchBarCross BackgroundTrans", "", styles.SearchBarCross, PROGRAM.FONTS[settings_fontName], settings_fontSize) ; Left Arrow
		; imageBtnLog .= Gui.Add("TradesBuyCompact", "Picture", "xp+" (SearchBox_W-( (two-one)/2 )) " y" SearchBarCross_Y " w" SearchBarCross_W " h" SearchBarCross_H " hwndhIMG_SearchBarCross Hidden BackgroundTrans", SKIN.Compact.Assets.Misc.SearchBarCross)

		imageBtnLog .= Gui.Add("TradesBuyCompact", "ImageButton", "x" LeftArrow_X " y" LeftArrow_Y " w" LeftArrow_W " h" LeftArrow_H " hwndhBTN_LeftArrow", "", styles.Arrow_Left, PROGRAM.FONTS[settings_fontName], settings_fontSize) ; Left Arrow
		imageBtnLog .= Gui.Add("TradesBuyCompact", "ImageButton", "x" RightArrow_X " y" RightArrow_Y " w" RightArrow_W " h" RightArrow_H " hwndhBTN_RightArrow", "", styles.Arrow_Right, PROGRAM.FONTS[settings_fontName], settings_fontSize) ; Right Arrow
				
		; SetEditCueBanner(GuiTradesBuyCompact_Controls.hEDIT_SearchBar, "Search Bar")
		
		GuiTradesBuyCompact_Controls.GuiTradesBuyCompactSearchHandle := GuiTradesBuyCompactSearch.Handle
		GuiTradesBuyCompact_Controls.GuiTradesBuyCompactSearchHiddenHandle := GuiTradesBuyCompactSearchHidden.Handle
		GuiTradesBuyCompact_Controls.hEDIT_SearchBar := GuiTradesBuyCompactSearch_Controls.hEDIT_SearchBar
		GuiTradesBuyCompact_Controls.hEDIT_HiddenSearchBar := GuiTradesBuyCompactSearchHidden_Controls.hEDIT_HiddenSearchBar

		__f := GUI_TradesBuyCompact.SetFakeSearch.bind(GUI_TradesBuyCompact, makeEmpty:=False)
		GuiControl, TradesBuyCompactSearchHidden:+g,% GuiTradesBuyCompact_Controls.hEDIT_HiddenSearchBar,% __f
		__f := GUI_TradesBuyCompact.SetFakeSearch.bind(GUI_TradesBuyCompact, makeEmpty:=True)
		GuiControl, TradesBuyCompact:+g,% GuiTradesBuyCompact_Controls.hIMG_SearchBarCross,% __f
		__f := GUI_TradesBuyCompact.ScrollUp.bind(GUI_TradesBuyCompact)
		GuiControl, TradesBuyCompact:+g,% GuiTradesBuyCompact_Controls.hBTN_LeftArrow,% __f
		__f := GUI_TradesBuyCompact.ScrollDown.bind(GUI_TradesBuyCompact)
		GuiControl, TradesBuyCompact:+g,% GuiTradesBuyCompact_Controls.hBTN_RightArrow,% __f
		

		/*
		Gui.Add("TradesBuyCompact", "Text", "x" leftMost " y" upMost " w" guiWidth-(borderSize*2)-30 " h25 hwndhTEXT_HeaderGhost BackgroundTrans ", "") ; Title bar, allow moving
		Gui.Add("TradesBuyCompact", "Picture", "xp yp wp hp Background359cfc") ; Title bar background
		; Gui.Add("TradesBuyCompact", "Text", "xp yp wp-100 h25 Center 0x200 cWhite BackgroundTrans ", "POE Trades Companion - TradesBuyCompact") ; Title bar text
		imageBtnLog .= Gui.Add("TradesBuyCompact", "ImageButton", "x" rightMost-30 " yp w30 h25 hwndhBTN_CloseGUI", "-", Style_RedBtn, PROGRAM.FONTS[settings_fontName], settings_fontSize)
		imageBtnLog .= Gui.Add("TradesBuyCompact", "ImageButton", "x" leftMost+35 " yp+2 w20 h20 hwndhBTN_GenericBtn1", "", Style_SystemButton, PROGRAM.FONTS[settings_fontName], settings_fontSize)
		imageBtnLog .= Gui.Add("TradesBuyCompact", "ImageButton", "x+5 yp w20 h20 hwndhBTN_GenericBtn2", "", Style_SystemButton, PROGRAM.FONTS[settings_fontName], settings_fontSize)
		__f := GUI_TradesBuyCompact.DragGui.bind(GUI_TradesBuyCompact, GuiTradesBuyCompact.Handle)
		GuiControl, TradesBuyCompact:+g,% GuiTradesBuyCompact_Controls.hTEXT_HeaderGhost,% __f
		__f := GUI_TradesBuyCompact.Close.bind(GUI_TradesBuyCompact)
		GuiControl, TradesBuyCompact:+g,% GuiTradesBuyCompact_Controls.hBTN_CloseGUI,% __f

		; * * Title Bar 2
		firstBarPos := Get_ControlCoords("TradesBuyCompact", GuiTradesBuyCompact_Controls.hTEXT_HeaderGhost)
		; Gui.Add("TradesBuyCompact", "Edit", "xp+5 yp w125 h20 hwndhEDIT_SearchBar")
		Gui.Add("TradesBuyCompact", "Edit", "x" leftMost+5 " y" firstBarPos.Y+firstBarPos.H " w125 h20 hwndhEDIT_SearchBar")
		Gui.Add("TradesBuyCompact", "Progress", "x" leftMost " y" firstBarPos.Y+firstBarPos.H " w" guiWidth " h20 Background359cfc") ; Title bar background
		Gui.Add("TradesBuyCompact", "ImageButton", "x" rightMost-50 " yp w25 hp hwndhBTN_ScrollUp", "<", Style_SystemButton, PROGRAM.FONTS[settings_fontName], settings_fontSize)
		Gui.Add("TradesBuyCompact", "ImageButton", "x+0 yp wp hp hwndhBTN_ScrollDown", ">", Style_SystemButton, PROGRAM.FONTS[settings_fontName], settings_fontSize)
		*/

		SmallButton_W := 35*scaleMult, SmallButton_H := 25*scaleMult, SmallButton_Space := 5*scaleMult, SmallButton_Count := 4
		CloseBtn_W := 15*scaleMult, CloseBtn_H := twoTextLineSize, CloseBtn_X := rightMost-CloseBtn_W, CloseBtn_Y := 0
		ItemName_X := leftMost+(5*scaleMult), ItemName_Y := (5*scaleMult), ItemName_W := CloseBtn_X-(SmallButton_W*SmallButton_Count)-(SmallButton_Space*SmallButton_Count)-(20*scaleMult)
		SellerName_X := ItemName_X+ItemName_W, SellerName_Y := ItemName_Y, SellerName_W := SmallButton_W*SmallButton_Count
		CurrencyImg_X := " x" leftMost+(5*scaleMult), CurrencyImg_Y := " y+8", CurrencyImg_W := " w" 20*scaleMult, CurrencyImg_H := " h" 20*scaleMult
		PriceTxt_X := "_CUSTOM_", PriceTxt_Y := "_CUSTOM_", PriceTxt_W := 35*scaleMult
		AdditionalMsg_X := "_CUSTOM_", AdditionalMsg_Y := "_CUSTOM_", AdditionalMsg_W := "_CUSTOM_"
		TimeSent_X := " x" CloseBtn_X-timeSlotWidth-(2*scaleMult), TimeSent_Y := " y" 0, TimeSent_W := " w" timeSlotWidth
		SmallButton_X := CloseBtn_X-(SmallButton_Count* (SmallButton_W+SmallButton_Space))-(15*scaleMult), SmallButton_Y := CloseBtn_Y+CloseBtn_H-SmallButton_H-borderSize
		Separation_X := leftMost, Separation_Y := SmallButton_Y+SmallButton_H+(2*scaleMult), Separation_W := guiWidth, Separation_H := borderSize
		BackgroundImg_X := leftMost, BackgroundImg_Y := 0
		BackgroundImg_W := Ceil( (guiWidth*windowsDPI) ), BackgroundImg_H := Ceil(Separation_Y*windowsDPI)
		CloseBtn_H := Separation_Y

		GuiTradesBuyCompact.PriceTxt_MaxW := SmallButton_X-3

		Loop % maxTabsToRender { ; Creating a child GUI for each
			Gui.New("TradesBuyCompact_Slot" A_Index, "-Caption -Border +AlwaysOnTop +ParentTradesBuyCompact +LabelGUI_TradesBuyCompact_Slot_ +HwndhGuiTradesBuyCompact_Slot" A_Index, "POE TC - Buy Item Slot " A_Index)
			Gui.Margin("TradesBuyCompact_Slot" A_Index, 0, 0)
			Gui.Color("TradesBuyCompact_Slot" A_Index, SKIN.Compact.Assets.Misc.Transparency_Color)
			Gui.Font("TradesBuyCompact_Slot" A_Index, settings_fontName, settings_fontSize, settings_fontQual)

			Gui.Add("TradesBuyCompact_Slot" A_Index, "Text", "x0 y0 w0 h0 BackgroundTrans Hidden hwndhTEXT_HiddenInfos", "")

			Gui.Add("TradesBuyCompact_Slot" A_Index, "Picture", "x" BackgroundImg_X " y" BackgroundImg_Y " hwndhIMG_Background BackgroundTrans", SKIN.Compact.Assets.Misc.Background)
			TilePicture("TradesBuyCompact_Slot" A_Index, GuiTradesBuyCompact_Slot%A_Index%_Controls.hIMG_Background, BackgroundImg_W, BackgroundImg_H) ; Fill the background
			
			Gui.Add("TradesBuyCompact_Slot" A_Index, "Text", "x" ItemName_X " y" ItemName_Y " w" ItemName_W " R1 BackgroundTrans hwndhTEXT_ItemName c" SKIN.Compact.Settings.COLORS.Trade_Info_2)
			Gui.Add("TradesBuyCompact_Slot" A_Index, "Text", "x" SellerName_X " y" SellerName_Y " w" SellerName_W " R1 BackgroundTrans hwndhTEXT_SellerName c" SKIN.Compact.Settings.COLORS.Trade_Info_2)
			Gui.Add("TradesBuyCompact_Slot" A_Index, "Picture", CurrencyImg_X . CurrencyImg_Y . CurrencyImg_W . CurrencyImg_H " 0xE BackgroundTrans  hwndhIMG_CurrencyIMG")
			Gui.Add("TradesBuyCompact_Slot" A_Index, "Text", "x0 y0" . PriceTxt_W " BackgroundTrans hwndhTEXT_PriceCount c" SKIN.Compact.Settings.COLORS.Trade_Info_2)
			Gui.Add("TradesBuyCompact_Slot" A_Index, "Text", "x0 y0 w100 R1 BackgroundTrans  hwndhTEXT_AdditionalMsg c" SKIN.Compact.Settings.COLORS.Trade_Info_2)
			Gui.Add("TradesBuyCompact_Slot" A_Index, "Text", TimeSent_X . TimeSent_Y . TimeSent_W " R1 BackgroundTrans hwndhTEXT_TimeSent c" SKIN.Compact.Settings.COLORS.Trade_Info_2)
			imageBtnLog .= Gui.Add("TradesBuyCompact_Slot" A_Index, "ImageButton", "x" CloseBtn_X " y" CloseBtn_Y " w" CloseBtn_W " h" CloseBtn_H " hwndhBTN_Close", "", Styles.Close_Tab, PROGRAM.FONTS[settings_fontName], settings_fontSize)
			; Gui.Add("TradesBuyCompact_Slot" A_Index, "Progress", "x" Separation_X " y" Separation_Y " w" Separation_W " h" Separation_H " hwndhPROGRESS_Separation Background" SKIN.Compact.Settings.COLORS.Border)

			imageBtnLog .= Gui.Add("TradesBuyCompact_Slot" A_Index, "ImageButton", "x" SmallButton_X " y" SmallButton_Y " w" SmallButton_W " h" SmallButton_H " hwndhBTN_WhisperSeller", "", Styles.Button_Whisper, PROGRAM.FONTS[settings_fontName], settings_fontSize) ; write to seller
			imageBtnLog .= Gui.Add("TradesBuyCompact_Slot" A_Index, "ImageButton", "x+5 yp wp hp hwndhBTN_HideoutSeller", "", Styles.Button_Hideout, PROGRAM.FONTS[settings_fontName], settings_fontSize) ; hideout seller
			imageBtnLog .= Gui.Add("TradesBuyCompact_Slot" A_Index, "ImageButton", "x+5 yp wp hp hwndhBTN_KickSelfSeller", "", Styles.Button_Kick, PROGRAM.FONTS[settings_fontName], settings_fontSize) ; thanks seller
			imageBtnLog .= Gui.Add("TradesBuyCompact_Slot" A_Index, "ImageButton", "x+5 yp wp hp hwndhBTN_ThankSeller", "", Styles.Button_Thanks, PROGRAM.FONTS[settings_fontName], settings_fontSize) ; kick self
			; imageBtnLog .= Gui.Add("TradesBuyCompact_Slot" A_Index, "ImageButton", "x+5 yp wp hp hwndhBTN_QuickBtn5", "?", Styles.Button_Special, PROGRAM.FONTS[settings_fontName], settings_fontSize) ; hideout self
			
			priceImgPos := Get_ControlCoords("TradesBuyCompact_Slot" A_Index, GuiTradesBuyCompact_Slot%A_Index%_Controls.hIMG_CurrencyIMG)
			priceTxtPos := Get_ControlCoords("TradesBuyCompact_Slot" A_Index, GuiTradesBuyCompact_Slot%A_Index%_Controls.hTEXT_PriceCount)
			GuiControl, TradesBuyCompact_Slot%A_Index%:Move,% GuiTradesBuyCompact_Slot%A_Index%_Controls.hTEXT_PriceCount,% " x" priceImgPos.X+priceImgPos.W+(2*scaleMult) " y" (priceImgPos.Y+priceImgPos.H/2) - (priceTxtPos.H/2)		
			priceTxtPos := Get_ControlCoords("TradesBuyCompact_Slot" A_Index, GuiTradesBuyCompact_Slot%A_Index%_Controls.hTEXT_PriceCount)
			GuiControl, TradesBuyCompact_Slot%A_Index%:Move,% GuiTradesBuyCompact_Slot%A_Index%_Controls.hTEXT_AdditionalMsg,% "x" priceTxtPos.X+priceTxtPos.W+(10*scaleMult) " y" priceTxtPos.Y " w" SmallButton_X-( priceTxtPos.X+priceTxtPos.W+(10*scaleMult) )
			
			GuiTradesBuyCompact["Slot" A_Index] := GuiTradesBuyCompact_Slot%A_Index% ; adding gui array to our main gui array as a sub array
			GuiTradesBuyCompact["Slot" A_Index "_Controls"] := GuiTradesBuyCompact_Slot%A_Index%_Controls

			__f := GUI_TradesBuyCompact.RemoveTab.bind(GUI_TradesBuyCompact, A_Index)
			GuiControl, TradesBuyCompact_Slot%A_Index%:+g,% GuiTradesBuyCompact_Slot%A_Index%_Controls.hBTN_Close,% __f 
			__f := GUI_TradesBuyCompact.DoTradeButtonAction.bind(GUI_TradesBuyCompact, A_Index, "WhisperSeller")
			GuiControl, TradesBuyCompact_Slot%A_Index%:+g,% GuiTradesBuyCompact_Slot%A_Index%_Controls.hBTN_WhisperSeller,% __f 
			__f := GUI_TradesBuyCompact.DoTradeButtonAction.bind(GUI_TradesBuyCompact, A_Index, "HideoutSeller")
			GuiControl, TradesBuyCompact_Slot%A_Index%:+g,% GuiTradesBuyCompact_Slot%A_Index%_Controls.hBTN_HideoutSeller,% __f 
			__f := GUI_TradesBuyCompact.DoTradeButtonAction.bind(GUI_TradesBuyCompact, A_Index, "KickSelfSeller")
			GuiControl, TradesBuyCompact_Slot%A_Index%:+g,% GuiTradesBuyCompact_Slot%A_Index%_Controls.hBTN_KickSelfSeller,% __f 
			__f := GUI_TradesBuyCompact.DoTradeButtonAction.bind(GUI_TradesBuyCompact, A_Index, "ThankSeller")
			GuiControl, TradesBuyCompact_Slot%A_Index%:+g,% GuiTradesBuyCompact_Slot%A_Index%_Controls.hBTN_ThankSeller,% __f 

			Gui.Show("TradesBuyCompact_Slot" A_Index, "x0 y0 w" guiWidth+borderSize " h" Separation_Y+Separation_H " Hide")			
		}
		; calculate slot positions
		GuiTradesBuyCompact["Slot1_Pos"] := (Header2_Y+Header2_H)*windowsDPI
		GuiTradesBuyCompact["Slot2_Pos"] := GuiTradesBuyCompact["Slot1_Pos"] + (GuiTradesBuyCompact.Slot1.Height*windowsDPI)
		GuiTradesBuyCompact["Slot3_Pos"] := GuiTradesBuyCompact["Slot2_Pos"] + (GuiTradesBuyCompact.Slot1.Height*windowsDPI)
		GuiTradesBuyCompact["Slot4_Pos"] := GuiTradesBuyCompact["Slot3_Pos"] + (GuiTradesBuyCompact.Slot1.Height*windowsDPI)

		
		/* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * 
		*	SHOW
		*/

		if (imageBtnLog) {
			AppendToLogs(imageBtnLog)
			TrayNotifications.Show("TradesBuyCompact - Image button errors", "Some ImageButtons failed to be created successfully."
			. "`n" "The look of the interface may be altered, but it won't impact its behaviour."
			. "`n" "Further informations have been added to the logs file.")
		}

		savedXPos := PROGRAM.SETTINGS.SETTINGS_MAIN.Compact_Pos_X, savedYPos := PROGRAM.SETTINGS.SETTINGS_MAIN.Compact_Pos_Y
		winXPos := IsNum(savedXPos) ? savedXPos : (A_ScreenWidth-guiFullWidth)*windowsDPI
		winYPos := IsNum(savedYPos) ? savedYPos : 0

		Gui.Show("TradesBuyCompact", "x" winXPos " y" winYPos " h" guiMinimizedHeight " w" guiFullWidth " Hide")
		Gui.Show("TradesBuyCompactSearch", "x" SearchBox_X " y" SearchBox_Y " Hide")
		Gui.Show("TradesBuyCompactSearchHidden", "x0 y0 w0 h0 NoActivate") ; Not hidden on purpose so it can work with ShellMessage to empty on click

		GUI_TradesBuyCompact.Minimize()

		OnMessage(0x200, "WM_MOUSEMOVE")
		OnMessage(0x20A, "WM_MOUSEWHEEL")
		OnMessage(0x201, "WM_LBUTTONDOWN")
		OnMessage(0x202, "WM_LBUTTONUP")

		GUI_TradesBuyCompact.SetTransparency_Inactive()
		if (PROGRAM.SETTINGS.SETTINGS_MAIN.AllowClicksToPassThroughWhileInactive = "True")
			GUI_TradesBuyCompact.Enable_ClickThrough()

		Gui_TradesBuyCompact.ResetPositionIfOutOfBounds()

		Return
	
		GUI_TradesBuyCompact_Slot_Size:
			; So we can know the Slot gui height
			if (A_Gui)
				Gui%A_Gui%["Height"] := A_GuiHeight, Gui%A_Gui%["Width"] := A_GuiWidth
		Return

		GUI_TradesBuyCompact_ContextMenu:
			ctrlHwnd := Get_UnderMouse_CtrlHwnd()
			GuiControlGet, ctrlName, TradesBuyCompact:,% ctrlHwnd

			Gui_TradesBuyCompact.ContextMenu(ctrlHwnd, ctrlName)
		return

		GUI_TradesBuyCompact_Slot_ContextMenu:
			ctrlHwnd := Get_UnderMouse_CtrlHwnd()
			GuiControlGet, ctrlName, %A_Gui%:,% ctrlHwnd

			Gui_TradesBuyCompact.ContextMenu(ctrlHwnd, ctrlName)
		return
    }

	ContextMenu(CtrlHwnd, CtrlName) {
		global PROGRAM, GuiTradesBuyCompact, GuiTradesBuyCompact_Controls
		iniFile := PROGRAM.INI_FILE

		; if IsIn(CtrlHwnd, GuiTrades_Controls.hTXT_HeaderGhost "," GuiTrades_Controls.hTEXT_Title) {
		; 	try Menu, HeaderMenu, DeleteAll
		; 	Menu, HeaderMenu, Add,% PROGRAM.TRANSLATIONS.TrayMenu.LockPosition, Gui_Trades_ContextMenu_LockPosition
		; 	if (PROGRAM.SETTINGS.SETTINGS_MAIN.TradesGUI_Locked = "True")
		; 		Menu, HeaderMenu, Check,% PROGRAM.TRANSLATIONS.TrayMenu.LockPosition
		; 	Menu, HeaderMenu, Show
		; }
		; else
		; 	Menu, Tray, Show
		try Menu, RClickMenu, DeleteAll
		Menu, RClickMenu, Add,% PROGRAM.TRANSLATIONS.TrayMenu.LockPosition, Gui_TradesBuyCompact_ContextMenu_LockPosition
		Menu, RClickMenu, Add, Expand upwards?, Gui_TradesBuyCompact_ContextMenu_ExpandUpwardsToggle
		Menu, RClickMenu, Add
		Menu, RClickMenu, Add,% PROGRAM.TRANSLATIONS.GUI_Trades.RMENU_CloseAllTabs, Gui_TradesBuyCompact_ContextMenu_CloseAllTabs
		Menu, RClickMenu, Add,% PROGRAM.TRANSLATIONS.GUI_Trades.RMENU_CloseOtherTabsForSameItem, Gui_TradesBuyCompact_ContextMenu_CloseOtherTabsWithSameItem
		if (PROGRAM.SETTINGS.SETTINGS_MAIN.TradesGUI_Locked = "True")
			Menu, RClickMenu, Check,% PROGRAM.TRANSLATIONS.TrayMenu.LockPosition
		if (!GuiTradesBuyCompact.Tabs_Count)
			Menu, RClickMenu, Disable,% PROGRAM.TRANSLATIONS.GUI_Trades.RMENU_CloseAllTabs
		if RegExMatch(A_Gui, "TradesBuyCompact_Slot\d+")
			thisSlotID := RegExReplace(A_Gui, "\D")			
		else
			Menu, RClickMenu, Disable,% PROGRAM.TRANSLATIONS.GUI_Trades.RMENU_CloseOtherTabsForSameItem

		Menu, RClickMenu, Show
			
		Return

		Gui_TradesBuyCompact_ContextMenu_ExpandUpwardsToggle:
			TrayNotifications.Show("""Expand upwards""", "Feature not added yet")
			SetTimer, RemoveToolTip, -2000
		return

		Gui_TradesBuyCompact_ContextMenu_LockPosition:
			Tray_ToggleLockPosition()
		Return

		Gui_TradesBuyCompact_ContextMenu_CloseAllTabs:
			GUI_TradesBuyCompact.CloseAllTabs()
		return

		Gui_TradesBuyCompact_ContextMenu_CloseOtherTabsWithSameItem:
			GUI_TradesBuyCompact.CloseOtherTabsForSameItem(thisSlotID)
		return
	}

	Exists() {
		global GuiTradesBuyCompact
		hw := A_DetectHiddenWindows
		DetectHiddenWindows, On
		hwnd := WinExist("ahk_id " GuiTradesBuyCompact.Handle)
		DetectHiddenWindows, %hw%

		return hwnd
	}

	Enable_ClickThrough() {
		global PROGRAM, GuiTradesBuyCompact
		Gui, TradesBuyCompact: +LastFound
		WinSet, ExStyle, +0x20
		; Gui, TradesMinimized: +LastFound
		; WinSet, ExStyle, +0x20
	}

	Disable_ClickThrough() {
		global GuiTradesBuyCompact
		Gui, TradesBuyCompact: +LastFound
		WinSet, ExStyle, -0x20
		; Gui, TradesMinimized: +LastFound
		; WinSet, ExStyle, -0x20
	}

	SetTransparencyPercent(transPercent) {
		global GuiTradesBuyCompact

		if !IsNum(transPercent) {
			AppendToLogs(A_ThisFunc "(transPercent=" transPercent "): Not a number. Setting transparency to max.")
			transValue := 255
		}
		else
			transValue := (255/100)*transPercent

		Gui, TradesBuyCompact:+LastFound
		WinSet, Transparent,% transValue
		; Gui, TradesMinimized:+LastFound
		; WinSet, Transparent,% transValue
	}

	SetTransparency_Automatic() {
		global GuiTradesBuyCompact
		if (GuiTradesBuyCompact.Tabs_Count = 0)
			GUI_TradesBuyCompact.SetTransparency_Inactive()
		else
			GUI_TradesBuyCompact.SetTransparency_Active()
	}

	SetTransparency_Inactive() {
		global PROGRAM, GuiTradesBuyCompact
		transPercent := PROGRAM.SETTINGS.SETTINGS_MAIN.NoTabsTransparency
		Gui_TradesBuyCompact.SetTransparencyPercent(transPercent)
		if (transPercent = 0)
			GUI_TradesBuyCompact.Enable_ClickThrough()
	}

	SetTransparency_Active() {
		global PROGRAM, GuiTradesBuyCompact
		transPercent := PROGRAM.SETTINGS.SETTINGS_MAIN.TabsOpenTransparency
		Gui_TradesBuyCompact.SetTransparencyPercent(transPercent)
	}

	CloseAllTabs() {
		global GuiTradesBuyCompact

		Loop % GuiTradesBuyCompact.Tabs_Count {
			Gui_TradesBuyCompact.RemoveTab(A_LoopField)
		}
	}

	CloseOtherTabsForSameItem(slotID) {
		global GuiTradesBuyCompact
		
		slotInfos := Gui_TradesBuyCompact.GetSlotContent(slotID)
		slotsToLoop := GuiTradesBuyCompact.Tabs_Count
		; Parse every tab, from highest to lowest so when we close it, it doesn't affect tab order
		Loop % GuiTradesBuyCompact.Tabs_Count {
			loopedSlot := slotsToLoop
			loopedSlotInfos := Gui_TradesBuyCompact.GetSlotContent(loopedSlot)
			if (loopedSlotInfos.Item = slotInfos.Item) && (loopedSlot != slotID) {
				if (loopedSlot > slotID)
					slotsToRemoveBigger := slotsToRemoveBigger ? "," loopedSlot : loopedSlot
				else
					slotsToRemoveSmaller := slotsToRemoveSmaller ? "," loopedSlot : loopedSlot
				; AppendToLogs(A_ThisLabel ": Removed slot " loopedSlot)
			}
			slotsToLoop--
		}

		Loop, Parse, slotsToRemoveBigger,% ","
			Gui_TradesBuyCompact.RemoveTab(A_LoopField)
		Loop, Parse, slotsToRemoveSmaller,% ","
		{
			slotToDelete := A_LoopField-(A_Index-1)
			Gui_TradesBuyCompact.RemoveTab(slotToDelete)
		}
	}

	RecreateGUI(tabsLimit="") {
		global PROGRAM, GuiTradesBuyCompact
		tabsCount := GuiTradesBuyCompact.Tabs_Count
		maxTabsPerRow := GuiTradesBuyCompact.Max_Tabs_Per_Row
		tabRange := GUI_TradesBuyCompact.GetTabsRange()

		if (tabsLimit = "")
			tabsLimit := GuiTradesBuyCompact.Tabs_Limit

		firstRangeTab := tabRange.1
		Loop % tabsCount { ; Get all tabs content
			tabInfos%A_Index% := GUI_TradesBuyCompact.GetSlotContent(A_Index)
		}
		
		if (tabsLimit)
			Gui_TradesBuyCompact.Create(tabsLimit) ; Recreate GUI with more tabs
		else
			Gui_TradesBuyCompact.Create() ; No limit specific, just use default limit
		Loop % tabsCount { ; Set tabs content
			GUI_TradesBuyCompact.PushNewTab(tabInfos%A_Index%)
		}

		Loop % tabRange.2-maxTabsPerRow
			GUI_TradesBuyCompact.ScrollDown()

		if (tabsCount) {
			Gui_TradesBuyCompact.SetTransparency_Active()
			Gui_TradesBuyCompact.Disable_ClickThrough()
		}
		else  {
			Gui_TradesBuyCompact.SetTransparency_Inactive()
			if (PROGRAM.SETTINGS.SETTINGS_MAIN.AllowClicksToPassThroughWhileInactive = "True")
				Gui_TradesBuyCompact.Enable_ClickThrough()
		}
	}

	IncreaseTabsLimit() {
		global GuiTradesBuyCompact
		tabsLimit := GuiTradesBuyCompact.Tabs_Limit

		nextTabsLimit := (tabsLimit=50)?(100):(tabsLimit=100)?(150):(tabsLimit=150)?(251):("ERROR") ; Set next limit
		if (nextTabsLimit = "ERROR") {
			MsgBox(4096, "", "Error when deciding the tabs limit. Current limit: """ tabsLimit """")
			Return
		}
		
		GUI_TradesBuyCompact.RecreateGUI(nextTabsLimit)
	}

	HotBarButton(btnType) {
		global PROGRAM
		global GuiTradesBuyCompact, GuiTradesBuyCompact_Controls, LASTACTIVATED_GAMEPID

		
		if (btnType="Hideout") {
			keysState := GetKeyStateFunc("Ctrl,LCtrl,RCtrl")
			Send_GameMessage("WRITE_SEND", "/hideout", LASTACTIVATED_GAMEPID)
			SetKeyStateFunc(keysState)
		}
		else if (btnType="LeagueHelp") {
			try Menu, HelpMenu, DeleteAll
			Menu, HelpMenu, Add, Betrayal, GUI_TradesBuyCompact_LeagueHelpMenu
			Menu, HelpMenu, Add, Delve, GUI_TradesBuyCompact_LeagueHelpMenu
			Menu, HelpMenu, Add, Essence, GUI_TradesBuyCompact_LeagueHelpMenu
			Menu, HelpMenu, Add, Incursion, GUI_TradesBuyCompact_LeagueHelpMenu
			Menu, HelpMenu, Add, Heist, GUI_TradesBuyCompact_LeagueHelpMenu
			Menu, HelpMenu, Show
		}
		else {
			ShowToolTip("This button isn't implemented yet.")
			SetTimer, RemoveToolTip, -2000
		}		
		return

		GUI_TradesBuyCompact_LeagueHelpMenu:
			which := A_ThisMenuItem="Betrayal"?"Betrayal"
				: A_ThisMenuItem="Delve"?"Delve"
				: A_ThisMenuItem="Essence"?"Essence"
				: A_ThisMenuItem="Incursion"?"Incursion"
				: A_ThisMenuItem="Heist"?"Heist"
				: ""
			if (!which)
				return
 
			GUI_CheatSheet.Show(which)
		return
	}

	DoTradeButtonAction(slotNum, btnType) {
		global PROGRAM
		global GuiTradesBuyCompact, GuiTradesBuyCompact_Controls
		static uniqueNum

		if !IsNum(slotNum)
			Return
			
		slotContent := Gui_TradesBuyCompact.GetSlotContent(slotNum)
		tabPID := slotContent.PID

		if WinExist("ahk_group POEGameGroup ahk_pid " tabPID) {
			uniqueNum := !uniqueNum
			keysState := GetKeyStateFunc("Ctrl,LCtrl,RCtrl")

			actionType := btnType="WhisperSeller" ? "WRITE_MSG"
				: btnType="HideoutSeller" ? "SEND_MSG"
				: btnType="KickSelfSeller" ? "KICK_MYSELF"
				: btnType="ThankSeller" ? "SEND_MSG"
				: ""
			
			actionContent := btnType="WhisperSeller" ? "@%seller% "
				: btnType="HideoutSeller" ? "/hideout %seller%"
				: btnType="KickSelfSeller" ? "/kick %myself%"
				: btnType="ThankSeller" ? "@%seller% ty!"
				: ""

			actionContent := StrReplace(actionContent, "%seller%", slotContent.Seller)

			if (actionType)
				Do_Action(actionType, actionContent)
			SetKeyStateFunc(keysState)

			if (btnType="ThankSeller") {
				GUI_TradesBuyCompact.SaveStats(slotNum)
				GUI_TradesBuyCompact.RemoveTab(slotNum)
			}
			
			
		}
		; else { ; Instance doesn't exist anymore, replace and do btn action
		; 	runningInstances := Get_RunningInstances()
		; 	if !(runningInstances.Count) {
		; 		TrayNotifications.Show(PROGRAM.TRANSLATIONS.TrayNotifications.NoGameInstanceFound_Title, PROGRAM.TRANSLATIONS.TrayNotifications.NoGameInstanceFound_Msg)
		; 		Return
		; 	}
		; 	newInstancePID := GUI_ChooseInstance.Create(runningInstances, "PID").PID

		; 	Loop % GuiTrades.Tabs_Count {
		; 		loopTabContent := GuiTradesBuyCompact.GetTabContent(A_Index)
		; 		loopTabPID := loopTabContent.PID

		; 		if (loopTabPID = tabPID)
		; 			GuiTradesBuyCompact.UpdateSlotContent(A_Index, "PID", newInstancePID)
		; 	}
		; 	GuiTradesBuyCompact.DoTradeButtonAction(btnNum, btnType)
		; }
	}

	SaveStats(slotNum) {
		global PROGRAM, DEBUG
		iniFile := PROGRAM.TRADES_HISTORY_BUY_FILE

		slotContent := GUI_TradesBuyCompact.GetSlotContent(slotNum)

		; if (DEBUG.settings.use_chat_logs || slotContent.Seller = "iSellStuff") {
		; 	TrayNotifications.Show(PROGRAM.TRANSLATIONS.TrayNotifications.iSellStuffNotSaved_Title, PROGRAM.TRANSLATIONS.TrayNotifications.iSellStuffNotSaved_Msg)
		; 	Return
		; }

		index := INI.Get(iniFile, "GENERAL", "Index")
		index := IsNum(index) ? index : 0

		index++
		; existsAlready := INI.Get(iniFile, index, "Buyer")
		; existsAlready := existsAlready = "ERROR" || existsAlready = "" ? False : True
		; if (existsAlready = True) {
		; 	trayTxt := StrReplace(PROGRAM.TRANSLATIONS.TrayNotifications.ErrorSavingStatsSameIDExists_Msg, "%number%", index)
		; 	TrayNotifications.Show(PROGRAM.TRANSLATIONS.TrayNotifications.ErrorSavingStatsSameIDExists_Title, trayTxt)
		; 	Loop {
		; 		index++
		; 		existsAlready := INI.Get(iniFile, index, "Buyer")
		; 		if (existsAlready = "ERROR" || existsAlready = "")
		; 			Break
		; 	}
		; 	TrayNotifications.Show(PROGRAM.TRANSLATIONS.TrayNotifications.ErrorSavingStatsSameIDExists_Solved_Title, PROGRAM.TRANSLATIONS.TrayNotifications.ErrorSavingStatsSameIDExists_Solved_Msg)
		; }
		INI.Set(iniFile, "GENERAL", "Index", index)

		value := StrReplace(value, "`n", "\n"), value := StrReplace(value, "`r", "\n")
		INI.Set(iniFile, index, key, value)
	}

	GenerateUniqueID() {
		return RandomStr(l := 24, i := 48, x := 122)
	}

	Minimize() {
		global GuiTradesBuyCompact, GuiTradesBuyCompact_Controls
		global PROGRAM

		windowsDPI := GuiTradesBuyCompact.Windows_DPI

		hiddenWin := A_DetectHiddenWindows
		DetectHiddenWindows, On
		WinMove,% "ahk_id " GuiTradesBuyCompact.Handle, , , , ,% GuiTradesBuyCompact.Height_Minimized * windowsDPI
		DetectHiddenWindows, %hiddenWin%

		GuiControl, TradesBuyCompact:Show,% GuiTradesBuyCompact_Controls.hBTN_Maximize
		GuiControl, TradesBuyCompact:Hide,% GuiTradesBuyCompact_Controls.hBTN_Minimize

		GuiControl, TradesBuyCompact:Show,% GuiTradesBuyCompact_Controls.hPROGRESS_BorderBottom_1
		; GuiControl, TradesBuyCompact:Hide,% GuiTradesBuyCompact_Controls.hPROGRESS_BorderBottom

		GuiTradesBuyCompact.Is_Maximized := False
		GuiTradesBuyCompact.Is_Minimized := True

		GUI_TradesBuyCompact.ResetPositionIfOutOfBounds()
		; GUI_Trades.ToggleTabSpecificAssets("Off")
		; TO_DO Possibly hide tabs to avoid overlap on border?
	}

	Maximize() {
		global GuiTradesBuyCompact, GuiTradesBuyCompact_Controls
		global PROGRAM

		windowsDPI := GuiTradesBuyCompact.Windows_DPI

		hiddenWin := A_DetectHiddenWindows
		DetectHiddenWindows, On
		WinMove,% "ahk_id " GuiTradesBuyCompact.Handle, , , , ,% GuiTradesBuyCompact.Height_Maximized * windowsDPI ; change size first to avoid btn flicker
		DetectHiddenWindows, %hiddenWin%

		GuiControl, TradesBuyCompact:Show,% GuiTradesBuyCompact_Controls.hBTN_Minimize
		GuiControl, TradesBuyCompact:Hide,% GuiTradesBuyCompact_Controls.hBTN_Maximize

		; GuiControl, TradesBuyCompact:Show,% GuiTradesBuyCompact_Controls.hPROGRESS_BorderBottom
		GuiControl, TradesBuyCompact:Hide,% GuiTradesBuyCompact_Controls.hPROGRESS_BorderBottom_1

		GuiTradesBuyCompact.Is_Maximized := True
		GuiTradesBuyCompact.Is_Minimized := False

		GUI_TradesBuyCompact.ResetPositionIfOutOfBounds()
		; GUI_Trades.ToggleTabSpecificAssets("On")
	}

	SetFakeSearch(makeEmpty=False) {
		global SKIN, GuiTradesBuyCompact, GuiTradesBuyCompact_Controls

		GuiControlGet, search, TradesBuyCompactSearchHidden:,% GuiTradesBuyCompact_Controls.hEDIT_HiddenSearchBar
		if (search!="") {
			GuiControl,% "TradesBuyCompact: +c" SKIN.Compact.Settings.COLORS.SearchBar_NotEmpty,% GuiTradesBuyCompact_Controls.hTEXT_SearchBarFake
			GuiControl, TradesBuyCompact:,% GuiTradesBuyCompact_Controls.hTEXT_SearchBarFake,% search
		}
		else {
			GuiControl,% "TradesBuyCompact: +c" SKIN.Compact.Settings.COLORS.SearchBar_Empty,% GuiTradesBuyCompact_Controls.hTEXT_SearchBarFake
			GuiControl, TradesBuyCompact:,% GuiTradesBuyCompact_Controls.hTEXT_SearchBarFake,% "..."
		}

		if (makeEmpty=True) {
			GuiControl,% "TradesBuyCompact: +c" SKIN.Compact.Settings.COLORS.SearchBar_Empty,% GuiTradesBuyCompact_Controls.hTEXT_SearchBarFake
			GuiControl, TradesBuyCompactSearchHidden:,% GuiTradesBuyCompact_Controls.hEDIT_HiddenSearchBar,% ""
			GuiControl, TradesBuyCompact:,% GuiTradesBuyCompact_Controls.hTEXT_SearchBarFake,% "..."
		}

		SetTimer, GUI_TradesBuyCompact_Search, -500
	}

	Search() {
		/*	Starting a search will look through tabs to find match
			Any matching tab will be added to the list
			Once done, replace all tabs with matches

			TO_DO solution when sending whisper with search box still with text
		*/
		global GuiTradesBuyCompact, GuiTradesBuyCompact_Controls

		GuiControlGet, search, ,% GuiTradesBuyCompact_Controls.hEDIT_HiddenSearchBar
		
		matches := 0
		if (search != "") {		
			contents := {}
			Loop % GuiTradesBuyCompact.Tabs_Count {
				content := GuiTradesBuyCompact["Tab" A_Index "Content"]
				if IsContaining(content.Seller, search) || IsContaining(content.Item, search)
					contents[matches+1] := content, matches++
			}
			if (matches) {
				ShowToolTip("""" search """`n" matches " matches found")
				SetTimer, RemoveToolTip, -2000
				Loop % GuiTradesBuyCompact.Tabs_Count
					GUI_TradesBuyCompact.SetSlotContent(A_Index, "")
				Loop % matches
					GUI_TradesBuyCompact.SetSlotContent(A_Index, contents[A_Index])
			}
			else {
				ShowToolTip("""" search """`nNo matches found")
				SetTimer, RemoveToolTip, -2000
			}
		}
		else {
			Loop % GuiTradesBuyCompact.Tabs_Count {
				GUI_TradesBuyCompact.SetSlotContent(A_Index, GuiTradesBuyCompact["Tab" A_Index "Content"])
			}
		}
		GUI_TradesBuyCompact.Redraw()
	}

	RemoveTab(slotNum) {
		global PROGRAM, SKIN
		global GuiTradesBuyCompact, GuiTradesBuyCompact_Controls

		tabsCount := GuiTradesBuyCompact.Tabs_Count
		tabsRange := GUI_TradesBuyCompact.GetRange()
		; GUI_TradesBuyCompact.SetSlotContent(slotNum, "", "", "", "", "")
		if (slotNum < tabsCount) {
			tabIndex := slotNum+1
			Loop % tabsCount-slotNum {
				tabContent := GUI_TradesBuyCompact.GetSlotContent(tabIndex) ; Get tab content
				GuiTradesBuyCompact["Tab" tabIndex-1 "Content"] := tabContent
				GUI_TradesBuyCompact.SetSlotContent(tabIndex-1, tabContent) ; Set tab content to previous tab
				tabIndex++
			}
			GUI_TradesBuyCompact.SetSlotContent(tabIndex-1, "") ; Make last tab empty
			GuiTradesBuyCompact["Tab" tabIndex-1 "Content"] := {}
			; GUI_TradesBuyCompact.SetTabStyleDefault(tabIndex-1)
		}
		else if (slotNum = tabsCount) {
			GUI_TradesBuyCompact.SetSlotContent(slotNum, "")
			GuiTradesBuyCompact["Tab" slotNum "Content"] := {}
			; GUI_TradesBuyCompact.SetTabStyleDefault(slotNum)
		}

		; Move tabs if needed
		if (tabsRange.2 = tabsCount) {
			GUI_TradesBuyCompact.ScrollUp()
		}

		GuiTradesBuyCompact.Tabs_Count := GuiTradesBuyCompact.Tabs_Count<=0?0:GuiTradesBuyCompact.Tabs_Count-1

		GuiTradesBuyCompact.Height_Maximized := guiHeight := GuiTradesBuyCompact.Tabs_Count = 0 ? GuiTradesBuyCompact.Height_NoRow
			: GuiTradesBuyCompact.Tabs_Count = 1 ? GuiTradesBuyCompact.Height_OneRow
			: GuiTradesBuyCompact.Tabs_Count = 2 ? GuiTradesBuyCompact.Height_TwoRow
			: GuiTradesBuyCompact.Tabs_Count = 3 ? GuiTradesBuyCompact.Height_ThreeRow
			: GuiTradesBuyCompact.Tabs_Count >= 4 ? GuiTradesBuyCompact.Height_FourRow
			: GuiTradesBuyCompact.Height_FourRow

		if (GuiTradesBuyCompact.Tabs_Count = 0) {
			GuiControl,TradesBuyCompact:,% GuiTradesBuyCompact_Controls["hTEXT_Title"],% PROGRAM.NAME
			; GuiControl,TradesMinimized:,% GuiTradesMinimized_Controls["hTEXT_Title"],% "(0)"
			GuiControl,% "TradesBuyCompact: +c" SKIN.Compact.Settings.COLORS.Title_No_Trades,% GuiTradesBuyCompact_Controls["hTEXT_Title"]
			; GuiControl,% "TradesMinimized: +c" SKIN.Compact.Settings.COLORS.Title_No_Trades,% GuiTradesMinimized_Controls["hTEXT_Title"]
			if (PROGRAM.SETTINGS.SETTINGS_MAIN.AllowClicksToPassThroughWhileInactive = "True")
				Gui_TradesBuyCompact.Enable_ClickThrough()
			; if (PROGRAM.SETTINGS.SETTINGS_MAIN.AutoMinimizeOnAllTabsClosed = "True")
				; Gui_Trades.Minimize("True")
			Gui_TradesBuyCompact.SetTransparency_Inactive()
			Gui_TradesBuyCompact.Redraw()
		}
		else {
			GuiControl,TradesBuyCompact:,% GuiTradesBuyCompact_Controls["hTEXT_Title"],% PROGRAM.NAME " (" GuiTradesBuyCompact.Tabs_Count ")"
			; GuiControl,TradesBuyCompact:,% GuiTradesMinimized_Controls["hTEXT_Title"],% "(" GuiTrades.Tabs_Count ")"
		}

		Gui.Show("TradesBuyCompact", "h" guiHeight " NoActivate")
	}

	IsTabAlreadyExisting(contentInfos) {
		global GuiTradesBuyCompact, GuiTradesBuyCompact_Controls

		Loop % GuiTradesBuyCompact.Tabs_Count {
			loopedcontentInfos := GUI_TradesBuyCompact.GetSlotContent(A_Index)
			if (contentInfos.Seller = loopedcontentInfos.Seller)
			&& (contentInfos.Item = loopedcontentInfos.Item)
			&& (contentInfos.Price = loopedcontentInfos.Price)
			&& (contentInfos.Currency = loopedcontentInfos.Currency)
			&& (contentInfos.Stash = loopedcontentInfos.Stash)
				Return A_Index
		}
	}

	PushNewTab(infos) {
		global PROGRAM, SKIN
		global GuiTradesBuyCompact, GuiTradesBuyCompact_Controls
		static doOnlyOnce

		if (PROGRAM.SETTINGS.SETTINGS_MAIN.DisableBuyInterface="True")
			return
			
		tabsLimit := GuiTradesBuyCompact.Tabs_Limit
		tabsCount := GuiTradesBuyCompact.Tabs_Count

		hadNoTab := tabsCount = 0 ? True : False

		existingTabID := GUI_TradesBuyCompact.IsTabAlreadyExisting(infos)
		if (existingTabID) {
			; Gui_Trades.UpdateSlotContent(existingTabID, "Other", contentInfos.Other) ; Disabled. Useless?
			Return "TabAlreadyExists"
		}
		
		; Need to allocate more tabs
		if (tabsCount+1 >= tabsLimit) {
			GUI_TradesBuyCompact.IncreaseTabsLimit()
		}

		GUI_TradesBuyCompact.SetSlotContent(tabsCount+1, infos)
		GUI_TradesBuyCompact.SetSlotPosition(tabsCount+1, tabsCount+1)
		GuiTradesBuyCompact["Tab" tabsCount+1 "Content"] := infos

		GuiTradesBuyCompact.Tabs_Count := GuiTradesBuyCompact.Tabs_Count<0?1:GuiTradesBuyCompact.Tabs_Count+1

		if (hadNoTab) {
			; if (PROGRAM.SETTINGS.SETTINGS_MAIN.AutoMaximizeOnFirstNewTab = "True")
			GUI_TradesBuyCompact.Maximize()
		}

		if (doOnlyOnce != False) {
			Gui, TradesBuyCompactSearch:Show, NoActivate
			doOnlyOnce := True
		}

		if (GuiTradesBuyCompact.Tabs_Count > 0) {
			GuiControl,TradesBuyCompact:,% GuiTradesBuyCompact_Controls["hTEXT_Title"],% PROGRAM.NAME " (" GuiTradesBuyCompact.Tabs_Count ")"
			; GuiControl,TradesMinimized:,% GuiTradesMinimized_Controls["hTEXT_Title"],% "(" GuiTrades.Tabs_Count ")"
			GuiControl,% "TradesBuyCompact: +c" SKIN.Compact.Settings.COLORS.Title_Trades,% GuiTradesBuyCompact_Controls["hTEXT_Title"]
			; GuiControl,% "TradesMinimized: +c" SKIN.Compact.Settings.COLORS.Title_Trades,% GuiTradesMinimized_Controls["hTEXT_Title"]
			Gui_TradesBuyCompact.SetTransparency_Active()
			Gui_TradesBuyCompact.Disable_ClickThrough()
			Gui_TradesBuyCompact.Redraw()
		}

		GuiTradesBuyCompact.Height_Maximized := guiHeight := GuiTradesBuyCompact.Tabs_Count = 0 ? GuiTradesBuyCompact.Height_NoRow
			: GuiTradesBuyCompact.Tabs_Count = 1 ? GuiTradesBuyCompact.Height_OneRow
			: GuiTradesBuyCompact.Tabs_Count = 2 ? GuiTradesBuyCompact.Height_TwoRow
			: GuiTradesBuyCompact.Tabs_Count = 3 ? GuiTradesBuyCompact.Height_ThreeRow
			: GuiTradesBuyCompact.Tabs_Count >= 4 ? GuiTradesBuyCompact.Height_FourRow
			: GuiTradesBuyCompact.Height_FourRow


		GuiTradesBuyCompact.Height_Maximized := guiHeight

		Gui.Show("TradesBuyCompact", "h" guiHeight " NoActivate")
	}

	GetSlotContent(slotNum) {
		global GuiTradesBuyCompact, GuiTradesBuyCompact_Controls

		GuiControlGet, hiddenInfosWall, ,% GuiTradesBuyCompact["Slot" slotNum "_Controls"].hTEXT_HiddenInfos

		hiddenInfosArr := {}
		Loop, Parse, hiddenInfosWall, `n, `r
		{
			if RegExMatch(A_LoopField, "O)Seller:" A_Tab "(.*)", sellerPat)
				hiddenInfosArr.Seller := sellerPat.1
			else if RegExMatch(A_LoopField, "O)Item:" A_Tab "(.*)", itemPat)
				hiddenInfosArr.Item := itemPat.1
			else if RegExMatch(A_LoopField, "O)Price:" A_Tab "(.*)", pricePat)
				hiddenInfosArr.Price := pricePat.1
			else if RegExMatch(A_LoopField, "O)Currency:" A_Tab "(.*)", currencyPat)
				hiddenInfosArr.Currency := currencyPat.1
			else if RegExMatch(A_LoopField, "O)Stash:" A_Tab "(.*)", stashPat)
				hiddenInfosArr.Stash := stashPat.1
			else if RegExMatch(A_LoopField, "O)TimeSent:" A_Tab "(.*)", timeSentPat)
				hiddenInfosArr.TimeSent := timeSentPat.1
			else if RegExMatch(A_LoopField, "O)ItemIsCut:" A_Tab "(.*)", itemIsCutPat)
				hiddenInfosArr.ItemIsCut := itemIsCutPat.1
			else if RegExMatch(A_LoopField, "O)SellerIsCut:" A_Tab "(.*)", sellerIsCutPat)
				hiddenInfosArr.SellerIsCut := sellerIsCutPat.1
			else if RegExMatch(A_LoopField, "O)TimeStamp:" A_Tab "(.*)", timeStampPat)
				hiddenInfosArr.TimeStamp := timeStampPat.1
			else if RegExMatch(A_LoopField, "O)PID:" A_Tab "(.*)", pidPat)
				hiddenInfosArr.PID := pidPat.1
			else if RegExMatch(A_LoopField, "O)ItemName:" A_Tab "(.*)", itemNamePat)
				hiddenInfosArr.ItemName := itemNamePat.1
			else if RegExMatch(A_LoopField, "O)ItemLevel:" A_Tab "(.*)", itemLevelPat)
				hiddenInfosArr.ItemLevel := itemLevelPat.1
			else if RegExMatch(A_LoopField, "O)ItemQuality:" A_Tab "(.*)", itemQualityPat)
				hiddenInfosArr.ItemQuality := itemQualityPat.1
			else if RegExMatch(A_LoopField, "O)StashLeague:" A_Tab "(.*)", stashLeaguePat)
				hiddenInfosArr.StashLeague := stashLeaguePat.1
			else if RegExMatch(A_LoopField, "O)StashTab:" A_Tab "(.*)", stashTabPat)
				hiddenInfosArr.StashTab := stashTabPat.1
			else if RegExMatch(A_LoopField, "O)StashPosition:" A_Tab "(.*)", stashPositionPat)
				hiddenInfosArr.StashPosition := stashPositionPat.1
			else if RegExMatch(A_LoopField, "O)TimeYear:" A_Tab "(.*)", timeYearPat)
				hiddenInfosArr.TimeYear := timeYearPat.1
			else if RegExMatch(A_LoopField, "O)TimeMonth:" A_Tab "(.*)", timeMonthPat)
				hiddenInfosArr.TimeMonth := timeMonthPat.1
			else if RegExMatch(A_LoopField, "O)TimeDay:" A_Tab "(.*)", timeDayPat)
				hiddenInfosArr.TimeDay := timeDayPat.1
			else if RegExMatch(A_LoopField, "O)TimeHour:" A_Tab "(.*)", timeHourPat)
				hiddenInfosArr.TimeHour := timeHourPat.1
			else if RegExMatch(A_LoopField, "O)TimeMinute:" A_Tab "(.*)", timeMinPat)
				hiddenInfosArr.TimeMinute := timeMinPat.1
			else if RegExMatch(A_LoopField, "O)TimeSecond:" A_Tab "(.*)", timeSecPat)
				hiddenInfosArr.TimeSecond := timeSecPat.1
			else if RegExMatch(A_LoopField, "O)UniqueID:" A_Tab "(.*)", uniqueIDPat)
				hiddenInfosArr.UniqueID := uniqueIDPat.1
			else if RegExMatch(A_LoopField, "O)WhisperSite:" A_Tab "(.*)", whisperSitePat)
				hiddenInfosArr.WhisperSite := whisperSitePat.1
			else if RegExMatch(A_LoopField, "O)WhisperLang:" A_Tab "(.*)", whisperLangPat)
				hiddenInfosArr.WhisperLang := whisperLangPat.1
			else if RegExMatch(A_LoopField, "O)AdditionalMsg:" A_Tab "(.*)", addMsgPat)
				hiddenInfosArr.AdditionalMsg := addMsgPat.1
			else if RegExMatch(A_LoopField, "O)AdditionalMsgFull:" A_Tab "(.*)", addMsgFullPat) {
				hiddenInfosArr.AdditionalMsgFull := StrReplace(addMsgFullPat.1, "`n", "\n")
				hiddenInfosArr.AdditionalMsgFull := StrReplace(hiddenInfosArr.AdditionalMsgFull, "`r", "\n")
			}
		}

		slotContent := {}
		for key, value in hiddenInfosArr
			slotContent[key] := value

		return slotContent
	}

	SetSlotContent(slotNum, contentInfos, isNewlyPushed=False, updateOnly=False) {
		; Set the content of the Slot gui, increase tab count
		global PROGRAM
		global GuiTradesBuyCompact, GuiTradesBuyCompact_Controls

		windowsDPI := GuiTradesBuyCompact.Windows_DPI
		cSlotCont := GUI_TradesBuyCompact.GetSlotContent(slotNum)

		; Parsing infos
		newTabSeller 		:= updateOnly && !contentInfos.Seller ? cSlotCont.Seller : contentInfos.Seller
		newTabItem 			:= updateOnly && !contentInfos.Item ? cSlotCont.Item : contentInfos.Item
		newTabPrice 		:= updateOnly && !contentInfos.Price ? cSlotCont.Price : contentInfos.Price
		newTabStash 		:= updateOnly && !contentInfos.Stash ? cSlotCont.Stash : contentInfos.Stash
		newTabAddMsgFull	:= updateOnly && !contentInfos.AdditionalMsgFull ? cSlotCont.AdditionalMsgFull : contentInfos.AdditionalMsgFull
		newTabAddMsgFull	:= StrReplace(newTabAddMsgFull, "`n", "\n"), newTabAddMsgFull := StrReplace(newTabAddMsgFull, "`r", "\n")
		newTabAddMsg 		:= RegExMatch( StrSplit(newTabAddMsgFull, "\n").1 , "O)\[\d+\:\d+\] \@(?:To|From)\: (.*)", outPat), newTabAddMsg := outPat.1
		newTabTimeStamp 	:= updateOnly && !contentInfos.TimeStamp ? cSlotCont.TimeStamp : contentInfos.TimeStamp
		newTabTimeSent 		:= updateOnly && !contentInfos.TimeSent ? cSlotCont.TimeSent : contentInfos.TimeSent
		newTabCurrency		:= updateOnly && !contentInfos.Currency ? cSlotCont.Currency : contentInfos.Currency

		if RegExMatch(newTabStash, "O)(.*)\(Tab:(.*) / Pos:(.*)\)", newTabStashPat)
			stashLeague := newTabStashPat.1, stashTab := newTabStashPat.2, stashPosition := newTabStashPat.3
		else
			stashLeague := newTabStash

		if RegExMatch(newTabItem, "O)(.*)\(Lvl:(.*) / Qual:(.*)\)", itemPat) ; quality gem, get only gem name
			itemName := itemPat.1, itemLevel := itemPat.2, itemQuality := itemPat.3
		else if RegExMatch(newTabItem, "O)(.*)\(T(\d+)\)", itemPat) ; map item, get only map name
			itemName := itemPat.1, itemLevel := itemPat.2
		else
			itemName := newTabItem

		if RegExMatch(newTabTimeStamp, "O)(.*)/(.*)/(.*) (.*):(.*):(.*)", timeStampPat) {
			timeYear := timeStampPat.1, timeMonth := timeStampPat.2, timeDay := timeStampPat.3
			timeHour := timeStampPat.4, timeMin := timeStampPat.5, timeSec := timeStampPat.6
		}

		newTabItemName := updateOnly && !contentInfos.ItemName ? cSlotCont.ItemName : itemName
		newTabItemLevel := updateOnly && !contentInfos.ItemLevel ? cSlotCont.ItemLevel : itemLevel
		newTabItemQuality := updateOnly && !contentInfos.ItemQuality ? cSlotCont.ItemQuality : itemQuality
		newTabStashLeague := updateOnly && !contentInfos.StashLeague ? cSlotCont.StashLeague : stashLeague
		newTaStashTab := updateOnly && !contentInfos.StashTab ? cSlotCont.StashTab : stashTab
		newTabStashPosition := updateOnly && !contentInfos.StashPosition ? cSlotCont.StashPosition : stashPosition
		newTabUniqueID := updateOnly && !contentInfos.UniqueID ? cSlotCont.UniqueID : contentInfos.UniqueID
		newWhisperSite := updateOnly && !contentInfos.WhisperSite ? cSlotCont.WhisperSite : contentInfos.WhisperSite
		newWhisperLang := updateOnly && !contentInfos.WhisperLang ? cSlotCont.WhisperLang : contentInfos.WhisperLang
		newTabPID := updateOnly && !contentInfos.PID ? cSlotCont.PID : contentInfos.PID

		AutoTrimStr(newTabSeller, newTabItem, newTabPrice, newTabStash, newTabAddMsg, newTabTimeStamp, newTabPID)
		AutoTrimStr(newTabItemName, newTabItemLevel, newTabItemQuality, newTabStashLeague, newTabStashTab, newTabStashPosition)
		AutoTrimStr(newTabUniqueID, newWhisperSite, newWhisperLang, newTabTimeSent, newTabCurrency, newTabAddMsgFull)

		; Setting invisible wall of infos
		hiddenInfosWall := ""
		.		"Seller:"	 		A_Tab newTabSeller
		. "`n"	"Item:"		 		A_Tab newTabItem
		. "`n"	"Price:"			A_Tab newTabPrice
		. "`n"	"Currency:"			A_Tab newTabCurrency
		. "`n"	"Stash:"			A_Tab newTabStash
		. "`n"	"AdditionalMsg:"	A_Tab newTabAddMsg
		. "`n"	"AdditionalMsgFull:" A_Tab newTabAddMsgFull
		. "`n"	"TimeSent:"			A_Tab newTabTimeSent
		. "`n" 	"TimeStamp:"		A_Tab newTabTimeStamp
		. "`n" 	"PID:"				A_Tab newTabPID
		. "`n"	"ItemName:"			A_Tab newTabItemName
		. "`n"	"ItemLevel:"		A_Tab newTabItemLevel
		. "`n"	"ItemQuality:"		A_Tab newTabItemQuality
		. "`n"	"StashLeague:"		A_Tab newTabStashLeague
		. "`n"	"StashTab:"			A_Tab newTaStashTab
		. "`n"	"StashPosition:"	A_Tab newTabStashPosition
		. "`n"	"TimeYear:"			A_Tab timeYear
		. "`n"	"TimeMonth:"		A_Tab timeMonth
		. "`n"	"TimeDay:"			A_Tab timeDay
		. "`n"	"TimeHour:"			A_Tab timeHour
		. "`n"	"TimeMinute:"		A_Tab timeMin
		. "`n"	"TimeSecond:"		A_Tab timeSec
		. "`n"	"UniqueID:"			A_Tab newTabUniqueID
		. "`n"	"WhisperSite:"		A_Tab newWhisperSite
		. "`n" 	"WhisperLang:"		A_Tab newWhisperLang

		; Making sure price count isn't too long
		priceW := Get_TextCtrlSize(newTabPrice, GuiTradesBuyCompact.Font, GuiTradesBuyCompact.FontSize, "", "R1").W
		if (priceW >= GuiTradesBuyCompact.PriceTxt_MaxW)
			priceW := GuiTradesBuyCompact.PriceTxt_MaxW

		; Trim string based on size
		itemSlotSizeMax := Get_ControlCoords("TradesBuyCompact_Slot" slotNum, GuiTradesBuyCompact["Slot" slotNum "_Controls"].hTEXT_ItemName).W
		newItemTxtSize := Get_TextCtrlSize(txt:=newTabItem, fontName:=GuiTradesBuyCompact.Font, fontSize:=GuiTradesBuyCompact.Font_Size).W
		buyerSlotSizeMax := Get_ControlCoords("TradesBuyCompact_Slot" slotNum, GuiTradesBuyCompact["Slot" slotNum "_Controls"].hTEXT_SellerName).W
		newBuyerTxtSize := Get_TextCtrlSize(txt:=newTabSeller, fontName:=GuiTradesBuyCompact.Font, fontSize:=GuiTradesBuyCompact.Font_Size).W

		if (newItemTxtSize >= itemSlotSizeMax-10) {	
			cutStr := newTabItem
			Loop % Ceil( StrLen(newTabItem)/3 ) {
				StringTrimRight, cutStr, cutStr, 3
				newSize := Get_TextCtrlSize(txt:=cutStr "...", fontName:=GuiTradesBuyCompact.Font, fontSize:=GuiTradesBuyCompact.Font_Size).W
				if !(newSize >= itemSlotSizeMax-10)
					Break
			}
			newTabItem := cutStr "..."
			hiddenInfosWall .= "`n" "ItemIsCut:"		A_Tab True
		}
		else
			hiddenInfosWall .= "`n" "ItemIsCut:"		A_Tab False

		if (newBuyerTxtSize >= buyerSlotSizeMax) {	
			cutStr := newTabSeller
			Loop % Ceil( StrLen(newTabSeller)/3 ) {
				StringTrimRight, cutStr, cutStr, 3
				newSize := Get_TextCtrlSize(txt:=cutStr "...", fontName:=GuiTradesBuyCompact.Font, fontSize:=GuiTradesBuyCompact.Font_Size).W
				if !(newSize >= buyerSlotSizeMax)
					Break
			}
			newTabSeller := cutStr "..."
			hiddenInfosWall .= "`n" "SellerIsCut:"		A_Tab True
		}
		else
			hiddenInfosWall .= "`n" "SellerIsCut:"		A_Tab False

		; Setting content
		GuiControl, ,% GuiTradesBuyCompact["Slot" slotNum "_Controls"].hTEXT_HiddenInfos,% hiddenInfosWall
		GuiControl, ,% GuiTradesBuyCompact["Slot" slotNum "_Controls"].hTEXT_ItemName,% newTabItem
		GuiControl, ,% GuiTradesBuyCompact["Slot" slotNum "_Controls"].hTEXT_SellerName,% newTabSeller
		GuiControl, ,% GuiTradesBuyCompact["Slot" slotNum "_Controls"].hTEXT_PriceCount,% newTabPrice
		GuiControl, ,% GuiTradesBuyCompact["Slot" slotNum "_Controls"].hTEXT_TimeSent,% newTabTimeSent
		
		; Set price count width
		GuiControl, Move,% GuiTradesBuyCompact["Slot" slotNum "_Controls"].hTEXT_PriceCount,% "w" priceW*windowsDPI

		; Move AdditionalMsg msg based on price count pos
		ControlGetPos, x, y, w, h,,% "ahk_id " GuiTradesBuyCompact["Slot" slotNum "_Controls"].hTEXT_PriceCount
		ControlGetPos, x2, y2, w2, h2,,% "ahk_id " GuiTradesBuyCompact["Slot" slotNum "_Controls"].hBTN_WhisperSeller
		GuiControl, Move,% GuiTradesBuyCompact["Slot" slotNum "_Controls"].hTEXT_AdditionalMsg,% "x" (x+w+10)/windowsDPI " w" (x2-( x+w+10 )-10)/windowsDPI

		addMsgSlotSizeMax := Get_ControlCoords("TradesBuyCompact_Slot" slotNum, GuiTradesBuyCompact["Slot" slotNum "_Controls"].hTEXT_AdditionalMsg).W
		newAddMsgTxtSize := Get_TextCtrlSize(txt:=newTabAddMsg, fontName:=GuiTradesBuyCompact.Font, fontSize:=GuiTradesBuyCompact.Font_Size).W
		if (newAddMsgTxtSize >= addMsgSlotSizeMax) {	
			cutStr := newTabAddMsg
			Loop % Ceil( StrLen(newTabAddMsg)/3 ) {
				StringTrimRight, cutStr, cutStr, 3
				newSize := Get_TextCtrlSize(txt:=cutStr "...", fontName:=GuiTradesBuyCompact.Font, fontSize:=GuiTradesBuyCompact.Font_Size).W
				if !(newSize >= addMsgSlotSizeMax)
					Break
			}
			newTabAddMsg := cutStr "..."
		}
		GuiControl, ,% GuiTradesBuyCompact["Slot" slotNum "_Controls"].hTEXT_AdditionalMsg,% newTabAddMsg

		; Set currency IMG
		if (newTabCurrency != cSlotCont.Currency) {
			if (newTabCurrency = "") {
				GuiControl, ,% GuiTradesBuyCompact["Slot" slotNum "_Controls"].hIMG_CurrencyIMG,% newTabCurrency
			}
			else {
				if FileExist(PROGRAM.CURRENCY_IMGS_FOLDER "\" newTabCurrency ".png")
					currencyPngFile := PROGRAM.CURRENCY_IMGS_FOLDER "\" newTabCurrency ".png"
				else 
					currencyPngFile := PROGRAM.CURRENCY_IMGS_FOLDER "\Unknown.png"

				coords := Get_ControlCoords("TradesBuyCompact_Slot" slotNum, GuiTradesBuyCompact["Slot" slotNum "_Controls"].hIMG_CurrencyIMG)
				imgSlot_W := coords.W, imgSlot_H := coords.H
				
				hBitMap := Gdip_CreateResizedHBITMAP_FromFile(currencyPngFile, imgSlot_W*windowsDPI, imgSlot_H*windowsDPI, PreserveAspectRatio:=False)
				SetImage(GuiTradesBuyCompact["Slot" slotNum "_Controls"].hIMG_CurrencyIMG, hBitmap)
			}
			GuiControl, Hide,% GuiTradesBuyCompact["Slot" slotNum "_Controls"].hIMG_CurrencyIMG ; basically "redraw", fixes old pic still there behind
			GuiControl, Show,% GuiTradesBuyCompact["Slot" slotNum "_Controls"].hIMG_CurrencyIMG
		}
	}

	UpdateSlotContent(slotNum, slotName, newContent) {
		global GuiTrades_Controls

		if !IsNum(slotNum) {
			AppendToLogs(A_ThisFunc "(slotNum=" tabID ")): tabID is not a number.")
			return
		}

		slotContent := GUI_TradesBuyCompact.GetSlotContent(slotNum)
		if (slotName = "AdditionalMsgFull") {
			mergedCurrendAndNew := slotContent.AdditionalMsgFull?slotContent.AdditionalMsgFull "\n" newContent : newContent
			GUI_TradesBuyCompact.SetSlotContent(slotNum, {AdditionalMsgFull:mergedCurrendAndNew}, isNewlyPushed:=False, updateOnly:=True)
		}
	}

	SetSlotPosition(slotNum, slotPos) {
		; Set the position of the Slot gui
		; If position is higher than the allocated slot count, it will be hidden
		global GuiTradesBuyCompact

		guiName := "TradesBuyCompact_Slot" slotNum, guiSlot := GuiTradesBuyCompact["Slot" slotPos "_Pos"] 
		if (guiSlot)
			Gui.Show(guiName, "x0 y" guiSlot " NoActivate")
		else Gui, %guiName%:Hide
	}

	ScrollUp() {
		; Re-arrange the Slot gui positions based, simulating a scroll up
		global GuiTradesBuyCompact
		tabsRange := GUI_TradesBuyCompact.GetRange()

		if (tabsRange.1 > 1) {
			num := tabsRange.1
			GUI_TradesBuyCompact.SetSlotPosition(num-1, 1) ; show new first in row
			Loop 4 { ; handle the other gui
				GUI_TradesBuyCompact.SetSlotPosition(num, A_Index+1)
				num++
			}	
		}
	}

	ScrollDown() {
		; Re-arrange the Slot gui positions based, simulating a scroll down
		global GuiTradesBuyCompact
		tabsRange := GUI_TradesBuyCompact.GetRange()

		if (GuiTradesBuyCompact.Tabs_Count > tabsRange.2) {
			num := tabsRange.1
			Loop 4 { ; handle 1,2,3 gui
				GUI_TradesBuyCompact.SetSlotPosition(num, A_Index-1)
				num++
			}
			GUI_TradesBuyCompact.SetSlotPosition(num, 4) ; show last in row
		}
	}

	GetRange() {
		; get the first and last gui, based on controls visibility
		global GuiTradesBuyCompact

		Loop % GuiTradesBuyCompact.Tabs_Count {		
			guiName := "TradesBuyCompact_Slot" A_Index
			GuiControlGet, isVisible, %guiName%:Visible,% GuiTradesBuyCompact["Slot" A_Index "_Controls"].hTEXT_TimeSent

			if (firstVisibleTab = "" && isVisible)
				firstVisibleTab := A_Index
			if (isVisible)
				lastVisibleTab := A_Index

			if (firstVisibleTab && lastVisibleTab && !isVisible)
				Break
		}
		Return [firstVisibleTab, lastVisibleTab]
	}

	Get_Styles() {
		global PROGRAM, SKIN

		skinSettings := SKIN.Compact.Settings
		skinAssets := SKIN.Compact.Assets

		pngTransColor 		:= (skinAssets.Misc.Transparency_Color = "0x000000")?("Black"):(skinAssets.Misc.Transparency_Color)

		Arrow_Left 			:=	[ [0, skinAssets.Arrow_Left.Normal, "", "", "", pngTransColor]
		              			, [0, skinAssets.Arrow_Left.Hover, "", "", "", pngTransColor]
		    	      			, [0, skinAssets.Arrow_Left.Press, "", "", "", pngTransColor] ]

		Arrow_Right 		:=	[ [0, skinAssets.Arrow_Right.Normal, "", "", "", pngTransColor]
		              			, [0, skinAssets.Arrow_Right.Hover, "", "", "", pngTransColor]
		    	      			, [0, skinAssets.Arrow_Right.Press, "", "", "", pngTransColor] ]

		Button_ToolBar	:=	[ [0, skinAssets.Button_ToolBar.Normal, "", "", "", pngTransColor]
		              				, [0, skinAssets.Button_ToolBar.Hover, "", "", "", pngTransColor]
		    	      				, [0, skinAssets.Button_ToolBar.Press, "", "", "", pngTransColor] ]

		Toolbar_Hideout	:=	[ [0, skinAssets.Toolbar_Hideout.Normal, "", "", "", pngTransColor]
		              				, [0, skinAssets.Toolbar_Hideout.Hover, "", "", "", pngTransColor]
		    	      				, [0, skinAssets.Toolbar_Hideout.Press, "", "", "", pngTransColor] ]
		
		Toolbar_Sheet	:=	[ [0, skinAssets.Toolbar_Sheet.Normal, "", "", "", pngTransColor]
		              				, [0, skinAssets.Toolbar_Sheet.Hover, "", "", "", pngTransColor]
		    	      				, [0, skinAssets.Toolbar_Sheet.Press, "", "", "", pngTransColor] ]

		Button_Hideout 		:=	[ [0, skinAssets.Button_Hideout.Normal, "", "", "", pngTransColor]
		              			, [0, skinAssets.Button_Hideout.Hover, "", "", "", pngTransColor]
		    	      			, [0, skinAssets.Button_Hideout.Press, "", "", "", pngTransColor] ]

		Button_Whisper 		:=	[ [0, skinAssets.Button_Whisper.Normal, "", "", "", pngTransColor]
		              			, [0, skinAssets.Button_Whisper.Hover, "", "", "", pngTransColor]
		    	      			, [0, skinAssets.Button_Whisper.Press, "", "", "", pngTransColor] ]

		Button_Kick 		:=	[ [0, skinAssets.Button_Kick.Normal, "", "", "", pngTransColor]
		              			, [0, skinAssets.Button_Kick.Hover, "", "", "", pngTransColor]
		    	      			, [0, skinAssets.Button_Kick.Press, "", "", "", pngTransColor] ]

		Button_Thanks 		:=	[ [0, skinAssets.Button_Thanks.Normal, "", "", "", pngTransColor]
		              			, [0, skinAssets.Button_Thanks.Hover, "", "", "", pngTransColor]
		    	      			, [0, skinAssets.Button_Thanks.Press, "", "", "", pngTransColor] ]

		Close_Tab 			:=	[ [0, skinAssets.Close_Tab.Normal, "", "", "", pngTransColor]
		              			, [0, skinAssets.Close_Tab.Hover, "", "", "", pngTransColor]
		    	      			, [0, skinAssets.Close_Tab.Press, "", "", "", pngTransColor] ]

		Minimize 			:=	[ [0, skinAssets.Minimize.Normal, "", "", "", pngTransColor]
		              			, [0, skinAssets.Minimize.Hover, "", "", "", pngTransColor]
		    	      			, [0, skinAssets.Minimize.Press, "", "", "", pngTransColor] ]

		Maximize 			:=	[ [0, skinAssets.Maximize.Normal, "", "", "", pngTransColor]
		              			, [0, skinAssets.Maximize.Hover, "", "", "", pngTransColor]
		    	      			, [0, skinAssets.Maximize.Press, "", "", "", pngTransColor] ]


		returnArr := {Arrow_Left:Arrow_Left, Arrow_Right:Arrow_Right, Arrow_Left_Use_Character:skinAssets.Arrow_Left.Use_Character, Arrow_Right_Use_Character:skinAssets.Arrow_Right.Use_Character
					, Button_Special:Button_Special, Minimize:Minimize,Maximize:Maximize
					, Close_Tab:Close_Tab, Close_Tab_Use_Character:skinAssets.Close_Tab.Use_Character
					, Toolbar_Hideout:Toolbar_Hideout, Toolbar_Sheet:Toolbar_Sheet
					, Button_Hideout:Button_Hideout, Button_Whisper:Button_Whisper, Button_Kick:Button_Kick,Button_Thanks:Button_Thanks}

		Return returnArr
	}


	SetTranslation(_lang="english", _ctrlName="") {
		global PROGRAM, GuiTradesBuyCompact, GuiTradesBuyCompact_Controls
		trans := PROGRAM.TRANSLATIONS.GUI_TradesBuyCompact

		GUI_TradesBuyCompact.DestroyBtnImgList()

		noResizeCtrls := "hBTN_CloseGUI,hBTN_AcceptLang"
		noSmallerCtrls := "hTEXT_TopText"
		needsCenterCtrls := "hTEXT_TopText"

		if (_ctrlName) {
			if (trans != "") ; selected trans
				GuiControl, TradesBuyCompact:,% GuiTradesBuyCompact_Controls[_ctrlName],% trans
		}
		else {
			for ctrlName, ctrlTranslation in trans {
				if !( SubStr(ctrlName, -7) = "_ToolTip" ) { ; if not a tooltip
					ctrlHandle := GuiTradesBuyCompact_Controls[ctrlName]

					ctrlType := IsContaining(ctrlName, "hCB_") ? "CheckBox"
							: IsContaining(ctrlName, "hTEXT_") ? "Text"
							: IsContaining(ctrlName, "hBTN_") ? "Button"
							: IsContaining(ctrlName, "hDDL_") ? "DropDownList"
							: IsContaining(ctrlName, "hEDIT_") ? "Edit"
							: IsContaining(ctrlName, "hGB_") ? "GroupBox"
							: IsContaining(ctrlName, "hLV_") ? "ListView"
							: "Text"

					if !IsIn(ctrlName, noResizeCtrls) { ; Readjust size to fit translation
						txtSize := Get_TextCtrlSize(txt:=ctrlTranslation, fontName:=GuiTradesBuyCompact.Font, fontSize:=GuiTradesBuyCompact.Font_Size, maxWidth:="", params:="", ctrlType)
						txtPos := Get_ControlCoords("TradesBuyCompact", ctrlHandle)

						if (IsIn(ctrlName, noSmallerCtrls) && (txtSize.W > txtPos.W))
						|| !IsIn(ctrlName, noSmallerCtrls)
							GuiControl, TradesBuyCompact:Move,% ctrlHandle,% "w" txtSize.W
					}

					if (ctrlHandle) { ; set translation
						if (ctrlType = "DropDownList")
							ddlValue := GUI_TradesBuyCompact.Submit(ctrlName), ctrlTranslation := "|" ctrlTranslation

						if (ctrlTranslation != "") { ; selected trans
							if (ctrlType = "ListView") {
								GUI_TradesBuyCompact.SetDefaultListView(ctrlName)
								Loop, Parse, ctrlTranslation, |
									LV_ModifyCol(A_Index, Options, A_LoopField)
							}
							GuiControl, TradesBuyCompact:,% ctrlHandle,% ctrlTranslation
						}

						if (ctrlType = "DropDownList")
							GuiControl, TradesBuyCompact:Choose,% ctrlHandle,% ddlValue
					}

					if IsIn(ctrlName, needsCenterCtrls) {
						GuiControl, TradesBuyCompact:-Center,% ctrlHandle
						GuiControl, TradesBuyCompact:+Center,% ctrlHandle
					}

				}
			}
			
			GuiControl, TradesBuyCompact:,% GuiTradesBuyCompact_Controls["hBTN_CloseGUI"],% "X"
			ImageButton.Create(GuiTradesBuyCompact_Controls["hBTN_CloseGUI"], GuiTradesBuyCompact.Style_RedBtn, PROGRAM.FONTS[GuiTradesBuyCompact.Font], GuiTradesBuyCompact.FontSize)						
		}

		GUI_TradesBuyCompact.Redraw()
	}

	DestroyBtnImgList() {
		global GuiTradesBuyCompact, GuiTradesBuyCompact_Controls

		for key, value in GuiTradesBuyCompact_Controls
			if IsContaining(key, "hBTN_")
				try ImageButton.DestroyBtnImgList(value)
		
		Loop % GuiTradesBuyCompact.Tabs_Limit
			for key, value in GuiTradesBuyCompact["Slot" A_Index "_Controls"]
				if IsContaining(key, "hBTN_")
					try ImageButton.DestroyBtnImgList(value)
	}

	Destroy() {
		global GuiTradesBuyCompact
		
		GUI_TradesBuyCompact.DestroyBtnImgList()
		Gui.Destroy("TradesBuyCompactSearch")
		Gui.Destroy("TradesBuyCompactSearchHidden")
		Loop % GuiTradesBuyCompact.Tabs_Limit
			Gui.Destroy("TradesBuyCompact_Slot" A_Index)
		Gui.Destroy("TradesBuyCompact")
	}

	Submit(CtrlName="") {
		global GuiTradesBuyCompact_Submit, GuiTradesBuyCompact_Controls
		Gui.Submit("TradesBuyCompact")

		if (CtrlName) {
			Return GuiTradesBuyCompact_Submit[ctrlName]
		}
	}
	
    OnGuiMove(GuiHwnd) {
		global PROGRAM
		
		if (PROGRAM.SETTINGS.SETTINGS_MAIN.TradesGUI_Locked = "False")
			PostMessage, 0xA1, 2,,,% "ahk_id " GuiHwnd

		KeyWait, LButton, L
		GUI_TradesBuyCompact.SavePosition()
		; Gui_Trades.RemoveButtonFocus()
		GUI_TradesBuyCompact.ResetPositionIfOutOfBounds()
	}

	SavePosition() {
		global PROGRAM, GuiTradesBuyCompact

		gtPos := GUI_TradesBuyCompact.GetPosition()
		if !IsNum(gtPos.X) || !IsNum(gtPos.Y)
			Return

		INI.Set(PROGRAM.INI_FILE, "SETTINGS_MAIN", "Compact_Pos_X", gtPos.X)
		INI.Set(PROGRAM.INI_FILE, "SETTINGS_MAIN", "Compact_Pos_Y", gtPos.Y)
	}

	GetPosition() {
		global GuiTradesBuyCompact
		hiddenWin := A_DetectHiddenWindows
		DetectHiddenWindows, On
		WinGetPos, x, y, w, h,% "ahk_id " GuiTradesBuyCompact.Handle
		Sleep 10
		DetectHiddenWindows, %hiddenWin%
		return {x:x,y:y,w:w,h:h}
	}

	ResetPosition(dontWrite=False) {
		global PROGRAM, GuiTradesBuyCompact ; , GuiTradesMinimized
		iniFile := PROGRAM.INI_FILE

		gtPos := GUI_TradesBuyCompact.GetPosition()	
		; gtmPos := GUI_TradesMinimized.GetPosition()

		try {
			; if (GuiTrades.Is_Minimized)
			; 	if (PROGRAM.SETTINGS.SETTINGS_MAIN.MinimizeInterfaceToBottomLeft)
			; 		Gui, TradesMinimized:Show,% "NoActivate x" Ceil(A_ScreenWidth-gtPos.W) " y"  Ceil(0+gtPos.H-gtmPos.H)
			; 	else
			; 		Gui, TradesMinimized:Show,% "NoActivate x" Ceil(A_ScreenWidth-gtmPos.W) " y0"
			; else 
			Gui, TradesBuyCompact:Show,% "NoActivate x" Ceil(A_ScreenWidth-gtPos.W) " y0"
			
			if !(dontWrite) {
				; if (GuiTrades.Is_Minimized)
					; Gui_TradesMinimized.SavePosition()
				; else 
					GUI_TradesBuyCompact.SavePosition()
			}
		}
		catch e {
			AppendToLogs(A_ThisFunc "(dontWrite=" dontWrite "): Failed to set GUI pos based on screen width. Setting to 0,0.")
			; if (GuiTrades.Is_Minimized)
				; Gui, TradesMinimized:Show,% "NoActivate x0 y0"
			; else
			Gui, TradesBuyCompact:Show,% "NoActivate x0 y0"
			
			if !(dontWrite) {
				INI.Set(iniFile, "SETTINGS_MAIN", "Compact_Pos_X", 0)
				INI.Set(iniFile, "SETTINGS_MAIN", "Compact_Pos_Y", 0)
			}
		}
	}

	ResetPositionIfOutOfBounds() {
		global PROGRAM, GuiTradesBuyCompact ;, GuiTradesMinimized

		if ( !GUI_TradesBuyCompact.Exists() )
			return

		; winHandle := GuiTrades.Is_Minimized ? GuiTradesMinimized.Handle : GuiTrades.Handle
		winHandle := GuiTradesBuyCompact.Handle
		
		if !IsWindowInScreenBoundaries(_win:="ahk_id " winHandle, _screen:="All", _adv:=False) {
			bounds := IsWindowInScreenBoundaries(_win:="ahk_id " winHandle, _screen:="All", _adv:=True)
			appendTxtFinal := "Win_X: " bounds[index].Win_X " | Win_Y: " bounds[index].Win_Y " - Win_W: " bounds[index].Win_W " | Win_H: " bounds[index].Win_H
			for index, nothing in bounds {
				appendTxt := "Monitor ID: " index
				. "`nMon_L: " bounds[index].Mon_L " | Mon_T: " bounds[index].Mon_T " | Mon_R: " bounds[index].Mon_R " | Mon_B: " bounds[index].Mon_B
				. "`nIsInBoundaries_H: " bounds[index].IsInBoundaries_H " | IsInBoundaries_V: " bounds[index].IsInBoundaries_V
				appendTxtFinal := appendTxtFinal ? appendTxtFinal "`n" appendTxt : appendTxt
			}
			AppendToLogs("Reset GUI TradesBuyCompact position due to being deemed out of bounds."
			. "`n" appendTxtFinal)
			GUI_TradesBuyCompact.ResetPosition()
			
			TrayNotifications.Show(PROGRAM.TRANSLATIONS.TrayNotifications.PositionHasBeenReset_Title, PROGRAM.TRANSLATIONS.TrayNotifications.PositionHasBeenReset_Msg)
		}
	}

    Show() {
		global GuiTradesBuyCompact, PROGRAM
		
		if (PROGRAM.SETTINGS.SETTINGS_MAIN.DisableBuyInterface="True")
			return

		hiddenWin := A_DetectHiddenWindows
		DetectHiddenWindows, On
		foundHwnd := WinExist("ahk_id " GuiTradesBuyCompact.Handle)
		DetectHiddenWindows, %hiddenWin%

		if (foundHwnd) {
			Gui, TradesBuyCompact:Show, NoActivate
		}
		else {
			AppendToLogs("GUI_TradesBuyCompact.Show(): Non existent. Recreating.")
			GUI_TradesBuyCompact.Create()
			Gui, TradesBuyCompact:Show, NoActivate
		}
	}

    Close() {
		
	}

	Redraw() {
		Gui, TradesBuyCompact:+LastFound
		WinSet, Redraw
	}
}

GUI_TradesBuyCompact_Search:
	GUI_TradesBuyCompact.Search()
return