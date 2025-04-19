/obj/structure/stool
	name = "stool"
	desc = "Apply butt."
	icon = 'icons/obj/objects.dmi'
	icon_state = "stool"
	anchored = 1.0
	flags = FPRINT
	pressure_resistance = 15
	var/can_leave = FALSE //if you can "prepare to leave" while sleeping and buckled to this obj. Blame oldcode.

/obj/structure/stool/ex_act(severity)
	switch(severity)
		if(1.0)
			qdel(src)
			return
		if(2.0)
			if (prob(50))
				qdel(src)
				return
		if(3.0)
			if (prob(5))
				qdel(src)
				return
	return

/obj/structure/stool/attackby(obj/item/W as obj, mob/user as mob)
	if(istype(W, /obj/item/wrench))
		playsound(src.loc, 'sound/items/Ratchet.ogg', 50, 1)
		new /obj/item/stack/sheet/metal(src.loc)
		qdel(src)
	return

/obj/structure/stool/MouseDrop(atom/over_object)
	if (istype(over_object, /mob/living/carbon/human))
		var/mob/living/carbon/human/H = over_object
		if (H==usr && !H.restrained() && !H.stat && in_range(src, over_object))
			var/obj/item/stool/S = new/obj/item/stool()
			S.origin = src
			src.loc = S
			H.put_in_hands(S)
			H.visible_message("\red [H] grabs [src] from the floor!", "\red You grab [src] from the floor!")

/obj/item/stool
	name = "stool"
	desc = "Uh-hoh, bar is heating up."
	icon = 'icons/obj/objects.dmi'
	icon_state = "stool"
	force = 10
	throwforce = 10
	w_class = 5.0
	var/obj/structure/stool/origin = null

/obj/item/stool/attack_self(mob/user as mob)
	..()
	origin.loc = get_turf(src)
	user.u_equip(src)
	user.visible_message("\blue [user] puts [src] down.", "\blue You put [src] down.")
	qdel(src)

/obj/item/stool/attack(mob/M as mob, mob/user as mob)
	if (prob(5) && istype(M,/mob/living))
		user.visible_message("\red [user] breaks [src] over [M]'s back!.")
		user.u_equip(src)
		var/obj/item/stack/sheet/metal/m = new/obj/item/stack/sheet/metal
		m.loc = get_turf(src)
		qdel(src)
		var/mob/living/T = M
		T.Weaken(10)
		T.apply_damage(20)
		return
	..()

/obj/structure/stool/barstool
	name = "barstool"
	icon_state = "barstool"

/obj/structure/stool/barstool2
	name = "barstool"
	icon_state = "barstool2"

obj/structure/casino/roulette
	name = "roulette"
	desc = "Spin the roulette to try your luck."
	icon = 'icons/obj/objects.dmi'
	icon_state = "roulette_r"
	density = TRUE
	anchored = TRUE
	var/busy=0
    // Don't question why I put this in here.
/obj/structure/casino/roulette/attack_hand(mob/user as mob)
	if (busy)
		to_chat(user,"[("You cannot spin now! \The [src] is already spinning.")] ")
		return
	visible_message(("\ [user]  spins the roulette and throws inside little ball."))
	busy = 1
	var/n = rand(0,36)
	var/color = "green"
	add_fingerprint(user)
	if ((n>0 && n<11) || (n>18 && n<29))
		if (n%2)
			color="red"
	else
		color="black"
	if ( (n>10 && n<19) || (n>28) )
		if (n%2)
			color="black"
	else
		color="red"
	spawn(5 SECONDS)
		visible_message(("\The [src] stops spinning, the ball landing on [n], [color]."))
		busy=0

/obj/structure/casino/table
	name = "roulette table"
	desc = "Spin the roulette to try your luck."
	icon = 'icons/obj/objects.dmi'
	icon_state = "roulette_l"
	density = TRUE
	anchored = TRUE