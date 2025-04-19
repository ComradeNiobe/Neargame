/obj/item/storage/pacote
	name = "papelote"
	desc = "Papelote de droga."
	icon_state ="powderbag"
	item_state = "shake"
	throw_speed = 1
	throw_range = 5
	w_class = 3.0
	flags = FPRINT | TABLEPASS

/obj/item/storage/pacote/cocaina/New()
	..()
	new /obj/item/reagent_containers/food/snacks/cocaine(src)
	new /obj/item/reagent_containers/food/snacks/cocaine(src)
	new /obj/item/reagent_containers/food/snacks/cocaine(src)
	new /obj/item/reagent_containers/food/snacks/cocaine(src)
	new /obj/item/reagent_containers/food/snacks/cocaine(src)

/obj/item/storage/pacote/heroinlq/New()
	..()
	new /obj/item/reagent_containers/food/snacks/desomorphine(src)
	new /obj/item/reagent_containers/food/snacks/desomorphine(src)
	new /obj/item/reagent_containers/food/snacks/desomorphine(src)
	new /obj/item/reagent_containers/food/snacks/desomorphine(src)
	new /obj/item/reagent_containers/food/snacks/desomorphine(src)