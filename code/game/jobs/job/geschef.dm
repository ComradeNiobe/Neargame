/datum/job/factorykid
	title = "Minor Worker"
	titlebr = "Crianca da FEBEM"
	flag = FACKID
	department_flag = MEDSCI
	faction = "Station"
	stat_mods = list(STAT_ST = 0, STAT_DX = 0, STAT_HT = 0, STAT_IN = -1)
	total_positions = 1
	spawn_positions = 1
	supervisors = "Your parents."
	selection_color = "#ddddff"
	jobdesc = "A child worker in Enoch&#8217;s Gates local factory, you are entrusted with performing manual labor. Bring shipments to the merchant, clean slop off the floor and making sure the gears keep grinding. You&#8217;re cheap labour, and nobody minds one bit."
	idtype = /obj/item/card/id/other
	minimal_player_age = 10
	latejoin_locked = FALSE
	children = TRUE
	access = list(geschef)
	minimal_access = list(geschef)
	equip(var/mob/living/carbon/human/H)
		if(!H)
			return 0
		..()
		H.set_species("Child")
		H.equip_to_slot_or_del(new /obj/item/device/radio/headset/bracelet/cheap(H), slot_wrist_r)
		H.equip_to_slot_or_del(new /obj/item/clothing/under/child_jumpsuit(H), slot_w_uniform)
		H.equip_to_slot_or_del(new /obj/item/clothing/suit/eye(H), slot_wear_suit)
		H.equip_to_slot_or_del(new /obj/item/clothing/shoes/lw/child/shoes(H), slot_shoes)
		H.equip_to_slot_or_del(new /obj/item/clothing/head/cap(H), slot_head)
		H.vice = null
		H.add_perk(/datum/perk/shoemaking)
		H.add_perk(/datum/perk/illiterate)
		H.height = rand(155,165)
		H.Altista()
		H.religion = "Gray Church"
		return 1

/datum/job/cargo_tech
	title = "Ganger"
	titlebr = "Doqueiro"
	flag = GANGER
	department_flag = MEDSCI
	faction = "Station"
	stat_mods = list(STAT_ST = 2, STAT_DX = 0, STAT_HT = 1, STAT_IN = -1)
	total_positions = 1
	spawn_positions = 1
	supervisors = "the merchant and the BARON"
	selection_color = "#dddddd"
	idtype = /obj/item/card/id/qm
	access = list(geschef)
	minimal_access = list(geschef)
	money = 12
	jobdesc = "Short for pressganger, you enjoy reminding yourself. Your lot is a simple one, making sure that the factory keeps running, your pockets stay filled and the worker numbers stay manageable, even if you need to do a little persuading. The Guildsman may not be your boss, but he might end up being your best friend as long as he keeps shipping out your goods and paying you. Without him? You always have the locals. Your latest orphan batch should keep the machines going, and if you take some casualties? Well, Bums and Migrants work just as well with enough quote-on-quote convincing."
	thanati_chance = 70
	skill_mods = list(
	list(SKILL_MELEE,3,3),
	list(SKILL_RANGE,2,2),
	list(SKILL_UNARM,1,2),
	list(SKILL_FARM,0),
	list(SKILL_COOK,0),
	list(SKILL_ENGINE,0),
	list(SKILL_SURG,0),
	list(SKILL_CLIMB, 4),
	list(SKILL_MEDIC,0),
	list(SKILL_CLEAN,1,2),
	list(SKILL_SWIM,2,2),
	list(SKILL_OBSERV, 2,2),
	list(SKILL_BOAT, 0),
	)
	equip(var/mob/living/carbon/human/H)
		if(!H)
			return 0
		..()
		H.voicetype = "strong"
		H.equip_to_slot_or_del(new /obj/item/device/radio/headset/bracelet/cheap(H), slot_wrist_r)
		H.equip_to_slot_or_del(new /obj/item/clothing/under/new_cut_alt(H), slot_w_uniform)
		H.equip_to_slot_or_del(new /obj/item/clothing/shoes/lw/jackboots(H), slot_shoes)
		H.equip_to_slot_or_del(new /obj/item/clothing/head/cap(H), slot_head)
		H.equip_to_slot_or_del(new /obj/item/clothing/suit/new_cut/new_cut_alt2(H), slot_wear_suit)
		H.equip_to_slot_or_del(new /obj/item/clothing/gloves/fingerless(H), slot_gloves)
		H.equip_to_slot_or_del(new /obj/item/melee/classic_baton/club/knuckleduster(H), slot_l_store)
		H.add_perk(/datum/perk/docker)
		H.terriblethings = TRUE
		H.add_perk(/datum/perk/ref/strongback)
		H.add_perk(/datum/perk/illiterate)
		H.add_perk(/datum/perk/morestamina)
		H.create_kg()
		return 1