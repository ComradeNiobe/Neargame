// To clarify:
// For use_to_pickup and allow_quick_gather functionality,
// see item/attackby() (/game/objects/items.dm)
// Do not remove this functionality without good reason, cough reagent_containers cough.
// -Sayu


/obj/item/storage
	name = "storage"
	icon = 'icons/obj/storage.dmi'
	w_class = 3.0
	var/list/can_hold = list() //List of objects which this item can store (if set, it can't store anything else)
	var/list/cant_hold = list() //List of objects which this item can't store (in effect only if can_hold isn't set)
	var/max_w_class = 2 //Max size of objects that this object can store (in effect only if can_hold isn't set)
	var/max_combined_w_class = 14 //The sum of the w_classes of all the items in this storage item.
	var/storage_slots = 7 //The number of storage slots in this container.
	var/obj/screen/storage/boxes = null
	var/obj/screen/close/closer = null
	var/use_to_pickup	//Set this to make it possible to use this item in an inverse way, so you can have the item in your hand and click items on the floor to pick them up.
	var/display_contents_with_number	//Set this to make the storage item group contents of the same type and display them as a number.
	var/allow_quick_empty	//Set this variable to allow the object to have the 'empty' verb, which dumps all the contents on the floor.
	var/allow_quick_gather	//Set this variable to allow the object to have the 'toggle mode' verb, which quickly collects all items from a tile.
	var/collection_mode = TRUE;  //0 = pick one at a time, 1 = pick all on tile
	var/foldable = null	// BubbleWrap - if set, can be folded (when empty) into a sheet of cardboard
	var/is_satchel = FALSE
	can_improv = FALSE
	var/list/is_seeing //List of mobs which are currently seeing the contents of this item's storage. Lazy list.

/obj/item/storage/New()

	if(allow_quick_empty)
		verbs += /obj/item/storage/verb/quick_empty
	else
		verbs -= /obj/item/storage/verb/quick_empty

	if(allow_quick_gather)
		verbs += /obj/item/storage/verb/toggle_gathering_mode
	else
		verbs -= /obj/item/storage/verb/toggle_gathering_mode

	src.boxes = new /obj/screen/storage(  )
	src.boxes.icon = 'icons/mob/screen1_White.dmi'
	src.boxes.name = "storage"
	src.boxes.master = src
	src.boxes.icon_state = "hud_fill"
	src.boxes.screen_loc = "7,7 to 10,8"
	src.boxes.layer = 19
	src.boxes.plane = 30
	src.closer = new /obj/screen/close(  )
	src.closer.master = src
	src.closer.icon_state = "x"
	src.closer.layer = 20
	src.closer.plane = 30
	orient2hud()
	return

/obj/item/storage/Destroy()
	close_all()
	QDEL_NULL(boxes)
	QDEL_NULL(closer)

	. = ..()

/obj/item/storage/MouseDrop(obj/over_object as obj)
	if (ishuman(usr) || ismonkey(usr)) //so monkeys can take off their backpacks -- Urist
		var/mob/M = usr

		if (istype(usr.loc,/obj/mecha)) // stops inventory actions in a mech
			return

		if(over_object == M && Adjacent(M)) // this must come before the screen objects only block
			if(istype(src, /obj/item/storage/backpack))
				if(!is_satchel)
					var/mob/living/carbon/human/user = usr
					if((src == user.back || src == user.back2)&& !is_satchel)
						to_chat(user, "<span class ='combat'>[pick(fnord)] I can't reach my [src]!</span>")
						return
			orient2hud(M)          // dunno why it wasn't before
			if(M.s_active)
				M.s_active.close(M)
			show_to(M)
			playsound(src.loc, "rustle", 50, 1, -5)
			return

		if (!( istype(over_object, /obj/screen) ))
			return ..()
		if (!(src.loc == usr) || (src.loc && src.loc.loc == usr))
			return
		playsound(src.loc, "rustle", 50, 1, -5)
		if (!( M.restrained() ) && !( M.stat ))
			switch(over_object.name)
				if("r_hand")
					M.u_equip(src)
					M.put_in_r_hand(src)
				if("l_hand")
					M.u_equip(src)
					M.put_in_l_hand(src)
			src.add_fingerprint(usr)
			return
		if(istype(src, /obj/item/storage/backpack))
			if(!is_satchel)
				var/mob/user = usr
				if((src == user.back) && !is_satchel)
					to_chat(user, "<span class ='combat'>[pick(fnord)] I can't reach my [src]!</span>")
					return
			else
				if(over_object == usr && in_range(src, usr) || usr.contents.Find(src))
					if (usr.s_active)
						usr.s_active.close(usr)
					src.show_to(usr)
					return
		else
			if(over_object == usr && in_range(src, usr) || usr.contents.Find(src))
				if (usr.s_active)
					usr.s_active.close(usr)
				src.show_to(usr)
				return
	return


/obj/item/storage/proc/return_inv()

	var/list/L = list(  )

	L += src.contents

	for(var/obj/item/storage/S in src)
		L += S.return_inv()
	for(var/obj/item/gift/G in src)
		L += G.gift
		if (istype(G.gift, /obj/item/storage))
			L += G.gift:return_inv()
	return L

/obj/item/storage/proc/show_to(mob/user as mob)
	if(user.s_active != src)
		for(var/obj/item/I in src)
			if(I.on_found(user))
				return
	if(user.s_active)
		user.s_active.hide_from(user)
	user.client.screen -= src.boxes
	user.client.screen -= src.closer
	user.client.screen -= src.contents
	user.client.screen += src.boxes
	user.client.screen += src.closer
	user.client.screen += src.contents
	user.s_active = src

	LAZYDISTINCTADD(is_seeing, user)

/obj/item/storage/proc/hide_from(mob/user as mob)
	if(!user.client)
		return
	user.client.screen -= src.boxes
	user.client.screen -= src.closer
	user.client.screen -= src.contents
	if(user.s_active == src)
		user.s_active = null

	LAZYREMOVE(is_seeing, user)

/obj/item/storage/proc/close(mob/user as mob)
	src.hide_from(user)
	user.s_active = null
	return

/obj/item/storage/proc/close_all()
	for(var/mob/M as anything in can_see_contents())
		close(M)
		. = 1

/obj/item/storage/proc/can_see_contents()
	RETURN_TYPE(/list)

	// If is_seeing isn't initialized or if it's empty, don't bother trying to access it.
	if(!is_seeing)
		return
	if(!LAZYLEN(is_seeing))
		return

	var/list/cansee = list()
	for(var/mob/M as anything in is_seeing)
		if(M.s_active == src && M.client)
			cansee |= M
		else
			is_seeing -= M
	return cansee

//This proc draws out the inventory and places the items on it. tx and ty are the upper left tile and mx, my are the bottm right.
//The numbers are calculated from the bottom-left The bottom-left slot being 1,1.
/obj/item/storage/proc/orient_objs(tx, ty, mx, my)
	var/cx = tx
	var/cy = ty

	src.boxes.screen_loc = "[tx]:,[ty] to [mx],[my]"
	for(var/obj/O in src.contents)
		O.screen_loc = "[cx],[cy]"
		O.layer = 20
		O.plane = 30
		cx++
		if (cx > mx)
			cx = tx
			cy--
	src.closer.screen_loc = "[mx+1],[my]"
	return

//This proc draws out the inventory and places the items on it. It uses the standard position.
/obj/item/storage/proc/standard_orient_objs(var/rows, var/cols, var/list/obj/item/display_contents)
	var/cx = 1+rows
	var/cy = 4+cols
	src.boxes.screen_loc = "1,4 to [1+rows],[4+cols]"

	if(display_contents_with_number)
		for(var/datum/numbered_display/ND in display_contents)
			ND.sample_object.screen_loc = "[cx],[cy]"
			ND.sample_object.maptext = "<font color='white'>[(ND.number > 1)? "[ND.number]" : ""]</font>"
			ND.sample_object.layer = 20
			ND.sample_object.plane = 30
			cx++
			if (cx > (5+cols))
				cx = 5
				cy--
	else
		for(var/obj/O in contents)
			O.screen_loc = "[cx],[cy]"
			O.maptext = ""
			O.layer = 20
			O.plane = 30

			cy--
			if (cx > (5+cols))
				cx = 5
				cy--
	src.closer.screen_loc = "[rows+1],3"
	return

/obj/item/storage/proc/tg_orient_objs(var/rows, var/cols, var/list/obj/item/display_contents)
	var/cx = 4
	var/cy = 2+rows
	src.boxes.screen_loc = "4:16,2:16 to [4+cols]:16,[2+rows]:16"

	if(display_contents_with_number)
		for(var/datum/numbered_display/ND in display_contents)
			ND.sample_object.screen_loc = "[cx]:16,[cy]:16"
			ND.sample_object.maptext = "<font color='white'>[(ND.number > 1)? "[ND.number]" : ""]</font>"
			ND.sample_object.layer = 20
			ND.sample_object.plane = 30
			cx++
			if (cx > (4+cols))
				cx = 4
				cy--
	else
		for(var/obj/O in contents)
			O.screen_loc = "[cx]:16,[cy]:16"
			O.maptext = ""
			O.layer = 20
			O.plane = 30
			cx++
			if (cx > (4+cols))
				cx = 4
				cy--
	src.closer.screen_loc = "[4+cols+1]:16,2:16"
	return


/datum/numbered_display
	var/obj/item/sample_object
	var/number

	New(obj/item/sample as obj)
		if(!istype(sample))
			qdel(src)
		sample_object = sample
		number = 1

//This proc determins the size of the inventory to be displayed. Please touch it only if you know what you're doing.
/obj/item/storage/proc/orient2hud(mob/user as mob)

	var/adjusted_contents = contents.len

	//Numbered contents display
	var/list/datum/numbered_display/numbered_contents
	if(display_contents_with_number)
		numbered_contents = list()
		adjusted_contents = 0
		for(var/obj/item/I in contents)
			var/found = 0
			for(var/datum/numbered_display/ND in numbered_contents)
				if(ND.sample_object.type == I.type)
					ND.number++
					found = 1
					break
			if(!found)
				adjusted_contents++
				numbered_contents.Add( new/datum/numbered_display(I) )

	//var/mob/living/carbon/human/H = user
	var/row_num = 0
	var/col_count = min(7,storage_slots) -1
	if (adjusted_contents > 7)
		row_num = round((adjusted_contents-1) / 7) // 7 is the maximum allowed width.
	if(user && user.client.prefs.UI_type == "TG")
		src.tg_orient_objs(row_num, col_count, numbered_contents)
	else
		src.standard_orient_objs(row_num, col_count, numbered_contents)
	return

//This proc return 1 if the item can be picked up and 0 if it can't.
//Set the stop_messages to stop it from printing messages
/obj/item/storage/proc/can_be_inserted(obj/item/W as obj, stop_messages = 0)
	if(!istype(W)) return //Not an item

	if(src.loc == W)
		return 0 //Means the item is already in the storage item
	if(contents.len >= storage_slots)
		if(!stop_messages)
			usr << "<span class='notice'>[src] is full, make some space.</span>"
		return 0 //Storage item is full

	if(can_hold.len)
		var/ok = 0
		for(var/A in can_hold)
			if(istype(W, text2path(A) ))
				ok = 1
				break
		if(!ok)
			if(!stop_messages)
				if (istype(W, /obj/item/hand_labeler))
					return 0
				usr << "<span class='notice'>[src] cannot hold [W].</span>"
			return 0

	for(var/A in cant_hold) //Check for specific items which this container can't hold.
		if(istype(W, text2path(A) ))
			if(!stop_messages)
				usr << "<span class='notice'>[src] cannot hold [W].</span>"
			return 0

	if (W.w_class > max_w_class)
		if(!stop_messages)
			usr << "<span class='notice'>[W] is too big for this [src].</span>"
		return 0

	var/sum_w_class = W.w_class
	for(var/obj/item/I in contents)
		sum_w_class += I.w_class //Adds up the combined w_classes which will be in the storage item if the item is added to it.

	if(sum_w_class > max_combined_w_class)
		if(!stop_messages)
			usr << "<span class='notice'>[src] is full, make some space.</span>"
		return 0

	if(W.w_class >= src.w_class && (istype(W, /obj/item/storage)))
		if(!istype(src, /obj/item/storage/backpack/holding))	//bohs should be able to hold backpacks again. The override for putting a boh in a boh is in backpack.dm.
			if(!stop_messages)
				usr << "<span class='notice'>[src] cannot hold [W] as it's a storage item of the same size.</span>"
			return 0 //To prevent the stacking of same sized storage items.

	return 1

//This proc handles items being inserted. It does not perform any checks of whether an item can or can't be inserted. That's done by can_be_inserted()
//The stop_warning parameter will stop the insertion message from being displayed. It is intended for cases where you are inserting multiple items at once,
//such as when picking up all the items on a tile with one click.
/obj/item/storage/proc/handle_item_insertion(obj/item/W as obj, prevent_warning = 0)
	if(!istype(W)) return 0
	W.on_enter_storage(src)
	if(usr)
		usr.u_equip(W)
		usr.update_icons()	//update our overlays
	W.loc = src
	if(usr)
		if (usr.client && usr.s_active != src)
			usr.client.screen -= W
		W.dropped(usr)
		add_fingerprint(usr)

		if(!prevent_warning)
			for(var/mob/M in viewers(usr, null))
				if (M == usr)
					usr << "<span class='notice'>You put the [W] into [src].</span>"
				else if (M in range(1)) //If someone is standing close enough, they can tell what it is...
					M.show_message("<span class='notice'>[usr] puts [W] into [src].</span>")
				else if (W && W.w_class >= 3.0) //Otherwise they can only see large or normal items from a distance...
					M.show_message("<span class='notice'>[usr] puts [W] into [src].</span>")

		src.orient2hud(usr)
		if(usr.s_active)
			usr.s_active.show_to(usr)
	update_icon()
	return 1

//Call this proc to handle the removal of an item from the storage item. The item will be moved to the atom sent as new_target
/obj/item/storage/proc/remove_from_storage(obj/item/W as obj, atom/new_location)
	if(!istype(W))
		return 0

	if(istype(src, /obj/item/storage/fancy))
		var/obj/item/storage/fancy/F = src
		F.update_icon(1)

	for(var/mob/M in range(1, get_turf(src)))
		if (M.s_active == src)
			if (M.client)
				M.client.screen -= W

	if(new_location)
		if(ismob(loc))
			W.dropped(usr)
		if(ismob(new_location))
			W.layer = 20
			W.plane = 30
		else
			W.layer = initial(W.layer)
			W.plane = initial(W.plane)
		W.loc = new_location
	else
		W.loc = get_turf(src)

	if(usr)
		src.orient2hud(usr)
		if(usr.s_active)
			usr.s_active.show_to(usr)
	if(W.maptext)
		W.maptext = ""

	if(new_location)
		W.on_exit_storage(src, new_location)
	else if(usr)
		W.on_exit_storage(src, usr)
	else
		W.on_exit_storage(src, get_turf(src))
	return 1

//This proc is called when you want to place an item into the storage item.
/obj/item/storage/attackby(obj/item/W as obj, mob/user as mob)
	..()

	if(isrobot(user))
		user << "\blue You're a robot. No."
		return 1 //Robots can't interact with storage items.

	if(!can_be_inserted(W))
		return 0

	if(istype(W, /obj/item/tray))
		var/obj/item/tray/T = W
		if(T.calc_carry() > 0)
			if(prob(85))
				user << "\red The tray won't fit in [src]."
				return 1
			else
				W.loc = user.loc
				if ((user.client && user.s_active != src))
					user.client.screen -= W
				W.dropped(user)
				user << "\red God damnit!"

	handle_item_insertion(W)
	return 1

/obj/item/storage/dropped(mob/user as mob)
	return

/obj/item/storage/attack_hand(mob/user as mob)
	playsound(src.loc, "rustle", 50, 1, -5)

	if(ishuman(user))
		var/mob/living/carbon/human/H = user
		if(H.l_store == src && !H.get_active_hand())	//Prevents opening if it's in a pocket.
			H.put_in_hands(src)
			H.l_store = null
			return
		if(H.r_store == src && !H.get_active_hand())
			H.put_in_hands(src)
			H.r_store = null
			return

	src.orient2hud(user)
	if (src.loc == user)
		if (user.s_active)
			user.s_active.close(user)
		src.show_to(user)
	else
		..()
		for(var/mob/M in range(1))
			if (M.s_active == src)
				src.close(M)
	src.add_fingerprint(user)
	return

/obj/item/storage/verb/toggle_gathering_mode()
	set name = "Switch Gathering Method"
	set category = "Object"

	collection_mode = !collection_mode
	switch (collection_mode)
		if(1)
			usr << "[src] now picks up all items in a tile at once."
		if(0)
			usr << "[src] now picks up one item at a time."


/obj/item/storage/verb/quick_empty()
	set name = "Empty Contents"
	set category = "Object"

	if((!ishuman(usr) && (src.loc != usr)) || usr.stat || usr.restrained())
		return

	var/turf/T = get_turf(src)
	hide_from(usr)
	for(var/obj/item/I in contents)
		remove_from_storage(I, T)

/obj/item/storage/emp_act(severity)
	if(!istype(src.loc, /mob/living))
		for(var/obj/O in contents)
			O.emp_act(severity)
	..()

// BubbleWrap - A box can be folded up to make card
/obj/item/storage/attack_self(mob/user as mob)

	//Clicking on itself will empty it, if it has the verb to do that.
	if(user.get_active_hand() == src)
		if(src.verbs.Find(/obj/item/storage/verb/quick_empty))
			src.quick_empty()
			return

	//Otherwise we'll try to fold it.
	if ( contents.len )
		return

	if ( !ispath(src.foldable) )
		return
	var/found = 0
	// Close any open UI windows first
	for(var/mob/M in range(1))
		if (M.s_active == src)
			src.close(M)
		if ( M == user )
			found = 1
	if ( !found )	// User is too far away
		return
	// Now make the cardboard
	user << "<span class='notice'>You fold [src] flat.</span>"
	new src.foldable(get_turf(src))
	qdel(src)
//BubbleWrap END




