var/global/energyInvestimento = 0
/// Associated list. K: nominee -> V: nominator
var/global/list/medal_nominated = list()

/obj/structure/stool/bed/chair/ThroneMid
	name = "Baron's Throne"
	desc = "A magnificent throne."
	icon = 'icons/obj/throne_new.dmi'
	icon_state = "enoch_throne"
	anchored = 1
	flammable = 0
	var/captured = FALSE

/obj/structure/stool/bed/chair/ThroneMid/interact(mob/user)
	if(!CanPhysicallyInteract(user))
		return
	user.set_machine(src)
	var/list/dat = list()

	dat += "<div id='thronecom'>"
	dat += "<a class='thronelinks' href='byond://?src=\ref[src];usecrown=declareemergency'><span class='thronelink'>Declare Emergency</span></a>"
	dat += "<a class='thronelinks' href='byond://?src=\ref[src];usecrown=gathermeeting'><span class='thronelink second'>Gather a Meeting</span></a>"
	dat += "<a class='thronelinks' href='byond://?src=\ref[src];usecrown=decree'><span class='thronelink'>Make a Decree</span></a>"
	dat += "<a class='thronelinks' href='byond://?src=\ref[src];usecrown=capture'><span class='thronelink second'>Capture</span></a>"
	dat += "<a class='thronelinks' href='byond://?src=\ref[src];usecrown=execute'><span class='thronelink'>Execute</span></a>"
	dat += "<a class='thronelinks' href='byond://?src=\ref[src];usecrown=settaxes'><span class='thronelink second'>Set the Taxes</span></a>"
	dat += "<a class='thronelinks' href='byond://?src=\ref[src];usecrown=riotreal'><span class='thronelink'>Riot!</span></a>"
	dat += "<a class='thronelinks' href='byond://?src=\ref[src];usecrown=appointhand'><span class='thronelink second'>Appoint a Hand</span></a>"
	dat += "<a class='thronelinks' href='byond://?src=\ref[src];usecrown=battlealarm'><span class='thronelink'>Battle Alarm!</span></a>"
	dat += "<a class='thronelinks' href='byond://?src=\ref[src];usecrown=firearmlaw'><span class='thronelink second'>Firearms Trade Law</span></a>"
	dat += "<a class='thronelinks' href='byond://?src=\ref[src];usecrown=drugslaw'><span class='thronelink'>Drugs Trade Law</span></a>"
	dat += "<a class='thronelinks' href='byond://?src=\ref[src];usecrown=expandchurch'><span class='thronelink second'>Expand Church Powers</span></a>"
	dat += "<a class='thronelinks' href='byond://?src=\ref[src];usecrown=reassign'><span class='thronelink'>Reassign</span></a>"
	dat += "<a class='thronelinks' href='byond://?src=\ref[src];usecrown=playsong'><span class='thronelink second'>Play Songs</span></a>"
	dat += "<a class='thronelinks' href='byond://?src=\ref[src];usecrown=migburnlaw'><span class='thronelink'>Migrants Burn Law</span></a>"
	dat += "<a class='thronelinks' href='byond://?src=\ref[src];usecrown=openpit'><span class='thronelink second'>Open the Pit!</span></a>"
	dat += "<a class='thronelinks' href='byond://?src=\ref[src];usecrown=callformigrants'><span class='thronelink'>Call For Migrants</span></a>"
	dat += "<a class='thronelinks' href='byond://?src=\ref[src];usecrown=craftmedal'><span class='thronelink second'>Craft a Medal</span></a>"
	dat += "<a class='thronelinks' href='byond://?src=\ref[src];usecrown=energylaw'><span class='thronelink'>Energy Law</span></a>"
	dat += "<a class='thronelinks' href='byond://?src=\ref[src];usecrown=labourend'><span class='thronelink'>Proclaim End of Labours</span></a>"
	dat += "</div>"

	var/datum/browser/popup = new(user, "baronthrone", "The Dragon Throne", 300, 700)
	popup.set_content(jointext(dat,"<br>"))
	popup.add_stylesheet("throne", 'html/browser/throne.css')
	popup.open()

var/global/isEmergency = 0
var/global/isMeeting = 0
var/global/list/riot_essential = list("Baron", "Court Bodyguard", "Charybdis", "Squire", "Kraken", "Triton", "Hand", "Heir", "Successor", "Baroness", "Guest", "Meister", "Treasurer", "Praetor", "Vicar", "Sniffer", "Sheriff")

/obj/structure/stool/bed/chair/ThroneMid/Topic(mob/living/carbon/human/user, list/href_list, state = global.physical_topic_state)
	. = ..()
	if(user != src.buckled_mob)
		return TOPIC_HANDLED
	if(!CanPhysicallyInteractWith(user, src))
		to_chat(user, SPAN_WARNING("You must stay close to \the [src]!"))
		return

	var/obj/item/clothing/head/caphat/crown = user.get_item_by_slot(slot_head)
	var/list/allowedjobs = list("Baron","Hand","Count","Baroness","Heir","Successor")
	if(user.job == "Jester" && user.special == "jesterdecree")
		switch(href_list["usecrown"])
			if("decree")
				var/input = sanitize(input(usr, "Type your decree.", "Enoch's Gate Decree", "") as message|null)
				if(!input)
					return TOPIC_NOACTION
				if(global.is_http_protocol.Find(input))
					message_admins("[key_name(user)] attempted to send a decree with a URL in their decree.")
					return TOPIC_NOACTION
				if(get_dist(src, user) > 1)
					return TOPIC_NOACTION
				if(user.stat)
					return TOPIC_NOACTION
				to_chat(world, "<span class='ravenheartfortress'>Enoch's Gate Hold</span>")
				to_chat(world, "<span class='excomm'>New Baron's decree!</span>")
				sound_to(world, sound('sound/AI/bell_toll.ogg'))
				to_chat(world, "<span class='decree'>[input]</span>")
				to_chat(world, "<br>")
				for(var/obj/machinery/information_terminal/T in vending_list)
					if(T.hacked) continue
					if(T.screenbroken) continue
					T.announces += input

				return TOPIC_HANDLED
	if(user.job == "Kraken")
		switch(href_list["usecrown"])
			if("riotreal")
				if(riotreal == 0 && riot != 1)
					to_chat(world, "<br>")
					to_chat(world, "<span class='ravenheartfortress'>Enoch's Gate Hold</span>")
					to_chat(world, "<span class='excomm'>¤Riot Declared! Tritons must gear up in the small armory, those caught outside their residence shall be executed!¤</span>")
					world << sound('sound/AI/bell_toll.ogg')
					to_chat(world, "<br>")
					to_chat(world, "<span class='excomm'>New [user.job]'s decree!</span>")
					to_chat(world, "<br>")
					world << sound('sound/RiotAlarm.ogg', repeat = 1, wait = 0, volume = 100, channel = 6)
					riotreal = 1
					for(var/obj/machinery/door/poddoor/shutters/B in world)
						if(B.alert == "baronriot")
							B.open()
				else
					if(riotreal == 1 && riot == 0)
						to_chat(world, "<br>")
						to_chat(world, "<span class='ravenheartfortress'>Enoch's Gate Hold</span>")
						to_chat(world, "<span class='excomm'><b>¤Riot state inactive. Fortress residents may now return to their duties.¤</b></span>")
						world << sound('sound/AI/bell_toll.ogg')
						to_chat(world, "<br>")
						to_chat(world, "<span class='excomm'>New [user.job]'s decree!</span>")
						to_chat(world, "<br>")
						world << sound('sound/RiotAlarm.ogg', repeat = 0, wait = 0, volume = 0, channel = 6)
						riotreal = 0
						for(var/obj/machinery/door/poddoor/shutters/B in world)
							if(B.alert == "baronriot")
								B.close()
					if(riot == 1)
						to_chat(usr, "<span class='combat'>[pick(fnord)] I need to turn off the Battle Alarm first!</span>")

				return TOPIC_HANDLED
	if(allowedjobs.Find(user.job) && user.head && crown)
		switch(href_list["usecrown"])
			if("declareemergency")
				if(!global.isEmergency)
					to_chat(world, "<span class='ravenheartfortress'>Enoch's Gate Hold</span>")
					to_chat(world, "<span class='excomm'>New [user.job]'s decree!</span>")
					world << sound('sound/AI/bell_toll.ogg')
					to_chat(world, "<span class='decree'>Our glorious [user.job] declares state of EMERGENCY!</span>")
					to_chat(world, "<br>")
					global.isEmergency = 1
					for(var/obj/machinery/emergency_room/E in emergency_rooms)
						if(!E.activearea.alarm_toggled)
							E.icon_state = E.active_state
							E.activearea.alarm_toggled = TRUE
							playsound(E.loc, 'sound/effects/danger_alarm.ogg',80,0, 30, 30)
							E.active = TRUE
							spawn(20)
								processing_objects.Add(E)
				else
					to_chat(world, "<span class='ravenheartfortress'>Enoch's Gate Hold</span>")
					to_chat(world, "<span class='excomm'>New [user.job]'s decree!</span>")
					world << sound('sound/AI/bell_toll.ogg')
					to_chat(world, "<span class='decree'>Our glorious [user.job] undeclares state of emergency!</span>")
					to_chat(world, "<br>")
					global.isEmergency = 0
					for(var/obj/machinery/emergency_room/E in emergency_rooms)
						if(E.activearea.alarm_toggled)
							E.icon_state = initial(E.icon_state)
							E.activearea.alarm_toggled = FALSE
							E.active = FALSE
							spawn(20)
								processing_objects.Remove(E)

				return TOPIC_HANDLED
			if("labourend")
				var/endbegun = 0
				var/obj/item/device/radio/intercom/INTERCOM = new()
				if(TIME_SINCE_START >= 60 MINUTES)
					switch(alert("Are you SURE you want to end the nightly labours? (This will end the round and cannot be undone)", "End Round", "Yes", "No"))
						if("Yes")
							if(!endbegun)
								endbegun = 1
								spawn(15 MINUTES)
									quietend = 1
									world << 'sound/lfwbsounds/wondermaker.ogg'
									INTERCOM.autosay("The Nightly Labours have ended, return to your dwellings for curfew.", "Curfew Announcement")
								spawn(5 MINUTES)
									world << 'sound/machines/pods_launch_countdown.ogg'
									INTERCOM.autosay("The Nightly Labours will end in 10 minutes. Complete your duties and return to your dwelling.", "Curfew Announcement")
								spawn(10 MINUTES)
									world << 'sound/machines/pods_launch_countdown.ogg'
									INTERCOM.autosay("The Nightly Labours will end in 5 minutes. Complete your duties and return to your dwelling.", "Curfew Announcement")
								to_chat(world, "<span class='ravenheartfortress'>Enoch's Gate Hold</span>")
								to_chat(world,"<span class='excomm'>¤The Lord proclaims that the end of Nightly Labours shall commence in 15 minutes!!¤</span>")
								world << sound('sound/AI/bell_toll.ogg')
								to_chat(world, "<br>")
								to_chat(world, "<span class='decree'>New [user.job]'s decree!</span>")
								to_chat(world, "<br>")
								return TOPIC_HANDLED
						else
							return TOPIC_HANDLED
				else
					to_chat(user, "<span class='combat'>What am I doing? It's too soon to end the labours.</span>")
					return TOPIC_HANDLED
			if("gathermeeting")
				if(!global.isMeeting)
					to_chat(world, "<span class='ravenheartfortress'>Enoch's Gate Hold</span>")
					to_chat(world, "<span class='excomm'>New [user.job]'s decree!</span>")
					world << sound('sound/AI/bell_toll.ogg')
					to_chat(world, "<span class='decree'>Our glorious [user.job] calls for a MEETING IN THE THRONE ROOM!</span>")
					to_chat(world, "<br>")
					global.isMeeting = 1
				else
					to_chat(world, "<span class='ravenheartfortress'>Enoch's Gate Hold</span>")
					to_chat(world, "<span class='excomm'>New [user.job]'s decree!</span>")
					world << sound('sound/AI/bell_toll.ogg')
					to_chat(world, "<span class='decree'>Our glorious [user.job] finishes the meeting!</span>")
					to_chat(world, "<span class='decree'>Go away!</span>")
					to_chat(world, "<br>")
					global.isMeeting = 0
				return TOPIC_HANDLED

			if("decree")
				var/input = sanitize(input(user, "Type your decree.", "Enoch's Gate Decree", "") as message|null)
				if(!input)
					return
				if(global.is_http_protocol.Find(input))
					message_admins("[key_name(user)] attempted to send a decree with a URL in their decree.")
					return TOPIC_NOACTION
				if(get_dist(src, user) > 1)
					return TOPIC_NOACTION
				if(user.stat)
					return TOPIC_NOACTION
				to_chat(world, "<span class='ravenheartfortress'>Enoch's Gate Hold</span>")
				to_chat(world, "<span class='excomm'>New [user.job]'s decree!</span>")
				world << sound('sound/AI/bell_toll.ogg')
				to_chat(world, "<span class='decree'>[input]</span>")
				to_chat(world, "<br>")
				for(var/obj/machinery/information_terminal/T in vending_list)
					if(T.hacked) continue
					if(T.screenbroken) continue
					T.announces += input
				return TOPIC_HANDLED

			if("capture")
				var/input = sanitize(input(usr, "Type your capture.", "Enoch's Gate Decree", "") as message|null)
				if(!input)
					return TOPIC_NOACTION
				if(global.is_http_protocol.Find(input))
					message_admins("[key_name(user)] attempted to send a decree with a URL in their decree.")
					return TOPIC_NOACTION
				to_chat(world, "<span class='ravenheartfortress'>Enoch's Gate Hold</span>")
				to_chat(world, "<span class='excomm'>New [user.job]'s decree!</span>")
				world << sound('sound/AI/bell_toll.ogg')
				to_chat(world, "<span class='decree'>[input] must be CAPTURED alive!</span>")
				to_chat(world, "<br>")
				return TOPIC_HANDLED

			if("execute")
				var/input = sanitize(input(usr, "Type your execution.", "Enoch's Gate Decree", "") as message|null)
				if(!input)
					return TOPIC_NOACTION
				if(global.is_http_protocol.Find(input))
					message_admins("[key_name(user)] attempted to send a decree with a URL in their decree.")
					return TOPIC_NOACTION
				to_chat(world, "<span class='ravenheartfortress'>Enoch's Gate Hold</span>")
				to_chat(world, "<span class='excomm'>New [user.job]'s decree!</span>")
				world << sound('sound/AI/bell_toll.ogg')
				to_chat(world, "<span class='decree'>[input] must be EXECUTED!</span>")
				to_chat(world, "<br>")
				return TOPIC_HANDLED

			if("settaxes")
				var/input = sanitize_num(input(usr, "Choose between 0 and 100 percent.", "Enoch's Gate Decree", "") as num, 0, 100)
				to_chat(world, "<br>")
				to_chat(world, "<span class='ravenheartfortress'>Enoch's Gate Hold</span>")
				to_chat(world,"<span class='excomm'>¤The new taxes are <i>[input]%</i>!¤</span>")
				taxes = input
				world << sound('sound/AI/bell_toll.ogg')
				to_chat(world, "<br>")
				to_chat(world, "<span class='decree'>New [user.job]'s decree!</span>")
				to_chat(world, "<br>")
				return TOPIC_HANDLED

			if("opensmall")
				var/obj/item/device/radio/headset/bracelet/a = new /obj/item/device/radio/headset/bracelet(null)
				a.autosay("Alert: The small armory has been opent!", "Emergency")
				for(var/obj/machinery/door/poddoor/shutters/B in world)
					if(B.alert == "smallarmory")
						B.open()
				return TOPIC_HANDLED

			if("appointhand")
				var/list/candidates = list()
				if(fortHand)
					return TOPIC_HANDLED
				for(var/mob/living/carbon/human/near_mobs in oview(1,usr))
					candidates |= near_mobs
				var/mob/living/carbon/human/input = sanitize_name(input(usr, "Enter the name of your appointee", "What?", "") as null|anything in candidates)
				var/mob/living/carbon/human/G = input
				to_chat(usr, "[G]")
				if(!input)
					return TOPIC_NOACTION
				G.job = "Hand"
				fortHand = G.name
				if(G.wear_id)
					var/obj/item/card/id/R = G.wear_id
					R.registered_name = G.real_name
					R.rank = "Hand"
					R.assignment = "Hand"
					R.access = list(meistery,smith,treasury,esculap,sanctuary,innkeep,merchant,garrison,keep,baronquarter,hump,courtroom,soilery,lifeweb,geschef, marduk, hand_access)
					R.name = "[R.registered_name]'s Ring"
				if(!fortHand)
					return TOPIC_NOACTION
				to_chat(world, "<span class='ravenheartfortress'>Enoch's Gate Hold</span>")
				to_chat(world, "<span class='excomm'>New [src.buckled_mob.job]'s decree!</span>")
				world << sound('sound/AI/bell_toll.ogg')
				to_chat(world, "<span class='decree'>[G.real_name] has been named Hand, welcome the Lord Regent!</span>")
				return TOPIC_HANDLED

			if("battlealarm")
				if(riot == 0 && riotreal == 0)
					to_chat(world, "<br>")
					to_chat(world, "<span class='ravenheartfortress'>Enoch's Gate Hold</span>")
					to_chat(world, "<span class='excomm'>¤BATTLE ALARM! Everyone must head to the Armory and prepare for combat!¤</span>")
					world << sound('sound/AI/bell_toll.ogg')
					to_chat(world, "<br>")
					to_chat(world, "<span class='decree'>New [buckled_mob.job]'s decree!</span>")
					to_chat(world, "<br>")
					world << sound('sound/music/mantrap.ogg', repeat = 1, wait = 0, volume = 50, channel = 6)
					riot = 1
					for(var/obj/machinery/door/poddoor/shutters/B in world)
						if(B.alert == "baronalert")
							B.open()
				else
					if(riot == 1 && riotreal == 0)
						to_chat(world, "<br>")
						to_chat(world, "<span class='ravenheartfortress'>Enoch's Gate Hold</span>")
						to_chat(world, "<span class='excomm'><b>¤The alert has been terminated.¤</b></span>")
						world << sound('sound/AI/bell_toll.ogg')
						to_chat(world, "<br>")
						to_chat(world, "<span class='decree'>New [buckled_mob.job]'s decree!</span>")
						to_chat(world, "<br>")
						world << sound('sound/music/mantrap.ogg', repeat = 0, wait = 0, volume = 0, channel = 6)
						riot = 0
						for(var/obj/machinery/door/poddoor/shutters/B in world)
							if(B.alert == "baronalert")
								B.close()
					if(riotreal == 1)
						to_chat(usr, "<span class='combat'>[pick(fnord)] I need to turn off the Riot Alarm first!</span>")
				return TOPIC_HANDLED

			if("riotreal")
				if(riotreal == 0 && riot != 1)
					to_chat(world, "<br>")
					to_chat(world, "<span class='ravenheartfortress'>Enoch's Gate Hold</span>")
					to_chat(world, "<span class='excomm'>¤Riot Declared! Tritons must gear up in the small armory, those caught outside their residence shall be executed!¤</span>")
					world << sound('sound/AI/bell_toll.ogg')
					to_chat(world, "<br>")
					to_chat(world, "<span class='decree'>New [buckled_mob.job]'s decree!</span>")
					to_chat(world, "<br>")
					world << sound('sound/RiotAlarm.ogg', repeat = 1, wait = 0, volume = 100, channel = 6)
					riotreal = 1
					for(var/obj/machinery/door/poddoor/shutters/B in world)
						if(B.alert == "baronriot")
							B.open()
				else
					if(riotreal == 1 && riot == 0)
						to_chat(world, "<br>")
						to_chat(world, "<span class='ravenheartfortress'>Enoch's Gate Hold</span>")
						to_chat(world, "<span class='excomm'><b>¤Riot state inactive. Fortress residents may now return to their duties.¤</b></span>")
						world << sound('sound/AI/bell_toll.ogg')
						to_chat(world, "<br>")
						to_chat(world, "<span class='decree'>New [buckled_mob.job]'s decree!</span>")
						to_chat(world, "<br>")
						world << sound('sound/RiotAlarm.ogg', repeat = 0, wait = 0, volume = 0, channel = 6)
						riotreal = 0
						for(var/obj/machinery/door/poddoor/shutters/B in world)
							if(B.alert == "baronriot")
								B.close()
					if(riot == 1)
						to_chat(usr, "<span class='combat'>[pick(fnord)] I need to turn off the Battle Alarm first!</span>")
				return TOPIC_HANDLED

			if("firearmlaw")
				world << sound('sound/AI/bell_toll.ogg')
				to_chat(world, "<br>")
				to_chat(world, "<span class='ravenheartfortress'>Enoch's Gate Hold</span>")
				if(!gunban)
					to_chat(world, "<span class='excomm'>¤The sale and exchange of firearms is now Banned in the fortress.¤</span>")
					gunban = 1
				else
					to_chat(world, "<span class='excomm'>¤The sale and exchange of firearms is now Allowed in the fortress.¤</span>")
					gunban = 0
				to_chat(world, "<br>")
				to_chat(world, "<span class='decree'>New [user.job]'s decree!</span>")
				to_chat(world, "<br>")
				return TOPIC_HANDLED

			if("drugslaw")
				to_chat(world, "<br>")
				to_chat(world, "<span class='ravenheartfortress'>Enoch's Gate Hold</span>")
				if(!drugban)
					to_chat(world, "<span class='excomm'>¤The sale and exchange of drugs is now Banned in the fortress.¤</span>")
					drugban = 1
				else
					to_chat(world, "<span class='excomm'>¤The sale and exchange of drugs is now Allowed in the fortress.¤</span>")
					drugban = 0
				world << sound('sound/AI/bell_toll.ogg')
				to_chat(world, "<br>")
				to_chat(world, "<span class='decree'>New [user.job]'s decree!</span>")
				to_chat(world, "<br>")
				return TOPIC_HANDLED

			if("expandchurch")
				switch(alert("Are you SURE you want to expand church powers? This is irreversible.", "Expand Church Powers", "Yes", "No"))
					if("Yes")
						if(!churchexpanded)
							to_chat(world, "<span class='ravenheartfortress'>Enoch's Gate Hold</span>")
							to_chat(world,"<span class='excomm'>¤The Lord expands the churches powers, Praise the Lord!!¤</span>")
							world << sound('sound/AI/bell_toll.ogg')
							to_chat(world, "<br>")
							to_chat(world, "<span class='decree'>New [user.job]'s decree!</span>")
							to_chat(world, "<br>")
							churchexpanded = 1
							Inquisitor_Points += rand(6,11)

							for(var/mob/living/carbon/human/ChurchMen in mob_list)
								if(ChurchMen.wear_id)
									if(ChurchMen.job == "Praetor" || ChurchMen.job == "Sniffer" || ChurchMen.job == "Vicar" || ChurchMen.job == "Sniffer")
										var/obj/item/card/id/R = ChurchMen.wear_id
										R.access = list(church, access_morgue, access_chapel_office, access_maint_tunnels, meistery,smith,treasury,esculap,sanctuary,innkeep,merchant,garrison,keep,baronquarter,hump,courtroom,soilery,lifeweb,geschef, marduk, hand_access)

						else
							return TOPIC_NOACTION
				return TOPIC_HANDLED

			if("reassign")
				var/turf/T = get_step(src, SOUTH)
				var/job = input("What job?", "Dragon Throne") in list("Judge", "Meister", "Baroness", "Heir", "Successor", "Jester",\
				"Butler", "Sitzfrau", "Maid", "Servant", "Kraken", "Triton", "Charybdis", "Squire", "Sheriff", "Court Bodyguard",\
				"Esculap", "Serpent", "Blacksmith", "Blacksmith’s Assistant", "Pusher",\
				"Amuser", "Merchant", "Homeless", "Wright", "Mortician", "Misero",\
				"Docker", "Soiler", "Treasurer", "Madam")
				for(var/mob/living/carbon/human/M in T)
					M.job = job
					if(M.wear_id)
						var/obj/item/card/id/R = M.wear_id
						R.registered_name = M.real_name
						R.rank = job
						R.assignment = job
						R.name = "[R.registered_name]'s Ring"
						switch(job)
							if("Judge") R.access = list(keep,courtroom)
							if("Meister") R.access = list(keep,meistery,treasury)
							if("Baroness") R.access = list(treasury,meistery,keep,baronquarter)
							if("Court Bodyguard") R.access = list(garrison,keep)
							if("Heir") R.access = list(keep,baronquarter)
							if("Successor") R.access = list(keep,baronquarter)
							if("Jester") R.access = list(keep)
							if("Butler") R.access = list(keep)
							if("Sitzfrau") R.access = list(keep)
							if("Maid") R.access = list(keep)
							if("Servant") R.access = list(keep)
							if("Kraken") R.access = list(meistery,sanctuary,garrison,keep,hump,courtroom,soilery,lifeweb, baronquarter, marduk, innkeep)
							if("Triton") R.access = list(garrison,keep,courtroom)
							if("Sheriff") R.access = list(garrison,keep,courtroom)
							if("Charybdis") R.access = list(garrison,keep,courtroom)
							if("Squire") R.access = list(garrison,keep)
							if("Esculap") R.access = list(sanctuary,keep,esculap)
							if("Serpent") R.access = list(sanctuary)
							if("Blacksmith") R.access = list(smith)
							if("Blacksmith’s Assistant") R.access = list(smith)
							if("Pusher") R.access = list(brothel, amuser,innkeep)
							if("Amuser") R.access = list(amuser)
							if("Merchant") R.access = list(keep,courtroom)
							if("Homeless") R.access = list()
							if("Wright") R.access = list(keep,hump)
							if("Mortician") R.access = list(lifeweb)
							if("Misero") R.access = list(lifeweb)
							if("Docker") R.access = list(merchant)
							if("Soiler") R.access = list(soilery)
							if("Treasurer") R.access = list(keep,meistery,treasury)
							if("Madam") R.access = list(innkeep)
					to_chat(world, "<br>")
					to_chat(world, "<span class='ravenheartfortress'>Enoch's Gate Hold</span>")
					to_chat(world,"<span class='excomm'>¤[M.real_name] is now a [job]!¤</span>")
					sound_to(world, sound('sound/AI/bell_toll.ogg'))
					to_chat(world, "<br>")
					to_chat(world, "<span class='decree'>New [src.buckled_mob.job]'s decree!</span>")
					to_chat(world, "<br>")
				return TOPIC_HANDLED

			if("playsong")
				var/song = input("What song?", "Dragon Throne") in list("Unknown (1)", "Unknown (2)", "Unknown (3)")
				if(!song)
					return TOPIC_NOACTION
				if(song == "Unknown (1)")
					chosenSong = 'sound/music/csrio.ogg'
				else if(song == "Unknown (2)")
					chosenSong = 'sound/music/soufoda.ogg'
				else
					chosenSong = 'sound/music/rapdasarmas.ogg'
				for(var/obj/machinery/loud_speaker/L in loud_speakers)
					L.playsom()
				return TOPIC_HANDLED

			if("migburnlaw")
				to_chat(world, "<br>")
				to_chat(world, "<span class='ravenheartfortress'>Enoch's Gate Hold</span>")
				world << sound('sound/AI/bell_toll.ogg')
				if(!migban)
					to_chat(world, "<span class='excomm'>¤The entrance of new migrants into the village is now prohibited. The Charybdis and Sheriff are now allowed to deport them.¤</span>")
					migban = 1
				else
					to_chat(world, "<span class='excomm'>¤Migrants are allowed inside the village.¤</span>")
					migban = 0
				to_chat(world, "<br>")
				to_chat(world, "<span class='decree'>New [user.job]'s decree!</span>")
				to_chat(world, "<br>")
				return TOPIC_HANDLED

			if("openpit")
				for(var/obj/machinery/door/airlock/orbital/gates/magma/trap_door/keep/T as anything in global.keep_trap_doors)
					T.toggle()
				return TOPIC_HANDLED

			if("callformigrants")
				to_chat(world, "<br>")
				to_chat(world, "<span class='ravenheartfortress'>Enoch's Gate Hold</span>")
				to_chat(world,"<span class='excomm'>¤The Lord asks for migrants!¤</span>")
				world << sound('sound/AI/bell_toll.ogg')
				to_chat(world, "<br>")
				to_chat(world, "<span class='decree'>New [user.job]'s decree!</span>")
				to_chat(world, "<br>")
				return TOPIC_HANDLED

			if("craftmedal")
				var/mob/living/carbon/human/already_nominated

				var/input = sanitize(input(user, "Choose someone to recieve the medal.", "Enoch's Gate Decree", "") as text|null)
				if(!input)
					return TOPIC_NOACTION
				if(user.real_name == input)
					to_chat(user, "<span class='combat'>I feel stupid...</span>")
					return TOPIC_HANDLED
				if(length(global.medal_nominated))
					for(var/mob/living/carbon/human/HU in global.medal_nominated)
						if(HU.real_name == input)
							already_nominated = HU
							break

				to_chat(world, "<span class='ravenheartfortress'>Enoch's Gate Hold</span>")
				to_chat(world, "<span class='excomm'>New [user.job]'s decree!</span>")
				world << sound('sound/AI/bell_toll.ogg')
				if(already_nominated)
					to_chat(world, "<span class='decree'>[user.job] don't want any medal for [input]!</span>")
					to_chat(world, "<br>")
					global.medal_nominated.Remove(already_nominated)
					return TOPIC_HANDLED

				to_chat(world, "<span class='decree'>[input] has been rewarded! The smiths shall craft a medal for them!</span>")
				to_chat(world, "<br>")
				for(var/mob/living/carbon/human/HH in mob_list)
					if(HH.real_name == input)
						global.medal_nominated[HH] = user
				return TOPIC_HANDLED

			if("energylaw")
				if((treasuryworth.get_money()) > 199 && energyInvestimento == 0)
					to_chat(world, "<span class='ravenheartfortress'>Enoch's Gate Hold</span>")
					to_chat(world, "<span class='excomm'>New [src.buckled_mob.job]'s decree!</span>")
					world << sound('sound/AI/bell_toll.ogg')
					to_chat(world, "<span class='decree'>Our glorious [src.buckled_mob.job] has decided to spend money on energy!</span>")
					to_chat(world, "<br>")
					energyInvestimento = 1
				else if((treasuryworth.get_money()) > 199 && energyInvestimento == 1)
					to_chat(world, "<span class='ravenheartfortress'>Enoch's Gate Hold</span>")
					to_chat(world, "<span class='excomm'>New [src.buckled_mob.job]'s decree!</span>")
					world << sound('sound/AI/bell_toll.ogg')
					to_chat(world, "<span class='decree'>Our glorious [src.buckled_mob.job] has stopped spending money on energy!</span>")
					to_chat(world, "<br>")
					energyInvestimento = 0
				else
					to_chat(usr, "Not enough money on the treasury.")
				return TOPIC_HANDLED

/obj/structure/stool/bed/chair/ThroneBaroness
	name = "Throne"
	desc = "A magnificent throne."
	icon = 'icons/obj/throne_new.dmi'
	icon_state = "baroness_throne"
	anchored = 1

var/global/taxes = 13
var/roundendready = FALSE

/obj/structure/stool/bed/chair/ThroneMid/buckle_mob(mob/M as mob, mob/user as mob)
	if (!ticker)
		user << "You can't buckle anyone in before the game starts."
	if ( !ismob(M) || (get_dist(src, user) > 1) || (M.loc != src.loc) || user.restrained() || user.lying || user.stat || M.buckled || istype(user, /mob/living/silicon/pai) )
		return

	unbuckle()

	if (M == usr)
		M.visible_message("<span class='passivebold'>[M.name]</span> <span class='passive'>sits majestically on [src]!</span>")
	else
		M.visible_message("<span class='passivebold'>[M.name]</span> <span class='passive'>sits majestically on [src]!</span>")

	M.pixel_y = 5

	interact(M)

	M.buckled = src
	M.loc = src.loc
	M.dir = src.dir
	M.update_canmove()
	src.buckled_mob = M
	src.add_fingerprint(user)
	var/mob/living/carbon/human/H = usr
	var/list/allowedjobs = list("Baron","Hand","Count","Baroness","Heir","Successor")
	if(allowedjobs.Find(H.job) && H.head && istype(H.head, /obj/item/clothing/head/caphat))
		H.verbs += /mob/living/carbon/human/verb/BaronRiot
		H.verbs += /mob/living/carbon/human/verb/BaronAnnounce
		H.verbs += /mob/living/carbon/human/verb/BaronRiotReal
		H.verbs += /mob/living/carbon/human/verb/DrugBan
		H.verbs += /mob/living/carbon/human/verb/WeaponBan
		H.verbs += /mob/living/carbon/human/verb/Migrants
		H.verbs += /mob/living/carbon/human/verb/SetTaxes
		H.verbs += /mob/living/carbon/human/verb/ChurchExpand
		H.verbs += /mob/living/carbon/human/verb/OpenTraps
		H.verbs += /mob/living/carbon/human/verb/SetHand

	if(H.job == "Jester" && H.special == "jesterdecree")
		H.verbs += /mob/living/carbon/human/verb/BaronAnnounce
	M.updateStatPanel()

	if(H.job == "Kraken")
		H.verbs += /mob/living/carbon/human/verb/BaronRiotReal
	M.updateStatPanel()

/obj/structure/stool/bed/chair/ThroneMid/unbuckle(mob/M as mob, mob/user as mob)
	if(buckled_mob)
		if(buckled_mob.buckled == src)	//this is probably unneccesary, but it doesn't hurt
			buckled_mob.buckled = null
			buckled_mob.anchored = initial(buckled_mob.anchored)
			buckled_mob.update_canmove()
			buckled_mob = null
	var/mob/living/carbon/human/H = usr
	H.pixel_y = initial(H.pixel_y)
	src << output(list2params(list()), "outputwindow.browser:removeAntagTab")
	src << output(list2params(list()), "outputwindow.browser:initial")
	H.verbs -= /mob/living/carbon/human/verb/BaronRiot
	H.verbs -= /mob/living/carbon/human/verb/BaronAnnounce
	H.verbs -= /mob/living/carbon/human/verb/BaronRiotReal
	H.verbs -= /mob/living/carbon/human/verb/DrugBan
	H.verbs -= /mob/living/carbon/human/verb/WeaponBan
	H.verbs -= /mob/living/carbon/human/verb/Migrants
	H.verbs -= /mob/living/carbon/human/verb/SetTaxes
	H.verbs -= /mob/living/carbon/human/verb/ChurchExpand
	H.verbs -= /mob/living/carbon/human/verb/OpenTraps
	H.verbs -= /mob/living/carbon/human/verb/SetHand
	if(H.job == "Jester" && H.special == "jesterdecree")
		H.verbs -= /mob/living/carbon/human/verb/BaronAnnounce
	H.updateStatPanel()

	if(H.job == "Kraken")
		H.verbs -= /mob/living/carbon/human/verb/BaronRiotReal
	H.updateStatPanel()

/mob/living/carbon/human/New()
	. = ..()
	src.verbs -= /mob/living/carbon/human/verb/BaronRiot
	src.verbs -= /mob/living/carbon/human/verb/BaronAnnounce
	src.verbs -= /mob/living/carbon/human/verb/BaronRiotReal
	src.verbs -= /mob/living/carbon/human/verb/DrugBan
	src.verbs -= /mob/living/carbon/human/verb/WeaponBan
	src.verbs -= /mob/living/carbon/human/verb/Migrants
	src.verbs -= /mob/living/carbon/human/verb/SetTaxes
	src.verbs -= /mob/living/carbon/human/verb/ChurchExpand
	src.verbs -= /mob/living/carbon/human/verb/OpenTraps
	src.verbs -= /mob/living/carbon/human/verb/SetHand

/mob/living/carbon/human/verb/BaronAnnounce()
	set hidden = 0
	set category = "Baron"
	set name = "Decretodobarao"
	set desc="Decretar algo."
	var/input = sanitize(input(usr, "Type your decree.", "Enoch's Gate Decree", "") as message|null, list("\t"="#","ÿ"="&#255;"))
	if(!input)
		return
	if(global.is_http_protocol.Find(input))
		message_admins("[key_name(usr)] attempted to send a decree with a URL in their decree.")
		return
	to_chat(world, "<span class='ravenheartfortress'>Enoch's Gate Hold</span>")
	to_chat(world, "<span class='excomm'>New [src.job]'s decree!</span>")
	world << sound('sound/AI/bell_toll.ogg')
	to_chat(world, "<span class='decree'>[input]</span>")
	to_chat(world, "<br>")
	for(var/obj/machinery/information_terminal/T in vending_list)
		if(T.hacked) continue
		if(T.screenbroken) continue
		T.announces += input
	log_admin("[key_name(src)] has made a decree")
	message_admins("[key_name_admin(src)] has made a decree", 1)


/mob/living/carbon/human/verb/SetHand()
	set hidden = 0
	set category = "Baron"
	set name = "SetHands"
	set desc="Decretar algo."
	if(fortHand)
		return
	var/input = sanitize(input(usr, "Choose your hand, must be their full name.", "Enoch's Gate Decree", "") as message|null)
	if(!input)
		return
	for(var/mob/living/carbon/human/H in mob_list)
		if(input == H.real_name)
			fortHand = H
			H.job = "Hand"
	if(!fortHand)
		return
	to_chat(world, "<span class='ravenheartfortress'>Enoch's Gate Hold</span>")
	to_chat(world, "<span class='excomm'>New [src.job]'s decree!</span>")
	world << sound('sound/AI/bell_toll.ogg')
	to_chat(world, "<span class='decree'>[input] is now [src.real_name]'s Hand!</span>")
	to_chat(world, "<br>")

/mob/living/carbon/human/verb/OpenTraps()
	set hidden = 0
	set category = "Baron"
	set name = "Abrirtrapdoors"
	set desc="abre trap doors."

	for(var/obj/machinery/door/airlock/orbital/gates/magma/trap_door/keep/T as anything in global.keep_trap_doors)
		T.toggle()

/mob/living/carbon/human/verb/SetTaxes()
	set hidden = 0
	set category = "Baron"
	set name = "ColocarTaxas"
	set desc="Coloca taxas."
	var/input = sanitize_num(input(usr, "Choose between 0 and 100 percent.", "Enoch's Gate Decree", "") as num, 0, 100)
	to_chat(world, "<br>")
	to_chat(world, "<span class='ravenheartfortress'>Enoch's Gate Hold</span>")
	to_chat(world,"<span class='excomm'>¤The new taxes are <i>[input]%</i>!¤</span>")
	taxes = input
	world << sound('sound/AI/bell_toll.ogg')
	to_chat(world, "<br>")
	to_chat(world, "<span class='decree'>New [src.job]'s decree!</span>")
	to_chat(world, "<br>")

	log_admin("[key_name(src)] has made a decree")
	message_admins("[key_name_admin(src)] has made a decree", 1)

/mob/living/carbon/human/verb/BaronRiot()
	set hidden = 0
	set category = "Baron"
	set name = "Declararalerta"
	set desc="Abre a armory e declara alerta."
	if(riot == 0 && riotreal == 0)
		to_chat(world, "<br>")
		to_chat(world, "<span class='ravenheartfortress'>Enoch's Gate Hold</span>")
		to_chat(world, "<span class='excomm'>¤BATTLE ALARM! Everyone must head to the Armory and prepare for combat!¤</span>")
		world << sound('sound/AI/bell_toll.ogg')
		to_chat(world, "<br>")
		to_chat(world, "<span class='decree'>New [src.job]'s decree!</span>")
		to_chat(world, "<br>")
		world << sound('sound/music/mantrap.ogg', repeat = 1, wait = 0, volume = 50, channel = 6)
		riot = 1
		for(var/obj/machinery/door/poddoor/shutters/B in world)
			if(B.alert == "baronalert")
				B.open()
	else
		if(riot == 1 && riotreal == 0)
			to_chat(world, "<br>")
			to_chat(world, "<span class='ravenheartfortress'>Enoch's Gate Hold</span>")
			to_chat(world, "<span class='excomm'><b>¤The alert has been terminated.¤</b></span>")
			world << sound('sound/AI/bell_toll.ogg')
			to_chat(world, "<br>")
			to_chat(world, "<span class='decree'>New [src.job]'s decree!</span>")
			to_chat(world, "<br>")
			world << sound('sound/music/mantrap.ogg', repeat = 0, wait = 0, volume = 0, channel = 6)
			riot = 0
			for(var/obj/machinery/door/poddoor/shutters/B in world)
				if(B.alert == "baronalert")
					B.close()
		if(riotreal == 1)
			to_chat(usr, "<span class='combat'>[pick(fnord)] I need to turn off the Riot Alarm first!</span>")

		log_admin("[key_name(src)] has turned on the battle alarm")
		message_admins("[key_name_admin(src)] has turned on the battle alarm", 1)

/mob/living/carbon/human/verb/BaronRiotReal()
	set hidden = 0
	set category = "Baron"
	set name = "Riot Alarm"
	set desc="Declare a riot."
	if(riotreal == 0 && riot == 0)
		to_chat(world, "<br>")
		to_chat(world, "<span class='ravenheartfortress'>Enoch's Gate Hold</span>")
		to_chat(world, "<span class='excomm'>¤Riot Declared! Tritons must gear up in the small armory, those caught outside their residence shall be executed!¤</span>")
		world << sound('sound/AI/bell_toll.ogg')
		to_chat(world, "<br>")
		to_chat(world, "<span class='decree'>New [src.job]'s decree!</span>")
		to_chat(world, "<br>")
		world << sound('sound/RiotAlarm.ogg', repeat = 1, wait = 0, volume = 100, channel = 6)
		riotreal = 1
		for(var/obj/machinery/door/poddoor/shutters/B in world)
			if(B.alert == "baronriot")
				B.open()
	else
		if(riotreal == 1 && riot == 0)
			to_chat(world, "<br>")
			to_chat(world, "<span class='ravenheartfortress'>Enoch's Gate Hold</span>")
			to_chat(world, "<span class='excomm'><b>¤Riot state inactive. Fortress residents may now return to their duties.¤</b></span>")
			world << sound('sound/AI/bell_toll.ogg')
			to_chat(world, "<br>")
			to_chat(world, "<span class='decree'>New [src.job]'s decree!</span>")
			to_chat(world, "<br>")
			world << sound('sound/RiotAlarm.ogg', repeat = 0, wait = 0, volume = 0, channel = 6)
			riotreal = 0
			for(var/obj/machinery/door/poddoor/shutters/B in world)
				if(B.alert == "baronriot")
					B.close()
		if(riot == 1)
			to_chat(usr, "<span class='combat'>[pick(fnord)] I need to turn off the Battle Alarm first!</span>")

			log_admin("[key_name(src)] has declared riot")
			message_admins("[key_name_admin(src)] has declared riot", 1)
		if(riot == 1)
			to_chat(usr, "<span class='combat'>[pick(fnord)] I need to turn off the Battle Alarm first!</span>")

/mob/living/carbon/human/verb/DrugBan()
	set hidden = 0
	set category = "Baron"
	set name = "VendadeDrogas"
	set desc="Proibe ou permite venda de drogas."

	to_chat(world, "<br>")
	to_chat(world, "<span class='ravenheartfortress'>Enoch's Gate Hold</span>")
	if(!drugban)
		to_chat(world, "<span class='excomm'>¤The sale and exchange of drugs is now Banned in the fortress.¤</span>")
		drugban = 1
	else
		to_chat(world, "<span class='excomm'>¤The sale and exchange of drugs is now Allowed in the fortress.¤</span>")
		drugban = 0
	world << sound('sound/AI/bell_toll.ogg')
	to_chat(world, "<br>")
	to_chat(world, "<span class='decree'>New [src.job]'s decree!</span>")
	to_chat(world, "<br>")

/mob/living/carbon/human/verb/WeaponBan()
	set hidden = 0
	set category = "Baron"
	set name = "VendadeArmas"
	set desc="Proibe ou permite venda de armas."

	world << sound('sound/AI/bell_toll.ogg')
	to_chat(world, "<br>")
	to_chat(world, "<span class='ravenheartfortress'>Enoch's Gate Hold</span>")
	if(!gunban)
		to_chat(world, "<span class='excomm'>¤The sale and exchange of firearms is now Banned in the fortress.¤</span>")
		gunban = 1
	else
		to_chat(world, "<span class='excomm'>¤The sale and exchange of firearms is now Allowed in the fortress.¤</span>")
		gunban = 0
	to_chat(world, "<br>")
	to_chat(world, "<span class='decree'>New [src.job]'s decree!</span>")
	to_chat(world, "<br>")

/mob/living/carbon/human/verb/ChurchExpand()
	set hidden = 0
	set category = "Baron"
	set name = "Expandirpoderesdaigreja"
	set desc="Expande o poder da igreja."
	switch(alert("Are you SURE you want to expand church powers? This is irreversible.", "Expand Church Powers", "Yes", "No"))
		if("Yes")
			if(!churchexpanded)
				to_chat(world, "<br>")
				to_chat(world, "<span class='ravenheartfortress'>Enoch's Gate Hold</span>")
				to_chat(world, "<span class='excomm'>The [src.job] expanded church powers, praise the lord!</span>")
				world << sound('sound/AI/bell_toll.ogg')
				to_chat(world, "<br>")
				to_chat(world, "<span class='decree'>New [src.job]'s decree!</span>")
				to_chat(world, "<br>")
				churchexpanded = 1
				Inquisitor_Points += 10
			else
				return

/mob/living/carbon/human/verb/Migrants()
	set hidden = 0
	set category = "Baron"
	set name = "TrafegodeMigrantes"
	set desc="Proibe ou permite a entrada de migrantes."

	to_chat(world, "<br>")
	to_chat(world, "<span class='ravenheartfortress'>Enoch's Gate Hold</span>")
	world << sound('sound/AI/bell_toll.ogg')
	if(!migban)
		to_chat(world, "<span class='excomm'>¤The entrance of new migrants into the fortress is now prohibited. The Incarn is now allowed to throw them into the magma.¤</span>")
		migban = 1
	else
		to_chat(world, "<span class='excomm'>¤Migrants are allowed inside the fortress.¤</span>")
		migban = 0
	to_chat(world, "<br>")
	to_chat(world, "<span class='decree'>New [src.job]'s decree!</span>")
	to_chat(world, "<br>")

/obj/structure/stool/bed/chair/ThroneSides
	name = "Baron's Throne"
	desc = "A magnificent throne."
	icon = 'icons/obj/throne_new.dmi'
	icon_state = "enoch_throne2"
	anchored = 1
	flammable = 0

/obj/structure/stool/bed/chair/ThroneSides/right
	icon = 'icons/obj/throne_new.dmi'
	icon_state = "baseright"

/obj/structure/stool/bed/chair/ThroneSides/left
	icon = 'icons/obj/throne_new.dmi'
	icon_state = "baseleft"

/obj/structure/stool/bed/chair/ThroneSides/wingright
	icon = 'icons/obj/throne_new.dmi'
	icon_state = "wingright"
	plane = 21
	mouse_opacity = FALSE

/obj/structure/stool/bed/chair/ThroneSides/wingleft
	icon = 'icons/obj/throne_new.dmi'
	icon_state = "wingleft"
	plane = 21
	mouse_opacity = FALSE

/obj/structure/stool/bed/chair/ThroneSides/top
	icon = 'icons/obj/throne_new.dmi'
	icon_state = "enoch_throne_2"
	plane = 21
	mouse_opacity = FALSE

/obj/structure/stool/bed/chair/ThroneSides/buckle_mob()
	return 0

/obj/structure/stool/bed/chair/ThroneSides2
	name = "Throne"
	desc = "A magnificent throne."
	icon = 'icons/obj/throne.dmi'
	icon_state = "thronecenter2"
	anchored = 1

/obj/structure/stool/bed/chair/ThroneSides/buckle_mob()
	return 0
