/mob/living/carbon/human/New()
	..()
	if(!client)
		return
	if(donation_30cm.Find(ckey))
		penis_size = rand(30, 32)
