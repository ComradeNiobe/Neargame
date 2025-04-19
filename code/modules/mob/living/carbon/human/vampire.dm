/mob/living/carbon
	var/isVampire = 0
	var/ExposedFang = 0
	var/DeadEyes = 0
	var/vampireBuffFortitude = 0
	var/vampireBuffCelerity = 0

/mob/living/carbon/human/proc/vampire_me()
	to_chat(src, "<span class='combat'>You're now a</span> <span class='combatglow'>vampire</span>. ")
	to_chat(src, "<span class='bname'>Secret masters of the human race, relying on secrecy and centuries-old wisdom.</span>")
	log_game("[src]([src?.key]) is now a vampire.")
	//src << 'theater-gargoyle.ogg'
	//src.combat_music = 'disturbed-and-twisted-combat.ogg'
	src.isVampire = 1
	src.status_flags |= STATUS_NO_PAIN
	src.vice = null
	src.favorite_beverage = "Blood"
	src.my_stats.change_stat(STAT_IN, 5)
	src.my_skills.change_skill(SKILL_UNARM, rand(1,5))
	src.add_verb(list(/mob/living/carbon/human/proc/expose_fangs,
	/mob/living/carbon/human/proc/blood_strength,
	/mob/living/carbon/human/proc/fortitude,
	/mob/living/carbon/human/proc/celerety,
	/mob/living/carbon/human/proc/dead_eyes,
	/mob/living/carbon/human/proc/heal))


/mob/living/carbon/human/proc/expose_fangs()
	set category = "fangs"
	set name = "ExposeFangs"
	set desc = "Expose Fangs"
	if(ExposedFang == TRUE)
		playsound(src.loc, 'sound/effects/fangs0.ogg', 50, 0, -1)
		src.visible_message("<span class='combatbold'>[src]</span> <span class='combat'>hides fangs!</span>")
		src.ExposedFang = FALSE
		src.update_body()
	else
		playsound(src.loc, 'sound/effects/fangs1.ogg', 50, 0, -1)
		src.visible_message("<span class='combatbold'>[src]</span> <span class='combat'>exposes fangs!</span>")
		src.ExposedFang = TRUE
		src.update_body()
	return

/mob/living/carbon/human/proc/heal()
	set category = "fangs"
	set name = "Heal"
	set desc = "Heal (150cl)"
	if(stat == 2) return
	if(src.vessel.total_volume <= 150)
		to_chat(src, "<span class='excomm'>I need more blood!</span>")
		return
	src << 'sound/effects/discipline.ogg'
	src.vessel.remove_reagent("blood",150)
	src.dizziness = 0
	rejuvenate(TRUE)
	return

/mob/living/carbon/human/proc/blood_strength()
	set category = "fangs"
	set name = "BloodStrength"
	set desc = "Blood Strength (50cl)"
	var/maximum = 30
	if(src.vessel.total_volume <= 50)
		to_chat(src, "<span class='excomm'>I need more blood!</span>")
		return
	if(src.my_stats.get_stat(STAT_ST) < maximum)
		src.my_stats.add_mod("BloodStrength", stat_list(ST = 5), time = 1200,override = TRUE, override_timer = TRUE)
		src.vessel.remove_reagent("blood",50)
		src << 'sound/effects/discipline.ogg'
	else
		to_chat(src, "<span class='excomm'>I can't get more than that!</span>")


/mob/living/carbon/human/proc/fortitude()
	set category = "fangs"
	set name = "Fortitude"
	set desc = "Fortitude (50cl)"
	var/maximum = 30
	if(src.vessel.total_volume <= 50)
		to_chat(src, "<span class='excomm'>I need more blood!</span>")
		return
	if(src.my_stats.get_stat(STAT_HT) < maximum)
		src.vessel.remove_reagent("blood",50)
		src.my_stats.add_mod("Fortitude", stat_list(HT = 4), time = 1200,override = TRUE, override_timer = TRUE)
		src << 'sound/effects/discipline.ogg'
		vampireBuffFortitude = 1
		spawn(1200)
			vampireBuffFortitude = 0
	else
		to_chat(src, "<span class='excomm'>I can't get more than that!</span>")

/mob/living/carbon/human/proc/celerety()
	set category = "fangs"
	set name = "Celerety"
	set desc = "Celerety (250cl)"
	if(src.vessel.total_volume <= 250)
		to_chat(src, "<span class='excomm'>I need more blood!</span>")
		return
	if(vampireBuffCelerity != 1)
		src.my_stats.add_mod("Celerty", stat_list(DX = 6), time = 900 ,override = TRUE, override_timer = TRUE)
		src.movement_speed_modifier = 3
		src.vessel.remove_reagent("blood",250)
		src << 'sound/effects/discipline.ogg'
		vampireBuffCelerity = 1
		spawn(900)
			vampireBuffCelerity = 0
			src.movement_speed_modifier = 1
	else
		to_chat(src, "<span class='excomm'>I can't get more than that!</span>")

/mob/living/carbon/human/proc/dead_eyes()
	set name = "DeadEyes"
	set category = "fangs"
	set desc = "Dead Eyes"

	if (see_invisible == SEE_INVISIBLE_OBSERVER_NOLIGHTING)
		see_invisible = SEE_INVISIBLE_OBSERVER
		src.DeadEyes = 0
		src.regenerate_icons()
	else
		see_invisible = SEE_INVISIBLE_OBSERVER_NOLIGHTING
		src.DeadEyes = 1
		src.regenerate_icons()

/mob/living/carbon/human/proc/handle_vampire()
	stamina_loss = 0
	nutrition = 450
	hydration = 700
	src.vessel.remove_reagent("blood", 0.15)

	for(var/obj/structure/fire/F in view(1, src))
		src.rotate_plane(1)
		to_chat(src, pick("<span class='combatglow'><b>GET THIS OUT OF HERE!</b></span>", "<span class='combatglow'><b>FIRE FIRE FIRE!</b></span>", "<span class='combatglow'><b>AAAAAAAAAAAAAAAAAAAAAAAAH!</b></span>"))

	/*for(var/obj/structure/torchwall/T in view(1, src))
		if(T.on)
			src.rotate_plane(1)
			to_chat(src, pick("<span class='combatglow'><b>GET THIS OUT OF HERE!</b></span>", "<span class='combatglow'><b>FIRE FIRE FIRE!</b></span>", "<span class='combatglow'><b>AAAAAAAAAAAAAAAAAAAAAAAAH!</b></span>"))*/

	for(var/obj/structure/fireplace/F in view(1, src))
		if(F.lit)
			src.rotate_plane(1)
			to_chat(src, pick("<span class='combatglow'><b>GET THIS OUT OF HERE!</b></span>", "<span class='combatglow'><b>FIRE FIRE FIRE!</b></span>", "<span class='combatglow'><b>AAAAAAAAAAAAAAAAAAAAAAAAH!</b></span>"))

/obj/item/attack_hand(mob/user as mob)
	..()
	var/mob/living/carbon/human/H = user
	var/vamp_hand = H.l_hand ? "l_hand" : "r_hand"
	if(H.isVampire)
		if(src.silver && !H.gloves)
			if(vamp_hand)
				to_chat(H, pick("<span class='combatglow'><b>GET THIS OUT OF HERE!</b></span>", "<span class='combatglow'><b>ACCURSED SILVER!</b></span>", "<span class='combatglow'><b>IT BURNS! IT BURNS!</b></span>"))
				H.drop_from_inventory(H.get_active_hand())
				H.apply_damage(rand(5, 10), BRUTE, vamp_hand)
				H.flash_pain()
				H.rotate_plane(1)