/datum/game_mode/quietday
	name = "Quiet Day"
	config_tag = "quietday"
	required_players = 0
	uplink_welcome = "Syndicate Uplink Console:"
	uplink_uses = 10

	var/const/waittime_l = 600 //lower bound on time before intercept arrives (in tenths of seconds)
	var/const/waittime_h = 1800

/datum/game_mode/quietday/announce()
	world << "<B>Our fate is a peaceful one.</B>"
	return
/datum/game_mode/quietday/pre_setup()
	return 1

/datum/game_mode/quietday/post_setup()
	..()

/datum/game_mode/quietday/can_start()
	. = ..()
	for(var/mob/new_player/player in player_list)
		if(player.ready && player.client.work_chosen == "Baron")
			return TRUE
	return FALSE

/datum/game_mode/quietday/declare_completion()
	. = ..()
	if(!has_starring)
		var/mob/living/carbon/human/H
		H = pick(player_list)
		to_chat(world, "<span class='bname'>Starring: [H.real_name]</span>")
		to_chat(world, "<span class='bname'>Objective #1:</span> Prevent tragedy from happening in Enoch's Gate. <font color='green'>Success!</font>")