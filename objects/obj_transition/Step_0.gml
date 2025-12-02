
if stage = 1 {
	spd += acc;
	drawHeightTop += spd;
	if drawHeightTop <= drawHeight {
		spd = startSpd;
		stage = 2;
		if instance_exists(obj_mapController) {
			obj_mapController.setStage = true;
		}
	} 
} else {
	spd += acc;
	drawHeightBottom += spd;
	if drawHeightBottom <= drawHeight {
		instance_destroy();
		with instance_create_layer(-100, -100, layer, obj_textAnnouncement) {
			text = "fight!"
			winnerColor = c_white;
			holdTimer = FPS/2;
		}
	} 
}