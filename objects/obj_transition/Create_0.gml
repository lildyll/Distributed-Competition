drawWidth = room_width;
drawHeight = 0;
drawHeightTop = room_height;
drawHeightBottom = room_height;
startSpd = -1;
spd = startSpd;
acc = -.05;
stage = 1;
winnerColor = c_white;

if instance_exists(obj_textPlayers) instance_destroy(obj_textPlayers);

alarm[0] = 5;