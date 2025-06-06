/obj/structure/closet/secure_closet/captains
	name = "Captain's Locker"
	req_access = list(access_captain)
	icon_state = "capsecure1"
	icon_closed = "capsecure"
	icon_locked = "capsecure1"
	icon_opened = "capsecureopen"
	icon_broken = "capsecurebroken"
	icon_off = "capsecureoff"

	New()
		sleep(2)
		if(prob(50))
			new /obj/item/storage/backpack/captain(src)
		else
			new /obj/item/storage/backpack/satchel_cap(src)
		new /obj/item/clothing/suit/captunic(src)
		new /obj/item/clothing/head/helmet/cap(src)
		new /obj/item/clothing/under/rank/captain(src)
		new /obj/item/clothing/suit/armor/vest(src)
		new /obj/item/cartridge/captain(src)
		new /obj/item/clothing/head/helmet/swat(src)
		new /obj/item/clothing/shoes/brown(src)
		new /obj/item/device/radio/headset/heads/captain(src)
		new /obj/item/reagent_containers/food/drinks/flask(src)
		new /obj/item/clothing/gloves/captain(src)
		new /obj/item/gun/energy/gun(src)
		return



/obj/structure/closet/secure_closet/hop
	name = "Head of Personnel's Locker"
	req_access = list(access_hop)
	icon_state = "hopsecure1"
	icon_closed = "hopsecure"
	icon_locked = "hopsecure1"
	icon_opened = "hopsecureopen"
	icon_broken = "hopsecurebroken"
	icon_off = "hopsecureoff"

	New()
		sleep(2)
		new /obj/item/clothing/under/rank/head_of_personnel(src)
		new /obj/item/clothing/suit/armor/vest(src)
		new /obj/item/clothing/head/helmet(src)
		new /obj/item/cartridge/hop(src)
		new /obj/item/device/radio/headset/heads/hop(src)
		new /obj/item/clothing/shoes/brown(src)
		new /obj/item/storage/id_kit(src)
		new /obj/item/storage/id_kit( src )
		new /obj/item/device/flash(src)
		new /obj/item/clothing/glasses/sunglasses(src)
		return



/obj/structure/closet/secure_closet/hos
	name = "Safety Administrator's Locker"
	req_access = list(access_hos)
	icon_state = "hossecure1"
	icon_closed = "hossecure"
	icon_locked = "hossecure1"
	icon_opened = "hossecureopen"
	icon_broken = "hossecurebroken"
	icon_off = "hossecureoff"

	New()
		sleep(2)
		new /obj/item/storage/backpack/satchel_sec(src)
		new /obj/item/cartridge/hos(src)
		new /obj/item/device/radio/headset/heads/hos(src)
		if (config.use_loyalty_implants) new /obj/item/storage/lockbox/loyalty(src)
		new /obj/item/storage/flashbang_kit(src)
		new /obj/item/storage/belt/security(src)
		new /obj/item/device/flash(src)
		new /obj/item/melee/baton(src)
		new /obj/item/gun/energy/taser(src)
		new /obj/item/reagent_containers/spray/pepper(src)
		return



/obj/structure/closet/secure_closet/warden
	name = "Correctional Advisor's Locker"
	req_access = list(access_armory)
	icon_state = "wardensecure1"
	icon_closed = "wardensecure"
	icon_locked = "wardensecure1"
	icon_opened = "wardensecureopen"
	icon_broken = "wardensecurebroken"
	icon_off = "wardensecureoff"


	New()
		sleep(2)
		new /obj/item/storage/backpack/satchel_sec(src)
		new /obj/item/clothing/under/rank/advisor(src)
		new /obj/item/device/radio/headset/headset_sec(src)
		new /obj/item/clothing/glasses/sunglasses(src)
		new /obj/item/storage/flashbang_kit(src)
		new /obj/item/storage/belt/security(src)
		new /obj/item/reagent_containers/spray/pepper(src)
		new /obj/item/reagent_containers/spray/pepper(src)
		new /obj/item/melee/baton(src)
		return



/obj/structure/closet/secure_closet/security
	name = "Crew Supervisor's Locker"
	req_access = list(access_security)
	icon_state = "sec1"
	icon_closed = "sec"
	icon_locked = "sec1"
	icon_opened = "secopen"
	icon_broken = "secbroken"
	icon_off = "secoff"

	New()
		sleep(2)
		new /obj/item/storage/backpack/satchel_sec(src)
		new /obj/item/device/radio/headset/headset_sec(src)
		new /obj/item/storage/belt/security(src)
		new /obj/item/device/flash(src)
		new /obj/item/reagent_containers/spray/pepper(src)
		new /obj/item/reagent_containers/spray/pepper(src)
		new /obj/item/clothing/glasses/sunglasses(src)
		return



/obj/structure/closet/secure_closet/detective
	name = "Detective's Cabinet"
	req_access = list(access_forensics_lockers)
	icon_state = "cabinetdetective_locked"
	icon_closed = "cabinetdetective"
	icon_locked = "cabinetdetective_locked"
	icon_opened = "cabinetdetective_open"
	icon_broken = "cabinetdetective_broken"
	icon_off = "cabinetdetective_broken"

	New()
		sleep(2)
		new /obj/item/clothing/under/det(src)
		new /obj/item/clothing/suit/armor/det_suit(src)
		new /obj/item/clothing/suit/det_suit(src)
		new /obj/item/clothing/gloves/black(src)
		new /obj/item/clothing/head/det_hat(src)
		new /obj/item/clothing/shoes/brown(src)
		new /obj/item/device/radio/headset/headset_sec(src)
		new /obj/item/cartridge/detective(src)
		new /obj/item/clipboard(src)
		new /obj/item/device/detective_scanner(src)
		new /obj/item/storage/box/evidence(src)
		return

/obj/structure/closet/secure_closet/detective/update_icon()
	if(broken)
		icon_state = icon_broken
	else
		if(!opened)
			if(locked)
				icon_state = icon_locked
			else
				icon_state = icon_closed
		else
			icon_state = icon_opened

/obj/structure/closet/secure_closet/injection
	name = "Lethal Injections"
	req_access = list(access_hos)


	New()
		sleep(2)
		new /obj/item/reagent_containers/ld50_syringe/choral(src)
		new /obj/item/reagent_containers/ld50_syringe/choral(src)
		return



/obj/structure/closet/secure_closet/brig
	name = "Brig Locker"
	req_access = list(access_brig)
	anchored = 1

	New()
		new /obj/item/clothing/under/color/orange( src )
		new /obj/item/clothing/shoes/orange( src )
		return



/obj/structure/closet/secure_closet/courtroom
	name = "Courtroom Locker"
	req_access = list(access_court)

	New()
		sleep(2)
		new /obj/item/clothing/shoes/brown(src)
		new /obj/item/paper/Court (src)
		new /obj/item/paper/Court (src)
		new /obj/item/paper/Court (src)
		new /obj/item/pen (src)
		new /obj/item/clothing/suit/judgerobe (src)
		new /obj/item/clothing/head/powdered_wig (src)
		new /obj/item/storage/briefcase(src)
		return

/obj/structure/closet/secure_closet/wall
	name = "wall locker"
	req_access = list(access_security)
	icon_state = "wall-locker1"
	density = 1
	icon_closed = "wall-locker"
	icon_locked = "wall-locker1"
	icon_opened = "wall-lockeropen"
	icon_broken = "wall-lockerbroken"
	icon_off = "wall-lockeroff"

	//too small to put a man in
	large = 0

/obj/structure/closet/secure_closet/wall/update_icon()
	if(broken)
		icon_state = icon_broken
	else
		if(!opened)
			if(locked)
				icon_state = icon_locked
			else
				icon_state = icon_closed
		else
			icon_state = icon_opened
