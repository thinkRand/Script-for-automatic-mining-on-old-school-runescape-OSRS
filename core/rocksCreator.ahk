#include core/class_Pixel.ahk
#include core/rocksColor.ahk

ini_rocksColor()

prospectRock(area){
	Global _ROCKS, _Pixel
	loop, % _ROCKS.length() {
		pixelSearch, cX, cY, area.x1,area.y1, area.x2, area.y2, _ROCKS[A_Index].color,,fast
		if(ErrorLevel = 0){
			return {name:_ROCKS[A_Index].name 
				,color:_ROCKS[A_Index].color 
				,rawColor:_ROCKS[A_Index].rawColor 
				,pixelSelected: new _Pixel(cX, cY, _ROCKS[A_Index].color)
			}
		}
		else{	
			; ToolTip, % _ROCKS[A_Index].name " not found"
			; sleep 300
		}
	}
	
	;Nothing found
	return 0
}