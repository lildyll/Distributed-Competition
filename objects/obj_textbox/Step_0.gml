var _currentText = keyboard_string;

if keyboard_check_pressed(vk_delete) _currentText = keyboard_string - keyboard_lastchar;
if keyboard_check_pressed(vk_escape) instance_destroy();

if (string_length(_currentText) + 1) * spacing >= sprite_width {
	//too much
} else {
	text = _currentText;
}

if keyboard_check_pressed(vk_enter) {
	if text != "" {
		show_debug_message("sent");
		var _buff = buffer_create(32, buffer_grow, 1);
		buffer_seek(_buff, buffer_seek_start, 0);
		buffer_write(_buff, buffer_u8, network.text);			//set the id of the packet to text
		buffer_write(_buff, buffer_u8, playerID);				//send the hit ID to know what player said it

		buffer_write(_buff, buffer_string, text);									
		
		if instance_exists(obj_server) {
			network_send_packet(obj_server.client, _buff, buffer_tell(_buff));
		} else if instance_exists(obj_client) {
			network_send_packet(obj_client.client, _buff, buffer_tell(_buff));
		}
		
		buffer_delete(_buff);
	}
	instance_destroy();
}