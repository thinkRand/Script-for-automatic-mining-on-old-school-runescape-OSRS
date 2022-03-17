﻿; <<Copyright (C)  2022 Abel Granados>>

; This file is part of miningv1.2_BETA
; This program is free software: you can redistribute it and/or modify it under the terms of the 
; GNU General Public License as published by the Free Software Foundation, either version 3 of 
; the License, or (at your option) any later version.

; This program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the 
; implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU General Public License 
; for more details.

; You should have received a copy of the GNU General Public License along with this program. If not, see 
; <https://www.gnu.org/licenses/>.

;To represent an afk or distracted player.
delayLong(increment:=0)
{
	Local
	t := 0 ;time
	Random t, 800, 1200
	Sleep t+increment
}

;To represent an occasionally distraction
delayMid(increment:=0)
{		
	Local
	t := 0 ;time
	Random t, 400, 800
	Sleep t+increment
}

;To represent the usual speed that an average player have. I only based on self proof.
delayShort(increment:=0)
{
	Local
	t := 0 ;time
	Random t, 250, 400
	Sleep t+increment
}

;To represent a hurry player, the speed when he is really concentrated
delayMin(increment:=0)
{
	Local
	t := 0 ;time
	Random t, 40, 100
	Sleep t+increment
}

;Well, the delays are based on self proof, i did some evaluations on my speed. 
;I do not know how to get sufficient data to determine what are the corrects 
;delays of a palyer when he is hurry, distracted or in average etc.  I will like to know how can i do it.