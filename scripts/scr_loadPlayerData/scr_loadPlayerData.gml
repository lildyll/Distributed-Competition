// Script assets have changed for v2.3.0 see
// https://help.yoyogames.com/hc/en-us/articles/360005277377 for more information
function scr_loadPlayerData(_packet) {
	var _playerID =		buffer_read(_packet, buffer_u16);
	var _playerX =		buffer_read(_packet, buffer_s16);
	var _playerY =		buffer_read(_packet, buffer_s16);
	var _spriteIndex =	buffer_read(_packet, buffer_u16);
	var _frame =		buffer_read(_packet, buffer_u8) ;
	var _color =		buffer_read(_packet, buffer_u32);
	var _hp =			buffer_read(_packet, buffer_u8);
	var _xScale =		buffer_read(_packet, buffer_s8);
	var _data = {
		playerID:		_playerID,	
		playerX:		_playerX,	
		playerY:		_playerY,	
		spriteIndex:	_spriteIndex,
		frame:			_frame,		
		color:			_color,		
		hp:				_hp,
		xScale:			_xScale,
	}
	
	return _data;
}