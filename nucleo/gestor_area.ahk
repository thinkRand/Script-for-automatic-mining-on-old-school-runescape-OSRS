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


#include nucleo/Class_Area.ahk

ini_gestor_area(){
	Global
	AREAS_DEFINIDAS_POR_EL_USUARIO := []
	EXISTE_AREA_DEFENIDA_POR_USUARIO := false ; puede no se necesaria, mientras tanto la voy a usar
}

;El parametro reset indica si es necesario borrar los datos anteriores de las variables staticas
define_area(reset := ""){
	Global
	;Global AREAS_DEFINIDAS_POR_EL_USUARIO
	;Global EXISTE_AREA_DEFENIDA_POR_USUARIO	
	static cuentaPuntos = 1
	static cuentaAreas = 1
	if (reset == "reset")
	{
		cuentaPuntos = 1
		cuentaAreas = 1
		return
	}
	Local x = 0
	Local y = 0
	
	;las coordenadas del cliente no consideran la ventana de titulos y menu, y los bordes.
	MouseGetPos, x, y
	if(cuentaPuntos == 1){
		cuentaPuntos++
		AREAS_DEFINIDAS_POR_EL_USUARIO[cuentaAreas] := new Area
		AREAS_DEFINIDAS_POR_EL_USUARIO[cuentaAreas].x1 := x
		AREAS_DEFINIDAS_POR_EL_USUARIO[cuentaAreas].y1 := y
		;MsgBox % 
	}
	else if (cuentaPuntos == 2){
		AREAS_DEFINIDAS_POR_EL_USUARIO[cuentaAreas].x2 := x
		AREAS_DEFINIDAS_POR_EL_USUARIO[cuentaAreas].y2 := y
		;MsgBox % "
		;arganizo a toda AREAS_DEFINIDAS_POR_EL_USUARIO para que se  forme desde x, y minimo a x, y maximo
		if(AREAS_DEFINIDAS_POR_EL_USUARIO[cuentaAreas].x1 > AREAS_DEFINIDAS_POR_EL_USUARIO[cuentaAreas].x2){
			aux := AREAS_DEFINIDAS_POR_EL_USUARIO[cuentaAreas].x1
			AREAS_DEFINIDAS_POR_EL_USUARIO[cuentaAreas].x1 := AREAS_DEFINIDAS_POR_EL_USUARIO[cuentaAreas].x2
			AREAS_DEFINIDAS_POR_EL_USUARIO[cuentaAreas].x2 := aux
		}
	
		if(AREAS_DEFINIDAS_POR_EL_USUARIO[cuentaAreas].y1 > AREAS_DEFINIDAS_POR_EL_USUARIO[cuentaAreas].y2){
			aux := AREAS_DEFINIDAS_POR_EL_USUARIO[cuentaAreas].y1
			AREAS_DEFINIDAS_POR_EL_USUARIO[cuentaAreas].y1 := AREAS_DEFINIDAS_POR_EL_USUARIO[cuentaAreas].y2
			AREAS_DEFINIDAS_POR_EL_USUARIO[cuentaAreas].y2 := aux
		}
		MsgBox area %cuentaAreas% a sido creada
		cuentaAreas++
		cuentaPuntos = 1
		EXISTE_AREA_DEFENIDA_POR_USUARIO := true	
	}
}

borrarAreas(){
	Global
	;Global AREAS_DEFINIDAS_POR_EL_USUARIO
	;Global EXISTE_AREA_DEFENIDA_POR_USUARIO
	AREAS_DEFINIDAS_POR_EL_USUARIO := []
	EXISTE_AREA_DEFENIDA_POR_USUARIO := false
	define_area("reset") ;para resetear la variable statica de esta funcion
}


dameArea(n){
	Global
	;si areas estan definias continuo
	;global AREAS_DEFINIDAS_POR_EL_USUARIO
	return AREAS_DEFINIDAS_POR_EL_USUARIO[n]
}


esta_color_en_area(area, color){
	Global
	;primero se tiene que comprobar que la variable area y color contienen valores validos
	;la variable color puede ser un arreglo o una cadena unico que indica un color
	if isObject(area){
		if color is xdigit
		{
			Local cX := 0
			Local cY := 0
			pixelSearch, cX, cY, area.x1,area.y1, area.x2, area.y2, color,,fast
			if(!ErrorLevel){
				return 1
			}
			else{
				return 0
			}
		}
		else{
			MsgBox Error en funcion esta_color_en_area(). El color no es valido.
			return -1
		}
	}
	else{
		MsgBox Error en funcion esta_color_en_area(). El area no es valida.
		return -1
	}
}

;version monitor de la funcion esta_color_en_area()
espera_color_en_area(area, color, ciclos := 30, frecuencia := 200){
	Global	
	if isObject(area){
		if color is xdigit
		{
			Local cX := 0
			Local cY := 0
			loop, ciclos{		
				pixelSearch, cX, cY, area.x1,area.y1, area.x2, area.y2, color,,fast
				if(!ErrorLevel){
					return 1
				}
				else{
					return 0
				}
				;sleep debe ir aqui para permitir que la primera busqueda sea instantanea y detenga el ciclo si consigue el color bucado
				sleep frecuencia
			}
		}
		else{
			MsgBox Error en funcion espera_color_en_area(). El color no es valido.
			return -1
		}
	}
	else{
		MsgBox Error en funcion espera_color_en_area(). El area no es valida.
		return -1
	}	
}