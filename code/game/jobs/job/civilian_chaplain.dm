//Due to how large this one is it gets its own file
var/global/Inquisitor_Points = 15 //HAHAHAHAHHAHAHAHAHAHHAHAH AAAAAAAAAAAAAAHAHAHAHAHAHAHAHHAHAHAHAHAHAHHAHAHAHAHHAHAHAHHA
var/global/Inquisitor_Type = "Null"

/datum/job/chaplain
	title = "Vicar"
	titlebr = "Bispo"
	flag = CHAPLAIN
	department_flag = ENGSEC
	faction = "Station"
	stat_mods = list(STAT_ST = 0, STAT_DX = -1, STAT_HT = 0, STAT_IN = 2)
	total_positions = 1
	spawn_positions = 1
	supervisors = "the god king"
	selection_color = "#dddddd"
	idtype = /obj/item/card/id/chaplain
	access = list(church, access_morgue, access_chapel_office, access_maint_tunnels, keep)
	minimal_access = list(church, access_morgue, access_chapel_office, keep)
	sex_lock = MALE
	jobdesc = "Head of the local church in Enoch&#8217;s Gate. He blesses those who give their tithes and strive to separate themselves from God. The Shepard of the sheep, he guides people who have lost their way back to the right path, either through confession or epitemia, and when that fails, the Praetor is a useful zealot that obeys him, while the sniffer, even if his true loyalties are questionable, has his own ways of ensuring The Church maintains its control.  Excommunication from the Church is nothing to be taken lightly and is reserved only for acts of serious, unrepentant heresy."
	skill_mods = list(
	list(SKILL_MELEE,0),
	list(SKILL_RANGE,0),
	list(SKILL_FARM,0),
	list(SKILL_COOK,0),
	list(SKILL_ENGINE,0),
	list(SKILL_KNIFE,1,3),
	list(SKILL_SURG,0),
	list(SKILL_MEDIC,0),
	list(SKILL_CLEAN,0),
	list(SKILL_CLIMB,1,2),
	list(SKILL_OBSERV, 2,2),
	)
	equip(var/mob/living/carbon/human/H)
		if(!H)
			return 0
		..()
		var/obj/item/storage/bible/B = new /obj/item/storage/bible(H) //BS12 EDIT
		H.equip_to_slot_or_del(B, slot_l_hand)
		H.voicetype = "noble"
		H.religion = "Gray Church"
		H.equip_to_slot_or_del(new /obj/item/clothing/under/rank/chaplain(H), slot_w_uniform)
		H.equip_to_slot_or_del(new /obj/item/clothing/suit/bishop(H), slot_wear_suit)
		H.equip_to_slot_or_del(new /obj/item/clothing/shoes/lw/brown(H), slot_shoes)
		H.equip_to_slot_or_del(new /obj/item/device/radio/headset/bracelet/vicar(H), slot_wrist_r)
		H.equip_to_slot_or_del(new /obj/item/clothing/head/amulet/epitrachelion(H), slot_amulet)
		H.add_verb(list(
			/mob/living/carbon/human/proc/excommunicate,
			/mob/living/carbon/human/proc/callmeeting,
			/mob/living/carbon/human/proc/marriage,
			/mob/living/carbon/human/proc/banish,
			/mob/living/carbon/human/proc/undeadead,
			/mob/living/carbon/human/proc/sins,
			/mob/living/carbon/human/proc/coronation,
			/mob/living/carbon/human/proc/reward,
			/mob/living/carbon/human/proc/eucharisty,
			/mob/living/carbon/human/proc/ClearName,
			/mob/living/carbon/human/proc/knifeprayer,
			/mob/living/carbon/human/proc/epitemia,
			/mob/living/carbon/human/proc/bloodyhands
		))
		H.updateStatPanel()
		H.create_kg()
		//H << sound('sound/music/train_music.ogg', repeat = 0, wait = 0, volume = 20, channel = 3)
		return 1

/mob/living/carbon/human/proc/knifeprayer()
	set hidden = 0
	set category = "cross"
	set name = "KnifePrayer"
	set desc="Knife Prayer"

	if(stat) return
	src.qualarea()
	var/flock = 0
	var/enemies = 0
	var/mob/living/carbon/human/prayer_user = usr
	prayer_user.qualarea()
	if(knifeprayer == TRUE)
		to_chat(prayer_user, "<span class='churchexcomm'>Am I stupid? I already did this.</span>")
		return
	if(prayer_user.lastarea && istype(lastarea, /area/dunwell/station/church))
		for(var/mob/living/carbon/human/H in view(5, src))
			if(H.bloody_hands)
				flock += 1
			if(H.religion == "Thanati")
				enemies += 1
		src.visible_message("<font color ='#649568'><b>[src]</b> begins singing, channeling the light of the Comatic")
		if(do_after(src, 30))
			if(enemies > 0)
				src.visible_message("<font color ='#649568'><b>[src]</b> abruptly stops singing, coughing up dark black blood.")
				var/datum/organ/external/affected = prayer_user.get_organ("throat")
				affected.VocalTorn = TRUE
				to_chat(prayer_user, "<span class='combatbold'>Vocal chords were torn!</span>")
				flock = 0
				enemies = 0
				return
			if(flock < 5)
				src.visible_message("<font color ='#649568'><b>[src]</b> grows quiet, their voice not strong enough.")
				to_chat(src, "<span class='churchexcomm'>I only have [flock] bloodied followers!</span>")
				flock = 0
				enemies = 0
				return
			if(flock >= 5)
				src.visible_message("<font color ='#649568'><b>[src]</b> produces a beautiful melody, resonating with the power of the Comatic.")
				to_chat(world, "<h1 class='churchannouncement'>Grey Post-Christian Church</span>")
				to_chat(world, "<span class='churchexcomm'>Vicar [src] has delivered Enoch's Gate from the Warlock's evil another night!</span>")
				world << sound('sound/AI/bell_toll.ogg')
				to_chat(world, "<br>")
				to_chat(world, "<span class='churchdecree'>God be Saved!</span>")
				to_chat(world, "<br>")
				knifeprayer = TRUE
				for(var/mob/living/carbon/human/H in living_mob_list)
					H.clear_event("cursed", /datum/happiness_event/cursed)
	else
		to_chat(prayer_user, "<span class='churchexcomm'>[pick(fnord)] I can't. I must go to the church.</span>")



/mob/living/carbon/human/proc/excommunicate()
	set hidden = 0
	set category = "cross"
	set name = "Excommunicate"
	set desc="Excommunicate"
	var/input = sanitize_name(input(usr, "Enter the name of the excommunicated member.", "What?", "") as text|null)
	var/mob/living/carbon/human/H = usr

	if(!input) return
	if(stat) return

	H.qualarea()
	if(H.lastarea && istype(lastarea, /area/dunwell/station/church))
		world << sound('sound/AI/bell_toll_02_lp.ogg')
		to_chat(world, "<span class='churchannouncement'>Grey Post-Christian Church</span>")
		to_chat(world, "<span class='churchexcomm'>Vicar [src.real_name] excommunicates [input]!</span>")
		world << sound('sound/AI/bell_toll.ogg')
		to_chat(world, "<br>")
		to_chat(world, "<span class='churchdecree'>Anathema!</span>")
		to_chat(world, "<br>")
		for(var/mob/living/carbon/human/HH in mob_list)
			if(ticker.eof.id == "godwill" && (HH.real_name == input || HH.name == input))
				bans.Add(HH.ckey)
				if(HH.client)
					qdel(HH.client)
			var/isValidPerson = 0
			if(HH.name == input && HH.religion == "Gray Church")
				HH.add_event("excom", /datum/happiness_event/excom)
				HH.rotate_plane()
				HH.excomunicated = TRUE
				isValidPerson = 1
			if(HH.name == input && HH.religion == "Thanati")
				HH.add_event("excom", /datum/happiness_event/excomthanati)
				HH.excomunicated = TRUE
				isValidPerson = 1
			if(HH.name != input && HH.religion == "Gray Church" && isValidPerson)
				var/datum/happiness_event/excomothers/E = new()
				E.description = "<span class='badmood'>• I MUST KILL [uppertext(input)]!</span>\n"
				HH.add_precreated_event("[uppertext(input)]excom", E)

		log_admin("[key_name(src)] has excommunicated someone: [input]")
		message_admins("[key_name_admin(src)] has created a excomm report", 1)

	else
		to_chat(H, "<span class='churchexcomm'>[pick(fnord)] I can't. I must go to the church.</span>")

/mob/living/carbon/human/proc/epitemia()
	set hidden = 0
	set category = "cross"
	set desc="Epitemia"
	var/input = sanitize_name(input(usr, "Enter the name of the sinful member.", "What?", "") as text|null)
	var/list/epitemia_list = EPITEMIA_LIST
	var/mob/living/carbon/human/H = usr

	if(!input) return
	var/epitemia_c = input(usr, "Which epitemia I should choose?", "Which?", "") in epitemia_list
	if(stat || !epitemia_c) return

	H.qualarea()
	if(H.lastarea && istype(lastarea, /area/dunwell/station/church))
		world << sound('sound/AI/bell_toll_02_lp.ogg')
		to_chat(world, "<span class='churchannouncement'>Grey Post-Christian Church</span>")

		to_chat(world, "<span class='churchexcomm'>For the committed sins, [src.real_name] imposes an epitemia on [input]: [epitemia_c]!</span>")
		world << sound('sound/AI/bell_toll.ogg')
		to_chat(world, "<br>")
		to_chat(world, "<span class='churchdecree'>Anathema!</span>")
		to_chat(world, "<br>")
		for(var/mob/living/carbon/human/HH in mob_list)
			if(HH.real_name == input && HH.religion == "Gray Church")
				HH.add_epitemia(epitemia_list[epitemia_c])

/mob/living/carbon/human/proc/free_sins()
	clear_event("epitemia")
	to_chat(src, "<span class='passive'>Finally, I'm free from my sins!</span>")
	gainWP(TRUE, 3)
	return

/mob/living/carbon/human/proc/banish()
	set hidden = 0
	set category = "cross"
	set desc="Banish Undead"
	set name = "BanishtheUndead"

	if(stamina_loss >= 100)
		return

	if(stat) return

	playsound(src.loc, 'sound/lfwbsounds/bishop_banish.ogg', 100, 1)

	for(var/mob/living/carbon/human/H in view(world.view, src))
		if(iszombie(H) || isVampire(H))
			var/turf/target = get_turf(H.loc)
			var/range = rand(4,5)
			var/throw_dir = get_dir(usr, H)
			for(var/i = 1; i < range; i++)
				var/turf/new_turf = get_step(target, throw_dir)
				target = new_turf
				if(new_turf.density)
					break
			H.throw_at(target, rand(4,5), src.throw_speed)
			H.Weaken(2)
			src.adjustStaminaLoss(10)

/mob/living/carbon/human/proc/sins()
	set hidden = 0
	set name = "RobofSins"
	set desc="Rob of Sins"
	set category = "cross"

	if(stat) return

	if(istype(src.get_active_hand(), /obj/item/grab/wrench) && src.zone_sel.selecting == BP_HEAD)
		var/obj/item/grab/wrench/W = get_active_hand()
		var/mob/living/carbon/human/H = W.affecting
		H.viceneed = 0
		H.clear_event("vice")
		to_chat(src, "You have absorbed their sins.")
		to_chat(H, "You have been delivered from your sins.")
		src.sins_absorbed += 1
		if(src.sins_absorbed >= 5)
			src.add_event("filthysoul", /datum/happiness_event/vice/dirty_soul)

/mob/living/carbon/human/proc/bloodyhands()
	set hidden = 0
	set name = "BloodyHands"
	set desc="Bloody Hands"
	set category = "cross"

	if(stat) return
	var/mob/living/carbon/human/H = usr
	H.qualarea()
	if(H.lastarea && istype(lastarea, /area/dunwell/station/church))
		if(!src.bloody_hands)
			src.bloody_hands = 1
			bloody_hands(src)
			src.visible_message("<span class='passivebold'>[src]</span> <span class='passive'>cries for the Comatic as blood runs from their hands!")
			playsound(src.loc, 'sound/lfwbsounds/bishop_hands.ogg', 100, 1)
			return
		if(src.bloody_hands)
			src.bloody_hands = 0
			usr.clean_blood()
			src:update_inv_gloves()
			src.visible_message("<span class='passivebold'>[src]</span> <span class='passive'>raises his hands to the Comatic as the blood recedes!")
			playsound(src.loc, 'sound/lfwbsounds/bishop_hands.ogg', 100, 1)
			return
	else
		to_chat(H, "<span class='churchexcomm'>[pick(fnord)] I can't. I must go to the church.</span>")

var/rewarded = 0

/mob/living/carbon/human/proc/reward()
	set hidden = 0
	set category = "cross"
	set name = "RewardtheInquisitor"
	set desc="Reward the Sniffer"

	if(stat) return
	if(rewarded) return

	var/input = sanitize(input(usr, "Why you should reward?", "Reward", "") as message|null)
	if(!input)
		return

	to_chat(world, "<span class='churchannouncement'>Grey Post-Christian Church</span>")
	if(src.job == "Vicar")
		to_chat(world, "<span class='churchexcomm'>By the Vicar's will, the Sniffer was rewarded! His heroic conquests: [input]</span>")
	else
		to_chat(world, "<span class='churchexcomm'>By the Priest's will, the Sniffer was rewarded! His heroic conquests: [input]</span>")
	world << sound('sound/AI/bell_toll.ogg')
	to_chat(world, "<span class='decree'>Santa Felicidade!</span>")
	to_chat(world, "<br>")

	for(var/mob/living/carbon/human/H in player_list)
		if(H.job == "Sniffer" && H.mind)
			rewarded = 1
			Inquisitor_Points += 9
			H.remove_verb(/mob/living/carbon/human/proc/reward)

/mob/living/carbon/human/proc/coronation()
	set hidden = 0
	set category = "cross"
	set name = "Coronation"
	set desc="Coronation"

	if(stat) return
	src.qualarea()
	for(var/mob/living/carbon/human/H in view(1, src))
		if(H.head && istype(H.head, /obj/item/clothing/head/caphat) && src.bloody_hands)
			if(H.lastarea && istype(lastarea, /area/dunwell/station/church) || H.lastarea && istype(lastarea, /area/dunwell/station/bridge))
				if(src.lastarea && istype(lastarea, /area/dunwell/station/church) || src.lastarea && istype(lastarea, /area/dunwell/station/bridge))
					src.visible_message("<font color ='#649568'><b>[src]</b> draws a bloody cross in [H.real_name]'s forehead")
					if(do_after(src, 15))
						world << sound('sound/AI/bell_toll_02_lp.ogg')

						to_chat(world, "<h1 class='churchannouncement'>Grey Post-Christian Church</span>")
						to_chat(world, "<span class='churchexcomm'>By the will of the blood and cross [H.real_name] is coronated the new Baron!</span>")
						world << sound('sound/AI/bell_toll.ogg')
						to_chat(world, "<br>")
						to_chat(world, "<span class='churchdecree'>God be Saved!</span>")
						to_chat(world, "<br>")
						H.job = "Baron"
						H.add_event("coronation", /datum/happiness_event/misc/coronated)


/mob/living/carbon/human/proc/eucharisty()
	set hidden = 0
	set hidden = 0
	set category = "cross"
	set name = "Eucharisty"
	set desc="Eucharisty"

	if(src.get_active_hand() == /obj/item/organ)
		var/obj/item/organ/O = src.get_active_hand()
		if(O.blood_DNA == src.dna.unique_enzymes)
			var/list/frasestosay = list("Finally, be strong in the Lord and in his mighty power. Put on the whole armor of God, so that you can stand firm against the wiles of the Devil, for our fight is not against human beings, but against the powers and authorities, against the rulers of this dark world, against the spiritual forces of evil in the heavenly places. Therefore, put on the whole armor of God, so that you may be able to withstand on the evil day and stand firm, after you have done everything.",\
"Blessed be the Lord, my Rock, who trains my hands for war and my fingers for battle. He is my faithful ally, my fortress, my tower of protection and my deliverer; he is my shield, he in whom I take refuge. He subdues the peoples under me.",
"For although we live like men, we do not fight according to human standards. The weapons with which we fight are not human weapons, but are mighty in God to pull down strongholds. We tear down arguments and every pretense that sets itself up against the knowledge of God and We take every thought captive to make it obedient to Christ.",
"Fight the good fight of faith. Take hold of the eternal life to which you were called and which you made the good confession in the presence of many witnesses.","Bear with me in my sufferings, as a good soldier of Christ Jesus. No soldier gets involved in the affairs of civilian life, since he wants to please the one who enlisted him.",
"I have fought the good fight, I have finished the race, I have kept the faith. Now there is reserved for me the crown of righteousness, which the Lord, the righteous Judge, will give me on that day; and not to me only, but also to all who love his coming.",
"The Lord is my strength and my song; he is my salvation! He is my God, and I will praise him; he is the God of my father, and I will exalt him! The Lord is a warrior, his name is God."
			)
			src.say(pick(frasestosay))
			if(do_after(src, 30))
				O.force += 50
				playsound(src.loc, 'sound/lfwbsounds/bishop_banish.ogg', 100, 1)


/mob/living/carbon/human/proc/undeadead()
	set hidden = 0
	set category = "cross"
	set name = "BannishSpirits"
	set desc="Banish Spirits"

	if(stamina_loss >= 100)
		return

	if(stat) return

	playsound(src.loc, 'sound/lfwbsounds/bishop_banish.ogg', 100, 1)

	for(var/mob/dead/observer/H in view(world.view, src))
		var/turf/target = get_turf(H.loc)
		var/range = H.throw_range
		var/throw_dir = get_dir(usr, H)
		for(var/i = 1; i < range; i++)
			var/turf/new_turf = get_step(target, throw_dir)
			target = new_turf
			if(new_turf.density)
				break
		H.throw_at(target, rand(2,4), src.throw_speed)


/mob/living/carbon/human/proc/callmeeting()
	set hidden = 0
	set category = "cross"
	set name = "CallforChurchMeeting"
	set desc="Call for Church Meeting"
	var/mob/living/carbon/human/H = usr

	if(stat) return
	if(!churchexpanded) return
	H.qualarea()
	if(H.lastarea && istype(lastarea, /area/dunwell/station/church))
		if(src.ischurchmeeting == 1)
			to_chat(world, "<span class='churchannouncement'>Grey Post-Christian Church</span>")
			to_chat(world, "<span class='churchexcomm'>[src] finishes the meeting!</span>")
			world << sound('sound/AI/bell_toll.ogg')
			to_chat(world, "<br>")
			to_chat(world, "<span class='decree'>Santa reunião!</span>")
			to_chat(world, "<br>")
			src.ischurchmeeting = 0
		else
			to_chat(world, "<span class='churchannouncement'>Grey Post-Christian Church</span>")
			to_chat(world, "<span class='churchexcomm'>Vicar [src] calls for a church meeting!</span>")
			world << sound('sound/AI/bell_toll.ogg')
			to_chat(world, "<br>")
			to_chat(world, "<span class='churchdecree'>Santa reunião!</span>")
			to_chat(world, "<br>")
			src.ischurchmeeting = 1

			for(var/mob/living/carbon/human/HH in player_list)
				if(HH.outsider)
					continue
				if(HH.lastarea && !istype(HH.lastarea, /area/dunwell/station/church) && HH.religion == "Gray Church")
					HH.rotate_plane() // ficarem loucos loucos da cabeça...
					HH.emote("scream")
					for(var/x = 0, x<=3, x++)
						sleep(7)
						to_chat(HH, "I MUST GO TO THE CHURCH!!")

		world << sound('sound/AI/bell_toll_02_lp.ogg')
		log_admin("[key_name(src)] has called for a meeting at the church")
		message_admins("[key_name_admin(src)] has called for a meeting at the church", 1)
	else
		to_chat(H, "<span class='excomm'>[pick(fnord)] I can't. I must go to the church.</span>")

/mob/living/carbon/human/proc/marriage()
	set hidden = 0
	set category = "cross"
	set name = "Marriage"
	set desc="Marriage!"
	var/list/spouses = list()


	if(stat) return

	src.qualarea()
	if(src.lastarea && istype(lastarea, /area/dunwell/station/church))
		for(var/mob/living/carbon/human/H in oview(1,src))
			if(H.stat) continue
			if(H?.client?.married == null)
				spouses += H
		var/mob/living/carbon/human/married1 = input(usr, "Enter the name of first spouse", "Matrimony", "") as null|anything in spouses
		spouses -= married1
		var/mob/living/carbon/human/married2 = input(usr, "Enter the name of second spouse", "Matrimony", "") as null|anything in spouses
		if(!married1 || !married2)
			return
		married1.client.married = married2.client.ckey
		married2.client.married = married1.client.ckey
		var/mob/living/carbon/human/husband
		var/mob/living/carbon/human/wife
		if(married1.has_penis())
			husband = married1
			wife = married2
		else
			husband = married2
			wife = married1
		var/datum/family/F = new /datum/family(husband)
		LAZYDISTINCTADD(matchmaker.families, F)
		F.add_member(wife)
		married1.client.ChromieWinorLoose(1)
		married2.client.ChromieWinorLoose(1)
		to_chat(world, "<span class='churchannouncement'>Grey Post-Christian Church</span>")
		to_chat(world, "<span class='churchexcomm'>By the bonds of the Cross, [married1.real_name] and [married2.real_name] are united unto Death! Rejoice!</span>")
		world << sound('sound/AI/bell_toll.ogg')
		to_chat(world, "<br>")
		to_chat(world, "<span class='churchdecree'>Holy Wedding!</span>")
		to_chat(world, "<br>")

		world << sound('sound/AI/bell_toll_02_lp.ogg')
		log_admin("[key_name(src)] has declared a marriage between [married1] and [married2]")
		message_admins("[key_name_admin(src)] has declared a marriage between [married1] and [married2]", 1)
/*		if(S1 && S2)
			var/datum/game_mode/siege/S = ticker.mode
			var/list/marriage_M = list(S1, S2)
			if(S.hascountheir in marriage_M)
				marriage_M.Remove(S.hascountheir)
				var/mob/living/carbon/human/S3 = marriage_M[1]
				if((S.hascountheir.gender == MALE && S3.job == "Successor") || (S.hascountheir.gender == FEMALE && S3.job == "Heir"))
					if(!roundendready)
						S.result = SIEGE_DRAW_MARRIAGE
						roundendready = TRUE */
	else
		to_chat(src, "<span class='excomm'>[pick(fnord)] I can't. I must go to the church.</span>")

/mob/living/carbon/human/proc/ClearName()
	set hidden = 0
	set category = "cross"
	set name = "ClearName"
	set desc="Clear NickName"

	if(stat) return
	var/list/list_M = list()

	for(var/mob/M in view(7))
		list_M.Add(M)

	list_M.Add("(CANCEL)")
	var/who_name = input(usr, "Who?", "Who?") in list_M

	if(istype(who_name, /mob))
		var/mob/M = who_name
		if(M.nickname)
			visible_message("[src.name] cleared [M.real_name]'s name!")
			M.nickname = FALSE
			return
		else
			to_chat(src, "<span class='combat'>They don't have a nickname!</span>")
			return

/datum/job/inquisitor
	title = "Praetor"
	titlebr = "Praetor"
	flag = INQUISITOR
	department_flag = ENGSEC
	faction = "Station"
	stat_mods = list(STAT_ST = 2, STAT_DX = 3, STAT_HT = 6, STAT_IN = 2)
	total_positions = 1
	spawn_positions = 1
	supervisors = "the bishop"
	selection_color = "#dddddd"
	idtype = /obj/item/card/id/churchkeeper
	access = list(church, access_morgue, access_chapel_office, access_maint_tunnels)
	minimal_access = list(church, access_morgue, access_chapel_office)
	jobdesc = "A fanatical zealot of the Grey Church, he holds no true nor official position as part of the clergy or even the INKVD, but he cares little for such facts. The Praetor is the iron first of The Church and the enforcer of the local Vicar. While they are useful muscle, one should take care when dealing with them, for this zealot may yet turn on those that use him, if they consider certain behavior or acts unacceptable, or worse, sacrilege."
	sex_lock = MALE
	latejoin_locked = FALSE
	skill_mods = list(
	list(SKILL_MELEE,6,6),
	list(SKILL_UNARM,0,2),
	list(SKILL_RANGE,5,5),
	list(SKILL_FARM,0),
	list(SKILL_COOK,0),
	list(SKILL_ENGINE,0),
	list(SKILL_SURG,2,2),
	list(SKILL_MEDIC,2,2),
	list(SKILL_CLEAN,0),
	list(SKILL_CLIMB,5,5),
	list(SKILL_SWIM,4,4),
	list(SKILL_OBSERV, 2,2),
	list(SKILL_BOAT, 1,2),
	)
	equip(var/mob/living/carbon/human/H)
		if(!H)
			return 0
		..()
		if(Gatekeeper_Type == "Penitence")
			H.voicetype = "strong"
			H.equip_to_slot_or_del(new /obj/item/clothing/suit/armor/vest/security/incarn(H), slot_wear_suit)
			H.equip_to_slot_or_del(new /obj/item/clothing/under/rank/security(H), slot_w_uniform)
			H.equip_to_slot_or_del(new /obj/item/clothing/head/helmet/sechelm/incarn(H), slot_head)
			H.equip_to_slot_or_del(new /obj/item/clothing/shoes/lw/jackboots(H), slot_shoes)
			H.equip_to_slot_or_del(new /obj/item/device/radio/headset/bracelet/eng(H), slot_wrist_r)
			H.equip_to_slot_or_del(new /obj/item/crossbow(H), slot_l_hand)
			H.equip_to_slot_or_del(new /obj/item/storage/backpack/minisatchelchurch, slot_back)
			H.equip_to_slot_or_del(new /obj/item/spike(H.back), slot_in_backpack)
			H.equip_to_slot_or_del(new /obj/item/spike(H.back), slot_in_backpack)
			H.equip_to_slot_or_del(new /obj/item/spike(H.back), slot_in_backpack)
			H.equip_to_slot_or_del(new /obj/item/spike(H.back), slot_in_backpack)
			H.equip_to_slot_or_del(new /obj/item/spike(H.back), slot_in_backpack)
			H.equip_to_slot_or_del(new /obj/item/spike(H.back), slot_in_backpack)
			H.equip_to_slot_or_del(new /obj/item/spike(H.back), slot_in_backpack)
			H.equip_to_slot_or_del(new /obj/item/spike(H.back), slot_in_backpack)
			H.my_skills.change_skill(SKILL_MELEE, 2)
			H.my_skills.change_skill(SKILL_RANGE, 8)
			H.my_stats.change_stat(STAT_ST , 1)
			H.my_stats.change_stat(STAT_HT , 1)
			H.terriblethings = TRUE
			H.add_perk(/datum/perk/morestamina)
			H.add_perk(/datum/perk/ref/strongback)
			H.add_perk(/datum/perk/heroiceffort)
			H.religion = "Gray Church"
			H.virgin = TRUE
			H.create_kg()
			return 1
		else if(Gatekeeper_Type == "Castigation")
			H.voicetype = "strong"
			H.equip_to_slot_or_del(new /obj/item/clothing/suit/armor/vest/security/chariot(H), slot_wear_suit)
			H.equip_to_slot_or_del(new /obj/item/clothing/under/rank/security(H), slot_w_uniform)
			H.equip_to_slot_or_del(new /obj/item/clothing/head/donor/redvent/tatteredhood(H), slot_head)
			H.equip_to_slot_or_del(new /obj/item/clothing/shoes/lw/jackboots(H), slot_shoes)
			H.equip_to_slot_or_del(new /obj/item/device/radio/headset/bracelet/eng(H), slot_wrist_r)
			H.equip_to_slot_or_del(new /obj/item/clothing/head/amulet/holy/cross/old(H), slot_amulet)
			H.equip_to_slot_or_del(new /obj/item/melee/classic_baton/slab(H), slot_l_hand)
			H.my_skills.change_skill(SKILL_MELEE, 6)
			H.my_skills.change_skill(SKILL_UNARM, 6)
			H.my_skills.change_skill(SKILL_RANGE, 2)
			H.my_skills.change_skill(SKILL_CRAFT, 5)
			H.my_skills.change_skill(SKILL_SWIM, 5)
			H.my_skills.change_skill(SKILL_SWING,rand(1,3))
			H.my_stats.change_stat(STAT_ST , 4)
			H.my_stats.change_stat(STAT_HT , 2)
			H.my_stats.change_stat(STAT_DX , -2)
			H.terriblethings = TRUE
			H.add_perk(/datum/perk/morestamina)
			H.add_perk(/datum/perk/ref/strongback)
			H.add_perk(/datum/perk/heroiceffort)
			H.religion = "Gray Church"
			H.virgin = TRUE
			H.create_kg()
			return 1


/mob/living/carbon/human/proc/interrogate()
	set category = "gpc"
	set name = "Interrogate"
	set desc = "Interrogate"
	if(stat) return
	var/turf/T = get_step(src, dir)
	if(src?.mind?.cooldown_interrogate > world.time)
		to_chat(src, "<span class='jogtowalk'>Let's give them some time to think...</span>")
		return
	src?.mind?.cooldown_interrogate = world.time + 100
	for(var/mob/living/carbon/human/H in T.contents)
		if(!H.buckled)
			continue
		if(H.stat)
			continue
		if(H == src)
			continue
		if(istype(H, /mob/living/carbon/human/monster))
			continue
		if(H.bot)
			continue

		var/mod_interro
		mod_interro += src.my_stats.get_stat(STAT_WP)
		var/mod_H
		mod_H -= (H.get_pain() / 10)
		mod_H += H.my_stats.get_stat(STAT_WP)
		var/list/roll_interro = roll3d6(src, (src.my_stats.get_stat(STAT_IN) - 5), mod_interro, TRUE,TRUE)
		var/list/roll_H = roll3d6(H, src.my_stats.get_stat(STAT_WP), mod_H, TRUE,TRUE)

		if(roll_interro[GP_RESULT] > roll_H[GP_RESULT])
			H.emote("torturescream",1, null, 0)
			H.reveal_self()
			if(prob(50) && !H.religion_is_legal())
				return
			H.reveal_others()
		else if((roll_H[GP_RESULT] + 5) > roll_interro[GP_RESULT])
			H.emote("torturescream",1, null, 0)
			H.reveal_lie()
		else
			to_chat(src, "<span class='jogtowalk'>[pick("They're still resistant","They're ignoring my questions")]...</span>")
			return
		return

/mob/living/carbon/human/proc/religion_is_legal()
	if(religion == "Gray Church")
		return TRUE
	else
		return FALSE

/mob/living/carbon/human/proc/reveal_self()
	src.rotate_plane()
	sleep(20)
	if (religion_is_legal())  //Non-heretics will still deny
		var/list/msg
		msg = list("I WANT MY MOTHER!", "I DON'T KNOW ANYTHING!!", "LET ME OUT!", "PLEASE LET ME GO!", "I SWEAR I DON'T KNOW!", "I'VE DONE NOTHING WRONG!")

		say(pick(msg))
		emote("cry",1, null, 0)
	else
		emote("praise",1, null, 0)
		sleep(20)
		emote("praise",1, null, 0)
		sleep(20)
		emote("praise",1, null, 0)

/mob/living/carbon/human/proc/reveal_lie()
	src.rotate_plane()
	sleep(20)
	if(prob(50))
		var/list/msg
		msg = list("I WANT MY MOTHER!", "I DON'T KNOW ANYTHING!!", "LET ME OUT!", "PLEASE LET ME GO!", "I SWEAR I DON'T KNOW!", "I'VE DONE NOTHING WRONG!")

		say(pick(msg))
		emote("cry",1, null, 0)
	else
		var/list/whom
		for(var/mob/living/carbon/human/H in mob_list)
			if(H.religion_is_legal())
				whom.Add(H.real_name)
		if(whom.len)
			say("[pick("I THINK IT'S", "IT'S", "I PROMISE IT'S")] [uppertext(pick(whom))]!")
		else
			say("I DON'T KNOW WHO IT IS!")
		emote("cry",1, null, 0)


/mob/living/carbon/human/proc/reveal_others()
	src.rotate_plane()
	sleep(20)
	if (religion_is_legal())  //Non-heretics will still deny
		var/list/whom
		for(var/mob/living/carbon/human/H in mob_list)
			if(H.religion_is_legal())
				whom.Add(H.real_name)
		if(whom.len)
			say("[pick("I THINK IT'S", "IT'S", "I PROMISE IT'S")] [uppertext(pick(whom))]!")
		else
			say("I DON'T KNOW WHO IT IS!")
	else
		var/list/whom
		for(var/mob/living/carbon/human/H in mob_list)
			if(H.religion_is_legal())
				if(prob(15))
					whom.Add(H.real_name)
			else
				if(prob(50))
					whom.Add(H.real_name)
		if(whom.len)
			say("[pick("I THINK IT'S", "IT'S", "I PROMISE IT'S")] [uppertext(pick(whom))]!")
		else
			say("I DON'T KNOW WHO IT IS!")
		emote("cry",1, null, 0)

/datum/job/practicus
	title = "Sniffer"
	titlebr = "Prático"
	flag = PRACTICUS
	department_flag = ENGSEC
	faction = "Station"
	stat_mods = list(STAT_ST = 0, STAT_DX = 6, STAT_HT = 2, STAT_IN = 4)
	total_positions = 1
	spawn_positions = 1
	jobdesc = "The Informant of the God-King, who has resided in Enoch´s Gate for years, living amongst its inhabitants as one of them for long. His reports, none of which mention the thanati or anything of real note, to the INKVD have been either ignored and left unanswered, or replied to with heavily delayed non-answers, a situation that has forced him to rely on the local Vicar and his Praetor to ensure that the God-King´s will is done. A master of disguise and the subtle blade of the church, their true identity is unknown to most living fortress member. Often going by aliases, their real name was scrubbed long ago, and they often use the birthnames of both forged and cleaned aliases within the Tribunal Archives."
	supervisors = "the bishop and the inquisitor"
	selection_color = "#dddddd"
	idtype = /obj/item/card/id/churchkeeper
	access = list(church, access_morgue, access_chapel_office, access_maint_tunnels)
	minimal_access = list(church, access_morgue, access_chapel_office)
	sex_lock = MALE
	latejoin_locked = FALSE
	skill_mods = list(
	list(SKILL_MELEE,5,5),
	list(SKILL_RANGE,8,8),
	list(SKILL_SWING,1,2),
	list(SKILL_FARM,0),
	list(SKILL_COOK,0),
	list(SKILL_ENGINE,0),
	list(SKILL_SURG,0),
	list(SKILL_MEDIC,2,2),
	list(SKILL_CLEAN,0),
	list(SKILL_CLIMB,6,6),
	list(SKILL_STEAL,6,6),
	list(SKILL_SWIM,3,3),
	list(SKILL_OBSERV, 6,6),
	list(SKILL_SNEAK, 6,6),
	list(SKILL_BOAT, 0),
	)
	equip(var/mob/living/carbon/human/H)
		if(!H)
			return 0
		..()
		H.religion = "Gray Church"
		H.equip_to_slot_or_del(new /obj/item/clothing/under/rank/chaplain(H), slot_w_uniform)
		H.equip_to_slot_or_del(new /obj/item/clothing/suit/chaplain_hoodie(H), slot_wear_suit)
		H.equip_to_slot_or_del(new /obj/item/clothing/head/hood(H), slot_head)
		H.equip_to_slot_or_del(new /obj/item/device/radio/headset/bracelet/eng(H), slot_wrist_r)
		H.equip_to_slot_or_del(new /obj/item/clothing/shoes/lw/boots(H), slot_shoes)
		H.equip_to_slot_or_del(new /obj/item/reagent_containers/syringe/blood_snatcher, slot_l_store)
		H.equip_to_slot_or_del(new /obj/item/reagent_containers/glass/beaker/chalice, slot_r_store)
		H.equip_to_slot_or_del(new /obj/item/kitchen/utensil/knife/dagger/silver, slot_belt)
		H.add_perk(/datum/perk/ref/silent)
		H.create_kg()
		H.add_verb(list(/mob/living/carbon/human/proc/interrogate, \
		/mob/living/carbon/human/proc/ChangeJob, \
		/mob/living/carbon/human/proc/ChangeName))
		//H << sound('sound/music/train_music.ogg', repeat = 0, wait = 0, volume = 20, channel = 3)
		return 1

/mob/living/carbon/human/proc/ChangeJob()
	set hidden = 0
	set category = "cross"
	set name = "ChangeJob"
	set desc="Change Job"

	var/newjob = input(src, "Choose your new job:", "What?") in list("Triton", "Serpent", "Mortus", "Migrant", "Wright", "Sniffer", "Lord", "Blacksmith Assistant", "Esculap", "Nun", "Madam", "Sheriff", "Ganger", "Docker", "Merchant", "Misero", "Chemsister", "Church Interrogator", "Maid", "Tribunal Ordinator")
	src.assignment = newjob
	if(src.wear_id)
		var/obj/item/card/id/I = src.wear_id
		I.assignment = newjob

/mob/living/carbon/human/proc/ChangeName()
	set hidden = 0
	set category = "cross"
	set name = "ChangeName"
	set desc="Change Name"

	var/input = sanitize_name(input(usr, "Enter your new identity", "What?", "") as text|null)
	src.real_name = input
	if(wear_id)
		var/obj/item/card/id/R = wear_id
		R.registered_name = input
		R.name = "[input]'s Ring"


/datum/job/nun
	title = "Nun"
	titlebr = "Freira"
	flag = NUN
	department_flag = ENGSEC
	faction = "Station"
	stat_mods = list(STAT_ST = -1, STAT_DX = 1, STAT_HT = -1, STAT_IN = 1)
	total_positions = 2
	spawn_positions = 2
	jobdesc = "As a sister of the church, you are a symbol of purity. You help the sick and downtrodden, and are trusted by all residents within the fortress. You use this trust to extract information from those you care for, and report sinners and evildoers to the Holy Father. Trust and care are your information."
	jobdescbr = "Cuide dos feridos, alimente os famintos e não se esqueça de punir os maus costumes."
	supervisors = "the bishop and the inquisitor"
	selection_color = "#dddddd"
	idtype = /obj/item/card/id/churchkeeper
	access = list(church, access_morgue, access_chapel_office, access_maint_tunnels)
	minimal_access = list(church, access_morgue, access_chapel_office)
	sex_lock = FEMALE
	latejoin_locked = FALSE
	skill_mods = list(
	list(SKILL_MELEE,0),
	list(SKILL_RANGE,0),
	list(SKILL_FARM,3,3),
	list(SKILL_COOK,4,5),
	list(SKILL_ENGINE,0),
	list(SKILL_SURG,4,4),
	list(SKILL_MEDIC,4,4),
	list(SKILL_CLEAN,5,5),
	list(SKILL_CLIMB,0),
	list(SKILL_SWIM,0),
	list(SKILL_OBSERV, 2,2),
	)
	equip(var/mob/living/carbon/human/H)
		if(!H)
			return 0
		..()
		H.religion = "Gray Church"
		H.equip_to_slot_or_del(new /obj/item/clothing/under/rank/chaplain(H), slot_w_uniform)
		H.equip_to_slot_or_del(new /obj/item/clothing/suit/nundress(H), slot_wear_suit)
		H.equip_to_slot_or_del(new /obj/item/clothing/head/nun_hood(H), slot_head)
		H.equip_to_slot_or_del(new /obj/item/device/radio/headset/bracelet/cheap(H), slot_wrist_r)
		H.equip_to_slot_or_del(new /obj/item/clothing/shoes/lw/boots(H), slot_shoes)
		H.create_kg()
		//H << sound('sound/music/train_music.ogg', repeat = 0, wait = 0, volume = 20, channel = 3)
		return 1

