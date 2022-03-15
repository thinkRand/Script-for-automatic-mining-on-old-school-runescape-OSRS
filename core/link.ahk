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



ini_link(){
	Local
	line := "Network:`nBNB Smart Chain (BEP20)`n`nWallet address:`n"
	line .= "0x4ffe58d307aebd4c1edb26a17b77c991da0f45ff`n`nBNB Wallet: Send only BNB to this address."
	Global metamaskAddress := "0x25C5f8ea519F29D148C356F077CdDbb983CBD65D", gmail := "infoabelgranados@gmail.com",binance := line, discord := "thinkRand#7433 UID:681695022600814642",gitHub := "https://github.com/thinkRand"
}


link_addAsGroupBox(guiName){
	Local
	Static controlPicDiscord := 0, controlPicBinance := 0, controlPicMetamask := 0,controlPicGMail := 0, controlPicGitHub = 0
	Gui, %guiName%:Add, GroupBox, w600 Center cCCCCCC, Links to Contact and Donations
	GBWidth := 600
	PicturesWidth := (5*40) + 10
	xIni := round((GBWidth/2) - (PicturesWidth/2))
	Gui, %guiName%:Add,Picture,x%xIni%+10 yp+15 w40 h40 gcontentToClipboard vcontrolPicDiscord, %A_WorkingDir%/img/discord_logo_48.png
	Gui, %guiName%:Add,Picture,x+10 yp w40 h40 gcontentToClipboard vcontrolPicBinance, %A_WorkingDir%/img/bnb_logo_48_3.png
	Gui, %guiName%:Add,Picture,x+10 yp w40 h40 gcontentToClipboard vcontrolPicMetamask, %A_WorkingDir%/img/metamask_logo_48_3.png
	Gui, %guiName%:Add,Picture,x+10 yp w40 h40 gcontentToClipboard vcontrolPicGMail, %A_WorkingDir%/img/gmail_logo_48.png
	Gui, %guiName%:Add,Picture,x+10 yp w40 h40 gcontentToClipboard vcontrolPicGitHub, %A_WorkingDir%/img/git_logo_48.png 
}


mouseHoverPicOn(control){
	ToolTip, Copy to clipboard
}


mouseHoverPicOff(){
	ToolTip
}

contentToClipboard(){
	Local 
	Global metamaskAddress, gmail, binance, discord, gitHub
	Switch A_GuiControl
	{
		case "controlPicDiscord": Clipboard := discord
		case "controlPicBinance": Clipboard := binance
		case "controlPicMetamask": Clipboard := metamaskAddress
		case "controlPicGMail": Clipboard := gmail
		case "controlPicGitHub" : Clipboard := gitHub
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