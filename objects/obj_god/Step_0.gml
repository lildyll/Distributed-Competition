if startFlicker {
	bgTimer++;
	if array_contains(bgTimerFlicker, bgTimer) {
		layer_background_sprite(bgLayer, bgNormal);
	} else {
		layer_background_sprite(bgLayer, bgColored);
	}
	if bgTimer > bgTimerMax {
		bgTimer = 0;
	}
}