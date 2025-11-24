function scr_outline(_type = 0, _sprite = sprite_index, _image = image_index, _x = x, _y = y, _xScale = image_xscale, _yScale = image_yscale, _angle = image_angle, _col = col, _alpha = image_alpha, _colBlack = c_black) {
	if _type == 0 {
		draw_sprite_ext(_sprite, _image, _x + 1, _y, _xScale, _yScale, _angle, _col, _alpha);
		draw_sprite_ext(_sprite, _image, _x - 1, _y, _xScale, _yScale, _angle, _col, _alpha);
		draw_sprite_ext(_sprite, _image, _x, _y + 1, _xScale, _yScale, _angle, _col, _alpha);
		draw_sprite_ext(_sprite, _image, _x, _y - 1, _xScale, _yScale, _angle, _col, _alpha);
	} else {
		draw_sprite_ext(_sprite, _image, _x + 2, _y, _xScale, _yScale, _angle, _col, _alpha);
		draw_sprite_ext(_sprite, _image, _x + 1, _y - 1, _xScale, _yScale, _angle, _col, _alpha);
		draw_sprite_ext(_sprite, _image, _x, _y - 2, _xScale, _yScale, _angle, _col, _alpha);
		draw_sprite_ext(_sprite, _image, _x - 1, _y - 1, _xScale, _yScale, _angle, _col, _alpha);
		draw_sprite_ext(_sprite, _image, _x - 2, _y, _xScale, _yScale, _angle, _col, _alpha);
		draw_sprite_ext(_sprite, _image, _x - 1, _y + 1, _xScale, _yScale, _angle, _col, _alpha);
		draw_sprite_ext(_sprite, _image, _x, _y + 2, _xScale, _yScale, _angle, _col, _alpha);
		draw_sprite_ext(_sprite, _image, _x + 1, _y + 1, _xScale, _yScale, _angle, _col, _alpha);
		
		if _type == 1 { //draw black too
			draw_sprite_ext(_sprite, _image, _x + 1, _y, _xScale, _yScale, _angle, _colBlack, _alpha);
			draw_sprite_ext(_sprite, _image, _x - 1, _y, _xScale, _yScale, _angle, _colBlack, _alpha);
			draw_sprite_ext(_sprite, _image, _x, _y + 1, _xScale, _yScale, _angle, _colBlack, _alpha);
			draw_sprite_ext(_sprite, _image, _x, _y - 1, _xScale, _yScale, _angle, _colBlack, _alpha);
		}
	}
}

