/// @description Remove Instance
if ds_map_find_value(instances,disconnectedID) {
	ds_map_delete(instances, disconnectedID);
	disconnectedID = -1;
}