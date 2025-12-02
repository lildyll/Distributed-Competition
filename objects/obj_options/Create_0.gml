selection = 0;
selectionMax = 3;
selections = ["resume", "music", "sfx", "quit"];

col = c_white;

x = room_width/2;
y = room_height/2;

topHeight = 38;

keyUpPressed = keyboard_check_pressed(vk_up) or keyboard_check_pressed(ord("W"));
keyDownPressed = keyboard_check_pressed(vk_down) or keyboard_check_pressed(ord("S"));