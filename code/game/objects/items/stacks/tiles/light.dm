/obj/item/stack/tile/light
	name = "light tile"
	singular_name = "light floor tile"
	desc = "A floor tile, made out off glass. It produces light."
	icon_state = "tile_e"
	w_class = 3.0
	force = 3.0
	throwforce = 5.0
	throw_speed = 5
	throw_range = 20
	flags = FPRINT | TABLEPASS | CONDUCT
	max_amount = 60
	attack_verb = list("bashed", "battered", "bludgeoned", "thrashed", "smashed")
	var/on = TRUE
	var/state //0 = fine, 1 = flickering, 2 = breaking, 3 = broken

/obj/item/stack/tile/light/New(var/loc, var/amount=null)
	..()
	if(prob(5))
		state = 3 //broken
	else if(prob(5))
		state = 2 //breaking
	else if(prob(10))
		state = 1 //flickering occasionally
	else
		state = 0 //fine

/obj/item/stack/tile/light/Destroy()
	var/area/A = get_area(src)
	if(A)
		on = FALSE
	. = ..()

/obj/item/stack/tile/light/attackby(var/obj/item/O as obj, var/mob/user as mob)
	..()
	if(istype(O,/obj/item/crowbar))
		new/obj/item/stack/sheet/metal(user.loc)
		amount--
		new/obj/item/stack/light_w(user.loc)
		if(amount <= 0)
			user.drop_from_inventory(src)
			qdel(src)

/obj/item/stack/tile/neon
	name = "light tile"
	singular_name = "light floor tile"
	desc = "A floor tile, made out off glass. It produces light."
	icon_state = "tile_e"
	w_class = 3.0
	force = 4.0
	throwforce = 6.0
	throw_speed = 5
	throw_range = 6
	flags = FPRINT | TABLEPASS | CONDUCT
	max_amount = 60
	attack_verb = list("bashed", "battered", "bludgeoned", "thrashed", "smashed")
	var/on = TRUE
	var/c = "techfloor_neon"

/obj/item/stack/tile/neon/neonwhte
	c = "techfloor_neonwhte"

/obj/item/stack/tile/neon/neonwhte/side
	c = "techfloor_lightedcorner"

/obj/item/stack/tile/neon/neonwhte/side_grid
	c = "techfloor_lightedcorner_grid"

