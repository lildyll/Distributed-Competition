//backend
playerID = 0; //temp

mainCol = choose(cRed, cBlue, cGreen, cYellow); // global.currentPalette[1];
bgCol = global.currentPalette[2];
col = bgCol;
flash = false;
angle = 0;
doOutline = true;

connected = true;
if room == rm_start {
	connected = false;
}

enum iSpd {
	idle = 10,
	run = 15,
	jump = 10,
	punch = 15,
	slide = 15
}

image_speed = iSpd.idle;
hpMax = 50;
hp = hpMax;

//hosting? - if yes, connect to server obj
playerHost = false;
broadcastDeath = false;

//movement
xSpeed = 0;
spd = 2.5;
jumpSpd = -6;
ySpeed = 0;
gravNormal = 0.25;
gravFloat = 0.1;
grav = gravNormal;
coyoteMax = 10;
coyote = coyoteMax;
canJump = false;
stateJump = false;
doSprite = true;
slideDir = 0;
chat = noone;
canChat = true;

//fighting
punchSpd = 3;
hit = false;
dmg = 1;
dmgToTake = 0;
myHit = noone;
hitDir = 0;
pushBackX = 0;
pushBackY = 0;
force = 2;
airResistance = .1;
floorResistance = .2;
yResistance = .3;
blockTimeMax = FPS;
blockTime = 0;

function pushBack(_hit) {
	var _dir = _hit.dir;
	var _dmg =  _hit.damage;
	
	image_xscale = (_dir > 90 and _dir < 270) ? 1 : -1;
	
	pushBackX = lengthdir_x(force * _dmg, _dir);
	pushBackY = lengthdir_y(force * _dmg * yResistance, _dir);
	
}

hitSprite = spr_player_hit_ground_1;

#region attacks
attackStretch = 1.5;
attack_punch1 = {
	sprite: spr_player_punch_1,
	damage: 5,
	length: 15,
	attackBoxFrame: 4, //when the attack box should disappear
	endFrame: 5, //when you should be able to attack again
	moveFrame: 2, //when you should stop moving
	moveSpd: 2,
	xStretch: attackStretch,
}
attack_punch2 = {
	sprite: spr_player_punch_2,
	damage: 5,
	length: 15,
	attackBoxFrame: 4, 
	endFrame: 5,
	moveFrame: 2,
	moveSpd: 2,
	xStretch: attackStretch,
}
attack_kickflip = {
	sprite: spr_player_kickflip,
	damage: 10,
	length: 15,
	attackBoxFrame: 4, 
	endFrame: 10,
	moveFrame: 2,
	moveSpd: 2,
	xStretch: attackStretch,
}
attack_punch1_air = {
	sprite: spr_player_punch_1,
	damage: 5,
	length: 15,
	attackBoxFrame: 4, //when the attack box should disappear
	endFrame: 5, //when you should be able to attack again
	moveFrame: 3, //when you should stop moving
	moveSpd: 4,
	xStretch: attackStretch,
}

#endregion
attackChosen = false;
attack = attack_punch1;

gpHitGround = false;
gpEndFrame = 10;
gpStartFrame = 2;
gpSpeed = 3;

attack_groundpound = {
	sprite: spr_player_groundpound,
	damage: 10,
	length: 4,
	attackBoxFrame: 4, 
	endFrame: gpEndFrame + 1,
	moveFrame: 0,
	moveSpd: 0,
	xStretch: 2.5,
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
	attacking,
	blocking,
	hit,
	groundpound,
	locked
}
state = pState.jump;
prevState = state;

blockEndIndex = 8;