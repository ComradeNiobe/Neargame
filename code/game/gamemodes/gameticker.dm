var/global/datum/controller/gameticker/ticker
var/global/shuttleMain = null
var/global/quietend = 0
var/global/deathinfort = 0
var/global/deathincave = 0
var/global/orgasms = 0
var/global/cromosperdidos = 0
var/global/dentesperdidos = 0
var/global/firstvictim
var/global/firstvictimlastword
var/global/gruevictims = 0
var/global/manyburied = 0
var/global/itemscrafted = 0
var/global/migrantsarrived = 0
var/global/migrantsdied = 0
var/global/limbodoors = 0
var/global/firstmigwent = FALSE
var/global/login_music = pick('sound/music/Aram_17_-_Mentally_Ill_Ghost.ogg','sound/music/beyondretrieval.ogg','sound/music/IntrudersAtTheKeep.ogg','sound/music/Newlobby30.ogg','sound/music/newlobby31.ogg','sound/music/lobbytrack1q.ogg','sound/music/Klockstapeln.ogg','sound/music/track2.ogg','sound/music/track3.ogg','sound/music/track5.ogg','sound/music/track13.ogg','sound/music/Hatter.ogg','sound/music/sacred_dagger.ogg','sound/music/outpost.ogg','sound/music/hiding.ogg','sound/music/morning.ogg','sound/music/cave_hatred.ogg')
var/list/key_changed_list = list()
var/list/soulbroken = list()
var/TIME_SINCE_START = 0

var/round_nuke_loc = "None"

/datum/controller/gameticker
	var/message_events
	var/const/restart_timeout = 600
	var/current_state = GAME_STATE_PREGAME

	var/hide_mode = 0
	var/datum/game_mode/mode = null
	var/event_time = null
	var/event = 0

	var/login_music			// music played in pregame lobby

	var/list/datum/mind/minds = list()//The people in the game. Used for objective tracking.

	var/Bible_icon_state	// icon_state the chaplain has chosen for his bible
	var/Bible_item_state	// item_state the chaplain has chosen for his bible
	var/Bible_name			// name of the bible
	var/Bible_deity_name

	var/random_players = 0 	// if set to nonzero, ALL players who latejoin or declare-ready join will have random appearances/genders

	var/list/syndicate_coalition = list() // list of traitor-compatible factions
	var/list/factions = list()			  // list of all factions
	var/list/availablefactions = list()	  // list of factions with openings

	var/pregame_timeleft = 0

	var/delay_end = 0	//if set to nonzero, the round will not restart on it's own

	var/triai = 0//Global holder for Triumvirate
	var/datum/round_event/eof
	var/first_timer = TRUE

	//MIGRANT WAVE
	var/migwave_timeleft = 30
	var/max_migrant_req = 5
	var/migrant_req = 5
	var/migwave_going = FALSE
	var/list/migrants_inwave = list()
	var/forcemod = null
	var/force_started

var/turf/MiniSpawn

/datum/controller/gameticker/proc/pre_migwave()
	var/list/mob/living/carbon/human/family_migrants = list()
	if(migwave_timeleft <= 0)
		if(LAZYLEN(migrants_inwave) >= migrant_req)
			var/turf/pickNewmigLocs
			if(mode.config_tag == "siege")
				pickNewmigLocs = pick(siegestart)
				max_migrant_req = 1
			else
				pickNewmigLocs = pick(migstart)
			MiniSpawn = pickNewmigLocs
			for(var/client/C in migrants_inwave)
				if(istype(C.mob, /mob/new_player))
					to_chat(C, "The tide comes!")
					var/mob/living/carbon/human/H = C.mob:AttemptMigSpawn()
					if(C in set_spoused && !H.job != "Ordinator")
						continue
					if(H && C.prefs.family == TRUE && H.job != "Ordinator")
						family_migrants |= H
			matchmaker.do_migrant_matchmaking(family_migrants)
			matchmaker.do_migrant_setspouse()
			migwave_timeleft = initial(migwave_timeleft)
			migrant_req = max_migrant_req
			migrants_inwave.Cut()
			firstmigwent = TRUE
		else
			migwave_timeleft = initial(migwave_timeleft)
			if(migrant_req > 1 && !(mode.config_tag == "siege"))
				migrant_req--

/client/Topic(href, href_list, hsrc)
	..()
	switch(href_list["action"])
		if("joinMigWave")
			if(ticker.current_state == GAME_STATE_PLAYING)
				if(ticker.migrants_inwave.Find(src))
					ticker.migrants_inwave.Remove(src)
					src.prefs.ShowChoices(mob)
				else
					ticker.migrants_inwave.Add(src)
					src.prefs.ShowChoices(mob)
			else
				return

/datum/controller/gameticker/proc/pregame()
	var/player_count
	do
		if(first_timer)
			pregame_timeleft = 180
		else
			pregame_timeleft = 60
		to_chat(world, "<span class='lowpain'>[pregame_timeleft]s to go.</span>")
		ooc_allowed = TRUE
		player_count = 0
		for(var/mob/new_player/player in player_list)
			if(player.client)
				player_count++

		if(forcemod)
			master_mode = forcemod
		else
			if(master_mode != "extended")
				if(master_mode != "holywar")
					if((player_count >= HARD_MODE_PLAYER_CAP) && prob (50))
						master_mode = list("kingwill", "siege")
					else if(prob(85))
						var/list/gamemodes = list("changeling", "dreamer", "succubus")
						if(prob(20))
							gamemodes.Add("inspector") // this is so boring... im sorry
						master_mode = pick(gamemodes)
					else
						master_mode = "quietday"


		while(current_state == GAME_STATE_PREGAME)
			for(var/i=0, i<10, i++)
				sleep(1)
				vote.process()
			if(going)
				pregame_timeleft--
			if(pregame_timeleft <= 0)
				current_state = GAME_STATE_SETTING_UP
				Master.SetRunLevel(RUNLEVEL_SETUP)
	while (!setup())


/datum/controller/gameticker/proc/setup()
	if(current_state == GAME_STATE_PLAYING || Master.current_runlevel == RUNLEVEL_GAME)
		return

	//Create and announce mode
	if(master_mode=="secret")
		src.hide_mode = 1

	var/list/datum/game_mode/runnable_modes

	if((master_mode=="random") || (master_mode=="secret"))
		runnable_modes = config.get_runnable_modes()

		if (length(runnable_modes) == 0)
			current_state = GAME_STATE_PREGAME
			Master.SetRunLevel(RUNLEVEL_LOBBY)
			world << "<B>Unable to choose playable game mode.</B> Reverting to pre-game lobby."
			return 0

		if(secret_force_mode != "secret")
			var/datum/game_mode/M = config.pick_mode(secret_force_mode)
			if(M.can_start())
				src.mode = config.pick_mode(secret_force_mode)

		job_master.ResetOccupations()

		if(!src.mode)
			src.mode = pickweight(runnable_modes)

		if(src.mode)
			var/mtype = src.mode.type
			src.mode = new mtype
	else
		if(master_mode == "holywar")
			src.mode = config.pick_mode("holywar")
			login_music = 'sound/holywar/holywarlobby.ogg'
			global.login_music = 'sound/holywar/holywarlobby.ogg'
			for(var/mob/new_player/N in player_list)
				N.client.playtitlemusic()
		else
			src.mode = config.pick_mode(master_mode)

	if(!src.mode)
		current_state = GAME_STATE_PREGAME
		Master.SetRunLevel(RUNLEVEL_LOBBY)
		to_chat(world, "<span class='danger'>Serious error in mode setup!</span> Reverting to pre-game lobby.")
		return FALSE


	job_master.ResetOccupations()
	src.mode.pre_setup()
	job_master.DivideOccupations() // Apparently important for new antagonist system to register specific job antags properly.

	if (!src.mode.can_start())
		if(!ticker.force_started)
			var/baron = "badmood"
			for(var/mob/new_player/NN in player_list)
				if(NN.client.work_chosen == "Baron" && NN.ready)
					baron = "hit"

			if(master_mode == "holywar")
				to_chat(world,"<b><span class='highlighttext'>Crusade aborted:</span></b> We need <span class='bname'>20 soldiers</span>!")
				to_chat(world,"<b><span class='bname'>10 Thanatis</span> and <span class='bname'>10 Post-Christians</span>!")
			else
				to_chat(world,"<b><span class='hitbold'>Story aborted:</span></b><span class='hit'> The fortress needs a just </span><span class='[baron]'><b>Baron.</b></span>")
			first_timer = FALSE
			current_state = GAME_STATE_PREGAME
			Master.SetRunLevel(RUNLEVEL_LOBBY)
			mode = null
			job_master.ResetOccupations()
			return FALSE

	createnuke()
	createHellDoor()
	create_characters() //Create player characters and transfer them
	set_treasury()
	if(!eof)
		eof = pick_round_event()

	migwave_going = TRUE
	pre_migwave()
	collect_minds()
	equip_characters()
	matchmaker.do_family_matchmaking()
	matchmaker.setup_special_marriage()
	give_keys()
	do_postequip()
	current_state = GAME_STATE_PLAYING
	for(var/client/C in player_list)
		C << browse(null, "window=playerlist")

	callHook("roundstart")

	//here to initialize the random events nicely at round start
	//setup_economy()

	// TODO - Leshana - Dear God Fix This.  Fix all of this. Not just this line, this entire proc. This entire file!
	spawn(0)//Forking here so we dont have to wait for this to finish
		mode.post_setup()
		//Cleanup some stuff
		for(var/obj/effect/landmark/start/S in landmarks_list)
			//Deleting Startpoints but we need the ai point to AI-ize people later
			if (S.name != "AI")
				landmarks_list -= S
				qdel(S)
		if(master_mode == "holywar")
			to_chat(world,"<h2><B><FONT color='#8f535d'>Holy War!</font></B></h2>")
			var/quote = pick("War is neither glamorous nor attractive. It is monstrous. Its very nature is one of tragedy and suffering.","Dwell in peace in the home of your own being, and the Messenger of Death will not be able to touch you.","The real and lasting victories are those of peace and not of war.")
			to_chat(world,"<h4><B><i> \"[quote]\" </i></B></h4>")
			world << 'sound/effects/war_banner.ogg'
			world << sound('sound/holywar/holywarintroduction.ogg', volume = 50, channel = 6)
		else
			TIME_SINCE_START = world.time

		for(var/client/C in clients)
			C << browse(null, "window=playerlist")
			C.prefs.roundsplayed += 1
			C.prefs.save_preferences()
			C.prefs.savefile_update()
		announce_events()
		apply_events()
		world << sound('sound/AI/welcome.ogg') // Skie
		ooc_allowed = FALSE
	//new random event system is handled from the MC.

	supply_shuttle.process() 		//Start the supply shuttle regenerating points -- TLE
	processScheduler.start()
	Master.SetRunLevel(RUNLEVEL_GAME)
	createnpcs()
	lightlumosoviks()
	//update_the_treasury()
	update_the_graceperiods()
	//lighting_controller.process()	//Start processing DynamicAreaLighting updates
	var/list/possibletiamathi = list()
	var/list/possiblehunters = list()
	var/mob/living/carbon/human/traitor_tiamat
	var/mob/living/carbon/human/hunter
	for(var/mob/living/carbon/human/H in player_list)
		if(H.job == "Triton")
			possibletiamathi.Add(H)
	if(length(possibletiamathi) >= 2 && prob(33))
		spawn(400)
			to_chat(world, "<span class='baronboldoutlined'>One of the Tritons is a TRAITOR.</span> <span class='baron'>Rumors about them have disturbed the Fortress for weeks, but the villain's identity remains unclear.</span>")
		if(prob(50))
			traitor_tiamat = pick(possibletiamathi)
			traitor_tiamat.add_event("Imposter", /datum/happiness_event/imposter)
			possibletiamathi.Remove(traitor_tiamat)

			for(var/mob/living/carbon/human/OtherTiamathi in possibletiamathi)
				OtherTiamathi.add_event("Imposterbad", /datum/happiness_event/imposterbad)

			if(traitor_tiamat)
				to_chat(traitor_tiamat, "<span class='baronboldoutlined'>You're a traitor Triton. </span><span class='baron'>Your pay is pathetic, your tasks are suicidal, and the Thanati offered you enough money to buy a dozen fortresses.</span>")
				to_chat(traitor_tiamat, "<span class='baronboldoutlined'>OBJECTIVE: </span><span class='baron'>Assassinate the Baron and survive with his ring.</span>")
				traitor_tiamat.mind.special_role = "tiamatrait"
				traitor_tiamat.combat_music = 'sound/lfwbcombatuse/traitcerbcombat.ogg'
	if(master_mode == "changeling")
		for(var/mob/living/carbon/human/H in player_list)
			if(is_they(H)) continue
			if(H.job != "Baron")
				possiblehunters.Add(H)
		if(length(possiblehunters))
			hunter = pick(possiblehunters)
			hunter.add_event("Hunter", /datum/happiness_event/hunter)
			possiblehunters.Remove(hunter)

			to_chat(hunter, "THEY hide here, wearing human form. I am the only one who knows about THEM, and if I speak up, THEY'll find out and surely kill me. I must tread lightly")
			to_chat(hunter, "<B>Objective #1</B>: Stop THEM by exterminating all the specimen")
			to_chat(hunter, "<B>Objective #1</B>: Survive! You're the only one who truly understands the threat.")
			to_chat(hunter, SPAN_NOTICE("As you've managed to learn, it's possible to unmask THEM using [ticker.mode.changeling_chem]"))
			hunter.mind.special_role = "hunter"
			ticker.mode.hunter = hunter.real_name
			hunter.combat_music = 'sound/lfwbsounds/bloodlust1.ogg'

	for(var/mob/living/carbon/human/H in player_list)
		if(H.job == "Baron" || H.job == "Vicar" || H.job == "Merchant")
			H.client.ChromieWinorLoose(1)

	for(var/obj/multiz/ladder/L as anything in ladder_list)
		L.connect() //Lazy hackfix for ladders. TODO: move this to an actual controller. ~ Z

	return TRUE

/datum/controller/gameticker
	//station_explosion used to be a variable for every mob's hud. Which was a waste!
	//Now we have a general cinematic centrally held within the gameticker....far more efficient!
	var/obj/screen/cinematic = null

	//Plus it provides an easy way to make cinematics for other events. Just use this as a template :)
	proc/station_explosion_cinematic(var/station_missed=0, var/override = null)
		if( cinematic )	return	//already a cinematic in progress!

		//initialise our cinematic screen object
		cinematic = new(src)
		cinematic.icon = 'icons/effects/station_explosion.dmi'
		cinematic.icon_state = "start"
		cinematic.layer = 21
		cinematic.mouse_opacity = 0
		//cinematic.screen_loc = "1,0"
		cinematic.screen_loc = "CENTER-7,CENTER-7"

		var/obj/structure/stool/bed/temp_buckle = new(src)
		//Incredibly hackish. It creates a bed within the gameticker (lol) to stop mobs running around
		if(station_missed)
			for(var/mob/living/M in living_mob_list)
				M.buckled = temp_buckle				//buckles the mob so it can't do anything
				if(M.client)
					M.client.screen += cinematic	//show every client the cinematic
		else	//nuke kills everyone on z-level of a ship to prevent "hurr-durr I survived"
			for(var/mob/living/M in living_mob_list)
				M.buckled = temp_buckle
				if(M.client)
					M.client.screen += cinematic

				if(M.z == 0)	//inside a crate or something
					var/turf/T = get_turf(M)
					if(T && !(T.z in vessel_z))				//we don't use M.death(0) because it calls a for(/mob) loop and
						M.health = 0
						M.stat = DEAD
				else if(M.z in vessel_z)	//on a ship's turf.
					M.health = 0
					M.stat = DEAD

		//Now animate the cinematic
		switch(station_missed)
			if(1)	//nuke was nearby but (mostly) missed
				if( mode && !override )
					override = mode.name
				switch( override )
					if("nuclear emergency") //Nuke wasn't on station when it blew up
						flick("start_nuke",cinematic)
						sleep(35)
						world << sound('sound/effects/nukee.ogg')
						flick("explode",cinematic)
						cinematic.icon_state = "loss_nuke"
					else
						flick("start_nuke",cinematic)
						sleep(35)
						world << sound('sound/effects/nukee.ogg')
						flick("explode",cinematic)
						cinematic.icon_state = "loss_nuke"


			if(2)	//nuke was nowhere nearby	//TODO: a really distant explosion animation
				sleep(50)
				world << sound('sound/effects/nukee.ogg')


			else	//station was destroyed
				if( mode && !override )
					override = mode.name
				switch( override )
					if("nuclear emergency") //Nuke Ops successfully bombed the station
						flick("intro_nuke",cinematic)
						sleep(35)
						flick("station_intact",cinematic)
						world << sound('sound/effects/explosionfar.ogg')
						cinematic.icon_state = "station_intact"
					else //Station nuked (nuke,explosion,summary)
						flick("start_nuke",cinematic)
						sleep(35)
						world << sound('sound/effects/nukee.ogg')
						flick("explode",cinematic)
						cinematic.icon_state = "loss_nuke"
				for(var/mob/living/M in living_mob_list)
					var/area/A = get_area(M)
					if(!A.nukesafe)
						M.death()
						M.client.ChromieWinorLoose(-1)
		//No mercy
		//If its actually the end of the round, wait for it to end.
		//Otherwise if its a verb it will continue on afterwards.
		sleep(300)

		if(cinematic)	qdel(cinematic)		//end the cinematic
		if(temp_buckle)	qdel(temp_buckle)	//release everybody
		return


	proc/create_characters()
		for(var/mob/new_player/player in player_list)
			if(player.ready && player.mind)
				if(player.mind.assigned_role=="AI")
					player.close_spawn_windows()
					player.AIize()
				else if(player.mind.assigned_role == "Baron" && length(player.aspects_list) && !length(eof))
					eof = pick(player.aspects_list)
					player.create_character()
					qdel(player)
				else if(!player.mind.assigned_role)
					continue
				else
					player.create_character()
					//player.preferences.save_preferences()
					//player.client.prefs.save_preferences()
					qdel(player)


	proc/collect_minds()
		for(var/mob/living/player in player_list)
			if(player.mind)
				ticker.minds += player.mind

	proc/createnpcs()
		for(var/obj/effect/landmark/L in landmarks_list)
			if (L.name == "NPCBum")
				if(prob(50))
					new /mob/living/carbon/human/bumbot(L.loc)
		for(var/obj/effect/landmark/L in landmarks_list)
			if (L.name == "BigRat")
				if(prob(45))
					new /mob/living/carbon/human/monster/rat(L.loc)
		for(var/obj/effect/landmark/L in landmarks_list)
			if (L.name == "Strygh")
				if(prob(65))
					new /mob/living/carbon/human/monster/strygh(L.loc)
		for(var/obj/effect/landmark/L in landmarks_list)
			if (L.name == "Arellit")
				new /mob/living/carbon/human/monster/arellit/adult(L.loc)
		for(var/obj/effect/landmark/L in landmarks_list)
			if (L.name == "Skinless")
				new /mob/living/carbon/human/skinless(L.loc)
		for(var/obj/effect/landmark/L in landmarks_list)
			if (L.name == "NPCSkeleton")
				new /mob/living/carbon/human/monster/skeleton(L.loc)
		for(var/obj/effect/landmark/L in landmarks_list)
			if (L.name == "AncestorSkeleton")
				new /mob/living/carbon/human/monster/skeleton/ancestor(L.loc)
		for(var/obj/effect/landmark/L in landmarks_list)
			if (L.name == "Eelo")
				new /mob/living/carbon/human/monster/eelo(L.loc)
		for(var/obj/effect/landmark/L in landmarks_list)
			if (L.name == "Tzanch")
				if(prob(80))
					new /mob/living/carbon/human/monster/tzanch(L.loc)
		for(var/obj/effect/landmark/L in landmarks_list)
			if (L.name == "Zombie")
				if(prob(80))
					new /mob/living/carbon/human/zombiebot(L.loc)
		for(var/obj/effect/landmark/L in landmarks_list)
			if (L.name == "Graga")
				if(prob(90))
					new /mob/living/carbon/human/monster/graga(L.loc)
		for(var/obj/effect/landmark/L in landmarks_list)
			if (L.name == "Loge")
				if(prob(80))
					new /mob/living/carbon/human/monster/loge(L.loc)
		for(var/obj/effect/landmark/L in landmarks_list)
			if (L.name == "NewMonkey")
				if(prob(70))
					new /mob/living/carbon/human/monster/newmonkey(L.loc)
		var/list/puppeList = list()
		for(var/obj/effect/landmark/L in landmarks_list)
			if (L.name == "Puppeteer")
				puppeList.Add(L.loc)

		if(!LAZYLEN(puppeList))
			return
		var/turf/newLoc = pick(puppeList)
		new /mob/living/puppeteer(newLoc)
	proc/createnuke()
		if(!LAZYLEN(nukeSpawn))
			return
		var/turf/newLoc = pick(nukeSpawn)
		var/area/A = get_area(newLoc)
		new /obj/machinery/nuclearbomb(newLoc)
		if(A)
			round_nuke_loc = A.name
	proc/createHellDoor()
		if(!LAZYLEN(HellDoor))
			return
		var/turf/newLoc = pick(HellDoor)
		new /obj/structure/helldoor(newLoc)

	proc/lightlumosoviks()
		for(var/obj/structure/lifeweb/mushroom/glorbmushroom/G in lumosoviks_list)
			G.set_light(4, 4,"#5e90a6")
		for(var/obj/machinery/glowshroom/G in lumosoviks_list)
			G.set_light(3, 3,"#d5fa84")
			G.icon_state = pick("1","2","3","4")
		for(var/obj/structure/lifeweb/grass/glow/G in lumosoviks_list)
			G.set_light(2, 2,"#edc87e")


	proc/update_the_graceperiods()
		if(master_mode == "minimig")
			for(var/obj/effect/blockedminimig/M in minimiglist)
				M.icon_state = "dark23"
		else
			QDEL_LIST(minimiglist)

	proc/equip_characters()
		if(master_mode == "minimig" || master_mode == "holywar")
			for(var/mob/living/carbon/human/player in player_list)
				if(player && player.mind)
					job_master.EquipRank(player, "Migrant")
					player.special_load()
					EquipCustomItems(player)
					return
		for(var/mob/living/carbon/human/player in player_list)
			if(player.mind.assigned_role != "MODE")
				job_master.EquipRank(player, player.mind.assigned_role, 0)
				EquipCustomItems(player)

	proc/do_postequip()
		if(master_mode == "minimig" || master_mode == "holywar")
			for(var/mob/living/carbon/human/player in player_list)
				if(player && player.mind)
					job_master.PostEquip(player, 0)
					return
		for(var/mob/living/carbon/human/player in player_list)
			if(player.mind.assigned_role != "MODE")
				job_master.PostEquip(player, 0)

	proc/give_keys()
		var/list/slots = list (
		"left pocket" = slot_l_store,
		"right pocket" = slot_r_store,
		"left hand" = slot_l_hand,
		"right hand" = slot_r_hand,
		)
		var/datum/family/biggest
		var/datum/family/second
		for(var/datum/family/F in matchmaker.families)
			if(F == baron_family)
				continue
			if(!biggest)
				biggest = F
				continue
			if(!second)
				second = F
				continue
			if(LAZYLEN(F.members) <= 1)
				continue
			if(LAZYLEN(F.members) > LAZYLEN(biggest.members))
				biggest = F
				continue
			if(LAZYLEN(F.members) > LAZYLEN(second.members))
				second = F
		if(biggest)
			var/list/mob/living/carbon/human/biggest_members = (biggest.members + biggest.family_head)
			for(var/mob/living/carbon/human/H in biggest_members)
				var/obj/item/key/residencesONE/K = new()
				var/where = H.equip_in_one_of_slots(K, slots)
				if (!where)
					K.loc = get_turf(H)
					to_chat(H,"My family has a house inside the fortress. It's the first house in the residences alley. My key is at my feet")
				else
					to_chat(H,"My family has a house inside the fortress. It's the first house in the residences alley. My key is in my [where]")
					H.update_icons()
		if(second)
			var/list/mob/living/carbon/human/second_members = (second.members + second.family_head)
			for(var/mob/living/carbon/human/H in second_members)
				var/obj/item/key/residencesTWO/K = new()
				var/where = H.equip_in_one_of_slots(K, slots)
				if (!where)
					K.loc = get_turf(H)
					to_chat(H,"My family has a house inside the fortress. It's the second house in the residences alley. My key is at my feet")
				else
					to_chat(H,"My family has a house inside the fortress. It's the second house in the residences alley. My key is in my [where]")
					H.update_icons()

	proc/process()
		if(current_state != GAME_STATE_PLAYING)
			return 0

		mode.process()

		emergency_shuttle.process()

		if(migwave_timeleft <= 0)
			pre_migwave()
		else
			if(migwave_timeleft > 0)
				migwave_timeleft--

		if(energyInvestimento == 1)
			treasuryworth.add_money(-3)

		var/datum/shuttle/S = global.shuttleMain

		var/mode_finished = (mode.check_finished() || (emergency_shuttle.location == 2 && emergency_shuttle.alert == 1 || S.location_flag & FLAG_LEVIATHAN)) // 3 == LEVIATHAN
		if((!mode.explosion_in_progress && mode_finished)|| quietend)
			current_state = GAME_STATE_FINISHED
			Master.SetRunLevel(RUNLEVEL_POSTGAME)

			declare_completion()

			spawn(50)
				callHook("roundend")

				if (mode.station_was_nuked)
					if(!delay_end)
						to_chat(world,"<span class='passivebold'>This is how the day has passed.</span> <span class='passive'>One minute until story end.</span>")
				else
					if(!delay_end)
						to_chat(world,"<span class='passivebold'>This is how the day has passed.</span> <span class='passive'>One minute until story end.</span>")

				if(!delay_end)
					sleep(restart_timeout)
					if(!delay_end)
						to_chat(world, "<span class='bname'>Your fortress has been abandoned.</span>")
						world.Reboot()
					else
						to_chat(world,"<span class='passivebold'>[pick(fnord)]</span> <span class='passive'>The comatic hasn't allowed the story to end yet!</span>")
				else
					to_chat(world,"<span class='passivebold'>[pick(fnord)]</span> <span class='passive'>The comatic hasn't allowed the story to end yet!</span>")


		return 1

	proc/getfactionbyname(var/name)
		for(var/datum/faction/F in factions)
			if(F.name == name)
				return F

	proc/announce_events()
		if(!message_events)
			message_events += "[eof.event_message] "
		if(eof.roundstartdisplay)
			to_chat(world, "<span class ='passivebold'>Praise the Lord!</span> <span class ='passive'>[message_events]</span>")

	proc/apply_events()
		eof.apply_event()

/mob/living/carbon/human/var/dst_completed = 0

/datum/controller/gameticker/proc/declare_completion()

	var/list/client/cultists = list()
	for(var/mob/M in player_list)
		if(M.client.prefs.toggles & SOUND_MIDI && EndRoundMusicGAMEMODE == 0) //pra antag que tem endround song proprio, e uma var global so botar = 1 e deixar no declare completion
			M << pick('sound/roundend1.ogg','sound/roundend2.ogg')
			showlads = TRUE
			var/list/nomusicmodes = list("revolution")
			if(M.z >= 5 || nomusicmodes.Find(master_mode))
				M << sound('sound/music/sherold.ogg', repeat = 0, wait = 0, volume = M?.client?.prefs?.music_volume, channel = 24)
	var/list/thanati_list = list()
	for(var/mob/living/carbon/human/H in mob_list)
		if(H.religion == "Thanati")
			if(LAZYLEN(thanati_list) > 1)
				thanati_list.Add(", [H.real_name]")
			else
				thanati_list.Add("[H.real_name]")
		if(H.stat != DEAD && H.client) // LEVIATHAN
			if(H.religion == "Thanati")
				cultists |= H.client
				continue
			break

	to_chat(player_list, "<span class='boldred'>[vessel_name()] (Story #[story_id])</span>")
	to_chat(player_list,"<br><span class='dreamershitbutitsbigasfuckanditsboldtoo'><center>[mode.name]</center></span><br><br>")

	ooc_allowed = TRUE
	mode.declare_completion()//To declare normal completion.
	to_chat(player_list,"<span class='bname'><font size=+2>STATISTICS:</font></span><br>")
	to_chat(player_list,"<span class='passive'>The aspect was: <i>[eof.name]:</i> <b>[message_events]<b></span><br>")
	to_chat(player_list,"&#8226; Deaths in the Caves: [deathincave]")
	to_chat(player_list,"&#8226; Deaths in the Fortress: [deathinfort]")
	to_chat(player_list,"&#8226; Buried: [manyburied]") // BOTAR O BURIED AQUI
	to_chat(player_list,"&#8226; First victim: [firstvictim], Last Words:\"[firstvictimlastword]\"")
	to_chat(player_list,"&#8226; Orgasms: [orgasms]")
	to_chat(player_list,"&#8226; Migrants arrived: [migrantsarrived]")
	to_chat(player_list,"&#8226; Migrants died: [migrantsdied]")
	to_chat(player_list,"&#8226; Teeth lost: [dentesperdidos]")
	to_chat(player_list,"&#8226; Items crafted: [itemscrafted]")
	to_chat(player_list,"&#8226; Chromosomes lost: [cromosperdidos]")
	to_chat(player_list,"&#8226; Eaten by a grue: [gruevictims]")
	to_chat(player_list,"&#8226; Limbo doors found: [limbodoors]")
	if(LAZYLEN(soulbroken) >= 1)
		to_chat(player_list,"<span class='bname'><font color='#910000'>&#8226; Soulbroken into slavery:</font></span> <span class='combat'>[english_list(soulbroken)]</span>")
	if(LAZYLEN(thanati_list) >= 1)
		to_chat(player_list,"<span class='passivebold'>&#8226;</span> <span class='passivebold'>The Thanati cultists were:</span> <span class='passive'>[english_list(thanati_list)]</span>")
	if(thanatiGlobal.objective.checkCompletion())
		to_chat(player_list,"<span class='passivebold'>&#8226;</span> <span class='passivebold'> The thanati cultists managed to complete their objective!</span>")
		to_chat(player_list,"<span class='passivebold'>&#8226;</span> <span class='passivebold'> Tzchernobog Wish: [thanatiGlobal?.objective?.name]</span>")
	else
		to_chat(player_list,"<span class='passivebold'>&#8226;</span> <span class='passivebold'> The thanati cultists did not complete their objective!</span>")
		to_chat(player_list,"<span class='passivebold'>&#8226;</span> <span class='passivebold'> Tzchernobog Wish: [thanatiGlobal?.objective?.name]</span>")
	if(LAZYLEN(key_changed_list) >= 1)
		to_chat(player_list, "Roles Handover: [english_list(key_changed_list)]")
	if(LAZYLEN(achievements_unlocked) >= 1)
		to_chat(player_list, "Achievements Unlocked: [english_list(achievements_unlocked)]")

	mode.end_round_rewards()

	for (var/mob/living/carbon/human/H in mob_list)
		H.CheckFateCompletion()
		H.CheckSpecialCompletion()
	//calls auto_declare_completion_* for all modes
	for(var/handler in typesof(/datum/game_mode/proc))
		if (findtext("[handler]","auto_declare_completion_"))
			call(mode, handler)()

	CheckLatepartyCompletion()

	for(var/mob/living/carbon/human/H in thanatiGlobal.knowsTheObjective)
		if(thanatiGlobal.objective.checkCompletion())
			H?.client?.ChromieWinorLoose(thanatiGlobal.objective.reward)

	//Print a list of antagonists to the server log
	var/list/total_antagonists = list()
	//Look into all mobs in world, dead or alive
	for(var/datum/mind/Mind in minds)
		var/temprole = Mind.special_role
		if(temprole)							//if they are an antagonist of some sort.
			if(temprole in total_antagonists)	//If the role exists already, add the name to it
				total_antagonists[temprole] += ", [Mind.name]([Mind.key])"
			else
				total_antagonists.Add(temprole) //If the role doesnt exist in the list, create it and add the mob
				total_antagonists[temprole] += ": [Mind.name]([Mind.key])"

	//Now print them all into the log!
	log_game("Antagonists at round end were...")
	for(var/i in total_antagonists)
		log_game("[i]s[total_antagonists[i]].")
	mode.check_round()

	return 1

/mob/living/carbon/human/proc/CheckSpecialCompletion()
	if(special)
		var/has_ticket = FALSE
		for(var/obj/item/T in contents)
			if(istype(T, /obj/item/clothing/head/amulet/ticket))
				has_ticket = TRUE
				break
		switch(special)
			if("dst")
				if(LAZYLEN(src.HadSex) >= 6 && stat != DEAD && src.job == "Amuser")
					src?.client?.ChromieWinorLoose(10)
			if("amusermany")
				if(LAZYLEN(src.HadSex) >= 1 && stat != DEAD && src.job == "Amuser")
					src?.client?.ChromieWinorLoose(LAZYLEN(src.HadSex))
			if("baronsurvive")
				if(src.job == "Triton")
					for(var/mob/living/carbon/human/H in mob_list)
						if(H.job == "Baron" && H.stat != DEAD)
							src?.client?.ChromieWinorLoose(2)
			if("unmarriedwoman")
				if(src.gender == FEMALE && src?.client?.married)
					var/area/A = get_area(src)
					if(istype(A,/area/shuttle/escape/centcom) && stat != DEAD || istype(A,/area/dunwell/artemis) && stat != DEAD)
						src?.client?.ChromieWinorLoose(5)
					else if(has_ticket && stat != DEAD)
						src?.client?.ChromieWinorLoose(5)
			if("rich")
				if(supply_shuttle.points >= 5000 && (src.job == "Merchant" || src.job == "Docker"))
					src?.client?.ChromieWinorLoose(10)
					src.unlock_medal("The Richest Man In The Fortress", 0, "Collected more then 5000 obols in the merchant console.", "24")


/mob/living/carbon/human/proc/CheckFateCompletion()
	if(job)
		switch(job)
			if("Baron")
				// COLOQUE TODOS OS MODOS QUE NÃO DEVEM PERDER CHROMIE QUANDO A CHARON SAI SEM O BARON NA LISTA
				var/list/NonChormieModes = list(
				"extended"
				)
				if(!NonChormieModes.Find(master_mode))
					if(stat != DEAD)
						src?.client?.ChromieWinorLoose(2)
					else
						src?.client?.ChromieWinorLoose(-3)
			if("Amuser")
				var/datum/ring_account/RA = found_account_by_human(src)
				if(LAZYLEN(src.HadSex) >= 3 && RA && stat != DEAD)
					if(RA.get_money() >= 100)
						to_chat(src, "GOOD WHORE.")
						src?.client?.ChromieWinorLoose(3)
			if("Kraken")
				for(var/mob/living/carbon/human/H in mob_list)
					if(H.job == "Baron" && H.stat != DEAD)
						src?.client?.ChromieWinorLoose(1)

/proc/CheckLatepartyCompletion()
	if(vanden_late == 1)
		for(var/mob/living/carbon/human/H in mob_list)
			var/area/A = get_area(H)
			if(H.job == "Lady Vandenberg" && istype(A, /area/safespawnarea/ladycapturezone) && H.stat != DEAD)
				for(var/mob/living/carbon/human/ludruk in mob_list)
					if(ludruk.job == "Ludruk's Leper")
						ludruk?.client?.ChromieWinorLoose(3)
						to_chat(ludruk, "<span class='baronboldoutlined'>Lord Ludruk will be pleased.</span>")
				break

/world/proc/has_round_started()
	return (ticker && ticker.current_state >= GAME_STATE_PLAYING)