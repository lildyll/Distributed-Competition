// Script assets have changed for v2.3.0 see
// https://help.yoyogames.com/hc/en-us/articles/360005277377 for more information
function scr_disconnect() {
	if instance_exists(obj_client) {
		if instance_exists(obj_client.player) {
			var _disconnectBuff = buffer_create(32, buffer_grow, 1);
			buffer_seek(_disconnectBuff, buffer_seek_start, 0);
			buffer_write(_disconnectBuff, buffer_u8, network.disconnect);
			buffer_write(_disconnectBuff, buffer_u16, obj_client.player.playerID);
			
			network_send_packet(obj_client.client, _disconnectBuff, buffer_tell(_disconnectBuff));
			buffer_delete(_disconnectBuff);
		} else {
			//no player found to disconnect
			show_message("No player was found");
		}
	} else {
		//no client was found > go to server
		if instance_exists(obj_server) {
			if instance_exists(obj_server.player) {
				var _disconnectBuff = buffer_create(32, buffer_grow, 1);
				buffer_seek(_disconnectBuff, buffer_seek_start, 0);
				buffer_write(_disconnectBuff, buffer_u8, network.disconnect);
				buffer_write(_disconnectBuff, buffer_u16, obj_server.player.playerID);
			
				network_send_packet(obj_server.client, _disconnectBuff, buffer_tell(_disconnectBuff));
				buffer_delete(_disconnectBuff);
			} else {
				//no player found to disconnect
				show_message("No player was found");
			}
		} else {
			show_message("No Client or Server was found");
		}
		
	}
}