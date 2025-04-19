/obj/item/reagent_containers/food/snacks/lw
	On_Consume()
		..()
		if(ishuman(usr))
			var/mob/living/carbon/human/H = usr
			H.add_event("goodfood", /datum/happiness_event/nutrition/goodfood)

/obj/item/reagent_containers/food/snacks/lw/bakedpotato
	name = "baked potato"
	icon_state = "bakedpotato"
	icon = 'icons/obj/cooking.dmi'
	New()
		..()
		reagents.add_reagent("nutriment", 8)
		bitesize = 3

/obj/item/reagent_containers/food/snacks/lw/steak
	name = "steak"
	icon_state = "steak"
	icon = 'icons/obj/cooking.dmi'
	New()
		..()
		reagents.add_reagent("nutriment", 8)
		bitesize = 3


/obj/item/reagent_containers/food/snacks/lw/omelette
	name = "omelette"
	icon_state = "omelette"
	icon = 'icons/obj/cooking.dmi'
	New()
		..()
		reagents.add_reagent("nutriment", 6)
		bitesize = 2

/obj/item/reagent_containers/food/snacks/lw/fries
	name = "fries"
	icon_state = "fries"
	icon = 'icons/obj/cooking.dmi'
	New()
		..()
		reagents.add_reagent("nutriment", 8)
		bitesize = 3

/obj/item/reagent_containers/food/snacks/lw/flatbread
	name = "flatbread"
	icon_state = "flatbread"
	icon = 'icons/obj/cooking.dmi'
	New()
		..()
		reagents.add_reagent("nutriment", 10)
		bitesize = 3

/obj/item/reagent_containers/food/snacks/lw/loaf
	name = "loaf"
	icon_state = "loaf4"
	icon = 'icons/obj/cooking.dmi'
	New()
		..()
		reagents.add_reagent("nutriment", 10)
		bitesize = 4
	On_Consume()
		..()
		var/totial = bitesize-bitecount
		icon_state = "loaf[totial]"


/obj/item/reagent_containers/food/snacks/lw/pancake
	name = "pancake"
	icon_state = "pancake"
	icon = 'icons/obj/cooking.dmi'
	New()
		..()
		reagents.add_reagent("nutriment", 6)
		bitesize = 3


/obj/item/reagent_containers/food/snacks/lw/cutlet
	name = "cutlet"
	icon_state = "cutlet4"
	icon = 'icons/obj/cooking.dmi'
	New()
		..()
		reagents.add_reagent("nutriment", 8)
		reagents.add_reagent("sodiumchloride", 1)
		bitesize = 4
	On_Consume()
		..()

/obj/item/reagent_containers/food/snacks/lw/crackers
	name = "crackers"
	icon_state = "cracker5"
	icon = 'icons/obj/food.dmi'
	
	New()
		..()
		reagents.add_reagent("nutriment", 8)
		reagents.add_reagent("sodiumchloride", 1)
		bitesize = 5
	On_Consume()
		..()
		var/totial = bitesize-bitecount
		icon_state = "cracker[totial]"


// ALCOHOLISMS GREAT FOOD REWORK/REDO/THINGY

// EXOTIC SPICES - Nobles love 'em, everyone loves 'em, only way to taste luxury!

/obj/item/reagent_containers/food/snacks/lw/exotic
	name = "spices"
	desc = "Incredibly armoatic."
	icon_state = "exotic"
	icon = 'icons/obj/cooking.dmi'
	New()
		..()
		reagents.add_reagent("nutriment", 1) // Why the fuck would you eat this raw. Seriously.
		reagents.add_reagent("sodiumchloride", 1)
		bitesize = 1

/obj/item/reagent_containers/food/snacks/lw/salt
	name = "salt"
	desc = "Incredibly salty"
	icon_state = "exotic"
	icon = 'icons/obj/cooking.dmi'
	New()
		..()
		reagents.add_reagent("nutriment", 1) // Why the fuck would you eat this raw. Seriously.
		reagents.add_reagent("sodiumchloride", 1)
		bitesize = 1

// PASTRY

/obj/item/reagent_containers/food/snacks/lw/bun
	name = "bun"
	icon_state = "lwbun"
	icon = 'icons/obj/cooking.dmi'
	New()
		..()
		reagents.add_reagent("nutriment", 6)
		bitesize = 2

// PERSONAL PIE - Fuck it! Throw it in a PIE!

/obj/item/reagent_containers/food/snacks/lw/plpie
	name = "plump-helmet pie"
	icon_state = "pieshroom"
	icon = 'icons/obj/cooking.dmi'
	New()
		..()
		reagents.add_reagent("nutriment", 6)
		bitesize = 4

/obj/item/reagent_containers/food/snacks/lw/popie
	name = "potato pie"
	icon_state = "piepotato"
	icon = 'icons/obj/cooking.dmi'
	New()
		..()
		reagents.add_reagent("nutriment", 8)
		bitesize = 4

/obj/item/reagent_containers/food/snacks/lw/mpie
	name = "meat pie"
	icon_state = "piemeat"
	icon = 'icons/obj/cooking.dmi'
	New()
		..()
		reagents.add_reagent("nutriment", 12)
		bitesize = 4

// OVEN-ROASTED - Delicious, probably. Generic food goes here

/obj/item/reagent_containers/food/snacks/lw/shroomsteak
	name = "shroomsteak"
	icon_state = "shroomsteak"
	icon = 'icons/obj/cooking.dmi'
	New()
		..()
		reagents.add_reagent("nutriment", 4)
		bitesize = 4 // Lots of bites, since it's got alot of pieces!

/obj/item/reagent_containers/food/snacks/lw/eggytoast
	name = "arelite-in-the-nest"
	icon_state = "egghole"
	icon = 'icons/obj/cooking.dmi'
	New()
		..()
		reagents.add_reagent("nutriment", 4)
		bitesize = 2

/obj/item/reagent_containers/food/snacks/lw/eeye
	name = "eelo eye"
	icon_state = "eelo_eye"
	icon = 'icons/obj/cooking.dmi'
	New()
		..()
		reagents.add_reagent("nutriment", 6)
		bitesize = 2

/obj/item/reagent_containers/food/snacks/lw/stuffplump
	name = "stuffed plumphelmet"
	icon_state = "stuffedhelmet"
	icon = 'icons/obj/cooking.dmi'
	New()
		..()
		reagents.add_reagent("nutriment", 6)
		bitesize = 2

/obj/item/reagent_containers/food/snacks/lw/bastardcake
	name = "alms cake"
	icon_state = "srygnik"
	icon = 'icons/obj/cooking.dmi'
	New()
		..()
		reagents.add_reagent("nutriment", 2) // TERRIBLE! But CHEAP!
		bitesize = 1

// BURGERS & HANDHELDS - BORGAR

/obj/item/reagent_containers/food/snacks/lw/ratburger
	name = "rat burger"
	icon_state = "ratburger"
	icon = 'icons/obj/cooking.dmi'
	New()
		..()
		reagents.add_reagent("nutriment", 6) // No longer a luxury! It's a RAT!
		bitesize = 3

/obj/item/reagent_containers/food/snacks/lw/ratburger/cheese
	name = "cheese rat burger"
	icon_state = "cheeseratburger"
	icon = 'icons/obj/cooking.dmi'
	New()
		..()
		reagents.add_reagent("nutriment", 8) // No. Not even cheese makes it a luxury.
		bitesize = 3

/obj/item/reagent_containers/food/snacks/lw/donair
	name = "donair"
	icon_state = "shaurma" // Get fucked
	icon = 'icons/obj/cooking.dmi'
	New()
		..()
		reagents.add_reagent("nutriment", 8)
		reagents.add_reagent("sodiumchloride", 1)
		bitesize = 4


// Spiced Variants

/obj/item/reagent_containers/food/snacks/lw/plpie/spiced
	name = "plump-helmet pie"
	desc = "It smells delicious!"
	icon_state = "pieshroom"
	icon = 'icons/obj/cooking.dmi'
	New()
		..()
		reagents.add_reagent("nutriment", 6)
		reagents.add_reagent("sodiumchloride", 1)
		bitesize = 4

/obj/item/reagent_containers/food/snacks/lw/popie/spiced
	name = "potato pie"
	desc = "It smells delicious!"
	icon_state = "piepotato"
	icon = 'icons/obj/cooking.dmi'
	New()
		..()
		reagents.add_reagent("nutriment", 8)
		reagents.add_reagent("sodiumchloride", 1)
		bitesize = 4

/obj/item/reagent_containers/food/snacks/lw/mpie/spiced
	name = "meat pie"
	desc = "It smells delicious!"
	icon_state = "piemeat"
	icon = 'icons/obj/cooking.dmi'
	New()
		..()
		reagents.add_reagent("nutriment", 12)
		reagents.add_reagent("sodiumchloride", 1)
		bitesize = 4

/obj/item/reagent_containers/food/snacks/lw/stuffplump/spiced
	name = "stuffed plumphelmet"
	desc = "It smells delicious!"
	icon_state = "stuffedhelmet"
	icon = 'icons/obj/cooking.dmi'
	New()
		..()
		reagents.add_reagent("nutriment", 6)
		reagents.add_reagent("sodiumchloride", 1)
		bitesize = 2

/obj/item/reagent_containers/food/snacks/lw/shroomsteak/spiced
	name = "shroomsteak"
	desc = "It smells delicious!"
	icon_state = "shroomsteak"
	icon = 'icons/obj/cooking.dmi'
	New()
		..()
		reagents.add_reagent("nutriment", 4)
		reagents.add_reagent("sodiumchloride", 1)
		bitesize = 4

/obj/item/reagent_containers/food/snacks/lw/steak/spiced
	name = "steak"
	desc = "It smells delicious!"
	icon_state = "steak"
	icon = 'icons/obj/cooking.dmi'
	New()
		..()
		reagents.add_reagent("nutriment", 8)
		reagents.add_reagent("sodiumchloride", 1)
		bitesize = 3
