/datum/data/vending_product
	var/product_name = "generic"
	var/product_path = null
	var/amount = 0
	var/price = 0
	var/max_amount = 0
	var/display_color = "blue"



/obj/machinery/vending
	name = "Vendomat"
	desc = "A generic vending machine."
	icon = 'icons/obj/vending.dmi'
	icon_state = "generic"
	layer = 2.9
	anchored = 1
	density = 1
	var/active = 1 //No sales pitches if off!
	var/vend_ready = 1 //Are we ready to vend?? Is it time??
	var/vend_delay = 10 //How long does it take to vend?
	var/datum/data/vending_product/currently_vending = null // A /datum/data/vending_product instance of what we're paying for right now.

	// To be filled out at compile time
	var/list/products	= list() // For each, use the following pattern:
	var/list/contraband	= list() // list(/type/path = amount,/type/path2 = amount2)
	var/list/premium 	= list() // No specified amount = only one in stock
	var/list/prices     = list() // Prices for each item, list(/type/path = price), items not in the list don't have a price.

	var/product_slogans = "" //String of slogans separated by semicolons, optional
	var/product_ads = "" //String of small ad messages in the vending screen - random chance
	var/list/product_records = list()
	var/list/hidden_records = list()
	var/list/coin_records = list()
	var/list/slogan_list = list()
	var/list/small_ads = list() // small ad messages in the vending screen - random chance of popping up whenever you open it
	var/obols_stored = 0
	var/vend_reply //Thank you for shopping!
	var/last_reply = 0
	var/last_slogan = 0 //When did we last pitch?
	var/slogan_delay = 6000 //How long until we can pitch again?
	var/icon_vend //Icon_state when vending!
	var/icon_deny //Icon_state when vending!
	//var/emagged = 0 //Ignores if somebody doesn't have card access to that machine.
	var/seconds_electrified = 0 //Shock customers like an airlock.
	var/shoot_inventory = 0 //Fire items at customers! We're broken!
	var/shut_up = 1 //Stop spouting those godawful pitches!
	var/extended_inventory = 0 //can we access the hidden inventory?
	var/wires = 15
	var/obj/item/coin/coin
	var/const/WIRE_EXTEND = 1
	var/const/WIRE_SCANID = 2
	var/const/WIRE_SHOCK = 3
	var/const/WIRE_SHOOTINV = 4

	var/check_accounts = 1		// 1 = requires PIN and checks accounts.  0 = You slide an ID, it vends, SPACE COMMUNISM!

	var/obj/item/vending_refill/refill_canister = null		//The type of refill canisters used by this machine.


/obj/machinery/vending/New()
	..()
	spawn(4)
		src.slogan_list = text2list(src.product_slogans, ";")

		// So not all machines speak at the exact same time.
		// The first time this machine says something will be at slogantime + this random value,
		// so if slogantime is 10 minutes, it will say it at somewhere between 10 and 20 minutes after the machine is crated.
		src.last_slogan = world.time + rand(0, slogan_delay)

	if(refill_canister) //constructable vending machine
		component_parts = list()
		component_parts += new refill_canister
		component_parts += new refill_canister
		component_parts += new refill_canister
		RefreshParts()
	else
		build_inventory(products)
		build_inventory(contraband, 1)
		build_inventory(premium, 0, 1)
		power_change()

		return

	return



/obj/machinery/vending/RefreshParts()         //Better would be to make constructable child
	if(component_parts)
		product_records = list()
		hidden_records = list()
		coin_records = list()
		build_inventory(products, start_empty = 1)
		build_inventory(contraband, 1, start_empty = 1)
		build_inventory(premium, 0, 1, start_empty = 1)
		for(var/obj/item/vending_refill/VR in component_parts)
			refill_inventory(VR, product_records)


/obj/machinery/vending/proc/refill_inventory(obj/item/vending_refill/refill, datum/data/vending_product/machine)
	var/total = 0

	var/to_restock = 0
	for(var/datum/data/vending_product/machine_content in machine)
		if(machine_content.amount == 0 && refill.charges > 0)
			machine_content.amount++
			refill.charges--
			total++
		to_restock += machine_content.max_amount - machine_content.amount
	if(to_restock <= refill.charges)
		for(var/datum/data/vending_product/machine_content in machine)
			machine_content.amount = machine_content.max_amount
		refill.charges -= to_restock
		total += to_restock
	else
		var/tmp_charges = refill.charges
		for(var/datum/data/vending_product/machine_content in machine)
			if(refill.charges == 0)
				break
			var/restock = Ceiling(((machine_content.max_amount - machine_content.amount)/to_restock)*tmp_charges)
			if(restock > refill.charges)
				restock = refill.charges
			machine_content.amount += restock
			refill.charges -= restock
			total += restock
	return total

/obj/machinery/vending/ex_act(severity)
	switch(severity)
		if(1.0)
			qdel(src)
			return
		if(2.0)
			if (prob(50))
				qdel(src)
				return
		if(3.0)
			if (prob(25))
				spawn(0)
					src.malfunction()
					return
				return
		else
	return

/obj/machinery/vending/proc/build_inventory(var/list/productlist, hidden=0, req_coin=0, start_empty = null)
	for(var/typepath in productlist)
		var/amount = productlist[typepath]
		if(isnull(amount))
			amount = 0

		var/atom/temp = new typepath(null)
		var/datum/data/vending_product/R = new /datum/data/vending_product()
		R.product_name = temp.name
		R.product_path = typepath
		if(!start_empty)
			R.amount = amount
		R.max_amount = amount
		R.display_color = pick("red","blue","green")

		if(hidden)
			hidden_records += R
		else if(req_coin)
			coin_records += R
		else
			product_records += R
	return

/obj/machinery/vending/attackby(obj/item/W as obj, mob/user as mob)
	if(src.panel_open)
		if(default_unfasten_wrench(user, W, time = 60))
			return

		if(component_parts && istype(W, /obj/item/crowbar))
			var/datum/data/vending_product/machine = product_records
			for(var/datum/data/vending_product/machine_content in machine)
				while(machine_content.amount !=0)
					for(var/obj/item/vending_refill/VR in component_parts)
						VR.charges++
						machine_content.amount--
						if(!machine_content.amount)
							break
			default_deconstruction_crowbar(W)

	if (istype(W, /obj/item/card/emag))
		src.emagged = 1
		user << "You short out the product lock on [src]"
		return
	else if(istype(W, /obj/item/screwdriver))
		playsound(src.loc, 'sound/items/Screwdriver.ogg', 100, 1)
		src.panel_open = !src.panel_open
		user << "You [src.panel_open ? "open" : "close"] the maintenance panel."
		src.overlays.Cut()
		if(src.panel_open)
			src.overlays += image(src.icon, "[initial(icon_state)]-panel")
		src.updateUsrDialog()
		return
	else if(istype(W, /obj/item/device/multitool)||istype(W, /obj/item/wirecutters))
		if(src.panel_open)
			attack_hand(user)
		return
	else if(istype(W, /obj/item/coin) && premium.len > 0)
		user.drop_item()
		W.loc = src
		coin = W
		user << "\blue You insert the [W] into the [src]"
		return
	else if(istype(W, /obj/item/card) && currently_vending)
		var/obj/item/card/I = W
		scan_card(I)
	else if (istype(W, /obj/item/wrench))
		if (src.anchored)
			playsound(src.loc, 'sound/items/Ratchet.ogg', 50, 1)
			user << "\blue You begin to unfasten \the [src] from the floor..."
			if (do_after(user, 40))
				user.visible_message( \
					"[user] unfastens \the [src].", \
					"\blue You have unfastened \the [src]. Now it can be pulled somewhere else.", \
					"You hear ratchet.")
				src.anchored = 0
				src.stat |= MAINT
				if (usr.machine==src)
					usr << browse(null, "window=vending")
		else
			playsound(src.loc, 'sound/items/Ratchet.ogg', 50, 1)
			user << "\blue You begin to fasten \the [src] to the floor..."
			if (do_after(user, 20))
				user.visible_message( \
					"[user] fastens \the [src].", \
					"\blue You have fastened \the [src].", \
					"You hear ratchet.")
				src.anchored = 1
				src.stat &= ~MAINT
				power_change()
	else if(src.panel_open)

		for(var/datum/data/vending_product/R in product_records)
			if(istype(W, R.product_path))
				stock(R, user)
				qdel(W)
	else if(istype(W, refill_canister) && refill_canister != null)
		if(stat & (BROKEN|NOPOWER))
			user << "<span class='notice'>It does nothing.</span>"
		else if(src.panel_open)
			//if the panel is open we attempt to refill the machine
			var/obj/item/vending_refill/canister = W
			if(canister.charges == 0)
				user << "<span class='notice'>This [canister.name] is empty!</span>"
			else
				var/transfered = refill_inventory(canister,product_records,user)
				if(transfered)
					user << "<span class='notice'>You loaded [transfered] items in \the [name].</span>"
				else
					user << "<span class='notice'>The [name] is fully stocked.</span>"
			return;
		else
			user << "<span class='notice'>You should probably unscrew the service panel first.</span>"

	else
		..()

/obj/machinery/vending/proc/scan_card(var/obj/item/card/I)
	if(!currently_vending) return
	if (istype(I, /obj/item/card/id))
		var/obj/item/card/id/C = I
		visible_message("<span class='info'>[usr] swipes a card through [src].</span>")
		if(check_accounts)
			if(vendor_account)
				var/attempt_pin = input("Enter pin code", "Vendor transaction") as num
				var/datum/money_account/D = attempt_account_access(C.associated_account_number, attempt_pin, 2)
				if(D)
					var/transaction_amount = currently_vending.price
					if(transaction_amount <= D.money)

						//transfer the money
						D.money -= transaction_amount
						vendor_account.money += transaction_amount

						//create entries in the two account transaction logs
						var/datum/transaction/T = new()
						T.target_name = "[vendor_account.owner_name] (via [src.name])"
						T.purpose = "Purchase of [currently_vending.product_name]"
						if(transaction_amount > 0)
							T.amount = "([transaction_amount])"
						else
							T.amount = "[transaction_amount]"
						T.source_terminal = src.name
						T.date = current_date_string
						T.time = worldtime2text()
						D.transaction_log.Add(T)
						//
						T = new()
						T.target_name = D.owner_name
						T.purpose = "Purchase of [currently_vending.product_name]"
						T.amount = "[transaction_amount]"
						T.source_terminal = src.name
						T.date = current_date_string
						T.time = worldtime2text()
						vendor_account.transaction_log.Add(T)

						// Vend the item
						src.vend(src.currently_vending, usr)
						currently_vending = null
				else
					usr << "\icon[src]<span class='warning'>You don't have that much money!</span>"
			else
				usr << "\icon[src]<span class='warning'>Unable to access account. Check security settings and try again.</span>"
		else
			//Just Vend it.
			src.vend(src.currently_vending, usr)
			currently_vending = null
	else
		usr << "\icon[src]<span class='warning'>Unable to access vendor account. Please record the machine ID and call CentComm Support.</span>"
	src.updateUsrDialog()

/obj/machinery/vending/attack_paw(mob/user as mob)
	return attack_hand(user)

/obj/machinery/vending/attack_ai(mob/user as mob)
	return attack_hand(user)

/obj/machinery/vending/attack_hand(mob/user as mob)
	if(stat & (BROKEN|NOPOWER))
		return
	user.set_machine(src)

	if(src.seconds_electrified != 0)
		if(src.shock(user, 100))
			return

	var/vendorname = (src.name)  //import the machine's name
/*
	if(src.currently_vending)
		var/dat = "<TT><center><b>[vendorname]</b></center><hr /><br>" //display the name, and added a horizontal rule
		dat += "<b>You have selected [currently_vending.product_name].<br>Please swipe your ID to pay for the article.</b><br>"
		dat += "<a href='byond://?src=\ref[src];cancel_buying=1'>Cancel</a>"
		user << browse(dat, "window=vending")
		onclose(user, "")
		return*/

	var/list/dat = list()
	dat += "<b>Select an item: </b><br><br>" //the rest is just general spacing and bolding

	if (premium.len > 0)
		dat += "<b>Coin slot:</b> [coin ? coin : "No coin inserted"] (<a href='byond://?src=\ref[src];remove_coin=1'>Remove</A>)<br><br>"

	if (src.product_records.len == 0)
		dat += "<font color = 'red'>No product loaded!</font>"
	else
		var/list/display_records = src.product_records
		if(src.extended_inventory)
			display_records = src.product_records + src.hidden_records
		if(src.coin)
			display_records = src.product_records + src.coin_records
		if(src.coin && src.extended_inventory)
			display_records = src.product_records + src.hidden_records + src.coin_records

		for (var/datum/data/vending_product/R in display_records)
			dat += "<FONT color = '[R.display_color]'><B>[R.product_name]</B>:"
			dat += " <b>[R.amount]</b> </font>"
			if(R.price)
				dat += " <b>(Price: [R.price])</b>"
			if (R.amount > 0)
				dat += " <a href='byond://?src=\ref[src];vend=\ref[R]'>(Vend)</A>"
			else
				dat += " <font color = 'red'>SOLD OUT</font>"
			dat += "<br>"

		dat += "</TT>"

	if(panel_open)
		var/list/vendwires = list(
			"Violet" = 1,
			"Orange" = 2,
			"Goldenrod" = 3,
			"Green" = 4,
		)
		dat += "<br><hr><br><B>Access Panel</B><br>"
		for(var/wiredesc in vendwires)
			var/is_uncut = src.wires & APCWireColorToFlag[vendwires[wiredesc]]
			dat += "[wiredesc] wire: "
			if(!is_uncut)
				dat += "<a href='byond://?src=\ref[src];cutwire=[vendwires[wiredesc]]'>Mend</a>"
			else
				dat += "<a href='byond://?src=\ref[src];cutwire=[vendwires[wiredesc]]'>Cut</a> "
				dat += "<a href='byond://?src=\ref[src];pulsewire=[vendwires[wiredesc]]'>Pulse</a> "
			dat += "<br>"

		dat += "<br>"
		dat += "The orange light is [(src.seconds_electrified == 0) ? "off" : "on"].<BR>"
		dat += "The red light is [src.shoot_inventory ? "off" : "blinking"].<BR>"
		dat += "The green light is [src.extended_inventory ? "on" : "off"].<BR>"
		dat += "The [(src.wires & WIRE_SCANID) ? "purple" : "yellow"] light is on.<BR>"

		if (product_slogans != "")
			dat += "The speaker switch is [src.shut_up ? "off" : "on"]. <a href='byond://?src=\ref[src];togglevoice=[1]'>Toggle</a>"

	var/datum/browser/popup = new(user, "vending", "[vendorname]", 400, 600)
	popup.set_content(JOINTEXT(dat))
	popup.open()

/obj/machinery/vending/Topic(href, href_list)
	if(stat & (BROKEN|NOPOWER))
		return
	if(!CanPhysicallyInteractWith(usr, src))
		to_chat(usr, SPAN_WARNING("You must stay close to \the [src]!"))
		return
	if(usr.stat || usr.restrained())
		return

	if(href_list["remove_coin"] && !istype(usr,/mob/living/silicon))
		if(!coin)
			to_chat(usr, "There is no coin in this machine.")
			return

		coin.loc = src.loc
		if(!usr.get_active_hand())
			usr.put_in_hands(coin)
		to_chat(usr, "You remove the [coin] from the [src]")
		coin = null


	if ((usr.contents.Find(src) || (in_range(src, usr) && istype(src.loc, /turf))))
		usr.set_machine(src)
		if((href_list["vend"]) && (vend_ready))
			if(panel_open)
				usr << "<span class='notice'>The vending machine cannot dispense products while its service panel is open!</span>"
				return

			if((!allowed(usr)) && !emagged && WIRE_SCANID)	//For SECURE VENDING MACHINES YEAH
				usr << "<span class='warning'>Access denied.</span>"	//Unless emagged of course
				flick(icon_deny,src)
				return

			vend_ready = 0 //One thing at a time!!

			var/datum/data/vending_product/R = locate(href_list["vend"])
			if(!R || !istype(R) || !R.product_path)
				vend_ready = 1
				return

			if(R in hidden_records)
				if(!extended_inventory)
					vend_ready = 1
					return
			else if(R in coin_records)
				if(!coin)
					usr << "<span class='notice'>You need to insert a coin to get this item.</span>"
					vend_ready = 1
					return
				if(coin.string_attached)
					if(prob(50))
						if(usr.put_in_hands(coin))
							usr << "<span class='notice'>You successfully pull [coin] out before [src] could swallow it.</span>"
							coin = null
						else
							usr << "<span class='notice'>You couldn't pull [coin] out because your hands are full.</span>"
							qdel(coin)
							coin = null
					else
						usr << "<span class='notice'>You weren't able to pull [coin] out fast enough, the machine ate it, string and all.</span>"
						qdel(coin)
						coin = null
				else
					qdel(coin)
					coin = null
			else if (!(R in product_records))
				vend_ready = 1
				message_admins("Vending machine exploit attempted by [key_name(usr, usr.client)]!")
				return

			if (R.amount <= 0)
				usr << "<span class='warning'>Sold out.</span>"
				vend_ready = 1
				return
			else
				R.amount--

			if(((last_reply + (vend_delay + 200)) <= world.time) && vend_reply)
				speak(vend_reply)
				last_reply = world.time

			use_power(5)
			if(icon_vend) //Show the vending animation if needed
				flick(icon_vend,src)
			spawn(vend_delay)
				new R.product_path(get_turf(src))
				vend_ready = 1
				return

			updateUsrDialog()
			return

		else if (href_list["cancel_buying"])
			src.currently_vending = null
			src.updateUsrDialog()
			return

		else if ((href_list["cutwire"]) && (src.panel_open))
			var/twire = text2num(href_list["cutwire"])
			if (!( istype(usr.get_active_hand(), /obj/item/wirecutters) ))
				usr << "You need wirecutters!"
				return
			if (src.isWireColorCut(twire))
				src.mend(twire)
			else
				src.cut(twire)

		else if ((href_list["pulsewire"]) && (src.panel_open))
			var/twire = text2num(href_list["pulsewire"])
			if (!istype(usr.get_active_hand(), /obj/item/device/multitool))
				usr << "You need a multitool!"
				return
			if (src.isWireColorCut(twire))
				usr << "You can't pulse a cut wire."
				return
			else
				src.pulse(twire)

		else if ((href_list["togglevoice"]) && (src.panel_open))
			src.shut_up = !src.shut_up

		src.add_fingerprint(usr)
		src.updateUsrDialog()
	else
		usr << browse(null, "window=vending")
		return
	return

/obj/machinery/vending/proc/vend(datum/data/vending_product/R, mob/user)
	if ((!src.allowed(user)) && (!src.emagged) && (src.wires & WIRE_SCANID)) //For SECURE VENDING MACHINES YEAH
		user << "\red Access denied." //Unless emagged of course
		flick(src.icon_deny,src)
		return
	src.vend_ready = 0 //One thing at a time!!

	if (R in coin_records)
		if(!coin)
			user << "\blue You need to insert a coin to get this item."
			return
		if(coin.string_attached)
			if(prob(50))
				user << "\blue You successfully pull the coin out before the [src] could swallow it."
			else
				user << "\blue You weren't able to pull the coin out fast enough, the machine ate it, string and all."
				qdel(coin)
		else
			qdel(coin)

	R.amount--

	if(((src.last_reply + (src.vend_delay + 200)) <= world.time) && src.vend_reply)
		spawn(0)
			src.speak(src.vend_reply)
			src.last_reply = world.time

	use_power(5)
	if (src.icon_vend) //Show the vending animation if needed
		flick(src.icon_vend,src)
	spawn(src.vend_delay)
		new R.product_path(get_turf(src))
		src.vend_ready = 1
		return

	src.updateUsrDialog()

/obj/machinery/vending/proc/stock(var/datum/data/vending_product/R, var/mob/user)
	if(src.panel_open)
		user << "\blue You stock the [src] with \a [R.product_name]"
		R.amount++

	src.updateUsrDialog()

/obj/machinery/vending/process()
	if(stat & (BROKEN|NOPOWER))
		return

	if(!src.active)
		return

	if(src.seconds_electrified > 0)
		src.seconds_electrified--

	//Pitch to the people!  Really sell it!
	if(((src.last_slogan + src.slogan_delay) <= world.time) && (src.slogan_list.len > 0) && (!src.shut_up) && prob(5))
		var/slogan = pick(src.slogan_list)
		src.speak(slogan)
		src.last_slogan = world.time

	if(src.shoot_inventory && prob(2))
		src.throw_item()

	return

/obj/machinery/vending/proc/speak(var/message)
	if(stat & NOPOWER)
		return

	if (!message)
		return

	for(var/mob/O in hearers(src, null))
		O.show_message("<span class='game say'><span class='name'>[src]</span> beeps, \"[message]\"",2)
	return

/obj/machinery/vending/power_change()
	if(stat & BROKEN)
		icon_state = "[initial(icon_state)]-broken"
	else
		if( powered() )
			icon_state = initial(icon_state)
			stat &= ~NOPOWER
		else
			spawn(rand(0, 15))
				src.icon_state = "[initial(icon_state)]-off"
				stat |= NOPOWER

//Oh no we're malfunctioning!  Dump out some product and break.
/obj/machinery/vending/proc/malfunction()
	for(var/datum/data/vending_product/R in src.product_records)
		if (R.amount <= 0) //Try to use a record that actually has something to dump.
			continue
		var/dump_path = R.product_path
		if (!dump_path)
			continue

		while(R.amount>0)
			new dump_path(src.loc)
			R.amount--
		break

	stat |= BROKEN
	src.icon_state = "[initial(icon_state)]-broken"
	return

//Somebody cut an important wire and now we're following a new definition of "pitch."
/obj/machinery/vending/proc/throw_item()
	var/obj/throw_item = null
	var/mob/living/target = locate() in view(7,src)
	if(!target)
		return 0

	for(var/datum/data/vending_product/R in src.product_records)
		if (R.amount <= 0) //Try to use a record that actually has something to dump.
			continue
		var/dump_path = R.product_path
		if (!dump_path)
			continue

		R.amount--
		throw_item = new dump_path(src.loc)
		break
	if (!throw_item)
		return 0
	spawn(0)
		throw_item.throw_at(target, 16, 3, src)
	src.visible_message("\red <b>[src] launches [throw_item.name] at [target.name]!</b>")
	return 1

/obj/machinery/vending/proc/isWireColorCut(var/wireColor)
	var/wireFlag = APCWireColorToFlag[wireColor]
	return ((src.wires & wireFlag) == 0)

/obj/machinery/vending/proc/isWireCut(var/wireIndex)
	var/wireFlag = APCIndexToFlag[wireIndex]
	return ((src.wires & wireFlag) == 0)

/obj/machinery/vending/proc/cut(var/wireColor)
	var/wireFlag = APCWireColorToFlag[wireColor]
	var/wireIndex = APCWireColorToIndex[wireColor]
	src.wires &= ~wireFlag
	switch(wireIndex)
		if(WIRE_EXTEND)
			src.extended_inventory = 0
		if(WIRE_SHOCK)
			src.seconds_electrified = -1
		if (WIRE_SHOOTINV)
			if(!src.shoot_inventory)
				src.shoot_inventory = 1


/obj/machinery/vending/proc/mend(var/wireColor)
	var/wireFlag = APCWireColorToFlag[wireColor]
	var/wireIndex = APCWireColorToIndex[wireColor] //not used in this function
	src.wires |= wireFlag
	switch(wireIndex)
//		if(WIRE_SCANID)
		if(WIRE_SHOCK)
			src.seconds_electrified = 0
		if (WIRE_SHOOTINV)
			src.shoot_inventory = 0

/obj/machinery/vending/proc/pulse(var/wireColor)
	var/wireIndex = APCWireColorToIndex[wireColor]
	switch(wireIndex)
		if(WIRE_EXTEND)
			src.extended_inventory = !src.extended_inventory
//		if (WIRE_SCANID)
		if (WIRE_SHOCK)
			src.seconds_electrified = 30
		if (WIRE_SHOOTINV)
			src.shoot_inventory = !src.shoot_inventory


/obj/machinery/vending/proc/shock(mob/user, prb)
	if(stat & (BROKEN|NOPOWER))		// unpowered, no shock
		return 0
	if(!prob(prb))
		return 0
	var/datum/effect/effect/system/spark_spread/s = new /datum/effect/effect/system/spark_spread
	s.set_up(5, 1, src)
	s.start()
	if (electrocute_mob(user, get_area(src), src, 0.7))
		return 1
	else
		return 0

/*
 * Vending machine types
 */

/*

/obj/machinery/vending/[vendors name here]   // --vending machine template   :)
	name = ""
	desc = ""
	icon = ''
	icon_state = ""
	vend_delay = 15
	products = list()
	contraband = list()
	premium = list()

*/

/*
/obj/machinery/vending/atmospherics //Commenting this out until someone ponies up some actual working, broken, and unpowered sprites - Quarxink
	name = "Tank Vendor"
	desc = "A vendor with a wide variety of masks and gas tanks."
	icon = 'icons/obj/objects.dmi'
	icon_state = "dispenser"
	product_paths = "/obj/item/tank/oxygen;/obj/item/tank/plasma;/obj/item/tank/emergency_oxygen;/obj/item/tank/emergency_oxygen/engi;/obj/item/clothing/mask/breath"
	product_amounts = "10;10;10;5;25"
	vend_delay = 0
*/

/obj/machinery/vending/assist
	products = list(	/obj/item/device/assembly/prox_sensor = 5,/obj/item/device/assembly/igniter = 3,/obj/item/device/assembly/signaler = 4,
						/obj/item/wirecutters = 1, /obj/item/cartridge/signal = 4)
	contraband = list(/obj/item/device/flashlight = 5,/obj/item/device/assembly/timer = 2)
	product_ads = "Only the finest!;Have some tools.;The most robust equipment.;The finest gear in space!"

/obj/machinery/vending/coffee
	name = "Hot Drinks machine"
	desc = "A vending machine which dispenses hot drinks."
	product_ads = "Have a drink!;Drink up!;It's good for you!;Would you like a hot joe?;I'd kill for some coffee!;The best beans in the galaxy.;Only the finest brew for you.;Mmmm. Nothing like a coffee.;I like coffee, don't you?;Coffee helps you work!;Try some tea.;We hope you like the best!;Try our new chocolate!;Admin conspiracies"
	icon_state = "coffee"
	icon_vend = "coffee-vend"
	vend_delay = 34
	products = list(/obj/item/reagent_containers/food/drinks/coffee = 25,/obj/item/reagent_containers/food/drinks/tea = 25,/obj/item/reagent_containers/food/drinks/h_chocolate = 25)
	contraband = list(/obj/item/reagent_containers/food/drinks/ice = 10)
	prices = list(/obj/item/reagent_containers/food/drinks/coffee = 25, /obj/item/reagent_containers/food/drinks/tea = 25, /obj/item/reagent_containers/food/drinks/h_chocolate = 25)
	refill_canister = /obj/item/vending_refill/coffee



/obj/machinery/vending/snack
	name = "Getmore Chocolate Corp"
	desc = "A snack machine courtesy of the Getmore Chocolate Corporation, based out of Mars"
	product_slogans = "Try our new nougat bar!;Twice the calories for half the price!"
	product_ads = "The healthiest!;Award-winning chocolate bars!;Mmm! So good!;Oh my god it's so juicy!;Have a snack.;Snacks are good for you!;Have some more Getmore!;Best quality snacks straight from mars.;We love chocolate!;Try our new jerky!"
	icon_state = "snack"
	products = list(/obj/item/reagent_containers/food/snacks/candy = 6,/obj/item/reagent_containers/food/drinks/dry_ramen = 6,/obj/item/reagent_containers/food/snacks/chips =6,
					/obj/item/reagent_containers/food/snacks/sosjerky = 6,/obj/item/reagent_containers/food/snacks/no_raisin = 6,/obj/item/reagent_containers/food/snacks/spacetwinkie = 6,
					/obj/item/reagent_containers/food/snacks/cheesiehonkers = 6)
	contraband = list(/obj/item/reagent_containers/food/snacks/syndicake = 6)
	prices = list(/obj/item/reagent_containers/food/snacks/candy = 1,/obj/item/reagent_containers/food/drinks/dry_ramen = 5,/obj/item/reagent_containers/food/snacks/chips = 1,
					/obj/item/reagent_containers/food/snacks/sosjerky = 2,/obj/item/reagent_containers/food/snacks/no_raisin = 1,/obj/item/reagent_containers/food/snacks/spacetwinkie = 1,
					/obj/item/reagent_containers/food/snacks/cheesiehonkers = 1)



/obj/machinery/vending/cola
	name = "Robust Softdrinks"
	desc = "A softdrink vendor provided by Robust Industries, LLC."
	icon_state = "Cola_Machine"
	product_slogans = "Robust Softdrinks: More robust than a toolbox to the head!"
	product_ads = "Refreshing!;Hope you're thirsty!;Over 1 million drinks sold!;Thirsty? Why not cola?;Please, have a drink!;Drink up!;The best drinks in space."
	products = list(/obj/item/reagent_containers/food/drinks/cans/cola = 10,/obj/item/reagent_containers/food/drinks/cans/space_mountain_wind = 10,
					/obj/item/reagent_containers/food/drinks/cans/dr_gibb = 10,/obj/item/reagent_containers/food/drinks/cans/starkist = 10,
					/obj/item/reagent_containers/glass/bottle/waterbottle = 10,/obj/item/reagent_containers/food/drinks/cans/space_up = 10,
					/obj/item/reagent_containers/food/drinks/cans/iced_tea = 10, /obj/item/reagent_containers/food/drinks/cans/grape_juice = 10)
	contraband = list(/obj/item/reagent_containers/food/drinks/cans/thirteenloko = 5)
	prices = list(/obj/item/reagent_containers/food/drinks/cans/cola = 1,/obj/item/reagent_containers/food/drinks/cans/space_mountain_wind = 1,
					/obj/item/reagent_containers/food/drinks/cans/dr_gibb = 1,/obj/item/reagent_containers/food/drinks/cans/starkist = 1,
					/obj/item/reagent_containers/glass/bottle/waterbottle = 2,/obj/item/reagent_containers/food/drinks/cans/space_up = 1,
					/obj/item/reagent_containers/food/drinks/cans/iced_tea = 1,/obj/item/reagent_containers/food/drinks/cans/grape_juice = 1)
	refill_canister = /obj/item/vending_refill/cola

/obj/machinery/vending/cola/soda
	icon_state = "soda"


//This one's from bay12
/obj/machinery/vending/cart
	name = "PTech"
	desc = "Cartridges for PDAs"
	product_slogans = "Carts to go!"
	icon_state = "cart"
	icon_deny = "cart-deny"
	products = list(/obj/item/cartridge/medical = 10,/obj/item/cartridge/engineering = 10,/obj/item/cartridge/security = 10,
					/obj/item/cartridge/janitor = 10,/obj/item/cartridge/signal/toxins = 10,/obj/item/device/pda/heads = 10,
					/obj/item/cartridge/captain = 3,/obj/item/cartridge/quartermaster = 10)


/obj/machinery/vending/cigarette
	name = "Cigarette machine" //OCD had to be uppercase to look nice with the new formating
	desc = "If you want to get cancer, might as well do it in style"
	product_slogans = "Space cigs taste good like a cigarette should.;I'd rather toolbox than switch.;Smoke!;Don't believe the reports - smoke today!"
	product_ads = "Probably not bad for you!;Don't believe the scientists!;It's good for you!;Don't quit, buy more!;Smoke!;Nicotine heaven.;Best cigarettes since 2150.;Award-winning cigs."
	vend_delay = 34
	icon_state = "cigs"

	contraband = list(/obj/item/flame/lighter/zippo = 4)
	premium = list(/obj/item/clothing/mask/cigarette/cigar/havana = 2)

	refill_canister = /obj/item/vending_refill/cigarette


/obj/machinery/vending/medical
	name = "NanoMed Plus"
	desc = "Medical drug dispenser."
	icon_state = "med"
	icon_deny = "med-deny"
	product_ads = "Go save some lives!;The best stuff for your medbay.;Only the finest tools.;Natural chemicals!;This stuff saves lives.;Don't you want some?;Ping!"
	req_access_txt = "5"
	products = list(/obj/item/storage/pill_bottle/charcoal = 4,/obj/item/reagent_containers/glass/bottle/epinephrine = 4,
					/obj/item/reagent_containers/glass/bottle/stoxin = 4,/obj/item/reagent_containers/glass/bottle/toxin = 4,
					/obj/item/reagent_containers/syringe/antiviral = 4,/obj/item/reagent_containers/syringe = 12,
					/obj/item/device/healthanalyzer = 5,/obj/item/reagent_containers/glass/beaker = 4, /obj/item/reagent_containers/dropper = 2,
					/obj/item/stack/medical/advanced/bruise_pack = 3, /obj/item/stack/medical/advanced/ointment = 3, /obj/item/stack/medical/splint = 2)
	contraband = list(/obj/item/reagent_containers/pill/tox = 3,/obj/item/reagent_containers/pill/morphine = 4,/obj/item/reagent_containers/pill/antitox = 6)


//This one's from bay12
/obj/machinery/vending/plasmaresearch
	name = "Toximate 3000"
	desc = "All the fine parts you need in one vending machine!"
	products = list(/obj/item/clothing/under/rank/scientist = 6,/obj/item/clothing/suit/bio_suit = 6,/obj/item/clothing/head/bio_hood = 6,
					/obj/item/device/transfer_valve = 6,/obj/item/device/assembly/timer = 6,/obj/item/device/assembly/signaler = 6,
					/obj/item/device/assembly/prox_sensor = 6,/obj/item/device/assembly/igniter = 6)

/obj/machinery/vending/wallmed1
	name = "NanoMed"
	desc = "Wall-mounted Medical Equipment dispenser."
	product_ads = "Go save some lives!;The best stuff for your medbay.;Only the finest tools.;Natural chemicals!;This stuff saves lives.;Don't you want some?"
	icon_state = "wallmed"
	icon_deny = "wallmed-deny"
	req_access_txt = "5"
	density = 0 //It is wall-mounted, and thus, not dense. --Superxpdude
	products = list(/obj/item/stack/medical/bruise_pack = 2,/obj/item/stack/medical/ointment = 2,/obj/item/reagent_containers/hypospray/medipen = 4,/obj/item/device/healthanalyzer = 1)
	contraband = list(/obj/item/reagent_containers/syringe/antitoxin = 4,/obj/item/reagent_containers/syringe/antiviral = 4,/obj/item/reagent_containers/pill/tox = 1)

/obj/machinery/vending/wallmed2
	name = "NanoMed"
	desc = "Wall-mounted Medical Equipment dispenser."
	icon_state = "wallmed"
	icon_deny = "wallmed-deny"
	req_access_txt = "5"
	density = 0 //It is wall-mounted, and thus, not dense. --Superxpdude
	products = list(/obj/item/reagent_containers/hypospray/medipen = 5,/obj/item/reagent_containers/syringe/antitoxin = 3,/obj/item/stack/medical/bruise_pack = 3,
					/obj/item/stack/medical/ointment =3,/obj/item/device/healthanalyzer = 3)
	contraband = list(/obj/item/reagent_containers/pill/tox = 3)

/obj/machinery/vending/security
	name = "SecTech"
	desc = "A security equipment vendor"
	product_ads = "Crack capitalist skulls!;Beat some heads in!;Don't forget - harm is good!;Your weapons are right here.;Handcuffs!;Freeze, scumbag!;Don't tase me bro!;Tase them, bro.;Why not have a donut?"
	icon_state = "sec"
	icon_deny = "sec-deny"
	req_access_txt = "1"
	products = list(/obj/item/handcuffs = 8,/obj/item/grenade/flashbang = 4,/obj/item/device/flash = 5,
					/obj/item/reagent_containers/food/snacks/donut/normal = 12,/obj/item/storage/box/evidence = 6)
	contraband = list(/obj/item/clothing/glasses/sunglasses = 2,/obj/item/storage/fancy/donut_box = 2)


/obj/machinery/vending/hydronutrients
	name = "NutriMax"
	desc = "A plant nutrients vendor."
	product_slogans = "Aren't you glad you don't have to fertilize the natural way?;Now with 50% less stink!;Plants are people too!"
	product_ads = "We like plants!;Don't you want some?;The greenest thumbs ever.;We like big plants.;Soft soil..."
	icon_state = "nutri"
	icon_deny = "nutri-deny"
	products = list(/obj/item/reagent_containers/glass/fertilizer/ez = 35,/obj/item/reagent_containers/glass/fertilizer/l4z = 25,/obj/item/reagent_containers/glass/fertilizer/rh = 15,/obj/item/plantspray/pests = 20,
					/obj/item/reagent_containers/syringe = 5,/obj/item/storage/bag/plants = 5)
	premium = list(/obj/item/reagent_containers/glass/bottle/ammonia = 10,/obj/item/reagent_containers/glass/bottle/diethylamine = 5)
	idle_power_usage = 211 //refrigerator - believe it or not, this is actually the average power consumption of a refrigerated vending machine according to NRCan.

/obj/machinery/vending/hydroseeds
	name = "MegaSeed Servitor"
	desc = "When you need seeds fast!"
	product_slogans = "THIS'S WHERE TH' SEEDS LIVE! GIT YOU SOME!;Hands down the best seed selection on the station!;Also certain mushroom varieties available, more for experts! Get certified today!"
	product_ads = "We like plants!;Grow some crops!;Grow, baby, growww!;Aw h'yeah son!"
	icon_state = "seeds"
	products = list(/obj/item/seeds/bananaseed = 3,/obj/item/seeds/berryseed = 3,/obj/item/seeds/carrotseed = 3,/obj/item/seeds/chantermycelium = 3,/obj/item/seeds/chiliseed = 3,
					/obj/item/seeds/cornseed = 3, /obj/item/seeds/eggplantseed = 3, /obj/item/seeds/potatoseed = 3, /obj/item/seeds/replicapod = 3,/obj/item/seeds/soyaseed = 3,
					/obj/item/seeds/sunflowerseed = 3,/obj/item/seeds/tomatoseed = 3,/obj/item/seeds/towermycelium = 3,/obj/item/seeds/wheatseed = 3,/obj/item/seeds/appleseed = 3,
					/obj/item/seeds/poppyseed = 3,/obj/item/seeds/sugarcaneseed = 3,/obj/item/seeds/ambrosiavulgarisseed = 3,/obj/item/seeds/peanutseed = 3,/obj/item/seeds/whitebeetseed = 3,/obj/item/seeds/watermelonseed = 3,/obj/item/seeds/limeseed = 3,
					/obj/item/seeds/lemonseed = 3,/obj/item/seeds/orangeseed = 3,/obj/item/seeds/grassseed = 3,/obj/item/seeds/cocoapodseed = 3,/obj/item/seeds/plumpmycelium = 2,
					/obj/item/seeds/cabbageseed = 3,/obj/item/seeds/grapeseed = 3,/obj/item/seeds/pumpkinseed = 3,/obj/item/seeds/cherryseed = 3,/obj/item/seeds/plastiseed = 3,/obj/item/seeds/riceseed = 3)
	contraband = list(/obj/item/seeds/amanitamycelium = 2,/obj/item/seeds/glowshroom = 2,/obj/item/seeds/libertymycelium = 2,/obj/item/seeds/mtearseed = 2,
					  /obj/item/seeds/nettleseed = 2,/obj/item/seeds/reishimycelium = 2,/obj/item/seeds/reishimycelium = 2,/obj/item/seeds/shandseed = 2,)
	premium = list(/obj/item/toy/waterflower = 1)



/obj/machinery/vending/magivend
	name = "MagiVend"
	desc = "A magic vending machine."
	icon_state = "MagiVend"
	product_slogans = "Sling spells the proper way with MagiVend!;Be your own Houdini! Use MagiVend!"
	vend_delay = 15
	vend_reply = "Have an enchanted evening!"
	product_ads = "FJKLFJSD;AJKFLBJAKL;1234 LOONIES LOL!;>MFW;Kill them fuckers!;GET DAT FUKKEN DISK;HONK!;EI NATH;Destroy the station!;Admin conspiracies since forever!;Space-time bending hardware!"
	products = list(/obj/item/clothing/head/wizard = 1,/obj/item/clothing/suit/wizrobe = 1,/obj/item/clothing/head/wizard/red = 1,/obj/item/clothing/suit/wizrobe/red = 1,/obj/item/clothing/shoes/lw/sandal = 1,/obj/item/staff = 2)
	contraband = list(/obj/item/reagent_containers/glass/bottle/wizarditis = 1)	//No one can get to the machine to hack it anyways; for the lulz - Microwave

/obj/machinery/vending/tool
	name = "YouTool"
	desc = "Tools for tools."
	icon_state = "tool"
	icon_deny = "tool-deny"
	//req_access_txt = "12" //Maintenance access
	products = list(/obj/item/stack/cable_coil/random = 10,/obj/item/crowbar = 5,/obj/item/weldingtool = 3,/obj/item/wirecutters = 5,
					/obj/item/wrench = 5,/obj/item/device/analyzer = 5,/obj/item/device/t_scanner = 5,/obj/item/screwdriver = 5)
	contraband = list(/obj/item/weldingtool/hugetank = 2,/obj/item/clothing/gloves/fyellow = 2)
	premium = list(/obj/item/clothing/gloves/yellow = 1)

/obj/machinery/vending/engivend
	name = "Engi-Vend"
	desc = "Spare tool vending. What? Did you expect some witty description?"
	icon_state = "engivend"
	icon_deny = "engivend-deny"
	req_access_txt = "11" //Engineering Equipment access
	products = list(/obj/item/clothing/glasses/meson = 2,/obj/item/device/multitool = 4,/obj/item/airlock_electronics = 10,/obj/item/module/power_control = 10,/obj/item/airalarm_electronics = 10,/obj/item/cell/high = 10)
	contraband = list(/obj/item/cell/potato = 3)
	premium = list(/obj/item/storage/belt/utility = 3)

//This one's from bay12
/obj/machinery/vending/engineering
	name = "Robco Tool Maker"
	desc = "Everything you need for do-it-yourself station repair."
	icon_state = "engi"
	icon_deny = "engi-deny"
	req_access_txt = "11"
	products = list(/obj/item/clothing/under/rank/chief_engineer = 4,/obj/item/clothing/under/rank/engineer = 4,/obj/item/clothing/shoes/lw/brown = 4,/obj/item/clothing/head/hardhat = 4,
					/obj/item/storage/belt/utility = 4,/obj/item/clothing/glasses/meson = 4,/obj/item/clothing/gloves/yellow = 4, /obj/item/screwdriver = 12,
					/obj/item/crowbar = 12,/obj/item/wirecutters = 12,/obj/item/device/multitool = 12,/obj/item/wrench = 12,/obj/item/device/t_scanner = 12,
					/obj/item/stack/cable_coil/heavyduty = 8, /obj/item/cell = 8, /obj/item/weldingtool = 8,/obj/item/clothing/head/welding = 8,
					/obj/item/light/tube = 10,/obj/item/clothing/suit/fire = 4, /obj/item/stock_parts/scanning_module = 5,/obj/item/stock_parts/micro_laser = 5,
					/obj/item/stock_parts/matter_bin = 5,/obj/item/stock_parts/manipulator = 5,/obj/item/stock_parts/console_screen = 5)
	// There was an incorrect entry (cablecoil/power).  I improvised to cablecoil/heavyduty.
	// Another invalid entry, /obj/item/circuitry.  I don't even know what that would translate to, removed it.
	// The original products list wasn't finished.  The ones without given quantities became quantity 5.  -Sayu

//This one's from bay12
/obj/machinery/vending/robotics
	name = "Robotech Deluxe"
	desc = "All the tools you need to create your own robot army."
	icon_state = "robotics"
	icon_deny = "robotics-deny"
	req_access_txt = "29"
	products = list(/obj/item/clothing/suit/storage/labcoat = 4,/obj/item/clothing/under/rank/roboticist = 4,/obj/item/stack/cable_coil = 4,/obj/item/device/flash = 4,
					/obj/item/cell/high = 12, /obj/item/device/assembly/prox_sensor = 3,/obj/item/device/assembly/signaler = 3,/obj/item/device/healthanalyzer = 3,
					/obj/item/surgery_tool/scalpel = 2,/obj/item/surgery_tool/circular_saw = 2,/obj/item/tank/anesthetic = 2,/obj/item/clothing/mask/breath/medical = 5,
					/obj/item/screwdriver = 5,/obj/item/crowbar = 5)
	//everything after the power cell had no amounts, I improvised.  -Sayu


//This one's from Animus Yellow
/obj/machinery/vending/ammo
	name = "Sgt. Ammy's ammo supplies."
	desc = "Ammunition vending machine."
	icon_state = "ammo"
	icon_deny = "ammo-deny"
	vend_reply = "Lock'n'load!; I hope you know where bullet comes out...; KILL 'EM ALL!; KABOOM!"
	product_ads = "Any caliber or filling!; One shot - one kill!.. Just kidding.; With or without engravements?; Only nuke is more deadly. IFF systems are not included."
	icon_state = "ammo"
	req_access_txt = "1"
	products = list(/obj/item/ammo_magazine/box/shotgun = 4, /obj/item/ammo_magazine/box/shotgun/stun = 4, /obj/item/ammo_magazine/box/c38 = 5,
					/obj/item/ammo_magazine/external/mc9mm = 2)

	premium = list(/obj/item/ammo_magazine/external/m50 = 2)

	contraband = list(/obj/item/ammo_magazine/external/m75 = 4, /obj/item/ammo_magazine/external/m12mm = 4, /obj/item/ammo_magazine/external/m762 = 2)


//This one' from TG
/obj/machinery/vending/autodrobe
	name = "\improper AutoDrobe"
	desc = "A vending machine for costumes."
	icon_state = "theater"
	icon_deny = "theater-deny"
	req_access_txt = "46" //Theatre access needed, unless hacked.
	product_slogans = "Dress for success!;Suited and booted!;It's show time!;Why leave style up to fate? Use AutoDrobe!"
	vend_delay = 15
	vend_reply = "Thank you for using AutoDrobe!"
/*	products = list(/obj/item/clothing/mask/fawkes = 1, /obj/item/clothing/suit/chickensuit = 1,/obj/item/clothing/head/chicken = 1,/obj/item/clothing/under/gladiator = 1,
					/obj/item/clothing/head/helmet/gladiator = 1,/obj/item/clothing/under/gimmick/rank/captain/suit = 1,/obj/item/clothing/head/flatcap = 1,
					/obj/item/clothing/suit/labcoat/mad = 1,/obj/item/clothing/glasses/greenglasses = 1,/obj/item/clothing/shoes/lw/jackboots = 1,
					/obj/item/clothing/under/schoolgirl = 1,/obj/item/clothing/head/kitty = 1,/obj/item/clothing/under/blackskirt = 1,/obj/item/clothing/head/beret = 1,
					/obj/item/clothing/tie/waistcoat = 1,/obj/item/clothing/under/suit_jacket = 1,/obj/item/clothing/head/that =1,/obj/item/clothing/head/cueball = 1,
					/obj/item/clothing/under/scratch = 1,/obj/item/clothing/under/kilt = 1,/obj/item/clothing/head/beret = 1,/obj/item/clothing/tie/waistcoat = 1,
					/obj/item/clothing/glasses/monocle =1,/obj/item/clothing/head/bowler = 1,/obj/item/cane = 1,/obj/item/clothing/under/sl_suit = 1,
					/obj/item/clothing/mask/fakemoustache = 1,/obj/item/clothing/suit/bio_suit/plaguedoctorsuit = 1,/obj/item/clothing/head/plaguedoctorhat = 1,
					/obj/item/clothing/under/owl = 1,/obj/item/clothing/mask/gas/owl_mask = 1,/obj/item/clothing/suit/apron = 1,/obj/item/clothing/under/waiter = 1,
					/obj/item/clothing/under/pirate = 1,/obj/item/clothing/suit/pirate = 1,/obj/item/clothing/head/pirate = 1,/obj/item/clothing/head/bandana = 1,
					/obj/item/clothing/head/bandana = 1,/obj/item/clothing/under/soviet = 1,/obj/item/clothing/head/ushanka = 1,/obj/item/clothing/suit/imperium_monk = 1,
					/obj/item/clothing/mask/gas/cyborg = 1,/obj/item/clothing/suit/holidaypriest = 1,/obj/item/clothing/head/wizard/marisa/fake = 1, /obj/item/clothing/suit/cabanelasuit = 1, /obj/item/clothing/mask/horsehead/black = 1, /obj/item/clothing/mask/unicornhead = 1, /obj/item/clothing/head/rabbithead = 1,
					/obj/item/clothing/suit/wizrobe/marisa/fake = 1,/obj/item/clothing/under/sundress = 1,/obj/item/clothing/head/witchwig = 1,/obj/item/staff/broom = 1, /obj/item/clothing/mask/heist/smiley = 1, /obj/item/clothing/mask/heist/smiley/yellow = 1, /obj/item/clothing/mask/heist/smiley/red = 1,
					/obj/item/clothing/suit/wizrobe/fake = 1,/obj/item/clothing/head/wizard/fake = 1,/obj/item/staff = 3,/obj/item/clothing/mask/gas/sexyclown = 1, /obj/item/clothing/mask/crocodile = 1,
					/obj/item/clothing/under/sexyclown = 1,/obj/item/clothing/mask/gas/sexymime = 1,/obj/item/clothing/under/sexymime = 1,/obj/item/clothing/suit/apron/overalls = 1, /obj/item/clothing/suit/rabbitsuit = 1,
					/obj/item/clothing/head/rabbitears = 1, /obj/item/clothing/under/maid = 1, /obj/item/clothing/head/maidbow = 1, /obj/item/clothing/under/schoolgirl = 1, /obj/item/clothing/under/schoolgirl/red = 1, /obj/item/clothing/under/schoolgirl/green = 1, /obj/item/clothing/under/schoolgirl/orange = 1,
					/obj/item/clothing/head/sombrero = 1, /obj/item/clothing/head/sombrero/green = 1, /obj/item/clothing/suit/poncho = 1,
					/obj/item/clothing/suit/poncho/green = 1, /obj/item/clothing/suit/poncho/red = 1) //Pretty much everything that had a chance to spawn.
	contraband = list(/obj/item/clothing/suit/cardborg = 1,/obj/item/clothing/head/cardborg = 1, /obj/item/clothing/suit/judgerobe = 1,/obj/item/clothing/head/powdered_wig = 1,/obj/item/gun/magic/wand = 1, /obj/item/clothing/glasses/sunglasses/garb = 1, /obj/item/clothing/glasses/hypno = 1)
	premium = list(/obj/item/clothing/suit/hgpirate = 1, /obj/item/clothing/head/hgpiratecap = 1, /obj/item/clothing/head/helmet/roman = 1, /obj/item/clothing/head/helmet/roman/legionaire = 1, /obj/item/clothing/under/roman = 1, /obj/item/clothing/shoes/roman = 1, /obj/item/shield/riot/roman = 1, /obj/item/clothing/glasses/sunglasses/gar = 1, /obj/item/clothing/glasses/threed = 1)*/
	refill_canister = /obj/item/vending_refill/autodrobe

/obj/machinery/vending/clothing
	name = "Clothe-O-Mat"
	desc = "A vending machine for clothing."
	icon_state = "clothes"
	product_slogans = "Dress for success!;Prepare to look swagalicious!;Look at all this free swag!;Why leave style up to fate? Use the Clothe-O-Mat!"
	vend_delay = 15
	vend_reply = "Thank you for using the Clothe-O-Mat!"
/*	products = list(/obj/item/clothing/mask/fakemoustache = 3,/obj/item/clothing/head/collectable/tophat = 3,/obj/item/clothing/glasses/monocle = 2,
					/obj/item/clothing/under/suit_jacket/navy = 3,/obj/item/clothing/under/kilt = 1,/obj/item/clothing/under/overalls = 3,
					/obj/item/clothing/under/suit_jacket/really_black = 3,/obj/item/clothing/under/jeans = 5,/obj/item/clothing/under/camo = 2,
					/obj/item/clothing/tie/waistcoat = 3,/obj/item/clothing/under/sundress = 4,/obj/item/clothing/under/blacktango = 2,
					/obj/item/clothing/head/maidbow = 1,/obj/item/clothing/under/janimaid = 1,/obj/item/clothing/suit/labcoat/coat/jacket/varsity = 3,/obj/item/clothing/suit/labcoat/coat/jacket = 5,
					/obj/item/clothing/glasses/regular = 3,/obj/item/clothing/head/sombrero = 2,/obj/item/clothing/suit/poncho = 2,
					/obj/item/clothing/shoes/lw/boots = 3,/obj/item/clothing/shoes/sneakers/black = 6, /obj/item/clothing/shoes/lw/sandal = 2)
	contraband = list(/obj/item/clothing/under/syndicate/tacticool = 1,/obj/item/clothing/mask/fawkes = 1,/obj/item/clothing/mask/balaclava = 1,/obj/item/clothing/head/ushanka = 1,/obj/item/clothing/under/soviet = 1,/obj/item/clothing/suit/cardborg = 1, /obj/item/clothing/head/cardborg = 1,/obj/item/clothing/glasses/hypno = 1)
	premium = list(/obj/item/clothing/under/suit_jacket/checkered = 1,/obj/item/clothing/head/mailman = 1,/obj/item/clothing/under/rank/mailman = 1,/obj/item/clothing/suit/labcoat/coat/jacket/leather = 1,/obj/item/clothing/suit/ianshirt = 1,/obj/item/clothing/glasses/sunglasses = 3, /obj/item/clothing/glasses/threed = 2, /obj/item/clothing/head/collectable/paper = 1, /obj/item/clothing/head/fedora = 2)*/
	refill_canister = /obj/item/vending_refill/clothing


/obj/machinery/vending/sustenance
	name = "\improper Sustenance Vendor"
	desc = "A vending machine which vends food, as required by section 47-C of the NT's Prisoner Ethical Treatment Agreement."
	product_slogans = "Enjoy your meal.;Enough calories to support strenuous labor."
	product_ads = "Sufficiently healthy.;Efficiently produced tofu!;Mmm! So good!;Have a meal.;You need food to live!;Have some more candy corn!;Try our new ice cups!"
	icon_state = "sustenance"
	products = list(/obj/item/reagent_containers/food/snacks/tofu = 24,
					/obj/item/reagent_containers/food/drinks/ice = 12,
					/obj/item/reagent_containers/food/snacks/candy_corn = 6)
	contraband = list(/obj/item/kitchen/utensil/knife = 6)