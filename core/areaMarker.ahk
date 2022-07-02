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

MARKED_AREAS := [] ;To store the areas defined by the user
MARKED_AREAS_FILLED := false ;Flag to indicate if exists at least one area defined

class _Area{
    x1 := 0
	y1 := 0
	x2 := 0
	y2 := 0
}



makeArea(reset := ""){
	
	Global _Area, MARKED_AREAS, MARKED_AREAS_FILLED	
	static currentPoint := 1 
	static areasCount := 1
	x := y := 0
	
	if (reset == "reset") {
		
		currentPoint := 1
		areasCount := 1
		return
	
	}
	
	MouseGetPos, x, y
	if(currentPoint == 1){
	
		currentPoint++
		MARKED_AREAS[areasCount] := new Area
		MARKED_AREAS[areasCount].x1 := x
		MARKED_AREAS[areasCount].y1 := y
	
	}else if (currentPoint == 2){
		
		MARKED_AREAS[areasCount].x2 := x
		MARKED_AREAS[areasCount].y2 := y
		;Transforms the coordinates given into a correct area
		if(MARKED_AREAS[areasCount].x1 > MARKED_AREAS[areasCount].x2){
		
			aux := MARKED_AREAS[areasCount].x1
			MARKED_AREAS[areasCount].x1 := MARKED_AREAS[areasCount].x2
			MARKED_AREAS[areasCount].x2 := aux
		
		}
		
		if(MARKED_AREAS[areasCount].y1 > MARKED_AREAS[areasCount].y2){
		
			aux := MARKED_AREAS[areasCount].y1
			MARKED_AREAS[areasCount].y1 := MARKED_AREAS[areasCount].y2
			MARKED_AREAS[areasCount].y2 := aux
		
		}
		MsgBox Area %areasCount% created.
		areasCount++
		currentPoint := 1
		MARKED_AREAS_FILLED := true	
	
	}
}



isColorInArea(area, color){

	if isObject(area){
		if (color is xdigit) {
		
			cX := cY := 0
			pixelSearch, cX, cY, area.x1, area.y1, area.x2, area.y2, color,,fast
			if(!ErrorLevel){
				return 1
			} else {
				return 0
			}
		
		}else{
			MsgBox Error in isColorInArea(), the color is invalid
			return -1
		}
	
	} else{
		MsgBox Error in isColorInArea(), the area is invalid
		return -1
	}
}




eraseAreas(){
	Global
	MARKED_AREAS := []
	MARKED_AREAS_FILLED := false
	makeArea("reset")
}



getArea(n){
	Global

	if(MARKED_AREAS_FILLED) {
		
		if(isObject(MARKED_AREAS[n])){
			return MARKED_AREAS[n]
		}else{
			return -1
		}
	}else{
		return -1
	}

}