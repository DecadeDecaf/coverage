var _friendly = true;
var _affordable = true;

if (g.turn == 1 && g.minutes_blue < cost) { _affordable = false; }
if (g.turn == 2 && g.minutes_red < cost) { _affordable = false; }

if (g.turn == 2 && g.singleplayer) { _friendly = false; }

var _mx = (_friendly ? mouse_x : obj_cpu.x);
var _my = (_friendly ? mouse_y : obj_cpu.y);

var _clicking = (_friendly ? mouse_check_button_pressed(mb_left) : obj_cpu.click);

if (_mx > x - 250 && _my > y - 64 && _mx < x + 250 && _my < y + (short ? 108 : 192)) {
	alph = clamp(alph + 0.025, 0, 0.25);
	if (_clicking && _affordable) {
		var _plan = title;
		if (g.turn == 1) { g.minutes_blue -= cost; }
		if (g.turn == 2) { g.minutes_red -= cost; }
		instance_destroy(obj_plan);
		with (obj_main) {
			execute_plan(_plan);
		}
	}
} else {
	alph = clamp(alph - 0.05, 0, 0.25);
}