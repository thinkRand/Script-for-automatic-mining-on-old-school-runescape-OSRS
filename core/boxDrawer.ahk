
boxesIds := []

boxDraw(X:=0, Y:=0, W:=0, H:=0) {

  Global boxesIds

  If(W < 0)
  X += W, W *= -1
  If(H < 0)
  Y += H, H *= -1
  
  WinGetPos, wx, wy,,, A
  X+=wx
  Y+=wy
  
  Gui, New, +E0x00000020 +E0x08000000 -Caption +AlwaysOnTop -LastFound HwndboxHwnd
  Gui, %boxHwnd%:Color, 0x00FF00
  Gui, %boxHwnd%:Show, x%X%  y%Y% w%W% h%H% NA
  WinSet, Transparent, 255 , ahk_id %boxHwnd%
  WinSet, Region, % "0-0 " W "-0 " W "-" H " 0-" H " 0-0 2-2 " W-2 "-2 " W-2 "-" H-2 " 2-" H-2 " 2-2", ahk_id %boxHwnd%

  boxesIds.push(boxHwnd)

}

boxDrawAll(){

  Global boxesIds
    loop, % boxesIds.Count() {
      boxId := boxesIds[A_Index]
      Gui, %boxId%:Show, NA
    }

}

boxHideAll(){

  Global boxesIds
  loop, % boxesIds.Count(){
    boxId := boxesIds[A_Index]
    Gui, %boxId%:Hide
  }

}


;Shows a red-transparent gui where the inventory is, to see its position
boxToggleAll() {
  
  static visible := true
  
    if (visible) {
    
      boxHideAll()
      visible := false
    
    }else{

      boxDrawAll()
      visible := true
    }

}