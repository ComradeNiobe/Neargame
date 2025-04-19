/obj/structure/closet/secure_closet/medical1
	name = "Medicine Closet"
	desc = "Filled with medical junk."
	icon_state = "medical1"
	icon_closed = "medical"
	icon_locked = "medical1"
	icon_opened = "medicalopen"
	icon_broken = "medicalbroken"
	icon_off = "medicaloff"
	req_access = list(access_medical)


	New()
		..()
		sleep(2)
		new /obj/item/storage/box/medipens(src)
		new /obj/item/storage/box/syringes(src)
		new /obj/item/reagent_containers/dropper(src)
		new /obj/item/reagent_containers/dropper(src)
		new /obj/item/reagent_containers/glass/beaker(src)
		new /obj/item/reagent_containers/glass/beaker(src)
		new /obj/item/reagent_containers/glass/bottle/epinephrine(src)
		new /obj/item/reagent_containers/glass/bottle/epinephrine(src)
		new /obj/item/storage/pill_bottle/charcoal(src)
		return



/obj/structure/closet/secure_closet/medical2
	name = "Anesthetic"
	desc = "Used to knock people out."
	icon_state = "medical1"
	icon_closed = "medical"
	icon_locked = "medical1"
	icon_opened = "medicalopen"
	icon_broken = "medicalbroken"
	icon_off = "medicaloff"
	req_access = list(access_surgery)


	New()
		..()
		sleep(2)
		new /obj/item/tank/anesthetic(src)
		new /obj/item/tank/anesthetic(src)
		new /obj/item/tank/anesthetic(src)
		new /obj/item/clothing/mask/breath/medical(src)
		new /obj/item/clothing/mask/breath/medical(src)
		new /obj/item/clothing/mask/breath/medical(src)
		return


/obj/structure/closet/secure_closet/medical4
	name = "Blood Freezer"
	desc = "Contains blood packs used for transfusion."
	icon_state = "medical1"
	icon_closed = "medical"
	icon_locked = "medical1"
	icon_opened = "medicalopen"
	icon_broken = "medicalbroken"
	icon_off = "medicaloff"
	req_access = list(access_medical)

	New()
		..()
		sleep(2)
		new /obj/item/reagent_containers/blood/APlus(src)
		new /obj/item/reagent_containers/blood/APlus(src)
		new /obj/item/reagent_containers/blood/AMinus(src)
		new /obj/item/reagent_containers/blood/AMinus(src)
		new /obj/item/reagent_containers/blood/BPlus(src)
		new /obj/item/reagent_containers/blood/BPlus(src)
		new /obj/item/reagent_containers/blood/BMinus(src)
		new /obj/item/reagent_containers/blood/BMinus(src)
		new /obj/item/reagent_containers/blood/OPlus(src)
		new /obj/item/reagent_containers/blood/OPlus(src)
		new /obj/item/reagent_containers/blood/OMinus(src)
		new /obj/item/reagent_containers/blood/OMinus(src)
		return





/obj/structure/closet/secure_closet/animal
	name = "Animal Control"
	req_access = list(access_surgery)


	New()
		..()
		sleep(2)
		new /obj/item/device/assembly/signaler(src)
		new /obj/item/device/radio/electropack(src)
		new /obj/item/device/radio/electropack(src)
		new /obj/item/device/radio/electropack(src)
		return



/obj/structure/closet/secure_closet/chemical
	name = "Chemical Closet"
	desc = "Store dangerous chemicals in here."
	icon_state = "medical1"
	icon_closed = "medical"
	icon_locked = "medical1"
	icon_opened = "medicalopen"
	icon_broken = "medicalbroken"
	icon_off = "medicaloff"
	req_access = list(access_chemistry)


	New()
		..()
		sleep(2)
		new /obj/item/storage/box/pillbottles(src)
		new /obj/item/storage/box/pillbottles(src)
		return

/obj/structure/closet/secure_closet/medical_wall
	name = "First Aid Closet"
	desc = "It's a secure wall-mounted storage unit for first aid supplies."
	icon_state = "medical_wall_locked"
	icon_closed = "medical_wall_unlocked"
	icon_locked = "medical_wall_locked"
	icon_opened = "medical_wall_open"
	icon_broken = "medical_wall_spark"
	icon_off = "medical_wall_off"
	anchored = 1
	density = 0
	wall_mounted = 1
	req_access = list(access_medical)

/obj/structure/closet/secure_closet/medical_wall/update_icon()
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