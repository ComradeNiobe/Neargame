//Config stuff
#define SYNDICATE_ELITE_MOVETIME 600	//Time to station is milliseconds. 60 seconds, enough time for everyone to be on the shuttle before it leaves.
#define SYNDICATE_ELITE_STATION_AREATYPE "/area/shuttle/syndicate_elite/station" //Type of the spec ops shuttle area for station
#define SYNDICATE_ELITE_DOCK_AREATYPE "/area/shuttle/syndicate_elite/mothership"	//Type of the spec ops shuttle area for dock

var/syndicate_elite_shuttle_moving_to_station = 0
var/syndicate_elite_shuttle_moving_to_mothership = 0
var/syndicate_elite_shuttle_at_station = 0
var/syndicate_elite_shuttle_can_send = 1
var/syndicate_elite_shuttle_time = 0
var/syndicate_elite_shuttle_timeleft = 0

/obj/machinery/computer/syndicate_elite_shuttle
	name = "Elite Syndicate Squad Shuttle Console"
	icon = 'icons/obj/computer.dmi'
	icon_state = "syndishuttle"
	req_access = list(access_cent_specops)
	var/temp = null
	var/hacked = 0
	var/allowedtocall = 0

/proc/syndicate_elite_process()
	var/area/syndicate_mothership/control/syndicate_ship = locate()//To find announcer. This area should exist for this proc to work.
	var/mob/living/silicon/decoy/announcer = locate() in syndicate_ship//We need a fake AI to announce some stuff below. Otherwise it will be wonky.

	var/message_tracker[] = list(0,1,2,3,5,10,30,45)//Create a a list with potential time values.
	var/message = "THE SYNDICATE ELITE SHUTTLE IS PREPARING FOR LAUNCH"//Initial message shown.
	if(announcer)
		announcer.say(message)
	//	message = "ARMORED SQUAD TAKE YOUR POSITION ON GRAVITY LAUNCH PAD"
	//	announcer.say(message)

	while(syndicate_elite_shuttle_time - world.timeofday > 0)
		var/ticksleft = syndicate_elite_shuttle_time - world.timeofday

		if(ticksleft > 1e5)
			syndicate_elite_shuttle_time = world.timeofday	// midnight rollover
		syndicate_elite_shuttle_timeleft = (ticksleft / 10)

		//All this does is announce the time before launch.
		if(announcer)
			var/rounded_time_left = round(syndicate_elite_shuttle_timeleft)//Round time so that it will report only once, not in fractions.
			if(rounded_time_left in message_tracker)//If that time is in the list for message announce.
				message = "ALERT: [rounded_time_left] SECOND[(rounded_time_left!=1)?"S":""] REMAIN"
				if(rounded_time_left==0)
					message = "ALERT: TAKEOFF"
				announcer.say(message)
				message_tracker -= rounded_time_left//Remove the number from the list so it won't be called again next cycle.
				//Should call all the numbers but lag could mean some issues. Oh well. Not much I can do about that.

		sleep(5)

	syndicate_elite_shuttle_moving_to_station = 0
	syndicate_elite_shuttle_moving_to_mothership = 0

	syndicate_elite_shuttle_at_station = 1
	if (syndicate_elite_shuttle_moving_to_station || syndicate_elite_shuttle_moving_to_mothership) return

	if (!syndicate_elite_can_move())
		usr << "\red The Syndicate Elite shuttle is unable to leave."
		return

/proc/syndicate_elite_can_move()
	if(syndicate_elite_shuttle_moving_to_station || syndicate_elite_shuttle_moving_to_mothership) return 0
	else return 1

/obj/machinery/computer/syndicate_elite_shuttle/attackby(I as obj, user as mob)
	return attack_hand(user)

/obj/machinery/computer/syndicate_elite_shuttle/attack_ai(var/mob/user as mob)
	return attack_hand(user)

/obj/machinery/computer/syndicate_elite_shuttle/attack_paw(var/mob/user as mob)
	return attack_hand(user)

/obj/machinery/computer/syndicate_elite_shuttle/attackby(I as obj, user as mob)
	if(istype(I,/obj/item/card/emag))
		user << "\blue The electronic systems in this console are far too advanced for your primitive hacking peripherals."
	else
		return attack_hand(user)

/obj/machinery/computer/syndicate_elite_shuttle/attack_hand(var/mob/user as mob)
	if(!allowed(user))
		user << "\red Access Denied."
		return

//	if (sent_syndicate_strike_team == 0)
//		usr << "\red The strike team has not yet deployed."
//		return

	if(..())
		return

	user.set_machine(src)
	var/dat
	if (temp)
		dat = temp
	else
		dat  = {"<BR><B>Special Operations Shuttle</B><HR>
		\nLocation: [syndicate_elite_shuttle_moving_to_station || syndicate_elite_shuttle_moving_to_mothership ? "Departing for [vessel_name] in ([syndicate_elite_shuttle_timeleft] seconds.)":syndicate_elite_shuttle_at_station ? "Station":"Dock"]<BR>
		[syndicate_elite_shuttle_moving_to_station || syndicate_elite_shuttle_moving_to_mothership ? "\n*The Syndicate Elite shuttle is already leaving.*<BR>\n<BR>":syndicate_elite_shuttle_at_station ? "\n<A href='byond://?src=\ref[src];sendtodock=1'>Shuttle Offline</A><BR>\n<BR>":"\n<A href='byond://?src=\ref[src];sendtostation=1'>Depart to [vessel_name]</A><BR>\n<BR>"]
		\n<A href='byond://?src=\ref[user];mach_close=computer'>Close</A>"}

	user << browse(dat, "window=computer;size=575x450")
	onclose(user, "computer")
	return

/obj/machinery/computer/syndicate_elite_shuttle/Topic(href, href_list)
	if(..())
		return

	if ((usr.contents.Find(src) || (in_range(src, usr) && istype(loc, /turf))) || (istype(usr, /mob/living/silicon)))
		usr.set_machine(src)

	if (href_list["sendtodock"])
		if(!syndicate_elite_shuttle_at_station|| syndicate_elite_shuttle_moving_to_station || syndicate_elite_shuttle_moving_to_mothership) return

		usr << "\blue The Syndicate will not allow the Elite Squad shuttle to return."
		return

	else if (href_list["sendtostation"])
		if(syndicate_elite_shuttle_at_station || syndicate_elite_shuttle_moving_to_station || syndicate_elite_shuttle_moving_to_mothership) return

		if (!specops_can_move())
			usr << "\red The Syndicate Elite shuttle is unable to leave."
			return

		usr << "\blue The Syndicate Elite shuttle will arrive on [vessel_name] in [(SYNDICATE_ELITE_MOVETIME/10)] seconds."

		temp  = "Shuttle departing.<BR><BR><A href='byond://?src=\ref[src];mainmenu=1'>OK</A>"
		updateUsrDialog()

		var/area/syndicate_mothership/elite_squad/elite_squad = locate()
		if(elite_squad)
			elite_squad.readyalert()//Trigger alarm for the spec ops area.
		syndicate_elite_shuttle_moving_to_station = 1

		syndicate_elite_shuttle_time = world.timeofday + SYNDICATE_ELITE_MOVETIME
		spawn(0)
			syndicate_elite_process()


	else if (href_list["mainmenu"])
		temp = null

	add_fingerprint(usr)
	updateUsrDialog()
	return