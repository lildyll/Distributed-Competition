players = scr_playersJoined();
if players[0] scr_doText("Red: " + string(redWins), cRed, x, y, 6, 8, 1, 1, 0, 0);
if players[1] scr_doText("Blue: " + string(blueWins), cBlue, x + sep, y, 6, 8, 1, 1, 0, 0);
if players[2] scr_doText("Green: " + string(greenWins), cGreen, x + (sep * 2), y, 6, 8, 1, 1, 0, 0);
if players[3] scr_doText("Yellow: " + string(yellowWins), cYellow, x + (sep * 3), y, 6, 8, 1, 1, 0, 0);