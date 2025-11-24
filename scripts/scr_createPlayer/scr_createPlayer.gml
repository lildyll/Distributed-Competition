// Script assets have changed for v2.3.0 see
// https://help.yoyogames.com/hc/en-us/articles/360005277377 for more information
function scr_createPlayer() {
	var _player = instance_create_layer(room_width/2, room_height/2, "Players", obj_player);
	
	return _player;
}