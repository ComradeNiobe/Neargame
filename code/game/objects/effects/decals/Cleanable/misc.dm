/obj/effect/decal/cleanable/generic
	name = "clutter"
	desc = "Someone should clean that up."
	gender = PLURAL
	density = 0
	anchored = 1
	layer = 2
	icon = 'icons/obj/objects.dmi'
	icon_state = "shards"

/obj/item/ash
	name = "ashes"
	desc = "Ashes to ashes, dust to dust, and into space."
	gender = PLURAL
	icon = 'icons/obj/objects.dmi'
	icon_state = "ash"
	anchored = 1

/obj/effect/decal/cleanable/ash/attack_hand(mob/user as mob)
	user << "<span class='notice'>[src] sifts through your fingers.</span>"
	qdel(src)

/obj/effect/decal/cleanable/greenglow

	New()
		..()
		spawn(1200)// 2 minutes
			qdel(src)

/obj/effect/decal/cleanable/dirt
	name = "dirt"
	desc = "Someone should clean that up."
	gender = PLURAL
	density = 0
	anchored = 1
	layer = 2
	icon = 'icons/effects/effects.dmi'
	icon_state = "dirt"
	mouse_opacity = 0

/obj/effect/decal/cleanable/confetti
	name = "confetti"
	desc = "Someone should clean that up."
	gender = PLURAL
	density = 0
	anchored = 1
	layer = 2
	icon = 'icons/effects/effects.dmi'
	icon_state = "confetti1"
	random_icon_states = list("confetti1", "confetti2", "confetti3", "confetti4")
	mouse_opacity = 0

/obj/effect/decal/cleanable/flour
	name = "flour"
	desc = "It's still good. Four second rule!"
	gender = PLURAL
	density = 0
	anchored = 1
	layer = 2
	icon = 'icons/effects/effects.dmi'
	icon_state = "flour"

/obj/effect/decal/cleanable/greenglow
	name = "glowing goo"
	desc = "Jeez. I hope that's not for lunch."
	gender = PLURAL
	density = 0
	anchored = 1
	layer = 2
	luminosity = 1
	icon = 'icons/effects/effects.dmi'
	icon_state = "greenglow"

/obj/effect/decal/cleanable/cobweb
	name = "cobweb"
	desc = "Somebody should remove that."
	density = 0
	anchored = 1
	layer = 3
	icon = 'icons/effects/effects.dmi'
	icon_state = "cobweb1"

	Bumped(atom/user)
		if(ismob(user))
			if(prob(20))
				user << "[pick("The cobweb softly touches your face", "You feel something touching your face", "You fell the disguisting touch of the cobweb", "Some of the cobweb remains on your face")]..."

/obj/effect/decal/cleanable/molten_item
	name = "gooey grey mass"
	desc = "It looks like a melted... something."
	density = 0
	anchored = 1
	layer = 3
	icon = 'icons/obj/chemical.dmi'
	icon_state = "molten"

/obj/effect/decal/cleanable/cobweb2
	name = "cobweb"
	desc = "Somebody should remove that."
	density = 0
	anchored = 1
	layer = 3
	icon = 'icons/effects/effects.dmi'
	icon_state = "cobweb2"

	Bumped(atom/user)
		if(ismob(user))
			if(prob(20))
				user << "[pick("The cobweb softly touches your face", "You feel something touching your face", "You fell the disguisting touch of the cobweb", "Some of the cobweb remains on your face")]..."

/obj/item/reagent_containers/food/snacks/Destroy()
	if(contents)
		for(var/atom/movable/something in contents)
			something.dropInto(loc)
	. = ..()

/obj/effect/decal/cleanable/vomit
	name = "vomit"
	desc = "Gosh, how unpleasant."
	gender = PLURAL
	density = 0
	anchored = 1
	layer = 2
	icon = 'icons/effects/blood.dmi'
	icon_state = "vomit_1"
	random_icon_states = list("vomit_1", "vomit_2", "vomit_3", "vomit_4")
	var/list/viruses = list()
	cleanable = 1

/obj/effect/decal/cleanable/vomit/New()
	. = ..()
	processing_objects |= src
	//src.process()

/obj/effect/decal/cleanable/vomit/Destroy()
	processing_objects -= src
	for(var/datum/disease/D in viruses)
		D.cure(0)
	return ..()

/*
// TODO: for love of all that is good and holy, replace this
/obj/effect/decal/cleanable/vomit/process()
	spawn(2400)
		new /obj/effect/decal/cleanable/vomit/old(get_turf(src))
		qdel(src)
*/
/obj/effect/decal/cleanable/vomit/Crossed(AM as mob|obj)
	if(iscarbon(AM))
		var/mob/living/carbon/M = AM
		if(prob(5))
			M.stumble(1,src)
	else
		return

/obj/effect/decal/cleanable/vomit/old
	name = "crusty dried vomit"
	desc = "You try not to look at the chunks, and fail."

/obj/effect/decal/cleanable/vomit/old/New()
	. = ..()

/obj/effect/decal/cleanable/tomato_smudge
	name = "tomato smudge"
	desc = "It's red."
	density = 0
	anchored = 1
	layer = 2
	icon = 'icons/effects/tomatodecal.dmi'
	random_icon_states = list("tomato_floor1", "tomato_floor2", "tomato_floor3")

/obj/effect/decal/cleanable/egg_smudge
	name = "smashed egg"
	desc = "Seems like this one won't hatch."
	density = 0
	anchored = 1
	layer = 2
	icon = 'icons/effects/tomatodecal.dmi'
	random_icon_states = list("smashed_egg1", "smashed_egg2", "smashed_egg3")

/obj/effect/decal/cleanable/pie_smudge //honk
	name = "smashed pie"
	desc = "It's pie cream from a cream pie."
	density = 0
	anchored = 1
	layer = 2
	icon = 'icons/effects/tomatodecal.dmi'
	random_icon_states = list("smashed_pie")
