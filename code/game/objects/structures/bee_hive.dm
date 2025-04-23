/obj/item/storage/bee_hive
	name = "Bee Hive"
	icon = 'icons/obj/lw_bees.dmi'
	icon_state = "hive1"
	density = FALSE
	anchored = FALSE
	w_class = 8.0 // No, you may not have pocket or backpack pipe-bee-bombs.
	can_hold = list(
		"/obj/item/reagent_containers/food/snacks/honeycomb",
	)
	var/burned = FALSE
	var/without_honey = FALSE
	var/last_time = 0
	var/mob/living/carbon/human/mob_targeted
	var/mob/living/simple_animal/bee/child_bee
	COOLDOWN_DECLARE(honey_time)

/obj/item/storage/bee_hive/New()
	. = ..()
	last_time = world.time
	new /obj/item/reagent_containers/food/snacks/honeycomb(src)
	processing_objects.Add(src)

/obj/item/storage/bee_hive/Destroy()
	. = ..()
	processing_objects.Remove(src)

/obj/item/storage/bee_hive/process()
	if(contents && without_honey)
		var/obj/item/reagent_containers/food/snacks/honeycomb/honey_comb
		if(contents.Find(honey_comb))
			without_honey = FALSE

	else if(!(length(contents)))
		without_honey = TRUE

	if(!without_honey)
		if((COOLDOWN_FINISHED(src, honey_time)) && (length(contents) < storage_slots))
			new /obj/item/reagent_containers/food/snacks/honeycomb(src)
			COOLDOWN_START(src, honey_time, 10 MINUTES)

		if(!mob_targeted)
			for(var/mob/living/carbon/human/M in view(5, src))
				if((!M.stat && !iszombie(M)) && !(M.check_perk(/datum/perk/bee_queen)))
					child_bee = new /mob/living/simple_animal/bee(loc)
					child_bee.target_mob = M
					child_bee.hive = src
					mob_targeted = M
					break
	update_icon()

/obj/item/storage/bee_hive/attackby(var/obj/item/O, var/mob/user)
	if(istype(O, /obj/item/flame))
		var/obj/item/flame/F = O
		if(F.lit)
			processing_objects.Remove(src)
			burned = TRUE
			without_honey = TRUE
			for(var/obj/item/reagent_containers/food/snacks/honeycomb/H in contents)
				qdel(H)
				new /obj/item/wax(src)
			update_icon()

	else if(istype(O, /obj/item/wax) && ishuman(user))
		var/mob/living/carbon/human/H = user
		if(H.check_perk(/datum/perk/bees))
			H.drop_item()
			qdel(O)
			processing_objects.Add(src)
			burned = FALSE
			update_icon()

/obj/item/storage/bee_hive/attack_hand(mob/living/carbon/human/user as mob)
	. = ..()
	if(user.s_active)
		user.s_active.close(user)
	show_to(user)

/obj/item/storage/bee_hive/update_icon()
	if(burned) icon_state = "hive2"
	else if(without_honey)	icon_state = "hive0"
	else	icon_state = "hive1"

/obj/item/wax
	name = "wax"
	icon_state = "wax"
	icon = 'icons/obj/lw_bees.dmi'

/obj/item/reagent_containers/food/snacks/honeycomb
	name = "honeycomb"
	icon_state = "honeycomb"
	icon = 'icons/obj/food.dmi'
	desc = "Dripping with sugary sweetness."
	item_worth = 8
	New()
		..()
		reagents.add_reagent("honey",10)
		reagents.add_reagent("nutriment", 5)
		reagents.add_reagent("sugar", 5)
		bitesize = 5
	On_Consume()
		..()

/datum/reagent/honey
	name = "Honey"
	id = "honey"
	description = "A golden yellow syrup, loaded with sugary sweetness."
	color = "#FFFF00"
