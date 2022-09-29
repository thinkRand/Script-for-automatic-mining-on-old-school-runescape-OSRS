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



#include core/runelite.ahk

inventoryExist := false ;Flag to indicate if the inventory is already created
inventory := {}

loadInventory(){

	evalCurrentWindow()
	Global RUNELITE_EXIST, CURRENT_WINDOW, CURRENT_PROCESS, inventory, inventoryExist
	
	if RUNELITE_EXIST {

		if (CURRENT_PROCESS = "RuneLite.exe"){

			WinActivate, ahk_id %CURRENT_WINDOW%
			
			;SunAwtCanvas2 is the control than contain the runescape client in runeLite
		 	Control := 0
			ControlGet, Control, Hwnd, , SunAwtCanvas2, ahk_id %CURRENT_WINDOW%
			if (ErrorLevel){

				MsgBox, The runescape client is unable to be detect
				return 0
			}
			ControlGetPos, X, Y, controlWidth, controlHeight, , ahk_id %Control%
			
			;inventory position relative to control
			inventoryPosRelativeControl := {x:controlWidth-204, y:controlHeight-311}
			;invetory position relative to window 
			inventoryPosRelativeWindow := {x:(inventoryPosRelativeControl.x+X), y:(inventoryPosRelativeControl.y+Y), father:CURRENT_WINDOW}
			cells := {}
			cellsProperties := {width:32,height:32 ,marginTop:4, marginLeft:10}
			inventoryPropertys := {paddingLeft:13, paddingTop:11}
		
			;Defining the position of every cell of the inventory
			x1 := inventoryPosRelativeWindow.x+inventoryPropertys.paddingLeft
			y1 := inventoryPosRelativeWindow.y+inventoryPropertys.paddingTop
			count := 1
			y2 := 0
			x2 := 0
			;7 rows
			loop, 7 {

				y1 := y1 + cellsProperties.marginTop
				y2 := y1 + cellsProperties.height
				;4 colums
				loop, 4 {

					x1 := x1 + cellsProperties.marginLeft
					x2 := x1 + cellsProperties.width
					cells[count] := {x:x1, y:y1, area:{x1:x1, y1:y1, x2:x2, y2:y2}, width:cellsProperties.width, height:cellsProperties.height}
					x1 := x2
					count++
				}
				
				y1 := y2
				x1 := inventoryPosRelativeWindow.x+inventoryPropertys.paddingLeft
			}
			
			inventory :=  {x:inventoryPosRelativeWindow.x, y:inventoryPosRelativeWindow.y, cells:cells, baseColor:"0x29353E", father:inventoryPosRelativeWindow.father}
			inventoryExist := true
			boxDraw(inventory.x, inventory.y, 204, 276) ;Shows a click-troghout gui where the inventory is, to see its position
			return true
		
		}else{
			MsgBox, Current process is invalid.
		}
	
	}else{
		MsgBox, The main window is not defined.
		Return 0
	}	
} 


;Drop every item in the inventory from start to end
inventoryDropItems(start, end, step:=1) {
		
	Global inventoryExist, inventory
	
	if inventoryExist {	
		i := start
		Send {Shift down}
		
		loop, % end-(start-1) {
	
			cursorTo(inventory.cells[i].area, 1)
			Click
			delayMin()
			i++
		
		}
		sleep 20 
		Send {Shift up}
	
	} else {
		MsgBox Error at inventoryDropItems(), the invetory is not created.
		return 0
	}

}
