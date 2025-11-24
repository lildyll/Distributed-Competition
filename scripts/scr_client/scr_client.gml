// Script assets have changed for v2.3.0 see
// https://help.yoyogames.com/hc/en-us/articles/360005277377 for more information
function scr_client() {
	var _packet = async_load[? "buffer"]; //load the ID of the buffer that was sent
	buffer_seek(_packet, buffer_seek_start, 0);
	
	var _packetID = buffer_read(_packet, buffer_u8); //read the first value of the packet - the network enum
	
	switch _packetID {
		case network.move: //assign it to the correct player
			var _data = scr_loadPlayerData(_packet);
			var _playerID =		_data.playerID;
			var _findPlayer = ds_map_find_value(instances, _playerID); 
			if is_undefined(_findPlayer) { //if none exists, create one
				var _player = scr_createPlayer();
				ds_map_add(instances, _playerID, _player);
			} else {
				if clientID != _playerID and instance_exists(_findPlayer) {
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
						ds_map_add(attacks, _hitID, _newHit);
					} 
					if instance_exists(_newHit) {
						_newHit.myID = _hitID;
						_newHit.x = _data.xx;
						_newHit.y = _data.yy;
						_newHit.image_xscale = _data.xScale;
						_newHit.image_yscale = _data.yScale;
						_newHit.damage = _data.dmg;
					}
				}
			}
		break;
	}
}