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
	Gui, licence:Add, edit, vEditlicence readOnly w600 h400, %FileContents% . `n`n
	FileContents := "" ;I think that it is better to free that memory. I am not sure if this variable will be destroyed when the label end.
	Gui, licence:Add, Button, w64 h32 xm gbAccept , Accept
	Gui, licence:Show 

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

}

