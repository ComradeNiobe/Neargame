/*
Contains most of the procs that are called when a mob is attacked by something

bullet_act
ex_act
meteor_act
emp_act

*/

/mob/living/carbon/human/bullet_act(var/obj/item/projectile/P, var/def_zone)

	if(wear_suit && istype(wear_suit, /obj/item/clothing/suit/armor/laserproof))
		if(istype(P, /obj/item/projectile/energy) || istype(P, /obj/item/projectile/beam))
			var/reflectchance = 40 - round(P.damage/3)
			if(!(def_zone in list("chest", "groin")))
				reflectchance /= 2
			if(prob(reflectchance))
				visible_message("\red <B>The [P.name] gets reflected by [src]'s [wear_suit.name]!</B>")

				// Find a turf near or on the original location to bounce to
				if(P.starting)
					var/new_x = P.starting.x + pick(0, 0, 0, 0, 0, -1, 1, -2, 2)
					var/new_y = P.starting.y + pick(0, 0, 0, 0, 0, -1, 1, -2, 2)
					var/turf/curloc = get_turf(src)

					// redirect the projectile
					P.original = locate(new_x, new_y, P.z)
					P.starting = curloc
					P.current = curloc
					P.firer = src
					P.yo = new_y - curloc.y
					P.xo = new_x - curloc.x

				return -1 // complete projectile permutation
	if(istype(P, /obj/item/projectile/energy/electrode))
		if(mShock in src.mutations) //shockproof
			return -1
		if(src.stat == DEAD)
			if(prob(30) && (src.timeofdeath + 1800 > world.time) && !(NOCLONE in src.mutations))
				src.stat = UNCONSCIOUS
				src.visible_message( \
					"\red [src]'s body trembles!", \
					"\red You feel the life enter your body with the heavy pain!", \
					"\red You hear a heavy electric crack!" \
				)
			else
				src.visible_message( \
					"\red [src]'s lifeless body trembles!", \
					"\red A discharge of electricity passes through your body, but the efforts to bring you back to life are useless.", \
					"\red You hear a heavy electric crack!" \
				)


	if(check_shields(P.damage, "the [P.name]"))
		P.on_hit(src, 2)
		return 2

	var/obj/item/cloaking_device/C = locate(/obj/item/cloaking_device) in src
	if(C && C.active)
		C.attack_self(src)//Should shut it off
		update_icons()
		src << "\blue Your [C.name] was disrupted!"
		Stun(2)

	if(istype(equipped(),/obj/item/device/assembly/signaler))
		var/obj/item/device/assembly/signaler/signaler = equipped()
		if(signaler.deadman && prob(80))
			src.visible_message("\red [src] triggers their deadman's switch!")
			signaler.signal()


		var/datum/organ/external/organ = get_organ(check_zone(def_zone))

		var/armor = checkarmor(organ, "bullet")

		if((P.embed && prob(20 + max(P.damage - armor, -10))) && P.damage_type == BRUTE)
			var/obj/item/shard/shrapnel/SP = new()
			(SP.name) = "[P.name] shrapnel"
			(SP.desc) = "[SP.desc] It looks like it was fired from [P.shot_from]."
			(SP.loc) = organ
			organ.implants += SP
			visible_message("<span class='combatbold'>The projectile sticks in the wound!</span>")
			src.verbs += /mob/proc/yank_out_object
			SP.add_blood(src)

	return (..(P , def_zone))


/mob/living/carbon/human/getarmor(var/def_zone, var/type, var/armortype)
	var/armorval = 0
	var/organnum = 0

	if(def_zone)
		if(isorgan(def_zone))
			return checkarmor(def_zone, type)
		var/datum/organ/external/affecting = get_organ(ran_zone(def_zone))
		return checkarmor(affecting, type)
		//If a specific bodypart is targetted, check how that bodypart is protected and return the value.

	//If you don't specify a bodypart, it checks ALL your bodyparts for protection, and averages out the values
	for(var/datum/organ/external/organ in organs)
		armorval += checkarmor(organ, type)
		organnum++
	return (armorval/max(organnum, 1))


/mob/living/carbon/human/proc/checkarmor(var/datum/organ/external/def_zone, var/type, var/armortype)
	if(!type)	return 0
	var/protection = 0
	var/list/body_parts = list(head, wear_mask, wear_suit, w_uniform, l_hand, r_hand, amulet, shoes, wrist_l, wrist_r, gloves)
	for(var/bp in body_parts)
		if(!bp)	continue
		if(bp && istype(bp ,/obj/item/clothing))
			var/obj/item/clothing/C = bp
			if(C.body_parts_covered & def_zone?.body_part)
				protection += C.armor[type]
	return protection

/mob/living/carbon/human/proc/check_head_coverage()

	var/list/body_parts = list(head, wear_mask, wear_suit, w_uniform)
	for(var/bp in body_parts)
		if(!bp)	continue
		if(bp && istype(bp ,/obj/item/clothing))
			var/obj/item/clothing/C = bp
			if(C.body_parts_covered & HEAD)
				return 1
	return 0

/mob/living/carbon/human/proc/check_shields(var/damage = 0, var/attack_text = "the attack")
	if(l_hand && istype(l_hand, /obj/item))//Current base is the prob(50-d/3)
		var/obj/item/I = l_hand
		if(istype(I, /obj/item/claymore))
			return 0
		if(I.IsShield() && (prob(50 - round(damage / 3))))
			visible_message("<span class='hitbold'>[src]</span> <span class='hit'>blocks [attack_text] with the [l_hand.name]!</span> ")
			return 1
	if(r_hand && istype(r_hand, /obj/item))
		var/obj/item/I = r_hand
		if(istype(I, /obj/item/claymore))
			return 0
		if(I.IsShield() && (prob(50 - round(damage / 3))))
			visible_message("<span class='hitbold'[src]</span> <span class='hit'>blocks [attack_text] with the [r_hand.name]!</span> ")
			return 1
	if(slot_belt && istype(slot_belt, /obj/item/shield/generator))
		var/obj/item/shield/generator/I = slot_belt
		if(I.IsShield() && (prob(70)))
			visible_message("<span class='hitbold'[src]</span> <span class='hit'>blocks [attack_text] with the [r_hand.name]!</span> ")
			return 1
	if(wear_suit && istype(wear_suit, /obj/item/))
		var/obj/item/I = wear_suit
		if(I.IsShield() && (prob(35)))
			visible_message("\red <B>The reactive teleport system flings [src] clear of [attack_text]!</B>")
			var/list/turfs = new/list()
			for(var/turf/T in orange(6))
				if(istype(T,/turf/space)) continue
				if(T.density) continue
				if(T.x>world.maxx-6 || T.x<6)	continue
				if(T.y>world.maxy-6 || T.y<6)	continue
				turfs += T
			if(!turfs.len) turfs += pick(/turf in orange(6))
			var/turf/picked = pick(turfs)
			if(!isturf(picked)) return
			src.loc = picked
			return 1
	return 0

/mob/living/carbon/human/emp_act(severity)
	for(var/obj/O in src)
		if(!O)	continue
		O.emp_act(severity)
	for(var/datum/organ/external/O  in organs)
		if(O.status & ORGAN_DESTROYED)	continue
		O.emp_act(severity)
		for(var/datum/organ/internal/I  in O.internal_organs)
			if(I.robotic == 0)	continue
			I.emp_act(severity)
	..()

//this proc handles being hit by a thrown atom
/mob/living/carbon/human/hitby(atom/movable/AM as mob|obj,var/speed = 5)
	if(istype(AM,/obj/))
		var/obj/O = AM

		if(in_throw_mode && !get_active_hand() && speed <= 5)	//empty active hand and we're in throw mode
			if(canmove && !restrained())
				if(isturf(O.loc))
					put_in_active_hand(O)
					visible_message("<span class='passivebold'>[src]</span> <span class='passive'>catches [O]!</span> ")
					throw_mode_off()
					return

		var/dtype = BRUTE
		if(istype(O,/obj/item))
			var/obj/item/W = O
			dtype = W.damtype
		var/throw_damage = O.throwforce*(speed/5)

		var/zone
		if (istype(O.thrower, /mob/living))
			var/mob/living/L = O.thrower
			zone = check_zone(L.zone_sel.selecting)
		else
			zone = ran_zone("chest",75)	//Hits a random part of the body, geared towards the chest

		//check if we hit
		if (O.throw_source)
			var/distance = get_dist(O.throw_source, loc)
			zone = get_zone_with_miss_chance(zone, src, min(15*(distance-2), 0))
		else
			zone = get_zone_with_miss_chance(zone, src, 15)

		if(!zone)
			visible_message("<span class='hitbold'>The [O] misses [src] narrowly!</span> ")
			return

		O.throwing = 0		//it hit, so stop moving

		if ((O.thrower != src) && check_shields(throw_damage, "[O]"))
			return

		var/datum/organ/external/affecting = get_organ(zone)
		var/hit_area = affecting.display_name

		src.visible_message("<span class='hitbold'>[src]</span> <span class='hit'>has been hit in the [hit_area] by</span> <span class='hitbold'>[O]</span><span class='hit'>.</span> ")
		var/armor = run_armor_check(affecting.name, "melee", O) //I guess "melee" is the best fit here

		if(armor < 2)
			apply_damage(throw_damage, dtype, zone, armor, is_sharp(O), has_edge(O), O)

		if(ismob(O.thrower))
			var/mob/M = O.thrower
			var/client/assailant = M.client
			if(assailant)
				src.attack_log += text("\[[time_stamp()]\] <font color='orange'>Has been hit with a [O], thrown by [M.name] ([assailant.ckey])</font>")
				M.attack_log += text("\[[time_stamp()]\] <font color='red'>Hit [src.name] ([src.ckey]) with a thrown [O]</font>")
				if(!istype(src,/mob/living/simple_animal/mouse))
					msg_admin_attack("[src.name] ([src.ckey]) was hit by a [O], thrown by [M.name] ([assailant.ckey]) (<A HREF='byond://?_src_=holder;adminplayerobservecoodjump=1;X=[src.x];Y=[src.y];Z=[src.z]'>JMP</a>)")

		//thrown weapon embedded object code.
		if(dtype == BRUTE && istype(O,/obj/item))
			var/obj/item/I = O
			if (!I.is_robot_module())
				var/sharp = is_sharp(I)
				var/damage = throw_damage
				if (armor)
					damage /= armor+1

				//blunt objects should really not be embedding in things unless a huge amount of force is involved
				var/embed_chance = sharp? damage/I.w_class : damage/(I.w_class*3)
				var/embed_threshold = sharp? 5*I.w_class : 15*I.w_class

				//Sharp objects will always embed if they do enough damage.
				//Thrown sharp objects have some momentum already and have a small chance to embed even if the damage is below the threshold
				if(istype(I, /obj/item/fragment) || (sharp && prob(damage/(10*I.w_class)*100)) || (damage > embed_threshold && prob(embed_chance)))
					affecting.embed(I)
					if(istype(I, /obj/item/fragment))
						var/som = pick('sound/projectilesnew/blt_flesh1.ogg', 'sound/projectilesnew/blt_flesh2.ogg', 'sound/projectilesnew/blt_flesh3.ogg')
						playsound(I.loc, som, 50, 1)
				var/mob/living/carbon/human/M = O.thrower

				if(I.sharp && prob(I.force*17 + M.my_stats.get_stat(STAT_ST) + M.my_skills.get_skill(SKILL_MELEE) - src.my_stats.get_stat(STAT_HT)) && !(affecting.status & ORGAN_ARTERY) && prob(affecting.artery_prob))
					affecting.sever_artery()
					if(affecting.artery_name == "carotid artery")
						src.visible_message("<span class='danger'>[M] slices [src]'s throat!</span>")
					else
						src.visible_message("<span class='danger'>[M] slices open [src]'s [affecting.artery_name] artery!</span>")
				if(I.sharp && prob(I.force*17 + M.my_stats.get_stat(STAT_ST) + M.my_skills.get_skill(SKILL_MELEE) - src.my_stats.get_stat(STAT_HT)) && prob(20))
					if(affecting.hasVocal && !affecting.VocalTorn)
						src.visible_message("<span class='hitbold'>[M] slices [src]'s vocal chords!</span>")
						affecting.VocalTorn = TRUE

		// Begin BS12 momentum-transfer code.
		if(O.throw_source && speed >= 15)
			var/obj/item/W = O
			var/momentum = speed/2
			var/dir = get_dir(O.throw_source, src)

			visible_message("<span class='hitbold'>[src]</span> <span class='hit'staggers under the impact!</span> ","<span class='crithit'>You stagger under the impact!</span> ")
			src.throw_at(get_edge_target_turf(src,dir),1,momentum)

			if(!W || !src) return

			if(W.loc == src && W.sharp) //Projectile is embedded and suitable for pinning.
				var/turf/T = near_wall(dir,2)

				if(T)
					src.loc = T
					visible_message("<span class='hitbold'>[src]</span> <span class='hit'>is pinned to the wall by</span> <span class='hitbold'>[O]!</span> ","<span class='hit'>You are pinned to the wall by</span> <span class='hitbold'>[O]!</span> ")
					src.anchored = 1
					src.pinned += O


/mob/living/carbon/human/proc/bloody_hands(var/mob/living/source, var/amount = 2)
	if(istype(src?.species, /datum/species/human/alien))
		return
	if (gloves)
		gloves.add_blood(source)
		gloves:transfer_blood = amount
		gloves:bloody_hands_mob = source
	else
		add_blood(source)
		bloody_hands = amount
		bloody_hands_mob = source
	update_inv_gloves()		//updates on-mob overlays for bloody hands and/or bloody gloves

/mob/living/carbon/human/proc/bloody_body(var/mob/living/source)
	if(wear_suit)
		wear_suit.add_blood(source)
		update_inv_wear_suit(0)
	if(w_uniform)
		w_uniform.add_blood(source)
		update_inv_w_uniform(0)

/mob/living/carbon/human/proc/handle_suit_punctures(var/damtype, var/damage)

	if(!wear_suit) return
	if(!istype(wear_suit,/obj/item/clothing/suit/space)) return
	if(damtype != BURN && damtype != BRUTE) return

	var/obj/item/clothing/suit/space/SS = wear_suit
	var/penetrated_dam = max(0,(damage - SS.breach_threshold)) // - SS.damage)) - Consider uncommenting this if suits seem too hardy on dev.

	if(penetrated_dam) SS.create_breaches(damtype, penetrated_dam)

/mob/living/carbon/human/steal_act(var/mob/living/carbon/human/user)
	if(!..())
		return

	if(user == src)//nao da pra se roubar
		return

	if(user.get_active_hand() != null) //nao da pra roubar com a mão cheia
		return
	if(src.combat_mode)
		to_chat(user, "<span class='combatbold'>[pick(fnord)] They're aware!</span>")
		return

	var/hit_zone = user.zone_sel.selecting

	var/datum/organ/external/affecting = get_organ(ran_zone(user.zone_sel.selecting))
	if(!affecting || affecting == ORGAN_DESTROYED)
		to_chat(user, "<span class='badstate'>⠀⠀They are missing that limb!</span>")
		return

	if(user.vice == "Kleptomaniac")
		user.clear_event("vice")
		user.viceneed = 0
	var/list/rolled = roll3d6(user,SKILL_STEAL,null)
	var/obj/whatwillitsteal = null
	var/slot_it_will_go = null
	switch(rolled[GP_RESULT])
		if(GP_CRITFAIL)
			user.visible_message("<span class='bname'>CRITICAL FAILURE! [user]</span><span class='baron'> tries to steal from </span><span class='bname'>[src]</span> and trips!")
			user.Weaken(rand(1,5))
			return
		if(GP_FAIL)
			user.visible_message("<span class='bname'>[user]</span><span class='baron'> tries to steal from </span><span class='bname'>[src]</span>!")
			return

	switch(hit_zone)
		if("chest")
			if(src.r_store)
				whatwillitsteal = src.r_store
				slot_it_will_go = r_store
			else
				if(src.l_store)
					whatwillitsteal = src.l_store
					slot_it_will_go = l_store
				else
					to_chat(user, "[pick(fnord)] There is nothing left in the pockets!")
					return
		if("vitals" || "groin")
			if(src.belt)
				whatwillitsteal = src.belt
				slot_it_will_go = belt
			else
				if(src.s_store)
					whatwillitsteal = src.s_store
					slot_it_will_go = s_store
				else
					to_chat(user, "[pick(fnord)] There is nothing left in the belt!")
					return
		if("l_hand" || "r_hand")
			if(!src.gloves)
				whatwillitsteal = src.wear_id
				slot_it_will_go = slot_wear_id
			else
				to_chat(user, "[pick(fnord)] They're wearing gloves!")
				return
	if(whatwillitsteal)
		var/obj/item/stolen/S = new(src)
		S.icon = whatwillitsteal.icon
		S.icon_state = whatwillitsteal.icon_state
		S.name = whatwillitsteal.name
		S.desc = whatwillitsteal.desc
		src.u_equip(whatwillitsteal)
		user.put_in_active_hand(whatwillitsteal)
		src.equip_to_slot(S, slot_it_will_go)
		to_chat(user, "<span class='bname'>I managed to steal the [S.name]!</span>")

/obj/item/stolen
	name = "none"
	desc = "none"

/obj/item/stolen/attack_hand(mob/user as mob)
	. = ..()
	to_chat(user, "<span class='malfunction'>IT'S NOT HERE, STOLEN!</span>")
	user << 'sound/lfwbsounds/stolen.ogg'
	qdel(src)