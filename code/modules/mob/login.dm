//handles setting lastKnownIP and computer_id for use by the ban systems as well as checking for multikeying
/mob/proc/update_Login_details()
	winset(src, null, "mainwindow.title='[vessel_name]'")
	//Multikey checks and logging
	if(!client)
		return
	lastKnownIP	= client.address
	computer_id	= client.computer_id
	log_access("Login: [key_name(src)] from [lastKnownIP ? lastKnownIP : "localhost"]-[computer_id] || BYOND v[client.byond_version]")
	if(config.log_access)
		for(var/mob/M in player_list)
			if(M == src)	continue
			if( M.key && (M.key != key) )
				var/matches
				if( (M.lastKnownIP == client.address) )
					matches += "IP ([client.address])"
				if( (M.computer_id == client.computer_id) )
					if(matches)	matches += " and "
					matches += "ID ([client.computer_id])"
					spawn() alert("You have logged in already with another key this round, please log out of this one NOW or risk being banned!")
				if(matches)
					if(M.client)
						message_admins("<font color='red'><B>Notice: </B><font color='blue'><A href='byond://?src=\ref[usr];priv_msg=\ref[src]'>[key_name_admin(src)]</A> has the same [matches] as <A href='byond://?src=\ref[usr];priv_msg=\ref[M]'>[key_name_admin(M)]</A>.</font>", 1)
						log_access("Notice: [key_name(src)] has the same [matches] as [key_name(M)].")
					else
						message_admins("<font color='red'><B>Notice: </B><font color='blue'><A href='byond://?src=\ref[usr];priv_msg=\ref[src]'>[key_name_admin(src)]</A> has the same [matches] as [key_name_admin(M)] (no longer logged in). </font>", 1)
						log_access("Notice: [key_name(src)] has the same [matches] as [key_name(M)] (no longer logged in).")

/mob/Login()
	client.chatOutput.start()
	player_list |= src
	update_Login_details()
	world.update_status()

	client.images = null				//remove the images such as AIs being unable to see runes
	client.screen = null				//remove hud items just in case
	if(hud_used)	qdel(hud_used)		//remove the hud objects
	hud_used = new /datum/hud(src)

	next_move = 1
	sight |= SEE_SELF
	..()

	if(loc && !isturf(loc))
		client.eye = loc
		client.perspective = EYE_PERSPECTIVE
	else
		client.eye = src
		client.perspective = MOB_PERSPECTIVE

	//Clear ability list and update from mob.
	client.verbs -= ability_verbs

	if(habilities)
		client.verbs |= habilities

	if(istype(src,/mob/living/carbon/human))
		var/mob/living/carbon/human/H = src
		if(H.species && H.species.abilities)
			client.verbs |= H.species.abilities
	src.add_filter_effects()
	updateStatPanel()
	hud_used?.add_inventory_overlay()
	winset(src, "name", "text='[real_name]'")
	//bug blur effect, para ativar por completo tira os comentario do Turfs.dm