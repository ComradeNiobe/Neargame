/obj/item/laptop
	name = "laptop"
	icon = 'icons/obj/laptops.dmi'
	icon_state = "seclaptop"
	var/obj/item/circuitboard/circuit = null //if circuit==null, computer can't disassembly


/obj/machinery/computer/laptop/MouseDrop(atom/over_object)
	if (istype(over_object, /mob/living/carbon/human))
		var/mob/living/carbon/human/H = over_object
		if (H==usr && !H.restrained() && !H.stat && in_range(src, over_object))
			var/obj/item/laptop/L = new/obj/item/laptop()
			L.origin = src
			src.loc = L
			H.put_in_hands(L)
			H.visible_message("\red [H] grabs [src]!", "\red You grab [src]!")