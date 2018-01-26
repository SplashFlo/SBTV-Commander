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

	UDPSend($udpSocket, $UDPMessage)

	if $waitForAnswer == true Then
		Do
		Global $UDPReceivedData = UDPRecv($udpSocket, 128) ;er wartet auf eine Antwort des Servers
		$loopCounter = $loopCounter + 1
		if $loopCounter >= 20 Then
			if WinExists("Steam Punk Loading") then
				WinKill("Steam Punk Loading")
			EndIf
			errormessage(002,true)
		EndIf

		sleep(20) ;timeout für wartezeit vom server

		Until $UDPReceivedData <> ""
			Global $waitForAnswer = 0
			UDPShutdown()
			Return $UDPReceivedData
	EndIf

EndFunc


;==================================================================================================================



