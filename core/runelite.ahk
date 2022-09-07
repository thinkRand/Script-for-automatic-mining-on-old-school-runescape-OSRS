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



CURRENT_WINDOW := 0 ;To store the hwnd of the window being use
CURRENT_PROCESS := "" ;The name of the process associated with the current window
RUNELITE_EXIST := false ;Flag to indicate if the runeLite window exist


evalCurrentWindow(){
	
	Global CURRENT_WINDOW, CURRENT_PROCESS, RUNELITE_EXIST
	
	currentWindow := WinExist("A")
	WinGet, processName , ProcessName, ahk_id %currentWindow%
	winGetTitle, vTitle, ahk_id %currentWindow%
	
	if (processName = "RuneLite.exe"){	
		
		MsgBox The window %vTitle%  is running with the script now.
		CURRENT_WINDOW := currentWindow
		CURRENT_PROCESS := processName
		RUNELITE_EXIST := true
	
	}else{
		MsgBox The window %vTitle% is ivalid.
	}
}