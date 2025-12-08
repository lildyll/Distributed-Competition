if ds_list_size(totalPlayers) > 1 { //at least two players
	if deadPlayers >= ds_list_size(totalPlayers) - 1 and roundStart {
		//everyone else is dead > declare winner
		for (var i = 0; i < ds_list_size(totalPlayers); i++) {
			var _player = instance_find(obj_player, i);
			if instance_exists(_player) {
				var _playerID = _player.playerID;
				if _player.hp > 0 {
					winnerColor = _player.mainCol;
					switch _playerID {
						case 0: player1.wins++; break;
						case 1: player2.wins++; break;
						case 2: player3.wins++; break;
						case 3: player4.wins++; break;
					}
				} else {
					switch _playerID {
						case 0: player1.losses++; break;
						case 1: player2.losses++; break;
						case 2: player3.losses++; break;
						case 3: player4.losses++; break;
					}
				}
			}
		}
	
		//send leaderboard
		var _leader = buffer_create(32, buffer_grow, 1);
		buffer_write(_leader, buffer_u8, network.leaderboard);
		buffer_write(_leader, buffer_u8, player1.wins);
		buffer_write(_leader, buffer_u8, player2.wins);
		buffer_write(_leader, buffer_u8, player3.wins);
		buffer_write(_leader, buffer_u8, player4.wins);
		
		//send to all players
		for (var i = 0; i < ds_list_size(totalPlayers); i++) {
			network_send_packet(ds_list_find_value(totalPlayers,i), _leader, buffer_tell(_leader));
		}
		buffer_delete(_leader);
	
		//go to next stage
		roundStart = false; //stop everyone from moving until transition is complete
		stage++;
		if stage > maxStage stage = 0;
		global.nextStageNumber = stage;
		
		var _matrix = scr_stage(stage);
			
		var _rows = array_length(_matrix);
		var _cols = array_length(_matrix[0]);

		var _buff = buffer_create(256, buffer_grow, 1);


		buffer_write(_buff, buffer_u8, network.nextRound);
		buffer_write(_buff, buffer_u8, stage);
		buffer_write(_buff, buffer_u8, _rows);
		buffer_write(_buff, buffer_u8, _cols);

		//matrix data 
		for (var _y = 0; _y < _rows; _y++) {
			var _row = _matrix[_y];
			for (var _x = 0; _x < _cols; _x++) {
				buffer_write(_buff, buffer_u8, _row[_x]); // 0/1 fits in a byte
			}
		}

		//send to all players
		for (var i = 0; i < ds_list_size(totalPlayers); i++) {
			network_send_packet(ds_list_find_value(totalPlayers,i), _buff, buffer_tell(_buff));
		}

		buffer_delete(_buff);
	
		//start transition
		with instance_create_layer(x, y, layer, obj_transition) {
			winnerColor = other.winnerColor;
		}
	}

	//check for deaths
	var _deaths = 0;
	for (var i = 0; i < ds_list_size(totalPlayers); i++) {
		var _player = instance_find(obj_player, i);
		if instance_exists(_player) {
			if _player.hp <= 0 _deaths++;
		}
	}

	deadPlayers = _deaths;
}
