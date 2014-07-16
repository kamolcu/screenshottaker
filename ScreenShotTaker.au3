#Region ;**** Directives created by AutoIt3Wrapper_GUI ****
#AutoIt3Wrapper_Icon=icon.ico
#AutoIt3Wrapper_Outfile=ScreenShotTaker.exe
#AutoIt3Wrapper_Res_Comment=ScreenShotTaker.exe by kamolcu@gmail.com
#AutoIt3Wrapper_Res_Description=ScreenShotTaker.exe by kamolcu@gmail.com
#AutoIt3Wrapper_Res_Fileversion=0.10.0.5
#AutoIt3Wrapper_Res_Fileversion_AutoIncrement=y
#AutoIt3Wrapper_Res_LegalCopyright=2014 kamolcu@gmail.com dee-por.com
#AutoIt3Wrapper_Res_Language=1033
#AutoIt3Wrapper_Run_Tidy=y
#EndRegion ;**** Directives created by AutoIt3Wrapper_GUI ****
; ----------------------------------------------------------------------------
; Screen Shot Taker program
;
; $Workfile :   ScreenShotTaker.au3
;
; Author    :	Kamol C.
;
; Revision  :   10
;
; Modtime   :	02:13 PM 07/16/2014 (Wednesday)
;
; Usage		: Run this program without argument will take the screenshot every 15 mins
;				  Run this program with single argument to specify period of taking screenshot (mins)
;
;
; Note		: Minimun period is 5 seconds
; ----------------------------------------------------------------------------
; History:
; Rev 3: update output file name to include computer name as prefix.
; Rev 4: add feature to capture active window only (not capture whole desktop area) with flag active_win_capture
;            add feature put the printed alt+screen to clipboard with flag $add_to_clipboard
; Rev 5: not to capture cursor
;            add feature to press F10 then open the output folder
; Rev 6: add auto open mspaint after take screenshot (auto_mspaint)
; Rev 7: remove {ESC} key to exit program, use icon at right down cornor instead
;           add feature to change shot key and opendir key between F3-F10
; Rev 8: Add destination path configuraion
;
; Rev9: Add key to capture screen when use Ctrl+LeftClick and add tray icon notification
; Rev10: Add key to capture screen when use Alt+LeftClick and refactor code
; ----------------------------------------------------------------------------
; Include part
; ----------------------------------------------------------------------------
;#include-once
;#NoTrayIcon
#include <ScreenCapture.au3>
#include <Misc.au3>
#include <TrayConstants.au3>

$g_szVersion = "_ScreenShotTaker_"
If WinExists($g_szVersion) Then Exit ; It's already running
AutoItWinSetTitle($g_szVersion)

;~ HotKeySet("{ESC}", "MyExit")
;~ Func MyExit()
;~     Exit 0
;~ EndFunc
Func CaptureScreenForCorrectKey($ScreenShotFolder, $active_win_flag, $clipFlag, $openmsFlag)
	$output = $ScreenShotFolder & "\" & @ComputerName & "_" & @YEAR & @MON & @MDAY & @HOUR & @MIN & @SEC & ".png"
	If $active_win_flag Then
		$size = WinGetPos("[active]")
		$left = $size[0]
		$top = $size[1]
		$right = $left + $size[2]
		$bottom = $top + $size[3]
		If Not FileExists($ScreenShotFolder) Then
			DirCreate($ScreenShotFolder)
		EndIf
		_ScreenCapture_Capture($output, $left, $top, $right, $bottom, False)
	Else
		If Not FileExists($ScreenShotFolder) Then
			DirCreate($ScreenShotFolder)
		EndIf
		_ScreenCapture_Capture($output, 0, 0, -1, -1, False)
	EndIf
	TrayTip("ScreenShot Taker", $output & " was created.", 0, $TIP_ICONASTERISK)
	If $clipFlag Then
		Send("{ALTDOWN}{PRINTSCREEN}{ALTUP}")
	EndIf

	If $openmsFlag Then
		Run(@SystemDir & "\mspaint.exe " & """" & $output & """")
	EndIf
EndFunc   ;==>CaptureScreenForCorrectKey

Func ConvertKeyCode($keyInput)
	Switch StringUpper($keyInput)
		Case "F3"
			Return "72"
		Case "F4"
			Return "73"
		Case "F5"
			Return "74"
		Case "F6"
			Return "75"
		Case "F7"
			Return "76"
		Case "F8"
			Return "77"
		Case "F9"
			Return "78"
		Case "F10"
			Return "79"
		Case "Ctrl+LeftClick"
			Return "Ctrl+LeftClick"
		Case "Alt+LeftClick"
			Return "Alt+LeftClick"
		Case Else
			Return ""
	EndSwitch
EndFunc   ;==>ConvertKeyCode
; ----------------------------------------------------------------------------
; Set up our defaults
; ----------------------------------------------------------------------------
AutoItSetOption("SendKeyDelay", 50)

; ----------------------------------------------------------------------------
; Script Start
; ----------------------------------------------------------------------------
$default_min_period = 5
; Read INI first
$repeat_enable = IniRead(@ScriptDir & "\configure.ini", "main", "repeat_enable", 0)
$active_win_capture = IniRead(@ScriptDir & "\configure.ini", "main", "active_win_capture", 0)
$add_to_clipboard = IniRead(@ScriptDir & "\configure.ini", "main", "add_to_clipboard", 0)
$open_mspaint = IniRead(@ScriptDir & "\configure.ini", "main", "auto_mspaint", 0)
$shotkey = IniRead(@ScriptDir & "\configure.ini", "main", "shotkey", "")
$opendirkey = IniRead(@ScriptDir & "\configure.ini", "main", "opendirkey", "")

$shotkey = ConvertKeyCode($shotkey)
$opendirkey = ConvertKeyCode($opendirkey)

If $shotkey = "" Then
	$shotkey = 78 ;F9
EndIf

If $opendirkey = "" Then
	$opendirkey = 79 ;F10
EndIf

; ConsoleWrite("$active_win_capture: " & $active_win_capture)
; ConsoleWrite($repeat_enable)
If $repeat_enable <> 0 Then
	$loopflag = True
	ConsoleWrite("loop flag: " & $loopflag & @CRLF)
Else
	$loopflag = False
	ConsoleWrite("loop flag: " & $loopflag & @CRLF)
EndIf

If $active_win_capture <> 0 Then
	$active_win_flag = True
	ConsoleWrite("$active_win_flag: " & $active_win_flag & @CRLF)
Else
	$active_win_flag = False
	ConsoleWrite("$active_win_flag: " & $active_win_flag & @CRLF)
EndIf

If $add_to_clipboard <> 0 Then
	$clipFlag = True
	ConsoleWrite("$clipFlag: " & $clipFlag & @CRLF)
Else
	$clipFlag = False
	ConsoleWrite("$clipFlag: " & $clipFlag & @CRLF)
EndIf

If $open_mspaint <> 0 Then
	$openmsFlag = True
	ConsoleWrite("$openmsFlag: " & $openmsFlag & @CRLF)
Else
	$openmsFlag = False
	ConsoleWrite("$openmsFlag: " & $openmsFlag & @CRLF)
EndIf

$repeat_period = IniRead(@ScriptDir & "\configure.ini", "main", "repeat_period", 5)
ConsoleWrite("$repeat_period: " & $repeat_period & @CRLF)
If Not IsNumber($repeat_period) Or $repeat_period <= 0 Then
	$repeat_period = $default_min_period
EndIf

$ScreenShotFolder = IniRead(@ScriptDir & "\configure.ini", "main", "desdir", "D:\ScreenShotTakerOutput")
DirCreate($ScreenShotFolder)
If Not FileExists($ScreenShotFolder) Then
	MsgBox(4096 + 16, "", "Failed to create directory " & $ScreenShotFolder & ". The program will exit.")
	Exit (1)
EndIf

If $loopflag Then
	While 1
		Sleep($repeat_period * 1000)
		ConsoleWrite(@ComputerName & "_" & @YEAR & @MON & @MDAY & @HOUR & @MIN & @SEC & ".png")
		If Not FileExists($ScreenShotFolder) Then
			DirCreate($ScreenShotFolder)
		EndIf
		_ScreenCapture_Capture($ScreenShotFolder & "\" & @ComputerName & "_" & @YEAR & @MON & @MDAY & @HOUR & @MIN & @SEC & ".png", 0, 0, -1, -1, False)
	WEnd
Else
	ConsoleWrite("No loop, waiting for trigger." & @CRLF)
	Dim $dll
	$dll = DllOpen("user32.dll")

	While 1
		$shotkey = IniRead(@ScriptDir & "\configure.ini", "main", "shotkey", "")
		$opendirkey = IniRead(@ScriptDir & "\configure.ini", "main", "opendirkey", "")
		$shotkey = ConvertKeyCode($shotkey)
		$opendirkey = ConvertKeyCode($opendirkey)
		$ScreenShotFolder = IniRead(@ScriptDir & "\configure.ini", "main", "desdir", "D:\ScreenShotTakerOutput")
		Sleep(50)
		If _IsPressed("11", $dll) Then
			If $shotkey = "Ctrl+LeftClick" And _IsPressed("01", $dll) Then
				CaptureScreenForCorrectKey($ScreenShotFolder, $active_win_flag, $clipFlag, $openmsFlag)
			EndIf
		ElseIf _IsPressed("12", $dll) Then
			If $shotkey = "Alt+LeftClick" And _IsPressed("01", $dll) Then
				CaptureScreenForCorrectKey($ScreenShotFolder, $active_win_flag, $clipFlag, $openmsFlag)
			EndIf
		ElseIf _IsPressed($shotkey, $dll) Then
			CaptureScreenForCorrectKey($ScreenShotFolder, $active_win_flag, $clipFlag, $openmsFlag)
		ElseIf _IsPressed($opendirkey, $dll) Then
			If Not FileExists($ScreenShotFolder) Then
				DirCreate($ScreenShotFolder)
			EndIf
			ConsoleWrite($opendirkey & " key pressed. Try to open " & $ScreenShotFolder & @CRLF)
			$sCommand = "start " & """" & """" & " " & """" & $ScreenShotFolder & """"
			ConsoleWrite($sCommand & @CRLF)
			Run(@ComSpec & " /c " & """" & $sCommand & """", "", @SW_HIDE)
		EndIf
	WEnd
EndIf

Exit 0

