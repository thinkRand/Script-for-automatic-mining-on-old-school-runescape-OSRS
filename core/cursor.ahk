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

;This function receive an area in absolute coordinates
;innerBorder is a option to strech the area, making it more precice. If you put negative values then you make the area more bigger, to make more imprecice
;The speed is set to 15 because i think ta is a good value to asimisly human mousemove, but does not work well because the speed is constant
;I had no idea of how to move the mouse in a variable speed, just like human do. 
cursorTo(area, innerBorder := 0, speed := 15)
{	
	Local
	x = y = 0

	Random, x, area.x1+innerBorder, area.x2-(innerBorder*2)
	Random, y, area.y1+innerBorder, area.y2-(innerBorder*2)
	
	MouseMove x, y, speed
}