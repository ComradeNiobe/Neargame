/obj/item
	var/arterychance = 0
	var/statDependent = TRUE
	var/ignoreArmor = FALSE

/obj/item/melee/energy/sword
	statDependent = FALSE
	ignoreArmor = TRUE

/mob/living/carbon/human/proc/attacked_by(var/obj/item/I, var/mob/living/carbon/human/attacker, var/def_zone)
	var/mob/living/carbon/human/victim = src
	if(!I || !attacker) return
	if(attacker.consyte) return
	if(attacker.lifeweb_locked) return

	var/hit_modifier_skill = miss_chance_check_melee(attacker)
	var/hit_modifier_weapon = I.accuracy
	var/hit_modifier_specialty = specialty_check(attacker, I)
	var/hit_modifier_src = miss_chance_last_src(src)
	var/hit_modifier_attacker = miss_chance_last_attacker(attacker)


	var/miss_chance_mod = hit_modifier_skill + hit_modifier_weapon + hit_modifier_specialty + hit_modifier_src + hit_modifier_attacker
	var/target_zone = get_zone_with_miss_chance_new(attacker.zone_sel.selecting, src, miss_chance_mod)

	if(src == attacker)
		target_zone = attacker.zone_sel.selecting

	var/datum/organ/external/maybeSpecialPart = get_organ(target_zone, 0)
	var/datum/organ/external/affecting = get_organ(target_zone)


	if(!affecting) return
	if(affecting.status & ORGAN_DESTROYED)
		to_chat(src, "<b> They are missing that limb!</b>")
		return

	var/dmgTXT = null
	var/display_name = affecting.display_name

	if(!target_zone)
		playsound(loc, I.swing_sound, 100, 1)
		visible_message("<span class='hitbold'>[attacker]</span> <span class='hit'>misses trying to attack [src]'s [display_name] with the [I]!</span>")
		return

	if(is_it_high(attacker))
		playsound(loc, I.swing_sound, 100, 1)
		visible_message("<span class='hitbold'>[attacker]</span> <span class='hit'>misses trying to reach [src]'s [display_name] with the [I]!</span>")
		to_chat(src, "<b>Too high!</b>")
		return

	if(attempt_dodge(src, attacker))
		playsound(loc, I.swing_sound, 100, 1)
		visible_message("<span class='hitbold'>[attacker]</span> <span class='hit'>misses trying to attack [src]'s [display_name] with his [capitalize(I.name)]!</span>")
		src.do_dodge()
		return

	if(attempt_parry(src, attacker, I.force))
		playsound(loc, I.swing_sound, 100, 1)
		visible_message("<span class='hitbold'>[attacker]</span> <span class='hit'>[I.attack_verb.len ? pick(I.attack_verb) : "attack"] [src]'s [display_name] with his [capitalize(I.name)]!</span>")
		do_parry(src, attacker)
		return


	if(I.attack_verb.len)
		dmgTXT += "<span class='hitbold'>[attacker]</span> <span class='hit'>[pick(I.attack_verb)] [src]'s [display_name] with [capitalize(I.name)]!</span> "

	else
		dmgTXT += "<span class='hitbold'>[attacker]</span> <span class='hit'>attacks [src]'s [display_name] with [capitalize(I.name)]!</span> "

	if(I.swing_sound) playsound(src, I.swing_sound, 100, 1)

	if(!I.force) return
	var/isBlunt = 0
	if(!I.sharp && !I.edge)
		isBlunt = 1

	var/armor = run_armor_check(affecting.name, "melee", I)

	if(armor == ARMOR_BLOCKED && !I.ignoreArmor)
		dmgTXT += "<span class='hit'>Armor stops the damage.</span> "
		attacker.visible_message(dmgTXT)
		I.damageItem("MEDIUM")
		I.damageSharp("MEDIUM")
		return

	var/damage = I.statDependent ? I.getNewWeaponForce(attacker.my_stats.get_stat(STAT_ST), victim.my_stats.get_stat(STAT_HT)) : I.force

	if(armor == ARMOR_SOFTEN)
		dmgTXT += "<span class='hit'>Armor softens the damage.</span> "
		I.sharp = 0
		I.damageItem("SOFT")
		I.damageSharp("SOFT")
		var/armadura = getarmor(affecting.name, "melee")
		damage = max(0, damage - armadura) // podia ter usado /= mas isso e estranho
		if(damage == 0)
			dmgTXT += "<span class='hit'>No damage has been dealt.</span> "

	if(I.sharp && I.sharpness)
		damage = (damage*I.sharpness)/100

	apply_damage(damage, I.damtype, affecting, armor, sharp=I.sharp, edge=I.edge, used_weapon = I, specialAttack = maybeSpecialPart)

	if(I.poisoned.len)
		for(var/list/L in I.poisoned)
			reagents.add_reagent(L[1], L[2])
		I.poisoned = list()

	if(I.damtype == BRUTE && I.sharp || I.damtype == BRUTE && I.edge)
		I.add_blood(src)
		attacker.update_inv_r_hand()
		attacker.update_inv_l_hand()

	if (I.hitsound)
		playsound(src, I.hitsound, 100, 1)

	I.damageItem("SOFT")
	I.damageSharp("SOFT")

	var/weakenProb = 0

	if(!src.combat_mode)
		weakenProb += 30
	if(src.combat_mode)
		weakenProb -= 35
	if(armor == ARMOR_SOFTEN)
		weakenProb -= 60
	if(attacker in src?.hidden_mobs)
		weakenProb += 60

	if(display_name == "head" || display_name == "mouth" || display_name == "face")
		if(I.sharp && armor != ARMOR_SOFTEN || I.edge && armor != ARMOR_SOFTEN || affecting.status & ORGAN_BLEEDING)
			if(wear_mask)
				wear_mask.add_blood(src)
				update_inv_wear_mask(0)
			if(head)
				head.add_blood(src)
				update_inv_head(0)
			if(glasses && prob(33))
				glasses.add_blood(src)
				update_inv_glasses(0)
		if(attacker in src?.hidden_mobs && prob(weakenProb) && armor != ARMOR_SOFTEN && damage > 8 && I.damtype == BRUTE)
			var/randa = rand(1,2)
			if(randa == 1)
				apply_effect(13, PARALYZE, armor)
				dmgTXT += "<span class='combatbold'>[src] has been knocked unconscious!</span> "
				src.ear_deaf = max(src.ear_deaf,6)
			if(randa == 2)
				apply_effect(13, WEAKEN, armor)
				dmgTXT += "<span class='combatbold'>[src] has been weakened!</span> "
				src.ear_deaf = max(src.ear_deaf,6)

	if(display_name == "chest" || display_name == "groin" || display_name == "vitals")
		if(I.sharp && armor != ARMOR_SOFTEN || I.edge && armor != ARMOR_SOFTEN || affecting.status & ORGAN_BLEEDING)
			bloody_body(src)

	if(src.gender == MALE && attacker.gender == FEMALE || src.gender == FEMALE && attacker.gender == MALE)
		if(src.has_vice("Masochist"))
			src.viceneed = 0


	if(attacker.my_stats.get_stat(STAT_ST) >= my_stats.get_stat(STAT_HT)+4 && !lying && isBlunt && damage > 8)
		Weaken(1)
		var/turf/target = get_turf(src.loc)
		var/range = src.throw_range
		var/throw_dir = get_dir(attacker, src)
		for(var/i = 1; i < range; i++)
			var/turf/new_turf = get_step(target, throw_dir)
			target = new_turf
			if(new_turf.density)
				break
		src.throw_at(target, rand(2,4), src.throw_speed)

	update_transform()
	update_canmove()

	if (I.damtype == BRUTE)
		//blunt objects should really not be embedding in things unless a huge amount of force is involved
		var/embed_chance = I.edge ? (damage/I.w_class)/2 : damage/(I.w_class*3)
		var/embed_threshold = I.edge ? 10*I.w_class : 20*I.w_class

		//Sharp objects will always embed if they do enough damage.
		if((I.edge && damage > (10*I.w_class)) || (damage > embed_threshold && prob(embed_chance)))
			if(prob(2))
				affecting.embed(I)

	dmgTXT += affecting.get_actions()

	attacker.visible_message(dmgTXT)

	if(victim?.isVampire && I.silver)
		if(armor == ARMOR_SOFTEN)
			return
		else
			victim.Weaken(4)
			victim.apply_damage(damage*1.5, BRUTE, affecting)
			flash_pain()
			victim.rotate_plane(1)
			if(prob(40))
				victim.vessel.remove_reagent("blood",25)
			if(prob(50))
				victim.emote("SCREECHES in pain!")
				playsound(victim.loc, pick('sound/effects/vamphit1.ogg', 'sound/effects/vamphit2.ogg', 'sound/effects/vamphit3.ogg'), 75, 0, -1)
				if(!victim.ExposedFang)
					playsound(victim.loc, ('sound/effects/fangs1.ogg'), 50, 0, -1)
					victim.visible_message("<span class='combatbold'>[victim]</span> <span class='combat'>exposes fangs!</span>")
					victim.ExposedFang = TRUE
					victim.update_body()

	return 1

/mob/living/carbon/human/kick_act(var/mob/living/carbon/human/user)
	if(!..()) return
	if(user == src) return
	for(var/obj/item/grab/G in usr.grabbed_by)
		if (G.state >= 2) return

	if(istype(user?.species, /datum/species/human/alien))
		var/obj/item/claymore/rapier/xeno/X = new
		user.contents += X
		src.attacked_by(X, user, user.zone_sel.selecting)
		user.contents -= X
		qdel(X)
		return

	if(istype(user.buckled,/obj/structure/stool/bed/chair/comfy/torture)) return to_chat(usr,"<span class='combat'>[pick(fnord)] I can't move my legs!</span>")
	if(user.grabbed_by.len)
		for(var/x = 1; x <= user.grabbed_by.len; x++)
			if(user.grabbed_by[x])
				if(istype(user.grabbed_by[x], /obj/item/grab))
					var/obj/item/grab/G = user.grabbed_by[x]

					if(G.aforgan.display_name == "r_leg" || G.aforgan.display_name == "l_leg" || G.aforgan.display_name == "r_foot" || G.aforgan.display_name == "l_foot")
						to_chat(user, "<span class='combatbold'>Something is holding your leg!</span>")
						return
	if(user.consyte) return vomit()

	var/target_zone = get_zone_with_miss_chance_new(user.zone_sel.selecting, src, null)
	var/datum/organ/external/affecting = get_organ(target_zone)
	var/display_name = affecting.display_name

	if(!affecting || affecting.status & ORGAN_DESTROYED) return to_chat(user, "<span class='hit'>They are missing that limb!</span>")

	if(is_it_high(user))
		playsound(loc, 'sound/weapons/punchmiss.ogg', 50, 1)
		visible_message("<span class='hitbold'>[user]</span> <span class='hit'>misses trying to reach [src]'s [display_name] with his foot!</span>")
		to_chat(src, "<b>Too high!</b>")
		return

	var/dmgTXT = "<span class='hitbold'>[user]</span> <span class='hit'>kicks [src]'s [display_name] with his foot!</span> "

	var/armor = run_armor_check(affecting.name, "melee", null, "PUNCH")

	if(armor == ARMOR_BLOCKED)
		dmgTXT += "<span class='hit'>Armor stops the damage.</span> "
		user.visible_message(dmgTXT)
		return

	if(attempt_dodge(src, user))
		playsound(loc, 'sound/weapons/punchmiss.ogg', 100, 1)//play a sound
		visible_message("<span class='hitbold'>[user]</span> <span class='hit'>misses trying to kick [src]'s [display_name] with his foot!</span>")
		src.do_dodge()
		return

	if(attempt_parry(src, user, strToDamageModifier(user.my_stats.get_stat(STAT_ST), src.my_stats.get_stat(STAT_HT))))
		playsound(loc, 'sound/weapons/punchmiss.ogg', 100, 1)//play a sound
		visible_message("<span class='hitbold'>[user]</span> <span class='hit'>kicks [src]'s [display_name] with his foot!</span>")
		do_parry(src, user)
		return

	var/list/kickRoll = roll3d6(user,SKILL_UNARM,null)

	var/kickdam = rand(0,4)
	kickdam += strToDamageModifier(user.my_stats.get_stat(STAT_ST), my_stats.get_stat(STAT_HT))
	if(user.special == "proficientkicker")
		kickdam += rand(15,30)
		user.adjustStaminaLoss(rand(5,10))
	else
		user.adjustStaminaLoss(rand(8,12))

	switch(kickRoll[GP_RESULT])
		if(GP_FAIL)
			if(src.handcuffed)
				var/list/kickRollCuff = roll3d6(user,SKILL_UNARM,null)
				switch(kickRollCuff[GP_RESULT])
					if(GP_FAIL || GP_CRITFAIL)
						playsound(loc, 'sound/weapons/punchmiss.ogg', 50, 1)
						visible_message("<span class='crithit'>CRITICAL FAILURE!</span> <span class='hitbold'>[user]</span> <span class='hit'>loses their balance!</span>")
						user.resting = 1
						user.Weaken(6)
						return
			else
				user.visible_message("<span class='hitbold'>[user]</span> <span class='hit'>misses trying to kick [src] in the [display_name]!</span> ")
				playsound(loc, 'sound/weapons/punchmiss.ogg', 50, 1)
				return
		if(GP_CRITFAIL)
			playsound(loc, 'sound/weapons/punchmiss.ogg', 50, 1)
			visible_message("<span class='crithit'>CRITICAL FAILURE!</span> <span class='hitbold'>[user]</span> <span class='hit'>loses their balance!</span>")
			user.resting = 1
			user.Weaken(6)
			return
		if(GP_SUCCESS)
			kickdam += strToDamageModifier(user.my_stats.get_stat(STAT_ST), my_stats.get_stat(STAT_HT))/2
		if(GP_CRITSUCCESS)
			kickdam += strToDamageModifier(user.my_stats.get_stat(STAT_ST), my_stats.get_stat(STAT_HT))

	if(user.my_stats.get_stat(STAT_ST) >= src.my_stats.get_stat(STAT_HT)+4)
		var/difference = user.my_stats.get_stat(STAT_ST) - src.my_stats.get_stat(STAT_HT)+4
		var/turf/target = get_turf(src.loc)
		var/range = src.throw_range
		var/throw_dir = get_dir(user, src)
		for(var/i = 1; i < range; i++)
			var/turf/new_turf = get_step(target, throw_dir)
			target = new_turf
			if(new_turf.density)
				break
		src.throw_at(target, difference, src.throw_speed)

	else if(user.special == "proficientkicker")
		var/turf/target = get_turf(src.loc)
		var/range = src.throw_range
		var/throw_dir = get_dir(user, src)
		for(var/i = 1; i < range; i++)
			var/turf/new_turf = get_step(target, throw_dir)
			target = new_turf
			if(new_turf.density)
				break
		if(prob(80))
			src.throw_at(target, rand(3,5), src.throw_speed)

	playsound(user.loc, 'sound/effects/kick1.ogg', 50, 0)

	if(armor == ARMOR_SOFTEN)
		dmgTXT += "<span class='hit'>Armor softens the damage.</span> "
		var/armadura = getarmor(affecting.name, "melee")
		kickdam = max(0, kickdam - armadura) // podia ter usado /= mas isso e estranho
		if(kickdam == 0)
			dmgTXT += "<span class='hit'>No damage has been dealt.</span> "

	apply_damage(kickdam, BRUTE, target_zone, armor)

	dmgTXT += affecting.get_actions()

	user.visible_message(dmgTXT)

/mob/living/carbon/human/bite_act(var/mob/living/carbon/human/user)
	if(!..()) return
	if(user == src) return
	if(user.restrained()) return


	if(istype(user?.species, /datum/species/human/alien))
		var/hit_zone = user.zone_sel.selecting
		var/datum/organ/external/affecting = get_organ(ran_zone(hit_zone))
		var/obj/item/claymore/rapier/xeno/X = new
		user.contents += X
		var/armor = run_armor_check(affecting.name, "melee", X)
		user.contents -= X
		qdel(X)
		if(armor == ARMOR_BLOCKED) return
		src.apply_damage(45, BRUTE, affecting)
		user.visible_message("<span class='hitbold'>[user.name]</span> <span class='hit'>bites [src] in the [affecting.display_name] with its extended mouth!</span> ")
		playsound(user.loc, pick('sound/webbers/alien_harm.ogg', 'sound/webbers/alien_harm2.ogg', 'sound/webbers/alien_harm3.ogg'), 50, 1)
		if(affecting.name == "vitals" && src.resting)
			var/obj/item/reagent_containers/food/snacks/organ/O = pick(organ_storage.contents)
			O.connected = FALSE
			coisa(O, O.owner, 0)
			if(O.organ_data.vital)
				O.owner.death()
			var/datum/organ/external/chest = get_organ("chest")
			chest.dissected = 1
			affecting.dissected = 1
			src.update_surgery(1)
			user.visible_message("<span class='hitbold'>[user.name]</span> <span class='hit'>consumes [src]'s [O.name]!</span> ")
			src.emote("agonydeath")
			playsound(user.loc, 'sound/webbers/fangs_flesh.ogg', 50, 1)
			return

	if(user.grabbed_by.len)
		for(var/x = 1; x <= user.grabbed_by.len; x++)
			if(user.grabbed_by[x])
				if(istype(user.grabbed_by[x], /obj/item/grab))
					var/obj/item/grab/G = user.grabbed_by[x]
					if(G.aforgan.display_name == "mouth")
						to_chat(user, "<span class='combatbold'>Something is holding your mouth!</span>")
						return

	if(user.consyte) return user.vomit()
	if(user.wear_mask) return to_chat(src, "<span class='combatbold'>I'm wearing a mask!</span>")

	if(istype(user.head, /obj/item/clothing/head/blackbag))
		var/obj/item/clothing/head/helm = user.head
		if(helm.body_parts_covered & MOUTH)
			to_chat(user, "I can't bite with something blocking my mouth!")

	var/target_zone = get_zone_with_miss_chance_new(user.zone_sel.selecting, src, null)
	var/datum/organ/external/affecting = get_organ(target_zone)
	var/display_name = affecting.display_name

	if(!affecting || affecting.status & ORGAN_DESTROYED) return to_chat(user, "<span class='hit'>They are missing that limb!</span>")

	var/armor = run_armor_check(affecting.name, "melee", null, "PUNCH")
	var/dmgTXT = "<span class='hitbold'>[user.name]</span> <span class='hit'>bites [src] in the [display_name]!</span> "
	if(armor == ARMOR_BLOCKED)
		dmgTXT += "<span class='hit'>Armor stops the damage.</span> "
		user.visible_message(dmgTXT)
		return

	if(attempt_dodge(src, user))
		playsound(loc, 'sound/weapons/punchmiss.ogg', 100, 1)//play a sound
		visible_message("<span class='hitbold'>[user]</span> <span class='hit'>misses trying to kick [src]'s [display_name] with his foot!</span>")
		src.do_dodge()
		return

	if(attempt_parry(src, user, strToDamageModifier(user.my_stats.get_stat(STAT_ST), src.my_stats.get_stat(STAT_HT))))
		playsound(loc, 'sound/weapons/punchmiss.ogg', 100, 1)//play a sound
		visible_message("<span class='hitbold'>[user]</span> <span class='hit'>kicks [src]'s [display_name] with his foot!</span>")
		do_parry(src, user)
		return

	var/bitedam = rand(0,2)
	bitedam += strToDamageModifier(user.my_stats.get_stat(STAT_ST), src.my_stats.get_stat(STAT_HT))
	user.adjustStaminaLoss(rand(2,4))

	var/list/failRoll = roll3d6(user,SKILL_UNARM,null)
	switch(failRoll[GP_RESULT])
		if(GP_FAIL)
			user.visible_message("<span class=hitbold>[user]</span> <span class='hit'>tries to bite [src] in the [display_name], but misses!</span> ")
			playsound(loc, 'sound/weapons/punchmiss.ogg', 50, 1)
			return
		if(GP_CRITFAIL)
			playsound(loc, 'sound/weapons/punchmiss.ogg', 50, 1)
			visible_message("<span class='crithit'>CRITICAL FAILURE!</span> <span class='hitbold'>[user]</span> <span class='hit'>loses their balance!</span> ")
			user.resting = 1
			return

	if(user.species.name == "Zombie")
		if(prob(30) && !zombieimmune)
			zombie_infect()

	if(user.isVampire && user.ExposedFang && armor != ARMOR_BLOCKED)
		playsound(user.loc, 'sound/webbers/fangs_flesh.ogg', 50, 1)
	else
		playsound(user.loc, 'sound/weapons/bite.ogg', 50, 1)
		src.emote("agonymoan")
		apply_damage(rand(4,12), BRUTE, target_zone, armor, sharp=TRUE)

	if(user.ExposedFang && user.isVampire)
		if(vampirebit == TRUE && src.vessel.total_volume > 0)
			visible_message("<span class='hitbold'>[user]</span><span class='hit'> drinks [src]'s blood.</span> " )
			src.vessel.remove_reagent("blood", 40)
			user.vessel.add_reagent("blood",40)
			playsound(user.loc, 'sound/effects/bloodsuck.ogg', 20, 1)
			src.druggy += 200
			src.add_event("sin", /datum/happiness_event/misc/better)
			src.emote("agonymoan")
			src.Stun(10)
			return
		else
			apply_damage(5, BRUTE, target_zone, armor, sharp=TRUE)
			vampirebit = TRUE

	if(armor == ARMOR_SOFTEN)
		dmgTXT += "<span class='hit'>Armor softens the damage.</span> "
		var/armadura = getarmor(affecting.name, "melee")
		bitedam = max(0, bitedam - armadura) // podia ter usado /= mas isso e estranho
		if(bitedam == 0)
			dmgTXT += "<span class='hit'>No damage has been dealt.</span> "

	apply_damage(bitedam, BRUTE, target_zone, armor)
	if(user.ExposedFang)
		playsound(user.loc, 'sound/webbers/fangs_flesh.ogg', 35, 1)
	else
		playsound(user.loc, 'sound/weapons/bite.ogg', 50, 1)
	if(affecting.name == "head" && affecting.brute_dam > affecting.min_broken_damage && iszombie(user))
		var/datum/organ/external/head/O = affecting
		O.breakskull()
		user.rejuvenate()

	dmgTXT += affecting.get_actions()
	user.visible_message(dmgTXT)