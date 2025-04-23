/datum/game_mode/allmig
	name = "All Migration"
	config_tag = "allmig"
	required_players = 20
	uplink_welcome = "Syndicate Uplink Console:"
	uplink_uses = 10
	var/const/waittime_l = 600 //lower bound on time before intercept arrives (in tenths of seconds)
	var/const/waittime_h = 1800

/datum/game_mode/allmig/announce()
	world << "<B>All migration!</B>"
	world << 'sound/music/allmigration_start.ogg'

/datum/game_mode/allmig/pre_setup()
	return TRUE

/datum/game_mode/allmig/post_setup()
	. = ..()


/datum/game_mode/allmig/can_start()
	. = ..()