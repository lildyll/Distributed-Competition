/// @description Receive Data

var _type = async_load[? "type"];
var _id   = async_load[? "id"];

// only do it if it's a real data buffer
if (_type == network_type_data and _id == client) {
    scr_client();
}
