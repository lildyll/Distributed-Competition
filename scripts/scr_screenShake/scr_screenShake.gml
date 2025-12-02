// Script assets have changed for v2.3.0 see
// https://help.yoyogames.com/hc/en-us/articles/360005277377 for more information
function scr_screenShake(magnitude,frames) {
	with (obj_camera) {
		if (magnitude > shakeRemain) {
			shakeMag = magnitude;
			shakeRemain = magnitude;
			shakeLength = frames;
		}
	}
}