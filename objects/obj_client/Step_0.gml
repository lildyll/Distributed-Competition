//latency checker
var _latencyBuff = buffer_create(32, buffer_grow, 1);
buffer_seek(_latencyBuff, buffer_seek_start, 0);
buffer_write(_latencyBuff, buffer_u8, network.latency);
buffer_write(_latencyBuff, buffer_u32, current_time);
network_send_packet(client, _latencyBuff, buffer_tell(_latencyBuff));
buffer_delete(_latencyBuff);

timeout++;

if timeout > FPS * 3 {
	scr_disconnect();
	//go to lobby
}

if keyboard_check_pressed(vk_down) {
	scr_disconnect();
}
