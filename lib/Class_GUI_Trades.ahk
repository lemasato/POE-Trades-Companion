Class GUI_Trades {
	Get_ButtonsRowsCount() {
		global PROGRAM

		customBtnBiggestSlot := 0
		Loop 9 {
			customBtnSettings := PROGRAM.SETTINGS["SETTINGS_CUSTOM_BUTTON_" A_Index]
			if (customBtnSettings.Enabled = "True") {
				customBtnBiggestSlot := customBtnSettings.Slot > customBtnBiggestSlot ? customBtnSettings.Slot : customBtnBiggestSlot
			}
		}

		specialsBtnRowsCount := 0
		Loop 5 {
			specialBtnSettings := PROGRAM.SETTINGS["SETTINGS_SPECIAL_BUTTON_" A_Index]
			if (specialBtnSettings.Enabled = "True") {
				specialsBtnRowsCount := 1
			}
		}
		
		customBtnsRowsCount := customBtnBiggestSlot = 0 ? "0"
			: IsIn(customBtnBiggestSlot, "1,2,3") ? 1
			: IsIn(customBtnBiggestSlot, "4,5,6") ? 2
			: IsIn(customBtnBiggestSlot, "7,8,9") ? 3
			: "ERROR"
		specialsBtnRowsCount := specialsBtnRowsCount

		Return {Custom:customBtnsRowsCount, Special:specialsBtnRowsCount}
	}
	Create(_maxTabsToRender=20) {
		global PROGRAM, GAME, SKIN
		global GuiTrades, GuiTrades_Controls, GuiTrades_Submit
		static guiCreated, maxTabsToRender

		GUI_Trades.DisableHotkeys()

		scaleMult := PROGRAM.SETTINGS.SETTINGS_CUSTOMIZATION_SKINS.ScalingPercentage / 100
		resDPI := Get_DpiFactor() 

		AppendToLogs("Trades GUI: Creating with max tabs """ _maxTabsToRender """.")

		; Free ImageButton memory
		for key, value in GuiTrades_Controls
			if IsIn(key, "hBTN_Minimize,hBTN_Maximize,hBTN_LeftArrow,hBTN_RightArrow,hBTN_CloseTab")
			|| IsContaining(key, "hBTN_TabDefault,hBTN_TabJoinedArea,hBTN_TabWhisperReceived,hBTN_Custom,hBTN_Special")
				ImageButton.DestroyBtnImgList(value)

		; Initialize gui arrays
		Gui, Trades:Destroy
		Gui.New("Trades", "+AlwaysOnTop +ToolWindow +LastFound -SysMenu -Caption -Border +LabelGUI_Trades_ +HwndhGuiTrades", "Trades")
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

		tradeInfoBox := Get_TextCtrlSize("Buyer:`nItem:`nPrice:`nLocation:`nOther:", settings_fontName, settings_fontSize, "", "R5")

		; Gui size and positions
		borderSize := Floor(1*scaleMult)
		guiHeightNoRow_NoSpecial := (30+25)*scaleMult + 2 + 5 + tradeInfoBox.H + 5 ; (header+tabs bar) + undertab line + 5 off + info + 5 off
		guiHeightNoRow := guiHeightNoRow_NoSpecial+(scaleMult*25)+5 ; 25 = SpecialButton_H

		guiHeightOneRow_NoSpecial := guiHeightNoRow_NoSpecial+(scaleMult*35)+5 ; 35 = CustomButton_H, 5 = space between rows	
		guiHeightTwoRow_NoSpecial := guiHeightOneRow_NoSpecial+(scaleMult*35)+5
		guiHeightThreeoRow_NoSpecial := guiHeightTwoRow_NoSpecial+(scaleMult*35)+5

		guiHeightOneRow := guiHeightNoRow+(scaleMult*35)+5
		guiHeightTwoRow := guiHeightOneRow+(scaleMult*35)+5
		guiHeightThreeRow := guiHeightTwoRow+(scaleMult*35)+5

		btnRowsCount := Gui_Trades.Get_ButtonsRowsCount()
		if (btnRowsCount.Special)
			guiFullHeight := btnRowsCount.Custom = 0 ? guiHeightNoRow
				: btnRowsCount.Custom = 1 ? guiHeightOneRow
				: btnRowsCount.Custom = 2 ? guiHeightTwoRow
				: btnRowsCount.Custom = 3 ? guiHeightThreeRow
				: "ERROR"
		else
			guiFullHeight := btnRowsCount.Custom = 0 ? guiHeightNoRow_NoSpecial
				: btnRowsCount.Custom = 1 ? guiHeightOneRow_NoSpecial
				: btnRowsCount.Custom = 2 ? guiHeightTwoRow_NoSpecial
				: btnRowsCount.Custom = 3 ? guiHeightThreeoRow_NoSpecial
				: "ERROR"

		guiFullHeight := guiFullHeight+(borderSize*2), guiFullWidth := scaleMult*(398+(2*borderSize))

		guiHeight := guiFullHeight-(2*borderSize), guiWidth := guiFullWidth-(2*borderSize)
		guiMinimizedHeight := (30*scaleMult)+(2*borderSize) ; 30 = Header_H
		leftMost := borderSize, rightMost := guiWidth-borderSize
		upMost := borderSize, downMost := guiHeight-borderSize		

		; Tabs count
		maxTabsPerRow := 8
		maxTabsToRender := _maxTabsToRender

		; Header pos
		Header_X := leftMost, Header_Y := upMost, Header_W := guiWidth, Header_H := scaleMult*30
		Icon_X := Header_X+(3*scaleMult), Icon_Y := Header_Y+(3*scaleMult), Icon_W := scaleMult*24, Icon_H := scaleMult*24
		MinMax_X := rightMost-((scaleMult*20)+3), MinMax_Y := Header_Y+(5*scaleMult), MinMax_W := scaleMult*20, MinMax_H := scaleMult*20
		Title_X := Icon_X+Icon_W+5, Title_Y := Header_Y, Title_W := MinMax_X-Title_X-5, Title_H := Header_H

		; Tab btn pos
		Loop % maxTabsToRender {
			indexMinusOne := A_Index-1
			TabButton%A_Index%_X := (A_Index=1)?(leftMost):(A_Index > maxTabsPerRow)?(TabButton%maxTabsPerRow%_X):(TabButton%indexMinusOne%_X + TabButton%indexMinusOne%_W)
			TabButton%A_Index%_Y := Header_X+Header_H
			TabButton%A_Index%_W := scaleMult*40
			TabButton%A_Index%_H := scaleMult*25
		}
		TabBackground_X := TabButton1_X, TabBackground_Y := TabButton1_Y, TabBackground_W := (TabButton1_W*8), TabBackground_H := TabButton1_H
		LeftArrow_Y := TabButton1_Y, LeftArrow_W := scaleMult*25, LeftArrow_H := TabButton1_H
		RightArrow_Y := LeftArrow_Y, RightArrow_W := LeftArrow_W, RightArrow_H := LeftArrow_H
		CloseTab_Y := RightArrow_Y, CloseTab_W := scaleMult*27, CloseTab_H := RightArrow_H
		LeftArrow_X := guiWidth+borderSize-LeftArrow_W-RightArrow_W-CloseTab_W-1 ; 1=dont stick to border
		RightArrow_X := LeftArrow_X+LeftArrow_W
		CloseTab_X := RightArrow_X+RightArrow_W

		TabUnderline_X := leftMost, TabUnderline_Y := TabButton1_Y+TabButton1_H, TabUnderline_W := guiWidth, TabUnderline_H := 2 ; TO_DO why cant i scaleMult TabUnderline_H?

		; Background img
		BackgroundImg_X := leftMost, BackgroundImg_Y := Header_Y+Header_H
		BackgroundImg_W := Ceil( (guiWidth*reSDPI) ), BackgroundImg_H := (guiHeight-Header_H)*resDPI

		; Trade infos text pos + time slot auto size
		TradeInfos_X := leftMost+5, TradeInfos_Y := TabUnderline_Y+TabUnderline_H+5, TradeInfos_W := guiWidth-TradeInfos_X-5
		Loop 10 { ; from 0 to 9
			num := (A_Index=10)?("0"):(A_Index)
			txtCtrlSize := Get_TextCtrlSize(num num ":" num num, settings_fontName, settings_fontSize), thisW := txtCtrlSize.W, thisH := txtCtrlSize.H
			timeSlotWidth := (timeSlotWidth > thisW)?(timeSlotWidth):(thisW)
			timeSlotHeight := (timeSlotHeight > thisH)?(timeSlotHeight):(thisH)
		}
		TimeSlot_X := (guiWidth-timeSlotWidth)-5, TimeSlot_Y := TabUnderline_Y+TabUnderline_H, TimeSlot_W := timeSlotWidth
		TradeVerify_W := 10*scaleMult, TradeVerify_H := TradeVerify_W, TradeVerify_X := TimeSlot_X-5-TradeVerify_W, TradeVerify_Y := TimeSlot_Y+3
		; TO_DO Proper Scalemult?
		; Set TradeVerify_W same as TimeSlot_H? --Cant do. Height changes based on font type.

		; Special btn pos
		SpecialButton_X := leftMost+5, SpecialButton_W := scaleMult*35, SpecialButton_H := scaleMult*25

		; Custom btn pos
		CustomButtonOneThird_W := Ceil( (TradeInfos_W)/3 )-3 , CustomButtonTwoThird_W := (CustomButtonOneThird_W*2)+5, CustomButtonThreeThird_W := (CustomButtonOneThird_W*3)+10
		CustomButtonLeft_X := leftMost+5, CustomButtonMiddle_X := CustomButtonLeft_X+CustomButtonOneThird_W+5, CustomButtonRight_X := CustomButtonMiddle_X+CustomButtonOneThird_W+5
		CustomButton_H := 35*scaleMult

		; Info text content and pos
		InfoMsg_X := TradeInfos_X, InfoMsg_Y := TradeInfos_Y, InfosMsg_W := TradeInfos_W
		InfoMsg_NoTradeMsg := "All trade requests have been answered"
				    . "`nor no whisper has been received yet."
				    . "`n`nRight click on the tray icon,"
				    . "`nthen [Settings] to set your preferences."
		InfoMsg_NoGameInstanceMsg := "No game instance could be found,"
					   . "`nretrying in XX seconds..."
					   . "`n`nRight click on the tray icon,"
					   . "`nthen [Settings] to set your preferences."

		; Set required gui array variables
		GuiTrades.Height_Maximized := guiFullHeight
		GuiTrades.Height_Minimized := guiMinimizedHeight
		GuiTrades.Active_Tab := 0
		GuiTrades.Tabs_Count := 0
		GuiTrades.Tabs_Limit := maxTabsToRender
		GuiTrades.Max_Tabs_Per_Row := maxTabsPerRow
		GuiTrades.Is_Created := False
		GuiTrades.Height := guiFullHeight
		GuiTrades.Width := guiFullWidth

		styles := Gui_Trades.Get_Styles()

		/* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * 
		*	CREATION
		*/

		Gui.Margin("Trades", 0, 0)
		Gui.Color("Trades", "White")
		Gui.Font("Trades", settings_fontName, settings_fontSize, settings_fontQual)

		; = = TAB CTRL = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = =
		Gui.Add("Trades", "Tab2", "x0 y0 w0 h0 hwndhTab_AllTabs Choose1")
		Gui, Trades:Tab

		; = = BORDERS = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = =
		bordersPositions := [{Position:"Top", X:0, Y:0, W:guiFullWidth, H:borderSize}, {Position:"Left", X:0, Y:0, W:borderSize, H:guiFullHeight} ; Top and Left
							,{Position:"Bottom", X:0, Y:guiFullHeight-borderSize, W:guiFullWidth, H:borderSize}, {Position:"Right", X:guiFullWidth-borderSize, Y:0, W:borderSize, H:guiFullHeight} ; Bottom and Right
							,{Position:"BottomMinimized", X:0, Y:guiMinimizedHeight-borderSize, W:guiFullWidth, H:borderSize}] ; Bottom when minimized

		Loop 4 {
			Gui.Add("Trades", "Progress", "x" bordersPositions[A_Index]["X"] " y" bordersPositions[A_Index]["Y"] " w" bordersPositions[A_Index]["W"] " h" bordersPositions[A_Index]["H"] " hwndhPROGRESS_Border" bordersPositions[A_index]["Position"] " Background" SKIN.Settings.COLORS.Border)
			if (bordersPositions[A_Index]["Position"] = "BottomMinimized")
				GuiControl, Trades:Hide,% GuiTrades_Controls["hPROGRESS_Border" bordersPositions[A_index]["Position"]]
		}

		; = = BACKGROUND = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = =
		Gui.Add("Trades", "Picture", "x" BackgroundImg_X " y" BackgroundImg_Y " hwndhIMG_Background BackgroundTrans", SKIN.Assets.Misc.Background)
		TilePicture("Trades", GuiTrades_Controls.hIMG_Background, BackgroundImg_W, BackgroundImg_H) ; Fill the background

		; = = TITLE BAR = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = =
		Gui.Add("Trades", "Picture", "x" Header_X " y" Header_Y " w" Header_W " h" Header_H " hwndhIMG_Header BackgroundTrans", SKIN.Assets.Misc.Header) ; Title bar
		Gui.Add("Trades", "Picture", "x" Icon_X " y" Icon_Y " w" Icon_W " h" Icon_H " BackgroundTrans", SKIN.Assets.Misc.Icon) ; Icon
		imageBtnLog .= Gui.Add("Trades", "ImageButton", "x" MinMax_X " y" MinMax_Y " w" MinMax_W " h" MinMax_H " BackgroundTrans hwndhBTN_Minimize", "", styles.Minimize, PROGRAM.FONTS[settings_fontName], settings_fontSize) ; Min
		imageBtnLog .= Gui.Add("Trades", "ImageButton", "x" MinMax_X " y" MinMax_Y " w" MinMax_W " h" MinMax_H " BackgroundTrans hwndhBTN_Maximize Hidden", "", styles.Maximize, PROGRAM.FONTS[settings_fontName], settings_fontSize) ; Max

		Gui.Add("Trades", "Text", "x" Title_X " y" Title_Y " w" Title_W " h" Title_H " hwndhTEXT_Title Center BackgroundTrans +0x200 c" SKIN.Settings.COLORS.Title_No_Trades, PROGRAM.NAME)
		titleCoords := Get_ControlCoords("Trades", GuiTrades_Controls.hTEXT_Title) ; Get coords to center on Y
		; GuiControl, Trades:Move,% GuiTrades_Controls.hTEXT_Title,% "y" Ceil( titleCoords.Y+(titleCoords.H/2) ) ; Center on Y based on text H

		Gui.Add("Trades", "Text", "x" Header_X " y" Header_Y " w" Header_W " h" Header_H " hwndhTXT_HeaderGhost BackgroundTrans", "") ; Empty text ctrl to allow moving the gui by dragging the title bar


		__f := GUI_Trades.OnGuiMove.bind(GUI_Trades, GuiTrades.Handle)
		GuiControl, Trades:+g,% GuiTrades_Controls["hTXT_HeaderGhost"],% __f

		__f := GUI_Trades.Minimize.bind(GUI_Trades, False)
		GuiControl, Trades:+g,% GuiTrades_Controls["hBTN_Minimize"],% __f

		__f := GUI_Trades.Maximize.bind(GUI_Trades, False)
		GuiControl, Trades:+g,% GuiTrades_Controls["hBTN_Maximize"],% __f

		; = = TAB BACKGROUND = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = =
		Gui.Add("Trades", "Picture", "x" TabBackground_X " y" TabBackground_Y " w" TabBackground_W " h" TabBackground_H " hwndhIMG_TabsBackground BackgroundTrans Hidden", SKIN.Assets.Misc.Tabs_Background) ; Title bar

		; = = TABS BUTTONS = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = =
		Loop % maxTabsToRender {
			imageBtnLog .= Gui.Add("Trades", "ImageButton", "x" TabButton%A_Index%_X " y" TabButton%A_Index%_Y " w" TabButton%A_Index%_W " h" TabButton%A_Index%_H " hwndhBTN_TabDefault" A_Index "  Hidden", A_Index, styles.Tab, PROGRAM.FONTS[settings_fontName], settings_fontSize) ; Default state
			imageBtnLog .= Gui.Add("Trades", "ImageButton", "x" TabButton%A_Index%_X " y" TabButton%A_Index%_Y " w" TabButton%A_Index%_W " h" TabButton%A_Index%_H " hwndhBTN_TabJoinedArea" A_Index " Hidden", A_Index, styles.Tab_Joined, PROGRAM.FONTS[settings_fontName], settings_fontSize) ; Joined area state
			imageBtnLog .= Gui.Add("Trades", "ImageButton", "x" TabButton%A_Index%_X " y" TabButton%A_Index%_Y " w" TabButton%A_Index%_W " h" TabButton%A_Index%_H " hwndhBTN_TabWhisperReceived" A_Index " Hidden", A_Index, styles.Tab_Whisper, PROGRAM.FONTS[settings_fontName], settings_fontSize) ; Whisper received state

			if (A_Index <= maxTabsPerRow) {
				GuiTrades["TabButton" A_Index "_X"] := TabButton%A_Index%_X, GuiTrades["TabButton" A_Index "_Y"] := TabButton%A_Index%_Y
				GuiTrades["TabButton" A_Index "_W"] := TabButton%A_Index%_W, GuiTrades["TabButton" A_Index "_H"] := TabButton%A_Index%_H
			}

			__f := GUI_Trades.SetActiveTab.bind(Gui_Trades, tabName:=A_Index, autoScroll:=True, skipError:=False, styleChanged:=False) ; tabName, autoScroll
			GuiControl, Trades:+g,% GuiTrades_Controls["hBTN_TabDefault" A_Index],% __f
			GuiControl, Trades:+g,% GuiTrades_Controls["hBTN_TabJoinedArea" A_Index],% __f
			GuiControl, Trades:+g,% GuiTrades_Controls["hBTN_TabWhisperReceived" A_Index],% __f

			GuiTrades["Tab_" A_Index] := GuiTrades_Controls["hBTN_TabDefault" A_Index]
		}

		imageBtnLog .= Gui.Add("Trades", "ImageButton", "x" LeftArrow_X " y" LeftArrow_Y " w" LeftArrow_W " h" LeftArrow_H " hwndhBTN_LeftArrow Hidden", styles.Arrow_Left_Use_Character = "True"?"<" : "", styles.Arrow_Left, PROGRAM.FONTS[settings_fontName], settings_fontSize) ; Left Arrow
		imageBtnLog .= Gui.Add("Trades", "ImageButton", "x" RightArrow_X " y" RightArrow_Y " w" RightArrow_W " h" RightArrow_H " hwndhBTN_RightArrow Hidden", styles.Arrow_Right_Use_Character = "True"?">" : "", styles.Arrow_Right, PROGRAM.FONTS[settings_fontName], settings_fontSize) ; Right Arrow
		imageBtnLog .= Gui.Add("Trades", "ImageButton", "x" CloseTab_X " y" CloseTab_Y " w" CloseTab_W " h" CloseTab_H " hwndhBTN_CloseTab Hidden", styles.Close_Tab_Use_Character = "True"?"X" : "", styles.Close_Tab, PROGRAM.FONTS[settings_fontName], settings_fontSize) ; Close tab

		Gui.Add("Trades", "Picture", "x" TabUnderline_X " y" TabUnderline_Y " w" TabUnderline_W " h" TabUnderline_H " hwndhIMG_TabsUnderline Hidden", SKIN.Assets.Misc.Tabs_Underline) ; Tab underline


		__f := GUI_Trades.ScrollTabs.bind(GUI_Trades, "Left")
		GuiControl, Trades:+g,% GuiTrades_Controls["hBTN_LeftArrow"],% __f
		__f := GUI_Trades.ScrollTabs.bind(GUI_Trades, "Right")
		GuiControl, Trades:+g,% GuiTrades_Controls["hBTN_RightArrow"],% __f

		__f := GUI_Trades.RemoveTab.bind(GUI_Trades, tabName:="", massRemove:=False)
		GuiControl, Trades:+g,% GuiTrades_Controls["hBTN_CloseTab"],% __f

		; = = TABS CONTENT = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = =
		Loop % maxTabsToRender {
			GuiControl, Trades:,% GuiTrades_Controls.hTab_AllTabs,% A_Index "|"
			Gui, Trades:Tab,% A_Index,,Exact

			Gui.Add("Trades", "Text", "x0 y0 w0 h0 hwndhTEXT_HiddenTradeInfos" A_Index " BackgroundTrans Hidden", "")
			Gui.Add("Trades", "Text", "x" TimeSlot_X " y" TimeSlot_Y " w" TimeSlot_W " hwndhTEXT_TradeReceivedTime" A_Index " R1 BackgroundTrans c" SKIN.Settings.COLORS.Trade_Info_2, A_Hour ":" A_Min) ; Time trade received
			Gui.Add("Trades", "Picture", "x" TradeVerify_X " y" TradeVerify_Y " w" TradeVerify_W " h" TradeVerify_H " hwndhIMG_TradeVerify" A_Index " BackgroundTrans", SKIN.Assets.Trade_Verify.Grey)
			Gui.Add("Trades", "Picture", "x" TradeVerify_X " y" TradeVerify_Y " w" TradeVerify_W " h" TradeVerify_H " hwndhIMG_TradeVerifyGrey" A_Index " Hidden BackgroundTrans", SKIN.Assets.Trade_Verify.Grey)
			Gui.Add("Trades", "Picture", "x" TradeVerify_X " y" TradeVerify_Y " w" TradeVerify_W " h" TradeVerify_H " hwndhIMG_TradeVerifyOrange" A_Index " Hidden BackgroundTrans", SKIN.Assets.Trade_Verify.Orange)
			Gui.Add("Trades", "Picture", "x" TradeVerify_X " y" TradeVerify_Y " w" TradeVerify_W " h" TradeVerify_H " hwndhIMG_TradeVerifyGreen" A_Index " Hidden BackgroundTrans", SKIN.Assets.Trade_Verify.Green)
			Gui.Add("Trades", "Picture", "x" TradeVerify_X " y" TradeVerify_Y " w" TradeVerify_W " h" TradeVerify_H " hwndhIMG_TradeVerifyRed" A_Index " Hidden BackgroundTrans", SKIN.Assets.Trade_Verify.Red)
			Gui.Add("Trades", "Text", "x" TradeInfos_X " y" TradeInfos_Y " w" TradeInfos_W " hwndhTEXT_TradeInfos" A_Index " R5 BackgroundTrans -Wrap c" SKIN.Settings.COLORS.Trade_Info_2, "Buyer:`nItem:`nPrice:`nStash:`nOther:") ; Trade infos			
		}

		; = = SPECIAL BUTTONS = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = =
		Gui, Trades:Tab
		specialBtnsChar := {Clipboard:"0", Whisper:"1", Invite:"2", Trade:"3", Kick:"4"}
		if (btnRowsCount.Special > 0) {
			for btnName, btnChar in specialBtnsChar {
				btnX := (A_Index=1)?(SpecialButton_X):("+5"), btnY := (A_Index=1)?("+5"):("p")
				Gui.Add("Trades", "Button", "x" btnX " y" btnY " w" SpecialButton_W " h" SpecialButton_H " hwndhBTN_Special" A_Index " FontTC_Symbols FontSize12 Hidden", btnChar)

				specialBtn%A_Index%Coords := Get_ControlCoords("Trades", GuiTrades_Controls["hBTN_Special" A_Index])

				__f := GUI_Trades.DoTradeButtonAction.bind(GUI_Trades, A_Index, "Special")
				GuiControl, Trades:+g,% GuiTrades_Controls["hBTN_Special" A_Index],% __f
			}
		}

		GuiTrades.SpecialButton1_X := specialBtn1Coords.X, GuiTrades.SpecialButton2_X := specialBtn2Coords.X
		GuiTrades.SpecialButton3_X := specialBtn3Coords.X, GuiTrades.SpecialButton4_X := specialBtn4Coords.X, GuiTrades.SpecialButton5_X := specialBtn5Coords.X

		; = = CUSTOM BUTTONS = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = =
		Gui, Trades:Tab

		if (btnRowsCount.Custom > 0) {
			Loop 9 {
				btnX := IsIn(A_Index, "1,4,7")?CustomButtonLeft_X : IsIn(A_Index, "2,5,8")?CustomButtonMiddle_X : IsIn(A_Index, "3,6,9")?CustomButtonRight_X : "ERROR"
				btnY := IsIn(A_Index, "1,4,7")?"y+5" : "yp"
				Gui.Add("Trades", "Button", "x" btnX " " btnY " w" CustomButtonOneThird_W " h" CustomButton_H " hwndhBTN_Custom" A_Index " Hidden", A_Index)

				customBtn%A_Index%Coords := Get_ControlCoords("Trades", GuiTrades_Controls["hBTN_Custom" A_Index])

				__f := GUI_Trades.DoTradeButtonAction.bind(GUI_Trades, A_Index, "Custom")
				GuiControl, Trades:+g,% GuiTrades_Controls["hBTN_Custom" A_Index],% __f
			}
		}

		GuiTrades.CustomButtonOneThird_W := CustomButtonOneThird_W,	GuiTrades.CustomButtonTwoThird_W := CustomButtonTwoThird_W,	GuiTrades.CustomButtonThreeThird_W := CustomButtonThreeThird_W
		GuiTrades.CustomButtonLeft_X := CustomButtonLeft_X,	GuiTrades.CustomButtonMiddle_X := CustomButtonMiddle_X,	GuiTrades.CustomButtonRight_X := CustomButtonRight_X
		GuiTrades.CustomButtonRow1_Y := customBtn1Coords.Y,	GuiTrades.CustomButtonRow2_Y := customBtn4Coords.Y,	GuiTrades.CustomButtonRow3_Y := customBtn7Coords.Y

		; = = ERROR TEXT MSG = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = =
		Gui, Trades:Tab
		GuiControl, Trades:,% GuiTrades_Controls.hTab_AllTabs,% "No Trades On Queue|"
		Gui, Trades:Tab,% "No Trades On Queue",,Exact
		Gui.Add("Trades", "Text", "x" InfoMsg_X " y" InfoMsg_Y " w" InfosMsg_W " hwndhTEXT_InfoMsgNoTradeOnQueue Center BackgroundTrans c" SKIN.Settings.COLORS.Trade_Info_1, InfoMsg_NoTradeMsg)

		GuiControl, Trades:,% GuiTrades_Controls.hTab_AllTabs,% "No Game Instance|"
		Gui, Trades:Tab,% "No Game Instance",,Exact
		Gui.Add("Trades", "Text", "x" InfoMsg_X " y" InfoMsg_Y " w" InfosMsg_W " hwndhTEXT_InfoMsgNoGameInstance Center BackgroundTrans c" SKIN.Settings.COLORS.Trade_Info_1, InfoMsg_NoGameInstanceMsg)

		; = = MINIMIZED BORDER = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = =
		; We have to add it now, otherwise other controls will overlap it 
		Gui, Trades:Tab
		Gui.Add("Trades", "Progress", "x" bordersPositions[5]["X"] " y" bordersPositions[5]["Y"] " w" bordersPositions[5]["W"] " h" bordersPositions[5]["H"] " hwndhPROGRESS_Border" bordersPositions[5]["Position"] " Hidden Background" SKIN.Settings.COLORS.Border)

		; = = SHOW THE GUI = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = =
		Gui, Trades:Tab
		GUI_Trades.SetActiveTab("No Trades On Queue")

		isModeWindowed := PROGRAM.SETTINGS.SETTINGS_MAIN.TradesGUI_Mode = "Window" ? True : False
		savedXPos := PROGRAM.SETTINGS.SETTINGS_MAIN.Pos_X, savedYPos := PROGRAM.SETTINGS.SETTINGS_MAIN.Pos_Y
		winXPos := IsNum(savedXPos) && isModeWindowed ? savedXPos : (A_ScreenWidth-guiFullWidth)*resDPI
		winYPos := IsNum(savedYPos) && isModeWindowed ? savedYPos : 0

		if (imageBtnLog) {
			Gui, ErrorLog:New, +AlwaysOnTop +ToolWindow +hwndhGuiErrorLog
			Gui, ErrorLog:Add, Text, x10 y10,% "One or multiple error(s) occured while creating the Trades GUI imagebuttons."
			. "`nIn case you are getting ""Couldn't get button's font"" errors, restarting your computer should fix it."
			Gui, ErrorLog:Add, Edit, xp y+5 w500 R15 ReadOnly,% imageBtnLog
			Gui, ErrorLog:Add, Link, xp y+5,% "If you need assistance, you can contact me on: "
			. "<a href=""" PROGRAM.LINK_GITHUB """>GitHub</a> - <a href=""" PROGRAM.LINK_REDDIT """>Reddit</a> - <a href=""" PROGRAM.LINK_GGG """>PoE Forums</a> - <a href=""" PROGRAM.LINK_DISCORD """>Discord</a>"
			Gui, ErrorLog:Show,xCenter yCenter,% PROGRAM.NAME " - Trades GUI Error log"
			WinWait, ahk_id %hGuiErrorLog%
			WinWaitClose, ahk_id %hGuiErrorLog%
		}

		Gui.Show("Trades", "x" winXPos " y" winYPos " h" guiFullHeight " w" guiFullWidth " NoActivate")

		GUI_Trades.SetButtonsPositions()
		GuiTrades.Is_Created := True
		
		OnMessage(0x200, "WM_MOUSEMOVE")
		OnMessage(0x201, "WM_LBUTTONDOWN")
		OnMessage(0x202, "WM_LBUTTONUP")

		GUI_Trades.SetTransparency_Inactive()
		if (PROGRAM.SETTINGS.SETTINGS_MAIN.AutoMinimizeOnAllTabsClosed = "True")
			GUI_Trades.Minimize()
		if (PROGRAM.SETTINGS.SETTINGS_MAIN.AllowClicksToPassThroughWhileInactive = "True")
			GUI_Trades.Enable_ClickThrough()

		GUI_Trades.EnableHotkeys()
		Return

		Gui_Trades_ContextMenu:
			ctrlHwnd := Get_UnderMouse_CtrlHwnd()
			GuiControlGet, ctrlName, Trades:,% ctrlHwnd

			Gui_Trades.ContextMenu(ctrlHwnd, ctrlName)
		Return
	}

	ContextMenu(CtrlHwnd, CtrlName) {
		global PROGRAM, GuiTrades, GuiTrades_Controls
		iniFile := PROGRAM.INI_FILE

		if (CtrlHwnd = GuiTrades_Controls.hBTN_CloseTab) {
			try Menu, CloseTabMenu, DeleteAll
			Menu, CloseTabMenu, Add, Close other tabs for same item, Gui_Trades_ContextMenu_CloseOtherTabsWithSameItem
			Menu, CloseTabMenu, Add, Close all tabs, Gui_Trades_ContextMenu_CloseAllTabs
			Menu, CloseTabMenu, Show
		}
		else if IsIn(CtrlHwnd, GuiTrades_Controls.hTXT_HeaderGhost "," GuiTrades_Controls.hTEXT_Title) {
			try Menu, HeaderMenu, DeleteAll
			Menu, HeaderMenu, Add, Lock Position?, Gui_Trades_ContextMenu_LockPosition
			if (PROGRAM.SETTINGS.SETTINGS_MAIN.TradesGUI_Locked = "True")
				Menu, HeaderMenu, Check, Lock Position?
			Menu, HeaderMenu, Show
		}
		else
			Menu, Tray, Show
			
		Return

		Gui_Trades_ContextMenu_LockPosition:
			Tray_ToggleLockPosition()
		Return

		Gui_Trades_ContextMenu_CloseAllTabs:
			GUI_Trades.CloseAllTabs()
		return

		Gui_Trades_ContextMenu_CloseOtherTabsWithSameItem:
			GUI_Trades.CloseOtherTabsForSameItem()
		Return
	}

	CloseAllTabs() {
		global GuiTrades

		Loop % GuiTrades.Tabs_Count {
			GUI_Trades.RemoveTab(A_LoopField, massRemove:=True)
		}
	}

	CloseOtherTabsForSameItem() {
		global GuiTrades
		
		activeTabID := Gui_Trades.GetActiveTab()
		activeTabInfos := Gui_Trades.GetTabContent(activeTabID)
		tabsToLoop := GuiTrades.Tabs_Count

		; Parse every tab, from highest to lowest so when we close it, it doesn't affect tab order
		Loop % GuiTrades.Tabs_Count {
			loopedTab := tabsToLoop
			if (loopedTab != activeTabID) {
				tabInfos := Gui_Trades.GetTabContent(loopedTab)
				if (tabInfos.Item = activeTabInfos.Item)
				&& (tabInfos.Price = activeTabInfos.Price)
				&& (tabInfos.Stash =  activeTabInfos.Stash) {
					Gui_Trades.RemoveTab(loopedTab, massRemove:=True)
					AppendToLogs(A_ThisLabel ": Removed tab " loopedTab)
				}
			}
			tabsToLoop--
		}
	}

	SetButtonsPositions() {
		global PROGRAM
		global GuiTrades, GuiTrades_Controls
		iniFile := PROGRAM.INI_FILE

		oneThird := GuiTrades.CustomButtonOneThird_W, twoThird := GuiTrades.CustomButtonTwoThird_W, threeThird := GuiTrades.CustomButtonThreeThird_W
		col1X := GuiTrades.CustomButtonLeft_X, col2X := GuiTrades.CustomButtonMiddle_X, col3X := GuiTrades.CustomButtonRight_X
		row1Y := GuiTrades.CustomButtonRow1_Y, row2Y := GuiTrades.CustomButtonRow2_Y, row3Y := GuiTrades.CustomButtonRow3_Y

		styles := Gui_Trades.Get_Styles()

		Loop 5 {
			specialBtnSettings := INI.Get(iniFile, "SETTINGS_SPECIAL_BUTTON_" A_Index,,1)
			specialBtnHandle := GuiTrades_Controls["hBTN_Special" A_Index]
			specialBtnSlot := specialBtnSettings.Slot
			specialBtnType := specialBtnSettings.Type

			specialBtnChar := specialBtnType="Clipboard" ? "0"
				: specialBtnType="Whisper" ? "1"
				: specialBtnType="Invite" ? "2"
				: specialBtnType="Trade" ? "3"
				: specialBtnType="Kick" ? "4"
				: "ERROR"

			btnX := GuiTrades["SpecialButton" specialBtnSlot "_X"]
			specialBtnStyle := Styles.Button_Special

			if (specialBtnSettings.Enabled = "True") {
				GuiControl, Trades:Move,% specialBtnHandle, x%btnX%
				GuiControl, Trades:,% specialBtnHandle,% specialBtnChar

				ImageButton.Create(specialBtnHandle, specialBtnStyle, PROGRAM.FONTS["TC_Symbols"], GuiTrades.Font_Size)
			}
			else {
				GuiControl, Trades:Hide,% specialBtnHandle
				GuiTrades_Controls["hBTN_Special" A_Index] := ""
			}
		}

		Loop 9 {
			customBtnSettings := INI.Get(iniFile, "SETTINGS_CUSTOM_BUTTON_" A_Index,,1)
			customBtnHandle := GuiTrades_Controls["hBTN_Custom" A_Index]
			customBtnSlot := customBtnSettings.Slot
			customBtnSize := customBtnSettings.Size

			btnX := IsIn(customBtnSlot, "1,4,7")?col1X : IsIn(customBtnSlot, "2,5,8")?col2X : IsIn(customBtnSlot, "3,6,9")?col3X : "ERROR SLOT " A_Index " XPOS"
			btnY := IsIn(customBtnSlot, "1,2,3")?row1Y : IsIn(customBtnSlot, "4,5,6")?row2Y : IsIn(customBtnSlot, "7,8,9")?row3Y : "ERROR SLOT " A_Index " YPOS"
			btnW := customBtnSize="Small"?oneThird : customBtnSize="Medium"?twoThird : customBtnSize="Large"?threeThird : "ERROR SLOT " A_Index " WIDTH"
			customBtnStyle := customBtnSize="Small"?Styles.Button_OneThird : customBtnSize="Medium"?Styles.Button_TwoThird : customBtnSize="Large"?Styles.Button_ThreeThird : "ERROR SLOT " A_Index " STYLE"

			if (customBtnSettings.Enabled = "True") {
				GuiControl, Trades:Move,% customBtnHandle, x%btnX% y%btnY% w%btnW%
				GuiControl, Trades:,% customBtnHandle,% customBtnSettings.Name

				ImageButton.Create(customBtnHandle, customBtnStyle, PROGRAM.FONTS[GuiTrades.Font], GuiTrades.Font_Size)
			}
			else {
				GuiControl, Trades:Hide,% customBtnHandle
				GuiTrades_Controls["hBTN_Custom" A_Index] := ""
			}
		}
	}

	DoTradeButtonAction(btnNum, btnType) {
		global PROGRAM, GuiTrades
		static uniqueNum
		activeTab := GuiTrades.Active_Tab

		if !IsNum(activeTab) || (activeTab = 0)
			Return
			
		tabContent := GUI_Trades.GetTabContent(activeTab)
		tabPID := tabContent.PID

		if WinExist("ahk_group POEGameGroup ahk_pid " tabPID) {
			uniqueNum := !uniqueNum
			keysState := GetKeyStateFunc("Ctrl,LCtrl,RCtrl")
			if (btnType = "Custom") {
				Loop {
					actionIndex := A_Index
					actionType := PROGRAM.SETTINGS["SETTINGS_CUSTOM_BUTTON_" btnNum]["Action_" actionIndex "_Type"]
					actionContent := PROGRAM.SETTINGS["SETTINGS_CUSTOM_BUTTON_" btnNum]["Action_" actionIndex "_Content"]

					if (actionType = "" || actionType = "ERROR")
						Break
					else if (actionType = "COPY_ITEM_INFOS")
						doCopyActionAtEnd := True

					if (actionType != "COPY_ITEM_INFOS")
						Do_Action(actionType, actionContent, , uniqueNum)
				}

				if (doCopyActionAtEnd = True) {
					Sleep 100
					Do_Action("COPY_ITEM_INFOS", "", , uniqueNum)
				}
			}
			else if (btnType = "Special") {
				actionType := PROGRAM.SETTINGS["SETTINGS_SPECIAL_BUTTON_" btnNum]["Type"]
				actionType := actionType="Clipboard" ? "COPY_ITEM_INFOS"
					: actionType="Whisper" ? "WRITE_TO_BUYER"
					: actionType="Invite" ? "INVITE_BUYER"
					: actionType="Trade" ? "TRADE_BUYER"
					: actionType="Kick" ? "KICK_BUYER"
					: ""
				actionContent := ACTIONS_FORCED_CONTENT[actionType]

				if (actionType) {
					Do_Action(actionType, actionContent)
					if (actionType = "INVITE_BUYER")
						GUI_Trades.ShowActiveTabItemGrid()
				}
			}
			SetKeyStateFunc(keysState)
		}
		else { ; Instance doesn't exist anymore, replace and do btn action
			runningInstances := Get_RunningInstances()
			if !(runningInstances.Count) {
				TrayNotifications.Show("No game instance found.", "No running game instance could be found.`nMake sure the game is running before trying again.")
				Return
			}
			newInstancePID := GUI_ChooseInstance.Create(runningInstances, "PID").PID

			Loop % GuiTrades.Tabs_Count {
				loopTabContent := GUI_Trades.GetTabContent(A_Index)
				loopTabPID := loopTabContent.PID

				if (loopTabPID = tabPID)
					GUI_Trades.UpdateSlotContent(A_Index, "PID", newInstancePID)
			}
			GUI_Trades.DoTradeButtonAction(btnNum, btnType)
		}
	}

	Redraw() {
		Gui, Trades: +LastFound
		WinSet, Redraw
	}

	SaveStats(tabName) {
		global PROGRAM, DEBUG
		iniFile := PROGRAM.TRADES_HISTORY_FILE

		tabContent := GUI_Trades.GetTabContent(tabName)

		if (DEBUG.settings.use_chat_logs || tabContent.Buyer = "iSellStuff") {
			TrayNotifications.Show("iSellStuff.", "The tab stats for tab with seller ""iSellStuff"" will not be saved.")
			Return
		}

		index := INI.Get(iniFile, "GENERAL", "Index")
		index := IsNum(index) ? index : 0

		index++
		existsAlready := INI.Get(iniFile, index, "Buyer")
		existsAlready := existsAlready = "ERROR" || existsAlready = "" ? False : True
		if (existsAlready = True) {
			MsgBox(4096, "", "There was an error when trying to save the Stats for this trade."
				. "`nIt seems there is already a trade saved with ID """ index """."
				. "The tool will now verify for the next ID. If this error appears again, please report it.")
			Loop {
				index++
				existsAlready := INI.Get(iniFile, index, "Buyer")
				if (existsAlready = "ERROR" || existsAlready = "")
					Break
			}
			MsgBox(4096, "", "Successfully found available ID: """ index """.")
		}
		INI.Set(iniFile, "GENERAL", "Index", index)

		correspondingIniKey := { "":""
		, Buyer: "Buyer"
		, BuyerGuild: "Guild"
		, Item: "Item"
		, ItemLevel: "Item_Level"
		, ItemName: "Item_Name"
		, ItemQuality: "Item_Quality"
		, Price: "Price"
		, Stash: "Location"
		, StashLeague: "Location_League"
		, StashPosition: "Location_Position"
		, StashTab: "Location_Tab"
		, "":"" }

		INI.Set(iniFile, index, "TimeStamp", tabContent.TimeYear "-" tabContent.TimeMonth "-" tabContent.TimeStamp)
		INI.Set(iniFile, index, "Date_YYYYMMDD", tabContent.TimeYear "-" tabContent.TimeMonth "-" tabContent.TimeDay)
		INI.Set(iniFile, index, "Time", tabContent.TimeHour ":" tabContent.TimeMinute)
		for key, value in tabContent {
			iniKey := correspondingIniKey[key]
			if (iniKey)
				INI.Set(iniFile, index, iniKey, tabContent[key])
			else if (key = "Other") {
				otherIndex := 0
				Loop, Parse, value, `n, `r
				{
					if !InStr(A_LoopField, "message(s). Hold click to see more.") {
						otherIndex++
						INI.Set(iniFile, index, "Other_" otherIndex, A_LoopField)
					}
				}
			}
		}
	}

	Toggle_MinMax() {
		global GuiTrades

		if (GuiTrades.Is_Maximized)
			GUI_Trades.Minimize()
		else 
			GUI_Trades.Maximize()
	}

	SelectNextTab() {
		global GuiTrades
		tabsCount := GuiTrades.Tabs_Count
		activeTab := GuiTrades.Active_Tab

		if !IsNum(activeTab)
			Return

		if (tabsCount > activeTab)
			GUI_Trades.SetActiveTab(activeTab+1)
		else if (tabsCount = activeTab)
			GUI_Trades.SetActiveTab(1)
	}

	SelectPreviousTab() {
		global GuiTrades
		tabsCount := GuiTrades.Tabs_Count
		activeTab := GuiTrades.Active_Tab

		if !IsNum(activeTab)
			Return

		if (activeTab != 1)
			GUI_Trades.SetActiveTab(activeTab-1)
		else if (activeTab = 1)
			GUI_Trades.SetActiveTab(tabsCount)
	}

	CopyItemInfos(_tabID="") {
		global GuiTrades
		tabID := _tabID="" ? GuiTrades.Active_Tab : _tabID

		tabContent := GUI_Trades.GetTabContent(tabID)
		item := tabContent.Item, whisLang := tabContent.WhisperLang
		if RegExMatch(item, "O)(.*?) \(Lvl:(.*?) \/ Qual:(.*?)%\)", itemPat) {
			gemName := itemPat.1, gemLevel := itemPat.2, gemQual := itemPat.3
		}
		else if RegExMatch(item, "O)(.*?) \(T(.*?)\)", itemPat) {
			mapName := itemPat.1, mapTier := itemPat.2
		}

		if (gemName) {
			Gui_Trades_CopyItemInfos_GemString:
			searchLvlPrefix := whisLang = "ENG" ? "l" ; level
				: whisLang = "RUS" ? "ь" ; Уровень
				: whisLang = "FRE" ? "u" ; Niveau
				: whisLang = "POR" ? "l" ; Nível
				: whisLang = "THA" ? "ล" ; เลเวล
				: whisLang = "GER" ? "e" ; Stufe
				: whisLang = "SPA" ? "l" ; Nivel
				: "l"
			searchQualPrefix := whisLang = "ENG" ? "y" ; quality
				: whisLang = "RUS" ? "о" ; Качество
				: whisLang = "FRE" ? "é" ; Qualité
				: whisLang = "POR" ? "e" ; Qualidade
				: whisLang = "THA" ? "พ" ; คุณภาพ
				: whisLang = "GER" ? "t" ; Qualität
				: whisLang = "SPA" ? "d" ; Calidad
				: "y"

			searchGemStr := """" gemName """"
			searchLvlStr := """" searchLvlPrefix ": " gemLevel """"
			searchQualStr := """" searchQualPrefix ": +" gemQual "%"""
			searchString := searchGemStr
			searchString .= (gemLevel && !gemQual)?(" " searchLvlStr):(gemLevel && gemQual)?(" " searchLvlStr " " searchQualStr):("")

			searchStrLen := StrLen(searchString)
			if (searchStrLen > 50) {
				charsToRemove := searchStrLen-50
				StringTrimRight, gemName, gemName, %charsToRemove%
				GoTo Gui_Trades_CopyItemInfos_GemString
			}
		}
		else if (mapName) {
			Gui_Trades_CopyItemInfos_MapString:
			searchMapStr := mapName, searchTierStr := "tier:" mapTier
			searchString := searchMapStr
			searchString .= (mapTier)?(" " searchTierStr):("")

			searchStrLen := StrLen(searchString)
			if (searchStrLen > 50) {
				charsToRemove := searchStrLen-50
				StringTrimRight, mapName, mapName, %charsToRemove%
				GoTo Gui_Trades_CopyItemInfos_MapString
			}
		}
		else { ; Remove numbers from str, so we only keep item name
			searchString := RegExReplace(item, "\d")
			AutoTrimStr(searchString)
		}

		clipContent := (searchString)?(searchString):(item)
		if (clipContent) {
			Set_Clipboard(clipContent)
		}
	}

	Get_Styles() {
		global PROGRAM, SKIN

		skinSettings := SKIN.Settings
		skinAssets := SKIN.Assets


		skinColors := skinSettings.COLORS
		
		colorTitleActive 			:= (skinColors.Title_Trades = "0x000000")?("Black"):(skinColors.Title_Trades)
		colorTitleInactive 			:= (skinColors.Title_No_Trades = "0x000000")?("Black"):(skinColors.Title_No_Trades)
		colorTradesInfos1 			:= (skinColors.Trades_Infos_1 = "0x000000")?("Black"):(skinColors.Trades_Infos_1)
		colorTradesInfos2 			:= (skinColors.Trades_Infos_2 = "0x000000")?("Black"):(skinColors.Trades_Infos_2)
		colorBorder 				:= (skinColors.Border = "0x000000")?("Black"):(skinColors.Border)

		colorButtonNormal 			:= (skinColors.Button_Normal = "0x000000")?("Black"):(skinColors.Button_Normal)
		colorButtonHover 			:= (skinColors.Button_Hover = "0x000000")?("Black"):(skinColors.Button_Hover)
		colorButtonPress 			:= (skinColors.Button_Press = "0x000000")?("Black"):(skinColors.Button_Press)

		colorTabActive 				:= (skinColors.Tab_Active = "0x000000")?("Black"):(skinColors.Tab_Active)
		colorTabInactive 			:= (skinColors.Tab_Inactive = "0x000000")?("Black"):(skinColors.Tab_Inactive)
		colorTabHover 				:= (skinColors.Tab_Hover = "0x000000")?("Black"):(skinColors.Tab_Hover)
		colorTabPress 				:= (skinColors.Tab_Press = "0x000000")?("Black"):(skinColors.Tab_Press)

		colorTabJoinedActive 		:= (skinColors.Tab_Joined_Active = "0x000000")?("Black"):(skinColors.Tab_Joined_Active)
		colorTabJoinedInactive 		:= (skinColors.Tab_Joined_Inactive = "0x000000")?("Black"):(skinColors.Tab_Joined_Inactive)
		colorTabJoinedHover 		:= (skinColors.Tab_Joined_Hover = "0x000000")?("Black"):(skinColors.Tab_Joined_Hover)
		colorTabJoinedPress 		:= (skinColors.Tab_Joined_Press = "0x000000")?("Black"):(skinColors.Tab_Joined_Press)

		colorTabWhisperActive 		:= (skinColors.Tab_Whisper_Active = "0x000000")?("Black"):(skinColors.Tab_Whisper_Active)
		colorTabWhisperInactive 	:= (skinColors.Tab_Whisper_Inactive = "0x000000")?("Black"):(skinColors.Tab_Whisper_Inactive)
		colorTabWhisperHover 		:= (skinColors.Tab_Whisper_Hover = "0x000000")?("Black"):(skinColors.Tab_Whisper_Hover)
		colorTabWhisperPress 		:= (skinColors.Tab_Whisper_Press = "0x000000")?("Black"):(skinColors.Tab_Whisper_Press)

		pngTransColor 				:= (skinAssets.Misc.Transparency_Color = "0x000000")?("Black"):(skinAssets.Misc.Transparency_Color)

		Tab 				:=	[ [0, skinAssets.Tab.Inactive, "", colorTabInactive, "", pngTransColor]			; normal
		              			, [0, skinAssets.Tab.Hover, "", colorTabHover, "", pngTransColor]				; hover
		    	      			, [0, skinAssets.Tab.Press, "", colorTabPress, "", pngTransColor]				; pressed
								, [0, skinAssets.Tab.Active, "", colorTabActive, "", pngTransColor] ]			; disabled (defaulted)

		Tab_Joined 			:=	[ [0, skinAssets.Tab_Joined.Inactive, "", colorTabJoinedInactive, "", pngTransColor]
		              			, [0, skinAssets.Tab_Joined.Hover, "", colorTabJoinedHover, "", pngTransColor]
		    	      			, [0, skinAssets.Tab_Joined.Press, "", colorTabJoinedPress, "", pngTransColor]
							  	, [0, skinAssets.Tab_Joined.Active, "", colorTabJoinedActive, "", pngTransColor] ]

		Tab_Whisper 		:=	[ [0, skinAssets.Tab_Whisper.Inactive, "", colorTabWhisperInactive, "", pngTransColor]
		              			, [0, skinAssets.Tab_Whisper.Hover, "", colorTabWhisperHover, "", pngTransColor]
		    	      			, [0, skinAssets.Tab_Whisper.Press, "", colorTabWhisperPress, "", pngTransColor]
							  	, [0, skinAssets.Tab_Whisper.Active, "", colorTabWhisperActive, "", pngTransColor] ]

		Arrow_Left 			:=	[ [0, skinAssets.Arrow_Left.Normal, "", colorButtonNormal, "", pngTransColor]
		              			, [0, skinAssets.Arrow_Left.Hover, "", colorButtonHover, "", pngTransColor]
		    	      			, [0, skinAssets.Arrow_Left.Press, "", colorButtonPress, "", pngTransColor] ]

		Arrow_Right 		:=	[ [0, skinAssets.Arrow_Right.Normal, "", colorButtonNormal, "", pngTransColor]
		              			, [0, skinAssets.Arrow_Right.Hover, "", colorButtonHover, "", pngTransColor]
		    	      			, [0, skinAssets.Arrow_Right.Press, "", colorButtonPress, "", pngTransColor] ]

		Button_OneThird 	:=	[ [0, skinAssets.Button_OneThird.Normal, "", colorButtonNormal, "", pngTransColor]
		              			, [0, skinAssets.Button_OneThird.Hover, "", colorButtonHover, "", pngTransColor]
		    	      			, [0, skinAssets.Button_OneThird.Press, "", colorButtonPress, "", pngTransColor] ]

		Button_TwoThird 	:=	[ [0, skinAssets.Button_TwoThird.Normal, "", colorButtonNormal, "", pngTransColor]
		              			, [0, skinAssets.Button_TwoThird.Hover, "", colorButtonHover, "", pngTransColor]
		    	      			, [0, skinAssets.Button_TwoThird.Press, "", colorButtonPress, "", pngTransColor] ]

		Button_ThreeThird 	:=	[ [0, skinAssets.Button_ThreeThird.Normal, "", colorButtonNormal, "", pngTransColor]
		              			, [0, skinAssets.Button_ThreeThird.Hover, "", colorButtonHover, "", pngTransColor]
		    	      			, [0, skinAssets.Button_ThreeThird.Press, "", colorButtonPress, "", pngTransColor] ]

		Button_Special 		:=	[ [0, skinAssets.Button_Special.Normal, "", colorButtonNormal, "", pngTransColor]
		              			, [0, skinAssets.Button_Special.Hover, "", colorButtonHover, "", pngTransColor]
		    	      			, [0, skinAssets.Button_Special.Press, "", colorButtonPress, "", pngTransColor] ]

		Close_Tab 			:=	[ [0, skinAssets.Close_Tab.Normal, "", colorButtonNormal, "", pngTransColor]
		              			, [0, skinAssets.Close_Tab.Hover, "", colorButtonHover, "", pngTransColor]
		    	      			, [0, skinAssets.Close_Tab.Press, "", colorButtonPress, "", pngTransColor] ]

		Minimize 			:=	[ [0, skinAssets.Minimize.Normal, "", colorButtonNormal, "", pngTransColor]
		              			, [0, skinAssets.Minimize.Hover, "", colorButtonHover, "", pngTransColor]
		    	      			, [0, skinAssets.Minimize.Press, "", colorButtonPress, "", pngTransColor] ]

		Maximize 			:=	[ [0, skinAssets.Maximize.Normal, "", colorButtonNormal, "", pngTransColor]
		              			, [0, skinAssets.Maximize.Hover, "", colorButtonHover, "", pngTransColor]
		    	      			, [0, skinAssets.Maximize.Press, "", colorButtonPress, "", pngTransColor] ]

		returnArr := {Tab:Tab, Tab_Joined:Tab_Joined, Tab_Whisper:Tab_Whisper, Arrow_Left:Arrow_Left, Arrow_Right:Arrow_Right, Button_OneThird:Button_OneThird
					, Button_TwoThird:Button_TwoThird, Button_ThreeThird:Button_ThreeThird, Button_Special:Button_Special, Close_Tab:Close_Tab,Minimize:Minimize,Maximize:Maximize
					, Arrow_Left_Use_Character:skinAssets.Arrow_Left.Use_Character, Arrow_Right_Use_Character:skinAssets.Arrow_Right.Use_Character, Close_Tab_Use_Character:skinAssets.Close_Tab.Use_Character}

		Return returnArr
	}

	GetTabsRange() {
		global GuiTrades, GuiTrades_Controls
		tabsCount := GuiTrades.Tabs_Count

		gui, trades:+OwnDialogs

		firstVisibleTab := ""
		lastVisibleTab := ""

		Loop % tabsCount {
			GuiControlGet, isVisible, Trades:Visible,% GuiTrades["Tab_" A_Index]
			if (firstVisibleTab = "" && isVisible)
				firstVisibleTab := A_Index
			if (isVisible)
				lastVisibleTab := A_Index
		}
		Return [firstVisibleTab, lastVisibleTab]
	}

	GetActiveTab() {
		global GuiTrades, GuiTrades_Controls
		GuiControlGet, tabActive, Trades:,% GuiTrades_Controls.hTab_AllTabs
		return tabActive		
	}

	ScrollTabs(scrollDirection) {
		global GuiTrades, GuiTrades_Controls
		tabsCount := GuiTrades.Tabs_Count
		maxTabsPerRow := GuiTrades.Max_Tabs_Per_Row

		tabRange := GUI_Trades.GetTabsRange()
		firstVisibleTab := tabRange.1, lastVisibleTab := tabRange.2

		Gui, Trades:+OwnDialogs

		if (scrollDirection = "Left" && firstVisibleTab = 1) || (scrollDirection = "Right" && lastVisibleTab = tabsCount) { ; Cannot go more in said direciton
			Return
		}
		else if (scrollDirection = "Left") {
			newFirstVisibleTab := firstVisibleTab-1
			newLastVisibleTab := lastVisibleTab-1

			tabMoving := newFirstVisibleTab
			While (tabMoving != lastVisibleTab) {
				tabX := GuiTrades["TabButton" A_Index "_X"] ; Get tab slot X pos
				GuiControl, Trades:Move,% GuiTrades_Controls["hBTN_TabDefault" tabMoving],% "x" tabX ; Move tab to said pos
				GuiControl, Trades:Move,% GuiTrades_Controls["hBTN_TabJoinedArea" tabMoving],% "x" tabX ; Move tab to said pos
				GuiControl, Trades:Move,% GuiTrades_Controls["hBTN_TabWhisperReceived" tabMoving],% "x" tabX ; Move tab to said pos
				tabMoving++ ; Move onto the next tab to move
			}

			GuiControl, Trades:Show,% GuiTrades["Tab_" newFirstVisibleTab] ; Show new tab on left most
			GuiControl, Trades:Hide,% GuiTrades["Tab_" lastVisibleTab] ; Hide previous tab on right most
		}
		else if (scrollDirection = "Right") {
			newFirstVisibleTab := firstVisibleTab+1
			newLastVisibleTab := lastVisibleTab+1

			tabMoving := firstVisibleTab+1
			While (tabMoving != newLastVisibleTab) {
				tabX := GuiTrades["TabButton" A_Index "_X"] ; Get tab slot X pos
				GuiControl, Trades:Move,% GuiTrades_Controls["hBTN_TabDefault" tabMoving],% "x" tabX ; Move tab to said pos
				GuiControl, Trades:Move,% GuiTrades_Controls["hBTN_TabJoinedArea" tabMoving],% "x" tabX ; Move tab to said pos
				GuiControl, Trades:Move,% GuiTrades_Controls["hBTN_TabWhisperReceived" tabMoving],% "x" tabX ; Move tab to said pos
				tabMoving++ ; Move onto the next tab to move
			}

			GuiControl, Trades:Show,% GuiTrades["Tab_" newLastVisibleTab] ; Show new tab on right most
			GuiControl, Trades:Hide,% GuiTrades["Tab_" firstVisibleTab] ; Hide previous tab on left most
		}
	}

	RemoveTab(tabName="", massRemove=False) {
		global PROGRAM, SKIN
		global GuiTrades, GuiTrades_Controls, GuiTradesMinimized_Controls
		tabsLimit := GuiTrades.Tabs_Limit
		tabsCount := GuiTrades.Tabs_Count
		maxTabsPerRow := GuiTrades.Max_Tabs_Per_Row
		tabRange := GUI_Trades.GetTabsRange(), firstVisibleTab := tabRange.1, lastVisibleTab := tabRange.2

		if (tabName = "")
			tabName := Gui_Trades.GetActiveTab()

		if !IsNum(tabName) {
			AppendToLogs(A_ThisFunc "(tabName=" tabName ", massRemove=" massRemove "): Failed to remove tab due to not being a number.")
			Return
		}

		if (tabName = 1 && tabsCount = 1 && tabsLimit > 20) { ; We had more tabs allocated than default (20) and last tab
			Gui_Trades.Create() ;								has been closed, recreate the GUI with default value
			Return
		}

		; Set new tabs content
		if (tabName < tabsCount) {
			tabIndex := tabName+1
			Loop % tabsCount-tabName {
				tabContent := GUI_Trades.GetTabContent(tabIndex) ; Get tab content
				GUI_Trades.SetTabContent(tabIndex-1, tabContent, isNewlyPushed:=False, updateOnly:=False, replaceTab:=True) ; Set tab content to previous tab

				tabIndex++
			}
			GUI_Trades.SetTabContent(tabIndex-1, "") ; Make last tab empty
			GUI_Trades.SetTabStyleDefault(tabIndex-1)
		}
		else if (tabName = tabsCount) {
			GUI_Trades.SetTabContent(tabName, "")
			GUI_Trades.SetTabStyleDefault(tabName)
		}

		; Move tabs if needed
		if (lastVisibleTab = tabsCount) {
			GUI_Trades.ScrollTabs("Left")
		}
		; Change active tab if needed
		if (GUI_Trades.GetActiveTab() = tabsCount) && (tabsCount != 1) {
			GUI_Trades.SetActiveTab(tabsCount-1, False) ; autoScroll=False
		}
		; Hide tab assets is required
		else if (tabsCount = 1) {
			GUI_Trades.ToggleTabSpecificAssets("OFF")
			GUI_Trades.SetActiveTab("No Trades On Queue")
		}
		else if (tabsCount > tabName) && (massRemove=False) ; Re-activate same
			GUI_Trades.SetActiveTab(tabName)

		GuiControl, Trades:Hide,% GuiTrades["Tab_" tabsCount]
		GuiTrades.Tabs_Count--

		if (GuiTrades.Tabs_Count = 0) {
			GuiControl,Trades:,% GuiTrades_Controls["hTEXT_Title"],% "POE Trades Companion"
			GuiControl,TradesMinimized:,% GuiTradesMinimized_Controls["hTEXT_Title"],% "(0)"
			GuiControl,% "Trades: +c" SKIN.Settings.COLORS.Title_No_Trades,% GuiTrades_Controls["hTEXT_Title"]
			GuiControl,% "TradesMinimized: +c" SKIN.Settings.COLORS.Title_No_Trades,% GuiTradesMinimized_Controls["hTEXT_Title"]
			if (PROGRAM.SETTINGS.SETTINGS_MAIN.AllowClicksToPassThroughWhileInactive = "True")
				Gui_Trades.Enable_ClickThrough()
			if (PROGRAM.SETTINGS.SETTINGS_MAIN.AutoMinimizeOnAllTabsClosed = "True")
				Gui_Trades.Minimize("True")
			GUI_Trades.SetTransparency_Inactive()
			Gui_Trades.Redraw()
		}
		else {
			GuiControl,Trades:,% GuiTrades_Controls["hTEXT_Title"],% "POE Trades Companion (" GuiTrades.Tabs_Count ")"
			GuiControl,Trades:,% GuiTradesMinimized_Controls["hTEXT_Title"],% "(" GuiTrades.Tabs_Count ")"
		}
	}

	RecreateGUI(tabsLimit="") {
		global GuiTrades
		tabsCount := GuiTrades.Tabs_Count
		maxTabsPerRow := GuiTrades.Max_Tabs_Per_Row
		tabRange := GUI_Trades.GetTabsRange()

		if (tabsLimit = "")
			tabsLimit := GuiTrades.Tabs_Limit

		currentActiveTab := GUI_Trades.GetActiveTab() ; Get current active tab
		Loop % tabsCount { ; Get all tabs content
			tabInfos%A_Index% := GUI_Trades.GetTabContent(A_Index)
		}
		
		if (tabsLimit)
			Gui_Trades.Create(tabsLimit) ; Recreate GUI with more tabs
		else
			Gui_Trades.Create() ; No limit specific, just use default limit
		Loop % tabsCount { ; Set tabs content
			GUI_Trades.PushNewTab(tabInfos%A_Index%)
		}
		GUI_Trades.SetActiveTab(currentActiveTab) ; Reactivate the tab we were on

		if (tabRange.2 > currentActiveTab && tabRange.2 > maxTabsPerRow) { ; Set the range as it was
			Loop % tabRange.2-currentActiveTab
				GUI_Trades.ScrollTabs("Right")
		}

		if (tabsCount) {
			Gui_Trades.SetTransparency_Active()
			Gui_Trades.Disable_ClickThrough()
		}
		else  {
			Gui_Trades.SetTransparency_Inactive()
			if (PROGRAM.SETTINGS.SETTINGS_MAIN.AllowClicksToPassThroughWhileInactive = "True")
			Gui_Trades.Enable_ClickThrough()
		}
	}

	IncreaseTabsLimit() {
		global GuiTrades
		tabsLimit := GuiTrades.Tabs_Limit

		nextTabsLimit := (tabsLimit=20)?(50):(tabsLimit=50)?(100):(tabsLimit=100)?(251):("ERROR") ; Set next limit
		if (nextTabsLimit = "ERROR") {
			MsgBox(4096, "", "Error when deciding the tabs limit. Current limit: """ tabsLimit """")
			Return
		}
		
		GUI_Trades.RecreateGUI(nextTabsLimit)
	}

	IsTabAlreadyExisting(tabInfos) {
		global GuiTrades, GuiTrades_Controls

		Loop % GuiTrades.Tabs_Count {
			loopedTabInfos := Gui_Trades.GetTabContent(A_Index)
			if (tabInfos.Buyer = loopedTabInfos.Buyer)
			&& (tabInfos.Item = loopedTabInfos.Item)
			&& (tabInfos.Price = loopedTabInfos.Price)
			&& (tabInfos.Stash = loopedTabInfos.Stash)
				Return A_Index
		}
	}

	PushNewTab(tabInfos) {
		global PROGRAM, SKIN
		global GuiTrades, GuiTrades_Controls, GuiTradesMinimized_Controls
		tabsLimit := GuiTrades.Tabs_Limit
		tabsCount := GuiTrades.Tabs_Count
		maxTabsPerRow := GuiTrades.Max_Tabs_Per_Row
		tabRange := GUI_Trades.GetTabsRange()


		hadNoTab := tabsCount = 0 ? True : False

		existingTabID := Gui_Trades.IsTabAlreadyExisting(tabInfos)
		if (existingTabID) {
			; Gui_Trades.UpdateSlotContent(existingTabID, "Other", tabInfos.Other) ; Disabled. Useless?
			Return "TabAlreadyExists"
		}
		if GUI_Trades.IsTrade_In_IgnoreList(tabInfos) {
			AppendToLogs(A_ThisFunc "(): Canceled creating new tab due to trade being in ignore list:" 
			. "Buyer: """ tabInfos.Buyer """ - Item: """ tabInfos.Item """ - Price: """ tabInfos.Price """ - Stash:""" tabInfos.Stash """")
			return "TabIgnored"
		}

		; Need to allocate more tabs
		if (tabsCount+1 >= tabsLimit) {
			Gui_Trades.IncreaseTabsLimit()
		}

		GUI_Trades.SetTabContent(tabsCount+1, tabInfos, isNewlyPushed:=True)

		if IsBetween(tabsCount+1, 1, maxTabsPerRow) { ; Show new tab btn if its in the row
			GuiControl, Trades:Show,% GuiTrades["Tab_" tabsCount+1]
		}
		GuiTrades.Tabs_Count++

		if (!tabsCount) { ; First tab, make sure controls are shown
			GUI_Trades.ToggleTabSpecificAssets("ON")
			GUI_Trades.SetActiveTab(1)
			GUI_Trades.SetTransparency_Active()
		}
		else if (PROGRAM.SETTINGS.SETTINGS_MAIN.AutoFocusNewTabs = "True")
			GUI_Trades.SetActiveTab(GuiTrades.Tabs_Count)

		if (hadNoTab) {
			if (PROGRAM.SETTINGS.SETTINGS_MAIN.AutoMaximizeOnFirstNewTab = "True")
				Gui_Trades.Maximize("True")
		}

		if (GuiTrades.Tabs_Count > 0) {
			GuiControl,Trades:,% GuiTrades_Controls["hTEXT_Title"],% "POE Trades Companion (" GuiTrades.Tabs_Count ")"
			GuiControl,TradesMinimized:,% GuiTradesMinimized_Controls["hTEXT_Title"],% "(" GuiTrades.Tabs_Count ")"
			GuiControl,% "Trades: +c" SKIN.Settings.COLORS.Title_Trades,% GuiTrades_Controls["hTEXT_Title"]
			GuiControl,% "TradesMinimized: +c" SKIN.Settings.COLORS.Title_Trades,% GuiTradesMinimized_Controls["hTEXT_Title"]
			Gui_Trades.Disable_ClickThrough()
			Gui_Trades.Redraw()
		}

		Loop % GuiTrades.Tabs_Count {
			tabContent := GUI_Trades.GetTabContent(A_Index)
			if (tabContent.Buyer = tabInfos.Buyer && tabContent.IsInArea = True) {
				GUI_Trades.SetTabStyleJoinedArea(tabInfos.Buyer)
				Break
			}
		}

		if (tabContent.HasNewMessage = True)
			GUI_Trades.SetTabStyleWhisperReceived(tabContent.Buyer)

		tabContent := GUI_Trades.GetTabContent(GuiTrades.Tabs_Count)
		; GUI_Trades.VerifyItemPrice(tabContent, ) ; TO_DO disabled bcs it lags the script, need to see if we can do the request without interupting script. until then, user needs to click on color dot
	}

	GenerateUniqueID() {
		return RandomStr(l := 24, i := 48, x := 122)
	}

	GetTabNumberFromUniqueID(uniqueID) {
		global GuiTrades
		tabsCount := GuiTrades.Tabs_Count

		Loop %tabsCount% {
			tabContent := Gui_Trades.GetTabContent(A_Index)
			if (tabContent.UniqueID = uniqueID)
				found := A_Index
		}
		if !(found) {
			AppendToLogs(A_ThisFunc "(uniqueId=" uniqueId "): Couldn't find any tab ID matching this unique ID")
			MsgBox("", "", "Unable to find matching tab ID with unique id """ uniqueID """")
			return
		}

		return found
	}

	VerifyItemPrice(tabInfos) {
		global PROGRAM, SKIN
		accounts := PROGRAM.SETTINGS.SETTINGS_MAIN.PoeAccounts

		if RegExMatch(tabInfos.Item, "iO)(\d+\.\d+|\d+) (\D+)", itemPat) { ; its a currency trade
			RegExMatch(tabInfos.Price, "iO)(\d+\.\d+|\d+) (\D+)", pricePat)
			wantCount := itemPat.1, wantWhat := itemPat.2
			wantCurInfos := Get_CurrencyInfos(wantWhat)
			wantFullName := wantCurInfos.Name, wantID := PROGRAM["DATA"]["POETRADE_CURRENCY_DATA"][wantFullName].ID, isWantListed := wantCurInfos.Is_Listed
			giveCount := pricePat.1, giveWhat := pricePat.2
			giveCurInfos := Get_CurrencyInfos(giveWhat)
			giveFullName := giveCurInfos.Name, giveID := PROGRAM["DATA"]["POETRADE_CURRENCY_DATA"][giveFullName].ID, isGiveListed := giveCurInfos.Is_Listed
			sellBuyRatio := RemoveTrailingZeroes(wantCount/giveCount)

			Loop, Parse, accounts,% ","
			{
				poeTradeObj := {"league": tabInfos.StashLeague, "online": "x", "want": wantID, "have": giveID}
				itemURL := PoeTrade_GetCurrencySearchUrl(poeTradeObj)

				poeTradeObj.username := A_LoopField
				poeTradeObj.sellcurrency := wantID, poeTradeObj.sellvalue := wantCount
				poeTradeObj.buycurrency := giveID, poeTradeObj.buyvalue := giveCount
				poeTradeObj.sellBuyRatio := sellBuyRatio

				if (itemURL)
					matchingObj := PoETrade_GetMatchingCurrencyTradeData(poeTradeObj, itemURL)

				if matchingObj.MaxIndex() {
					foundMatch := True
					Break
				}
			}

			tabID := GUI_Trades.GetTabNumberFromUniqueID(tabInfos.UniqueID)

			_infos .= ""
			if (foundMatch) {
				Loop % matchingObj.MaxIndex() { ; Loop through matchs
					legitRatio := matchingObj[A_Index].IsSameRatio
					ratioTxt := "poe.trade: 1 " giveFullName " = " matchingObj[A_Index].sellBuyRatio " " wantFullName
						. "\nwhisper: 1 " giveFullName " = " sellBuyRatio " " wantFullName
					
					if (legitRatio=True) { ; If ratio is the same
						_infos := "Ratio is the same."
						. "\n" ratioTxt
						vColor := "Green"
						Break
					}
					else if (matchingObj[A_Index].sellBuyRatio > sellBuyRatio) { ; Or if ratio is higher
						_infos := "Ratio is higher."
						. "\n" ratioTxt
						vColor := "Green"
						Break
					}
					else { ; Otherwise, currency either not listed or ratio modified
						if (!isWantListed || !isGiveListed) {
							wantListedInfos := isWantListed=True?"" : "\nUnknown currency type: """ wantFullName """"
							giveListedInfos := isGiveListed=True?"" : "\nUnknown currency type: """ giveFullName """"
							_infos := wantListedInfos . giveListedInfos "\nPlease report it."
							vColor := "Orange"
						}
						else {
							_infos := "Ratio is lower."
							. "\n" ratioTxt
							vColor := "Red"
						}
					}
				}
			}
			else {
				if (tabInfos.WhisperLang != "ENG") {
					_infos := "Cannot verify price for"
					. "\npathofexile.com/trade translated whispers."
					vColor := "Orange"
				}
				else {
					_infos := "Could not find any item matching the same currency trade."
					. "\nMake sure to set your account name in the settings."
					. "\nAccounts: " accounts
					vColor := "Orange"
				}
			}

			GUI_Trades.SetTabVerifyColor(tabID, vColor)
			GUI_Trades.UpdateSlotContent(tabID, "TradeVerifyInfos", _infos)
		}
		else { ; its a regular trade
			itemQualNoPercent := StrReplace(tabInfos.ItemQuality, "%", "")
			RegExMatch(tabInfos.StashPosition, "O)(.*);(.*)", stashPosPat)
			stashPosX := stashPosPat.1, stashPosY := stashPosPat.2
			RegExMatch(tabInfos.Price, "O)(\d+\.\d+|\d+) (\D+)", pricePat)
			priceNum := pricePat.1, priceCurrency := pricePat.2
			AutoTrimStr(priceNum, pricePat)
			
			currencyInfos := Get_CurrencyInfos(priceCurrency)
			poeTradeCurrencyName := PoeTrade_Get_CurrencyAbridgedName_From_FullName(currencyInfos.Name)
			poeTradePrice := priceNum " " poeTradeCurrencyName

			Loop, Parse, accounts,% ","
			{
				poeTradeObj := {"name": tabInfos.ItemName, "buyout": poeTradePrice
				, "level_min": tabInfos.ItemLevel, "level_max": tabInfos.ItemLevel
				, "q_min": itemQualNoPercent, "q_max": itemQualNoPercent
				, "league": tabInfos.StashLeague, "seller": A_LoopField}
				itemURL := PoeTrade_GetItemSearchUrl(poeTradeObj)
				
				poeTradeObj.seller := A_LoopField, poeTradeObj.level := poeTradeObj.level_max
				poeTradeObj.quality := poeTradeObj.q_max, poeTradeObj.tab := tabInfos.StashTab
				poeTradeObj.x := stashPosX,	poeTradeObj.y := stashPosY, poeTradeObj.online := ""

				matchingObj := PoeTrade_GetMatchingItemData(poeTradeObj, itemURL)

				if IsObject(matchingObj) {
					foundMatch := True
					Break
				}
			}

			tabID := GUI_Trades.GetTabNumberFromUniqueID(tabInfos.UniqueID)

			_infos := ""
			if (foundMatch) {
				if (poeTradeObj.buyout = matchingObj.buyout) {
					_infos := "Price confirmed legit."
					. "\npoe.trade: " matchingObj.buyout
					. "\nwhisper: " poeTradeObj.buyout
					vColor := "Green"
				}
				else {
					if (currencyInfos.Name = "") {
						_infos := "/!\ Cannot verify unpriced items yet. /!\"
						vColor := "Orange"
						
					}
					else if (!currencyInfos.Is_Listed) {
						_infos := "Unknown currency name: """ currencyInfos.Name """"
						. "\nPlease report it."
						vColor := "Orange"
					}
					else if (currencyInfos.Is_Listed && poeTradeObj.buyout != matchingObj.buyout) {
						_infos := "Price is different."
						. "\npoe.trade: " matchingObj.buyout
						. "\nwhisper " poeTradeObj.buyout
						vColor := "Red"
					}

				}
			}
			else {
				if (tabInfos.WhisperLang != "ENG") {
					_infos := "Cannot verify price for"
					. "\npathofexile.com/trade translated whispers."
					vColor := "Orange"
				}
				else {
					_infos := "Could not find any item matching the same stash location"
					. "\nMake sure to set your account name in the settings."
					. "\nAccounts: " accounts
					vColor := "Orange"
				}
			}

			GUI_Trades.SetTabVerifyColor(tabID, vColor)
			GUI_Trades.UpdateSlotContent(tabID, "TradeVerifyInfos", _infos)
		}
	}

	SetTabVerifyColor(tabID, colour) {
		global GuiTrades_Controls

		if !IsIn(colour, "Grey,Orange,Green,Red") || !IsNum(tabID) {
			AppendToLogs(A_ThisFunc "(tabID=" tabID ", colour=" colour "): Invalid colour or tabID is not a number.")
			MsgBox("", "", "Invalid use of " A_ThisFunc "`n`ntabID: """ tabID """`ncolour: """ colour """")
			return
		}

		newColHwnd := GuiTrades_Controls["hIMG_TradeVerify" colour tabID]
		curColHwnd := GuiTrades_Controls["hIMG_TradeVerify" tabID]

		if (newColHwnd != curColHwnd) {
			GuiControl, Trades:Show,% newColHwnd
			GuiControl, Trades:Hide,% curColHwnd
			GuiTrades_Controls["hIMG_TradeVerify" tabID] := newColHwnd

			Gui_Trades.UpdateSlotContent(tabID, "TradeVerify", colour)
		}
	}

	UpdateSlotContent(tabName, slotName, newContent) {
		global GuiTrades_Controls

		tabContent := GUI_Trades.GetTabContent(tabName)
		if (slotName = "Other") {
			otherSlotContent := Gui_Trades.GetTabContent(tabName).Other
			mergedCurrendAndNew := otherSlotContent?otherSlotContent "`n" newContent : newContent

			finalOtherStr := "", msgCount := 0
			Loop, Parse, mergedCurrendAndNew, `n, `r
			{
				parsedMsg := A_LoopField, timeStamp := ""
				AutoTrimStr(parsedMsg)
				
				if !InStr(A_LoopField, " messages(s). Hold click to see more.") && (parsedMsg != "") {
					if !RegExMatch(A_LoopField, "[\d+:\d+]")
						timeStamp := "[" A_Hour ":" A_Min "] "

					finalOtherStr := finalOtherStr?finalOtherStr "`n" timeStamp . A_LoopField : timeStamp . A_LoopField
					msgCount++
				}
			}
			finalOtherStr := msgCount " messages(s). Hold click to see more.`n" finalOtherStr

			GUI_Trades.SetTabContent(tabName, {Other:finalOtherStr}, isNewlyPushed:=False, updateOnly:=True)
		}
		else if (slotName = "IsInArea") {
			GUI_Trades.SetTabContent(tabName, {IsInArea:newContent}, isNewlyPushed:=False, updateOnly:=True)
		}
		else if (slotName = "HasNewMessage") {
			GUI_Trades.SetTabContent(tabName, {HasNewMessage:newContent}, isNewlyPushed:=False, updateOnly:=True)
		}
		else if (slotName = "PID") {
			GUI_Trades.SetTabContent(tabName, {PID:newContent}, isNewlyPushed:=False, updateOnly:=True)
		}
		else if (slotName = "TradeVerify") {
			GUI_Trades.SetTabContent(tabName, {TradeVerify:newContent}, isNewlyPushed:=False, updateOnly:=True)
		}
		else if (slotName = "TradeVerifyInfos") {
			GUI_Trades.SetTabContent(tabName, {TradeVerifyInfos:newContent}, isNewlyPushed:=False, updateOnly:=True)
		}
		else if (slotName = "WithdrawTally") {
			GUI_Trades.SetTabContent(tabName, {WithdrawTally:newContent}, isNewlyPushed:=False, updateOnly:=True)
		}
		else if (slotName = "IsBuyerInvited") {
			GUI_Trades.SetTabContent(tabName, {IsBuyerInvited:newContent}, isNewlyPushed:=False, updateOnly:=True)
		}
	}

	GetTabContent(tabName) {
		global GuiTrades_Controls

		GuiControlGet, visibleInfos, Trades:,% GuiTrades_Controls["hTEXT_TradeInfos" tabName]
		GuiControlGet, invisibleInfos, Trades:,% GuiTrades_Controls["hTEXT_HiddenTradeInfos" tabName]
		GuiControlGet, timeReceived, Trades:,% GuiTrades_Controls["hTEXT_TradeReceivedTime" tabName]

		visibleInfosArr := {}
		Loop, Parse, visibleInfos, `n, `r
		{
			if RegExMatch(A_LoopField, "O)Buyer:" A_Tab "(.*)", buyerPat)
				visibleInfosArr.Buyer := buyerPat.1
			else if RegExMatch(A_LoopField, "O)Item:" A_Tab "(.*)", itemPat)
				visibleInfosArr.Item := itemPat.1
			else if RegExMatch(A_LoopField, "O)Price:" A_Tab "(.*)", pricePat)
				visibleInfosArr.Price := pricePat.1
			else if RegExMatch(A_LoopField, "O)Stash:" A_Tab "(.*)", stashPat)
				visibleInfosArr.Stash := stashPat.1
			else if RegExMatch(A_LoopField, "O)Other:" A_Tab "(.*)", otherPat) 
				visibleInfosArr.Other := otherPat.1, lastWasOther := True
			else if (lastWasOther)
				visibleInfosArr.Other := visibleInfosArr.Other "`n" A_LoopField
		}

		invisibleInfosArr := {}
		Loop, Parse, invisibleInfos, `n, `r
		{
			if RegExMatch(A_LoopField, "O)BuyerGuild:" A_Tab "(.*)", buyerGuildPat)
				invisibleInfosArr.BuyerGuild := buyerGuildPat.1
			else if RegExMatch(A_LoopField, "O)TimeStamp:" A_Tab "(.*)", timeStampPat)
				invisibleInfosArr.TimeStamp := timeStampPat.1
			else if RegExMatch(A_LoopField, "O)PID:" A_Tab "(.*)", pidPat)
				invisibleInfosArr.PID := pidPat.1
			else if RegExMatch(A_LoopField, "O)IsInArea:" A_Tab "(.*)", isInAreaPat)
				invisibleInfosArr.IsInArea := isInAreaPat.1
			else if RegExMatch(A_LoopField, "O)HasNewMessage:" A_Tab "(.*)", hasNewMessagePat)
				invisibleInfosArr.HasNewMessage := hasNewMessagePat.1
			else if RegExMatch(A_LoopField, "O)WithdrawTally:" A_Tab "(.*)", withdrawTallyPat)
				invisibleInfosArr.WithdrawTally := withdrawTallyPat.1
			else if RegExMatch(A_LoopField, "O)ItemName:" A_Tab "(.*)", itemNamePat)
				invisibleInfosArr.ItemName := itemNamePat.1
			else if RegExMatch(A_LoopField, "O)ItemLevel:" A_Tab "(.*)", itemLevelPat)
				invisibleInfosArr.ItemLevel := itemLevelPat.1
			else if RegExMatch(A_LoopField, "O)ItemQuality:" A_Tab "(.*)", itemQualityPat)
				invisibleInfosArr.ItemQuality := itemQualityPat.1
			else if RegExMatch(A_LoopField, "O)StashLeague:" A_Tab "(.*)", stashLeaguePat)
				invisibleInfosArr.StashLeague := stashLeaguePat.1
			else if RegExMatch(A_LoopField, "O)StashTab:" A_Tab "(.*)", stashTabPat)
				invisibleInfosArr.StashTab := stashTabPat.1
			else if RegExMatch(A_LoopField, "O)StashPosition:" A_Tab "(.*)", stashPositionPat)
				invisibleInfosArr.StashPosition := stashPositionPat.1
			else if RegExMatch(A_LoopField, "O)TimeYear:" A_Tab "(.*)", timeYearPat)
				invisibleInfosArr.TimeYear := timeYearPat.1
			else if RegExMatch(A_LoopField, "O)TimeMonth:" A_Tab "(.*)", timeMonthPat)
				invisibleInfosArr.TimeMonth := timeMonthPat.1
			else if RegExMatch(A_LoopField, "O)TimeDay:" A_Tab "(.*)", timeDayPat)
				invisibleInfosArr.TimeDay := timeDayPat.1
			else if RegExMatch(A_LoopField, "O)TimeHour:" A_Tab "(.*)", timeHourPat)
				invisibleInfosArr.TimeHour := timeHourPat.1
			else if RegExMatch(A_LoopField, "O)TimeMinute:" A_Tab "(.*)", timeMinPat)
				invisibleInfosArr.TimeMinute := timeMinPat.1
			else if RegExMatch(A_LoopField, "O)TimeSecond:" A_Tab "(.*)", timeSecPat)
				invisibleInfosArr.TimeSecond := timeSecPat.1
			else if RegExMatch(A_LoopField, "O)UniqueID:" A_Tab "(.*)", uniqueIDPat)
				invisibleInfosArr.UniqueID := uniqueIDPat.1
			else if RegExMatch(A_LoopField, "O)TradeVerify:" A_Tab "(.*)", tradeVerifyPat)
				invisibleInfosArr.TradeVerify := tradeVerifyPat.1
			else if RegExMatch(A_LoopField, "O)WhisperSite:" A_Tab "(.*)", whisperSitePat)
				invisibleInfosArr.WhisperSite := whisperSitePat.1
			else if RegExMatch(A_LoopField, "O)TradeVerifyInfos:" A_Tab "(.*)", tradeVerifyInfosPat)
				invisibleInfosArr.TradeVerifyInfos := tradeVerifyInfosPat.1
			else if RegExMatch(A_LoopField, "O)IsBuyerInvited:" A_Tab "(.*)", isBuyerInvitedPat)
				invisibleInfosArr.IsBuyerInvited := isBuyerInvitedPat.1
			else if RegExMatch(A_LoopField, "O)WhisperLang:" A_Tab "(.*)", whisperLangPat)
				invisibleInfosArr.WhisperLang := whisperLangPat.1
		}

		tabContent := {}
		for key, value in visibleInfosArr
			tabContent[key] := value
		for key, value in invisibleInfosArr
			tabContent[key] := value
		tabContent["Time"] := timeReceived

		return tabContent
	}

	SetTabContent(tabName, tabInfos="", isNewlyPushed=False, updateOnly=False, replaceTab=False) {
		global GuiTrades_Controls

		if !IsNum(tabName) {
			MsgBox(4096, "", A_ThisFunc ": Invalid tab name: """ tabName """"
			. "`nEither the tab is not a number, or it has not been created yet.")
			Return
		}

		currentTabContent := GUI_Trades.GetTabContent(tabName)
		cTabCont := GUI_Trades.GetTabContent(tabName)

		; newTabBuyer := (tabInfos.Buyer != "")?(tabInfos.Buyer):(currentTabContent.Buyer)
		; newTabItem := (tabInfos.Item != "")?(tabInfos.Item):(currentTabContent.Item)
		; newTabPrice := (tabInfos.Price != "")?(tabInfos.Price):(currentTabContent.Price)
		; newTabStash := (tabInfos.Stash != "")?(tabInfos.Stash):(currentTabContent.Stash)
		; newTabOther := (isNewlyPushed)?(""):(tabInfos.Other != "")?(tabInfos.Other):(currentTabContent.Other)
		newTabBuyer := updateOnly && !tabInfos.Buyer ? cTabCont.Buyer : tabInfos.Buyer
		newTabItem := updateOnly && !tabInfos.Item ? cTabCont.Item : tabInfos.Item
		newTabPrice := updateOnly && !tabInfos.Price ? cTabCont.Price : tabInfos.Price
		newTabStash := updateOnly && !tabInfos.Stash ? cTabCont.Stash : tabInfos.Stash
		newTabOther := updateOnly && !tabInfos.Other ? cTabCont.Other : tabInfos.Other		

		visibleText := ""
		.		"Buyer:"	 A_Tab newTabBuyer
		. "`n"	"Item:"		 A_Tab newTabItem
		. "`n"	"Price:"	 A_Tab newTabPrice
		. "`n"	"Stash:"	 A_Tab newTabStash
		. "`n"	"Other:"	 A_Tab newTabOther

		; newTabBuyerGuild := (tabInfos.BuyerGuild != "")?(tabInfos.BuyerGuild):(currentTabContent.BuyerGuild)
		; newTabTimeStamp := (tabInfos.TimeStamp != "")?(tabInfos.TimeStamp) : (currentTabContent.TimeStamp)?(currentTabContent.TimeStamp) : (A_YYYY "/" A_MM "/" A_DD " " A_Hour ":" A_Min ":" A_Sec)
		; newTabPID := (tabInfos.PID != "")?(tabInfos.PID):(currentTabContent.PID)
		; newTabIsInArea := (tabInfos.IsInArea != "")?(tabInfos.IsInArea):(currentTabContent.IsInArea)
		; newTabHasNewMessage := (tabInfos.HasNewMessage != "")?(tabInfos.HasNewMessage):(currentTabContent.HasNewMessage)
		; newTabWithdrawTally := (tabInfos.WithdrawTally != "")?(tabInfos.WithdrawTally):(currentTabContent.WithdrawTally)
		newTabBuyerGuild := updateOnly && !tabInfos.BuyerGuild ? cTabCont.BuyerGuild : tabInfos.BuyerGuild
		newTabTimeStamp := updateOnly && !tabInfos.TimeStamp ? cTabCont.TimeStamp : tabInfos.TimeStamp
		newTabPID := updateOnly && !tabInfos.PID ? cTabCont.PID : tabInfos.PID
		newTabIsInArea := updateOnly && !tabInfos.IsInArea ? cTabCont.IsInArea : tabInfos.IsInArea
		newTabHasNewMessage := updateOnly && !tabInfos.HasNewMessage ? cTabCont.HasNewMessage : tabInfos.HasNewMessage
		newTabWithdrawTally := updateOnly && !tabInfos.WithdrawTally ? cTabCont.WithdrawTally : tabInfos.WithdrawTally

		if RegExMatch(newTabStash, "O)(.*)\(Tab:(.*) / Pos:(.*)\)", newTabStashPat)
			stashLeague := newTabStashPat.1, stashTab := newTabStashPat.2, stashPosition := newTabStashPat.3
		else
			stashLeague := newTabStash

		if RegExMatch(newTabItem, "O)(.*)\(Lvl:(.*) / Qual:(.*)\)", itemPat) {
			itemName := itemPat.1, itemLevel := itemPat.2, itemQuality := itemPat.3
		}
		else
			itemName := newTabItem

		if RegExMatch(newTabTimeStamp, "O)(.*)/(.*)/(.*) (.*):(.*):(.*)", timeStampPat) {
			timeYear := timeStampPat.1, timeMonth := timeStampPat.2, timeDay := timeStampPat.3
			timeHour := timeStampPat.4, timeMin := timeStampPat.5, timeSec := timeStampPat.6
		}

		; newTabItemName := (tabInfos.ItemName != "")?(tabInfos.ItemName) : (itemName)?(itemName) : (currentTabContent.ItemName)
		; newTabItemLevel := (tabInfos.ItemLevel != "")?(tabInfos.ItemLevel) : (itemLevel)?(itemLevel) : (currentTabContent.ItemLevel)
		; newTabItemQuality := (tabInfos.ItemQuality != "")?(tabInfos.ItemQuality) : (itemQuality)?(itemQuality) : (currentTabContent.ItemQuality)
		; newTabStashLeague := (tabInfos.StashLeague != "")?(tabInfos.StashLeague) : (stashLeague)?(stashLeague) : (currentTabContent.StashLeague)
		; newTaStashTab := (tabInfos.StashTab != "")?(tabInfos.StashTab) : (stashTab)?(stashTab) : (currentTabContent.StashTab)
		; newTabStashPosition := (tabInfos.StashPosition != "")?(tabInfos.StashPosition) : (stashPosition)?(stashPosition) : (currentTabContent.StashPosition)
		; newTabUniqueID := (tabInfos.UniqueID != "")?(tabInfos.UniqueID):(currentTabContent.UniqueID)?(currentTabContent.UniqueID) : ( GUI_Trades.GenerateUniqueID() )
		; newTradeVerify := (tabInfos.TradeVerify != "")?(tabInfos.TradeVerify):(currentTabContent.TradeVerify)?(currentTabContent.TradeVerify):("Grey")
		; newWhisperSite := (tabInfos.WhisperSite != "")?(tabInfos.WhisperSite):(currentTabContent.WhisperSite)
		; newTradeVerifyInfos := (tabInfos.TradeVerifyInfos != "")?(tabInfos.TradeVerifyInfos):(currentTabContent.TradeVerifyInfos)
		newTabItemName := updateOnly && !tabInfos.ItemName ? cTabCont.ItemName : itemName
		newTabItemLevel := updateOnly && !tabInfos.ItemLevel ? cTabCont.ItemLevel : itemLevel
		newTabItemQuality := updateOnly && !tabInfos.ItemQuality ? cTabCont.ItemQuality : itemQuality
		newTabStashLeague := updateOnly && !tabInfos.StashLeague ? cTabCont.StashLeague : stashLeague
		newTaStashTab := updateOnly && !tabInfos.StashTab ? cTabCont.StashTab : stashTab
		newTabStashPosition := updateOnly && !tabInfos.StashPosition ? cTabCont.StashPosition : stashPosition
		newTabUniqueID := updateOnly && !tabInfos.UniqueID ? cTabCont.UniqueID : tabInfos.UniqueID
		newTradeVerify := updateOnly && !tabInfos.TradeVerify ? cTabCont.TradeVerify : tabInfos.TradeVerify
		newWhisperSite := updateOnly && !tabInfos.WhisperSite ? cTabCont.WhisperSite : tabInfos.WhisperSite
		newTradeVerifyInfos := updateOnly && !tabInfos.TradeVerifyInfos ? cTabCont.TradeVerifyInfos : tabInfos.TradeVerifyInfos
		newIsBuyerInvited := updateOnly && !tabInfos.IsBuyerInvited ? cTabCont.IsBuyerInvited : tabInfos.IsBuyerInvited
		newWhisperLang := updateOnly && !tabInfos.WhisperLang ? cTabCont.WhisperLang : tabInfos.WhisperLang

		AutoTrimStr(newTabBuyer, newTabItem, newTabPrice, newTabStash, newTabOther, newTabBuyerGuild, newTabTimeStamp, newTabPID, newTabIsInArea, newTabHasNewMessage)
		AutoTrimStr(newTabWithdrawTally, newTabItemName, newTabItemLevel, newTabItemQuality, newTabStashLeague, newTabStashTab, newTabStashPosition)
		AutoTrimStr(newTabUniqueID, newTradeVerify, newWhisperSite, newTradeVerifyInfos, newIsBuyerInvited, newWhisperLang)
				
		invisibleText := ""
		. 		"BuyerGuild:"		A_Tab newTabBuyerGuild
		. "`n" 	"TimeStamp:"		A_Tab newTabTimeStamp
		. "`n" 	"PID:"				A_Tab newTabPID
		. "`n" 	"IsInArea:"	 		A_Tab newTabIsInArea
		. "`n" 	"HasNewMessage:"	A_Tab newTabHasNewMessage
		. "`n" 	"WithdrawTally:"	A_Tab newTabWithdrawTally
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
		. "`n"	"TradeVerify:"		A_Tab newTradeVerify
		. "`n"	"WhisperSite:"		A_Tab newWhisperSite
		. "`n" 	"TradeVerifyInfos:"	A_Tab newTradeVerifyInfos
		. "`n" 	"IsBuyerInvited:"	A_Tab newIsBuyerInvited
		. "`n" 	"WhisperLang:"		A_Tab newWhisperLang

		; newTimeReceived := (currentTabContent.Time)?(currentTabContent.Time):(timeReceived)
		newTimeReceived := updateOnly && !tabInfos.Time ? cTabCont.Time : tabInfos.Time

		GuiControl, Trades:,% GuiTrades_Controls["hTEXT_TradeInfos" tabName],% visibleText
		GuiControl, Trades:,% GuiTrades_Controls["hTEXT_HiddenTradeInfos" tabName],% invisibleText
		GuiControl, Trades:,% GuiTrades_Controls["hTEXT_TradeReceivedTime" tabName],% newTimeReceived
		if (updateOnly=False && newTradeVerify)
			GUI_Trades.SetTabVerifyColor(tabName, newTradeVerify)

		if IsNum(tabName) && (updateOnly=True || replaceTab=True) {
			if (newTabIsInArea && (!cTabCont.IsInArea || replaceTab=True) )
				GUI_Trades.SetTabStyleJoinedArea(tabName)
			if (newTabHasNewMessage && (!cTabCont.HasNewMessage || replaceTab=True) )
				GUI_Trades.SetTabStyleWhisperReceived(tabName)

			else if (!newTabIsInArea && !newTabHasNewMessage)
				GUI_Trades.SetTabStyleDefault(tabName)
		}

		if (visibleInfos.Other && isNewlyPushed) {
			Gui_Trades.UpdateSlotContent(tabName, "Other", visibleInfos.Other)
		}
	}

	ToggleTabSpecificAssets(state="") {
		global GuiTrades_Controls
		if (state = "ON")
			whatDo := "Show"
		else if (state = "OFF")
			whatDo := "Hide"
		else Return

		for ctrlName, ctrlHandle in GuiTrades_Controls {
			; if || InStr(ctrlName, "hBTN_TabDefault")
			; || InStr(ctrlName, "hBTN_TabJoinedArea")
			; || InStr(ctrlName, "hBTN_TabWhisperReceived")
			if InStr(ctrlName, "hIMG_TabsBackground")
			|| InStr(ctrlName, "hIMG_TabsUnderline")
			|| InStr(ctrlName, "hBTN_LeftArrow")
			|| InStr(ctrlName, "hBTN_RightArrow")
			|| InStr(ctrlName, "hBTN_CloseTab")
			|| InStr(ctrlName, "hTEXT_TradeInfos")
			|| InStr(ctrlName, "hTEXT_TradeReceivedTime")
			|| InStr(ctrlName, "hBTN_Special")
			|| InStr(ctrlName, "hBTN_Custom") 
				GuiControl, Trades:%whatDo%,% ctrlHandle
		}
	}

	SetActiveTab(tabName, autoScroll=True, skipError=False, styleChanged=False) {
		global PROGRAM, GuiTrades, GuiTrades_Controls
		tabRange := GUI_Trades.GetTabsRange()
		tabsCount := GuiTrades.Tabs_Count

		tabName := tabName="0"?"No Trades On Queue" : tabName

		if IsNum(tabName) && !IsBetween(tabName, 1, tabsCount) {
			if (skipError=False)
				MsgBox(48, "", "Cannot select tab """ tabName """ because it exceed the tabs count (" tabsCount ")")

			return
		}

		GuiControl, Trades:Choose,% GuiTrades_Controls.hTab_AllTabs,% tabName

		if ( autoScroll && IsNum(tabName) && !IsBetween(tabName, tabRange.1, tabRange.2) ) {
			if (tabName < tabRange.1) {
				diff := tabRange.1-tabName
				Loop % diff
					Gui_Trades.ScrollTabs("Left")
			}
			else if (tabName > tabRange.2) {
				diff := tabName-tabRange.2
				Loop % diff
					Gui_Trades.ScrollTabs("Right")
			}
		}

		Loop % tabsCount {
			if (A_Index = tabName) {
				GuiControl, Trades:+Disabled,% GuiTrades["Tab_" A_Index]
			}
			else 
				GuiControl, Trades:-Disabled,% GuiTrades["Tab_" A_Index]
		}

		tabContent := GUI_Trades.GetTabContent(tabName)
		if (tabContent.IsBuyerInvited = True)
			GUI_Trades.ShowActiveTabItemGrid()
		else
			GUI_Trades.DestroyItemGrid()
		; Don't do these if only the tab style changed.
		; Avoid an issue where upon removing a tab, it would copy the item infos again due to the tab style func re-activating the tab
		if (styleChanged=False) {
			if (PROGRAM.SETTINGS.SETTINGS_MAIN.CopyItemInfosOnTabChange = "True" && IsNum(tabName)) {
				GoSub, GUI_Trades_CopyItemInfos_CurrentTab_Timer
			}
		}

		GuiTrades.Active_Tab := tabName
	}

	
	Maximize(skipAnimation="") {
		global GuiTrades

		if !(GuiTrades.Is_Created)
			return
		
		GUI_TradesMinimized.Maximize()

		/* ; Old code, changing gui size
		global GuiTrades, GuiTrades_Controls
		global PROGRAM

		resDPI := Get_DpiFactor()

		hiddenWin := A_DetectHiddenWindows
		DetectHiddenWindows, On
		WinMove,% "ahk_id " GuiTrades.Handle, , , , ,% GuiTrades.Height_Maximized * resDPI ; change size first to avoid btn flicker
		DetectHiddenWindows, %hiddenWin%

		GuiControl, Trades:Show,% GuiTrades_Controls.hBTN_Minimize
		GuiControl, Trades:Hide,% GuiTrades_Controls.hBTN_Maximize

		GuiControl, Trades:Show,% GuiTrades_Controls.hPROGRESS_BorderBottom
		GuiControl, Trades:Hide,% GuiTrades_Controls.hPROGRESS_BorderBottomMinimized

		if ( GUI_ItemGrid.Exists())
			GUI_Trades.ShowActiveTabItemGrid()

		GuiTrades.Is_Maximized := True
		GuiTrades.Is_Minimized := False
		; GUI_Trades.ToggleTabSpecificAssets("On")
		*/
	}

	Minimize(skipAnimation="") {
		global GuiTrades

		if !(GuiTrades.Is_Created)
			return

		GuiTrades.Is_Maximized := False
		GuiTrades.Is_Minimized := True

		hiddenWin := A_DetectHiddenWindows
		DetectHiddenWindows, On
		GUI_TradesMinimized.Show()
		DetectHiddenWindows, %hiddenWin%

		if ( GUI_ItemGrid.Exists() )
			GUI_ItemGrid.Hide()

		/* ; Old code, changing gui size
		global GuiTrades, GuiTrades_Controls
		global PROGRAM

		resDPI := Get_DpiFactor()

		hiddenWin := A_DetectHiddenWindows
		DetectHiddenWindows, On
		WinMove,% "ahk_id " GuiTrades.Handle, , , , ,% GuiTrades.Height_Minimized * resDPI
		DetectHiddenWindows, %hiddenWin%

		GuiControl, Trades:Show,% GuiTrades_Controls.hBTN_Maximize
		GuiControl, Trades:Hide,% GuiTrades_Controls.hBTN_Minimize

		GuiControl, Trades:Show,% GuiTrades_Controls.hPROGRESS_BorderBottomMinimized
		GuiControl, Trades:Hide,% GuiTrades_Controls.hPROGRESS_BorderBottom

		if ( GUI_ItemGrid.Exists() )
			GUI_ItemGrid.Hide()

		GuiTrades.Is_Maximized := False
		GuiTrades.Is_Minimized := True
		; GUI_Trades.ToggleTabSpecificAssets("Off")
		; TO_DO Possibly hide tabs to avoid overlap on border?
		*/
	}

	OnGuiMove(GuiHwnd) {
		/*	Allow dragging the GUI 
		*/
		global PROGRAM
		if ( PROGRAM.SETTINGS.SETTINGS_MAIN.TradesGUI_Mode = "Window" && PROGRAM.SETTINGS.SETTINGS_MAIN.TradesGUI_Locked = "False" ) {
			PostMessage, 0xA1, 2,,,% "ahk_id " GuiHwnd
		}
		KeyWait, LButton, Up
		Gui_Trades.SavePosition()
		; Gui_Trades.RemoveButtonFocus()
	}

	SetTransparencyPercent(transPercent) {
		global GuiTrades

		if !IsNum(transPercent) {
			AppendToLogs(A_ThisFunc "(transPercent=" transPercent "): Not a number. Setting transparency to max.")
			transValue := 255
		}
		else
			transValue := (255/100)*transPercent

		Gui, Trades:+LastFound
		WinSet, Transparent,% transValue
		Gui, TradesMinimized:+LastFound
		WinSet, Transparent,% transValue
	}

	SetTransparency_Automatic() {
		global GuiTrades
		if (GuiTrades.Tabs_Count = 0)
			GUI_Trades.SetTransparency_Inactive()
		else
			GUI_Trades.SetTransparency_Active()
	}

	SetTransparency_Inactive() {
		global PROGRAM, GuiTrades
		transPercent := PROGRAM.SETTINGS.SETTINGS_MAIN.NoTabsTransparency
		Gui_Trades.SetTransparencyPercent(transPercent)
		if (transPercent = 0)
			GUI_Trades.Enable_ClickThrough()
	}

	SetTransparency_Active() {
		global PROGRAM, GuiTrades
		transPercent := PROGRAM.SETTINGS.SETTINGS_MAIN.TabsOpenTransparency
		Gui_Trades.SetTransparencyPercent(transPercent)
	}

	Enable_ClickThrough() {
		global PROGRAM, GuiTrades
		Gui, Trades: +LastFound
		WinSet, ExStyle, +0x20
		Gui, TradesMinimized: +LastFound
		WinSet, ExStyle, +0x20
	}

	Disable_ClickThrough() {
		global GuiTrades
		Gui, Trades: +LastFound
		WinSet, ExStyle, -0x20
		Gui, TradesMinimized: +LastFound
		WinSet, ExStyle, -0x20
	}

	ResetPosition(dontWrite=False) {
		global PROGRAM, GuiTrades, GuiTradesMinimized

		resDPI := PROGRAM.OS.RESOLUTION_DPI
		iniFile := PROGRAM.INI_FILE

		resDPI := Get_DpiFactor()

		try {
			if (GuiTrades.Is_Minimized)
				Gui, TradesMinimized:Show,% "NoActivate x" Ceil(A_ScreenWidth - (GuiTradesMinimized.Width * resDPI) ) " y0"
			else Gui, Trades:Show,% "NoActivate x" Ceil(A_ScreenWidth - (GuiTrades.Width * resDPI) ) " y0"
			
			if !(dontWrite) {
				if (GuiTrades.Is_Minimized)
					INI.Set(iniFile, "SETTINGS_MAIN", "Pos_X", Ceil(A_ScreenWidth - (GuiTradesMinimized.Width * resDPI) ) )
				else INI.Set(iniFile, "SETTINGS_MAIN", "Pos_X", Ceil(A_ScreenWidth - (GuiTrades.Width * resDPI) ) )
				INI.Set(iniFile, "SETTINGS_MAIN", "Pos_Y", 0)
			}
		}
		catch e {
			AppendToLogs(A_ThisFunc "(dontWrite=" dontWrite "): Failed to set GUI pos based on screen width. Setting to 0,0.")
			if (GuiTrades.Is_Minimized)
				Gui, TradesMinimized:Show,% "NoActivate x0 y0"
			else Gui, Trades:Show,% "NoActivate x0 y0"
			
			if !(dontWrite) {
				INI.Set(iniFile, "SETTINGS_MAIN", "Pos_X", 0)
				INI.Set(iniFile, "SETTINGS_MAIN", "Pos_Y", 0)
			}
		}
	}

	Use_WindowMode(checkOnly=False) {
		global PROGRAM, GuiTrades

		if (checkOnly=False) {
			INI.Set(PROGRAM.INI_FILE, "SETTINGS_MAIN", "TradesGUI_Mode", "Window")
			GuiTrades.Docked_Window_Handle := ""

			GUI_Trades.ResetPosition()
		}

		Menu, Tray, UnCheck, Mode: Dock
		Menu, Tray, Check, Mode: Window
		Menu, Tray, Disable, Cycle Dock

		INI.Set(PROGRAM.INI_FILE, "SETTINGS_MAIN", "TradesGUI_Locked", "False")
		PROGRAM.SETTINGS.SETTINGS_MAIN.TradesGUI_Locked := "False"
	}

	Use_DockMode(checkOnly=False) {
		global PROGRAM, GuiTrades

		if (checkOnly=False) {
			INI.Set(PROGRAM.INI_FILE, "SETTINGS_MAIN", "TradesGUI_Mode", "Dock")
			GuiTrades.Docked_Window_Handle := ""

			GUI_Trades.ResetPosition()
		}

		Menu, Tray, Check, Mode: Dock
		Menu, Tray, UnCheck, Mode: Window
		Menu, Tray, Enable, Cycle Dock

		Tray_ToggleLockPosition("Check")

		GUI_Trades.DockMode_Cycle()
	}

	RemoveButtonFocus() {
		global GuiTrades
		ControlFocus,,% "ahk_id " GuiTrades.Handle ; Remove focus
	}

	SavePosition() {
		global PROGRAM, GuiTrades

		WinGetPos, xpos, ypos, , ,% "ahk_id " GuiTrades.Handle
		if !IsNum(xpos) || !IsNum(ypos)
			Return

		INI.Set(PROGRAM.INI_FILE, "SETTINGS_MAIN", "Pos_X", xpos)
		INI.Set(PROGRAM.INI_FILE, "SETTINGS_MAIN", "Pos_Y", ypos)
	}

	DockMode_Cycle(dontSetPos=False) {
		global GuiTrades

		gameInstances := Get_RunningInstances()
		Loop % gameInstances.Count {
			if (gameInstances[A_Index]["Hwnd"] = GuiTrades.Docked_Window_Handle)
				cycleIndex := A_Index=gameInstances.Count ? 1 : A_Index+1
		}
		cycleIndex := cycleIndex ? cycleIndex : 1
		GuiTrades.Docked_Window_Handle := gameInstances[cycleIndex]["Hwnd"]

		if (dontSetPos=False)
			Gui_Trades.DockMode_SetPosition()
	}

	DockMode_SetPosition() {
		global GuiTrades, GuiTradesMinimized

		WinGet, isMinMax, MinMax,% "ahk_id " GuiTrades.Docked_Window_Handle
		isWinMinimized := isMinMax=-1?True:False

		WinGetPos, dockedX, dockedY, dockedW, dockedH,% "ahk_id " GuiTrades.Docked_Window_Handle
		WinGetPos, tradesX, tradesY, tradesW, tradesH,% "ahk_id " GuiTrades.Handle
		WinGetPos, tradesMinX, tradesMinY, tradesMinW, tradesMinH,% "ahk_id " GuiTradesMinimized.Handle
		
		if (GuiTrades.Is_Minimized)
			moveToX := (dockedX+dockedW)-GuiTradesMinimized.Width, moveToY := dockedY 
		else moveToX := (dockedX+dockedW)-GuiTrades.Width, moveToY := dockedY 

		if IsNum(dockedX) && ( (GuiTrades.Is_Minimized && tradesX = moveToX && tradesY = moveToY) || (GuiTrades.Is_Minimized && tradesMinX = moveToX && tradesMinY = moveToY) )
			Return
		else if !IsNum(dockedX) || (isWinMinimized) {
			AppendToLogs(A_ThisFunc "(): Couldn't dock Trades GUI to game window. Resetting pos and cycling to next game window.")
			GUI_Trades.ResetPosition(dontWrite:=True)
			GUI_Trades.DockMode_Cycle(dontSetPos:=True)
		}
		else {
			if (GuiTrades.Is_Minimized)
				WinMove,% "ahk_id " GuiTradesMinimized.Handle, ,% moveToX,% moveToY
			else WinMove,% "ahk_id " GuiTrades.Handle, ,% moveToX,% moveToY
		}
	}

	SaveBackup() {
	/*		Save all pending trades in a file.
	 */
	 	global PROGRAM, GuiTrades
		tabsCount := GuiTrades.Tabs_Count
		backupFile := PROGRAM.TRADES_BACKUP_FILE

		if (!tabsCount)
			Return

		FileDelete,% backupFile

		currentActiveTab := GUI_Trades.GetActiveTab() ; Get current active tab
		Loop % tabsCount { ; Get all tabs content
			tabInfos%A_Index% := GUI_Trades.GetTabContent(A_Index)
		}

		INI.Set(backupFile, "GENERAL", "Count", tabsCount)
		Loop % tabsCount { ; Save tabs content
			loopIndex := A_Index, loopedTab := tabInfos%loopIndex%
			for key, value in loopedTab {
				if (key = "Other") {
					otherIndex := 0
					Loop, Parse, value, `n, `r
					{
						if !InStr(A_LoopField, "message(s). Hold click to see more.") {
							otherIndex++
							INI.Set(backupFile, loopIndex, "Other_" otherIndex, A_LoopField)
						}
					}
				}
				else
					INI.Set(backupFile, loopIndex, key, value)
			}
		}
	}

	LoadBackup() {
	/*		Read the backup file, and send those trades requests to the Trades GUI
	 */
		global PROGRAM
		backupFile := PROGRAM.TRADES_BACKUP_FILE

		if !FileExist(backupFile)
			Return

		savedCount := INI.Get(backupFile, "GENERAL", "Count")
		if !(IsNum(savedCount) && (savedCount > 0))
			Return

		Loop % savedCount {
			loopedCount := A_Index
			sectKeysAndValues := INI.Get(backupFile, loopedCount, , getKeysAndValues:=True)
			thisTabInfos := {}, otherArr := [], otherTxt := ""
			for key, value in sectKeysAndValues {
				if RegExMatch(key, "iO)Other_(\d+)", otherPat)
					otherArr[otherPat.1] := value
				else
					thisTabInfos[key] := value
			}
			for key, value in otherArr
				otherTxt .= key=1?value : "`n" value

			GUI_Trades.PushNewTab(thisTabInfos)
			if (otherTxt)
				GUI_Trades.UpdateSlotContent(A_Index, "Other", otherTxt)
		}
		
		FileDelete,% backupFile
	}

	SetOrUnsetTabStyle(whatDo="", tabStyle="", playerOrTab="", applyToThisTabOnly=False) {
		global GuiTrades, GuiTrades_Controls

		if !(whatDo) || !(playerOrTab) || (!tabStyle) {
			MsgBox(4096, "", "Invalid use of GUI_Trades.SetOrUnsetTabStyle()`n`nwhatDo: " whatDo "`nplayerOrTab: " playerOrTab "`ntabStyle: " tabStyle)
			return
		}

		if IsNum(playerOrTab)
			buyerName := GUI_Trades.GetTabContent(playerOrTab).Buyer
		else
			buyerName := playerOrTab

		if (applyToThisTabOnly=True) && IsNum(playerOrTab) {
			tabContent := Gui_Trades.GetTabContent(playerOrTab)
			buyerTabs := playerOrTab, tab%playerOrTab%IsInArea := tabContent.IsInArea, tab%playerOrTab%HasNewMessage := tabContent.HasNewMessage
		}
		else {
			Loop % GuiTrades.Tabs_Count {
				tabContent := Gui_Trades.GetTabContent(A_Index)
				if (tabContent.Buyer = buyerName) {
					buyerTabs .= A_Index ",", tab%A_Index%IsInArea := tabContent.IsInArea, tab%A_Index%HasNewMessage := tabContent.HasNewMessage
				}
			}
			StringTrimRight, buyerTabs, buyerTabs, 1
		}

		Loop, Parse, buyerTabs,% ","
		{
			styleCurrent := GuiTrades["Tab_" A_LoopField]

			if (whatDo = "Set") {
				newStyle := tabStyle="Default"?GuiTrades_Controls["hBTN_TabDefault" A_LoopField]
					: tabStyle = "JoinedArea"?GuiTrades_Controls["hBTN_TabJoinedArea" A_LoopField]
					: tabStyle = "WhisperReceived"?GuiTrades_Controls["hBTN_TabWhisperReceived" A_LoopField]
					: GuiTrades_Controls["hBTN_TabDefault" A_LoopField]
			}
			else if (whatDo = "UnSet") {
				newStyle := tabStyle="JoinedArea" && tab%A_LoopField%HasNewMessage = True ? GuiTrades_Controls["hBTN_TabWhisperReceived" A_LoopField]
					: tabStyle="JoinedArea" && tab%A_LoopField%HasNewMessage != True ? GuiTrades_Controls["hBTN_TabDefault" A_LoopField]
					: tabStyle="WhisperReceived" && tab%A_LoopField%IsInArea = True ? GuiTrades_Controls["hBTN_TabJoinedArea" A_LoopField]
					: tabStyle="WhisperReceived" && tab%A_LoopField%IsInArea != True ? GuiTrades_Controls["hBTN_TabDefault" A_LoopField]
					: GuiTrades_Controls["hBTN_TabDefault" A_LoopField]
			}

			state := whatDo="Set"? True : False
			tabContent := GUI_Trades.GetTabContent(A_LoopField)
			if (tabStyle = "JoinedArea" && !tabContent.IsInArea)
				Gui_Trades.UpdateSlotContent(A_LoopField, "IsInArea", state)
			else if (tabStyle = "WhisperReceived" && !tabContent.HasNewMessage)
				Gui_Trades.UpdateSlotContent(A_LoopField, "HasNewMessage", state)

			if (styleCurrent != newStyle) {
				if !(whatDo = "Set" && tabStyle = "JoinedArea" && tab%A_LoopField%HasNewMessage = True) { ; Priority: Whisper > Joined > Default. Don't set JoinedArea style if we already have WhisperReceived style
					GuiControl, Trades:Show,% newStyle
					GuiControl, Trades:Hide,% styleCurrent
					GuiTrades["Tab_" A_LoopField] := newStyle
					styleChanged := True
				}
			}
		}

		if (styleChanged = True) {
			GUI_Trades.SetActiveTab( tabName:=GUI_Trades.GetActiveTab(), autoScroll:=True, skipError:=False, styleChanged:=True )
		}
	}

	SetTabStyleDefault(playerOrTab) {
		GUI_Trades.SetOrUnsetTabStyle("Set", "Default", playerOrTab)
	}

	SetTabStyleJoinedArea(playerOrTab) {
		GUI_Trades.SetOrUnsetTabStyle("Set", "JoinedArea", playerOrTab)
	}

	UnSetTabStyleJoinedArea(playerOrTab) {
		GUI_Trades.SetOrUnsetTabStyle("Unset", "JoinedArea", playerOrTab)
	}

	SetTabStyleWhisperReceived(playerOrTab) {
		GUI_Trades.SetOrUnsetTabStyle("Set", "WhisperReceived", playerOrTab)
	}

	UnSetTabStyleWhisperReceived(playerOrTab) {
		GUI_Trades.SetOrUnsetTabStyle("Unset", "WhisperReceived", playerOrTab, applyToThisTabOnly:=True)
	}

	IsTrade_In_IgnoreList(tradeInfos) {
		global TRADES_IGNORE_LIST
		
		for key, value in TRADES_IGNORE_LIST
			ignoreIndex := key

		isInList := False
		Loop % ignoreIndex {
			loopIndex := A_Index
			if (TRADES_IGNORE_LIST[loopIndex].Item = tradeInfos.Item)
			 && (TRADES_IGNORE_LIST[loopIndex].Price = tradeInfos.Price)
			 && (TRADES_IGNORE_LIST[loopIndex].Stash = tradeInfos.Stash) {
			 	isInList := True
				Break
			}
		}
		
		return isInList
	}

	AddActiveTrade_To_IgnoreList() {
		global GuiTrades, TRADES_IGNORE_LIST
		if !IsObject(TRADES_IGNORE_LIST)
			TRADES_IGNORE_LIST := {}

		for key, value in TRADES_IGNORE_LIST
			ignoreIndex := key
		ignoreIndex++
		
		if !IsNum(GuiTrades.Active_Tab) || (GuiTrades.Active_Tab = 0)
			return

		tabContent := GUI_Trades.GetTabContent(GuiTrades.Active_Tab)
		if GUI_Trades.IsTrade_In_IgnoreList(tabContent) {
			AppendToLogs(A_ThisFunc "(): Tab is already in ignore list. Canceling."
			. "`nBuyer: """ tabContent.Buyer """ - Item: """ tabContent.Item """ - Price: """ tabContent.Price """ - Stash: """ tabContent.Stash """")
			return
		}
		if !(tabContent.Item) {
			return
		}

		TRADES_IGNORE_LIST[ignoreIndex+1] := {}
		TRADES_IGNORE_LIST[ignoreIndex+1].Item := tabContent.Item
		TRADES_IGNORE_LIST[ignoreIndex+1].Price := tabContent.Price
		TRADES_IGNORE_LIST[ignoreIndex+1].Stash := tabContent.Stash
		TRADES_IGNORE_LIST[ignoreIndex+1].Time := A_Now
		AppendToLogs(A_ThisFunc "(): Successfully added tab to ignore list."
		. "`nBuyer: """ tabContent.Buyer """ - Item: """ tabContent.Item """ - Price: """ tabContent.Price """ - Stash: """ tabContent.Stash """")
	}
	
	RefreshIgnoreList() {
		global TRADES_IGNORE_LIST
		timeToIgnore := 10 ; Time in mins

		for key, value in TRADES_IGNORE_LIST
			ignoreIndex := key
		Loop % ignoreIndex {
			loopIndex := A_Index
			timeDif := A_Now, timeAdded := TRADES_IGNORE_LIST[loopIndex].Time
			timeDif -= timeAdded, Minutes

			if (timeDif > timeToIgnore) {
				for key, value in TRADES_IGNORE_LIST[loopIndex]
					TRADES_IGNORE_LIST[loopIndex].Delete(key)
				TRADES_IGNORE_LIST.Delete(loopIndex)
				; AppendToLogs(A_ThisFunc "(): Removed item from ignore list after " timeToIgnore "mins.")
			}
		}
	}

	ShowActiveTabItemGrid() {
		global GuiTrades
		static prev_tabXPos, prev_tabYPos, prev_tabStashTab
		static prev_winX, prev_winY, prev_clientInfos

		activeTabID := Gui_Trades.GetActiveTab()
		activeTabInfos := GUI_Trades.GetTabContent(activeTabID)
		tabStashPos := StrSplit(activeTabInfos.StashPosition, ";")
		tabXPos := tabStashPos.1, tabYPos := tabStashPos.2, tabStashTab := activeTabInfos.StashTab

		if !IsNum(tabXPos) || !IsNum(tabYPos)
			return

		if (tabXPos && tabYPos) && WinExist("ahk_pid " activeTabInfos.PID " ahk_group POEGameGroup") {
			WinGetPos, winX, winY, winW, winH,% "ahk_pid " activeTabInfos.PID " ahk_group POEGameGroup"
			clientInfos := GetWindowClientInfos("ahk_pid" activeTabInfos.PID " ahk_group POEGameGroup")

			if RegExMatch(activeTabInfos.Item, ".* \(T(\d+)\)$")
				itemType := "Map"

			if (clientInfos.Y = 0) && IsIn(clientInfos.H, "606,774,870,726,806,966,1030,1056,1086,1206") ; Fix issue where +6 is added to res H
				clientInfos.H -= 6

			isItemGridVisible := GUI_ItemGrid.IsVisible()
			if !(isItemGridVisible) ; if not visible, or visible and one variable changed
			|| (isItemGridVisible) && ( (prev_tabXPos != tabXPos) || (prev_tabYPos != tabYPos) || (prev_tabStashTab != tabStashTab)
			 || (prev_winX != winX) || (prev_winY != winY)
			 || (prev_clientInfos.X != clientInfos.X) || (prev_clientInfos.Y != clientInfos.Y) || (prev_clientInfos.H != clientInfos.H) ) {
				Gui_Trades.UpdateSlotContent(activeTabID, "IsBuyerInvited", True)
				GUI_ItemGrid.Create(tabXPos, tabYPos, tabStashTab, winX, winY, clientInfos.H, clientInfos.X, clientInfos.Y, itemType)
				GuiTrades.ItemGrid_PID := activeTabInfos.PID
			}
		}
		else
			GUI_Trades.DestroyItemGrid()

		prev_tabXPos := tabXPos, prev_tabYPos := tabYPos, prev_tabStashTab := tabStashTab
		prev_winX := winX, prev_winY := winY, prev_clientInfos := clientInfos
	}
	DestroyItemGrid() {
		GUI_ItemGrid.Destroy()
	}

	EnableHotkeys() {
		global GuiTrades, PROGRAM

		codes := ["^SCF","^+SCF","^SC2","^SC3","^SC4","^SC5","^SC6","^SC7","^SC8","^SC9","^SCA","^WheelDown","^WheelUp"]
		for index, code in codes {
			if !IsObject(PROGRAM.HOTKEYS[code]) { ; Don't declare if user has custom hotkey for that. Fix HK working only IG or on TradesGUI (???)
				Hotkey, IfWinActive,% "ahk_id " GuiTrades.Handle
				Hotkey, %code%, GUI_Trades_SelectTab, On
			}
		} 
	}

	DisableHotkeys() {
		global GuiTrades
		if !(GuiTrades.Handle)
			return

		try {
			codes := ["^SCF","^+SCF","^SC2","^SC3","^SC4","^SC5","^SC6","^SC7","^SC8","^SC9","^SCA","^WheelDown","^WheelUp"]
			for index, code in codes { 
				Hotkey, IfWinActive,% "ahk_id " GuiTrades.Handle
				Hotkey, %code%, Off
			}
		}
	}
}

GUI_Trades_SelectTab:
	if IsIn(A_ThisHotkey, "^SC00F,^WheelDown")
		GUI_Trades.SelectNextTab(returnToFirst:=True)
	else if IsIn(A_ThisHotkey, "^+SC00F,^WheelUp")
		GUI_Trades.SelectPreviousTab(returnToFirst:=True)
	else if IsIn(A_ThisHotkey, "^SC002,^SC003,^SC004,^SC005,^SC006,^SC007,^SC008^SC009^SC00A") {
		lastChar := SubStr(A_ThisHotkey, 0, 1)
		tabNum := IsNum(lastChar) ? lastChar-1 : lastChar = "A" ? 9 : 1
		GUI_Trades.SetActiveTab(tabNum, autoScroll:=True, skipWarn:=True)
	}
return

GUI_Trades_RefreshIgnoreList:
	GUI_Trades.RefreshIgnoreList()
return

GUI_Trades_CopyItemInfos_CurrentTab_Timer:
	SetTimer, GUI_Trades_CopyItemInfos_CurrentTab, Delete
	SetTimer, GUI_Trades_CopyItemInfos_CurrentTab, -500
return
GUI_Trades_CopyItemInfos_CurrentTab:
	Gui_Trades.CopyItemInfos()
return