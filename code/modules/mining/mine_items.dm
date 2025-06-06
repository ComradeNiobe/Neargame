/**********************Light************************/

//this item is intended to give the effect of entering the mine, so that light gradually fades
/obj/effect/light_emitter
	name = "Light-emtter"
	anchored = 1
	unacidable = 1
	luminosity = 8

/**********************Miner Lockers**************************/

/obj/structure/closet/secure_closet/miner
	name = "miner's equipment"
	icon_state = "miningsec1"
	icon_closed = "miningsec"
	icon_locked = "miningsec1"
	icon_opened = "miningsecopen"
	icon_broken = "miningsecbroken"
	icon_off = "miningsecoff"
	req_access = list(access_mining)

/obj/structure/closet/secure_closet/miner/New()
	..()
	sleep(2)
	if(prob(50))
		new /obj/item/storage/backpack/industrial(src)
	else
		new /obj/item/storage/backpack/satchel_eng(src)
	new /obj/item/device/radio/headset/headset_cargo(src)
	new /obj/item/clothing/under/rank/miner(src)
	new /obj/item/clothing/gloves/black(src)
	new /obj/item/clothing/shoes/lw/black(src)
	new /obj/item/device/analyzer(src)
	new /obj/item/storage/bag/ore(src)
	new /obj/item/flame/torch/lantern(src)
	new /obj/item/shovel(src)
	new /obj/item/pickaxe(src)
	new /obj/item/clothing/glasses/meson(src)


/**********************Shuttle Computer**************************/

var/mining_shuttle_tickstomove = 10
var/mining_shuttle_moving = 0
var/mining_shuttle_location = 0 // 0 = station 13, 1 = mining station

proc/move_mining_shuttle()
	if(mining_shuttle_moving)	return
	mining_shuttle_moving = 1
	spawn(mining_shuttle_tickstomove*10)
		var/area/fromArea
		var/area/toArea
		if (mining_shuttle_location == 1)
			fromArea = locate(/area/shuttle/mining/outpost)
			toArea = locate(/area/shuttle/mining/station)

		else
			fromArea = locate(/area/shuttle/mining/station)
			toArea = locate(/area/shuttle/mining/outpost)

		var/list/dstturfs = list()
		var/throwy = world.maxy

		for(var/turf/T in toArea)
			dstturfs += T
			if(T.y < throwy)
				throwy = T.y

		// hey you, get out of the way!
		for(var/turf/T in dstturfs)
			// find the turf to move things to
			var/turf/D = locate(T.x, throwy - 1, 1)
			//var/turf/E = get_step(D, SOUTH)
			for(var/atom/movable/AM as mob|obj in T)
				AM.Move(D)
				// NOTE: Commenting this out to avoid recreating mass driver glitch
				/*
				spawn(0)
					AM.throw_at(E, 1, 1)
					return
				*/

			if(istype(T, /turf/simulated))
				qdel(T)

		for(var/mob/living/carbon/bug in toArea) // If someone somehow is still in the shuttle's docking area...
			bug.gib()

		for(var/mob/living/simple_animal/pest in toArea) // And for the other kind of bug...
			pest.gib()

		fromArea.move_contents_to(toArea)
		if (mining_shuttle_location)
			mining_shuttle_location = 0
		else
			mining_shuttle_location = 1

		for(var/mob/M in toArea)
			if(M.client)
				spawn(0)
					if(M.buckled)
						shake_camera(M, 3, 1) // buckled, not a lot of shaking
					else
						shake_camera(M, 10, 1) // unbuckled, HOLY SHIT SHAKE THE ROOM
			if(istype(M, /mob/living/carbon))
				if(!M.buckled)
					M.Weaken(3)

		mining_shuttle_moving = 0
	return

/obj/machinery/computer/mining_shuttle
	name = "mining shuttle console"
	icon = 'icons/obj/computer.dmi'
	icon_state = "shuttle"
	req_access = list(access_mining)
	circuit = "/obj/item/circuitboard/mining_shuttle"
	var/hacked = 0
	var/location = 0 //0 = station, 1 = mining base

/obj/machinery/computer/mining_shuttle/attack_hand(user as mob)
	if(..(user))
		return
	src.add_fingerprint(usr)
	var/dat

	dat = "<center>Mining Shuttle Control<hr>"

	if(mining_shuttle_moving)
		dat += "Location: <font color='red'>Moving</font> <br>"
	else
		dat += "Location: [mining_shuttle_location ? "Outpost" : "Station"] <br>"

	dat += "<b><A href='byond://?src=\ref[src];move=[1]'>Send</A></b></center>"


	user << browse("[dat]", "window=miningshuttle;size=200x150")

/obj/machinery/computer/mining_shuttle/Topic(href, href_list)
	if(..())
		return
	usr.set_machine(src)
	src.add_fingerprint(usr)
	if(href_list["move"])
		if (!mining_shuttle_moving)
			usr << "\blue Shuttle recieved message and will be sent shortly."
			move_mining_shuttle()
		else
			usr << "\blue Shuttle is already moving."

	updateUsrDialog()

/obj/machinery/computer/mining_shuttle/attackby(obj/item/W as obj, mob/user as mob)

	if (istype(W, /obj/item/card/emag))
		src.req_access = list()
		hacked = 1
		usr << "You fried the consoles ID checking system. It's now available to everyone!"

	else if(istype(W, /obj/item/screwdriver))
		playsound(src.loc, 'sound/items/Screwdriver.ogg', 50, 1)
		if(do_after(user, 20))
			var/obj/structure/computerframe/A = new /obj/structure/computerframe( src.loc )
			var/obj/item/circuitboard/mining_shuttle/M = new /obj/item/circuitboard/mining_shuttle( A )
			for (var/obj/C in src)
				C.loc = src.loc
			A.circuit = M
			A.anchored = 1

			if (src.stat & BROKEN)
				user << "\blue The broken glass falls out."
				new /obj/item/shard( src.loc )
				A.state = 3
				A.icon_state = "3"
			else
				user << "\blue You disconnect the monitor."
				A.state = 4
				A.icon_state = "4"

			qdel(src)

/******************************Lantern*******************************/
/*
/obj/item/device/flashlight/lantern
	name = "lantern"
	icon_state = "lantern"
	desc = "A mining lantern."
	brightness_red = 3
	brightness_green = 3
	brightness_blue = 2
*/
/*****************************Pickaxe********************************/

/obj/item/pickaxe
	name = "pickaxe"
	icon = 'icons/obj/items.dmi'
	icon_state = "pickaxe"
	flags = FPRINT | TABLEPASS| CONDUCT
	slot_flags = SLOT_BELT
	force = 8
	throwforce = 4.0
	edge = 1
	embed = 1
	penetrating = TRUE
	item_state = "pickaxe"
	w_class = 4.0
	m_amt = 3750 //one sheet, but where can you make them?
	var/digspeed = 40 //moving the delay to an item var so R&D can make improved picks. --NEO
	origin_tech = "materials=1;engineering=1"
	attack_verb = list("hit", "pierced", "sliced", "attacked")
	var/mining_power = 4
	var/drill_sound = null
	var/drill_verb = "picking"
	embedicon = "pickaxe"
	smelted_return = /obj/item/ore/refined/lw/ironlw

	var/excavation_amount = 100

	hammer
		name = "sledgehammer"
		//icon_state = "sledgehammer" Waiting on sprite
		desc = "A mining hammer made of reinforced metal. You feel like smashing your boss in the face with this."
		mining_power = 2

	silver
		name = "silver pickaxe"
		icon_state = "spickaxe"
		item_state = "spickaxe"
		digspeed = 30
		origin_tech = "materials=3"
		desc = "This makes no metallurgic sense."
		mining_power = 3

	drill
		name = "mining drill" // Can dig sand as well!
		icon_state = "handdrill"
		item_state = "jackhammer"
		digspeed = 30
		origin_tech = "materials=2;powerstorage=3;engineering=2"
		desc = "Yours is the drill that will pierce through the rock walls."

	jackhammer
		name = "sonic jackhammer"
		icon_state = "jackhammer"
		item_state = "jackhammer"
		digspeed = 20 //faster than drill, but cannot dig
		origin_tech = "materials=3;powerstorage=2;engineering=2"
		desc = "Cracks rocks with sonic blasts, perfect for killing cave lizards."

	gold
		name = "golden pickaxe"
		icon_state = "gpickaxe"
		item_state = "gpickaxe"
		digspeed = 20
		origin_tech = "materials=4"
		desc = "This makes no metallurgic sense."
		mining_power = 3

	diamond
		name = "diamond pickaxe"
		icon_state = "dpickaxe"
		item_state = "dpickaxe"
		digspeed = 10
		origin_tech = "materials=6;engineering=4"
		desc = "A pickaxe with a diamond pick head, this is just like minecraft."

	diamonddrill //When people ask about the badass leader of the mining tools, they are talking about ME!
		name = "diamond mining drill"
		icon_state = "diamonddrill"
		item_state = "jackhammer"
		digspeed = 5 //Digs through walls, girders, and can dig up sand
		origin_tech = "materials=6;powerstorage=4;engineering=5"
		desc = "Yours is the drill that will pierce the heavens!"

	borgdrill
		name = "cyborg mining drill"
		icon_state = "diamonddrill"
		item_state = "jackhammer"
		digspeed = 15
		desc = ""

/*****************************Shovel********************************/

/obj/item/shovel
	name = "shovel"
	desc = "A shovel for digging and bashing someone's skull when necessary."
	icon = 'icons/obj/items.dmi'
	flags = FPRINT | TABLEPASS| CONDUCT
	slot_flags = SLOT_BELT
	force = 18.0
	throwforce = 4.0
	item_state = "shovel"
	w_class = 3.0
	m_amt = 50
	edge = 0
	sharp = 0
	origin_tech = "materials=1;engineering=1"
	attack_verb = list("bashed", "bludgeoned", "thrashed", "whacked")
	full = 0
	icon_state = "shovel"
	hitsound = "shovel"
	swing_sound = "shovelswing"
	drop_sound = 'sound/effects/shovel_drop.ogg'
	smelted_return = /obj/item/ore/refined/lw/ironlw

/obj/item/shovel/update_icon()
	if(src.contents.len)
		icon_state = "shovel1"
	else
		icon_state = "shovel0"

/obj/item/shovel/attack(var/mob/living/carbon/human/M, var/mob/living/carbon/human/user) //This is really fucking bad.
	..()
	if(!..()) return //Something else failed don't bother with this at all.
	if(user.zone_sel.selecting == "head")
		var/bother_with_this = TRUE
		var/obj/item/clothing/worn_helmet = M.head
		if(worn_helmet)
			if(worn_helmet.armor_type >= ARMOR_CHAINMAIL)//Check if they're wearing strong armor.
				bother_with_this = FALSE
		if(user.dir != M.dir)//Check if we're behind them.
			bother_with_this = FALSE
		if(bother_with_this)//Ok they're not wearing head armor and we are behind them, roll to knock them out.
			if(prob(50))
				M.Stun(8)
				M.Weaken(8)
				M.Paralyse(8)
				M.ear_deaf = max(M.ear_deaf,6)
				M.Jitter(8)


/obj/item/shovel/spade
	name = "spade"
	desc = "A small tool for digging and moving dirt."
	icon_state = "spade"
	item_state = "spade"
	force = 5.0
	throwforce = 7.0
	w_class = 2.0