// Script assets have changed for v2.3.0 see
// https://help.yoyogames.com/hc/en-us/articles/360005277377 for more information
function scr_serverData() {
	var _packet = async_load[? "buffer"]; //load the ID of the buffer that was sent
	buffer_seek(_packet, buffer_seek_start, 0);
	
	var _packetID = buffer_read(_packet, buffer_u8); //read the first value of the packet - the network enum
	
	switch _packetID {
		case network.move:
			var _data = scr_loadPlayerData(_packet);
			var _playerID =		_data.playerID;
			var _player_x =		_data.playerX; 
			var _player_y =		_data.playerY; 
			
			//now send it to all other clients
			var _buff = scr_sendPlayerData(_playerID, _player_x, _player_y, 
			_data.spriteIndex, _data.frame, _data.color, _data.hp, _data.xScale);
			
			//send to all players
			for (var i = 0; i < ds_list_size(totalPlayers); i++) {
				network_send_packet(ds_list_find_value(totalPlayers,i), _buff, buffer_tell(_buff));
			}
			
			buffer_delete(_buff);			//no memory leaks
		break;
		
		case network.hit: {
			var _data = scr_loadPlayerHit(_packet);
			
			//send to all other clients
			var _buff = scr_sendPlayerHit(_data.hitID, _data.xx, _data.yy,
			_data.xScale, _data.yScale, _data.dmg);
			
			//send to all players
			for (var i = 0; i < ds_list_size(totalPlayers); i++) {
				network_send_packet(ds_list_find_value(totalPlayers,i), _buff, buffer_tell(_buff));
			}
			
			//dont delete buffer so it registers
		}
	}
}