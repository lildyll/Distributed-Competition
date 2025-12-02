if stage = 1 {
	scale += scaleSpd;
	if scale <= scaleMax {
		scale = scaleMax
		stage = 2;
	}
} else {
	if holdTimer-- <= 0 {
		scale -= scaleSpd;
		if scale <= 0 {
			instance_destroy();
		}
	}
}