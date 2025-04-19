/mob/living/carbon/human/monster/skeleton
	maxHealth = 120
	health = 120
	item_worth = 4
	flags = NO_PAIN

/mob/living/carbon/human/monster/skeleton/New()
	..()
	makeSkeleton(TRUE)
	src.zone_sel = new /obj/screen/zone_sel( null )
	penis_size = rand(16, 25)
	my_skills.change_skill(SKILL_MELEE, rand(6,7))
	sleep(10)
	if(!mind)
		mind = new /datum/mind(src)
	// main loop
	spawn while(stat != 2 && bot)
		sleep(cycle_pause)
		src.process()

/mob/living/carbon/human/monster/skeleton/movement_delay()
	return 1

/mob/living/carbon/human/monster/skeleton/ancestor
	maxHealth = 300
	health = 300
	item_worth = 64

/mob/living/carbon/human/monster/skeleton/ancestor/New()
	..()
	makeSkeleton(TRUE)
	real_name = "Ancestor"
	name = "Ancestor"

	src.zone_sel = new /obj/screen/zone_sel( null )
	penis_size = rand(16, 25)
	my_stats.change_stat(STAT_ST, 10)
	my_stats.change_stat(STAT_HT, 10)
	my_stats.change_stat(STAT_DX, 10)
	var/pickit = pick("spear","sabre","rapier","copper")
	switch(pickit)
		if("sabre")
			equip_to_slot_or_del(new /obj/item/claymore/rusty/sabre(src), slot_r_hand)
		if("spear")
			equip_to_slot_or_del(new /obj/item/claymore/cspear(src), slot_r_hand)
		if("rapier")
			equip_to_slot_or_del(new /obj/item/claymore/rusty/rapier(src), slot_r_hand)
		if("copper")
			equip_to_slot_or_del(new /obj/item/claymore/copper(src), slot_r_hand)
	equip_to_slot_or_del(new /obj/item/clothing/suit/armor/vest/iron_plate(src), slot_wear_suit)
	my_skills.change_skill(SKILL_MELEE, 7)
	my_skills.change_skill(SKILL_RANGE, 7)
	sleep(10)
	if(!mind)
		mind = new /datum/mind(src)
	// main loop
	spawn while(stat != 2 && bot)
		sleep(cycle_pause)
		src.process()
