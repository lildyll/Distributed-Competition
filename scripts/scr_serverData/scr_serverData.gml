// Script assets have changed for v2.3.0 see
// https://help.yoyogames.com/hc/en-us/articles/360005277377 for more information
function scr_serverData() {
	var _packet = async_load[? "buffer"]; //load the ID of the buffer that was sent
	var _socket = async_load[? "id"];	//get the socket of the client who sent the packet
	buffer_seek(_packet, buffer_seek_start, 0);
	
	var _packetID = buffer_read(_packet, buffer_u8); //read the first value of the packet - the network enum
	
	switch _packetID {
		#region movement
		case network.move:
			var _data = scr_loadPlayerData(_packet);
			var _playerID =		_data.playerID;
			var _player_x =		_data.playerX; 
			var _player_y =		_data.playerY; 
			//now send it to all other clients
			var _buff = scr_sendPlayerData(_playerID, _data.playerState, _player_x, _player_y,   
			_data.spriteIndex, _data.frame, _data.color, _data.hp, _data.xScale);
			
			//send to all players
			for (var i = 0; i < ds_list_size(totalPlayers); i++) {
				network_send_packet(ds_list_find_value(totalPlayers,i), _buff, buffer_tell(_buff));
			}
			
			buffer_delete(_buff);			//no memory leaks
		break;
		#endregion
		#region attacks
		case network.hit: {
			var _data = scr_loadPlayerHit(_packet);
			
			//send to all other clients
			var _buff = scr_sendPlayerHit(_data.hitID, _data.xx, _data.yy,
			_data.xScale, _data.yScale, _data.dmg, _data.dir);
			
			//send to all players
			for (var i = 0; i < ds_list_size(totalPlayers); i++) {
				network_send_packet(ds_list_find_value(totalPlayers,i), _buff, buffer_tell(_buff));
			}
			
			//dont delete buffer so it registers
		}
		break;
		#endregion
		#region latency
		case network.latency:
			var _time = buffer_read(_packet, buffer_u32);
			
			//send to client that sent it
			var _latencyBuff = buffer_create(32, buffer_grow, 1);
			buffer_seek(_latencyBuff, buffer_seek_start, 0);
			buffer_write(_latencyBuff, buffer_u8, network.latency);
			buffer_write(_latencyBuff, buffer_u32, _time);
			
			network_send_packet(_socket, _latencyBuff, buffer_tell(_latencyBuff));
			buffer_delete(_latencyBuff);
		break;
		#endregion
		#region disconnect
		case network.disconnect:
			var _disconnectID = buffer_read(_packet, buffer_u16);
			
			//add the freed up ID to the leftIDs
			array_push(leftPlayerIDs, _disconnectID);
			
			//create new buffer to send to all clients
			var _disconnectBuff = buffer_create(32, buffer_grow, 1);
			buffer_seek(_disconnectBuff, buffer_seek_start, 0);
			buffer_write(_disconnectBuff, buffer_u8, network.disconnect);
			buffer_write(_disconnectBuff, buffer_u16, _disconnectID);
			
			for (var i = 0; i < ds_list_size(totalPlayers); i++) {
				network_send_packet(ds_list_find_value(totalPlayers,i), _disconnectBuff, buffer_tell(_disconnectBuff));
			}
			
			//remove the disconnected player
			ds_list_delete(totalPlayers, ds_list_find_index(totalPlayers, _socket));
			buffer_delete(_disconnectBuff);
		break;
		#endregion
		#region chat
		case network.text:
			var _playerID = buffer_read(_packet, buffer_u8);
			
			var _player = ds_map_find_value(instances, _playerID);
			var _text = buffer_read(_packet, buffer_string);
			
			//if the player exists, create the text and assign it to that player instance
			if instance_exists(_player) {
				if !instance_exists(_player.chat) or _player.chat.text != _text {//if the player already has a chat over its head delete it
				instance_destroy(_player.chat);
				var _chat = instance_create_layer(_player.x, _player.y, "Heaven", obj_textOverPlayer);
					_chat.player = _player;
					_chat.text = _text;
					
					_player.chat = _chat;
				}
			}
			
			//now send to other clients
			var _buff = buffer_create(32, buffer_grow, 1);
			buffer_seek(_buff, buffer_seek_start, 0);
			buffer_write(_buff, buffer_u8, network.text);			//set the id of the packet to text
			buffer_write(_buff, buffer_u8, _playerID);				//send the hit ID to know what player said it

			buffer_write(_buff, buffer_string, _text);									
		
			//send to all players
			for (var i = 0; i < ds_list_size(totalPlayers); i++) {
				network_send_packet(ds_list_find_value(totalPlayers,i), _buff, buffer_tell(_buff));
			}
			
			buffer_delete(_buff);			//no memory leaks
		break;
		#endregion
	}
}