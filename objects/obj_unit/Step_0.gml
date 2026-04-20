var _backline = -1;

with (obj_unit) {
	if (carrier != o.carrier) {
		if (_backline == -1) {
			_backline = id;
		} else if ((o.carrier == 1 ? (x > _backline.x) : (x < _backline.x))) {
			_backline = id;
		}
	}
}

if (behavior == "S") {
	if (y < ground || yv < 0) {
		image_index = 1;
		x += xv;
		y += yv;
		xv /= 1.05;
		yv += 0.5;
	} else {
		image_index = 0;
		if (jump_cooldown > 0) {
			jump_cooldown--;
		} else {
			if (_backline != -1) {
				var _offscreen_left = (x < 128);
				var _offscreen_right = (x > 2432);
				if ((x < _backline.x - 20) && !_offscreen_right) {
					yv = (-random_range(10, 12));
					xv = (random_range(15, 18));
					image_xscale = 1;
				} else if ((x > _backline.x + 20) && !_offscreen_left) {
					yv = (-random_range(10, 12));
					xv = (-random_range(15, 18));
					image_xscale = -1;
				} else {
					yv = (-random_range(16, 18));
				}
				jump_cooldown = irandom_range(jump_range_min, jump_range_max);
			}
		}
	}
}

if (behavior == "C") {
	if (_backline != -1) {
		if (x < _backline.x - 48) {
			xv += spd;
			image_xscale = 1;
		} else if (x > _backline.x + 48) {
			xv -= spd;
			image_xscale = -1;
		} else {
			if (poop_cooldown > 0) {
				poop_cooldown--;
			} else {
				var _poop = instance_create_depth(x, y - 96, depth, obj_poop);
				_poop.carrier = carrier;
				poop_cooldown = irandom_range(poop_range_min, poop_range_max);
			}
		}
	}
	xv /= 1.1;
	if (y < sky || yv < 0) {
		x += xv;
		y += yv;
		yv += 0.5;
	} else {
		yv = -random_range(5, 6);
		spd += random_range(-0.2, 0.2);
		spd = clamp(spd, 0.2, 0.6);
	}
	if (yv < 0) {
		image_index = 0;
	} else {
		image_index = 1;
	}
}

if (behavior == "B") {
	var _burn = (10 + (burner_number * burner_cooldown));
	print(_burn);
	if (fc == _burn) {
		xv = (random_range(14, 20) * image_xscale);
		yv = (-random_range(18, 22));
		image_xscale = 1;
	} else if (fc > _burn) {
		image_angle = point_direction(0, 0, xv, yv);
		x += xv;
		y += yv;
		xv /= 1.005;
		yv += 0.25;
		if (y >= ground) {
			hp = 0;
		}
	}
}