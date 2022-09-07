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


#include core/class__Pixel.ahk

;The colorFormat is BGR
;commonColors is an array of the most common colors for that rock, ordered from most common at first. Colors have to be diferent from others, e. g diferent than ground color
;rawColor is not used for now. It is the color of the material on the inventory, but only the color of the point in the center.
_ROCKS := []
_ROCKS[1] := {name:"Clay", commonColors:["0x3C7798", "0x1B3B46", "0x1F414E"], rawColor:"nodefined", colorFormat:"BGR"}
_ROCKS[2] := {name:"Iron", commonColors:["0x18223E","0x1A3E42","0x141F37"], rawColor:"0x111A32", colorFormat:"BGR"}
_ROCKS[3] := {name:"Cooper", commonColors:["0x345B87","0x335984","0x284365"], rawColor:"0x26466B", colorFormat:"BGR"}


;Look at the area to find one rock knowed
prospectRock(region){
	
	Global _ROCKS, _Pixel
	loop, % _ROCKS.Length() {
		
		rock := _ROCKS[A_Index]
		ToolTip, % "Looking for " . rock.name 
		Sleep 500
		ToolTip
		loop, % rock.commonColors.Length(){

			PixelSearch, cX, cY, region.x1, region.y1, region.x2, region.y2, rock.commonColors[A_Index], 0, fast
			if(!ErrorLevel){ 
				return {name: rock.name  
						,rawColor:rock.rawColor 
						,selectedPixel: new _Pixel(cX, cY, rock.commonColors[A_Index])
						,region:region}
			
			} 
		}

		ToolTip, % rock.name . " not found" 
		Sleep 500
		ToolTip
	}
	
	;Nothing found
	return 0
}