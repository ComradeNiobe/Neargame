//This file was auto-corrected by findeclaration.exe on 25.5.2012 20:42:33

/* new portable generator - work in progress

/obj/machinery/power/port_gen
	name = "portable generator"
	desc = "A portable generator used for emergency backup power."
	icon = 'generator.dmi'
	icon_state = "off"
	density = 1
	anchored = 0
	directwired = 0
	var/t_status = 0
	var/t_per = 5000
	var/d_filter = 1
	var/tank = null
	var/turf/inturf
	var/starter = 0
	var/rpm = 0
	var/rpmtarget = 0
	var/capacity = 1e6
	var/turf/outturf
	var/lastgen


/obj/machinery/power/port_gen/process()
ideally we're looking to generate 5000

/obj/machinery/power/port_gen/attackby(obj/item/W, mob/user)
tank [un]loading stuff

/obj/machinery/power/port_gen/attack_hand(mob/user)
turn on/off

/obj/machinery/power/port_gen/examine()
display round(lastgen) and plasmatank amount

*/

//Previous code been here forever, adding new framework for portable generators


//Baseline portable generator. Has all the default handling. Not intended to be used on it's own (since it generates unlimited power).
/obj/machinery/power/port_gen
	name = "Portable Generator"
	desc = "A portable generator for emergency backup power"
	icon = 'icons/obj/power.dmi'
	icon_state = "portgen0"
	density = 1
	anchored = 0
	directwired = 0
	use_power = 0

	var/active = 0
	var/power_gen = 5000
	var/open = 0
	var/recent_fault = 0
	var/power_output = 1

/obj/machinery/power/port_gen/proc/HasFuel() //Placeholder for fuel check.
	return 1

/obj/machinery/power/port_gen/proc/UseFuel() //Placeholder for fuel use.
	return

/obj/machinery/power/port_gen/proc/DropFuel()
	return

/obj/machinery/power/port_gen/proc/handleInactive()
	return

/obj/machinery/power/port_gen/process()
	if(active && HasFuel() && !crit_fail && anchored && powernet)
		add_avail(power_gen * power_output)
		UseFuel()
		src.updateDialog()

	else
		active = 0
		icon_state = initial(icon_state)
		handleInactive()

/obj/machinery/power/port_gen/attack_hand(mob/user as mob)
	if(..())
		return
	if(!anchored)
		return

/obj/machinery/power/port_gen/examine()
	set src in oview(1)
	if(active)
		usr << "\blue The generator is on."
	else
		usr << "\blue The generator is off."

/obj/machinery/power/port_gen/pacman
	name = "P.A.C.M.A.N.-type Portable Generator"
	var/sheets = 0
	var/max_sheets = 100
	var/sheet_name = ""
	var/sheet_path = /obj/item/stack/sheet/mineral/plasma
	var/board_path = "/obj/item/circuitboard/pacman"
	var/sheet_left = 0 // How much is left of the sheet
	var/time_per_sheet = 40
	var/heat = 0
	New()
		..()
		init_obj.Add(src)

/obj/machinery/power/port_gen/pacman/initialize()
	..()
	if(anchored)
		connect_to_network()

/obj/machinery/power/port_gen/pacman/New()
	..()
	component_parts = list()
	component_parts += new /obj/item/stock_parts/matter_bin(src)
	component_parts += new /obj/item/stock_parts/micro_laser(src)
	component_parts += new /obj/item/stack/cable_coil(src)
	component_parts += new /obj/item/stack/cable_coil(src)
	component_parts += new /obj/item/stock_parts/capacitor(src)
	component_parts += new board_path(src)
	var/obj/sheet = new sheet_path(null)
	sheet_name = sheet.name
	RefreshParts()

/obj/machinery/power/port_gen/pacman/Destroy()
	DropFuel()
	..()

/obj/machinery/power/port_gen/pacman/RefreshParts()
	var/temp_rating = 0
	var/temp_reliability = 0
	for(var/obj/item/stock_parts/SP in component_parts)
		if(istype(SP, /obj/item/stock_parts/matter_bin))
			max_sheets = SP.rating * SP.rating * 50
		else if(istype(SP, /obj/item/stock_parts/micro_laser) || istype(SP, /obj/item/stock_parts/capacitor))
			temp_rating += SP.rating
	for(var/obj/item/CP in component_parts)
		temp_reliability += CP.reliability
	reliability = min(round(temp_reliability / 4), 100)
	power_gen = round(initial(power_gen) * (max(2, temp_rating) / 2))

/obj/machinery/power/port_gen/pacman/examine()
	..()
	usr << "\blue The generator has [sheets] units of [sheet_name] fuel left, producing [power_gen] per cycle."
	if(crit_fail) usr << "\red The generator seems to have broken down."

/obj/machinery/power/port_gen/pacman/HasFuel()
	if(sheets >= 1 / (time_per_sheet / power_output) - sheet_left)
		return 1
	return 0

/obj/machinery/power/port_gen/pacman/DropFuel()
	if(sheets)
		var/fail_safe = 0
		while(sheets > 0 && fail_safe < 100)
			fail_safe += 1
			var/obj/item/stack/sheet/S = new sheet_path(loc)
			var/amount = min(sheets, S.max_amount)
			S.amount = amount
			sheets -= amount

/obj/machinery/power/port_gen/pacman/UseFuel()
	var/needed_sheets = 1 / (time_per_sheet / power_output)
	var/temp = min(needed_sheets, sheet_left)
	needed_sheets -= temp
	sheet_left -= temp
	sheets -= round(needed_sheets)
	needed_sheets -= round(needed_sheets)
	if (sheet_left <= 0 && sheets > 0)
		sheet_left = 1 - needed_sheets
		sheets--

	var/lower_limit = 56 + power_output * 10
	var/upper_limit = 76 + power_output * 10
	var/bias = 0
	if (power_output > 4)
		upper_limit = 400
		bias = power_output * 3
	if (heat < lower_limit)
		heat += 3
	else
		heat += rand(-7 + bias, 7 + bias)
		if (heat < lower_limit)
			heat = lower_limit
		if (heat > upper_limit)
			heat = upper_limit

	if (heat > 300)
		overheat()
		qdel(src)
	return

/obj/machinery/power/port_gen/pacman/handleInactive()

	if (heat > 0)
		heat = max(heat - 2, 0)
		src.updateDialog()

/obj/machinery/power/port_gen/pacman/proc/overheat()
	explosion(src.loc, 2, 5, 2, -1)

/obj/machinery/power/port_gen/pacman/attackby(var/obj/item/O as obj, var/mob/user as mob)
	if(istype(O, sheet_path))
		var/obj/item/stack/addstack = O
		var/amount = min((max_sheets - sheets), addstack.amount)
		if(amount < 1)
			user << "\blue The [src.name] is full!"
			return
		user << "\blue You add [amount] sheets to the [src.name]."
		sheets += amount
		addstack.use(amount)
		updateUsrDialog()
		return
	else if (istype(O, /obj/item/card/emag))
		emagged = 1
		emp_act(1)
	else if(!active)

		if(istype(O, /obj/item/wrench))

			if(!anchored)
				connect_to_network()
				user << "\blue You secure the generator to the floor."
			else
				disconnect_from_network()
				user << "\blue You unsecure the generator from the floor."

			playsound(src.loc, 'sound/items/Deconstruct.ogg', 50, 1)
			anchored = !anchored

		else if(istype(O, /obj/item/screwdriver))
			open = !open
			playsound(src.loc, 'sound/items/Screwdriver.ogg', 50, 1)
			if(open)
				user << "\blue You open the access panel."
			else
				user << "\blue You close the access panel."
		else if(istype(O, /obj/item/crowbar) && open)
			var/obj/machinery/constructable_frame/machine_frame/new_frame = new /obj/machinery/constructable_frame/machine_frame(src.loc)
			for(var/obj/item/I in component_parts)
				if(I.reliability < 100)
					I.crit_fail = 1
				I.loc = src.loc
			while ( sheets > 0 )
				var/obj/item/stack/sheet/G = new sheet_path(src.loc)

				if ( sheets > 50 )
					G.amount = 50
				else
					G.amount = sheets

				sheets -= G.amount

			new_frame.state = 2
			new_frame.icon_state = "box_1"
			qdel(src)

/obj/machinery/power/port_gen/pacman/attack_hand(mob/user as mob)
	..()
	if (!anchored)
		return

	interact(user)

/obj/machinery/power/port_gen/pacman/attack_ai(mob/user as mob)
	interact(user)

/obj/machinery/power/port_gen/pacman/attack_paw(mob/user as mob)
	interact(user)

/obj/machinery/power/port_gen/pacman/interact(mob/user)
	if (get_dist(src, user) > 1 )
		if (!istype(user, /mob/living/silicon/ai))
			user.unset_machine()
			user << browse(null, "window=port_gen")
			return

	user.set_machine(src)

	var/dat = text("<b>[name]</b><br>")
	if (active)
		dat += text("Generator: <A href='byond://?src=\ref[src];action=disable'>On</A><br>")
	else
		dat += text("Generator: <A href='byond://?src=\ref[src];action=enable'>Off</A><br>")
	dat += text("[capitalize(sheet_name)]: [sheets] - <A href='byond://?src=\ref[src];action=eject'>Eject</A><br>")
	var/stack_percent = round(sheet_left * 100, 1)
	dat += text("Current stack: [stack_percent]% <br>")
	dat += text("Power output: <A href='byond://?src=\ref[src];action=lower_power'>-</A> [power_gen * power_output] <A href='byond://?src=\ref[src];action=higher_power'>+</A><br>")
	dat += text("Power current: [(powernet == null ? "Unconnected" : "[avail()]")]<br>")
	dat += text("Heat: [heat]<br>")
	dat += "<br><A href='byond://?src=\ref[src];action=close'>Close</A>"
	user << browse("[dat]", "window=port_gen")
	onclose(user, "port_gen")

/obj/machinery/power/port_gen/pacman/Topic(href, href_list)
	if(..())
		return

	src.add_fingerprint(usr)
	if(href_list["action"])
		if(href_list["action"] == "enable")
			if(!active && HasFuel() && !crit_fail)
				active = 1
				icon_state = "portgen1"
				src.updateUsrDialog()
		if(href_list["action"] == "disable")
			if (active)
				active = 0
				icon_state = "portgen0"
				src.updateUsrDialog()
		if(href_list["action"] == "eject")
			if(!active)
				DropFuel()
				src.updateUsrDialog()
		if(href_list["action"] == "lower_power")
			if (power_output > 1)
				power_output--
				src.updateUsrDialog()
		if (href_list["action"] == "higher_power")
			if (power_output < 4 || emagged)
				power_output++
				src.updateUsrDialog()
		if (href_list["action"] == "close")
			usr << browse(null, "window=port_gen")
			usr.unset_machine()

/obj/machinery/power/port_gen/pacman/super
	name = "S.U.P.E.R.P.A.C.M.A.N.-type Portable Generator"
	icon_state = "portgen1"
	sheet_path = /obj/item/stack/sheet/mineral/uranium
	power_gen = 15000
	time_per_sheet = 65
	board_path = "/obj/item/circuitboard/pacman/super"
	overheat()
		explosion(src.loc, 3, 3, 3, -1)

/obj/machinery/power/port_gen/pacman/mrs
	name = "M.R.S.P.A.C.M.A.N.-type Portable Generator"
	icon_state = "portgen2"
	sheet_path = /obj/item/stack/sheet/mineral/diamond
	power_gen = 40000
	time_per_sheet = 80
	board_path = "/obj/item/circuitboard/pacman/mrs"
	overheat()
		explosion(src.loc, 4, 4, 4, -1)

/obj/machinery/power/port_gen/pacman/bottom
	name = "geothermal bottom generator"
	icon = 'icons/life/heatmachine.dmi'
	icon_state = ""
	sheet_path = /obj/item/stack/sheet/mineral/snow
	power_gen = 20000
	time_per_sheet = 80
	anchored = 1
	board_path = "/obj/item/circuitboard/pacman"
	overheat()
		explosion(src.loc, 4, 4, 4, -1)

/obj/machinery/power/port_gen/pacman/bottom/left
	icon_state = "lower_off"
	dir = SOUTH

/obj/machinery/power/port_gen/pacman/bottom/left/Click(location, control, params)
	var/list/P = params2list(params)
	var/icon_x = text2num(P["icon-x"])
	var/icon_y = text2num(P["icon-y"])
	switch(icon_x)
		if(17 to 25)
			switch(icon_y)
				if(21 to 31)
					return


/obj/machinery/power/port_gen/pacman/bottom/right
	icon_state = "lower_off"
	dir = NORTH

/obj/machinery/power/port_gen/pacman/top/left
	icon = 'icons/life/heatmachine.dmi'
	icon_state = "upper"
	dir = SOUTH
	anchored = 1


/obj/machinery/power/port_gen/pacman/top/right
	icon = 'icons/life/heatmachine.dmi'
	icon_state = "upper"
	dir = NORTH
	anchored = 1