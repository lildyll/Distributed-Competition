global.port = 7676;
global.ip = "192.168.5.113"
global.networkType = network_socket_tcp;

global.currentPalette = ["White", c_white, c_black];
randomize();
enum network {
	join,
	move,
	hit,
	smoke,
	latency,
	disconnect,
	assignID,
	nextRound,
	text
}

global.nextStageMatrix = scr_stage(0);
global.nextStageNumber = 0;

global.volMUSIC = 75;
global.volSFX = 75;

layer_set_visible(layer_get_id("Walls"), false);

bgTimer = 0;
bgTimerMax = FPS * 2;
bgTimerFlicker = [10, 11, 12, 70, 71, 80, 81, 100];
bgLayer = layer_background_get_id(layer_get_id("Background"));
bgNormal = spr_lobby_BG;
bgColored = spr_lobby_BG_full;
startFlicker = false;
if room == rm_start {
	alarm[0] = FPS;
	layer_background_sprite(bgLayer, bgNormal);
}

instance_create_layer(x, y, layer, obj_camera);