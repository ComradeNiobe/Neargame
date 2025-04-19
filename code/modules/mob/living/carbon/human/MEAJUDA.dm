proc/coisa(var/obj/item/reagent_containers/food/snacks/organ/O, var/mob/living/carbon/human/who, var/arme = 0)
	var/organ_name = initial(O.name)
	if(arme == 0)
		who.internal_organs_by_name[organ_name] = null
		who.internal_organs_by_name -= organ_name
		for(var/datum/organ/internal/I in who.internal_organs)
			if(I.name == organ_name)
				who.internal_organs -= I
		processing_objects.Remove(O.organ_data)
	else
		O.organ_data:owner = who
		if(!(organ_name in who.internal_organs_by_name))
			who.internal_organs_by_name += organ_name
		who.internal_organs_by_name[organ_name] = O.organ_data
		who.internal_organs += O.organ_data
		processing_objects.Add(O.organ_data)