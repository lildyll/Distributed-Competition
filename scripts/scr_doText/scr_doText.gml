// Script assets have changed for v2.3.0 see
// https://help.yoyogames.com/hc/en-us/articles/360005277377 for more information
function scr_doText(_text = "", _col1 = col, _x = x, _y = y, _spacing = spacing, _lineSpacing = 8, _bloomStart = 1, _bloomSpd = -200, _bloomSpread = .5, _bloomAmp = .5, _size = 1, _center = true) {
	_text = string_upper(_text);
	var xx = 0;
	var _line = 0;
	var _lOffset = 1;
	var _e = 0;
	var letter = -1;
	var l = 0;
	
	var _scale = _bloomStart;
	_e = string_length(_text);
	
	if _center _x -= (_e * _spacing * _size)/2; //center it
	
	for (l = 1; l <= _e; l++) { //l is defined up there so i can return it
		var _draw = true;
		letter = string_char_at(_text,l);
		if letter == "\\" {
			//check the next character to see special shit
			
		} else if letter == "~" and string_char_at(_text,l-1) != "\\" { //new line
			_line++;
			_lOffset = 1;
			xx = 0;
			_draw = false;
		} else {
			var lValue = ord(letter);
			var yy = 0 + (_line * _lineSpacing);
			if (string_char_at(_text,l-1) == "M" or string_char_at(_text,l-1) == "W") and (letter != " " )/*and _lOffset != 1*/ {
				xx += 2;
			} 
			if letter == " " {
				_draw = false;
			} else if letter == "+" {
				lValue = A + 26;
			} else if letter == "-" {
				lValue = A + 27;
			} else if letter == "!" {
				lValue = A + 28;
			} else if letter == "/" {
				lValue = A + 29;
			} else if letter == "'" {
				lValue = A + 30;
			} else if letter == "?" {
				lValue = A + 31;
			} else if letter == ":" {
				lValue = A + 32;
			} else if letter == "(" {
				lValue = A + 33;
			} else if letter == ")" {
				lValue = A + 34;
			} else if letter == "." {
				lValue = A + 35;
			}
			
			if _draw {
				var _wave = sin(current_time / _bloomSpd + l * _bloomSpread) * _bloomAmp + _bloomStart;
				if lValue >= ZERO and lValue < A { //numbers
					draw_sprite_ext(spr_number,lValue-ZERO,_x + ((_lOffset + 0) * _spacing * _size) + xx,_y+yy,_wave * _size,_wave * _size,image_angle,_col1,image_alpha);
				} else { //alphabet
					draw_sprite_ext(spr_alpha,lValue-A,_x + ((_lOffset + 0) * _spacing * _size) + xx,_y+yy,_wave * _size,_wave * _size,image_angle,_col1,image_alpha);
				}
			}
			_lOffset++;
		}
	}
	return l;
}