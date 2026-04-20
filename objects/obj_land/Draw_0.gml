draw_sprite(spr_land, 0, x, y);

draw_sprite(spr_land_capture, captured, x, y);

if (tower) {
	draw_sprite(spr_land_tower, 0, x, y);
}

if (booth) {
	draw_sprite(spr_land_booth, 0, x, y);
}

draw_set_color(colors.white);

draw_set_alpha(1);

draw_set_halign(fa_left);
draw_set_valign(fa_top);

var _x = x - 145;
var _y = y - 130;

draw_set_font(fnt_regular_32);

var _off_x = 48;
var _off_y = 64;

if (smartphones > 0) {
	draw_sprite_ext(spr_smartphone, 0, _x + 8, _y + 54, 0.4, 0.4, 0, -1, 1);
	draw_text(_x + _off_x, _y, string(smartphones));
	_y += _off_y;
}

if (clamshells > 0) {
	draw_sprite_ext(spr_clamshell, 0, _x + 8, _y + 88, 0.6, 0.6, 0, -1, 1);
	draw_text(_x + _off_x, _y, string(clamshells));
	_y += _off_y;
}

if (burners > 0) {
	draw_sprite_ext(spr_burner, 0, _x + 10, _y + 34, 0.6, 0.6, 90, -1, 1);
	draw_text(_x + _off_x, _y, string(burners));
	_y += _off_y;
}