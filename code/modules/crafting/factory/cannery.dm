// STRUCTURES AND MACHINES
/obj/structure/cannery/dispenser 
	name = "Can Dispesner"
	desc = "A metal former used to shape the cans used for packaging."
	icon = 'icons/obj/objects.dmi'
	icon_state = "dispenser0"
	density = 1
	anchored = 1
	var/on = 0


	attack_hand(mob/user)
		if(on)
			to_chat(user, "It's already dispensing!")
			return
		else
			on = 1
			icon_state = "dispenser1"
			playsound(src.loc, 'sound/factory/dispenser.ogg', 100, 1)
			spawn(40)
				new /obj/item/can(src.loc)
				src.visible_message("[src] groans as it dispenses a can!")
				icon_state = "dispenser0"
				on = 0

/obj/structure/cannery/grueltank
	name = "Stew Vat"
	desc = "A combination grinder/vat designed to produce the famous Enoch's Gate stew."
	icon = 'icons/obj/objects.dmi'
	icon_state = "meatvat0"
	density = 1
	anchored = 1
	var/fill_level = 10
	var/on = 0

	New()
		..()
		update_fill_level()

	attackby(obj/item/W, mob/living/carbon/human/user)
		if(on)
			to_chat(user, "It's already in use!")
			return
		if(istype(W, /obj/item/can))
			var/obj/item/can/C = W
			if(fill_level == 0)
				to_chat(user, "The Vat is Empty!")
				return
				
			if(!C.filled)
				on = 1
				playsound(src.loc, 'sound/factory/filling.ogg', 150, 1)
				user.visible_message("[user] begins to fill the [W] from the [src].")
				spawn(60)
					on = 0
				if(do_after(user, 60))
					user.visible_message("[user] fills the [W] from the [src].")
					C.filled = 1
					C.can_worth = 2
					C.icon_state = "can1"
					C.name = "Filled Tin Can"
					fill_level -= 1
					update_fill_level()

		if(istype(W, /obj/item/reagent_containers/food/snacks/fish)||istype(W, /obj/item/reagent_containers/food/snacks/organ))
			if(prob(2))
				playsound(src.loc, 'sound/factory/grinding.ogg', 100, 1)
				user.visible_message(user, "<span class='combatglow'>[user] gets their hand caught in the grinder!</span>")
				switch(user.hand)
					if(1)
						user.apply_damage(60, BRUTE, "l_hand")
					if(0)
						user.apply_damage(60, BRUTE, "r_hand")
				user.emote("scream")
				fill_level += 1
				update_fill_level()
				return
			user.visible_message("[user] stuffs the [W] into the [src]'s grinder.")
			on = 1
			qdel(W)
			playsound(src.loc, 'sound/factory/grinding.ogg', 100, 1)
			spawn(80)
				fill_level += 2
				on = 0
			update_fill_level()
			
	examine(mob/user)
		..()
		to_chat(user, "It has [fill_level] cans worth of stew remaining.")

	proc/update_fill_level()
		switch(fill_level)
			if(0)
				icon_state = "meatvat0"
			if(1 to 5)
				icon_state = "meatvat1"
			if(6 to 10)
				icon_state = "meatvat2"
			if(11 to 15)
				icon_state = "meatvat3"
			if(16 to 20)
				icon_state = "meatvat4"

/obj/structure/cannery/sealer
	name = "Heat Sealer"
	desc = "An amazing machine that cooks and seals cans. It can do three at a time!"
	icon = 'icons/obj/objects.dmi'
	icon_state = "sealer"
	density = 1
	anchored = 1
	var/internal_cans = 0
	var/on = 0

	attackby(obj/item/W, mob/living/carbon/human/user)
		var/obj/item/can/C = W
		if(on)
			to_chat(user, "It's already running!")
			return
		if(internal_cans == 3)
			to_chat(user, "It's full!")
			return
		else
			user.drop_item()
			C.loc = src
			internal_cans += 1
			icon_state = "sealerc[internal_cans]"
	RightClick(mob/user)
		if(on)
			to_chat(user, "It's already running!")
			return
		else
			on = 1
			icon_state = "sealerc[internal_cans]_on"
			spawn(40)
				icon_state = "sealer"
				for(var/obj/item/can/S in contents)
					S.sealed = 1
					S.icon_state = "can3"
					S.loc = src.loc
				on = 0
				internal_cans = 0


		

//OBJECTS AND ITEMS

/obj/item/can
	name = "Tin Can"
	desc = "A can used for storage and shipment of The Gate's signature meat soup."
	icon = 'icons/obj/objects.dmi'
	icon_state = "can0"
	var/crackers = 0
	var/filled = 0
	var/sealed = 0
	var/can_worth = 0

	attackby(obj/item/W, mob/living/carbon/human/user)
		if(istype(W, /obj/item/reagent_containers/food/snacks/lw/crackers))
			if(!filled)
				to_chat(user, "There's no stew in this!")
				return
			if(!crackers)
				qdel(W)
				user.visible_message("[user] adds the [W] to the [src]")
				crackers = 1
				can_worth += 2
				icon_state = "can2"
			else
				to_chat(user, "There's already crackers in there!")
	

		
	
/obj/item/canningcrate
	name = "Can Shipping Crate"
	desc = "A crate used for collecting cans to be shipped across Evergreen. It looks like it can hold 9."
	icon = 'icons/obj/objects.dmi'
	icon_state = "crate0"
	var/cans = 0
	var/unsealed_worth = 0
	var/sealed = 0
	item_worth = 0

	attackby(obj/item/W, mob/living/carbon/human/user)
		if(istype(W, /obj/item/can))
			var/obj/item/can/C = W
			if(sealed)
				to_chat(user, "[pick(fnord)], the crate is closed!")
			if(!C.sealed)
				to_chat(user, "[pick(fnord)], I can't pack an unsealed can!")
				return
			if(!C.filled)
				to_chat(user, "[pick(fnord)], I can't pack an empty can!")
				return
			if(cans == 9)
				to_chat(user, "[pick(fnord)], It's full!")
				return
			else
				user.drop_item()
				C.loc = src
				cans += 1
				unsealed_worth += C.can_worth
			
		if(istype(W, /obj/item/crowbar))
			if(sealed)
				user.visible_message("[user] begins to unseal the [src]")
				if(do_after(user, 30))
					user.visible_message("[user] unseals the [src]")
					sealed = 0
					icon_state = "crate0"
					item_worth = 0
					playsound(src.loc, 'sound/factory/crate.ogg', 50, 1)
			else
				user.visible_message("[user] begins to seal the [src]")
				if(do_after(user, 30))
					user.visible_message("[user] seals the [src]")
					sealed = 1
					icon_state = "crate1"
					item_worth = unsealed_worth
					playsound(src.loc, 'sound/factory/crate.ogg', 50, 1)

	examine(mob/user)
		..()
		to_chat(user, "It has [cans] cans in it!")

	