players = instance_number(obj_player);
text = string(players) + " / 4 Players";
if players >= 4 {
	scr_doText(text, c_white, x, y, 6, 8, 1, -200, .5, .25);
} else {
	scr_doText(text, c_white, x, y, 6, 8, 1, 1, 0, 0);
}

if players > 0 {
	scr_doText("Compete to start", c_white, x, y + 16, 6, 8, 1, -200, .5, .25, 2);
}
