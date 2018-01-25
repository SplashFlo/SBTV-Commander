;=================================================================================================================
; Compiler Settings
;=================================================================================================================


#pragma compile(UPX, False)
;#pragma compile(FileDescription, DESCRIPTION)
#pragma compile(ProductName, SBTV Commander)
#pragma compile(ProductVersion, 0.1)
#pragma compile(FileVersion, 0.1) ; The last parameter is optional.
#pragma compile(LegalCopyright, © SplashBirdTV)
;#pragma compile(LegalTrademarks, '"Trademark something1, and some text in "quotes" etc...')
#pragma compile(CompanyName, 'SplashBirdTV')
OnAutoItExitRegister("_exitScript")

;=================================================================================================================


;=================================================================================================================
; Variablen
;=================================================================================================================


;=================================================================================================================


;=================================================================================================================
; Includings
;=================================================================================================================

#include <File.au3>
#include <Date.au3>
#include <Crypt.au3>
#include <GDIPlus.au3>
#include <MsgBoxConstants.au3>

;=================================================================================================================


; Function: Startup ;=============================================================================================
;
; Name...........: Startup Funktion
; Beschreibung ...: Überprüft ob alle Daten vorhanden sind
; Syntax.........: _startUp()
; Parameters ....: -
; Return values .: -
; Autor ........: SplashFlo
;
; ;================================================================================================================

if FileExists("C:\Program Files\SBTVPrograms\Commander") Then

	MsgBox(64, "Info", "Programmstart erfolgreich!")

Else

	errorMessage(001,true)

EndIf

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

		Case Else
			MsgBox(16, "#UNKNOWN ERROR#", "Es ist ein schwerwiegender Fehler beim erstellen einer Fehlermeldung aufgetreten!")
			Exit
	EndSwitch

	if $stopScript == true Then
		_exitScript()
	EndIf

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

func _exitScript()

	UDPShutdown()
	Exit

EndFunc

;==================================================================================================================