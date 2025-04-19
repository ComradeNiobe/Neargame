/obj/machinery/charon
	name = "drydock launch console"
	icon = 'icons/obj/Launch.dmi'
	icon_state = "launch2"
	density = 1
	anchored = 1

/obj/machinery/charon/attack_hand(mob/living/carbon/human/user)
	var/sounds = 'sound/webbers/console_input2.ogg'
	if(user.check_perk(/datum/perk/illiterate) || user.my_stats.get_stat(STAT_IN) <= 5)
		to_chat(usr, "<span class='jogtowalk'><i>How do I use this...</i></span>")
		playsound(src.loc, sounds, 25, 1)
		if(do_after(user, 10))
			if(prob(90))
				playsound(src.loc, sounds, 25, 1)
		else
			return
	if(do_after(user, 10))
		playsound(src.loc, sounds, 25, 1)
		var/choice = input("Ulysses Panel","ULYSSES") in list("Launch","Cancel Launch", "(CANCEL)")
		var/datum/shuttle/shuttle = shuttleMain
		switch(choice)
			if("Launch")
				src.add_fingerprint(usr)

				//if(world.time < 10 MINUTES) // Ten minute grace period to let the game get going without lolmetagaming. -- TLE
				//	to_chat(usr, "<span class='combat'>The Ulysses is refueling. Please wait another</span> <span class='combatbold'>[round((6000-world.time)/600)]</span> <span class='combat'>minutes before trying again.</span>")
				//	return

				if(ticker.mode.config_tag == "kingwill" && world.time < 80 MINUTES)
					to_chat(usr, "<span class='combatbold'>The tribunal will not allow the Ulysses to be launched.</span>")
					return

				if(ticker.mode.config_tag == "siege")
					to_chat(usr, "<span class='combatbold'>There can be only one!</span>")
					return

				if(shuttle.called)
					to_chat(usr, "<span class='combat'>The Ulysses launch has already been initiated.</span>")
					return

				shuttle.callshuttle()
				log_game("[key_name(user)] has launched the Ulysses.")
				message_admins("[key_name_admin(user)] has launched the Ulysses.", 1)
			if("Cancel Launch")
				if(shuttle.called && !shuttle.launched) //check that shuttle isn't already heading to centcomm
					shuttle.recall()
					log_game("[key_name(user)] has canceled the Ulysses launch.")
					message_admins("[key_name_admin(user)] has canceled the Ulysses launch.", 1)
				return
			if("(CANCEL)")
				return