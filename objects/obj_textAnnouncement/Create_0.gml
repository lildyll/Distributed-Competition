text = choose("Boom!", "Booyah!", "In your face!", "Owned!", "Nice try!", "Jeez!", 
"Best color!", "Sheesh!", "That's gotta hurt!", "Yikes!", "Did you see that!", 
"Wow!", "Woah!", "That ain't PG!", "Dunked on!", "Get Pwned!", "Holy smokes!", "Gee Willikers!",
"Wowza!", "Get outta here!", "G.O.A.T!", "Badabing Badaboom!");

winnerColor = c_white;

x = room_width/2;
y = 32;

stage = 1;
scaleStart = .5;
scaleSpd = .2;
scale = scaleStart;
scaleMax = 3;
holdTimer = FPS * 1.5;

depth = -999;

