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


#include <Date.au3>
#include <Process.au3>
#RequireAdmin

;------------------------------------------------------
;--------------------Variablen-------------------------
;------------------------------------------------------

Global $versioningFile = "C:\SBTV Commander\Version\version.ini"
Global $newDate = ""
Global $run = False
;------------------------------------------------------
;------------------------------------------------------
;------------------------------------------------------

_startup()
func _startup()
	while $run = false
		$secWait = _DateDiffSec()
		if $secWait == "error" Then
			consoleWrite("Sleeping: 10 sec and then get new version" & @CRLF)
			sleep(10000)
			$secWait = _DateDiffSec()
		Else
			Switch $secWait
				case -9999999999999999 to 0
					_deleteOldVersion()
				case 1 to 3
					Sleep(1000)
				case 4 to 6
					sleep(3000)
				case 7 to 10
					sleep(6000)
				case 11 to 20
					Sleep(5000)
				case 21 to 30
					sleep(10000)
				case 31 to 50
					Sleep(20000)
				case 51 to 60
				case 61 to 100
					sleep(60000)
				case 101 to 500
					Sleep(100000)
				case 501 to 1000
					sleep(480000)
				case 1001 to 5000
					sleep(1500000)
				case 5000 to 20000
					sleep(5520000)
				case 20001 to 50000
					Sleep(19800000)
				case Else
					Sleep(48600000)
			EndSwitch
		EndIf
	WEnd
EndFunc

func _deleteOldVersion()
	ConsoleWrite("deleting old version..." & @CRLF & @CRLF & @CRLF)
	$deleteOldVersion = FileDelete("C:\SBTV Commander\release\ftp\SBTV Commander.zip")
	ConsoleWrite("deleting old ZIP..." & @CRLF)
	if $deleteOldVersion == 0 Then
		ConsoleWrite("error, could not delete the old version! Trying again in 60 sec" & @CRLF & @CRLF)
		sleep(60000)
		_startup()
	EndIf
	ConsoleWrite("Old ZIP successfully deleted" & @CRLF & @CRLF)

	ConsoleWrite("killing all running UDPServers..." & @CRLF)
	if WinExists("C:\SBTV Commander\release\udp\UDPServer\UDPMainserver.exe") Then
		WinKill("C:\SBTV Commander\release\udp\UDPServer\UDPMainserver.exe")
	EndIf

	if WinExists("C:\SBTV Commander\release\udp\UDPServer\ConnectionBuilder.exe") Then
		WinKill("C:\SBTV Commander\release\udp\UDPServer\ConnectionBuilder.exe")
	EndIf
	ConsoleWrite("All UDPServer were killed" & @CRLF & @CRLF)

	ConsoleWrite("deleting old UDP Servers..." & @CRLF)
	$deleteOldVersion = DirRemove("C:\SBTV Commander\release\udp\UDPServer",1)
	if $deleteOldVersion == 0 Then
		ConsoleWrite("error, could not delete the old UDP Servers! Trying again in 60 sec" & @CRLF & @CRLF)
		sleep(60000)
		_startup()
	EndIf
	ConsoleWrite("old UDPServers deleted" & @CRLF & @CRLF)
	_installNewVersion()
EndFunc

func _installNewVersion()
	ConsoleWrite("installing new version..." & @CRLF & @CRLF & @CRLF)
	ConsoleWrite("moving new zip..." & @CRLF)
	$FileMove = FileMove("C:\SBTV Commander\release\newVersionZipped\SBTV Commander.zip", "C:\SBTV Commander\release\ftp\SBTV Commander.zip",1+8)
	if $FileMove == 0 Then
		If FileExists("C:\SBTV Commander\release\ftp\SBTV Commander.zip") Then

		Else
			ConsoleWrite("error while moving the new zip trying again in 10 seconds" & @CRLF & @CRLF)
			sleep(10000)
			_installNewVersion()
		EndIf
	EndIf
	ConsoleWrite("new zip was moved" & @CRLF & @CRLF)
	ConsoleWrite("moving new UDP server..." & @CRLF)
	$DirMove = DirMove("C:\SBTV Commander\release\newVersionServer\UDPServer", "C:\SBTV Commander\release\udp\UDPServer",1)
	if $DirMove == 0 Then
		if FileExists("C:\SBTV Commander\release\udp\UDPServer\ConnectionBuilder.exe") Then

		Else
			ConsoleWrite("error while moving the new UDPServer trying again in 10 seconds" & @CRLF & @CRLF)
			sleep(10000)
			_installNewVersion()
		EndIf
	EndIf
	ConsoleWrite("UDP server was moved" & @CRLF & @CRLF)
	ConsoleWrite("Starting new UDP servers..." & @CRLF)
	ShellExecute("C:\SBTV Commander\release\udp\UDPServer\ConnectionBuilder.exe")
	Sleep(3000)
	if WinExists("C:\SBTV Commander\release\udp\UDPServer\ConnectionBuilder.exe") Then
		ConsoleWrite("ConnectionBulder started and ready" & @CRLF)
	Else
		ConsoleWrite("error starting the ConnectionBuilder trying again in 10 seconds" & @CRLF & @CRLF)
		sleep(10000)
		_installNewVersion()
	EndIf

	ConsoleWrite("Adding new Update Date to Versioningfile" & @CRLF)
	$newUpdate = _DateAdd("D", "7", _NowCalc())
	IniWrite($versioningFile, "Version", "newVersionDate", $newUpdate)
	if @error Then
		ConsoleWrite("Error while writing new Version date" & @CRLF)
	Else
		ConsoleWrite("Successfully added new Version Date" & @CRLF)
	EndIf
	ConsoleWrite("servers successfully started" & @CRLF & @CRLF)
	IniWrite($versioningFile, "Version", "current", $newVersion)
	sleep(3000)
	_RunDos("cls")
	ConsoleWrite("New Version successfully installed" & @CRLF & @CRLF)
	_startup()
EndFunc

; #FUNCTION# ===============================================================================
;
; Name...........: _DateDiffSec()
; Description ...: Checking the New Version and the new Date
; AutoIt Version : V3.3.6.0
; Syntax.........: _DateDiffSec()
; Parameters ....: -
;
; Return values .: Success - Returns : The new Version release in Seconds
;                  Failure - Returns : error
;
; Author ........: SplashFlo
;
; ==========================================================================================

Func _DateDiffSec()
	_RunDos("cls")
	Global $newDate = IniRead($versioningFile, "Version", "newVersionDate", 0)
	if $newDate == 0 Then
		ConsoleWrite("error, could not get new Version Date!" & @CRLF & @CRLF & @CRLF)
		Return "error"

	Else
		ConsoleWrite("New Version Date: " & $newDate & @CRLF)
		ConsoleWrite("Current Date: " & _NowCalc() & @CRLF)
		Global $newVersion = IniRead($versioningFile, "Version", "newVersion", 0)
		if $newVersion == 0 Then
			ConsoleWrite("error, could not get new Version!" & @CRLF & @CRLF)
			Return "error"

		Else
			ConsoleWrite("New Version: " & $newVersion & @CRLF)
			$oldVersion = IniRead($versioningFile, "Version", "current", $newVersion)
			if $oldVersion == $newVersion then

				ConsoleWrite("Newest version already installed. Checking again in 10 min" & @CRLF & @CRLF & @CRLF)
				sleep(600000)
				_startup()
			EndIf
			$dateDiffSec = _DateDiff('s', _NowCalc(),$newDate)
			if FileExists("C:\SBTV Commander\release\newVersionZipped\SBTV Commander.zip") Then

				if FileExists("C:\SBTV Commander\release\newVersionServer\UDPServer\ConnectionBuilder.exe") Then
					Return $dateDiffSec
				Else
					ConsoleWrite("error, could not get new Version UDP Server!" & @CRLF & @CRLF)
					return "error"
				EndIf
			Else
				ConsoleWrite("error, could not get new Version ZIP!" & @CRLF & @CRLF)
				Return "error"
			EndIf

		EndIf
	EndIf
EndFunc

; ==========================================================================================
