create_macros();
create_globals();

create_savefile();

load_savefile();
load_settings();

set_data();

audio_stop_all();
audio_master_gain(ss.vol);
set_fullscreen(ss.fullscreen);

exception_unhandled_handler(error);

randomize();

window_set_cursor(cr_none);

execute_plan("Back");