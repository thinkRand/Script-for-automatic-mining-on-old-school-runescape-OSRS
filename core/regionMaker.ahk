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


#include core/boxDrawer.ahk

markedRegions := [] ;To store the regions defined by the user

makeRegion(reset := 0){
	
	Global markedRegions
	static currentPoint := 1 
	static x1 = 0
	static y1 = 0
	static x2 = 0
	static y2 = 0
	
	if (reset){
		
		currentPoint := 1
		x1 := 0
		y1 := 0
	 	x2 := 0
	 	y2 := 0
		return
	
	}
	
	if(currentPoint == 1){
	
		MouseGetPos, x1, y1
		currentPoint++
	
	}else if (currentPoint == 2){
		
		MouseGetPos, x2, y2
		
		;Transforms the coordinates given into a correct region
		if(x2 < x1){
			temp := x1
			x1 := x2
			x2 := temp
		}

		if(y2 < y1){
			temp := y1
			y1 := y2
			y2 := temp
		}

		newRegion := {"x1":x1, "y1":y1, "x2":x2, "y2":y2}
		markedRegions.push(newRegion)
		boxDraw(x1, y1, x2-x1, y2-y1)
		
		currentPoint := 1
		x1 := 0
		y1 := 0
	 	x2 := 0
	 	y2 := 0

	
	}
}



clearRegions(){
	
	Global
	markedRegions := []
	makeRegion(reset:=1)

}



getRegion(n){
	Global

	if(markedRegions[n]) {
		return markedRegions[n]
	}

	return 0 ;Region does not exist
}
