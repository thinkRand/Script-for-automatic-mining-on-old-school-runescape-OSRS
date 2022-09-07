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




#include core/links.ahk

createGuiInfo(infotxt){

	if FileExist(infotxt){
		FileRead, FileContents, %infotxt%
		if (ErrorLevel){
			MsgBox, Error. The program will finish.
			Exitapp
		}
	}else{
		MsgBox, Error. The program will finish.
		Exitapp
	}

	Gui, info:New, -Resize +MinimizeBox -MaximizeBox +HwndGuiHwnd, Free osrs mining script - by thinkRand
	Gui, Color, 0x22262A, 0x393F46
	Gui, Font , , Verdana
	Gui, info:add, Edit, T16  w600  h240 0x80 ReadOnly cCCCCCC 0x40,  %FileContents%
	link_addAsGroupBox("info")
	Gui, info:show, NA
	SetTimer, watchCursor, 100 

	return

	InfoGuiClose:
		Exitapp
	return
}



;watchCursor is a function that look over the position of the mouse constantly.
;It is used to draw a Tooltip over some images. Does not work well, i think that there has to be a better way to do this.
watchCursor(){
	
	Global GuiHwnd	
	MouseGetPos, , , id, control
	if (GuiHwnd == id){ ;Only when the mouse is over the main window of this script
		;Static1,2,3, and 4 are the names of some Picture Controls on the info window
		If (control == "Static1" ||control == "Static2"||control == "Static3"){
			;mouseHoverPicOn ; has to draw the tooltip if mouse is hover the picture
			mouseHoverPicOn(control)
			;Is onPicHover(control) a better name for this function? i am asking because i do not understand English very well. 
		}else{
			;mouseHoverPictureOff ; has to remove the tooltip if mouse leaves the picture
			mouseHoverPicOff()
		}
	}

}