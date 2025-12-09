var _currentText = keyboard_string;

if keyboard_check_pressed(vk_delete) _currentText = keyboard_string - keyboard_lastchar;
if keyboard_check_pressed(vk_escape) instance_destroy();

if (string_length(_currentText) + 1) * spacing >= sprite_width {
	//too much
} else {
	text = _currentText;
}

if keyboard_check_pressed(vk_enter) {
	connect = true;
	instance_destroy();
}