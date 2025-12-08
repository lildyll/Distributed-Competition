/// @description Announcement

for (var i = 0; i < instance_number(obj_player); i++) {
	var _player = instance_find(obj_player, i);
	if instance_exists(_player) {
		var _playerID = _player.playerID;
		if _player.hp > 0 {
			winnerColor = _player.mainCol;
			show_debug_message(_player);
		}
	}
}

if !instance_exists(obj_textAnnouncement) {
	with instance_create_layer(-100, -100, layer, obj_textAnnouncement) {
		winnerColor = other.winnerColor;
	}
}

