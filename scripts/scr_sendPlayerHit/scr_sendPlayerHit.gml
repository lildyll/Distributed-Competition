// Script assets have changed for v2.3.0 see
// https://help.yoyogames.com/hc/en-us/articles/360005277377 for more information
function scr_sendPlayerHit(_hitID, _x, _y, _xScale, _yScale, _dmg) {
	var _buff = buffer_create(32, buffer_grow, 1);
	buffer_seek(_buff, buffer_seek_start, 0);
	buffer_write(_buff, buffer_u8, network.hit);			//set the id of the packet to hit
	buffer_write(_buff, buffer_u8, _hitID);					//send the hit ID to know what player did the hit

	buffer_write(_buff, buffer_s16, _x);					
	buffer_write(_buff, buffer_s16, _y);					
	buffer_write(_buff, buffer_s16, _xScale);					
	buffer_write(_buff, buffer_s16, _yScale);					
	buffer_write(_buff, buffer_u8, _dmg);					
	return _buff
}