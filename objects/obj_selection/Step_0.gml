if instance_exists(obj_player) {
	if distance_to_object(obj_player) <= closeEnough {
		inRange = true;
		col = obj_player.mainCol;
		if obj_player.keyAttack {
			if text == "Host" {
				room_goto(rm_host);
			} else {
				room_goto(rm_client);
			}
		}
	} else {
		inRange = false;
	}
}