var/silenceofpigs = FALSE
var/trapokalipsis = FALSE
var/global/list/hiden_obols = list()
/client/proc/ChromieReturn(var/cost, var/name, var/desc)
	if(!cost)
		return FALSE
	if(current_server == "S3")
		return FALSE
	if((chromie_holder.chromie_number < cost) && !(usr.ckey in puppeteers))
		to_chat(usr, "Not enough chromosomes.")
		return FALSE
	if((chromie_holder.chromie_number >= cost) || (usr.ckey in puppeteers))
		if(usr.ckey in puppeteers)
			ChromieDO(name)
			return TRUE
		else
			AdjustChromies(cost*-1) // multiply by negative one to make the value negative
			ChromieDO(name)
			to_chat(usr, "<span class='excomm'>[cost] Chromosomes lost!</span>")
			return TRUE

/client/proc/ChromieDO(var/name)
	if(current_server == "S3")
		return
	switch(name)
		if("Limpar Cromossomos")
			return
		if("ReRolarSpecial")
			var/mob/new_player/N = usr
			if(N.special || SpecialRolledList.Find(N.ckey))
				if(SpecialRolledList.Find(N.ckey))
					SpecialRolledList.Remove(N.ckey)
				N.special = 0
				N.specialitem = null
				N.specialdesc = null
				N.qualspecial = ""

		if("Chamar a Ulysses")
			emergency_shuttle.incall()
			log_game("[src] has launched the Ulysses.")
			message_admins("[src] has launched the Ulysses.", 1)
			world << sound('sound/AI/shuttlecalled.ogg')
		if("RetirarVice")
			var/mob/living/carbon/human/H = usr
			if(H.vice)
				H.vice = null
				H.viceneed = 0
				H.clear_event("vice")
				return
		if("SilencePigs")
			to_chat(world, "<p style='font-size:22px'><span class='passivebold'>[src.key] grants us Silence of the Pigs!</span></p>")
			world << 'sound/pigdeath.ogg'
			silenceofpigs = TRUE
			return
		if("Trapokalipsis")
			trapokalipsis = TRUE
			to_chat(world, "<p style='font-size:22px'><span class='passivebold'>[src.key] grants us Trapokalipsis!</span></p>")
			donation_trap = ckeywhitelistweb.Copy()
			world << 'sound/effects/ladyend.ogg'
		if("ForceAspect")
			var/mob/new_player/N = usr
			var/events_pick = subtypesof(/datum/round_event)
			var/list/events_choose
			for(var/datum/round_event/E in events_pick)
				new E
				events_choose[E.name] = E
			var/event_select = input(N, "Select an Aspect.", "Aspects", null) in events_choose
			if(!event_select)
				event_select = pick(events_choose)
			for(var/i = 1, i <= aspects_max, i++)
				N.aspects_list += events_choose[event_select]
			to_chat(src, "<b>Aspect Rerolls Left:</b> [N.aspects_rerolls]")
			var/number = 1
			for(var/datum/round_event/R in N.aspects_list)
				to_chat(N, "[number]. <b>[R.name]</b> - [R.event_message]")
				number++
		if("ReceiveObols")
			var/obj/item/card/id/ID = found_ring_by_human(usr)
			if(!ID)
				hiden_obols += usr.ckey
				to_chat(usr, "<i>I hide them somewhere, but where...</i>")
			else
				to_chat(usr, "Did I receive it?")
				ID.receivePayment(50)

/client/proc/ChromieWinorLoose(var/value)
	var/chromossomeTXT
	if(!value)
		return
	if(current_server == "S3")
		return
	if(value > 0)
		AdjustChromies(value)
		chromossomeTXT = "<span class='passivebold'>[value] Chromosomes gained!</span>"
		if(value > 3)
			chromossomeTXT = "<span class='passivebold'>[value] Chromosomes gained!</span>"
		to_chat(src, chromossomeTXT)
	if(value < 0)
		if(chromie_holder.chromie_number <= -5)
			return
		AdjustChromies(value)
		cromosperdidos += value
		chromossomeTXT = "<span class='excomm'>[value] Chromosomes lost!</span>"
		if(value > -3)
			chromossomeTXT = "<span class='excomm'>[value] Chromosomes lost!</span>"
		to_chat(src, chromossomeTXT)

/client/verb/wipeChromossomes()
	set category = "Chromossomes"
	set name = "LimparCromossomos"
	set desc = "Voce vai limpar todos os cromossomos dos jogadores."


	var/nameE = "Limpar Cromossomos"
	var/descE = "Voce vai limpar todos os cromossomos dos jogadores."
	var/cost = 100

	ChromieReturn(cost, nameE, descE)


/client/verb/allMig()
	set category = "Chromossomes"
	set name = "MigracaodeTodos"
	set desc = "Voce vai fazer o gamemode All Mig."


	var/nameE = "Migracao de Todos"
	var/descE = "Voce vai fazer o gamemode All Mig."
	var/cost = 100

	ChromieReturn(cost, nameE, descE)

/client/verb/callCharon()
	set category = "Chromossomes"
	set name = "ChamarCharon"
	set desc = "Voce vai chamar a Charon."

	var/nameE = "Chamar a Ulysses"
	var/descE = "You will call the Ulysses."
	var/cost = 10

	if(!ChromieReturn(cost, nameE, descE)) //This one isn't in the chromieDO proc for some reason.
		return

	if(ticker.mode.config_tag == "kingwill" && world.time < 80 MINUTES)
		to_chat(usr, "<span class='combatbold'>The tribunal will not allow the Ulysses to be launched.</span>")
		return

	if(ticker.mode.config_tag == "siege")
		to_chat(usr, "<span class='combatbold'>There can be only one!</span>")
		return

	var/datum/shuttle/shuttle = global.shuttleMain

	if(shuttle.called)
		to_chat(usr, "<span class='combat'>The Ulysses launch has already been initiated.</span>")
		return

	shuttle.callshuttle()
	log_game("[key_name(usr)] has launched the Ulysses.")
	message_admins("[key_name_admin(usr)] has launched the Ulysses.", 1)

/client/verb/jobConcealCustom()
	set category = "Chromossomes"
	set name = "EscondercargoCustom"
	set desc = "Voce vai se conceder um cargo customizado."

	var/nameE = "Esconder cargo Custom"
	var/descE = "Voce vai se conceder um cargo customizado."
	var/cost = 10

	ChromieReturn(cost, nameE, descE)

/client/verb/jobConceal()
	set category = "Chromossomes"
	set name = "Escondercargo"
	set desc = "Voce vai se conceder um cargo."

	var/nameE = "Esconder cargo"
	var/descE = "Voce vai se conceder um cargo."
	var/cost = 2

	ChromieReturn(cost, nameE, descE)

/client/verb/rerollSpecial()
	set category = "Chromossomes"
	set name = "ReRolarSpecial"
	set desc = "Voce vai dar reroll em seu Special."

	var/nameE = "ReRolarSpecial"
	var/descE = "Voce vai dar reroll em seu Special."
	var/cost = 2

	ChromieReturn(cost, nameE, descE)

/client/verb/Trapokalipsis()
	set category = "Chromossomes"
	set name = "Trapokalipsis"
	set desc = "Pain."

	var/nameE = "Trapokalipsis"
	var/descE = "Pain."
	var/cost = 15

	if(trapokalipsis)
		return

	ChromieReturn(cost, nameE, descE)

/client/verb/removeVice()
	set category = "Chromossomes"
	set name = "RetirarVice"
	set desc = "Voce vai retirar seu vicio sobre algo."

	var/nameE = "RetirarVice"
	var/descE = "Voce vai retirar seu vicio sobre algo."
	var/cost = 1

	if(!ticker || ticker.current_state != GAME_STATE_PLAYING)
		to_chat(src, "The round is either not ready, or has already finished...")
		return 0
	ChromieReturn(cost, nameE, descE)

/client/verb/silencePigs()
	set category = "Chromossomes"
	set name = "SilencePigs"
	set desc = "cale os porcos"

	var/nameE = "SilencePigs"
	var/descE = "cale os porcos"
	var/cost = 2
	if(silenceofpigs)
		return
	ChromieReturn(cost, nameE, descE)

/client/verb/ForceAspect()
	set category = "Chromossomes"
	set name = "ForceAspect"
	set desc = "Force Aspect"

	var/nameE = "ForceAspect"
	var/descE = "Force Aspect"
	var/cost = 10

	if(!istype(usr, /mob/new_player) || ticker.current_state != GAME_STATE_PREGAME)
		to_chat(usr, "It's only useble before round begins.")
		return

	ChromieReturn(cost, nameE, descE)

/client/verb/ForcePadla()
	set category = "Chromossomes"
	set name = "ForcePadla"
	set desc = "Force Padla"

	var/nameE = "ForcePadla"
	var/descE = "Force Padla"
	var/cost = 7

	if (!ticker || ticker.current_state != GAME_STATE_PLAYING)
		to_chat(usr, "Wait for round start.")
		return

	ChromieReturn(cost, nameE, descE)

/client/verb/ReceiveObols()
	set category = "Chromossomes"
	set name = "ReceiveObols"
	set desc = "Receive Obols"

	var/nameE = "ReceiveObols"
	var/descE = "Receive Obols"
	var/cost = 1

	if (!istype(usr, /mob/living/carbon/human))
		to_chat(usr, "I need to be human, after all...")
		return

	ChromieReturn(cost, nameE, descE)

/datum/admins/proc/change_chromies()
	set name = "ChangeChromies"
	set hidden = 1
	if(!check_rights(R_SERVER))
		to_chat(usr, "You don't have the  rights! O, you don't have the rights!")
		return
	var/new_number = input("Enter chromie amount", "Chromies") as num
	usr.client.chromie_holder.chromie_number += new_number