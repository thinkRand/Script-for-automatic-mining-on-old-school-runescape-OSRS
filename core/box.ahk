ini_box(){
  Global
  boxHwnd := ""
}

ini_box()


boxDraw(X, Y, W, H, bName := "inv") {
  Local
  Global boxHwnd
  If(W < 0)
  X += W, W *= -1
  If(H < 0)
  Y += H, H *= -1
  Gui, bName:New
  Gui,+E0x20 +ToolWindow -Caption +AlwaysOnTop +LastFound HwndboxHwnd
  ; Set window to 50% transparency+
  WinSet,Transparent,128
  Gui,Color, 0xFF0000
  Gui, Show, x%X%  y%Y% w%W% h%H% NA
}

boxDestroy(){
  Global
  WinClose, ahk_id %boxHwnd% 
}

