if (!instance_exists(targ)) {
	targ = -1;
}

click = false;

if (g.fc % 45 == 0) {
	if (g.singleplayer && g.turn == 2) {
		if (targ != -1) {
			if (point_distance(x, y, targ_x, targ_y) <= 8) {
				click = true;
			}
		} else {
			var _plans = instance_number(obj_plan);
			var _targs = instance_number(obj_target);
			if (_plans > 0) {
				targ = instance_find(obj_plan, irandom_range(0, _plans - 1));
				if (g.minutes_red < targ.cost) {
					targ = -1;
				}
			} else if (_targs > 0) {
				targ = instance_find(obj_target, irandom_range(0, _targs - 1));
			}
			if (targ != -1) {
				targ_x = targ.x;
				targ_y = targ.y;
			}
		}
	}
}

if (targ != -1) {
	if (point_distance(x, y, targ_x, targ_y) > 8) {
		x += ((targ_x - x) / 12);
		y += ((targ_y - y) / 12);
	}
}