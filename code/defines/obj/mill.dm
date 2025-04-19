/obj/structure/millstone
	name = "millstone"
	icon = 'icons/obj/miscobjs.dmi'
	density = TRUE
	icon_state = "millstone"

/obj/structure/millstone/attackby(obj/item/C, mob/user)
	if(istype(C, /obj/item/bone))
		user.drop_from_inventory(C)
		qdel(C)
		playsound(src.loc,'sound/webbers/obj_windmill_wheel_lp.ogg', rand(40,50), 0)
		spawn(50)
			new/obj/item/reagent_containers/food/snacks/bone(src.loc)
			new/obj/item/reagent_containers/food/snacks/bone(src.loc)
			new/obj/item/reagent_containers/food/snacks/bone(src.loc)
	if(istype(C, /obj/item/reagent_containers/food/snacks/grown/sweetpod))
		user.drop_from_inventory(C)
		qdel(C)
		playsound(src.loc,'sound/webbers/obj_windmill_wheel_lp.ogg', rand(40,50), 0)
		spawn(50)
			new/obj/item/reagent_containers/food/snacks/sugar(src.loc)
			new/obj/item/reagent_containers/food/snacks/sugar(src.loc)
			new/obj/item/reagent_containers/food/snacks/sugar(src.loc)
	if(istype(C, /obj/item/reagent_containers/food/snacks/grown/mushroom/zheleznyak))
		user.drop_from_inventory(C)
		qdel(C)
		playsound(src.loc,'sound/webbers/obj_windmill_wheel_lp.ogg', rand(40,50), 0)
		spawn(50)
			new/obj/item/reagent_containers/food/snacks/salt(src.loc)
			new/obj/item/reagent_containers/food/snacks/salt(src.loc)
			new/obj/item/reagent_containers/food/snacks/salt(src.loc)
	if(istype(C, /obj/item/reagent_containers/food/snacks/grown/wheat))
		var/obj/item/W = user.get_inactive_hand()
		if(!istype(W, /obj/item/reagent_containers))
			to_chat(user, "I should hold a container in my other hand.")
			return
		var/obj/item/reagent_containers/B = W
		user.drop_from_inventory(C)
		qdel(C)
		playsound(src.loc,'sound/webbers/obj_windmill_wheel_lp.ogg', rand(40,50), 0)
		spawn(50)
			B.reagents.add_reagent("flour", 5)

/obj/item/reagent_containers/food/snacks/bone
	name = "bone powder"
	icon_state = "powder"
	filling_color = "#211F02"
	New()
		..()
		reagents.add_reagent("bone", 4)

/obj/item/reagent_containers/food/snacks/sugar
	name = "sugar powder"
	icon_state = "sugar"
	filling_color = "#FFC0CB"
	New()
		..()
		reagents.add_reagent("sugar", 4)
