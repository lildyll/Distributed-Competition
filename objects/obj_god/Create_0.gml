global.port = 7676;
global.networkType = network_socket_tcp;

global.currentPalette = ["White", c_white, c_black];
randomize();
enum network {
	join,
	move,
	hit,
	disconnect
}

layer_set_visible(layer_get_id("Walls"), false);