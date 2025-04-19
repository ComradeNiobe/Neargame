//cara eu sem querer castrei o code
/datum/organ/internal/breasts
	name = "breasts"
	parent_organ = "chest"
	removed_type = /obj/item/reagent_containers/food/snacks/organ/internal/breasts

/obj/item/reagent_containers/food/snacks/organ/internal/breasts
    name = "breasts"
    icon_state = "breasts"
    gender = PLURAL
    var/breast_size = "A" 

/obj/item/reagent_containers/food/snacks/organ/internal/breasts/New()
	desc = "It's [breast_size] cup."
	..()

/obj/item/reagent_containers/food/snacks/organ/internal/breasts/proc/set_breasts_size(B_size)
	breast_size = B_size
	desc = "It's [breast_size] cup."
