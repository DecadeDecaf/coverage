draw_set_alpha(1);

draw_set_halign(fa_center);
draw_set_valign(fa_top);

var _turn = g.turn;

if (!g.started) {
	draw_set_color(colors.white);
	draw_set_font(fnt_regular_48);
	draw_text(330, 180, "Coverage")
	if (instance_number(obj_plan) == 1) {
		var _txt = "In Coverage, play as one of two cell service carriers, train an army of cellphones, and compete for map coverage.\n\nEach turn, choose between 3 random plans. Plans let you do a variety of things. Train units at cell towers, then move those units around the map.\n\nWhenever friendly units come into contact with enemy units, both sides fight until only one remains.\n\nClaim all 4 cell towers to win!";
		draw_set_font(fnt_regular_24);
		draw_text_ext(330, 320, _txt, 36, 500);
	}
} else if (instance_number(obj_plan) > 0) {
	draw_set_color(colors.white);
	draw_set_font(fnt_regular_48);
	draw_text(330, 180, "What's the plan?")
	var _col = (_turn == 1 ? colors.light_blue : colors.dark_red);
	var _txt = (_turn == 1 ? "Blue carrier's turn!" : "Red carrier's turn!");
	draw_set_color(_col);
	draw_set_font(fnt_regular_24);
	draw_text(330, 120, _txt)
}

if (instance_number(obj_target) > 0) {
	draw_set_alpha(0.5);
	draw_set_color(colors.black);
	draw_rectangle(0, 0, 2560, 1440, false);
	draw_set_alpha(1);
	with (obj_target) {
		draw_self();
	}
	var _header = "";
	var _body = "";
	if (g.training_units) {
		_header = "Training units...";
		_body = "Train new units at any claimed cell tower (or phone booth).";
	} else if (g.selecting_units) {
		_header = "Selecting units...";
		_body = "Select units to move.";
	} else if (g.moving_units) {
		_header = "Moving units...";
		_body = "Move units onto an adjacent tile, then attempt to claim it.";
		if (g.roaming > 0) {
			_header = "Roaming...";
			_body = "Move units onto an adjacent tile, then attempt to claim it.\n\nIf a tile is claimed, move again.\n\nMoves left: " + string(g.roaming);
		}
	} else if (g.selecting_booth) {
		_header = "Selecting booth...";
		_body = "Select a phone booth to teleport.";
	} else if (g.placing_booth) {
		_header = "Installing booth...";
		_body = "Install a phone booth on any claimed tile.\n\nNew units may be trained at phone booths!";
	}
	draw_set_color(colors.white);
	draw_set_font(fnt_regular_48);
	draw_text(330, 180, _header);
	draw_set_font(fnt_regular_32);
	draw_text_ext(330, 350, _body, 48, 600);
}

if (g.started) {
	draw_set_font(fnt_regular_32);

	draw_set_color(colors.white);
	draw_text(330, 1160, "Minutes:");

	draw_set_font(fnt_regular_48);

	draw_set_colour(colors.light_blue);
	draw_text(220, 1220, string(g.minutes_blue));

	draw_set_colour(colors.dark_red);
	draw_text(440, 1220, string(g.minutes_red));
}

if (g.contesting_land) {
	draw_set_alpha(0.5);
	draw_set_color(colors.black);
	draw_rectangle(0, 0, 2560, 1440, false);
	draw_set_alpha(1);
	with (obj_poop) {
		draw_self();
	}
	with (obj_unit) {
		var _squeeze_x = 1;
		var _squeeze_y = 1;
		if (sprite_index == spr_smartphone) {
			if (yv < 0) {
				_squeeze_x -= (0.4 * abs(yv / 18));
				_squeeze_y += (0.35 * abs(yv / 18));
			} else if (jump_cooldown < 10) {
				_squeeze_x += (0.3 * abs((10 - jump_cooldown) / 9));
				_squeeze_y -= (0.35 * abs((10 - jump_cooldown) / 9));
			}
		} else if (sprite_index == spr_smartphone) {
			if (yv < 0) {
				_squeeze_x -= (0.3 * abs(yv / 6));
				_squeeze_y += (0.5 * abs(yv / 6));
			}
		} else if (sprite_index == spr_burner) {
			_squeeze_x -= (0.4 * abs(xv / 20));
			_squeeze_y += (0.35 * abs(xv / 20));
			draw_sprite_ext(spr_burner_flames, image_index, x, y, _squeeze_x, _squeeze_y, image_angle, -1, 0.9);
		}
		_squeeze_x *= image_xscale;
		if (iframes > 0) { gpu_set_fog(true, colors.white, 1, 1); }
		draw_sprite_ext(sprite_index, image_index, x, y, _squeeze_x, _squeeze_y, image_angle, -1, 1);
		if (iframes > 0) { gpu_set_fog(false, colors.white, 1, 1); }
	}
	with (obj_unit) {
		var _perc = (hp / maxhp);
		var _col = (carrier == 1 ? colors.light_blue : colors.dark_red);
		draw_set_color(colors.black);
		draw_rectangle(x - 62, y - 202, x + 62, y - 178, false);
		draw_set_color(_col);
		draw_rectangle(x - 60, y - 200, x - 60 + (120 * _perc), y - 180, false);
	}
}

if (g.game_over) {
	draw_set_alpha(0.75);
	draw_set_color(colors.black);
	draw_rectangle(0, 0, 2560, 1440, false);
	draw_set_alpha(1);
	var _col = (g.winner == 1 ? colors.light_blue : colors.dark_red);
	var _txt = (g.winner == 1 ? "The blue carrier achieved mapwide coverage!" : "The red carrier achieved mapwide coverage!");
	draw_set_font(fnt_regular_48);
	draw_set_color(colors.white);
	draw_text(1280, 440, "Game over.");
	draw_set_font(fnt_regular_32);
	draw_set_color(_col);
	draw_text(1280, 540, _txt);
	draw_set_color(colors.white);
	draw_text(1280, 690, "Coverage was made by one person in less than 48 hours for the Ludum Dare 59 compo.\nThe theme was \"signal\". Thank you for playing!\n\n(press R to return to the menu)");
}

var _img = (_turn == 2 ? 1 : 0);

if (g.singleplayer) { _img = 0; }

draw_sprite(spr_cursor, _img, mouse_x, mouse_y);