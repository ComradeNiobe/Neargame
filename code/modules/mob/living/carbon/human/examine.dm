

/mob/verb/ZEPRETACO()
	winset( src.client, "mapwindow.map", "zoom-mode=normal" )

/mob/verb/ZEPRETOLA()
	winset( src.client, "mapwindow.map", "zoom-mode=distort" )

/mob/verb/ZEPRETALE()
	winset( src.client, "mapwindow.map", "zoom-mode=blur" )

/mob/living/carbon/human/examine(mob/user)
	if(!isobserver(user))
		if( user.sdisabilities & BLIND || user.blinded || user.stat==UNCONSCIOUS )
			to_chat(user, "<span class='passivebold'>Something is there but you can't see it.</span>")
			return

		var/skipgloves = 0
		var/skipjumpsuit = 0
		var/skipshoes = 0
		var/skipmask = 0
		var/skipears = 0
		var/skipeyes = 0
		var/skipface = 0
		var/list/ExamineList = list()
		if(ishuman(user))
			user.visible_message("<span class='looksatbold'>[user]</span> <span class='looksat'>looks at [src].</span>")
		//exosuits and helmets obscure our view and stuff.
		if(wear_suit)
			skipgloves = wear_suit.flags_inv & HIDEGLOVES
			//skipsuitstorage = wear_suit.flags_inv & HIDESUITSTORAGE
			skipjumpsuit = wear_suit.flags_inv & HIDEJUMPSUIT
			skipshoes = wear_suit.flags_inv & HIDESHOES

		if(head)
			skipmask = head.flags_inv & HIDEMASK
			skipeyes = head.flags_inv & HIDEEYES
			skipears = head.flags_inv & HIDEEARS
			skipface = head.flags_inv & HIDEFACE

		if(wear_mask)
			skipface |= wear_mask.flags_inv & HIDEFACE

		// crappy hacks because you can't do \his[src] etc. I'm sorry this proc is so unreadable, blame the text macros :<
		var/t_He = "It" //capitalised for use at the start of each line.
		var/t_his = "its"
		var/t_him = "it"
		var/t_has = "has"
		var/t_is = "is"
		var/t_chis = "Its"

		var/msg = "<div class='firstdivexamineplyr'><div class='boxexamineplyr'><span class='statustext'>Oh, this is "

		if( skipjumpsuit && skipface || isStealth()) //big suits/masks/helmets make it hard to tell their gender
			t_He = "It"
			t_his = "its"
			t_him = "it"
			t_has = "has"
			t_is = "is"
			t_chis = "Its"
		else
			switch(gender)
				if(MALE)
					t_He = "He"
					t_his = "his"
					t_chis = "His"
					t_him = "him"
				if(FEMALE)
					t_He = "She"
					t_his = "her"
					t_chis = "Her"
					t_him = "her"

			if(has_penis() && (!wear_suit && is_nude()))
				t_He = "He"
				t_his = "his"
				t_him = "him"

		var/mob/living/carbon/human/M = user
		var/mob/living/carbon/human/P = src
		if(isStealth())
			msg += "<span class='uppertext'>R a t</span>!\n"
		else
			msg += "<span class='uppertext'>[src.name]</span>!\n"

		var/datum/organ/internal/heart/HE = locate() in P.internal_organs
		if(HE)
			if(HE.stopped_working)
				msg += "\n<span class='hitbold'>[t_He] [t_is] having a heart attack!</span>\n"
		if((ishuman(P) && ishuman(M)) && M.exam_wounds && P != M) // This should be its own proc once medical/combat becomes more advanced
			if(!istype(P, /mob/living/carbon/human/monster))
				msg += "<span class='statustext'>The state of [t_his] body is:\n</span>"
				for(var/datum/organ/external/org in src.organs)
					var/list/status = list()

					if(org.status & ORGAN_DESTROYED)
						status += "<span class='missingnew'><big>MISSING</big></span>"
					if(org.status & ORGAN_MUTATED)
						status += "<span class='magentatext'>MISSHAPEN</span>"
					if(org.germ_level >= 1)
						status += "<span class='redtext'>FESTERING</span>"
					if(org.status & ORGAN_BLEEDING)
						status += "<span class='redtext'>BLEEDING</span>"
					if(org.status & ORGAN_BROKEN)
						status += "<span class='redtext'>FRACTURE</span>"
					if(org.status & ORGAN_SPLINTED)
						status += "<span class='passivebold'>SPLINTED</span>"
						status -= "<span class='redtext'>FRACTURE</span>"
					if(org.status & ORGAN_DEAD)
						status += "<span class='redtext'>NECROSIS</span>"
					if(org.status & ORGAN_ARTERY)
						status += "<span class='magentatext'>ARTERY</span>"
					if(org.cripple_left > 0)
						status += "<span class='magentatext'>CRIPPLED</span>"
					if(org.status & ORGAN_TENDON)
						status += "<span class='magentatext'>TENDON</span>"
					if(!org.is_usable())
						status += "<span class='missingnew'>UNUSABLE</span>"
					if(org.status & ORGAN_CUT_AWAY)
						status += "<span class='magentatext'>UNCONNECTED</span>"
					if(istype(org, /datum/organ/external/head))
						var/datum/organ/external/head/HEADD = org
						if(HEADD.brained)
							status += "<span class='magentatext'>CRACK</span>"
					if(status.len)
						msg += "<span class='statustext'>¤ [capitalize(org.display_name)]: [english_listt(status)]</span>\n"
					else
						msg += "<span class='statustext'>¤ [capitalize(org.display_name)]: OK</span>\n"

				to_chat(user, "[msg]</div></div>", 10)
				return

		if(istype(src, /mob/living/carbon/human/monster) && src.gender == MALE && !isChild())
			msg += {"</span>[src.desc]\n<span class='bname'>Penis size: [penis_size]cm.</span></div></div>"}
			to_chat(user, msg)
			return 1
		if(isStealth())
			msg += "<span class='uppertext'>I can't recognize it.</span>"
		else
			if(!isobserver(user))
				if(job == "Bum" && !skipface && istype(src, /mob/living/carbon/human/bumbot))
					msg += "<span class='statustext'>I always knew [decapitalize(t_him)] as some </span> <span class='uppertext'>bum.</span>"
				else
					if(job && !P.outsider && !skipface || job == "Sheriff") // MUDAR CASO OP DEMAIS			else
						msg += "<span class='statustext'>I always knew [decapitalize(t_him)] as a </span> <span class='uppertext'>[display_job()].</span>"
					else
						if(P.bandit && !skipface)
							msg += "<span class='statustext'>I always knew [decapitalize(t_him)] as a </span> <span class='uppertext'>bandit!</span>"
						else
							if(P.outsider && M.outsider && !skipface)
								if(P.province != "Wanderer")
									if(M == P || P == M)
										msg += "<span class='statustext'>I always knew [decapitalize(t_him)] as a </span> <span class='uppertext'>[display_job()].</span>"
									else
										if(M.province == P.province)
											msg += "<span class='statustext'>I always knew [decapitalize(t_him)] as a </span> <span class='uppertext'>[display_job()].</span><span class='statustext'> [t_He] is from </span><span class='uppertext'>[P.province],</span><span class='statustext'> same as me!</span>"
										else
											msg += "<span class='statustext'>I always knew [decapitalize(t_him)] as a </span> <span class='uppertext'>[display_job()].</span><span class='statustext'> [t_He] is from </span><span class='uppertext'>[P.province]</span>"
			else
				msg += "<span class='statustext'>I always knew [decapitalize(t_him)] as a </span> <span class='uppertext'>[display_job()].</span>"
		if(ishuman(P))
			if(P.lip_style && !skipface && !isStealth())
				msg += "\n<span class='bname'>Mmhmm, [t_his] lips look sexy!</span>"

		if(!skipface && !isStealth() && (M.seen_heresy.Find(ref(src))|| excomunicated) && !skipface)
			msg += "\n<span class='excommun'>[t_He] [t_is] A DIRTY HERETIC!</span>"

		if(bandit && !skipface && !isStealth())
			msg += "\n<br><span class='excommun'>[t_He] [t_is] A BANDIT!</span>"

		if(master_mode == "holywar")
			if(ishuman(P) && ishuman(M))
				if(P.religion && M.religion)
					if(P.religion == M.religion)
						msg += "\n<span class='baronboldoutlined'>[t_He] [t_is] my comrade!</span>"
					else
						msg += "<br><span class='excommun'>[t_He] [t_is] THE ENEMY!</span>"

		if(isStealth())
			msg += "<span class='uppertext'>\n[t_He] is camouflaged.</span>"
		else
			//head
			if(head)
				if(head.blood_DNA)
					msg += "\n<span class='combat'>[t_He] wears [icon2html(head, user)] [head.gender==PLURAL?"some":"a"] blood-stained <span class='passiveglow'>[head.name]</span> <span class='combat'>on [t_his] head.</span>"
				else
					msg += "\n<span class='statustext'>[t_He] wears [icon2html(head, user)] \a </span> <span class='passiveglow'>[head]</span> <span class='statustext'>on [t_his] head.</span>"

			//suit/armour
			if(wear_suit)
				if(wear_suit.blood_DNA)
					msg += "\n<span class='combat'>[t_He] has [icon2html(wear_suit, user)] [wear_suit.gender==PLURAL?"some":"a"]</span> <span class='passiveglow'>[wear_suit.name]</span><span class='combat'>on (covered with blood)</span>"
				else
					msg += "\n<span class='statustext'>[t_He] has</span> [icon2html(wear_suit, user)] <span class='statustext'> \a </span><span class='passiveglow'>[wear_suit]</span><span class='statustext'> on</span>"
			var/list/BELTSTORE = list()
			if(s_store)
				BELTSTORE.Add("[icon2html(s_store, user)] </span><span class='passiveglow'>[s_store.name]</span>")
			if(belt)
				BELTSTORE.Add("[icon2html(belt, user)] </span><span class='passiveglow'>[belt.name]</span>")
			if(BELTSTORE.len)
				msg += "\n<span class='statustext'>[t_He] has</span> [english_list(BELTSTORE)] on <span class='statustext'>[t_his] belt.</span>"
			//back
			if(back)
				ExamineList.Add("[icon2html(back, user)] <span class='passiveglow'>[back.name]</span>")

			//left hand
			if(l_hand)
				if(l_hand.blood_DNA)
					msg += "\n<span class='combat'>[t_He] holds [icon2html(l_hand, user)]</span> <span class='passiveglow'>[l_hand.name]</span> <span class='combat'>in [t_his] left hand!</span>"
				else
					msg += "\n<span class='statustext'>[t_He] holds [icon2html(l_hand, user)] \a </span><span class='passiveglow'>[l_hand]</span> <span class='statustext'>in [t_his] left hand.</span>"

			//right hand
			if(r_hand)
				if(r_hand.blood_DNA)
					msg += "\n<span class='combat'>[t_He] holds [icon2html(r_hand, user)]</span> <span class='passiveglow'>[r_hand.name]</span> <span class='combat'>in [t_his] right hand! (covered with blood)</span>"
				else
					msg += "\n<span class='statustext'>[t_He] [t_is] holding [icon2html(r_hand, user)] \a </span><span class='passiveglow'>[r_hand]</span> <span class='statustext'>in [t_his] right hand.</span>"

			//gloves
			if(gloves && !skipgloves)
				ExamineList.Add("[icon2html(gloves, user)] <span class='passiveglow'>[gloves.name]</span>")

			//handcuffed?

			//handcuffed?
			if(handcuffed)
				if(istype(handcuffed, /obj/item/handcuffs/cable))
					msg += "\n<span class='combat'>[t_He] [t_is] [icon2html(handcuffed, user)] restrained with cable!</span>"
				else
					msg += "\n<span class='combat'>[t_He] [t_is] [icon2html(handcuffed, user)] handcuffed!</span>"

			//shoes
			if(shoes && !skipshoes)
				if(shoes.blood_DNA)
					msg += "\n<span class='statustext'>[t_He] [t_is] wearing [icon2html(shoes, user)] [shoes.gender==PLURAL?"some":"a"] blood-stained</span> <span class='passiveglow'>[shoes.name]</span> <span class='statustext'>on [t_his] feets!</span> <span class='combat'>(covered in blood)</span>"
				else
					msg += "\n<span class='statustext'>[t_He] [t_is] wearing [icon2html(shoes, user)] \a </span><span class='passiveglow'>[shoes]</span> <span class='statustext'>on [t_his] feets."

			//mask
			if(wear_mask && !skipmask)
				if(wear_mask.blood_DNA)
					msg += "\n<span class='statustext'>[t_He] [t_has] [icon2html(wear_mask, user)] [wear_mask.gender==PLURAL?"some":"a"] blood-stained</span> <span class='passiveglow'>[wear_mask.name]</span> <span class='statustext'>on [t_his] face!</span> <span class='combat'>(covered in blood)</span>"
				else
					msg += "\n<span class='statustext'>[t_He] [t_has] [icon2html(wear_mask, user)] \a </span><span class='passiveglow'>[wear_mask]</span> <span class='statustext'>on [t_his] face.</span>"

			//eyes
			if(glasses && !skipeyes)
				ExamineList.Add("[icon2html(glasses, user)] <span class='passiveglow'>[glasses.name]</span>")
			//left ear
			if(l_ear && !skipears)
				msg += "\n<span class='statustext'>[t_He] [t_has] [icon2html(l_ear, user)] \a </span><span class='passiveglow'>[l_ear]</span> <span class='statustext'>on [t_his] left ear.</span>"

			//right ear
			if(r_ear && !skipears)
				msg += "\n<span class='statustext'>[t_He] [t_has] [icon2html(r_ear, user)] \a </span><span class='passiveglow'>[r_ear]</span> <span class='statustext'>on [t_his] right ear.</span>"

			if(wrist_r)
				ExamineList.Add("[icon2html(wrist_r, user)] <span class='passiveglow'>[wrist_r.name]</span>")
			if(wrist_l)
				ExamineList.Add("[icon2html(wrist_l, user)] <span class='passiveglow'>[wrist_l.name]</span>")

			if(amulet)
				msg += "\n<span class='statustext'>[t_He] [t_has] [icon2html(amulet, user)] \a </span><span class='passiveglow'>[amulet]</span> <span class='statustext'>on [t_his] neck.</span>"
			else
				if(vampirebit)
					msg += "\n<span class='itsatrap'>[t_his] neck has teeth marks!</span>"

			if(back2)
				ExamineList.Add("[icon2html(back2, user)] <span class='passiveglow'>[back2.name]</span>")
		if(ExamineList.len)
			msg += "<p style='margin : 0; padding-top:0;font-size:13px;'>[t_He] also has [english_list(ExamineList)]</p>"
		if(!isobserver(user))
			if(seen_heart_key && is_dreamer(user))
				msg += "\n<span class='excommun'>It knows the [seen_heart_key] key!</span>"

		if(!wear_mask)
			if(ExposedFang || (prob(50) && P.special == "youlooksick"))
				msg += "\n<span class='itsatrap'>[t_He] has big, bloody fangs!</span>"

		if(!glasses)
			if(DeadEyes || (prob(50) && P.special == "youlooksick"))
				msg += "\n<span class='itsatrap'>[t_chis] eyes are shining and their pupils are white!</span>"
/*
		if(DeadEyes && ExposedFang || (prob(80) && P.special == "youlooksick"))
			msg+= "\n<span class='itsatrap2'>Holy shit, IT IS a vampire!</span>"
*/
		if(!isobserver(user))
			if(special == "merchunt" && ishuman(M))
				if(M.job && M.job == "Mercenary")
					msg += "\n<span class='excomm'>That's my target!</span>"

		if(P.species.name == "Midget")
			msg += "\n<span class='baronboldoutlined'>ha-ha, a midget! How revolting!</span>"
		if(!isobserver(user))
			if(ishuman(P) && ishuman(M))
				if(P.religion && M.religion)
					if(P.religion == "Thanati" && M.religion == "Thanati")
						if(gender == FEMALE)
							msg += "\n<span class='baronboldoutlined'>It's my sister in faith. Glory to the Overlord!</span>"
						else
							msg += "\n<span class='baronboldoutlined'>It's my brother in faith. Glory to the Overlord!</span>"

		if(!isobserver(user))
			if(ishuman(P) && ishuman(M) && M.mind)
				for(var/datum/relation/family/R in M.mind?.relations)//NPC's don't have fucking minds.
					if(R?.relation_holder?.current == src)
						msg += "\n<span class='baronboldoutlined'>It's my [R.name]!</span>"

		if(!isobserver(user))
			if(ishuman(P) && ishuman(M))
				if(P.special == "piercinggaze")
					if(M != P && P != M)
						M.rotate_plane()

		if(ishuman(P) && !isStealth())
			if(ishuman(M))
				if((M.my_stats.get_stat(STAT_IN) >= 8 && M.my_stats.get_stat(STAT_PR) >= 12) || M.my_skills.get_skill(SKILL_OBSERV) >= 2)
					msg += "<p style='margin : 0; padding-top:0;font-size:12px;'><span class='moodboxtext'>[t_He] is around <b>[P.height]cm</b> tall.</span></p>"
				if((M.my_stats.get_stat(STAT_IN) >= 10 && M.my_stats.get_stat(STAT_PR) >= 14) || M.my_skills.get_skill(SKILL_OBSERV) >= 3)
					if(P.combat_mode)
						msg += "<p style='margin : 0; padding-top:0;font-size:12px;'><span class='combatbold'>[t_He] is aware.</span></p>"
		if(!isobserver(user) && !isStealth())
			if(ishuman(M))
				var/totaldifference = null
				if(P.height > M.height)
					totaldifference = P.height - M.height
					if(totaldifference >= 6)
						msg += "<p style='margin : 0; padding-top:0;font-size:12px;'><small><span class='moodboxtext'>[t_He] is taller than me.</span></small></p>"
					else
						msg += "<p style='margin : 0; padding-top:0;font-size:12px;'><small><span class='moodboxtext'>[t_He] is slightly taller than me.</span></small></p>"
				if(P.height == M.height)
					msg += "<p style='margin : 0; padding-top:0;font-size:12px;'><small><span class='moodboxtext'>[t_He] is the same size as me.</span></small></p>"
				if(P.height < M.height)
					totaldifference = M.height - P.height
					if(totaldifference >= 6)
						msg += "<p style='margin : 0; padding-top:0;font-size:12px;'><small><span class='moodboxtext'>[t_He] is shorter than me.</span></small></p>"
					else
						msg += "<p style='margin : 0; padding-top:0;font-size:12px;'><small><span class='moodboxtext'>[t_He] is slightly shorter than me.</span></small></p>"
				if(P.eye_closed)
					msg += "<p style='margin : 0; padding-top:0;font-size:12px;'><small><span class='moodboxtext'>[t_chis] eyes are closed.</span></small></p>"
		if(!isobserver(user) && (ishuman(M)))
			if(M?.isVampire)
				var/blood_volume = round(P:vessel.get_reagent_amount("blood"))
				var/blood_percent =  blood_volume / 560
				blood_percent *= 100
				blood_percent = round(blood_percent)
				msg += "<p style='margin : 0; padding-top:0;font-size:15px;'><span class='excomm'>[blood_percent]% blood left on [src]</span></p>"
		//splints
		for(var/organ in list("l_leg","r_leg","l_arm","r_arm"))
			var/datum/organ/external/o = get_organ(organ)
			if(o && o.status & ORGAN_SPLINTED)
				msg += "\n<span class='combat'>[t_He] [t_has] a splint on [t_his] [o.display_name]!</span>"

		if(mSmallsize in mutations)
			msg += "\n[t_He] [t_is] small halfling!"

		var/distance = get_dist(user,src)
		if(istype(user, /mob/dead/observer) || user.stat == 2) // ghosts can see anything
			distance = 1
		if (src.stat)
			msg += "\n<span class='passive'>[t_He] [t_is]n't responding to anything around [t_him] and seems to be asleep.</span>"
			if((stat == 2 || src.death_door) && distance <= 3)
				msg += "\n<span class='horriblestate'>[t_He] does not appear to be breathing.</span>"
			if(istype(user, /mob/living/carbon/human) && !user.stat && distance <= 1)
				user.visible_message("<span class='passivebold'>[user]</span> <span class='passive'>checks</span> <span class='passivebold'>[src]</span><span class='passive'>'s pulse.</span>", 1)
			/*
			spawn(0)
				if(distance <= 1 && user.stat != 1)
					if(do_after(user, 15))					
						if(pulse == PULSE_NONE)
							to_chat(user, "<span class='horriblestate'>[t_He] has no pulse[src.client ? "" : " and [t_his] soul has departed"]...</span>")
						else
							to_chat(user, "<span class='passiveglow'>[t_He] has a pulse!</span>")
			*/

		msg += "<span class='warning'>"


		msg += "</span>"

		if(stat == UNCONSCIOUS)
			msg += "\n<span class='passiveglow'>[t_He] unconscious.</span>"

		if((has_brain()) && !is_npc && stat != DEAD)
			if(!key)
				msg += "\n<span class='cavedoze'>Yellow saliva drips from [t_his] mouth, cave doze perhaps?</span>"
			else if(!client)
				msg += "\n<span class='cavedoze'>Yellow saliva drips from [t_his] mouth, cave doze perhaps?</span>"

		var/list/wound_flavor_text = list()
		var/list/is_destroyed = list()
		var/list/is_bleeding = list()
		for(var/datum/organ/external/temp in organs)
			if(temp)
				if(temp.status & ORGAN_DESTROYED)
					is_destroyed["[temp.display_name]"] = 1
					wound_flavor_text["[temp.display_name]"] = "\n<span class='magentasmall'>[t_He] is missing [t_his] [temp.display_name].</span>"
					continue
				if(temp.status & ORGAN_ROBOT)
					if(!(temp.brute_dam + temp.burn_dam))
						wound_flavor_text["[temp.display_name]"] = "\n<span class='magentasmall'>[t_He] has a robot [temp.display_name]!</span>"
						continue
					else
						wound_flavor_text["[temp.display_name]"] = "<span class='magentasmall'>[t_He] has a robot [temp.display_name], it has"
					if(temp.brute_dam) switch(temp.brute_dam)
						if(0 to 20)
							wound_flavor_text["[temp.display_name]"] += " some dents"
						if(21 to INFINITY)
							wound_flavor_text["[temp.display_name]"] += pick(" a lot of dents"," severe denting")
					if(temp.brute_dam && temp.burn_dam)
						wound_flavor_text["[temp.display_name]"] += " and"
					if(temp.burn_dam) switch(temp.burn_dam)
						if(0 to 20)
							wound_flavor_text["[temp.display_name]"] += " some burns"
						if(21 to INFINITY)
							wound_flavor_text["[temp.display_name]"] += pick(" a lot of burns"," severe melting")
					wound_flavor_text["[temp.display_name]"] += "\n!</span>"
				else if(temp.wounds.len > 0)
					var/list/wound_descriptors = list()
					for(var/datum/wound/W in temp.wounds)
						if(W.internal && !temp.open) continue // can't see internal wounds
						var/this_wound_desc = W.desc
						if(W.bleeding()) this_wound_desc = "bleeding [this_wound_desc]"
						else if(W.bandaged) this_wound_desc = "bandaged [this_wound_desc]"
						if(W.germ_level > 250) this_wound_desc = "badly [pick("infected", "smelling")] [this_wound_desc]"
						else if(W.germ_level > 50) this_wound_desc = "lightly infected [this_wound_desc]"
						if(this_wound_desc in wound_descriptors)
							wound_descriptors[this_wound_desc] += W.amount
							continue
						wound_descriptors[this_wound_desc] = W.amount
					if(wound_descriptors.len)
						var/list/flavor_text = list()
						var/list/no_exclude = list("gaping wound", "big gaping wound", "massive wound", "large bruise",\
						"huge bruise", "massive bruise", "severe burn", "large burn", "deep burn", "carbonised area")
						for(var/wound in wound_descriptors)
							switch(wound_descriptors[wound])
								if(1)
									if(!flavor_text.len)
										flavor_text += "<span class='magentasmall'>[t_He] has[prob(10) && !(wound in no_exclude)  ? " what might be" : ""] a [wound]"
									else
										flavor_text += "[prob(10) && !(wound in no_exclude) ? " what might be" : ""] a [wound]"
								if(2)
									if(!flavor_text.len)
										flavor_text += "<span class='magentasmall'>[t_He] has[prob(10) && !(wound in no_exclude) ? " what might be" : ""] a pair of [wound]s"
									else
										flavor_text += "[prob(10) && !(wound in no_exclude) ? " what might be" : ""] a pair of [wound]s"
								if(3 to 5)
									if(!flavor_text.len)
										flavor_text += "<span class='magentasmall'>[t_He] has several [wound]s"
									else
										flavor_text += " several [wound]s"
								if(6 to INFINITY)
									if(!flavor_text.len)
										flavor_text += "<span class='magentasmall'>[t_He] has a bunch of [wound]s"
									else
										flavor_text += " a ton of [wound]\s"
						var/flavor_text_string = "\n"
						for(var/text = 1, text <= flavor_text.len, text++)
							if(text == flavor_text.len && flavor_text.len > 1)
								flavor_text_string += ", and"
							else if(flavor_text.len > 1 && text > 1)
								flavor_text_string += ","
							flavor_text_string += flavor_text[text]
						flavor_text_string += " on [t_his] [temp.display_name].</span>"
						wound_flavor_text["[temp.display_name]"] = flavor_text_string
					else
						wound_flavor_text["[temp.display_name]"] = ""
					if(temp.status & ORGAN_BLEEDING)
						is_bleeding["[temp.display_name]"] = 1
				else
					wound_flavor_text["[temp.display_name]"] = ""

		//Handles the text strings being added to the actual description.
		//If they have something that covers the limb, and it is not missing, put flavortext.  If it is covered but bleeding, add other flavortext.
		var/display_chest = 0
		var/display_shoes = 0
		var/display_gloves = 0
		if(is_bleeding["right foot"])
			display_shoes = 1
		if(display_chest)
			msg += "\n<span class='combatglow'><b>[src] has blood soaking through from under [t_his] clothing!</b></span>"
		if(display_shoes)
			msg += "\n<span class='combatglow'><b>[src] has blood running from [t_his] shoes!</b></span>"
		if(display_gloves)
			msg += "\n<span class='combatglow'><b>[src] has blood running from under [t_his] gloves!</b></span>"
		for(var/implant in get_visible_implants(1))
			msg += "\n<span class='combatglow'><b>[src] has \a [implant] sticking out of their flesh!</span>"
		if(digitalcamo)
			msg += "\n<span class='combatglow'>[t_He] [t_is] repulsively uncanny!</span>"

		var/datum/organ/external/mouth/O = locate() in organs

		if(O && O.get_teeth() < O.max_teeth)
			msg += "\n<span class='combatglow'><B>[O.get_teeth() <= 0 ? "All" : "[O.max_teeth - O.get_teeth()]"] of [t_his] teeth are missing!</B></span>"

		if(is_nude() && (penis_size > -1) && species.genitals && !isChild())//Interactions
			if(!wear_suit)
				if(gender == FEMALE && (futa || isFemboy()))
					msg += "\n<span class='bname'>Penis size: [penis_size]cm.</span>"
					msg += SPAN_BNAME("\nBreast size: [breast_size].")
				else if(gender == MALE)
					msg += "\n<span class='bname'>Penis size: [penis_size]cm.</span>"

		if(is_nude() && gender == FEMALE && species.genitals && futa == FALSE && !isChild())
			msg += SPAN_BNAME("\nBreast size: [breast_size].")
			if(virgin)
				msg += "\n<span class='erp'>Their cherry is intact!</span>\n"

		if(is_nude() && mutilated_genitals)
			msg += "\n<span class='combatglow'><b>THEIR GROIN IS DESTROYED!</b></span>\n"

		if(right_eye_fucked && !left_eye_fucked && !istype(src.glasses, /obj/item/clothing/glasses/Reyepatch))
			msg += "\n<span class='combatglow'><b>[t_chis] right eye is destroyed!</b></span>\n"
		else if(!right_eye_fucked && left_eye_fucked && !istype(src.glasses, /obj/item/clothing/glasses/Leyepatch))
			msg += "\n<span class='combatglow'><b>[t_chis] left eye is destroyed!</b></span>\n"
		else if(right_eye_fucked && left_eye_fucked)
			msg += "\n<span class='combatglow'><b>[t_chis] eyes are destroyed!</b></span>\n"

		if(reagents.has_reagent("cocaine"))
			msg += "\n<span class='combatglow'><b>[t_chis] pupils are widened.</b></span>\n"

		if(pale)
			msg += "\n<span class='combatglow'><b>[t_He] look pale.</b></span>\n"

		if(happiness <= MOOD_LEVEL_SAD2)
			msg += "\n<span class='statustext'>[t_He] looks sad.</span>"

		if(decaylevel == 1)
			msg += "\n<span class='combat'>[t_He] [t_is] starting to smell.</span>"
		if(decaylevel == 2)
			msg += "\n<span class='combat'>[t_He] [t_is] bloated and smells disgusting.</span>"
		if(decaylevel == 3)
			msg += "\n<span class='combat'>[t_He] [t_is] rotting and blackened, the skin sloughing off. The smell is indescribably foul.</span>"
		if(decaylevel == 4)
			msg += "\n<span class='combat'>[t_He] [t_is] mostly dessicated now, with only bones remaining of what used to be a person.</span>"

		if(ishuman(M) && ishuman(P))
			var/Pmystatsst = P.my_stats.get_stat(STAT_ST)
			var/Mmystatsst = M.my_stats.get_stat(STAT_ST)

			if(is_dreamer(user))
				Mmystatsst = M.my_stats.get_stat(STAT_ST)

			if(!isobserver(user) && !isStealth() && src != user)//Please no more looking at myself and thinking I'm as strong as I am.
				if(Pmystatsst > Mmystatsst && Pmystatsst < (Mmystatsst + 5))
					msg += "\n<span class='combat'>[t_He] looks stronger than you.</span>"

				if(Pmystatsst > (Mmystatsst + 5))
					msg += "\n<span class='combatglow'><b>[t_He] looks a lot stronger than you.</b></span>"

				if(Pmystatsst == Mmystatsst)
					msg += "\n<span class='combat'>[t_He] looks as strong as you.</span>"

				if(Pmystatsst < Mmystatsst)
					msg += "\n<span class='passiveglow'>[t_He] looks weaker than you.</span>"

		msg += "\n</span>"
		if(distance <= 1 && ishuman(src))
			msg += "<hr class='linexd'>"
			var/datum/organ/external/head/H = get_organ("head")
			var/datum/organ/external/head/THR = get_organ("throat")
			if(H && H.brained)
				msg += "\n<span class='magentasmall'><b>[src]</b>'s skull is crushed and the brain is exposed to the air!</span>"
			if(THR && THR.hasVocal && THR.VocalTorn)
				msg += "\n<span class='magentasmall'><b>[src]</b>'s vocal chords are torn!</span>"
			if(wound_flavor_text["head"] && (is_destroyed["head"] || (!skipmask && !(wear_mask && istype(wear_mask, /obj/item/clothing/mask/gas)))))
				msg += wound_flavor_text["head"]
			else if(is_bleeding["head"])
				msg += "\n<span class='magentasmall'>[src] head is bleeding!</span>"
			if(wound_flavor_text["chest"] && !w_uniform && !skipjumpsuit) //No need.  A missing chest gibs you.
				msg += wound_flavor_text["chest"]
			else if(is_bleeding["chest"])
				display_chest = 1
			if(wound_flavor_text["left arm"] && (is_destroyed["left arm"] || (!w_uniform && !skipjumpsuit)))
				msg += wound_flavor_text["left arm"]
			else if(is_bleeding["left arm"])
				display_chest = 1
			if(wound_flavor_text["left hand"] && (is_destroyed["left hand"] || (!gloves && !skipgloves)))
				msg += wound_flavor_text["left hand"]
			else if(is_bleeding["left hand"])
				display_gloves = 1
			if(wound_flavor_text["right arm"] && (is_destroyed["right arm"] || (!w_uniform && !skipjumpsuit)))
				msg += wound_flavor_text["right arm"]
			else if(is_bleeding["right arm"])
				display_chest = 1
			if(wound_flavor_text["right hand"] && (is_destroyed["right hand"] || (!gloves && !skipgloves)))
				msg += wound_flavor_text["right hand"]
			else if(is_bleeding["right hand"])
				display_gloves = 1
			if(wound_flavor_text["groin"] && (is_destroyed["groin"] || (!w_uniform && !skipjumpsuit)))
				msg += wound_flavor_text["groin"]
			else if(is_bleeding["groin"])
				display_chest = 1
			if(wound_flavor_text["left leg"] && (is_destroyed["left leg"] || (!w_uniform && !skipjumpsuit)))
				msg += wound_flavor_text["left leg"]
			else if(is_bleeding["left leg"])
				display_chest = 1
			if(wound_flavor_text["left foot"]&& (is_destroyed["left foot"] || (!shoes && !skipshoes)))
				msg += wound_flavor_text["left foot"]
			else if(is_bleeding["left foot"])
				display_shoes = 1
			if(wound_flavor_text["right leg"] && (is_destroyed["right leg"] || (!w_uniform && !skipjumpsuit)))
				msg += wound_flavor_text["right leg"]
			else if(is_bleeding["right leg"])
				display_chest = 1
			if(wound_flavor_text["right foot"]&& (is_destroyed["right foot"] || (!shoes  && !skipshoes)))
				msg += wound_flavor_text["right foot"]
		to_chat(user, "[msg]</div></div>")
