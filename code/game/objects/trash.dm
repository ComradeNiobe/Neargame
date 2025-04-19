obj/structure/trash
	name = "object"
	icon = 'icons/obj/miscobjs.dmi'

	anchored = TRUE
	density = TRUE
	flammable = 1
	icon_state = "equip8"

obj/structure/trash/one
	icon_state = "2"

obj/structure/trash/two
	icon_state = "a8"

obj/structure/trash/three
	icon_state = "a9"

obj/structure/trash/four
	icon_state = "a10"

obj/structure/trash/five
	icon_state = "a11"

obj/structure/trash/six
	icon_state = "a4"

obj/structure/trash/charon
	icon_state = "charon"
	name = "ulysses console"
	density = FALSE
	plane = 15

/obj/structure/trash/charon/attack_hand(mob/user as mob)
	user.setClickCooldown(DEFAULT_SLOW_COOLDOWN)
	user.visible_message("<span class='passivebold'>[user] [pick("watches porn!", "smashes the keyboard!", "types in!", "licks the keyboard!")]</span>")
	playsound(user, pick('sound/webbers/confirm1.ogg', 'sound/webbers/confirm2.ogg', 'sound/webbers/confirm3.ogg', 'sound/webbers/confirm5.ogg', 'sound/webbers/confirm7.ogg', 'sound/webbers/confirm8.ogg', 'sound/webbers/confirm9.ogg'), 100)

obj/structure/trash/vidcam
	name = "video camera"
	icon_state = "standupmoviecamera"

//BRIDGE
obj/structure/bridge_small
	name = "bridge"
	icon = 'icons/obj/structures.dmi'

	anchored = TRUE
	density = FALSE
	icon_state = "bri"
	blocksOpenFalling = 1

obj/structure/bridge_small/end
	icon_state = "bri2"