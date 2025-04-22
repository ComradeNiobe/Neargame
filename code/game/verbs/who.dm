var/showlads = FALSE


/client
	var/anonymous_number = 0
	var/relevancy_color = "#454343"

/client/New()
	..()
	anonymous_number = rand(100,600)

var/global/list/datum/showlads_holder/showlads_list = list()
/datum/showlads_holder //for when people's bodies get destroyed.
	var/name = ""
	var/job = ""
	var/key = ""
	var/thanati = FALSE

/datum/showlads_holder/New()
	..()
	showlads_list |= src

/client/verb/showlads()
	set name = "Show Lads"
	set category = "OOC"
	if(!showlads)
		return

	var/list/dat = list()

	if(master_mode == "holywar" || master_mode == "minimig")
		dat += "<center><h2>POST CHRISTIANS</h2></center>"
		for(var/mob/living/C in global.mob_list)
			if(C.old_key)
				dat += "&#8226;<b>\t[C.real_name]</b>([C.old_job]) : [C.old_key]<br>"
		for(var/datum/showlads_holder/S as anything in global.showlads_list)
			if(S.job && S.name && S.key)
				dat += "&#8226;<b>\t[S.name]</b>([S.job]) : [S.key]<br>"
		dat += "<br><center><h2><font color='red'>THANATI</font></h2></center>"

		for(var/mob/living/carbon/human/C in global.mob_list)
			if(C.old_key && C.religion == "Thanati")
				dat += "&#8226;<b>\t[C.real_name]</b>([C.old_job]) : [C.old_key]<br>"
			for(var/datum/showlads_holder/S as anything in global.showlads_list)
				if(!S.thanati)
					continue
				if(S.job && S.name && S.key)
					dat += "&#8226;<b>\t[S.name]</b>([S.job]) : [S.key]<br>"

	else
		dat += "<center><h2>THE GATE'S VICTIMS</h2></center>"
		for(var/mob/living/carbon/human/H in global.mob_list)
			if(H.old_key)
				dat += "&#8226;<b>\t[H.real_name]</b>([H.old_job]) : [H.old_key]<br>"
		for(var/datum/showlads_holder/S as anything in global.showlads_list)
			if(S.name && S.key)
				dat += "&#8226;<b>\t[S.name]</b>([S.job]) : [S.key]<br>"
		dat += "<br><center><h2><font color='red'>THANATI</font></h2></center>"

		for(var/mob/living/carbon/human/C in global.mob_list)
			if(C.old_key && C.religion == "Thanati")
				dat += "&#8226;<b>\t[C.real_name]</b>([C.old_job]) : [C.old_key]<br>"
		for(var/datum/showlads_holder/S as anything in global.showlads_list)
			if(!S.thanati)
				continue
			if(S.job && S.name && S.key)
				dat += "&#8226;<b>\t[S.name]</b>([S.job]) : [S.key]<br>"

	var/datum/browser/popup = new(usr, "showlads", "Show Lads", 450, 500)
	popup.set_content(JOINTEXT(dat))
	popup.add_head_content("<style>table, th, td { border: 1px solid black; border-collapse: collapse; } th, td { padding: 15px; }</style>")
	popup.open()


/*
	if(holder)
		for(var/client/C in clients)
			var/entry = "\t[C.key]"
			if(C.holder && C.holder.fakekey)
				entry += " <i>(as [C.holder.fakekey])</i>"
			entry += " - Playing as [C.mob.real_name]"
			switch(C.mob.stat)
				if(UNCONSCIOUS)
					entry += " - <font color='darkgray'><b>Unconscious</b></font>"
				if(DEAD)
					if(isobserver(C.mob))
						var/mob/dead/observer/O = C.mob
						if(O.started_as_observer)
							entry += " - <font color='gray'>Observing</font>"
						else
							entry += " - <font color='black'><b>DEAD</b></font>"
					else
						entry += " - <font color='black'><b>DEAD</b></font>"
			if(is_special_character(C.mob))
				entry += " - <b><font color='red'>Antagonist</font></b>"
			entry += " (<A HREF='byond://?_src_=holder;adminmoreinfo=\ref[C.mob]'>?</A>)"
			Lines += entry
	else
		for(var/client/C in clients)
			if(C.holder && C.holder.fakekey)
				Lines += C.holder.fakekey
			else
				Lines += C.key

	for(var/line in sortList(Lines))
		msg += "[line]\n"

	msg += "<b>Total Players: [length(Lines)]</b>"
	src << msg
*/
/*
/client/verb/adminwho()
	set category = "Admin"
	set name = "Adminwho"

	var/msg = ""
	var/num_admins_online = 0
	if(holder)
		for(var/client/C in admins)
			msg += "\t[C] is a [C.holder.rank]"

			if(C.holder.fakekey)
				msg += " <i>(as [C.holder.fakekey])</i>"

			if(isobserver(C.mob))
				msg += " - Observing"
			else if(istype(C.mob,/mob/new_player))
				msg += " - Lobby"
			else
				msg += " - Playing"

			if(C.is_afk())
				msg += " (AFK)"
			msg += "\n"

			num_admins_online++
	else
		for(var/client/C in admins)
			if(!C.holder.fakekey)
				msg += "\t[C] is a [C.holder.rank]\n"
				num_admins_online++

	msg = "<b>Current Admins ([num_admins_online]):</b>\n" + msg
	to_chat(src, msg)
*/
