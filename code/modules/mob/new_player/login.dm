/var/obj/effect/lobby_image = new/obj/effect/lobby_image()
var/interquote = pick("I hate this place and I would do anything to get out of here, may the great lord have mercy on us.",
"All pigs must die.", "There are no angels in Heaven; they're all down here.","Build your wings on the way down.","I'm a coward, stick your knife in me.",
"Happiness makes death a threat.","Three can keep a secret, if two of them are dead.","Conscious meat. Loving meat. Dreaming meat.",
"Be happy that it happened, not sad that it ends","This world is a machine! A Machine for Pigs! Fit only for the slaughtering of pigs!",
"I am begging you. You made me. You are my Creator, my Father. You cannot destroy me!","I have you now, creature. I will destroy you.",
"It is over. It is time to end this madness.","He who makes a beast of himself removes himself from the pain of being human.")
/obj/effect/lobby_image
	name = "Nearweb"
	desc = "Theatre of pain."
	icon = 'icons/misc/fullscreen.dmi'
	icon_state = "title"
	screen_loc = "WEST,SOUTH"
	plane = 300

/obj/effect/lobby_grain
	name = "Grain"
	desc = "Theatre of pain."
	icon = 'icons/misc/fullscreen.dmi'
	icon_state = "grain"
	screen_loc = "WEST,SOUTH"
	mouse_opacity = 0
	layer = MOB_LAYER+6
	plane = 300

/obj/effect/lobby_image/New()
	if(master_mode == "holywar")
		icon_state = "holywar"
	else
		icon_state = "title"
	overlays += /obj/effect/lobby_grain
	desc = vessel_name()

/mob/new_player/Login()
	..()
	if(ticker?.current_state != GAME_STATE_PLAYING)
		for(var/mob/new_player/N in mob_list)
			to_chat(N, "⠀<span class='passivebold'>A new player has joined the game</span>")
	message_admins("<span class='notice'>Login: [key], id:[computer_id], ip:[client.address]</span>")
	update_Login_details()	//handles setting lastKnownIP and computer_id for use by the ban systems as well as checking for multikeying
	winset(src, null, "mainwindow.title='Nearweb'")//Making it so window is named what it's named.
	if(join_motd)
		if(guardianlist.Find(ckey(src.client.key)))
			to_chat(src, "Welcome, <span class='graytextbold'>[capitalize(usr.ckey)]</span>! Your reliability level: <span class='guardianlobby'>Guardian</span>")
		else if(src.client in admins)
			to_chat(src, "Welcome, <span class='graytextbold'>[capitalize(usr.ckey)]</span>! Your reliability level: <span class='adminlobby'>[src.client.holder.rank]</span>")
		else if(access_comrade.Find(ckey(src.client.key)))
			to_chat(src, "Welcome, <span class='graytextbold'>[capitalize(usr.ckey)]</span>! Your reliability level: <span class='comradelobby'>Comrade</span>")
		else if(access_villain.Find(ckey(src.client.key)))
			to_chat(src, "Welcome, <span class='graytextbold'>[capitalize(usr.ckey)]</span>! Your reliability level: <span class='villainlobby'>Villain</span>")
		else if(access_pigplus.Find(ckey(src.client.key)))
			to_chat(src, "Welcome, <span class='graytextbold'>[capitalize(usr.ckey)]</span>! Your reliability level: <span class='graytextbold'>Experienced Pig</span>")
		else
			to_chat(src, "Welcome, <span class='graytextbold'>[capitalize(usr.ckey)]</span>! Your reliability level: <span class='graytextbold'>Pig</span>")
		//to_chat(src, "Press <a href='byond://?src=\ref[src];action=f12'>F12</a> find your death!")
		to_chat(src, "Map of the week:</span> <span class='bname'><i>[currentmaprotation]</i></span>")
		to_chat(src, "<span class='lobby'>Nearweb</span>   <span class='lobbyy'>Story #[story_id]</span>")
		to_chat(src, "<span class='bname'><b>Interzone:</span></b> <i>\"[interquote]\"</i>")
	if(ticker && ticker.current_state == GAME_STATE_PLAYING && master_mode == "inspector")
		to_chat(src, "\n<div class='firstdivmood'><div class='moodbox'><span class='graytext'>You may join as the Inspector or his bodyguard.</span>\n<span class='feedback'><a href='byond://?src=\ref[src];acao=joininspectree'>1. I want to.</a></span>\n<span class='feedback'><a href='byond://?src=\ref[src];acao=nao'>2. I'll pass.</a></span></div></div>")


	if(!mind)
		mind = new /datum/mind(key)
		mind.active = 1
		mind.current = src

	if(length(newplayer_start))
		loc = pick(newplayer_start)
	else
		loc = locate(1,1,1)
	lastarea = loc


	sight |= SEE_TURFS
	player_list |= src
	client.screen += lobby_image

	new_player_panel()
	src << output(list2params(list(0)), "outputwindow.browser:ChangeTheme")
	spawn(40)
		if(client)
			client.playtitlemusic()
	spawn(30)
		client.chatOutput.start()