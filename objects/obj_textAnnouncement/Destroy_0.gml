if text == "fight!" {
	if instance_exists(obj_player) {
		var _numPlayers = instance_number(obj_player);
		for (var i = 0; i < _numPlayers; i++) {
			var _player = instance_find(obj_player,i);
			if instance_exists(_player) {
				_player.state = pState.idle;
				_player.hp = _player.hpMax;
			}
		}
	}
	if instance_exists(obj_server) obj_server.alarm[0] = 10;
}