//backend
playerID = irandom_range(1, 200); //change this 

mainCol = choose(cRed, cBlue, cGreen, cYellow); // global.currentPalette[1];
bgCol = global.currentPalette[2];
col = bgCol;
flash = false;
angle = 0;
doOutline = false;

enum iSpd {
	idle = 10,
	run = 15,
	jump = 10,
	punch = 15
}

image_speed = iSpd.idle;
hp = 100;

//hosting? - if yes, connect to server obj
playerHost = false;

//movement
xSpeed = 0;
spd = 2.5;
jumpSpd = -5;
ySpeed = 0;
grav = 0.25;
coyoteMax = 10;
coyote = coyoteMax;
canJump = false;
stateJump = false;
doSprite = true;

//fighting
punchSpd = 3;
hit = false;
dmg = 1;
dmgToTake = 0;
myHit = noone;

enum attackDmg {
	punch1 = 5,
}

enum attackLength {
	punch1 = 15,
}

//states
enum pState {
	dead,
	idle,
	run,
	slide,
	jump,
	vault,
	vaultslide,
	flip,
	punch1
}
state = pState.jump;
prevState = state;

/*
start = true;

deathYCheck = -2;

canMove = true;
canMoveFinish = true;

keyDown = false;
keyDownPressed = false;
keyUp = false;
keyUp = false;
keyUpPressed = false;
keyBloom = false;

canBloom = true;
bloomTimerMax = FPS;
bloomTimer = bloomTimerMax;

mLeft = false;
mLeftPressed = false;
mRight = false;
mRightPressed = false;
mouseDir = 0;

mainCol = global.currentPalette[1];
bgCol = global.currentPalette[2];
col = bgCol;
	
enum pState {
	dead,
	run,
	slide,
	jump,
	vault,
	vaultslide,
	flip,
	vinegrab
}
state = pState.flip;
prevState = state;
doOutline = true;

enum pDeaths {
	filler, //cause it starts at 0 (false)
	wallFace,
	wallFaceDive,
	wallFaceSlide,
	chomped,
	buzzed
}

floorY = 136;
centerX = x;
grav = .25;
ySpeed = 0;
xSpeed = 0;
jumpSpeedDefault = -6;
jumpSpeed = jumpSpeedDefault;
slideSpeed = 0;
resetSpeed = slideSpeed;
doJump = true;

deathSlide = false;
deathSlideSpd = .2;
deathSlideGrav = .05;
deathFall = false;
deathFallSpd = grav;

startingIndex = 0;

_coyote = 10;
coyote = _coyote;

minSpd = 0;
maxSpd = 2;
currentSpd = 0;
currentDir = 0;

spriteFill = -1;
doneSmoke = false;
mySmoke = noone;
myBloom = obj_bloom;
myBloomDelay = 5;

vaultCheck = global.spd * 12;
vaultBlockX = 0;
vaultBlockY = 0;

vineSegments = 0;
vineStart = 0;
vineSep = 16;
vineSpd = 1;
vineDownSpd = 2;
vineHangTime = 5;
vineHanging = 0;
vineTracker = 0;
vineGround = false;
vineY = y;
vineX = x;
vineEnd = 0;

gunSprite = spr_player_gun;
bulletSprite = spr_player_bullet;
bulletDmg = 1;
bulletType = -1;
bulletSpd = 3;

gunAngle = 0;
gunRadius = 16;
gunScale = 1;
gunSpinTime = 30;
gunSpin = 0;
gunSpinning = false;
shots = global.shots;

widthHalf = sprite_width/2;
heightHalf = sprite_height/2;

flashing = false;
flash = false;
_flashAmount = 6;
flashAmount = _flashAmount;
_flashTimer = 10;
flashTimer = _flashTimer;
hit = false;
hitDmg = 0;

depth -= 10;

function createSmoke(_sprite, _x, _y = floorY + 8, _spd = image_speed, _loop = false) {
	if instance_exists(mySmoke) return mySmoke;
	var _inst = instance_create_depth(_x, _y, depth + 1, obj_player_smoke);
	_inst.sprite_index = _sprite;
	_inst.image_speed = _spd;
	_inst.loop = _loop;
	_inst.image_alpha = 1;
	return _inst;
	
}

function dropToFloor() {
	var _floorCheck = y + (ySpeed + grav);
	var _foundFloor = false;
	if _floorCheck >= floorY { //dropped on floor
		if ySpeed != 0 {
			image_index = image_number - 3;
			createSmoke(spr_player_jump_drop_smoke, x - 2);
		}
		y = floorY;
		ySpeed = 0;
		_foundFloor = true;
		if image_index >= image_number - 1 or keyDown or keyUp {
			state = pState.run;
		}
	} else if place_meeting(x, _floorCheck - 1, obj_obstaclePAR) {
		if sign(ySpeed) == -1 { //hit it on top
			exit;
		}
		if ySpeed != 0 {
			image_index = image_number - 3;
			createSmoke(spr_player_jump_drop_smoke, x - 2, y + 10);
		}
		var _stopper = 0;
		while !place_meeting(x, y, obj_obstaclePAR) and _stopper < 16 {
			y++;
			_stopper++;
		}
		ySpeed = 0;
		_foundFloor = true;
		if image_index >= image_number - 1 or keyDown or keyUp {
			state = pState.run;
		}
	}
	return _foundFloor;
}