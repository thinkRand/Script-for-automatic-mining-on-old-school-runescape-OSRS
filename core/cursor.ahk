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



;innerBorder is a option to strech the area, making it more precice. If you put negative values then you make the area more bigger, to make more imprecice

cursorTo(region, innerBorder := 0, speed := 2){
	
	if IsObject(region) {

		regionWidth := (region.x2 -innerBorder) - (region.x1 +innerBorder)
		regionHeigth := (region.y2 -innerBorder) - (region.y1 +innerBorder)

		Random, delta, 0, 9

		if(delta < 7){
			
			;Centered x, y
			Random, rx, (region.x1 + (regionWidth * 0.20)), (region.x1 + (regionWidth * 0.80))
			Random, ry, (region.y1 + (regionHeigth * 0.20)), (region.y1 + (regionHeigth * 0.80))
		
		}else{

			;normal x, y
			Random, rx, region.x1 +innerBorder, region.x2 -innerBorder
			Random, ry, region.y1 +innerBorder, region.y2 -innerBorder
		
		}
	
		MouseMove rx, ry, speed
	
	}else {
		MsgBox, Error at cursorTo(), region invalid
		return
	}
}