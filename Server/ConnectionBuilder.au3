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

;=================================================================================================================

;=================================================================================================================
; Variablen
;=================================================================================================================

$login = 0
$loginStart = 0
$c1 = 0
$c2 = 0
$serverPort = 9898
$configFile = "C:\SBTV Commander\Version\version.ini"
$portsFile = "C:\SBTV Commander\connections\currentConnections.ini"
$versioningFile = "C:\SBTV Commander\Version\version.ini"
$version = IniRead($versioningFile, "Version", "current", "err")
$g_IP = IniRead($versioningFile, "IP", "ip", 0)
$SenData = 0
OnAutoItExitRegister("_exit") ;Falls das Script beendet wird, wird folgendes gesendet

;=================================================================================================================



;------------------------------------------------------
;-------------Starte UDP Server------------------------
;------------------------------------------------------


UDPStartup() ;startet den UDP-Service
$aSocket = UDPBind($g_IP, $serverPort) ; Öffnet einen Socket mit der IP $g_IP und dem Port 65432
; $aSocket ist genauso aufgebaut wie das Array von UDPOpen()
;	$aSocket[1]: real socket
;	$aSocket[2]: IP des Servers
;	$aSocket[3]: Port des Servers
ConsoleWrite("Starting UDP Server..." & @CRLF)
ConsoleWrite("Current Version: " & $version & @CRLF)
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
	If $aData <> "" Then
		ConsoleWrite("Intialising new connection" & @CRLF)
		Global $aClientArray[4] = [$aSocket[0], $aSocket[1], $aData[1], $aData[2]]
		if $aData[0] = "version" Then
			$version = IniRead($configFile,"Version", "current","err")
			ConsoleWrite("Sending new version..." & @CRLF)
			UDPSend($aClientArray,$version)
		ElseIf $aData[0] > 1999 And $aData[0] < 9999 Then
				ConsoleWrite("Opening new Connection for port: " & $aData[0] & @CRLF)
				$portTest = IniRead($portsFile, "Ports", $aData[0], "0")
				If $portTest <> 0 Then
					ConsoleWrite("ERROR: Port does already exist" & @CRLF)
					UDPSend($aClientArray, "0")
				Else
					IniWrite($portsFile, "Ports", $aData[0], $aData[1])
					ConsoleWrite("Starting new Session on port: " & $aData[0] & @CRLF)
					$startnew = Run(@ScriptDir & "\UDPMainServer.exe " & $aData[0])
					If $startnew == 0 Then
						ConsoleWrite("!!!ERROR: Could start the UDPMainServer.exe!!!" & @CRLF)
						UDPSend($aClientArray, "0")
					Else
						$loop = 1
						while $loop = 1
							$test = IniRead("C:\SBTV Commander\connections\currentConnections.ini", "Running", $aData[0],"no")
							if $test == "yes" Then
								ConsoleWrite("Server successfully started" & @CRLF)
								UDPSend($aClientArray, "1")
								$loop = 0
							EndIf
							sleep(20)
						WEnd
					EndIf
				EndIf
			Else
				ConsoleWrite("ERROR: Unknown funcion name")
				UDPSend($aClientArray, "0")
			EndIf
			ConsoleWrite("End of connection." & @CRLF & @CRLF)
		EndIf
	Sleep(20)
WEnd



Func _exit()
	UDPShutdown()
	Exit
EndFunc   ;==>_exit

