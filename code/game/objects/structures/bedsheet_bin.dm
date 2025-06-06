/*
CONTAINS:
BEDSHEETS
LINEN BINS
*/

/obj/item/bedsheet
	name = "bedsheet"
	desc = "A surprisingly soft linen bedsheet."
	icon = 'icons/obj/items.dmi'
	icon_state = "sheet"
	item_state = "bedsheet"
	layer = 4.0
	throwforce = 1
	throw_speed = 1
	throw_range = 2
	w_class = 2.0
	item_color = "white"
	slot_flags = SLOT_BACK
//	pressure_resistance = 1
//	slot_flags = SLOT_OCLOTHING
//	body_parts_covered = UPPER_TORSO | LOWER_TORSO | LEGS | HEAD


/obj/item/bedsheet/attack_self(mob/user as mob)
	user.drop_item()
	if(layer == initial(layer))
		layer = 5
	else
		layer = initial(layer)
	add_fingerprint(user)
	return


/obj/item/bedsheet/blue
	icon_state = "sheetblue"
	item_color = "blue"

/obj/item/bedsheet/green
	icon_state = "sheetgreen"
	item_color = "green"

/obj/item/bedsheet/orange
	icon_state = "sheetorange"
	item_color = "orange"

/obj/item/bedsheet/purple
	icon_state = "sheetpurple"
	item_color = "purple"

/obj/item/bedsheet/rainbow
	icon_state = "sheetrainbow"
	desc = "A multicolored blanket.  It's actually several different sheets cut up and sewn together."
	item_color = "rainbow"

/obj/item/bedsheet/red
	icon_state = "sheetred"
	item_color = "red"

/obj/item/bedsheet/yellow
	icon_state = "sheetyellow"
	item_color = "yellow"

/obj/item/bedsheet/mime
	icon_state = "sheetmime"
	desc = "A very soothing striped blanket.  All the noise just seems to fade out when you're under the covers in this."
	item_color = "mime"

/obj/item/bedsheet/clown
	icon_state = "sheetclown"
	desc = "A rainbow blanket with a clown mask woven in.  It smells faintly of bananas."
	item_color = "clown"

/obj/item/bedsheet/captain
	name = "captain's bedsheet"
	icon_state = "sheetcaptain"
	desc = "It has a Nanotrasen symbol on it, and was woven with a revolutionary new kind of thread guaranteed to have 0.01% permeability for most non-chemical substances, popular among most modern captains."
	item_color = "captain"

/obj/item/bedsheet/rd
	name = "research director's bedsheet"
	desc = "It appears to have a beaker emblem, and is made out of fire-resistant material, although it probably won't protect you in the event of fires you're familiar with every day."
	icon_state = "sheetrd"
	item_color = "director"

/obj/item/bedsheet/medical
	name = "medical blanket"
	desc = "It's a sterilized* blanket commonly used in the Medbay.  *Sterilization is voided if a virologist is present onboard the station."
	icon_state = "sheetmedical"
	item_color = "medical"

/obj/item/bedsheet/hos
	name = "head of security's bedsheet"
	desc = "It is decorated with a shield emblem.  While crime doesn't sleep, you do, but you are still THE LAW!"
	icon_state = "sheethos"
	item_color = "hosred"

/obj/item/bedsheet/hop
	name = "head of personnel's bedsheet"
	desc = "It is decorated with a key emblem.  For those rare moments when you can rest and cuddle with Ian without someone screaming for you over the radio."
	icon_state = "sheethop"
	item_color = "hop"

/obj/item/bedsheet/ce
	name = "chief engineer's bedsheet"
	desc = "It is decorated with a wrench emblem.  It's highly reflective and stain resistant, so you don't need to worry about ruining it with oil."
	icon_state = "sheetce"
	item_color = "chief"

/obj/item/bedsheet/brown
	icon_state = "sheetbrown"
	item_color = "brown"




/obj/structure/bedsheetbin
	name = "linen bin"
	desc = "A linen bin. It looks rather cosy."
	icon = 'icons/obj/structures.dmi'
	icon_state = "linenbin-full"
//	anchored = 1
	throwforce = 1
	throw_speed = 3
	throw_range = 7
	var/amount = 20
	var/list/sheets = list()
	var/obj/item/hidden = null


/obj/structure/bedsheetbin/examine()
	usr << desc
	if(amount < 1)
		usr << "There are no bed sheets in the bin."
		return
	if(amount == 1)
		usr << "There is one bed sheet in the bin."
		return
	usr << "There are [amount] bed sheets in the bin."


/obj/structure/bedsheetbin/update_icon()
	if(amount == 0)
		icon_state = "linenbin-empty"
	else if(clamp(amount, 1, 10))
		icon_state = "linenbin-half"
	else
		icon_state = "linenbin-full"


/obj/structure/bedsheetbin/attackby(obj/item/I as obj, mob/user as mob)
	if(istype(I, /obj/item/bedsheet))
		user.drop_item()
		I.loc = src
		sheets.Add(I)
		amount++
		user << "<span class='notice'>You put [I] in [src].</span>"
	else if(amount && !hidden && I.w_class < 4)	//make sure there's sheets to hide it among, make sure nothing else is hidden in there.
		user.drop_item()
		I.loc = src
		hidden = I
		user << "<span class='notice'>You hide [I] among the sheets.</span>"



/obj/structure/bedsheetbin/attack_paw(mob/user as mob)
	return attack_hand(user)


/obj/structure/bedsheetbin/attack_hand(mob/user as mob)
	if(amount >= 1)
		amount--

		var/obj/item/bedsheet/B
		if(sheets.len > 0)
			B = sheets[sheets.len]
			sheets.Remove(B)

		else
			B = new /obj/item/bedsheet(loc)

		B.loc = user.loc
		user.put_in_hands(B)
		user << "<span class='notice'>You take [B] out of [src].</span>"
		update_icon()
		if(hidden)
			hidden.loc = user.loc
			user << "<span class='notice'>[hidden] falls out of [B]!</span>"
			hidden = null


	add_fingerprint(user)

/obj/structure/bedsheetbin/attack_tk(mob/user as mob)
	if(amount >= 1)
		amount--

		var/obj/item/bedsheet/B
		if(sheets.len > 0)
			B = sheets[sheets.len]
			sheets.Remove(B)

		else
			B = new /obj/item/bedsheet(loc)

		B.loc = loc
		user << "<span class='notice'>You telekinetically remove [B] from [src].</span>"
		update_icon()

		if(hidden)
			hidden.loc = loc
			hidden = null


//	add_fingerprint(user)