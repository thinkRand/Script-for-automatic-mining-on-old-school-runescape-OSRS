
Box_Draw(X, Y, W, H, guiNombre := "") {
	Global
	
	If(W < 0)
	X += W, W *= -1
	If(H < 0)
	Y += H, H *= -1
	Gui, guiNombre:New
	Gui,+E0x20 +ToolWindow -Caption +AlwaysOnTop +LastFound 
	; Set window to 50% transparency
	WinSet,Transparent,128
	Gui,Color, 0xFF0000
	Gui, Show, x%X%  y%Y% w%W% h%H% NA
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

Box_Destroy(){
  Gui, Destroy
}

