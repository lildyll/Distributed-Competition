if instance_exists(obj_player) {
	draw_text(32, 32, string(obj_player.playerID));
}
if instance_exists(obj_server) {
	draw_text(32, 48, string(obj_server.clientID));
}
if instance_exists(obj_attackBox) {
	draw_text(32, 64, string(obj_attackBox.myID));
}