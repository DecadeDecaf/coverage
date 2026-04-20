fc++;

with (obj_unit) {
	if (iframes == 0 && o.iframes == 0) {
		if (carrier != o.carrier) {
			if (place_meeting(x, y, o.id)) {
				if (image_index == 1) { xv *= (behavior == "C" ? -4 : -1.5); }
				hp--;
				iframes = 5;
				if (o.image_index == 1) { o.xv *= (behavior == "C" ? -4 : -1.5); }
				o.hp--;
				o.iframes = 5;
			}
		}
	}
}

with (obj_unit) {
	if (hp <= 0) {
		if (behavior == "B") {
			var _poop;
			_poop = instance_create_depth(x, y, depth, obj_poop);
			_poop.sprite_index = spr_fireball;
			_poop.carrier = carrier;
			_poop.xv = -6;
			_poop.yv = -2;
			_poop.dmg = 2;
			_poop = instance_create_depth(x, y, depth, obj_poop);
			_poop.sprite_index = spr_fireball;
			_poop.carrier = carrier;
			_poop.xv = -3;
			_poop.yv = -4;
			_poop.dmg = 2;
			_poop = instance_create_depth(x, y, depth, obj_poop);
			_poop.sprite_index = spr_fireball;
			_poop.carrier = carrier;
			_poop.xv = 0;
			_poop.yv = -6;
			_poop.dmg = 2;
			_poop = instance_create_depth(x, y, depth, obj_poop);
			_poop.sprite_index = spr_fireball;
			_poop.carrier = carrier;
			_poop.xv = 3;
			_poop.yv = -4;
			_poop.dmg = 2;
			_poop = instance_create_depth(x, y, depth, obj_poop);
			_poop.sprite_index = spr_fireball;
			_poop.carrier = carrier;
			_poop.xv = 6;
			_poop.yv = -2;
			_poop.dmg = 2;
		}
		instance_destroy();
	}
}