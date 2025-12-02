var _type = async_load[? "type"];
var _id   = async_load[? "id"];

switch (_type) {
    case network_type_connect:
        // SERVER: new client connected
		if (server >= 0 and _id == server) {
            var _socket = async_load[? "socket"];

		    var _newID = nextPlayerID;
			
			//check if there are any IDs in the queue
			if array_length(leftPlayerIDs) > 0 {
				_newID = array_pop(leftPlayerIDs);
				nextPlayerID = _newID;
			}
			
		    //send the new ID to the client
		    var _buff = buffer_create(32, buffer_grow, 1);
		    buffer_write(_buff, buffer_u8, network.assignID);
		    buffer_write(_buff, buffer_u16, _newID);
		    network_send_packet(_socket, _buff, buffer_tell(_buff));
			
		    buffer_delete(_buff);

		    //add it to the total players
		    ds_list_add(totalPlayers, _socket);
			nextPlayerID++;
		}
    break;

    case network_type_disconnect:
        // SERVER: a client disconnected
		if (server >= 0 and _id == server) {
	        var _playerDisconnect = async_load[? "socket"];
	        var _index = ds_list_find_index(totalPlayers, _playerDisconnect);
	        if _index != -1 {
				ds_list_delete(totalPlayers, _index);
			}
		}
    break;

    case network_type_data:
        if (client >= 0 and _id == client) {
			scr_client();
        }
        // SERVER SIDE: data from any other socket
        else if (server >= 0) {
            scr_serverData(); 
        }
    break;
}
