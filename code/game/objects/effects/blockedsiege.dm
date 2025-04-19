var/static/list/minimiglist
var/static/list/blockedsiegelist

/obj/effect/blockedsiege
	name = "Evil Siege Camp"
	desc = "I Better stay away from that thing."
	density = 1
	anchored = 1
	mouse_opacity = 0
	icon = 'icons/life/screen1.dmi'
	icon_state = "dark23"

/obj/effect/blockedsiege/Bumped(mob/user)
	if(ishuman(user) && user.client)
		to_chat(user, "War hasn't been declared, I can't go past this.")

/obj/effect/blockedsiege/New()
	. = ..()
	if(istype(src.loc,/turf/simulated/wall/r_wall))
		var/turf/simulated/wall/r_wall/W = src.loc
		W.siegeblocked = TRUE

	LAZYDISTINCTADD(blockedsiegelist, src)

/obj/effect/blockedsiege/Destroy()
	. = ..()
	if(istype(src.loc,/turf/simulated/wall/r_wall))
		var/turf/simulated/wall/r_wall/W = src.loc
		W.siegeblocked = FALSE

	LAZYREMOVE(blockedsiegelist, src)

/obj/effect/blockedminimig
	name = "Evil Minimig Camp"
	desc = "I Better stay away from that thing."
	density = 1
	anchored = 1
	mouse_opacity = 0
	icon = 'icons/life/screen1.dmi'
	icon_state = "dark23"

/obj/effect/blockedminimig/New()
	. = ..()
	LAZYDISTINCTADD(minimiglist, src)

/obj/effect/blockedminimig/Destroy()
	. = ..()
	LAZYREMOVE(minimiglist, src)

/obj/effect/blockedminimig/Bumped(mob/user)
	if(ishuman(user) && user.client)
		if(minimig_grace)
			to_chat(user, "Grace period hasn't ended, I can't go past this.")