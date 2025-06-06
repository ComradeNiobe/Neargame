//This file was auto-corrected by findeclaration.exe on 25.5.2012 20:42:31

/*
 * GAMEMODES (by Rastaf0)
 *
 * In the new mode system all special roles are fully supported.
 * You can have proper wizards/traitors/changelings/cultists during any mode.
 * Only two things really depends on gamemode:
 * 1. Starting roles, equipment and preparations
 * 2. Conditions of finishing the round.
 *
 */

/datum/game_mode
	var/name = "invalid"
	var/config_tag = null
	var/intercept_hacked = 0
	var/votable = 1
	var/probability = 0
	var/station_was_nuked = 0 //see nuclearbomb.dm and malfunction.dm
	var/explosion_in_progress = 0 //sit back and relax
	var/list/datum/mind/modePlayer = new
	var/list/restricted_jobs = list()	// Jobs it doesn't make sense to be.  I.E chaplain or AI cultist
	var/list/protected_jobs = list()	// Jobs that can't be tratiors because
	var/required_players = 0
	var/required_players_secret = 0 //Minimum number of players for that game mode to be chose in Secret
	var/required_enemies = 0
	var/mob/living/succubus = null
	var/recommended_enemies = 0
	var/newscaster_announcements = null
	var/uplink_welcome = "Syndicate Uplink Console:"
	var/uplink_uses = 10
	var/jobbypass = FALSE
	var/has_starring = FALSE
	var/uplink_items = {"Highly Visible and Dangerous Weapons;
/obj/item/gun/projectile:6:Revolver;
/obj/item/ammo_magazine/box/a357:2:Ammo-357;
/obj/item/gun/energy/crossbow:5:Energy Crossbow;
/obj/item/melee/energy/sword:4:Energy Sword;
/obj/item/storage/box/syndicate:10:Syndicate Bundle;
/obj/item/storage/box/emps:3:5 EMP Grenades;
Whitespace:Seperator;
Stealthy and Inconspicuous Weapons;
/obj/item/pen/paralysis:3:Paralysis Pen;
/obj/item/soap/syndie:1:Syndicate Soap;
/obj/item/cartridge/syndicate:3:Detomatix PDA Cartridge;
Whitespace:Seperator;
Stealth and Camouflage Items;
/obj/item/clothing/under/chameleon:3:Chameleon Jumpsuit;
/obj/item/clothing/shoes/syndigaloshes:2:No-Slip Syndicate Shoes;
/obj/item/card/id/syndicate:2:Agent ID card;
/obj/item/clothing/mask/gas/voice:4:Voice Changer;
/obj/item/device/chameleon:4:Chameleon-Projector;
Whitespace:Seperator;
Devices and Tools;
/obj/item/card/emag:3:Cryptographic Sequencer;
/obj/item/storage/toolbox/syndicate:1:Fully Loaded Toolbox;
/obj/item/storage/box/syndie_kit/space:3:Space Suit;
/obj/item/clothing/glasses/thermal/syndi:3:Thermal Imaging Glasses;
/obj/item/device/encryptionkey/binary:3:Binary Translator Key;
/obj/item/aiModule/syndicate:7:Hacked AI Upload Module;
/obj/item/plastique:2:C-4 (Destroys walls);
/obj/item/device/powersink:5:Powersink (DANGER!);

/obj/item/circuitboard/teleporter:20:Teleporter Circuit Board;
Whitespace:Seperator;
Implants;
/obj/item/storage/box/syndie_kit/imp_freedom:3:Freedom Implant;
/obj/item/storage/box/syndie_kit/imp_uplink:10:Uplink Implant (Contains 5 Telecrystals);
/obj/item/storage/box/syndie_kit/imp_explosive:6:Explosive Implant (DANGER!);
/obj/item/storage/box/syndie_kit/imp_compress:4:Compressed Matter Implant;Whitespace:Seperator;
(Pointless) Badassery;
/obj/item/toy/syndicateballoon:10:For showing that You Are The BOSS (Useless Balloon);"}

// Items removed from above:
/*
/obj/item/device/radio/beacon/syndicate:7:Singularity Beacon (DANGER!);
/obj/item/cloaking_device:4:Cloaking Device;	//Replacing cloakers with thermals.	-Pete
*/

/datum/game_mode/proc/announce() //to be calles when round starts
	world << "<B>Notice</B>: [src] did not define announce()"


///can_start()
///Checks to see if the game can be setup and ran with the current number of players or whatnot.
/datum/game_mode/proc/can_start()
	var/playerC = 0
	for(var/mob/new_player/player in player_list)
		if((player.client)&&(player.ready))
			playerC++

	if(master_mode == "secret")
		if(playerC >= required_players_secret)
			return TRUE
	else
		if(playerC >= required_players)
			return TRUE

	if(ticker.force_started)
		return TRUE

	return FALSE

///pre_setup()
///Attempts to select players for special roles the mode might have.
/datum/game_mode/proc/pre_setup()
	return 1


///post_setup()
///Everyone should now be on the station and have their normal gear.  This is the place to give the special roles extra things
/datum/game_mode/proc/post_setup()
	spawn (ROUNDSTART_LOGOUT_REPORT_TIME)
		display_roundstart_logout_report()
	return 1


///process()
///Called by the gameticker
/datum/game_mode/proc/process()
	return 0


/datum/game_mode/proc/check_finished() //to be called by ticker
	if(emergency_shuttle.location==2 || station_was_nuked || roundendready)
		return 1
	return 0


/datum/game_mode/proc/declare_completion()
	var/amountswon = 0 // 1 ele existia 2 ele existia mas falhou 3 ele existia e foi bem sucedido
	var/mob/living/tiamatrait = null
	for(var/mob/living/carbon/human/H in mob_list)
		if(H.job == "Triton" && H.mind.special_role == "tiamatrait")
			amountswon = 1
			tiamatrait = H
			var/list/all_items = H.get_contents()
			for(var/obj/item/I in all_items)
				if(istype(I, /obj/item/card/id/lord))
					amountswon += 1
			for(var/mob/living/carbon/human/blowjob in mob_list)
				if(blowjob.job == "Baron" && blowjob.stat == DEAD)
					amountswon += 1
		if(is_succubus(H) && master_mode != "succubus")
			var/succwin = 1
			var/text = ""
			to_chat(world, "<span class='dreamershitfuckcomicao1'>The Succubus was: [H.real_name] ([H.key])</span>")
			if(H.mind.objectives.len)
				var/count = 1
				for(var/datum/objective/objective in H.mind.objectives)
					if(objective.check_completion())
						text += "<br><span class='bname'>Objective #[count]</span>: [objective.explanation_text] <font color='green'><B>Success</B></font>"
					else
						text += "<br><span class='bname'>Objective #[count]</span>: [objective.explanation_text] <font color='red'>Failure</font>"
						succwin = 0
					count++
			if(succwin)
				text += "<h3><span class='passive'>[H.real_name] The Succubus has achieved her goals! The sinners will serve their Mistress for eternity!</span></h3>"
			else
				text += "<h3><span class='combat'>Morality Victory! The Succubus has failed at corrupting the fortress!</span></h3>"
			to_chat(world, text)

	if(tiamatrait)
		has_starring = TRUE
		if(amountswon <= 2)
			to_chat(world, "<span class='dreamershitfuckcomicao1'>Starring: [capitalize(pick(tiamatrait.ckey))]</span>")
			to_chat(world, "<span class='dreamershitfuckcomicao1'>The Traitor was unsuccessful!</span>")
			tiamatrait?.client?.ChromieWinorLoose(-1)
			to_chat(tiamatrait, "\n<span class='dreamershitbutitsbigasfuckanditsboldtoo'>			     I WAS A FAILURE! THEY'RE GOING TO KILL ME!</span>\n\n\n")
		else if(amountswon == 3)
			to_chat(world, "<span class='dreamershitfuckcomicao1'>Starring: [capitalize(pick(tiamatrait.ckey))]</span>")
			to_chat(world, "<span class='dreamershitfuckcomicao1'>The Traitor has been successful!</span>")
			to_chat(tiamatrait, "\n<span class='dreamershitbutitsbigasfuckanditsboldtoo'>			     Feels good to be the Traitor.</span>\n\n\n")
			tiamatrait.client.ChromieWinorLoose(7)


/datum/game_mode/proc/check_win() //universal trigger to be called at mob death, nuke explosion, etc. To be called from everywhere.
	return 0

/datum/game_mode/proc/get_players_for_antag(var/override_jobbans=0)
	var/list/players = list()
	var/list/candidates = list()

	// Assemble a list of active players without jobbans.
	for(var/mob/new_player/player in player_list)
		if(player.client && player.ready)
			players += player

	// Shuffle the players list so that it becomes ping-independent.
	players = shuffle(players)

	// Get a list of all the people who want to be the antagonist for this round
	for(var/mob/new_player/player in players)
		if(player.client.prefs.be_antag == TRUE)
			log_debug("[player.key] wants to be antag.")
			candidates += player.mind
			players -= player

	// If we don't have enough antags, draft people.
	if(candidates.len < recommended_enemies)
		for(var/mob/new_player/player in players)
			log_debug("[player.key] forced to be antag.")
			candidates += player.mind
			players -= player
			if(candidates.len >= recommended_enemies)
				break

	// Remove candidates who want to be antagonist but have a job that precludes it
	if(restricted_jobs)
		for(var/datum/mind/player in candidates)
			for(var/job in restricted_jobs)
				if(player.assigned_role == job)
					candidates -= player

	return candidates		// Returns: The number of people who had the antagonist role set to yes, regardless of recomended_enemies, if that number is greater than recommended_enemies
							//			recommended_enemies if the number of people with that role set to yes is less than recomended_enemies,
							//			Less if there are not enough valid players in the game entirely to make recommended_enemies.


/datum/game_mode/proc/latespawn(var/mob)


/datum/game_mode/proc/num_players()
	. = 0
	for(var/mob/new_player/P in player_list)
		if(P.client && P.ready)
			. ++


///////////////////////////////////
//Keeps track of all living heads//
///////////////////////////////////
/datum/game_mode/proc/get_living_heads()
	var/list/heads = list()
	for(var/mob/living/carbon/human/player in mob_list)
		if(player.stat!=2 && player.mind && (player.mind.assigned_role in command_positions))
			heads += player.mind
	return heads


////////////////////////////
//Keeps track of all heads//
////////////////////////////
/datum/game_mode/proc/get_all_heads()
	var/list/heads = list()
	for(var/mob/player in mob_list)
		if(player.mind && (player.mind.assigned_role in command_positions))
			heads += player.mind
	return heads

/datum/game_mode/New()
	newscaster_announcements = pick(newscaster_standard_feeds)

//////////////////////////
//Reports player logouts//
//////////////////////////
proc/display_roundstart_logout_report()
	var/msg = "\blue <b>Roundstart logout report\n\n"
	for(var/mob/living/L in mob_list)

		if(L.ckey)
			var/found = 0
			for(var/client/C in clients)
				if(C.ckey == L.ckey)
					found = 1
					break
			if(!found)
				msg += "<b>[L.name]</b> ([L.ckey]), the [L.job] (<font color='#ffcc00'><b>Disconnected</b></font>)\n"


		if(L.ckey && L.client)
			if(L.client.inactivity >= (ROUNDSTART_LOGOUT_REPORT_TIME / 2))	//Connected, but inactive (alt+tabbed or something)
				msg += "<b>[L.name]</b> ([L.ckey]), the [L.job] (<font color='#ffcc00'><b>Connected, Inactive</b></font>)\n"
				continue //AFK client
			if(L.stat)
				if(L.suiciding)	//Suicider
					msg += "<b>[L.name]</b> ([L.ckey]), the [L.job] (<font color='red'><b>Suicide</b></font>)\n"
					continue //Disconnected client
				if(L.stat == UNCONSCIOUS)
					msg += "<b>[L.name]</b> ([L.ckey]), the [L.job] (Dying)\n"
					continue //Unconscious
				if(L.stat == DEAD)
					msg += "<b>[L.name]</b> ([L.ckey]), the [L.job] (Dead)\n"
					continue //Dead

			continue //Happy connected client
		for(var/mob/dead/observer/D in mob_list)
			if(D.mind && (D.mind.original == L || D.mind.current == L))
				if(L.stat == DEAD)
					if(L.suiciding)	//Suicider
						msg += "<b>[L.name]</b> ([ckey(D.mind.key)]), the [L.job] (<font color='red'><b>Suicide</b></font>)\n"
						continue //Disconnected client
					else
						msg += "<b>[L.name]</b> ([ckey(D.mind.key)]), the [L.job] (Dead)\n"
						continue //Dead mob, ghost abandoned
				else
					if(D.can_reenter_corpse)
						msg += "<b>[L.name]</b> ([ckey(D.mind.key)]), the [L.job] (<font color='red'><b>This shouldn't appear.</b></font>)\n"
						continue //Lolwhat
					else
						msg += "<b>[L.name]</b> ([ckey(D.mind.key)]), the [L.job] (<font color='red'><b>Ghosted</b></font>)\n"
						continue //Ghosted while alive



	for(var/mob/M in mob_list)
		if(M.client && M.client.holder)
			M << msg


proc/get_nt_opposed()
	var/list/dudes = list()
	for(var/mob/living/carbon/human/man in player_list)
		if(man.client)
			if(man.client.prefs.nanotrasen_relation == "Opposed")
				dudes += man
			else if(man.client.prefs.nanotrasen_relation == "Skeptical" && prob(50))
				dudes += man
	if(dudes.len == 0) return null
	return pick(dudes)

/datum/game_mode/proc/check_round()

/datum/game_mode/proc/end_round_rewards()
	return
