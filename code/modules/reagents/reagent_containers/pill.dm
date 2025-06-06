////////////////////////////////////////////////////////////////////////////////
/// Pills.
////////////////////////////////////////////////////////////////////////////////
/obj/item/reagent_containers/pill
	name = "pill"
	desc = "a pill."
	icon = 'icons/obj/chemical.dmi'
	icon_state = null
	item_state = "pill"
	possible_transfer_amounts = null
	volume = 50
	var/apply_type = INGEST
	var/apply_method = "swallow"


	New()
		..()
		if(!icon_state)
			icon_state = "pill[rand(1,20)]"

	attack_self(mob/user as mob)
		return

	attack(mob/M as mob, mob/user as mob, def_zone)
		if(M == user)

			if(istype(M, /mob/living/carbon/human))
				var/mob/living/carbon/human/H = M
				if(H.special == "afraidmed")
					H.rotate_plane()
				if(H.species.flags & IS_SYNTHETIC)
					H << "\red You have a monitor for a head, where do you think you're going to put that?"
					return

			M << "<span class='notice'>You [apply_method] [src].</span>"
			M.drop_from_inventory(src) //icon update
			if(reagents.total_volume)
				reagents.reaction(M, apply_type)
				spawn(5)
					reagents.trans_to(M, reagents.total_volume)
					qdel(src)
			else
				qdel(src)
			return 1

		else
			if(istype(M, /mob/living/carbon/human) )

				var/mob/living/carbon/human/H = M
				if(H.species.flags & IS_SYNTHETIC)
					H << "\red They have a monitor for a head, where do you think you're going to put that?"
					return

			M.visible_message("<span class='danger'>[user] attempts to force [M] to [apply_method] [src].</span>", \
								"<span class='userdanger'>[user] attempts to force [M] to [apply_method] [src].</span>")

			if(!do_mob(user, M)) return

			M.visible_message("<span class='danger'>[user] forces [M] to [apply_method] [src].</span>", \
								"<span class='userdanger'>[user] forces [M] to [apply_method] [src].</span>")


			user.drop_from_inventory(src) //icon update

			M.attack_log += text("\[[time_stamp()]\] <font color='orange'>Has been fed [src.name] by [user.name] ([user.ckey]) Reagents: [reagentlist(src)]</font>")
			user.attack_log += text("\[[time_stamp()]\] <font color='red'>Fed [M.name] by [M.name] ([M.ckey]) Reagents: [reagentlist(src)]</font>")
			msg_admin_attack("[user.name] ([user.ckey]) fed [M.name] ([M.ckey]) with [src.name] Reagents: [reagentlist(src)] (INTENT: [uppertext(user.a_intent)]) (<A HREF='byond://?_src_=holder;adminplayerobservecoodjump=1;X=[user.x];Y=[user.y];Z=[user.z]'>JMP</a>)")

		if(reagents.total_volume)
			reagents.reaction(M, apply_type)
			spawn(5)
				reagents.trans_to(M, reagents.total_volume)
				qdel(src)
		else
			qdel(src)

			return 1

		return 0

	afterattack(obj/target, mob/user, proximity)
		if(!proximity) return

		if(target.is_open_container() != 0 && target.reagents)
			if(!target.reagents.total_volume)
				user << "\red [target] is empty. Cant dissolve pill."
				return
			user << "\blue You dissolve the pill in [target]"

			user.attack_log += text("\[[time_stamp()]\] <font color='red'>Spiked \a [target] with a pill. Reagents: [reagentlist(src)]</font>")
			msg_admin_attack("[user.name] ([user.ckey]) spiked \a [target] with a pill. Reagents: [reagentlist(src)] (INTENT: [uppertext(user.a_intent)]) (<A HREF='byond://?_src_=holder;adminplayerobservecoodjump=1;X=[user.x];Y=[user.y];Z=[user.z]'>JMP</a>)")

			reagents.trans_to(target, reagents.total_volume)
			for(var/mob/O in viewers(2, user))
				O.show_message("\red [user] puts something in \the [target].", 1)

			spawn(5)
				qdel(src)

		return

////////////////////////////////////////////////////////////////////////////////
/// Pills. END
////////////////////////////////////////////////////////////////////////////////

//Pills
/obj/item/reagent_containers/pill/antitox
	name = "Charcoal pill"
	desc = "Neutralizes many common toxins."
	icon_state = "pill17"
	New()
		..()
		reagents.add_reagent("charcoal", 25)

/obj/item/reagent_containers/pill/tox
	name = "Toxins pill"
	desc = "Highly toxic."
	icon_state = "pill5"
	New()
		..()
		reagents.add_reagent("toxin", 50)

/obj/item/reagent_containers/pill/cyanide
	name = "Cyanide pill"
	desc = "Don't swallow this."
	icon_state = "pill5"
	New()
		..()
		reagents.add_reagent("cyanide", 50)

/obj/item/reagent_containers/pill/adminordrazine
	name = "Adminordrazine pill"
	desc = "It's magic. We don't have to explain it."
	icon_state = "pill16"
	New()
		..()
		reagents.add_reagent("adminordrazine", 50)

/obj/item/reagent_containers/pill/morphine
	name = "morphine pill"
	desc = "Commonly used to treat insomnia."
	icon_state = "pill8"
	list_reagents = list("morphine" = 50)

/obj/item/reagent_containers/pill/stimulant
	name = "stimulant pill"
	desc = "Often taken by overworked employees, athletes, and the inebriated. You'll snap to attention immediately!"
	icon_state = "pill19"
	list_reagents = list("ephedrine" = 10, "ethylredoxrazine" = 10, "coffee" = 30)


/obj/item/reagent_containers/pill/kelotane
	name = "Kelotane pill"
	desc = "Used to treat burns."
	icon_state = "pill11"
	New()
		..()
		reagents.add_reagent("salglu_solution", 15)

/obj/item/reagent_containers/pill/paracetamol
	name = "Paracetamol pill"
	desc = "Tylenol! A painkiller for the ages. Chewables!"
	icon_state = "pill8"
	New()
		..()
		reagents.add_reagent("paracetamol", 25)

/obj/item/reagent_containers/pill/tramadol
	name = "Tramadol pill"
	desc = "A simple painkiller."
	icon_state = "pill8"
	New()
		..()
		reagents.add_reagent("tramadol", 25)


/obj/item/reagent_containers/pill/methylphenidate
	name = "Methylphenidate pill"
	desc = "Improves the ability to concentrate."
	icon_state = "pill8"
	New()
		..()
		reagents.add_reagent("methylphenidate", 15)

/obj/item/reagent_containers/pill/citalopram
	name = "Citalopram pill"
	desc = "Mild anti-depressant."
	icon_state = "pill8"
	New()
		..()
		reagents.add_reagent("citalopram", 15)

/obj/item/reagent_containers/pill/epinephrine
	name = "epinephrine pill"
	desc = "Used to stabilize patients."
	icon_state = "pill5"
	list_reagents = list("epinephrine" = 25)

/obj/item/reagent_containers/pill/salbutamol
	name = "Salbutamol pill"
	desc = "Used to treat oxygen deprivation."
	icon_state = "pill16"
	New()
		..()
		reagents.add_reagent("salbutamol", 15)


/obj/item/reagent_containers/pill/salglu_solution
	name = "salglu_solution pill"
	desc = "Used to treat physical injuries."
	icon_state = "pill18"
	New()
		..()
		reagents.add_reagent("salglu_solution", 20)

/obj/item/reagent_containers/pill/happy
	name = "Happy pill"
	desc = "Happy happy joy joy!"
	icon_state = "pill18"
	New()
		..()
		reagents.add_reagent("space_drugs", 15)
		reagents.add_reagent("sugar", 15)

/obj/item/reagent_containers/pill/zoom
	name = "Zoom pill"
	desc = "Zoooom!"
	icon_state = "pill18"
	New()
		..()
		reagents.add_reagent("impedrezene", 10)
		reagents.add_reagent("synaptizine", 5)
		reagents.add_reagent("morphine", 5)

/obj/item/reagent_containers/pill/salicyclic
	name = "salicyclic acid pill"
	desc = "Used to dull pain."
	icon_state = "pill5"
	list_reagents = list("sal_acid" = 50)

/obj/item/reagent_containers/pill/mutadone
	name = "mutadone pill"
	desc = "Used to treat genetic damage."
	icon_state = "pill20"
	list_reagents = list("mutadone" = 50)

/obj/item/reagent_containers/pill/mannitol
	name = "mannitol pill"
	desc = "Used to treat brain damage."
	icon_state = "pill17"
	list_reagents = list("mannitol" = 50)

/obj/item/reagent_containers/pill/charcoal
	name = "Charcoal pill"
	desc = "Neutralizes many common toxins."
	icon_state = "pill17"
	list_reagents = list("charcoal" = 50)
