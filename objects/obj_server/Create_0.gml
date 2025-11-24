port = global.port;
maxPlayers = 4;

server = network_create_server(global.networkType, port, maxPlayers);
totalPlayers = ds_list_create();

if server < 0 { //make sure the server is created
	show_message("Error creating server");
	game_restart();
} 

//start the client to connect to itself
ip = "127.0.0.1";

network_set_config(global.networkType, 3000); //will time out after 3 seconds of no connecting
client = network_create_socket(network_socket_tcp);
network_connect(client, ip, port);

//creating the player
instances = ds_map_create();
clientID = 0;
player = scr_createPlayer();
clientID = player.playerID;

ds_map_add(instances, clientID, player);

//creating the attacks
attacks = ds_map_create();

if client < 0 { //make sure you can connect
	show_message("Error connecting to server");
	game_restart();
}
