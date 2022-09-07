; <<Copyright (C)  2022 thinkRand - Abel Granados>>
; <<https://es.fiverr.com/abelgranados>>

; This file is part of free osrs mining scrip by thinkRand
; This program is free software: you can redistribute it and/or modify it under the terms of the 
; GNU General Public License as published by the Free Software Foundation, either version 3 of 
; the License, or (at your option) any later version.

; This program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the 
; implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU General Public License 
; for more details.

; You should have received a copy of the GNU General Public License along with this program. If not, see 
; <https://www.gnu.org/licenses/>.




#include core/guiInfo.ahk

createGuiLicence(){
	
	if FileExist("docs/copying.txt"){
		FileRead, FileContents, docs/copying.txt
		if (ErrorLevel){
			MsgBox, 4 Error. The program will finish.
			Exitapp
		}
	}else{
		MsgBox, The copying.txt file does not exist. The program will finish.
		Exitapp
	}

	Gui, licence:New, -Resize +MinimizeBox -MaximizeBox +HwndGuiHwnd , Mining_v1.3 licence
	Gui, licence:Add, edit, readOnly w600 h400, %FileContents% . `n`n
	Gui, licence:Add, Button, w64 h32 xm gbAccept , Accept
	Gui, licence:Show 

	return
	
	; Button that is on the licence window, when it is pressed it has to open the Info window
	bAccept:
		Gui, licence:Destroy
		FileDelete, docs/config.ini
		FileAppend , true, docs/config.ini, 
		
		if (ErrorLevel) {
			MsgBox, Error. The program will finish.
			Exitapp
		}

		createGuiInfo("docs/info.txt")
	return

	licenceGuiClose:
		Exitapp
	return

}

