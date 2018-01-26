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