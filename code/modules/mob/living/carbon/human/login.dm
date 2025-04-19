/mob/living/carbon/human/Login()
	..()
	src.update_hud()
	old_key = src.key
	src << sound(combat_music, repeat = 1, wait = 0, volume = 50, channel = 12)
	src << sound(null, repeat = 0, wait = 0, volume = 0, channel = 12)
	if(src in thanatiteams || src in pcteams)
		src.update_all_team_icons()
	if(iszombie(src))
		src.update_all_zombie_icons()
	matchmaker.update_family_icons(src)
	if(outsider && !migclass)
		if(ticker?.mode.config_tag == "siege")
			src.add_verb(/mob/living/carbon/human/proc/siegequip)
		else
			src.add_verb(/mob/living/carbon/human/proc/migequip)
	src.updateStatPanel()
	if(province == "Ravenheart") //thought it'd be a nice touch.
		src << output(list2params(list(1)), "outputwindow.browser:ChangeTheme")
	else
		src << output(list2params(list(0)), "outputwindow.browser:ChangeTheme")

	src.handle_regular_hud_updates()
	return
