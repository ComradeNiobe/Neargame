/datum/game_mode/extended
	name = "Extended"
	config_tag = "extended"
	required_players = 0
	uplink_welcome = "Syndicate Uplink Console:"
	uplink_uses = 10

	var/const/waittime_l = 600 //lower bound on time before intercept arrives (in tenths of seconds)
	var/const/waittime_h = 1800

/datum/game_mode/announce()
	world << "<B>Our fate is peaceful.</B>"

/datum/game_mode/extended/pre_setup()
	return TRUE

/datum/game_mode/extended/post_setup()
	. = ..()

/datum/game_mode/extended/can_start()
	. = ..()

/datum/game_mode/extended/declare_completion()
	. = ..()
	if(!has_starring)
		var/mob/living/carbon/human/H
		H = pick(player_list)
		to_chat(world, "<span class='bname'>Starring: [H.real_name]</span>")
		to_chat(world, "<span class='bname'>Objective #1:</span> Prevent tragedy from happening in Enoch's Gate. <font color='green'>Success!</font>")