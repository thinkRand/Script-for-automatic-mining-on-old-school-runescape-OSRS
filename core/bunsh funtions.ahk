
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



;en lugar de definir inventario puede ser llamada crear_inventario y que devuelva un objeto inventario, las condiciones para que funcione asi es que la ventana tenga un rango permitido de tamanio y este en runelite
;quisas esta funcion solo necesite  el tipo de interface que se desea crear, la hwnd es un aglobal en CURRENT_WINDOW 
;/////////////////////////////////////////////////////////////////
defineAreaInterface(tipoInterface){
	Global
	;Global CURRENT_WINDOW
	;hay que validar el contenido de las variables qu entran aqui
	if CURRENT_WINDOW != 0
	{
		if CURRENT_WINDOW is xdigit
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


;//////////////////////////////////////////////
showCells(inventario)
{
	Global
	loop, % inventario.cells.length()
	{
			;MsgBox Se mostrara la cells %A_index%
			Box_Draw(inventario.cells[A_index].pos.x, inventario.cells[A_index].pos.y, inventario.cells[A_index].width, inventario.cells[A_index].alto)
	}	
}


Box_Draw_R(X, Y, W, H, ventanaPadre := 1) {
  Global
 ; No longer adding to the height since using only a single rectangle
  If(W < 0)
    X += W, W *= -1
  If(H < 0)
    Y += H, H *= -1
  Gui, New
  ;se puede usar +Parent y +Owner para hacer que una venta sea hija de otra
  ;MsgBox % ventanaPadre
  WinGetPos, vX, vY, vAncho, vLargo,ahk_id %ventanaPadre%
  Gui,+E0x20 +ToolWindow -Caption +AlwaysOnTop +LastFound
  ; Set window to 50% transparency
  WinSet,Transparent,128
  Gui,Color, 0xFF0000
  X += vX
  Y += vY
  Gui, Show, % "x"X " y"Y " w" W " h" H " NA"
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



link_addAsNewGui(){
	Local
	Static controlPicDiscord := 0 ,controlPicBinance := 0,controlPicMetamask := 0,controlPicGMail := 0
	Gui, links:new, 
	Gui, links:Add, GroupBox, cWhite, Enlaces a Donaciones y Contactos
	
	Gui, links:Add,Picture,xp+5 yp+15 w40 h40 gcontentToClipboard vcontrolPicDiscord, %A_WorkingDir%/img/discord_logo_48.png
	Gui, links:Add,Picture,xp+45 yp w40 h40 gcontentToClipboard vcontrolPicBinance, %A_WorkingDir%/img/bnb_logo_48_3.png
	Gui, links:Add,Picture,xp+45 yp w40 h40 gcontentToClipboard vcontrolPicMetamask, %A_WorkingDir%/img/metamask_logo_48_3.png
	Gui, links:Add,Picture,xp+45 yp w40 h40 gcontentToClipboard vcontrolPicGMail, %A_WorkingDir%/img/gmail_logo_48.png
	Gui, links:show


}
