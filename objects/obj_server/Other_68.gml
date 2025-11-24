var _type = async_load[? "type"];
var _id   = async_load[? "id"];

switch (_type) {
    case network_type_connect:
        // SERVER: new client connected
        if (server >= 0 and _id == server) {
            var _playerSocket = async_load[? "socket"];
            ds_list_add(totalPlayers, _playerSocket);
        }
    break;

    case network_type_disconnect:
        // SERVER: a client disconnected
        if (server >= 0 and _id == server) {
            var _playerDisconnect = async_load[? "socket"];
            var _index = ds_list_find_index(totalPlayers, _playerDisconnect);
            if (_index != -1) ds_list_delete(totalPlayers, _index);
        }
    break;

    case network_type_data:
        // CLIENT SIDE: packets meant for this machine as a client
        if (client >= 0 and _id == client) {;
			scr_client();
        }
        // SERVER SIDE: data from any other socket
        else if (server >= 0) {
            scr_serverData(); 
        }
    break;
}
