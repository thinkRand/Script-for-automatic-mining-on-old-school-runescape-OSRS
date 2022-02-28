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

	
pausaAlta(incremento:=0)
{
	Global
	Local time := 0
	Random time, 800, 1200
	Sleep time+incremento
}

pausaMedia(incremento:=0)
{		
	Global
	Local time := 0
	Random time, 400, 800
	Sleep time+incremento
}

pausaBaja(incremento:=0)
{
	Global
	;Tooltip, pausa baja bro
	;sleep 50	
	
	Local time := 0
	Random time, 250, 400
	Sleep time+incremento
}

pausaMin(incremento:=0)
{
	Global
	Local time := 0
	Random time, 40, 100
	Sleep time+incremento
}