;=================================================================================================================
; Compiler Settings
;=================================================================================================================


#RequireAdmin
;#pragma compile(Console, true)
#pragma compile(UPX, False)
#pragma compile(Console, true)
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
#include <MsgBoxConstants.au3>

;=================================================================================================================


;=================================================================================================================
; Autor: Florian Krismer
; Version: 0.1
;=================================================================================================================


;=================================================================================================================
; Variablen
;=================================================================================================================


;=================================================================================================================




; #FUNCTION# ;====================================================================================================
;
; Name...........:
; Beschreibung ...:
; Syntax.........:
; Parameters ....: -
; Return values .: -
; Autor ........: Florian Krismer
;
; ;================================================================================================================

ConsoleWrite("Checking server..." & @CRLF)

if FileExists("C:\SBTV Commander") Then
	ConsoleWrite("Found old installation. Deleting..." & @CRLF)
	DirRemove("C:\SBTV Commander",1)
	if @error Then
		ConsoleWrite("ERROR while deleting! Please close all programs in this directory!")
		sleep(10000)
		Exit
	Else
		ConsoleWrite("Old installation cleared!" & @CRLF)
	EndIf
Else
	ConsoleWrite("No old installation found!" & @CRLF)
EndIf

ConsoleWrite("Creating directories..." & @CRLF)
DirCreate("C:\SBTV Commander")
if @error Then
	ConsoleWrite("ERROR while creating main dir!")
	sleep(10000)
	Exit
EndIf
DirCreate("C:\SBTV Commander\connections")
_FileCreate("C:\SBTV Commander\connections\currentConnections.ini")

DirCreate("C:\SBTV Commander\requests")
_FileCreate("C:\SBTV Commander\requests\Requests.ini")
DirCreate("C:\SBTV Commander\requests\bug")
DirCreate("C:\SBTV Commander\requests\feature")

DirCreate("C:\SBTV Commander\logs")
_FileCreate("C:\SBTV Commander\logs\main.log")

DirCreate("C:\SBTV Commander\Version")
_FileCreate("C:\SBTV Commander\Version\version.ini")

DirCreate("C:\SBTV Commander\users")
_FileCreate("C:\SBTV Commander\users\users.ini")

DirCreate("C:\SBTV Commander\release")
DirCreate("C:\SBTV Commander\release\ftp")
DirCreate("C:\SBTV Commander\release\newVersionServer")
DirCreate("C:\SBTV Commander\release\newVersionZipped")
DirCreate("C:\SBTV Commander\release\udp")
DirCreate("C:\SBTV Commander\release\udp\UDPServer")

ConsoleWrite("Finished!" & @CRLF)
Sleep(5000)
Exit
;==================================================================================================================



