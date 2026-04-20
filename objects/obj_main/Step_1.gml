gp_anykey = false;

var _pad_num = 0;

for (var _i = gp_face1; _i <= gp_padr; _i++) {
    if (gamepad_button_check_pressed(_pad_num, _i)) {
		gamepad_last = _i;
		gp_anykey = true;
		break;
	}
}

for (var _i = 0; _i < 2; _i++) {	
	g.gp_pressed[@ _i] = [false, false, false, false, false, false, false, false];
	g.gp_released[@ _i] = [false, false, false, false, false, false, false, false];

	var _h_axis = 0;
	var _v_axis = 0;
	var _ls_up = false;
	var _ls_down = false;
	var _ls_left = false;
	var _ls_right = false;
	var _rs_up = false;
	var _rs_down = false;
	var _rs_left = false;
	var _rs_right = false;

	_h_axis = gamepad_axis_value(_i, gp_axislh);
	_v_axis = gamepad_axis_value(_i, gp_axislv);

	_ls_up = (_v_axis < -0.5);
	_ls_down = (_v_axis > 0.5);
	_ls_left = (_h_axis < -0.5);
	_ls_right = (_h_axis > 0.5);
	
	_h_axis = gamepad_axis_value(_i, gp_axisrh);
	_v_axis = gamepad_axis_value(_i, gp_axisrv);
	
	_rs_up = (_v_axis < -0.5);
	_rs_down = (_v_axis > 0.5);
	_rs_left = (_h_axis < -0.5);
	_rs_right = (_h_axis > 0.5);
	
	if (_ls_up && !g.gp_press[@ _i][@ 0]) { g.gp_pressed[@ _i][@ 0] = true; }
	if (_ls_down && !g.gp_press[@ _i][@ 1]) { g.gp_pressed[@ _i][@ 1] = true; }
	if (_ls_left && !g.gp_press[@ _i][@ 2]) { g.gp_pressed[@ _i][@ 2] = true; }
	if (_ls_right && !g.gp_press[@ _i][@ 3]) { g.gp_pressed[@ _i][@ 3] = true; }
	if (_rs_up && !g.gp_press[@ _i][@ 4]) { g.gp_pressed[@ _i][@ 4] = true; }
	if (_rs_down && !g.gp_press[@ _i][@ 5]) { g.gp_pressed[@ _i][@ 5] = true; }
	if (_rs_left && !g.gp_press[@ _i][@ 6]) { g.gp_pressed[@ _i][@ 6] = true; }
	if (_rs_right && !g.gp_press[@ _i][@ 7]) { g.gp_pressed[@ _i][@ 7] = true; }
	
	if (!_ls_up && g.gp_press[@ _i][@ 0]) { g.gp_released[@ _i][@ 0] = true; }
	if (!_ls_down && g.gp_press[@ _i][@ 1]) { g.gp_released[@ _i][@ 1] = true; }
	if (!_ls_left && g.gp_press[@ _i][@ 2]) { g.gp_released[@ _i][@ 2] = true; }
	if (!_ls_right && g.gp_press[@ _i][@ 3]) { g.gp_released[@ _i][@ 3] = true; }
	if (!_rs_up && g.gp_press[@ _i][@ 4]) { g.gp_released[@ _i][@ 4] = true; }
	if (!_rs_down && g.gp_press[@ _i][@ 5]) { g.gp_released[@ _i][@ 5] = true; }
	if (!_rs_left && g.gp_press[@ _i][@ 6]) { g.gp_released[@ _i][@ 6] = true; }
	if (!_rs_right && g.gp_press[@ _i][@ 7]) { g.gp_released[@ _i][@ 7] = true; }
	
	g.gp_press[@ _i] = [_ls_up, _ls_down, _ls_left, _ls_right, _rs_up, _rs_down, _rs_left, _rs_right];
}