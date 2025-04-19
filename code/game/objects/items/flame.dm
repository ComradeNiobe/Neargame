/obj/item/flame
	var/lit = 0
	var/r_range = 5
	var/f_force = 1
	var/c_color = "#ff7a7a"

	var/hand_on = "torch1"
	var/hand_off = "torch0"

	var/state_on = "torch-on"
	var/state_off = "torch"

/obj/item/flame/proc/turn_on()
	lit = 1
	set_light(r_range, f_force, c_color)
	icon_state = state_on
	item_state = hand_on
	if(istype(src, /obj/item/flame/torch) && !istype(src, /obj/item/flame/torch/lantern))
		slot_flags = null
	if(istype(src.loc, /mob/living/carbon/human))
		var/mob/living/carbon/human/H = src.loc
		H.update_inv_r_hand()
		H.update_inv_l_hand()

/obj/item/flame/proc/turn_off()
	src.lit = 0
	set_light(0)
	icon_state = state_off
	item_state = hand_off
	if(istype(src, /obj/item/flame/torch))
		slot_flags = SLOT_BELT
	if(istype(src.loc, /mob/living/carbon/human))
		var/mob/living/carbon/human/H = src.loc
		H.update_inv_r_hand()
		H.update_inv_l_hand()

/obj/item/flame/attack_self(var/mob/user)
	if(src.lit)
		turn_off()
		user.visible_message("<span class='badlight'>[user] shuts [src].")

/obj/item/flame/on_enter_storage()
	if(lit)
		turn_off()
	..()