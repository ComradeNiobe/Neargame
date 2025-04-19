/mob/living/carbon/RightClick(mob/user)
	var/mob/living/carbon/H = user
	if(H.a_intent == "grab")
		if(/mob/proc/yank_out_object in verbs)
			src.yank_out_object(H)