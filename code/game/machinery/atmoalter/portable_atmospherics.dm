/obj/machinery/portable_atmospherics
	name = "atmoalter"
	use_power = 0
	var/datum/gas_mixture/air_contents = new

	var/obj/machinery/atmospherics/portables_connector/connected_port
	var/obj/item/tank/holding

	var/volume = 0
	var/destroyed = 0

	var/maximum_pressure = 90*ONE_ATMOSPHERE

	New()
		..()

		air_contents.volume = volume
		air_contents.temperature = T20C
		init_obj.Add(src)

		return 1

	initialize()
		. = ..()
		spawn()
			var/obj/machinery/atmospherics/portables_connector/port = locate() in loc
			if(port)
				connect(port)
				update_icon()

	process()
		if(!connected_port) //only react when pipe_network will ont it do it for you
			//Allow for reactions
			air_contents.react()
		else
			update_icon()

	Destroy()
		QDEL_NULL(air_contents)
		QDEL_NULL(holding)
		. = ..()

	update_icon()
		return null

	proc

		connect(obj/machinery/atmospherics/portables_connector/new_port)
			//Make sure not already connected to something else
			if(connected_port || !new_port || new_port.connected_device)
				return 0

			//Make sure are close enough for a valid connection
			if(new_port.loc != loc)
				return 0

			//Perform the connection
			connected_port = new_port
			connected_port.connected_device = src

			anchored = 1 //Prevent movement

			//Actually enforce the air sharing
			var/datum/pipe_network/network = connected_port.return_network(src)
			if(network && !network.gases.Find(air_contents))
				network.gases += air_contents
				network.update = 1

			return 1

		disconnect()
			if(!connected_port)
				return 0

			var/datum/pipe_network/network = connected_port.return_network(src)
			if(network)
				network.gases -= air_contents

			anchored = 0

			connected_port.connected_device = null
			connected_port = null

			return 1

/obj/machinery/portable_atmospherics/proc/update_connected_network()
	if(!connected_port)
		return

	var/datum/pipe_network/network = connected_port.return_network(src)
	if (network)
		network.update = 1

/obj/machinery/portable_atmospherics/attackby(var/obj/item/W as obj, var/mob/user as mob)
	var/obj/icon = src
	if ((istype(W, /obj/item/tank) && !( src.destroyed )))
		if (src.holding)
			return
		var/obj/item/tank/T = W
		user.drop_item()
		T.loc = src
		src.holding = T
		update_icon()
		return

	else if (istype(W, /obj/item/wrench))
		if(connected_port)
			disconnect()
			user << "\blue You disconnect [name] from the port."
			update_icon()
			return
		else
			var/obj/machinery/atmospherics/portables_connector/possible_port = locate(/obj/machinery/atmospherics/portables_connector/) in loc
			if(possible_port)
				if(connect(possible_port))
					user << "\blue You connect [name] to the port."
					update_icon()
					return
				else
					user << "\blue [name] failed to connect to the port."
					return
			else
				user << "\blue Nothing happens."
				return

	else if ((istype(W, /obj/item/device/analyzer)) && get_dist(user, src) <= 1)
		visible_message("\red [user] has used [W] on \icon[icon]")
		if(air_contents)
			var/pressure = air_contents.return_pressure()
			var/total_moles = air_contents.total_moles

			user << "\blue Results of analysis of \icon[icon]"
			if (total_moles>0)
				var/o2_concentration = air_contents.gas["oxygen"]/total_moles
				var/n2_concentration = air_contents.gas["nitrogen"]/total_moles
				var/co2_concentration = air_contents.gas["carbon_dioxide"]/total_moles
				var/plasma_concentration = air_contents.gas["plasma"]/total_moles

				var/unknown_concentration =  1-(o2_concentration+n2_concentration+co2_concentration+plasma_concentration)

				user << "\blue Pressure: [round(pressure,0.1)] kPa"
				user << "\blue Nitrogen: [round(n2_concentration*100)]%"
				user << "\blue Oxygen: [round(o2_concentration*100)]%"
				user << "\blue CO2: [round(co2_concentration*100)]%"
				user << "\blue Plasma: [round(plasma_concentration*100)]%"
				if(unknown_concentration>0.01)
					user << "\red Unknown: [round(unknown_concentration*100)]%"
				user << "\blue Temperature: [round(air_contents.temperature-T0C)]&deg;C"
			else
				user << "\blue Tank is empty!"
		else
			user << "\blue Tank is empty!"
		return

	return

/obj/machinery/portable_atmospherics/powered
	var/power_rating
	var/power_losses
	var/last_power_draw = 0
	var/obj/item/cell/cell

/obj/machinery/portable_atmospherics/powered/attackby(obj/item/I, mob/user)
	if(istype(I, /obj/item/cell))
		if(cell)
			user << "There is already a power cell installed."
			return

		var/obj/item/cell/C = I

		user.drop_item()
		C.add_fingerprint(user)
		cell = C
		C.loc = src
		user.visible_message("\blue [user] opens the panel on [src] and inserts [C].", "\blue You open the panel on [src] and insert [C].")
		return

	if(istype(I, /obj/item/screwdriver))
		if(!cell)
			user << "\red There is no power cell installed."
			return

		user.visible_message("\blue [user] opens the panel on [src] and removes [cell].", "\blue You open the panel on [src] and remove [cell].")
		cell.add_fingerprint(user)
		cell.loc = src.loc
		cell = null
		return

	..()

/obj/machinery/portable_atmospherics/proc/log_open()
	if(air_contents.gas.len == 0)
		return

	var/gases = ""
	for(var/gas in air_contents.gas)
		if(gases)
			gases += ", [gas]"
		else
			gases = gas
	log_admin("[usr] ([usr.ckey]) opened '[src.name]' containing [gases].")
	message_admins("[usr] ([usr.ckey]) opened '[src.name]' containing [gases].")
