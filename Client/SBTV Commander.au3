;=================================================================================================================
; Compiler Settings
;=================================================================================================================

#pragma compile (Icon,.\icons\sbtv.ico)
#pragma compile(UPX, False)
#pragma compile(FileDescription, Ein Clanverwaltungsprogramm)
#pragma compile(ProductName, SBTV Commander)
#pragma compile(ProductVersion, 0.1)
#pragma compile(FileVersion, 0.1) ; The last parameter is optional.
#pragma compile(LegalCopyright, © SplashBirdTV)
;#pragma compile(LegalTrademarks, '"Trademark something1, and some text in "quotes" etc...')
#pragma compile(CompanyName, 'SplashBirdTV')
OnAutoItExitRegister("_endScript")

;=================================================================================================================


;=================================================================================================================
; Includings
;=================================================================================================================

#include <File.au3>
#include <Date.au3>
#include <GuiListBox.au3>
#include <Crypt.au3>
#include <GuiImageList.au3>
#include <GDIPlus.au3>
#include <Misc.au3>
#include <MsgBoxConstants.au3>
#include <ButtonConstants.au3>
#include <EditConstants.au3>
#include <GUIConstantsEx.au3>
#include <WindowsConstants.au3>
#include <ButtonConstants.au3>
#include <StaticConstants.au3>
#Include <GuiButton.au3>
#include <FTPEx.au3>
#include <ComboConstants.au3>


;=================================================================================================================


;=================================================================================================================
; Variablen
;=================================================================================================================

$version = 0.3 ;Aktuelle Versionsnumemr als double
$clientPath = "C:\Program Files\SBTVPrograms\Commander" ;Pfad nach Installation von dem Programm
Global $ip = "10.53.32.64"
Global $aPos[2]
Global $nowsec = @SEC
$apos[0] = -1
$apos[1] = -1
$no = 0
startup() ; Programmstart
;=================================================================================================================


; Function: Startup ;=============================================================================================
;
; Name...........: Startup
; Beschreibung ...: Überprüft ob alle Daten vorhanden sind
; Syntax.........: _startUp()
; Parameters ....: -
; Return values .: -
; Autor ........: SplashFlo
;
; ;================================================================================================================



func startup()

		If Not FileExists("C:\Program Files\SBTVPrograms\Commander") then $no = 1
		If Not FileExists("C:\Program Files\SBTVPrograms\Commander\SBTV Commander.exe") then $no = 1
		If Not FileExists("C:\Program Files\SBTVPrograms\Commander\icons") then $no = 1
		If Not FileExists("C:\Program Files\SBTVPrograms\installer") then $no = 1
		If Not FileExists("C:\Program Files\SBTVPrograms\installer\NewVersionInstaller.exe") then $no = 1

		if $no == 1 Then
			errormessage(001,true)
		EndIf
		_checkVersion()

		LoginGUI()



EndFunc

;==================================================================================================================


; Function: Errormessages ;========================================================================================
;
; Name...........: errorMessage
; Beschreibung ...: Überprüft ob alle Daten vorhanden sind
; Syntax.........: errormessage($errorNumber,[optional]$stopScript)
; Parameters ....: $errorNumber = Die Errornummer, $stopScript = true, false (default false)
; Return values .: -
; Autor ........: SplashFlo
;
; ;================================================================================================================

func errorMessage($errorNumber,$stopScript = False)

	Switch $errorNumber
		Case 001
			MsgBox(16, "Error001", "Das Programm wurde nicht ordnungsgemäß installiert!")

		Case 002
			MsgBox(16, "Error002", "Der Server konnte nicht erreicht werden!")

		Case Else
			MsgBox(16, "#UNKNOWN ERROR#", "#UNKNOWN ERROR#" & @CRLF &"Es ist ein schwerwiegender Fehler beim erstellen einer Fehlermeldung aufgetreten!")
			Exit

	EndSwitch

	if $stopScript == true Then
		_endScript()
	EndIf

EndFunc

;==================================================================================================================


; Function: LoginGUI ;=============================================================================================
;
; Name...........: loginGUI
; Beschreibung ...: Eine GUI für den Login
; Syntax.........: loginGUI()
; Parameters ....: -
; Return values .: -
; Autor ........: SplashFlo
;
; ;================================================================================================================

func loginGUI()

	$LoginGUI = GUICreate("Login", 260, 153, $apos[0],$apos[1])
	GUISetIcon(@ScriptDir & "\icons\sbtv.ico")
	GUISetBkColor(0xC0C0C0)
	$Group = GUICtrlCreateGroup("", 16, 16, 178, 81)
	$UsernameInput = GUICtrlCreateInput("Username", 33, 32, 151, 21)
	GUICtrlSetFont(-1, 8, 800, 0, "MS Sans Serif")
	GUICtrlSetColor(-1, 0xFFFFFF)
	GUICtrlSetBkColor(-1, 0x000000)
	GUICtrlSetCursor (-1, 5)
	$PasswordInput = GUICtrlCreateInput("Passwort", 33, 64, 151, 21,$ES_PASSWORD)
	GUICtrlSetFont(-1, 6, 800, 0, "MS Sans Serif")
	GUICtrlSetColor(-1, 0xFFFFFF)
	GUICtrlSetBkColor(-1, 0x000000)
	GUICtrlSetCursor (-1, 5)
	GUICtrlCreateGroup("", -99, -99, 1, 1)
	GUICtrlCreateLabel("V:" & $version, 208,8,25,15)
	GUICtrlSetFont(-1,8)
	$LoginButton = GUICtrlCreateButton("Login", 208, 32, 48, 48,$BS_ICON)
	GUICtrlSetImage(-1, @ScriptDir & "\icons\login.ico",-1)
	GUICtrlSetTip(-1, "Login")
	GUICtrlSetCursor (-1, 0)
	$ForgotButton = GUICtrlCreateButton("Forgot Password", 208, 104, 48, 48, $BS_ICON)
	GUICtrlSetImage(-1, @ScriptDir & "\icons\forgot_password.ico",-1,$BS_ICON)
	GUICtrlSetTip(-1, "Passwort vergessen")
	GUICtrlSetCursor (-1, 0)
	GUICtrlSetState(-1,$GUI_DISABLE)
	$RememberMe = GUICtrlCreateCheckbox("Anmeldedaten speichern", 32, 120, 161, 17)
	GUICtrlSetBkColor(-1, 0xEEEEEE)
	GUICtrlSetState(-1,$GUI_DISABLE)
	GUISetState(@SW_SHOW)
	GUICtrlCreatePic(@ScriptDir & "\icons\guibackground.jpg",0,0,285,251)

	While 1
		$nMsg = GUIGetMsg()
		Switch $nMsg
			Case $GUI_EVENT_CLOSE
				_endScript()

			Case $LoginButton
				Global $Username = GUICtrlRead($UsernameInput)
				$password = GUICtrlRead($PasswordInput)
				Global $aPos = WinGetPos($LoginGUI)
				GUIDelete($LoginGUI)
				Run(@ScriptDir & "\includings\_GDIPlus_Connecting_To_Server.exe")
				_GUIMainMenu()
				errormessage(002)

		EndSwitch
	WEnd

EndFunc

;==================================================================================================================


; #FUNCTION# ;====================================================================================================
;
; Name...........: UDP Send
; Beschreibung ...: Sendet daten an den UDP Server
; Syntax.........: _UdpSend($ip,$port,$data,[optional]$waitForAnswer)
; Parameters ....: $ip = IP des Server
;				   $port = Port des Servers
;				   $data = Daten die geschickt werden sollen
;				   [optional$waitForAnswer = true oder false (default true)
; Return values .: Antwort des Servers (wenn vorhanden)
; Autor ........: Florian Krismer
;
; ;================================================================================================================

func _UdpSend($ip,$port,$data,$waitForAnswer = true)


	$loopCounter = 0
	UDPStartup()
	$udpSocket = UDPOpen($ip, $port)
	If @error Then ;Falls es probleme gibt beim Verbindungsaufbau wird die UPD verbindung geschlossen und das Programm beendet
		if WinExists("Steam Punk Loading") then
			WinKill("Steam Punk Loading")
		EndIf
		errormessage(002,true)
	EndIf

	UDPSend($udpSocket, $data)

	if $waitForAnswer == true Then
		Do
		Global $UDPReceivedData = UDPRecv($udpSocket, 65000) ;er wartet auf eine Antwort des Servers
		$loopCounter = $loopCounter + 1
		if $loopCounter >= 20 Then
			if WinExists("Steam Punk Loading") then
				WinKill("Steam Punk Loading")
			EndIf
			errormessage(002,true)
		EndIf

		sleep(20) ;timeout für wartezeit vom server

		Until $UDPReceivedData <> ""
			UDPShutdown()
			Return $UDPReceivedData
	EndIf

EndFunc


;==================================================================================================================


; encrypt data ;===================================================================================================
;
; Name...........: encrypt data
; Beschreibung ...: verschlüsselt daten
; Syntax.........: _encryptData($dataToEncrypt)
; Parameters ....: $dataToEncrypt = Daten die Verchlüsselt werden sollen (nur strings)
; Return values .: Verschlüsselte Daten
; Autor ........: Florian Krismer
;
; ;================================================================================================================

func _encryptData($dataToEncrypt)

	$EncryptedData = _Crypt_EncryptData($dataToEncrypt, "Di48JDLk83äa1KD8DKW§dfkj32DK38°k§DfLcI", $CALG_AES_256)

	return $EncryptedData

EndFunc


; decrypt data ;===================================================================================================
;
; Name...........: decrypt data
; Beschreibung ...: entschlüsselt daten
; Syntax.........: _decryptData($dataToDecrypt)
; Parameters ....: $dataToDecrypt = Daten die Entchlüsselt werden sollen (nur strings)
; Return values .: Entschlüsselte Daten
; Autor ........: Florian Krismer
;
; ;================================================================================================================


Func _decryptData($dataToDecrypt)

	$decryptedDataBinary = _Crypt_DecryptData($dataToDecrypt, "Di48JDLk83äa1KD8DKW§dfkj32DK38°k§DfLcI", $CALG_AES_256)
	$decryptedData = BinaryToString($decryptedDataBinary)

	return $decryptedData

EndFunc


; ;===============================================================================================================


; Function: exitScript ;===========================================================================================
;
; Name...........: exitScript
; Beschreibung ...: Beendet jede UDP Verbindung und beendet das Programm
; Syntax.........: _exitScript()
; Parameters ....: -
; Return values .: -
; Autor ........: SplashFlo
;
; ;================================================================================================================

func _endScript()

	UDPShutdown()
	Exit

EndFunc

;==================================================================================================================


; Function: GuiMainMenu() ;========================================================================================
;
; Name...........: GuiMainMenu
; Beschreibung ...: Hauptmenü
; Syntax.........: _GuiMainMenu()
; Parameters ....: -
; Return values .: -
; Autor ........: SplashFlo
;
; ;================================================================================================================


func _GUIMainMenu()
	$refreshTime = 200
	$data = _getMainMenuData()
	if WinExists("Steam Punk Loading") then
		WinKill("Steam Punk Loading")
	EndIf

	_GDIPlus_Startup()
	Global $iW = 615, $iH = 90
	$mainMenu = GUICreate("MainMenu", 615, 437, $apos[0],$apos[1])
	Global $cPic = GUICtrlCreatePic("", 0, 0, $iW, $iH)
	GUICtrlSetState(-1, $GUI_DISABLE)
	$MenuCommander = GUICtrlCreateMenu("&SBTV Commander")
	$BGimage = GUICtrlCreatePic(@scriptdir & "\icons\guibackground.jpg",0,0,615,437,$WS_CLIPSIBLINGS)
	GUISetIcon(@ScriptDir & "\bin\images\dsa.ico")
	$MenuInfo = GUICtrlCreateMenu("Info", $MenuCommander)
	$MenuVersion = GUICtrlCreateMenuItem("Version", $MenuInfo)
	$MenuCreator = GUICtrlCreateMenuItem("Ersteller", $MenuInfo)
	$MenuEnd = GUICtrlCreateMenuItem("Beenden", $MenuCommander)
	$Help = GUICtrlCreateMenu("&Hilfe")
	$MenuContact = GUICtrlCreateMenuItem("Kontakt", $Help)
	GUISetFont(8, 400, 0, "Georgia")
	GUISetBkColor(0xC61414)
	$ButtonAccount = GUICtrlCreateButton("Accountverwaltung",35, 120, 40, 40, $BS_ICON)
	GUICtrlSetImage(-1, @ScriptDir & "\icons\user.ico", -1)
	GUICtrlSetTip(-1, "Accountverwaltung")
	$ButtonBugReport = GUICtrlCreateButton("Bug Report / Feature Request",35, 180, 40, 40, $BS_ICON)
	GUICtrlSetImage(-1, @ScriptDir & "\icons\bug.ico", -1)
	GUICtrlSetTip(-1, "Bug Report / Feature Request")
	$GroupUserbereich = GUICtrlCreateGroup("Userbereich", 8, 88, 97, 289)
	GUICtrlCreateGroup("", -99, -99, 1, 1)
	$labelCountdown = GUICtrlCreateLabel("Nächstes Update in: 00:00:00", 103, 376, 400, 22)
	GUICtrlSetFont(-1, 12, 400, 0, "Georgia")
	GUICtrlSetColor(-1, 0xC0C0C0)
	$GroupUserbereich = GUICtrlCreateGroup("Adminbereich",500, 88, 97, 289)
	GUICtrlCreateGroup("", -99, -99, 1, 1)
	$buttonAdminSettings = GUICtrlCreateButton("Admin Verwaltung", 527,120,40,40,$BS_ICON)
	GUICtrlSetImage(-1,@ScriptDir & "\icons\adminSettings.ico",-1)
	GUICtrlSetTip(-1, "Admin Einstellungen")
	$buttonTeamspeak = GUICtrlCreateButton("Teamspeak", 527,180,40,40,$BS_ICON)
	GUICtrlSetImage(-1, @ScriptDir & "\icons\teamspeak.ico",-1)
	GUICtrlSetTip(-1,"Teamspeak Verwaltung")
	$LabelRefreshing = GUICtrlCreateLabel("Refreshing Data...", 280, 405, 90, 17)
	GUICtrlSetColor(-1, 0xFFFFFF)
	GUICtrlSetState(-1,$GUI_HIDE)
	GUISetState(@SW_SHOW)

	Global $hHBmp_BG, $hB, $iPerc = 0, $iSleep = 20, $fPower = 0.2

	GUIRegisterMsg($WM_TIMER, "PlayAnim")
	DllCall("user32.dll", "int", "SetTimer", "hwnd", $mainMenu, "int", 0, "int", $iSleep, "int", 0)

	Do
		Switch GUIGetMsg()
			Case $GUI_EVENT_CLOSE
				GUIRegisterMsg($WM_TIMER, "")
				_WinAPI_DeleteObject($hHBmp_BG)
				_GDIPlus_Shutdown()
				GUIDelete()
				Exit

			Case $MenuVersion
				MsgBox(0, "Info", "Aktuelle Versionsnummer: " & $version)

			Case $MenuEnd
				GUIRegisterMsg($WM_TIMER, "")
				_WinAPI_DeleteObject($hHBmp_BG)
				_GDIPlus_Shutdown()
				GUIDelete()
				Exit

			Case $ButtonBugReport
				Global $aPos = WinGetPos($MainMenu)
				GUIRegisterMsg($WM_TIMER, "")
				_WinAPI_DeleteObject($hHBmp_BG)
				_GDIPlus_Shutdown()
				GUIDelete($MainMenu)
				_BugReportGui()

			Case $ButtonAccount
				Global $aPos = WinGetPos($MainMenu)
				GUIRegisterMsg($WM_TIMER, "")
				_WinAPI_DeleteObject($hHBmp_BG)
				_GDIPlus_Shutdown()
				GUIDelete($MainMenu)
				_GUImyAccount()

			Case $buttonTeamspeak
				MsgBox(0, "Info", "Dieses Feature ist derzeit noch nicht verfügbar!")

			Case $buttonAdminSettings
				Global $aPos = WinGetPos($MainMenu)
				GUIRegisterMsg($WM_TIMER, "")
				_WinAPI_DeleteObject($hHBmp_BG)
				_GDIPlus_Shutdown()
				GUIDelete($MainMenu)
				_GUIadminSettings()
		EndSwitch
		Sleep(20)
		if $refreshTime <= 0 Then
			GUICtrlSetState($LabelRefreshing,$GUI_SHOW)
			$data = _getMainMenuData()
			$refreshTime = 200
			GUICtrlSetState($LabelRefreshing,$GUI_HIDE)
		Else
			$refreshTime = $refreshTime - 1
		EndIf
		if $nowsec <> @SEC Then
			Global $dateDiffDays = _DateDiff('d', _NowCalc(),$data)
			if $dateDiffDays <= 0 Then
				$dateDiffDays = 0
			EndIf
			Global $dateMinusDays = _DateAdd("d", $dateDiffDays,_NowCalc())

			Global $dateDiffHr = _DateDiff('h', $dateMinusDays,$data)
			if $dateDiffHr <= 0 Then
				$dateDiffHr = 0
			EndIf
			Global $dateMinusHr = _DateAdd("h", $dateDiffHr,$dateMinusDays)


			Global $dateDiffMin = _DateDiff('n', $dateMinusHr,$data)
			if $dateDiffmin <= 0 Then
				$dateDiffmin = 0
			EndIf
			Global $dateMinusmin = _DateAdd("n", $dateDiffmin,$dateMinusHr)


			Global $dateDiffSec = _DateDiff('s', $dateMinusmin,$data)
			if $dateDiffSec <= 0 Then
				$dateDiffSec = 0
			EndIf
			GUICtrlSetData($labelCountdown,"Nächstes Update in: " & $dateDiffDays & " days " & $dateDiffHr & " hrs " & $dateDiffMin & " min " & $dateDiffSec & " sec")
			if $dateDiffDays == 0 and $dateDiffHr == 0 and $dateDiffMin == 0 and $dateDiffSec == 0 Then
				_checkVersion()
			EndIf
			$nowsec = @SEC
		EndIf
	Until False

EndFunc

Func PlayAnim()
    $hHBmp_BG = _GDIPlus_DrawingText($iPerc, $iW, $iH)
    $hB = GUICtrlSendMsg($cPic, $STM_SETIMAGE, $IMAGE_BITMAP, $hHBmp_BG)
    If $hB Then _WinAPI_DeleteObject($hB)
    _WinAPI_DeleteObject($hHBmp_BG)
    $iPerc += $fPower
    If ($iPerc > 105) Then
        $iPerc = 0
        $fPower = 0.2
    EndIf
EndFunc


Func _GDIPlus_DrawingText($fProgress, $iW, $iH, $sText = "SBTV", $iColor = 0xFF00FF33)
    Local $hBmp = _GDIPlus_BitmapCreateFromScan0($iW, $iH)
    Local $hGfx = _GDIPlus_ImageGetGraphicsContext($hBmp)
    _GDIPlus_GraphicsSetSmoothingMode($hGfx, 2)
    _GDIPlus_GraphicsClear($hGfx, 0xFF141414)

    Local $fCX = $iW * 0.5
    Local $fCY = $iH * 0.5

    Local Static $tPath = 0, $sTextStore = ""
    If $sTextStore <> $sText Then
        $tPath = 0
        $sTextStore = $sText
    EndIf

    If Not IsDllStruct($tPath) Then
        Local $hPath_Txt = _GDIPlus_PathCreate()

        Local $hFamily = _GDIPlus_FontFamilyCreate("Impact")
        Local $tLayout = _GDIPlus_RectFCreate()
        _GDIPlus_PathAddString($hPath_Txt, $sText, $tLayout, $hFamily, 0, 96, 0)
        _GDIPlus_FontFamilyDispose($hFamily)
        Local $aBounds = _GDIPlus_PathGetWorldBounds($hPath_Txt)

        Local $hMatrix = _GDIPlus_MatrixCreate()
        _GDIPlus_MatrixTranslate($hMatrix, -$aBounds[0] - $aBounds[2] * 0.5, -$aBounds[1] - $aBounds[3] * 0.5)
        _GDIPlus_MatrixTranslate($hMatrix, $fCX, $fCY, True)
        _GDIPlus_PathTransform($hPath_Txt, $hMatrix)
        _GDIPlus_MatrixDispose($hMatrix)

        _GDIPlus_PathFlatten($hPath_Txt, 0.1)

        Local $aData = _GDIPlus_PathGetData($hPath_Txt)
        $aBounds = _GDIPlus_PathGetWorldBounds($hPath_Txt)
        _GDIPlus_PathDispose($hPath_Txt)

        Local $fStep = 0.2

        Local $iIdx = 0, $fX1, $fY1, $fX2, $fY2, $fX0, $fY0, $fD, $fDX, $fDY
        Local $aData2[$aData[0][0]][3] = [[0]]
        For $i = 1 To $aData[0][0]
            $fX1 = $fX2
            $fY1 = $fY2

            Select
                Case $aData[$i][2] = 0
                    $iIdx += 1

                    $fX0 = $aData[$i][0]
                    $fY0 = $aData[$i][1]
                    $fX2 = $aData[$i][0]
                    $fY2 = $aData[$i][1]

                    $aData2[$iIdx][0] = $aData[$i][0]
                    $aData2[$iIdx][1] = $aData[$i][1]
                    $aData2[$iIdx][2] = $aData[$i][2]

                Case Else
                    $fX2 = $aData[$i][0]
                    $fY2 = $aData[$i][1]

                    $fDX = ($fX2 - $fX1)
                    $fDY = ($fY2 - $fY1)
                    $fD = Sqrt($fDX * $fDX + $fDY * $fDY)


                    If $fD > 0 Then
                        For $j = 0 To $fD Step $fStep
                            $iIdx += 1
                            If $iIdx >= UBound($aData2) Then ReDim $aData2[$iIdx * 2][3]

                            $aData2[$iIdx][0] = $fX1 + $fDX * $j / $fD
                            $aData2[$iIdx][1] = $fY1 + $fDY * $j / $fD
                            $aData2[$iIdx][2] = 1
                        Next
                    EndIf
            EndSelect

            If BitAND($aData[$i][2], 0x80) Then
                $fX1 = $aData[$i][0]
                $fY1 = $aData[$i][1]
                $fX2 = $fX0
                $fY2 = $fY0

                $fDX = ($fX2 - $fX1)
                $fDY = ($fY2 - $fY1)
                $fD = Sqrt($fDX * $fDX + $fDY * $fDY)

                If $fD > 0 Then
                    For $j = 0 To $fD Step $fStep
                        $iIdx += 1
                        If $iIdx >= UBound($aData2) Then ReDim $aData2[$iIdx * 2][3]

                        $aData2[$iIdx][0] = $fX1 + $fDX * $j / $fD
                        $aData2[$iIdx][1] = $fY1 + $fDY * $j / $fD
                        $aData2[$iIdx][2] = 1
                    Next
                    $aData2[$iIdx][2] = 129
                EndIf
            EndIf

        Next



        $tPath = DllStructCreate("int Cnt; float Bounds[4]; float Data[" & $iIdx * 2 & "]; byte Type[" & $iIdx & "];")
        $tPath.Cnt = $iIdx
        $tPath.Bounds(1) = $aBounds[0]
        $tPath.Bounds(2) = $aBounds[1]
        $tPath.Bounds(3) = $aBounds[2]
        $tPath.Bounds(4) = $aBounds[3]

        For $i = 0 To $iIdx - 1
            $tPath.Data(($i * 2 + 1)) = $aData2[$i + 1][0]
            $tPath.Data(($i * 2 + 2)) = $aData2[$i + 1][1]
            $tPath.Type(($i + 1)) = $aData2[$i + 1][2]
        Next
    EndIf



    If Not IsDllStruct($tPath) Then Return
    $fProgress = $fProgress < 0 ? 0 : ($fProgress > 100 ? 100 : $fProgress)

    Local $iCnt = Int($tPath.Cnt * $fProgress / 100)
    If $tPath.Type(($iCnt)) = 0 Then $iCnt += 1

    Local $aResult = DllCall($__g_hGDIPDll, "int", "GdipCreatePath2", "struct*", DllStructGetPtr($tPath, "Data"), "struct*", DllStructGetPtr($tPath, "Type"), "int", $tPath.Cnt, "int", 0, "handle*", 0)
    If @error Then Return
    Local $hPath_Full = $aResult[5]

    Local $aResult = DllCall($__g_hGDIPDll, "int", "GdipCreatePath2", "struct*", DllStructGetPtr($tPath, "Data"), "struct*", DllStructGetPtr($tPath, "Type"), "int", $iCnt, "int", 0, "handle*", 0)
    If @error Then Return
    Local $hPath = $aResult[5]

    Local $hPen = _GDIPlus_PenCreate(0x44FFFFFF, 1)
    _GDIPlus_GraphicsDrawPath($hGfx, $hPath_Full, $hPen)
    _GDIPlus_GraphicsDrawRect($hGfx, $tPath.Bounds(1) - 5, $tPath.Bounds(2) + $tPath.Bounds(4) + 5, $tPath.Bounds(3) + 10, 10, $hPen)

    _GDIPlus_PenSetWidth($hPen, 3)
    _GDIPlus_PenSetColor($hPen, $iColor)
    _GDIPlus_GraphicsDrawRect($hGfx, $tPath.Bounds(1) + $tPath.Bounds(3) * $fProgress / 100 - 5, $tPath.Bounds(2) + $tPath.Bounds(4) + 5, 10, 10, $hPen)

    _GDIPlus_GraphicsDrawPath($hGfx, $hPath, $hPen)
    _GDIPlus_PenDispose($hPen)

    _GDIPlus_PathDispose($hPath)
    _GDIPlus_PathDispose($hPath_Full)


    Local $hHBITMAP = _GDIPlus_BitmapCreateHBITMAPFromBitmap($hBmp)
    _GDIPlus_GraphicsDispose($hGfx)
    _GDIPlus_BitmapDispose($hBmp)
    Return $hHBITMAP
EndFunc

;==================================================================================================================



; Function: BugReportGUI() ;========================================================================================
; Name...........: BugReportGUI
; Beschreibung ...: Reporting Gui
; Syntax.........: _BugReportGui()
; Parameters ....: -
; Return values .: -
; Autor ........: SplashFlo
;
; ;================================================================================================================

func _BugReportGui()

	$BugReportGUI = GUICreate("Bug Report / Feature Request", 466, 197, $apos[0],$apos[1])
	$Label1 = GUICtrlCreateLabel("Was möchtest du melden?", 72, 24, 309, 33)
	GUICtrlSetFont(-1, 18, 800, 0, "MS Sans Serif")
	$ComboList = GUICtrlCreateCombo("Einen Bug Melden", 120, 80, 185, 25, BitOR($CBS_DROPDOWN,$CBS_AUTOHSCROLL))
	$ButtonWeiter = GUICtrlCreateButton("Weiter", 216, 120, 75, 25)
	$ButtonZur = GUICtrlCreateButton("Zurück", 128, 120, 75, 25)
	GUICtrlSetData($ComboList, "Ein neues Feature vorschlagen", "Einen Bug melden")
	GUISetState(@SW_SHOW)

	While 1
		$nMsg = GUIGetMsg()
		Switch $nMsg
			Case $GUI_EVENT_CLOSE
				_endScript()
			Case $ButtonZur
				Global $aPos = WinGetPos($BugReportGUI)
				GUIDelete($BugReportGUI)
				_GUIMainMenu()
			Case $ButtonWeiter
				$selection = GUICtrlRead($ComboList)
				Switch $selection
					Case "Einen Bug Melden"
						Global $aPos = WinGetPos($BugReportGUI)
						GUIDelete($BugReportGUI)
						_reportBugGUI()

					Case "Ein neues Feature vorschlagen"

						Global $aPos = WinGetPos($BugReportGUI)
						GUIDelete($BugReportGUI)
						_featureRequestGui()
					Case Else
						MsgBox(16, "Fehler", "Bitte wähle etwas aus der Liste aus!")
				EndSwitch

		EndSwitch
	WEnd


EndFunc

func _reportBugGUI()

	$ReportBugGui = GUICreate("Report Bug", 464, 569, $apos[0],$apos[1])
	$ButtonSenden = GUICtrlCreateButton("&Senden", 249, 523, 75, 25)
	$ButtonZur = GUICtrlCreateButton("&Zurück", 138, 523, 75, 25)
	$labelArt = GUICtrlCreateLabel("Kurzbeschreibung", 120, 24, 215, 33)
	GUICtrlSetFont(-1, 18, 800, 0, "MS Sans Serif")
	$inputKurzbeschreibung = GUICtrlCreateInput("Das Hauptmenü öffnet sich nicht", 88, 112, 289, 21)
	GUICtrlSetLimit(-1, 32)
	$labelBeschreibung = GUICtrlCreateLabel("Beschreibe kurz deinen Bug", 160, 80, 137, 17)
	$editBeschreibung = GUICtrlCreateEdit("", 8, 224, 441, 273)
	GUICtrlSetLimit(-1, 500)
	GUICtrlSetData(-1, "Wenn man auf login drückt öffnet sich das Hauptmenü nicht")
	$Label1 = GUICtrlCreateLabel("Detailliert Beschreibung", 88, 160, 285, 33)
	GUICtrlSetFont(-1, 18, 800, 0, "MS Sans Serif")
	GUISetState(@SW_SHOW)

	While 1
		$nMsg = GUIGetMsg()
		Switch $nMsg
			Case $GUI_EVENT_CLOSE
				_endScript()

			Case $ButtonZur
				Global $aPos = WinGetPos($ReportBugGui)
				GUIDelete($ReportBugGui)
				_BugReportGui()

			Case $ButtonSenden
				GUISetState(@SW_HIDE)
				$startnew = Run(@ScriptDir & "\includings\_GDIPlus_Loading.exe " & "Sending data...|" & $apos[0] & "|" & $apos[1])
				$shortDes = GUICtrlRead($inputKurzbeschreibung)
				$longDes = GUICtrlRead($editBeschreibung)
				$newport = _buildConnection()
				$request = _UdpSend($ip,$newport,"ReportBug|" & $Username & "B" & "|" & $shortDes & "|" & $longDes)
				if WinExists("Steam Punk Loading") then
					WinKill("Steam Punk Loading")
				EndIf
				if $request == 1 Then
					MsgBox(0, "Info", "Dein Bug Report wurde erfolgreich versendet!" & @CRLF & "Danke für deine Unterstützung!")
					Global $aPos = WinGetPos($ReportBugGui)
					GUIDelete($ReportBugGui)
					_GuiMainMenu()
				Else
					MsgBox(16, "Info", "Dem Server ist ein Fehler beim Speichern passiert :(" & @CRLF & "Bitte versuche es erneut!")
					Global $aPos = WinGetPos($ReportBugGui)
					GUIDelete($ReportBugGui)
					_GuiMainMenu()
				EndIf

		EndSwitch
	WEnd

EndFunc

func _featureRequestGui()

	$FeatureRequestGui = GUICreate("Feature Request", 464, 569, $apos[0],$apos[1])
	$ButtonSenden = GUICtrlCreateButton("&Senden", 249, 523, 75, 25)
	$ButtonZur = GUICtrlCreateButton("&Zurück", 138, 523, 75, 25)
	$labelArt = GUICtrlCreateLabel("Kurzbeschreibung", 128, 24, 215, 33)
	GUICtrlSetFont(-1, 18, 800, 0, "MS Sans Serif")
	$inputKurzbeschreibung = GUICtrlCreateInput("", 88, 112, 289, 21)
	GUICtrlSetLimit(-1, 32)
	$labelBeschreibung = GUICtrlCreateLabel("Beschreibe kurz was du vorschlagen würdest", 128, 80, 218, 17)
	$editBeschreibung = GUICtrlCreateEdit("", 8, 224, 441, 273)
	GUICtrlSetLimit(-1, 500)
	$Label1 = GUICtrlCreateLabel("Detailliert Beschreibung", 88, 160, 285, 33)
	GUICtrlSetFont(-1, 18, 800, 0, "MS Sans Serif")
	GUISetState(@SW_SHOW)

	While 1
		$nMsg = GUIGetMsg()
		Switch $nMsg
			Case $GUI_EVENT_CLOSE
				_endScript()

			Case $ButtonZur
				Global $aPos = WinGetPos($FeatureRequestGui)
				GUIDelete($FeatureRequestGui)
				_BugReportGui()

			Case $ButtonSenden
				$startnew = Run(@ScriptDir & "\includings\_GDIPlus_Loading.exe " & "Sending data...|" & $apos[0] & "|" & $apos[1])
				GUISetState(@SW_HIDE)
				$shortDes = GUICtrlRead($inputKurzbeschreibung)
				$longDes = GUICtrlRead($editBeschreibung)
				$newport = _buildConnection()
				$request = _UdpSend($ip,$newport,"RequestFeature|" & $Username & "F" & "|" & $shortDes & "|" & $longDes)
				if WinExists("Steam Punk Loading") then
					WinKill("Steam Punk Loading")
				EndIf
				if $request == 1 Then
					MsgBox(0, "Info", "Dein Request wurde erfolgreich versendet!" & @CRLF & "Danke für deine Unterstützung!")
					Global $aPos = WinGetPos($FeatureRequestGui)
					GUIDelete($FeatureRequestGui)
					_GuiMainMenu()
				Else
					MsgBox(16, "Info", "Dem Server ist ein Fehler beim Speichern passiert :(" & @CRLF & "Bitte versuche es erneut!")
					Global $aPos = WinGetPos($FeatureRequestGui)
					GUIDelete($FeatureRequestGui)
					_GuiMainMenu()
				EndIf
		EndSwitch
	WEnd
EndFunc

;==================================================================================================================

; Function: BuildConnection() ;========================================================================================
; Name...........: BuildConnection
; Beschreibung ...: Baut eine Verbindung mit dem Server auf
; Syntax.........: _BugReportGui()
; Parameters ....: -
; Return values .: Der zu verwendende Port
; Autor ........: SplashFlo
;
; ;================================================================================================================

func _buildConnection()
$test = 5
	while $test >= 1
		$loopCounter = 0
		$UDPport = "9898"
		$waitForAnswer = 1
		$newPortInt = _randomPort()
		$newPort = String($newPortInt)
		UDPStartup()
		$udpSocket = UDPOpen($ip, "9898")
		If @error Then ;Falls es probleme gibt beim Verbindungsaufbau wird die UPD verbindung geschlossen und das Programm beendet
			if WinExists("Steam Punk Loading") then
				WinKill("Steam Punk Loading")
			EndIf
			errormessage(002,true)
		EndIf
		UDPSend($udpSocket,$newport)
		Do

			$UDPReceivedData = UDPRecv($udpSocket, 128) ;er wartet auf eine Antwort des Servers
			$loopCounter = $loopCounter + 1
			if $loopCounter >= 20 Then
				if $test <= 1 Then

					if WinExists("Steam Punk Loading") then
						WinKill("Steam Punk Loading")
					EndIf
					errormessage(002,true)
				EndIf
			EndIf
		until $UDPReceivedData <> "" Or $loopCounter >= 20
		if $UDPReceivedData <> "" Then
			Switch $UDPReceivedData
				Case "0"
					$test = $test - 1
					if $test == 2 Then

						errorMessage(002,true)
					EndIf

				Case "1"

					Return $newPort
					$test = 0

				Case Else
					$test = $test - 1
					if $test == 2 Then

						errorMessage(002,true)

					EndIf

			EndSwitch
		Else
			$test = $test - 1
		EndIf



		sleep(20) ;timeout für wartezeit vom server

	WEnd

	Sleep(50)
EndFunc


func _randomPort()

	$randomPort = Random(2000,9999,1)
	Switch $randomPort
		Case 9999
			_randomPort()
		Case 9898
			_randomPort()
	EndSwitch
	Return $randomPort


EndFunc


;==================================================================================================================


; Function: _getMainMenuData()() ;========================================================================================
;
; Name...........: _getMainMenuData()
; Beschreibung ...: Daten für das Hauptmenü werden zurückgegeben
; Syntax.........: _getMainMenuData()
; Parameters ....: -
; Return values .: Die Daten vom Server als Array
;				   0 für Error
; Autor ........: SplashFlo
;
; ;================================================================================================================

func _getMainMenuData()


	$port = _buildConnection()
	$data = _UdpSend($ip,$port,"getMainMenuData|" & $Username)
	if $data == 0 Then
		errormessage(002,true)
	EndIf
	Return $data

EndFunc

;==================================================================================================================


; Function: _checkVersion()() ;========================================================================================
;
; Name...........: _checkVersion()
; Beschreibung ...: Überprüft auf eine neue Version
; Syntax.........: _checkVersion()
; Parameters ....: -
; Return values .: Die Daten vom Server als Array
;				   0 für Error
; Autor ........: SplashFlo
;
; ;================================================================================================================

func _checkVersion()

	$versioncheck = _UdpSend($ip,"9898","version")
	if $version == $versioncheck Then

	Else

		$iMsgBoxAnswer = MsgBox(52,"Neue Version verfügbar","Es ist eine neue Version verfügbar!" & @CRLF & "Soll diese heruntergeladen und installiert werden?")
		Select
			Case $iMsgBoxAnswer = 6 ;Yes
				if IsAdmin() Then

					Run("C:\Program Files\SBTVPrograms\installer\NewVersionInstaller.exe")
				Else
					MsgBox(16, "Error", "Bitte starten Sie das Programm als Administrator!")
				EndIf
				_endScript()

			Case $iMsgBoxAnswer = 7 ;No
				MsgBox(16, "Info", "Sie müssen die neue Version installieren um das Programm zu starten")
				_endScript()
		EndSelect
	EndIf
EndFunc

;==================================================================================================================


; Function: _GUImyAccount()() ;=====================================================================================
;
; Name...........: _GUImyAccount()
; Beschreibung ...: Persönliche Einstellungen
; Syntax.........: _GUImyAccount()
; Parameters ....: -
; Return values .: -
; Autor ........: SplashFlo
;
; ;================================================================================================================

func _GUImyAccount()

	$ProfileEditorGUI = GUICreate("Profileinstellungen für: " & $Username, 615, 437, $apos[0], $apos[1])
	$BGimage = GUICtrlCreatePic(@scriptdir & "\icons\guibackground.jpg",0,0,615,437,$WS_CLIPSIBLINGS)
	$GroupMyAccount = GUICtrlCreateGroup("Mein Account", 8, 40, 145, 113)
	GUICtrlSetFont(-1, 12, 800, 0, "MS Sans Serif")
	GUICtrlSetColor(-1, 0xFFFFFF)
	$ButtonChangePassword = GUICtrlCreateButton("Change Password", 56, 96, 40, 40, $BS_ICON)
	GUICtrlSetImage(-1, "C:\Users\florian.krismer\Documents\GitHub\SBTV-Commander\Client\icons\changePassword.ico", -1)
	$labelchangepass = GUICtrlCreateLabel("Passwort ändern", 24, 72, 104, 20)
	GUICtrlSetFont(-1, 10, 400, 0, "MS Sans Serif")
	GUICtrlCreateGroup("", -99, -99, 1, 1)
	GUICtrlSetTip(-1, "Passwort ändern")
	$Group1 = GUICtrlCreateGroup("Hilfe und Support", 424, 40, 177, 113)
	GUICtrlSetFont(-1, 12, 800, 0, "MS Sans Serif")
	GUICtrlSetColor(-1, 0xFFFFFF)
	$buttonRequestHelp = GUICtrlCreateButton("Hilfe Anfordern", 488, 96, 40, 40, $BS_ICON)
	GUICtrlSetState(-1,$GUI_DISABLE)
	GUICtrlSetImage(-1, "C:\Users\florian.krismer\Documents\GitHub\SBTV-Commander\Client\icons\support.ico", -1)
	$labelrequesthelp = GUICtrlCreateLabel("Hilfe Anfordern", 464, 72, 92, 20)
	GUICtrlSetFont(-1, 10, 400, 0, "MS Sans Serif")
	GUICtrlCreateGroup("", -99, -99, 1, 1)
	GUICtrlSetTip(-1, "Passwort ändern")
	$Buttonback = GUICtrlCreateButton("Zurück", 8, 8, 75, 25)
	$labelNews = GUICtrlCreateLabel("News", 152, 16, 271, 17)
	GUICtrlSetState(-1,$GUI_HIDE)
	GUISetState(@SW_SHOW)

	While 1
		$nMsg = GUIGetMsg()
		Switch $nMsg
			Case $GUI_EVENT_CLOSE
				Global $aPos = WinGetPos($ProfileEditorGUI)
				GUIDelete($ProfileEditorGUI)
				_GUIMainMenu()

			Case $Buttonback
				Global $aPos = WinGetPos($ProfileEditorGUI)
				GUIDelete($ProfileEditorGUI)
				_GUIMainMenu()

			Case $buttonRequestHelp
				MsgBox(0, "Info", "Dieses Feature ist derzeit noch nicht verfügbar!")

			Case $ButtonChangePassword
				$finish = false
				while $finish = False

					$password1 = InputBox("Passwortänderung","Bitte geben Sie Ihr neues Passwort ein","","*")
					Select
						Case @Error = 0 ;OK - The string returned is valid
							if $password1 == "" Then
								$run = false
								MsgBox(16, "Error", "Bitte geben Sie ein gültiges Passwort ein!")
							Else
								$run = true
							EndIf
						Case @Error = 1 ;The Cancel button was pushed
							$run = False
							$finish = true
					EndSelect

					if $run = true Then
						$password2 = InputBox("Passwortbestätigung", "Bitte bestätigen Sie Ihr Passwort", "", "*")
						Select
							Case @error = 0
								if $password1 == $password2 Then
									$port = _buildConnection()
									$newPasswort = _encryptData($password2)
									$ChangePassword = _UdpSend($ip,$port,"newpass|" & $Username & "|" & $newPasswort & "|1")
									if $ChangePassword == "1" Then
										GUICtrlSetData($labelNews,"Passwort wurde erfolgreich geändert!")
										GUICtrlSetState($labelNews,$GUI_SHOW)
										$finish = true
									Else
										MsgBox(16, "Fehler", "Es ist ein Fehler beim ändern des Passworts aufgetreten!" & @CRLF & "Bitte versuchen Sie es später erneut!")
										$finish = true
									EndIf
								Else
									$finish = False
									MsgBox(16, "Fehler", "Die Passwörter stimmen nicht überein!")
								endif

							Case @error = 1
								$finish = true
						EndSelect
					Else
						$run = True
						MsgBox(0, "Info", "Passwortänderung abgebrochen!")
					EndIf
				WEnd
		EndSwitch
	WEnd


EndFunc

;==================================================================================================================


; Function: _GUImyAccount()() ;=====================================================================================
;
; Name...........: _GUImyAccount()
; Beschreibung ...: Persönliche Einstellungen
; Syntax.........: _GUImyAccount()
; Parameters ....: -
; Return values .: -
; Autor ........: SplashFlo
;
; ;================================================================================================================

func _GUIadminSettings()
	$GUIAdminSelection = GUICreate("AdminSelection", 219, 373, $aPos[0], $apos[1])
	$buttonUserControl = GUICtrlCreateButton("Benutzerverwaltung", 32, 16, 147, 41)
	$buttonReports = GUICtrlCreateButton("Bug/Feature Reports", 32, 72, 147, 41)
	$buttonHelpRequests = GUICtrlCreateButton("Hilfeanfragen", 32, 128, 147, 41)
	GUISetState(@SW_SHOW)

	While 1
		$nMsg = GUIGetMsg()
		Switch $nMsg
			Case $GUI_EVENT_CLOSE
				Global $aPos = WinGetPos($GUIAdminSelection)
				GUIDelete($GUIAdminSelection)
				_GUIMainMenu()
			Case $buttonReports
				Global $aPos = WinGetPos($GUIAdminSelection)
				GUIDelete($GUIAdminSelection)
				_GUIShowReports()

		EndSwitch
	WEnd
EndFunc


func _GUIShowReports()

	$port = _buildConnection()
	$requestsRaw = _UdpSend($ip,$port,"getRequests|")
	$request = StringSplit($requestsRaw,"|")
	$GUIShowReports = GUICreate("Show Reports", 612, 566, $apos[0], $apos[1])
	$List1 = GUICtrlCreateList("", 0, 0, 609, 422)
	GUICtrlSetLimit(-1, 200)
	$buttonCloseRequest = GUICtrlCreateButton("Ticket löschen",256,460,75,25)
	$buttonShow = GUICtrlCreateButton("Anzeigen", 256, 432, 75, 25)
	$buttonBack = GUICtrlCreateButton("Zurück", 8, 536, 75, 25)
	for $i = 1 to $request[0]
		_GUICtrlListBox_AddString($List1,$request[$i])
	Next

	GUISetState(@SW_SHOW)
	While 1
		$nMsg = GUIGetMsg()
		Switch $nMsg
			Case $GUI_EVENT_CLOSE
				Global $aPos = WinGetPos($GUIShowReports)
				GUIDelete($GUIShowReports)
				_GUIMainMenu()

			Case $buttonShow
				$index = _GUICtrlListBox_GetCurSel($List1)
				$text = _GUICtrlListBox_GetText($List1,$index)
				$usernameString = StringInStr($text, "User:")
				$usernameString = $usernameString + 5
				$temp = StringTrimLeft($text, $usernameString)
				$totalLenth = StringLen($temp)
				$temp2 = StringInStr($temp, "ID:")
				$temp2 = $temp2 - 6
				$totalLenth = $totalLenth - $temp2
				$usernameTest = StringTrimRight($temp,$totalLenth)

				$temp = StringInStr($text, "ID:")
				$temp = $temp + 2
				$temp2 = StringTrimLeft($text,$temp)
				$temp3 = StringInStr($temp2,"Message")
				$temp3 = $temp3 - 6
				$totalLenth = Stringlen($temp2)
				$temp3 = $totalLenth - $temp3
				$id = StringTrimRight($temp2,$temp3)
				$port = _buildConnection()
				$data = _UdpSend($ip,$port,"viewRequests|" & $usernameTest & $id)
				if $data == "0" Then
					MsgBox(16,"Error", "Error while getting request")
				Else
					Global $aPos = WinGetPos($GUIShowReports)
					GUIDelete($GUIShowReports)
					_viewRequest($data)
				EndIf

			Case $buttonCloseRequest

				$index = _GUICtrlListBox_GetCurSel($List1)
				$text = _GUICtrlListBox_GetText($List1,$index)
				$usernameString = StringInStr($text, "User:")
				$usernameString = $usernameString + 5
				$temp = StringTrimLeft($text, $usernameString)
				$totalLenth = StringLen($temp)
				$temp2 = StringInStr($temp, "ID:")
				$temp2 = $temp2 - 6
				$totalLenth = $totalLenth - $temp2
				$usernameTest = StringTrimRight($temp,$totalLenth)

				$temp = StringInStr($text, "ID:")
				$temp = $temp + 2
				$temp2 = StringTrimLeft($text,$temp)
				$temp3 = StringInStr($temp2,"Message")
				$temp3 = $temp3 - 6
				$totalLenth = Stringlen($temp2)
				$temp3 = $totalLenth - $temp3
				$id = StringTrimRight($temp2,$temp3)
				$port = _buildConnection()
				$data = _UdpSend($ip,$port,"deleteRequests|" & $usernameTest & $id)
				if $data == "0" Then
					MsgBox(16,"Error", "Error while deleting request")
				Else
					Global $aPos = WinGetPos($GUIShowReports)
					GUIDelete($GUIShowReports)
					_GUIShowReports()
				EndIf

			Case $Buttonback
				Global $aPos = WinGetPos($GUIShowReports)
				GUIDelete($GUIShowReports)
				_GUIMainMenu()






		EndSwitch
	WEnd
EndFunc

func _viewRequest($data)

	$newData = StringSplit($data,"|")

	$GUIListRequest = GUICreate("List Request", 428, 394, $apos[0], $apos[1])
	GUISetBkColor(0x99B4D1)
	$labelRequest = GUICtrlCreateLabel($newData[2], 0, 64, 420, 252, BitOR($WS_VSCROLL,$WS_BORDER))
	$labelKind = GUICtrlCreateLabel("Typ: " & $newData[1], 112, 16, 178, 24)
	GUICtrlSetFont(-1, 12, 800, 0, "MS Sans Serif")
	$buttonBack = GUICtrlCreateButton("Zurück", 24, 352, 75, 25)
	GUISetState(@SW_SHOW)

	While 1
		$nMsg = GUIGetMsg()
		Switch $nMsg
			Case $GUI_EVENT_CLOSE

				Global $aPos = WinGetPos($GUIListRequest)
				GUIDelete($GUIListRequest)
				_GUIShowReports()

			Case $buttonBack

				Global $aPos = WinGetPos($GUIListRequest)
				GUIDelete($GUIListRequest)
				_GUIShowReports()

		EndSwitch
	WEnd


EndFunc



;==================================================================================================================