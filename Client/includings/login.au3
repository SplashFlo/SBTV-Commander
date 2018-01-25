; Function: login ;=============================================================================================
;
; Name...........: login
; Beschreibung ...: Startet den loginvorgang
; Syntax.........: login($username,$password)
; Parameters ....: $username = Der Benutezrname, $password = das Passwort
; Return values .: 1 = ok, 0 = fehler
; Autor ........: SplashFlo
;
; ;================================================================================================================

func login($username,$password)

	if $username = "splashflo" Then
		$return = 1
	Else
		$return = 0
	EndIf

EndFunc