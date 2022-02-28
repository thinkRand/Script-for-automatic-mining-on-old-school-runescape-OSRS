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



;la funcion de inicio se encargara de cargar las globales
ini_detectar_entorno(){
	Global
	VENTANA_EN_USO := 0
	NOMBRE_PROCESO_EN_USO := ""
	EXISTE_ENTORNO:= false
}

;comprueba si la venta  es valida y devuelve el process id si lo es, devuelve 0 si no es valida
detectarEntorno(){
	;ini_detectar_entorno() esto me parece mejor jajajaj
	Global	
	;Global VENTANA_EN_USO
	;Global NOMBRE_PROCESO_EN_USO
	;Global EXISTE_ENTORNO
	Local hwndActiva := WinExist("A")
	;WinGet, nombreProceso , ProcessName, A es valido tambien
	WinGet, nombreProceso , ProcessName, ahk_id %hwndActiva%
	winGetTitle, vTitle, ahk_id %hwndActiva%
	;nombreProceso == runelite.exe no funciona por alguna razon que desconosco
	if (nombreProceso = "RuneLite.exe"){	
		MsgBox La ventana %vTitle%  del proceso %nombreProceso% ha sido seleccionada para operar con el script
		VENTANA_EN_USO := hwndActiva
		NOMBRE_PROCESO_EN_USO := nombreProceso
		EXISTE_ENTORNO := true
	}
	else if (nombreProceso = "OldSchoolClient.exe"){
		VENTANA_EN_USO := hwndActiva
	}
	else if (nombreProceso = "Osbuddy.exe"){	
		VENTANA_EN_USO := hwndActiva
	}
	else{
		MsgBox la ventana %vTitle% del proceso %nombreProceso% no es valida.
		;esta funcion no retorna nada
	}
}








