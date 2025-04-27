#define CONDOM_NONE 0
#define CONDOM_SMALL 1
#define CONDOM_REGULAR 2
#define CONDOM_BIG 3

/obj/item/condom_wrapper
	name = "condom"
	icon = 'icons/obj/personal.dmi'
	var/icon_state_abrido =  "wrapper_s_empty"
	var/icon_state_fechado = "wrapper_s"
	var/opened = FALSE
	var/obj/item/condom/condomtype = /obj/item/condom
	w_class = 1.0

/obj/item/condom_wrapper/New()
	..()
	update_icon()

/obj/item/condom_wrapper/update_icon()
	if(opened)
		icon_state = icon_state_abrido
	else
		icon_state = icon_state_fechado

/obj/item/condom_wrapper/attack_self(mob/user as mob)
	if(!opened)
		if(do_after(user, 5))
			to_chat(user, "<span class='passive'>You open the condom wrapper.</span>")
			opened = TRUE
			playsound(user, "open_candy.ogg", 50, 0)
			update_icon()
			var/turf/T = get_turf(user)
			new condomtype(T)
	else
		to_chat(user, "<span class='combat'>[pick(fnord)] it is already open!</span>")
	return

/obj/item/condom_wrapper/small
	name = "small condom (1-10cm)"
	icon = 'icons/obj/personal.dmi'
	icon_state_abrido =  "wrapper_s_empty"
	icon_state_fechado = "wrapper_s"
	icon_state = "wrapper_s"
	condomtype = /obj/item/condom/small

/obj/item/condom_wrapper/regular
	name = "regular condom (11-18cm)"
	icon = 'icons/obj/personal.dmi'
	icon_state_abrido =  "wrapper_empty"
	icon_state_fechado = "wrapper"
	icon_state = "wrapper"
	condomtype = /obj/item/condom/regular


/obj/item/condom_wrapper/large
	name = "large condom (19-30cm)"
	icon = 'icons/obj/personal.dmi'
	icon_state_abrido =  "wrapper_l_empty"
	icon_state_fechado = "wrapper_l"
	icon_state = "wrapper_l"
	condomtype = /obj/item/condom/big


/obj/item/condom
	var/minsize = 0
	var/maxsize = 0
	var/alreadyUsed = FALSE
	var/CameInto = FALSE
	var/condomsize = CONDOM_NONE

/obj/item/condom/update_icon()
	if(alreadyUsed)
		var/sizeicon
		switch(condomsize)
			if(CONDOM_SMALL)
				sizeicon = "s"
			if(CONDOM_REGULAR)
				sizeicon = "m"
			if(CONDOM_BIG)
				sizeicon = "xxl"
		var/icon_condom = "condom_[sizeicon]"
		if(CameInto)
			icon_condom = "ucondom_[sizeicon]"
		icon_state = icon_condom
	else
		icon_state = "condom_ready"

/obj/item/condom/small
	name = "condom"
	icon = 'icons/obj/personal.dmi'
	icon_state = "condom_s"
	desc = "1-10 cm"
	minsize = 1
	maxsize = 10
	condomsize = CONDOM_SMALL

/obj/item/condom/New()
	..()
	update_icon()

/obj/item/condom/regular
	name = "condom"
	icon = 'icons/obj/personal.dmi'
	icon_state = "condom_s"
	desc = "11-18 cm"
	minsize = 11
	maxsize = 18
	condomsize = CONDOM_REGULAR

/obj/item/condom/big
	name = "condom"
	icon = 'icons/obj/personal.dmi'
	icon_state = "condom_s"
	desc = "19-30 cm"
	minsize = 19
	maxsize = 30
	condomsize = CONDOM_BIG

/mob/living/carbon/human/attacked_by(var/obj/item/I, var/mob/living/carbon/human/attacker, var/def_zone)
	if(istype(I, /obj/item/condom) && attacker.zone_sel.selecting == "groin" && !src.ConDom)
		var/obj/item/condom/C = I
		if(src.penis_size < C.minsize || src.penis_size > C.maxsize)
			to_chat(src, "<span class='combatbold'>[pick(fnord)] Won't fit!</span>")
			return
		if(do_after(attacker, 10))
			attacker.drop_from_inventory(I)
			src.ConDom = I
			ConDom.loc = src
			C.alreadyUsed = TRUE
	..()

/**********************************
*******Interactions code by HONKERTRON feat TestUnit with translations and code edits by Matt********
**Contains a lot ammount of ERP and MEHANOYEBLYA**
***********************************/

var/list/cuckoldlist = list()
/mob/living/carbon/human/MouseDrop_T(mob/M as mob, mob/user as mob)
	if(M == src || src == usr && src.ConDom)
		if(do_after(M, 10))
			src.drop_from_inventory(src.ConDom)
			src.put_in_active_hand(src.ConDom)
			src.ConDom = null
	if(M == src || src == usr || M != usr)			return
	if(usr.restrained())		return
	var/mob/living/carbon/human/H = usr
	H.partner = src
	if(H.isChild())		return
	if(src.isChild())	return
	if(master_mode == "miniwar")	return
	if(iszombie(H))		return
	if(istype(H.species, /datum/species/human/alien)) return //stopping a problem before it ever happens
	if(istype(src.species, /datum/species/human/alien)) return
	make_interaction(machine)

/mob/proc/make_interaction()
	return

//Distant interactions
///mob/living/carbon/human/verb/interact(mob/M as mob)
//	set name = "Interact"
//	set category = "IC"
//
//	if (istype(M, /mob/living/carbon/human) && usr != M)
//		partner = M
//		make_interaction(machine)

/datum/species/human
	genitals = 1
	anus = 1

/mob/living/carbon/human/proc/get_pleasure_amt(hole)
	switch (hole)
		if ("anal")
			switch (penis_size)
				if (-INFINITY to 9)
					return penis_size * 0.15
				if (10 to 20)
					return penis_size * 0.30
				if (21 to INFINITY)
					return penis_size * 0.45
		if ("anal-2")
			return get_pleasure_amt("anal") * 1
		if ("vaginal")
			switch (penis_size)
				if (-INFINITY to 9)
					return penis_size * 0.33
				if (10 to 20)
					return penis_size * 0.66
				if (21 to INFINITY)
					return penis_size * 1.00
		if ("vaginal-2")
			return get_pleasure_amt("vaginal") * 2

/mob/living/carbon/human/proc/is_nude()
	var/obj/item/clothing/under/P = src.w_uniform
	return (!w_uniform || P.pants_down) ? 1 : 0

/mob/living/carbon/human/make_interaction()
	// No ass slapping from miles away.
	if(!CanPhysicallyInteractWith(usr, src))
		return
	set_machine(src)

	var/mob/living/carbon/human/H = usr
	var/mob/living/carbon/human/P = H.partner
	var/datum/organ/external/temp = H.organs_by_name[BP_R_HAND]
	var/hashands = (temp && temp.is_usable())
	if (!hashands)
		temp = H.organs_by_name[BP_L_HAND]
		hashands = (temp && temp.is_usable())
	temp = P.organs_by_name[BP_R_HAND]
	var/hashands_p = (temp && temp.is_usable())
	if (!hashands_p)
		temp = P.organs_by_name[BP_L_HAND]
		hashands = (temp && temp.is_usable())
	temp = H.organs_by_name["head"]
	var/mouthfree = !(H.wear_mask && temp)
	temp = P.organs_by_name["head"]
	var/mouthfree_p = !(P.wear_mask && temp)
	var/haspenis = H.has_penis()
	var/haspenis_p = P.has_penis()
	var/hasvagina = (H.gender == FEMALE && H.species.genitals && !haspenis)
	var/hasvagina_p = (P.gender == FEMALE && P.species.genitals && !haspenis_p)
	var/hasanus_p = P.species.anus
	var/isnude = H.is_nude()
	var/isnude_p = P.is_nude()

	H.lastfucked = null
	H.lfhole = ""

	var/list/dat = list()

	if (hashands)
		dat +=  "<font size=3><B>Hands:</B></font>"
		if(get_dist(H,P) <= 1)
			dat +=  "<A href='byond://?src=\ref[usr];interaction=slap'>Slap face!</A>"
			if (hasanus_p)
				dat += "<A href='byond://?src=\ref[usr];interaction=assslap'>Slap ass!</A>"
			if (isnude_p)
				if (hasvagina_p && (!P.mutilated_genitals))
					dat += "<A href='byond://?src=\ref[usr];interaction=fingering'>Put fingers in places.</A>"
				if(P.gender == FEMALE || P.isFemboy())
					dat += "<A href='byond://?src=\ref[usr];interaction=squeezebreast'>Squeeze breasts!</A>"

	if (mouthfree && (lying == P.lying || !lying))
		dat += "<font size=3><B>Mouth:</B></font>"
		dat += "<A href='byond://?src=\ref[usr];interaction=kiss'>Kiss.</A>"
		if(get_dist(H,P) <= 1)
			if (isnude_p && (!P.mutilated_genitals))
				if (haspenis_p)
					dat += "<A href='byond://?src=\ref[usr];interaction=blowjob'>Suck cock.</A>"
					dat += "<A href='byond://?src=\ref[usr];interaction=handjob'>Masturbate.</A>"
					dat += "<A href='byond://?src=\ref[usr];interaction=ballsuck'>Suck balls.</A>"
				if (hasvagina_p)
					dat += "<A href='byond://?src=\ref[usr];interaction=vaglick'>Lick vagina.</A>"
			dat +=  "<A href='byond://?src=\ref[usr];interaction=spit'>Spit.</A>"

	if(isnude && get_dist(usr,H.partner) <= 1)
		if (haspenis && hashands)
			dat += "<font size=3><B>Forbidden Fruits:</B></font>"
			if (isnude_p)
				if (hasvagina_p && (!P.mutilated_genitals))
					dat += "<A href='byond://?src=\ref[usr];interaction=vaginal'>Vaginal.</A>"
				if (hasanus_p)
					dat += "<A href='byond://?src=\ref[usr];interaction=anal'>Anal.</A>"
				if (mouthfree_p)
					dat += "<A href='byond://?src=\ref[usr];interaction=oral'>Oral.</A>"
	if (isnude && get_dist(usr,H.partner) <= 1)
		if (hasvagina && haspenis_p && (!H.mutilated_genitals))
			dat += "<font size=3><B>Vagina:</B></font>"
			dat += "<A href='byond://?src=\ref[usr];interaction=mount'>Mount</A><HR>"

	var/datum/browser/popup = new(H, "interactions", "INTERACTIONS - [H.partner.name]", 350, 300)
	popup.set_content(jointext(dat,"<br>"))
	popup.open()

//INTERACTIONS
/mob/living/carbon/human
	var/mob/living/carbon/human/partner
	var/mob/living/carbon/human/lastfucked
	var/lfhole
	var/penis_size = 10
	var/breast_size = "A"
	var/resistenza = 200
	var/lust = 0
	var/erpcooldown = 0
	var/multiorgasms = 0
	var/lastmoan
	var/mutilated_genitals = 0 //Whether or not they can do the fug.
	var/virgin = FALSE //:mistake:
	var/doing_fuck = FALSE
	var/list/breast_sizes = list("AA", "A", "B", "C", "D", "E")  // Breast sizes that can normally be picked from. Follows EU sizes. - Possible values: AA, A, B, C, D, E, F

/mob/living/carbon/human/proc/cum(mob/living/carbon/human/H as mob, mob/living/carbon/human/P as mob, var/hole = "floor")
	var/sound
	var/sound_path
	var/message = ""
	var/turf/T
	if(!H.HadSex.Find(P))
		H.HadSex.Add(P)
	if(!P.HadSex.Find(H))
		P.HadSex.Add(H)

	if(H.ConDom)
		H.ConDom.CameInto = TRUE
		H.ConDom.update_icon()

	if(P.ConDom)
		P.ConDom.CameInto = TRUE
		P.ConDom.update_icon()

	switch(H.gender)
		if(MALE)
			playsound(loc, "honk/sound/interactions/final_m[rand(1, 5)].ogg", 90, 0, -5)
		if(FEMALE)
			playsound(loc, "honk/sound/interactions/final_f[rand(1, 3)].ogg", 90, 0, -5)
	H.druggy = 30
	to_chat(H, "<span class='malfunction'>[pick("OH FUCK", "HOLY SHIT")]!</span>") //creativity
	P.druggy = 30
	if (has_penis())
		var/datum/reagent/blood/source = H.get_blood(H.vessel)
		if (P)
			T = get_turf(P)
		else
			T = get_turf(H)
		if (H.multiorgasms < H.penis_size)
			var/obj/effect/decal/cleanable/cum/C = new(T)
			C.add_fingerprint(H)
			// Update cum information.
			C.blood_DNA = list()
			if(source.data["blood_type"])
				C.blood_DNA[source.data["blood_DNA"]] = source.data["blood_type"]
			else
				C.blood_DNA[source.data["blood_DNA"]] = "O+"

		if (H.species.genitals)
			var/amt = rand(20,30)
			if(P.job)
				if(P.job == "Amuser" && !H.client.chromiesex && P.stat != DEAD)
					H.client.chromiesex = TRUE
					H.client.ChromieWinorLoose(1)
					if(H.check_perk(/datum/perk/sexaddict))
						H.gainWP(1, 4)
					else
						H.gainWP(1, 2)
					if(P.check_perk(/datum/perk/sexaddict))
						H.gainWP(1, 2)
					else
						H.gainWP(1, 1)
			if (hole == "mouth" || H?.zone_sel?.selecting == "mouth")
				message = pick("cums right in [P]'s mouth.")
				P.reagents.add_reagent("semen", amt)
				sound_path = "honk/sound/new/ACTIONS/MOUTH/SWALLOW/"
				sound = pick(flist("[sound_path]"))
			else if (hole == "vagina")
				message = pick("cums in [P]'s pussy")
				if(!H.ConDom && !P.ConDom)
					if(P.gender == FEMALE && P.pregnant == FALSE && P.stat != DEAD && !P?.mind.succubus)
						if(prob(rand(35, 55)))
							P.pregnant = TRUE
							var/is_husband = FALSE
							if(P.mind && H.mind)
								for(var/datum/relation/family/R in P.mind.relations)
									if(R.relation_holder == H.mind && R.name == "Husband")
										P.client.ChromieWinorLoose(1)
										P.add_event("pregnant", /datum/happiness_event/misc/pregnantgood)
										is_husband = TRUE
							if(!is_husband)
								P.add_event("pregnant", /datum/happiness_event/misc/pregnantbad)
								P.client.ChromieWinorLoose(-1)
								P.wedlock = 1

			else if (hole == "anus")
				message = pick("cums in [P]'s asshole.")
			else if (hole == "floor")
				message = "cums on the floor!"

			sound_path = "honk/sound/new/ACTIONS/PENIS/CUM/"
			sound = pick(flist("[sound_path]"))
		else
			message = pick("cums!", "orgasms!")

		if(P.job == "Successor" && ticker.eof.id == "blessedflesh")
			H.client.ChromieWinorLoose(1)
			H.my_stats.change_stat(STAT_WP , 3)
			P.my_stats.change_stat(STAT_WP , 2)
			src.my_stats.change_stat(STAT_ST, 10)
			src.my_stats.change_stat(STAT_HT, 10)
			src.my_stats.change_stat(STAT_DX, 10)

		if(H?.mind?.succubus)
			H.succubus_enslave(P)
			if(P.check_event(H.real_name))
				if(H.stat != DEAD)
					P.my_stats.clear_mod("succubus\ref[H]")
				P.clear_event("[H.real_name]")
		if(P?.mind?.succubus)
			P.succubus_enslave(H)
			if(H.check_event(P.real_name))
				if(P.stat != DEAD)
					H.my_stats.clear_mod("succubus\ref[P]")
				H.clear_event("[P.real_name]")
		H.visible_message("<span class='erpbold'>[H]</span> <span class='cumzone'>[message]</span>")
		if (istype(P.loc, /obj/structure/closet))
			P.visible_message("<span class='erpbold'>[H]</span> <span class='cumzone'>[message]</span>")
		H.lust = 5
		orgasms += 1
		if(P.mind && H.mind && (!ismonster(H) && !H.bot && !istype(H, /mob/living/carbon/human/skinless) && P.stat != DEAD))
			var/has_husband = FALSE
			for(var/datum/relation/family/R in P.mind.relations)
				if(R.name == "Husband")
					has_husband = TRUE
				if(R.relation_holder == H.mind && R.name == "Husband")
					break
				else if (has_husband)
					if(H.has_penis())
						if(!R.relation_holder.current.CuckedBy.Find(H))
							R.relation_holder.current.CuckedBy.Add(H)
	else
		message = pick("cums!")
		H.visible_message("<span class='erpbold'>[H]</span> <span class='cumzone'>[message].</span>")
		if (istype(P.loc, /obj/structure/closet))
			P.visible_message("<span class='erpbold'>[H]</span> <span class='cumzone'>[message].</span>")
		switch(lust)
			if(0 to 150)
				sound_path = "honk/sound/new/ACTIONS/VAGINA/SQUIRT/SHORT/"
			if(150 to INFINITY)
				sound_path = "honk/sound/new/ACTIONS/VAGINA/SQUIRT/LONG/"
		sound = pick(flist("[sound_path]"))
		src.lust = 60
		orgasms += 1

	H.multiorgasms += 1
	if (H.multiorgasms > H.penis_size / 3)
		if (H.stamina_loss < P.penis_size * 4)
			H.stamina_loss += H.penis_size * 0.5

	if(H.special == "dst")
		H.dst_completed += 1

	if(H.has_vice("Necrophile"))
		if(P.stat == DEAD)
			H.add_event("came", /datum/happiness_event/goodsex)
			H.viceneed = 0
		else
			H.add_event("came", /datum/happiness_event/badsex)
	else
		H.add_event("came", /datum/happiness_event/goodsex)
		if(H.has_vice("Sexoholic"))
			viceneed = 0
	H.clear_event("lustpadla")

	if(sound && sound_path)
		playsound(loc, "[sound_path][sound]", 90, 1, -5)

	for(var/mob/living/carbon/human/V in view(7))
		if(V != H || V != P)
			if(V.has_vice("Voyeur"))
				viceneed = 0

	times_came++

/mob/living/carbon/human/proc/fakecum() // for masturbate because 2 lazy to rewrite
	var/sound
	var/sound_path
	var/turf/T


	var/obj/item/reagent_containers/glass/G = locate() in src.loc

	if(G && !(G.reagents.total_volume >= G.reagents.maximum_volume))
		G.reagents.add_reagent("semen", 10)
		G.update_icon()
		src.visible_message("<span class='erpbold'>[src]</span> <span class='cumzone'>cums on the [G]!</span>")

	if(src.ConDom)
		src.ConDom.CameInto = TRUE
		src.ConDom.update_icon()
		src.visible_message("<span class='erpbold'>[src]</span> <span class='cumzone'>cums on the condom!</span>")

	else
		src.visible_message("<span class='erpbold'>[src]</span> <span class='cumzone'>cums on the floor!</span>")


	switch(src.gender)
		if(MALE)
			playsound(loc, "honk/sound/interactions/final_m[rand(1, 5)].ogg", 90, 0, -5)
		if(FEMALE)
			playsound(loc, "honk/sound/interactions/final_f[rand(1, 3)].ogg", 90, 0, -5)
	if (has_penis())
		var/datum/reagent/blood/source = src.get_blood(src.vessel)
		T = get_turf(src)
		if (src.multiorgasms < src.penis_size)
			var/obj/effect/decal/cleanable/cum/C = new(T)
			C.add_fingerprint(src)
			// Update cum information.
			C.blood_DNA = list()
			if(source.data["blood_type"])
				C.blood_DNA[source.data["blood_DNA"]] = source.data["blood_type"]
			else
				C.blood_DNA[source.data["blood_DNA"]] = "O+"

	if(istype(src.get_active_hand(), /obj/item/adultmag) || istype(src.get_other_hand(), /obj/item/adultmag))
		src.add_event("adultmag", /datum/happiness_event/magazinepleasure)
		if(src.has_vice("Voyeur"))
			viceneed = 0

	if(sound && sound_path)
		playsound(loc, "[sound_path][sound]", 90, 1, -5)

	times_came++

/mob/living/carbon/human/proc/fuck(mob/living/carbon/human/H as mob, mob/living/carbon/human/P as mob, var/hole)
	if(P.isChild() || H.isChild()) //No hrefing this asshole.
		return
	if(H.doing_fuck)
		return
	var/chastity_text_H = "I can't fuck with... that on..."
	var/chastity_text_P = "Oh... I can't get fucked like this..."
	var/chastity_check_H = FALSE
	var/chastity_check_P = FALSE
	if(H.underwear)//Chastity check.
		chastity_check_H = TRUE
	if(P.underwear)
		chastity_check_P = TRUE
	var/sound
	var/sound_path // hack for blowjob. Can be used elsewhere to have dynamic sound depending on message
	var/message = ""
	if(!H.HadSex.Find(P))
		H.HadSex.Add(P)
	if(!P.HadSex.Find(H))
		P.HadSex.Add(H)
	H.adjustStaminaLoss(2)
	if(!H.ConDom && !P.ConDom)
		for(var/datum/disease/A in H.viruses)
			if(istype(A,/datum/disease/aids))
				P.contract_disease(new /datum/disease/aids,1,0)
		for(var/datum/disease/A in P.viruses)
			if(istype(A,/datum/disease/aids))
				H.contract_disease(new /datum/disease/aids,1,0)
	if(P.job == "Nun" || P.job == "Praetor")
		H.custom_pain("[pick("<span class='hugepain'>OH [uppertext(god_text())] MY DICK!</span>", "<span class='hugepain'>OH [uppertext(god_text())] WHY!</span>", "<span class='hugepain'>OH [uppertext(god_text())] IT HURTS!</span>")]", 100)
		H.apply_damage(rand(50,70), BRUTE, BP_GROIN)
		playsound(H, 'sound/effects/gore/severed.ogg', 50, 1, -1)
		H.mutilate_genitals()
		H.client.ChromieWinorLoose(-1)
	H.doing_fuck = TRUE
	switch(hole)

		if("vaglick")
			if(chastity_check_P)
				chastity_text_H = "Oh, I can't please with this in the way..."
				to_chat(H, chastity_text_H)
				H.doing_fuck = FALSE
				return
			message = pick("licks [P].", "sucks [P]'s pussy.")

			if (H.lastfucked != P || H.lfhole != hole)
				H.lastfucked = P
				H.lfhole = hole

			if (prob(5) && P.stat != DEAD)
				H.visible_message("<span class='erpbold'>[H]</span> <span class='erp'>[message]</span>")
				P.lust += 10
			else
				H.visible_message("<span class='erpbold'>[H]</span> <span class='erp'>[message]</span>")
			if (istype(P.loc, /obj/structure/closet))
				P.visible_message("<span class='erpbold'>[H]</span> <span class='erp'>[message]</span>")
			if (P.stat != DEAD && P.stat != UNCONSCIOUS)
				P.lust += 10
				if (P.lust >= P.resistenza)
					P.cum(P, H)
				else
					P.moan()
			if(prob(75))
				sound = pick(flist("honk/sound/new/ACTIONS/VAGINA/TOUCH/"))
				playsound(loc, ("honk/sound/new/ACTIONS/VAGINA/TOUCH/[sound]"), 90, 1, -5)
			else
				sound = pick(flist("honk/sound/new/ACTIONS/MOUTH/SALIVA/"))
				playsound(loc, ("honk/sound/new/ACTIONS/MOUTH/SALIVA/[sound]"), 90, 1, -5)


		if("fingering")
			if(chastity_check_P)
				chastity_text_H = "Oh, I can't please with this in the way..."
				to_chat(H, chastity_text_H)
				H.doing_fuck = FALSE
				return
			message = pick("fingers [P].", "fingers [P]'s pussy.")
			if (prob(35))
				message = pick("fingers [P] hard.")
			if (H.lastfucked != P || H.lfhole != hole)
				message = (" shoves their fingers into [P]'s pussy.")
				sound = ("honk/sound/new/ACTIONS/VAGINA/INSERTION/")
				playsound(loc, "honk/sound/new/ACTIONS/VAGINA/INSERTION/[sound]", 90, 1, -5)
				H.lastfucked = P
				H.lfhole = hole

			if (prob(5) && P.stat != DEAD)
				H.visible_message("<span class='erpbold'>[H]</span> <span class='erp'>[message]</span>")
				P.lust += 8
			else
				H.visible_message("<span class='erpbold'>[H]</span> <span class='erp'>[message]</span>")
			if (P.stat != DEAD && P.stat != UNCONSCIOUS)
				P.lust += 8
				if (P.lust >= P.resistenza)
					P.cum(P, H)
				else
					P.moan()

			sound = pick(flist("honk/sound/new/ACTIONS/VAGINA/TOUCH/"))
			playsound(loc, ("honk/sound/new/ACTIONS/VAGINA/TOUCH/[sound]"), 90, 1, -5)

		if("ballsuck")
			message = pick("sucks [P]'s balls.", "licks [P]'s nuts.")
			sound_path = ("honk/sound/new/ACTIONS/BLOWJOB/")
			if (prob(25))
				message = pick("twirls their tongue around [P]'s sack.")
				sound_path = "honk/sound/new/ACTIONS/MOUTH/SUCK/"
			sound = pick(flist("[sound_path]"))

			if (H.lust < 6)
				H.lust += 6

			if(prob(5))
				if(P.stat != DEAD)
					H.visible_message("<span class='erpbold'>[H]</span> <span class='erp'>[message]</span>")
					P.lust += 10
				else
					H.visible_message("<span class='erpbold'>[H]</span> <span class='erp'>[message]</span>")
			else
				H.visible_message("<span class='erpbold'>[H]</span> <span class='erp'>[message]</span>")

			if(P.stat != DEAD)
				P.lust += 10
				if (P.lust >= P.resistenza)
					P.cum(P, H, "floor")
				else
					P.moan()

			playsound(loc, ("[sound_path][sound]"), 90, 1, -5)
			if(prob(35))
				sound = pick(flist("honk/sound/new/ACTIONS/MOUTH/SALIVA/"))
				playsound(loc, ("honk/sound/new/ACTIONS/MOUTH/SALIVA/[sound]"), 90, 1, -5)

		if("blowjob")
			message = pick("sucks [P]'s dick.", "gives [P] head.")
			sound_path = ("honk/sound/new/ACTIONS/BLOWJOB/")
			if (prob(35))
				message = pick("sucks [P] off.")
				sound_path = "honk/sound/new/ACTIONS/MOUTH/SUCK/"
			sound = pick(flist("[sound_path]"))

			if (H.lust < 6)
				H.lust += 6

			if(prob(5))
				if(P.stat != DEAD)
					H.visible_message("<span class='erpbold'>[H]</span> <span class='erp'>[message]</span>")
					P.lust += 10
				else
					H.visible_message("<span class='erpbold'>[H]</span> <span class='erp'>[message]</span>")
			else
				H.visible_message("<span class='erpbold'>[H]</span> <span class='erp'>[message]</span>")

			if(P.stat != DEAD)
				P.lust += 10
				if (P.lust >= P.resistenza)
					P.cum(P, H, "mouth")
				else
					P.moan()

			playsound(loc, ("[sound_path][sound]"), 90, 1, -5)
			if(prob(35))
				sound = pick(flist("honk/sound/new/ACTIONS/MOUTH/SALIVA/"))
				playsound(loc, ("honk/sound/new/ACTIONS/MOUTH/SALIVA/[sound]"), 90, 1, -5)
			if (prob(P.penis_size))
				H.visible_message("<span class='erpbold'>[H]</span> <span class='erp'>goes in deep on</span> <span class='erpbold'>[P]</span><span class='erp'>.</span>")

		if("handjob")
			message = pick("strokes [P]'s dick.", "masturbate [P]'s penis.")
			if (H.lust < 6)
				H.lust += 6

			if(prob(5))
				if(P.stat != DEAD)
					H.visible_message("<span class='erpbold'>[H]</span> <span class='erp'>[message]</span>")
					P.lust += 10
				else
					H.visible_message("<span class='erpbold'>[H]</span> <span class='erp'>[message]</span>")
			else
				H.visible_message("<span class='erpbold'>[H]</span> <span class='erp'>[message]</span>")

			if (P.stat != DEAD && P.stat != UNCONSCIOUS)
				P.lust += 8
				if (P.lust >= P.resistenza)
					P.cum(P, H)
				else
					P.moan()
			if(prob(50))
				sound = pick(flist("honk/sound/new/ACTIONS/PENIS/HANDJOB/"))
				playsound(loc, "honk/sound/new/ACTIONS/PENIS/HANDJOB/[sound]", 90, 1, -5)
			if (prob(P.penis_size))
				H.visible_message("<span class='erpbold'>[H]</span> <span class='erp'>strokes</span> <B>[P]'s </span><span class='erp'> [pick("cock","dick","penis")] faster.</span>")

		if("vaginal")
			if(chastity_check_P)
				to_chat(H, chastity_text_H)
				to_chat(P, chastity_text_P)
				H.doing_fuck = FALSE
				return
			message = pick("fucks [P].", "pounds [P]'s pussy.")
			if(P.job == "Fortune Teller")
				if(prob(25))
					to_chat(H, "<span class='ifeelsick'>Something doesn't feel right...</span>")
			if(H.combat_mode)
				to_chat(P, pick("Ow! That's pretty rough!","Ow! He's fucking roughly!", "That hurts! He's being too rough!"))
				var/datum/organ/external/groin/G = P.get_organ("groin")
				G.add_pain(10)
				if(P.has_vice("Masochist"))
					P.viceneed = 0


			if (H.lastfucked != P || H.lfhole != hole)
				message = pick(" shoves their dick into [P]'s pussy.")
				sound = pick(flist("honk/sound/new/ACTIONS/VAGINA/INSERTION/"))
				playsound(loc, "honk/sound/new/ACTIONS/VAGINA/INSERTION/[sound]", 90, 1, -5)
				H.lastfucked = P
				H.lfhole = hole

			if(P.virgin)
				P.virgin = FALSE
				H.visible_message("<span class='erpbold'>[H]</span> <span class='erp'>pop's</span> <span class='erpbold'>[P]'s</span> <span class='erp'>cherry.</span>")
				H.gainWP(1, 1)
				var/datum/organ/external/groin/G = P.get_organ("groin")
				G.add_pain(20)
				to_chat(P, "<span class='magentatext'>OH FUCK! IT'S TIGHT!</span>")
			if (prob(5) && P.stat != DEAD)
				H.visible_message("<span class='erpbold'>[H]</span> <span class='erp'>[message]</span>")
				P.lust += H.get_pleasure_amt("vaginal-2")
			else
				H.visible_message("<span class='erpbold'>[H]</span> <span class='erp'>[message]</span>")
			if (istype(P.loc, /obj/structure/closet))
				P.visible_message("<span class='erpbold'>[H]</span> <span class='erp'>[message]</span>")
				playsound(P.loc.loc, 'sound/effects/clang.ogg', 50, 0, 0)
			H.lust += 10
			if (H.lust >= H.resistenza)
				H.cum(H, P, "vagina")

			if (P.stat != DEAD)
				P.lust += H.get_pleasure_amt("vaginal")
				/*if (H.penis_size > 20)
					P.stamina_loss += H.penis_size * 0.10*/
				if (P.lust >= P.resistenza)
					P.cum(P, H)
				else
					P.moan(H.penis_size)
			if(prob(75))
				sound = pick(flist("honk/sound/new/ACTIONS/PENETRATION/"))
				playsound(loc, "honk/sound/new/ACTIONS/PENETRATION/[sound]", 90, 1, -5)
			else
				sound = pick(flist("honk/sound/new/ACTIONS/BODY/COLLIDE/NAKED/"))
				playsound(loc, "honk/sound/new/ACTIONS/BODY/COLLIDE/NAKED/[sound]", 90, 1, -5)

		if("mount")
			if(chastity_check_H)
				chastity_text_H = "Oh, I can't please with this in the way..."
				to_chat(H, chastity_text_H)
				to_chat(P, chastity_text_P)
				H.doing_fuck = FALSE
				return
			message = pick("fucks [P]'s dick", "rides [P]'s dick", "rides [P]")

			if (H.lastfucked != P || H.lfhole != hole)
				message = pick("begins to hop on [P]'s dick")
				H.lastfucked = P
				H.lfhole = hole

			if(H.virgin)
				H.virgin = FALSE
				H.visible_message("<span class='erpbold'>[P]</span> <span class='erp'>pop's</span> <span class='erpbold'>[H]'s</span> <span class='erp'>cherry.</span>")

			if (prob(5))
				if(P.stat != DEAD)
					H.visible_message("<span class='erpbold'>[H]</span> <span class='erp'>[message].</span>")
					P.lust += H.penis_size * 2
			else
				H.visible_message("<span class='erpbold'>[H] [message].</span>")

			H.lust += P.penis_size
			if (H.lust >= H.resistenza)
				H.cum(H, P, "vagina")
			else
				H.moan(P.penis_size)
			if (P.stat != DEAD)
				P.lust += H.get_pleasure_amt("vaginal")
				if (P.lust >= P.resistenza)
					P.cum(P, H, "vagina")
				else
					P.moan(P.penis_size)
			if(prob(75))
				sound = pick(flist("honk/sound/new/ACTIONS/PENETRATION/"))
				playsound(loc, "honk/sound/new/ACTIONS/PENETRATION/[sound]", 90, 1, -5)
			else
				sound = pick(flist("honk/sound/new/ACTIONS/BODY/COLLIDE/NAKED/"))
				playsound(loc, "honk/sound/new/ACTIONS/BODY/COLLIDE/NAKED/[sound]", 90, 1, -5)
		if("anal")

			message = pick("fucks [P]'s ass.")

			if (H.lastfucked != P || H.lfhole != hole)
				message = pick(" shoves their dick into [P]'s asshole.")
				H.lastfucked = P
				H.lfhole = hole

			if (prob(5) && P.stat != DEAD)
				H.visible_message("<span class='erpbold'>[H]</span> <span class='erp'>[message]</span>")
				P.lust += H.get_pleasure_amt("anal-2")
			else
				H.visible_message("<span class='erpbold'>[H]</span> <span class='erp'>[message]</span>")
			if (istype(P.loc, /obj/structure/closet))
				P.visible_message("<span class='erpbold'>[H]</span> <span class='erp'>[message]</span>")
				playsound(P.loc.loc, 'sound/effects/clang.ogg', 50, 0, 0)
			H.lust += 12
			if (H.lust >= H.resistenza)
				H.cum(H, P, "anus")
			else
				P.moan(H.penis_size)

			if (P.stat != DEAD && P.stat != UNCONSCIOUS)
				P.lust += H.get_pleasure_amt("anal")
				if (P.lust >= P.resistenza)
					P.cum(P, H)
				else
					P.moan(H.penis_size)
			sound = pick(flist("honk/sound/new/ACTIONS/BODY/COLLIDE/NAKED/"))
			playsound(loc, "honk/sound/new/ACTIONS/BODY/COLLIDE/NAKED/[sound]", 90, 1, -5)

		if("oral")
			message = pick(" fucks [P]'s mouth.")
			if (prob(35))
				message = pick(" sucks [P]'s [P.has_penis() ? "dick" : "vag"]..", " licks [P]'s [P.has_penis() ? "dick" : "vag"]..")
			if (H.lastfucked != P || H.lfhole != hole)
				message = pick(" shoves their dick down [P]'s throat.")
				H.lastfucked = P
				H.lfhole = hole

			if (prob(5) && H.stat != DEAD)
				H.visible_message("<span class='erpbold'>[H]</span><span class='erp'>[message]</span>")
				H.lust += 15
			else
				H.visible_message("<span class='erpbold'>[H]</span><span class='erp'>[message]</span>")
			if (istype(P.loc, /obj/structure/closet))
				P.visible_message("<span class='erpbold'>[H]</span><span class='erp'>[message]</span>")
				playsound(P.loc.loc, 'sound/effects/clang.ogg', 50, 0, 0)
			H.lust += 15
			if (H.lust >= H.resistenza)
				H.cum(H, P, "mouth")

			if (prob(H.penis_size))
				P.stamina_loss += 3
				sound_path = "honk/sound/new/ACTIONS/MOUTH/SWALLOW/"
				H.visible_message("<span class='erpbold'>[H]</span> <span class='erp'>fucks</span> <span class='erpbold'>[P]'s</span> <span class='erp'>throat.</span>")
				if (istype(P.loc, /obj/structure/closet))
					P.visible_message("<span class='erpbold'>[H]</span> <span class='erp'>fucks</span> <span class='erpbold'>[P]'s</span> <span class='erp'>throat.</span>")
			else
				sound_path = "honk/sound/new/ACTIONS/BLOWJOB/"
			sound = pick(flist("[sound_path]"))
			playsound(loc, "[sound_path][sound]", 90, 1, -5)
	spawn(2)
		H.doing_fuck = FALSE


/mob/living/carbon/human/proc/moan(var/size = 0)
	var/mob/living/carbon/human/H = src
	if (species.name == "Human" || H.isFemboy())
		if (prob(H.lust / H.resistenza * 65))
			var/message = pick("moans", "moans in pleasure",)
			H.visible_message("<span class='erpbold'>[H]</span> <span class='erp'>[message].</span>")
			var/g = H.gender == FEMALE ? "f" : "m"
			var/moan = rand(1, 7)
			if (moan == lastmoan)
				moan--
			if(g == "m")
				playsound(loc, "honk/sound/interactions/moan_[g][moan].ogg", 90, 0, -5)
			else if (g == "f")
				var/sound_path
				var/sound
				if(H.job == "Amuser")
					sound_path = "honk/sound/amuser"
					sound = pick(flist("[sound_path]"))
					playsound(loc, "[sound_path][sound]", 90, 0, -5)
				else
					switch(size)
						if(-INFINITY to 11)
							sound_path = "honk/sound/new/Moans/mild/"
						if(12 to 20)
							sound_path = "honk/sound/new/Moans/medium/"
						if(21 to INFINITY)
							sound_path = "honk/sound/new/Moans/hot/"
					sound = pick(flist("[sound_path]"))
					playsound(loc, "[sound_path][sound]", 90, 0, -5)

			lastmoan = moan


/mob/living/carbon/human/proc/handle_lust()
	lust -= 4
	if (lust <= 0)
		lust = 0
		lastfucked = null
		lfhole = ""
		multiorgasms = 0

/mob/living/carbon/human/proc/do_fucking_animation(mob/living/carbon/human/P)
	var/pixel_x_diff = 0
	var/pixel_y_diff = 0
	var/final_pixel_y = initial(pixel_y)

	var/direction = get_dir(src, P)
	if(direction & NORTH)
		pixel_y_diff = 8
	else if(direction & SOUTH)
		pixel_y_diff = -8

	if(direction & EAST)
		pixel_x_diff = 8
	else if(direction & WEST)
		pixel_x_diff = -8

	if(pixel_x_diff == 0 && pixel_y_diff == 0)
		pixel_x_diff = rand(-3,3)
		pixel_y_diff = rand(-3,3)
		animate(src, pixel_x = pixel_x + pixel_x_diff, pixel_y = pixel_y + pixel_y_diff, time = 2)
		animate(pixel_x = initial(pixel_x), pixel_y = initial(pixel_y), time = 2)
		return

	animate(src, pixel_x = pixel_x + pixel_x_diff, pixel_y = pixel_y + pixel_y_diff, time = 2)
	animate(pixel_x = initial(pixel_x), pixel_y = final_pixel_y, time = 2)

/obj/item/chastity_key
	name = "chastity belt key"
	desc = "For when you finally want to use your wife."
	icon = 'icons/obj/items.dmi'
	icon_state = "key"
	drop_sound = 'sound/webbers/keydrop.ogg'
	drawsound = 'sound/webbers/keyring_up.ogg'
	force = 0
	throwforce = 0
	w_class = 1

/obj/item/chastity_key/attack(mob/living/carbon/human/M, mob/living/user, def_zone, special)
	if(!istype(M))
		return
	if(!M.is_nude())
		to_chat(user, "Take their clothes off first.")
		return
	if(!M.underwear)
		return ..()
	if(do_mob(user, M, 0))
		M.underwear = "" //Return to nothingness
		M.update_body()
		playsound(M, 'sound/effects/wboltswitch.ogg', 100, 0)
		user.put_in_hands(new /obj/item/chastity_belt(user))
		user.visible_message("[user] unlocks [M]'s belt. They are free to be a whore again.")


/obj/item/chastity_belt //I hate this
	name = "chastity belt"
	desc = "For keeping your wife fully faithful."
	icon = 'icons/obj/clothing/underwears.dmi'
	icon_state = "chastity"
	force = 5

/obj/item/chastity_belt/attack(mob/living/carbon/human/M, mob/living/user, def_zone, special)
	if(!istype(M))
		return
	if(M.isChild())
		return
	if(M.gender != FEMALE)
		to_chat(user, "This was designed for women.")
		return
	if(!M.is_nude())
		to_chat(user, "They must be nude for this.")
		return
	if(M.underwear)
		to_chat(user, "They are already wearing one.")
		return
	if(do_mob(user, M, 40))
		user.visible_message("[user] locks the [src] onto [M]. They are now chaste.")
		M.underwear = "chastity"
		M.update_body()
		playsound(M, 'sound/effects/wboltswitch.ogg', 100, 0)
		qdel(src)

/obj/item/dildo
	name = "dildo"
	desc = "Hmmm, deal throw"
	icon = 'honk/icons/obj/items/dildo.dmi'
	icon_state = "dildo"
	item_state = "c_tube"
	throwforce = 0
	force = 10
	force_wielded = 12
	force_unwielded = 10
	w_class = 1
	throw_speed = 3
	throw_range = 15
	attack_verb = list("slammed", "bashed", "whipped")
	var/hole = "vagina"
	var/pleasure = 10

/obj/item/dildo/copper
	name = "copper dildo"
	desc = "Hmmm, deal throw"
	icon = 'icons/obj/weapons.dmi'
	icon_state = "dildo_copper0"
	item_state = "c_tube"
	throwforce = 0
	force = 10
	w_class = 1
	throw_speed = 3
	throw_range = 15
	attack_verb = list("slammed", "bashed", "whipped")
	hole = "vagina"
	pleasure = 7
	smelted_return = /obj/item/ore/refined/lw/copperlw

/obj/item/dildo/goldeb
	name = "golden dildo"
	desc = "Hmmm, deal throw"
	icon = 'icons/obj/weapons.dmi'
	icon_state = "dildo_gold"
	item_state = "c_tube"
	throwforce = 0
	force = 10
	w_class = 1
	throw_speed = 3
	throw_range = 15
	attack_verb = list("slammed", "bashed", "whipped")
	hole = "vagina"
	pleasure = 15

/obj/item/dildo/attack(mob/living/carbon/human/M, mob/living/carbon/human/user)
	var/hasvagina = (M.gender == FEMALE && M.species.genitals && M.species.name != "Unathi" && M.species.name != "Stok" && !M.has_penis())
	var/hasanus = M.species.anus
	var/message = ""
	if(M.isChild() || user.isChild())
		return
	if(istype(M, /mob/living/carbon/human) && user.zone_sel.selecting == "groin" && M.is_nude())
		if (hole == "vagina" && hasvagina)
			if (user == M)
				message = pick("fucks their own pussy")//, "çàòàëêèâàåò â ñåá[ya] [rus_name]", "ïîãðóæàåò [rus_name] â ñâîå ëîíî")
			else
				message = pick("fucks [M] right in the pussy with the dildo", "jams it right into [M]")//, "çàòàëêèâàåò â [M] [rus_name]", "ïîãðóæàåò [rus_name] â ëîíî [M]")

			if (prob(5) && M.stat != DEAD && M.stat != UNCONSCIOUS)
				user.visible_message("<span class='erpbold'>[user]</span> <span class='erp'>[message].</span>")
				M.lust += pleasure * 2

			else if (M.stat != DEAD && M.stat != UNCONSCIOUS)
				user.visible_message("<span class='erpbold'>[user]</span> <span class='erp'>[message].</span>")
				M.lust += pleasure

			if (M.lust >= M.resistenza)
				M.cum(M, user, "floor")
			else
				M.moan()

			playsound(loc, "honk/sound/interactions/bang[rand(4, 6)].ogg", 90, 0, -5)

		else if (hole == "anus" && hasanus)
			if (user == M)
				message = pick("fucks their ass")
			else
				message = pick("fucks [M]'s asshole")

			if (prob(5) && M.stat != DEAD && M.stat != UNCONSCIOUS)
				user.visible_message("<span class='erpbold'>[user]</span> <span class='erp'>[message].</span>")
				M.lust += pleasure * 2

			else if (M.stat != DEAD && M.stat != UNCONSCIOUS)
				user.visible_message("<span class='erpbold'>[user]</span> <span class='erp'>[message].</span>")
				M.lust += pleasure

			if (M.lust >= M.resistenza)
				M.cum(M, user, "floor")
			else
				M.moan()

			var/sound = pick(flist("honk/sound/new/ACTIONS/PENETRATION/"))
			playsound(loc, "honk/sound/new/ACTIONS/PENETRATION/[sound]", 90, 1, -5)

		else
			..()
	else
		..()

/obj/item/dildo/attack_self(mob/user as mob)
	if(hole == "vagina")
		hole = "anus"
	else
		hole = "vagina"
	to_chat(usr, "<span class='erp'>Hmmm. Maybe we should put it in [hole]?!</span>")

/obj/item/adultmag
	name = "adult magazine"
	desc = "Not safe for work."
	icon = 'icons/life/LFWB_USEFUL.dmi'
	icon_state = "mag1"
	w_class = 2
	var/list/thoughts = list("Oh.","Oh?","Like that?","How...?","Interesting...","Wow.","Huh.","Nice...","Nice.")
	var/list/childthoughts = list("WHAT?!","WOAH!","UHH...","WH-...","I SHOULDN'T LOOK AT THIS!","EW!","GROSS!","NOPE!","WHAT IS THIS?!")

/obj/item/adultmag/one
	name = "SCREW & CHIC"
	desc = "An adult tabloid for the working man."
	icon_state = "mag1"

/obj/item/adultmag/two
	name = "Mazokhist"
	desc = "A mature magazine written by a support group for masochists."
	icon_state = "mag2"

/obj/item/adultmag/three
	name = "Exposed Skin"
	desc = "Not safe for work."
	icon_state = "mag3"

/obj/item/adultmag/attack_self(mob/living/carbon/human/user)
	playsound(src.loc, pick('sound/webbers/paper_up1.ogg', 'sound/webbers/paper_up2.ogg', 'sound/webbers/paper_up3.ogg'), 100, 0)
	if(user.isChild())
		to_chat(user, "<span class='combatbold'>[pick(src.childthoughts)]</span>")
		user.rotate_plane()
	else
		to_chat(user, "<span class='passivebold'>[pick(src.thoughts)]</span>")
		user.lust += 5


#undef CONDOM_NONE
#undef CONDOM_SMALL
#undef CONDOM_REGULAR
#undef CONDOM_BIG
