; <<Copyright (C)  2022 Abel Granados>>

; This file is part of miningv1.3
; This program is free software: you can redistribute it and/or modify it under the terms of the 
; GNU General Public License as published by the Free Software Foundation, either version 3 of 
; the License, or (at your option) any later version.

; This program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the 
; implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU General Public License 
; for more details.

; You should have received a copy of the GNU General Public License along with this program. If not, see 
; <https://www.gnu.org/licenses/>.

#include core/class__Pixel.ahk


;The colorFormat can be BGR or RGB. 
;commonColors is an array of the three most common colors for that rock, ordered from most common at first.
;rawColor is not used for now. It is the color of the material on the inventory, but only the color of the point in the center.
_ROCKS := [{name:"Clay", commonColors:["0x1B3B46","0x1F414E","0x2C5972"], rawColor:"nodefined", colorFormat:"BGR"}
,{name:"Iron", commonColors:["0x1B2646","0x1A3E42","0x141F37"], rawColor:"0x111A32", colorFormat:"BGR"}
,{name:"Cooper", commonColors:["0x345B87","0x335984","0x284365"], rawColor:"0x26466B", colorFormat:"BGR"}]


;Look at the area to find one rock knowed
prospectRock(area){
	
	Global _ROCKS, _Pixel
	loop, % _ROCKS.length() {
		rock := _ROCKS[A_Index]
		loop, % rock.commonColors.length() {
			pixelSearch, cX, cY, area.x1, area.y1, area.x2, area.y2, rock.commonColors[A_Index],,fast
			if(ErrorLevel = 0){
				return {name: rock.name  
						,rawColor:rock.rawColor 
						,pixelSelected: new _Pixel(cX, cY, rock.commonColors[A_Index])}
			} 

		}

		;rock.name not found	
	}
	
	;Nothing found
	return 0
}

