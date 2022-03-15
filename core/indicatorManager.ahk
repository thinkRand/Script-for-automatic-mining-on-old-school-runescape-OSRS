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



#include core/osrsData.ahk

ini_indicatorManager(){
	ini_osrsData()
}


prospectRock(area){
	Local
	Global _ROCK
	loop, % _ROCK.length()
	{
		pixelSearch, cX, cY, area.x1,area.y1, area.x2, area.y2, _ROCK[A_Index].color,,fast
		if(ErrorLevel = 0){
			return {name:_ROCK[A_Index].name 
				,color:_ROCK[A_Index].color 
				,rawColor:_ROCK[A_Index].rawColor 
				,indicator:{x:cX, y:cY, color:_ROCK[A_Index].color}}
		}
		else{	
			; ToolTip, % _ROCK[A_Index].name " not found"
			; sleep 300
		}
	}
	
	;Nothing found
	return 0
}


;eval an indicator to know if it changed

evalIndicator(indicator){
	Local
	PixelGetColor currentColor, indicator.x, indicator.y
	if !ErrorLevel
	{
		if(indicator.color != currentColor)
		{
			return 1
		}else{
			return 0
		}
	
	}else{
		return -1
	}
}

;It is kept watching an indicator, waiting for it to change.
waitIndicatorChange(indicator,  cicles := 100 , frequence := 200){	
	Local
	loop, %cicles%
	{
		; tooltip, ciclo %A_Index%
		PixelGetColor currentColor, indicator.x, indicator.y
		if !ErrorLevel 
		{
			if indicator.color != currentColor
			{
				return 1
			}else{	
				Sleep, % frequence
			}
		
		}else{
			;Continue
		}
	}
	return 0
}