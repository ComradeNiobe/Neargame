/obj/item/paper/talisman
	icon_state = "paper_talisman"
	var/imbue = null
	var/uses = 0


	examine()
		set src in view(2)
		..()
		return


	attack_self(mob/living/user as mob)
		if(iscultist(user))
			var/delete = 1
			switch(imbue)
				if("newtome")
					call(/obj/effect/rune/proc/tomesummon)()
				if("armor")
					call(/obj/effect/rune/proc/armor)()
				if("emp")
					call(/obj/effect/rune/proc/emp)(usr.loc,3)
				if("conceal")
					call(/obj/effect/rune/proc/obscure)(2)
				if("revealrunes")
					call(/obj/effect/rune/proc/revealrunes)(src)
				if("ire", "ego", "nahlizet", "certum", "veri", "jatkaa", "balaq", "mgar", "karazet", "geeri")
					call(/obj/effect/rune/proc/teleport)(imbue)
				if("communicate")
					//If the user cancels the talisman this var will be set to 0
					delete = call(/obj/effect/rune/proc/communicate)()
				if("deafen")
					call(/obj/effect/rune/proc/deafen)()
				if("blind")
					call(/obj/effect/rune/proc/blind)()
				if("runestun")
					user << "\red To use this talisman, attack your target directly."
					return
				if("supply")
					supply()
			user.take_organ_damage(5, 0)
			if(src && src.imbue!="supply" && src.imbue!="runestun")
				if(delete)
					qdel(src)
			return
		else
			user << "You see strange symbols on the paper. Are they supposed to mean something?"
			return


	attack(mob/living/carbon/T as mob, mob/living/user as mob)
		if(iscultist(user))
			if(imbue == "runestun")
				user.take_organ_damage(5, 0)
				call(/obj/effect/rune/proc/runestun)(T)
				qdel(src)
			else
				..()   ///If its some other talisman, use the generic attack code, is this supposed to work this way?
		else
			..()


	proc/supply(var/key)
		if (!src.uses)
			qdel(src)
			return

		var/dat = "<B>There are [src.uses] bloody runes on the parchment.</B><BR>"
		dat += "Please choose the chant to be imbued into the fabric of reality.<BR>"
		dat += "<HR>"
		dat += "<A href='byond://?src=\ref[src];rune=newtome'>N'ath reth sh'yro eth d'raggathnor!</A> - Allows you to summon a new arcane tome.<BR>"
		dat += "<A href='byond://?src=\ref[src];rune=teleport'>Sas'so c'arta forbici!</A> - Allows you to move to a rune with the same last word.<BR>"
		dat += "<A href='byond://?src=\ref[src];rune=emp'>Ta'gh fara'qha fel d'amar det!</A> - Allows you to destroy technology in a short range.<BR>"
		dat += "<A href='byond://?src=\ref[src];rune=conceal'>Kla'atu barada nikt'o!</A> - Allows you to conceal the runes you placed on the floor.<BR>"
		dat += "<A href='byond://?src=\ref[src];rune=communicate'>O bidai nabora se'sma!</A> - Allows you to coordinate with others of your cult.<BR>"
		dat += "<A href='byond://?src=\ref[src];rune=runestun'>Fuu ma'jin</A> - Allows you to stun a person by attacking them with the talisman.<BR>"
		dat += "<A href='byond://?src=\ref[src];rune=armor'>Sa tatha najin</A> - Allows you to summon armoured robes and an unholy blade<BR>"
		dat += "<A href='byond://?src=\ref[src];rune=soulstone'>Kal om neth</A> - Summons a soul stone<BR>"
		dat += "<A href='byond://?src=\ref[src];rune=construct'>Da A'ig Osk</A> - Summons a construct shell for use with captured souls. It is too large to carry on your person.<BR>"
		usr << browse(dat, "window=id_com;size=350x200")
		return



/obj/item/paper/talisman/supply
	imbue = "supply"
	uses = 5