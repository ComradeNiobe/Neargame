//This file was auto-corrected by findeclaration.exe on 25.5.2012 20:42:31

// The communications computer
/obj/machinery/computer/communications
	name = "Communications Console"
	desc = "This can be used for various important functions. Still under developement."
	icon_state = "comm"
	req_access = list(access_heads)
	circuit = "/obj/item/circuitboard/communications"
	var/prints_intercept = 1
	var/authenticated = 0
	var/list/messagetitle = list()
	var/list/messagetext = list()
	var/currmsg = 0
	var/aicurrmsg = 0
	var/state = STATE_DEFAULT
	var/aistate = STATE_DEFAULT
	var/message_cooldown = 0
	var/centcomm_message_cooldown = 0
	var/tmp_alertlevel = 0
	var/const/STATE_DEFAULT = 1
	var/const/STATE_CALLSHUTTLE = 2
	var/const/STATE_CANCELSHUTTLE = 3
	var/const/STATE_MESSAGELIST = 4
	var/const/STATE_VIEWMESSAGE = 5
	var/const/STATE_DELMESSAGE = 6
	var/const/STATE_STATUSDISPLAY = 7
	var/const/STATE_ALERT_LEVEL = 8
	var/const/STATE_CONFIRM_LEVEL = 9
	var/const/STATE_CREWTRANSFER = 10

	var/obj/item/device/radio/intercom/a = new /obj/item/device/radio/intercom(null)
	var/status_display_freq = "1435"
	var/stat_msg1
	var/stat_msg2



/obj/machinery/computer/communications/process()
	if(..())
		if(state != STATE_STATUSDISPLAY)
			src.updateDialog()


/obj/machinery/computer/communications/Topic(href, href_list)
	if(..())
		return
	if (!(src.z in vessel_z))
		usr << "\red <b>Unable to establish a connection</b>: \black You're too far away from the [vessel_type]!"
		return
	usr.set_machine(src)

	if(!href_list["operation"])
		return
	switch(href_list["operation"])
		// main interface
		if("main")
			src.state = STATE_DEFAULT
		if("login")
			var/mob/M = usr
			var/obj/item/card/id/I = M.get_active_hand()
			if (istype(I, /obj/item/device/pda))
				var/obj/item/device/pda/pda = I
				I = pda.id
			if (I && istype(I))
				if(src.check_access(I))
					authenticated = 1
				if(20 in I.access)
					authenticated = 2
		if("logout")
			authenticated = 0

		if("swipeidseclevel")
			var/mob/M = usr
			var/obj/item/card/id/I = M.get_active_hand()
			if (istype(I, /obj/item/device/pda))
				var/obj/item/device/pda/pda = I
				I = pda.id
			if (I && istype(I))
				if(access_captain in I.access || access_heads in I.access) //Let heads change the alert level.
					if(tmp_alertlevel == SEC_LEVEL_RED && !(access_captain in I.access))
						usr << "\red You are not authorized to do this. You need to have captain's access on your ID to declare red alert."
						return
					var/old_level = security_level
					if(!tmp_alertlevel) tmp_alertlevel = SEC_LEVEL_GREEN
					if(tmp_alertlevel < SEC_LEVEL_GREEN) tmp_alertlevel = SEC_LEVEL_GREEN
					if(tmp_alertlevel > SEC_LEVEL_RED) tmp_alertlevel = SEC_LEVEL_RED //Cannot engage delta with this
					set_security_level(tmp_alertlevel)
					if(security_level != old_level)
						//Only notify the admins if an actual change happened
						log_game("[key_name(usr)] has changed the security level to [get_security_level()].")
						message_admins("[key_name_admin(usr)] has changed the security level to [get_security_level()].")
					tmp_alertlevel = 0
				else
					usr << "\red You are not authorized to do this."
					tmp_alertlevel = 0
				state = STATE_DEFAULT
			else
				usr << "\red You need to swipe your ID."

		if("announce")
			if(src.authenticated==2)
				if(message_cooldown)	return
				var/input = stripped_input(usr, "Please choose a message to announce to the [vessel_type]'s crew.", "What?")
				if(!input || !(usr in view(1,src)))
					return
				captain_announce(input)//This should really tell who is, IE HoP, CE, HoS, RD, Captain
				log_say("[key_name(usr)] has made a captain announcement: [input]")
				message_admins("[key_name_admin(usr)] has made a captain announcement.", 1)
				message_cooldown = 1
				spawn(600)//One minute cooldown
					message_cooldown = 0

		if("callshuttle")
			src.state = STATE_DEFAULT
			if(src.authenticated)
				src.state = STATE_CALLSHUTTLE
		if("callshuttle2")
			if(src.authenticated)
				call_shuttle_proc(usr)
				if(emergency_shuttle.online)
					post_status("shuttle")
			src.state = STATE_DEFAULT
		if("cancelshuttle")
			src.state = STATE_DEFAULT
			if(src.authenticated)
				src.state = STATE_CANCELSHUTTLE
		if("cancelshuttle2")
			if(src.authenticated)
				cancel_call_proc(usr)
			src.state = STATE_DEFAULT
		if("messagelist")
			src.currmsg = 0
			src.state = STATE_MESSAGELIST
		if("viewmessage")
			src.state = STATE_VIEWMESSAGE
			if (!src.currmsg)
				if(href_list["message-num"])
					src.currmsg = text2num(href_list["message-num"])
				else
					src.state = STATE_MESSAGELIST
		if("delmessage")
			src.state = (src.currmsg) ? STATE_DELMESSAGE : STATE_MESSAGELIST
		if("delmessage2")
			if(src.authenticated)
				if(src.currmsg)
					var/title = src.messagetitle[src.currmsg]
					var/text  = src.messagetext[src.currmsg]
					src.messagetitle.Remove(title)
					src.messagetext.Remove(text)
					if(src.currmsg == src.aicurrmsg)
						src.aicurrmsg = 0
					src.currmsg = 0
				src.state = STATE_MESSAGELIST
			else
				src.state = STATE_VIEWMESSAGE
		if("status")
			src.state = STATE_STATUSDISPLAY

		// Status display stuff
		if("setstat")
			switch(href_list["statdisp"])
				if("message")
					post_status("message", stat_msg1, stat_msg2)
				if("alert")
					post_status("alert", href_list["alert"])
				else
					post_status(href_list["statdisp"])

		if("setmsg1")
			stat_msg1 = input("Line 1", "Enter Message Text", stat_msg1) as text|null
			src.updateDialog()
		if("setmsg2")
			stat_msg2 = input("Line 2", "Enter Message Text", stat_msg2) as text|null
			src.updateDialog()

		// OMG CENTCOMM LETTERHEAD
		if("MessageCentcomm")
			if(src.authenticated==2)
				if(centcomm_message_cooldown)
					usr << "\red Arrays recycling.  Please stand by."
					return
				var/input = stripped_input(usr, "Please choose a message to transmit to Centcomm via quantum entanglement.  Please be aware that this process is very expensive, and abuse will lead to... termination.  Transmission does not guarantee a response. There is a 30 second delay before you may send another message, be clear, full and concise.", "To abort, send an empty message.", "")
				if(!input || !(usr in view(1,src)))
					return
				Centcomm_announce(input, usr)
				usr << "\blue Message transmitted."
				log_say("[key_name(usr)] has made an IA Centcomm announcement: [input]")
				centcomm_message_cooldown = 1
				spawn(300)//10 minute cooldown
					centcomm_message_cooldown = 0


		// OMG SYNDICATE ...LETTERHEAD
		if("MessageSyndicate")
			if((src.authenticated==2) && (src.emagged))
				if(centcomm_message_cooldown)
					usr << "\red Arrays recycling.  Please stand by."
					return
				var/input = stripped_input(usr, "Please choose a message to transmit to \[ABNORMAL ROUTING CORDINATES\] via quantum entanglement.  Please be aware that this process is very expensive, and abuse will lead to... termination. Transmission does not guarantee a response. There is a 30 second delay before you may send another message, be clear, full and concise.", "To abort, send an empty message.", "")
				if(!input || !(usr in view(1,src)))
					return
				Syndicate_announce(input, usr)
				usr << "\blue Message transmitted."
				log_say("[key_name(usr)] has made a Syndicate announcement: [input]")
				centcomm_message_cooldown = 1
				spawn(300)//10 minute cooldown
					centcomm_message_cooldown = 0

		if("RestoreBackup")
			usr << "Backup routing data restored!"
			src.emagged = 0
			src.updateDialog()



		// AI interface
		if("ai-main")
			src.aicurrmsg = 0
			src.aistate = STATE_DEFAULT
		if("ai-callshuttle")
			src.aistate = STATE_CALLSHUTTLE
		if("ai-callshuttle2")
			call_shuttle_proc(usr)
			src.aistate = STATE_DEFAULT
		if("ai-messagelist")
			src.aicurrmsg = 0
			src.aistate = STATE_MESSAGELIST
		if("ai-viewmessage")
			src.aistate = STATE_VIEWMESSAGE
			if (!src.aicurrmsg)
				if(href_list["message-num"])
					src.aicurrmsg = text2num(href_list["message-num"])
				else
					src.aistate = STATE_MESSAGELIST
		if("ai-delmessage")
			src.aistate = (src.aicurrmsg) ? STATE_DELMESSAGE : STATE_MESSAGELIST
		if("ai-delmessage2")
			if(src.aicurrmsg)
				var/title = src.messagetitle[src.aicurrmsg]
				var/text  = src.messagetext[src.aicurrmsg]
				src.messagetitle.Remove(title)
				src.messagetext.Remove(text)
				if(src.currmsg == src.aicurrmsg)
					src.currmsg = 0
				src.aicurrmsg = 0
			src.aistate = STATE_MESSAGELIST
		if("ai-status")
			src.aistate = STATE_STATUSDISPLAY

		if("securitylevel")
			src.tmp_alertlevel = text2num( href_list["newalertlevel"] )
			if(!tmp_alertlevel) tmp_alertlevel = 0
			state = STATE_CONFIRM_LEVEL

		if("changeseclevel")
			state = STATE_ALERT_LEVEL



	src.updateUsrDialog()

/obj/machinery/computer/communications/attackby(var/obj/I as obj, var/mob/user as mob)
	if(istype(I,/obj/item/card/emag/))
		src.emagged = 1
		user << "You scramble the communication routing circuits!"
	..()

/obj/machinery/computer/communications/attack_ai(var/mob/user as mob)
	return src.attack_hand(user)


/obj/machinery/computer/communications/attack_paw(var/mob/user as mob)
	return src.attack_hand(user)


/obj/machinery/computer/communications/attack_hand(var/mob/user as mob)
	if(..())
		return
	if(level_check()==0)	return

	user.set_machine(src)
	var/dat = "<head><title>Communications Console</title></head><body>"
	if (emergency_shuttle.online && emergency_shuttle.location==0)
		var/timeleft = emergency_shuttle.timeleft()
		if(evac_type == "pods")
			dat += "<B>Escape Pods</B>\n<BR>\nETA: [timeleft / 60 % 60]:[add_zero(num2text(timeleft % 60), 2)]<BR>"
		else
			dat += "<B>Escape Shuttle</B>\n<BR>\nETA: [timeleft / 60 % 60]:[add_zero(num2text(timeleft % 60), 2)]<BR>"

	if (istype(user, /mob/living/silicon))
		var/dat2 = src.interact_ai(user) // give the AI a different interact proc to limit its access
		if(dat2)
			dat +=  dat2
			user << browse(dat, "window=communications;size=400x500")
			onclose(user, "communications")
		return

	switch(src.state)
		if(STATE_DEFAULT)
			if (src.authenticated)
				dat += "<BR>\[ <A HREF='byond://?src=\ref[src];operation=logout'>Log Out</A> \]"
				if (src.authenticated==2)
					dat += "<BR>\[ <A HREF='byond://?src=\ref[src];operation=announce'>Make An Announcement</A> \]"
					if(src.emagged == 0)
						dat += "<BR>\[ <A HREF='byond://?src=\ref[src];operation=MessageCentcomm'>Send an emergency message to Centcomm</A> \]"
					else
						dat += "<BR>\[ <A HREF='byond://?src=\ref[src];operation=MessageSyndicate'>Send an emergency message to \[UNKNOWN\]</A> \]"
						dat += "<BR>\[ <A HREF='byond://?src=\ref[src];operation=RestoreBackup'>Restore Backup Routing Data</A> \]"

				dat += "<BR>\[ <A HREF='byond://?src=\ref[src];operation=changeseclevel'>Change alert level</A> \]"
				if(emergency_shuttle.location==0)
					if (emergency_shuttle.online)
						dat += "<BR>\[ <A HREF='byond://?src=\ref[src];operation=cancelshuttle'>Cancel Evacuation Sequence</A> \]"
					else
						dat += "<BR>\[ <A HREF='byond://?src=\ref[src];operation=callshuttle'>Launch Evacuation Sequence</A> \]"

				dat += "<BR>\[ <A HREF='byond://?src=\ref[src];operation=status'>Set Status Display</A> \]"
			else
				dat += "<BR>\[ <A HREF='byond://?src=\ref[src];operation=login'>Log In</A> \]"
			dat += "<BR>\[ <A HREF='byond://?src=\ref[src];operation=messagelist'>Message List</A> \]"
		if(STATE_CALLSHUTTLE)
			dat += "Are you sure you want to launch the pods? \[ <A HREF='byond://?src=\ref[src];operation=callshuttle2'>OK</A> | <A HREF='byond://?src=\ref[src];operation=main'>Cancel</A> \]"
		if(STATE_CANCELSHUTTLE)
			dat += "Are you sure you want to abort the pods launch? \[ <A HREF='byond://?src=\ref[src];operation=cancelshuttle2'>OK</A> | <A HREF='byond://?src=\ref[src];operation=main'>Cancel</A> \]"
		if(STATE_MESSAGELIST)
			dat += "Messages:"
			for(var/i = 1; i<=src.messagetitle.len; i++)
				dat += "<BR><A HREF='byond://?src=\ref[src];operation=viewmessage;message-num=[i]'>[src.messagetitle[i]]</A>"
		if(STATE_VIEWMESSAGE)
			if (src.currmsg)
				dat += "<B>[src.messagetitle[src.currmsg]]</B><BR><BR>[src.messagetext[src.currmsg]]"
				if (src.authenticated)
					dat += "<BR><BR>\[ <A HREF='byond://?src=\ref[src];operation=delmessage'>Delete \]"
			else
				src.state = STATE_MESSAGELIST
				src.attack_hand(user)
				return
		if(STATE_DELMESSAGE)
			if (src.currmsg)
				dat += "Are you sure you want to delete this message? \[ <A HREF='byond://?src=\ref[src];operation=delmessage2'>OK</A> | <A HREF='byond://?src=\ref[src];operation=viewmessage'>Cancel</A> \]"
			else
				src.state = STATE_MESSAGELIST
				src.attack_hand(user)
				return
		if(STATE_STATUSDISPLAY)
			dat += "Set Status Displays<BR>"
			dat += "\[ <A HREF='byond://?src=\ref[src];operation=setstat;statdisp=blank'>Clear</A> \]<BR>"
			dat += "\[ <A HREF='byond://?src=\ref[src];operation=setstat;statdisp=shuttle'>Shuttle ETA</A> \]<BR>"
			dat += "\[ <A HREF='byond://?src=\ref[src];operation=setstat;statdisp=message'>Message</A> \]"
			dat += "<ul><li> Line 1: <A HREF='byond://?src=\ref[src];operation=setmsg1'>[ stat_msg1 ? stat_msg1 : "(none)"]</A>"
			dat += "<li> Line 2: <A HREF='byond://?src=\ref[src];operation=setmsg2'>[ stat_msg2 ? stat_msg2 : "(none)"]</A></ul><br>"
			dat += "\[ Alert: <A HREF='byond://?src=\ref[src];operation=setstat;statdisp=alert;alert=default'>None</A> |"
			dat += " <A HREF='byond://?src=\ref[src];operation=setstat;statdisp=alert;alert=redalert'>Red Alert</A> |"
			dat += " <A HREF='byond://?src=\ref[src];operation=setstat;statdisp=alert;alert=lockdown'>Lockdown</A> |"
			dat += " <A HREF='byond://?src=\ref[src];operation=setstat;statdisp=alert;alert=biohazard'>Biohazard</A> \]<BR><HR>"
		if(STATE_ALERT_LEVEL)
			dat += "Current alert level: [get_security_level()]<BR>"
			if(security_level == SEC_LEVEL_DELTA)
				dat += "<font color='red'><b>The self-destruct mechanism is active. Find a way to deactivate the mechanism to lower the alert level or evacuate.</b></font>"
			else
				dat += "<A HREF='byond://?src=\ref[src];operation=securitylevel;newalertlevel=[SEC_LEVEL_BLUE]'>Blue</A><BR>"
				dat += "<A HREF='byond://?src=\ref[src];operation=securitylevel;newalertlevel=[SEC_LEVEL_GREEN]'>Green</A><BR>"
				dat += "<A HREF='byond://?src=\ref[src];operation=securitylevel;newalertlevel=[SEC_LEVEL_RED]'>Red</A>"
		if(STATE_CONFIRM_LEVEL)
			dat += "Current alert level: [get_security_level()]<BR>"
			dat += "Confirm the change to: [num2seclevel(tmp_alertlevel)]<BR>"
			dat += "<A HREF='byond://?src=\ref[src];operation=swipeidseclevel'>Swipe ID</A> to confirm change.<BR>"

	dat += "<BR>\[ [(src.state != STATE_DEFAULT) ? "<A HREF='byond://?src=\ref[src];operation=main'>Main Menu</A> | " : ""]<A HREF='byond://?src=\ref[user];mach_close=communications'>Close</A> \]"
	user << browse(dat, "window=communications;size=400x500")
	onclose(user, "communications")




/obj/machinery/computer/communications/proc/interact_ai(var/mob/living/silicon/ai/user as mob)
	var/dat = ""
	switch(src.aistate)
		if(STATE_DEFAULT)
			if(emergency_shuttle.location==0 && !emergency_shuttle.online)
				dat += "<BR>\[ <A HREF='byond://?src=\ref[src];operation=ai-callshuttle'>Launch Escape </A> \]"
			dat += "<BR>\[ <A HREF='byond://?src=\ref[src];operation=ai-messagelist'>Message List</A> \]"
			dat += "<BR>\[ <A HREF='byond://?src=\ref[src];operation=ai-status'>Set Status Display</A> \]"
		if(STATE_CALLSHUTTLE)
			dat += "Are you sure you want to launch the Escape Pods? \[ <A HREF='byond://?src=\ref[src];operation=ai-callshuttle2'>OK</A> | <A HREF='byond://?src=\ref[src];operation=ai-main'>Cancel</A> \]"
		if(STATE_MESSAGELIST)
			dat += "Messages:"
			for(var/i = 1; i<=src.messagetitle.len; i++)
				dat += "<BR><A HREF='byond://?src=\ref[src];operation=ai-viewmessage;message-num=[i]'>[src.messagetitle[i]]</A>"
		if(STATE_VIEWMESSAGE)
			if (src.aicurrmsg)
				dat += "<B>[src.messagetitle[src.aicurrmsg]]</B><BR><BR>[src.messagetext[src.aicurrmsg]]"
				dat += "<BR><BR>\[ <A HREF='byond://?src=\ref[src];operation=ai-delmessage'>Delete</A> \]"
			else
				src.aistate = STATE_MESSAGELIST
				src.attack_hand(user)
				return null
		if(STATE_DELMESSAGE)
			if(src.aicurrmsg)
				dat += "Are you sure you want to delete this message? \[ <A HREF='byond://?src=\ref[src];operation=ai-delmessage2'>OK</A> | <A HREF='byond://?src=\ref[src];operation=ai-viewmessage'>Cancel</A> \]"
			else
				src.aistate = STATE_MESSAGELIST
				src.attack_hand(user)
				return

		if(STATE_STATUSDISPLAY)
			dat += "Set Status Displays<BR>"
			dat += "\[ <A HREF='byond://?src=\ref[src];operation=setstat;statdisp=blank'>Clear</A> \]<BR>"
			dat += "\[ <A HREF='byond://?src=\ref[src];operation=setstat;statdisp=shuttle'>Pods ETA</A> \]<BR>"
			dat += "\[ <A HREF='byond://?src=\ref[src];operation=setstat;statdisp=message'>Message</A> \]"
			dat += "<ul><li> Line 1: <A HREF='byond://?src=\ref[src];operation=setmsg1'>[ stat_msg1 ? stat_msg1 : "(none)"]</A>"
			dat += "<li> Line 2: <A HREF='byond://?src=\ref[src];operation=setmsg2'>[ stat_msg2 ? stat_msg2 : "(none)"]</A></ul><br>"
			dat += "\[ Alert: <A HREF='byond://?src=\ref[src];operation=setstat;statdisp=alert;alert=default'>None</A> |"
			dat += " <A HREF='byond://?src=\ref[src];operation=setstat;statdisp=alert;alert=redalert'>Red Alert</A> |"
			dat += " <A HREF='byond://?src=\ref[src];operation=setstat;statdisp=alert;alert=lockdown'>Lockdown</A> |"
			dat += " <A HREF='byond://?src=\ref[src];operation=setstat;statdisp=alert;alert=biohazard'>Biohazard</A> \]<BR><HR>"


	dat += "<BR>\[ [(src.aistate != STATE_DEFAULT) ? "<A HREF='byond://?src=\ref[src];operation=ai-main'>Main Menu</A> | " : ""]<A HREF='byond://?src=\ref[user];mach_close=communications'>Close</A> \]"
	return dat

/proc/enable_prison_shuttle(var/mob/user)
	for(var/obj/machinery/computer/prison_shuttle/PS in world)
		PS.allowedtocall = !(PS.allowedtocall)

/proc/call_shuttle_proc(var/mob/user)
	var/obj/item/device/radio/headset/bracelet/a = new /obj/item/device/radio/headset/bracelet(null)
	if ((!( ticker ) || emergency_shuttle.location))
		return

	if(sent_strike_team == 1)
		user << "Centcom will not allow the pods to be launched. Consider all contracts terminated."
		return

	if(world.time < 6000) // Ten minute grace period to let the game get going without lolmetagaming. -- TLE
		user << "The escape pods are refueling. Please wait another [round((6000-world.time)/600)] minutes before trying again."
		return

	if(emergency_shuttle.direction == -1)
		user << "The escape pods may not be launched in such a short time after canceling."
		return

	if(emergency_shuttle.online)
		user << "The escape pods launch has already been initiated."
		return

	emergency_shuttle.incall()
	log_game("[key_name(user)] has launched the pods.")
	message_admins("[key_name_admin(user)] has launched the pods.", 1)
	if(evac_type == "pods")
		a.autosay("Alert: The Ulysses is being launched. They will launch in [round(emergency_shuttle.timeleft()/60)] minutes.", "Escape Computer")
	else
		a.autosay("Alert: The emergency shuttle has been called. It will arrive in [round(emergency_shuttle.timeleft()/60)] minutes.", "Escape Computer")
	world << sound('sound/AI/shuttlecalled.ogg')

	return

/proc/init_shift_change(var/mob/user, var/force = 0)
	if ((!( ticker ) || emergency_shuttle.location))
		return

	if(emergency_shuttle.direction == -1)
		user << "The pods may not be called in such a short time after canceling."
		return

	if(emergency_shuttle.online)
		user << "The escape pods launch has already been initiated"
		return

	// if force is 0, some things may stop the shuttle call
	if(!force)
		if(emergency_shuttle.deny_shuttle)
			user << "Centcom permits the escape pods launch. Please try again later."
			return

		if(sent_strike_team == 1)
			user << "Centcom permits the escape pods launch. Consider all contracts terminated."
			return

		if(world.time < 54000) // 30 minute grace period to let the game get going
			user << "The pods may not be called at the beginning of the shift. Please wait another [round((54000-world.time)/600)] minutes before trying again."//may need to change "/600"
			return

		if(ticker.mode.name == "revolution" || ticker.mode.name == "AI malfunction" || ticker.mode.name == "sandbox")
			//New version pretends to call the shuttle but cause the shuttle to return after a random duration.
			emergency_shuttle.fake_recall = rand(300,500)

	emergency_shuttle.shuttlealert(1)
	emergency_shuttle.incall()
	log_game("[key_name(user)] has launched the pods.")
	message_admins("[key_name_admin(user)] has launched the pods.", 1)
	captain_announce("A crew transfer has been initiated. The escape pods will be launched in [round(emergency_shuttle.timeleft()/60)] minutes.")

	return

/proc/cancel_call_proc(var/mob/user)
	if ((!( ticker ) || emergency_shuttle.location || emergency_shuttle.direction == 0 || emergency_shuttle.timeleft() < 300))
		return

	if(emergency_shuttle.direction != -1 && emergency_shuttle.online) //check that shuttle isn't already heading to centcomm
		emergency_shuttle.recall()
		log_game("[key_name(user)] has canceled the pods launch.")
		message_admins("[key_name_admin(user)] has canceled the pods launch.", 1)
	return

/obj/machinery/computer/communications/proc/post_status(var/command, var/data1, var/data2)

	var/datum/radio_frequency/frequency = radio_controller.return_frequency(1435)

	if(!frequency) return

	var/datum/signal/status_signal = new
	status_signal.source = src
	status_signal.transmission_method = 1
	status_signal.data["command"] = command

	switch(command)
		if("message")
			status_signal.data["msg1"] = data1
			status_signal.data["msg2"] = data2
			log_admin("STATUS: [src.fingerprintslast] set status screen message with [src]: [data1] [data2]")
			//message_admins("STATUS: [user] set status screen with [PDA]. Message: [data1] [data2]")
		if("alert")
			status_signal.data["picture_state"] = data1

	frequency.post_signal(src, status_signal)


/obj/machinery/computer/communications/Destroy()

	for(var/obj/machinery/computer/communications/commconsole in world)
		if(istype(commconsole.loc,/turf) && commconsole != src)
			return ..()

	for(var/obj/item/circuitboard/communications/commboard in world)
		if(istype(commboard.loc,/turf) || istype(commboard.loc,/obj/item/storage))
			return ..()

	for(var/mob/living/silicon/ai/shuttlecaller in player_list)
		if(!shuttlecaller.stat && shuttlecaller.client && istype(shuttlecaller.loc,/turf))
			return ..()

	if(ticker.mode.name == "revolution" || ticker.mode.name == "AI malfunction" || sent_strike_team)
		return ..()

	emergency_shuttle.incall(2)
	log_game("All the AIs, comm consoles and boards are destroyed. Pods launch started.")
	message_admins("All the AIs, comm consoles and boards are destroyed. Pods launch started.", 1)
	if(evac_type == "pods")
		a.autosay("Alert: The escape pods are being launched. They will launch in [round(emergency_shuttle.timeleft()/60)] minutes.", "Escape Computer")
	else
		a.autosay("Alert: The emergency shuttle has been called. It will arrive in [round(emergency_shuttle.timeleft()/60)] minutes.", "Escape Computer")
	world << sound('sound/AI/shuttlecalled.ogg')

	..()

/obj/item/circuitboard/communications/Destroy()
	var/obj/item/device/radio/intercom/a = new /obj/item/device/radio/intercom(null)

	for(var/obj/machinery/computer/communications/commconsole in world)
		if(istype(commconsole.loc,/turf))
			return ..()

	for(var/obj/item/circuitboard/communications/commboard in world)
		if((istype(commboard.loc,/turf) || istype(commboard.loc,/obj/item/storage)) && commboard != src)
			return ..()

	for(var/mob/living/silicon/ai/shuttlecaller in player_list)
		if(!shuttlecaller.stat && shuttlecaller.client && istype(shuttlecaller.loc,/turf))
			return ..()

	if(ticker.mode.name == "revolution" || ticker.mode.name == "AI malfunction" || sent_strike_team)
		return ..()

	emergency_shuttle.incall(2)
	log_game("All the AIs, comm consoles and boards are destroyed. Pods launch started.")
	message_admins("All the AIs, comm consoles and boards are destroyed. Pods launch started.", 1)
	if(evac_type == "pods")
		a.autosay("Alert: The escape pods are being launched. They will launch in [round(emergency_shuttle.timeleft()/60)] minutes.", "Ulysses Console")
	else
		a.autosay("Alert: The emergency shuttle has been called. It will arrive in [round(emergency_shuttle.timeleft()/60)] minutes.", "Ulysses Console")
	world << sound('sound/AI/shuttlecalled.ogg')

	..()
