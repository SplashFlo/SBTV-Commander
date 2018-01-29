#RequireAdmin

#include <Zip.au3>
#include <FTPEx.au3>
#include <MsgBoxConstants.au3>

ProgressOn("", "", "", -1, -1, 18)


ProgressSet(0,"Installing software...")

$sSavePath = @DesktopDir &"\SBTV Commander.zip"


Local $sServer = '80.82.222.3'
Local $sUsername = 'admin'
Local $sPass = '!VSAdmin01!'

Local $hOpen = _FTP_Open('MyFTP Control')
Local $hConn = _FTP_Connect($hOpen, $sServer, $sUsername, $sPass,1,21)
If @error Then
    MsgBox($MB_SYSTEMMODAL, '_FTP_Connect', 'ERROR=' & @error)
Else
	$ftpdownload = _FTP_FileGet($hConn, "/home/admin/SBTV Commander/release/ftp/SBTV Commander.zip", $sSavePath)
EndIf
Local $iFtpc = _FTP_Close($hConn)
Local $iFtpo = _FTP_Close($hOpen)
ProgressSet(30,"Installing software...")

if $ftpdownload == 0 Then
	MsgBox(0, "ERROR", "ERROR while downloading the new Version!")
	Exit
EndIf
Sleep(500)
ProgressSet(40,"Installing software...")
$unzip = _Zip_UnzipAll($sSavePath,@DesktopDir,0)
if $unzip == 0 Then
	MsgBox(0, "ERROR", "ERROR while unzipping the software")
	Exit
EndIf
sleep(2000)
ProgressSet(60,"Installing software...")
Run(@DesktopDir & "\SBTV Commander\installer.exe")
sleep(1000)
ProgressSet(90,"Installing software...")
if WinExists("Line Progressbar") Then
	WinWaitClose("Line Progressbar")
	sleep(500)
	$delete = DirRemove(@DesktopDir & "\SBTV Commander",1)
	if $delete == 0 Then
		MsgBox(0, "error", "error while deleting the sbtv commander directory on your desktop")
	EndIf
	$zipdelete = FileDelete($sSavePath)
	if $zipdelete == 0 Then
		MsgBox(0, "error", "error while deleting the sbtv commander zip on your desktop")
	EndIf
Else
	MsgBox(0, "Error", "Error while installing")
	Exit
EndIf
ProgressSet(100,"Software installed")