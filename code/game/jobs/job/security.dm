/datum/job/ordinator
	title = "Kraken"
	titlebr = "Kraken"
	flag = HOS
	department_flag = ENGSEC
	faction = "Station"
	stat_mods = list(STAT_ST = 8, STAT_DX = 3, STAT_HT = 6, STAT_IN = 2)
	total_positions = 1
	spawn_positions = 1
	supervisors = "The Baron."
	selection_color = "#ccccff"
	idtype = /obj/item/card/id/hos
	access = list(meistery,sanctuary,garrison,keep,hump,courtroom,soilery,lifeweb, baronquarter, marduk, innkeep, hand_access)
	minimal_access = list(meistery,sanctuary,garrison,keep,hump,courtroom,soilery,lifeweb, baronquarter, marduk, innkeep, hand_access)
	minimal_player_age = 14
	latejoin_locked = TRUE
	jobdesc = "Champion of Enoch´s Gate, Captain of the Triton Guard, a near-inhumanly strong warrior, the Kraken is one of the most horrifying men one will ever face in battle. His formidable skills are recognized throughout the Southern provinces. He is sometimes sent to take part in hastilude and martial games among more wealthy nobility, representing his lord and fort. Many more influential and wealthier nobles have offered this veteran a seat among their mighty men, but his loyalty towards his Lord is undying."
	sex_lock = MALE
	money = 66
	thanati_chance = 1
	skill_mods = list(
	list(SKILL_RANGE,5,5),
	list(SKILL_FARM,0),
	list(SKILL_COOK,0),
	list(SKILL_ENGINE,0),
	list(SKILL_SURG,2,2),
	list(SKILL_CLIMB, 6),
	list(SKILL_MEDIC,2,2),
	list(SKILL_CLEAN,0),
	list(SKILL_SWIM,4,5),
	list(SKILL_OBSERV, 6,6),
	list(SKILL_BOAT, 0),
	)
	equip(var/mob/living/carbon/human/H)
		if(!H)
			return 0
		..()
		H.voicetype = "strong"
		H.height = rand(210,240)
		H.equip_to_slot_or_del(new /obj/item/clothing/under/rank/security/triton(H), slot_w_uniform)
		H.equip_to_slot_or_del(new /obj/item/clothing/suit/armor/vest/security/marduk(H), slot_wear_suit)
		H.equip_to_slot_or_del(new /obj/item/clothing/head/helmet/sechelm/veteran(H), slot_r_hand)
		H.equip_to_slot_or_del(new /obj/item/clothing/gloves/kraken(H), slot_gloves)
		H.equip_to_slot_or_del(new /obj/item/clothing/shoes/lw/jackboots/triton(H), slot_shoes)
		H.set_dir(NORTH)
		H.equip_to_slot_or_del(new /obj/item/device/radio/headset/bracelet/security/censor(H), slot_wrist_r)
		H.equip_to_slot_or_del(new /obj/item/combatsheath/Censor(H), slot_wrist_l)
		H.equip_to_slot_or_del(new /obj/item/gun/energy/taser/leet/sparq(H), slot_belt)
		if(prob(60))
			H.virgin = FALSE
		H.add_perk(/datum/perk/ref/strongback)
		H.terriblethings = TRUE
		H.add_perk(/datum/perk/heroiceffort)
		H.add_perk(/datum/perk/morestamina)
		H.my_skills.change_skill(SKILL_MELEE,rand(8,8))
		if(prob(5))
			H.my_skills.change_skill(SKILL_MELEE,10)
		var/weaponSpecs = rand(0,2)
		switch(weaponSpecs)
			if(0)
				H.my_skills.change_skill(SKILL_SWORD,rand(0,3))
				H.my_skills.change_skill(SKILL_KNIFE,rand(0,3))
			if(1)
				H.my_skills.change_skill(SKILL_SWORD,rand(0,3))
				H.my_skills.change_skill(SKILL_STAFF,rand(0,3))
			if(2)
				H.my_skills.change_skill(SKILL_STAFF,rand(0,3))
				H.my_skills.change_skill(SKILL_SWING,rand(0,3))
		H.create_kg()
		return 1

/datum/job/enforcer
	title = "Triton"
	titlebr = "Triton"
	flag = OFFICER
	department_flag = ENGSEC
	faction = "Station"
	stat_mods = list(STAT_ST = 3, STAT_DX = 0, STAT_HT = 4, STAT_IN = 0)
	total_positions = 5
	spawn_positions = 5
	supervisors = "the Baron and the Marduk"
	selection_color = "#ffeeee"
	idtype = /obj/item/card/id/sec
	access = list(garrison,keep,courtroom)
	minimal_access = list(garrison,keep,courtroom)
	minimal_player_age = 3
	sex_lock = MALE
	money = 25
	jobdesc = " Members of The Gate´s Triton Guard, Tritons are the personal guard of the Baron. Skilled in combat, their main priority is to protect their Lord, his family, and enforce his will. So long as they´re being paid, that is."	
	latejoin_locked = TRUE
	thanati_chance = 1
	skill_mods = list(
	list(SKILL_MELEE,5,5),
	list(SKILL_RANGE,4,4),
	list(SKILL_UNARM,0,3),
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
		H.voicetype = "strong"
		H.add_perk(/datum/perk/ref/strongback)
		H.add_perk(/datum/perk/heroiceffort)
		H.add_perk(/datum/perk/morestamina)
		if(prob(50))
			H.virgin = FALSE
		H.equip_to_slot_or_del(new /obj/item/daggerssheath/iron(H), slot_wrist_l)
		H.terriblethings = TRUE
		if(access_pigplus?.Find(ckey(H?.client?.key)))
			H.equip_to_slot_or_del(new /obj/item/clothing/under/rank/security(H), slot_w_uniform)
			H.equip_to_slot_or_del(new /obj/item/clothing/shoes/lw/jackboots/triton(H), slot_shoes)
			H.set_dir(NORTH)
			H.equip_to_slot_or_del(new /obj/item/clothing/head/helmet/sechelm(H), slot_r_hand)
			H.equip_to_slot_or_del(new /obj/item/clothing/gloves/triton(H), slot_gloves)
			H.equip_to_slot_or_del(new /obj/item/clothing/under/rank/security/triton(H), slot_wear_suit)
			H.equip_to_slot_or_del(new /obj/item/device/radio/headset/bracelet/security(H), slot_wrist_r)
			H.equip_to_slot_or_del(new /obj/item/gun/energy/taser/leet/sparq(H), slot_belt)
			H.my_skills.change_skill(SKILL_MELEE, 5)
			H.my_skills.change_skill(SKILL_RANGE, 4)
		else if(access_comrade?.Find(ckey(H?.client?.key)))
			H.equip_to_slot_or_del(new /obj/item/clothing/shoes/lw/jackboots/triton(H), slot_shoes)
			H.set_dir(NORTH)
			H.equip_to_slot_or_del(new /obj/item/clothing/head/helmet/sechelm/trusted(H), slot_r_hand)
			H.equip_to_slot_or_del(new /obj/item/clothing/under/rank/security/triton(H), slot_w_uniform)
			H.equip_to_slot_or_del(new /obj/item/clothing/gloves/triton(H), slot_gloves)
			H.equip_to_slot_or_del(new /obj/item/clothing/suit/armor/vest/security/comrade(H), slot_wear_suit)
			H.equip_to_slot_or_del(new /obj/item/device/radio/headset/bracelet/security(H), slot_wrist_r)
			H.equip_to_slot_or_del(new /obj/item/gun/energy/taser/leet/sparq(H), slot_belt)
			H.my_skills.change_skill(SKILL_MELEE, 5)
			H.my_skills.change_skill(SKILL_RANGE, 4)
		else if(access_villain?.Find(ckey(H?.client?.key)))
			H.equip_to_slot_or_del(new /obj/item/clothing/shoes/lw/jackboots/triton(H), slot_shoes)
			H.equip_to_slot_or_del(new /obj/item/clothing/under/rank/security(H), slot_w_uniform)
			H.set_dir(NORTH)
			H.equip_to_slot_or_del(new /obj/item/clothing/head/helmet/sechelm/trusted(H), slot_r_hand)
			H.equip_to_slot_or_del(new /obj/item/clothing/gloves/triton(H), slot_gloves)
			H.equip_to_slot_or_del(new /obj/item/clothing/suit/armor/vest/security/villain(H), slot_wear_suit)
			H.equip_to_slot_or_del(new /obj/item/clothing/under/rank/security/triton(H), slot_wrist_r)
			H.equip_to_slot_or_del(new /obj/item/gun/energy/taser/leet/sparq(H), slot_belt)
			H.my_skills.change_skill(SKILL_MELEE, 5)
			H.my_skills.change_skill(SKILL_RANGE, 4)
		else
			H.equip_to_slot_or_del(new /obj/item/clothing/under/rank/security/triton(H), slot_w_uniform)
			H.equip_to_slot_or_del(new /obj/item/clothing/shoes/lw/jackboots(H), slot_shoes)
			H.set_dir(NORTH)
			H.equip_to_slot_or_del(new /obj/item/clothing/head/helmet/sechelm(H), slot_r_hand)
			H.equip_to_slot_or_del(new /obj/item/clothing/gloves/triton(H), slot_gloves)
			H.equip_to_slot_or_del(new /obj/item/clothing/suit/armor/vest/security(H), slot_wear_suit) //H.equip_to_slot_or_del(new /obj/item/clothing/suit/armor/vest/iron_cuirass(H), slot_wear_suit)
			H.equip_to_slot_or_del(new /obj/item/device/radio/headset/bracelet/security(H), slot_wrist_r)
			H.equip_to_slot_or_del(new /obj/item/gun/energy/taser/leet/sparq(H), slot_belt)
			H.my_skills.change_skill(SKILL_MELEE, rand(3,4))
			H.my_skills.change_skill(SKILL_RANGE, rand(3,4))
			H.my_stats.change_stat(STAT_ST , -2)
			H.my_stats.change_stat(STAT_HT , -3)
			H.my_stats.change_stat(STAT_DX , 0)
			H.my_stats.change_stat(STAT_IN , 0)
		

		var/weaponSpecs = rand(0,2)
		switch(weaponSpecs)
			if(0)
				H.my_skills.change_skill(SKILL_SWORD,rand(0,3))
				H.my_skills.change_skill(SKILL_KNIFE,rand(0,3))
			if(1)
				H.my_skills.change_skill(SKILL_SWORD,rand(0,3))
				H.my_skills.change_skill(SKILL_STAFF,rand(0,3))
			if(2)
				H.my_skills.change_skill(SKILL_STAFF,rand(0,3))
				H.my_skills.change_skill(SKILL_SWING,rand(0,3))
		H.create_kg()
		return 1

/datum/job/sheriff
	title = "Sheriff"
	titlebr = "Xerife"
	flag = SHERIFF
	department_flag = ENGSEC
	faction = "Station"
	stat_mods = list(STAT_ST = 1, STAT_DX = 0, STAT_HT = 0, STAT_IN = 0)
	total_positions = 1
	spawn_positions = 1
	supervisors = "the Baron and the Marduk"
	selection_color = "#ffeeee"
	idtype = /obj/item/card/id/other
	access = list(garrison,keep,courtroom)
	minimal_access = list(garrison,keep,courtroom)
	minimal_player_age = 3
	jobdesc = "Serving as both the village´s watchman and lawman, you are the first person to know of any impending threat to Enoch´s Gate. You once used to patrol the caves, watching the migrants roll into what later became the village. Now? You are redelegated to following the Magistrate´s orders and enforcing a semblance of law in the Village. Maybe one day you might end up getting promoted to the guard, but until that comes, you atleast have a comfortable office."
	sex_lock = MALE
	money = 25
	latejoin_locked = TRUE
	thanati_chance = 10
	skill_mods = list(
	list(SKILL_MELEE,2,2),
	list(SKILL_RANGE,7,10),
	list(SKILL_UNARM,1,2),
	list(SKILL_FARM,0),
	list(SKILL_COOK,2,2),
	list(SKILL_ENGINE,0),
	list(SKILL_SURG,2,2),
	list(SKILL_MEDIC,3,3),
	list(SKILL_CLEAN,0),
	list(SKILL_CLIMB,5,5),
	list(SKILL_SWIM,5,5),
	list(SKILL_OBSERV, 4,5),
	list(SKILL_BOAT, 0),
	)
	equip(var/mob/living/carbon/human/H)
		if(!H)
			return 0
		..()
		H.voicetype = "sketchy"
		H.outsider = TRUE
		H.equip_to_slot_or_del(new /obj/item/clothing/under/rank/security(H), slot_w_uniform)
		H.equip_to_slot_or_del(new /obj/item/clothing/suit/storage/vest/sheriff(H), slot_wear_suit)
		H.equip_to_slot_or_del(new /obj/item/clothing/head/tricorn(H), slot_head)
		H.equip_to_slot_or_del(new /obj/item/clothing/shoes/lw/bastard(H), slot_shoes)
		H.equip_to_slot_or_del(new /obj/item/device/radio/headset/bracelet/security(H), slot_wrist_r)
		H.terriblethings = TRUE
		H.add_perk(/datum/perk/morestamina)
		if(prob(30))
			H.virgin = FALSE
		H.create_kg()
		//H << sound('sound/music/sherold.ogg', repeat = 0, wait = 0, volume = 12, channel = 3)
		return 1

/datum/job/squire
	title = "Squire"
	titlebr = "Escudeiro"
	flag = SQUIRE
	department_flag = ENGSEC
	faction = "Station"
	stat_mods = list(STAT_ST = -1, STAT_DX = 0, STAT_HT = -2, STAT_IN = -1)
	total_positions = 4
	spawn_positions = 4
	supervisors = "the Cerberii"
	selection_color = "#ddddff"
	minimal_player_age = 10
	idtype = /obj/item/card/id/other
	access = list(garrison,keep)
	minimal_access = list(garrison,keep)
	sex_lock = MALE
	money = 5
	jobdesc = "Still young, squires have yet to earn the right to call themselves Tritons. Serve your master well. Fit his armor, sharpen his blade, and he shall teach you how to become a man. And one day you too shall have the honor of serving directly under the Lord himself among your brothers. It is an honor to all young men."
	latejoin_locked = FALSE
	skill_mods = list(
	list(SKILL_MELEE,2,2),
	list(SKILL_RANGE,2,2),
	list(SKILL_FARM,0),
	list(SKILL_COOK,0),
	list(SKILL_UNARM,0,2),
	list(SKILL_ENGINE,0),
	list(SKILL_SURG,0),
	list(SKILL_MEDIC,0),
	list(SKILL_CLEAN,0),
	list(SKILL_CLIMB,5,5),
	list(SKILL_STEAL,2,2),
	list(SKILL_SWIM,3,3),
	list(SKILL_OBSERV, 2,2),
	list(SKILL_BOAT, 0),
	)
	equip(var/mob/living/carbon/human/H)
		if(!H)
			return 0
		..()
		if((H.client.prefs.toggle_squire || H.special == "squireadult"))
			H.equip_to_slot_or_del(new /obj/item/clothing/under/rank/security(H), slot_w_uniform)
			H.equip_to_slot_or_del(new /obj/item/clothing/suit/armor/vest/security/squireadult(H), slot_wear_suit)
			H.equip_to_slot_or_del(new /obj/item/clothing/shoes/lw/jackboots(H), slot_shoes)
			H.set_dir(NORTH)
			H.equip_to_slot_or_del(new /obj/item/device/radio/headset/bracelet/cheap/sec(H), slot_wrist_r)
			H.my_skills.change_skill(SKILL_MELEE,rand(2,2))
			H.my_skills.change_skill(SKILL_RANGE,rand(2,2))
			H.my_skills.change_skill(SKILL_FARM,rand(0,0))
			H.my_skills.change_skill(SKILL_COOK,rand(0,0))
			H.my_skills.change_skill(SKILL_UNARM,rand(0,1))
			H.my_skills.change_skill(SKILL_ENGINE,rand(0,0))
			H.my_skills.change_skill(SKILL_SURG,rand(0,0))
			H.my_skills.change_skill(SKILL_MEDIC,rand(0,0))
			H.my_skills.change_skill(SKILL_CLEAN,rand(0,0))
			H.my_skills.change_skill(SKILL_CLIMB,rand(3,4))
			H.my_skills.change_skill(SKILL_STEAL,rand(0,0))
			H.my_skills.change_skill(SKILL_SWIM,rand(2,3))
			H.my_skills.change_skill(SKILL_OBSERV, rand(2,2))
			H.my_stats.change_stat(STAT_ST , 2)
			H.my_stats.change_stat(STAT_HT , 2)
			H.my_stats.change_stat(STAT_DX , 0)
			H.my_stats.change_stat(STAT_IN , 0)
			H.add_perk(/datum/perk/heroiceffort)
			H.add_perk(/datum/perk/morestamina)
			if(H.gender == FEMALE && !H.has_penis())
				H.my_stats.change_stat(STAT_ST , -1)
			var/weaponreal = pick("axe","sword")
			switch(weaponreal)
				if("axe")
					H.equip_to_slot_or_del(new /obj/item/hatchet(H), slot_l_hand)
				if("sword")
					H.equip_to_slot_or_del(new /obj/item/claymore(H), slot_l_hand)
			H.equip_to_slot_or_del(new /obj/item/shield/fort(H), slot_r_hand)
		else
			H.set_species("Child")
			H.equip_to_slot_or_del(new /obj/item/clothing/under/child_jumpsuit(H), slot_w_uniform)
			H.equip_to_slot_or_del(new /obj/item/clothing/shoes/lw/child/shoes(H), slot_shoes)
			H.set_dir(NORTH)
			H.equip_to_slot_or_del(new /obj/item/clothing/suit/armor/vest/squire(H), slot_wear_suit)
			H.equip_to_slot_or_del(new /obj/item/device/radio/headset/bracelet/cheap/sec(H), slot_wrist_r)
			H.vice = null
			H.religion = "Gray Church"
			H.add_perk(/datum/perk/heroiceffort)
			H.add_perk(/datum/perk/morestamina)
			H.height = rand(130,150)
		var/weaponSpecs = rand(0,2)
		switch(weaponSpecs)
			if(0)
				H.my_skills.change_skill(SKILL_SWORD,rand(1,2))
			if(1)
				H.my_skills.change_skill(SKILL_STAFF,rand(1,2))
			if(2)
				H.my_skills.change_skill(SKILL_SWING,rand(1,2))
		H.create_kg()
		return 1

var/global/Gatekeeper_Type = "Null"

/datum/job/gatekeeper
	title = "Charybdis"
	titlebr = "Charybdis"
	flag = GATEKEEPER
	department_flag = ENGSEC
	faction = "Station"
	stat_mods = list(STAT_ST = 1, STAT_DX = 0, STAT_HT = 1, STAT_IN = 0)
	total_positions = 1
	spawn_positions = 1
	supervisors = "the Baron and the Marduk"
	selection_color = "#ffeeee"
	idtype = /obj/item/card/id/other
	access = list(garrison,keep,courtroom)
	minimal_access = list(garrison,keep,courtroom)
	minimal_player_age = 3
	sex_lock = MALE
	latejoin_locked = TRUE
	money = 13
	thanati_chance = 1
	jobdesc = " Gatekeeper to the Barons Fort. Dungeon Master. Armourer of the Triton Guard. The Charybdis is all of these at once. His nightly duty is to watch the keeps gates, ensuring the smerds dont just wander in when they please while letting the Tritons and nobility in and out as often as they want.  And who better to watch the Dungeon and guard the armory, than the one that has to sit atop both for hours on end?"
	skill_mods = list(
	list(SKILL_MELEE,5,5),
	list(SKILL_RANGE,4,4),
	list(SKILL_UNARM,0,3),
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
		H.voicetype = "strong"
		H.add_perk(/datum/perk/ref/strongback)
		H.add_perk(/datum/perk/heroiceffort)
		H.add_perk(/datum/perk/morestamina)
		if(prob(50))
			H.virgin = FALSE
		H.equip_to_slot_or_del(new /obj/item/daggerssheath/iron(H), slot_wrist_l)
		H.terriblethings = TRUE
		H.equip_to_slot_or_del(new /obj/item/clothing/under/rank/security/triton(H), slot_w_uniform)
		H.equip_to_slot_or_del(new /obj/item/clothing/shoes/lw/jackboots(H), slot_shoes)
		H.set_dir(NORTH)
		H.equip_to_slot_or_del(new /obj/item/clothing/head/helmet/sechelm(H), slot_r_hand)
		H.equip_to_slot_or_del(new /obj/item/clothing/gloves/triton(H), slot_gloves)
		H.equip_to_slot_or_del(new /obj/item/clothing/suit/armor/vest/security(H), slot_wear_suit) //H.equip_to_slot_or_del(new /obj/item/clothing/suit/armor/vest/iron_cuirass(H), slot_wear_suit)
		H.equip_to_slot_or_del(new /obj/item/device/radio/headset/bracelet/security(H), slot_wrist_r)
		H.equip_to_slot_or_del(new /obj/item/gun/energy/taser/leet/sparq(H), slot_belt)
		var/weaponSpecs = rand(0,2)
		switch(weaponSpecs)
			if(0)
				H.my_skills.change_skill(SKILL_SWORD,rand(0,3))
				H.my_skills.change_skill(SKILL_KNIFE,rand(0,3))
			if(1)
				H.my_skills.change_skill(SKILL_SWORD,rand(0,3))
				H.my_skills.change_skill(SKILL_STAFF,rand(0,3))
			if(2)
				H.my_skills.change_skill(SKILL_STAFF,rand(0,3))
				H.my_skills.change_skill(SKILL_SWING,rand(0,3))
		H.create_kg()
		return 1
