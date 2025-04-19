var/NextCurseProc = 30 SECONDS
/datum/controller/process/curse/setup()
	name = "curses"
	schedule_interval = 10 // every 1 second
	start_delay = 18

/datum/controller/process/curse/started()
	..()
var/witchdisguised = 0

/datum/controller/process/curse/process()
	NextCurseProc = max(0, NextCurseProc-1)
	if(NextCurseProc == 0 && knifeprayer == FALSE)
		for(var/mob/living/carbon/human/V in cursed)
			switch(V.curse)
				if("Journey to Evergreen")
					V.lying = 1
				if("Soil Contribution")
					V.bowels = 40
					V.handle_shit()
				if("Virtuous Disability")
					V.erpcooldown = rand(200, 450)
		if(witchdisguised)
			for(var/mob/living/carbon/human/H in mob_list)
				if(H.job == "Fortune Teller" || H.old_job == "Fortune Teller")
					var/obj/item/clothing/head/amulet/A = H.amulet
					if(!istype(A, /obj/item/clothing/head/amulet/witch))
						H.age = 120
						H.h_style = "Bedhead"
						H.r_hair = 128
						H.g_hair = 128
						H.b_hair = 128
						witchdisguised = 0
						H.update_inv_wear_suit()
						H.update_hair()
						for(var/obj/item/clothing/suit/witch/R in world)
							R.icon_state = "witch"
							R.name = "ragged dress"
		NextCurseProc = rand(1 MINUTES, 3 MINUTES)

