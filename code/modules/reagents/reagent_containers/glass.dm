
////////////////////////////////////////////////////////////////////////////////
/// (Mixing)Glass.
////////////////////////////////////////////////////////////////////////////////
/obj/item/reagent_containers/glass
	name = " "
	var/base_name = " "
	desc = " "
	icon = 'icons/obj/chemical.dmi'
	icon_state = "null"
	item_state = "null"
	amount_per_transfer_from_this = 10
	possible_transfer_amounts = list(5,10,15,25,30,50)
	volume = 50
	flags = FPRINT | TABLEPASS | OPENCONTAINER
	var/smerd = 0

	var/label_text = ""

	var/list/can_be_placed_into = list(
		/obj/machinery/chem_master/,
		/obj/machinery/chem_dispenser/,
		/obj/machinery/chem_heater/,
		/obj/machinery/reagentgrinder,
		/obj/structure/table,
		/obj/structure/rack,
		/obj/structure/closet,
		/obj/structure/sink,
		/obj/item/storage,
		/obj/machinery/atmospherics/unary/cryo_cell,
		/obj/machinery/dna_scannernew,
		/obj/item/grenade/chem_grenade,
		/obj/machinery/bot/medbot,
		/obj/machinery/computer/pandemic,
		/obj/item/storage/secure/safe,
		/obj/machinery/iv_drip,
		/obj/machinery/disease2/incubator,
		/obj/machinery/disposal,
		/mob/living/simple_animal/cow,
		/mob/living/simple_animal/hostile/retaliate/goat,
		/obj/machinery/computer/centrifuge,
		/obj/machinery/sleeper	)

	New()
		..()
		base_name = name

	examine()
		set src in view()
		..()
		if (!(usr in view(2)) && usr!=src.loc) return
		if(reagents && reagents.reagent_list.len)
			to_chat(usr, "\blue It contains [src.reagents.total_volume] units of liquid.")
			if(istype(usr, /mob/living/carbon/human))
				var/mob/living/carbon/human/H = usr
				if(H.glasses && istype(H.glasses, /obj/item/clothing/glasses/science))
					var/reagents_length = reagents.reagent_list.len
					to_chat(usr, "\icon[H.glasses] \blue [reagents_length] chemical agent[reagents_length > 1 ? "s" : ""] found.")
					for (var/re in reagents.reagent_list)
						to_chat(usr, "\blue \t [re]")
		else
			to_chat(usr, "\blue It is empty.")
		if (!is_open_container())
			to_chat(usr, "\blue Airtight lid seals it completely.")

	attack_self()
		..()
		if (is_open_container())
			to_chat(usr, "<span class = 'notice'>You put the lid on \the [src].")
			flags ^= OPENCONTAINER
		else
			to_chat(usr, "<span class = 'notice'>You take the lid off \the [src].")
			flags |= OPENCONTAINER
		update_icon()

	afterattack(obj/target, mob/user , flag)

		if (!is_open_container() || !flag)
			return

		for(var/type in src.can_be_placed_into)
			if(istype(target, type))
				return

		if(ismob(target) && target.reagents && reagents.total_volume)
			var/mob/living/M = target
			if(user.zone_sel.selecting == "mouth")
				if(!reagents.total_volume)
					to_chat(user, "<span class='combatbold'>[pick(fnord)]</span> <span class='combat'>\the<span class='combatbold'>[src]</span> is empty!</span>")
					return
				if(user == M)
					to_chat(user,"<span class='passive'> You drink from <span class='passivebold'>[src]</span>.</span>")
					if(reagents.total_volume)
						reagents.reaction(M, INGEST, override = amount_per_transfer_from_this)
						playsound(M.loc,pick('sound/effects/glass_drink1.ogg','sound/effects/glass_drink2.ogg','sound/effects/glass_drink3.ogg','sound/effects/glass_drink4.ogg','sound/effects/glass_drink5.ogg'), rand(10,50), 1)
						spawn(5)
							reagents.trans_to(M, amount_per_transfer_from_this)
				else
					user.visible_message("<span class='combat'><span class='combatbold'>[user]</span> attempts to feed \the <span class='combatbold'>[M]</span> with \the <span class='combatbold'>[src]</span>.</span>")
					if(!do_mob(user, M)) return
					user.visible_message("<span class='combat'><span class='combatbold'>[user]</span> feeds \the <span class='combatbold'>[M]</span> with \the <span class='combatbold'>[src]</span>.</span>")
					if(reagents.total_volume)
						reagents.reaction(M, INGEST)
						playsound(M.loc,pick('sound/effects/glass_drink1.ogg','sound/effects/glass_drink2.ogg','sound/effects/glass_drink3.ogg','sound/effects/glass_drink4.ogg','sound/effects/glass_drink5.ogg'), rand(10,50), 2)
						spawn(5)
							reagents.trans_to(M, amount_per_transfer_from_this)
				return

			to_chat(user, "<span class='hit'> You splash the solution onto</span><span class='hitbold'> [target].</span>")
			var/list/injected = list()
			for(var/datum/reagent/R in src.reagents.reagent_list)
				injected += R.name
			var/contained = english_list(injected)
			M.attack_log += text("\[[time_stamp()]\] <font color='orange'>Has been splashed with [src.name] by [user.name] ([user.ckey]). Reagents: [contained]</font>")
			user.attack_log += text("\[[time_stamp()]\] <font color='red'>Used the [src.name] to splash [M.name] ([M.key]). Reagents: [contained]</font>")
			msg_admin_attack("[user.name] ([user.ckey]) splashed [M.name] ([M.key]) with [src.name]. Reagents: [contained] (INTENT: [uppertext(user.a_intent)]) (<A HREF='byond://?_src_=holder;adminplayerobservecoodjump=1;X=[user.x];Y=[user.y];Z=[user.z]'>JMP</a>)")

			for(var/mob/O in viewers(world.view, user))
				O.show_message(text(" <span class='hitbold'>[]</span><span class='hit'> has been splashed with something by </span><span class='hitbold'>[]</span><span class='hit'>!</span>", target, user), 1)
			src.reagents.reaction(target, TOUCH)
			spawn(5) src.reagents.clear_reagents()
			return
		else if(istype(target, /obj/structure/reagent_dispensers)) //A dispenser. Transfer FROM it TO us.

			if(!target.reagents.total_volume && target.reagents)
				to_chat(user, "\red [target] is empty.")
				return

			if(reagents.total_volume >= reagents.maximum_volume)
				to_chat(user, "\red [src] is full.")
				return

			var/trans = target.reagents.trans_to(src, target:amount_per_transfer_from_this)
			to_chat(user, "\blue You fill [src] with [trans] units of the contents of [target].")

		else if(istype(target, /obj/structure/sink))
			return

		else if(istype(target, /obj/structure/lifeweb/statue/well))
			return

		else if(istype(target, /obj/structure/water))
			return

		else if(istype(target, /obj/structure/fireplace/hearth))
			return

		else if(target.is_open_container() && target.reagents) //Something like a glass. Player probably wants to transfer TO it.
			if(!reagents.total_volume)
				to_chat(user, "\red [src] is empty.")
				return

			if(target.reagents.total_volume >= target.reagents.maximum_volume)
				to_chat(user, "\red [target] is full.")
				return

			var/trans = src.reagents.trans_to(target, amount_per_transfer_from_this)
			to_chat(user, "\blue You transfer [trans] units of the solution to [target].")


		else if(reagents.total_volume)
			if(istype(target, /turf/simulated/floor/open))
				var/turf/T = locate(target.x, target.y, target.z-1)
				src.add_fluid_by_transfer(get_turf(T), 5)
				to_chat(user, "\blue You splash the solution onto [T].")
				user.setClickCooldown(DEFAULT_ATTACK_COOLDOWN)
				return
			if(istype(target, /turf/simulated/floor/exoplanet/water/shallow))
				return

			if(istype(target, /obj/reagent))
				if(user.a_intent == "hurt")
					src.add_fluid_by_transfer(get_turf(target), 5)
				return
			src.add_fluid_by_transfer(get_turf(target), 5)
			to_chat(user, "\blue You splash the solution onto [target].")
		if(ismob(target) && target.reagents && !reagents.total_volume)
			to_chat(user, "<span class='passivebold'>None of [src] left, oh no!</span>")
			return 0

	attackby(obj/item/W as obj, mob/user as mob)
		..()
		if(istype(W, /obj/item/pen))
			var/tmp_label = sanitize(input(user, "Enter a label for [src.name]","Label",src.label_text))
			if(length(tmp_label) > 10)
				user << "\red The label can be at most 10 characters long."
			else
				user << "\blue You set the label to \"[tmp_label]\"."
				src.label_text = tmp_label
				src.update_name_label()

	on_reagent_change()
		update_icon()

	pickup(mob/user)
		..()
		update_icon()

	dropped(mob/user)
		..()
		update_icon()

	attack_hand()
		..()
		update_icon()

	proc/update_name_label()
		if(src.label_text == "")
			src.name = src.base_name
		else
			src.name = "[src.base_name] ([src.label_text])"


/obj/item/reagent_containers/glass/throw_impact(atom/hit_atom, speed)
	..(hit_atom, speed)
	if(src.reagents.total_volume)
		src.add_fluid_by_transfer(get_turf(src), src.reagents.total_volume)

/obj/item/reagent_containers/glass/beaker
	name = "beaker"
	desc = "A beaker. Can hold up to 50 units."
	icon = 'icons/obj/chemical.dmi'
	icon_state = "beaker"
	item_state = "beaker"
	m_amt = 0
	g_amt = 500

	update_icon()
		overlays.Cut()

		if(reagents.total_volume)
			var/image/filling = image('icons/obj/reagentfillings.dmi', src, "[icon_state]10")

			var/percent = round((reagents.total_volume / volume) * 100)
			switch(percent)
				if(0 to 9)		filling.icon_state = "[icon_state]-10"
				if(10 to 24) 	filling.icon_state = "[icon_state]10"
				if(25 to 49)	filling.icon_state = "[icon_state]25"
				if(50 to 74)	filling.icon_state = "[icon_state]50"
				if(75 to 79)	filling.icon_state = "[icon_state]75"
				if(80 to 90)	filling.icon_state = "[icon_state]80"
				if(91 to INFINITY)	filling.icon_state = "[icon_state]100"

			filling.icon += mix_color_from_reagents(reagents.reagent_list)
			overlays += filling

		if (!is_open_container())
			var/image/lid = image(icon, src, "lid_[initial(icon_state)]")
			overlays += lid

/obj/item/reagent_containers/glass/beaker/large
	name = "large beaker"
	desc = "A large beaker. Can hold up to 100 units."
	icon_state = "beakerlarge"
	g_amt = 5000
	volume = 100
	amount_per_transfer_from_this = 10
	possible_transfer_amounts = list(5,10,15,25,30,50,100)
	flags = FPRINT | TABLEPASS | OPENCONTAINER

/obj/item/reagent_containers/glass/beaker/noreact
	name = "cryostasis beaker"
	desc = "A cryostasis beaker that allows for chemical storage without reactions. Can hold up to 50 units."
	icon_state = "beakernoreact"
	g_amt = 500
	volume = 50
	amount_per_transfer_from_this = 10
	flags = FPRINT | TABLEPASS | OPENCONTAINER | NOREACT

/obj/item/reagent_containers/glass/beaker/bluespace
	name = "bluespace beaker"
	desc = "A bluespace beaker, powered by experimental bluespace technology. Can hold up to 300 units."
	icon_state = "beakerbluespace"
	g_amt = 5000
	volume = 300
	amount_per_transfer_from_this = 10
	possible_transfer_amounts = list(5,10,15,25,30,50,100,300)
	flags = FPRINT | TABLEPASS | OPENCONTAINER


/obj/item/reagent_containers/glass/beaker/vial
	name = "vial"
	desc = "A small glass vial. Can hold up to 25 units."
	icon_state = "vial"
	g_amt = 250
	volume = 30
	amount_per_transfer_from_this = 10
	possible_transfer_amounts = list(5,10,15,30)
	flags = FPRINT | TABLEPASS | OPENCONTAINER

/obj/item/reagent_containers/glass/beaker/cryoxadone
	New()
		..()
		reagents.add_reagent("cryoxadone", 30)
		update_icon()

/obj/item/reagent_containers/glass/beaker/sulphuric
	New()
		..()
		reagents.add_reagent("sacid", 50)
		update_icon()

/obj/item/reagent_containers/glass/bucket
	desc = "It's a bucket."
	name = "bucket"
	icon = 'icons/obj/janitor.dmi'
	icon_state = "bucket"
	item_state = "bucket"
	m_amt = 200
	g_amt = 0
	w_class = 3.0
	amount_per_transfer_from_this = 20
	possible_transfer_amounts = list(10,20,30,50,70)
	volume = 70
	flags = FPRINT | OPENCONTAINER

	attackby(var/obj/D, mob/user as mob)
		if(isprox(D))
			user << "You add [D] to [src]."
			qdel(D)
			user.put_in_hands(new /obj/item/bucket_sensor)
			user.drop_from_inventory(src)
			qdel(src)

// vials are defined twice, what?
/*
/obj/item/reagent_containers/glass/beaker/vial
	name = "vial"
	desc = "Small glass vial. Looks fragile."
	icon_state = "vial"
	g_amt = 500
	volume = 15
	amount_per_transfer_from_this = 5
	possible_transfer_amounts = list(1,5,15)
	flags = FPRINT | TABLEPASS | OPENCONTAINER */

/*
/obj/item/reagent_containers/glass/blender_jug
	name = "Blender Jug"
	desc = "A blender jug, part of a blender."
	icon = 'icons/obj/kitchen.dmi'
	icon_state = "blender_jug_e"
	volume = 100

	on_reagent_change()
		switch(src.reagents.total_volume)
			if(0)
				icon_state = "blender_jug_e"
			if(1 to 75)
				icon_state = "blender_jug_h"
			if(76 to 100)
				icon_state = "blender_jug_f"

/obj/item/reagent_containers/glass/canister		//not used apparantly
	desc = "It's a canister. Mainly used for transporting fuel."
	name = "canister"
	icon = 'icons/obj/tank.dmi'
	icon_state = "canister"
	item_state = "canister"
	m_amt = 300
	g_amt = 0
	w_class = 4.0

	amount_per_transfer_from_this = 20
	possible_transfer_amounts = list(10,20,30,60)
	volume = 120
	flags = FPRINT

/obj/item/reagent_containers/glass/dispenser
	name = "reagent glass"
	desc = "A reagent glass."
	icon = 'icons/obj/icons/obj/chemical.dmi'
	icon_state = "beaker0"
	amount_per_transfer_from_this = 10
	flags = FPRINT | TABLEPASS | OPENCONTAINER

/obj/item/reagent_containers/glass/dispenser/surfactant
	name = "reagent glass (surfactant)"
	icon_state = "liquid"

	New()
		..()
		reagents.add_reagent("fluorosurfactant", 20)

*/
