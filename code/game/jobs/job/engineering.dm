/datum/job/engineer
	title = "Wright"
	titlebr = "Minerador"
	flag = ENGINEER
	department_flag = ENGSEC
	faction = "Station"
	stat_mods = list(STAT_ST = 2, STAT_DX = -1, STAT_HT = 2, STAT_IN = -2)
	total_positions = 2
	spawn_positions = 2
	supervisors = "the Baron"
	selection_color = "#fff5cc"
	jobdesc = "An all around skilled engineer and mason paid to construct works of stone, make repairs to the fortress or even mine. An all around handyman, he is the only person in the fortress with these capabilities ensuring his niche trade skills always land him a job. Don&#8217;t pay him and he&#8217;ll be sure to measure the thickness of your skull."
	jobdescbr = "An all around skilled engineer and mason paid to construct works of stone, make repairs to the fortress or even mine. An all around handyman, he is the only person in the fortress with these capabilities ensuring his niche trade skills always land him a job. Don&#8217;t pay him and he&#8217;ll be sure to measure the thickness of your skull."
	idtype = /obj/item/card/id/engie
	access = list(keep,hump)
	minimal_access = list(keep,hump)
	thanati_chance = 75
	money = 9
	skill_mods = list(
	list(SKILL_MELEE,2,2),
	list(SKILL_RANGE,0),
	list(SKILL_UNARM,0,2),
	list(SKILL_FARM,0),
	list(SKILL_COOK,0),
	list(SKILL_ENGINE,5,6),
	list(SKILL_CRAFT, 7),
	list(SKILL_SURG,0),
	list(SKILL_MEDIC,0),
	list(SKILL_CLEAN,0),
	list(SKILL_MASON,8,9),
	list(SKILL_CLIMB, 4),
	list(SKILL_SWIM,2,2),
	list(SKILL_OBSERV, 2,2),
	list(SKILL_MINE,5,5),
	)
	equip(var/mob/living/carbon/human/H)
		if(!H)
			return 0
		..()
		H.equip_to_slot_or_del(new /obj/item/device/radio/headset/bracelet(H), slot_wrist_r)
		H.equip_to_slot_or_del(new /obj/item/storage/backpack/industrial(H), slot_back)
		H.equip_to_slot_or_del(new /obj/item/clothing/under/rank/hydroponics(H), slot_w_uniform)
		H.equip_to_slot_or_del(new /obj/item/clothing/shoes/lw/brown(H), slot_shoes)
		H.equip_to_slot_or_del(new /obj/item/clothing/head/hardhat(H), slot_head)
		H.equip_to_slot_or_del(new /obj/item/clothing/mask/breath(H), slot_wear_mask)
		H.equip_to_slot_or_del(new /obj/item/clothing/suit/minerapron(H), slot_wear_suit)
		H.equip_to_slot_or_del(new /obj/item/pickaxe(H), slot_l_hand)
		H.equip_to_slot_or_del(new /obj/item/shovel(H), slot_belt)
		H.equip_to_slot_or_del(new /obj/item/clothing/gloves/botanic_leather(H), slot_gloves)
		H.equip_to_slot_or_del(new /obj/item/chisel(H), slot_r_store)
		H.equip_to_slot_or_del(new /obj/item/key/residencesHUMP(H), slot_l_store)
		H.add_perk(/datum/perk/ref/strongback)
		H.add_perk(/datum/perk/illiterate)
		H.add_perk(/datum/perk/ancitech)
		H.create_kg()
		return 1


/datum/job/mortus
	title = "Mortus"
	titlebr = "Mortus"
	flag = MORTUS
	department_flag = CIVILIAN
	faction = "Station"
	stat_mods = list(STAT_ST = 2, STAT_DX = 0, STAT_HT = 2, STAT_IN = 2)
	total_positions = 2
	spawn_positions = 2
	supervisors = "the Baron"
	jobdesc = "The obscure residents of the fortress, often hiding their faces from others to not be identified. With an immunity from the lifeweb radiation, they can sometimes be heard referring to it as the &#8217;Mistress&#8217; amongst themselves. Kidnappings happen often in Enoch&#8217;s Gate, and its usually the mortii blamed first. The garrison turn a blind eye to the necessities of your job as long as you&#8217;re keeping the power on, or else you&#8217;ll be the mistress&#8217;s next sacrifice."
	jobdescbr = "The obscure residents of the fortress, often hiding their faces from others to not be identified. With an immunity from the lifeweb radiation, they can sometimes be heard referring to it as the &#8217;Mistress&#8217; amongst themselves. Kidnappings happen often in Enoch&#8217;s Gate, and its usually the mortii blamed first. The garrison turn a blind eye to the necessities of your job as long as you&#8217;re keeping the power on, or else you&#8217;ll be the mistress&#8217;s next sacrifice."
	selection_color = "#fff5cc"
	idtype = /obj/item/card/id/mortician
	access = list(lifeweb)
	minimal_access = list(lifeweb)
	thanati_chance = 25
	money = 6
	skill_mods = list(
	list(SKILL_MELEE,4,4),
	list(SKILL_UNARM,1,2),
	list(SKILL_RANGE,2,2),
	list(SKILL_FARM,0),
	list(SKILL_COOK,0),
	list(SKILL_ENGINE,0),
	list(SKILL_SURG,0),
	list(SKILL_MEDIC,2,2),
	list(SKILL_CLEAN,0),
	list(SKILL_CLIMB,5,5),
	list(SKILL_SWIM,2,2),
	list(SKILL_OBSERV, 3,3),
	)
	equip(var/mob/living/carbon/human/H)
		if(!H)
			return 0
		..()
		H.equip_to_slot_or_del(new /obj/item/device/radio/headset/bracelet/cheap(H), slot_wrist_r)
		H.equip_to_slot_or_del(new /obj/item/daggerssheath(H), slot_wrist_l)
		H.equip_to_slot_or_del(new /obj/item/clothing/under/rank/janitor(H), slot_w_uniform)
		H.equip_to_slot_or_del(new /obj/item/clothing/shoes/lw/boots(H), slot_shoes)
		H.equip_to_slot_or_del(new /obj/item/daggerssheath(H), slot_wrist_l)
		H.equip_to_slot_or_del(new /obj/item/clothing/suit/storage/vest/goodhood/morticiancloak(H), slot_wear_suit)
		H.equip_to_slot_or_del(new /obj/item/chisel(H), slot_r_store)
		H.equip_to_slot_or_del(new /obj/item/spacecash/c10(H), slot_l_store)
		H.add_perk(/datum/perk/ref/strongback)
		H.add_perk(/datum/perk/ancitech)
		H.terriblethings = TRUE
		H.create_kg()
		return 1
