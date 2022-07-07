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

	Gui, info:New, -Resize +MinimizeBox -MaximizeBox +HwndGuiHwnd, Info
	Gui, Color, 0x22262A, 0x393F46
	Gui, Font , , Verdana
	Gui, info:add, Edit,0x80 ReadOnly w600  h240 Wrap cCCCCCC VScroll ,  %FileContents%
	link_addAsGroupBox("info")
	;Gui, info:show, NoActivate ;If i do not put NoActivate, the window shows a blue selection on all the text that is horrible to see. Is there other way to do it?
	Gui, info:show
	SetTimer, watchCursor, 100 

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