draw_self();

scr_doText("Options", c_white, x - 2, y - topHeight, 6, 8, 1, 1, 0, 0, 1);

for (var s = 0; s < array_length(selections); s++) {
	var _sep = 14 + (16 * s);
	var _xSep = 2;
	if s == 1 _xSep += 2;
	if selection == s {
		scr_doText(selections[s], col, x - _xSep, y - topHeight + _sep, 6, 8, 1, -300, .5, .25, 1);
	} else {
		scr_doText(selections[s], c_white, x - _xSep, y - topHeight + _sep, 6, 8, 1, 1, 0, 0, 1);
	}
}
draw_sprite_ext(spr_options_selection, image_index, x, y, image_xscale, image_yscale, image_angle, col, 1);