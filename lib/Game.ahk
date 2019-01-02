Get_TradingLeagues(forceScriptLeagues=False) {
/*		Retrieves leagues from the API
		Parse them, to keep only non-solo or non-ssf leagues
		Return the resulting list
*/
	global PROGRAM, GAME, LEAGUES

	challengeLeagues := GAME.CHALLENGE_LEAGUE
	Loop, Parse, challengeLeagues,% ","
		scriptLeagues := scriptLeagues ? scriptLeagues "," A_LoopField ",Hardcore " A_LoopField : A_LoopField ",Hardcore " A_LoopField
	scriptLeagues := scriptLeagues ? scriptLeagues ",Standard,Hardcore" : "Standard,Hardcore"

	if (forceScriptLeagues = True) {
		LEAGUES := scriptLeagues
		return scriptLeagues
	}

	; HTTP Request
	postData		:= ""
	options 	:= "TimeOut: 10"
	reqHeaders	:= []
	reqHeaders.push("Host: api.pathofexile.com")
	reqHeaders.push("Connection: keep-alive")
	reqHeaders.push("Cache-Control: max-age=0")
	reqHeaders.push("Content-type: application/x-www-form-urlencoded; charset=UTF-8")
	reqHeaders.push("Accept: text/html,application/xhtml+xml,application/xml;q=0.9,image/webp,image/apng,*/*;q=0.8")
	reqHeaders.push("User-Agent: Mozilla/5.0 (Windows NT 6.3; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/60.0.3112.90 Safari/537.36")
	url := "http://api.pathofexile.com/leagues?type=main"
	leaguesJSON := cURL_Download(url, postData, reqHeaders, options, false, true, false, "", reqHeadersCurl)

	; Parse league names
	apiLeagues		:= ""
	try parsedLeaguesJSON := JSON.Load(leaguesJSON)
	Loop % parsedLeaguesJSON.MaxIndex() {
		arrID 		:= parsedLeaguesJSON[A_Index]
		leagueName 	:= arrID.ID
		if !IsIn(leagueName, apiLeagues) {
 			apiLeagues .= leagueName ","
		}
	}
	StringTrimRight, apiLeagues, apiLeagues, 1
	apiLeagues := IsContaining(apiLeagues, "Standard")?apiLeagues:""

	; Parse trading leagues only
	excludedWords 		:= "SSF,Solo"
	apiTradingLeagues 		:= ""
	Loop, Parse, apiLeagues,% ","
	{
		if !IsContaining(A_LoopField, excludedWords)
			apiTradingLeagues .= A_LoopField ","
	}
	StringTrimRight, apiTradingLeagues, apiTradingLeagues, 1

	; In case leagues api is down, get from my own list on github
	if !(apiTradingLeagues) {
		postData := ""
		reqHeaders := []
		url := "http://raw.githubusercontent.com/" PROGRAM.GITHUB_USER "/" PROGRAM.GITHUB_REPO "/master/data/TradingLeagues.txt"
		rawFile := cURL_Download(url, postData, reqHeaders, "", false, true, false, "", reqHeadersCurl)

		if IsContaining(rawFile, "Error,404") {
			AppendToLogs(A_ThisFunc "(forceScriptLeagues=" forceScriptLeagues "): Failed to get leagues from GitHub file."
			. "`nrawFile: """ rawFile """")
			rawFile := ""
		}
		gitLeagues := ""		
		Loop, Parse, rawFile,% "`n",% "`r"
			if (A_LoopField)
				gitLeagues .= A_LoopField ","
		StringTrimRight, gitLeagues, gitLeagues, 1
		AppendToLogs("Leagues API: Couldn't retrieve leagues from Leagues API. Retrieving list from GitHub repo: " gitLeagues)
	}

	; Set LEAGUES var content
	tradingLeagues := apiTradingLeagues?apiTradingLeagues : gitLeagues?gitLeagues : scriptLeagues
	Loop, Parse, scriptLeagues,% ","
	{
		loopedLeague := A_LoopField
		if !IsIn(loopedLeague, tradingLeagues)
			tradingLeagues := tradingLeagues ? tradingLeagues "," loopedLeague : loopedLeague
	}
	LEAGUES := tradingLeagues

	AppendToLogs("Leagues API: Retrieved leagues: " tradingLeagues)

	return tradingLeagues
}

Send_GameMessage(actionType, msgString, gamePID="") {
	global PROGRAM, GAME
	Thread, NoTimers

	sendMsgMode := PROGRAM.SETTINGS.SETTINGS_MAIN.SendMsgMode

;	Retrieve the virtual key id for chat opening
	chatVK := GAME.SETTINGS.ChatKey_VK ? GAME.SETTINGS.ChatKey_VK : "0xD"

	titleMatchMode := A_TitleMatchMode
	SetTitleMatchMode, RegEx ; RegEx = Fix some case where specifying only the pid does not work

	firstChar := SubStr(msgString, 1, 1) ; Get first char, to compare if its a special chat command

	if (gamePID) {
		WinActivate,[a-zA-Z0-9_] ahk_group POEGameGroup ahk_pid %gamePID%
		WinWaitActive,[a-zA-Z0-9_] ahk_group POEGameGroup ahk_pid %gamePID%, ,2
	}
	else {
		WinActivate,[a-zA-Z0-9_] ahk_group POEGameGroup
		WinWaitActive,[a-zA-Z0-9_] ahk_group POEGameGroup, ,2
	}
	if (ErrorLevel) {
		AppendToLogs(A_ThisFunc "(actionType=" actionType ", msgString=" msgString ", gamePID=" gamePID "): WinWaitActive timed out.")
		TrayNotifications.Show("Window timeout", "Game window wasn't focused after 5 seconds, canceling sending message.")
		return "WINWAITACTIVE_TIMEOUT"
	}
	GoSub, Send_GameMessage_OpenChat
	GoSub, Send_GameMessage_ClearChat

	if (actionType = "WRITE_SEND") {
		if (sendMsgMode = "Clipboard") {
			While (Clipboard != msgString) {
				Set_Clipboard(msgString)

				if (Clipboard = msgString)
					break

				else if (A_Index > 100) {
					err := True
					break
				}
				Sleep 50
			}
			if (!err)
				SendEvent, ^{sc02F}
			else
				TrayNotifications.Show("Failed to send message.", "The clipboard couldn't be updated with the message content.`nClipboard: " Clipboard "`nMessage: " msgString)
			; SetTimer, Reset_Clipboard, -700
		}
		else if (sendMsgMode = "SendInput")
			SendInput,%msgString%
		else if (sendMsgMode = "SendEvent")
			SendEvent,%msgString%

		SendEvent,{Enter}
	}
	else if (actionType = "WRITE_DONT_SEND") {
		if (sendMsgMode = "Clipboard") {
			While (Clipboard != msgString) {
				Set_Clipboard(msgString)

				if (Clipboard = msgString)
					break

				else if (A_Index > 100) {
					err := True
					break
				}
				Sleep 50
			}
			if (!err)
				SendEvent, ^{sc02F}
			else
				TrayNotifications.Show("Failed to send message.", "The clipboard couldn't be updated with the message content.`nClipboard: " Clipboard "`nMessage: " msgString)
			; SetTimer, Reset_Clipboard, -700
		}
		else if (sendMsgMode = "SendInput")
			SendEvent,%msgString%
		else if (sendMsgMode = "SendEvent")
			SendEvent,%msgString%
	}
	else if (actionType = "WRITE_GO_BACK") {
		foundPos := InStr(msgString, "{X}"), _strLen := StrLen(msgString), leftPresses := _strLen-foundPos+1-3
		msgString := StrReplace(msgString, "{X}", "")

		if (sendMsgMode = "Clipboard") {
			While (Clipboard != msgString) {
				Set_Clipboard(msgString)

				if (Clipboard = msgString)
					break

				else if (A_Index > 100) {
					err := True
					break
				}
				Sleep 50
			}
			if (!err)
				SendEvent, ^{sc02F}
			else
				TrayNotifications.Show("Failed to send message.", "The clipboard couldn't be updated with the message content.`nClipboard: " Clipboard "`nMessage: " msgString)
			; SetTimer, Reset_Clipboard, -700
		}
		else if (sendMsgMode = "SendInput")
			SendInput,%msgString%
		else if (sendMsgMode = "SendEvent")
			SendEvent,%msgString%

		if (!err)
			SendInput {Left %leftPresses%}
	}

	SetTitleMatchMode, %titleMatchMode%
	Return

	Send_GameMessage_ClearChat:
		if !IsIn(firstChar, "/,`%,&,#,@") { ; Not a command. We send / then remove it to make sure chat is empty
			SendEvent,/{BackSpace}
		}
	Return

	Send_GameMessage_OpenChat:
		if IsIn(chatVK, "0x1,0x2,0x4,0x5,0x6,0x9C,0x9D,0x9E,0x9F") { ; Mouse buttons
			keyDelay := A_KeyDelay, keyDuration := A_KeyDuration
			SetKeyDelay, 10, 10
			if (gamePID)
				ControlSend, ,{VK%keyVK%}, [a-zA-Z0-9_] ahk_groupe POEGameGroup ahk_pid %gamePID% ; Mouse buttons tend to activate the window under the cursor.
																	  						  	  ; Therefore, we need to send the key to the actual game window.
			else {
				WinGet, activeWinHandle, ID, A
				ControlSend, ,{VK%keyVK%}, [a-zA-Z0-9_] ahk_groupe POEGameGroup ahk_pid %activeWinHandle%
			}
			SetKeyDelay,% keyDelay,% keyDuration
		}
		else
			SendEvent,{VK%chatVK%}
	Return
}

Get_RunningInstances() {
	global POEGameArr

	runningInstances := {}
	runningInstances.Count := 0

	for id, pName in POEGameArr {
		hwndList := Get_Windows_ID(pName, "ahk_exe")
		if (hwndList) {
			matchingHwnd .= hwndList ","
		}
	}
	StringTrimRight, matchingHwnd, matchingHwnd, 1

	Loop, Parse, matchingHwnd,% ","
	{
		runningInstances[A_Index] := {}
		runningInstances.Count := A_Index

		WinGet, pPID, PID, ahk_id %A_LoopField%
		WinGet, pPath, ProcessPath, ahk_id %A_LoopField%
		SplitPath, pPath, pFile, pFolder

		runningInstances[A_Index]["Hwnd"] := A_LoopField
		runningInstances[A_Index]["Folder"] := pFolder
		runningInstances[A_Index]["File"] := pFile
		runningInstances[A_Index]["PID"] := pPID
	}
	
	return runningInstances
}

Get_GameLogsFile() {
	global POEGameArr

	runningInstances := Get_RunningInstances()
	Loop % runningInstances.Count {
		thisInstanceFolder := runningInstances[A_Index]["Folder"]
		hasDifferentFolders := (thisInstanceFolder && prevInstanceFolder && thisInstanceFolder != prevInstanceFolder)?(True):(False)
		prevInstanceFolder := thisInstanceFolder
	}
	if (runningInstances.Count = 0)
		Return
	else if (runningInstances.Count > 1 && hasDifferentFolders) {
		instanceInfos := GUI_ChooseInstance.Create(runningInstances, "Folder")
		logsFile := instanceInfos["Folder"] "\logs\Client.txt"
	}
	else {
		logsFile := runningInstances[1]["Folder"] "\logs\Client.txt"
	}
	if !FileExist(logsFile) && (logsFile != "\logs\Client.txt") {
		TrayNotifications.Show("Logs file not found", "The specified file does not exist:`n" logsFile)
		Return
	}

	Return logsFile
}

Monitor_GameLogs() {
	global RUNTIME_PARAMETERS
	static logsFile

	if !(logsFile) {
		SetTimer,% A_ThisFunc, Delete

		if (RUNTIME_PARAMETERS.GameFolder)
			logsFile := RUNTIME_PARAMETERS.GameFolder "\logs\Client.txt"
		else
			logsFile := Get_GameLogsFile()

		if (logsFile) {
			SetTimer,% A_ThisFunc, 500
			AppendToLogs("Monitoring logs file: """ logsFile """.")
		}
		else {
			SetTimer,% A_ThisFunc, -10000
		}
	}

	newFileContent := Read_GameLogs(logsFile)
	if (newFileContent)
		Parse_GameLogs(newFileContent)
}

Parse_GameLogs(strToParse) {
	global PROGRAM, GuiTrades, LEAGUES

	; poe.trade
	static poeTradeRegex 			:= {String:"(.*)Hi, I would like to buy your (.*) listed for (.*) in (.*)"
										, Other:1, Item:2, Price:3, League:4}
	static poeTradeUnpricedRegex 	:= {String:"(.*)Hi, I would like to buy your (.*) in (.*)"
										, Other:1, Item:2, League:3}
	static poeTradeCurrencyRegex	:= {String:"(.*)Hi, I'd like to buy your (.*) for my (.*) in (.*)"
										, Other:1, Item:2, Price:3, League:4}
	static poeTradeStashRegex 		:= {String:"\(stash tab ""(.*)""; position: left (\d+), top (\d+)\)(.*)"
										, Tab:1, Left:2, Top:3, Other:4}
	static poeTradeQualityRegEx 		:= {String:"level (\d+) (\d+)% (.*)"
										, Level:1, Quality:2, Item:3}

	; poeapp.com
	static poeAppRegEx 				:= {String:"(.*)wtb (.*) listed for (.*) in (.*)"
										, Other:1, Item:2, Price:3, League:4}
	static poeAppUnpricedRegex 		:= {String:"(.*)wtb (.*) in (.*)"
										, Other:1, Item:2, League:3}
	static poeAppStashRegex 		:= {String:"\(stash ""(.*)""; left (\d+), top (\d+)\)(.*)"
										, Tab:1, Left:2, Top:3, Other:4}
	static poeAppQualityRegEx 		:= {String:"(.*) \((\d+)/(\d+)%\)"
										, Item:1, Level:2, Quality:3}

	; pathofexile.com/trade
	; doesn't need ENG str as its same than poe.trade
	static RUS_gggRegEx				:= {String:"(.*)Здравствуйте, хочу купить у вас (.*) за (.*) в лиге (.*)"
										, Other:1, Item:2, Price:3, League:4}
	static RUS_gggUnpricedRegEx		:= {String:"(.*)Здравствуйте, хочу купить у вас (.*) в лиге (.*)"
                                        , Other:1, Item:2, League:3}
	static RUS_gggCurrencyRegEx		:= {String:"(.*)Здравствуйте, хочу купить у вас (.*) за (.*) в лиге (.*)"
                                        , Other:1, Item:2, Price:3, League:4}
	static RUS_gggStashRegEx		:= {String:"\(секция ""(.*)""; позиция: (\d+) столбец, (\d+) ряд\)(.*)"
										, Tab:1, Left:2, Top:3, Other:4}
	static RUS_gggQualityRegEx 		 := {String:"уровень (\d+) (\d+)% (.*)"
										, Level:1, Quality:2, Item:3}


	static POR_gggRegEx 			:= {String:"(.*)Olá, eu gostaria de comprar o seu item (.*) listado por (.*) na (.*)"
										, Other:1, Item:2, Price:3, League:4}
	static POR_gggUnpricedRegEx 	:= {String:"(.*)Olá, eu gostaria de comprar o seu item (.*) na (.*)"
											, Other:1, Item:2, League:3}
	static POR_gggCurrencyRegEx 	:= {String:"(.*)Olá, eu gostaria de comprar seu\(s\) (.*) pelo\(s\) meu\(s\) (.*) na (.*)"
										, Other:1, Item:2, Price:3, League:4}
	static POR_gggStashRegEx 		:= {String:"\(aba do baú: ""(.*)""; posição: esquerda (\d+), topo (\d+)\)(.*)"
										, Tab:1, Left:2, Top:3, Other:4}
	static POR_gggQualityRegEx 		:= {String:"nível (\d+) (\d+)% (.*)"
										, Level:1, Quality:2, Item:3}


	static THA_gggRegEx				:= {String:"(.*)สวัสดี, เราต้องการจะชื้อของคุณ (.*) ใน ราคา (.*) ใน (.*)"
										, Other:1, Item:2, Price:3, League:4}
	static THA_gggUnpricedRegEx		:= {String:"(.*)สวัสดี, เราต้องการจะชื้อของคุณ (.*) ใน (.*)"
										, Other:1, Item:2, League:3}
	static THA_gggCurrencyRegEx		:= {String:"(.*)สวัสดี เรามีความต้องการจะชื้อ (.*) ของคุณ ฉันมี (.*) ใน (.*)"
										, Other:1, Item:2, Price:3, League:4}
	static THA_gggStashRegEx		:= {String:"\(stash tab ""(.*)""; ตำแหน่ง: ซ้าย (\d+), บน (.*)\)(.*)" ; Top position is bugged from GGG side and appears as {{TOP}) for priced items, so we use (.*) instead of (\d+)
										, Tab:1, Left:2, Top:3, Other:4}
	static THA_gggQualityRegEx		:= {String:"level (\d+) (\d+)% (.*)"
										, Level:1, Quality:2, Item:3}

	static GER_gggRegEx 			:= {String:"(.*)Hi, ich möchte '(.*)' zum angebotenen Preis von (.*) in der '(.*)'-Liga kaufen(.*)"
										, Other:1, Item:2, Price:3, League:4, Other2:5}
	static GER_gggUnpricedRegEx		:= {String:"(.*)Hi, ich möchte '(.*)' in der '(.*)'-Liga kaufen(.*)"
										, Other:1, Item:2, League:3, Other2:4}
	static GER_gggCurrencyRegEx		:= {String:"(.*)Hi, ich möchte '(.*)' zum angebotenen Preis von '(.*)' in der '(.*)'-Liga kaufen(.*)"
										, Other:1, Item:2, Price:3, League:4, Other2:5}
	static GER_gggStashRegEx		:= {String:"\(Truhenfach ""(.*)""; Position: (\d+). von links, (\d+). von oben\)(.*)"
										, Tab:1, Left:2, Top:3, Other:4}
	static GER_gggQualityRegEx		:= {String:"Stufe (\d+) (\d+)% (.*)"
										, Level:1, Quality:2, Item:3} 


	static FRE_gggRegEx				:= {String:"(.*)Bonjour, je souhaiterais t'acheter (.*) pour (.*) dans la ligue (.*)"
										, Other:1, Item:2, Price:3, League:4}
	static FRE_gggUnpricedRegEx		:= {String:"(.*)Bonjour, je souhaiterais t'acheter (.*) dans la ligue (.*)"
										, Other:1, Item:2, League:3}
	static FRE_gggCurrencyRegEx		:= {String:"(.*)Bonjour, je voudrais t'acheter (.*) contre (.*) dans la ligue (.*)"
										, Other:1, Item:2, Price:3, League:4}
	static FRE_gggStashRegEx		:= {String:"\(onglet de réserve ""(.*)"" \; (\d+)e en partant de la gauche, (\d+)e en partant du haut\)(.*)"
										, Tab:1, Left:2, Top:3, Other:4}
	static FRE_gggQualityRegEx		:= {String:"(.*) de niveau (\d+) à (\d+)% de qualité"
										, Item:1, Level:2, Quality:3}


	static SPA_gggRegEx				:= {String:"(.*)Hola, quisiera comprar tu (.*) listado por (.*) en (.*)"
										, Other:1, Item:2, Price:3, League:4}
	static SPA_gggUnpricedRegEx 	:= {String:"(.*)Hola, quisiera comprar tu (.*) en (.*)"
										, Other:1, Item:2, League:3}
	static SPA_gggCurrencyRegEx		:= {String:"(.*)Hola, me gustaría comprar tu\(s\) (.*) por mi (.*) en (.*)"
										, Other:1, Item:2, Price:3, League:4}
	static SPA_gggStashRegEx		:= {String:"\(pestaña de alijo ""(.*)""; posición: izquierda(\d+), arriba (\d+)\)"
										, Tab:1, Left:2, Top:3, Other:4}
	static SPA_gggQualityRegEx		:= {String:"(.*) nivel (\d+) (\d+)%"
										, Item:1, Level:2, Quality:3}


	static allTradingRegex := {"poeTrade":poeTradeRegex
		,"poeTrade_Unpriced":poeTradeUnpricedRegex
		,"currencyPoeTrade":poeTradeCurrencyRegex
		,"poeApp":poeAppRegEx
		,"poeApp_Unpriced":poeAppUnpricedRegex}

	langs := "RUS,POR,THA,GER,FRE,SPA"
	Loop, Parse, langs,% "," ; Adding ggg trans regex to allTradingRegEx
	{
		allTradingRegex["ggg_" A_LoopField] := %A_LoopField%_gggRegEx
		allTradingRegex["ggg_" A_LoopField "_unpriced"] := %A_LoopField%_gggUnpricedRegEx
		allTradingRegex["ggg_" A_LoopField "_currency"] := %A_LoopField%_gggCurrencyRegEx
	}	

	static ENG_areaJoinedRegexStr := ("^(?:[^ ]+ ){6}(\d+)\] : (.*?) has joined the area.*") 
	static ENG_areaLeftRegexStr := ("^(?:[^ ]+ ){6}(\d+)\] : (.*?) has left the area.*") 
	static ENG_afkOnRegexStr := ("^(?:[^ ]+ ){6}(\d+)\] : AFK mode is now ON.*") 
	static ENG_afkOffRegexStr := ("^(?:[^ ]+ ){6}(\d+)\] : AFK mode is now OFF.*") 

	static FRE_areaJoinedRegexStr := ("^(?:[^ ]+ ){6}(\d+)\] : (.*?) a rejoint la zone.*") 
	static FRE_areaLeftRegexStr := ("^(?:[^ ]+ ){6}(\d+)\] : (.*?) a quitté la zone.*") 
	static FRE_afkOnRegexStr := ("^(?:[^ ]+ ){6}(\d+)\] : Le mode Absent \(AFK\) est désormais activé.*") 
	static FRE_afkOffRegexStr := ("^(?:[^ ]+ ){6}(\d+)\] : Le mode Absent \(AFK\) est désactivé.*") 

	static GER_areaJoinedRegexStr := ("^(?:[^ ]+ ){6}(\d+)\] : (.*?) hat das Gebiet betreten.*") 
	static GER_areaLeftRegexStr := ("^(?:[^ ]+ ){6}(\d+)\] : (.*?) hat das Gebiet verlassen.*")
	static GER_afkOnRegexStr := ("^(?:[^ ]+ ){6}(\d+)\] : AFK-Modus ist nun AN.*") 
	static GER_afkOffRegexStr := ("^(?:[^ ]+ ){6}(\d+)\] : AFK-Modus ist nun AUS.*") 

	static POR_areaJoinedRegexStr := ("^(?:[^ ]+ ){6}(\d+)\] : (.*?) entrou na área.*") 
	static POR_areaLeftRegexStr := ("^(?:[^ ]+ ){6}(\d+)\] : (.*?) saiu da área.*") 
	static POR_afkOnRegexStr := ("^(?:[^ ]+ ){6}(\d+)\] : Modo LDT Ativado.*") 
	static POR_afkOffRegexStr := ("^(?:[^ ]+ ){6}(\d+)\] : Modo LDT Desativado.*") 

	static RUS_areaJoinedRegexStr := ("^(?:[^ ]+ ){6}(\d+)\] : (.*?) присоединился.*") 
	static RUS_areaLeftRegexStr := ("^(?:[^ ]+ ){6}(\d+)\] : (.*?) покинул область.*") 
	static RUS_afkOnRegexStr := ("^(?:[^ ]+ ){6}(\d+)\] : Режим ""отошёл"" включён.*") 
	static RUS_afkOffRegexStr := ("^(?:[^ ]+ ){6}(\d+)\] : Режим ""отошёл"" выключен.*") 

	static THA_areaJoinedRegexStr := ("^(?:[^ ]+ ){6}(\d+)\] : (.*?) เข้าสู่พื้นที่.*") 
	static THA_areaLeftRegexStr := ("^(?:[^ ]+ ){6}(\d+)\] : (.*?) ออกจากพื้นที่.*") 
	static THA_afkOnRegexStr := ("^(?:[^ ]+ ){6}(\d+)\] : เปิดโหมด AFK แล้ว.*") 
	static THA_afkOffRegexStr := ("^(?:[^ ]+ ){6}(\d+)\] : ปิดโหมด AFK แล้ว.*") 

	static SPA_areaJoinedRegexStr := ("^(?:[^ ]+ ){6}(\d+)\] : (.*?) se unió al área.*") 
	static SPA_areaLeftRegexStr := ("^(?:[^ ]+ ){6}(\d+)\] : (.*?) abandonó el área.*") 
	static SPA_afkOnRegexStr := ("^(?:[^ ]+ ){6}(\d+)\] : El modo Ausente está habilitado.*") 
	static SPA_afkOffRegexStr := ("^(?:[^ ]+ ){6}(\d+)\] : El modo Ausente está deshabilitado.*")

	allAreaJoinedRegEx := [ENG_areaJoinedRegexStr, FRE_areaJoinedRegexStr, GER_areaJoinedRegexStr, POR_areaJoinedRegexStr
		, RUS_areaJoinedRegexStr, THA_areaJoinedRegexStr, SPA_areaJoinedRegexStr]
	allAreaLeftRegEx := [ENG_areaLeftRegexStr, FRE_areaLeftRegexStr, GER_areaLeftRegexStr, POR_areaLeftRegexStr
		, RUS_areaLeftRegexStr, THA_areaLeftRegexStr, SPA_areaLeftRegexStr]
	allAfkOnRegEx := [ENG_afkOnRegexStr, FRE_afkOnRegexStr, GER_afkOnRegexStr, POR_afkOnRegexStr
		, RUS_afkOnRegexStr, THA_afkOnRegexStr, SPA_afkOnRegexStr]
	allAfkOffRegEx := [ENG_afkOffRegexStr, FRE_afkOffRegexStr, GER_afkOffRegexStr, POR_afkOffRegexStr
		, RUS_afkOffRegexStr, THA_afkOffRegexStr, SPA_afkOffRegexStr]

	Loop, Parse,% strToParse,`n,`r ; For each line
	{
		; Check if area joined
		for index, regexStr in allAreaJoinedRegEx {
			if RegExMatch(A_LoopField, "SO)" regexStr, joinedPat) {
				instancePID := joinedPat.1, playerName := joinedPat.2
				GUI_Trades.SetTabStyleJoinedArea(playerName)
				if (PROGRAM.SETTINGS.SETTINGS_MAIN.BuyerJoinedAreaSFXToggle = "True") && FileExist(PROGRAM.SETTINGS.SETTINGS_MAIN.BuyerJoinedAreaSFXPath)
					SoundPlay,% PROGRAM.SETTINGS.SETTINGS_MAIN.BuyerJoinedAreaSFXPath
				break
			}
		}
		for index, regexStr in allAreaLeftRegEx {
			if RegExMatch(A_LoopField, "SO)" regexStr, leftPat) {
				instancePID := leftPat.1, playerName := leftPat.2
				GUI_Trades.UnSetTabStyleJoinedArea(playerName)
				break
			}
		}

		; Check if afk mode
		for index, regexStr in allAfkOnRegEx {
			if RegExMatch(A_LoopField, "iSO)" regexStr, afkOnPat) {
				instancePID := afkOnPat.1
				GuiTrades[instancePID "_AfkState"] := True
				AppendToLogs("AFK mode for instance PID """ instancePID """ set to ON.")
				break
			}
		}
		for index, regexStr in allAfkOffRegEx {
			if RegExMatch(A_LoopField, "iSO)" regexStr, afkOffPat) {
				instancePID := afkOffPat.1
				GuiTrades[instancePID "_AfkState"] := False
				AppendToLogs("AFK mode for instance PID """ instancePID """ set to OFF.")
				break
			}
		}

		; Check if whisper sent
		if RegExMatch(A_LoopField, "SO)^(?:[^ ]+ ){6}(\d+)\] (?=[^#$&%]).*@(?:To|À|An|Para|Кому|ถึง) (.*?): .*", whisperPat) {
			instancePID := whisperPat.1, whispNameFull := whisperPat.2
			nameAndGuild := SplitNameAndGuild(whispNameFull), whispName := nameAndGuild.Name, whispGuild := nameAndGuild.Guild
			GuiTrades.Last_Whisper_Sent_Name := whispName
		}
		; Check if whisper received
		else if RegExMatch(A_LoopField, "SO)^(?:[^ ]+ ){6}(\d+)\] (?=[^#$&%]).*@(?:From|De|От кого|จาก|Von|Desde) (.*?): (.*)", whisperPat ) {
			instancePID := whisperPat.1, whispNameFull := whisperPat.2, whispMsg := whisperPat.3
			nameAndGuild := SplitNameAndGuild(whispNameFull), whispName := nameAndGuild.Name, whispGuild := nameAndGuild.Guild
			GuiTrades.Last_Whisper_Name := whispName

			; Retrieve the regEx pattern specific to the whisper type
			for subRegEx, nothing in allTradingRegex {
				if RegExMatch(whispMsg, "iS)" allTradingRegex[subRegEx]["String"]) { ; Match found
					matchingRegEx := allTradingRegex[subRegEx]
					tradeRegExStr := allTradingRegex[subRegEx]["String"]
					tradeRegExName := subRegEx
					Break
				}
			}

			if (matchingRegEx) { ; Trade whisper match
				RegExMatch(whispMsg, "iSO)" tradeRegExStr, tradePat)

				isPoeTrade := IsIn(tradeRegExName, "poeTrade,poeTrade_Unpriced,currencyPoeTrade")
				isPoeApp := IsIn(tradeRegExName, "poeApp,poeApp_Unpriced")
				isGGGRus := IsContaining(tradeRegExName, "ggg_rus")
				isGGGPor := IsContaining(tradeRegExName, "ggg_por")
				isGGGTha := IsContaining(tradeRegExName, "ggg_tha")
				isGGGGer := IsContaining(tradeRegExName, "ggg_ger")
				isGGGFre := IsContaining(tradeRegExName, "ggg_fre")
				isGGGSpa := IsContaining(tradeRegExName, "ggg_spa")
				
				qualRegEx := isPoeTrade ? poeTradeQualityRegEx
					: isPoeApp ? poeAppQualityRegEx
					: isGGGRus ? RUS_gggQualityRegEx
					: isGGGPor ? POR_gggQualityRegEx
					: isGGGTha ? THA_gggQualityRegEx
					: isGGGGer ? GER_gggQualityRegEx
					: isGGGFre ? FRE_gggQualityRegEx
					: isGGGSpa ? SPA_gggQualityRegEx
					: ""
				stashRegEx := isPoeTrade ? poeTradeStashRegex
					: isPoeApp ? poeAppStashRegex
					: isGGGRus ? RUS_gggStashRegEx
					: isGGGPor ? POR_gggStashRegEx
					: isGGGTha ? THA_gggStashRegEx
					: isGGGGer ? GER_gggStashRegEx
					: isGGGFre ? FRE_gggStashRegEx
					: isGGGSpa ? SPA_gggStashRegEx
					: ""

				whisperLang := isPoeTrade ? "ENG"
					: isPoeApp ? "ENG"
					: isGGGRus ? "RUS"
					: isGGGPor ? "POR"
					: isGGGTha ? "THA"
					: isGGGGer ? "GER"
					: isGGGFre ? "FRE"
					: isGGGSpa ? "SPA"
					: ""

				tradeBuyerName := whispName, tradeBuyerGuild := whispGuild
				tradeOtherStart := tradePat[matchingRegEx["Other"]]
				tradeItem := tradePat[matchingRegEx["Item"]]
				tradePrice := tradePat[matchingRegEx["Price"]]
				tradeLeagueAndMore := tradePat[matchingRegEx["League"]]
				tradeLeagueAndMore .= tradePat[matchingRegEx["Other2"]]

				; German priced whisper is the same as currency whisper. Except that currency whisper has '' between price name
				; while the normal whisper doesn't have them. Fix: Remove '' in price if detected
				if (whisperLang = "GER") && ( SubStr(tradePrice, 1, 1) = "'" ) && ( SubStr(tradePrice, 0, 1) = "'") {
					StringTrimLeft, tradePrice, tradePrice, 1
					StringTrimRight, tradePrice, tradePrice, 1
				}

				AutoTrimStr(tradeBuyerName, tradeItem, tradePrice, tradeOtherStart)

				leagueMatches := [], leagueMatchesIndex := 0
				Loop, Parse, LEAGUES,% ","
				{
					parsedLeague := A_LoopField
					parsedLeague := StrReplace(parsedLeague, "(", "\(")
					parsedLeague := StrReplace(parsedLeague, ")", "\)")
					if RegExMatch(tradeLeagueAndMore, "iSO)" parsedLeague "(.*)", leagueAndMorePat) {
						leagueMatchesIndex++
						tradeLeague := A_LoopField
						restOfWhisper := leagueAndMorePat.1
						AutoTrimStr(tradeLeague, restOfWhisper)

						leagueMatches[leagueMatchesIndex] := {Len:StrLen(A_LoopField), Str:A_LoopField}
					}
				}
				Loop % leagueMatches.MaxIndex() {
					if (leagueMatches[A_Index].Len > biggestLen) {
						biggestLen := leagueMatches[A_Index].Len, tradeLeague := leagueMatches[A_Index].Str
					}
				}

				if (!tradeLeague)
					restOfWhisper := tradeLeagueAndMore

				if RegExMatch(tradeItem, "iSO)" qualRegEx.String, qualPat) && (qualRegEx.String) {
					tradeItem := qualPat[qualRegEx["Item"]]
					tradeItemLevel := qualPat[qualRegEx["Level"]]
					tradeItemQual := qualPat[qualregEx["Quality"]]
					AutoTrimStr(tradeItem, tradeItemLevel, tradeItemQual)

					tradeItemFull := tradeItem " (Lvl:" tradeItemLevel " / Qual:" tradeItemQual "%)"
				}
				else {
					tradeItemFull := tradeItem
					AutoTrimStr(tradeItemFull)
				}
				if RegExMatch(restOfWhisper, "iSO)" stashRegEx.String, stashPat) && (stashRegEx.String) {
					tradeStashTab := stashPat[stashRegEx["Tab"]]
					tradeStashLeft := stashPat[stashRegEx["Left"]]
					tradeStashTop := stashPat[stashRegEx["Top"]]
					tradeOtherEnd := stashPat[stashRegEx["Other"]]
					AutoTrimStr(tradeStashTab, tradeStashLeft, tradeStashTop, tradeOtherEnd)

					tradeStashLeftAndTop := tradeStashLeft ";" tradeStashTop
				}
				else {
					tradeOtherEnd := restOfWhisper
					AutoTrimStr(tradeOtherEnd)
				}

				if ( SubStr(tradeOtherEnd, 1, 1) = "." ) ; Remove dot from end at some whispers
					StringTrimLeft, tradeOtherEnd, tradeOtherEnd, 1
				tradeOther := (tradeOtherStart && tradeOtherEnd)?(tradeOtherStart "`n" tradeOtherEnd)
				: (tradeOtherStart && !tradeOtherEnd)?(tradeOtherStart)
				: (tradeOtherEnd && !tradeOtherStart)?(tradeOtherEnd)
				: ("")

				tradeStashFull := (tradeLeague && !tradeStashTab)?(tradeLeague)
				: (tradeLeague && tradeStashTab)?(tradeLeague " (Tab:" tradeStashTab " / Pos:" tradeStashLeftAndTop ")")
				: (!tradeLeague && tradeStashTab) ? ("??? (Tab:" tradeStashTab " / Pos:" tradeStashLeftAndTop ")")
				: (!tradeLeague) ? ("???")
				: ("ERROR")

				timeStamp := A_YYYY "/" A_MM "/" A_DD " " A_Hour ":" A_Min ":" A_Sec

				tradeInfos := {Buyer:tradeBuyerName, Item:tradeItemFull, Price:tradePrice, Stash:tradeStashFull, Other:tradeOther
					,BuyerGuild:tradeBuyerGuild, TimeStamp:timeStamp,PID:instancePID, IsInArea:False, HasNewMessage:False, WithdrawTally:0, Time: A_Hour ":" A_Min
					,WhisperSite:tradeRegExName, UniqueID:GUI_Trades.GenerateUniqueID(), TradeVerify:"Grey", WhisperLang:whisperLang}
				err := Gui_Trades.PushNewTab(tradeInfos)

				if !(err) {
					if (PROGRAM.SETTINGS.SETTINGS_MAIN.TradingWhisperSFXToggle = "True") && FileExist(PROGRAM.SETTINGS.SETTINGS_MAIN.TradingWhisperSFXPath)
						SoundPlay,% PROGRAM.SETTINGS.SETTINGS_MAIN.TradingWhisperSFXPath

					if !WinActive("ahk_pid " instancePID) { ; If the instance is not active
						if ( PROGRAM.SETTINGS.SETTINGS_MAIN.ShowTabbedTrayNotificationOnWhisper = "True" ) {
							notifTxt := "Item: " A_Tab tradeItemFull "`nPrice: " A_Tab tradePrice "`nStash: " A_Tab tradeStashFull
							notifTxt .= tradeOther ? "`nOther: " A_Tab tradeOther : ""
							TrayNotifications.Show("Buying request from " whispName ":", notifTxt)
						}
					}

					pbNoteOnTradingWhisper := PROGRAM.SETTINGS.SETTINGS_MAIN.PushBulletOnTradingWhisper
					if (pbNoteOnTradingWhisper = "True") {
						if (PROGRAM.SETTINGS.SETTINGS_MAIN.PushBulletOnlyWhenAFK = "True" && GuiTrades[instancePID "_AfkState"] = True)
							doPBNote := True
						else if (PROGRAM.SETTINGS.SETTINGS_MAIN.PushBulletOnlyWhenAFK = "False")
							doPBNote := True
					}

					if (doPBNote = True) && StrLen(PROGRAM.SETTINGS.SETTINGS_MAIN.PushBulletToken) > 5 {
						pbTxt := "Item: " tradeItemFull "\nPrice: " tradePrice "\nStash: " tradeStashFull
						pbTxt .= tradeOther ? "\nOther: " tradeOther : ""
						pbErr := PB_PushNote(PROGRAM.SETTINGS.SETTINGS_MAIN.PushBulletToken, "Buying request from " whispName ":", pbTxt)
						if (pbErr && pbErr != 200)
							AppendToLogs(A_ThisFunc "(): Error sending PushBullet notification."
							. "Code: """ pbErr """ - Token length: """ StrLen(PROGRAM.SETTINGS.SETTINGS_MAIN.PushBulletToken) """")
					}
				}
			}
			else { ; No trading whisper match
				; Add whisper to buyer's tab if existing
				Loop % GuiTrades.Tabs_Count {
					tabInfos := Gui_Trades.GetTabContent(A_Index)
					if (tabInfos.Buyer = whispName) {
						Gui_Trades.UpdateSlotContent(A_Index, "Other", "[" A_Hour ":" A_Min "] " whispMsg)
						GUI_Trades.SetTabStyleWhisperReceived(whispName)
					}
				}
				if (PROGRAM.SETTINGS.SETTINGS_MAIN.RegularWhisperSFXToggle = "True") && FileExist(PROGRAM.SETTINGS.SETTINGS_MAIN.RegularWhisperSFXPath)
					SoundPlay,% PROGRAM.SETTINGS.SETTINGS_MAIN.RegularWhisperSFXPath

				if !WinActive("ahk_pid " instancePID) { ; If the instance is not active
					if ( PROGRAM.SETTINGS.SETTINGS_MAIN.ShowTabbedTrayNotificationOnWhisper = "True" ) {
						TrayNotifications.Show("Whisper from " whispName ":", whispMsg)
					}
				}

				pbNoteOnRegularWhisper := PROGRAM.SETTINGS.SETTINGS_MAIN.PushBulletOnWhisperMessage
				if (pbNoteOnRegularWhisper = "True") {
					if (PROGRAM.SETTINGS.SETTINGS_MAIN.PushBulletOnlyWhenAFK = "True" && GuiTrades[instancePID "_AfkState"] = True)
						doPBNote := True
					else if (PROGRAM.SETTINGS.SETTINGS_MAIN.PushBulletOnlyWhenAFK = "False")
						doPBNote := True
				}

				if (doPBNote = True) && StrLen(PROGRAM.SETTINGS.SETTINGS_MAIN.PushBulletToken) > 5 {
					pbErr := PB_PushNote(PROGRAM.SETTINGS.SETTINGS_MAIN.PushBulletToken, "Whisper from " whispName ":"
					, whispMsg)
					if (pbErr && pbErr != 200)
						AppendToLogs(A_ThisFunc "(): Error sending PushBullet notification."
						. "Code: """ pbErr """ - Token length: """ StrLen(PROGRAM.SETTINGS.SETTINGS_MAIN.PushBulletToken) """")
				}
			}
		}
	}
}

Read_GameLogs(logsFile) {
	global sLOGS_FILE, sLOGS_TIMER
	static logsFileObj

	if (!logsFileObj && logsFile) {
		logsFileObj := FileOpen(logsFile, "r")
		logsFileObj.Read()
	}

	if ( logsFileObj.pos < logsFileObj.length ) {
		newFileContent := logsFileObj.Read()
		return newFileContent 
	}
	else if (logsFileObj.pos > logsFileObj.length) || (logsFileObj.pos < 0) && (logsFileObj) {
		AppendToLogs(A_ThisFunc "(logsFile=" logsFile "): Restarting logs file monitor."
		. "logsFileObj.pos: """ logsFileObj.pos """ - logsFileObj.length: """ logsFileObj.length """")
		TrayNotifications.Show("Restarting logs file monitoring", "An issue occured while reading the logs file. Restarting the monitoring function.")
		logsFileObj.Close()
		logsFileObj := FileOpen(logsFile, "r")
		logsFileObj.Read()
	}
}

SplitNameAndGuild(str) {
	if RegExMatch(str, "O)<(.*)>(.*)", guildPat) {
		guild := guildPat.1
		name := guildPat.2

		_autoTrim := A_AutoTrim
		AutoTrim, On
		name = %name%
		guild = %guild%
		AutoTrim, %_autoTrim%

		Return {Guild:guild,Name:name}
	}
	else
		Return {Guild:"",Name:str}
}

IsTradingWhisper(str) {
	firstChar := SubStr(str, 1, 1)

	; poe.trade regex
	poeTradeRegex := "@.* Hi, I would like to buy your .* listed for .* in .*"
	poeTradeUnpricedRegex := "@.* Hi, I would like to buy your .* in .*"
	currencyPoeTradeRegex := "@.* Hi, I'd like to buy your .* for my .* in .*"
	; poeapp.com regex
	poeAppRegex := "@.* wtb .* listed for .* in .*"
	poeAppUnpricedRegex := "@.* wtb .* in .*"
	; ggg regex
	RUS_gggRegEx			:= "@.* Здравствуйте, хочу купить у вас .* за (.*) в лиге.*"
	RUS_gggUnpricedRegEx	:= "@.* Здравствуйте, хочу купить у вас .* в лиге.*"
	RUS_gggCurrencyRegEx	:= "@.* Здравствуйте, хочу купить у вас .* за (.*) в лиге.*"

	POR_gggRegEx 			:= "@.* Olá, eu gostaria de comprar o seu item .* listado por .* na.*"
	POR_gggUnpricedRegEx 	:= "@.* Olá, eu gostaria de comprar o seu item .* na.*"
	POR_gggCurrencyRegEx 	:= "@.* Olá, eu gostaria de comprar seu\(s\) .* pelo\(s\) meu\(s\).*"

	THA_gggRegEx			:= "@.* สวัสดี, เราต้องการจะชื้อของคุณ .* ใน ราคา .* ใน.*"
	THA_gggUnpricedRegEx	:= "@.* สวัสดี, เราต้องการจะชื้อของคุณ .* ใน.*"
	THA_gggCurrencyRegEx	:= "@.* สวัสดี เรามีความต้องการจะชื้อ .* ของคุณ ฉันมี .* ใน.*"

	GER_gggRegEx 			:= "@.* Hi, ich möchte '.*' zum angebotenen Preis von .* in der '.*'-Liga kaufen.*"
	GER_gggUnpricedRegEx	:= "@.* Hi, ich möchte '.*' in der '.*'-Liga kaufen.*"
	GER_gggCurrencyRegEx	:= "@.* Hi, ich möchte '.*' zum angebotenen Preis von '(.*)' in der '(.*)'-Liga kaufen(.*)"

	FRE_gggRegEx			:= "@.* Bonjour, je souhaiterais t'acheter .* pour .* dans la ligue.*"
	FRE_gggUnpricedRegEx	:= "@.* Bonjour, je souhaiterais t'acheter .* dans la ligue.*"
	FRE_gggCurrencyRegEx	:= "@.* Bonjour, je voudrais t'acheter .* contre .* dans la ligue.*"

	SPA_gggRegEx			:= "@.* Hola, quisiera comprar tu .* listado por .* en.*"
	SPA_gggUnpricedRegEx 	:= "@.* Hola, quisiera comprar tu .* en.*"
	SPA_gggCurrencyRegEx	:= "@.* Hola, me gustaría comprar tu\(s\) .* por mi .* en.*"

	allRegexes := []
	allRegexes.Push(poeTradeRegex, poeTradeUnpricedRegex, currencyPoeTradeRegex
		, poeAppRegex, poeAppUnpricedRegex
		, RUS_gggRegEx, RUS_gggUnpricedRegEx, RUS_gggCurrencyRegEx
		, POR_gggRegEx, POR_gggUnpricedRegEx, POR_gggCurrencyRegEx
		, THA_gggRegEx, THA_gggUnpricedRegEx, THA_gggCurrencyRegEx
		, GER_gggRegEx, GER_gggUnpricedRegEx, GER_gggCurrencyRegEx
		, FRE_gggRegEx, FRE_gggUnpricedRegEx, FRE_gggCurrencyRegEx
		, SPA_gggRegEx, SPA_gggUnpricedRegEx, SPA_gggCurrencyRegEx)

	; Make sure it starts with @ and doesnt contain line break
	if InStr(str, "`n") || (firstChar != "@")  {
		Return False
	}

	; Check if trading whisper
	Loop % allRegexes.MaxIndex() { ; compare whisper with regex
		if RegExMatch(str, "S)" allRegexes[A_Index]) { ; Trading whisper detected
			isTradingWhisper := True
		}
		if (isTradingWhisper)
			Break
	}

	Return isTradingWhisper
}