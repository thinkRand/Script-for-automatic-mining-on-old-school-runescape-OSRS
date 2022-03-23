; miningv1.2_BETA.ahk : A macro based on color detection to automate mining in the MMO OSRS.
; <<Copyright (C)  2022 Abel Granados>>

; This program is free software: you can redistribute it and/or modify it under the terms of the 
; GNU General Public License as published by the Free Software Foundation, either version 3 of 
; the License, or (at your option) any later version.

; This program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the 
; implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU General Public License 
; for more details.

; You should have received a copy of the GNU General Public License along with this program. If not, see 
; <https://www.gnu.org/licenses/>.



;[THE HOTKEYS ARE ALL AT THE END OF THE FILE]
#NoTrayIcon 
#SingleInstance, force 
SetWorkingDir %A_ScriptDir%

#include core/cursor.ahk
#include core/delays.ahk
#include core/areaManager.ahk
#include core/clientInterface.ahk
#include core/indicatorManager.ahk
#include core/link.ahk


FileEncoding , UTF-8
critical, off 
stop := false ;Flag to stop the script, does not work well
scriptCicles = 10000 ;Number of times that the loop of mining will be executed, i did this to prevent long time of macroing without interruption.
GuiHwnd := 0 ;Main window handler, can be one of two options: Licence or Info
licenceAcepted := "false" ;Flag to indicate if the licence GUI has to be open

;config.ini has only one line with the word true or false.
if FileExist("docs/config.ini") {
	FileReadLine, licenceAcepted, docs/config.ini, 1
	if (ErrorLevel) {
		MsgBox, 0 Error. The program will finish.
		Exitapp
	}
}else{
	FileAppend , false, docs/config.ini 
	if (ErrorLevel) {
		MsgBox, 1 Error. The program will finish.
		Exitapp
	}
} 


if (licenceAcepted == "false"){
	GoSub createGuiLicence
}else if (licenceAcepted == "true"){
	 GoSub createGuiInfo
}else{
	MsgBox, 3 Error. The program will finish.
	Exitapp
}
return
;END OF AUTOEXECUTE SECTION



createGuiLicence:
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

	Gui, licence:New, -Resize +MinimizeBox -MaximizeBox +HwndGuiHwnd , Mining_v1.2_BETA licence
	Gui, licence:Add, edit, vEditlicence readOnly w600 h400, %FileContents% . `n`n
	FileContents := "" ;I think that it is better to free that memory. I am not sure if this variable will be destroyed when the label end.
	Gui, licence:Add, Button, w64 h32 xm gbAccept , Accept
	Gui, licence:Show 
return 


;watchCursor is a function that look over the position of the mouse constantly.
;It is used to draw a Tooltip over some images. Does not work well, i think that there has to be a better way to do this.
watchCursor(){
	Local
	Global GuiHwnd	
	MouseGetPos, , , id, control
	if (GuiHwnd == id){ ;Only when the mouse is over the main window of this script
		;Static1,2,3, and 4 are the names of some Picture Controls on the info window
		If (control == "Static1" ||control == "Static2"||control == "Static3"||control == "Static4"){
			;mouseHoverPicOn ; has to draw the tooltip if mouse is hover the picture
			mouseHoverPicOn(control)
			;Is onPicHover(control) a better name for this function? i am asking because i do not understand English very well. 
		}else{
			;mouseHoverPictureOff ; has to remove the tooltip if mouse leaves the picture
			mouseHoverPicOff()
		}
	}
}

; Button that is on the licence window, when it is pressed it has to open the Info window
bAccept:
	Gui, licence:Destroy
	FileDelete, docs/config.ini
	FileAppend , true, docs/config.ini, 
	
	if (ErrorLevel) {
		MsgBox, Error. The program will finish.
		Exitapp
	}

	GoSub, createGuiInfo
return


createGuiInfo:

	if FileExist("docs/info.txt"){
		FileRead, FileContents, docs/info.txt
		if (ErrorLevel){
			MsgBox, Error. The program will finish.
			Exitapp
		}
	}else{
		MsgBox, Error. The program will finish.
		Exitapp
	}

	Gui, info:New, -Resize +MinimizeBox -MaximizeBox +HwndGuiHwnd, Info
	Gui, Color, 0x22262A, 0x393F46
	Gui, Font , , Verdana
	Gui, info:add, Edit,0x80 ReadOnly w600  h240 Wrap cCCCCCC VScroll ,  %FileContents%
	link_addAsGroupBox("info")
	Gui, info:show, NoActivate ;If i do not put NoActivate, the window shows a blue selection on all the text that is horrible to see. Is there other way to do it?
	SetTimer, watchCursor, 100 
return





;Main function. Apply the mining logic.
mining(){
	Global
	static firstExecution := true
	if (firstExecution)	{
		loadInventory()
		firstExecution := false
	}

	if (INVENTORY_EXIST) {
		if (MARKED_AREAS_FILLED) {
			Local userDefinedRocks := MARKED_AREAS ;Assigned it an intuitive alias
			static identifiedRocks := [] 
			;All the rocks have to be identified, now
			if (identifiedRocks.length() = 0){
				identifiedRocks := identifyRocks(userDefinedRocks)
			}
			;The process will continue only if all the rocks are identified
			if (identifiedRocks.length() = userDefinedRocks.length()){
				stop := false ;Maybe this is not necessary, i am not sure. I planned to ensure that stop is false every time that the script run
				Local rocksCantity := identifiedRocks.length()
				static rocksCantityMinadas := 0
				Local rockBeingMined := 0 ;Current rock being mined
				Random rockBeingMined, 1, rocksCantity
				;Indicator of cell 28 of the inventory, it is used to know when to drop. It is bad, but work
				Local cellIndicator28 := {x:INVENTORY.cells[28].x + 16, y:INVENTORY.cells[28].y + 16, color:INVENTORY.baseColor} 
		
				;Main loop
				loop, % scriptCicles 
				{
					Local isThereOre := isColorInArea(MARKED_AREAS[rockBeingMined], identifiedRocks[rockBeingMined].indicator.color)
					if(isThereOre) {
						;Move pointer to the rock
						cursorTo(MARKED_AREAS[rockBeingMined])
						delayMin() ;its trying to simulate a human delay after reach the rock.
						Click
						;Keep looking the rock to detect the extraction.
						Local mined := waitIndicatorChange(identifiedRocks[rockBeingMined].indicator)
						if(mined = 1){
							if(evalIndicator(cellIndicator28) = 1){ ;If the cell 28 is fill, the inventory is filled
								;drop items from cell 2 to cell 28
								inventoryDropItems(2,28,1)
							}else{
								;cell 28 is not filled, so nothing to do now
							}

							;if the rock being mining is the last on the list, then the next rock will be the first on the list
							if(rockBeingMined = rocksCantity){
								rockBeingMined := 1
							}else{
								rockBeingMined++
							}
						
						}else{
							MsgBox, An extraction has not been detected in a long time. The program will stop.
							break
						}
						
						if(stop){
							MsgBox, stopped
							identifiedRocks := []
							break
						}
					
					}else{ 
						;In case of there is not ore, try the next one
						if(rockBeingMined = rocksCantity){
							rockBeingMined := 1
						}else{
							rockBeingMined++
						}
					}
					
				} ;End of Main Loop
			
			}
			else{
				MsgBox, Cannot identify all the rocks. Try again. 
				return 0
			}
		}else {
		  MsgBox You have to define at least one rock in order to run mining.
		}
	
	}else{
		firstExecution := true ;This is for try to define the inventory again.
	}
} ;End of main function


;function that identify all the rocks one by one then return an array of identified rocks
identifyRocks(userDefinedRocks)
{
	Global
	Local identifiedRocks := []
	Local attempts := 0
	Local aux := 0
	loop
	{
		loop, % userDefinedRocks.length()
		{
			Local a := userDefinedRocks[A_index]
			aux := prospectRock(userDefinedRocks[A_index])	
			if (aux != 0){
				identifiedRocks[A_index] := aux
			}
		}
		
		if (identifiedRocks.length() = userDefinedRocks.length()) {
			return identifiedRocks
		}else{
			if (attempts > 40) {
				return identifiedRocks
			}
			attempts++	
		}
	}
}


stop(){
	Global
	stop := true
}

;[HOTKEYS]
!v::
	toggleInventory()
return

!a::
	makeArea()
return

!p::
	pause
return

!i::
	mining()
return

!d::
	stop()
return

!r::
	stop()
	eraseAreas()
	MsgBox, The areas has been reset.
return

!c::
GuiClose:
	MsgBox, The script was closed.
	Exitapp
return