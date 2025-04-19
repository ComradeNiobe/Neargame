datum/preferences
	//The mob should have a gender you want before running this proc. Will run fine without H
	proc/randomize_appearance_for(var/mob/living/carbon/human/H)
		if(H)
			if(H.gender == MALE)
				gender = MALE
			else
				gender = FEMALE
		s_tone = random_skin_tone()
		h_style = random_hair_style(gender, species)
		f_style = random_facial_hair_style(gender, species)
		randomize_hair_color("hair")
		randomize_hair_color("facial")
		randomize_eyes_color()
		underwear = rand(1,underwear_m.len)
		backbag = 2
		age = rand(AGE_MIN,AGE_MAX)
		if(H)
			copy_to(H,1)


	proc/randomize_hair_color(var/target = "hair")
		if(prob (75) && target == "facial") // Chance to inherit hair color
			r_facial = r_hair
			g_facial = g_hair
			b_facial = b_hair
			return

		var/red
		var/green
		var/blue

		var/col = pick ("blonde", "black", "chestnut", "copper", "brown", "wheat", "old", "punk")
		switch(col)
			if("blonde")
				red = 255
				green = 255
				blue = 0
			if("black")
				red = 0
				green = 0
				blue = 0
			if("chestnut")
				red = 153
				green = 102
				blue = 51
			if("copper")
				red = 255
				green = 153
				blue = 0
			if("brown")
				red = 102
				green = 51
				blue = 0
			if("wheat")
				red = 255
				green = 255
				blue = 153
			if("old")
				red = rand (100, 255)
				green = red
				blue = red
			if("punk")
				red = rand (0, 255)
				green = rand (0, 255)
				blue = rand (0, 255)

		red = max(min(red + rand (-25, 25), 255), 0)
		green = max(min(green + rand (-25, 25), 255), 0)
		blue = max(min(blue + rand (-25, 25), 255), 0)

		switch(target)
			if("hair")
				r_hair = red
				g_hair = green
				b_hair = blue
			if("facial")
				r_facial = red
				g_facial = green
				b_facial = blue

	proc/randomize_eyes_color()
		var/red
		var/green
		var/blue

		var/col = pick ("black", "grey", "brown", "chestnut", "blue", "lightblue", "green", "albino")
		switch(col)
			if("black")
				red = 0
				green = 0
				blue = 0
			if("grey")
				red = rand (100, 200)
				green = red
				blue = red
			if("brown")
				red = 102
				green = 51
				blue = 0
			if("chestnut")
				red = 153
				green = 102
				blue = 0
			if("blue")
				red = 51
				green = 102
				blue = 204
			if("lightblue")
				red = 102
				green = 204
				blue = 255
			if("green")
				red = 0
				green = 102
				blue = 0
			if("albino")
				red = rand (200, 255)
				green = rand (0, 150)
				blue = rand (0, 150)

		red = max(min(red + rand (-25, 25), 255), 0)
		green = max(min(green + rand (-25, 25), 255), 0)
		blue = max(min(blue + rand (-25, 25), 255), 0)

		r_eyes = red
		g_eyes = green
		b_eyes = blue


	proc/update_preview_icon()		//seriously. This is horrendous.
		qdel(preview_icon_front)
		qdel(preview_icon_side)
		qdel(preview_icon)

		var/g = "_m"
		if(gender == FEMALE)	g = "_f"

		var/icon/icobase
		var/datum/species/current_species = all_species[species]
		if(fat && gender == MALE)
			icobase = 'icons/mob/flesh/old/human_fat_old.dmi'
			gender = ""
		else
			icobase = 'icons/mob/human.dmi'

		preview_icon = new /icon(icobase, "chest[g]_s")
		preview_icon.Blend(new /icon(icobase, "groin_[gender == FEMALE ? "f" : "m"]_s"), ICON_OVERLAY)
		preview_icon.Blend(new /icon(icobase, "head_[gender == FEMALE ? "f" : "m"]_s"), ICON_OVERLAY)
		preview_icon.Blend(new /icon(icobase, "l_arm[g]_s"), ICON_OVERLAY)
		preview_icon.Blend(new /icon(icobase, "r_arm[g]_s"), ICON_OVERLAY)
		preview_icon.Blend(new /icon(icobase, "l_leg[g]_s"), ICON_OVERLAY)
		preview_icon.Blend(new /icon(icobase, "r_leg[g]_s"), ICON_OVERLAY)
		preview_icon.Blend(new /icon(icobase, "l_foot[g]_s"), ICON_OVERLAY)
		preview_icon.Blend(new /icon(icobase, "r_foot[g]_s"), ICON_OVERLAY)
		preview_icon.Blend(new /icon(icobase, "l_hand[g]_s"), ICON_OVERLAY)
		preview_icon.Blend(new /icon(icobase, "r_hand[g]_s"), ICON_OVERLAY)

		for(var/name in list("l_arm","r_arm","l_leg","r_leg","l_foot","r_foot","l_hand","r_hand"))
			// make sure the organ is added to the list so it's drawn
			if(organ_data[name] == null)
				organ_data[name] = null

		for(var/name in organ_data)
			if(organ_data[name] == "amputated") continue

			var/icon/temp = new /icon(icobase, "[name]")
			if(organ_data[name] == "cyborg")
				temp.MapColors(rgb(77,77,77), rgb(150,150,150), rgb(28,28,28), rgb(0,0,0))

			preview_icon.Blend(temp, ICON_OVERLAY)

		// Skin tone
		if(current_species && (current_species.flags & HAS_SKIN_TONE))
			if (s_tone >= 0)
				preview_icon.Blend(rgb(s_tone, s_tone, s_tone), ICON_ADD)
			else
				preview_icon.Blend(rgb(-s_tone,  -s_tone,  -s_tone), ICON_SUBTRACT)
		var/icon/eye_icon = 'icons/mob/human.dmi'
		if(gender == FEMALE)
			eye_icon = 'icons/mob/flesh/human_face_f.dmi'
		var/icon/eyes_s = new/icon("icon" = eye_icon, "icon_state" = "eyes_s")
		eyes_s.Blend(rgb(r_eyes, g_eyes, b_eyes), ICON_MULTIPLY)

		var/datum/sprite_accessory/hair_style = hair_styles_list[h_style]
		var/hair_icon = 'icons/mob/flesh/old/human_face_old.dmi'
		if(gender ==  FEMALE)
			hair_icon = 'icons/mob/flesh/old/human_f_face_old.dmi'
		if(hair_style)
			var/icon/hair_s = new/icon("icon" = hair_icon, "icon_state" = "[hair_style.icon_state]_s")
			hair_s.Blend(rgb(r_hair, g_hair, b_hair), ICON_ADD)
			eyes_s.Blend(hair_s, ICON_OVERLAY)

		var/datum/sprite_accessory/facial_hair_style = facial_hair_styles_list[f_style]
		if(facial_hair_style)
			var/icon/facial_s = new/icon("icon" = hair_icon, "icon_state" = "[facial_hair_style.icon_state]_s")
			facial_s.Blend(rgb(r_facial, g_facial, b_facial), ICON_ADD)
			eyes_s.Blend(facial_s, ICON_OVERLAY)

		var/datum/sprite_accessory/facial_detail = facial_details_list[d_style]
		if(facial_detail)
			var/icon/detail_s = new/icon("icon" = 'icons/mob/flesh/old/human_detail_old.dmi', "icon_state" = "[facial_detail.icon_state]_s")
			detail_s.Blend(rgb(r_detail, g_detail, b_detail), ICON_ADD)
			eyes_s.Blend(detail_s, ICON_OVERLAY)

		preview_icon.Blend(eyes_s, ICON_OVERLAY)
		preview_icon_front = new(preview_icon, dir = SOUTH)
		preview_icon_side = new(preview_icon, dir = WEST)

		qdel(eyes_s)