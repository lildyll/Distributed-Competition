if doOutline scr_outline();

var _mainCol = mainCol;
var _bgCol = bgCol;

if flash {
	_mainCol = global.currentPalette[1];
	_bgCol = global.currentPalette[1];
}

draw_sprite_ext(sprite_index, image_index, x, y, image_xscale, image_yscale, angle, _mainCol, image_alpha);

//draw_text(x, y + 4, string(state));