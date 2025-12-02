/// @description Spawn Player
instance_create_layer(160, -32, "Players", obj_player);
global.music = audio_play_sound(mus_intro, 1, true);
startFlicker = true;