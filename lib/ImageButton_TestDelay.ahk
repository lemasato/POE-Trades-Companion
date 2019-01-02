ImageButton_TestDelay() {
/*		Check how long it takes to create ImageButtons.

		Under W10, with more than 720 installed fonts, it can take over a second to process ImageButton.Create()
		This function is meant to retrieve the font count, and check the delay if we have over 720 fonts.
*/
	global PROGRAM

	; Retrieving installed fonts count
	RunWait,% PROGRAM.FONTS_FOLDER "/EnumFonts.vbs"
	Loop, Read,% PROGRAM.FONTS_FOLDER "/EnumFontsResults.txt"
	{
		line := A_LoopReadLine
		if RegExMatch(line, "O)Count = (.*)", lineSub) {
			fontsCount := lineSub.1
		}
	}
	if (fontsCount < 700) ; Less than 700 fonts, no test needed
		Return

	; Creating ImageButtons, retrieving the delay
	IBClrStyles := [ [0, 0x80FFFFFF, , 0xD3000000, 0, , 0x80FFFFFF, 1]      ; normal
			   , [0, 0x80E6E6E6, , 0xD3000000, 0, , 0x80E6E6E6, 1]      ; hover
			   , [0, 0x80CCCCCC, , 0xD3000000, 0, , 0x80CCCCCC, 1]      ; pressed
			   , [0, 0x80F3F3F3, , 0x000078D7, 0, , 0x80F3F3F3, 1] ]    ; disabled (defaulted)

	try Gui, TestDelay:Destroy
	Gui, TestDelay:New
	startTime := A_TickCount
	Loop 2 {
		Gui, TestDelay:Add, Button,hWndHBtn%A_Index%,% A_Index
		ImageButton.Create(HBtn%A_Index%, IBClrStyles)
	}
	imageButtonDelay := A_TickCount-StartTime

	Gui, TestDelay:Destroy
	
	if (imageButtonDelay > 1001) { ; Took over a second to create two buttons, tell the user about it
		TrayNotifications.Show(PROGRAM.Name " - Too many fonts (" fontsCount ")","Your system has more than 720 fonts installed."
																	.  "`nOn Win10, it is known to noticeably slow the tool startup."
																	. "`n"
																	. "`nIf the tool takes a long time to start, it is recommended to uninstall fonts (" A_WinDir "\Fonts) until you have 720 fonts or less."
																	,{Fade_Timer:15000})
	}
}
