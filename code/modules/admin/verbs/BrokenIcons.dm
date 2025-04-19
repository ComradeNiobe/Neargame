/proc/getbrokeninhands()
	var/icon/IL = new('icons/mob/items_lefthand.dmi')
	var/list/Lstates = IL.IconStates()
	var/icon/IR = new('icons/mob/items_righthand.dmi')
	var/list/Rstates = IR.IconStates()


	var/text
	for(var/A in typesof(/obj/item))
		var/obj/item/O = new A( locate(1,1,1) )
		if(!O) continue
		var/icon/J = new(O.icon)
		var/list/istates = J.IconStates()
		if(!Lstates.Find(O.icon_state) && !Lstates.Find(O.item_state))
			if(O.icon_state)
				text += "[O.type] is missing left hand icon called \"[O.icon_state]\".\n"
		if(!Rstates.Find(O.icon_state) && !Rstates.Find(O.item_state))
			if(O.icon_state)
				text += "[O.type] is missing right hand icon called \"[O.icon_state]\".\n"


		if(O.icon_state)
			if(!istates.Find(O.icon_state))
				text += "[O.type] is missing normal icon called \"[O.icon_state]\" in \"[O.icon]\".\n"
		//if(O.item_state)
		//	if(!istates.Find(O.item_state))
		//		text += "[O.type] MISSING NORMAL ICON CALLED\n\"[O.item_state]\" IN \"[O.icon]\"\n"
		//text+="\n"
		qdel(O)
	if(text)
		var/F = file("broken_icons.txt")
		fdel(F)
		F << text
		world << "Completeled successfully and written to [F]"

client/verb/getbrokenicons()
	var/list/icon_list = list(
	"head"    = list('icons/mob/clothing/secondary/head.dmi',"",/obj/item/clothing/head),
	"uniform" = list('icons/mob/clothing/new_clothes_male.dmi',"_body_s",/obj/item/clothing/under),
	"suit"    = list('icons/mob/clothing/suit_parts_male.dmi',"",/obj/item/clothing/suit),
	"shoes"   = list('icons/mob/clothing/secondary/feet_right.dmi',"",/obj/item/clothing/shoes),
	"hands"   = list('icons/mob/clothing/secondary/hands.dmi',"_rhand",/obj/item/clothing/gloves),
	"mask"    = list('icons/mob/clothing/secondary/mask.dmi',"",/obj/item/clothing/mask),
	"eyes"    = list('icons/mob/clothing/secondary/eyes.dmi',"",/obj/item/clothing/glasses),
	)

	for(var/l in icon_list)
		var/text
		var/icon/IL = new(icon_list[l][1])
		var/list/Lstates = IL.IconStates()
		for(var/A in typesof(icon_list[l][3]))
			var/obj/item/O = new A( locate(1,1,1) )
			var/str = icon_list[l][2]
			if(!Lstates.Find("[O.item_state][str]"))
				if(O.item_state)
					text += "[O.type] is missing (item_state) icon called \"[O.item_state][str]\".\n"
			if(!Lstates.Find("[O.icon_state][str]"))
				text += "[O.type] is missing (icon_state) icon called \"[O.icon_state][str]\".\n"
			if(O.icon)
				var/icon/newi = icon(O.icon)
				var/list/istates = newi.IconStates()
				if(!istates.Find(O.icon_state))
					text += "[O.type] is missing normal icon called \"[O.icon_state]\" in \"[O.icon]\".\n"
			qdel(O)
		if(text)
			var/F = file("broken_[l].txt")
			fdel(F)
			F << text
			to_chat(usr,"Completeled successfully and written to [F]")

client/verb/getconjoinedsuits()
	var/icon/I = new('icons/mob/clothing/suit_parts_male_lower.dmi')
	var/list/states = I.IconStates()
	var/text
	for(var/A in subtypesof(/obj/item/clothing/suit))
		var/obj/item/O = new A( locate(1,1,1) )
		world.log << O.type
		if(states.Find(O.icon_state))
			world.log << TRUE
			text += "[O.type] should have LEGS_TOGETHER.\n"
		qdel(O)

	if(text)
		var/F = file("conjoin_icons.txt")
		fdel(F)
		F << text
		to_chat(usr,"Completeled successfully and written to [F]")

client/verb/getbrokenhair()
	var/icon/I = new('icons/mob/flesh/old/human_face_old.dmi')
	var/list/states = I.IconStates()
	var/text
	for(var/type in subtypesof(/datum/sprite_accessory))
		var/datum/sprite_accessory/A = new type
		if(!states.Find("[A.icon_state]_s"))
			text += "[A.icon_state]_s\n"
	if(text)
		var/F = file("broken_hair.txt")
		fdel(F)
		F << text
		to_chat(usr,"Completeled successfully and written to [F]")