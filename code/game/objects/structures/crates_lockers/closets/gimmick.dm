/obj/structure/closet/cabinet
	name = "cabinet"
	desc = "Old will forever be in fashion."
	icon_state = "cabinet_closed"
	icon_closed = "cabinet_closed"
	icon_opened = "cabinet_open"
	hastrap = TRUE

/obj/structure/closet/cabinet/update_icon()
	if(!opened)
		icon_state = icon_closed
	else
		icon_state = icon_opened

/obj/structure/closet/acloset
	name = "strange closet"
	desc = "It looks alien!"
	icon_state = "acloset"
	icon_closed = "acloset"
	icon_opened = "aclosetopen"


/obj/structure/closet/gimmick
	name = "administrative supply closet"
	desc = "It's a storage unit for things that have no right being here."
	icon_state = "syndicate1"
	icon_closed = "syndicate1"
	icon_opened = "syndicate1open"
	anchored = 0

/obj/structure/closet/gimmick/russian
	name = "russian surplus closet"
	desc = "It's a storage unit for Russian standard-issue surplus."
	icon_state = "syndicate1"
	icon_closed = "syndicate1"
	icon_opened = "syndicate1open"

/obj/structure/closet/gimmick/russian/New()
	..()
	sleep(2)
	new /obj/item/clothing/head/ushanka(src)
	new /obj/item/clothing/head/ushanka(src)
	new /obj/item/clothing/head/ushanka(src)
	new /obj/item/clothing/head/ushanka(src)
	new /obj/item/clothing/head/ushanka(src)
	new /obj/item/clothing/under/soviet(src)
	new /obj/item/clothing/under/soviet(src)
	new /obj/item/clothing/under/soviet(src)
	new /obj/item/clothing/under/soviet(src)
	new /obj/item/clothing/under/soviet(src)


/obj/structure/closet/thunderdome
	name = "\improper Thunderdome closet"
	desc = "Everything you need!"
	icon_state = "syndicate"
	icon_closed = "syndicate"
	icon_opened = "syndicateopen"
	anchored = 1

/obj/structure/closet/thunderdome/New()
	..()
	sleep(2)

/obj/structure/closet/thunderdome/tdred
	name = "red-team Thunderdome closet"

/obj/structure/closet/thunderdome/tdred/New()
	..()
	sleep(2)
	new /obj/item/clothing/suit/armor/tdome/red(src)
	new /obj/item/clothing/suit/armor/tdome/red(src)
	new /obj/item/clothing/suit/armor/tdome/red(src)
	new /obj/item/melee/energy/sword(src)
	new /obj/item/melee/energy/sword(src)
	new /obj/item/melee/energy/sword(src)
	new /obj/item/gun/energy/taser/leet/laser(src)
	new /obj/item/gun/energy/taser/leet/laser(src)
	new /obj/item/gun/energy/taser/leet/laser(src)
	new /obj/item/melee/baton(src)
	new /obj/item/melee/baton(src)
	new /obj/item/melee/baton(src)
	new /obj/item/storage/box/flashbangs(src)
	new /obj/item/storage/box/flashbangs(src)
	new /obj/item/storage/box/flashbangs(src)
	new /obj/item/clothing/head/helmet/thunderdome(src)
	new /obj/item/clothing/head/helmet/thunderdome(src)
	new /obj/item/clothing/head/helmet/thunderdome(src)

/obj/structure/closet/thunderdome/tdgreen
	name = "green-team Thunderdome closet"
	icon_state = "syndicate1"
	icon_closed = "syndicate1"
	icon_opened = "syndicate1open"

/obj/structure/closet/thunderdome/tdgreen/New()
	..()
	sleep(2)
	new /obj/item/clothing/suit/armor/tdome/green(src)
	new /obj/item/clothing/suit/armor/tdome/green(src)
	new /obj/item/clothing/suit/armor/tdome/green(src)
	new /obj/item/melee/energy/sword(src)
	new /obj/item/melee/energy/sword(src)
	new /obj/item/melee/energy/sword(src)
	new /obj/item/gun/energy/taser/leet/laser(src)
	new /obj/item/gun/energy/taser/leet/laser(src)
	new /obj/item/gun/energy/taser/leet/laser(src)
	new /obj/item/melee/baton(src)
	new /obj/item/melee/baton(src)
	new /obj/item/melee/baton(src)
	new /obj/item/storage/box/flashbangs(src)
	new /obj/item/storage/box/flashbangs(src)
	new /obj/item/storage/box/flashbangs(src)
	new /obj/item/clothing/head/helmet/thunderdome(src)
	new /obj/item/clothing/head/helmet/thunderdome(src)
	new /obj/item/clothing/head/helmet/thunderdome(src)


/obj/structure/closet/oldstyle
	name = "\improper Old closet"
	desc = "It looks as if it will fall apart now"
	icon_state = "closedoldstyle"
	icon_closed = "closedoldstyle"
	icon_opened = "openoldstyle"
