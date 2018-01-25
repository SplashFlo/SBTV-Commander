;=================================================================================================================
; Compiler Settings
;=================================================================================================================


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
#include <Crypt.au3>
#include <GuiImageList.au3>
#include <GDIPlus.au3>
#include <MsgBoxConstants.au3>
#include <ButtonConstants.au3>
#include <EditConstants.au3>
#include <GUIConstantsEx.au3>
#include <WindowsConstants.au3>
#include <ButtonConstants.au3>
#include <login.au3>


;=================================================================================================================


;=================================================================================================================
; Variablen
;=================================================================================================================

$version = 0.1 ;Aktuelle Versionsnumemr als double
$clientPath = "C:\Program Files\SBTVPrograms\Commander" ;Pfad nach Installation von dem Programm

loginGUI() ; Programmstart
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
	if FileExists("C:\Program Files\SBTVPrograms\Commander") Then

	Else

		errorMessage(001,true)

	EndIf

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

	$Login = GUICreate("Login", 260, 153, -1, -1)
	GUISetIcon(@ScriptDir & "\icons\sbtv.ico")
	GUISetBkColor(0xC0C0C0)
	$Group = GUICtrlCreateGroup("", 16, 16, 178, 81)
	$Username = GUICtrlCreateInput("Username", 33, 32, 151, 21)
	GUICtrlSetFont(-1, 8, 800, 0, "MS Sans Serif")
	GUICtrlSetColor(-1, 0xFFFFFF)
	GUICtrlSetBkColor(-1, 0x000000)
	GUICtrlSetCursor (-1, 5)
	$Password = GUICtrlCreateInput("Passwort", 33, 64, 151, 21)
	GUICtrlSetFont(-1, 6, 800, 0, "MS Sans Serif")
	GUICtrlSetColor(-1, 0xFFFFFF)
	GUICtrlSetBkColor(-1, 0x000000)
	GUICtrlSetCursor (-1, 5)
	GUICtrlCreateGroup("", -99, -99, 1, 1)
	GUICtrlCreateLabel("V:" & $version, 208,8,25,15)
	GUICtrlSetFont(-1,8)
	$Login = GUICtrlCreateButton("Login", 208, 32, 48, 48,$BS_ICON)
	GUICtrlSetImage(-1, @ScriptDir & "\icons\login.ico",-1)
	GUICtrlSetTip(-1, "Login")
	GUICtrlSetCursor (-1, 0)
	$Forgot = GUICtrlCreateButton("Forgot Password", 208, 104, 48, 48, $BS_ICON)
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

			Case $Login
				$loginTry = login($Username, $Password)
				MsgBox(0, "", $loginTry)

		EndSwitch
	WEnd

EndFunc

;==================================================================================================================


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