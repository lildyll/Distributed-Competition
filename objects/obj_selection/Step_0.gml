if instance_exists(obj_player) {
	if distance_to_object(obj_player) <= closeEnough {
		inRange = true;
		col = obj_player.mainCol;
		if obj_player.keyAttack {
			if text == "Host" {
				room_goto(rm_host);
			} else if !instance_exists(obj_ipSelection) {
				instance_create_layer(x, y, "Heaven", obj_ipSelection);
			}
		}
	} else {
		inRange = false;
	}
}