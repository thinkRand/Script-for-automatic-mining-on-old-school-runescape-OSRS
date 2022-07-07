
boxHwnd := ""

boxDraw(X:=0, Y:=0, W:=0, H:=0, bName := "inv") {
  Global boxHwnd
  If(W < 0)
  X += W, W *= -1
  If(H < 0)
  Y += H, H *= -1
  Gui, bName:New
  Gui,+E0x20 +ToolWindow -Caption +AlwaysOnTop +LastFound HwndboxHwnd
  WinSet,Transparent,128 ; Set window to 50% transparency
  Gui, Color, 0xFF0000
  Gui, Show, x%X%  y%Y% w%W% h%H% 
}

boxDestroy(){
  Global
  WinClose, ahk_id %boxHwnd% 
}

