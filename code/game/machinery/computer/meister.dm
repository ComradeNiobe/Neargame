/obj/machinery/computer/meister
	name = "meister console"
	icon_state = "meister"
//	req_one_access = list(access_change_ids)

/obj/machinery/computer/meister/attack_hand(var/mob/user as mob)
	user.set_machine(src)

	var/list/dat = list()

	dat += "<div><div id = 'l'>"
	dat += "<table>"
	dat += {"
		<th>NAME</th>
		<th>POSITION</th>
		<th>LOCATION</th>
		<th>ACCOUNT</th>
		<th>OPERATIONS</th>
	"}
	if(!ticker)
		return
	for(var/obj/item/card/id/ID as anything in rings_account)
		if(ID.no_showing)
			continue
		if(ID.registered_name == "Unknown")
			continue
		var/area/T = get_area(ID)
		var/money_in = ID.money_account.get_money()
		dat += "<tr>"
		dat += "<td>[ID.assignment]</td>"
		dat += "<td>[T.name]</td>"
		dat += "<td>[ID.registered_name]</td>"
		dat += "<td>[money_in]</td>"
		dat += "<td>"
		dat += "<a href='byond://?src=\ref[ID];choice=nullify'>Nullify</a><br>"
		dat += "<a href='byond://?src=\ref[ID];choice=addfund'>Add Funds</a><br>"
		dat += "</td>"
		dat += "</tr>"
	dat += "</table><br>"
	dat += "</div></div>"

	dat += "<div id = 'r'>"
	dat += "<br><br>"
	dat += "<a class = 'rpo' href='byond://?src=\ref[src];choice=wage'>Give Wage</a><br>"
	dat += "<a class = 'rpo' href='byond://?src=\ref[src];choice=recovercrown'>Recover the Crown</a><br>"
	dat += "<a class='rpo' href='byond://?src=\ref[src];choice=alarmoff'>Turn Off All Alarms</a><br>"
	dat += "</div>"

	var/datum/browser/popup = new(user, "id_com", "ENOCH'S GATE - MANAGEMENT", 700, 520)
	popup.set_content(JOINTEXT(dat))
	popup.open()

/obj/item/card/id/Topic(href, href_list)
	switch(href_list["choice"])
		if("nullify")
			if(money_account == treasuryworth)
				to_chat(usr, "<span class='combatbold'>[pick(fnord)] I can't do this to Baron's ring!</span>")
				return
			to_chat(usr, "[src.name] has been nullified ([src.rank])")
			log_game("[usr.real_name]([usr.key]) has nullified [src.name]'s funds.")
			money_account.set_money(0)

			return TOPIC_REFRESH
		if("addfund")
			if(money_account == treasuryworth)
				to_chat(usr, "<span class='combatbold'>[pick(fnord)] I can't do this to Baron's ring!</span>")
				return
			var/manyobols = input("How many obols in copper are they going to receive? [treasuryworth.get_money()] obols in Treasury!", "MEISTERY") as null|num
			if(manyobols <= 0)
				return
			if(manyobols <= 0)
				if(money_account.get_money() < manyobols)
					to_chat(usr, "The ring is empty!")
					return
			manyobols = clamp(manyobols,0,(treasuryworth.get_money())*10)
			log_game("[usr.real_name]([usr.key]) has added [manyobols] to [src.name]'s ring.")
			src.receivePayment(manyobols)

			return TOPIC_REFRESH

/obj/machinery/computer/meister/Topic(href, href_list)
	. = ..()
	if(!CanPhysicallyInteractWith(usr, src))
		to_chat(usr, SPAN_WARNING("You must stay close to \the [src]!"))
		return

	switch(href_list["choice"])
		if ("wage")
			var/list/wages = list("Maid","Kraken","Triton","Sheriff","Charybdis","Mortus","Misero","Servant","Pusher")
			var/choice = input("Choose a job to receive their wage!", "MEISTERY") as null|anything in wages
			if(!choice)
				return TOPIC_HANDLED
			var/manyobols = input("How many obols in copper are they going to receive? [treasuryworth.get_money()] obols in Treasury!", "MEISTERY") as null|num
			if(manyobols <= 0)
				return TOPIC_HANDLED
			var/list/wagelist = list()
			for(var/obj/item/card/id/ID in rings)
				if(ID.rank != choice)
					continue
				else
					wagelist.Add(ID)
			playsound(src.loc, 'sound/webbers/console_interact7.ogg', 60, 0)
			to_chat(usr, "[manyobols] sent!")
			log_game("[key_name(usr)] has paid all [choice] a wage of [manyobols].")
			for(var/obj/item/card/id/ID in wagelist)
				ID.receivePayment(manyobols)

			return TOPIC_REFRESH
		if ("recovercrown")
			if(!fortCrown)
				to_chat(usr, "<span class='combatbold'>[pick(fnord)] The crown does not exist!</span>")
				return TOPIC_HANDLED
			if(istype(fortCrown.loc, /mob/living))
				to_chat(usr, "<span class='combatbold'>[pick(fnord)] Someone is wearing the crown!</span>")
				return TOPIC_HANDLED
			log_game("[key_name(usr)] has recovered the crown.")
			to_chat(usr, "<span class='passive'>Success</span>")
			playsound(src.loc, 'sound/webbers/console_interact7.ogg', 60, 0)
			fortCrown.loc = src.loc

			return TOPIC_HANDLED
		if ("alarmoff")
			for(var/obj/machinery/emergency_room/E in emergency_rooms)
				if(E.activearea.alarm_toggled)
					E.activearea.alarm_toggled = FALSE
					E.icon_state = E.normal_state
					E.active = FALSE
					processing_objects.Remove(E)
			log_game("[key_name(usr)] has disabled the alarms.")
			to_chat(usr, "<span class='passive'>Success</span>")
			playsound(src.loc, 'sound/webbers/console_interact7.ogg', 60, 0)

			return TOPIC_HANDLED

/obj/machinery/computer/meister/attackby(obj/item/W as obj, mob/user as mob)
	if(istype(W, /obj/item/spacecash))
		var/obj/item/spacecash/C = W
		treasuryworth.add_money(C.worth)
		qdel(C)
		playsound(src.loc, 'sound/effects/coininsert.ogg', 30, 0)

	if(istype(W, /obj/item/fakecash))
		to_chat(user, "<span class='combat'>Curse. It's fake!</span>")
