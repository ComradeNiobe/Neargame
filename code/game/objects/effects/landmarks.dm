/obj/effect/landmark
	name = "landmark"
	icon = 'icons/mob/screen1.dmi'
	icon_state = "x2"
	anchored = 1.0
	unacidable = 1
	flammable = 0

/obj/effect/landmark/New()
	. = ..()
	tag = text("landmark*[]", name)
	invisibility = 101

	switch(name)			//some of these are probably obsolete
		if("shuttle")
			shuttle_z = z
			qdel(src)

		if("airtunnel_stop")
			airtunnel_stop = x

		if("airtunnel_start")
			airtunnel_start = x

		if("airtunnel_bottom")
			airtunnel_bottom = y

		if("monkey")
			monkeystart += loc
			qdel(src)
		if("start")
			newplayer_start += loc
			qdel(src)
		if("migstart")
			migstart += src
			//qdel(src)

		if("wizard")
			wizardstart += loc
			qdel(src)

		if("regurgitator")
			regurgilist += loc

		if("nukeSpawn")
			nukeSpawn += loc
			qdel(src)

		if("HellDoor")
			HellDoor += loc
			qdel(src)

		if("JoinLate")
			latejoin += loc
			qdel(src)

		if("MiniWarS")
			MiniWarJoinS += loc
			qdel(src)

		if("MiniWarN")
			MiniWarJoinN += loc
			qdel(src)

		//prisoners
		if("prisonwarp")
			prisonwarp += loc
			qdel(src)
	//	if("mazewarp")
	//		mazewarp += loc
		if("Holding Facility")
			holdingfacility += loc
		if("tdome1")
			tdome1	+= loc
		if("tdome2")
			tdome2 += loc
		if("tdomeadmin")
			tdomeadmin	+= loc
		if("tdomeobserve")
			tdomeobserve += loc
		//not prisoners
		if("prisonsecuritywarp")
			prisonsecuritywarp += loc
			qdel(src)

		if("xeno_spawn")
			xeno_spawn += loc
			qdel(src)

		if("ninjastart")
			ninjastart += loc
			qdel(src)
		if("dreamerspawn")
			dreamerspawn = loc
			qdel(src)
		if("bombchurchloc")
			bombchurch_loc = loc
			qdel(src)
		if("siegecamp")
			siegecamp += loc
			qdel(src)

	landmarks_list |= src
	return 1

/obj/effect/landmark/Destroy()
	. = ..()
	landmarks_list -= src
	loc = null
	tag = null
	qdel(reagents)


/obj/effect/landmark/start
	name = "start"
	icon = 'icons/mob/screen1.dmi'
	icon_state = "x"
	anchored = 1.0

/obj/effect/landmark/start/New()
	. = ..()
	tag = "start*[name]"
	invisibility = 101

	return 1

/obj/effect/landmark/start/Destroy()
	. = ..()
	tag = null

/obj/effect/landmark/mapinfo
	name = "mapinfo"
	icon = 'icons/mob/screen1.dmi'
	icon_state = "x"
	anchored = 1.0
	var/mapname = "Default"

/obj/effect/landmark/mapinfo/New()
	. = ..()

//Costume spawner landmarks

/obj/effect/landmark/costume/New() //costume spawner, selects a random subclass and disappears

	var/list/options = typesof(/obj/effect/landmark/costume)
	var/PICK= options[rand(1,options.len)]
	new PICK(src.loc)
	qdel(src)

//SUBCLASSES.  Spawn a bunch of items and disappear likewise
/obj/effect/landmark/costume/chicken/New()
	new /obj/item/clothing/suit/chickensuit(src.loc)
	new /obj/item/clothing/mask/chicken(src.loc)
	new /obj/item/reagent_containers/food/snacks/egg(src.loc)
	qdel(src)

/obj/effect/landmark/costume/madscientist/New()
	new /obj/item/clothing/under/gimmick/rank/captain/suit(src.loc)
	new /obj/item/clothing/head/flatcap(src.loc)
	new /obj/item/clothing/suit/storage/labcoat/mad(src.loc)
	new /obj/item/clothing/glasses/greenglasses(src.loc)
	qdel(src)

/obj/effect/landmark/costume/elpresidente/New()
	new /obj/item/clothing/under/gimmick/rank/captain/suit(src.loc)
	new /obj/item/clothing/head/flatcap(src.loc)
	new /obj/item/clothing/mask/cigarette/cigar/havana(src.loc)
	qdel(src)

/obj/effect/landmark/costume/butler/New()
	new /obj/item/clothing/suit/wcoat(src.loc)
	new /obj/item/clothing/under/suit_jacket(src.loc)
	new /obj/item/clothing/head/that(src.loc)
	qdel(src)

/obj/effect/landmark/costume/prig/New()
	new /obj/item/clothing/suit/wcoat(src.loc)
	new /obj/item/clothing/glasses/monocle(src.loc)
	var/CHOICE= /obj/item/clothing/head/that
	new CHOICE(src.loc)
	new /obj/item/cane(src.loc)
	new /obj/item/clothing/under/sl_suit(src.loc)
	new /obj/item/clothing/mask/fakemoustache(src.loc)
	qdel(src)

/obj/effect/landmark/costume/plaguedoctor/New()
	new /obj/item/clothing/suit/bio_suit/plaguedoctorsuit(src.loc)
	qdel(src)

/obj/effect/landmark/costume/nightowl/New()
	new /obj/item/clothing/under/owl(src.loc)
	new /obj/item/clothing/mask/gas/owl_mask(src.loc)
	qdel(src)

/obj/effect/landmark/costume/waiter/New()
	new /obj/item/clothing/under/waiter(src.loc)
	new /obj/item/clothing/suit/apron(src.loc)
	qdel(src)

/obj/effect/landmark/costume/pirate/New()
	new /obj/item/clothing/under/pirate(src.loc)
	new /obj/item/clothing/suit/pirate(src.loc)
	new /obj/item/clothing/glasses/Reyepatch(src.loc)
	qdel(src)

/obj/effect/landmark/costume/commie/New()
	new /obj/item/clothing/under/soviet(src.loc)
	new /obj/item/clothing/head/ushanka(src.loc)
	qdel(src)

/obj/effect/landmark/costume/holiday_priest/New()
	new /obj/item/clothing/suit/holidaypriest(src.loc)
	qdel(src)

/obj/effect/landmark/costume/marisawizard/fake/New()
	new /obj/item/clothing/head/wizard/marisa/fake(src.loc)
	new/obj/item/clothing/suit/wizrobe/marisa/fake(src.loc)
	qdel(src)

/obj/effect/landmark/costume/cutewitch/New()
	new /obj/item/clothing/under/sundress(src.loc)
	new /obj/item/clothing/head/witchwig(src.loc)
	new /obj/item/staff/broom(src.loc)
	qdel(src)

/obj/effect/landmark/costume/fakewizard/New()
	new /obj/item/clothing/suit/wizrobe/fake(src.loc)
	new /obj/item/clothing/head/wizard/fake(src.loc)
	new /obj/item/staff/(src.loc)
	qdel(src)

/obj/effect/landmark/alterations
	name = "alterations"

/obj/effect/landmark/alterations/nopath
	name = "Bot No-Path"

/obj/effect/landmark/sieger_spawn
	name = ""
	icon = 'icons/misc/trip.dmi'
	icon_state = "trip4"

/obj/effect/landmark/sieger_spawn/New()
	..()
	siegestart += src
	invisibility = 0