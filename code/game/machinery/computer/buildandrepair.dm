//This file was auto-corrected by findeclaration.exe on 25.5.2012 20:42:31

/obj/structure/computerframe
	density = 1
	anchored = 0
	name = "computer frame"
	icon = 'icons/obj/stock_parts.dmi'
	icon_state = "0"
	var/state = 0
	var/obj/item/circuitboard/circuit = null
//	weight = 1.0E8

/obj/item/circuitboard
	density = 0
	anchored = 0
	w_class = 2.0
	name = "Circuit board"
	icon = 'icons/obj/module.dmi'
	icon_state = "id_mod"
	item_state = "electronic"
	origin_tech = "programming=2"
	var/id = null
	var/frequency = null
	var/build_path = null
	var/board_type = "computer"
	var/list/req_components = null
	var/powernet = null
	var/list/records = null
	var/frame_desc = null
	var/contain_parts = 1


/obj/item/circuitboard/message_monitor
	name = "Circuit board (Message Monitor)"
	build_path = "/obj/machinery/computer/message_monitor"
	origin_tech = "programming=3"

/obj/item/circuitboard/security
	name = "Circuit board (Security)"
	build_path = "/obj/machinery/computer/security"
	var/network = list("SS13")
	req_access = list(access_security)
	var/locked = 1
	var/emagged = 0

/obj/item/circuitboard/mining
	name = "circuit board (Outpost Status Display)"
	build_path = /obj/machinery/computer/security/mining

/obj/item/circuitboard/aicore
	name = "Circuit board (AI core)"
	origin_tech = "programming=4;biotech=2"
	board_type = "other"

/obj/item/circuitboard/aiupload
	name = "Circuit board (AI Upload)"
	build_path = "/obj/machinery/computer/aiupload"
	origin_tech = "programming=4"

/obj/item/circuitboard/borgupload
	name = "Circuit board (Cyborg Upload)"
	build_path = "/obj/machinery/computer/borgupload"
	origin_tech = "programming=4"

/obj/item/circuitboard/med_data
	name = "Circuit board (Medical Records)"
	build_path = "/obj/machinery/computer/med_data"

/obj/item/circuitboard/pandemic
	name = "Circuit board (PanD.E.M.I.C. 2200)"
	build_path = "/obj/machinery/computer/pandemic"
	origin_tech = "programming=2;biotech=2"

/obj/item/circuitboard/scan_consolenew
	name = "Circuit board (DNA Machine)"
	build_path = "/obj/machinery/computer/scan_consolenew"
	origin_tech = "programming=2;biotech=2"

/obj/item/circuitboard/communications
	name = "Circuit board (Communications)"
	build_path = "/obj/machinery/computer/communications"
	origin_tech = "programming=2;magnets=2"

/obj/item/circuitboard/card
	name = "Circuit board (ID Computer)"
	build_path = "/obj/machinery/computer/card"

/obj/item/circuitboard/card/centcom
	name = "Circuit board (CentCom ID Computer)"
	build_path = "/obj/machinery/computer/card/centcom"

//obj/item/circuitboard/shield
//	name = "Circuit board (Shield Control)"
//	build_path = "/obj/machinery/computer/stationshield"
/obj/item/circuitboard/teleporter
	name = "Circuit board (Teleporter)"
	build_path = "/obj/machinery/computer/teleporter"
	origin_tech = "programming=2;bluespace=2"

/obj/item/circuitboard/secure_data
	name = "Circuit board (Security Records)"
	build_path = "/obj/machinery/computer/secure_data"

/obj/item/circuitboard/stationalert
	name = "Circuit board (Station Alerts)"
	build_path = "/obj/machinery/computer/station_alert"

/obj/item/circuitboard/atmospheresiphonswitch
	name = "Circuit board (Atmosphere siphon control)"
	build_path = "/obj/machinery/computer/atmosphere/siphonswitch"

/obj/item/circuitboard/air_management
	name = "Circuit board (Atmospheric monitor)"
	build_path = "/obj/machinery/computer/general_air_control"

/obj/item/circuitboard/injector_control
	name = "Circuit board (Injector control)"
	build_path = "/obj/machinery/computer/general_air_control/fuel_injection"

/obj/item/circuitboard/atmos_alert
	name = "Circuit board (Atmospheric Alert)"
	build_path = "/obj/machinery/computer/atmos_alert"

/obj/item/circuitboard/pod
	name = "Circuit board (Massdriver control)"
	build_path = "/obj/machinery/computer/pod"

/obj/item/circuitboard/robotics
	name = "Circuit board (Robotics Control)"
	build_path = "/obj/machinery/computer/robotics"
	origin_tech = "programming=3"

/obj/item/circuitboard/cloning
	name = "Circuit board (Cloning)"
	build_path = "/obj/machinery/computer/cloning"
	origin_tech = "programming=3;biotech=3"

/obj/item/circuitboard/arcade
	name = "Circuit board (Arcade)"
	build_path = "/obj/machinery/computer/arcade"
	origin_tech = "programming=1"

/obj/item/circuitboard/turbine_control
	name = "Circuit board (Turbine control)"
	build_path = "/obj/machinery/computer/turbine_computer"

/obj/item/circuitboard/solar_control
	name = "Circuit board (Solar Control)"  //name fixed 250810
	build_path = "/obj/machinery/power/solar_control"
	origin_tech = "programming=2;powerstorage=2"

/obj/item/circuitboard/powermonitor
	name = "Circuit board (Power Monitor)"  //name fixed 250810
	build_path = "/obj/machinery/power/monitor"

/obj/item/circuitboard/olddoor
	name = "Circuit board (DoorMex)"
	build_path = "/obj/machinery/computer/pod/old"

/obj/item/circuitboard/syndicatedoor
	name = "Circuit board (ProComp Executive)"
	build_path = "/obj/machinery/computer/pod/old/syndicate"

/obj/item/circuitboard/swfdoor
	name = "Circuit board (Magix)"
	build_path = "/obj/machinery/computer/pod/old/swf"

/obj/item/circuitboard/prisoner
	name = "Circuit board (Prisoner Management)"
	build_path = "/obj/machinery/computer/prisoner"

/obj/item/circuitboard/rdconsole
	name = "Circuit Board (RD Console)"
	build_path = "/obj/machinery/computer/rdconsole/core"

/obj/item/circuitboard/mecha_control
	name = "Circuit Board (Exosuit Control Console)"
	build_path = "/obj/machinery/computer/mecha"

/obj/item/circuitboard/rdservercontrol
	name = "Circuit Board (R&D Server Control)"
	build_path = "/obj/machinery/computer/rdservercontrol"

/obj/item/circuitboard/crew
	name = "Circuit board (Crew monitoring computer)"
	build_path = "/obj/machinery/computer/crew"
	origin_tech = "programming=3;biotech=2;magnets=2"

/obj/item/circuitboard/mech_bay_power_console
	name = "Circuit board (Mech Bay Power Control Console)"
	build_path = "/obj/machinery/computer/mech_bay_power_console"
	origin_tech = "programming=2;powerstorage=3"

/obj/item/circuitboard/ordercomp
	name = "Circuit board (Supply ordering console)"
	build_path = "/obj/machinery/computer/ordercomp"
	origin_tech = "programming=2"

/obj/item/circuitboard/supplycomp
	name = "Circuit board (Supply shuttle console)"
	build_path = "/obj/machinery/computer/supplycomp"
	origin_tech = "programming=3"
	var/contraband_enabled = 0

/obj/item/circuitboard/research_shuttle
	name = "Circuit board (Research Shuttle)"
	build_path = "/obj/machinery/computer/research_shuttle"
	origin_tech = "programming=2"

/obj/item/circuitboard/operating
	name = "Circuit board (Operating Computer)"
	build_path = "/obj/machinery/computer/operating"
	origin_tech = "programming=2;biotech=2"

/obj/item/circuitboard/comm_monitor
	name = "Circuit board (Telecommunications Monitor)"
	build_path = "/obj/machinery/computer/telecomms/monitor"
	origin_tech = "programming=3"

/obj/item/circuitboard/comm_server
	name = "Circuit board (Telecommunications Server Monitor)"
	build_path = "/obj/machinery/computer/telecomms/server"
	origin_tech = "programming=3"

/obj/item/circuitboard/comm_traffic
	name = "Circuitboard (Telecommunications Traffic Control)"
	build_path = "/obj/machinery/computer/telecomms/traffic"
	origin_tech = "programming=3"

/obj/item/circuitboard/curefab
	name = "Circuit board (Cure fab)"
	build_path = "/obj/machinery/computer/curer"

/obj/item/circuitboard/splicer
	name = "Circuit board (Disease Splicer)"
	build_path = "/obj/machinery/computer/diseasesplicer"

/obj/item/circuitboard/mining_shuttle
	name = "Circuit board (Mining Shuttle)"
	build_path = "/obj/machinery/computer/mining_shuttle"
	origin_tech = "programming=2"

/obj/item/circuitboard/church_shuttle
	name = "Circuit board (Church Shuttle)"
	build_path = "/obj/machinery/computer/church_shuttle"
	origin_tech = "programming=2"

/obj/item/circuitboard/research_shuttle
	name = "Circuit board (Research Shuttle)"
	build_path = "/obj/machinery/computer/research_shuttle"
	origin_tech = "programming=2"

/obj/item/circuitboard/HolodeckControl // Not going to let people get this, but it's just here for future
	name = "Circuit board (Holodeck Control)"
	build_path = "/obj/machinery/computer/HolodeckControl"
	origin_tech = "programming=4"

/obj/item/circuitboard/aifixer
	name = "Circuit board (AI Integrity Restorer)"
	build_path = "/obj/machinery/computer/aifixer"
	origin_tech = "programming=3;biotech=2"

/obj/item/circuitboard/area_atmos
	name = "Circuit board (Area Air Control)"
	build_path = "/obj/machinery/computer/area_atmos"
	origin_tech = "programming=2"

/obj/item/circuitboard/prison_shuttle
	name = "Circuit board (Prison Shuttle)"
	build_path = "/obj/machinery/computer/prison_shuttle"
	origin_tech = "programming=2"

/obj/item/circuitboard/telesci_console
	name = "circuit board (Telescience Console)"
	build_path = /obj/machinery/computer/telescience
	origin_tech = "programming=3;bluespace=2"

/obj/item/circuitboard/ore_redemption
	name = "Machine Design (Ore Redemption Board)"
	build_path = /obj/item/circuitboard/ore_redemption
	origin_tech = "programming=1;engineering=2"

/obj/item/circuitboard/mining_equipment_vendor
	name = "Machine Design (Mining Rewards Vender Board)"
	build_path = /obj/item/circuitboard/mining_equipment_vendor
	origin_tech = "programming=1;engineering=2"

/obj/item/circuitboard/helm
	name = "Circuit board (Helm Control)"
	build_path = "/obj/machinery/computer/helm"
	origin_tech = "programming=4;magnets=4"

/obj/item/circuitboard/propulsion_control
	name = "Circuit board (Propulsion Control)"
	build_path = "/obj/machinery/computer/engines/constructed"
	origin_tech = "programming=2;magnets=4"

/obj/item/circuitboard/supplycomp/attackby(obj/item/I as obj, mob/user as mob)
	if(istype(I,/obj/item/device/multitool))
		var/catastasis = src.contraband_enabled
		var/opposite_catastasis
		if(catastasis)
			opposite_catastasis = "STANDARD"
			catastasis = "BROAD"
		else
			opposite_catastasis = "BROAD"
			catastasis = "STANDARD"

		switch( alert("Current receiver spectrum is set to: [catastasis]","Multitool-Circuitboard interface","Switch to [opposite_catastasis]","Cancel") )
		//switch( alert("Current receiver spectrum is set to: " {(src.contraband_enabled) ? ("BROAD") : ("STANDARD")} , "Multitool-Circuitboard interface" , "Switch to " {(src.contraband_enabled) ? ("STANDARD") : ("BROAD")}, "Cancel") )
			if("Switch to STANDARD","Switch to BROAD")
				src.contraband_enabled = !src.contraband_enabled

			if("Cancel")
				return
			else
				user << "DERP! BUG! Report this (And what you were doing to cause it) to Agouri"
	return

/obj/item/circuitboard/security/attackby(obj/item/I as obj, mob/user as mob)
	if(istype(I,/obj/item/card/emag))
		if(emagged)
			user << "Circuit lock is already removed."
			return
		user << "\blue You override the circuit lock and open controls."
		emagged = 1
		locked = 0
	else if(istype(I,/obj/item/card/id))
		if(emagged)
			user << "\red Circuit lock does not respond."
			return
		if(check_access(I))
			locked = !locked
			user << "\blue You [locked ? "" : "un"]lock the circuit controls."
		else
			user << "\red Access denied."
	else if(istype(I,/obj/item/device/multitool))
		if(locked)
			user << "\red Circuit controls are locked."
			return
		var/existing_networks = list2text(network,",")
		var/input = sanitize(input(usr, "Which networks would you like to connect this camera console circuit to? Seperate networks with a comma. No Spaces!\nFor example: SS13,Security,Secret ", "Multitool-Circuitboard interface", existing_networks))
		if(!input)
			usr << "No input found please hang up and try your call again."
			return
		var/list/tempnetwork = text2list(input, ",")
		tempnetwork = difflist(tempnetwork,RESTRICTED_CAMERA_NETWORKS,1)
		if(tempnetwork.len < 1)
			usr << "No network found please hang up and try your call again."
			return
		network = tempnetwork
	return

/obj/item/circuitboard/rdconsole/attackby(obj/item/I as obj, mob/user as mob)
	if(istype(I,/obj/item/screwdriver))
		if(src.build_path == "/obj/machinery/computer/rdconsole/core")
			src.name = "Circuit Board (RD Console - Robotics)"
			src.build_path = "/obj/machinery/computer/rdconsole/robotics"
			user << "\blue Access protocols succesfully updated."
		else
			src.name = "Circuit Board (RD Console)"
			src.build_path = "/obj/machinery/computer/rdconsole/core"
			user << "\blue Defaulting access protocols."
	return

/obj/structure/computerframe/attackby(obj/item/P as obj, mob/user as mob)
	switch(state)
		if(0)
			if(istype(P, /obj/item/wrench))
				playsound(src.loc, 'sound/items/Ratchet.ogg', 50, 1)
				user << "<span class='notice'>You start wrenching the frame into place.</span>"
				if(do_after(user, 20))
					user << "<span class='notice'>You've wrenched the frame into place.</span>"
					anchored = 1
					state = 1
			if(istype(P, /obj/item/weldingtool))
				var/obj/item/weldingtool/WT = P
				if(!WT.remove_fuel(0, user))
					user << "<span class='warning'>The welding tool must be on to complete this task.</span>"
					return
				playsound(src.loc, 'sound/items/Welder.ogg', 50, 1)
				user << "<span class='notice'>You start deconstructing the frame.</span>"
				if(do_after(user, 20))
					if(!src || !WT.isOn()) return
					user << "<span class='notice'>You've deconstructed the frame.</span>"
					new /obj/item/stack/sheet/metal( src.loc, 5 )
					qdel(src)
		if(1)
			if(istype(P, /obj/item/wrench))
				playsound(src.loc, 'sound/items/Ratchet.ogg', 50, 1)
				user << "<span class='notice'>You start to unfasten the frame.</span>"
				if(do_after(user, 20))
					user << "<span class='notice'>You've unfastened the frame.</span>"
					anchored = 0
					state = 0
			if(istype(P, /obj/item/circuitboard) && !circuit)
				var/obj/item/circuitboard/B = P
				if(B.board_type == "computer")
					playsound(src.loc, 'sound/items/Deconstruct.ogg', 50, 1)
					user << "\blue You place the circuit board inside the frame."
					src.icon_state = "1"
					src.circuit = P
					user.drop_item()
					P.loc = src
				else
					user << "\red This frame does not accept circuit boards of this type!"
			if(istype(P, /obj/item/screwdriver) && circuit)
				playsound(src.loc, 'sound/items/Screwdriver.ogg', 50, 1)
				user << "<span class='notice'>You screw the circuit board into place.</span>"
				src.state = 2
				src.icon_state = "2"
			if(istype(P, /obj/item/crowbar) && circuit)
				playsound(src.loc, 'sound/items/Crowbar.ogg', 50, 1)
				user << "<span class='notice'>You remove the circuit board.</span>"
				src.state = 1
				src.icon_state = "0"
				circuit.loc = src.loc
				src.circuit = null
		if(2)
			if(istype(P, /obj/item/screwdriver) && circuit)
				playsound(src.loc, 'sound/items/Screwdriver.ogg', 50, 1)
				user << "<span class='notice'>You unfasten the circuit board.</span>"
				src.state = 1
				src.icon_state = "1"
			if(istype(P, /obj/item/stack/cable_coil))
				if(P:amount >= 5)
					playsound(src.loc, 'sound/items/Deconstruct.ogg', 50, 1)
					user << "<span class='notice'>You start adding cables to the frame.</span>"
					if(do_after(user, 20))
						if(P)
							P:amount -= 5
							if(!P:amount) qdel(P)
							user << "<span class='notice'>You've added cables to the frame.</span>"
							src.state = 3
							src.icon_state = "3"
				else
					user << "<span class='warning'>You need five lengths of cable to wire the frame.</span>"
		if(3)
			if(istype(P, /obj/item/wirecutters))
				playsound(src.loc, 'sound/items/Wirecutter.ogg', 50, 1)
				user << "<span class='notice'>You remove the cables.</span>"
				src.state = 2
				src.icon_state = "2"
				new /obj/item/stack/cable_coil(src.loc, 5)

			if(istype(P, /obj/item/stack/sheet/glass))
				var/obj/item/stack/sheet/glass/G = P
				if(G.get_amount() < 2)
					user << "<span class='warning'>You need two glass sheets to continue construction.</span>"
					return
				else
					playsound(src.loc, 'sound/items/Deconstruct.ogg', 50, 1)
					user << "<span class='notice'>You start to put in the glass panel.</span>"
					if(do_after(user, 20))
						if(state == 3 && G.use(2))
							user << "<span class='notice'>You've put in the glass panel.</span>"
							state = 4
							src.icon_state = "4"
		if(4)
			if(istype(P, /obj/item/crowbar))
				playsound(src.loc, 'sound/items/Crowbar.ogg', 50, 1)
				user << "<span class='notice'>You remove the glass panel.</span>"
				src.state = 3
				src.icon_state = "3"
				new /obj/item/stack/sheet/glass( src.loc, 2 )
			if(istype(P, /obj/item/screwdriver))
				playsound(src.loc, 'sound/items/Screwdriver.ogg', 50, 1)
				user << "<span class='notice'>You connect the monitor.</span>"
				var/B = new src.circuit.build_path(src.loc, src.circuit)
				circuit.loc = B
				if(circuit.powernet) B:powernet = circuit.powernet
				if(circuit.id) B:id = circuit.id
				if(circuit.records) B:records = circuit.records
				if(circuit.frequency) B:frequency = circuit.frequency
				if(istype(circuit,/obj/item/circuitboard/supplycomp))
					var/obj/machinery/computer/supplycomp/SC = B
					var/obj/item/circuitboard/supplycomp/C = circuit
					SC.can_order_contraband = C.contraband_enabled
				if(istype(circuit,/obj/item/circuitboard/security))
					var/obj/machinery/computer/security/C = B
					var/obj/item/circuitboard/security/CB = circuit
					C.network = CB.network
				qdel(src)