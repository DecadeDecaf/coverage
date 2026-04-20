x += xv;
y += yv;

image_angle = point_direction(0, 0, xv, yv);

xv /= 1.01;
yv += 0.2;

if (yv > 0) {
	yv *= 1.05;
	with (obj_unit) {
		if (iframes == 0) {
			if (carrier != o.carrier) {
				if (place_meeting(x, y, o.id)) {
					hp -= o.dmg;
					iframes = 5;
					instance_destroy(o);
					exit;
				}
			}
		}
	}


	if (y > 1200) {
		instance_destroy();
	}
}