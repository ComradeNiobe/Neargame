//Restores our verbs. It will only restore verbs allowed during lesser (monkey) form if we are not human
/mob/proc/make_changeling()
	if(!mind)				return
	if(!mind.changeling)	mind.changeling = new /datum/changeling(gender)

	var/mob/living/carbon/human/H = src
	if(ishuman(src))
		H.my_skills.change_skill(SKILL_CLIMB, 10)
		H.terriblethings = TRUE

	if(!length(powerinstances))
		for(var/P in powers)
			powerinstances += new P()

	// Code to auto-purchase free powers.
	for(var/datum/power/changeling/P in powerinstances)
		if(!(P in mind.changeling.purchasedpowers)) // Do we not have it already?
			mind.changeling.purchasePower(mind, P.name, 0)// Purchase it. Don't remake our verbs, we're doing it after this.

	for(var/datum/power/changeling/P in mind.changeling.purchasedpowers)
		if(P.isVerb)
			if(!(P in src.verbs))
				src.verbs += P.verbpath
	mind.changeling.absorbed_dna |= dna
	return 1

//removes our changeling verbs
/mob/proc/remove_changeling_powers()
	if(!mind || !mind.changeling)	return
	for(var/datum/power/changeling/P in mind.changeling.purchasedpowers)
		if(P.isVerb)
			verbs -= P.verbpath


//Helper proc. Does all the checks and stuff for us to avoid copypasta
/mob/proc/changeling_power(required_chems=0, required_dna=0, max_genetic_damage=100, max_stat=0)

	if(!src.mind)		return
	if(!iscarbon(src))	return

	var/datum/changeling/changeling = src.mind.changeling
	if(!changeling)
		world.log << "[src] has the changeling_transform() verb but is not a changeling."
		return

	if(src.stat > max_stat)
		to_chat(src, "<span class='warning'>We are incapacitated.</span>")
		return

	if(length(changeling.absorbed_dna) < required_dna)
		src << "<span class='warning'>We require at least [required_dna] samples of compatible DNA.</span>"
		return

	if(changeling.chem_charges < required_chems)
		src << "<span class='warning'>We require at least [required_chems] units of chemicals to do that!</span>"
		return

	if(changeling.geneticdamage > max_genetic_damage)
		to_chat(src, "<span class='warning'>Our geneomes are still reassembling. We need time to recover first.</span>")
		return

	return changeling

//Absorbs the victim's DNA making them uncloneable. Requires a strong grip on the victim.
//Doesn't cost anything as it's the most basic ability.
/mob/proc/changeling_absorb_dna()
	set category = "villain"
	set name = "Assimilate"
	set desc = "Assimilate"

	var/datum/changeling/changeling = changeling_power(0,0,100)
	if(!changeling)	return

	var/obj/item/grab/G = src.get_active_hand()
	if(!istype(G))
		to_chat(src, "<span class='warning'>We must be grabbing a creature in our active hand to transform them.</span>")
		return

	var/mob/living/carbon/human/T = G.affecting
	if(!istype(T) || ismonster(T) || iszombie(T) || T.isVampire)
		to_chat(src, "<span class='warning'>This inferior creature doesn't have much chances to survive the morph.</span>")
		src.visible_message(SPAN_WARNING("[src] quickly stops morphing [T], pulling a proboscis back!"))
		return

	if(is_they(T))
		to_chat(src, "<span class='warning'>[T] is a fellow appendage.</span>")
		return

	if(T.stat == DEAD)
		to_chat(src, "<span class='warning'>We must be grabbing a LIVING creature in our active hand to transform them</span>")
		return

	if(!G.state == GRAB_KILL)
		to_chat(src, "<span class='warning'>We must have a tighter grip to absorb this creature.</span>")
		return

	if(tentaclesexposed == FALSE)
		to_chat(src, "<span class='warning'>My tentacles need to be exposed.</span>")
		return

	if(changeling.isabsorbing)
		to_chat(src, "<span class='warning'>We are already morphing.</span>")
		return

	for(var/obj/O in T.contents)
		if(istype(O, /obj/item/reagent_containers/food/snacks/organ))
			continue
		else if(istype(O, /obj/item/storage/touchable/organ))
			continue
		else
			to_chat(src, SPAN_WARNING("The creature needs to be fully naked."))
			return

	changeling.isabsorbing = 1
	for(var/stage = 1, stage<=3, stage++)
		switch(stage)
			if(1)
				playsound(src.loc, 'sound/effects/changeling_walk.ogg', 20, 0, -1)
				to_chat(src, "<span class='notice'>This creature is compatible. We must hold still.</span>")
			if(2)
				playsound(src.loc, 'sound/effects/changeling_hunt.ogg', 20, 0, -1)
				to_chat(src, "<span class='notice'>We extend a proboscis.</span>")
				src.visible_message("<span class='warning'>[src] extends a proboscis!</span>")
			if(3)
				playsound(src.loc, 'sound/effects/stabchang.ogg', 20, 0, -1)
				to_chat(src, "<span class='notice'>We stab [T] with the proboscis.</span>")
				src.visible_message("<span class='danger'>[src] stabs [T] with the proboscis!</span>")
				to_chat(T, "<span class='danger'>You feel a sharp stabbing pain!</span>")
				var/datum/organ/external/affecting = T.get_organ(src.zone_sel.selecting)
				if(affecting.take_damage(39,0,1,"large organic needle"))
					T:UpdateDamageIcon()
					continue

		if(!do_mob(src, T, 140))
			to_chat(src, "<span class='warning'>Our assimilation of [T] has been interrupted!</span>")
			changeling.isabsorbing = 0
			return

	to_chat(src, "<span class='notice'>[T] has been assimilated.</span>")
	playsound(src.loc, pick('sound/effects/changeling_suck1.ogg','sound/effects/changeling_suck2.ogg','sound/effects/changeling_suck3.ogg'), 50, 0, -1)
	src.visible_message("<span class='danger'>[src] assimilates [T]!</span>")
	to_chat(T, "<span class='danger'>You feel an alien influence overtaking your senses!</span>")

	ticker.mode.absorbedcount++
	changeling.isabsorbing = 0

	T.TheyCage()
	playsound(T, 'sound/lfwbsounds/they_absorb.ogg', 100, 1)
	qdel(G)
	return 1

/mob/living/carbon/human/proc/TheyCage()
	var/obj/structure/theycage/cage = new(src)

	sleeping = 900
	if(client)
		client.perspective = EYE_PERSPECTIVE
		client.eye = cage
	forceMove(cage)

/obj/structure/theycage
	name = "Meat"
	icon = 'icons/monsters/critter.dmi'
	icon_state = "floater"
	var/mob/living/carbon/human/caged_human

/obj/structure/theycage/New(mob/living/carbon/human/M)
	. = ..()
	caged_human = M
	addtimer(CALLBACK(src, PROC_REF(they_transformation), caged_human), 60 SECONDS)

/obj/structure/theycage/proc/they_transformation(mob/living/carbon/human/caged_human)
	visible_message("<span class='warning'>[src] begins to shake!</span>")
	icon_state = "floaterx"

	if(caged_human.client)
		caged_human.client.eye = caged_human.client.mob
		caged_human.client.perspective = MOB_PERSPECTIVE
	caged_human.dropInto(loc)

	caged_human.mind.make_They()
	caged_human.updateStatPanel()

	caged_human.sleeping = 0

	caged_human.update_icons()
	caged_human.update_body()

	log_game("[key_name(caged_human)] is now a THEY (spawned from theycage).")

	icon_state = "floater2"
	density = 0
	caged_human = null

//Change our DNA to that of somebody we've absorbed.
/mob/proc/extend_tentacles()
	set category = "villain"
	set name = "ExtendTentacles"
	set desc = "Extend Tentacles"
	var/mob/living/carbon/human/H = src
	if(!H?.mind?.changeling)
		return
	if(H.tentaclesexposed == TRUE)
		playsound(H.loc, 'sound/effects/changeling_hunt.ogg', 50, 0, -1)
		H.visible_message("<span class='warning'>[H] hides tentacles!</span>")
		H.tentaclesexposed = FALSE
		H.status_flags &= ~STATUS_NO_PAIN
		H.my_stats.change_stat(STAT_ST , -1)
		H.my_stats.change_stat(STAT_DX , -3)
		H.overlays_standing[2] = null
		var/image/standing = null
		H.overlays_standing[2] = standing
		H.update_icons()
		return
	else
		playsound(H.loc, 'sound/effects/changeling_walk.ogg', 50, 0, -1)
		H.visible_message("<span class='warning'>[H] exposes tentacles!</span>")
		H.tentaclesexposed = TRUE
		H.status_flags |= STATUS_NO_PAIN
		H.my_stats.change_stat(STAT_ST , 1)
		H.my_stats.change_stat(STAT_DX , 3)
		H.overlays_standing[2] = null
		var/image/standing = overlay_image('icons/mob/mob.dmi', "theytentacle")
		if(H?.my_stats?.get_stat(STAT_ST) > 10)
			standing = overlay_image('icons/mob/mob.dmi', "3floater")
		else
			if(H.gender == FEMALE)
				standing = overlay_image('icons/mob/mob.dmi', "1floater")
			else
				standing = overlay_image('icons/mob/mob.dmi', "2floater")
		H.overlays_standing[2] = standing
		H.update_icons()
		return

/mob/proc/changhunt()
	set category = "villain"
	set name = "Hunt"
	set desc = "Hunt"
	if(!ishuman(src)) return
	var/mob/living/carbon/human/H = src
	if(H.ishunting)
		playsound(H.loc, 'sound/effects/changeling_walk.ogg', 50, 0, 1)
		sight |= SEE_MOBS
		H.ishunting = 0
	else
		playsound(H.loc, 'sound/effects/changeling_walk.ogg', 50, 0, 1)
		sight &= ~SEE_MOBS
		H.ishunting = 1

/mob/proc/infestweb()
	set category = "villain"
	set name = "infest"
	set desc = "Infest the Lifeweb"
	if(!ishuman(src)) return
	var/mob/living/carbon/human/H = src
	if(ticker.mode.absorbedcount >= 3)
		for(var/obj/machinery/lifeweb/pillar/left/L in view(1, H))
			playsound(H.loc, 'sound/effects/changeling_walk.ogg', 50, 0, 1)
			if(do_after(H, 50))
				L.overlays += image('icons/effects/things.dmi', "[rand(2,5)]")
				for(var/obj/machinery/lifeweb/pillar/P in view(7, H))
					P.overlays += image('icons/effects/things2.dmi', "[rand(1,2)]")
				world << pick('sound/lfwbsounds/they_contact1.ogg', 'sound/lfwbsounds/they_contact2.ogg', 'sound/lfwbsounds/they_contact3.ogg', 'sound/lfwbsounds/they_contact4.ogg')
				for(var/mob/living/carbon/human/HH in mob_list)
					if(HH.mind.changeling)
						HH.reagents.add_reagent("dentrine",2000)
	else
		to_chat(H, "<span class='combat'>[pick(fnord)] We need to absorb atleast three people.</span>")

/obj/effect/lump
	name = "Lump"
	desc = "I Better stay away from that thing."
	density = 0
	anchored = 1
	layer = 3
	icon = 'icons/mob/critter.dmi'
	icon_state = "lump1"

/obj/effect/lump/Crossed(mob/living/carbon/human/M as mob|obj)
	if(ismonster(M))
		return
	if(M?.mind?.changeling)
		return
	if(ishuman(M))
		var/obj/item/clothing/mask/MA = M.wear_mask
		if(MA && (MA.flags & BLOCK_GAS_SMOKE_EFFECT))
			playsound(M, pick('sound/lfwbsounds/lump_active.ogg', 'sound/lfwbsounds/lump_active2.ogg'), 100, 1)
			qdel(src)
			return
		if(prob(90))
			M.apply_damage(rand(1, 2), OXY);
			M.vomit()
		M.Weaken(10)
		M.flash_pain()
		playsound(M, pick('sound/lfwbsounds/lump_active.ogg', 'sound/lfwbsounds/lump_active2.ogg'), 100, 1)
		qdel(src)

/mob/proc/lump()
	set category = "villain"
	set name = "Lump"
	set desc = "Lump"
	if(!ishuman(src))
		return
	var/mob/living/carbon/human/H = src
	if(!H?.mind?.changeling)
		return

	var/datum/changeling/changeling = H.mind.changeling
	if(world.time > (changeling.last_lump + changeling.lump_delay))
		changeling.last_lump = world.time
		if(!H.wear_suit && !H.w_uniform)
			if(do_after(H, 40))
				playsound(H, pick('sound/lfwbsounds/lump_spawn.ogg', 'sound/lfwbsounds/lump_spawn2.ogg'), 100, 1)
				new /obj/effect/lump(src)
		else
			to_chat(H, "<span class='combat'>[pick(global.fnord)] I need to be naked.</span>")
	else
		to_chat(H, "<span class='combat'>[pick(global.fnord)] I need to wait longer!</span>")

/mob/proc/learn()
	set category = "villain"
	set name = "Learnch"
	set desc = "Learn"
	if(!ishuman(src)) return
	var/mob/living/carbon/human/H = src
	for(var/mob/living/carbon/human/Other in view(1, H))
		if(Other == H)
			continue
		if(do_after(H, 50))
			if(Other.mind.changeling && Other.tentaclesexposed)
				for(var/skill in Other.my_skills.skills_holder)
					var/learn_value = Other.my_skills.get_skill(skill)
					if(learn_value > H.my_skills.get_skill(skill))
						H.my_skills.add_skill(skill, learn_value)

				playsound(H, 'sound/lfwbsounds/they_learn.ogg', 100, 1)
				return
		to_chat(H, "<span class='combat'>[pick(fnord)] I must stand still.</span>")

//Fake our own death and fully heal. You will appear to be dead but regenerate fully after a short delay.
/mob/proc/changeling_fakedeath()
	set category = "villain"
	set name = "RegenerativeStasis"
	set desc = "Regenerate"

	var/datum/changeling/changeling = changeling_power(20,1,100,DEAD)
	if(!changeling)	return
	var/mob/living/carbon/human/C = src

	to_chat(src, "<span class='notice'>Time to do this again.</span>")

	C.status_flags |= FAKEDEATH		//play dead
	C.sleeping = 300
	C.resting = 1
	C.update_canmove()
	C.remove_changeling_powers()
	C.emote("gasp")
	C.tod = worldtime2text()

	spawn(rand(200,300))
		if(changeling)
			// charge the changeling chemical cost for stasis
			changeling.chem_charges -= 20

			// remove our fake death flag
			C.status_flags &= ~(FAKEDEATH)

			// restore us to health
			C.rejuvenate()
			var/datum/organ/internal/heart/HE = C.internal_organs_by_name["heart"]
			if(HE)
				HE.stopped_working = 0
			// let us move again
			C.update_canmove()

			C.revive()

			// re-add out changeling powers
			C.make_changeling()

			// sending display messages
			C.sleeping = 0
			to_chat(C, "<span class='notice'>We have regenerated.</span>")
			C.visible_message("<span class='warning'>[src] appears to wake from the dead, having healed all wounds.</span>")


	return 1