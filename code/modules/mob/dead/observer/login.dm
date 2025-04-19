/mob/dead/observer/Login()
	..()
	client.color = NOIRLIST
	add_overlay_wraith()
	src << sound(pick('sound/lfwbambi/ghosted1.ogg','sound/lfwbambimusic/geist.ogg','sound/lfwbambi/ghosted4.ogg','sound/lfwbambi/ghosted2.ogg'), repeat = 0, wait = 0, volume =  src?.client?.prefs?.music_volume, channel = 12)
	updateStatPanel()
	if(ticker && ticker.current_state == GAME_STATE_PLAYING && master_mode == "inspector")
		to_chat(src, "\n<div class='firstdivmood'><div class='moodbox'><span class='graytext'>You may join as the Inspector or his bodyguard.</span>\n<span class='feedback'><a href='byond://?src=\ref[src];acao=joininspectree'>1. I want to.</a></span>\n<span class='feedback'><a href='byond://?src=\ref[src];acao=nao'>2. I'll pass.</a></span></div></div>")

/mob/living/carbon/human/Login()
	..()
	clear_fullscreen("ghost")
	src << sound(null, repeat = 0, wait = 0, volume =  0, channel = 9) // remove the ambience
	var/area/A = get_area(src)
	if(A.forced_ambience)
		var/sound/S = sound(pick(A.forced_ambience), repeat=1, wait=0, channel=9, volume=src?.client?.prefs?.music_volume)
		src << S