/obj/machinery/disease2/isolator/
	name = "Pathogenic Isolator"
	density = 1
	anchored = 1
	icon = 'icons/obj/virology.dmi'
	icon_state = "isolator"
	var/datum/disease2/disease/virus2 = null
	var/isolating = 0
	var/beaker = null

	ex_act(severity)
		switch(severity)
			if(1.0)
				qdel(src)
				return
			if(2.0)
				if (prob(50))
					qdel(src)
					return

	attackby(var/obj/item/reagent_containers/glass/B as obj, var/mob/user as mob)
		if(!istype(B,/obj/item/reagent_containers/syringe))
			return

		if(src.beaker)
			user << "A syringe is already loaded into the machine."
			return

		src.beaker =  B
		user.drop_item()
		B.loc = src
		if(istype(B,/obj/item/reagent_containers/syringe))
			user << "You add the syringe to the machine!"
			src.updateUsrDialog()
			icon_state = "isolator_in"

	Topic(href, href_list)
		if(stat & BROKEN) return
		if(usr.stat || usr.restrained()) return
		if(!in_range(src, usr)) return

		usr.machine = src
		if(!beaker) return
		var/datum/reagents/R = beaker:reagents

		if (href_list["isolate"])
			var/datum/reagent/blood/Blood
			for(var/datum/reagent/blood/B in R.reagent_list)
				if(B)
					Blood = B
					break

			if(Blood.data["virus2"])
				virus2 = Blood.data["virus2"]
				isolating = 40
				icon_state = "isolator_processing"
			src.updateUsrDialog()
			return

		else if (href_list["main"])
			attack_hand(usr)
			return
		else if (href_list["eject"])
			beaker:loc = src.loc
			beaker = null
			icon_state = "isolator"
			src.updateUsrDialog()
			return

	attack_hand(mob/user as mob)
		if(stat & BROKEN)
			return
		user.machine = src
		var/dat = ""
		if(!beaker)
			dat = "Please insert sample into the isolator.<BR>"
			dat += "<A href='byond://?src=\ref[src];close=1'>Close</A>"
		else if(isolating)
			dat = "Isolating"
		else
			var/datum/reagents/R = beaker:reagents
			dat += "<A href='byond://?src=\ref[src];eject=1'>Eject</A><BR><BR>"
			if(!R.total_volume)
				dat += "[beaker] is empty."
			else
				dat += "Contained reagents:<BR>"
				for(var/datum/reagent/blood/G in R.reagent_list)
					dat += "    [G.name]: <A href='byond://?src=\ref[src];isolate=[G.id]'>Isolate</a>"
		user << browse("<TITLE>Pathogenic Isolator</TITLE>Isolator menu:<BR><BR>[dat]", "window=isolator;size=575x400")
		onclose(user, "isolator")
		return




	process()
		if(isolating > 0)
			isolating -= 1
			if(isolating == 0)
				var/obj/item/virusdish/d = new /obj/item/virusdish(src.loc)
				d.virus2 = virus2.getcopy()
				virus2 = null
				icon_state = "isolator_in"




/obj/item/virusdish
	name = "Virus containment/growth dish"
	icon = 'icons/obj/items.dmi'
	icon_state = "implantcase-b"
	var/datum/disease2/disease/virus2 = null
	var/growth = 0
	var/info = 0
	var/analysed = 0

/obj/item/virusdish/attackby(var/obj/item/W as obj,var/mob/living/carbon/user as mob)
	if(istype(W,/obj/item/hand_labeler))
		return
	..()
	if(prob(50))
		user << "The dish shatters"
		if(virus2.infectionchance > 0)
			infect_virus2(user,virus2)
		del src

/obj/item/virusdish/examine()
	usr << "This is a virus containment dish"
	if(src.info)
		usr << "It has the following information about its contents"
		usr << src.info
