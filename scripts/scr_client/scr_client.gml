// Script assets have changed for v2.3.0 see
// https://help.yoyogames.com/hc/en-us/articles/360005277377 for more information
function scr_client() {
	var _packet = async_load[? "buffer"]; //load the ID of the buffer that was sent
	buffer_seek(_packet, buffer_seek_start, 0);
	
	var _packetID = buffer_read(_packet, buffer_u8); //read the first value of the packet - the network enum
	
	switch _packetID {
		case network.assignID:
		    var _newID = buffer_read(_packet, buffer_u16);
			clientID = _newID;
			player = scr_createPlayer();
			player.playerID = clientID;
			ds_map_add(instances, clientID, player);
		    show_debug_message("Assigned client ID = " + string(clientID));
		break;

		case network.move: //assign it to the correct player
			if clientID == -1 break;
			var _data = scr_loadPlayerData(_packet);
			var _playerID =		_data.playerID;
			var _findPlayer = ds_map_find_value(instances, _playerID); 
			
			if is_undefined(_findPlayer) { //if none exists, create one
				var _player = scr_createPlayer();
				_player.playerID = _playerID;
				ds_map_add(instances, _playerID, _player);
			} else {
				if clientID != _playerID and instance_exists(_findPlayer) {
					//show_debug_message("client - " + string(clientID) + " player - " + string(_playerID));
					_findPlayer.state = _data.playerState; 
					_findPlayer.x = _data.playerX;
					_findPlayer.y = _data.playerY;
					_findPlayer.sprite_index = _data.spriteIndex;
					_findPlayer.image_index = _data.frame;
					_findPlayer.mainCol = _data.color;
					_findPlayer.hp = _data.hp;
					_findPlayer.image_xscale = _data.xScale;
				}
			}
		break;
	
		case network.hit: //assign it to the correct player
			var _data = scr_loadPlayerHit(_packet);
			var _hitID =		_data.hitID;
			
			var _findAttackBox = ds_map_find_value(attacks, _hitID);
			var _newHit = _findAttackBox;
			if clientID != _hitID { //if we did not do the hit
				if _data.dmg == -1 {
					ds_map_delete(attacks, _hitID);
					if instance_exists(_newHit) {
						instance_destroy(_newHit);
					}
				} else {
					if is_undefined(_newHit) {
						_newHit = instance_create_layer(_data.xx, _data.yy, "Players", obj_attackBox);
						_newHit.damage = _data.dmg;
						_newHit.dir = _data.dir;
						ds_map_add(attacks, _hitID, _newHit);
					} 
					if instance_exists(_newHit) {
						_newHit.myID = _hitID;
						_newHit.x = _data.xx;
						_newHit.y = _data.yy;
						_newHit.image_xscale = _data.xScale;
						_newHit.image_yscale = _data.yScale;
						_newHit.damage = _data.dmg;
						_newHit.dir = _data.dir;
					}
				}
			}
		break;
		
		case network.latency:
			var _gotTime = buffer_read(_packet, buffer_u32);
			
			latency = current_time - _gotTime; //the difference in ping
			
			timeout = 0; //reset since we are still connected
		break;
		
		case network.disconnect:
			var _disconnectedID = buffer_read(_packet, buffer_u16);
			
			var _disconnectedPlayer = ds_map_find_value(instances, _disconnectedID);
			
			//if the player exists, remove it on all clients
			if _disconnectedID != clientID {
				if not is_undefined(_disconnectedPlayer) {
					instance_destroy(_disconnectedPlayer);
				}
			} else { //if its you return to lobby
				game_end();
			}
		break;
		#region next round
		case network.nextRound:
		   
		    var _stage = buffer_read(_packet, buffer_u8);
		    var _rows = buffer_read(_packet, buffer_u8);
		    var _cols = buffer_read(_packet, buffer_u8);

		    //reconstruct the matrix
		    var _matrix = array_create(_rows);
		    for (var _y = 0; _y < _rows; _y++) {
		        var _row = array_create(_cols);
		        for (var _x = 0; _x < _cols; _x++) {
		            _row[_x] = buffer_read(_packet, buffer_u8);
		        }
		        _matrix[_y] = _row;
		    }

			global.nextStageMatrix = _matrix;
			global.nextStageNumber = _stage;
			
			if !instance_exists(obj_transition) {
				instance_create_layer(x, y, layer, obj_transition);
			}

		break;
		#endregion
		#region chat
		case network.text:
		
			var _playerID = buffer_read(_packet, buffer_u8);
			
			var _player = ds_map_find_value(instances, _playerID);
			var _text = buffer_read(_packet, buffer_string);
			
			//if the player exists, create the text and assign it to that player instance
			if instance_exists(_player) {
				if !instance_exists(_player.chat) or _player.chat.text != _text  {
					instance_destroy(_player.chat);
					var _chat = instance_create_layer(_player.x, _player.y, "Heaven", obj_textOverPlayer)
						_chat.player = _player;
						_chat.text = _text;
					
						_player.chat = _chat;
				} 
			}
		break;
		#endregion
		
		
	}
}