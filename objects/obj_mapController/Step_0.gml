if setStage {
	readStage(global.nextStageMatrix);
	if instance_exists(obj_player) {
		var _numPlayers = instance_number(obj_player);
		for (var i = 0; i < _numPlayers; i++) {
			var _player = instance_find(obj_player,i);
			if instance_exists(_player) {
				if _player.playerID == 0 {_player.x = redX;		_player.y = redY};
				if _player.playerID == 1 {_player.x = blueX;	_player.y = blueY};
				if _player.playerID == 2 {_player.x = greenX;	_player.y = greenY};
				if _player.playerID == 3 {_player.x = yellowX;	_player.y = yellowY};
			}
		}
	}
	var _bgSprite = asset_get_index("spr_stage_" + string(global.nextStageNumber));
	var _bgLayer = layer_background_get_id(layer_get_id("Background"));
	layer_background_sprite(_bgLayer, _bgSprite);
	setStage = false;
}