/datum/species/human/midget
	name = "Midget"
	name_plural = "Midgets"
	total_health = 80
	min_age = 18
	max_age = 75
	icobase = 'icons/mob/human_races/midget/human_midget.dmi'
	deform = 'icons/mob/human_races/midget/dam_midget.dmi'
	minheightm = 130
	maxheightm = 145
	minheightf = 130
	maxheightf = 140
/datum/species/human/midget/handle_post_spawn(var/mob/living/carbon/human/H)
	H.mutations.Add(CLUMSY)
	H.pixel_y = -4
	return ..()
