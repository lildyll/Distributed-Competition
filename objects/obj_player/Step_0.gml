var _inputBits = 0;
mask_index = spr_player_run;

if instance_exists(obj_server) and playerID == obj_server.clientID playerHost = true;

//get color
var _colorIndex = playerID mod 4;
mainCol = cOrder[_colorIndex];

//if keyboard_check_pressed(ord("F")) {hp = 0;}

if (!connected or (instance_exists(obj_client) and playerID == obj_client.clientID) or playerHost)
and !instance_exists(obj_transition) and !instance_exists(obj_textAnnouncement) {
	
	//check fallen off map
	if y >= room_height + 32 {
		hp = 0;
		state = pState.dead;
	}
	
	mLeft = mouse_check_button(mb_left);
	mRight = mouse_check_button(mb_right);

	keyUpPressed = keyboard_check_pressed(vk_up) or keyboard_check_pressed(ord("W"));
	keyDownPressed = keyboard_check_pressed(vk_down) or keyboard_check_pressed(ord("S"));

	mLeftPressed = mouse_check_button_pressed(mb_left);
	
	mRightPressed = mouse_check_button_pressed(mb_right);
	keyDown = keyboard_check(vk_down) or keyboard_check(ord("S"));
	keyUp = keyboard_check(vk_up) or keyboard_check(ord("W"));
	keyLeft = keyboard_check(vk_left) or keyboard_check(ord("A"));
	keyRight = keyboard_check(vk_right) or keyboard_check(ord("D"));
	keyEmote = keyboard_check_pressed(ord("E"));
	keyAttack = mLeft or mLeftPressed or keyboard_check(vk_space);
	keyChat = keyboard_check_pressed(vk_enter) or keyboard_check(vk_enter);
	keyBlock = mRight or keyboard_check(vk_shift);
	
	if keyboard_check_pressed(vk_escape) and canChat {
		if instance_exists(obj_options) {
			instance_destroy(obj_options);
		} else {
			with instance_create_layer(room_width/2, room_height/2, "Heaven", obj_options) {
				col = other.mainCol;
				player = other.id;
			}
			canChat = false;
		}
	}
	
	if keyChat and canChat {
		if !instance_exists(obj_textbox) {
			with instance_create_layer(room_width/2, room_height/2, "Heaven", obj_textbox) {
				col = other.mainCol;
				playerID = other.playerID;
				player = other.id;
			}
			canChat = false;
		}
	}
	
	if instance_exists(obj_options) or instance_exists(obj_textbox) {
		mLeft =  false;
		mRight =  false;

		keyUpPressed =  false;
		keyDownPressed =  false;

		mLeftPressed =  false;
	
		mRightPressed =  false;
		keyDown =  false;
		keyUp =  false;
		keyLeft =  false;
		keyRight =  false;
		keyEmote =  false;
		keyAttack = false;
		keyBlock = false;
	}
	
	//hit stuff
	if blockTime > 0 {
		keyBlock = false; //cant block
		blockTime--;
	} 
	
	var _collisionBox = collision_point(x, y, obj_attackBox, false, true);
	if instance_exists(_collisionBox) {
		//check blocked
		if sprite_index == spr_player_block and image_index < blockEndIndex {
			//possible parry?
			blockTime = blockTimeMax;
			state = pState.idle;
		} else if _collisionBox.myID != playerID { //not my hit => get hit
			audio_play_sound(choose(snd_hit_1, snd_hit_2, snd_hit_3), 1, false);
			gpHitGround = false;
			pushBack(_collisionBox);
			var _newHp = hp - _collisionBox.damage;
			if _newHp <= 0 { //die
				hp = 0;
				state = pState.dead;
			} else {
				hp = _newHp;
				state = pState.hit;
			}
		}
		//instance_destroy(_collisionBox); //maybe? might want to keep it to hit multiple people
	}
	
	
	var _leftRight = keyRight - keyLeft;
	
	if place_meeting(x, y + 1, obj_floor) {
		coyote = coyoteMax;
	} else {
		
		coyote = clamp(coyote - 1, 0, coyoteMax);
	}
	
	if coyote > 0 {
		canJump = true;
	}
	if canJump and stateJump {
		if keyUp {
			ySpeed = jumpSpd;
			state = pState.jump;
			instance_create_depth(x, y + 7, depth, obj_smoke);
			audio_play_sound(snd_jump, 1, false);
			canJump = false;
			coyote = 0;
			image_index = 0;
			sprite_index = spr_player_jump;
		}
	}
	
	//animations
	if sprite_index == spr_player_jump { //make it so you only animate after it plays the full dtop animation
		if image_index >= image_number - 1 {
			doSprite = true;
		}
	}
	
	ySpeed += grav;
	if place_meeting(x, y + ySpeed, obj_floor) {
		while !place_meeting(x, y + sign(ySpeed), obj_floor) {
			y += sign(ySpeed);
		}
		ySpeed = 0;
	} 
	
	if hp <= 0 {
		state = pState.dead;
	}
	
	switch state {
		
		case pState.dead: 
			//set dead sprite
			image_speed = 0;
			xSpeed = 0;
			ySpeed = 0;
			pushBackX = 0;
			pushBackY = 0;
			doSprite = true;
			stateJump = false;
			gpHitGround = false;
			myHit = noone;

		break;
		
		case pState.idle:
		grav = gravNormal;
		if doSprite {
			if sprite_index != spr_player_idle {
				image_index = 0;
				sprite_index = spr_player_idle;
			}
			image_speed = iSpd.idle;
		}
			xSpeed = 0;
			stateJump = true;
			if _leftRight != 0 {
				state = pState.run;
			} else if (keyAttack) {
				state = pState.attacking;
			} else if keyBlock {
				state = pState.blocking;
			}
		break;
		
		case pState.run: 
		
			if image_index == 2 or image_index == 7 {
				audio_play_sound(choose(snd_walk_1, snd_walk_2, snd_walk_3), 1, false);
			}
		
			stateJump = true;
			if _leftRight != 0 image_xscale = _leftRight;
			xSpeed = (spd * _leftRight);
			if doSprite {
				if sprite_index != spr_player_run {
					image_index = 0;
					sprite_index = spr_player_run;
				}
				image_speed = iSpd.run;
			}
			
			if !place_meeting(x, y + 1, obj_floor) and keyDownPressed {
				state = pState.groundpound;
			} else {
				if xSpeed == 0 and ySpeed == 0 {
					state = pState.idle;
				} else if (keyAttack) {
					state = pState.attacking;
				} else if keyBlock {
					state = pState.blocking;
				} else if keyDownPressed {
					state = pState.slide;
					slideDir = _leftRight;
				}
			}
			
		break;
		
		case pState.slide:
			stateJump = true;
			xSpeed = (spd * slideDir);
			
			if doSprite {
				if sprite_index != spr_player_slide {
					image_index = 0;
					sprite_index = spr_player_slide;
				}
				image_speed = iSpd.slide;
			}
			
			
			if keyUp {
				state = pState.jump;
				break;
			}
			
			if image_index >= image_number - 1 or _leftRight != slideDir {
				state = pState.run;
				break;
			}
		break;
		
		case pState.jump:
			if sprite_index != spr_player_jump {
				image_index = 0;
				sprite_index = spr_player_jump;
			}
			if _leftRight != 0 image_xscale = _leftRight;
			xSpeed = (spd * _leftRight);
			doSprite = false;
			if ySpeed == 0 and place_meeting(x, y + 1, obj_floor) {
				image_index = 15;
				audio_play_sound(snd_walk_3, 1, false);
				if xSpeed = 0 {
					state = pState.idle;
				} else {
					state = pState.run;
				}
			}
			
			if !place_meeting(x, y + 1, obj_floor) and keyDownPressed {
				state = pState.groundpound;
			}
			
			if (keyAttack) {
				state = pState.attacking;
				attackChosen = true;
				attack = attack_punch1_air;
				hitDir = point_direction(0, y, image_xscale, y);
				grav = gravFloat;
			}
			
			image_speed = iSpd.jump;
		break;
		
		case pState.attacking:
			stateJump = false;
			doSprite = true;
			//choose attack
			if !attackChosen {
				hitDir = point_direction(0, y, image_xscale, y);
				if sprite_index == spr_player_run or sprite_index == spr_player_idle {
					attack = attack_punch1;
					hitDir = point_direction(0, y, image_xscale, y);
				} else if sprite_index == spr_player_punch_1 {
					attack = attack_punch2;
					hitDir = point_direction(0, y, image_xscale, y);
				} else if sprite_index == spr_player_punch_2 {
					attack = attack_kickflip;
					hitDir = point_direction(0, 0, image_xscale, -1);
				} else if sprite_index == spr_player_kickflip {
					attack = attack_punch1;
					hitDir = point_direction(0, y, image_xscale, y);
				}
				attackChosen = true;
			}
			
			//do it 
			if sprite_index != attack.sprite {
					xSpeed = 0;
					image_index = 0;
					sprite_index = attack.sprite;
				}
			
				if image_index < attack.attackBoxFrame { 
					var _extend = image_xscale * (attack.length - (sprite_get_width(spr_boundary) * .5 / attack.xStretch));
					if !instance_exists(myHit) {
						myHit = instance_create_layer(x + _extend, y, layer,obj_attackBox);
						myHit.myID = playerID;
						myHit.damage = attack.damage;
						myHit.dir = hitDir;
						myHit.image_xscale = attack.xStretch;
					} else {
						myHit.x = x + _extend;
						myHit.y = y;
					
						//send the data
						if connected {
							var _hit = scr_sendPlayerHit(playerID, myHit.x, myHit.y, 
							myHit.image_xscale, myHit.image_yscale, myHit.damage, hitDir);
							
							if playerHost {
								network_send_packet(obj_server.client, _hit, buffer_tell(_hit));
							} else {
								network_send_packet(obj_client.client, _hit, buffer_tell(_hit));	//send the packet to the server with clients socket
							}
							buffer_delete(_hit);
						}
					}
				} else {
					if instance_exists(myHit) {
						//send the data
						if connected {
							var _hit = scr_sendPlayerHit(playerID, myHit.x, myHit.y, 
							myHit.image_xscale, myHit.image_yscale, -1, hitDir); //-1 indicates it should delete it
	
							if playerHost {
								network_send_packet(obj_server.client, _hit, buffer_tell(_hit));
							} else {
								network_send_packet(obj_client.client, _hit, buffer_tell(_hit));	//send the packet to the server with clients socket
							}
							
							buffer_delete(_hit);
						}
						
						instance_destroy(myHit);
					}
					
					myHit = noone;
				}
				
				if image_index < attack.moveFrame {
					xSpeed = attack.moveSpd * sign(image_xscale);
				} else {
					xSpeed = lerp(xSpeed, 0, .1);
					if keyAttack and image_index >= attack.endFrame {
						image_index = 0;
						attackChosen = false;
					} else if !place_meeting(x, y + 1, obj_floor) and keyDown {
						if instance_exists(myHit) {
						//send the data
						if connected {
							var _hit = scr_sendPlayerHit(playerID, myHit.x, myHit.y, 
							myHit.image_xscale, myHit.image_yscale, -1, hitDir); //-1 indicates it should delete it
	
							if playerHost {
								network_send_packet(obj_server.client, _hit, buffer_tell(_hit));
							} else {
								network_send_packet(obj_client.client, _hit, buffer_tell(_hit));	//send the packet to the server with clients socket
							}
							
							buffer_delete(_hit);
						}
						instance_destroy(myHit);
					}
					myHit = noone;
						state = pState.groundpound;
					}
				}
				if image_index >= image_number - 1 {
					attackChosen = false;
					state = pState.idle;
				}
			
				image_speed = iSpd.punch;
		break;
		
		case pState.groundpound: 
			doSprite = true;
			stateJump = false;
			attack = attack_groundpound;
			if sprite_index != spr_player_groundpound {
				image_index = 0;
				sprite_index = spr_player_groundpound;
				ySpeed = gpSpeed;
			}
			ySpeed += grav;
			xSpeed = 0;
			if !gpHitGround {
				if image_index >= gpEndFrame - 1 {
					image_index = gpStartFrame;
				}
				if place_meeting(x, y + ySpeed, obj_floor) {
					while !place_meeting(x, y + sign(ySpeed), obj_floor) {
						y += sign(ySpeed);
					}
					gpHitGround = true;
					audio_play_sound(snd_thud, 1, false);
					ySpeed = 0;
					image_index = gpEndFrame;
					scr_screenShake(1, 20);
					with instance_create_depth(x + 2, y + 7, depth - 1 , obj_smoke) {
						sprite_index = spr_player_groundpound_smoke;
						image_speed = 15;
					}
					
				} 
			} else {
				var _extend = image_xscale * (attack.length - (sprite_get_width(spr_boundary) * .5 / attack.xStretch));
				if !instance_exists(myHit) {
					myHit = instance_create_layer(x + _extend, y, layer,obj_attackBox);
					myHit.myID = playerID;
					myHit.damage = attack.damage;
					myHit.dir = hitDir;
					myHit.image_xscale = attack.xStretch;
				} else {
					myHit.x = x + _extend;
					myHit.y = y;
					
					//send the data
					if connected {
						var _hit = scr_sendPlayerHit(playerID, myHit.x, myHit.y, 
						myHit.image_xscale, myHit.image_yscale, myHit.damage, hitDir);
						
						if playerHost {
							network_send_packet(obj_server.client, _hit, buffer_tell(_hit));
						} else {
							network_send_packet(obj_client.client, _hit, buffer_tell(_hit));	//send the packet to the server with clients socket
						}
						buffer_delete(_hit);
					}
				}
				
				if image_index >= image_number - 1 {
					gpHitGround = false;
					state = pState.idle;
					if instance_exists(myHit) {
						//send the data
						if connected {
							var _hit = scr_sendPlayerHit(playerID, myHit.x, myHit.y, 
							myHit.image_xscale, myHit.image_yscale, -1, hitDir); //-1 indicates it should delete it
	
							if playerHost {
								network_send_packet(obj_server.client, _hit, buffer_tell(_hit));
							} else {
								network_send_packet(obj_client.client, _hit, buffer_tell(_hit));	//send the packet to the server with clients socket
							}
							
							buffer_delete(_hit);
						}
						instance_destroy(myHit);
					}
					myHit = noone;
				}
			}
			
		break;
		
		case pState.blocking:
			if sprite_index != spr_player_block {
				image_index = 0;
				sprite_index = spr_player_block;
			}
			
			xSpeed = 0;
			if !keyBlock {
				if image_index < blockEndIndex {
					state = pState.idle;
				}
			}
			
			if image_index >= image_number - 1 {
				state = pState.idle;
			}
			
			image_speed = iSpd.jump;
		break;
		
		case pState.hit:
			if sprite_index != hitSprite {
				image_index = 0;
				sprite_index = hitSprite;
			}
			
			if image_index >= image_number - 1 {
				state = pState.idle;
			}
			
			image_speed = iSpd.run;
		break;
	}
	
	if pushBackX != 0 { //should slide x
		xSpeed = pushBackX;
		
		var _resistance = airResistance;
		if place_meeting(x, y + 1, obj_floor) {
			_resistance += floorResistance;
		} 

		pushBackX = lerp(pushBackX, 0, _resistance);
	}
	
	if pushBackY != 0 { //set it once to be like a jump
		ySpeed = pushBackY;
		pushBackY = 0;
	}
	
	if place_meeting(x, y + ySpeed, obj_floor) {
		while !place_meeting(x, y + sign(ySpeed), obj_floor) {
			y += sign(ySpeed);
		}
		pushBackY = 0;
		ySpeed = 0;
	} 
	
	if place_meeting(x + xSpeed, y, obj_floor) {
		while !place_meeting(x + sign(xSpeed), y, obj_floor) {
			x += sign(xSpeed);
		}
		pushBackX = -pushBackX/2;
		xSpeed = -xSpeed/2; //make it go in the other direction
	} 
	
	x += xSpeed;
	y += ySpeed;
	
	//send the data
	if connected {
		var _buff = scr_sendPlayerData(playerID, state, x, y, sprite_index, image_index, mainCol, hp, image_xscale);
		
		if playerHost {
			network_send_packet(obj_server.client, _buff, buffer_tell(_buff));
		} else {
			network_send_packet(obj_client.client, _buff, buffer_tell(_buff));	//send the packet to the server with clients socket
		}
		
		buffer_delete(_buff);	//no memory leaks
	}
} else if instance_exists(obj_transition) or instance_exists(obj_textAnnouncement) {
	image_speed = 0;
	xSpeed = 0;
	ySpeed = 0;
	pushBackX = 0;
	pushBackY = 0;
	doSprite = true;
	stateJump = false;
	gpHitGround = false;
	attack = attack_punch1;
	myHit = noone;
	state = pState.idle;
} else { //not my player but spawn effects
	if state == pState.jump and prevState != pState.jump {
		instance_create_depth(x, y + 7 + 3, depth, obj_smoke); //extra due to "lag"
	}
	prevState = state;
}

