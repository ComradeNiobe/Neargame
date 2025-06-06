/**********************Mineral purifier (not used, replaced with mineral processing unit)**************************/

/obj/machinery/mineral/purifier
	name = "Ore Purifier"
	desc = "A machine which makes building material out of ores"
	icon = 'icons/obj/computer.dmi'
	icon_state = "aiupload"
	var/obj/machinery/mineral/input = null
	var/obj/machinery/mineral/output = null
	var/processed = 0
	var/processing = 0
	density = 1
	anchored = 1.0

/obj/machinery/mineral/purifier/attack_hand(user as mob)

	if(processing == 1)
		user << "The machine is processing"
		return

	var/dat
	dat = text("input connection status: ")
	if (input)
		dat += text("<b><font color='green'>CONNECTED</font></b>")
	else
		dat += text("<b><font color='red'>NOT CONNECTED</font></b>")
	dat += text("<br>output connection status: ")
	if (output)
		dat += text("<b><font color='green'>CONNECTED</font></b>")
	else
		dat += text("<b><font color='red'>NOT CONNECTED</font></b>")

	dat += text("<br><br><A href='byond://?src=\ref[src];purify=[input]'>Purify</A>")

	dat += text("<br><br>found: <font color='green'><b>[processed]</b></font>")
	user << browse("[dat]", "window=purifier")

/obj/machinery/mineral/purifier/Topic(href, href_list)
	if(..())
		return
	usr.machine = src
	src.add_fingerprint(usr)
	if(href_list["purify"])
		if (src.output)
			processing = 1;
			var/obj/item/ore/O
			processed = 0;
			while(locate(/obj/item/ore, input.loc))
				O = locate(/obj/item/ore, input.loc)
				if (istype(O,/obj/item/ore/iron))
					new /obj/item/stack/sheet/metal(output.loc)
					qdel(O)
				if (istype(O,/obj/item/ore/diamond))
					new /obj/item/stack/sheet/mineral/diamond(output.loc)
					qdel(O)
				if (istype(O,/obj/item/ore/plasma))
					new /obj/item/stack/sheet/mineral/plasma(output.loc)
					qdel(O)
				if (istype(O,/obj/item/ore/gold))
					new /obj/item/stack/sheet/mineral/gold(output.loc)
					qdel(O)
				if (istype(O,/obj/item/ore/silver))
					new /obj/item/stack/sheet/mineral/silver(output.loc)
					qdel(O)
				if (istype(O,/obj/item/ore/uranium))
					new /obj/item/ore/mineral/uranium(output.loc)
					qdel(O)
				/*if (istype(O,/obj/item/ore/adamantine))
					new /obj/item/ore/adamantine(output.loc)
					qdel(O)*/ //Dunno what this area does so I'll keep it commented out for now -Durandan
				processed++
				sleep(5);
			processing = 0;
	src.updateUsrDialog()
	return


/obj/machinery/mineral/purifier/New()
	..()
	spawn( 5 )
		for (var/dir in cardinal)
			src.input = locate(/obj/machinery/mineral/input, get_step(src, dir))
			if(src.input) break
		for (var/dir in cardinal)
			src.output = locate(/obj/machinery/mineral/output, get_step(src, dir))
			if(src.output) break
		return
	return
