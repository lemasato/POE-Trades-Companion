Get_DpiFactor() {
	return A_ScreenDPI=96?1:A_ScreenDPI/96

	/*	From Registry
	; Credits to ANT-ilic
	; autohotkey.com/board/topic/6893-guis-displaying-differently-on-other-machines/?p=77893
	
	RegRead, regValue, HKEY_CURRENT_USER, Control Panel\Desktop\WindowMetrics, AppliedDPI 
	dpiFactor := (ErrorLevel || regValue=96)?(1):(regValue/96)
	return dpiFactor
	*/
}

Get_DpiScalingBlurFix() {
	RegRead, regValue, HKEY_CURRENT_USER, Control Panel\Desktop, EnablePerProcessSystemDPI 
	regValue := regValue=1?True:False
	return regValue
}
