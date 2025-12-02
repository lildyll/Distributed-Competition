stageNumber = 0;
setStage = false;

redX = 0;
redY = 0;
blueX = 0;
blueY = 0;
greenX = 0;
greenY = 0;
yellowX = 0;
yellowY = 0;

function readStage(_matrix) {
	var _tileSize = 16;
	instance_destroy(obj_floor); //remove all prev floors
	for (var r = 0; r < array_length(_matrix); r++) {
		for (var c = 0; c < array_length(_matrix[r]); c++) {
			var _x = c * _tileSize + 8; //+8 to center it
			var _y = r * _tileSize + 8;
			var _value = _matrix[r][c];
			switch _value {
				case 0: break;
				case 1: //spawn red
				redX =  _x;
				redY = _y;
				break;
				case 2: //spawn blue
				blueX =  _x;
				blueY = _y;
				break;
				case 3: //spawn green
				greenX =  _x;
				greenY = _y;
				break;
				case 4: //spawn yellow
				yellowX =  _x;
				yellowY = _y;
				break;
				case 5: //spawn floor
				instance_create_layer(_x, _y, "Walls", obj_floor);
				break;
			}
		}
	}
}