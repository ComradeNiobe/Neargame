//RATON
/mob/living/carbon/human/monster/tzanch
	maxHealth = 45
	health = 45
	item_worth = 10
	name = "Tzanch"
	real_name = "Tzanch"
	attacksound = 'sound/effects/tzanzlife1.ogg'
	viewrange = 5
	zone_allowed = list("groin","vitals","l_foot", "r_foot", "l_leg", "r_leg")
	cycle_pause = 10

/datum/species/tzanch
	name = "tzanch"
	icobase = 'icons/monsters/tzanch.dmi'
	primitive = /mob/living/carbon/human/monster/tzanch
	unarmed_type = /datum/unarmed_attack/tzanch
	secondary_unarmed_type = /datum/unarmed_attack/tzanch
	minheightm = 50
	maxheightm = 70
	minheightf = 50
	maxheightf = 70

/datum/unarmed_attack/tzanch
	attack_verb = list("hits","slash")
	attack_sound = 'sound/weapons/bite.ogg'
	miss_sound = 'sound/weapons/slashmiss.ogg'
	damage = 3
	sharp = 1
	edge = 0

/mob/living/carbon/human/monster/tzanch/New()
	..()
	set_species("tzanch")

	src.zone_sel = new /obj/screen/zone_sel( null )
	penis_size = rand(16, 25)
	my_stats.change_stat(STAT_ST, -5)
	my_stats.change_stat(STAT_HT, -5)
	my_stats.change_stat(STAT_DX, -5)
	my_skills.change_skill(SKILL_MELEE, rand(1,2))
	equip_to_slot_or_del(new /obj/item/clothing/under/tzanch(src), slot_w_uniform)
	for(var/obj/item/reagent_containers/food/snacks/organ/O in src.organ_storage)
		O.bumorgans()
	sleep(10)
	if(!mind)
		mind = new /datum/mind(src)
	// main loop
	spawn while(stat != 2 && bot)
		sleep(cycle_pause)
		src.process()

/mob/living/carbon/human/monster/tzanch/Move()
	if(resting || stat)
		return ..()
	playsound(loc, 'sound/effects/tzanz_walk2.ogg', 30, 1)
	var/selectedSound = pick('sound/effects/tzanzlife1.ogg','sound/effects/tzanzlife2.ogg','sound/effects/tzanzlife3.ogg')
	if(prob(10))
		playsound(loc, selectedSound, 80, 1)
	return ..()

/mob/living/carbon/human/monster/tzanch/movement_delay()
	return -4