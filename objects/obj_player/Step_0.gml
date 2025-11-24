var _inputBits = 0;

if (instance_exists(obj_server) and playerID == obj_server.clientID) playerHost = true;

if (instance_exists(obj_client) and playerID == obj_client.clientID) or playerHost {
	mLeft = mouse_check_button(mb_left);
	mRight = mouse_check_button(mb_right);

	keyUpPressed = keyboard_check_pressed(vk_up);
	keyDownPressed = keyboard_check_pressed(vk_down);

	mLeftPressed = mouse_check_button_pressed(mb_left);
	mRightPressed = mouse_check_button_pressed(mb_right);
	keyDown = keyboard_check(vk_down) or keyboard_check(ord("S"));
	keyUp = keyboard_check(vk_up) or keyboard_check(ord("W")) or keyboard_check(vk_space);
	keyLeft = keyboard_check(vk_left) or keyboard_check(ord("A"));
	keyRight = keyboard_check(vk_right) or keyboard_check(ord("D"));
	keyEmote = keyboard_check_pressed(ord("E"));
	
	
	//hit stuff
	var _collisionBox = collision_point(x, y, obj_attackBox, false, true);
	if instance_exists(_collisionBox) {
		if _collisionBox.myID != playerID { //not my hit => get hit
			var _newHp = hp - _collisionBox.damage;
			if _newHp <= 0 { //die
				instance_destroy();
			} else {
				hp = _newHp;
			}
		}
		instance_destroy(_collisionBox); //maybe? might want to keep it to hit multiple people
	}
	
	
	var _leftRight = keyRight - keyLeft;
	if (keyDown)       y+=1;
	if (mRightPressed) x+=1;
	if (keyEmote)      x+=1;
	
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
	
	switch state {
		case pState.idle:
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
			} else if (mLeftPressed) {
				state = pState.punch1;
			}
		break;
		
		case pState.run: 
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
			if xSpeed == 0 and ySpeed == 0 {
				state = pState.idle;
			} else if (mLeftPressed) {
				state = pState.punch1;
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
				if xSpeed = 0 {
					state = pState.idle;
				} else {
					state = pState.run;
				}
			}
			
			image_speed = iSpd.jump;
		break;
		
		case pState.punch1:
			stateJump = false;
			if sprite_index != spr_player_punch_1 {
				xSpeed = 0;
				image_index = 0;
				sprite_index = spr_player_punch_1;
			}
			
			if image_index < 4 { 
				if !instance_exists(myHit) {
					myHit = instance_create_layer(x + (image_xscale * attackLength.punch1), y, layer,obj_attackBox);
					myHit.myID = playerID;
					myHit.damage = attackDmg.punch1;
				} else {
					myHit.x = x + (image_xscale * attackLength.punch1);
					myHit.y = y;
					
					//send the data
					var _hit = scr_sendPlayerHit(playerID, myHit.x, myHit.y, 
					myHit.image_xscale, myHit.image_yscale, myHit.damage);
	
					if playerHost {
						network_send_packet(obj_server.client, _hit, buffer_tell(_hit));
					} else {
						network_send_packet(obj_client.client, _hit, buffer_tell(_hit));	//send the packet to the server with clients socket
					}
					buffer_delete(_hit);
				}
			} else {
				if instance_exists(myHit) {
					//send the data
					var _hit = scr_sendPlayerHit(playerID, myHit.x, myHit.y, 
					myHit.image_xscale, myHit.image_yscale, -1); //-1 indicates it should delete it
	
					if playerHost {
						network_send_packet(obj_server.client, _hit, buffer_tell(_hit));
					} else {
						network_send_packet(obj_client.client, _hit, buffer_tell(_hit));	//send the packet to the server with clients socket
					}
					instance_destroy(myHit);
				}
				myHit = noone;
			}
			
			if image_index < 2 {
				xSpeed = punchSpd * sign(image_xscale);
			} else {
				xSpeed = lerp(xSpeed, 0, .1);
			}
			
			if image_index >= image_number - 1 {
				state = pState.idle;
			}
			
			image_speed = iSpd.punch;
		break;
	}
	
	x += xSpeed;
	y += ySpeed;
	
	if hit {
		hp -= dmgToTake;
		hit = false;
	}
	
	//send the data
	var _buff = scr_sendPlayerData(playerID, x, y, sprite_index, image_index, mainCol, hp, image_xscale);
	
	if playerHost {
		network_send_packet(obj_server.client, _buff, buffer_tell(_buff));
	} else {
		network_send_packet(obj_client.client, _buff, buffer_tell(_buff));	//send the packet to the server with clients socket
	}
	buffer_delete(_buff);			//no memory leaks
}

