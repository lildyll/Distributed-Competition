// Script assets have changed for v2.3.0 see
// https://help.yoyogames.com/hc/en-us/articles/360005277377 for more information
function scr_sendPlayerData(_playerID, _playerX, _playerY, _spriteIndex, _frame, _color, 
_hp, _xScale) {
	var _buff = buffer_create(32, buffer_grow, 1);
	buffer_seek(_buff, buffer_seek_start, 0);
	buffer_write(_buff, buffer_u8, network.move);			//set the id of the packet to move
	buffer_write(_buff, buffer_u16, _playerID);				//send our id so the client knows what player it is
	buffer_write(_buff, buffer_s16, _playerX);				//send out x and y with s16 to allow negative numbers
	buffer_write(_buff, buffer_s16, _playerY);
	buffer_write(_buff, buffer_u16, _spriteIndex); 
	buffer_write(_buff, buffer_u8, _frame); 
	buffer_write(_buff, buffer_u32, _color); 
	buffer_write(_buff, buffer_u8, _hp); 
	buffer_write(_buff, buffer_s8, _xScale); 
	return _buff
}