; free osrs mining scrip by thinkRand: A macro based on color detection to automate mining in the MMO OSRS.
; <<Copyright (C)  2022 thinkRand - Abel Granados>>
; <<https://es.fiverr.com/abelgranados>>

; This program is free software: you can redistribute it and/or modify it under the terms of the 
; GNU General Public License as published by the Free Software Foundation, either version 3 of 
; the License, or (at your option) any later version.

; This program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the 
; implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU General Public License 
; for more details.

; You should have received a copy of the GNU General Public License along with this program. If not, see 
; <https://www.gnu.org/licenses/>.


;NOTE: [THE HOTKEYS ARE AT THE END OF THE FILE]

#MaxThreadsPerHotkey, 2
#NoTrayIcon 
#SingleInstance, force 
FileEncoding , UTF-8
SetWorkingDir %A_ScriptDir%

#include core/cursor.ahk
#include core/delays.ahk
#include core/regionMaker.ahk
#include core/inventory.ahk
#include core/rockModel.ahk
#include core/guiLicence.ahk
#include core/guiInfo.ahk
#include core/class__Pixel.ahk



stop := false ;Flag to stop the script, does not work well
scriptCicles := 10000 ;Number of times that the loop of mining will be executed, i did this to prevent long time of macroing without interruption.
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

OnExit("ExitFunc")
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
	
	Global inventoryExist, markedRegions, _Pixel, inventory, scriptCicles, stop
	
	;#Initial validations 
	
	if (!inventoryExist){ ;if inventory no exist

		ToolTip,  Inventory undefined
		Sleep 2000
		ToolTip
		return

	}

	if (!markedRegions.Length()) { ;if there is not one region at least

		ToolTip,  Define at least one rock in order to run mining.
		Sleep 2000
		ToolTip
		return

	}
	;#End of initial validations 

	
	userDefinedRocks := markedRegions ;userDefinedRocks is an intuitive alias for the regions
	static identifiedRocks := [] ;identifiedRocks is remembered between calls to stop/continue the scrip without redefining regions
	
	;All the rocks have to be identified, now
	if (!identifiedRocks.Length()){ ;if there is not rocks identified
	
		identifiedRocks := identifyRocks(userDefinedRocks)
	
	}

	;The process will continue only if all the rocks are identified
	if (identifiedRocks.Length() != userDefinedRocks.Length()){ 
		
		identifiedRocks := []	
		ToolTip, Can not identify all the rocks. Try again.
		Sleep 2000
 		ToolTip 
		return 
	
	}

	;#All ready to start minig

	rocksCantity := identifiedRocks.Length()
	rockBeingMined := 0 ;Current rock being mined
	Random, rockBeingMined, 1, rocksCantity ;chose a random rock to start
	
	;Pixel of cell 28 of the inventory, it is used to know when to drop. It is bad, but work
	cell28pixelSelected := new _Pixel(inventory.cells[28].x + 16, inventory.cells[28].y + 16, inventory.baseColor)
	
	;Main loop
	loop, %scriptCicles% {
		
		isThereOre := !identifiedRocks[rockBeingMined].selectedPixel.Changed()
		if(isThereOre) {
			;Move pointer to the rock
			cursorTo(identifiedRocks[rockBeingMined].region)
			delayMin() ;its trying to simulate a human delay after reach the rock.
			Click
			
			;Keep looking the rock to detect the extraction.
			mined :=  identifiedRocks[rockBeingMined].selectedPixel.AwaitChange(20000)
			
			if(mined = 1){
				
				if(cell28pixelSelected.Changed()) { ;If the cell 28 is fill, the inventory is filled

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

				stop := false
				;identifiedRocks := []
				ToolTip, Stopped
				Sleep, 900
				ToolTip
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
	
} ;End of main function


;function that identify all the rocks one by one then return an array of identified rocks
identifyRocks(userDefinedRocks){
	
	
	identifiedRocks := []
	rocksCantity := userDefinedRocks.Count()
	aux := 0
	loop 3 { ;3 attempts

		loop, %rocksCantity% {

			aux := prospectRock(userDefinedRocks[A_index])	
			if (aux != 0){
				identifiedRocks[A_index] := aux
			}
		}
		
		if (identifiedRocks.Count() = rocksCantity) {
			return identifiedRocks
		}
	}

	return identifiedRocks
}


stop(){
	Global
	stop := true
}

;[HOTKEYS]
!v::
	boxToggleAll()
return

^LButton::
	makeRegion()
return

p::
	pause
return

!i::
	if (!inventoryExist){
		loadInventory()
	}

	mining()
return

!s::
	stop()
return

!r::
	stop()
	clearRegions()
	ToolTip, The regions has been cleared.
	Sleep, 600
	ToolTip
return

!l::
	changeLanguage()
return

!c::
	MsgBox, The script will close.
	Exitapp
return


ExitFunc(){

	if (GetKeyState("Shift")){
		Send, {Shift up}
	}

}