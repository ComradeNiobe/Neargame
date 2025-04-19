var/fortHand = null

/datum/job/captain
	title = "Baron"
	titlebr = "Barão"
	flag = CAPTAIN
	department_flag = ENGSEC
	stat_mods = list(STAT_ST = 2, STAT_DX = 1, STAT_HT = 1, STAT_IN = 1)
	faction = "Station"
	total_positions = 1
	spawn_positions = 1
	supervisors = "The God King."
	selection_color = "#ccccff"
	idtype = /obj/item/card/id/lord
	access = list(meistery,smith,treasury,esculap,sanctuary,innkeep,merchant,garrison,keep,baronquarter,hump,courtroom,soilery,lifeweb,geschef, marduk, hand_access)
	minimal_access = list(meistery,smith,treasury,esculap,sanctuary,innkeep,merchant,garrison,keep,baronquarter,hump,courtroom,soilery,lifeweb,geschef, marduk, hand_access)
	minimal_player_age = 14
	sex_lock = MALE
	jobdesc = "The most gracious, cunning and handsome ruler of Enochs Gate Hold. At least, that&#8217;s what everyone keeps telling you. And who are they to say otherwise?"
	jobdescbr = "The most gracious, cunning and handsome ruler of Enochs Gate Hold. At least, that&#8217;s what everyone keeps telling you. And who are they to say otherwise?"
	latejoin_locked = TRUE
	minimal_character_age = 40
	thanati_chance = 100
	skill_mods = list(
	list(SKILL_SWORD,0,2),
	list(SKILL_MELEE,2,2),
	list(SKILL_RANGE, 2,2),
	list(SKILL_FARM,0),
	list(SKILL_COOK,1,1),
	list(SKILL_ENGINE,0),
	list(SKILL_SURG,0),
	list(SKILL_MEDIC,0),
	list(SKILL_CLEAN,3,3),
	list(SKILL_CLIMB,8,8),
	list(SKILL_PARTY,1,1),
	list(SKILL_SWIM,2,2),
	list(SKILL_MUSIC, 0),
	list(SKILL_OBSERV, 2,2),
	)
	equip(var/mob/living/carbon/human/H)
		if(!H)
			return 0
		..()
		H.royalty = 1
		H.equip_to_slot_or_del(new /obj/item/device/radio/headset/bracelet/captain(H), slot_wrist_r)
		H.voicetype = "noble"
		H.equip_to_slot_or_del(new /obj/item/clothing/under/rank/captain(H), slot_w_uniform)
		H.equip_to_slot_or_del(new /obj/item/clothing/shoes/lw/nobelshoes(H), slot_shoes)
		H.equip_to_slot_or_del(new /obj/item/clothing/head/caphat(H), slot_head)
		H.equip_to_slot_or_del(new /obj/item/clothing/suit/baron(H), slot_wear_suit)
		H.equip_to_slot_or_del(new /obj/item/daggerssheath(H), slot_wrist_l)
		H.equip_to_slot_or_del(new /obj/item/storage/backpack/lord(H), slot_back)
		H.equip_to_slot_or_del(new /obj/item/sheath/sabre(H), slot_belt)
		H.equip_to_slot_or_del(new /obj/item/shield/generator(H), slot_s_store)
		H.equip_to_slot_or_del(new /obj/item/storage/backpack/coinbag(H), slot_amulet)
		H.equip_to_slot_or_del(new /obj/item/staffoflaw(H), slot_r_hand)
		H.add_perk(/datum/perk/lessstamina)
		H.add_event("nobleblood", /datum/happiness_event/noble_blood)
		H.create_kg()
		if(H.gender == FEMALE)
			to_chat(world, "<span class='baron'>\n † Baroness</span> <span class='bname'>[H.real_name]</span> <span class='baron'> is the woman who rules the Hold of Enoch's Gate. † </span>")
			to_chat(world, "<br>")
		else
			to_chat(world, "<span class='baron'>\n † Baron</span> <span class='bname'>[H.real_name]</span> <span class='baron'> is the man who rules the Hold of Enoch's Gate. † </span>")//asd
			to_chat(world, "<br>")
		//H << sound('sound/music/sherold.ogg', repeat = 0, wait = 0, volume = 12, channel = 3)
		return 1
/*
	get_access()
		return get_all_accesses()
*/

/obj/item/device/baron_device
	name = "ULTIMATE TNC THRONE CONTROLLER"
	icon_state = "Pipboy"
	item_state = "analyzer"
	desc = "A hand-held throne controller."
	flags = FPRINT | TABLEPASS | CONDUCT
	slot_flags = SLOT_BELT
	throwforce = 3
	w_class = 1.0
	throw_speed = 5
	throw_range = 10
	m_amt = 200
	origin_tech = "magnets=1;biotech=1"

/datum/job/hand
	title = "Hand"
	titlebr = "Braço Direito"
	flag = HAND
	department_flag = ENGSEC
	stat_mods = list(STAT_ST = 2, STAT_DX = 1, STAT_HT = 1, STAT_IN = 1)
	faction = "Station"
	total_positions = 1
	spawn_positions = 1
	supervisors = "The God King."
	selection_color = "#ccccff"
	idtype = /obj/item/card/id/gold
	access = list(meistery,smith,treasury,esculap,sanctuary,innkeep,merchant,garrison,keep,baronquarter,hump,courtroom,soilery,lifeweb,geschef, marduk, hand_access)
	minimal_access = list(meistery,smith,treasury,esculap,sanctuary,innkeep,merchant,garrison,keep,baronquarter,hump,courtroom,soilery,lifeweb,geschef, marduk, hand_access)
	minimal_player_age = 14
	sex_lock = MALE
	jobdesc = "A very close friend to the Baron and their most trusted advisor. Your status as Lord Regent gives you near equal power to the Baron himself in their presence, and equal power in their absence. The Hand is expected to make sure the will of the Baron is being executed, and reserves the rare right to lead the garrison forces to do so."
	jobdescbr = "A very close friend to the Baron and their most trusted advisor. Your status as Lord Regent gives you near equal power to the Baron himself in their presence, and equal power in their absence. The Hand is expected to make sure the will of the Baron is being executed, and reserves the rare right to lead the garrison forces to do so."
	latejoin_locked = TRUE
	thanati_chance = 75
	skill_mods = list(
	list(SKILL_SWORD,0,2),
	list(SKILL_MELEE,2,2),
	list(SKILL_RANGE, 2,2),
	list(SKILL_FARM,0),
	list(SKILL_COOK,1,1),
	list(SKILL_ENGINE,0),
	list(SKILL_SURG,0),
	list(SKILL_MEDIC,0),
	list(SKILL_CLEAN,1,1),
	list(SKILL_CLIMB,2,2),
	list(SKILL_PARTY,2,2),
	list(SKILL_SWIM,2,2),
	list(SKILL_MUSIC, 0),
	list(SKILL_OBSERV, 2,2),
	)
	equip(var/mob/living/carbon/human/H)
		if(!H)
			return 0
		..()
		H.royalty = 1
		H.equip_to_slot_or_del(new /obj/item/device/radio/headset/bracelet/captain(H), slot_wrist_r)
		H.voicetype = "noble"
		H.equip_to_slot_or_del(new /obj/item/clothing/under/rank/captain(H), slot_w_uniform)
		H.equip_to_slot_or_del(new /obj/item/clothing/shoes/lw/jackboots(H), slot_shoes)
		H.equip_to_slot_or_del(new /obj/item/clothing/suit/hand(H), slot_wear_suit)
		H.equip_to_slot_or_del(new /obj/item/sheath/sabre(H), slot_belt)
		H.add_perk(/datum/perk/ref/value)
		H.add_perk(/datum/perk/lessstamina)
		H.add_event("nobleblood", /datum/happiness_event/noble_blood)
		fortHand = H
		H.create_kg()
		to_chat(world, "<span class='baron'>† Hand</span> <span class='bname'>[H.real_name]</span> <span class='baron'>is the Baron's hand. † </span>\n")
		//H << sound('sound/music/sherold.ogg', repeat = 0, wait = 0, volume = 12, channel = 3)
		return 1
/*
	get_access()
		return get_all_accesses()
*/
/datum/job/heir
	title = "Heir"
	titlebr = "Herdeiro"
	flag = HEIR
	department_flag = ENGSEC
	stat_mods = list(STAT_ST = 1, STAT_DX = 0, STAT_HT = 0, STAT_IN = 1)
	faction = "Station"
	total_positions = 1
	spawn_positions = 1
	supervisors = "Your father and mother"
	selection_color = "#ddddff"
	idtype = /obj/item/card/id/heir
	minimal_player_age = 10
	latejoin_locked = TRUE
	sex_lock = MALE
	jobdesc = "The heir to the throne of The Gate. You have been taught all your life how to lead, yet still no one seems to take your word seriously. One day, however, it will be expected of you to follow in your father&#8217;s footsteps - for better or worse."
	jobdescbr = "The heir to the throne of The Gate. You have been taught all your life how to lead, yet still no one seems to take your word seriously. One day, however, it will be expected of you to follow in your father&#8217;s footsteps - for better or worse."
	thanati_chance = 75
	access = list(keep,baronquarter)
	minimal_access = list(keep,baronquarter)
	skill_mods = list(
	list(SKILL_SWORD,0,1),
	list(SKILL_MELEE,2,2),
	list(SKILL_RANGE, 1,1),
	list(SKILL_FARM,0),
	list(SKILL_COOK,0),
	list(SKILL_ENGINE,0),
	list(SKILL_SURG,0),
	list(SKILL_MEDIC,0),
	list(SKILL_CLEAN,0),
	list(SKILL_CLIMB,8,8),
	list(SKILL_PARTY,4,4),
	list(SKILL_SWIM,2,2),
	list(SKILL_MUSIC, 0,1),
	list(SKILL_OBSERV, 2,2),
	list(SKILL_UNARM, 0,1),
	)


	equip(var/mob/living/carbon/human/H)
		if(!H)
			return 0
		..()
		if(H.isChild())
			H.equip_to_slot_or_del(new /obj/item/clothing/under/rank/captain/child(H), slot_w_uniform)
			H.royalty = 1
			H.equip_to_slot_or_del(new /obj/item/device/radio/headset/bracelet/captain(H), slot_wrist_r)
			H.equip_to_slot_or_del(new /obj/item/clothing/shoes/lw/child/miner(H), slot_shoes)
			H.voicetype = "noble"
			H.add_event("nobleblood", /datum/happiness_event/noble_blood)
			H.height = rand(130,150)
			return 1
		H.royalty = 1
		H.equip_to_slot_or_del(new /obj/item/device/radio/headset/bracelet/captain(H), slot_wrist_r)
		H.voicetype = "noble"
		H.equip_to_slot_or_del(new /obj/item/clothing/under/rank/captain(H), slot_w_uniform)
		H.equip_to_slot_or_del(new /obj/item/clothing/shoes/lw/jackboots(H), slot_shoes)
		H.add_event("nobleblood", /datum/happiness_event/noble_blood)
		H.create_kg()
		return 1

/datum/job/successor
	title = "Successor"
	titlebr = "Sucessora"
	flag = SUCCESSOR
	
	department_flag = ENGSEC
	stat_mods = list(STAT_ST = -1, STAT_DX = 1, STAT_HT = -1, STAT_IN = 1)
	faction = "Station"
	total_positions = 1
	spawn_positions = 1
	jobdesc = "Your familial relationship is more complicated compared to most. Expected to act with dignity, honor your family, and eventually be wed to a more powerful aristocrat who shall align with your Father&#8217;s house, outside of the limelight you make your own rules."
	jobdescbr = "Your familial relationship is more complicated compared to most. Expected to act with dignity, honor your family, and eventually be wed to a more powerful aristocrat who shall align with your Father&#8217;s house, outside of the limelight you make your own rules."
	supervisors = "Your father and mother"
	selection_color = "#ddddff"
	idtype = /obj/item/card/id/successor
	minimal_player_age = 10
	latejoin_locked = TRUE
	sex_lock = FEMALE
	thanati_chance = 75
	no_trapoc = TRUE
	access = list(keep,baronquarter)
	minimal_access = list(keep,baronquarter)
	skill_mods = list(
	list(SKILL_MELEE,0),
	list(SKILL_RANGE,2,2),
	list(SKILL_FARM,0),
	list(SKILL_COOK,0),
	list(SKILL_ENGINE,0),
	list(SKILL_SURG,0),
	list(SKILL_MEDIC,0),
	list(SKILL_CLEAN,0),
	list(SKILL_CLIMB,1,2),
	list(SKILL_STEAL,0),
	list(SKILL_SWIM,2,3),
	list(SKILL_MUSIC, 5,6),
	list(SKILL_KNIFE,0,3),
	list(SKILL_OBSERV, 2,2),
	)

	equip(var/mob/living/carbon/human/H)
		if(!H)
			return 0
		..()

		if(H.isChild())
			H.royalty = 1
			H.equip_to_slot_or_del(new /obj/item/device/radio/headset/bracelet/captain(H), slot_wrist_r)
			H.equip_to_slot_or_del(new /obj/item/clothing/shoes/lw/child/shoes(H), slot_shoes)
			H.voicetype = "noble"
			H.add_event("nobleblood", /datum/happiness_event/noble_blood)
			H.equip_to_slot_or_del(new /obj/item/clothing/suit/succdress/child(H), slot_wear_suit)
			H.height = rand(130,150)
			return 1

		H.royalty = 1
		H.equip_to_slot_or_del(new /obj/item/device/radio/headset/bracelet/captain(H), slot_wrist_r)
		H.voicetype = "noble"
		H.equip_to_slot_or_del(new /obj/item/clothing/under/common(H), slot_w_uniform)
		H.equip_to_slot_or_del(new /obj/item/clothing/shoes/lw/brown(H), slot_shoes)
		H.equip_to_slot_or_del(new /obj/item/clothing/suit/succdress(H), slot_wear_suit)
		H.add_event("nobleblood", /datum/happiness_event/noble_blood)
		H.create_kg()
		return 1

/datum/job/baroness
	title = "Baroness"
	titlebr = "Baronesa"
	flag = BARONESS
	
	department_flag = ENGSEC
	stat_mods = list(STAT_ST = -1, STAT_DX = 0, STAT_HT = 0, STAT_IN = 2)
	faction = "Station"
	total_positions = 1
	spawn_positions = 1
	supervisors = "Your husband and life."
	selection_color = "#ddddff"
	idtype = /obj/item/card/id/baroness
	minimal_player_age = 10
	latejoin_locked = TRUE
	sex_lock = FEMALE
	thanati_chance = 75
	jobdesc = "The wife of the Baron himself. Your personal life is often carefree and filled with luxury. You&#8217;re fortunate beauty and elegance is a power all men respect. And they respect you."
	minimal_character_age = 30
	jobdescbr = "Você não é apenas o brinquedo de um barão silencioso. Suas mentiras cortam como uma espada e você sabe como controlar as pessoas. Aqueles que o subestimam - o verdadeiro governante da Fortaleza - estão cometendo um erro cruel."
	access = list(treasury,meistery,keep,baronquarter)
	minimal_access = list(treasury,meistery,keep,baronquarter)
	skill_mods = list(
	list(SKILL_MELEE,5,5),
	list(SKILL_RANGE,8,9),
	list(SKILL_FARM,0),
	list(SKILL_COOK,8,9),
	list(SKILL_ENGINE,0),
	list(SKILL_SURG,0),
	list(SKILL_MEDIC,0),
	list(SKILL_CLEAN,8,9),
	list(SKILL_CLIMB,8,8),
	list(SKILL_SWIM,1,2),
	list(SKILL_MUSIC, 2,6),
	list(SKILL_KNIFE,0,2),
	list(SKILL_OBSERV, 8,9),
	)

	equip(var/mob/living/carbon/human/H)
		if(!H)
			return 0
		..()
		H.royalty = 1
		H.voicetype = "noble"
		H.add_event("nobleblood", /datum/happiness_event/noble_blood)
		if(H.gender == MALE)
			H.equip_to_slot_or_del(new /obj/item/device/radio/headset/bracelet/captain(H), slot_wrist_r)
			H.equip_to_slot_or_del(new /obj/item/clothing/under/rank/captain(H), slot_w_uniform)
			H.equip_to_slot_or_del(new /obj/item/clothing/shoes/lw/jackboots(H), slot_shoes)
			H.add_event("nobleblood", /datum/happiness_event/noble_blood)
			H.create_kg()
			return 1
		H.equip_to_slot_or_del(new /obj/item/device/radio/headset/bracelet/captain(H), slot_wrist_r)
		H.equip_to_slot_or_del(new /obj/item/clothing/under/rank/migrant/baroness(H), slot_w_uniform)
		H.equip_to_slot_or_del(new /obj/item/clothing/suit/baronessdress(H), slot_wear_suit)
		H.equip_to_slot_or_del(new /obj/item/clothing/shoes/lw/brown(H), slot_shoes)
		H.equip_to_slot_or_del(new /obj/item/clothing/head/sunhat(H), slot_head)
		H.equip_to_slot_or_del(new /obj/item/clothing/gloves/evening(H), slot_gloves)
		H.equip_to_slot_or_del(new /obj/item/storage/backpack/minisatchelchurch2(H), slot_back)
		if(H.back)
			H.equip_to_slot_or_del(new /obj/item/reagent_containers/glass/bottle/lifeweb/widowtear(H.back), slot_in_backpack)
		H.add_event("nobleblood", /datum/happiness_event/noble_blood)
		H.add_perk(/datum/perk/lessstamina)
		H.create_kg()

		return 1


/datum/job/baronessbguard
	title = "Court Bodyguard"
	titlebr = "Guarda Costas"
	flag = BGUARD
	department_flag = ENGSEC
	stat_mods = list(STAT_ST = 2, STAT_DX = 2, STAT_HT = 1, STAT_IN = 0)
	faction = "Station"
	total_positions = 2
	spawn_positions = 2
	supervisors = "the Baron and the Baroness"
	selection_color = "#ffeeee"
	idtype = /obj/item/card/id/sec
	minimal_player_age = 3
	access = list(garrison,keep)
	minimal_access = list(garrison,keep,baronquarter)
	latejoin_locked = TRUE
	thanati_chance = 1
	jobdesc = "Serving as the noble protectors of The Gates Keep residents, their focus is to protect the local Baron and his family, although he may direct them to guard anyone worthy of his attention. They come from a variety of backgrounds, be it having once been part of the Baroness´ retinue, been employed by the lord´s heir, or even a long standing bodyguard hired by the Lord Baron himself, in his youth. You are bound by an oath to protect your target, and you have no intention of breaking it, ever, under any circumstance."
	skill_mods = list(
	list(SKILL_MELEE,5,6),
	list(SKILL_RANGE,3,3),
	list(SKILL_UNARM,3,3),
	list(SKILL_FARM,0),
	list(SKILL_COOK,0),
	list(SKILL_ENGINE,0),
	list(SKILL_SURG,0),
	list(SKILL_MEDIC,0),
	list(SKILL_CLEAN,0),
	list(SKILL_CLIMB,6,6),
	list(SKILL_SWIM,4,5),
	list(SKILL_OBSERV, 4,4),
	list(SKILL_BOAT, 0),
	)
	equip(var/mob/living/carbon/human/H)
		if(!H)
			return 0
		..()
		H.royalty = 1
		switch(H.client.prefs.BodyguardPref)
			if("Baronness' Protector")
				H.job = "Baronness' Protector"
				if(H.gender == MALE)
					H.age = 70
			if("Successor's Guardian")
				H.job = "Successor's Guardian"
				if(H.gender == MALE)
					H.age = 70
			if("Heir's Warden")
				H.job = "Heir's Warden"
			if("Baron's Retinue")
				H.job = "Baron's Retinue"
				
		H.voicetype = pick("strong","noble","sketchy")
		H.equip_to_slot_or_del(new /obj/item/clothing/under/rank/security(H), slot_w_uniform)
		H.equip_to_slot_or_del(new /obj/item/clothing/shoes/lw/jackboots(H), slot_shoes)
		H.equip_to_slot_or_del(new /obj/item/clothing/suit/armor/vest/security/bodyguard(H), slot_wear_suit)
		H.equip_to_slot_or_del(new /obj/item/device/radio/headset/bracelet/security(H), slot_wrist_r)
		H.equip_to_slot_or_del(new /obj/item/shield/generator/wrist(H), slot_wrist_l)
		H.add_event("nobleblood", /datum/happiness_event/noble_blood)

		H.add_perk(/datum/perk/ref/strongback)
		H.add_perk(/datum/perk/morestamina)
		H.add_perk(/datum/perk/heroiceffort)

		H.terriblethings = TRUE
		H.set_dir(EAST)
		var/swordtype = pick("claymore","sabre","bardiche","spear")
		switch(swordtype)
			if("claymore")
				H.equip_to_slot_or_del(new /obj/item/sheath/claymore(H), slot_belt)
				H.my_skills.change_skill(SKILL_SWORD, 5)
			if("sabre")
				H.equip_to_slot_or_del(new /obj/item/sheath/sabre(H), slot_belt)
				H.my_skills.change_skill(SKILL_SWORD, 5)
			if("bardiche")
				H.equip_to_slot_or_del(new /obj/item/claymore/bardiche(H), slot_l_hand)
				H.my_skills.change_skill(SKILL_STAFF, 5)
			if("spear")
				H.equip_to_slot_or_del(new /obj/item/claymore/spear(H), slot_l_hand)
				H.my_skills.change_skill(SKILL_STAFF, 5)
		H.create_kg()
		return 1

/datum/job/baronessbguard/set_runtime_title(mob/living/carbon/human/H)
	switch(H.client.prefs.BodyguardPref)
		if("Baronness' Protector")
			return "Baronness' Protector"
		if("Successor's Guardian")
			return "Successor's Guardian"
		if("Heir's Swordmaster")
			return "Heir's Warden"
		if("Baron's Retinue")
			return "Baron's Retinue"

/datum/job/maid
	title = "Maid"
	titlebr = "Empregada"
	flag = MAID
	department_flag = ENGSEC
	stat_mods = list(STAT_ST = -1, STAT_DX = 1, STAT_HT = -1, STAT_IN = 0)
	faction = "Station"
	total_positions = 3
	spawn_positions = 3
	supervisors = "The keep"
	selection_color = "#ddddff"
	idtype = /obj/item/card/id/ltgrey
	minimal_player_age = 10
	latejoin_locked = FALSE
	sex_lock = FEMALE
	thanati_chance = 70
	access = list(keep)
	minimal_access = list(keep,baronquarter)
	jobdesc = "You&#8217;re one of those girls who should be quiet and make the lives of your master and mistress easier."
	jobdescbr = "Você é uma daquelas garotas que deveria ficar quieta e tornar a vida de seu mestre e dona mais fácil."
	skill_mods = list(
	list(SKILL_MELEE,0),
	list(SKILL_RANGE,0),
	list(SKILL_FARM,2,3),
	list(SKILL_COOK,3,4),
	list(SKILL_ENGINE,0),
	list(SKILL_SURG,0),
	list(SKILL_MEDIC,0),
	list(SKILL_CLEAN, 5),
	list(SKILL_CLIMB,1,1),
	list(SKILL_STEAL,0),
	list(SKILL_SWIM,0),
	list(SKILL_OBSERV, 2,2),
	)
	equip(var/mob/living/carbon/human/H)
		if(!H)
			return 0
		..()
		H.equip_to_slot_or_del(new /obj/item/device/radio/headset/bracelet/cheap(H), slot_wrist_r)
		H.equip_to_slot_or_del(new /obj/item/clothing/under/common(H), slot_w_uniform)
		H.equip_to_slot_or_del(new /obj/item/clothing/suit/maiddress(H), slot_wear_suit)
		H.equip_to_slot_or_del(new /obj/item/clothing/shoes/lw/boots(H), slot_shoes)
		H.equip_to_slot_or_del(new /obj/item/rag(H), slot_r_store)
		H.add_perk(/datum/perk/lessstamina)
		H.create_kg()
		return 1

/datum/job/guest
	title = "Guest"
	titlebr = "Convidado"
	flag = GUEST
	department_flag = MEDSCI
	stat_mods = list(STAT_ST = 1, STAT_DX = 0, STAT_HT = 0, STAT_IN = 1)
	faction = "Station"
	total_positions = 1
	spawn_positions = 1
	supervisors = "The keep"
	selection_color = "#ddddff"
	idtype = /obj/item/card/id/ltgrey
	minimal_player_age = 10
	latejoin_locked = FALSE
	thanati_chance = 80
	access = list(keep)
	minimal_access = list(keep, baronquarter)
	jobdesc = "The Baron&#8217;s friend, a noble staying temporarily in Enoch&#8217;s Gate. Hopefully their stay is not extended indefinitely."
	skill_mods = list(
	list(SKILL_MELEE,2,2),
	list(SKILL_RANGE, 2,2),
	list(SKILL_FARM,0),
	list(SKILL_COOK,0),
	list(SKILL_ENGINE,0),
	list(SKILL_SURG,0,1),
	list(SKILL_MEDIC,0),
	list(SKILL_CLEAN,1,1),
	list(SKILL_CLIMB,2,2),
	list(SKILL_PARTY,3,4),
	list(SKILL_SWIM,1,2),
	list(SKILL_MUSIC, 0),
	list(SKILL_OBSERV, 2,2),
	)

	equip(var/mob/living/carbon/human/H)
		if(!H)
			return 0
		..()
		H.equip_to_slot_or_del(new /obj/item/device/radio/headset/bracelet(H), slot_wrist_r)
		H.voicetype = "noble"
		H.equip_to_slot_or_del(new /obj/item/clothing/under/rank/captain(H), slot_w_uniform)
		H.add_event("nobleblood", /datum/happiness_event/noble_blood)
		H.equip_to_slot_or_del(new /obj/item/sheath/sabre(H), slot_belt)
		H.equip_to_slot_or_del(new /obj/item/clothing/suit/storage/guest(H), slot_wear_suit)
		H.equip_to_slot_or_del(new /obj/item/clothing/shoes/lw/boots(H), slot_shoes)
		H.equip_to_slot_or_del(new /obj/item/storage/backpack/coinbag/guest(H), slot_amulet)
		H.create_kg()
		return 1
/*
/datum/job/servant
	title = "Servant"
	flag = SERVANT
	department_flag = OFFICER
	faction = "Station"
	total_positions = 3
	spawn_positions = 3
	supervisors = "the Baron and everyone"
	selection_color = "#ddddff"
	minimal_player_age = 10
	idtype = /obj/item/card/id/ltgrey
	access = list()
	minimal_access = list()

	equip(var/mob/living/carbon/human/H)
		if(!H)
			return 0
		..()
		H.set_species("Child")
		H.equip_to_slot_or_del(new /obj/item/clothing/under/child_jumpsuit(H), slot_w_uniform)
		H.equip_to_slot_or_del(new /obj/item/clothing/shoes/lw/child/shoes(H), slot_shoes)
		return 1
*/

/datum/job/Servant
	title = "Servant"
	titlebr = "Servo"
	flag = SERVANT
	department_flag = CIVILIAN
	stat_mods = list(STAT_ST = -3, STAT_DX = 2, STAT_HT = -3, STAT_IN = 0)
	faction = "Station"
	total_positions = 3
	spawn_positions = 3
	supervisors = "Everyone"
	selection_color = "#ddddff"
	idtype = /obj/item/card/id/other
	minimal_player_age = 10
	latejoin_locked = FALSE
	access = list(keep)
	minimal_access = list(keep)
	children = TRUE
	jobdesc = "One of the personal child servants of the Baron. They&#8217;re extremely nifty at getting into the small crevices maids just can&#8217;t reach and are excellent cleaners! Or so you&#8217;ve been told."
	jobdescbr = "Pequeno servo. Brinque e divirta-se até que alguém o force a lavar o chão."
	skill_mods = list(
	list(SKILL_MELEE,0),
	list(SKILL_RANGE,0),
	list(SKILL_FARM,2,2),
	list(SKILL_COOK,3,3),
	list(SKILL_ENGINE,0),
	list(SKILL_SURG,0),
	list(SKILL_MEDIC,0),
	list(SKILL_CLEAN,3,3),
	list(SKILL_CLIMB,4,4),
	list(SKILL_SWIM,0),
	list(SKILL_OBSERV, 2,2),
	)
	equip(var/mob/living/carbon/human/H)
		if(!H)
			return 0
		..()
		H.set_species("Child")
		H.equip_to_slot_or_del(new /obj/item/device/radio/headset/bracelet/cheap(H), slot_wrist_r)
		H.equip_to_slot_or_del(new /obj/item/clothing/under/child_jumpsuit(H), slot_w_uniform)
		H.equip_to_slot_or_del(new /obj/item/clothing/shoes/lw/child/miner(H), slot_shoes)
		H.equip_to_slot_or_del(new /obj/item/rag(H), slot_r_store)
		H.vice = null
		H.religion = "Gray Church"
		H.create_kg()
		return 1

/datum/job/meister
	title = "Meister"
	titlebr = "Meister"
	flag = HOP
	department_flag = CIVILIAN
	stat_mods = list(STAT_ST = 0, STAT_DX = -2, STAT_HT = -1, STAT_IN = 6)
	faction = "Station"
	total_positions = 1
	spawn_positions = 1
	jobdesc = "The archivist and advisor to the Baron. Meisters lack a familial background or political allegiance. Hailing from an egalitarian order located in Gahan, they are assigned to the fiefdoms of aristocrats, bound by vows to serve its sovereign. They are often considered to be the most intelligent and well-read people around, with a vast area of knowledge carefully crafted to suit the needs of their Lord."
	jobdescbr = "The archivist and advisor to the Baron. Meisters lack a familial background or political allegiance. Hailing from an egalitarian order located in Gahan, they are assigned to the fiefdoms of aristocrats, bound by vows to serve its sovereign. They are often considered to be the most intelligent and well-read people around, with a vast area of knowledge carefully crafted to suit the needs of their Lord."
	supervisors = "the Baron"
	selection_color = "#ddddff"
	idtype = /obj/item/card/id/hop
	minimal_character_age = 70
	minimal_player_age = 10
	//sex_lock = MALE
	thanati_chance = 25
	latejoin_locked = TRUE
	access = list(keep,meistery,treasury)
	minimal_access = list(keep,meistery,treasury)
	skill_mods = list(
	list(SKILL_MELEE,1,1),
	list(SKILL_RANGE, 2,2),
	list(SKILL_FARM,0),
	list(SKILL_COOK,0),
	list(SKILL_ENGINE,0),
	list(SKILL_SURG,0),
	list(SKILL_MEDIC,0),
	list(SKILL_CLEAN,0),
	list(SKILL_CLIMB,6,6),
	list(SKILL_PARTY,0),
	list(SKILL_SWIM,1,1),
	list(SKILL_MUSIC, 0),
	list(SKILL_OBSERV, 1,1),
	list(SKILL_ALCH, 5,7),
	)

	equip(var/mob/living/carbon/human/H)
		if(!H)
			return 0
		..()
		H.royalty = 1
		H.voicetype = "noble"
		H.equip_to_slot_or_del(new /obj/item/clothing/head/ushanka/soviet(H), slot_head)
		H.equip_to_slot_or_del(new /obj/item/device/radio/headset/bracelet/captain(H), slot_wrist_r)
		H.equip_to_slot_or_del(new /obj/item/clothing/under/common(H), slot_w_uniform)
		H.equip_to_slot_or_del(new /obj/item/clothing/shoes/lw/brown(H), slot_shoes)
		H.equip_to_slot_or_del(new /obj/item/clothing/suit/meister(H), slot_wear_suit)
		H.equip_to_slot_or_del(new /obj/item/clothing/glasses/monocle(H), slot_glasses)
		H.add_event("nobleblood", /datum/happiness_event/noble_blood)
		H.add_perk(/datum/perk/ancitech)
		H.add_perk(/datum/perk/lessstamina)
		H.add_perk(/datum/perk/ref/value)
		H.create_kg()
		return 1

/datum/job/meisterdisciple
	title = "Treasurer"
	titlebr = "Tesoureiro"
	flag = MEISTERDISC
	department_flag = ENGSEC
	stat_mods = list(STAT_ST = -3, STAT_DX = 0, STAT_HT = -3, STAT_IN = 2)
	faction = "Station"
	total_positions = 1
	spawn_positions = 1
	supervisors = "the Meister."
	selection_color = "#ddddff"
	thanati_chance = 80
	jobdesc = "Tasked with handling all aspects of financial management within Enoch&#8217;s Gate Hold, their ceremonial gilded cuirass is given to them as a signifier of their importance, and to emphasize the wealth of the Baron himself."
	jobdescbr = "Tasked with handling all aspects of financial management within Enoch&#8217;s Gate Hold, their ceremonial gilded cuirass is given to them as a signifier of their importance, and to emphasize the wealth of the Baron himself."
	latejoin_locked = TRUE
	idtype = /obj/item/card/id/ltgrey
	access = list(keep,meistery,treasury)
	minimal_access = list(keep,meistery,treasury)

	equip(var/mob/living/carbon/human/H)
		if(!H)
			return 0
		..()
		if(H.isChild())
			H.equip_to_slot_or_del(new /obj/item/clothing/under/child_jumpsuit(H), slot_w_uniform)
			H.equip_to_slot_or_del(new /obj/item/clothing/head/ushanka(H), slot_head)
			H.equip_to_slot_or_del(new /obj/item/clothing/shoes/lw/child/miner(H), slot_shoes)
			H.equip_to_slot_or_del(new /obj/item/clothing/suit/disciple(H), slot_wear_suit)
			H.equip_to_slot_or_del(new /obj/item/device/radio/headset/bracelet/captain(H), slot_wrist_r)
			H.height = rand(130,150)
			H.job = "Meister Disciple"
			H.old_job = "Meister Disciple"
			H.add_perk(/datum/perk/ancitech)
			H.create_kg()
			return 1
		H.equip_to_slot_or_del(new /obj/item/clothing/under/common(H), slot_w_uniform)
		H.equip_to_slot_or_del(new /obj/item/clothing/shoes/lw/brown(H), slot_shoes)
		H.equip_to_slot_or_del(new /obj/item/clothing/suit/armor/vest/gold_breastplate(H), slot_wear_suit)
		H.equip_to_slot_or_del(new /obj/item/daggerssheath/iron(H), slot_wrist_l)
		H.equip_to_slot_or_del(new /obj/item/device/radio/headset/bracelet/captain(H), slot_wrist_r)
		H.add_perk(/datum/perk/ancitech)
		H.create_kg()
		return 1
