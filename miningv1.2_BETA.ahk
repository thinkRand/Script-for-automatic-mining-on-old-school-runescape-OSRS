; miningv1.2_BETA.ahk : A macro based on color detection to automate mining in the MMO OSRS.
; <<Copyright (C)  2022 Abel Granados>>

; This program is free software: you can redistribute it and/or modify it under the terms of the 
; GNU General Public License as published by the Free Software Foundation, either version 3 of 
; the License, or (at your option) any later version.

; This program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the 
; implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU General Public License 
; for more details.

; You should have received a copy of the GNU General Public License along with this program. If not, see 
; <https://www.gnu.org/licenses/>.

#NoTrayIcon 
#SingleInstance, force 
SetWorkingDir %A_ScriptDir%

#include nucleo/puntero.ahk
#include nucleo/pausas.ahk
#include nucleo/gestor_area.ahk
#include nucleo/interface_cliente.ahk
#include nucleo/gestor_indicadores.ahk
#include nucleo/link.ahk

FileEncoding , UTF-8 ;para que se reconoscan las ñ y las ´ en los archivos de texto
critical, off ; para indicar que puede ser interrumpido inmediatamente
detener := false
ciclosScript = 1000
GuiHwnd := 0 ;su contenido sera la id unica de la ventana principal
licenceAcepted := "false" ;Para saber si hay que cargar la ventana de la licencia

if FileExist("docs/config.ini")
{
	FileReadLine, licenceAcepted, docs/config.ini, 1
	if ErrorLevel
	{
		MsgBox, 0 Ha ocurrido un porblema irresoluble. El programa se cerrara.
		Exitapp
	}
}
else
{
	FileAppend , false, docs/config.ini 
	if ErrorLevel
	{
		MsgBox, 1 Ha ocurrido un porblema irresoluble. El programa se cerrara.
		Exitapp
	}
} 

;FUNCIONES INICIADORAS: INICIAN LAS GLOBALES QUE CADA #INCLUDE NECESITA
ini_link()
ini_interface_cliente()
ini_gestor_area()
ini_gestor_indicadores()

if (licenceAcepted == "false")
{
	GoSub createGuiLicencia
}
else if (licenceAcepted == "true")
{
	 GoSub createGuiInformacion
}
else
{
	MsgBox, 3 Ha ocurrido un porblema irresoluble. El programa se cerrara.
	Exitapp
}
return
;FIN DE LA SECCION AUTOEJECUTABLE






createGuiLicencia:
if FileExist("docs/copying.txt")
{
	FileRead, FileContents, docs/copying.txt
	if ErrorLevel
	{
		MsgBox, 4 Ha ocurrido un porblema irresoluble. El programa se cerrara.
		Exitapp
	}
}
else
{
	MsgBox, 5 Ha ocurrido un porblema irresoluble. El programa se cerrara.
	Exitapp
}
Gui, Licencia:New, -Resize +MinimizeBox -MaximizeBox +HwndGuiHwnd , Mining_v1.2_BETA Licencia
Gui, Licencia:Add, edit, vEditLicencia readOnly w600 h400, %FileContents% . `n`n
FileContents := "" ;Libero el espacio en memoria porque no usare mas esta variable, me gustaria eliminarla totalmente.
Gui, Licencia:Add, Button, w64 h32 xm gbAceptar  , Aceptar
Gui, Licencia:Show, NoActivate
return 



WatchCursor(){
	Local
	Global GuiHwnd	
	MouseGetPos, , , id, control
	if (GuiHwnd == id){ ;Solo cuando el mouse este sobre la ventana
		
		 If (control == "Static1" ||control == "Static2"||control == "Static3"||control == "Static4"){
		 	onPicHover(control)
		 }else{
		 	onPicHoverOff()
		 }
	}
}

bAceptar:
	Gui, Licencia:Destroy
	FileDelete, docs/config.ini
	FileAppend , true, docs/config.ini, 
	if ErrorLevel
	{
		MsgBox, Ha ocurrido un porblema irresoluble. El programa se cerrara.
		Exitapp
	}
	GoSub, createGuiInformacion
return


createGuiInformacion:
if FileExist("docs/informacion.txt")
{
	FileRead, FileContents, docs/informacion.txt
	if ErrorLevel
	{
		MsgBox, Ha ocurrido un porblema irresoluble. El programa se cerrara.
		Exitapp
	}
}
else
{
	MsgBox, Ha ocurrido un porblema irresoluble. El programa se cerrara.
	Exitapp
}
	Gui, informacion:New, -Resize +MinimizeBox -MaximizeBox +HwndGuiHwnd, Informacion
	Gui, Color, 0x22262A, 0x393F46
	Gui, Font , , Verdana
	Gui, informacion:add, Edit,0x80 ReadOnly w600  h240 Wrap cCCCCCC VScroll ,  %FileContents%
	link_addAsGroupBox("informacion")
	Gui, informacion:show, NoActivate
	SetTimer, WatchCursor, 100 ;El rastreador del mouse es necesario todo el tiempo
return




return


;Funcion principal. Se encarga de la logica de la minerìa.
minar(){
	Global
	static primeraEjecucion := true
	if primeraEjecucion{
		CARGAR_INTERFACE_INVENTARIO_NORMAL()
		primeraEjecucion := false
	}

	if EXISTE_INVENTARIO_NORMAL{
		if EXISTE_AREA_DEFENIDA_POR_USUARIO{
			Local rocasDefinidasPorElUsuario := AREAS_DEFINIDAS_POR_EL_USUARIO ; un alias para manejo logico
			static rocasIdentificadas := [] ;
			;hay que identificar las rocas definidas por el usuario
			;esto solo se hace hasta que se consigue que todas las areas se identifiquen
			if (rocasIdentificadas.length() = 0){
				rocasIdentificadas := identificarRocas(rocasDefinidasPorElUsuario)
			}
			;El siguiente if verifica que la cantidad de rocas identificadas es igual al total de rocas, para verificar que todas las rocas fueron identificadas
			if (rocasIdentificadas.length() == rocasDefinidasPorElUsuario.length()){
				;hay por lo menos un area  que contiene un mineral reconocido
				detener := false ;me aseguro de que detener sea false cuando se empesara a minar, aunque puede no ser necesario
				Local cantidadRocas := rocasIdentificadas.length()
				static cantidadRocasMinadas := 0
				Local rocaActual := 0
				Random rocaActual, 1, cantidadRocas
				;indicador para la celda 28, usado para saber cuando botar, es defisiente, pero funciona.
				;INVENTARIO_NORMAL es el inventario que se creo, primero se tiene que recuperar del arreglo GLOBAL
				Local celda28ind := {x:INVENTARIO_NORMAL.celda[28].x + 16, y:INVENTARIO_NORMAL.celda[28].y + 16, color:INVENTARIO_NORMAL.colorBase} 
				; sleep 4000
				; MouseMove, celda28ind.x, celda28ind.y
				; 			Tooltip, indicando celda 28 como parte de una prueba.
				; 			sleep 4000
				; 			Tooltip, % "El color del indicador es: " . celda28ind.color
				; 			sleep 8000
				; 			Tooltip
				if(MSG_DEBUG){	
					MsgBox Se seleccionaron %cantidadRocas% piedra(s)
				}
				loop, %ciclosScript%{
					Local hayMineral := esta_color_en_area(AREAS_DEFINIDAS_POR_EL_USUARIO[rocaActual], rocasIdentificadas[rocaActual].indicador.color)
					if(hayMineral){
						punteroA(AREAS_DEFINIDAS_POR_EL_USUARIO[rocaActual])
						pausaBaja()
						Click
						Local minado := espera_indicador_cambio(rocasIdentificadas[rocaActual].indicador)
						; Tooltip, minado!
						; sleep 200
						; Tooltip
						; ;detectar cuando la piedra se le acabo el mineral, eso quiere decir que mino o que alguien se la robo
						if(minado = 1){
							; MouseMove, celda28ind.x, celda28ind.y
							; Tooltip, indicando celda 28 como parte de una prueba.
							; sleep 4000
							; Tooltip, % "El color del indicador es: " . celda28ind.color
							; sleep 8000
							; Tooltip
							; return
							if(indicador_cambio(celda28ind) = 1){
								; Tooltip, celda 28 está llena.
								; sleep 200
								; Tooltip
								botarObjetosInventarioNormal(2,28,1)
							}else{
								; Tooltip, celda 28 no ha cambiado
								; sleep 200
								; Tooltip
							
							}
							if(rocaActual = cantidadRocas){
								rocaActual := 1
							}
							else{
								rocaActual++
							}
						}
						else{
							MsgBox El script no ha detectado una extracion de mineral por un largo tiempo. El script se detendra.
							break
						}
						
						if(detener){
							MsgBox El script se detubo con exito
							rocasIdentificadas := []
							break
						}
					}
					else{
						sleep RAPIDEZ
						if(rocaActual = cantidadRocas){
							rocaActual := 1
						}
						else{
							rocaActual++
						}
					}
					
				} ;fin del loop
			
			}
			else{
				MsgBox,No se pudo identificar a todas las rocas. No se puede continuar hasta que todas las rocas sean identificadas.
				return 0
			}
		}
		else {
		  ;esto si es parte de la logica de la mineria. Si no hay un area no se tiene donde minar
		  MsgBox No se ha definido una roca para minar. Defina el area que ocupa una roca para empesar a minarla.
		}
	}
	else{
		primeraEjecucion := true ;esto hara que se intente definir nuevamente el inventario
	}
} ;fin de la funcion minar


;///////////////////////////////////////////
;Las rocas deben conservar el orden que traen con su Index, area1 es pareja de roca1
identificarRocas(rocasDefinidasPorElUsuario)
{
	Global
	Local rocasIdentificadas := []
	Local intentos = 0
	Local aux := 0
	loop
	{
		loop, % rocasDefinidasPorElUsuario.length(){
			aux := identificarRoca(rocasDefinidasPorElUsuario[A_index])	
			if (aux = 0){
				;MsgBox Ningun mineral hallado en el area %A_index%. No se puede continuar hasta que todas las rocas sean identificadas. Intente denuevo.
				;break
			}
			else{
				;en caso contrario la roca se identifico correctamente y se continua con la siguiente.
				rocasIdentificadas[A_index] := aux
			}
		}
		
		if (rocasIdentificadas.length() == rocasDefinidasPorElUsuario.length())
		{
			return rocasIdentificadas
		}
		else{
			if (intentos > 40)
			{
				return rocasIdentificadas
			}
			intentos++	
		}
	}
} ;fin de funcion

;//////////////////////////////////////////77
detener(){
	Global
	detener := true
}





!v::
	mostrarOcultarInventario()
return
!a::
	define_area()
return
!p::
	pause
return
!i::
	minar()
return
!d::
	detener()
return
!r::
	detener()
	borrarAreas()
	MsgBox, Las areas se han reseteado.
return

!c::
	; MsgBox, 0 El script esta apunto de cerrarce
	Exitapp
return

;OnExit("FuncName")

GuiClose:
	; MsgBox, 2 El script esta apunto de cerrarce
	Exitapp
return

informacionGuiClose:
	; MsgBox, 1 El script esta apunto de cerrarce
	Exitapp
return