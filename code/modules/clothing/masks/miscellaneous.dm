/obj/item/clothing/mask/muzzle
	name = "muzzle"
	desc = "To stop that awful noise."
	icon_state = "muzzle"
	item_state = "muzzle"
	flags = FPRINT|TABLEPASS|MASKCOVERSMOUTH
	w_class = 2
	gas_transfer_coefficient = 0.90

//Monkeys can not take the muzzle off of themself! Call PETA!
/obj/item/clothing/mask/muzzle/attack_paw(mob/user as mob)
	if (src == user.wear_mask)
		return
	else
		..()
	return

/obj/item/clothing/mask/chaser
	name = "screaming mask"
	desc = "It looks like it's screaming... Creepy."
	icon_state = "chaser"
	flags = FPRINT|TABLEPASS|MASKCOVERSMOUTH|BLOCKHAIR
	flags_inv = HIDEFACE

/obj/item/clothing/mask/surgical
	name = "sterile mask"
	desc = "A sterile mask designed to help prevent the spread of diseases."
	icon_state = "sterile"
	item_state = "sterile"
	w_class = 1
	flags = FPRINT|TABLEPASS|MASKCOVERSMOUTH
	gas_transfer_coefficient = 0.90
	permeability_coefficient = 0.01
	armor = list(melee = 0, bullet = 0, laser = 0,energy = 0, bomb = 0, bio = 25, rad = 0)

/obj/item/clothing/mask/surgical/church
	name = "half-mask"
	icon_state = "Sniffer"
	item_state = "Sniffer"

/obj/item/clothing/mask/fakemoustache
	name = "fake moustache"
	desc = "Warning: moustache is fake."
	icon_state = "fake-moustache"
	flags = FPRINT|TABLEPASS
	flags_inv = HIDEFACE

/obj/item/clothing/mask/snorkel
	name = "Snorkel"
	desc = "For the Swimming Savant."
	icon_state = "snorkel"
	flags = FPRINT|TABLEPASS
	flags_inv = HIDEFACE

/obj/item/clothing/mask/halfmask
	name = "half mask"
	icon_state = "halfmask"
	flags = FPRINT|TABLEPASS|MASKCOVERSMOUTH
	flags_inv = HIDEFACE

/obj/item/clothing/mask/bandit
	name = "bandit mask"
	icon_state = "bandit"
	flags = FPRINT|TABLEPASS|MASKCOVERSMOUTH
	flags_inv = HIDEFACE

/obj/item/clothing/mask/pig
	name = "pig mask"
	desc = "A rubber pig mask."
	icon_state = "pigmask"
	item_state = "pigmask"
	flags = FPRINT|TABLEPASS|BLOCKHAIR
	flags_inv = HIDEFACE
	w_class = 2
	siemens_coefficient = 0.9

/obj/item/clothing/mask/horsehead
	name = "horse head mask"
	desc = "A mask made of soft vinyl and latex, representing the head of a horse."
	icon_state = "horsehead"
	item_state = "horsehead"
	flags = FPRINT|TABLEPASS|BLOCKHAIR
	flags_inv = HIDEFACE
	w_class = 2
	var/voicechange = 0
	siemens_coefficient = 0.9

/obj/item/clothing/mask/bee
	name = "bee mask"
	desc = "Bzzzzzzzzz."
	icon_state = "bee"
	item_state = "bee"
	flags = FPRINT|TABLEPASS
	flags_inv = HIDEFACE
	w_class = 2
	siemens_coefficient = 0.9

/obj/item/clothing/mask/silvermask
	name = "silver mask"
	desc = ""
	icon_state = "silvermask"
	item_state = "silvermask"
	silver = TRUE
	flags = FPRINT|TABLEPASS
	flags_inv = HIDEFACE
	w_class = 2
	siemens_coefficient = 0.9
	armor = list(melee = 20, bullet = 5, laser = 5,energy = 5, bomb = 5, bio = 2, rad = 0)

/obj/item/clothing/mask/ironmask
	name = "iron mask"
	desc = ""
	icon_state = "ironmask"
	item_state = "ironmask"
	flags = FPRINT|TABLEPASS
	flags_inv = HIDEFACE
	w_class = 2
	siemens_coefficient = 0.9
	armor = list(melee = 35, bullet = 15, laser = 5,energy = 5, bomb = 5, bio = 2, rad = 0)