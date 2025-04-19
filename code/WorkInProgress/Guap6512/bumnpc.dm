#define cycle_pause 15 //min 1
#define viewrange 4 //min 2
#define EXTRACT_FIRST_CARDINAL_DIR(X) ((X) && 1 << (log(2, ((X) ^ ((X) - 1)) + 1) - 1))

#define BUM_SLEEP 0
#define BUM_ATTACK 1
#define BUM_IDLE 2

/mob/living/carbon/human
	var/provoked = FALSE
//All of this code is copied and pasted from the zombie code that guap made. It's probably laggy. Look into optimzing it.

/mob/living/carbon/human/bumbot/Move()
	..()
	if(stat != 0)
		return
	if(prob(6) && !target)
		say(pick(bumquotes))
	else if(prob(6) && target)//WITCHETTY WITCHETTY MAN!
		say(pick(angrybumquotes))
	if(prob(0.5))
		emote(pick("cry","scream","laugh"))
	if(prob(40))
		npc_pick_up()

var/list/bumquotes = list("I'M REAL! I'M FUCKING REAL!", "Cold... So cold...","Head juices... head juices...","Did you know?","Dog legs! Dog legs!","People are so stupid compared to me.","Witchetty, witchetty man...","Are we there yet?","Not enough love.","This fortress is my substitute for love.","Everything is fake.","I can't keep it in my mind. Can you help me?","Well, as usual","Vampires drink blood.","But if these ravens disappear one of these nights, the sun will still shine forever.","We need to endure it a little.","Today is just like yesterday.","It would be fun, but no.","Will I die in a great way?","I make mistake here.","You've changed!","Long ago, I was a lord.","Meat eaters, bone gnawlers, skin lickers...","Foe","HOW DOES IT FEEL?!","I was told I do.", "Mouth dry...", "I'm not a bum, I'm sapient!", "Who am I? I'm a hard worker. I set high goals and I've been told that I'm persistent.", "I surrender!")
var/list/angrybumquotes = list("YOU'RE FUCKING DEAD KIDDO!", "COME HERE YOU SHOE THIEVING BASTARD!", "WHY MY SHOES HUH? WHY MINE!", "I'M GONNA KILL YOU!", "NOW YOU FUCKED UP!", "YOU WILL DIE HERE!", "GIVE ME BACK MY SHOES!", "COME TO PAPA!", "I'M GONNA SQUEEZE ALL YOUR HEAD JUICE OUT!","WITCHETTY! WITCHETTY! WITCHETTY MAN!", "WHERE ARE MY DAMN SHOES!", "I'M GONNA SLURP YOUR FUCKING HEAD JUICE!", "BAD DOG! BAD DOG!", "HEAD JUICE! HEAD JUICE!")

/mob/living/carbon/human/bumbot/examine(mob/user)
	..()
	if(ishuman(user))
		if(stat)//They're not awake or alive, don't play the stinger.
			return
		var/mob/living/carbon/human/H = user
		if(H.job != "Bum") //Bums are immune to their ire.
			if(!H.StingerSeen.Find(src))
				H.StingerSeen.Add(src)
				H << sound(pick('sound/tension/tension.ogg','sound/tension/tension2.ogg','sound/tension/tension3.ogg','sound/tension/tension4.ogg','sound/tension/tension5.ogg','sound/tension/tension6.ogg','sound/tension/tension7.ogg'), repeat = 0, wait = 0, volume = H?.client?.prefs?.ambi_volume, channel = 23)
			combat_mode = 1
			face_atom(user)
			if(!target)	
				target = H
				say(pick(angrybumquotes))
				provoked = TRUE
			return 1

/mob/living/carbon/human/bumbot
	name = "Michael Shepard"
	real_name = "Michael Shepard"
	voice_name = "Michael Shepard"
	a_intent = "hurt"
	density = 1
	is_npc = TRUE
	var/list/path = new/list()
	var/frustration = 0
	var/atom/object_target
	var/reach_unable
	var/mob/living/carbon/target
	var/list/path_target = new/list()
	bot = 1
	health = 100

/mob/living/carbon/human/bumbot/New()
	..()
	sleep(10)
	if(!mind)
		mind = new /datum/mind(src)
	src.zone_sel = new /obj/screen/zone_sel( null )
	zone_sel.selecting = pick("chest","head","l_arm","r_arm","throat","mouth","right eye","left eye","vitals","r_hand","l_hand","groin","l_leg","r_leg","r_foot","l_foot")
	gender = pick(MALE,FEMALE)
	switch(gender)//You make things harder than it needs to be. Instead of using a regex to cut off their last name... why not just use the convient first name's list that the get random name proc already goes through.
		if(MALE)
			real_name = pick(first_names_male)
		else
			real_name = pick(first_names_female)
	name = real_name
	job = "Bum"
	voice_name = real_name
	hand = 0
	if(prob(2))
		real_name =  "[real_name] The Strong"
		name = real_name
		my_skills.change_skill(SKILL_MELEE, rand(1,7))
		my_stats.change_stat(STAT_ST, 5)
		my_stats.change_stat(STAT_HT, 5)
		my_stats.change_stat(STAT_DX, 5)
		if(gender == MALE)
			mutations += FAT
	voicetype = "hobo"
	for(var/obj/item/reagent_containers/food/snacks/organ/O in src.organ_storage)
		O.bumorgans()
	hygiene = -400
	if(gender == MALE)
		f_style = random_facial_hair_style(gender = src.gender, species = "Human")
	h_style = random_hair_style(gender = src.gender, species = "Human")
	regenerate_icons()
	var/bumweapon = pick("knife","club")
	if(prob(1))
		bumweapon = "revolver"
	switch(bumweapon)
		if("knife")
			if(prob(50))
				equip_to_slot_or_del(new /obj/item/kitchen/utensil/knife/dagger/copper(src), slot_r_hand)
			else
				equip_to_slot_or_del(new /obj/item/kitchen/utensil/knife(src), slot_r_hand)
		if("club")
			equip_to_slot_or_del(new /obj/item/melee/classic_baton/woodenclub(src), slot_r_hand)
		if("revolver")
			equip_to_slot_or_del(new /obj/item/gun/projectile/newRevolver/duelista/neoclassic(src), slot_r_hand)
	equip_to_slot_or_del(new /obj/item/clothing/under/rank/migrant/bum(src), slot_w_uniform)
	if(prob(30))
		say(pick(bumquotes))

	if(prob(90))
		virgin = FALSE
		contract_disease(new /datum/disease/aids,1,0)
	var/datum/organ/external/mouth/O = locate(/datum/organ/external/mouth) in src.organs
	if(O)//Bums are missing most of their teeth.
		O.teeth_list.Cut()
		var/obj/item/stack/teeth/T = new species.teeth_type(O)
		T.amount = rand(5, 30)
		O.teeth_list += T
	// main loop
	spawn while(stat != 2 && bot)
		sleep(cycle_pause)
		src.process()

/mob/living/carbon/human/bumbot/attackby(obj/item/I, mob/user)
	. = ..()
	if(user && !provoked)
		provoked = TRUE //They are mad now.
		combat_mode = 1
		face_atom(user)		
		target = user
		say(pick(angrybumquotes))


// this is called when the target is within one tile
// of distance from the bumbot
/mob/living/carbon/human/bumbot/proc/attack_target(var/mob/living/carbon/human/target)
	if(!target)
		return
	if(target?.stat != CONSCIOUS && prob(70))
		return
	var/direct = get_dir(src, target)
	if ( (direct - 1) & direct)
		var/turf/Step_1
		var/turf/Step_2
		switch(direct)
			if(EAST|NORTH)
				Step_1 = get_step(src, NORTH)
				Step_2 = get_step(src, EAST)

			if(EAST|SOUTH)
				Step_1 = get_step(src, SOUTH)
				Step_2 = get_step(src, EAST)

			if(NORTH|WEST)
				Step_1 = get_step(src, NORTH)
				Step_2 = get_step(src, WEST)

			if(SOUTH|WEST)
				Step_1 = get_step(src, SOUTH)
				Step_2 = get_step(src, WEST)

		if(Step_1 && Step_2)
			var/check_1 = 1
			var/check_2 = 1

			check_1 = Adjacent(get_turf(src), Step_1, target) && Adjacent(Step_1, get_turf(target), target)

			check_2 = Adjacent(get_turf(src), Step_2, target) && Adjacent(Step_2, get_turf(target), target)

			if(check_1 || check_2)
				target.attack_hand(src)
				return
			else
				var/obj/structure/rack/lwtable/W = locate() in target.loc
				var/obj/structure/rack/lwtable/WW = locate() in src.loc
				if(W)
					W.climb_table(src)
					return 1
				else if(WW)
					WW.climb_table(src)
					return 1
	else if(Adjacent(src?.loc , target?.loc,target))
		if(prob(15))
			say(pick(angrybumquotes))//Shout something at the guy you're attacking.
		if(src.r_hand || src.l_hand)
			if(r_hand && istype(r_hand, /obj/item))
				target.attackby(r_hand, src)
			else
				if(l_hand && istype(l_hand, /obj/item))
					target.attackby(l_hand, src)
		else
			target.attack_hand(src)
		//target.attack_hand(src)
		// sometimes push the enemy
		if(prob(80))
			if(prob(10))
				step(src,direct)
			else if(prob(80))
				zone_sel.selecting = pick("groin","l_leg","r_leg","r_foot","l_foot")
				target.kick_act(src)
			else if(prob(80))
				zone_sel.selecting = pick("chest","vitals","r_hand","l_hand","groin")
				target.steal_act(src)
		return 1
	else
		var/obj/structure/window/W = locate() in target.loc
		var/obj/structure/window/WW = locate() in src.loc
		if(W)
			if(src.r_hand || src.l_hand)
				if(r_hand)
					W.attackby(r_hand, src)
				else
					if(l_hand)
						W.attackby(l_hand, src)
			else
				W.attack_hand(src)
			return 1
		else if(WW)
			if(r_hand)
				WW.attackby(r_hand, src)
			else if(l_hand)
				WW.attackby(l_hand, src)
			else
				WW.attack_hand(src)
			return 1

/mob/living/carbon/human/proc/npc_pick_up()
	var/has_right = TRUE
	var/has_left = TRUE

	var/datum/organ/external/temp = organs_by_name["r_hand"]
	if(src.handcuffed)
		return
	if(!temp || !temp.is_usable() || temp.is_broken())
		has_right = FALSE
		temp = organs_by_name["l_hand"]
		if(!temp || !temp.is_usable() || temp.is_broken())
			has_left = FALSE

	if(!src.r_hand && !src.l_hand)//Try to pick up a weapon off the ground if we don't already have one.
		for(var/obj/item/G in view(1,src))
			if(G.anchored || G.throwing) continue
			if(G.loc == src) continue //Our clothes or something.
			if(G.force >= 10)
				if(has_right)
					put_in_r_hand(G)
				else if(has_left)
					put_in_l_hand(G)
				else
					drop_from_inventory(l_hand)
					drop_from_inventory(r_hand)
				break

// main loop
/mob/living/carbon/human/bumbot/proc/process()
	set background = 1

	if (stat) //I don't want zombie bums running after me please.
		return 0
	if(weakened || paralysis || handcuffed || !canmove)
		return 1
	if(resting)
		mob_rest()
		return

	if(destroy_on_path())
		return 1

	combat_mode = 0

	if(prob(40))
		npc_pick_up()

	if(target)
		// change the target if there is another human that is closer
		if(prob(2))//This percentage used to be way higher, which meant that bums would just like... walk away from you if you weren't right next to them. It was really annoying.
			target = null
		for (var/mob/living/carbon/C in orange(2,src.loc))
			if (C.stat == DEAD || !can_see(src,C,viewrange))
				continue
			if (istype(C, /mob/living/carbon/human/bumbot))
				continue
			if(get_dist(src, target) >= get_dist(src, C) && prob(30))
				target = C
				break

		if(target?.stat == DEAD) //Our target died. Try this again.
			target = null
			return 1

		var/distance = get_dist(src, target)

		if(target in orange(viewrange,src))
			if(distance <= 1)
				if(attack_target())
					var/tdir = get_cardinal_dir(src, target)
					var/turf/T = get_step(src, tdir)
					for(var/atom/A in T.contents)
						if(A.density)
							return 1
					if(!T.density)
						src.set_dir(tdir)
						Move(T)
					return 1
			else 
				var/tdir = get_cardinal_dir(src, target)
				var/turf/T = get_step(src, tdir)
				for(var/atom/A in T.contents)
					if(A.density)
						return 1
				if(!T.density)
					src.set_dir(tdir)
					Move(T)
				return 1
		else
			target = null
			return 1
	
	if(prob(20))	
		var/turf/random_step = pick(cardinal)
		var/obj/machinery/door/airlock/A = locate() in random_step
		if(A && A.density) //NPC AIs do not play nice with locked doors, skip this turn and reroll if they're about to walk into one.
			if(A.locked)
				return 1
			else
				step(src, random_step)//move them
		else
			step(src, random_step)
	
	if(provoked)
		for(var/mob/living/carbon/human/H in orange(1, src.loc))
			if (!istype(H, /mob/living/carbon/human/bumbot) && !ismonster(H) && H.job != "Bum")//Don't attack rats or human bums please.
				combat_mode = 1
				if(prob(75))
					var/face = 0
					if(grabbed_by.len)
						for(var/x = 1; x <= grabbed_by.len; x++)
							if(grabbed_by[x])
								face = 1
								break

					if(face)
						resist()
					if(!face)
						dir = get_dir(src, H)
						attack_target(H)
					target = H
				return 1
	return

// destroy items on the path
/mob/living/carbon/human/bumbot/proc/destroy_on_path()
	// if we already have a target, use that
	if(object_target)
		if(!object_target.density)
			object_target = null
			frustration = 0
		else
			// we know the target has attack_hand
			// since we only use such objects as the target
			object_target:attack_hand(src)
			return 1
	if(frustration > 8 )
		if(istype(get_step(src,src.dir),/turf/simulated/wall))
			var/turf/simulated/wall/W = get_step(src,src.dir)
			if(W)
				if(W.density && !(locate(/turf/space) in range(1,W)))
					W.attack_hand(src)
					object_target = W
					return 1
	return 0

/mob/living/carbon/human/bumbot/death()
	..()
	target = null

/mob/living/carbon/human/bumbot/firstvictimCheck()
	return