#pragma compile (Icon,.\icons\sbtv.ico)
#pragma compile(UPX, False)
#pragma compile(FileDescription, Ein Clanverwaltungsprogramm)
#pragma compile(ProductName, SBTV Commander)
#pragma compile(ProductVersion, 0.1)
#pragma compile(FileVersion, 0.1) ; The last parameter is optional.
#pragma compile(LegalCopyright, © SplashBirdTV)
;#pragma compile(LegalTrademarks, '"Trademark something1, and some text in "quotes" etc...')
#pragma compile(CompanyName, 'SplashBirdTV')

#RequireAdmin

#include <GDIPlus.au3>
#include <GUIConstantsEx.au3>
#include <WindowsConstants.au3>

Global $run = false
Global $runcopy = true

if FileExists(@ScriptDir & "\cfg\SBTV Commander.exe") Then

Else
	MsgBox($MB_ICONERROR, "Fehler", "Die Installation ist beschädigt. Bitte laden Sie das Programm erneut herunter")
	Exit
EndIf

if IsAdmin() Then

Else
	MsgBox(0, "Info", "Bitte starten Sie dieses Programm als Administrator")
EndIf

if @ScriptDir = @DesktopDir Then
	MsgBox($MB_ICONERROR, "ERROR", "Bitte führen Sie das Script NICHT direkt auf dem Desktop aus!")
	Exit
EndIf

if @ScriptDir = "C:\users\" & @UserName & "\downloads" Then
	MsgBox($MB_ICONERROR, "ERROR", "Bitte führen Sie das Script NICHT direkt im Downloadsordner aus!")
	Exit
EndIf

_GDIPlus_Startup()
Global Const $STM_SETIMAGE = 0x0172; $IMAGE_BITMAP = 0
Global $iW = 600, $iH = 250
Global Const $hGUI = GUICreate("Line Progressbar", $iW, $iH, -1, -1, $WS_POPUPWINDOW, $WS_EX_TOPMOST)
Global Const $iPic = GUICtrlCreatePic("", 0, 0, $iW, $iH)
GUICtrlSetState(-1, $GUI_DISABLE)
GUISetState()

Global $hHBmp_BG, $hB, $iPerc = 0, $iSleep = 30, $s = 0, $sFont = "Segoe Script"
If @OSBuild < 6000 Then $sFont = "Arial Black"
GUIRegisterMsg($WM_TIMER, "PlayAnim")
DllCall("user32.dll", "int", "SetTimer", "hwnd", $hGUI, "int", 0, "int", $iSleep, "int", 0)


Do
	Switch GUIGetMsg()
		Case $GUI_EVENT_CLOSE
			GUIRegisterMsg($WM_TIMER, "")
			_WinAPI_DeleteObject($hHBmp_BG)
			_GDIPlus_Shutdown()
			GUIDelete()
			Exit
	EndSwitch
Until False

Func PlayAnim()
	$hHBmp_BG = _GDIPlus_LineProgressbar($iPerc, $iW, $iH, "Installing Software: ", 0xF02187E7, $sFont)
	$hB = GUICtrlSendMsg($iPic, $STM_SETIMAGE, $IMAGE_BITMAP, $hHBmp_BG)
	If $hB Then _WinAPI_DeleteObject($hB)
	_WinAPI_DeleteObject($hHBmp_BG)
	$iPerc += 0.025 + Abs(Cos($s / 4))
	$s -= 0.1
	if $iPerc < 10 Then
		while $run == false
			if FileExists("C:\Program Files\SBTVPrograms\Commander") Then
				$deleteDirectory = DirRemove("C:\Program Files\SBTVPrograms\Commander",1)
				if $deleteDirectory == 0 Then
					GUISetState(@SW_HIDE)
					MsgBox($MB_ICONERROR, "Error", "Fehler: Bitte schließen sie den alten SBTV Commander und drücken Sie ok!")
					GUISetState(@SW_SHOW)
				Else
					$run = true
				EndIf
			Else
				Global $run = true
			EndIf

		WEnd
	EndIf

	if $iPerc > 50 AND $iPerc < 52 Then
		while $runcopy == true
			$copy = DirCopy(@ScriptDir & "\cfg", "C:\Program Files\SBTVPrograms\Commander\",1)

			if $copy == 0 Then
				_GDIPlus_Shutdown()
				MsgBox($MB_ICONERROR, "Fehler", "Das Programm konnte nicht installiert werden. Bitte versuchen sie es erneut!")
				Exit
			Else
				$shortcut = FileCreateShortcut("C:\Program Files\SBTVPrograms\Commander\SBTV Commander.exe",@DesktopDir & "\SBTV Commander.lnk")
				if $shortcut == 0 Then
					_GDIPlus_Shutdown()
					MsgBox(0, $MB_ICONERROR, "Fehler", "Das Programm wurde zwar richtig installiert, aber es konnte keine Verknüpfung auf dem Desktop erstellt werden!")
				EndIf
			$filemove = FileMove("C:\Program Files\SBTVPrograms\Commander\includings\Installer.exe", "C:\Program Files\SBTVPrograms\installer\Installer.exe",1+8)
			if $filemove == 0 Then
				If FileExists("C:\Program Files\SBTVPrograms\installer\Installer.exe") Then

				Else
				_GDIPlus_Shutdown()
				MsgBox(0, "error", "error while moving installer")
				EndIf
			EndIf
			EndIf
			Global $runcopy = false
		WEnd
	EndIf
	If $iPerc >= 100 Then
		_GDIPlus_Shutdown()
		DirRemove(@ScriptDir & "\cfg",1)
		Run("C:\Program Files\SBTVPrograms\Commander\SBTV Commander.exe")
		GUIDelete()
		exit(Run(@SystemDir & '\cmd.exe /C del /F /Q "' & @ScriptDir, @TempDir, @SW_HIDE))
	EndIf
EndFunc   ;==>PlayAnim


Func _GDIPlus_LineProgressbar($fProgress, $iW, $iH, $sText = "Loading: ", $iColorLineProgressbar = 0xF02187E7, $sFont = "Segoe Script", $bHBitmap = True)
	Local $aColorPattern[4][4] = [[0xFF2A2A2A, 0xFF131313, 0xFF1A1A1A, 0xFF131313], _
								  [0xFF1F1F1F, 0xFF1A1A1A, 0xFF131313, 0xFF1A1A1A], _
								  [0xFF1A1A1A, 0xFF131313, 0xFF2A2A2A, 0xFF131313], _
								  [0xFF131313, 0xFF1A1A1A, 0xFF1F1F1F, 0xFF1A1A1A]]
	Local Const $hBmp_texture = _GDIPlus_BitmapCreateFromScan0(4, 4)
	Local $iX, $iY
	For $iY = 0 To 3
		For $iX = 0 To 3
			_GDIPlus_BitmapSetPixel($hBmp_texture, $iX, $iY, $aColorPattern[$iY][$iX]) ;generate texture
		Next
	Next
	Local Const $hBrush_Texture = _GDIPlus_TextureCreate($hBmp_texture)
	_GDIPlus_BitmapDispose($hBmp_texture)
	Local Const $hBitmap  = _GDIPlus_BitmapCreateFromScan0($iW, $iH)
	Local Const $hGfx = _GDIPlus_ImageGetGraphicsContext($hBitmap)
	_GDIPlus_GraphicsSetPixelOffsetMode($hGfx, $GDIP_PIXELOFFSETMODE_HIGHQUALITY)

;~ 	_GDIPlus_GraphicsSetSmoothingMode($hGfx, 5) ;smoothing doesn't look good for light effect
	_GDIPlus_GraphicsFillRect($hGfx, 0, 0, $iW, $iH, $hBrush_Texture)
	Local Const $iW2 = $iW / 2, $iH2 = $iH / 2, $iDY = 7, $hBrush_Bg = _GDIPlus_BrushCreateSolid(0x80000000), _
				$hBrush_Line = _GDIPlus_BrushCreateSolid($iColorLineProgressbar), _
				$hBrush_Light = _GDIPlus_LineBrushCreate(($iW * $fProgress / 100 + 2) / 2, 0, ($iW * $fProgress / 100 + 2) / 2, $iDY, 0x68000000 + BitAND($iColorLineProgressbar, 0x00A0A0F0), 0x10000000, 3)
	_GDIPlus_LineBrushSetLinearBlend($hBrush_Light, 0, 1)
	_GDIPlus_LineBrushSetGammaCorrection($hBrush_Light)
	_GDIPlus_GraphicsFillRect($hGfx, 0, $iH2 - 1, $iW, 3, $hBrush_Bg)

	Local Const $hBitmap2  = _GDIPlus_BitmapCreateFromScan0($iW, $iDY * 2)
	Local Const $hGfx2 = _GDIPlus_ImageGetGraphicsContext($hBitmap2)
	_GDIPlus_GraphicsSetPixelOffsetMode($hGfx2, $GDIP_PIXELOFFSETMODE_HIGHQUALITY)

	Local $aPoints[6][2]
	$aPoints[0][0] = 5
    $aPoints[1][0] = 0
    $aPoints[1][1] = 0
    $aPoints[2][0] = $iW * $fProgress / 100 - 2
    $aPoints[2][1] = $iDY - $iDY
    $aPoints[3][0] = $iW * $fProgress / 100 + 2
    $aPoints[3][1] = $iDY
	$aPoints[4][0] = $iW * $fProgress / 100 - 2
    $aPoints[4][1] = $iDY + $iDY
	$aPoints[5][0] = 0
    $aPoints[5][1] = $iDY + $iDY
	_GDIPlus_GraphicsFillPolygon($hGfx2, $aPoints, $hBrush_Light)
	_GDIPlus_GraphicsDrawImageRect($hGfx, $hBitmap2, 0, $iH2 - $iDY, $iW, 2 * $iDY)
	_GDIPlus_GraphicsFillRect($hGfx, 0, $iH2, $iW * $fProgress / 100, 1, $hBrush_Line)

	Local Const $hBitmap_Text = _GDIPlus_BitmapCreateFromScan0($iW, $iH2)
	Local Const $hGfx_Text = _GDIPlus_ImageGetGraphicsContext($hBitmap_Text)
	_GDIPlus_GraphicsSetSmoothingMode($hGfx_Text, 4)

	Local Const $hPath = _GDIPlus_PathCreate()
	Local Const $hFamily = _GDIPlus_FontFamilyCreate($sFont)
	Local Const $hFormat = _GDIPlus_StringFormatCreate()
	_GDIPlus_StringFormatSetAlign($hFormat, 1)
	Local Const $tLayout = _GDIPlus_RectFCreate(0, $iH / 8, $iW)
	Local Const $hBrush_Text = _GDIPlus_BrushCreateSolid(0xE0FFFFFF), $hPen_Text = _GDIPlus_PenCreate(0x80000000, 4)

	_GDIPlus_PathAddString($hPath, StringFormat($sText & " %02d%", $fProgress), $tLayout, $hFamily, 0, $iH / 10, $hFormat)
	_GDIPlus_GraphicsDrawPath($hGfx_Text, $hPath, $hPen_Text)
	_GDIPlus_GraphicsFillPath($hGfx_Text, $hPath, $hBrush_Text)
	_GDIPlus_GraphicsDrawImageRect($hGfx, $hBitmap_Text, 0, $iH2, $iW, $iH2)

	_GDIPlus_GraphicsDispose($hGfx_Text)
	_GDIPlus_BitmapDispose($hBitmap_Text)

	_GDIPlus_FontFamilyDispose($hFamily)
	_GDIPlus_StringFormatDispose($hFormat)
	_GDIPlus_PathDispose($hPath)
	_GDIPlus_BrushDispose($hBrush_Text)
	_GDIPlus_BrushDispose($hBrush_Line)
	_GDIPlus_BrushDispose($hBrush_Bg)
	_GDIPlus_BrushDispose($hBrush_Texture)
	_GDIPlus_BrushDispose($hBrush_Light)
	_GDIPlus_PenDispose($hPen_Text)
	_GDIPlus_GraphicsDispose($hGfx)
	_GDIPlus_GraphicsDispose($hGfx2)
	_GDIPlus_BitmapDispose($hBitmap2)
	If $bHBitmap Then
		Local $hHBITMAP = _GDIPlus_BitmapCreateHBITMAPFromBitmap($hBitmap)
		_GDIPlus_BitmapDispose($hBitmap)
		Return $hHBITMAP
	EndIf
	Return $hBitmap
EndFunc