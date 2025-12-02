cam = view_camera[0];
viewWHalf = camera_get_view_width(cam) * .5;
viewHHalf = camera_get_view_height(cam) * .5;
xTo = room_width/2;
yTo = room_height/2;

x = xTo;
y = yTo;

//shake
shakeLength = 0;
shakeMag = 0;
shakeRemain = shakeMag;
buff = 0;

seperation = 0;
