// Ticker game states, turns out these are  equivilent to runlevels1
#define GAME_STATE_INIT			0	// RUNLEVEL_INIT
#define GAME_STATE_PREGAME		1	// RUNLEVEL_LOBBY
#define GAME_STATE_SETTING_UP	2	// RUNLEVEL_SETUP
#define GAME_STATE_PLAYING		3	// RUNLEVEL_GAME
#define GAME_STATE_FINISHED		4	// RUNLEVEL_POSTGAME

//End game state, to manage round end.
#define END_GAME_NOT_OVER		1	// Still playing normally
#define END_GAME_MODE_FINISHED	2	// Mode has finished but game has not, wait for game to end too.
#define END_GAME_READY_TO_END	3	// Game and Mode have finished, do rounded stuff.
#define END_GAME_ENDING			4	// Just waiting for ending timer.
#define END_GAME_DELAYED		5	// Admin has delayed the round.

#define HARD_MODE_PLAYER_CAP    25