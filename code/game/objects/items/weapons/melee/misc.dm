/obj/item/melee/chainofcommand
	name = "chain of command"
	desc = "A tool used by great men to placate the frothing masses."
	icon_state = "chain"
	item_state = "chain"
	flags = FPRINT | TABLEPASS | CONDUCT
	slot_flags = SLOT_BELT
	force = 15
	throwforce = 7
	w_class = 3
	origin_tech = "combat=4"
	attack_verb = list("flogged", "whipped", "lashed", "disciplined")
	weapon_speed_delay = 20
	smelted_return = /obj/item/ore/refined/lw/ironlw

	suicide_act(mob/user)
		viewers(user) << "\red <b>[user] is strangling \himself with the [src.name]! It looks like \he's trying to commit suicide.</b>"
		return (OXYLOSS)

/obj/item/gavelhammer
	name = "gavel"
	icon_state = "gavel"
	icon = 'icons/obj/items.dmi'
	flags = FPRINT | TABLEPASS | CONDUCT
	slot_flags = SLOT_BELT
	force = 1
	w_class = 3

/obj/item/gavelplatform
	name = "platform"
	icon = 'icons/obj/items.dmi'
	icon_state = "platform"
	flags = FPRINT | TABLEPASS | CONDUCT
	force = 1
	w_class = 3
	var/cooldown


/obj/item/gavelplatform/attackby(obj/item/W as obj, mob/user as mob)
	if(istype(W, /obj/item/gavelhammer))
		if(cooldown)
			to_chat(user, "<span class='combatbold'>[pick(fnord)] I can't yet!</span>")
			return
		cooldown = TRUE
		spawn(50)
			cooldown = FALSE
		playsound(src.loc, 'sound/weapons/gavel.ogg', 110, 1, -5)
		visible_message("<p style='font-size:20px'><span class='passivebold'>[user] hits the gavel!</span></p>")
	else
		..()

/obj/item/key
	name = "key"
	icon_state = "key1"
	icon = 'icons/obj/items.dmi'
	flags = FPRINT | TABLEPASS | CONDUCT
	force = 0
	w_class = 2
	drop_sound = 'sound/webbers/keydrop.ogg'
	drawsound = 'sound/webbers/keyring_up.ogg'
	var/key_lock = ""

/obj/item/key/New()
	..()
	icon_state = pick("key1", "key2")

/obj/item/key/residencesONE
	key_lock = "residencesONE"

/obj/item/key/residencesTWO
	key_lock = "residencesTWO"

/obj/item/key/residencesHUMP
	key_lock = "residencesHUMP"

/obj/item/key/residencesHAG
	key_lock = "residencesHAG"

/obj/item/key/residencesHUMP/New()
	..()
	icon_state = "key3"

/obj/item/key/residencesHAG/New()
	..()
	icon_state = "key4"