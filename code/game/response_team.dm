//STRIKE TEAMS
//Thanks to Kilakk for the admin-button portion of this code.

var/list/response_team_members = list()
var/global/send_emergency_team = 0 // Used for automagic response teams
                                   // 'admin_emergency_team' for admin-spawned response teams
var/ert_base_chance = 10 // Default base chance. Will be incremented by increment ERT chance.
var/can_call_ert

/*
client/verb/JoinResponseTeam()
	set category = "IC"

	if(istype(usr,/mob/dead/observer) || istype(usr,/mob/new_player))
		if(!send_emergency_team)
			usr << "No emergency response team is currently being sent."
			return
	/*	if(admin_emergency_team)
			usr << "An emergency response team has already been sent."
			return */
		if(jobban_isbanned(usr, "Syndicate") || jobban_isbanned(usr, "Emergency Response Team") || jobban_isbanned(usr, "Security Officer"))
			usr << "<font color=red><b>You are jobbanned from the emergency reponse team!"
			return

		if(response_team_members.len > 5) usr << "The emergency response team is already full!"


		for (var/obj/effect/landmark/L in landmarks_list) if (L.name == "Commando")
			L.name = null//Reserving the place.
			var/new_name = input(usr, "Pick a name","Name") as null|text
			if(!new_name)//Somebody changed his mind, place is available again.
				L.name = "Commando"
				return
			var/leader_selected = isemptylist(response_team_members)
			var/mob/living/carbon/human/new_commando = create_response_team(L.loc, leader_selected, new_name)
			qdel(L)
			new_commando.mind.key = usr.key
			new_commando.key = usr.key

			new_commando << "\blue You are [!leader_selected?"a member":"the <B>LEADER</B>"] of an Emergency Response Team, a type of military division, under CentComm's service. There is a code red alert on [vessel_name()], you are tasked to go and fix the problem."
			new_commando << "<b>You should first gear up and discuss a plan with your team. More members may be joining, don't move out before you're ready."
			if(!leader_selected)
				new_commando << "<b>As member of the Emergency Response Team, you answer only to your leader and CentComm officials.</b>"
			else
				new_commando << "<b>As leader of the Emergency Response Team, you answer only to CentComm, and have authority to override the Captain where it is necessary to achieve your mission goals. It is recommended that you attempt to cooperate with the captain where possible, however."
			return

	else
		usr << "You need to be an observer or new player to use this."
*/
// returns a number of dead players in %
proc/percentage_dead()
	var/total = 0
	var/deadcount = 0
	for(var/mob/living/carbon/human/H in mob_list)
		if(H.client) // Monkeys and mice don't have a client, amirite?
			if(H.stat == 2) deadcount++
			total++

	if(total == 0) return 0
	else return round(100 * deadcount / total)

// Increments the ERT chance automatically, so that the later it is in the round,
// the more likely an ERT is to be able to be called.
proc/increment_ert_chance()
	while(send_emergency_team == 0) // There is no ERT at the time.
		if(get_security_level() == "green")
			ert_base_chance += 1
		if(get_security_level() == "blue")
			ert_base_chance += 2
		if(get_security_level() == "red")
			ert_base_chance += 3
		if(get_security_level() == "delta")
			ert_base_chance += 10           // Need those big guns
		sleep(600 * 3) // Minute * Number of Minutes


/client/proc/create_response_team(obj/spawn_location, leader_selected = 0, commando_name)

	//usr << "\red ERT has been temporarily disabled. Talk to a coder."
	//return

	var/mob/living/carbon/human/M = new(null)
	response_team_members |= M

	//todo: god damn this.
	//make it a panel, like in character creation
	var/new_facial = input("Please select facial hair color.", "Character Generation") as color
	if(new_facial)
		M.r_facial = hex2num(copytext(new_facial, 2, 4))
		M.g_facial = hex2num(copytext(new_facial, 4, 6))
		M.b_facial = hex2num(copytext(new_facial, 6, 8))

	var/new_hair = input("Please select hair color.", "Character Generation") as color
	if(new_facial)
		M.r_hair = hex2num(copytext(new_hair, 2, 4))
		M.g_hair = hex2num(copytext(new_hair, 4, 6))
		M.b_hair = hex2num(copytext(new_hair, 6, 8))

	var/new_eyes = input("Please select eye color.", "Character Generation") as color
	if(new_eyes)
		M.r_eyes = hex2num(copytext(new_eyes, 2, 4))
		M.g_eyes = hex2num(copytext(new_eyes, 4, 6))
		M.b_eyes = hex2num(copytext(new_eyes, 6, 8))

	var/new_tone = input("Please select skin tone level: 1-255 (1=albino, 35=caucasian, 150=black, 255='very' black)", "Character Generation")  as text

	if (!new_tone)
		new_tone = 35
	M.s_tone = max(min(round(text2num(new_tone)), 150), 1)
	M.s_tone =  -M.s_tone + 35

	// hair
	var/list/all_hairs = typesof(/datum/sprite_accessory/hair) - /datum/sprite_accessory/hair
	var/list/hairs = list()

	// loop through potential hairs
	for(var/x in all_hairs)
		var/datum/sprite_accessory/hair/H = new x // create new hair datum based on type x
		hairs.Add(H.name) // add hair name to hairs
		qdel(H) // delete the hair after it's all done

//	var/new_style = input("Please select hair style", "Character Generation")  as null|anything in hairs
//hair
	var/new_hstyle = input(usr, "Select a hair style", "Grooming")  as null|anything in hair_styles_list
	if(new_hstyle)
		M.h_style = new_hstyle

	// facial hair
	var/new_fstyle = input(usr, "Select a facial hair style", "Grooming")  as null|anything in facial_hair_styles_list
	if(new_fstyle)
		M.f_style = new_fstyle

	// if new style selected (not cancel)
/*	if (new_style)
		M.h_style = new_style

		for(var/x in all_hairs) // loop through all_hairs again. Might be slightly CPU expensive, but not significantly.
			var/datum/sprite_accessory/hair/H = new x // create new hair datum
			if(H.name == new_style)
				M.h_style = H // assign the hair_style variable a new hair datum
				break
			else
				qdel(H) // if hair H not used, delete. BYOND can garbage collect, but better safe than sorry

	// facial hair
	var/list/all_fhairs = typesof(/datum/sprite_accessory/facial_hair) - /datum/sprite_accessory/facial_hair
	var/list/fhairs = list()

	for(var/x in all_fhairs)
		var/datum/sprite_accessory/facial_hair/H = new x
		fhairs.Add(H.name)
		qdel(H)

	new_style = input("Please select facial style", "Character Generation")  as null|anything in fhairs

	if(new_style)
		M.f_style = new_style
		for(var/x in all_fhairs)
			var/datum/sprite_accessory/facial_hair/H = new x
			if(H.name == new_style)
				M.f_style = H
				break
			else
				qdel(H)
*/
	var/new_gender = alert(usr, "Please select gender.", "Character Generation", "Male", "Female")
	if (new_gender)
		if(new_gender == "Male")
			M.gender = MALE
		else
			M.gender = FEMALE
	//M.rebuild_appearance()
	M.update_hair()
	M.update_body()
	M.check_dna(M)

	M.real_name = commando_name
	M.name = commando_name
	M.age = !leader_selected ? rand(23,35) : rand(35,45)

	M.dna.ready_dna(M)//Creates DNA.

	//Creates mind stuff.
	M.mind = new
	M.mind.current = M
	M.mind.original = M
	M.mind.assigned_role = "MODE"
	M.mind.special_role = "Response Team"
	if(!(M.mind in ticker.minds))
		ticker.minds += M.mind//Adds them to regular mind list.
	M.loc = spawn_location
	M.equip_strike_team(leader_selected)
	return M

/mob/living/carbon/human/proc/equip_strike_team(leader_selected = 0)

	//Special radio setup
	equip_to_slot_or_del(new /obj/item/device/radio/headset/ert(src), slot_l_ear)

	//Replaced with new ERT uniform
	equip_to_slot_or_del(new /obj/item/clothing/under/rank/centcom_officer(src), slot_w_uniform)
	equip_to_slot_or_del(new /obj/item/clothing/shoes/lw/swat(src), slot_shoes)
	equip_to_slot_or_del(new /obj/item/clothing/glasses/sunglasses(src), slot_glasses)
	equip_to_slot_or_del(new /obj/item/storage/backpack/satchel(src), slot_back)
/*

	//Old ERT Uniform
	//Basic Uniform
	equip_to_slot_or_del(new /obj/item/clothing/under/syndicate/tacticool(src), slot_w_uniform)
	equip_to_slot_or_del(new /obj/item/device/flashlight(src), slot_l_store)
	equip_to_slot_or_del(new /obj/item/clipboard(src), slot_r_store)
	equip_to_slot_or_del(new /obj/item/gun/energy/gun(src), slot_belt)
	equip_to_slot_or_del(new /obj/item/clothing/mask/gas/swat(src), slot_wear_mask)

	//Glasses
	equip_to_slot_or_del(new /obj/item/clothing/glasses/sunglasses/sechud(src), slot_glasses)

	//Shoes & gloves
	equip_to_slot_or_del(new /obj/item/clothing/shoes/lw/swat(src), slot_shoes)
	equip_to_slot_or_del(new /obj/item/clothing/gloves/swat(src), slot_gloves)

	//Removed
//	equip_to_slot_or_del(new /obj/item/clothing/suit/armor/swat(src), slot_wear_suit)
//	equip_to_slot_or_del(new /obj/item/clothing/head/helmet/space/deathsquad(src), slot_head)

	//Backpack
	equip_to_slot_or_del(new /obj/item/storage/backpack/security(src), slot_back)
	equip_to_slot_or_del(new /obj/item/storage/box/engineer(src), slot_in_backpack)
	equip_to_slot_or_del(new /obj/item/storage/firstaid/regular(src), slot_in_backpack)
*/
	var/obj/item/card/id/W = new(src)
	W.assignment = "Emergency Response Team[leader_selected ? " Leader" : ""]"
	W.registered_name = real_name
	W.name = "[real_name]'s ID Card ([W.assignment])"
	W.icon_state = "centcom"
	W.access = get_all_accesses()
	W.access += get_all_centcom_access()
	equip_to_slot_or_del(W, slot_wear_id)

	return 1

//debug verb (That is horribly coded, LEAVE THIS OFF UNLESS PRIVATELY TESTING. Seriously.
/*client/verb/ResponseTeam()
	set category = "Admin"
	if(!send_emergency_team)
		send_emergency_team = 1*/