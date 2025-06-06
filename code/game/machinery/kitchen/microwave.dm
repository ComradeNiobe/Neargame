
/obj/machinery/microwave
	name = "Furnace"
	icon = 'icons/obj/kitchen.dmi'
	icon_state = "oven0"
	layer = 2.9
	density = 0
	anchored = 1
	flags = OPENCONTAINER | NOREACT
	var/operating = 0 // Is it on?
	var/global/list/datum/recipe/available_recipes // List of the recipes you can use
	var/global/list/acceptable_items // List of the items you can put in
	var/global/list/acceptable_reagents // List of the reagents you can put in
	var/global/max_n_of_items = 0
	var/efficiency = 0
	var/niggabi
	plane = 21


/obj/machinery/microwave/south
	pixel_y = -32

/obj/machinery/microwave/north
	pixel_y = 32

/obj/machinery/microwave/east
	pixel_x = 32

/obj/machinery/microwave/west
	pixel_x = -32


// see code/modules/food/recipes_microwave.dm for recipes

/*******************
*   Initialising
********************/

/obj/machinery/microwave/New()
	//..() //do not need this
	reagents = new/datum/reagents(100)
	reagents.my_atom = src
	if (!available_recipes)
		available_recipes = new
		for (var/type in (typesof(/datum/recipe)-/datum/recipe/alchemy))//(typesof(/datum/recipe)-/datum/recipe))
			available_recipes+= new type
		acceptable_items = new
		acceptable_reagents = new
		for (var/datum/recipe/recipe in available_recipes)
			for (var/item in recipe.items)
				acceptable_items |= item
			for (var/reagent in recipe.reagents)
				acceptable_reagents |= reagent
			if (recipe.items)
				max_n_of_items = max(max_n_of_items,recipe.items.len)

		acceptable_items |= /obj/item/mob_holder

/*******************
*   Item Adding
********************/

/obj/machinery/microwave/New()
	..()
	processing_objects.Add(src)

/obj/machinery/microwave/process()
	if(operating)
		playsound(src, 'sound/webbers/bigfireloop.ogg', 100, wait=1, repeat=0)


/obj/machinery/microwave/attackby(var/obj/item/O as obj, var/mob/user as mob)
	if(operating)
		return

	else if(istype(O, /obj/item/flame))
		var/obj/item/flame/F = O
		if(F.lit)
			playsound(src.loc, 'sound/effects/torch_light.ogg', 50, 0)
			cook()
		return

	else if(is_type_in_list(O,acceptable_items))
		if (contents.len>=max_n_of_items)
			user << "\red This [src] is full of ingredients, you cannot put more."
			return 1
		if (istype(O,/obj/item/stack) && O:amount>1)
			new O.type (src)
			O:use(1)
			playsound(src.loc, pick('sound/effects/itm_ingredient_mushroom_up_01.ogg','sound/effects/itm_ingredient_mushroom_up_02.ogg','sound/effects/itm_ingredient_mushroom_up_03.ogg','sound/effects/itm_ingredient_mushroom_up_04.ogg'), 70, 0)
			user.visible_message("<span class='passivebold'>[user]</span> <span class='passive'>has added one of [O] on the [src].</span>")
		else
		//	user.before_take_item(O)	//This just causes problems so far as I can tell. -Pete
			user.drop_item()
			O.loc = src
			playsound(src.loc, pick('sound/effects/itm_ingredient_mushroom_up_01.ogg','sound/effects/itm_ingredient_mushroom_up_02.ogg','sound/effects/itm_ingredient_mushroom_up_03.ogg','sound/effects/itm_ingredient_mushroom_up_04.ogg'), 70, 0)
			user.visible_message("<span class='passivebold'>[user]</span> <span class='passive'>adds [O] on the [src].</span>")
	else if(istype(O,/obj/item/reagent_containers/glass) || \
	        istype(O,/obj/item/reagent_containers/food/drinks) || \
	        istype(O,/obj/item/reagent_containers/food/condiment) \
		)
		if (!O.reagents)
			return 1
		for (var/datum/reagent/R in O.reagents.reagent_list)
			if (!(R.id in acceptable_reagents))
				user << "\red Your [O] contains components unsuitable for cookery."
				return 1
		//G.reagents.trans_to(src,G.amount_per_transfer_from_this)
	else if(istype(O,/obj/item/grab))
		var/obj/item/grab/G = O
		user << "\red This is ridiculous. You can not fit \the [G.affecting] in this [src]."
		return 1
	else
		user << "\red You have no idea what you can cook with this [O]."
		return 1
	src.updateUsrDialog()

/obj/machinery/microwave/attack_paw(mob/user as mob)
	return src.attack_hand(user)

/obj/machinery/microwave/attack_ai(mob/user as mob)
	return 0

/obj/machinery/microwave/attack_hand(mob/user as mob)
	if(operating)
		operating = 0

/obj/machinery/microwave/RightClick(mob/user as mob)
	if(usr.get_active_hand() != null)
		return
	else
		if(!operating)
			dispose()
/*******************
*   Microwave Menu
********************/

/obj/machinery/microwave/interact(mob/user as mob) // The microwave Menu
	var/dat = ""
	if(src.operating)
		dat = {"<TT>Microwaving in progress!<BR>Please wait...!</TT>"}
	else
		var/list/items_counts = new
		var/list/items_measures = new
		var/list/items_measures_p = new
		for (var/obj/O in contents)
			var/display_name = O.name
			if (istype(O,/obj/item/reagent_containers/food/snacks/egg))
				items_measures[display_name] = "egg"
				items_measures_p[display_name] = "eggs"
			if (istype(O,/obj/item/reagent_containers/food/snacks/tofu))
				items_measures[display_name] = "tofu chunk"
				items_measures_p[display_name] = "tofu chunks"
			if (istype(O,/obj/item/reagent_containers/food/snacks/meat)) //any meat
				items_measures[display_name] = "slab of meat"
				items_measures_p[display_name] = "slabs of meat"
			if (istype(O,/obj/item/reagent_containers/food/snacks/donkpocket))
				display_name = "Turnovers"
				items_measures[display_name] = "turnover"
				items_measures_p[display_name] = "turnovers"
			if (istype(O,/obj/item/reagent_containers/food/snacks/carpmeat))
				items_measures[display_name] = "fillet of meat"
				items_measures_p[display_name] = "fillets of meat"
			items_counts[display_name]++
		for (var/O in items_counts)
			var/N = items_counts[O]
			if (!(O in items_measures))
				dat += {"<B>[capitalize(O)]:</B> [N] [lowertext(O)]\s<BR>"}
			else
				if (N==1)
					dat += {"<B>[capitalize(O)]:</B> [N] [items_measures[O]]<BR>"}
				else
					dat += {"<B>[capitalize(O)]:</B> [N] [items_measures_p[O]]<BR>"}

		for (var/datum/reagent/R in reagents.reagent_list)
			var/display_name = R.name
			if (R.id == "capsaicin")
				display_name = "Hotsauce"
			if (R.id == "frostoil")
				display_name = "Coldsauce"
			dat += {"<B>[display_name]:</B> [R.volume] unit\s<BR>"}

		if (items_counts.len==0 && reagents.reagent_list.len==0)
			dat = {"<B>The microwave is empty</B><BR>"}
		else
			dat = {"<b>Ingredients:</b><br>[dat]"}
		dat += {"<HR><BR>\
<A href='byond://?src=\ref[src];action=cook'>Turn on!<BR>\
<A href='byond://?src=\ref[src];action=dispose'>Eject ingredients!<BR>\
"}

	user << browse("<HEAD><TITLE>Microwave Controls</TITLE></HEAD><TT>[dat]</TT>", "window=microwave")
	onclose(user, "microwave")
	return



/***********************************
*   Microwave Menu Handling/Cooking
************************************/

/obj/machinery/microwave/proc/cook()
	start()
/*	if (reagents.total_volume==0 && !(locate(/obj) in contents)) //dry run
		if (!wzhzhzh(10))
			abort()
			return
		stop()
		return*/

	var/datum/recipe/recipe = select_recipe(available_recipes,src)
	var/obj/cooked
	if (!recipe)
		if (!wzhzhzh(10))
			abort()
			return
		stop()
		cooked = fail()
		cooked.loc = src.loc
		return
	else
		//var/halftime = round(recipe.time/10/2)
/*		if (!wzhzhzh(halftime))
			abort()
			return
		if (!wzhzhzh(halftime))
			abort()
			cooked = fail()
			cooked.loc = src.loc
			return*/
		sleep(rand(100,200))
		if(operating)
			cooked = recipe.make_food(src)
			if(cooked)
				cooked.loc = src
			stop()
		return

/obj/machinery/microwave/proc/wzhzhzh(var/seconds as num)
	for (var/i=1 to seconds)
		sleep(10)
	return 1

/obj/machinery/microwave/proc/has_extra_item()
	for (var/obj/O in contents)
		if ( \
				!istype(O,/obj/item/reagent_containers/food) && \
				!istype(O, /obj/item/grown) \
			)
			return 1
	return 0

/obj/machinery/microwave/proc/start()
	src.operating = 1
	src.icon_state = "oven1"
	set_light(3, 5, "#bf915c")

/obj/machinery/microwave/proc/abort()
	src.operating = 0 // Turn it off again aferwards
	src.icon_state = "oven0"
/obj/machinery/microwave/proc/stop()
	//playsound(src.loc, 'sound/machines/ding.ogg', 50, 1)
	src.operating = 0 // Turn it off again aferwards
	src.icon_state = "oven0"
	src.visible_message("<span class='bname'>Dish is ready!</span>")
	playsound(src.loc, 'sound/effects/torch_snuff.ogg', 75, 0)
	set_light(0)

/obj/machinery/microwave/proc/dispose()
	for (var/obj/O in contents)
		O.loc = src.loc
	src.reagents.clear_reagents()

/obj/machinery/microwave/proc/fail()
	var/obj/item/reagent_containers/food/snacks/badrecipe/ffuu = new(src)
	var/amount = 0
	for (var/obj/O in contents-ffuu)
		amount++
		if (O.reagents)
			var/id = O.reagents.get_master_reagent_id()
			if (id)
				amount+=O.reagents.get_reagent_amount(id)
		qdel(O)
	src.reagents.clear_reagents()
	ffuu.reagents.add_reagent("carbon", amount)
	ffuu.reagents.add_reagent("toxin", (amount/10)*efficiency)
	return ffuu

/obj/machinery/microwave/Topic(href, href_list)
	if(..())
		return

	usr.set_machine(src)
	if(src.operating)
		src.updateUsrDialog()
		return

	switch(href_list["action"])
		if ("cook")
			cook()

		if ("dispose")
			dispose()
	return
