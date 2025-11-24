// Script assets have changed for v2.3.0 see
// https://help.yoyogames.com/hc/en-us/articles/360005277377 for more information
function scr_loadPlayerHit(_packet) {
	var _hitID = buffer_read(_packet, buffer_u8);	
	var _x = buffer_read(_packet, buffer_s16);			
	var _y = buffer_read(_packet, buffer_s16);			
	var _xScale = buffer_read(_packet, buffer_s16);		
	var _yScale = buffer_read(_packet, buffer_s16);		
	var _dmg = buffer_read(_packet, buffer_s8);			

	var _data = {
		hitID:		_hitID,	
		xx:			_x,
		yy:			_y,
		xScale:		_xScale,
		yScale:		_yScale,
		dmg:		_dmg,			
	}
	
	return _data;
}