Class TrayNotifications {

	Set() {
		/*	Set default parameters
		*/
		global TRAY_NOTIFICATIONS := {}
	}


	Adjust(fromNum, creationOrder) {
		global TrayNotifications_Handles

		RegExMatch(fromNum, "\d", fromNum)

		Loop, Parse, creationOrder,% ","
		{
			reverse := A_LoopField "," reverse
		}

		Loop, Parse, reverse,% "," 
		{
			if (A_LoopField) {
				
				if (gotem) {
					
					WinGetPos, , pY, , pH,% "ahk_id " TrayNotifications_Handles[previous]
					WinGetPos, , tY, , tH,% "ahk_id " TrayNotifications_Handles[A_LoopField]
					formula := (previous = fromNum)?(pY-(tH-pH)):(py-tH-10)
					WinMove,% "ahk_id " TrayNotifications_Handles[A_LoopField], , ,% formula
				}
				if (A_LoopField = fromNum)
					gotEm := true
				else {
					newOrder .= A_Loopfield ","
				}

				previous := A_Loopfield
			}
		}

		creationOrder := StrReplace(creationOrder, fromNum, "", "")
		Loop, Parse, creationOrder,% ","
		{
			if (A_LoopField)
				finalOrder .= A_LoopField ","
		}

		Return finalOrder
	}

	Show(title, msg, params="") {
	/*		Show a notification.
	 *		Look based on w10 traytip.
	*/
		static
		global SKIN
		global TrayNotifications_Handles
		global PROGRAM

		resDPI := Get_DpiFactor()

	;	Monitor infos
		local MonitorCount, MonitorPrimary, MonitorWorkArea
		local MonitorWorkAreaTop, MonitorWorkAreaBottom, MonitorWorkAreaLeft, MonitorWorkAreaRight
		SysGet, MonitorCount, MonitorCount
		SysGet, MonitorPrimary, MonitorPrimary
		SysGet, MonitorWorkArea, MonitorWorkArea,% MonitorPrimary

		; Calculating GUI size, based on content
		titleWidthMax := 310, textWidthMax := 330
		guiFontName := "Segoe UI", guiFontSize := "9", guiTitleFontSize := "10"

		titleSize := This.Get_Text_Control_Size(title, guiFontName, guiTitleFontSize, titleWidthMax)
		textSize := This.Get_Text_Control_Size(msg, guiFontName, guiFontSize, textWidthMax)

		; Declaring gui size
		guiWidth 	:= 350
		guiHeight 	:= (titleSize.H+5) + (textSize.H+20) ; 5=top margin, 20=title/msg margin
		borderSize 	:= 1

		; Fixing DPI Size
		; guiHeight := guiHeight * ProgramSettings.Screen_DPI ; TO_DO
		
		; Get first avaialble notification to replace
		index := 1
		Loop 5 {
			local winHandle := TrayNotifications_Handles[A_Index]
			if WinExist("ahk_id " winHandle) {
				index++
			}
			else Break
		}
		; Create a list of order of creation, as long as we didnt reach the max of 5 notifications
		if !(index > 5) {
			creationOrder .= index ","
		}
		; We reached the max. So we replace the oldest available notification.
		else {
			index := SubStr(creationOrder,1,1)
			StringTrimLeft, creationOrder, creationOrder, 2
			creationOrder .= index ","
		}
		; Make sure the list doesn't go beyond 10 chars (5 number and 5 comma)
		len := StrLen(creationOrder)
		if (len > 10) {
			StringTrimRight, creationOrder, creationOrder,% len-10
		}

		; Parameters
		fadeTimer := (params.Fade_Timer)?(params.Fade_Timer):(8000)
		_label := (params.Is_Update)?("Gui_TrayNotification_OnLeftClick_Updater"):("Gui_TrayNotification_OnLeftClick")


		Gui, TrayNotification%index%:Destroy
		Gui, TrayNotification%index%:New, +ToolWindow +AlwaysOnTop -Border +LastFound -SysMenu -Caption +LabelGui_TrayNotification_ +hwndhGuiTrayNotification%index%

		if !(TrayNotifications_Handles)
			TrayNotifications_Handles := {}
		TrayNotifications_Handles[index] := hGuiTrayNotification%index%
		

		Gui, TrayNotification%index%:Margin, 0, 0
		Gui, TrayNotification%index%:Color, 1f1f1f

		Gui, TrayNotification%index%:Add, Progress, x0 y0 w%guiWidth% h%borderSize% Background484848 ; Top
		Gui, TrayNotification%index%:Add, Progress, x0 y0 w%borderSize% h%guiHeight% Background484848 ; Left
		Gui, TrayNotification%index%:Add, Progress,% "x" guiWidth-borderSize " y0" " w" borderSize " h" guiHeight " Background484848" ; Right
		Gui, TrayNotification%index%:Add, Progress,% "x" 0 " y" guiHeight-borderSize " w" guiWidth " h" borderSize " Background484848" ; Bottom
		Gui, TrayNotification%index%:Add, Text,% "x0 y0 w" guiWidth " h" guiHeight " BackgroundTrans g" _label,% ""

		Gui, TrayNotification%index%:Font, S%guiTitleFontSize% Bold,% guiFontName
		Gui, TrayNotification%index%:Add, Text,% "xm+35" " ym+9" " w" titleWidthMax " BackgroundTrans cFFFFFF",% title
		Gui, TrayNotification%index%:Font, S%guiFontSize% Norm,% guiFontName
		Gui, TrayNotification%index%:Add, Text,% "xm+10" " ym+35" " w" textWidthMax " BackgroundTrans ca5a5a5",% msg
		Gui, TrayNotification%index%:Add, Picture, x5 y5 w24 h24 hwndhIcon,% SKIN.Assets.Misc.Icon

		showX := MonitorWorkAreaRight - ( (guiWidth+10)*resDPI )
		showY := MonitorWorkAreaBottom - ( (guiHeight+10)*resDPI )
		showW := guiWidth, showH := guiHeight
		Gui, TrayNotification%index%:Show,% "x" showX " y" showY " w" showW " h" showH " NoActivate"

		Loop 5 {
			if (A_Index != index ) {
				local winHandle := TrayNotifications_Handles[A_Index]
				if WinExist("ahk_id " winHandle) {
					WinGetPos, , _y, , _h, ahk_id %winHandle%
					WinMove, ahk_id %winHandle%, , ,% _y- ((guiHeight+10)*resDPI)
				}
			}
		}

		This.Fade(index, true)
		SetTimer, TrayNotification_Show_Fade_%index%, -%fadeTimer%
		Return

		TrayNotification_Show_Fade_1:
			ret1 := This.Fade(1)
			if (ret1) {
				SetTimer, %A_ThisLabel%, -50
			}
			else {
				creationOrder := This.Adjust(1, creationOrder)
				Gui, TrayNotification1:Destroy
			}
		Return
		TrayNotification_Show_Fade_2:
			ret2 := This.Fade(2)
			if (ret2) {
				SetTimer, %A_ThisLabel%, -50
			}
			else {
				creationOrder := This.Adjust(2, creationOrder)
				Gui, TrayNotification2:Destroy
			}
		Return
		TrayNotification_Show_Fade_3:
			ret3 := This.Fade(3)
			if (ret3) {
				SetTimer, %A_ThisLabel%, -50
			}
			else {
				creationOrder := This.Adjust(3, creationOrder)
				Gui, TrayNotification3:Destroy
			}
		Return
		TrayNotification_Show_Fade_4:
			ret4 := This.Fade(4)
			if (ret4) {
				SetTimer, %A_ThisLabel%, -50
			}
			else {
				creationOrder := This.Adjust(4, creationOrder)
				Gui, TrayNotification4:Destroy
			}
		Return
		TrayNotification_Show_Fade_5:
			ret5 := This.Fade(5)
			if (ret5) {
				SetTimer, %A_ThisLabel%, -50
			}
			else {
				creationOrder := This.Adjust(5, creationOrder)
				Gui, TrayNotification5:Destroy
			}
		Return

		Gui_TrayNotification_ContextMenu: ; Launched whenever the user right-clicks anywhere in the window except the title bar and menu bar.
			creationOrder := This.Adjust(A_Gui, creationOrder)
			Gui, %A_GUI%:Destroy
		Return

		Gui_TrayNotification_OnLeftClick:
			creationOrder := This.Adjust(A_Gui, creationOrder)
			Gui, %A_Gui%:Destroy
		Return

		Gui_TrayNotification_OnLeftClick_Updater:
			creationOrder := This.Adjust(A_Gui, creationOrder)
			Gui, %A_Gui%:Destroy
			DownloadAndRunUpdater()
		Return
	}

	Fade(index="", start=false) {
		static

		if (start) {
			transparency%index% := 240 ; Set initial transparency
			; Return
		}

		transparency%index% := (0 > transparency%index%)?(0):(transparency%index%-15)
		
		Gui, TrayNotification%index%:+LastFound
		WinSet, Transparent,% transparency%index%
		return transparency%index%
	}

	Get_Text_Control_Size(txt, fontName, fontSize, maxWidth="") {
	/*		Create a control with the specified text to retrieve
	 *		the space (width/height) it would normally take
	*/
		Gui, GetTextSize:Destroy
		Gui, GetTextSize:Font, S%fontSize%,% fontName
		if (maxWidth) 
			Gui, GetTextSize:Add, Text,x0 y0 +Wrap w%maxWidth% hwndTxtHandler,% txt
		else 
			Gui, GetTextSize:Add, Text,x0 y0 hwndTxtHandler,% txt
		coords := This.Get_Control_Coords("GetTextSize", TxtHandler)
		; Gui, GetTextSize:Show, w500
		Gui, GetTextSize:Destroy

		return coords

	/*	Alternative version, with auto sizing

		Gui, GetTextSize:Font, S%fontSize%,% fontName
		Gui, GetTextsize:Add, Text,x0 y0 hwndTxtHandlerAutoSize,% txt
		coordsAuto := Get_Control_Coords("GetTextSize", TxtHandlerAutoSize)
		if (maxWidth) {
			Gui, GetTextSize:Add, Text,x0 y0 +Wrap w%maxWidth% hwndTxtHandlerFixedSize,% txt
			coordsFixed := Get_Control_Coords("GetTextSize", TxtHandlerFixedSize)
		}
		Gui, GetTextSize:Destroy

		if (maxWidth > coords.Auto)
			coords := coordsAuto
		else
			coords := coordsFixed

		return coords
	*/
	}

	Get_Control_Coords(guiName, ctrlHandler) {
	/*		Retrieve a control's position and return them in an array.
			The reason of this function is because the variable content would be blank
				unless its sub-variables (coordsX, coordsY, ...) were set to global.
				(Weird AHK bug)
	*/
		GuiControlGet, coords, %guiName%:Pos,% ctrlHandler
		return {X:coordsX,Y:coordsY,W:coordsW,H:coordsH}
}

}
