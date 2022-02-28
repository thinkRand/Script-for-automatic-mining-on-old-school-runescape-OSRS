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



;puede ser un objeto lista con una funcion siguiente()
siguienteNumeroEnLista(minimo, actual, maximo)
{		
	;minimo, actual y maximo debe ser enteros positivos
	; si minimo es 0, se ara return 0 es varias condiciones, sera algun error?
	if maximo > minimo
	{
		if actual < maximo
			return actual+1
		else if actual == maximo
			return minimo
	}
	else if minimo == maximo or actual == maximo ; en el caso en que minimo es igual maximo siempre se cumple que actual es iagual a ambos
		return minimo
	else
		return  ;retorna vacio  _blank
}