var _affordable = true;

if (g.turn == 1 && g.minutes_blue < cost) { _affordable = false; }
if (g.turn == 2 && g.minutes_red < cost) { _affordable = false; }

draw_set_color(colors.white);

if (!_affordable) { draw_set_color(colors.light_red); }

draw_set_alpha(alph);
draw_roundrect_ext(x - 260, y - 64, x + 260, y + (short ? 108 : 192), 32, 32, false);
draw_set_alpha(1);

draw_set_halign(fa_center);
draw_set_valign(fa_top);

draw_set_font(fnt_regular_32);
draw_text(x, y - 48, title);

var _body = string_replace(body, "$", string(cost) + " minute" + (cost == 1 ? "" : "s"));

draw_set_font(fnt_regular_24);
draw_text_ext(x, y + 12, _body, 32, 500);