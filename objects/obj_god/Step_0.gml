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

audio_group_set_gain(MUSIC, global.volMUSIC);
audio_group_set_gain(SFX, global.volSFX);