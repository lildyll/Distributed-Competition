text = choose("Boom!", "Booyah!", "In your face!", "Owned!", "Nice try!", "Jeez!", 
"Best color!", "Sheesh!", "That's gotta hurt!", "Yikes!", "Did you see that?!", 
"Wow!", "Woah!", "That ain't PG!", "Dunked on!");
winnerColor = c_white;

x = room_width/2;
y = 32;

stage = 1;
scaleStart = .5;
scaleSpd = .2;
scale = scaleStart;
scaleMax = 2;
holdTimer = FPS * 1.5;

depth = -10000;