port = global.port;
maxPlayers = 4;

server = network_create_server(global.networkType, port, maxPlayers);
totalPlayers = ds_list_create();

if server < 0 { //make sure the server is created
	show_message("Error creating server");
	game_restart();
} 

nextPlayerID = 0;
leftPlayerIDs = []; //stores left player IDs to reassign if someone leaves then another joins

//track server stuff
deadPlayers = -1;
stage = -1;
maxStage = 8;
roundStart = true;
setStage = false;
winnerColor = c_white;
function playerStats(_wins = 0, _losses = 0) constructor {
	wins = _wins;
	losses = _losses;
}
player1 = new playerStats();
player2 = new playerStats();
player3 = new playerStats();
player4 = new playerStats();

//start the client to connect to itself
ip = global.ip;

network_set_config(global.networkType, 3000); //will time out after 3 seconds of no connecting
client = network_create_socket(network_socket_tcp);
network_connect(client, ip, port);

//creating the player
instances = ds_map_create();
clientID = -1;
player = noone;
disconnectedID = -1;

ds_map_add(instances, clientID, player);

//creating the attacks
attacks = ds_map_create();

if client < 0 { //make sure you can connect
	show_message("Error connecting to server");
	game_restart();
}
