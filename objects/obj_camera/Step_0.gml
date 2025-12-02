//update obj position
x += (xTo - x) / 15;
y += (yTo - y) / 15;



x = clamp(x,viewWHalf+buff,room_width-viewWHalf-buff);
y = clamp(y,viewHHalf+buff,room_height-viewHHalf-buff);

//shake
var _shakeX = random_range(-shakeRemain,shakeRemain);
var _shakeY = random_range(-shakeRemain,shakeRemain);
x += _shakeX;
y += _shakeY;

shakeRemain = max(0,shakeRemain-((1/shakeLength)*shakeMag));

//update camera view
camera_set_view_pos(cam,x-viewWHalf,y-viewHHalf);
