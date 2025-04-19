/mob/living/carbon/human/proc/give(var/mob/living/target)
	if(stat)
		return
	if(!istype(target) || target.stat || target.client == null)
		return

	var/obj/item/I = usr.get_active_hand()
	if(!I)
		return

	if(istype(I, /obj/item/grab))
		return

	if(I.loc != usr || (usr.l_hand != I && usr.r_hand != I))
		return

	if(target.r_hand != null && target.l_hand != null)
		to_chat(usr, "<span class='warning'>Their hands are full.</span>")
		return

	usr.drop_from_inventory(I) // If this fails it will just end up on the floor, but that's fitting.
	target.put_in_hands(I)
	target.visible_message("<span class='notice'>\The [usr] handed \the [I] to \the [target].</span>")