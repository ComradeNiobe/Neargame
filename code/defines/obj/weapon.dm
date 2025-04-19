/obj/item
	var/typeDamage = BRUTE //COISA PRO FUTURO

/obj/item/phone
	name = "red phone"
	desc = "Should anything ever go wrong..."
	icon = 'icons/obj/items.dmi'
	icon_state = "red_phone"
	flags = FPRINT | TABLEPASS | CONDUCT
	force = 3.0
	throwforce = 2.0
	throw_speed = 1
	throw_range = 4
	w_class = 2
	attack_verb = list("called", "rang")
	hitsound = 'sound/weapons/ring.ogg'

/obj/item/rsp
	name = "\improper Rapid-Seed-Producer (RSP)"
	desc = "A device used to rapidly deploy seeds."
	icon = 'icons/obj/items.dmi'
	icon_state = "rcd"
	opacity = 0
	density = 0
	anchored = 0.0
	var/matter = 0
	var/mode = 1
	flags = TABLEPASS
	w_class = 3.0

/obj/item/bananapeel
	name = "banana peel"
	desc = "A peel from a banana."
	icon = 'icons/obj/items.dmi'
	icon_state = "banana_peel"
	item_state = "banana_peel"
	w_class = 1.0
	throwforce = 0
	throw_speed = 4
	throw_range = 20

/obj/item/soap
	name = "soap"
	desc = "A cheap bar of soap. Doesn't smell."
	gender = PLURAL
	icon = 'icons/obj/items.dmi'
	icon_state = "soap"
	w_class = 1.0
	throwforce = 0
	throw_speed = 4
	throw_range = 20

/obj/item/soap/Crossed(AM as mob|obj)
	if(iscarbon(AM))
		var/mob/living/carbon/M = AM
		if(prob(25))
			M.stumble(1,src)
	else
		return

/obj/item/soap/nanotrasen
	desc = "A Nanotrasen brand bar of soap. Smells of plasma."
	icon_state = "soapnt"

/obj/item/soap/deluxe
	desc = "A deluxe Waffle Co. brand bar of soap. Smells of condoms."
	icon_state = "soapdeluxe"

/obj/item/soap/syndie
	desc = "An untrustworthy bar of soap. Smells of fear."
	icon_state = "soapsyndie"

/obj/item/bikehorn
	name = "bike horn"
	desc = "A horn off of a bicycle."
	icon = 'icons/obj/items.dmi'
	icon_state = "bike_horn"
	item_state = "bike_horn"
	throwforce = 3
	w_class = 1.0
	throw_speed = 3
	throw_range = 15
	attack_verb = list("HONKED")
	var/spam_flag = 0


/obj/item/c_tube
	name = "cardboard tube"
	desc = "A tube... of cardboard."
	icon = 'icons/obj/items.dmi'
	icon_state = "c_tube"
	throwforce = 1
	w_class = 1.0
	throw_speed = 4
	throw_range = 5


/obj/item/cane
	name = "caduceus"
	icon = 'icons/obj/weapons.dmi'
	icon_state = "caduceus"
	item_state = "caduceus"
	flags = FPRINT | TABLEPASS| CONDUCT
	force = 5.0
	throwforce = 7.0
	w_class = 2.0
	m_amt = 50
	attack_verb = list("bludgeoned", "whacked", "disciplined", "thrashed")

/obj/item/disk
	name = "disk"
	icon = 'icons/obj/items.dmi'

/obj/item/disk/nuclear
	name = "nuclear authentication disk"
	desc = "Better keep this safe."
	icon_state = "nucleardisk"
	item_state = "card-id"
	w_class = 1.0
	flammable = 0

/*
/obj/item/game_kit
	name = "Gaming Kit"
	icon = 'icons/obj/items.dmi'
	icon_state = "game_kit"
	var/selected = null
	var/board_stat = null
	var/data = ""
	var/base_url = "http://svn.slurm.us/public/spacestation13/misc/game_kit"
	item_state = "sheet-metal"
	w_class = 5.0
*/

/obj/item/gift
	name = "gift"
	desc = "A wrapped item."
	icon = 'icons/obj/items.dmi'
	icon_state = "gift3"
	var/size = 3.0
	var/obj/item/gift = null
	item_state = "gift"
	w_class = 4.0

/obj/item/legcuffs
	name = "legcuffs"
	desc = "Use this to keep prisoners in line."
	gender = PLURAL
	icon = 'icons/obj/items.dmi'
	icon_state = "handcuff"
	flags = FPRINT | TABLEPASS | CONDUCT
	throwforce = 0
	w_class = 3.0
	origin_tech = "materials=1"
	var/breakouttime = 300	//Deciseconds = 30s = 0.5 minute

/obj/item/legcuffs/beartrap
	name = "bear trap"
	throw_speed = 2
	throw_range = 1
	icon_state = "beartrap0"
	desc = "A trap used to catch bears and other legged creatures."
	var/armed = 0

	suicide_act(mob/user)
		viewers(user) << "\red <b>[user] is putting the [src.name] on \his head! It looks like \he's trying to commit suicide.</b>"
		return (BRUTELOSS)

/obj/item/legcuffs/beartrap/attack_self(mob/user as mob)
	..()
	if(ishuman(user) && !user.stat && !user.restrained())
		armed = !armed
		icon_state = "beartrap[armed]"
		user << "<span class='notice'>[src] is now [armed ? "armed" : "disarmed"]</span>"

/obj/item/legcuffs/beartrap/Crossed(AM as mob|obj)
	if(armed)
		if(ishuman(AM))
			if(isturf(src.loc))
				var/mob/living/carbon/H = AM
				if(H.m_intent == "run")
					armed = 0
					H.legcuffed = src
					src.loc = H
					H.update_inv_legcuffed()
					H << "\red <B>You step on \the [src]!</B>"
					for(var/mob/O in viewers(H, null))
						if(O == H)
							continue
						O.show_message("\red <B>[H] steps on \the [src].</B>", 1)
		if(isanimal(AM) && !istype(AM, /mob/living/simple_animal/parrot) && !istype(AM, /mob/living/simple_animal/construct) && !istype(AM, /mob/living/simple_animal/shade))
			armed = 0
			var/mob/living/simple_animal/SA = AM
			SA.health -= 20
	..()

/obj/item/legcuffs/bola
	name = "throwing net"
	desc = "A restraining device designed to be thrown at the target. Upon connecting with said target, it will wrap around their legs, making it difficult for them to move quickly."
	icon = 'icons/obj/weapons.dmi'
	icon_state = "net_hands"
	item_state = "net_hands"
	breakouttime = 350//easy to apply, easy to break out of
	var/knockdown = 0
	slot_flags = SLOT_BELT|SLOT_BACK
	drawsound = 'sound/weapons/net_equip.ogg'

/obj/item/legcuffs/bola/throw_at(atom/target, range, speed, mob/thrower, spin=1, diagonals_first = 0, gentle = FALSE, quickstart = TRUE)
	if(!..())
		return
	playsound(src.loc,'sound/weapons/net_equip.ogg', 75, 0)

/obj/item/legcuffs/bola/throw_impact(atom/hit_atom)
	if((ishuman(hit_atom)))
		var/mob/living/carbon/human/H = hit_atom
		ensnare(H)

/**
  * Attempts to legcuff someone with the bola
  *
  * Arguments:
  * * C - the carbon that we will try to ensnare
  */
/obj/item/legcuffs/bola/proc/ensnare(mob/living/carbon/C)
	if(!C.legcuffed)
		visible_message("<span class='danger'>\The [src] ensnares [C]!</span>")
		C.legcuffed = src
		forceMove(C)
		C.update_inv_legcuffed()
		to_chat(C, "<span class='userdanger'>\The [src] ensnares you!</span>")
		playsound(C, 'sound/weapons/net_captured.ogg', 50, 0)


/obj/item/caution
	desc = "Caution! Wet Floor!"
	name = "wet floor sign"
	icon = 'icons/obj/janitor.dmi'
	icon_state = "caution"
	force = 1.0
	throwforce = 3.0
	throw_speed = 1
	throw_range = 5
	w_class = 2.0
	flags = FPRINT | TABLEPASS
	attack_verb = list("warned", "cautioned", "smashed")

/obj/item/caution/cone
	desc = "This cone is trying to warn you of something!"
	name = "warning cone"
	icon_state = "cone"

/obj/item/rack_parts
	name = "rack parts"
	desc = "Parts of a rack."
	icon = 'icons/obj/items.dmi'
	icon_state = "rack_parts"
	flags = FPRINT | TABLEPASS| CONDUCT
	m_amt = 3750

/obj/item/shard
	name = "shard"
	icon = 'icons/obj/shards.dmi'
	icon_state = "large"
	sharp = TRUE
	edge = TRUE
	desc = "Could probably be used as ... a throwing weapon?"
	w_class = 1.0
	force = 5.0
	throwforce = 8.0
	item_state = "shard-glass"
	g_amt = 3750
	attack_verb = list("slashed", "sliced", "cut")

	suicide_act(mob/user)
		viewers(user) << pick("\red <b>[user] is slitting \his wrists with the shard of glass! It looks like \he's trying to commit suicide.</b>", \
							"\red <b>[user] is slitting \his throat with the shard of glass! It looks like \he's trying to commit suicide.</b>")
		return (BRUTELOSS)

/obj/item/shard/attack(mob/living/carbon/M as mob, mob/living/carbon/user as mob)
	if((M == user) && ishuman(user) && (user.zone_sel == "mouth"))
		playsound(src, 'sound/effects/crunchychewing.ogg', 70, FALSE)
		if(do_after(user, 2 SECONDS))
			var/mob/living/carbon/human/eating_glass = user
			var/datum/organ/internal/stomach/stomach = eating_glass.internal_organs_by_name["stomach"]
			if(stomach)
				stomach.take_damage(15)
			eating_glass.apply_damage(10, BRUTE, "mouth", sharp = TRUE, edge = TRUE, used_weapon = src)
			for(var/mob/O in viewers(world.view, user))
				O.show_message("<span class='combatbold'>[user]</span><span class='combat'> chews and swallows [src].</span>", 1)
				return 0
			qdel(src)
		return
	else
		playsound(loc, 'sound/weapons/bladeslice.ogg', 50, 1, -1)
	return ..()

/*/obj/item/syndicate_uplink
	name = "station bounced radio"
	desc = "Remain silent about this..."
	icon = 'icons/obj/radio.dmi'
	icon_state = "radio"
	var/temp = null
	var/uses = 10.0
	var/selfdestruct = 0.0
	var/traitor_frequency = 0.0
	var/mob/currentUser = null
	var/obj/item/device/radio/origradio = null
	flags = FPRINT | TABLEPASS | CONDUCT | ONBELT
	w_class = 2.0
	item_state = "radio"
	throw_speed = 4
	throw_range = 20
	m_amt = 100
	origin_tech = "magnets=2;syndicate=3"*/

/obj/item/shard/shrapnel
	name = "shrapnel"
	icon = 'icons/obj/shards.dmi'
	icon_state = "shrapnellarge"
	desc = "A bunch of tiny bits of shattered metal."

/obj/item/shard/shrapnel/New()

	src.icon_state = pick("shrapnellarge", "shrapnelmedium", "shrapnelsmall")
	switch(src.icon_state)
		if("shrapnelsmall")
			src.pixel_x = rand(-12, 12)
			src.pixel_y = rand(-12, 12)
		if("shrapnelmedium")
			src.pixel_x = rand(-8, 8)
			src.pixel_y = rand(-8, 8)
		if("shrapnellarge")
			src.pixel_x = rand(-5, 5)
			src.pixel_y = rand(-5, 5)
		else
	return

/obj/item/SWF_uplink
	name = "station-bounced radio"
	desc = "used to comunicate it appears."
	icon = 'icons/obj/radio.dmi'
	icon_state = "radio"
	var/temp = null
	var/uses = 4.0
	var/selfdestruct = 0.0
	var/traitor_frequency = 0.0
	var/obj/item/device/radio/origradio = null
	flags = FPRINT | TABLEPASS| CONDUCT
	slot_flags = SLOT_BELT
	item_state = "radio"
	throwforce = 5
	w_class = 2.0
	throw_speed = 4
	throw_range = 20
	m_amt = 100
	origin_tech = "magnets=1"

/obj/item/staff
	name = "wizards staff"
	desc = "Apparently a staff used by the wizard."
	icon = 'icons/obj/wizard.dmi'
	icon_state = "staff"
	force = 3.0
	throwforce = 5.0
	throw_speed = 1
	throw_range = 5
	w_class = 2.0
	flags = FPRINT | TABLEPASS | NOSHIELD
	attack_verb = list("bludgeoned", "whacked", "disciplined")

/obj/item/staff/broom
	name = "broom"
	desc = "Used for sweeping, and flying into the night while cackling. Black cat not included."
	icon = 'icons/obj/wizard.dmi'
	icon_state = "broom"

/obj/item/staff/gentcane
	name = "Gentlemans Cane"
	desc = "An ebony can with an ivory tip."
	icon = 'icons/obj/weapons.dmi'
	icon_state = "cane"
	item_state = "stick"

/obj/item/staff/stick
	name = "stick"
	desc = "A great tool to drag someone else's drinks across the bar."
	icon = 'icons/obj/weapons.dmi'
	icon_state = "stick"
	item_state = "stick"
	force = 3.0
	throwforce = 5.0
	throw_speed = 1
	throw_range = 5
	w_class = 2.0
	flags = FPRINT | TABLEPASS | NOSHIELD

/obj/item/table_parts
	name = "table parts"
	desc = "Parts of a table. Poor table."
	gender = PLURAL
	icon = 'icons/obj/items.dmi'
	icon_state = "table_parts"
	m_amt = 3750
	flags = FPRINT | TABLEPASS| CONDUCT
	attack_verb = list("slammed", "bashed", "battered", "bludgeoned", "thrashed", "whacked")

/obj/item/table_parts/reinforced
	name = "reinforced table parts"
	desc = "Hard table parts. Well...harder..."
	icon = 'icons/obj/items.dmi'
	icon_state = "reinf_tableparts"
	m_amt = 7500
	flags = FPRINT | TABLEPASS| CONDUCT

/obj/item/table_parts/wood
	name = "wooden table parts"
	desc = "Keep away from fire."
	icon_state = "wood_tableparts"
	flags = null

/obj/item/wire
	desc = "This is just a simple piece of regular insulated wire."
	name = "wire"
	icon = 'icons/obj/power.dmi'
	icon_state = "item_wire"
	var/amount = 1.0
	var/laying = 0.0
	var/old_lay = null
	m_amt = 40
	attack_verb = list("whipped", "lashed", "disciplined", "tickled")

	suicide_act(mob/user)
		viewers(user) << "\red <b>[user] is strangling \himself with the [src.name]! It looks like \he's trying to commit suicide.</b>"
		return (OXYLOSS)

/obj/item/module
	icon = 'icons/obj/module.dmi'
	icon_state = "std_module"
	w_class = 2.0
	item_state = "electronic"
	flags = FPRINT|TABLEPASS|CONDUCT
	var/mtype = 1						// 1=electronic 2=hardware

/obj/item/module/card_reader
	name = "card reader module"
	icon_state = "card_mod"
	desc = "An electronic module for reading data and ID cards."

/obj/item/module/power_control
	name = "power control module"
	icon_state = "power_mod"
	desc = "Heavy-duty switching circuits for power control."
	m_amt = 50
	g_amt = 50

/obj/item/module/id_auth
	name = "\improper ID authentication module"
	icon_state = "id_mod"
	desc = "A module allowing secure authorization of ID cards."

/obj/item/module/cell_power
	name = "power cell regulator module"
	icon_state = "power_mod"
	desc = "A converter and regulator allowing the use of power cells."

/obj/item/module/cell_power
	name = "power cell charger module"
	icon_state = "power_mod"
	desc = "Charging circuits for power cells."


/obj/item/device/camera_bug
	name = "camera bug"
	icon = 'icons/obj/device.dmi'
	icon_state = "flash"
	w_class = 1.0
	item_state = "electronic"
	throw_speed = 4
	throw_range = 20

/obj/item/camera_bug/attack_self(mob/usr as mob)
	var/list/cameras = new/list()
	for (var/obj/machinery/camera/C in cameranet.cameras)
		if (C.bugged && C.status)
			cameras.Add(C)
	if (length(cameras) == 0)
		usr << "\red No bugged functioning cameras found."
		return

	var/list/friendly_cameras = new/list()

	for (var/obj/machinery/camera/C in cameras)
		friendly_cameras.Add(C.c_tag)

	var/target = input("Select the camera to observe", null) as null|anything in friendly_cameras
	if (!target)
		return
	for (var/obj/machinery/camera/C in cameras)
		if (C.c_tag == target)
			target = C
			break
	if (usr.stat == 2) return

	usr.client.eye = target


/obj/item/syntiflesh
	name = "syntiflesh"
	desc = "Meat that appears...strange..."
	icon = 'icons/obj/food.dmi'
	icon_state = "meat"
	flags = FPRINT | TABLEPASS | CONDUCT
	w_class = 1.0
	origin_tech = "biotech=2"

/obj/item/hatchet
	name = "axe"
	icon = 'icons/obj/weapons.dmi'
	icon_state = "axe"
	item_state = "hatchet"
	embedicon = "axe"
	flags = FPRINT | TABLEPASS | CONDUCT
	force = 28.0
	w_class = 4
	slot_flags = SLOT_BELT
	throwforce = 15.0
	sharp = TRUE
	throw_speed = 4
	throw_range = 4
	weaponteaching = "AXE"
	m_amt = 15000
	speciality = SKILL_SWING
	origin_tech = "materials=2;combat=1"
	attack_verb = list("chopped", "cut", "cleaved")
	drop_sound = 'sound/effects/axe_drop.ogg'
	drawsound = 'sound/weapons/axe_unsheath.ogg'
	hitsound= "axechop"
	swing_sound = "axeswing"
	force_wielded = 40.0
	force_unwielded = 28.0
	equip_sound = 'sound/weapons/axe_sheath.ogg'
	edge = TRUE
	weapon_speed_delay = 12
	smelted_return = /obj/item/ore/refined/lw/ironlw

/obj/item/hatchet/bronze
	name = "bronze axe"
	icon_state = "axe2"
	force_wielded = 35.0
	force_unwielded = 30.0
	force = 30.0
	smelted_return = /obj/item/ore/refined/lw/copperlw

/obj/item/hatchet/sun
	name = "axe of the sun"
	icon_state = "artiaxe2"
	force_wielded = 35.0
	force_unwielded = 30.0
	force = 35.0


/obj/item/hatchet/sun/attack(mob/living/carbon/human/M as mob, mob/living/carbon/human/user as mob)
	..()
	if(iszombie(M))
		if(prob(35))
			return
	else
		if(prob(75))
			return
	M.on_fire = 1
	M.bodytemperature = 1000
	M.update_fire()
	spawn(rand(4, 8))
		var/list/sound = list()
		sound = list('sound/voice/firescream_female1.ogg', 'sound/voice/firescream_female2.ogg')
		if(M.gender == "male")
			sound = list('sound/voice/firescream1.ogg', 'sound/voice/firescream2.ogg', 'sound/voice/firescream3.ogg')
		playsound(M, pick(sound), 200, 1)

/obj/item/hatchet/stone
	name = "stone axe"
	desc = "A very ancient axe."
	icon = 'icons/obj/weapons.dmi'
	icon_state = "saxe"
	force = 8.0
	force_wielded = 15.0
	force_unwielded = 8.0

/obj/item/hatchet/rusty
	name = "rusty axe"
	desc = "A very old axe."
	icon = 'icons/obj/weapons.dmi'
	icon_state = "rustyaxe"
	force = 21.2
	force_wielded = 25.5
	force_unwielded = 21.2

/obj/item/hatchet/unathiknife
	name = "duelling knife"
	desc = "A length of leather-bound wood studded with razor-sharp teeth. How crude."
	icon = 'icons/obj/weapons.dmi'
	icon_state = "unathiknife"
	attack_verb = list("ripped", "torn", "cut")

/obj/item/scythe
	icon_state = "scythe0"
	name = "scythe"
	desc = "A sharp and curved blade on a long fibremetal handle, this tool makes it easy to reap what you sow."
	force = 13.0
	throwforce = 5.0
	throw_speed = 1
	throw_range = 3
	w_class = 4.0
	flags = FPRINT | TABLEPASS | NOSHIELD
	slot_flags = SLOT_BACK
	origin_tech = "materials=2;combat=2"
	attack_verb = list("chopped", "sliced", "cut", "reaped")

/obj/item/scythe/afterattack(atom/A, mob/user as mob, proximity)
	if(!proximity) return

/*
/obj/item/cigarpacket
	name = "Pete's Cuban Cigars"
	desc = "The most robust cigars on the planet."
	icon = 'icons/obj/cigarettes.dmi'
	icon_state = "cigarpacket"
	item_state = "cigarpacket"
	w_class = 1
	throwforce = 2
	var/cigarcount = 6
	flags = ONBELT | TABLEPASS */

/obj/item/pai_cable
	desc = "A flexible coated cable with a universal jack on one end."
	name = "data cable"
	icon = 'icons/obj/power.dmi'
	icon_state = "wire1"

	var/obj/machinery/machine


/obj/item/horn
	name = "horn"
	icon = 'icons/obj/weapons.dmi'
	icon_state = "horn"
	var/cooldown
	var/distantsound = 'sound/effects/horn1d.ogg'
	var/closesound = 'sound/effects/horn1.ogg'
	flags = FPRINT | TABLEPASS | CONDUCT
	slot_flags = SLOT_BELT
	w_class = 4

/obj/item/horn/attack_self(mob/M)
	if(cooldown)	return
	M.visible_message("<span class='passivebold'>[M]</span> <span class='passive'>blows \the [src]!</span>")
	for(var/mob/L in mob_list)
		var/dirR = get_dir(L,M)
		if(get_dist(M, L) <= 10)
			var/distrange = get_dist(M, L)
			L << sound(closesound, repeat = 0, wait = 0, volume = 80-distrange, channel = 12)
		else
			to_chat(L, "<span class='passive'><i>I hear a distant horn sound coming from the [dir2text(dirR)]</i></span>")
			L << sound(distantsound, repeat = 0, wait = 0, volume = 100, channel = 13)
	cooldown = 1
	spawn(450)
		cooldown = 0

/obj/item/horn/horn2
	name = "horn"
	icon = 'icons/obj/weapons.dmi'
	icon_state = "horn2"
	distantsound = 'sound/effects/horn2d.ogg'
	closesound = 'sound/effects/horn2.ogg'

///////////////////////////////////////Stock Parts /////////////////////////////////

/obj/item/stock_parts
	name = "stock part"
	desc = "What?"
	gender = PLURAL
	icon = 'icons/obj/stock_parts.dmi'
	w_class = 2.0
	var/rating = 1
	New()
		src.pixel_x = rand(-5.0, 5)
		src.pixel_y = rand(-5.0, 5)

//Rank 1

/obj/item/stock_parts/console_screen
	name = "console screen"
	desc = "Used in the construction of computers and other devices with a interactive console."
	icon_state = "screen"
	origin_tech = "materials=1"
	g_amt = 200

/obj/item/stock_parts/capacitor
	name = "capacitor"
	desc = "A basic capacitor used in the construction of a variety of devices."
	icon_state = "capacitor"
	origin_tech = "powerstorage=1"
	m_amt = 50
	g_amt = 50

/obj/item/stock_parts/scanning_module
	name = "scanning module"
	desc = "A compact, high resolution scanning module used in the construction of certain devices."
	icon_state = "scan_module"
	origin_tech = "magnets=1"
	m_amt = 50
	g_amt = 20

/obj/item/stock_parts/manipulator
	name = "micro-manipulator"
	desc = "A tiny little manipulator used in the construction of certain devices."
	icon_state = "micro_mani"
	origin_tech = "materials=1;programming=1"
	m_amt = 30

/obj/item/stock_parts/micro_laser
	name = "micro-laser"
	desc = "A tiny laser used in certain devices."
	icon_state = "micro_laser"
	origin_tech = "magnets=1"
	m_amt = 10
	g_amt = 20

/obj/item/stock_parts/matter_bin
	name = "matter bin"
	desc = "A container for hold compressed matter awaiting re-construction."
	icon_state = "matter_bin"
	origin_tech = "materials=1"
	m_amt = 80

//Rank 2

/obj/item/stock_parts/capacitor/adv
	name = "advanced capacitor"
	icon_state = "adv_capacitor"
	desc = "An advanced capacitor used in the construction of a variety of devices."
	origin_tech = "powerstorage=3"
	rating = 2
	m_amt = 50
	g_amt = 50

/obj/item/stock_parts/scanning_module/adv
	name = "advanced scanning module"
	icon_state = "adv_scan_module"
	desc = "A compact, high resolution scanning module used in the construction of certain devices."
	icon_state = "scan_module"
	origin_tech = "magnets=3"
	rating = 2
	m_amt = 50
	g_amt = 20

/obj/item/stock_parts/manipulator/nano
	name = "nano-manipulator"
	desc = "A tiny little manipulator used in the construction of certain devices."
	icon_state = "nano_mani"
	origin_tech = "materials=3,programming=2"
	rating = 2
	m_amt = 30

/obj/item/stock_parts/micro_laser/high
	name = "high-power micro-laser"
	desc = "A tiny laser used in certain devices."
	icon_state = "high_micro_laser"
	origin_tech = "magnets=3"
	rating = 2
	m_amt = 10
	g_amt = 20

/obj/item/stock_parts/matter_bin/adv
	name = "advanced matter bin"
	desc = "A container for hold compressed matter awaiting re-construction."
	icon_state = "advanced_matter_bin"
	origin_tech = "materials=3"
	rating = 2
	m_amt = 80

//Rating 3

/obj/item/stock_parts/capacitor/super
	name = "super capacitor"
	icon_state = "super_capacitor"
	desc = "A super-high capacity capacitor used in the construction of a variety of devices."
	origin_tech = "powerstorage=5;materials=4"
	rating = 3
	m_amt = 50
	g_amt = 50

/obj/item/stock_parts/scanning_module/phasic
	name = "phasic scanning module"
	icon_state = "super_scan_module"
	desc = "A compact, high resolution phasic scanning module used in the construction of certain devices."
	origin_tech = "magnets=5"
	rating = 3
	m_amt = 50
	g_amt = 20

/obj/item/stock_parts/manipulator/pico
	name = "pico-manipulator"
	desc = "A tiny little manipulator used in the construction of certain devices."
	icon_state = "pico_mani"
	origin_tech = "materials=5,programming=2"
	rating = 3
	m_amt = 30

/obj/item/stock_parts/micro_laser/ultra
	name = "ultra-high-power micro-laser"
	icon_state = "ultra_high_micro_laser"
	desc = "A tiny laser used in certain devices."
	origin_tech = "magnets=5"
	rating = 3
	m_amt = 10
	g_amt = 20

/obj/item/stock_parts/matter_bin/super
	name = "super matter bin"
	desc = "A container for hold compressed matter awaiting re-construction."
	icon_state = "super_matter_bin"
	origin_tech = "materials=5"
	rating = 3
	m_amt = 80

// Subspace stock parts

/obj/item/stock_parts/subspace/ansible
	name = "subspace ansible"
	icon_state = "subspace_ansible"
	desc = "A compact module capable of sensing extradimensional activity."
	origin_tech = "programming=3;magnets=5;materials=4;bluespace=2"
	m_amt = 30
	g_amt = 10

/obj/item/stock_parts/subspace/filter
	name = "hyperwave filter"
	icon_state = "hyperwave_filter"
	desc = "A tiny device capable of filtering and converting super-intense radiowaves."
	origin_tech = "programming=4;magnets=2"
	m_amt = 30
	g_amt = 10

/obj/item/stock_parts/subspace/amplifier
	name = "subspace amplifier"
	icon_state = "subspace_amplifier"
	desc = "A compact micro-machine capable of amplifying weak subspace transmissions."
	origin_tech = "programming=3;magnets=4;materials=4;bluespace=2"
	m_amt = 30
	g_amt = 10

/obj/item/stock_parts/subspace/treatment
	name = "subspace treatment disk"
	icon_state = "treatment_disk"
	desc = "A compact micro-machine capable of stretching out hyper-compressed radio waves."
	origin_tech = "programming=3;magnets=2;materials=5;bluespace=2"
	m_amt = 30
	g_amt = 10

/obj/item/stock_parts/subspace/analyzer
	name = "subspace wavelength analyzer"
	icon_state = "wavelength_analyzer"
	desc = "A sophisticated analyzer capable of analyzing cryptic subspace wavelengths."
	origin_tech = "programming=3;magnets=4;materials=4;bluespace=2"
	m_amt = 30
	g_amt = 10

/obj/item/stock_parts/subspace/crystal
	name = "ansible crystal"
	icon_state = "ansible_crystal"
	desc = "A crystal made from pure glass used to transmit laser databursts to subspace."
	origin_tech = "magnets=4;materials=4;bluespace=2"
	g_amt = 50

/obj/item/stock_parts/subspace/transmitter
	name = "subspace transmitter"
	icon_state = "subspace_transmitter"
	desc = "A large piece of equipment used to open a window into the subspace dimension."
	origin_tech = "magnets=5;materials=5;bluespace=3"
	m_amt = 50

/obj/item/ectoplasm
	name = "ectoplasm"
	desc = "spooky"
	gender = PLURAL
	icon = 'icons/obj/wizard.dmi'
	icon_state = "ectoplasm"

/obj/item/research//Makes testing much less of a pain -Sieve
	name = "research"
	icon = 'icons/obj/stock_parts.dmi'
	icon_state = "capacitor"
	desc = "A debug item for research."
	origin_tech = "materials=8;programming=8;magnets=8;powerstorage=8;bluespace=8;combat=8;biotech=8;syndicate=8"


/obj/item/storage/part_replacer
	name = "Rapid Part Exchange Device"
	desc = "Special mechanical module made to store, sort, and apply standard machine parts."
	icon_state = "RPED"
	item_state = "RPED"
	w_class = 5
	can_hold = list(/obj/item/stock_parts)
	storage_slots = 21
	use_to_pickup = 1
	allow_quick_gather = 1
	allow_quick_empty = 1
	collection_mode = 1
	display_contents_with_number = 1
	max_w_class = 3
	max_combined_w_class = 42

/obj/item/storage/part_replacer/proc/play_rped_sound()
	//Plays the sound for RPED exhanging or installing parts.
	playsound(src, 'sound/items/rped.ogg', 40, 1)

//Sorts stock parts inside an RPED by their rating.
//Only use /obj/item/stock_parts/ with this sort proc!
/proc/cmp_rped_sort(var/obj/item/stock_parts/A, var/obj/item/stock_parts/B)
	return B.rating - A.rating



/obj/item/holosign_creator
	name = "holographic sign projector"
	desc = "A handy-dandy projector that displays a janitorial sign."
	icon = 'icons/obj/janitor.dmi'
	icon_state = "signmaker"
	item_state = "electronic"
	force = 5
	w_class = 2
	throwforce = 0
	throw_speed = 3
	throw_range = 7
	origin_tech = "programming=3"
	var/list/signs = list()
	var/max_signs = 10

/obj/item/holosign_creator/afterattack(atom/target, mob/user, flag)
	if(flag)
		var/turf/T = get_turf(target)
		var/obj/effect/overlay/holograph/H = locate() in T
		if(istype(target, /obj/structure/janitorialcart))	return
		if(istype(target, /obj/item/storage)) return
		if(H)
			user << "<span class='notice'>You use [src] to destroy [H].</span>"
			qdel(H)
		else
			if(signs.len < max_signs)
				H = new(get_turf(target))
				signs += H
				user << "<span class='notice'>You create \a [H] with [src].</span>"
			else
				user << "<span class='notice'>[src] is projecting at max capacity!</span>"

/obj/item/holosign_creator/attack(mob/living/carbon/human/M, mob/user)
	return

/obj/item/holosign_creator/attack_self(mob/user)
	if(signs.len)
		var/list/L = signs.Copy()
		for(var/sign in L)
			qdel(sign)
			signs -= sign
		user << "<span class='notice'>You clear all active holograms.</span>"


/obj/effect/overlay/holograph
	name = "wet floor sign"
	desc = "The words flicker as if they mean nothing."
	icon = 'icons/obj/janitor.dmi'
	icon_state = "holosign"
	anchored = 1
