function print(_msg) {
	show_debug_message(_msg);
}

function struct_merge(_primary, _secondary) {
	var _struct = _primary;
	var _addstruct = _secondary;
	if (_addstruct != -1) {
		var _names = variable_struct_get_names(_primary);
		var _len = array_length(_names);
		for (var _i = 0; _i < _len; _i++) {
			if (variable_struct_exists(_addstruct, _names[_i])) {
				variable_struct_set(_struct, _names[_i], variable_struct_get(_addstruct, _names[_i]));
			}
		}
		return _struct;
	}
	return _struct;
}

function array_has(_array, _thing) {
	var _has = false;
	for (var _i = 0; _i < array_length(_array); _i++) {
		if (_array[@ _i] == _thing) {
			_has = true;
			break;
		}
	}
	return _has;
}

function array_count(_array, _thing) {
	var _count = 0;
	for (var _i = 0; _i < array_length(_array); _i++) {
		if (_array[@ _i] == _thing) {
			_count++;
		}
	}
	return _count;
}

function array_find(_array, _thing) {
	var _pos = -1;
	for (var _i = 0; _i < array_length(_array); _i++) {
		if (_array[@ _i] == _thing) {
			_pos = _i;
			break;
		}
	}
	return _pos;
}

function array_remove(_array, value) {
	var _old = _array;
	var _len = array_length(_array);
	var _a = 0;
	for (var _i = 0; _i < _len; _i++) {
		if (_old[@ _i] != value) {
			_array[@ _a] = _old[@ _i];
			_a++;
		}
	}
	array_resize(_array, _a);
}

function array_remove_at(_array, _pos) {
	var _old = _array;
	var _len = array_length(_array);
	var _a = 0;
	for (var _i = 0; _i < _len; _i++) {
		if (_i != _pos) {
			_array[@ _a] = _old[@ _i];
			_a++;
		}
	}
	array_resize(_array, _a);
}

function array_mean(_array) {
	var _len = array_length(_array);
	var _mean = -1;
	if (_len > 0) {
		var _total = 0;
		for (var _i = 0; _i < _len; _i++) {
			_total += _array[@ _i];
		}
		_mean = (_total / _len);
	}
	return _mean;
}

function percent_chance(_perc) {
	_perc = clamp(_perc, 0, 100);
	var _rand = random(100);
	var _hit = (_perc > _rand);
	return _hit;
}

function bind_get_str(_bind) {
	var _str = "";
	if (!ss.controller) {
		_str = chr(_bind);
		switch (_bind) {
			case vk_left: _str = "LEFT"; break;
			case vk_right: _str = "RIGHT"; break;
			case vk_up: _str = "UP"; break;
			case vk_down: _str = "DOWN"; break;
			case vk_enter: _str = "ENTER"; break;
			case vk_escape: _str = "ESC"; break;
			case vk_space: _str = "SPACE"; break;
			case vk_lshift: _str = "LEFT SHIFT"; break;
			case vk_rshift: _str = "RIGHT SHIFT"; break;
			case vk_lcontrol: _str = "LEFT CTRL"; break;
			case vk_lalt: _str = "LEFT ALT"; break;
			case vk_rcontrol: _str = "RIGHT CTRL"; break;
			case vk_ralt: _str = "RIGHT ALT"; break;
			case vk_backspace: _str = "BACKSPACE"; break;
			case vk_tab: _str = "TAB"; break;
			case vk_home: _str = "HOME"; break;
			case vk_end: _str = "END"; break;
			case vk_delete: _str = "DELETE"; break;
			case vk_insert: _str = "INSERT"; break;
			case vk_pageup: _str = "PAGE UP"; break;
			case vk_pagedown: _str = "PAGE DOWN"; break;
			case vk_pause: _str = "PAUSE"; break;
			case vk_printscreen: _str = "PRINT SCREEN"; break;
			case vk_f1: _str = "F1"; break;
			case vk_f2: _str = "F2"; break;
			case vk_f3: _str = "F3"; break;
			case vk_f4: _str = "F4"; break;
			case vk_f5: _str = "F5"; break;
			case vk_f6: _str = "F6"; break;
			case vk_f7: _str = "F7"; break;
			case vk_f8: _str = "F8"; break;
			case vk_f9: _str = "F9"; break;
			case vk_f10: _str = "F10"; break;
			case vk_f11: _str = "F11"; break;
			case vk_f12: _str = "F12"; break;
			case vk_numpad1: _str = "NUMPAD 1"; break;
			case vk_numpad2: _str = "NUMPAD 2"; break;
			case vk_numpad3: _str = "NUMPAD 3"; break;
			case vk_numpad4: _str = "NUMPAD 4"; break;
			case vk_numpad5: _str = "NUMPAD 5"; break;
			case vk_numpad6: _str = "NUMPAD 6"; break;
			case vk_numpad7: _str = "NUMPAD 7"; break;
			case vk_numpad8: _str = "NUMPAD 8"; break;
			case vk_numpad9: _str = "NUMPAD 9"; break;
			case vk_multiply: _str = "MULTIPLY"; break;
			case vk_divide: _str = "DIVIDE"; break;
			case vk_add: _str = "ADD"; break;
			case vk_subtract: _str = "SUBTRACT"; break;
			case vk_decimal: _str = "DECIMAL"; break;
			case ord("F"): // fullscreen hotkey
			case ord("R"): // debug restart
				_str = ""; break;
			default: break;
		}
	} else {
		switch (_bind) {
			case gp_padl: _str = "D-PAD LEFT"; break;
			case gp_padr: _str = "D-PAD RIGHT"; break;
			case gp_padu: _str = "D-PAD UP"; break;
			case gp_padd: _str = "D-PAD DOWN"; break;
			case gp_face1: _str = "A"; break;
			case gp_face2: _str = "B"; break;
			case gp_face3: _str = "X"; break;
			case gp_face4: _str = "Y"; break;
			case gp_shoulderl: _str = "LEFT BUMPER"; break;
			case gp_shoulderlb: _str = "LEFT TRIGGER"; break;
			case gp_shoulderr: _str = "RIGHT BUMPER"; break;
			case gp_shoulderrb: _str = "RIGHT TRIGGER"; break;
			case gp_start: _str = "START"; break;
			case gp_select: _str = "SELECT"; break;
			case gp_stickl: _str = "LEFT STICK"; break;
			case gp_stickr: _str = "RIGHT STICK"; break;
			case gp_stickl_u: _str = "LEFT STICK UP"; break;
			case gp_stickl_d: _str = "LEFT STICK DOWN"; break;
			case gp_stickl_l: _str = "LEFT STICK LEFT"; break;
			case gp_stickl_r: _str = "LEFT STICK RIGHT"; break;
			case gp_stickr_u: _str = "RIGHT STICK UP"; break;
			case gp_stickr_d: _str = "RIGHT STICK DOWN"; break;
			case gp_stickr_l: _str = "RIGHT STICK LEFT"; break;
			case gp_stickr_r: _str = "RIGHT STICK RIGHT"; break;
			default: _str = ""; break;
		}
	}
	return _str;
}