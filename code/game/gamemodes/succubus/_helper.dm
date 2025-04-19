/proc/is_succubus(mob/living/carbon/human/M)
	return (M && M.mind && M.mind.special_role == "Succubus")