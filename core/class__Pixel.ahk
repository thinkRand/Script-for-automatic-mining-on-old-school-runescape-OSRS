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

class _Pixel {
	__New(x:=0,y:=0, color:=#fff){
		this.x := x
		this.y := y
		this.color := color
	}

	;Look if the pixel color changed
	Changed(){
		PixelGetColor currentColor, this.x, this.y
		if !ErrorLevel {
			if(this.color != currentColor) {
				return 1
			}else{
				return 0
			}
		
		}else{
			return -1
		}
	}

	;keeps watching the color untili it changed or max time is reached
	;return 1 if it changed, 0 otherwesi
	AwaitChange(cicles := 100 , frequence := 200){
		loop, %cicles% {
			if(this.Changed()){
				return 1
			}
			
			Sleep, % frequence 
		}
		
		return 0
	}
} ;class end

