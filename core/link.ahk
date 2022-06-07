; <<Copyright (C)  2022 Abel Granados>>

; This file is part of miningv1.2_BETA
; This program is free software: you can redistribute it and/or modify it under the terms of the 
; GNU General Public License as published by the Free Software Foundation, either version 3 of 
; the License, or (at your option) any later version.

; This program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the 
; implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU General Public License 
; for more details.

; You should have received a copy of the GNU General Public License along with this program. If not, see 
; <https://www.gnu.org/licenses/>.

ini_link()

ini_link(){
	Global discord := "thinkRand#7433 UID:681695022600814642", gitHub := "https://github.com/thinkRand", fiverr := "https://es.fiverr.com/abelgranados"
}


link_addAsGroupBox(guiName){
	Local
	Static controlPicDiscord := 0, controlPicGitHub = 0, controlPicFiverr = 0
	GBWidth := 600
	Gui, %guiName%:Add, GroupBox, w%GBWidth% Center cCCCCCC, Contacts
	PicturesWidth := (3*40) + 10 ;3 pics * 40width/each
	xIni := round((GBWidth/2) - (PicturesWidth/2))
	Gui, %guiName%:Add,Picture,x%xIni%+10 yp+15 w40 h40 gcontentToClipboard vcontrolPicDiscord, %A_WorkingDir%/img/discord_logo_48.png
	Gui, %guiName%:Add,Picture,x+10 yp w40 h40 gcontentToClipboard vcontrolPicGitHub, %A_WorkingDir%/img/git_logo_48.png 
	Gui, %guiName%:Add,Picture,x+10 yp w40 h40 gcontentToClipboard vcontrolPicFiverr, %A_WorkingDir%/img/fiverr_logo_48.png
}


mouseHoverPicOn(control){
	ToolTip, Copy to clipboard
}


mouseHoverPicOff(){
	ToolTip
}

contentToClipboard(){
	Global discord, gitHub, fiverr
	Switch A_GuiControl
	{
		case "controlPicDiscord": Clipboard := discord
		case "controlPicGitHub" : Clipboard := gitHub
		case "controlPicFiverr": Clipboard := fiverr
		Default:
		ToolTip, Link invalid.
		sleep 200
		ToolTip
	}
	SetTimer, WatchCursor, off
	ToolTip, Copyed!
	sleep 600
	ToolTip
	SetTimer, WatchCursor, on
}