/obj/item/wirerod
	name = "wired rod"
	desc = "A rod with some wire wrapped around the top. It'd be easy to attach something to the top bit."
	icon_state = "wiredrod"
	item_state = "rods"
	flags = CONDUCT
	force = 9
	throwforce = 10
	w_class = 3
	m_amt = 1875
	attack_verb = list("hit", "bludgeoned", "whacked", "bonked")

/obj/item/wirerod/attackby(var/obj/item/I, mob/user as mob)
	..()
	if(istype(I, /obj/item/shard))
		var/obj/item/twohanded/spear/S = new /obj/item/twohanded/spear

		user.before_take_item(I)
		user.before_take_item(src)

		user.put_in_hands(S)
		user << "<span class='notice'>You fasten the glass shard to the top of the rod with the cable.</span>"
		qdel(I)
		qdel(src)

	else if(istype(I, /obj/item/wirecutters))
		var/obj/item/melee/baton/cattleprod/P = new /obj/item/melee/baton/cattleprod

		user.before_take_item(I)
		user.before_take_item(src)

		user.put_in_hands(P)
		user << "<span class='notice'>You fasten the wirecutters to the top of the rod with the cable, prongs outward.</span>"
		qdel(I)
		qdel(src)

/obj/item/handcuffs/cable/attackby(var/obj/item/I, mob/user as mob)
	..()
	if(istype(I, /obj/item/stack/rods))
		var/obj/item/stack/rods/R = I
		var/obj/item/wirerod/W = new /obj/item/wirerod
		R.use(1)

		user.before_take_item(src)

		user.put_in_hands(W)
		user << "<span class='notice'>You wrap the cable restraint around the top of the rod.</span>"

		qdel(src)