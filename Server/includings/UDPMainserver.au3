;=================================================================================================================
; Compiler Settings
;=================================================================================================================

#RequireAdmin
;#pragma compile(Console, true)
#pragma compile(UPX, False)
;#pragma compile(FileDescription, DESCRIPTION)
#pragma compile(ProductName, MainUDPServer)
#pragma compile(ProductVersion, 0.1)
#pragma compile(FileVersion, 0.1) ; The last parameter is optional.
#pragma compile(LegalCopyright, © SplashBirdTV)
;#pragma compile(LegalTrademarks, '"Trademark something1, and some text in "quotes" etc...')
#pragma compile(CompanyName, 'SplashBirdTV')


;=================================================================================================================


;=================================================================================================================
; Includings
;=================================================================================================================

#include <File.au3>
#include <Date.au3>
#include <Crypt.au3>
#include <GDIPlus.au3>
#include <MsgBoxConstants.au3>
OnAutoItExitRegister("_exit")

;=================================================================================================================


;=================================================================================================================
; Variablen
;=================================================================================================================

Global $UDPPort = $CmdLineRaw
Global $versioningFile = "C:\SBTV Commander\Version\version.ini"
$login = 0
$idle = 0
$loginStart = 0
$c1 = 0
$c2 = 0
$g_IP = "10.53.32.64"
$scriptdir = "C:\SBTV Commander"
$version = IniRead($versioningFile, "Version", "current", "err")
$userini = "C:\SBTV Commander\users\users.ini"
$versioningFile = "C:\SBTV Commander\Version\version.ini"
$portsFile = "C:\SBTV Commander\connections\currentConnections.ini"
$logfile = "C:\SBTV Commander\logs\main.log"
OnAutoItExitRegister("_exit") ;Falls das Script beendet wird, wird folgendes gesendet

;=================================================================================================================




; startup ;====================================================================================================
;
; Name...........: UDP Startup
; Beschreibung ...: UDP Startup
; Syntax.........: -
; Parameters ....: -
; Return values .: -
; Autor ........: Florian Krismer
;
; ;================================================================================================================

FileWrite($logfile,"--------------------------------------------Start of Log--------------------------------------------" & @CRLF)

$checkPort = IniRead($portsfile, "Ports", $UDPPort, 0)


if $checkPort == 0 Then

	_FileWriteLog($logfile, "Error the Port is not ready to use (see ports.ini)" & @CRLF & @CRLF)
	exit

EndIf


UDPStartup() ;startet den UDP-Service
$aSocket = UDPBind($g_IP, $UDPPort) ; Öffnet einen Socket mit der IP $g_IP und dem Port 65432
; $aSocket ist genauso aufgebaut wie das Array von UDPOpen()
;	$aSocket[1]: real socket
;	$aSocket[2]: IP des Servers
;	$aSocket[3]: Port des Servers


;------------------------------------------------------
;-----------------Abfrage des UDP----------------------
;------------------------------------------------------


If @error Then
	_FileWriteLog($logfile, "ERROR: Could not start UDP Service" & @CRLF)
	_exit()
EndIf

;------------------------------------------------------
;-------------UDP Abfragen bearbeiten------------------
;------------------------------------------------------
_FileWriteLog($logfile, "Starting UDP Server..." & @CRLF)
_FileWriteLog($logfile, "Current Port : " & $UDPPort & @CRLF)
IniWrite($portsFile,"Running", $UDPPort, "yes")
_FileWriteLog($logfile, "Server is ready to use" & @CRLF & @CRLF & @CRLF)
While 1 ;Entlosschleife

	$aData = UDPRecv($aSocket,9999, 2) ;empfängt Daten von einem Client
	;durch das Flag 2 wird folgendes Array ausgegeben:
	;	$aData[0]: data
	;	$aData[1]: IP des Clients
	;	$aData[2]: Port des Clients
	if $aData <> "" Then
		Global $splitString = StringSplit($aData[0], "|")
		_FileWriteLog($logfile, "Intialising new connection" & @CRLF)
		Global $aClientArray[4] = [$aSocket[0], $aSocket[1], $aData[1], $aData[2]]
		if $splitString[0] > 1 Then
			_arrayRequest($aData)
		Else
			_normalRequest($aData)
		EndIf
	EndIf
	Sleep(20)
	$idle = $idle + 1
	if $idle > 1500 Then
		_FileWriteLog($logile, "Connection closed because of idling too long" & @CRLF & @CRLF)
		_exit()
	EndIf
WEnd
;==================================================================================================================

; normal request ;=================================================================================================
;
; Name...........: normal request
; Beschreibung ...: a non array request
; Syntax.........: _normalRequest($aData)
; Parameters ....: $aData = Array der UDP Verbindung
; Return values .: -
; Autor ........: Florian Krismer
;
; ;================================================================================================================

func _normalRequest($aData)
	_FileWriteLog($logfile, "Getting new Request: " & $aData[0] & @CRLF)
	Switch $aData[0]
		case "version"
			_FileWriteLog($logfile, "Requested new Version " & @CRLF & "Send new version" & @CRLF & @CRLF)
			UDPSend($aClientArray, $version)
			_exit()
		case Else
			_FileWriteLog($logfile, "Unknown call")
	EndSwitch

EndFunc

; ;================================================================================================================

; array request ;=================================================================================================
;
; Name...........: array request
; Beschreibung ...: a array request
; Syntax.........: _arrayRequest($aData)
; Parameters ....: $aData = Array der UDP Verbindung
; Return values .: -
; Autor ........: Florian Krismer
;
; ;================================================================================================================

func _arrayRequest($aData)
	_FileWriteLog($logfile, "Getting new Request: " & $splitString[1] & @CRLF)
	Select
		case $splitString[1] = "login"
			; Return values .: 0 = Fehler
			;				   1 = Login erfolgreich
			;				   2 = neues Passwort wird benötigt
			_login()

		case $splitString[1] = "newpass"
			;Return Values.: 0 = Passwort wurde nicht geändert
			;				 1 = Passwort erfolgreich geändert
			_newPass()

		case $splitString[1] = "RequestFeature"
			;Return Values.: 0 = Request wurde nicht eingetragen
			;				 1 = Request wurde eingeragen
			_RequestFeature()

		case $splitString[1] = "ReportBug"
			;Return Values.: 0 = Bug wurde nicht eingetragen
			;				 1 = Bug wurde eingeragen
			_ReportBug()

		case $splitString[1] = "getMainMenuData"
			;Return Values.: Daten für den Benutzer
			_getMainMenuData()
		case Else
			_exit()
	EndSelect

EndFunc

; ;================================================================================================================

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


; feature request;================================================================================================
;
; Name...........: request feature
; Beschreibung ...: Client will ein Feature Request senden
; Syntax.........: _RequestFeature()
; Parameters ....: -
; Return values .: -
; Autor ........: Florian Krismer
;
; ;================================================================================================================

func _RequestFeature()

	_FileWriteLog($logfile, "User is requesting an new feature" & @CRLF)
	$username = $splitString[2]
	$shortDes = $splitString[3]
	$longDes = $splitString[4]
	$test = IniRead($scriptdir & "\requests\Requests.ini", "FeatureRequest",$username & "1","err")
	if $test == "err" Then
		IniWrite($scriptdir & "\requests\Requests.ini", "FeatureRequest", $username & "1", $shortDes)
		FileWrite($scriptdir & "\requests\feature\" & $username & "1" & ".txt", "Long Description:"  & @CRLF & $longDes)
	Else
		$test = 2
		while $test < 99
			$read = IniRead($scriptdir & "\requests\Requests.ini", "FeatureRequest",$username & $test,"err")
			if $read == "err" Then
				IniWrite($scriptdir & "\requests\Requests.ini", "FeatureRequest", $username & $test, $shortDes)
				FileWrite($scriptdir & "\requests\feature\" & $username & $test & ".txt", "Long Description:"  & @CRLF & $longDes)
				$test = 100
			Else
				$test = $test + 1
			EndIf

		WEnd
	EndIf

	if @error Then
		UDPSend($aClientArray,"0")
	Else
		UDPSend($aClientArray,"1")
	EndIf
	_exit()

EndFunc

; ;================================================================================================================


; bug report;================================================================================================
;
; Name...........:bug report
; Beschreibung ...: Clinet sendet einen Bug Repoort
; Syntax.........: _ReportBug()
; Parameters ....: -
; Return values .: -
; Autor ........: Florian Krismer
;
; ;================================================================================================================

func _ReportBug()

	_FileWriteLog($logfile, "User is sending a Bug Report" & @CRLF)
	$username = $splitString[2]
	$shortDes = $splitString[3]
	$longDes = $splitString[4]
	$test = IniRead($scriptdir & "\requests\Requests.ini", "BugReport",$username & "1","err")
	if $test == "err" Then
		IniWrite($scriptdir & "\requests\Requests.ini", "BugReport", $username & "1", $shortDes)
		FileWrite($scriptdir & "\requests\bug\" & $username & "1" & ".txt", "Long Description:"  & @CRLF & $longDes)
	Else
		$test = 2
		while $test < 99
			$read = IniRead($scriptdir & "\requests\Requests.ini", "BugReport",$username & $test,"err")
			if $read == "err" Then
				IniWrite($scriptdir & "\requests\Requests.ini", "BugReport", $username & $test, $shortDes)
				FileWrite($scriptdir & "\requests\bug\" & $username & $test & ".txt", "Long Description:"  & @CRLF & $longDes)
				$test = 100
			Else
				$test = $test + 1
			EndIf

		WEnd
	EndIf

	if @error Then
		UDPSend($aClientArray,"0")
	Else
		UDPSend($aClientArray,"1")
	EndIf
	_exit()

EndFunc

; ;================================================================================================================


; passchange;======================================================================================================
;
; Name...........: newpass
; Beschreibung ...: Client versucht das Passwort zu ändern
; Syntax.........: _newPass()
; Parameters ....: -
; Return values .: -
; Autor ........: Florian Krismer
;
; ;================================================================================================================

func _newPass()

	$username = $splitString[1]
	$passwordCrypted = $splitString[2]
	$currentPassCrypted = IniRead($userini, "users",$username,"err")

	if $currentPassCrypted == "err" Then
		UDPSend($aClientArray,"0")
	ElseIf $currentPassCrypted == "new" Then
		IniWrite($userini, "users", $username, $passwordCrypted)
		if @error Then
			UDPSend($aClientArray,"0")
		Else
			UDPSend($aClientArray, "1")
		EndIf
	EndIf

	Exit
EndFunc

; ;===============================================================================================================


; login;==========================================================================================================
;
; Name...........: login
; Beschreibung ...: Client versucht sich einzuloggen
; Syntax.........: _login()
; Parameters ....: -
; Return values .: -
; Autor ........: Florian Krismer
;
; ;================================================================================================================

func _login()

	$username = $splitString[2]
	_FileWriteLog($logfile, "User is trying to login with following username: " & $username & @CRLF)
	$passwordCrypted = $splitString[3]
	$readPassCrypted = IniRead($userini, "users",$username,"err")

	if $readPassCrypted == "err" Then
		UDPSend($aClientArray, "0")
		_FileWriteLog($logfile, "User failed to login. Reason: user not defined" & @CRLF & @CRLF)
	ElseIf $readPassCrypted == "new" Then
		UDPSend($aClientArray, "2")
		_FileWriteLog($logfile, "User needs a new password" & @CRLF & @CRLF)
	EndIf

	if $readPassCrypted == $passwordCrypted Then
		UDPSend($aClientArray, "1")
		_FileWriteLog($logfile, "User successfully logged in" & @CRLF & @CRLF)
	Else
		UDPSend($aClientArray, "0")
		_FileWriteLog($logfile, "User failed to login. Reason: wrong password for user" & @CRLF & @CRLF)
	EndIf

	Exit
EndFunc

; ;===============================================================================================================


; _getMainMenuData ;==========================================================================================================
;
; Name...........: _getMainMenuData
; Beschreibung ...: sendet die Daten vom Client fürs Hauptmenü zurück (Rechte,...)
; Syntax.........: _getMainMenuData()
; Parameters ....: -
; Return values .: -
; Autor ........: Florian Krismer
;
; ;================================================================================================================


func _getMainMenuData()

	$username = $splitString[2]
	$newVersion = IniRead($versioningFile,"Version", "newVersionDate",0)
	UDPSend($aClientArray,$newVersion)
	_exit()


EndFunc


; ;===============================================================================================================


; exit ;==========================================================================================================
;
; Name...........: _exit
; Beschreibung ...: exit of script
; Syntax.........: _exit()
; Parameters ....: -
; Return values .: -
; Autor ........: Florian Krismer
;
; ;================================================================================================================

func _exit()

	IniDelete($portsfile, "Ports", $UDPPort)
	IniDelete($portsFile, "Running", $UDPPort)
	UDPShutdown()
	FileWrite($logfile, "--------------------------------------------End of log--------------------------------------------" & @CRLF & @CRLF & @CRLF)
	Exit


EndFunc