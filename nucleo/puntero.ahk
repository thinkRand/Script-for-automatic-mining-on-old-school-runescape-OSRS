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


punteroA(area, bordeInterno := 0, rapidez := 15)
{	
	Global
	Local x = 0
	Local y = 0


	Random, x, area.x1+bordeInterno, area.x2-(bordeInterno*2)
	Random, y, area.y1+bordeInterno, area.y2-(bordeInterno*2)
	
	MouseMove x, y, rapidez
}


