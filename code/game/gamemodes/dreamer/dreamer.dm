/datum/game_mode/dreamer
	name = "The Dreamer"
	config_tag = "dreamer"
	restricted_jobs = list("Cyborg")//They are part of the AI if he is traitor so are they, they use to get double chances
	required_players = 1
	required_enemies = 1
	recommended_enemies = 1

	var/list/datum/mind/dreamer = list()
	var/dreamer_awakened = FALSE

/datum/game_mode/dreamer/can_start()
	for(var/mob/new_player/player in player_list)
		for(var/mob/new_player/player2 in player_list)
			for(var/mob/new_player/player3 in player_list)
				if(player.ready && player.client.work_chosen == "Baron" && player2.ready && player2.client.work_chosen == "Vicar"&& player3.ready && player3.client.work_chosen == "Merchant")
					return 1
	return 0

/datum/game_mode/proc/greet_dreamer(datum/mind/dreamer)
	to_chat(dreamer.current, SPAN_DREAMER("Recently I've been visited by a lot of VISIONS. They're all about another WORLD, ANOTHER life. I will do EVERYTHING to know the TRUTH, to return to the REAL world."))
	to_chat(dreamer.current, SPAN_DREAMER("Dream #1: FOLLOWING my HEART shall be the WHOLE of the law."))
	return

/datum/game_mode/proc/finalize_dreamer(datum/mind/dreamer)
	var/mob/living/carbon/human/H = dreamer.current
	var/datum/antagonist/dreamer/M = new()

	dreamer.special_role = "Waker"
	dreamer.antag_datums = M
	H.combat_music = 'sound/lfwbsounds/bloodlust1.ogg'
	H.vice = "Graphomaniac"

	H.verbs += /mob/living/carbon/human/proc/dreamer
	H.verbs += /mob/living/carbon/human/proc/dreamerArchetypes
	H.consyte = 0
	H.status_flags |= STATUS_NO_PAIN
	starringlist += "[H.real_name] ([H.key]) "
	if(H.religion == "Thanati")
		if(prob(80))
			H.religion = "Gray Church"
	spawn(30)
		H.dreamerArchetypes(H)

/datum/game_mode/dreamer/pre_setup()
	var/list/possible_dreamers = get_players_for_antag()
	var/max_dreamer = 1

	for(var/j = 0, j < max_dreamer, j++)
		if (!LAZYLEN(possible_dreamers))
			break
		var/datum/mind/dreamer_mind = pick(possible_dreamers)
		dreamer += dreamer_mind
		possible_dreamers.Remove(dreamer)
	return 1


/datum/game_mode/dreamer/post_setup()
	for(var/datum/mind/dreamer_mind in dreamer)
		spawn(rand(10,100))
			finalize_dreamer(dreamer_mind)
			greet_dreamer(dreamer_mind)

	modePlayer += dreamer
	return 1

/datum/game_mode/dreamer/declare_completion(datum/mind/dreamer)
	..()
	var/text = "<span class='dreamershitfuckcomicao1'>Starring: [starringlist]</span>"
	var/mob/living/carbon/human/H = dreamer.current

	if(dreamer_awakened)
		text += "<br><span class='dreamershitbutitsactuallypassivebutitactuallyisbigandbold'>The Dreamer has awakened!</span>"
		H.unlock_medal("Finally Awake", 0, "As the Dreamer, followed their heart to the whole of the law.", "23")
	else
		text += "<br><span class='dreamershitbutitsactuallypassivebutitactuallyisbigandbold'>The Dreamer is still imprisioned in his own labyrinth.</span>"
	to_world(text)
	return