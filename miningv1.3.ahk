; miningv1.3.ahk : A macro based on color detection to automate mining in the MMO OSRS.
; <<Copyright (C)  2022 Abel Granados>>

; This program is free software: you can redistribute it and/or modify it under the terms of the 
; GNU General Public License as published by the Free Software Foundation, either version 3 of 
; the License, or (at your option) any later version.

; This program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the 
; implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU General Public License 
; for more details.

; You should have received a copy of the GNU General Public License along with this program. If not, see 
; <https://www.gnu.org/licenses/>.


;NOTE: [THE HOTKEYS ARE AT THE END OF THE FILE]


#NoTrayIcon 
#SingleInstance, force 
FileEncoding , UTF-8
critical, off 
SetWorkingDir %A_ScriptDir%

#include core/cursor.ahk
#include core/delays.ahk
#include core/areaMarker.ahk
#include core/inventory.ahk
#include core/rockModel.ahk
#include core/guiLicence.ahk
#include core/guiInfo.ahk
#include core/class__Pixel.ahk



stop := false ;Flag to stop the script, does not work well
scriptCicles = 10000 ;Number of times that the loop of mining will be executed, i did this to prevent long time of macroing without interruption.
GuiHwnd := 0 ;Main window handler, can be one of two options: Licence or Info
licenceAcepted := "false" ;Flag to indicate if the licence GUI has to be open
language := "en"


if FileExist("docs/config.ini") {
	FileReadLine, licenceAcepted, docs/config.ini, 1 ;config.ini has only one line with the word true or false.
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
	createGuiLicence()
}else if (licenceAcepted == "true"){
	 createGuiInfo("docs/info.txt")
}else{
	MsgBox, 3 Error. The program will finish.
	Exitapp
}

return
;END OF AUTOEXECUTE SECTION



;function to change the language
changeLanguage(){
	Global language
	if (language == "en") {

		createGuiInfo("docs/info_es_ES.txt")
		language := "es"
	
	} else if (language == "es") {
	
		createGuiInfo("docs/info.txt")
		language := "en"	
	
	}
}



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
				;Local cellIndicator28 := {x:INVENTORY.cells[28].x + 16, y:INVENTORY.cells[28].y + 16, color:INVENTORY.baseColor} 
				Local cell28pixelSelected := new _Pixel(INVENTORY.cells[28].x + 16, INVENTORY.cells[28].y + 16, INVENTORY.baseColor)

				;Main loop
				loop, % scriptCicles {
					
					Local isThereOre := !identifiedRocks[rockBeingMined].selectedPixel.Changed()
					if(isThereOre) {
						;Move pointer to the rock
						cursorTo(identifiedRocks[rockBeingMined].area)
						delayMin() ;its trying to simulate a human delay after reach the rock.
						Click
						
						;Keep looking the rock to detect the extraction.
						Local mined :=  identifiedRocks[rockBeingMined].selectedPixel.AwaitChange(20000)
						
						if(mined = 1){
							if(cell28pixelSelected.Changed()) { ;If the cell 28 is fill, the inventory is filled
								;drop items from cell 2 to cell 28
								MsgBox, 28 fll.
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

!l::
	changeLanguage()
return

!c::
	MsgBox, The script was closed.
	Exitapp
return


