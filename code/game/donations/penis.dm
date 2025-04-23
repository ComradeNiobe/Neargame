/mob/living/carbon/human/New()
	. = ..()
	if(client?.prefs?.togglesize)
		penis_size = rand(30, 32)
