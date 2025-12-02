keyUpPressed = keyboard_check_pressed(vk_up) or keyboard_check_pressed(ord("W"));
keyDownPressed = keyboard_check_pressed(vk_down) or keyboard_check_pressed(ord("S"));
keySelect = keyboard_check_pressed(vk_space) or keyboard_check_pressed(vk_enter) or mouse_check_button_pressed(mb_left);

if keyUpPressed {
	audio_play_sound(snd_click, 1, false);
	selection--;
	if selection < 0 selection = selectionMax;
} else if keyDownPressed {
	audio_play_sound(snd_click, 1, false);
	selection++;
	if selection > selectionMax selection = 0;
}
image_index = selection;

if keySelect {
	switch selection {
		case 0: //return 
			instance_destroy();
		break;
		case 1: //music
			if global.volMUSIC == 0 {
				global.volMUSIC = global.volMUSICStart;
			} else {
				global.volMUSIC = 0;
			}
		break;
		case 2: //sfx
			if global.volSFX == 0 {
				global.volSFX = global.volSFXStart;
			} else {
				global.volSFX = 0;
			}
		break;
		case 3: //quit
			if instance_exists(obj_client) {
				with obj_client {
					scr_disconnect();
				}
			} else {
				if instance_exists(obj_server) {
					with obj_server {
						scr_disconnect();
					}
				}
			}
		break;
	}
	audio_play_sound(snd_click, 1, false);
}