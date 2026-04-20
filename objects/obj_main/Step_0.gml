evaluate_board();

if (instance_number(obj_plan) == 0 && instance_number(obj_target) == 0 && !g.contesting_land && !g.game_over) {
	if (g.queued_plan != "") {
		execute_plan(g.queued_plan);
	} else {
		start_turn();
	}
}

evaluate_combat();

handle_fullscreen();

handle_restart();
handle_gameclose();