;=================================================================================================================
; Compiler Settings
;=================================================================================================================

#RequireAdmin
#pragma compile(Console, true)
#pragma compile(UPX, False)
;#pragma compile(FileDescription, DESCRIPTION)
#pragma compile(ProductName, ConnectionBuilder)
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
$loginStart = 0
$c1 = 0
$c2 = 0
$g_IP = @IPAddress1
$version = IniRead($versioningFile, "Version", "currenVersion", "err")
$userini = "C:\SBTV Commander\users\users.ini"
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
	Exit
EndIf

;------------------------------------------------------
;-------------UDP Abfragen bearbeiten------------------
;------------------------------------------------------
_FileWriteLog($logfile, "Starting UDP Server..." & @CRLF)
_FileWriteLog($logfile, "Current Port : " & $UDPPort & @CRLF)

_FileWriteLog($logfile, "Server is ready to use" & @CRLF & @CRLF & @CRLF)
While 1 ;Entlosschleife

	$aData = UDPRecv($aSocket, 64, 2) ;empfängt Daten von einem Client
	;durch das Flag 2 wird folgendes Array ausgegeben:
	;	$aData[0]: data
	;	$aData[1]: IP des Clients
	;	$aData[2]: Port des Clients
	if $aData <> "" Then
		Global $splitString = StringSplit($aData[0], " ")
		_FileWriteLog($logfile, "Intialising new connection" & @CRLF)
		Global $aClientArray[4] = [$aSocket[0], $aSocket[1], $aData[1], $aData[2]]
		if $splitString[0] > 1 Then
			_arrayRequest($aData)
		Else
			_normalRequest($aData)
		EndIf
	EndIf
	Sleep(20)
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

	Switch $aData[0]
		case "version"
			_FileWriteLog($logfile, "Requested new Version " & @CRLF & "Send new version" & @CRLF & @CRLF)
			UDPSend($aClientArray, $version)
			Exit

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

		case Else
			Exit
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


; passchange;==========================================================================================================
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

; ;================================================================================================================


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
	UDPShutdown()
	FileWrite($logfile, "--------------------------------------------End of log--------------------------------------------" & @CRLF & @CRLF & @CRLF)
	Exit


EndFunc