
///////////////////////////////////////////////Condiments
//Notes by Darem: The condiments food-subtype is for stuff you don't actually eat but you use to modify existing food. They all
//	leave empty containers when used up and can be filled/re-filled with other items. Formatting for first section is identical
//	to mixed-drinks code. If you want an object that starts pre-loaded, you need to make it in addition to the other code.

//Food items that aren't eaten normally and leave an empty container behind.
/obj/item/reagent_containers/food/condiment
	name = "Condiment Container"
	desc = "Just your average condiment container."
	icon = 'icons/obj/food.dmi'
	icon_state = "emptycondiment"
	flags = FPRINT | TABLEPASS | OPENCONTAINER
	possible_transfer_amounts = list(1,5,10)
	volume = 50

	attackby(obj/item/W as obj, mob/user as mob)

		return
	attack_self(mob/user as mob)
		return
	attack(mob/M as mob, mob/user as mob, def_zone)
		var/datum/reagents/R = src.reagents

		if(!R || !R.total_volume)
			user << "\red None of [src] left, oh no!"
			return 0

		if(!canconsume(M, user))
			return 0

		if(M == user)
			if (M.zone_sel.selecting == "mouth")
				M << "\blue You swallow some of contents of the [src]."
				if(reagents.total_volume)
					reagents.reaction(M, INGEST)
					spawn(5)
						reagents.trans_to(M, 10)
			else
				M << "\red I can't use that, I must drink it with my mouth."
				return 0

			playsound(M.loc,pick('sound/effects/glass_drink1.ogg','sound/effects/glass_drink2.ogg','sound/effects/glass_drink3.ogg','sound/effects/glass_drink4.ogg','sound/effects/glass_drink5.ogg'), rand(50,60), 0)
			return 1
		else if( istype(M, /mob/living/carbon/human) )

			for(var/mob/O in viewers(world.view, user))
				O.show_message("\red [user] attempts to feed [M] [src].", 1)
			if(!do_mob(user, M)) return
			for(var/mob/O in viewers(world.view, user))
				O.show_message("\red [user] feeds [M] [src].", 1)

			M.attack_log += text("\[[time_stamp()]\] <font color='orange'>Has been fed [src.name] by [user.name] ([user.ckey]) Reagents: [reagentlist(src)]</font>")
			user.attack_log += text("\[[time_stamp()]\] <font color='red'>Fed [src.name] by [M.name] ([M.ckey]) Reagents: [reagentlist(src)]</font>")
			msg_admin_attack("[user.name] ([user.ckey]) fed [M.name] ([M.ckey]) with [src.name] (INTENT: [uppertext(user.a_intent)]) (<A HREF='byond://?_src_=holder;adminplayerobservecoodjump=1;X=[user.x];Y=[user.y];Z=[user.z]'>JMP</a>)")

			if(reagents.total_volume)
				reagents.reaction(M, INGEST)
				spawn(5)
					reagents.trans_to(M, 10)

			playsound(M.loc,pick('sound/effects/glass_drink1.ogg','sound/effects/glass_drink2.ogg','sound/effects/glass_drink3.ogg','sound/effects/glass_drink4.ogg','sound/effects/glass_drink5.ogg'), rand(50,60), 0)
			return 1
		return 0

	attackby(obj/item/I as obj, mob/user as mob)

		return

	afterattack(obj/target, mob/user , flag)
		if(istype(target, /obj/structure/reagent_dispensers)) //A dispenser. Transfer FROM it TO us.

			if(!target.reagents.total_volume)
				user << "\red [target] is empty."
				return

			if(reagents.total_volume >= reagents.maximum_volume)
				user << "\red [src] is full."
				return

			var/trans = target.reagents.trans_to(src, target:amount_per_transfer_from_this)
			user << "\blue You fill [src] with [trans] units of the contents of [target]."

		//Something like a glass or a food item. Player probably wants to transfer TO it.
		else if(target.is_open_container() || istype(target, /obj/item/reagent_containers/food/snacks))
			if(!reagents.total_volume)
				user << "\red [src] is empty."
				return
			if(target.reagents.total_volume >= target.reagents.maximum_volume)
				user << "\red you can't add anymore to [target]."
				return
			var/trans = src.reagents.trans_to(target, amount_per_transfer_from_this)
			user << "\blue You transfer [trans] units of the condiment to [target]."

	on_reagent_change()
		if(icon_state == "saltshakersmall" || icon_state == "peppermillsmall")
			return
		if(reagents.reagent_list.len > 0)
			switch(reagents.get_master_reagent_id())
				if("ketchup")
					name = "Ketchup"
					desc = "You feel more American already."
					icon_state = "ketchup"
				if("capsaicin")
					name = "Hotsauce"
					desc = "You can almost TASTE the stomach ulcers now!"
					icon_state = "hotsauce"
				if("enzyme")
					name = "Universal Enzyme"
					desc = "Used in cooking various dishes."
					icon_state = "enzyme"
				if("soysauce")
					name = "Soy Sauce"
					desc = "A salty soy-based flavoring."
					icon_state = "soysauce"
				if("frostoil")
					name = "Coldsauce"
					desc = "Leaves the tongue numb in its passage."
					icon_state = "coldsauce"
				if("sodiumchloride")
					name = "Salt Shaker"
					desc = "Salt. From space oceans, presumably."
					icon_state = "saltshaker"
				if("blackpepper")
					name = "Pepper Mill"
					desc = "Often used to flavor food or make people sneeze."
					icon_state = "peppermillsmall"
				if("cornoil")
					name = "Corn Oil"
					desc = "A delicious oil used in cooking. Made from corn."
					icon_state = "oliveoil"
				if("sugar")
					name = "Sugar"
					desc = "Tastey space sugar!"
				else
					name = "Misc Condiment Bottle"
					if (reagents.reagent_list.len==1)
						desc = "Looks like it is [reagents.get_master_reagent_name()], but you are not sure."
					else
						desc = "A mixture of various condiments. [reagents.get_master_reagent_name()] is one of them."
					icon_state = "mixedcondiments"
		else
			icon_state = "emptycondiment"
			name = "Condiment Bottle"
			desc = "An empty condiment bottle."
			return

/obj/item/reagent_containers/food/condiment/enzyme
	name = "Universal Enzyme"
	desc = "Used in cooking various dishes."
	icon_state = "enzyme"
	New()
		..()
		reagents.add_reagent("enzyme", 50)

/obj/item/reagent_containers/food/condiment/sugar
	New()
		..()
		reagents.add_reagent("sugar", 50)

/obj/item/reagent_containers/food/condiment/saltshaker		//Seperate from above since it's a small shaker rather then
	name = "Salt Shaker"											//	a large one.
	desc = "Salt. From space oceans, presumably."
	icon_state = "saltshakersmall"
	possible_transfer_amounts = list(1,20) //for clown turning the lid off
	amount_per_transfer_from_this = 1
	volume = 20
	New()
		..()
		reagents.add_reagent("sodiumchloride", 20)

/obj/item/reagent_containers/food/condiment/saltshaker/attack_self(mob/user as mob)
	if(volume < 4)
		return
	volume -= 4
	var/turf/T = get_turf(src)
	new /obj/item/reagent_containers/food/snacks/salt(T)


/obj/item/reagent_containers/food/snacks/salt
	name = "salt"
	icon_state = "powder"
	filling_color = "#211F02"
	New()
		..()
		reagents.add_reagent("sodiumchloride", 4)

/obj/item/reagent_containers/food/snacks/cocaine
	name = "powder"
	icon_state = "powder"
	filling_color = "#211F02"
	New()
		..()
		reagents.add_reagent("cocaine", 5)

/obj/item/reagent_containers/food/snacks/cocaine/clean_mmb(mob/living/carbon/human/user)
	if(do_after(user,10))
		user.visible_message("<span class='passivebold'>[user]</span><span class='passive'> sniffs the [src]!</span>")
		reagents.add_reagent("cocaine", 10)
		src.reagents.reaction(user, INGEST)
		src.reagents.trans_to(user, 15)
		playsound(user,pick('sound/webbers/sniff.ogg'), rand(50,60), 0)
		qdel(src)

/obj/item/reagent_containers/food/snacks/salt/Crossed(AM as mob|obj)
	if(isobserver(AM))
		var/mob/dead/observer/O = AM
		O.Sendtohell()
		return

/obj/item/reagent_containers/food/condiment/peppermill
	name = "Pepper Mill"
	desc = "Often used to flavor food or make people sneeze."
	icon_state = "peppermillsmall"
	possible_transfer_amounts = list(1,20) //for clown turning the lid off
	amount_per_transfer_from_this = 1
	volume = 20
	New()
		..()
		reagents.add_reagent("blackpepper", 20)

/obj/item/reagent_containers/food/condiment/ketchup
	name = "Ketchup"
	desc = "You feel more American already."
	icon_state = "ketchup"
	possible_transfer_amounts = list(1,20) //for clown turning the lid off
	amount_per_transfer_from_this = 1
	volume = 50
	New()
		..()
		reagents.add_reagent("ketchup", 50)


// ALCOHOLISM SNIFFABLE GLUE :tm:

// Stimulants | Rip off your wifes head and beat your kids!

/obj/item/reagent_containers/food/snacks/apvp
	name = "powder"
	icon_state = "powder"
	filling_color = "#211F02"
	New()
		..()
		reagents.add_reagent("apvp", 5)

/obj/item/reagent_containers/food/snacks/apvp/clean_mmb(mob/living/carbon/human/user)
	if(do_after(user,10))
		user.visible_message("<span class='passivebold'>[user]</span><span class='passive'> sniffs the [src]!</span>")
		reagents.add_reagent("apvp", 5)
		src.reagents.reaction(user, INGEST)
		src.reagents.trans_to(user, 15)
		playsound(user,pick('sound/webbers/sniff.ogg'), rand(50,60), 0)
		qdel(src)



/obj/item/reagent_containers/food/snacks/meth
	name = "powder"
	icon_state = "powder"
	filling_color = "#211F02"
	New()
		..()
		reagents.add_reagent("amphetamine", 5)

/obj/item/reagent_containers/food/snacks/meth/clean_mmb(mob/living/carbon/human/user)
	if(do_after(user,10))
		user.visible_message("<span class='passivebold'>[user]</span><span class='passive'> sniffs the [src]!</span>")
		reagents.add_reagent("amphetamine", 5)
		src.reagents.reaction(user, INGEST)
		src.reagents.trans_to(user, 15)
		playsound(user,pick('sound/webbers/sniff.ogg'), rand(50,60), 0)
		qdel(src)


// Opiods! | I'm so cool bro

/obj/item/reagent_containers/food/snacks/desomorphine
	name = "powder"
	icon_state = "powder"
	filling_color = "#211F02"
	New()
		..()
		reagents.add_reagent("heroinlq", 5)

/obj/item/reagent_containers/food/snacks/desomorphine/clean_mmb(mob/living/carbon/human/user)
	if(do_after(user,10))
		user.visible_message("<span class='passivebold'>[user]</span><span class='passive'> sniffs the [src]!</span>")
		reagents.add_reagent("heroinlq", 5)
		src.reagents.reaction(user, INGEST)
		src.reagents.trans_to(user, 15)
		playsound(user,pick('sound/webbers/sniff.ogg'), rand(50,60), 0)
		qdel(src)

/obj/item/reagent_containers/food/snacks/morphine
	name = "powder"
	icon_state = "powder"
	filling_color = "#211F02"
	New()
		..()
		reagents.add_reagent("heroinhq", 5)

/obj/item/reagent_containers/food/snacks/morphine/clean_mmb(mob/living/carbon/human/user)
	if(do_after(user,10))
		user.visible_message("<span class='passivebold'>[user]</span><span class='passive'> sniffs the [src]!</span>")
		reagents.add_reagent("heroinhq", 5)
		src.reagents.reaction(user, INGEST)
		src.reagents.trans_to(user, 15)
		playsound(user,pick('sound/webbers/sniff.ogg'), rand(50,60), 0)
		qdel(src)