



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
		..()
		sleep(2)
		new /obj/item/clothing/glasses/sunglasses(src)
		new /obj/item/clothing/suit/armor/vest(src)
		new /obj/item/clothing/head/helmet(src)
		new /obj/item/cartridge/hop(src)
		new /obj/item/device/radio/headset/heads/hop(src)
		new /obj/item/storage/box/ids(src)
		new /obj/item/storage/box/ids( src )

		new /obj/item/device/flash(src)
		return

/obj/structure/closet/secure_closet/hop2
	name = "Head of Personnel's Attire"
	req_access = list(access_hop)
	icon_state = "hopsecure1"
	icon_closed = "hopsecure"
	icon_locked = "hopsecure1"
	icon_opened = "hopsecureopen"
	icon_broken = "hopsecurebroken"
	icon_off = "hopsecureoff"

	New()
		..()
		sleep(2)
		new /obj/item/clothing/under/rank/head_of_personnel(src)
		new /obj/item/clothing/under/dress/dress_hop(src)
		new /obj/item/clothing/under/dress/dress_hr(src)
		new /obj/item/clothing/under/lawyer/female(src)
		new /obj/item/clothing/under/lawyer/black(src)
		new /obj/item/clothing/under/lawyer/red(src)
		new /obj/item/clothing/under/lawyer/oldman(src)
		new /obj/item/clothing/shoes/lw/brown(src)
		new /obj/item/clothing/shoes/lw/black(src)
		new /obj/item/clothing/shoes/lw/leatherboots(src)
		new /obj/item/clothing/shoes/lw/brown(src)
		new /obj/item/clothing/under/rank/head_of_personnel_whimsy(src)
		return



/obj/structure/closet/secure_closet/hos
	name = "Head of Security's Locker"
	req_access = list(access_hos)
	icon_state = "hossecure1"
	icon_closed = "hossecure"
	icon_locked = "hossecure1"
	icon_opened = "hossecureopen"
	icon_broken = "hossecurebroken"
	icon_off = "hossecureoff"

	New()
		..()
		sleep(2)
		if(prob(50))
			new /obj/item/storage/backpack/security(src)
		else
			new /obj/item/storage/backpack/satchel_sec(src)
		new /obj/item/clothing/head/helmet/HoS(src)
		new /obj/item/reagent_containers/hypospray/medipen/combat(src)
		new /obj/item/clothing/under/rank/head_of_security/jensen(src)
		new /obj/item/clothing/under/rank/head_of_security/corp(src)
		new /obj/item/clothing/suit/armor/hos/jensen(src)
		new /obj/item/clothing/suit/armor/hos(src)
		new /obj/item/clothing/head/helmet/HoS/dermal(src)
		new /obj/item/cartridge/hos(src)
		new /obj/item/device/radio/headset/heads/hos(src)
		new /obj/item/clothing/glasses/sunglasses/sechud(src)
		new /obj/item/shield/riot(src)
		new /obj/item/storage/box/flashbangs(src)
		new /obj/item/storage/belt/security(src)
		new /obj/item/device/flash(src)
		new /obj/item/melee/baton(src)

		new /obj/item/clothing/tie/holster/waist(src)
		new /obj/item/melee/telebaton(src)
		return




/obj/structure/closet/secure_closet/security
	name = "Triton's Locker"
	req_access = list(garrison)
	icon_state = "sec1"
	icon_closed = "sec"
	icon_locked = "sec1"
	icon_opened = "secopen"
	icon_broken = "secbroken"
	icon_off = "secoff"

	New()
		..()
		sleep(2)
		if(prob(20))
			new/obj/item/gun/energy/taser/leet/sparq(src)
		new/obj/item/cell/crap/leet/sparq(src)
		if(prob(90))
			new/obj/item/clothing/shoes/lw/jackboots(src)
		if(prob(19))
			new/obj/item/storage/backpack/minisatchel(src)
		new /obj/item/clothing/under/rank/security(src)
		return

/obj/structure/closet/secure_closet/security/cargo

	New()
		..()
		new /obj/item/clothing/tie/armband/cargo(src)
		new /obj/item/device/encryptionkey/headset_cargo(src)
		return

/obj/structure/closet/secure_closet/security/engine

	New()
		..()
		new /obj/item/clothing/tie/armband/engine(src)
		new /obj/item/device/encryptionkey/headset_eng(src)
		return

/obj/structure/closet/secure_closet/security/science

	New()
		..()
		new /obj/item/clothing/tie/armband/science(src)
		new /obj/item/device/encryptionkey/headset_sci(src)
		return

/obj/structure/closet/secure_closet/security/med

	New()
		..()
		new /obj/item/clothing/tie/armband/medgreen(src)
		new /obj/item/device/encryptionkey/headset_med(src)
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
		..()
		sleep(2)
		new /obj/item/clothing/under/det(src)
		new /obj/item/reagent_containers/hypospray/medipen/combat(src)
		new /obj/item/clothing/under/det/black(src)
		new /obj/item/clothing/under/det/slob(src)
		new /obj/item/clothing/suit/storage/det_suit(src)
		new /obj/item/clothing/suit/storage/det_suit/black(src)
		new /obj/item/clothing/suit/storage/forensics/blue(src)
		new /obj/item/clothing/suit/storage/forensics/red(src)
		new /obj/item/clothing/gloves/black(src)
		new /obj/item/clothing/head/det_hat(src)
		new /obj/item/clothing/head/det_hat/black(src)
		new /obj/item/clothing/shoes/lw/brown(src)
		new /obj/item/storage/box/evidence(src)
		new /obj/item/device/radio/headset/headset_sec(src)
		new /obj/item/device/detective_scanner(src)
		new /obj/item/ammo_magazine/box/c38(src)
		new /obj/item/ammo_magazine/box/c38(src)
		new /obj/item/clothing/tie/holster/armpit(src)
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
	req_access = list(access_captain)


	New()
		..()
		sleep(2)
		new /obj/item/reagent_containers/ld50_syringe/choral(src)
		new /obj/item/reagent_containers/ld50_syringe/choral(src)
		return



/obj/structure/closet/secure_closet/brig
	name = "Brig Locker"
	req_access = list(access_brig)
	anchored = 1
	var/id = null

	New()
		new /obj/item/clothing/shoes/lw/brown( src )
		return



/obj/structure/closet/secure_closet/courtroom
	name = "Courtroom Locker"
	req_access = list(access_court)

	New()
		..()
		sleep(2)
		new /obj/item/clothing/shoes/lw/brown(src)
		new /obj/item/paper/Court (src)
		new /obj/item/paper/Court (src)
		new /obj/item/paper/Court (src)
		new /obj/item/pen (src)
		new /obj/item/clothing/suit/judgerobe (src)
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
