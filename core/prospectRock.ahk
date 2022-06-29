#include core/class_Pixel.ahk
#include core/rocksColor.ahk

ini_rocksColor()

;Look at the area to find one rock knowed
prospectRock(area){
	Global _ROCKS, _Pixel
	loop, % _ROCKS.length() {
		rock := _ROCKS[A_Index]
		loop, % rock.commonColors.length(){
			pixelSearch, cX, cY, area.x1, area.y1, area.x2, area.y2, rock.commonColors[A_Index],,fast
			if(ErrorLevel = 0){
				return {name:_ROCKS[A_Index].name  
						,rawColor:rock.rawColor 
						,pixelSelected: new _Pixel(cX, cY, rock.commonColors[A_Index])
						}
			} 

		}

		;rock.name not found	
	}
	
	;Nothing found
	return 0
}