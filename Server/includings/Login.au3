;=================================================================================================================
; Compiler Settings
;=================================================================================================================


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

OnAutoItExitRegister("_exit")

;=================================================================================================================


;=================================================================================================================
; Variablen
;=================================================================================================================

$login = 0
$loginStart = 0
$c1 = 0
$c2 = 0
$serverPort = 8080
$g_IP = @IPAddress1
$version = "0.1"
$userini = "C:\SBTV Commander\users\users.ini"
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


UDPStartup() ;startet den UDP-Service
$aSocket = UDPBind($g_IP, $serverPort) ; Öffnet einen Socket mit der IP $g_IP und dem Port 65432
; $aSocket ist genauso aufgebaut wie das Array von UDPOpen()
;	$aSocket[1]: real socket
;	$aSocket[2]: IP des Servers
;	$aSocket[3]: Port des Servers
ConsoleWrite("Starting UDP Server..." & @CRLF)
ConsoleWrite("Current Port : " & $serverPort & @CRLF)

;------------------------------------------------------
;-----------------Abfrage des UDP----------------------
;------------------------------------------------------


If @error Then
	MsgBox(0, "", "ERROR: Could not start UDP Service")
	Exit
EndIf

;------------------------------------------------------
;-------------UDP Abfragen bearbeiten------------------
;------------------------------------------------------

ConsoleWrite("Server is ready to use" & @CRLF & @CRLF & @CRLF)
While 1 ;Entlosschleife

	$aData = UDPRecv($aSocket, 64, 2) ;empfängt Daten von einem Client
	;durch das Flag 2 wird folgendes Array ausgegeben:
	;	$aData[0]: data
	;	$aData[1]: IP des Clients
	;	$aData[2]: Port des Clients
	if $aData <> "" Then
		$splitString = StringSplit($aData[0], " ")
		ConsoleWrite("Intialising new connection" & @CRLF)
		Global $aClientArray[4] = [$aSocket[0], $aSocket[1], $aData[1], $aData[2]]
		if $splitString[0] > 1 Then
			_arrayRequest($aData)
		Else
			_normalRequest($aData)
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

func _normalRequest()

	Switch $aData[0]
		case "version"
			ConsoleWrite("Requested new Version " & @CRLF & "Send new version" & @CRLF & @CRLF)
			UDPSend($aClientArray, $version)

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

func _arrayRequest()

	Select
		case $splitString[1] = "login"

			; Return values .: 0 = Fehler
			;				   1 = Login erfolgreich
			;				   2 = neues Passwort wird benötigt

			$username = $splitString[2]
			$passwordCrypted = $splitString[3]
			$readPassCrypted = IniRead($userini, "users",$username,"err")

			if $readPassCrypted == "err" Then
				UDPSend($aClientArray, "0")
			ElseIf $readPassCrypted == "new" Then
				UDPSend($aClientArray, "2")
			EndIf

			if $readPassCrypted == $passwordCrypted Then
				UDPSend($aClientArray, "1")
			Else
				UDPSend($aClientArray, "0")
			EndIf

	EndSwitch

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

	UDPShutdown()
	Exit

EndFunc