draw_self();

if inRange {
	scr_doText(text, col,   x + xOffset + 1, y + yOffset, 6, 8, 1, bloomSpd, .5, .25);
	scr_doText("Game", col, x + xOffset,     y + yOffset + 8, 6, 8, 1, bloomSpd, .5, .25);
	
	scr_doText("Hit me!", col, x + xOffset,     y - 32, 6, 8, 1, bloomSpd, .5, .25);
} else {
	scr_doText(text, c_white,   x + xOffset + 1, y + yOffset, 6, 8, 1, 1, 0, 0);
	scr_doText("Game", c_white, x + xOffset,     y + yOffset + 8, 6, 8, 1, 1, 0, 0);
}
