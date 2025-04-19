/mob/living/simple_animal/maggot
	name = "purring maggot"
	real_name = "purring maggot"
	icon_state = "worm"
	icon_living = "worm"
	icon_dead = "worm_l"
	pass_flags = PASSTABLE
	small = 1
	speak_chance = 0
	turns_per_move = 5
	see_in_dark = 6
	maxHealth = 5
	health = 5
	response_help  = "pets the"
	response_disarm = "gently pushes aside the"
	response_harm   = "stamps on the"
	density = 0
	var/body_color //brown, gray and white, leave blank for random
	layer = MOB_LAYER
	min_oxy = 16 //Require atleast 16kPA oxygen
	minbodytemp = 223		//Below -50 Degrees Celcius
	maxbodytemp = 323	//Above 50 Degrees Celcius
	universal_speak = 0
	universal_understand = 1
	var/milkstock = 4

/mob/living/simple_animal/maggot/Life()
	..()
	if(!stat && prob(20))
		playsound(src.loc, pick('sound/effects/maggot1.ogg','sound/effects/maggot2.ogg','sound/effects/maggot3.ogg'), 40, 0, -1)

/mob/living/simple_animal/maggot/Die()
	layer = MOB_LAYER
	playsound(src, 'sound/effects/maggotd.ogg', 40, 0, -1)
	new /obj/item/reagent_containers/food/snacks/purryingmaggot(src.loc)
	qdel(src)
	..()

/mob/living/simple_animal/maggot/Crossed(AM as mob|obj)
	if( ishuman(AM) )
		if(!stat)
			var/mob/M = AM
			playsound(M, pick('sound/effects/maggot1.ogg','sound/effects/maggot2.ogg','sound/effects/maggot3.ogg'), 40, 0, -1)
	..()
/mob/living/simple_animal/maggot/attack_hand(var/mob/living/carbon/human/H)
	if(H.a_intent == "help")
		if(buckled)
			return
		H.visible_message("<span class='notice'>[H] starts trying to scoop up \the [src]!</span>")
		if(do_after(H, 25))
			var/obj/item/mob_holder/holder = new(src,H)
			if(!H.put_in_hands(holder))
				qdel(holder)
			else
				H.visible_message("<span class='combat'>[H] scoops up [src]!</span>")
			return
	if(H.a_intent == "disarm")
		H.visible_message("<span class='notice'>[H] starts trying to milk \the [src]!</span>")
		if(do_after(H, 25))
			var/obj/item/I = H.get_inactive_hand()
			if(!istype(I, /obj/item/reagent_containers))
				to_chat(H, "<span class='combat'>[pick(fnord)] I should hold a container in my other hand.</span>")
				return
			if(!milkstock)
				to_chat(H, "<span class='combat'>[pick(fnord)] The maggot's milk gland is dry!</span>")
				return
			else
				var/obj/item/reagent_containers/C = I
				milkstock -= 1
				C.reagents.add_reagent("milk", min(C.volume - C.reagents.total_volume, C.amount_per_transfer_from_this))
				H.visible_message("<span class='passivebold'>[H]</span><span class='passive'> fills \the [C] with milk from \the [src].</span>")
	else
		..()

/mob/living/simple_animal/maggot/proc/process()
	for(var/mob/living/carbon/human/I in mob_list)
		if(src.loc == I.organ_storage.contents)
			if(prob(10))
				var/obj/item/reagent_containers/food/snacks/organ/O = locate() in I.organ_storage.contents
				qdel(O)
				new /mob/living/simple_animal/maggot(I.organ_storage.contents)
	if(prob(10))
		if(milkstock <= 4)
			milkstock += 1
	

