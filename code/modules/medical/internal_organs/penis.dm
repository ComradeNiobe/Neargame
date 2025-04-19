//cara eu sem querer castrei o code
/datum/organ/internal/penis
	name = "penis"
	parent_organ = "groin"
	removed_type = /obj/item/reagent_containers/food/snacks/organ/internal/penis

/obj/item/reagent_containers/food/snacks/organ/internal/penis
    name = "penis"
    icon_state = "penis"
    gender = PLURAL
    var/penis_size = 10

/obj/item/reagent_containers/food/snacks/organ/internal/penis/New()
	desc = "It's [penis_size] cm long."
	..()

/obj/item/reagent_containers/food/snacks/organ/internal/penis/proc/set_penis_size(P_size)
	penis_size = P_size
	desc = "It's [penis_size] cm long."
