/obj/machinery/atmospherics/unary/cold_sink/freezer
	name = "freezer"
	icon = 'icons/obj/Cryogenic2.dmi'
	icon_state = "freezer"
	density = 1
	var/min_temperature = 0
	anchored = 1.0
	use_power = 1
	current_heat_capacity = 1000

/obj/machinery/atmospherics/unary/cold_sink/freezer/New()
	..()
	initialize_directions = dir
	component_parts = list()
	component_parts += new /obj/item/circuitboard/thermomachine(null)
	component_parts += new /obj/item/stock_parts/matter_bin(null)
	component_parts += new /obj/item/stock_parts/matter_bin(null)
	component_parts += new /obj/item/stock_parts/micro_laser(null)
	component_parts += new /obj/item/stock_parts/micro_laser(null)
	component_parts += new /obj/item/stock_parts/console_screen(null)
	component_parts += new /obj/item/stack/cable_coil(null, 1)
	RefreshParts()

/obj/machinery/atmospherics/unary/cold_sink/freezer/RefreshParts()
	var/H
	var/T
	for(var/obj/item/stock_parts/matter_bin/M in component_parts)
		H += M.rating
	for(var/obj/item/stock_parts/micro_laser/M in component_parts)
		T += M.rating
	min_temperature = T0C - (170 + (T*15))
	current_heat_capacity = 1000 * ((H - 1) ** 2)

/obj/machinery/atmospherics/unary/cold_sink/freezer/attackby(obj/item/I, mob/user)
	if(default_deconstruction_screwdriver(user, "freezer-o", "freezer", I))
		on = 0
		update_icon()
		return

	if(exchange_parts(user, I))
		return user << "<span class='warning'>It would be very stupid to do it, because the engine is running</span>"

	default_deconstruction_crowbar(I)

	if(default_change_direction_wrench(user, I))
		return

/obj/machinery/atmospherics/unary/cold_sink/freezer/update_icon()
	if(panel_open)
		icon_state = "freezer-o"
	else if(src.on)
		icon_state = "freezer_1"
	else
		icon_state = "freezer"
	return

/obj/machinery/atmospherics/unary/cold_sink/freezer/attack_ai(mob/user as mob)
	return interact(user)

/obj/machinery/atmospherics/unary/cold_sink/freezer/attack_paw(mob/user as mob)
	return interact(user)

/obj/machinery/atmospherics/unary/cold_sink/freezer/attack_hand(mob/user as mob)
	return interact(user)

/obj/machinery/atmospherics/unary/cold_sink/freezer/interact(mob/user)
	if(stat & (NOPOWER|BROKEN))
		return
	user.set_machine(src)
	var/temp_text = ""
	if(air_contents.temperature > (T0C - 20))
		temp_text = "<span class='bad'>[air_contents.temperature]</span>"
	else if(air_contents.temperature < (T0C - 20) && air_contents.temperature > (T0C - 100))
		temp_text = "<span class='average'>[air_contents.temperature]</span>"
	else
		temp_text = "<span class='good'>[air_contents.temperature]</span>"

	var/dat = {"
	Current Status: [ on ? "<A href='byond://?src=\ref[src];start=1'>Off</A> <span class='linkOn'>On</span>" : "<span class='linkOn'>Off</span> <A href='byond://?src=\ref[src];start=1'>On</A>"]<BR>
	Current Gas Temperature: [temp_text]<BR>
	Current Air Pressure: [air_contents.return_pressure()]<BR>
	Target Gas Temperature: <A href='byond://?src=\ref[src];temp=-100'>-</A> <A href='byond://?src=\ref[src];temp=-10'>-</A> <A href='byond://?src=\ref[src];temp=-1'>-</A> [current_temperature] <A href='byond://?src=\ref[src];temp=1'>+</A> <A href='byond://?src=\ref[src];temp=10'>+</A> <A href='byond://?src=\ref[src];temp=100'>+</A><BR>
	"}

	//user << browse(dat, "window=freezer;size=400x500")
	//onclose(user, "freezer")
	var/datum/browser/popup = new(user, "freezer", "Cryo Gas Cooling System", 400, 240) // Set up the popup browser window
	popup.set_content(dat)
	popup.open()

/obj/machinery/atmospherics/unary/cold_sink/freezer/Topic(href, href_list)
	if(..())
		return
	usr.set_machine(src)
	if (href_list["start"])
		src.on = !src.on
		update_icon()
	if(href_list["temp"])
		var/amount = text2num(href_list["temp"])
		if(amount > 0)
			src.current_temperature = min(T20C, src.current_temperature+amount)
		else
			src.current_temperature = max(min_temperature, src.current_temperature+amount)
	src.updateUsrDialog()

/obj/machinery/atmospherics/unary/cold_sink/freezer/process()
	..()
	src.updateUsrDialog()

/obj/machinery/atmospherics/unary/cold_sink/freezer/power_change()
	..()
	if(stat & NOPOWER)
		on = 0
		update_icon()


/obj/machinery/atmospherics/unary/heat_reservoir/heater/
	name = "heater"
	icon = 'icons/obj/Cryogenic2.dmi'
	icon_state = "heater"
	density = 1
	var/max_temperature = 0
	anchored = 1.0

	current_heat_capacity = 1000

/obj/machinery/atmospherics/unary/heat_reservoir/heater/New()
	..()
	initialize_directions = dir
	var/obj/item/circuitboard/thermomachine/H = new /obj/item/circuitboard/thermomachine(null)
	H.build_path = /obj/machinery/atmospherics/unary/heat_reservoir/heater
	H.name = "circuit board (Heater)"
	component_parts = list()
	component_parts += H
	component_parts += new /obj/item/stock_parts/matter_bin(null)
	component_parts += new /obj/item/stock_parts/matter_bin(null)
	component_parts += new /obj/item/stock_parts/micro_laser(null)
	component_parts += new /obj/item/stock_parts/micro_laser(null)
	component_parts += new /obj/item/stock_parts/console_screen(null)
	component_parts += new /obj/item/stack/cable_coil(null, 1)
	RefreshParts()

/obj/machinery/atmospherics/unary/heat_reservoir/heater/RefreshParts()
	var/H
	var/T
	for(var/obj/item/stock_parts/matter_bin/M in component_parts)
		H += M.rating
	for(var/obj/item/stock_parts/micro_laser/M in component_parts)
		T += M.rating
	max_temperature = T20C + (140 * T)
	current_heat_capacity = 1000 * ((H - 1) ** 2)

/obj/machinery/atmospherics/unary/heat_reservoir/heater/attackby(obj/item/I, mob/user)
	if(default_deconstruction_screwdriver(user, "heater-o", "heater", I))
		on = 0
		update_icon()
		return

	if(exchange_parts(user, I))
		return

	default_deconstruction_crowbar(I)

	if(default_change_direction_wrench(user, I))
		return

/obj/machinery/atmospherics/unary/heat_reservoir/heater/update_icon()
	if(panel_open)
		icon_state = "heater-o"
	else if(src.on)
		icon_state = "heater_1"
	else
		icon_state = "heater"
	return

/obj/machinery/atmospherics/unary/heat_reservoir/heater/attack_ai(mob/user as mob)
	return src.attack_hand(user)

/obj/machinery/atmospherics/unary/heat_reservoir/heater/attack_paw(mob/user as mob)
	return src.attack_hand(user)

/obj/machinery/atmospherics/unary/heat_reservoir/heater/attack_hand(mob/user as mob)
	return interact(user)

/obj/machinery/atmospherics/unary/heat_reservoir/heater/interact(mob/user)
	if(stat & (NOPOWER|BROKEN))
		return
	user.set_machine(src)
	var/temp_text = ""
	if(air_contents.temperature < (T20C + 80))
		temp_text = "<span class='good'>[air_contents.temperature]</span>"
	else if(air_contents.temperature > (T20C + 80) && air_contents.temperature < (T20C + 180))
		temp_text = "<span class='average'>[air_contents.temperature]</span>"
	else
		temp_text = "<span class='bad'>[air_contents.temperature]</span>"

	var/dat = {"
	Current Status: [ on ? "<A href='byond://?src=\ref[src];start=1'>Off</A> <span class='linkOn'>On</span>" : "<span class='linkOn'>Off</span> <A href='byond://?src=\ref[src];start=1'>On</A>"]<BR>
	Current Gas Temperature: [temp_text]<BR>
	Current Air Pressure: [air_contents.return_pressure()]<BR>
	Target Gas Temperature: <A href='byond://?src=\ref[src];temp=-100'>-</A> <A href='byond://?src=\ref[src];temp=-10'>-</A> <A href='byond://?src=\ref[src];temp=-1'>-</A> [current_temperature] <A href='byond://?src=\ref[src];temp=1'>+</A> <A href='byond://?src=\ref[src];temp=10'>+</A> <A href='byond://?src=\ref[src];temp=100'>+</A><BR>
	"}

	//user << browse(dat, "window=freezer;size=400x500")
	//onclose(user, "freezer")
	var/datum/browser/popup = new(user, "freezer", "Cryo Gas Cooling System", 400, 240) // Set up the popup browser window
	popup.set_content(dat)
	popup.open()

/obj/machinery/atmospherics/unary/heat_reservoir/heater/Topic(href, href_list)
	if(..())
		return
	usr.set_machine(src)
	if (href_list["start"])
		src.on = !src.on
		update_icon()
	if(href_list["temp"])
		var/amount = text2num(href_list["temp"])
		if(amount > 0)
			src.current_temperature = min((T20C+max_temperature), src.current_temperature+amount)
		else
			src.current_temperature = max(T20C, src.current_temperature+amount)
	src.updateUsrDialog()
	src.add_fingerprint(usr)
	return

/obj/machinery/atmospherics/unary/heat_reservoir/heater/process()
	..()
	src.updateUsrDialog()

/obj/machinery/atmospherics/unary/heat_reservoir/heater/power_change()
	..()
	if(stat & NOPOWER)
		on = 0
		update_icon()