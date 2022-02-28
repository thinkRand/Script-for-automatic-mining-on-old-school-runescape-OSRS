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



#include nucleo/datos_runescape.ahk

ini_gestor_indicadores(){
	ini_datos_r()
}

;////////////////////////////////////////////7
detectarQueHay(area, modo:= ""){
	Global
	;si modo es blank se ejecutan todas las busquedas
	;los modos son roca, arbol, pez, gema,
	if isObject(area){
		switch modo{
			case "":
				MsgBox Modo de busqueda completa.
				return 1
			case "roca": 
				;Global ROCA
				loop, % _ROCA.length(){
					pixelSearch, cX, cY, area.x1,area.y1, area.x2, area.y2, _ROCA[A_Index].color,,fast
					if(!ErrorLevel){
						msgBox % "Detectado " _ROCA[A_Index].nombre
						return {contenido:_ROCA[A_Index], indicador:{x:cX, y:cY, color:_ROCA[A_Index].color}}
					}
					else{	
						;buscar de nuevo hasta conseguirlo
						MsgBox % _ROCA[A_Index].nombre " no detectado"
						;siguiente color a buscar
						;en caso de que sehalla buscado todo en el array _ROCA entoces lanzar un msj diciendo no se reconoce ningun color de una _ROCA
					}
				}
				
				MsgBox Ningun mineral hallado en el area evaluada
				return 0
			case "pez": 
				detectarPez()
				return
			case "arbol": 
				detectarArbol()
				return
			;Default:
				;MsgBox Erro en funcion detectarQueHay(). El modo escogido no esta permitido.
			;return -1
		}
	}
	else{
		MsgBox Error en funcion detectarQueHay(). El area no es valida.
		return -1
	}
}

;////////////////////////////
identificarRoca(area){
	Global
	loop, % _ROCA.length(){
		;MouseMove, area.x1,area.y1
		;Sleep 1000
		;MouseMove, area.x2,area.y2
		pixelSearch, cX, cY, area.x1,area.y1, area.x2, area.y2, _ROCA[A_Index].color,,fast
		if(ErrorLevel = 0){
			; msgBox % "Detectado " _ROCA[A_Index].nombre
			return {nombre:_ROCA[A_Index].nombre, color:_ROCA[A_Index].color, materialColor:_ROCA[A_Index].materialColor, indicador:{x:cX, y:cY, color:_ROCA[A_Index].color}}
		}
		else{	
			;buscar de nuevo hasta conseguirlo
			;MsgBox % _ROCA[A_Index].nombre " no detectado .err" ErrorLevel
			;siguiente color a buscar
			;en caso de que sehalla buscado todo en el array roca entoces lanzar un msj diciendo no se reconoce ningun color de una roca
		}
	}
	
	;MsgBox Ningun mineral hallado en el area evaluada
	return 0
}

;/////////////////////////////////////////////
;evalua si un inidcador cambio de color
indicador_cambio(indicador){
	Global
	PixelGetColor colorActual, indicador.x, indicador.y
	if !ErrorLevel{
		if(indicador.color != colorActual){
			return 1
		}
		else{
			return 0
		}
	}
	else{
		return -1
	}
}

;////////////////////////////////////////////////////////////
;evalua un indicador por un periodo de tiempo establecido, esperando que cambie
espera_indicador_cambio(indicador,  ciclos := 100 , frecuencia := 200){	
	Global
	;primero se debe comprobar que la variable indicador contiene un indicador correcto
	loop, %ciclos%{
		; tooltip, ciclo %A_Index%
		PixelGetColor colorActual, indicador.x, indicador.y
		if !ErrorLevel {
			if indicador.color != colorActual{
				; Tooltip
				return 1
			}
			else{	
				;si sleep esta aqui la primera busqueda se hace rapidamente, de manera que se puede detectar al instante mismo de iniciar la funcion
				Sleep, % frecuencia
			}
		}
		else{
			;continua
		}
		;Sleep, 50
	}
	;Tooltip, y frec como es? = frecuencia y cual es el valor %frecuencia%, y cuantos cic %ciclos%
	return 0
}
;////////////////////////////
detectarPez(){
	Global
	MsgBox "funcion detectar pez"
}
;////////////////////////////
detectarArbol(){
	Global
	MsgBox "funcion detectar arbol"
}

