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



#include nucleo/gui_caja.ahk
#include nucleo/detectar_entorno.ahk
#include nucleo/pausas.ahk
#include nucleo/puntero.ahk


;scrip para definir las interfaces y sus funciones. Un ejemplo es el inventario de items.


ini_interface_cliente(){
	Global
	EXISTE_INVENTARIO_NORMAL := false ; p1or defecto no se carga el inventario normal
	INVENTARIO_NORMAL := 0
	ini_detectar_entorno()
}

;en lugar de definir inventario puede ser llamada crear_inventario y que devuelva un objeto inventario, las condiciones para que funcione asi es que la ventana tenga un rango permitido de tamanio y este en runelite
;quisas esta funcion solo necesite  el tipo de interface que se desea crear, la hwnd es un aglobal en VENTANA_EN_USO 
;/////////////////////////////////////////////////////////////////
defineAreaInterface(tipoInterface){
	Global
	;Global VENTANA_EN_USO
	;hay que validar el contenido de las variables qu entran aqui
	if VENTANA_EN_USO != 0
	{
		if VENTANA_EN_USO is xdigit
		{
			if tipoInterface != ""
			{						
				if (tipoInterface = "inventario1")
				{
					return CARGAR_INTERFACE_INVENTARIO_NORMAL()
				}
				else if (tipoInterface = "inventario2")
				{
					MsgBox La creacion de inventario tipo 2 no es soportada por ahora
					return 0
				}
				else if (tipoInterface = "inventario3")
				{
					MsgBox La creacion de inventario tipo 3 no es soportada por ahora
					return 0
				}
				else 
					{
						MsgBox El tipo de interface %tipoInterface% no es reconocido
						return 0
					}
			}
			else
			{
				MsgBox Erro en funcion defineAreaInterface(). El parametro TipoInterface esta vacio.
			}
		}
		else
		{
			MsgBox Erro en funcion defineAreaInterface(). La id de ventana no es valida.
			return -1
		}
	}
	else
	{
		MsgBox Erro en funcion defineAreaInterface(). El valor de ventana esta vacio.
		return -1
	}

		
} ;fin de la funion


CARGAR_INTERFACE_INVENTARIO_NORMAL()
{
	Global
	detectarEntorno()
	;Global EXISTE_ENTORNO
	;Global VENTANA_EN_USO
	;Global NOMBRE_PROCESO_EN_USO
	;Global INVENTARIO_NORMAL
	
	if EXISTE_ENTORNO
	{
		;Global EXISTE_INVENTARIO_NORMAL
		;el 100% de los casos NOMBRE_PROCESO_EN_USO es un tipo de cliente valido
		switch (NOMBRE_PROCESO_EN_USO)
		{
			case "RuneLite.exe":
				;me aseguro de que la ventana este activa
				WinActivate, ahk_id %VENTANA_EN_USO%
				;detecto las coordenadas del control que contiene el cliente runescape en RuneLite, llamado SunAwtCanvas2. La ventana de runelite tine class SunAwtFrame
				
				ControlGet, Control, Hwnd, , SunAwtCanvas2, ahk_id %VENTANA_EN_USO%
				If(ErrorLevel)
				{
					Tooltip, no se puedo cargar el contenedor del cliente osrs wtf!
					sleep 2000
					Tooltip
				}
				ControlGetPos, X, Y, anchoControl, altoControl, , ahk_id %Control%
				Local posInventarioControl := {x:anchoControl-204, y:altoControl-311}
				Local posInventarioWindow := {x:(posInventarioControl.x+X), y:(posInventarioControl.y+Y), ventanaPadre:VENTANA_EN_USO}
				Local celdas := {}
				Local caracteristicasCelda := {ancho:32,alto:32 ,margenArriba:4, margenIzquierdo:10}
				Local inventarioCaracteristicas := {margenInternoIzq:13, margenInternoArr:11}
			
				;creo la pos de cada celda del inventario
				Local x1 := posInventarioWindow.x+inventarioCaracteristicas.margenInternoIzq
				Local y1 := posInventarioWindow.y+inventarioCaracteristicas.margenInternoArr
				Local count := 1
				Local y2 := 0
				Local x2 := 0
				;7 filas
				loop, 7
				{	
					y1 := y1 + caracteristicasCelda.margenArriba
					y2 := y1 + caracteristicasCelda.alto
					;4 columnas
					loop, 4
					{
						x1 := x1 + caracteristicasCelda.margenIzquierdo
						x2 := x1 + caracteristicasCelda.ancho
						;x1+1 1 pixel dentro de la casilla x2-2 2 pixelses meno del borde derecho
						celdas[count] := {x:x1, y:y1, area:{x1:x1, y1:y1, x2:x2, y2:y2}, ancho:caracteristicasCelda.ancho, alto:caracteristicasCelda.alto}
						x1 := x2
						count++
					}
					
					y1 := y2
					x1 := posInventarioWindow.x+inventarioCaracteristicas.margenInternoIzq
				}
				
				;retorno el inventario
				INVENTARIO_NORMAL :=  {x:posInventarioWindow.x, y:posInventarioWindow.y, celda:celdas, colorBase:"0x29353E", ventanaPadre:posInventarioWindow.ventanaPadre}
				EXISTE_INVENTARIO_NORMAL := true
				return true ;hay una funcion que usa el return CARGAR_INTERFACE_INVENTARIO_NORMAL()
			case "OSbuddy.exe":
			return
			case "OldSchool.exe":
			return
		}
	}
	else
	{
		MsgBox Error. No se puede cargar la interface inventariNormal hasta que el entorno este definido.
		Return 0 ;hay una funcion que usa el return CARGAR_INTERFACE_INVENTARIO_NORMAL()
		;return 0 esta funcion no devuelve nada
	}
	
} ;fin de defineAreaInventario1()


;//////////////////////////////////////////////
;debe ser inventarioNormal.botarItems(inicio, final, salto)
botarObjetosInventarioNormal(inicio, final, salto:=1)
{
	Global		
	;evitar que el script comience un ciclo de minado sin antes ver que no quede nada en el inventario 28. Esto sirve para evitar que un error al botar los items cree otra repeticion de botado de items.
	;tengo qu ehaberiguar por que pasa eso.
	;Global EXISTE_INVENTARIO_NORMAL
	;Global INVENTARIO_NORMAL
	;no necesito comprobar el estado del invenatrio normal porque fue definido con precausion y completamente seguro que su estado es optimo
	if EXISTE_INVENTARIO_NORMAL
	{	
		Local i := inicio
		;inicio-1 para incluir la posicion inicial en el listado de items a tirar
		Send {Shift down} ; presiona shift
		loop, % final-(inicio-1)
		{
			punteroA(INVENTARIO_NORMAL.celda[i].area, 1)
			Click
			pausaMin()
			i++
		}
		sleep 20 ;para prebenir que deje la celda 28 con un item 
		Send {Shift UP} ;libera shift
	}
	else
	{
		MsgBox Error en funcion botarInventario(). La interface INVENTARIO_NORMAL no esta definida.
		return 0
	}
	
	

}


;//////////////////////////////////////////////
mostrar_casillas(inventario)
{
	Global
	loop, % inventario.celda.length()
	{
			;MsgBox Se mostrara la celda %A_index%
			Box_Draw(inventario.celda[A_index].pos.x, inventario.celda[A_index].pos.y, inventario.celda[A_index].ancho, inventario.celda[A_index].alto)
	}	
}
	
;/////////////////////////////////////////////////
;muestro o oculta las guis del inventario
; solo debe funcionar si un invenatio normal est definido, para hacer eso no es necesario recibir el parametro inventario
mostrarOcultarInventario()
{
	Global
	;Global EXISTE_INVENTARIO_NORMAL
	;Global INVENTARIO_NORMAL

	if EXISTE_INVENTARIO_NORMAL
	{
		static activo := false
		if !activo
		{
			activo := true
			Box_Draw(INVENTARIO_NORMAL.x, INVENTARIO_NORMAL.y, 200, 300 , "inventarioNormalArea")
		}
		else
		{
			activo := false
			Box_Destroy()
		}
	}
	else
	{
		MsgBox, Error en funcion mostrar_ocultar_inventarioNormal(). La interface inventarioNormal no esta definida.
	}
} ;fin de funcion

	
;inicia todas las interfaces, para cargar las interfaces se necesita saber la ventana en la que se opera. Por esa razon se debe iniciar solo cuando se tenga esa informacion.
;por otro lado, las interfaces deden iniciarce antes de iniciar el scrip de mineria.
CARGAR_INTERFACES_CLIENTE()
{
	Global
		;si no se describe que interfaces se usaran se asume que se quieren cargar todas las interfaces 
		CARGAR_INTERFACE_INVENTARIO_NORMAL()
		;CARGAR_INTERFACE_INVENTARIO_BANCO()
		;CARGAR_INTERFACE_BARRA_CHAT()
		;CARGAR_INTERFACE_BARRA_NORMAL()
		;CARGAR_INTERFACE_MINIMAPA()
}


