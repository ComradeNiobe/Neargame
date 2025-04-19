/obj/structure/clothingbench 
	name = "Tailor Bench"
	desc = "A bench used to make clothes."
	icon = 'icons/obj/objects.dmi'
	icon_state = "shoework"
	density = 1
	anchored = 1
	var/on = 0
	var/tocomplete = 0
	var/endproduct = "Smerd Clothes"
	var/clothstock = 0
	var/leatherstock = 0
	var/cottonstock = 0
	var/garmentbase = 0
	var/fiberstock = 0
	var/hatbase = 0

	attack_hand(mob/user as mob)
		if(!on)
			for(var/obj/item/A in src.contents)
				A.loc = src.loc
		
		else 
			on = FALSE
			update_icon()
			playsound(src.loc, 'sound/effects/torch_snuff.ogg', 75, 0)

/obj/structure/clothingbench/RightClick(mob/user)
	var/end = input(user, "Choose your craft.") as null|anything in list("Smerd Clothes", "Garment Base", "Hat Base", "Fisher Hat", "Fine Coat", "Fancy Shoes")
	endproduct = end
		return

/obj/structure/clothingbench/examine(mob/user)
	..()
	to_chat(user, "<span class='passivebold'>Cloth Stock:</span> [clothstock]. <span class='passivebold'>Leather Stock:</span> [leatherstock] <span class='passivebold'>Garment Base:</span> [garmentbase] <span class='passivebold'>Hat Base:</span> [hatbase] <span class='passivebold'>Fibers:</span> [fiberstock]")

/obj/structure/clothingbench/attackby(obj/item/W as obj, mob/user as mob)
	if(on)
		to_chat(user, "The bench is already in use.")
		return
	
	if(istype(W, /obj/item/cloth))
		clothstock += 1
		qdel(W)
		to_chat(user, "You add the cloth to the stack.")
	if(istype(W, /obj/item/leather))
		leatherstock += 1
		qdel(W)
		to_chat(user, "You add the leather to the stack.")
	if(istype(W, /obj/item/garmentbase))
		garmentbase += 1
		qdel(W)
		to_chat(user, "You add the base to the stack.")
	if(istype(W, /obj/item/handcuffs/fiber))
		fiberstock += 1
		qdel(W)
		to_chat(user, "You add the fiber to the stack.")
		

	if(istype(W, /obj/item/surgery_tool/suture))
		var/list/recipes = subtypesof(/datum/clothes_recipe)
		for(var/CR in recipes)
			var/datum/clothes_recipe/C = new CR
			if(endproduct == C.name)
				if(C.name == "Fancy Shoes")
					if(user.job != "Child Worker")
						to_chat(user, "[pick(fnord)], my hands are too big!")
						return
				if(clothstock >= C.clothreq && leatherstock >= C.leatherreq && garmentbase >= C.gbasereq && hatbase >= C.hbasereq && fiberstock >= C.fiberreq)
					on = 1
					user.visible_message("<span class='passivebold'>[user]</span> <span class='passive'>begins sew together some fabric!</span>")
					if(do_after(user, 120))
						clothstock -= C.clothreq
						leatherstock -= C.leatherreq
						garmentbase -= C.gbasereq
						hatbase -= C.hbasereq
						new C.product(src.loc)
						user.visible_message("<span class='passivebold'>[user]</span> <span class='passive'>finishes the item.</span>")
						on = 0
						return				
				else
					to_chat(user, "[pick(fnord)], there's not enough materials!")
			
/* OTHER STRUCTURES */			
/obj/structure/loom
	name = "spinning wheel"
	desc = "A spinning wheel for refining raw materials into fabric and fiber."
	icon = 'icons/obj/structures.dmi'
	icon_state = "spinning"
	density = 1
	anchored = 1
	var/on = 0

/obj/structure/loom/attackby(obj/item/W as obj, mob/user as mob)
	if(on)
		to_chat(user, "The wheel is already in use!")
		return
	if(istype(W, /obj/item/cotton))
		user.visible_message("<span class='passivebold'>[user]</span> <span class='passive'>starts spinning the [W].</span>")
		on = 1
		spawn(0)
			src.spinning()
		if(do_after(user, 120))
			qdel(W)
			new /obj/item/cloth(src.loc)
			user.visible_message("<span class='passivebold'>[user]</span> <span class='passive'>spins the cotton into a cloth sheet.</span>")
			on = 0

	if(istype(W, /obj/item/pigtailrind))
		user.visible_message("<span class='passivebold'>[user]</span> <span class='passive'>starts refining the [W].</span>")
		on = 1
		spawn(0)
			src.spinning()
		if(do_after(user, 120))
			qdel(W)
			new /obj/item/handcuffs/fiber(src.loc)
			new /obj/item/handcuffs/fiber(src.loc)
			user.visible_message("<span class='passivebold'>[user]</span> <span class='passive'>spins the [W] into strong fibers.</span>")
			on = 0

/obj/structure/loom/proc/spinning()
	icon_state = "spinningon"
	sleep(120)
	icon_state = "spinning"


/* ITEMS */
/obj/item/garmentbase
	name = "garment base"
	desc = "A piece of fabric ready to be sewn together"
	icon = 'icons/obj/items.dmi'
	icon_state = "garmentbase"

/obj/item/pigtail
	name = "pigtail"
	desc = "A freshly harvested pigtail, it still has the rind!"
	icon = 'icons/obj/harvest.dmi'
	icon_state = "pigtail"

/obj/item/pigtail/attack_self(mob/user as mob)
	user.visible_message("<span class='passivebold'>[user]</span> <span class='passive'>begins shucking the [src]</span>")
	if(do_after(user, 60))
		new /obj/item/pigtailrind(user.loc)
		new /obj/item/reagent_containers/food/snacks/grown/pigtail(user.loc)
		qdel(src)
		user.visible_message("<span class='passivebold'>[user]</span> <span class='passive'>shucks the rind from the fruit!</span>")

/obj/item/pigtailrind
	name = "pigtail rind"
	desc = "The rind shucked from a pigtail, useful in making fibers."
	icon = 'icons/obj/harvest.dmi'
	icon_state = "pigtailrind"

/obj/item/leather
	name = "leather"
	desc = "A piece of hide from something."
	icon = 'icons/obj/items.dmi'
	icon_state = "sheet-leather"

/obj/item/hatbase
	name = "Hat Base"
	desc = "A piece of fabric ready to be sewn into a hat."
	icon = 'icons/obj/items.dmi'
	icon_state = "hatbase"

/obj/item/cotton
	name = "raw cave cotton"
	desc = "Raw cave cotton harvested from the plant"
	icon = 'icons/obj/items.dmi'
	icon_state = "rawcotton"

/obj/item/cotton/attackby(obj/item/W, mob/user)
	visible_message("<span class='bname'>[user]</span> crushes [src].")
	playsound(user, pick('sound/effects/itm_ingredient_mushroom_up_01.ogg','sound/effects/itm_ingredient_mushroom_up_02.ogg','sound/effects/itm_ingredient_mushroom_up_03.ogg','sound/effects/itm_ingredient_mushroom_up_04.ogg'), 70, 0)
	new /obj/item/seedsn/cotton/raw(src.loc)
	qdel(src)

/obj/item/cloth
	name = "cloth sheet"
	desc = "Cave cotton spun into a sheet"
	icon = 'icons/obj/items.dmi'
	icon_state = "sheet-cloth"
/* RECIPES */

/datum/clothes_recipe
	var/name
	var/clothreq
	var/leatherreq
	var/cottonreq
	var/fiberreq
	var/gbasereq
	var/hbasereq
	var/product

/datum/clothes_recipe/smerdclothes
	name = "Smerd Clothes"
	gbasereq = 2
	clothreq = 2
	fiberreq = 2
	product = /obj/item/clothing/under/common

/datum/clothes_recipe/garmentbase
	name = "Garment Base"
	clothreq = 2
	fiberreq = 1
	product = /obj/item/garmentbase

/datum/clothes_recipe/hatbase
	name = "Hat Base"
	leatherreq = 1
	fiberreq = 1
	product = /obj/item/hatbase

/datum/clothes_recipe/sunhat
	name = "Sun Hat"
	hbasereq = 1
	clothreq = 2
	fiberreq = 1
	product = /obj/item/clothing/head/sunhat

/datum/clothes_recipe/fisher
	name = "Fisher Hat"
	hbasereq = 1
	fiberreq = 2
	product = /obj/item/clothing/head/fisherhat

/datum/clothes_recipe/finecoat
	name = "Fine Coat"
	gbasereq = 2
	clothreq = 4
	fiberreq = 2
	leatherreq = 2
	product = /obj/item/clothing/suit/countheir

/datum/clothes_recipe/fancyshoes
	name = "Fancy Shoes"
	leatherreq = 2
	fiberreq = 4
	product = /obj/item/clothing/shoes/lw/nobelshoes