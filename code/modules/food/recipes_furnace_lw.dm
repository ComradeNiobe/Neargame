/datum/recipe/bakedpotato
	items = list(
		/obj/item/reagent_containers/food/snacks/grown/potato,
		/obj/item/reagent_containers/food/snacks/breadsys/ontop/butter,
	)
	result = /obj/item/reagent_containers/food/snacks/lw/bakedpotato

/datum/recipe/bun
	items = list(
		/obj/item/reagent_containers/food/snacks/doughslice,
		/obj/item/reagent_containers/food/snacks/breadsys/ontop/butter,
	)
	result = /obj/item/reagent_containers/food/snacks/lw/bun

/datum/recipe/steak
	items = list(
		/obj/item/reagent_containers/food/snacks/meat,
	)
	result = /obj/item/reagent_containers/food/snacks/lw/steak

/datum/recipe/ratburger
	items = list(
		/obj/item/reagent_containers/food/snacks/deadrat,
		/obj/item/reagent_containers/food/snacks/lw/bun,
	)
	result = /obj/item/reagent_containers/food/snacks/lw/ratburger

/datum/recipe/omelette
	items = list(
		/obj/item/reagent_containers/food/snacks/egg,
		/obj/item/reagent_containers/food/snacks/egg,
	)
	result = /obj/item/reagent_containers/food/snacks/lw/omelette

/datum/recipe/flatbread
	items = list(
		/obj/item/reagent_containers/food/snacks/flatdough,
	)
	result = /obj/item/reagent_containers/food/snacks/lw/flatbread

/datum/recipe/pancake
	items = list(
		/obj/item/reagent_containers/food/snacks/breadsys/ontop/butter,
		/obj/item/reagent_containers/food/snacks/dough,
	)
	result = /obj/item/reagent_containers/food/snacks/lw/pancake

/datum/recipe/fries
	items = list(
		/obj/item/reagent_containers/food/snacks/rawsticks,
	)
	result = /obj/item/reagent_containers/food/snacks/lw/fries

/datum/recipe/carrotcake
	reagents = list("milk" = 5)
	items = list(
		/obj/item/reagent_containers/food/snacks/egg,
		/obj/item/reagent_containers/food/snacks/egg,
		/obj/item/reagent_containers/food/snacks/dough,
		/obj/item/reagent_containers/food/snacks/grown/carrot,
		/obj/item/reagent_containers/food/snacks/grown/carrot //TODO: more carrots  DONE
	)
	result = /obj/item/reagent_containers/food/snacks/sliceable/carrotcake

/datum/recipe/crackers
	items = list(
		/obj/item/reagent_containers/food/snacks/doughslice,
		/obj/item/reagent_containers/food/snacks/lw/salt,
	)
	result = /obj/item/reagent_containers/food/snacks/lw/crackers

/datum/recipe/waffles
	items = list(
		/obj/item/reagent_containers/food/snacks/flatdough,
		/obj/item/reagent_containers/food/snacks/egg,
	)
	result = /obj/item/reagent_containers/food/snacks/waffles

/datum/recipe/cheesecake
	reagents = list("milk" = 5)
	items = list(
		/obj/item/reagent_containers/food/snacks/egg,
		/obj/item/reagent_containers/food/snacks/egg,
		/obj/item/reagent_containers/food/snacks/dough,
		/obj/item/reagent_containers/food/snacks/cheesewedge,
		/obj/item/reagent_containers/food/snacks/cheesewedge,
	)
	result = /obj/item/reagent_containers/food/snacks/sliceable/cheesecake

/datum/recipe/candiedapple
	items = list(
		/obj/item/reagent_containers/food/snacks/grown/apple,
		/obj/item/reagent_containers/food/snacks/sugar,
	)
	result = /obj/item/reagent_containers/food/snacks/candiedapple

/datum/recipe/applepie
	items = list(
		/obj/item/reagent_containers/food/snacks/dough,
		/obj/item/reagent_containers/food/snacks/breadsys/ontop/butter,
		/obj/item/reagent_containers/food/snacks/grown/apple,
	)
	result = /obj/item/reagent_containers/food/snacks/applepie

/datum/recipe/cutlet
	items = list(
		/obj/item/reagent_containers/food/snacks/rawcutlet,
	)
	result = /obj/item/reagent_containers/food/snacks/cutlet

/datum/recipe/meatball
	items = list(
		/obj/item/reagent_containers/food/snacks/rawmeatball,
	)
	result = /obj/item/reagent_containers/food/snacks/faggot



/datum/recipe/pattyapple
	items = list(
		/obj/item/reagent_containers/food/snacks/doughslice,
		/obj/item/reagent_containers/food/snacks/grown/apple,
	)
	result = /obj/item/reagent_containers/food/snacks/pattyapple


/datum/recipe/taco
	items = list(
		/obj/item/reagent_containers/food/snacks/doughslice,
		/obj/item/reagent_containers/food/snacks/meat,
		/obj/item/reagent_containers/food/snacks/cheesewedge,
	)
	result = /obj/item/reagent_containers/food/snacks/taco


// ALCOHOLISMS GREAT FOOD REWORK/REDO/THINGY


// Single-Serving Pies

/datum/recipe/plpie
	items = list(
		/obj/item/reagent_containers/food/snacks/dough,
		/obj/item/reagent_containers/food/snacks/egg,
		/obj/item/reagent_containers/food/snacks/breadsys/ontop/butter,
		/obj/item/reagent_containers/food/snacks/grown/mushroom/plumphelmet,
	)
	result = /obj/item/reagent_containers/food/snacks/lw/plpie

/datum/recipe/popie
	items = list(
		/obj/item/reagent_containers/food/snacks/dough,
		/obj/item/reagent_containers/food/snacks/egg,
		/obj/item/reagent_containers/food/snacks/breadsys/ontop/butter,
		/obj/item/reagent_containers/food/snacks/grown/potato,
	)
	result = /obj/item/reagent_containers/food/snacks/lw/popie

/datum/recipe/mpie
	items = list(
		/obj/item/reagent_containers/food/snacks/dough,
		/obj/item/reagent_containers/food/snacks/egg,
		/obj/item/reagent_containers/food/snacks/breadsys/ontop/butter,
		/obj/item/reagent_containers/food/snacks/grown/potato,
	)
	result = /obj/item/reagent_containers/food/snacks/lw/mpie

// Oven-Cooked/Generics

/datum/recipe/shroomsteak
	items = list(
		/obj/item/reagent_containers/food/snacks/grown/mushroom/plumphelmet,
		/obj/item/reagent_containers/food/snacks/breadsys/ontop/butter,
	)
	result = /obj/item/reagent_containers/food/snacks/lw/shroomsteak

/datum/recipe/eggytoast
	items = list(
		/obj/item/reagent_containers/food/snacks/doughslice,
		/obj/item/reagent_containers/food/snacks/egg,
	)
	result = /obj/item/reagent_containers/food/snacks/lw/eggytoast


/datum/recipe/eeloeye
	items = list(
		/obj/item/reagent_containers/food/snacks/egg,
		/obj/item/reagent_containers/food/snacks/breadsys/ontop/butter,
		/obj/item/reagent_containers/food/snacks/cutlet,

	)
	result = /obj/item/reagent_containers/food/snacks/lw/eeye

/datum/recipe/stuffedhelmet
	items = list(
		/obj/item/reagent_containers/food/snacks/egg,
		/obj/item/reagent_containers/food/snacks/breadsys/ontop/butter,
		/obj/item/reagent_containers/food/snacks/cutlet,
		/obj/item/reagent_containers/food/snacks/grown/mushroom/plumphelmet,

	)
	result = /obj/item/reagent_containers/food/snacks/lw/stuffplump


/datum/recipe/almscake
	items = list(
		/obj/item/reagent_containers/food/snacks/doughslice,

	)
	result = /obj/item/reagent_containers/food/snacks/lw/bastardcake

// Handhelds

/datum/recipe/donair
	items = list(
		/obj/item/reagent_containers/food/snacks/doughslice,
		/obj/item/reagent_containers/food/snacks/breadsys/ontop/butter,
		/obj/item/reagent_containers/food/snacks/grown/carrot,
		/obj/item/reagent_containers/food/snacks/cutlet,
		/obj/item/reagent_containers/food/snacks/cheesewedge,
		/obj/item/reagent_containers/food/snacks/lw/exotic,

	)
	result = /obj/item/reagent_containers/food/snacks/lw/donair
// Spiced

/datum/recipe/stuffedhelmetspiced
	items = list(
		/obj/item/reagent_containers/food/snacks/egg,
		/obj/item/reagent_containers/food/snacks/breadsys/ontop/butter,
		/obj/item/reagent_containers/food/snacks/cutlet,
		/obj/item/reagent_containers/food/snacks/grown/mushroom/plumphelmet,
		/obj/item/reagent_containers/food/snacks/lw/exotic,

	)
	result = /obj/item/reagent_containers/food/snacks/lw/stuffplump/spiced

/datum/recipe/shroomsteakspiced
	items = list(
		/obj/item/reagent_containers/food/snacks/grown/mushroom/plumphelmet,
		/obj/item/reagent_containers/food/snacks/breadsys/ontop/butter,
		/obj/item/reagent_containers/food/snacks/lw/exotic,
	)
	result = /obj/item/reagent_containers/food/snacks/lw/shroomsteak/spiced

/datum/recipe/plpiespiced
	items = list(
		/obj/item/reagent_containers/food/snacks/dough,
		/obj/item/reagent_containers/food/snacks/egg,
		/obj/item/reagent_containers/food/snacks/breadsys/ontop/butter,
		/obj/item/reagent_containers/food/snacks/grown/mushroom/plumphelmet,
		/obj/item/reagent_containers/food/snacks/lw/exotic,
	)
	result = /obj/item/reagent_containers/food/snacks/lw/plpie/spiced

/datum/recipe/popiespiced
	items = list(
		/obj/item/reagent_containers/food/snacks/dough,
		/obj/item/reagent_containers/food/snacks/egg,
		/obj/item/reagent_containers/food/snacks/breadsys/ontop/butter,
		/obj/item/reagent_containers/food/snacks/grown/potato,
		/obj/item/reagent_containers/food/snacks/lw/exotic,
	)
	result = /obj/item/reagent_containers/food/snacks/lw/popie/spiced

/datum/recipe/mpiespiced
	items = list(
		/obj/item/reagent_containers/food/snacks/dough,
		/obj/item/reagent_containers/food/snacks/egg,
		/obj/item/reagent_containers/food/snacks/breadsys/ontop/butter,
		/obj/item/reagent_containers/food/snacks/grown/potato,
		/obj/item/reagent_containers/food/snacks/lw/exotic,
	)
	result = /obj/item/reagent_containers/food/snacks/lw/mpie/spiced

/datum/recipe/steakspiced
	items = list(
		/obj/item/reagent_containers/food/snacks/meat,
		/obj/item/reagent_containers/food/snacks/lw/exotic,
	)
	result = /obj/item/reagent_containers/food/snacks/lw/steak/spiced