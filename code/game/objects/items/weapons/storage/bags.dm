/*
 *	These absorb the functionality of the plant bag, ore satchel, etc.
 *	They use the use_to_pickup, quick_gather, and quick_empty functions
 *	that were already defined in weapon/storage, but which had been
 *	re-implemented in other classes.
 *
 *	Contains:
 *		Trash Bag
 *		Mining Satchel
 *		Plant Bag
 *		Sheet Snatcher
 *		Cash Bag
 *
 *	-Sayu
 */

//  Generic non-item
/obj/item/storage/bag
	allow_quick_gather = 1
	allow_quick_empty = 1
	display_contents_with_number = 0 // UNStABLE AS FuCK, turn on when it stops crashing clients
	use_to_pickup = 1
	slot_flags = SLOT_BELT
	flags = FPRINT | TABLEPASS

// -----------------------------
//          Trash bag
// -----------------------------
/obj/item/storage/bag/trash
	name = "miser's sack"
	icon = 'icons/obj/janitor.dmi'
	icon_state = "cbag"
	item_state = "bag"
	slot_flags = SLOT_BACK

	w_class = 4
	max_w_class = 2
	storage_slots = 20
	can_hold = list() // any
	cant_hold = list("/obj/item/disk/nuclear")

/obj/item/storage/bag/trash/update_icon()
	if(contents.len >= 1)
		icon_state = "fbag"
	else
		icon_state = "cbag"

// -----------------------------
//       Cloth/Leather Bag
// -----------------------------
/obj/item/storage/bag/leather
	name = "bag"
	icon = 'icons/obj/cooking.dmi'
	icon_state = "cbag"
	item_state = "bag"

	w_class = 4 //might need to readjust if it's full
	max_w_class = 2
	storage_slots = 7
	can_hold = list() // any
	cant_hold = list("/obj/item/disk/nuclear")

/obj/item/storage/bag/leather/update_icon()
	if(contents.len >= 1)
		icon_state = "fbag"
	else
		icon_state = "cbag"

/obj/item/storage/bag/leather/afterattack(atom/A, mob/user as mob, proximity)
	if(!proximity) return
	if(istype(A, /obj/item))
		var/obj/item/I = A
		if(isturf(I.loc) && !src.contents.len >= storage_slots)
			I.loc = src
			playsound(src.loc, "rustle", 50, 1, -5)
			update_icon()
	if(istype(A, /turf/simulated/floor))
		var/turf/simulated/floor/T = A
		for(var/obj/item/I in T)
			if(src.contents.len >= storage_slots)
				break;
			I.loc = src
			playsound(src.loc, "rustle", 50, 1, -5)
			update_icon()

// -----------------------------
//        Plastic Bag
// -----------------------------

/obj/item/storage/bag/plasticbag
	name = "plastic bag"
	desc = "It's a very flimsy, very noisy alternative to a bag."
	icon = 'icons/obj/trash.dmi'
	icon_state = "plasticbag"
	item_state = "plasticbag"

	w_class = 4
	max_w_class = 2
	storage_slots = 21
	can_hold = list() // any
	cant_hold = list("/obj/item/disk/nuclear")

// -----------------------------
//        Mining Satchel
// -----------------------------

/obj/item/storage/bag/ore
	name = "Mining Satchel"
	desc = "This little bugger can be used to store and transport ores."
	icon = 'icons/obj/mining.dmi'
	icon_state = "satchel"
	slot_flags = SLOT_BELT | SLOT_POCKET
	w_class = 3
	storage_slots = 50
	max_combined_w_class = 200 //Doesn't matter what this is, so long as it's more or equal to storage_slots * ore.w_class
	max_w_class = 3
	can_hold = list("/obj/item/ore")


// -----------------------------
//          Plant bag
// -----------------------------

/obj/item/storage/bag/plants
	icon = 'icons/obj/hydroponics.dmi'
	icon_state = "plantbag"
	name = "Plant Bag"
	storage_slots = 50; //the number of plant pieces it can carry.
	max_combined_w_class = 200 //Doesn't matter what this is, so long as it's more or equal to storage_slots * plants.w_class
	max_w_class = 3
	w_class = 1
	can_hold = list("/obj/item/reagent_containers/food/snacks/grown","/obj/item/seeds","/obj/item/grown")


// -----------------------------
//        Sheet Snatcher
// -----------------------------
// Because it stacks stacks, this doesn't operate normally.
// However, making it a storage/bag allows us to reuse existing code in some places. -Sayu

/obj/item/storage/bag/sheetsnatcher
	icon = 'icons/obj/mining.dmi'
	icon_state = "sheetsnatcher"
	name = "Sheet Snatcher"
	desc = "A patented Nanotrasen storage system designed for any kind of mineral sheet."

	var/capacity = 300; //the number of sheets it can carry.
	w_class = 3

	allow_quick_empty = 1 // this function is superceded
	New()
		..()
		//verbs -= /obj/item/storage/verb/quick_empty
		//verbs += /obj/item/storage/bag/sheetsnatcher/quick_empty

	can_be_inserted(obj/item/W as obj, stop_messages = 0)
		if(!istype(W,/obj/item/stack/sheet) || istype(W,/obj/item/stack/sheet/mineral/sandstone) || istype(W,/obj/item/stack/sheet/wood))
			if(!stop_messages)
				usr << "The snatcher does not accept [W]."
			return 0 //I don't care, but the existing code rejects them for not being "sheets" *shrug* -Sayu
		var/current = 0
		for(var/obj/item/stack/sheet/S in contents)
			current += S.amount
		if(capacity == current)//If it's full, you're done
			if(!stop_messages)
				usr << "\red The snatcher is full."
			return 0
		return 1


// Modified handle_item_insertion.  Would prefer not to, but...
	handle_item_insertion(obj/item/W as obj, prevent_warning = 0)
		var/obj/item/stack/sheet/S = W
		if(!istype(S)) return 0

		var/amount
		var/inserted = 0
		var/current = 0
		for(var/obj/item/stack/sheet/S2 in contents)
			current += S2.amount
		if(capacity < current + S.amount)//If the stack will fill it up
			amount = capacity - current
		else
			amount = S.amount

		for(var/obj/item/stack/sheet/sheet in contents)
			if(S.type == sheet.type) // we are violating the amount limitation because these are not sane objects
				sheet.amount += amount	// they should only be removed through procs in this file, which split them up.
				S.amount -= amount
				inserted = 1
				break

		if(!inserted || !S.amount)
			usr.u_equip(S)
			usr.update_icons()	//update our overlays
			if (usr.client && usr.s_active != src)
				usr.client.screen -= S
			S.dropped(usr)
			if(!S.amount)
				qdel(S)
			else
				S.loc = src

		orient2hud(usr)
		if(usr.s_active)
			usr.s_active.show_to(usr)
		update_icon()
		return 1


// Sets up numbered display to show the stack size of each stored mineral
// NOTE: numbered display is turned off currently because it's broken
	orient2hud(mob/user as mob)
		var/adjusted_contents = contents.len

		//Numbered contents display
		var/list/datum/numbered_display/numbered_contents
		if(display_contents_with_number)
			numbered_contents = list()
			adjusted_contents = 0
			for(var/obj/item/stack/sheet/I in contents)
				adjusted_contents++
				var/datum/numbered_display/D = new/datum/numbered_display(I)
				D.number = I.amount
				numbered_contents.Add( D )

		var/row_num = 0
		var/col_count = min(7,storage_slots) -1
		if (adjusted_contents > 7)
			row_num = round((adjusted_contents-1) / 7) // 7 is the maximum allowed width.
		src.standard_orient_objs(row_num, col_count, numbered_contents)
		return


// Modified quick_empty verb drops appropriate sized stacks
	quick_empty()
		var/location = get_turf(src)
		for(var/obj/item/stack/sheet/S in contents)
			while(S.amount)
				var/obj/item/stack/sheet/N = new S.type(location)
				var/stacksize = min(S.amount,N.max_amount)
				N.amount = stacksize
				S.amount -= stacksize
			if(!S.amount)
				qdel(S) // todo: there's probably something missing here
		orient2hud(usr)
		if(usr.s_active)
			usr.s_active.show_to(usr)
		update_icon()

// Instead of removing
	remove_from_storage(obj/item/W as obj, atom/new_location)
		var/obj/item/stack/sheet/S = W
		if(!istype(S)) return 0

		//I would prefer to drop a new stack, but the item/attack_hand code
		// that calls this can't recieve a different object than you clicked on.
		//Therefore, make a new stack internally that has the remainder.
		// -Sayu

		if(S.amount > S.max_amount)
			var/obj/item/stack/sheet/temp = new S.type(src)
			temp.amount = S.amount - S.max_amount
			S.amount = S.max_amount

		return ..(S,new_location)

// -----------------------------
//    Sheet Snatcher (Cyborg)
// -----------------------------

/obj/item/storage/bag/sheetsnatcher/borg
	name = "Sheet Snatcher 9000"
	desc = ""
	capacity = 500//Borgs get more because >specialization

// -----------------------------
//           Cash Bag
// -----------------------------

/obj/item/storage/bag/cash
	icon = 'icons/obj/storage.dmi'
	icon_state = "cashbag"
	name = "Cash bag"
	desc = "A bag for carrying lots of cash. It's got a big dollar sign printed on the front."
	storage_slots = 50; //the number of cash pieces it can carry.
	max_combined_w_class = 200 //Doesn't matter what this is, so long as it's more or equal to storage_slots * cash.w_class
	max_w_class = 3
	w_class = 1
	can_hold = list("/obj/item/coin","/obj/item/spacecash")
