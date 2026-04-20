var _friendly = true;

if (g.turn == 2 && g.singleplayer) { _friendly = false; }

var _mx = (_friendly ? mouse_x : obj_cpu.x);
var _my = (_friendly ? mouse_y : obj_cpu.y);

var _clicking = (_friendly ? mouse_check_button_pressed(mb_left) : obj_cpu.click);

if (abs(x - _mx) < 64 && abs(y - _my) < 64) {
	size += 0.02;
	image_angle += 2;
	if (size > 1) { size = 1; }
	if (image_angle > 20) { image_angle = 20; }
	if (_clicking) {
		if (g.training_units) {
			if (instance_exists(land)) {
				add_units(land, units);
			}
			g.training_units = false;
			instance_destroy(obj_target);
		} else if (g.selecting_units) {
			var _units = units;
			if (instance_exists(land)) {
				with (obj_main) {
					move_units(o.land);
				}
			}
			g.selecting_units = false;
		} else if (g.moving_units) {
			var _captured = false;
			if (instance_exists(land)) {
				var _turn = g.turn;
				if (land.captured == 0 || land.captured == _turn || count_units(land) == 0) {
					if (land.captured != _turn) {
						land.captured = _turn;
						_captured = true;
					} else {
						g.roaming = 0;
					}
					add_units(land, units);
				} else {
					initiate_combat(units, land);
				}
			}
			g.moving_units = false;
			instance_destroy(obj_target);
			if (_captured && g.roaming > 0) {
				g.roaming--;
				if (g.roaming > 0) {
					with (obj_main) {
						move_units(o.land);
					}
				}
			}
		} else if (g.selecting_booth) {
			if (instance_exists(land)) {
				land.booth = false;
				with (obj_main) {
					place_booth(true, o.land);
				}
			}
			g.selecting_booth = false;
		} else if (g.placing_booth) {
			if (instance_exists(land)) {
				land.booth = true;
				if (g.tardis) {
					set_units(land, []);
				}
			}
			g.tardis = false;
			g.placing_booth = false;
			instance_destroy(obj_target);
		}
	}
} else {
	size -= 0.02;
	image_angle -= 2;
	if (size < 0.84) { size = 0.84; }
	if (image_angle < 0) { image_angle = 0; }
}

image_xscale = size;
image_yscale = size;