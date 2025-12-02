timer--;

if instance_exists(player) {
	x = player.x;
	y = player.y - hover;
} else {
	instance_destroy();
}

if timer <= 0 instance_destroy();
