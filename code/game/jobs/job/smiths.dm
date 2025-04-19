/datum/job/smithassistant
	title = "Blacksmiths Assistant"
	titlebr = "Smith Assistant"
	flag = ARMORSMITH
	department_flag = MEDSCI
	faction = "Station"
	stat_mods = list(STAT_ST = 3, STAT_DX = -1, STAT_HT = 0, STAT_IN = 0)
	total_positions = 1
	spawn_positions = 1
	supervisors = "The blacksmith."
	selection_color = "#ae00ff"
	idtype = /obj/item/card/id/ltgrey
	access = list(smith)
	minimal_access = list(smith)
	jobdesc = "The oldest assistant to The Gate&#8217;s own Blacksmith, you have had to endure his teachings and ramblings for many years, compared to the younger apprentices. Aid your teacher in his craft, and in due time you will surpass him eventually."
	jobdescbr = "Ferreiro especializado em tudo o que a forja pode fazer."
	thanati_chance = 75
	skill_mods = list(
	list(SKILL_MELEE,2,2),
	list(SKILL_RANGE,0),
	list(SKILL_FARM,0),
	list(SKILL_COOK,0),
	list(SKILL_ENGINE,0),
	list(SKILL_SURG,0),
	list(SKILL_MEDIC,0),
	list(SKILL_CLEAN,0),
	list(SKILL_MASON,3,4),
	list(SKILL_SMITH,5,7),
	list(SKILL_CLIMB,2,2),
	list(SKILL_UNARM,0),
	list(SKILL_OBSERV, 2,2),
	)
	equip(var/mob/living/carbon/human/H)
		if(!H)
			return 0
		..()
		H.voicetype = "sketchy"
		H.equip_to_slot_or_del(new /obj/item/device/radio/headset/bracelet(H), slot_wrist_r)
		H.equip_to_slot_or_del(new /obj/item/clothing/under/common/smith(H), slot_w_uniform)
		H.equip_to_slot_or_del(new /obj/item/clothing/suit/apron(H), slot_wear_suit)
		H.equip_to_slot_or_del(new /obj/item/clothing/shoes/lw/brown(H), slot_shoes)
		H.equip_to_slot_or_del(new /obj/item/alicate(H), slot_belt)
		H.equip_to_slot_or_del(new /obj/item/carverhammer(H), slot_l_hand)
		H.equip_to_slot_or_del(new /obj/item/storage/backpack/satchel/smith(H), slot_back)
		H.create_kg()
		return 1


/datum/job/blacksmith
	title = "Blacksmith"
	titlebr = "Smith"
	flag = METALSMITH
	department_flag = MEDSCI
	faction = "Station"
	stat_mods = list(STAT_ST = 3, STAT_DX = -1, STAT_HT = 0, STAT_IN = 0)
	total_positions = 1
	spawn_positions = 1
	supervisors = "The merchant and yourself."
	selection_color = "#ae00ff"
	idtype = /obj/item/card/id/ltgrey
	access = list(smith)
	minimal_access = list(smith)
	jobdesc = "The Gate&#8217;s sole, and best, blacksmith, if you do not count your own assistant or that hack hiding out in the caves that ran away several nights ago. You have a reputation to keep as the main supplier of smithed goods in Enoch&#8217;s Gate, and the demand is high, be it from the Baron and his garrison seeking some protection or weapons, or the Merchant wanting to export your metal wares, you have no short supply of customers."
	thanati_chance = 50
	skill_mods = list(
	list(SKILL_MELEE,2,2),
	list(SKILL_RANGE,0),
	list(SKILL_FARM,0),
	list(SKILL_COOK,0),
	list(SKILL_ENGINE,0),
	list(SKILL_SURG,0),
	list(SKILL_MEDIC,0),
	list(SKILL_CLEAN,0),
	list(SKILL_MASON,3,4),
	list(SKILL_SMITH,7,8),
	list(SKILL_CLIMB,2,2),
	list(SKILL_UNARM,0),
	list(SKILL_OBSERV, 2,2),
	)
	equip(var/mob/living/carbon/human/H)
		if(!H)
			return 0
		..()
		H.voicetype = "sketchy"
		H.equip_to_slot_or_del(new /obj/item/device/radio/headset/bracelet(H), slot_wrist_r)
		H.equip_to_slot_or_del(new /obj/item/clothing/under/common/smith(H), slot_w_uniform)
		H.equip_to_slot_or_del(new /obj/item/clothing/suit/apron(H), slot_wear_suit)
		H.equip_to_slot_or_del(new /obj/item/clothing/shoes/lw/brown(H), slot_shoes)
		H.equip_to_slot_or_del(new /obj/item/alicate(H), slot_belt)
		H.equip_to_slot_or_del(new /obj/item/carverhammer(H), slot_l_hand)
		H.equip_to_slot_or_del(new /obj/item/storage/backpack/satchel/smith(H), slot_back)
		H.create_kg()
		return 1


/datum/job/apprentice
	title = "Apprentice"
	titlebr = "Aprendiz"
	flag = APPRENTICE
	department_flag = CIVILIAN
	faction = "Station"
	stat_mods = list(STAT_ST = -1, STAT_DX = 1, STAT_HT = -2, STAT_IN = -1)
	total_positions = 3
	spawn_positions = 3
	supervisors = "the Blacksmith."
	selection_color = "#ddddff"
	minimal_player_age = 10
	jobdesc = "A young learner in a contract of apprenticeship with the local smith. Usually, they are children of parents who give them up to work under an artisan. Their many years of servitude to their master allow them to learn hands on, and potentially succeed them."
	idtype = /obj/item/card/id/ltgrey
	access = list(smith)
	minimal_access = list(smith)
	skill_mods = list(
	list(SKILL_MELEE,1,2),
	list(SKILL_RANGE,0),
	list(SKILL_FARM,0),
	list(SKILL_COOK,0),
	list(SKILL_ENGINE,0),
	list(SKILL_SURG,0),
	list(SKILL_MEDIC,0),
	list(SKILL_CLEAN,0,2),
	list(SKILL_SMITH,4,6),
	list(SKILL_CLIMB,3,4),
	list(SKILL_OBSERV, 2,2),
	)
	equip(var/mob/living/carbon/human/H)
		if(!H)
			return 0
		..()
		H.set_species("Child")
		H.equip_to_slot_or_del(new /obj/item/clothing/under/child_jumpsuit(H), slot_w_uniform)
		H.equip_to_slot_or_del(new /obj/item/device/radio/headset/bracelet/cheap(H), slot_wrist_r)
		H.equip_to_slot_or_del(new /obj/item/clothing/shoes/lw/child/shoes(H), slot_shoes)
		H.equip_to_slot_or_del(new /obj/item/clothing/suit/yapron(H), slot_wear_suit)
		H.vice = null
		H.religion = "Gray Church"
		H.height = rand(130,150)
		H.create_kg()
		return 1
