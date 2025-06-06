//This file was auto-corrected by findeclaration.exe on 25.5.2012 20:42:31

//Keeps track of the time for the ID console. Having it as a global variable prevents people from dismantling/reassembling it to
//increase the slots of many jobs.
var/time_last_changed_position = 0

/obj/machinery/computer/card
	name = "identification console"
	desc = "You can use this to change ID's."
	icon_state = "id"
	req_one_access = list(access_change_ids)
	circuit = /obj/item/circuitboard/card
	var/obj/item/card/id/scan = null
	var/obj/item/card/id/modify = null
	var/authenticated = 0.0
	var/mode = 0.0
	var/printing = null
	var/list/region_access = null
	var/list/head_subordinates = null

	//Cooldown for closing positions in seconds
	//if set to -1: No cooldown... probably a bad idea
	//if set to 0: Not able to close "original" positions. You can only close positions that you have opened before
	var/change_position_cooldown = 60
	//Jobs you cannot open new positions for
	var/list/blacklisted = list(
		"AI",
		"Assistant",
		"Cyborg",
		"Captain",
		"Head of Personnel",
		"Head of Security",
		"Chief Engineer",
		"Research Director",
		"Chief Medical Officer",
		"Chaplain",
		"Baron",
		"Hand",
		"Heir",
		"Successor",
		"Baroness")

	//The scaling factor of max total positions in relation to the total amount of people on board the station in %
	var/max_relative_positions = 30 //30%: Seems reasonable, limit of 6 @ 20 players

	//This is used to keep track of opened positions for jobs to allow instant closing
	//Assoc array: "JobName" = (int)<Opened Positions>
	var/list/opened_positions = list();

/obj/machinery/computer/card/attackby(O as obj, user as mob, params)//TODO:SANITY
	if(istype(O, /obj/item/card/id))
		var/obj/item/card/id/idcard = O
		if(check_access(idcard))
			if(!scan)
				usr.drop_item()
				idcard.loc = src
				scan = idcard
			else if(!modify)
				usr.drop_item()
				idcard.loc = src
				modify = idcard
		else
			if(!modify)
				usr.drop_item()
				idcard.loc = src
				modify = idcard
	else
		..()

//Check if you can't open a new position for a certain job
/obj/machinery/computer/card/proc/job_blacklisted(jobtitle)
	return (jobtitle in blacklisted)


//Logic check for Topic() if you can open the job
/obj/machinery/computer/card/proc/can_open_job(var/datum/job/job)
	if(job)
		if(!job_blacklisted(job.title))
			if((job.total_positions <= player_list.len * (max_relative_positions / 100)))
				var/delta = (world.time / 10) - time_last_changed_position
				if((change_position_cooldown < delta) || (opened_positions[job.title] < 0))
					return 1
				return -2
			return -1
	return 0

//Logic check for Topic() if you can close the job
/obj/machinery/computer/card/proc/can_close_job(var/datum/job/job)
	if(job)
		if(!job_blacklisted(job.title))
			if(job.total_positions > job.current_positions)
				var/delta = (world.time / 10) - time_last_changed_position
				if((change_position_cooldown < delta) || (opened_positions[job.title] > 0))
					return 1
				return -2
			return -1
	return 0

/obj/machinery/computer/card/attack_hand(var/mob/user as mob)
	if(..())
		return

	user.set_machine(src)
	var/dat
	if(!ticker)	return
	if (mode == 1) // accessing crew manifest
		var/crew = ""
		for(var/datum/data/record/t in sortRecord(data_core.general))
			crew += t.fields["name"] + " - " + t.fields["rank"] + "<br>"
		dat = "<tt><b>Crew Manifest:</b><br>Please use security record computer to modify entries.<br><br>[crew]<a href='byond://?src=\ref[src];choice=print'>Print</a><br><br><a href='byond://?src=\ref[src];choice=mode;mode_target=0'>Access ID modification console.</a><br></tt>"

	else if(mode == 2)
		// JOB MANAGEMENT
		dat = "<a href='byond://?src=\ref[src];choice=return'>Return</a>"
		dat += " || Confirm Identity: "
		var/S
		if(scan)
			S = html_encode(scan.name)
		else
			S = "--------"
		dat += "<a href='byond://?src=\ref[src];choice=scan'>[S]</a>"
		dat += "<table>"
		dat += "<tr><td style='width:25%'><b>Job</b></td><td style='width:25%'><b>Slots</b></td><td style='width:25%'><b>Open job</b></td><td style='width:25%'><b>Close job</b></td></tr>"
		var/ID
		if(scan && (access_change_ids in scan.access))
			ID = 1
		else
			ID = 0
		for(var/datum/job/job in job_master.occupations)
			dat += "<tr>"
			if(job.title in blacklisted)
				continue
			dat += "<td>[job.title]</td>"
			dat += "<td>[job.current_positions]/[job.total_positions]</td>"
			dat += "<td>"
			switch(can_open_job(job))
				if(1)
					if(ID)
						dat += "<a href='byond://?src=\ref[src];choice=make_job_available;job=[job.title]'>Open Position</a><br>"
					else
						dat += "Open Position"
				if(-1)
					dat += "Denied"
				if(-2)
					var/time_to_wait = round(change_position_cooldown - ((world.time / 10) - time_last_changed_position), 1)
					var/mins = round(time_to_wait / 60)
					var/seconds = time_to_wait - (60*mins)
					dat += "Cooldown ongoing: [mins]:[(seconds < 10) ? "0[seconds]" : "[seconds]"]"
				if(0)
					dat += "Denied"
			dat += "</td><td>"
			switch(can_close_job(job))
				if(1)
					if(ID)
						dat += "<a href='byond://?src=\ref[src];choice=make_job_unavailable;job=[job.title]'>Close Position</a>"
					else
						dat += "Close Position"
				if(-1)
					dat += "Denied"
				if(-2)
					var/time_to_wait = round(change_position_cooldown - ((world.time / 10) - time_last_changed_position), 1)
					var/mins = round(time_to_wait / 60)
					var/seconds = time_to_wait - (60*mins)
					dat += "Cooldown ongoing: [mins]:[(seconds < 10) ? "0[seconds]" : "[seconds]"]"
				if(0)
					dat += "Denied"
			dat += "</td></tr>"
		dat += "</table>"
	else
		var/header = ""

		var/target_name
		var/target_owner
		var/target_rank
		if(modify)
			target_name = html_encode(modify.name)
		else
			target_name = "--------"
		if(modify && modify.registered_name)
			target_owner = html_encode(modify.registered_name)
		else
			target_owner = "--------"
		if(modify && modify.assignment)
			target_rank = html_encode(modify.assignment)
		else
			target_rank = "Unassigned"

		var/scan_name
		if(scan)
			scan_name = html_encode(scan.name)
		else
			scan_name = "--------"

		if(!authenticated)
			header += "<br><i>Please insert the cards into the slots</i><br>"
			header += "Target: <a href='byond://?src=\ref[src];choice=modify'>[target_name]</a><br>"
			header += "Confirm Identity: <a href='byond://?src=\ref[src];choice=scan'>[scan_name]</a><br>"
		else
			header += "<div align='center'><br>"
			header += "<a href='byond://?src=\ref[src];choice=modify'>Remove [target_name]</a> || "
			header += "<a href='byond://?src=\ref[src];choice=scan'>Remove [scan_name]</a> <br> "
			header += "<a href='byond://?src=\ref[src];choice=mode;mode_target=1'>Access Crew Manifest</a> || "
			header += "<a href='byond://?src=\ref[src];choice=logout'>Log Out</a></div>"

		header += "<hr>"

		var/jobs_all = ""
		var/list/alljobs = list("Unassigned")
		alljobs += (istype(src,/obj/machinery/computer/card/centcom)? get_all_centcom_jobs() : get_all_jobs()) + "Custom"
		for(var/job in alljobs)
			jobs_all += "<a href='byond://?src=\ref[src];choice=assign;assign_target=[job]'>[replacetext(job, " ", "&nbsp")]</a> " //make sure there isn't a line break in the middle of a job


		var/body

		if (authenticated && modify)

			var/carddesc = text("")
			var/jobs = text("")
			if( authenticated == 2)
				carddesc += {"<script type="text/javascript">
									function markRed(){
										var nameField = document.getElementById('namefield');
										nameField.style.backgroundColor = "#FFDDDD";
									}
									function markGreen(){
										var nameField = document.getElementById('namefield');
										nameField.style.backgroundColor = "#DDFFDD";
									}
									function showAll(){
										var allJobsSlot = document.getElementById('alljobsslot');
										allJobsSlot.innerHTML = "<a href='#' onclick='hideAll()'>hide</a><br>"+ "[jobs_all]";
									}
									function hideAll(){
										var allJobsSlot = document.getElementById('alljobsslot');
										allJobsSlot.innerHTML = "<a href='#' onclick='showAll()'>show</a>";
									}
								</script>"}
				carddesc += "<form name='cardcomp' action='byond://?src=\ref[src]' method='get'>"
				carddesc += "<input type='hidden' name='src' value='\ref[src]'>"
				carddesc += "<input type='hidden' name='choice' value='reg'>"
				carddesc += "<b>registered name:</b> <input type='text' id='namefield' name='reg' value='[target_owner]' style='width:250px; background-color:white;' onchange='markRed()'>"
				carddesc += "<input type='submit' value='Rename' onclick='markGreen()'>"
				carddesc += "</form>"
				carddesc += "<b>Assignment:</b> "

				jobs += "<span id='alljobsslot'><a href='#' onclick='showAll()'>[target_rank]</a></span>" //CHECK THIS

			else
				carddesc += "<b>registered_name:</b> [target_owner]</span>"
				jobs += "<b>Assignment:</b> [target_rank] (<a href='byond://?src=\ref[src];choice=demote'>Demote</a>)</span>"

			var/accesses = ""
			if(istype(src,/obj/machinery/computer/card/centcom))
				accesses += "<h5>Central Command:</h5>"
				for(var/A in get_all_centcom_access())
					if(A in modify.access)
						accesses += "<a href='byond://?src=\ref[src];choice=access;access_target=[A];allowed=0'><font color=\"red\">[replacetext(get_centcom_access_desc(A), " ", "&nbsp")]</font></a> "
					else
						accesses += "<a href='byond://?src=\ref[src];choice=access;access_target=[A];allowed=1'>[replacetext(get_centcom_access_desc(A), " ", "&nbsp")]</a> "
			else
				accesses += "<div align='center'><b>Access</b></div>"
				accesses += "<table style='width:100%'>"
				accesses += "<tr>"
				for(var/i = 1; i <= 7; i++)
					if(authenticated == 1 && !(i in region_access))
						continue
					accesses += "<td style='width:14%'><b>[get_region_accesses_name(i)]:</b></td>"
				accesses += "</tr><tr>"
				for(var/i = 1; i <= 7; i++)
					if(authenticated == 1 && !(i in region_access))
						continue
					accesses += "<td style='width:14%' valign='top'>"
					for(var/A in get_region_accesses(i))
						if(A in modify.access)
							accesses += "<a href='byond://?src=\ref[src];choice=access;access_target=[A];allowed=0'><font color=\"red\">[replacetext(get_access_desc(A), " ", "&nbsp")]</font></a> "
						else
							accesses += "<a href='byond://?src=\ref[src];choice=access;access_target=[A];allowed=1'>[replacetext(get_access_desc(A), " ", "&nbsp")]</a> "
						accesses += "<br>"
					accesses += "</td>"
				accesses += "</tr></table>"
			body = "[carddesc]<br>[jobs]<br><br>[accesses]" //CHECK THIS

		else
			body = "<a href='byond://?src=\ref[src];choice=auth'>{Log in}</a> <br><hr>"
			body += "<a href='byond://?src=\ref[src];choice=mode;mode_target=1'>Access Crew Manifest</a>"
			body += "<br><hr><a href = 'byond://?src=\ref[src];choice=mode;mode_target=2'>Job Management</a>"

		dat = "<tt>[header][body]<hr><br></tt>"

	//user << browse(dat, "window=id_com;size=900x520")
	//onclose(user, "id_com")

	var/datum/browser/popup = new(user, "id_com", "Identification Card Modifier Console", 900, 620)
	popup.set_content(dat)
	popup.open()
	return


/obj/machinery/computer/card/Topic(href, href_list)
	if(..())
		return
	usr.set_machine(src)
	switch(href_list["choice"])
		if ("modify")
			if (modify)
				data_core.manifest_modify(modify.registered_name, modify.assignment)
				modify.update_label()
				modify.loc = loc
				modify.verb_pickup()
				modify = null
				region_access = null
				head_subordinates = null
			else
				var/obj/item/I = usr.get_active_hand()
				if (istype(I, /obj/item/card/id))
					usr.drop_item()
					I.loc = src
					modify = I
			authenticated = 0

		if ("scan")
			if (scan)
				scan.loc = src.loc
				scan.verb_pickup()
				scan = null
			else
				var/obj/item/I = usr.get_active_hand()
				if (istype(I, /obj/item/card/id))
					usr.drop_item()
					I.loc = src
					scan = I
			authenticated = 0
		if ("auth")
			if ((!( authenticated ) && (scan || (istype(usr, /mob/living/silicon))) && (modify || mode)))
				if (check_access(scan))
					if(access_change_ids in scan.access)
						authenticated = 2
					else
						region_access = list()
						head_subordinates = list()
						if(access_hop in scan.access)
							region_access += 1
							region_access += 6
							get_subordinates("Head of Personnel")
						if(access_rd in scan.access)
							region_access += 4
							get_subordinates("Research Director")
						if(access_ce in scan.access)
							region_access += 5
							get_subordinates("Chief Engineer")
						if(access_cmo in scan.access)
							region_access += 3
							get_subordinates("Chief Medical Officer")
						if(access_hos in scan.access)
							region_access += 2
							get_subordinates("Head of Security")
						if(region_access)
							authenticated = 1
			else if ((!( authenticated ) && (istype(usr, /mob/living/silicon))) && (!modify))
				usr << "<span class='warning'>You can't modify an ID without an ID inserted to modify! Once one is in the modify slot on the computer, you can log in.</span>"
		if ("logout")
			region_access = null
			head_subordinates = null
			authenticated = 0
		if("access")
			if(href_list["allowed"])
				if(authenticated)
					var/access_type = text2num(href_list["access_target"])
					var/access_allowed = text2num(href_list["allowed"])
					if(access_type in (istype(src,/obj/machinery/computer/card/centcom)?get_all_centcom_access() : get_all_accesses()))
						modify.access -= access_type
						if(access_allowed == 1)
							modify.access += access_type
		if ("assign")
			if (authenticated == 2)
				var/t1 = href_list["assign_target"]
				if(t1 == "Custom")
					var/newJob = reject_bad_text(input("Enter a custom job assignment.", "Assignment", modify ? modify.assignment : "Unassigned"), MAX_NAME_LEN)
					if(newJob)
						t1 = newJob

				else if(t1 == "Unassigned")
					modify.access = list()

				else
					var/datum/job/jobdatum
					for(var/jobtype in typesof(/datum/job))
						var/datum/job/J = new jobtype
						if(ckey(J.title) == ckey(t1))
							jobdatum = J
							break
					if(!jobdatum)
						usr << "<span class='error'>No log exists for this job.</span>"
						return

					modify.access = ( istype(src,/obj/machinery/computer/card/centcom) ? get_centcom_access(t1) : jobdatum.get_access() )
				if (modify)
					modify.assignment = t1
		if ("demote")
			if(modify.assignment in head_subordinates || modify.assignment == "Assistant")
				modify.assignment = "Unassigned"
			else
				usr << "<span class='error'>You are not authorized to demote this position.</span>"
		if ("reg")
			if (authenticated)
				var/t2 = modify
				//var/t1 = input(usr, "What name?", "ID computer", null)  as text
				if ((authenticated && modify == t2 && (in_range(src, usr) || (istype(usr, /mob/living/silicon))) && istype(loc, /turf)))
					var/newName = sanitize_name(href_list["reg"])
					if(newName)
						modify.registered_name = newName
					else
						usr << "<span class='error'>Invalid name entered.</span>"
						return
		if ("mode")
			mode = text2num(href_list["mode_target"])

		if("return")
			//DISPLAY MAIN MENU
			mode = 3;

		if("make_job_available")
			// MAKE ANOTHER JOB POSITION AVAILABLE FOR LATE JOINERS
			if(scan && (access_change_ids in scan.access))
				var/edit_job_target = href_list["job"]
				var/datum/job/j = job_master.GetJob(edit_job_target)
				if(!j)
					return 0
				if(can_open_job(j) != 1)
					return 0
				if(opened_positions[edit_job_target] >= 0)
					time_last_changed_position = world.time / 10
				j.total_positions++
				opened_positions[edit_job_target]++

		if("make_job_unavailable")
			// MAKE JOB POSITION UNAVAILABLE FOR LATE JOINERS
			if(scan && (access_change_ids in scan.access))
				var/edit_job_target = href_list["job"]
				var/datum/job/j = job_master.GetJob(edit_job_target)
				if(!j)
					return 0
				if(can_close_job(j) != 1)
					return 0
				//Allow instant closing without cooldown if a position has been opened before
				if(opened_positions[edit_job_target] <= 0)
					time_last_changed_position = world.time / 10
				j.total_positions--
				opened_positions[edit_job_target]--

		if ("print")
			if (!( printing ))
				printing = 1
				sleep(50)
				var/obj/item/paper/P = new /obj/item/paper( loc )
				var/t1 = "<B>Crew Manifest:</B><BR>"
				for(var/datum/data/record/t in sortRecord(data_core.general))
					t1 += t.fields["name"] + " - " + t.fields["rank"] + "<br>"
				P.info = t1
				P.name = "paper- 'Crew Manifest'"
				printing = null
	if (modify)
		modify.update_label()
	updateUsrDialog()
	return

/obj/machinery/computer/card/proc/get_subordinates(var/rank)
	/*
	for(var/datum/job/job in job_master.occupations)
		if(rank in job.department_head)
			head_subordinates += job.title
	*/
/obj/machinery/computer/card/centcom
	name = "\improper Centcom identification console"
	circuit = /obj/item/circuitboard/card/centcom
	req_access = list(access_cent_captain)

