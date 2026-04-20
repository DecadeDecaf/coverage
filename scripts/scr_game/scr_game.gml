function start_turn() {
	g.turn = (g.turn == 1 ? 2 : 1);
	var _turn = g.turn;
	if (_turn == 1) { gain_minutes(g.allowance_blue); };
	if (_turn == 2) { gain_minutes(g.allowance_red); };
	create_plans();
}

function create_plans(_override = [[], [], []], _short = false) {
	var _x = 330;
	var _y = 400;
	var _list_len = array_length(_override);
	if (_list_len == 1) { _y = 1120; }
	for (var _i = 0; _i < _list_len; _i++) {
		create_plan(_x, _y, _override[@ _i], _short);
		_y += (_short ? 180 : 270);
	}
	with (obj_plan) {
		if (cost > 0) {
			cost += g.markup;
			if (g.scalping) {
				cost = ceil(cost / 2);
			}
		}
	}
}

function create_plan(_x, _y, _override = [], _short = false) {
	var _plan = instance_create_depth(_x, _y, 0, obj_plan);
	var _plans = [
		["Modern", "Train 5 smartphones."],
		["Retro", "Train 3 clamshells."],
		["Mobilize", "Move units."],
		["Spree", "Gain 8 minutes, then browse a selection of units. You may train as many as you can afford."],
		["Phone Booth", "Install a phone booth on any claimed tile that doesn't already have a cell tower or phone booth."],
		["Passive Income", "Gain 3 minutes. Plan again."],
		["Pre-Production", "Train 2 smartphones. Plan again."],
		["Step One", "Move units. Plan again."],
		["Airplane Mode", "Move units to any tile on the coverage map, unclaiming the tile you leave behind."],
		["Roaming", "Move units. If you claim a tile, move again (up to 3 times)."],
		["Apples & Blackberries", "Train 3 smartphones and 2 clamshells."],
		["Unknown Caller", "Train a burner."],
		["Scalp", "Browse a selection of half-price units. Increase the price of ALL units (permanently)."],
		["TARDIS", "Teleport a phone booth, instantly killing any units at its new location."],
		["Y2K", "Wipe every clamshell from the coverage map."],
		["Unlimited Talk & Text", "Double your minutes."],
		["Fortune 500", "Gain +1 minute at the start of each turn."]
	];
	var _len = (array_length(_plans) - 1);
	var _c_len = (_len - 9);
	var _u_len = (_len - 5);
	var _r_len = (_len);
	var _rand = irandom_range(0, choose(_c_len, _u_len, _r_len));
	var _plan_info = _plans[@ _rand];
	if (array_length(_override) > 0) {
		_plan_info = _override;
	}
	_plan.title = _plan_info[@ 0];
	_plan.body = _plan_info[@ 1];
	_plan.short = _short;
	switch (_plan.title) {
		case "Train Smartphone":
			_plan.cost = 2;
			break;
		case "Train Clamshell":
			_plan.cost = 4;
			break;
		case "Train Burner":
			_plan.cost = 10;
			break;
		default:
			break;
	}
}

function evaluate_board() {
	var _blue_towers = 0;
	var _red_towers = 0;
	
	with (obj_land) {
		if (tower) {
			if (captured == 1) { _blue_towers++; }
			if (captured == 2) { _red_towers++; }
		}
	}
	
	if (_blue_towers == 4) { g.game_over = true; g.winner = 1; }
	if (_red_towers == 4) { g.game_over = true; g.winner = 2; }
}

function train_units(_list, _self = true) {
	var _turn = g.turn;
	if (!_self) { _turn = (_turn == 1 ? 2 : 1); }
	with (obj_land) {
		if (captured == _turn && (tower || booth)) {
			var _targ = instance_create_depth(x, y, depth, obj_target);
			_targ.land = id;
			_targ.units = _list;
		}
	}
	if (instance_number(obj_target) > 0) {
		g.training_units = true;
	}
}

function select_booth() {
	var _turn = g.turn;
	with (obj_land) {
		if (booth) {
			var _targ = instance_create_depth(x, y, depth, obj_target);
			_targ.land = id;
		}
	}
	if (instance_number(obj_target) > 0) {
		g.selecting_booth = true;
	} else {
		g.tardis = false;
	}
}

function place_booth(_self = true, _old_land = -1) {
	instance_destroy(obj_target);
	var _turn = g.turn;
	if (!_self) { _turn = (_turn == 1 ? 2 : 1); }
	with (obj_land) {
		if ((captured == _turn || g.tardis) && !(tower || booth)) {
			if (_old_land != -1) {
				if (_old_land.id == id) {
					continue;
				}
			}
			var _targ = instance_create_depth(x, y, depth, obj_target);
			_targ.land = id;
		}
	}
	if (instance_number(obj_target) > 0) {
		g.placing_booth = true;
	} else {
		g.tardis = false;
	}
}

function set_units(_land, _units) {
	_land.smartphones = 0;
	_land.clamshells = 0;
	_land.burners = 0;
	add_units(_land, _units);
}

function add_units(_land, _units) {
	_land.smartphones += array_count(_units, "S");
	_land.clamshells += array_count(_units, "C");
	_land.burners += array_count(_units, "B");
}

function count_units(_land = id) {
	var _units = 0;
	_units += _land.smartphones;
	_units += _land.clamshells;
	_units += _land.burners;
	return _units;
}

function list_units(_land = id) {
	var _list = [];
	repeat (_land.smartphones) { array_push(_list, "S"); }
	repeat (_land.clamshells) { array_push(_list, "C"); }
	repeat (_land.burners) { array_push(_list, "B"); }
	return _list;
}

function select_units() {
	var _turn = g.turn;
	with (obj_land) {
		if (captured == _turn && count_units() > 0) {
			var _targ = instance_create_depth(x, y, depth, obj_target);
			_targ.land = id;
		}
	}
	if (instance_number(obj_target) > 0) {
		g.selecting_units = true;
	} else {
		g.roaming = 0;
		g.airplane = false;
	}
}

function move_units(_land) {
	instance_destroy(obj_target);
	with (_land) {
		var _units = list_units();
		set_units(_land, []);
		with (obj_land) {
			var _can_move = false;
			if (g.airplane) {
				o.captured = 0;
				_can_move = o.id != id;
			} else {
				_can_move = land_is_adjacent(o.id, id);
			}
			if (_can_move) {
				var _targ = instance_create_depth(x, y, depth, obj_target);
				_targ.land = id;
				_targ.units = _units;
			}
		}
	}
	g.airplane = false;
	if (instance_number(obj_target) > 0) {
		g.moving_units = true;
	}
}

function land_is_adjacent(_land_a, _land_b) {
	var _above = position_meeting(_land_a.x, _land_a.y - 320, _land_b);
	var _below = position_meeting(_land_a.x, _land_a.y + 320, _land_b);
	var _left = position_meeting(_land_a.x - 370, _land_a.y, _land_b);
	var _right = position_meeting(_land_a.x + 370, _land_a.y, _land_b);
	return (_above || _below || _left || _right);
}

function gain_minutes(_minutes, _self = true) {
	var _turn = g.turn;
	if (!_self) { _turn = (_turn == 1 ? 2 : 1); }
	switch (_turn) {
		case 1:
			g.minutes_blue += _minutes;
			break;
		case 2:
			g.minutes_red += _minutes;
			break;
		default:
			break;
	}
	g.minutes_blue = clamp(g.minutes_blue, 0, 999);
	g.minutes_red = clamp(g.minutes_red, 0, 999);
}

function initiate_combat(_attackers, _land) {
	var _defenders = list_units(_land);
	g.contesting_land = true;
	var _turn = g.turn;
	spawn_army(_attackers, _turn);
	spawn_army(_defenders, (_turn == 1 ? 2 : 1));
	g.contested_land = _land;
	g.contesting_frames = 45;
}

function evaluate_combat() {
	if (g.contesting_land) {
		var _turn = g.turn;
		var _attackers = [];
		var _defenders = [];
		with (obj_unit) {
			if (carrier == _turn) {
				array_push(_attackers, unit);
			} else {
				array_push(_defenders, unit);
			}
		}
		if (g.contesting_frames > 0) {
			if ((array_length(_defenders) == 0 || array_length(_attackers) == 0) && instance_number(obj_poop) == 0) {
				g.contesting_frames--;
			}
		} else {
			var _land = g.contested_land;
			if (array_length(_defenders) == 0) {
				_land.captured = _turn;
				set_units(_land, _attackers);
				g.contesting_land = false;
				g.contested_land = -1;
				if (g.roaming > 0) {
					g.roaming--;
					if (g.roaming > 0) {
						move_units(_land);
					}
				}
			} else if (array_length(_attackers) == 0) {
				set_units(_land, _defenders);
				g.contesting_land = false;
				g.contested_land = -1;
				g.roaming = 0;
			}
			instance_destroy(obj_unit);
			instance_destroy(obj_poop);
		}
	}
}

function spawn_army(_army, _carrier) {
	var _x = (_carrier == 2 ? 2688 : -128);
	var _y = 1200;
	var _len = array_length(_army);
	var _burners = 1;
	for (var _i = 0; _i < _len; _i++) {
		var _unit;
		switch (_army[@ _i]) {
			case "S":
				_unit = instance_create_depth(_x, _y, -5, obj_unit);
				_unit.sprite_index = spr_smartphone;
				_unit.unit = "S";
				_unit.behavior = "S";
				_unit.maxhp = 3;
				_unit.hp = _unit.maxhp;
				_unit.carrier = _carrier;
				_unit.image_xscale = (_carrier == 2 ? -1 : 1);
				break;
			case "C":
				_unit = instance_create_depth(_x, _y - 300, -5, obj_unit);
				_unit.sprite_index = spr_clamshell;
				_unit.unit = "C";
				_unit.behavior = "C";
				_unit.maxhp = 2;
				_unit.hp = _unit.maxhp;
				_unit.carrier = _carrier;
				_unit.image_xscale = (_carrier == 2 ? -1 : 1);
				break;
			case "B":
				_unit = instance_create_depth(_x, _y - 200, -5, obj_unit);
				_unit.sprite_index = spr_burner;
				_unit.unit = "B";
				_unit.behavior = "B";
				_unit.maxhp = 1;
				_unit.hp = _unit.maxhp;
				_unit.carrier = _carrier;
				_unit.image_xscale = (_carrier == 2 ? -1 : 1);
				_unit.burner_number = _burners;
				_burners++;
				break;
			default:
				break;
		}
	}
}

function queue_plan(_plan) {
	g.queued_plan = _plan;
}

function execute_plan(_plan) {
	g.queued_plan = "";
	var _turn = g.turn;
	var _menu = [
		["Singleplayer", "Compete against a computer-controlled opponent."],
		["Local Multiplayer", "Take turns in the hotseat and compete for map coverage."],
		["How to Play", "Read important information about the game."],
		["Quit", "Close the game."]
	];
	var _back = [
		["Back", "Return to the main menu."]
	];
	var _shop = [
		["Train Smartphone", "Smartphones cost $ each."],
		["Train Clamshell", "Clamshells cost $ each."],
		["Train Burner", "Burners cost $ each."],
		["Done", "That's enough shopping."]
	];
	switch (_plan) {
		case "Singleplayer":
			g.singleplayer = true;
			g.started = true;
			instance_create_depth(1280, -128, depth - 10, obj_cpu);
			start_turn();
			break;
		case "Local Multiplayer":
			g.singleplayer = false;
			g.started = true;
			start_turn();
			break;
		case "How to Play":
			create_plans(_back, true);
			break;
		case "Back":
			create_plans(_menu, true);
			break;
		case "Quit":
			game_end();
			break;
		case "Modern":
			train_units(["S", "S", "S", "S", "S"]);
			break;
		case "Retro":
			train_units(["C", "C", "C"]);
			break;
		case "Mobilize":
			select_units();
			break;
		case "Spree":
			gain_minutes(8);
			create_plans(_shop, true);
			break;
		case "Spree (Again)":
			create_plans(_shop, true);
			break;
		case "Train Smartphone":
			train_units(["S"]);
			if (g.scalping) {
				queue_plan("Scalp");
			} else {
				queue_plan("Spree (Again)");
			}
			break;
		case "Train Clamshell":
			train_units(["C"]);
			if (g.scalping) {
				queue_plan("Scalp");
			} else {
				queue_plan("Spree (Again)");
			}
			break;
		case "Train Burner":
			train_units(["B"]);
			if (g.scalping) {
				queue_plan("Scalp");
			} else {
				queue_plan("Spree (Again)");
			}
			break;
		case "Phone Booth":
			place_booth();
			break;
		case "Plan Again":
			create_plans();
			break;
		case "Passive Income":
			gain_minutes(3);
			create_plans();
			break;
		case "Pre-Production":
			train_units(["S", "S"]);
			queue_plan("Plan Again");
			break;
		case "Step One":
			select_units();
			queue_plan("Plan Again");
			break;
		case "Airplane Mode":
			g.airplane = true;
			select_units();
			break;
		case "Roaming":
			g.roaming = 3;
			select_units();
			break;
		case "Apples & Blackberries":
			train_units(["S", "S", "S", "C", "C"]);
			break;
		case "Unknown Caller":
			train_units(["B"]);
			break;
		case "Scalp":
			g.scalping = true;
			create_plans(_shop, true);
			break;
		case "TARDIS":
			g.tardis = true
			select_booth();
			break;
		case "Y2K":
			with (obj_land) {
				clamshells = 0;
			}
			break;
		case "Unlimited Talk & Text":
			gain_minutes((_turn == 1 ? g.minutes_blue : g.minutes_red));
			break;
		case "Fortune 500":
			if (_turn == 1) { g.allowance_blue++; };
			if (_turn == 2) { g.allowance_red++; };
			break;
		case "Done":
			if (g.scalping) {
				g.scalping = false;
				g.markup += 1;
			}
			break;
		default:
			break;
	}
}