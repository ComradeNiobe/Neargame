	/*	Note from Carnie:
		The way datum/mind stuff works has been changed a lot.
		Minds now represent IC characters rather than following a client around constantly.

	Guidelines for using minds properly:

	-	Never mind.transfer_to(ghost). The var/current and var/original of a mind must always be of type mob/living!
		ghost.mind is however used as a reference to the ghost's corpse

	-	When creating a new mob for an existing IC character (e.g. cloning a dead guy or borging a brain of a human)
		the existing mind of the old mob should be transfered to the new mob like so:

			mind.transfer_to(new_mob)

	-	You must not assign key= or ckey= after transfer_to() since the transfer_to transfers the client for you.
		By setting key or ckey explicitly after transfering the mind with transfer_to you will cause bugs like DCing
		the player.

	-	IMPORTANT NOTE 2, if you want a player to become a ghost, use mob.ghostize() It does all the hard work for you.

	-	When creating a new mob which will be a new IC character (e.g. putting a shade in a construct or randomly selecting
		a ghost to become a xeno during an event). Simply assign the key or ckey like you've always done.

			new_mob.key = key

		The Login proc will handle making a new mob for that mobtype (including setting up stuff like mind.name). Simple!
		However if you want that mind to have any special properties like being a traitor etc you will have to do that
		yourself.

*/

datum/mind
	var/key
	var/name				//replaces mob/var/original_name
	var/mob/living/current
	var/mob/living/original	//TODO: remove.not used in any meaningful way ~Carn. First I'll need to tweak the way silicon-mobs handle minds.
	var/active = 0

	var/memory

	var/assigned_role
	var/special_role
	var/special_role_dreamer_wakeup = 0
	var/datum/job/assigned_job

	var/list/datum/objective/objectives = list()
	var/list/datum/objective/special_verbs = list()

	var/has_been_rev = 0//Tracks if this mind has been a rev or not

	var/datum/faction/faction 			//associated faction
	var/datum/changeling/changeling		//changeling holder
	var/datum/alien/alien				//alien
	var/last_words 			//last spoken message
	var/datum/succubus/succubus			//succubus
	var/rev_cooldown = 0

	var/prayer

	var/religion

	// the world.time since the mob has been brigged, or -1 if not at all
	var/brigged_since = -1

	var/thanati_type = "None"
	var/thanati_corrupt = "None"
	var/thanati_word_random = "None"
	var/lord_hears_you = 0


	//These need to be removed
	var/husband
	var/wife
	var/son
	var/sister
	var/brother
	var/daughter
	var/father
	var/mother

	//used to make checking relations easy.
	var/list/datum/relation/relations = list()

	//TEACHING BLYAT!
	var/list/learning_collector[SKILL_SIZE]
	var/learning_modif = 0
	var/teaching_modif = 0

	//inquisition
	var/inquisi_type = "None"
	var/avowals_of_guilt_sent = 0
	var/cooldown_interrogate = 0
	var/list/known_connections //list of known (RNG) relations between people

	var/time_to_pay = 0

	var/say_color = null

	New(var/key)
		src.key = key
		say_color = pick("sayname1","sayname2","sayname3","sayname4","sayname5","sayname6","sayname7","sayname8","sayname9","sayname10")

	Destroy()
		. = ..()
		relations = null
		current = null
		initial_account = null
		original = null

	//put this here for easier tracking ingame
	var/datum/money_account/initial_account
	var/datum/antagonist/dreamer/antag_datums

	proc/transfer_to(mob/living/new_character)
		if(!istype(new_character))
			world.log << "## DEBUG: transfer_to(): Some idiot has tried to transfer_to() a non mob/living mob. Please inform Carn"
		if(current)					//remove ourself from our old body's mind variable
			if(changeling)
				current.remove_changeling_powers()
			current.mind = null
		if(new_character.mind)		//remove any mind currently in our new body's mind variable
			new_character.mind.current = null

		nanomanager.user_transferred(current, new_character) // transfer active NanoUI instances to new user

		current = new_character		//link ourself to our new body
		new_character.mind = src	//and link our new body to ourself

		if(changeling)
			new_character.make_changeling()

		if(active)
			new_character.key = key		//now transfer the key to link the client to our new body

	proc/store_memory(new_text)
		memory += "[new_text]<BR>"

	proc/show_memory(mob/recipient)
		var/list/dat = list()

		dat += "<TT><CENTER><b></b></CENTER></TT><br>"
		var/mob/living/carbon/human/U = current
		dat += memory

		if(objectives.len>0)
			dat += "<HR><B><font face='Hando' color = #000000>Objectives:</font></B>"

			var/obj_count = 1
			for(var/datum/objective/objective in objectives)
				dat += "<B><font face='Hando' color = #000000>Objective #[obj_count]</font></B>: [objective.explanation_text]"
				obj_count++
		if(U.royalty)
			dat += "<font face='Hando' color = #000000>The nuclear bomb is at the [round_nuke_loc]</font>"
		if(U.religion == "Thanati")
			var/brothers_message = "Your brothers and sisters in faith:<br>"
			for(var/mob/living/carbon/human/H in mob_list)
				if(H.religion == "Thanati")
					brothers_message += "<b> [H.real_name]</b> ([H?.mind?.thanati_type] Circle)<br>"
			dat += "<font face='Hando' color = #000000>[brothers_message]</font>"
			dat += "<font face='Hando' color = #000000>I am of the [thanati_type] circle</font>"
			dat += "<font face='Hando' color = #000000>The corrupt word is [thanati_corrupt], my circle word is [thanati_word_random], the circle of [thanati_type]!</font>"

		var/datum/browser/popup = new(usr, "memory", "MY MEMORIES", 400, 700)
		popup.set_content(JOINTEXT(dat))
		popup.open()

	proc/edit_memory()
		if(!ticker || !ticker.mode)
			alert("Not before round-start!", "Alert")
			return

		var/out = "<B>[name]</B>[(current&&(current.real_name!=name))?" (as [current.real_name])":""]<br>"
		out += "Mind currently owned by key: [key] [active?"(synced)":"(not synced)"]<br>"
		out += "Assigned role: [assigned_role]. <a href='byond://?src=\ref[src];role_edit=1'>Edit</a><br>"
		out += "Factions and special roles:<br>"

		var/list/sections = list(
			"wizard",
			"changeling",
			"nuclear",
			"monkey",
		)
		var/text = ""

		if (istype(current, /mob/living/carbon/human) || istype(current, /mob/living/carbon/monkey))
			/** WIZARD ***/
			text = "wizard"
			if (ticker.mode.config_tag=="wizard")
				text = uppertext(text)
			text = "<i><b>[text]</b></i>: "

			/** WAKER ***/

			text = "waker"
			if (ticker.mode.config_tag=="waker")
				text = uppertext(text)
			text = "<i><b>[text]</b></i>: "
			text += "<a href='byond://?src=\ref[src];waker=waker'>yes</a>|<b>NO</b>"
			sections["waker"] = text

			/** SOULBREAKER ***/

			text = "vampire"
			if (ticker.mode.config_tag=="vampire")
				text = uppertext(text)
			text = "<i><b>[text]</b></i>: "
			text += "<a href='byond://?src=\ref[src];vampire=vampire'>yes</a>|<b>NO</b>"
			sections["vampire"] = text

			/** CHANGELING ***/
			text = "changeling"
			if (ticker.mode.config_tag=="changeling" || ticker.mode.config_tag=="traitorchan")
				text = uppertext(text)
			text = "<i><b>[text]</b></i>: "
			if (src in ticker.mode.changelings)
				text += "<b>YES</b>|<a href='byond://?src=\ref[src];changeling=clear'>no</a>"
				if (objectives.len==0)
					text += "<br>Objectives are empty! <a href='byond://?src=\ref[src];changeling=autoobjectives'>Randomize!</a>"
				if( changeling && changeling.absorbed_dna.len && (current.real_name != changeling.absorbed_dna[1]) )
					text += "<br><a href='byond://?src=\ref[src];changeling=initialdna'>Transform to initial appearance.</a>"
			else
				text += "<a href='byond://?src=\ref[src];changeling=changeling'>yes</a>|<b>NO</b>"
//			var/datum/game_mode/changeling/changeling = ticker.mode
//			if (istype(changeling) && changeling.changelingdeath)
//				text += "<br>All the changelings are dead! Restart in [round((changeling.TIME_TO_GET_REVIVED-(world.time-changeling.changelingdeathtime))/10)] seconds."
			sections["changeling"] = text

			/** NUCLEAR ***/
			text = "nuclear"
			if (ticker.mode.config_tag=="nuclear")
				text = uppertext(text)
			text = "<i><b>[text]</b></i>: "
			sections["nuclear"] = text

		for (var/i in sections)
			if (sections[i])
				out += sections[i]+"<br>"

		out += "<br>"

		out += "<b>Memory:</b><br>"
		out += memory
		out += "<br><a href='byond://?src=\ref[src];memory_edit=1'>Edit memory</a><br>"
		out += "Objectives:<br>"
		if (objectives.len == 0)
			out += "EMPTY<br>"
		else
			var/obj_count = 1
			for(var/datum/objective/objective in objectives)
				out += "<B>[obj_count]</B>: [objective.explanation_text] <a href='byond://?src=\ref[src];obj_edit=\ref[objective]'>Edit</a> <a href='byond://?src=\ref[src];obj_delete=\ref[objective]'>Delete</a> <a href='byond://?src=\ref[src];obj_completed=\ref[objective]'><font color=[objective.completed ? "green" : "red"]>Toggle Completion</font></a><br>"
				obj_count++
		out += "<a href='byond://?src=\ref[src];obj_add=1'>Add objective</a><br><br>"

		out += "<a href='byond://?src=\ref[src];obj_announce=1'>Announce objectives</a><br><br>"

		usr << browse(out, "window=edit_memory[src]")

	Topic(href, href_list)
		if(!check_rights(R_ADMIN))	return

		if (href_list["role_edit"])
			var/new_role = input("Select new role", "Assigned role", assigned_role) as null|anything in get_all_jobs()
			if (!new_role) return
			assigned_role = new_role

		else if (href_list["memory_edit"])
			var/new_memo = sanitize(input("Write new memory", "Memory", memory) as null|message)
			if (isnull(new_memo)) return
			memory = new_memo

		else if (href_list["obj_edit"] || href_list["obj_add"])
			var/datum/objective/objective
			var/objective_pos
			var/def_value

			if (href_list["obj_edit"])
				objective = locate(href_list["obj_edit"])
				if (!objective) return
				objective_pos = objectives.Find(objective)

				//Text strings are easy to manipulate. Revised for simplicity.
				var/temp_obj_type = "[objective.type]"//Convert path into a text string.
				def_value = copytext(temp_obj_type, 19)//Convert last part of path into an objective keyword.
				if(!def_value)//If it's a custom objective, it will be an empty string.
					def_value = "custom"

			var/new_obj_type = input("Select objective type:", "Objective type", def_value) as null|anything in list("assassinate", "debrain", "protect", "prevent", "harm", "brig", "hijack", "escape", "survive", "steal", "download", "nuclear", "capture", "absorb", "custom")
			if (!new_obj_type) return

			var/datum/objective/new_objective = null

			switch (new_obj_type)
				if ("assassinate","protect","debrain", "harm", "brig")
					//To determine what to name the objective in explanation text.
					var/objective_type_capital = uppertext(copytext(new_obj_type, 1,2))//Capitalize first letter.
					var/objective_type_text = copytext(new_obj_type, 2)//Leave the rest of the text.
					var/objective_type = "[objective_type_capital][objective_type_text]"//Add them together into a text string.

					var/list/possible_targets = list("Free objective")
					for(var/datum/mind/possible_target in ticker.minds)
						if ((possible_target != src) && istype(possible_target.current, /mob/living/carbon/human))
							possible_targets += possible_target.current

					var/mob/def_target = null
					var/objective_list[] = list(/datum/objective/assassinate, /datum/objective/protect, /datum/objective/debrain)
					if (objective&&(objective.type in objective_list) && objective:target)
						def_target = objective:target.current

					var/new_target = input("Select target:", "Objective target", def_target) as null|anything in possible_targets
					if (!new_target) return

					var/objective_path = text2path("/datum/objective/[new_obj_type]")
					if (new_target == "Free objective")
						new_objective = new objective_path
						new_objective.owner = src
						new_objective:target = null
						new_objective.explanation_text = "Free objective"
					else
						new_objective = new objective_path
						new_objective.owner = src
						new_objective:target = new_target:mind
						//Will display as special role if the target is set as MODE. Ninjas/commandos/nuke ops.
						new_objective.explanation_text = "[objective_type] [new_target:real_name], the [new_target:mind:assigned_role=="MODE" ? (new_target:mind:special_role) : (new_target:mind:assigned_role)]."

				if ("prevent")
					new_objective = new /datum/objective/block
					new_objective.owner = src

				if ("hijack")
					new_objective = new /datum/objective/hijack
					new_objective.owner = src

				if ("escape")
					new_objective = new /datum/objective/escape
					new_objective.owner = src

				if ("survive")
					new_objective = new /datum/objective/survive
					new_objective.owner = src

				if ("nuclear")
					new_objective = new /datum/objective/nuclear
					new_objective.owner = src

				if ("steal")
					if (!istype(objective, /datum/objective/steal))
						new_objective = new /datum/objective/steal
						new_objective.owner = src
					else
						new_objective = objective
					var/datum/objective/steal/steal = new_objective
					if (!steal.select_target())
						return

				if("download","capture")
					var/def_num
					if(objective&&objective.type==text2path("/datum/objective/[new_obj_type]"))
						def_num = objective.target_amount

					var/target_number = input("Input target number:", "Objective", def_num) as num|null
					if (isnull(target_number))//Ordinarily, you wouldn't need isnull. In this case, the value may already exist.
						return

					new_objective.owner = src
					new_objective.target_amount = target_number

				if ("custom")
					var/expl = sanitize(input("Custom objective:", "Objective", objective ? objective.explanation_text : "") as text|null)
					if (!expl) return
					new_objective = new /datum/objective
					new_objective.owner = src
					new_objective.explanation_text = expl

			if (!new_objective) return

			if (objective)
				objectives -= objective
				objectives.Insert(objective_pos, new_objective)
			else
				objectives += new_objective

		else if (href_list["obj_delete"])
			var/datum/objective/objective = locate(href_list["obj_delete"])
			if(!istype(objective))	return
			objectives -= objective

		else if(href_list["obj_completed"])
			var/datum/objective/objective = locate(href_list["obj_completed"])
			if(!istype(objective))	return
			objective.completed = !objective.completed

		else if (href_list["waker"])
			switch(href_list["waker"])
				if("waker")
					var/mob/living/carbon/human/H = current
					special_role = "Waker"
					//ticker.mode.learn_basic_spells(current)
					to_chat(H,"<span class='dreamershitfuckcomicao1'>Recentemente, tenho sido visitado por um monte de VISÕES. Elas falam sobre outro MUNDO, OUTRA vida. Eu farei de TUDO para saber a VERDADE, para retornar ao mundo REAL.</span>")
					to_chat(H, "<span class='dreamershitfuckcomicao1'>Sonho #1: SEGUIR meu CORAÇÃO deve ser TODA a minha lei.</span>")
					log_admin("[key_name_admin(usr)] has waker'ed [current].")
					H.combat_music = 'sound/lfwbsounds/bloodlust1.ogg'
					var/datum/antagonist/dreamer/D = new()
					H.mind.antag_datums = D
					H.my_skills.change_skill(SKILL_MELEE, 7)
					H.my_skills.change_skill(SKILL_RANGE, 7)
					H.my_stats.change_stat(STAT_ST , 10)
					H.my_stats.change_stat(STAT_DX , 8)
					H.my_stats.change_stat(STAT_HT , 15)
					H.verbs += /mob/living/carbon/human/proc/dreamer
					H.verbs += /mob/living/carbon/human/proc/dreamerArchetypes

		else if (href_list["soulbreaker"])
			switch(href_list["soulbreaker"])
				if("soulbreaker")
					//var/mob/living/carbon/human/H = current
					var/mob/living/carbon/human/new_character = new(pick(latejoin))
					var/list/pick_the_name = list("Bashar Ahmeed","Abu Marzook", "Abdul-Rashid","Eunuch","Jihad-Rashid")
					var/spawnpoint
					new_character.key = key
					new_character.gender = MALE
					special_role = "Soulbreaker"
					//ticker.mode.learn_basic_spells(current)
					to_chat(new_character, "<span class='dreamershitfuckcomicao1'>Você é um soulbreaker.</span")
					to_chat(new_character, "<span class='dreamershitfuckcomicao1'>Você escraviza pessoas vivas para que possam restaurar planetas perdidos. Você tem muitas ferramentas para fazer isso, então deve ser fácil capturar o migrante comum.</span>")
					log_admin("[key_name_admin(usr)] has soulbreaker'ed [new_character.key].")
					new_character << sound('sound/music/soulbreaker.ogg', repeat = 0, wait = 0, volume = 80, channel = 3)
					new_character.my_skills.change_skill(SKILL_MELEE, rand(3,6))
					new_character.my_skills.change_skill(SKILL_RANGE, rand(3,6))
					new_character.name = pick(pick_the_name)
					new_character.age = rand(24,45)
					new_character.voicetype = "strong"
					new_character.my_stats.change_stat(STAT_ST , 5)
					new_character.my_stats.change_stat(STAT_DX , 4)
					new_character.my_stats.change_stat(STAT_HT , 5)
					new_character.religion = "Allah"
					spawnpoint = pick(1,2,3,4)
					if(spawnpoint == 1)
						new_character.Move(locate(8,59,5))
					else if(spawnpoint == 2)
						new_character.Move(locate(9,59,5))
					else if(spawnpoint == 3)
						new_character.Move(locate(10,59,5))
					else
						new_character.Move(locate(11,59,5))

		else if (href_list["vampire"])
			switch(href_list["vampire"])
				if("vampire")
					var/mob/living/carbon/human/H = current
					special_role = "Vampire"
					H.vampire_me()

		else if (href_list["changeling"])
			switch(href_list["changeling"])
				if("clear")
					if(src in ticker.mode.changelings)
						ticker.mode.changelings -= src
						special_role = null
						current.remove_changeling_powers()
						if(changeling)	qdel(changeling)
						current << "<FONT color='red' size = 3><B>You grow weak and lose your powers! You are no longer a changeling and are stuck in your current form!</B></FONT>"
						log_admin("[key_name_admin(usr)] has de-changeling'ed [current].")
				if("changeling")
					if(!(src in ticker.mode.changelings))
						ticker.mode.changelings += src
						ticker.mode.grant_changeling_powers(current)
						special_role = "Changeling"
						current << "<B><font color='red'>Your powers are awoken. A flash of memory returns to us...we are a changeling!</font></B>"
						current << sound('sound/music/changeling_intro.ogg', repeat = 0, wait = 0, volume = 100, channel = 10)
						current << sound('sound/music/the_collective.ogg', repeat = 0, wait = 0, volume = 80, channel = 3)
						log_admin("[key_name_admin(usr)] has changeling'ed [current].")
				if("autoobjectives")
					ticker.mode.forge_changeling_objectives(src)
					usr << "\blue The objectives for changeling [key] have been generated. You can edit them and anounce manually."

				if("initialdna")
					if( !changeling || !changeling.absorbed_dna.len )
						usr << "\red Resetting DNA failed!"
					else
						current.dna = changeling.absorbed_dna[1]
						current.real_name = current.dna.real_name
						current.UpdateAppearance()
						domutcheck(current, null)

				if("lair")
					current.loc = get_turf(locate("landmark*Syndicate-Spawn"))
				if("dressup")
					var/mob/living/carbon/human/H = current
					qdel(H.belt)
					qdel(H.back)
					qdel(H.l_ear)
					qdel(H.r_ear)
					qdel(H.gloves)
					qdel(H.head)
					qdel(H.shoes)
					qdel(H.wear_id)
					qdel(H.wear_suit)
					qdel(H.w_uniform)
				if("tellcode")
					var/code
					for (var/obj/machinery/nuclearbomb/bombue in machines)
						if (length(bombue.r_code) <= 5 && bombue.r_code != "LOLNO" && bombue.r_code != "ADMIN")
							code = bombue.r_code
							break
					if (code)
						store_memory("<B>Syndicate Nuclear Bomb Code</B>: [code]", 0, 0)
						current << "The nuclear authorization code is: <B>[code]</B>"
					else
						usr << "\red No valid nuke found!"

		else if (href_list["monkey"])
			var/mob/living/L = current
			if (L.monkeyizing)
				return
			switch(href_list["monkey"])
				if("healthy")
					if (usr.client.holder.rights & R_ADMIN)
						var/mob/living/carbon/human/H = current
						var/mob/living/carbon/monkey/M = current
						if (istype(H))
							log_admin("[key_name(usr)] attempting to monkeyize [key_name(current)]")
							message_admins("\blue [key_name_admin(usr)] attempting to monkeyize [key_name_admin(current)]")
							src = null
							M = H.monkeyize()
							src = M.mind
							//world << "DEBUG: \"healthy\": M=[M], M.mind=[M.mind], src=[src]!"
						else if (istype(M) && length(M.viruses))
							for(var/datum/disease/D in M.viruses)
								D.cure(0)
							sleep(0) //because deleting of virus is done through spawn(0)
				if("infected")
					if (usr.client.holder.rights & R_ADMIN)
						var/mob/living/carbon/human/H = current
						var/mob/living/carbon/monkey/M = current
						if (istype(H))
							log_admin("[key_name(usr)] attempting to monkeyize and infect [key_name(current)]")
							message_admins("\blue [key_name_admin(usr)] attempting to monkeyize and infect [key_name_admin(current)]", 1)
							src = null
							M = H.monkeyize()
							src = M.mind
							current.contract_disease(new /datum/disease/jungle_fever,1,0)
						else if (istype(M))
							current.contract_disease(new /datum/disease/jungle_fever,1,0)
				if("human")
					var/mob/living/carbon/monkey/M = current
					if (istype(M))
						for(var/datum/disease/D in M.viruses)
							if (istype(D,/datum/disease/jungle_fever))
								D.cure(0)
								sleep(0) //because deleting of virus is doing throught spawn(0)
						log_admin("[key_name(usr)] attempting to humanize [key_name(current)]")
						message_admins("\blue [key_name_admin(usr)] attempting to humanize [key_name_admin(current)]")
						var/obj/item/dnainjector/m2h/m2h = new
						var/obj/item/implant/mobfinder = new(M) //hack because humanizing deletes mind --rastaf0
						src = null
						m2h.inject(M)
						src = mobfinder.loc:mind
						qdel(mobfinder)
						current.radiation -= 50

				if("unemag")
					var/mob/living/silicon/robot/R = current
					if (istype(R))
						R.emagged = 0
						if (R.activated(R.module.emag))
							R.module_active = null
						if(R.module_state_1 == R.module.emag)
							R.module_state_1 = null
							R.contents -= R.module.emag
						else if(R.module_state_2 == R.module.emag)
							R.module_state_2 = null
							R.contents -= R.module.emag
						else if(R.module_state_3 == R.module.emag)
							R.module_state_3 = null
							R.contents -= R.module.emag
						log_admin("[key_name_admin(usr)] has unemag'ed [R].")

				if("unemagcyborgs")
					if (istype(current, /mob/living/silicon/ai))
						var/mob/living/silicon/ai/ai = current
						for (var/mob/living/silicon/robot/R in ai.connected_robots)
							R.emagged = 0
							if (R.module)
								if (R.activated(R.module.emag))
									R.module_active = null
								if(R.module_state_1 == R.module.emag)
									R.module_state_1 = null
									R.contents -= R.module.emag
								else if(R.module_state_2 == R.module.emag)
									R.module_state_2 = null
									R.contents -= R.module.emag
								else if(R.module_state_3 == R.module.emag)
									R.module_state_3 = null
									R.contents -= R.module.emag
						log_admin("[key_name_admin(usr)] has unemag'ed [ai]'s Cyborgs.")

		else if (href_list["common"])
			switch(href_list["common"])
				if("undress")
					for(var/obj/item/W in current)
						current.drop_from_inventory(W)
				if("takeuplink")
					take_uplink()
					memory = null//Remove any memory they may have had.
				if("crystals")
					if (usr.client.holder.rights & R_FUN)
						var/obj/item/device/uplink/hidden/suplink = find_syndicate_uplink()
						var/crystals
						if (suplink)
							crystals = suplink.uses
						crystals = input("Amount of telecrystals for [key]","Syndicate uplink", crystals) as null|num
						if (!isnull(crystals))
							if (suplink)
								suplink.uses = crystals

		else if (href_list["obj_announce"])
			var/obj_count = 1
			current << "\blue Your current objectives:"
			for(var/datum/objective/objective in objectives)
				current << "<B>Objective #[obj_count]</B>: [objective.explanation_text]"
				obj_count++

		edit_memory()

	proc/find_syndicate_uplink()
		var/list/L = current.get_contents()
		for (var/obj/item/I in L)
			if (I.hidden_uplink)
				return I.hidden_uplink
		return null

	proc/take_uplink()
		var/obj/item/device/uplink/hidden/H = find_syndicate_uplink()
		if(H)
			qdel(H)

	proc/make_Dreamer()
		var/datum/game_mode/dreamer/D
		if(!(src in D.dreamer))
			D.dreamer += src
			special_role = "Waker"
			ticker.mode.finalize_dreamer(src)
			ticker.mode.greet_dreamer(src)

	proc/make_They()
		if(!(src in ticker.mode.changelings))
			ticker.mode.changelings += src
			ticker.mode.grant_changeling_powers(current)
			special_role = "Changeling"
			ticker.mode.forge_changeling_objectives(src)
			ticker.mode.greet_changeling(src)

	// check whether this mind's mob has been brigged for the given duration
	// have to call this periodically for the duration to work properly
	proc/is_brigged(duration)
		var/turf/T = current.loc
		if(!istype(T))
			brigged_since = -1
			return 0

		var/is_currently_brigged = 0

		if(istype(T.loc,/area/security/brig))
			is_currently_brigged = 1
			for(var/obj/item/card/id/card in current)
				is_currently_brigged = 0
				break // if they still have ID they're not brigged
			for(var/obj/item/device/pda/P in current)
				if(P.id)
					is_currently_brigged = 0
					break // if they still have ID they're not brigged

		if(!is_currently_brigged)
			brigged_since = -1
			return 0

		if(brigged_since == -1)
			brigged_since = world.time

		return (duration <= world.time - brigged_since)




//Initialisation procs
/mob/living/proc/mind_initialize()
	if(mind)
		mind.key = key
	else
		mind = new /datum/mind(key)
		mind.original = src
		if(ticker)
			ticker.minds += mind
		else
			world.log << "## DEBUG: mind_initialize(): No ticker ready yet! Please inform Carn"
	if(!mind.name)	mind.name = real_name
	mind.current = src

//HUMAN
/mob/living/carbon/human/mind_initialize()
	..()
	if(!mind.assigned_role)	mind.assigned_role = "Unassigned"	//defualt

//MONKEY
/mob/living/carbon/monkey/mind_initialize()
	..()

//XENO
/mob/living/carbon/alien/mind_initialize()
	..()
	mind.assigned_role = "Alien"
	//XENO HUMANOID
/mob/living/carbon/alien/humanoid/queen/mind_initialize()
	..()
	mind.special_role = "Queen"

/mob/living/carbon/alien/humanoid/hunter/mind_initialize()
	..()
	mind.special_role = "Hunter"

/mob/living/carbon/alien/humanoid/drone/mind_initialize()
	..()
	mind.special_role = "Drone"

/mob/living/carbon/alien/humanoid/sentinel/mind_initialize()
	..()
	mind.special_role = "Sentinel"
	//XENO LARVA

/mob/living/carbon/alien/larva/mind_initialize()
	..()
	mind.special_role = "Larva"

//AI
/mob/living/silicon/ai/mind_initialize()
	..()
	mind.assigned_role = "AI"

//BORG
/mob/living/silicon/robot/mind_initialize()
	..()
	mind.assigned_role = "Cyborg"

//PAI
/mob/living/silicon/pai/mind_initialize()
	..()
	mind.assigned_role = "pAI"
	mind.special_role = ""

//Animals
/mob/living/simple_animal/mind_initialize()
	..()
	mind.assigned_role = "Animal"

/mob/living/simple_animal/corgi/mind_initialize()
	..()
	mind.assigned_role = "Corgi"

/mob/living/simple_animal/shade/mind_initialize()
	..()
	mind.assigned_role = "Shade"

/mob/living/simple_animal/construct/builder/mind_initialize()
	..()
	mind.assigned_role = "Artificer"
	mind.special_role = "Cultist"

/mob/living/simple_animal/construct/wraith/mind_initialize()
	..()
	mind.assigned_role = "Wraith"
	mind.special_role = "Cultist"

/mob/living/simple_animal/construct/armoured/mind_initialize()
	..()
	mind.assigned_role = "Juggernaut"
	mind.special_role = "Cultist"

/mob/living/simple_animal/vox/armalis/mind_initialize()
	..()
	mind.assigned_role = "Armalis"
	mind.special_role = "Vox Raider"


