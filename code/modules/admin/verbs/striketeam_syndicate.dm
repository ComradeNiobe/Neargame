//STRIKE TEAMS

var/const/syndicate_commandos_possible = 6 //if more Commandos are needed in the future
var/global/sent_syndicate_strike_team = 0
/client/proc/syndicate_strike_team()
	set category = "Fun"
	set name = "Spawn Ordinator Strike Team"
	set desc = "Spawns a squad of commandos in the Ordinator homebase if you want to run an admin event."
	if(!src.holder)
		src << "Only administrators may use this command."
		return
	if(!ticker)
		alert("The game hasn't started yet!")
		return
//	if(world.time < 6000)
//		alert("Not so fast, buddy. Wait a few minutes until the game gets going. There are [(6000-world.time)/10] seconds remaining.")
//		return
	if(sent_syndicate_strike_team == 1)
		alert("The Ordinators are already sending a team, Mr. Dumbass.")
		return
	if(alert("Do you want to send in the Ordinator Strike Team? Once enabled, this is irreversible.",,"Yes","No")=="No")
		return
	alert("This 'mode' will go on until everyone is dead or the [vessel_type] is destroyed. You may also admin-call the evac shuttle when appropriate. Spawned syndicates have internals cameras which are viewable through a monitor inside the Syndicate Mothership Bridge. Assigning the team's detailed task is recommended from there. While you will be able to manually pick the candidates from active ghosts, their assignment in the squad will be random.")

	var/input = null
	while(!input)
		input = copytext(sanitize(input(src, "Please specify which mission the Ordinator strike team shall undertake.", "Specify Mission", "")),1,MAX_MESSAGE_LEN)
		if(!input)
			if(alert("Error, no mission set. Do you want to exit the setup process?",,"Yes","No")=="Yes")
				return

	if(sent_syndicate_strike_team)
		src << "Looks like someone beat you to it."
		return

	sent_syndicate_strike_team = 1

	if (emergency_shuttle.direction == 1 && emergency_shuttle.online == 1)
		emergency_shuttle.recall()

	var/syndicate_commando_number = syndicate_commandos_possible //for selecting a leader
	var/syndicate_leader_selected = 0 //when the leader is chosen. The last person spawned.

//Code for spawning a nuke auth code.
	var/nuke_code
	var/temp_code
	for(var/obj/machinery/nuclearbomb/N in world)
		temp_code = text2num(N.r_code)
		if(temp_code)//if it's actually a number. It won't convert any non-numericals.
			nuke_code = N.r_code
			break

//Generates a list of commandos from active ghosts. Then the user picks which characters to respawn as the commandos.
	var/list/candidates = list()	//candidates for being a commando out of all the active ghosts in world.
	var/list/commandos = list()			//actual commando ghosts as picked by the user.
	for(var/mob/dead/observer/G	 in player_list)
		if(!G.client.holder && !G.client.is_afk())	//Whoever called/has the proc won't be added to the list.
			if(!(G.mind && G.mind.current && G.mind.current.stat != DEAD))
				candidates += G.key
	for(var/i = commandos_possible, (i > 0 && length(candidates)), i--)//Decrease with every commando selected.
		var/candidate = input("Pick characters to spawn as the Ordinators. This will go on until there either no more ghosts to pick from or the slots are full.", "Active Players") as null|anything in candidates	//It will auto-pick a person when there is only one candidate.
		candidates -= candidate		//Subtract from candidates.
		commandos += candidate//Add their ghost to commandos.

//Spawns commandos and equips them.
	for(var/obj/effect/landmark/L in landmarks_list)
		if(syndicate_commando_number <= 0)	break
		if (L.name == "Syndicate-Commando")
			syndicate_leader_selected = syndicate_commando_number == 1 ? 1: 0

			var/mob/living/carbon/human/new_syndicate_commando = create_syndicate_death_commando(L, syndicate_leader_selected)

			if(length(commandos))
				new_syndicate_commando.key = pick(commandos)
				commandos -= new_syndicate_commando.key
				new_syndicate_commando.internal = new_syndicate_commando.s_store
				new_syndicate_commando.internals.icon_state = "internal1"

			//So they don't forget their code or mission.
			if(nuke_code)
				new_syndicate_commando.mind.store_memory("<B>Nuke Code:</B> \red [nuke_code].")
			new_syndicate_commando.mind.store_memory("<B>Mission:</B> \red [input].")

			to_chat(new_syndicate_commando, "\blue You are an Tribunal Ordinator. in the service of the God-king. \nYour current mission is: \red<B> [input]</B>")

			syndicate_commando_number--

	for (var/obj/effect/landmark/L in landmarks_list)
		if (L.name == "Syndicate-Commando-Bomb")
			new /obj/effect/spawner/newbomb/timer/syndicate(L.loc)
			qdel(L)

	message_admins("\blue [key_name_admin(usr)] has spawned a Tribunal Ordinator strike squad.", 1)
	log_admin("[key_name(usr)] used Tribunal Ordinator Squad.")

/client/proc/create_syndicate_death_commando(obj/spawn_location, syndicate_leader_selected = 0)
	var/mob/living/carbon/human/new_syndicate_commando = new(spawn_location.loc)
	var/syndicate_commando_leader_rank = pick("Lt.")
	var/syndicate_commando_rank = pick("Pvt.", "Pfc.", "LCpl.", "Cpl.", "Sgt.")
	var/syndicate_commando_name = pick(last_names)

	if(donation_trap.Find(ckey(src.key)))
		new_syndicate_commando.gender = pick(MALE,FEMALE)
	else
		new_syndicate_commando.gender = MALE

	var/datum/preferences/A = new()//Randomize appearance for the commando.
	A.randomize_appearance_for(new_syndicate_commando)

	new_syndicate_commando.real_name = "[!syndicate_leader_selected ? syndicate_commando_rank : syndicate_commando_leader_rank] [syndicate_commando_name]"
	new_syndicate_commando.age = !syndicate_leader_selected ? rand(23,35) : rand(35,45)

	new_syndicate_commando.dna.ready_dna(new_syndicate_commando)//Creates DNA.

	//Creates mind stuff.
	new_syndicate_commando.mind_initialize()
	new_syndicate_commando.mind.assigned_role = "MODE"
	new_syndicate_commando.mind.special_role = "Tribunal Ordinator"
	new_syndicate_commando.old_job = "Tribunal Ordinator"
	new_syndicate_commando.job = "Tribunal Ordinator"
	new_syndicate_commando.equip_syndicate_commando(syndicate_leader_selected)
	qdel(spawn_location)
	return new_syndicate_commando

/mob/living/carbon/human/proc/equip_syndicate_commando(syndicate_leader_selected = 0)
	var/radio_freq = COMM_FREQ
	var/obj/item/device/radio/R = new /obj/item/device/radio/headset/tribunal(src)
	R.set_frequency(radio_freq) //Same frequency as the syndicate team in Nuke mode.
	equip_to_slot_or_del(R, slot_l_ear)
	equip_to_slot_or_del(new /obj/item/clothing/under/ordinator(src), slot_w_uniform)
	equip_to_slot_or_del(new /obj/item/clothing/shoes/lw/infantry(src), slot_shoes)
	equip_to_slot_or_del(new /obj/item/shield/generator/wrist(src), slot_wrist_l)
	src.client.color = null
	src.my_stats.change_stat(STAT_ST , 2)
	src.my_stats.change_stat(STAT_DX , 1)
	src.my_stats.change_stat(STAT_HT , 2)
	src.my_stats.change_stat(STAT_IN , 2)
	src.my_skills.change_skill(SKILL_MELEE, rand(13,15))
	src.my_skills.change_skill(SKILL_RANGE, rand(13,15))
	src.my_skills.change_skill(SKILL_CLIMB, rand(12,13))
	src.my_skills.change_skill(SKILL_SURG, 11)
	src.my_skills.change_skill(SKILL_MEDIC, 11)
	var/obj/item/card/id/syndicate/W = new(src) //Untrackable by AI
	W.name = "[real_name]'s ID Card"
	W.icon_state = "id"
	W.access = get_all_accesses()//They get full station access because obviously the syndicate has HAAAX, and can make special IDs for their most elite members.
	W.access += list(access_cent_general, access_cent_specops, access_cent_living, access_cent_storage, access_syndicate)//Let's add their forged CentCom access and syndicate access.
	W.assignment = "Tribunal Ordinator"
	W.registered_name = real_name
	equip_to_slot_or_del(W, slot_wear_id)

	return 1