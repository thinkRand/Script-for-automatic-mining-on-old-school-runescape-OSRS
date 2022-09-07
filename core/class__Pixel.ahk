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


class _Pixel {
	
	__New(x:=0, y:=0, color:=0xffffff){
		this.x := x
		this.y := y
		this.color := color
	}

	;Look if the pixel color changed
	Changed(){

		PixelGetColor, currentColor, this.x, this.y
		if (currentColor != this.color) {
			
			return 1
			
		}
				
		return 0	
	}

	;keeps watching the color untili it changed or max time is reached
	;returns true if it changed, false otherwesi
	AwaitChange(timeOut := 500) {
		
		frequence := 200
		startTime := A_TickCount
		timeElapsed := 0

		while(timeElapsed < timeOut){

			if(this.Changed()){
				return true
			}

			Sleep, frequence
			timeElapsed := A_TickCount - startTime

		}

		return false
	}

} ;class end