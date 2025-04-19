//EELO
/mob/living/carbon/human/monster/eelo
	maxHealth = 120
	health = 120
	item_worth = 32
	attacksound = 'sound/effects/kthanid_attack.ogg'

/datum/species/eelo
	name = "eelo"
	icobase = 'icons/monsters/eelo.dmi'
	primitive = /mob/living/carbon/human/monster/eelo
	unarmed_type = /datum/unarmed_attack/eelo
	secondary_unarmed_type = /datum/unarmed_attack/eelo
	minheightm = 170
	maxheightm = 220
	minheightf = 170
	maxheightf = 220

/datum/unarmed_attack/eelo
	attack_verb = list("stabs", "hits","slash")
	attack_sound = 'sound/weapons/attackchan1.ogg'
	miss_sound = 'sound/weapons/slashmiss.ogg'
	damage = 25
	sharp = 1
	edge = 0

/mob/living/carbon/human/monster/eelo/New()
	..()
	set_species("eelo")
	var/selectedName = pick("Eelo","Kthanid")

	name = selectedName
	real_name = selectedName

	src.zone_sel = new /obj/screen/zone_sel( null )
	equip_to_slot_or_del(new /obj/item/clothing/under/eelo(src), slot_w_uniform)
	penis_size = rand(16, 25)
	my_stats.set_stat(STAT_ST, rand(10,12))
	my_stats.set_stat(STAT_HT, rand(5,10))
	my_stats.set_stat(STAT_DX, rand(4,5))
	my_skills.change_skill(SKILL_MELEE, rand(6,7))
	sleep(10)
	if(!mind)
		mind = new /datum/mind(src)
	// main loop
	spawn while(stat != 2 && bot)
		sleep(cycle_pause)
		src.process()

/mob/living/carbon/human/monster/eelo/Move()
	if(resting || stat)
		return ..()
	var/selectedSound = pick('sound/effects/kthanid_life.ogg')
	playsound(loc, 'sound/effects/kthanid_move.ogg', 50, 0)
	if(prob(25))
		playsound(loc, selectedSound, 80, 1)
	return ..()

/mob/living/carbon/human/monster/eelo/movement_delay()
	return 1