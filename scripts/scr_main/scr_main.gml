function create_macros() {
	#macro g global
	#macro o other
	#macro main obj_main
	
	#macro gp_stickl_u (gp_padr + 1)
	#macro gp_stickl_d (gp_padr + 2)
	#macro gp_stickl_l (gp_padr + 3)
	#macro gp_stickl_r (gp_padr + 4)
	#macro gp_stickr_u (gp_padr + 5)
	#macro gp_stickr_d (gp_padr + 6)
	#macro gp_stickr_l (gp_padr + 7)
	#macro gp_stickr_r (gp_padr + 8)
}

function create_globals() {
	g.fc = 0;
	
	g.g_cols = {
		white: #FFEECC,
		black: #46425E,
		light_blue: #00B9BE,
		dark_blue: #15788C,
		light_red: #FFB0A3,
		dark_red: #FF6973
	};
	
	#macro colors g.g_cols
	
	// global variables
	
	g.minutes_blue = 0;
	g.minutes_red = 0;
	g.allowance_blue = 0;
	g.allowance_red = 0;
	g.turn = 0;
	
	g.queued_plan = "";
	
	g.training_units = false;
	g.selecting_units = false;
	g.moving_units = false;
	g.selecting_booth = false;
	g.placing_booth = false;
	
	g.contesting_land = false;
	g.contested_land = -1;
	g.contesting_frames = 0;
	
	g.singleplayer = false;
	g.started = false;
	g.game_over = false;
	g.winner = 0;
	
	g.roaming = 0;
	g.airplane = false;
	g.tardis = false;
	
	g.scalping = false;
	g.markup = 0;
	
	g.second_controller = false;
	
	g.gp_press = [[false, false, false, false, false, false, false, false], [false, false, false, false, false, false, false, false]];
	g.gp_pressed = [[false, false, false, false, false, false, false, false], [false, false, false, false, false, false, false, false]];
	g.gp_released = [[false, false, false, false, false, false, false, false], [false, false, false, false, false, false, false, false]];
	
	g.gp_last = -1;
	g.gp_any = false;
	
	#macro gamepad_last g.gp_last
	#macro keyboard_last keyboard_lastkey
	#macro gp_anykey g.gp_any
}

function create_savefile() {
	g.save = {};
	#macro s g.save
	s.savedata = {};
	s.settings = {};
	#macro sd s.savedata
	#macro ss s.settings
	ss.fullscreen = true;
	ss.resolution = {
		w: 960,
		h: 540
	};
	ss.vsync = true;
	ss.vol = 0.75;
	ss.mute = false;
	ss.controller = false;
	ss.kb_controls = {
		left: vk_left,
		right: vk_right,
		up: vk_up,
		down: vk_down,
		a: ord("Z"),
		b: ord("X")
	};
	ss.gp_controls = {
		left: gp_stickl_l,
		right: gp_stickl_r,
		up: gp_stickl_u,
		down: gp_stickl_d,
		a: gp_face1,
		b: gp_face2
	};
}

function save(_filename, _encrypt, _struct) {
	var _str = "";
	_str = json_stringify(_struct);
	_str = (_encrypt ? base64_encode(_str) : _str);
	var _file = file_text_open_write(_filename);
	file_text_write_string(_file, _str);
	file_text_close(_file);
}

function load(_filename, _encrypted) {
	if (file_exists(_filename)) {
		try {
			var _file = file_text_open_read(_filename);
			var _str = file_text_read_string(_file);
			_str = (_encrypted ? base64_decode(_str) : _str);
			var _struct = json_parse(_str);
			return (_struct);
		} catch(but) {
			print(but.message);
		}
	}
	return -1;
}

function save_savefile() { save("save.txt", true, sd); }
function save_settings() { save("settings.txt", false, ss); }

function load_savefile() { var _struct = load("save.txt", true); sd = struct_merge(sd, _struct); }
function load_settings() { var _struct = load("settings.txt", false); ss = struct_merge(ss, _struct); }

function handle_fullscreen() {
	var _f = keyboard_check_pressed(ord("F"));
	if (_f) { switch_fullscreen(); }
	var _full = window_get_fullscreen();
	ss.fullscreen = _full;
}

function switch_fullscreen() {
	var _full = !window_get_fullscreen();
	set_fullscreen(_full);
}

function set_fullscreen(_full) {
	window_set_fullscreen(_full);
	if (_full) {
		window_set_size(2560, 1440);
	} else {
		window_set_size(ss.resolution.w, ss.resolution.h);
	}
	display_reset(8, ss.vsync);
}

function sift_resolutions() {
	if (!ss.fullscreen) {
		if (ss.resolution.w == 960) {
			ss.resolution.w = 1280;
			ss.resolution.h = 720;
		} else if (ss.resolution.w == 1280) {
			ss.resolution.w = 1366;
			ss.resolution.h = 768;
		} else if (ss.resolution.w == 1366) {
			ss.resolution.w = 1600;
			ss.resolution.h = 900;
		} else if (ss.resolution.w == 1600) {
			ss.resolution.w = 1920;
			ss.resolution.h = 1080;
		} else if (ss.resolution.w == 1920) {
			ss.resolution.w = 640;
			ss.resolution.h = 360;
		} else {
			ss.resolution.w = 960;
			ss.resolution.h = 540;
		}
		window_set_size(ss.resolution.w, ss.resolution.h);
		display_reset(8, ss.vsync);
	}
}

function toggle_vsync() {
	ss.vsync = !ss.vsync;
	display_reset(8, ss.vsync);
}

function handle_restart() {
	var _r = keyboard_check_pressed(ord("R"));
	if (_r) { video_close(); game_restart(); }
}

function handle_gameclose() {
	var _esc = keyboard_check_pressed(vk_escape);
	if (_esc) { game_end(); }
}

function error(_struct) {
	show_debug_message("ERROR: " + string(_struct));
}

function controls_check(_control, _protocol = "p1") {
	var _control_kb = struct_get(ss.kb_controls, _control);
	var _control_gp = struct_get(ss.gp_controls, _control);
	var _kb_check = keyboard_check(_control_kb);
	var _gp1_check = false;
	var _gp2_check = false;
	
	if (_control_gp > gp_padr) {
		var _control_gp_off = (_control_gp - gp_padr - 1);
		_gp1_check = g.gp_press[@ 0][@ _control_gp_off];
		_gp2_check = g.gp_press[@ 1][@ _control_gp_off];
	} else {
		_gp1_check = gamepad_button_check(0, _control_gp);
		_gp2_check = gamepad_button_check(1, _control_gp);
	}
	
	if (_protocol == "any") { return (_kb_check || _gp1_check); }
	if (_protocol == "p2") { return (ss.controller ? (!g.second_controller ? _kb_check : _gp2_check) : _gp1_check); }
	if (_protocol == "not p1") { return (ss.controller ? (_kb_check || _gp2_check) : _gp1_check); }
	
	return (!ss.controller ? _kb_check : _gp1_check);
}

function controls_check_pressed(_control, _protocol = "p1") {
	var _control_kb = struct_get(ss.kb_controls, _control);
	var _control_gp = struct_get(ss.gp_controls, _control);
	var _kb_check = keyboard_check_pressed(_control_kb);
	var _gp1_check = false;
	var _gp2_check = false;
	
	if (_control_gp > gp_padr) {
		var _control_gp_off = (_control_gp - gp_padr - 1);
		_gp1_check = g.gp_pressed[@ 0][@ _control_gp_off];
		_gp2_check = g.gp_pressed[@ 1][@ _control_gp_off];
	} else {
		_gp1_check = gamepad_button_check_pressed(0, _control_gp);
		_gp2_check = gamepad_button_check_pressed(1, _control_gp);
	}
	
	if (_protocol == "any") { return (_kb_check || _gp1_check); }
	if (_protocol == "p2") { return (ss.controller ? (!g.second_controller ? _kb_check : _gp2_check) : _gp1_check); }
	if (_protocol == "not p1") { return (ss.controller ? (_kb_check || _gp2_check) : _gp1_check); }
	
	return (!ss.controller ? _kb_check : _gp1_check);
}

function controls_check_released(_control, _protocol = "p1") {
	var _control_kb = struct_get(ss.kb_controls, _control);
	var _control_gp = struct_get(ss.gp_controls, _control);
	var _kb_check = keyboard_check_released(_control_kb);
	var _gp1_check = false;
	var _gp2_check = false;
	
	if (_control_gp > gp_padr) {
		var _control_gp_off = (_control_gp - gp_padr - 1);
		_gp1_check = g.gp_released[@ 0][@ _control_gp_off];
		_gp2_check = g.gp_released[@ 1][@ _control_gp_off];
	} else {
		_gp1_check = gamepad_button_check_released(0, _control_gp);
		_gp2_check = gamepad_button_check_released(1, _control_gp);
	}
	
	if (_protocol == "any") { return (_kb_check || _gp1_check); }
	if (_protocol == "p2") { return (ss.controller ? (!g.second_controller ? _kb_check : _gp2_check) : _gp1_check); }
	if (_protocol == "not p1") { return (ss.controller ? (_kb_check || _gp2_check) : _gp1_check); }
	
	return (!ss.controller ? _kb_check : _gp1_check);
}

function reset_binds() {
	if (!ss.controller) {
		ss.kb_controls = {
			left: vk_left,
			right: vk_right,
			up: vk_up,
			down: vk_down,
			a: ord("Z"),
			b: ord("X")
		};
	} else {
		ss.gp_controls = {
			left: gp_stickl_l,
			right: gp_stickl_r,
			up: gp_stickl_u,
			down: gp_stickl_d,
			a: gp_face1,
			b: gp_face2
		};
	}
}