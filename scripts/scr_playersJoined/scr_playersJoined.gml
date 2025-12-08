//Returns an array of 1 or 0 if a player is joined or not

function scr_playersJoined() {
	var _players = [true,false,false,false]; //1 at the red spot since thats the host
	for (var p = 0; p < instance_number(obj_player); p++) {
		var _player = instance_find(obj_player, p);
		var _playerID = _player.playerID;
		
		_players[_playerID] = true;
	}
	return _players;
}