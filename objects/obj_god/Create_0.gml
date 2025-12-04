global.port = 7676;
global.ipDefault = "192.168.137.1";
global.ip = global.ipDefault;
global.networkType = network_socket_tcp;

global.music = -1;

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

global.volMUSICStart = .3;
global.volMUSIC = global.volMUSICStart;
global.volSFXStart = .5;
global.volSFX = global.volSFXStart;
audio_group_load(MUSIC);
audio_group_load(SFX);


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
} else if room == rm_host or room == rm_client {
	global.music = audio_play_sound(mus_loading, 1, true);
}

instance_create_layer(x, y, layer, obj_camera);