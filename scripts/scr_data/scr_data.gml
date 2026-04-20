function set_data() {
	g.gamedata = {
		things: {}
	};
	
	#macro data g.gamedata
	
	var _thing_data;
	
	_thing_data = {
		thing_name: "a"
	};
	
	thing_data("a", _thing_data);
}

function thing_data(_name, _dat) {
	var _defdat = new default_thing();
	var _newdat = struct_merge(_defdat, _dat);
	variable_struct_set(data.things, _name, _newdat);
}

function default_thing() constructor {
	thing_name = "";
}