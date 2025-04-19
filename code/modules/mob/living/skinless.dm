//EELO
/mob/living/carbon/human/skinless
	maxHealth = 120
	health = 120
	item_worth = 16
	is_npc = TRUE //So they don't have the shit about yellow saliva.
	var/cycle_pause = 15
	var/atom/target
	var/attacksound
	var/rushing = 0
	var/stamina = 100
	var/maxstamina = 100
	var/list/zone_allowed = list("chest", "head", "l_arm", "r_arm", "groin")
	var/viewrange = 6
	var/frustration = 1000
	bot = 1

/datum/species/skinless
	name = "skinless"
	icobase = 'icons/mob/flesh/subhuman.dmi'
	primitive = /mob/living/carbon/human/skinless
	unarmed_type = /datum/unarmed_attack
	secondary_unarmed_type = /datum/unarmed_attack
	minheightm = 170
	maxheightm = 220
	minheightf = 170
	maxheightf = 220
	flags = NO_PAIN


/mob/living/carbon/human/skinless/Move()
	if(resting || stat)
		return ..()
	var/selectedSound = pick('sound/voice/skinless1.ogg', 'sound/voice/skinless2.ogg','sound/voice/skinless3.ogg','sound/voice/skinless4.ogg','sound/voice/skinless5.ogg')
	if(prob(10))
		src.sound2()
		src.emote("screams violently!")
		playsound(loc, selectedSound, 100, 1, 0, 0)
	if(prob(40))
		npc_pick_up()
	return ..()

/mob/living/carbon/human/skinless/Life()
	nutrition = 900
	becoming_zombie = 0
	zombify = 0
	src.vessel.add_reagent("dentrine", 30)
	return ..()

/mob/living/carbon/human/skinless/New()
	..()

	set_species("skinless")
	gender = MALE
	src.real_name = random_name(src.gender)
	gender = pick(MALE,FEMALE)
	switch(gender)//You make things harder than it needs to be. Instead of using a regex to cut off their last name... why not just use the convient first name's list that the get random name proc already goes through.
		if(MALE)
			real_name = pick(first_names_male)
		else
			real_name = pick(first_names_female)
	real_name = "[real_name] Skinless"
	a_intent = "hurt"
	src.zone_sel = new /obj/screen/zone_sel( null )
	var/skinless = pick("knife","club","spear")
	switch(skinless)
		if("knife")
			src.equip_to_slot_or_del(new /obj/item/kitchen/utensil/knife/dagger/copper(src), slot_r_hand)
		if("club")
			src.equip_to_slot_or_del(new /obj/item/melee/classic_baton/club(src), slot_r_hand)
		if("spear")
			src.equip_to_slot_or_del(new /obj/item/claymore/wspear(src), slot_r_hand)
	if(prob(45))
		src.equip_to_slot_or_del(new /obj/item/clothing/head/helmet/lw/ironopenhelmet(src), slot_head)
	if(prob(60))
		src.equip_to_slot_or_del(new /obj/item/clothing/suit/armor/vest/iron_cuirass(src), slot_wear_suit)
	penis_size = rand(16, 25)
	my_skills.change_skill(SKILL_MELEE, 11)
	sleep(10)
	if(!mind)
		mind = new /datum/mind(src)
	hand = 0
	// main loop
	spawn while(stat != 2 && bot)
		sleep(cycle_pause)
		src.process()

/mob/living/carbon/human/skinless
	proc/attack_target()

		var/direct = get_dir(src, target)
		if ( (direct - 1) & direct)
			var/turf/Step_1
			var/turf/Step_2
			switch(direct)
				if(EAST|NORTH)
					Step_1 = get_step(src, NORTH)
					Step_2 = get_step(src, EAST)

				if(EAST|SOUTH)
					Step_1 = get_step(src, SOUTH)
					Step_2 = get_step(src, EAST)

				if(NORTH|WEST)
					Step_1 = get_step(src, NORTH)
					Step_2 = get_step(src, WEST)

				if(SOUTH|WEST)
					Step_1 = get_step(src, SOUTH)
					Step_2 = get_step(src, WEST)

			if(Step_1 && Step_2)
				var/check_1 = 1
				var/check_2 = 1

				check_1 = Adjacent(get_turf(src), Step_1, target) && Adjacent(Step_1, get_turf(target), target)

				check_2 = Adjacent(get_turf(src), Step_2, target) && Adjacent(Step_2, get_turf(target), target)

				if(check_1 || check_2)
					target.attack_hand(src)
					return
				else
					var/obj/structure/window/W = locate() in target.loc
					var/obj/structure/window/WW = locate() in src.loc
					if(W)
						if(src.r_hand || src.l_hand)
							if(r_hand)
								W.attackby(r_hand, src)
							else
								if(l_hand)
									W.attackby(l_hand, src)
						else
							W.attack_hand(src)
						return 1
					else if(WW)
						if(src.r_hand || src.l_hand)
							if(r_hand)
								WW.attackby(r_hand, src)
							else
								if(l_hand)
									WW.attackby(l_hand, src)
						else
							WW.attack_hand(src)
						return 1
		if(!loc) return
		if(!target) return
		else if(Adjacent(src?.loc , target?.loc,target))
			if(src.r_hand || src.l_hand)
				if(r_hand)
					target.attackby(r_hand, src)
				else
					if(l_hand)
						target.attackby(l_hand, src)
			else
				target.attack_hand(src)
				if(prob(50) && attacksound)
					playsound(loc, attacksound, 80, 0)
			//target.attack_hand(src)
			// sometimes push the enemy
			if(prob(10))
				step(src,direct)
			else
				if(prob(30))
					zone_sel.selecting = pick(zone_allowed)
					kick_act(target)
				else
					if(prob(18))
						zone_sel.selecting = pick(zone_allowed)
						steal_act(target)
			return 1
		else
			var/obj/structure/window/W = locate() in target.loc
			var/obj/structure/window/WW = locate() in src.loc
			if(W)
				if(src.r_hand || src.l_hand)
					if(r_hand)
						W.attackby(r_hand, src)
					else if(l_hand)
						W.attackby(l_hand, src)
				else
					W.attack_hand(src)
				return 1
			else if(WW)
				if(src.r_hand || src.l_hand)
					if(r_hand)
						WW.attackby(r_hand, src)
					else
						if(l_hand)
							WW.attackby(l_hand, src)
				else
					WW.attack_hand(src)
				return 1
	proc/process()
		set background = 1
		if(client)
			return FALSE

		zone_sel.selecting = pick(zone_allowed)
		if (stat) //I don't want any zombie skinless chasing me around.
			return FALSE
		if(resting)
			mob_rest()
			return

		if(prob(40))
			npc_pick_up()

		stamina++
		if(stamina >= maxstamina)
			stamina = maxstamina
		if (!target)
			// no target, look for a new one

			// look for a target, taking into consideration their health
			// and distance from the zombie
			var/last_health = INFINITY
			combat_mode = 0
			if(resting)
				mob_rest()
			for (var/mob/living/carbon/human/C in orange(viewrange-2,src.loc))
				var/dist = get_dist(src, C)

				// if the zombie can't directly see the human, they're
				// probably blocked off by a wall, so act as if the
				// human is further away
				if(!(C in view(src, viewrange)))
					dist += 3

				if (C.stat == DEAD || istype(C, /mob/living/carbon/human/skinless) || !can_see(src,C,viewrange) || C.consyte)
					continue
				if(C.stunned || C.paralysis || C.weakened)
					target = C
					break
				if(C.health < last_health) if(!prob(30))
					last_health = C.health
					target = C

		// if we have found a target
		if(target)
			if(stamina >= 40)
				if(prob(5))
					jump_act(target, src)
			if(stamina == maxstamina && species.name == "Graga")
				rushing = 1
				stamina = 0
				var/selectedSound = pick('sound/effects/graga_life1.ogg', 'sound/effects/graga_life2.ogg', 'sound/effects/graga_life3.ogg')
				playsound(loc, selectedSound, 70, 0)
				cycle_pause = 5
				spawn(150)
					rushing = 0
					cycle_pause = 15
				return

			for(var/direction in cardinal)
				var/turf/T = get_step(src, direction)
				for(var/atom/A in T?.contents)
					if(ismob(A))
						continue
					if(istype(A, /obj/multiz/stairs/))
						continue
					if(A.density  && src.my_stats.get_stat(STAT_ST) >= 20)
						qdel(A)
				if(T.density && src.my_stats.get_stat(STAT_ST) >= 20)
					qdel(T)

			// change the target if there is another human that is closer
			for (var/mob/living/carbon/human/C in orange(2,src.loc))
				if (C.stat == 2 || istype(C, /mob/living/carbon/human/skinless) || C.consyte)
					continue
				if(get_dist(src, target) >= get_dist(src, C) && prob(30) && !rushing)
					target = C
					break

			if(ismob(target))
				var/mob/T = target
				if(T.stat == 2)
					target = null

			var/distance = get_dist(src, target)

			if(target in orange(viewrange,src))
				if(distance <= 1)
					if(attack_target())
						var/tdir = get_cardinal_dir(src, target)
						var/turf/T = get_step(src, tdir)
						for(var/atom/A in T.contents)
							if(A.density)
								return 1
						if(!T.density)
							src.set_dir(tdir)
							Move(T)
						return 1
				else
					var/tdir = get_cardinal_dir(src, target)
					var/turf/T = get_step(src, tdir)
					for(var/atom/A in T.contents)
						if(A.density)
							return 1
					if(!T.density)
						src.set_dir(tdir)
						Move(T)
					return 1
			else
				target = null
				return 1

		// if there is no target in range, roam randomly
		else

			frustration--
			frustration = max(frustration, 0)

			if(stat == 2) return 0

			var/prev_loc = loc
			// make sure they don't walk into space
			if(!(locate(/turf/space) in get_step(src,dir)) && !(locate(/turf/simulated/floor/open) in get_step(src,dir)))
				step(src,dir)
			// if we couldn't move, pick a different direction
			// also change the direction at random sometimes
			if(loc == prev_loc || prob(20))
				sleep(5)
				dir = pick(NORTH,SOUTH,EAST,WEST)

			return 1

		// if we couldn't do anything, take a random step
		var/obj/machinery/door/airlock/A = locate() in get_step_rand(src)//NPC's do not play nice with dense airlocks. If it is locked they will walk into it forever
		if(A && A.density)
			if(A.locked)
				dir = get_dir(src,target) // still face to the target
				frustration++
				return 1
			else
				step_rand(src)
				dir = get_dir(src,target) // still face to the target
				frustration++
				return 1
		else
			step_rand(src)
			dir = get_dir(src,target) // still face to the target
			frustration++
			return 1

