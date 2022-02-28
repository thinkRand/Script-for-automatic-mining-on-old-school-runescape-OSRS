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



;Inicia todas las variables necesarias para la interface link
ini_link(){
	Local
	line := "Network:`nBNB Smart Chain (BEP20)`n`nWallet address:`n"
	line .= "0x4ffe58d307aebd4c1edb26a17b77c991da0f45ff`n`nBNB Wallet: Send only BNB to this address."
	Global metamaskAddress := "0x25C5f8ea519F29D148C356F077CdDbb983CBD65D", gmail := "infoabelgranados@gmail.com",binance := line,discord := "Byss programmer#7433"
}

;Añade un GroupBox a la gui indicada, el cual contiene los links
link_addAsGroupBox(guiName){
	Local
	Static controlPicDiscord := 0, controlPicBinance := 0, controlPicMetamask := 0,controlPicGMail := 0
	Gui, %guiName%:Add, GroupBox, w600 Center cCCCCCC, Enlaces a Donaciones y Contactos
	GBWidth := 600
	PicturesWidth := (4*40) + 10
	xIni := round((GBWidth/2) - (PicturesWidth/2))
	Gui, %guiName%:Add,Picture,x%xIni%+10 yp+15 w40 h40 gcontentToClipboard vcontrolPicDiscord, %A_WorkingDir%/img/discord_logo_48.png
	Gui, %guiName%:Add,Picture,x+10 yp w40 h40 gcontentToClipboard vcontrolPicBinance, %A_WorkingDir%/img/bnb_logo_48_3.png
	Gui, %guiName%:Add,Picture,x+10 yp w40 h40 gcontentToClipboard vcontrolPicMetamask, %A_WorkingDir%/img/metamask_logo_48_3.png
	Gui, %guiName%:Add,Picture,x+10 yp w40 h40 gcontentToClipboard vcontrolPicGMail, %A_WorkingDir%/img/gmail_logo_48.png
}

;Crear una nueva Gui que contiene la informacion de los links
link_addAsNewGui(){
	Local
	Static controlPicDiscord := 0 ,controlPicBinance := 0,controlPicMetamask := 0,controlPicGMail := 0
	Gui, links:new, 
	Gui, links:Add, GroupBox, cWhite, Enlaces a Donaciones y Contactos
	;añado el primero link
	Gui, links:Add,Picture,xp+5 yp+15 w40 h40 gcontentToClipboard vcontrolPicDiscord, %A_WorkingDir%/img/discord_logo_48.png
	Gui, links:Add,Picture,xp+45 yp w40 h40 gcontentToClipboard vcontrolPicBinance, %A_WorkingDir%/img/bnb_logo_48_3.png
	Gui, links:Add,Picture,xp+45 yp w40 h40 gcontentToClipboard vcontrolPicMetamask, %A_WorkingDir%/img/metamask_logo_48_3.png
	Gui, links:Add,Picture,xp+45 yp w40 h40 gcontentToClipboard vcontrolPicGMail, %A_WorkingDir%/img/gmail_logo_48.png
	; Gui, Color, 0x22262A, 0x393F46
	Gui, links:show


} ;fin funcion



;muestra el mensaje de copiar al portapapeles cuando el mouse esta sobre un controlador pic
onPicHover(control){
	ToolTip, Copiar al portapapeles
}

;Elimina el tooltip cuando el mouse deja un controlador pic
onPicHoverOff(){
	ToolTip
}





;Copia el contenido del link informativo al portapapeles y da aviso de que se hiso
;El aviso debe consistir en un simbolo de nike y decir, COPIADO! como en Binance
contentToClipboard(){
	Local 
	Global metamaskAddress, gmail, binance, discord
	Switch A_GuiControl
	{
		case "controlPicDiscord": Clipboard := discord
		case "controlPicBinance": Clipboard := binance
		case "controlPicMetamask": Clipboard := metamaskAddress
		case "controlPicGMail": Clipboard := gmail
		Default:
		ToolTip, Error. no se selecciono un link valido
		sleep 200
		ToolTip
	}
	;hay que desactivar la subrutina porque el siguiente tooltip tiene prioridad
	SetTimer, WatchCursor, off
	ToolTip, ¡Copiado!
	sleep 600
	ToolTip
	SetTimer, WatchCursor, on
} ;fin funcion



/*

	if (GuiHwnd == id){ ;Solo cuando el mouse este sobre la ventana
		loop, % _Monitorear.length()
		{
			if (_Monitorear[A_index] == control){
				onPicHover(control) ;;muestra el mensaje de copiar al portapapeles cuando el mouse esta sobre un controlador pic
				break
			}else{
				onPicHoverOff()
			}
		}
	}
}*/



/*
a::
; addAsNewGui()
ini_link()
Gui, Prueba:New
addAsGroupBox("Prueba")
Gui, Prueba:show
return

esc::
ExitApp 
return
*/

/*
#If MouseIsOver("ahk_class Shell_TrayWnd")
WheelUp::Send {Volume_Up}
WheelDown::Send {Volume_Down}

MouseIsOver(WinTitle) {
    MouseGetPos,,, Win
    return WinExist(WinTitle . " ahk_id " . Win)
}

*/



; onMouseMove(wParam, lParam, msg, hwnd){
	
	; 	;ToolTip, % A_GuiControl ;muestra el nombre de la variable del controlador
	; 	; ToolTip, % hwnd muestra el hwnd del controlador o la ventana
	; 	Switch A_GuiControl
	; 	{
		; 		case "controlPicDiscord": 

		; 			; SplashTextOn , 100 ,100 , , Copiar al portapapeles
		; 			; Progress, zh0 fs18, Copiar al portapapeles.
		; 		case "controlPicBinance": 
		; 		case "controlPicMetamask": 
		; 		case "controlPicGMail": 
		; 		Default:
		; 	; 		ToolTip, Error. no se selecciono un link valido
		; 	; 		sleep 200
		; 	; 		ToolTip
		; 	 }
		; }




		; OnMessage(MsgNumber [, Function, MaxThreads])
		; WM_MOUSEHOVER := 0x2A1
		; WM_NCMOUSELEAVE := 0x2A2
		; WM_MOUSELEAVE := 0x2A3
		; WM_MOUSEMOVE := 0x200
