//Food items that are eaten normally and don't leave anything behind.
/obj/item/reagent_containers/food/proc/foodloc(var/mob/M, var/obj/item/O)
	if(O.loc == M) return M.loc
	else return O.loc

/obj/item/reagent_containers/food/snacks
	name = "snack"
	desc = "yummy"
	icon = 'icons/obj/food.dmi'
	icon_state = null
	var/bitesize = 1
	var/bitecount = 0
	var/trash = null
	var/slice_path
	var/slices_num
	var/progress = 0 //terrible var name.

	//Placeholder for effect that trigger on eating that aren't tied to reagents.
/obj/item/reagent_containers/food/snacks/proc/On_Consume(var/mob/M)
	if(!usr)	return
	if(!reagents.total_volume)
		if(M == usr)
			to_chat(usr, "<span class='passive'>You finish eating \the [src].</span>")
		usr.visible_message("<span class='passivebold'>[usr]</span> <span class='passive'>finishes eating \the [src].</span>")
		usr.drop_from_inventory(src)	//so icons update :[

		if(trash)
			if(ispath(trash,/obj/item))
				var/obj/item/TrashItem = new trash(usr)
				usr.put_in_hands(TrashItem)
			else if(istype(trash,/obj/item))
				usr.put_in_hands(trash)
		qdel(src)
	return

/obj/item/reagent_containers/food/snacks/attack_self(mob/user as mob)
	return

/obj/item/reagent_containers/food/snacks/attack(mob/M as mob, mob/user as mob, def_zone)

	if(!reagents.total_volume)						//Shouldn't be needed but it checks to see if it has anything left in it.
		to_chat(user, "<span class='combatbold'> None of [src] left, oh no!</span>")
		M.drop_from_inventory(src)	//so icons update :[
		qdel(src)
		return 0

	if(!canconsume(M, user))
		return 0

	user.setClickCooldown(DEFAULT_ATTACK_COOLDOWN)

	if(M == user)								//If you're eating it yourself.
		if (M.zone_sel.selecting == "mouth")
			var/fullness = M.nutrition + (M.reagents.get_reagent_amount("nutriment") * 25)
			if (fullness <= 50)
				to_chat(M, "<span class='combat'>You hungrily chew out a piece of [src] and gobble it!</span>")
			if (fullness > 50 && fullness <= 150)
				to_chat(M, "<span class='combat'> You hungrily begin to eat [src].</span>")
			if (fullness > 150 && fullness <= 350)
				to_chat(M, "<span class='passive'>You take a bite of [src].</span>")
			if (fullness > 350 && fullness <= 550)
				to_chat(M, "<span class='combat'>You unwillingly chew a bit of [src].</span>")
			if (fullness > 550)	// The more you eat - the more you can eat
				to_chat(M, "<span class='combat'>You cannot force any more of [src] to go down your throat.</span>")
				return 0
		else
			to_chat(M, "<span class='combatbold'>I can't use that, I must eat it with my mouth.</span>")
			return 0
	else
		var/fullness = M.nutrition + (M.reagents.get_reagent_amount("nutriment") * 25)
		if (fullness <= 550)
			for(var/mob/O in viewers(world.view, user))
				O.show_message("<span class='combatbold'>[user]</span> <span class='combat'>attempts to feed</span> <span class='combatbold'>[M]</span> <span class='combat'>[src].</span>", 1)
		else
			for(var/mob/O in viewers(world.view, user))
				O.show_message("<span class='combat'>[user] cannot force anymore of [src] down</span> <span class='combatbold'>[M]'s</span> <span class='combat'>throat.</span>", 1)
				return 0

		if(!do_mob(user, M)) return

		M.attack_log += text("\[[time_stamp()]\] <font color='orange'>Has been fed [src.name] by [user.name] ([user.ckey]) Reagents: [reagentlist(src)]</font>")
		user.attack_log += text("\[[time_stamp()]\] <font color='red'>Fed [src.name] by [M.name] ([M.ckey]) Reagents: [reagentlist(src)]</font>")
		log_attack("[user.name] ([user.ckey]) fed [M.name] ([M.ckey]) with [src.name] Reagents: [reagentlist(src)] (INTENT: [uppertext(user.a_intent)])")

		for(var/mob/O in viewers(world.view, user))
			O.show_message("<span class='combatbold'>[user]</span> <span class='combat'>feeds</span> <span class='combatbold'>[M]</span> <span class='combat'>[src].</span>", 1)

	if(reagents)								//Handle ingestion of the reagent.
		playsound(M.loc,'sound/items/eatfood.ogg', rand(10,50), 1)

		if(reagents.total_volume)
			reagents.reaction(M, INGEST)
			spawn(5)
				if(reagents.total_volume > bitesize)
					/*
					 * I totally cannot understand what this code supposed to do.
					 * Right now every snack consumes in 2 bites, my popcorn does not work right, so I simplify it. -- rastaf0
					var/temp_bitesize =  max(reagents.total_volume /2, bitesize)
					reagents.trans_to(M, temp_bitesize)
					*/
					reagents.trans_to(M, bitesize)
				else
					reagents.trans_to(M, reagents.total_volume)
				bitecount++
				On_Consume(M)
		return 1

	return 0

/obj/item/reagent_containers/food/snacks/afterattack(obj/target, mob/user, proximity)
	return

/obj/item/reagent_containers/food/snacks/examine()
	set src in view()
	..()
	if (!(usr in range(0)) && usr!=src.loc) return
	if (bitecount==0)
		return
	else if (bitecount==1)
		to_chat(usr, "<span class='passive'>\The [src] was bitten by someone!</span>")
	else if (bitecount<=3)
		to_chat(usr, "<span class='passive'>\The [src] was bitten [bitecount] times!</span>")
	else
		to_chat(usr, "<span class='passive'>\The [src] was bitten multiple times!</span>")

/obj/item/reagent_containers/food/snacks/attackby(obj/item/W as obj, mob/user as mob)
	if(istype(W,/obj/item/storage))
		..() // -> item/attackby()
	if(istype(W,/obj/item/storage))
		..() // -> item/attackby()
	if((slices_num <= 0 || !slices_num) || !slice_path)
		return 0
	var/inaccurate = 0
	if( \
			istype(W, /obj/item/kitchenknife) || \
			istype(W, /obj/item/butch) || \
			istype(W, /obj/item/surgery_tool/scalpel) || \
			istype(W, /obj/item/kitchen/utensil/knife) \
		)
	else if( \
			istype(W, /obj/item/surgery_tool/circular_saw) || \
			istype(W, /obj/item/melee/energy/sword) && W:active || \
			istype(W, /obj/item/melee/energy/blade) || \
			istype(W, /obj/item/shovel) || \
			istype(W, /obj/item/hatchet) \
		)
		inaccurate = 1
	else if(W.w_class <= 2 && istype(src,/obj/item/reagent_containers/food/snacks/sliceable))
		if(!iscarbon(user))
			return 1
		user << "\red You slip [W] inside [src]."
		user.u_equip(W)
		if ((user.client && user.s_active != src))
			user.client.screen -= W
		W.dropped(user)
		add_fingerprint(user)
		contents += W
		return
	else
		return 1
	if ( \
			!isturf(src.loc) || \
			!(locate(/obj/structure/table) in src.loc) && \
			!(locate(/obj/machinery/optable) in src.loc) && \
			!(locate(/obj/item/tray) in src.loc) && \
			!(locate(/obj/structure/rack/lwtable) in src.loc) \
		)
		user << "\red You cannot slice [src] here! You need a table or at least a tray to do it."
		return 1
	var/slices_lost = 0
	if (!inaccurate)
		user.visible_message( \
			"\blue [user] slices \the [src]!", \
			"\blue You slice \the [src]!" \
		)
	else
		user.visible_message( \
			"\blue [user] inaccurately slices \the [src] with [W]!", \
			"\blue You inaccurately slice \the [src] with your [W]!" \
		)
		slices_lost = rand(1,min(1,round(slices_num/2)))
	var/reagents_per_slice = reagents.total_volume/slices_num
	for(var/i=1 to (slices_num-slices_lost))
		var/obj/slice = new slice_path (src.loc)
		reagents.trans_to(slice,reagents_per_slice)
	qdel(src)
	return

/obj/item/reagent_containers/food/snacks/Destroy()
	if(contents)
		for(var/atom/movable/something in contents)
			something.dropInto(loc)
	. = ..()

/obj/item/reagent_containers/food/snacks/attack_animal(var/mob/M)
	if(isanimal(M))
		if(iscorgi(M))
			if(bitecount == 0 || prob(50))
				M.emote("nibbles away at the [src]")
			bitecount++
			if(bitecount >= 5)
				var/sattisfaction_text = pick("burps from enjoyment", "yaps for more", "woofs twice", "looks at the area where the [src] was")
				if(sattisfaction_text)
					M.emote("[sattisfaction_text]")
				qdel(src)
		if(ismouse(M))
			var/mob/living/simple_animal/mouse/N = M
			N << text("\blue You nibble away at [src].")
			if(prob(50))
				N.visible_message("[N] nibbles away at [src].", "")
			//N.emote("nibbles away at the [src]")
			N.health = min(N.health + 1, N.maxHealth)


////////////////////////////////////////////////////////////////////////////////
/// FOOD END
////////////////////////////////////////////////////////////////////////////////











//////////////////////////////////////////////////
////////////////////////////////////////////Snacks
//////////////////////////////////////////////////
//Items in the "Snacks" subcategory are food items that people actually eat. The key points are that they are created
//	already filled with reagents and are destroyed when empty. Additionally, they make a "munching" noise when eaten.

//Notes by Darem: Food in the "snacks" subtype can hold a maximum of 50 units Generally speaking, you don't want to go over 40
//	total for the item because you want to leave space for extra condiments. If you want effect besides healing, add a reagent for
//	it. Try to stick to existing reagents when possible (so if you want a stronger healing effect, just use Omnizine). On use
//	effect (such as the old officer eating a donut code) requires a unique reagent (unless you can figure out a better way).

//The nutriment reagent and bitesize variable replace the old heal_amt and amount variables. Each unit of nutriment is equal to
//	2 of the old heal_amt variable. Bitesize is the rate at which the reagents are consumed. So if you have 6 nutriment and a
//	bitesize of 2, then it'll take 3 bites to eat. Unlike the old system, the contained reagents are evenly spread among all
//	the bites. No more contained reagents = no more bites.

//Here is an example of the new formatting for anyone who wants to add more food items.
///obj/item/reagent_containers/food/snacks/xenoburger			//Identification path for the object.
//	name = "Xenoburger"													//Name that displays in the UI.
//	desc = "Smells caustic. Tastes like heresy."						//Duh
//	icon_state = "xburger"												//Refers to an icon in food.dmi
//	New()																//Don't mess with this.
//		..()															//Same here.
//		reagents.add_reagent("xenomicrobes", 10)						//This is what is in the food item. you may copy/paste
//		reagents.add_reagent("nutriment", 2)							//	this line of code for all the contents.
//		bitesize = 3													//This is the amount each bite consumes.




/obj/item/reagent_containers/food/snacks/aesirsalad
	name = "Aesir salad"
	desc = "Probably too incredible for mortal men to fully enjoy."
	icon_state = "aesirsalad"
	trash = /obj/item/trash/snack_bowl
	filling_color = "#468C00"

	New()
		..()
		reagents.add_reagent("nutriment", 8)
		reagents.add_reagent("omnizine", 8)
		reagents.add_reagent("omnizine", 8)
		bitesize = 3

/obj/item/reagent_containers/food/snacks/candy
	name = "candy"
	desc = "Nougat love it or hate it."
	icon_state = "candy"
	item_state = "candy"
	trash = /obj/item/trash/candy
	filling_color = "#7D5F46"
	var/candy_open = FALSE

	New()
		..()
		reagents.add_reagent("nutriment", 2)
		reagents.add_reagent("sugar", 2)
		bitesize = 2


/obj/item/reagent_containers/food/snacks/candy/On_Consume(mob/user as mob)
	if(ishuman(user))
		var/mob/living/carbon/human/H = user
		H.add_event("candy", /datum/happiness_event/nutrition/badtaste)
	..()

/obj/item/reagent_containers/food/snacks/candy/attack_self(mob/user as mob)
	if(ishuman(user))
		var/mob/living/carbon/human/H = user
		if(H.my_stats.get_stat(STAT_IN) <= 3)
			to_chat(user, "<span class='combat'>[pick(fnord)] [pick("WHAT???","FUNNY!!","CANDY!!!","HOW??","HUNGRY!!")]!</span>")
			return
		if(H.my_stats.get_stat(STAT_PR) <= 5)
			to_chat(user, "<span class='combat'>[pick(fnord)], this will be harder than what I expected to be!</span>")
			var/mod2 = (H.my_stats.get_stat(STAT_PR) + H.my_stats.get_stat(STAT_IN)) / 2
			if(do_after(user, rand(5,30-mod2)))
				goto CANDY
			return
	CANDY
	if(!candy_open)
		if(do_after(user, 5))
			to_chat(user, "<span class='passive'>You open the candy bar.</span>")
			candy_open = TRUE
			playsound(user, "open_candy.ogg", 50, 0)
			update_icon()
	else
		to_chat(user, "<span class='combat'>[pick(fnord)] it is already open!</span>")
	return

/obj/item/reagent_containers/food/snacks/candy/attack(mob/M as mob, mob/user as mob, def_zone)
	if(!candy_open)
		to_chat(user, "<span class='combat'>[pick(fnord)] I need to open it before eating!</span>")
		return
	..()

/obj/item/reagent_containers/food/snacks/candy/On_Consume()
	..()
	icon_state = "candy-chew"

/obj/item/reagent_containers/food/snacks/candy/update_icon()
	if(candy_open)
		icon_state = "candy-open"
	else
		icon_state = "candy"

/obj/item/reagent_containers/food/snacks/candy/donor
	name = "Donor Candy"
	desc = "A little treat for blood donors."
	trash = /obj/item/trash/candy
	New()
		..()
		reagents.add_reagent("nutriment", 10)
		reagents.add_reagent("sugar", 3)
		bitesize = 5

/obj/item/reagent_containers/food/snacks/candy_corn
	name = "candy corn"
	desc = "It's a handful of candy corn. Can be stored in a detective's hat."
	icon_state = "candy_corn"
	filling_color = "#FFFCB0"

	New()
		..()
		reagents.add_reagent("nutriment", 4)
		reagents.add_reagent("sugar", 2)
		bitesize = 2

/obj/item/reagent_containers/food/snacks/chips
	name = "chips"
	desc = "Commander Riker's What-The-Crisps"
	icon_state = "chips"
	trash = /obj/item/trash/chips
	filling_color = "#E8C31E"

	New()
		..()
		reagents.add_reagent("nutriment", 3)
		bitesize = 1

/obj/item/reagent_containers/food/snacks/cookie
	name = "cookie"
	desc = "COOKIE!!!"
	icon_state = "COOKIE!!!"
	filling_color = "#DBC94F"

	New()
		..()
		reagents.add_reagent("nutriment", 5)
		bitesize = 1

/obj/item/reagent_containers/food/snacks/chocolatebar
	name = "Chocolate Bar"
	desc = "Such, sweet, fattening food."
	icon_state = "chocolatebar"
	filling_color = "#7D5F46"

	New()
		..()
		reagents.add_reagent("nutriment", 2)
		reagents.add_reagent("sugar", 2)
		reagents.add_reagent("coco", 2)
		bitesize = 2

/obj/item/reagent_containers/food/snacks/chocolateegg
	name = "Chocolate Egg"
	desc = "Such, sweet, fattening food."
	icon_state = "chocolateegg"
	filling_color = "#7D5F46"

	New()
		..()
		reagents.add_reagent("nutriment", 3)
		reagents.add_reagent("sugar", 2)
		reagents.add_reagent("coco", 2)
		bitesize = 2

/obj/item/reagent_containers/food/snacks/donut
	name = "donut"
	desc = "Goes great with Robust Coffee."
	icon_state = "donut1"
	filling_color = "#D9C386"

/obj/item/reagent_containers/food/snacks/donut/normal
	name = "donut"
	desc = "Goes great with Robust Coffee."
	icon_state = "donut1"
	New()
		..()
		reagents.add_reagent("nutriment", 3)
		reagents.add_reagent("sprinkles", 1)
		src.bitesize = 3
		if(prob(30))
			src.icon_state = "donut2"
			src.name = "frosted donut"
			reagents.add_reagent("sprinkles", 2)

/obj/item/reagent_containers/food/snacks/donut/jelly
	name = "Jelly Donut"
	desc = "You jelly?"
	icon_state = "jdonut1"
	filling_color = "#ED1169"

	New()
		..()
		reagents.add_reagent("nutriment", 3)
		reagents.add_reagent("sprinkles", 1)
		reagents.add_reagent("berryjuice", 5)
		bitesize = 5
		if(prob(30))
			src.icon_state = "jdonut2"
			src.name = "Frosted Jelly Donut"
			reagents.add_reagent("sprinkles", 2)

/obj/item/reagent_containers/food/snacks/donut/cherryjelly
	name = "Jelly Donut"
	desc = "You jelly?"
	icon_state = "jdonut1"
	filling_color = "#ED1169"

	New()
		..()
		reagents.add_reagent("nutriment", 3)
		reagents.add_reagent("sprinkles", 1)
		reagents.add_reagent("cherryjelly", 5)
		bitesize = 5
		if(prob(30))
			src.icon_state = "jdonut2"
			src.name = "Frosted Jelly Donut"
			reagents.add_reagent("sprinkles", 2)

/obj/item/reagent_containers/food/snacks/egg
	name = "egg"
	desc = "An egg!"
	icon_state = "egg"
	filling_color = "#FDFFD1"

	New()
		..()
		reagents.add_reagent("nutriment", 1)

	throw_impact(atom/hit_atom)
		..()
		new/obj/effect/decal/cleanable/egg_smudge(src.loc)
		src.reagents.reaction(hit_atom, TOUCH)
		src.visible_message("\red [src.name] has been squashed.","\red You hear a smack.")
		qdel(src)

	attackby(obj/item/W as obj, mob/user as mob)
		if(istype( W, /obj/item/toy/crayon ))
			var/obj/item/toy/crayon/C = W
			var/clr = C.colourName

			if(!(clr in list("blue","green","mime","orange","purple","rainbow","red","yellow")))
				usr << "\blue The egg refuses to take on this color!"
				return

			usr << "\blue You color \the [src] [clr]"
			icon_state = "egg-[clr]"
			item_color = clr
		else
			..()

/obj/item/reagent_containers/food/snacks/egg/blue
	icon_state = "egg-blue"
	item_color = "blue"

/obj/item/reagent_containers/food/snacks/egg/green
	icon_state = "egg-green"
	item_color = "green"

/obj/item/reagent_containers/food/snacks/egg/mime
	icon_state = "egg-mime"
	item_color = "mime"

/obj/item/reagent_containers/food/snacks/egg/orange
	icon_state = "egg-orange"
	item_color = "orange"

/obj/item/reagent_containers/food/snacks/egg/purple
	icon_state = "egg-purple"
	item_color = "purple"

/obj/item/reagent_containers/food/snacks/egg/rainbow
	icon_state = "egg-rainbow"
	item_color = "rainbow"

/obj/item/reagent_containers/food/snacks/egg/red
	icon_state = "egg-red"
	item_color = "red"

/obj/item/reagent_containers/food/snacks/egg/yellow
	icon_state = "egg-yellow"
	item_color = "yellow"

/obj/item/reagent_containers/food/snacks/friedegg
	name = "Fried egg"
	desc = "A fried egg, with a touch of salt and pepper."
	icon_state = "friedegg"
	filling_color = "#FFDF78"

	New()
		..()
		reagents.add_reagent("nutriment", 2)
		reagents.add_reagent("sodiumchloride", 1)
		reagents.add_reagent("blackpepper", 1)
		bitesize = 1

/obj/item/reagent_containers/food/snacks/boiledegg
	name = "Boiled egg"
	desc = "A hard boiled egg."
	icon_state = "egg"
	filling_color = "#FFFFFF"

	New()
		..()
		reagents.add_reagent("nutriment", 2)

/*/obj/item/reagent_containers/food/snacks/flour //Has been converted into a reagent. Use that instead of the item!
	name = "flour"
	desc = "Some flour"
	icon_state = "flour"
	New()
		..()
		reagents.add_reagent("nutriment", 1)*/

/obj/item/reagent_containers/food/snacks/organ

	name = "organ"
	desc = "It's good for you."
	icon = 'icons/obj/surgery.dmi'
	icon_state = "appendix"
	filling_color = "#E00D34"

	New()
		..()
		reagents.add_reagent("nutriment", rand(3,5))
		reagents.add_reagent("toxin", rand(1,3))
		src.bitesize = 3

/obj/item/reagent_containers/food/snacks/tofu
	name = "Tofu"
	icon_state = "tofu"
	desc = "We all love tofu."
	filling_color = "#FFFEE0"

	New()
		..()
		reagents.add_reagent("nutriment", 3)
		src.bitesize = 3

/obj/item/reagent_containers/food/snacks/tofurkey
	name = "Tofurkey"
	desc = "A fake turkey made from tofu."
	icon_state = "tofurkey"
	filling_color = "#FFFEE0"

	New()
		..()
		reagents.add_reagent("nutriment", 12)
		reagents.add_reagent("stoxin", 3)
		bitesize = 3

/obj/item/reagent_containers/food/snacks/stuffing
	name = "Stuffing"
	desc = "Moist, peppery breadcrumbs for filling the body cavities of dead birds. Dig in!"
	icon_state = "stuffing"
	filling_color = "#C9AC83"

	New()
		..()
		reagents.add_reagent("nutriment", 3)
		bitesize = 1

/obj/item/reagent_containers/food/snacks/carpmeat
	name = "carp fillet"
	desc = "A fillet of spess carp meat"
	icon_state = "fishfillet"
	filling_color = "#FFDEFE"

	New()
		..()
		reagents.add_reagent("nutriment", 3)
		reagents.add_reagent("carpotoxin", 3)
		src.bitesize = 6

/obj/item/reagent_containers/food/snacks/fishfingers
	name = "Fish Fingers"
	desc = "A finger of fish."
	icon_state = "fishfingers"
	filling_color = "#FFDEFE"

	New()
		..()
		reagents.add_reagent("nutriment", 4)
		reagents.add_reagent("carpotoxin", 3)
		bitesize = 3

/obj/item/reagent_containers/food/snacks/hugemushroomslice
	name = "huge mushroom slice"
	desc = "A slice from a huge mushroom."
	icon_state = "hugemushroomslice"
	filling_color = "#E0D7C5"

	New()
		..()
		reagents.add_reagent("nutriment", 3)
		reagents.add_reagent("psilocybin", 3)
		src.bitesize = 6

/obj/item/reagent_containers/food/snacks/tomatomeat
	name = "tomato slice"
	desc = "A slice from a huge tomato"
	icon_state = "tomatomeat"
	filling_color = "#DB0000"

	New()
		..()
		reagents.add_reagent("nutriment", 3)
		src.bitesize = 6

/obj/item/reagent_containers/food/snacks/bearmeat
	name = "bear meat"
	desc = "A very manly slab of meat."
	icon_state = "bearmeat"
	filling_color = "#DB0000"

	New()
		..()
		reagents.add_reagent("nutriment", 12)
		reagents.add_reagent("morphine", 5)
		src.bitesize = 3

/obj/item/reagent_containers/food/snacks/xenomeat
	name = "meat"
	desc = "A slab of meat"
	icon_state = "xenomeat"
	filling_color = "#43DE18"

	New()
		..()
		reagents.add_reagent("nutriment", 3)
		src.bitesize = 6

/obj/item/reagent_containers/food/snacks/faggot
	name = "Faggot"
	desc = "A great meal all round. Not a cord of wood."
	icon_state = "faggot"
	filling_color = "#DB0000"

	New()
		..()
		reagents.add_reagent("nutriment", 3)
		bitesize = 2

/obj/item/reagent_containers/food/snacks/sausage
	name = "Sausage"
	desc = "A piece of mixed, long meat."
	icon_state = "sausage"
	filling_color = "#DB0000"

	New()
		..()
		reagents.add_reagent("nutriment", 6)
		bitesize = 2

/obj/item/reagent_containers/food/snacks/donkpocket
	name = "Donk-pocket"
	desc = "The food of choice for the seasoned traitor."
	icon_state = "donkpocket"
	filling_color = "#DEDEAB"

	New()
		..()
		reagents.add_reagent("nutriment", 4)

	var/warm = 0
	proc/cooltime() //Not working, derp?
		if (src.warm)
			spawn( 4200 )
				src.warm = 0
				src.reagents.del_reagent("omnizine")
				src.name = "donk-pocket"
		return

/obj/item/reagent_containers/food/snacks/brainburger
	name = "brainburger"
	desc = "A strange looking burger. It looks almost sentient."
	icon_state = "brainburger"
	filling_color = "#F2B6EA"

	New()
		..()
		reagents.add_reagent("nutriment", 6)
		reagents.add_reagent("mannitol", 6)
		bitesize = 2

/obj/item/reagent_containers/food/snacks/ghostburger
	name = "Ghost Burger"
	desc = "Spooky! It doesn't look very filling."
	icon_state = "ghostburger"
	filling_color = "#FFF2FF"

	New()
		..()
		reagents.add_reagent("nutriment", 2)
		bitesize = 2


/obj/item/reagent_containers/food/snacks/human
	var/hname = ""
	var/job = null
	filling_color = "#D63C3C"

/obj/item/reagent_containers/food/snacks/human/burger
	name = "-burger"
	desc = "A bloody burger."
	icon_state = "hburger"
	New()
		..()
		reagents.add_reagent("nutriment", 6)
		bitesize = 2

/obj/item/reagent_containers/food/snacks/monkeyburger
	name = "burger"
	desc = "The cornerstone of every nutritious breakfast."
	icon_state = "hburger"
	filling_color = "#D63C3C"

	New()
		..()
		reagents.add_reagent("nutriment", 6)
		bitesize = 2

/obj/item/reagent_containers/food/snacks/hamburger  // Copypasta till i will make new sprite
	name = "burger"
	desc = "The cornerstone of every nutritious breakfast."
	icon_state = "hburger"
	filling_color = "#D63C3C"

	New()
		..()
		reagents.add_reagent("nutriment", 6)
		bitesize = 2

/obj/item/reagent_containers/food/snacks/fishburger
	name = "Fillet -o- Carp Sandwich"
	desc = "Almost like a carp is yelling somewhere... Give me back that fillet -o- carp, give me that carp."
	icon_state = "fishburger"
	filling_color = "#FFDEFE"

	New()
		..()
		reagents.add_reagent("nutriment", 6)
		reagents.add_reagent("carpotoxin", 3)
		bitesize = 3

/obj/item/reagent_containers/food/snacks/tofuburger
	name = "Tofu Burger"
	desc = "What.. is that meat?"
	icon_state = "tofuburger"
	filling_color = "#FFFEE0"

	New()
		..()
		reagents.add_reagent("nutriment", 6)
		bitesize = 2

/obj/item/reagent_containers/food/snacks/roburger
	name = "roburger"
	desc = "The lettuce is the only organic component. Beep."
	icon_state = "roburger"
	filling_color = "#CCCCCC"

	New()
		..()
		reagents.add_reagent("nanites", 2)
		bitesize = 2

/obj/item/reagent_containers/food/snacks/roburgerbig
	name = "roburger"
	desc = "This massive patty looks like poison. Beep."
	icon_state = "roburger"
	filling_color = "#CCCCCC"
	volume = 100

	New()
		..()
		reagents.add_reagent("nanites", 100)
		bitesize = 0.1

/obj/item/reagent_containers/food/snacks/xenoburger
	name = "xenoburger"
	desc = "Smells caustic. Tastes like heresy."
	icon_state = "xburger"
	filling_color = "#43DE18"

	New()
		..()
		reagents.add_reagent("nutriment", 8)
		bitesize = 2

/obj/item/reagent_containers/food/snacks/clownburger
	name = "Clown Burger"
	desc = "This tastes funny..."
	icon_state = "clownburger"
	filling_color = "#FF00FF"

	New()
		..()
/*
		var/datum/disease/F = new /datum/disease/pierrot_throat(0)
		var/list/data = list("viruses"= list(F))
		reagents.add_reagent("blood", 4, data)
*/
		reagents.add_reagent("nutriment", 6)
		bitesize = 2

/obj/item/reagent_containers/food/snacks/mimeburger
	name = "Mime Burger"
	desc = "Its taste defies language."
	icon_state = "mimeburger"
	filling_color = "#FFFFFF"

	New()
		..()
		reagents.add_reagent("nutriment", 6)
		bitesize = 2

/obj/item/reagent_containers/food/snacks/omelette
	name = "Omelette Du Fromage"
	desc = "That's all you can say!"
	icon_state = "omelette"
	trash = /obj/item/trash/plate
	filling_color = "#FFF9A8"

	//var/herp = 0
	New()
		..()
		reagents.add_reagent("nutriment", 8)
		bitesize = 1
	attackby(obj/item/W as obj, mob/user as mob)
		if(istype(W,/obj/item/kitchen/utensil/fork))
			if (W.icon_state == "forkloaded")
				user << "\red You already have omelette on your fork."
				return
			//W.icon = 'icons/obj/kitchen.dmi'
			W.icon_state = "forkloaded"
			/*if (herp)
				world << "[user] takes a piece of omelette with his fork!"*/
				//Why this unecessary check? Oh I know, because I'm bad >:C
				// Yes, you are. You griefing my badmin toys. --rastaf0
			user.visible_message( \
				"[user] takes a piece of omelette with their fork!", \
				"\blue You take a piece of omelette with your fork!" \
			)
			reagents.remove_reagent("nutriment", 1)
			if (reagents.total_volume <= 0)
				qdel(src)
/*
 * Unsused.
/obj/item/reagent_containers/food/snacks/omeletteforkload
	name = "Omelette Du Fromage"
	desc = "That's all you can say!"
	New()
		..()
		reagents.add_reagent("nutriment", 1)
*/

/obj/item/reagent_containers/food/snacks/muffin
	name = "Muffin"
	desc = "A delicious and spongy little cake"
	icon_state = "muffin"
	filling_color = "#E0CF9B"

	New()
		..()
		reagents.add_reagent("nutriment", 6)
		bitesize = 2

/obj/item/reagent_containers/food/snacks/bananaphone
	name = "Banana Phone"
	desc = "Ring ring ring ring ring..."
	icon = 'icons/obj/items.dmi'
	icon_state = "banana" //needs a new icon.
	bitesize = 5
	var/obj/item/device/radio/banana/bananaphone
	New()
		..()
		reagents.add_reagent("banana", 5)
		bananaphone = new /obj/item/device/radio/banana(src)
		bananaphone.listening = 1
		bananaphone.broadcasting = 1

	On_Consume()
		if(!reagents.total_volume)
			usr << sound('sound/ambience/bananaphone.ogg',1)
	hear_talk(mob/M as mob, msg)
		if(bananaphone)
			bananaphone.hear_talk(M, msg)


/obj/item/reagent_containers/food/snacks/pie
	name = "Banana Cream Pie"
	desc = "Just like back home, on clown planet! HONK!"
	icon_state = "pie"
	trash = /obj/item/trash/plate
	filling_color = "#FBFFB8"

/obj/item/reagent_containers/food/snacks/pie/New()
	..()
	reagents.add_reagent("nutriment", 4)
	reagents.add_reagent("banana",5)
	bitesize = 3

/obj/item/reagent_containers/food/snacks/pie/throw_impact(atom/hit_atom)
	..()
	new/obj/effect/decal/cleanable/pie_smudge(src.loc)
	src.visible_message("\red [src.name] splats.","\red You hear a splat.")
	qdel(src)

/obj/item/reagent_containers/food/snacks/berryclafoutis
	name = "Berry Clafoutis"
	desc = "No black birds, this is a good sign."
	icon_state = "berryclafoutis"
	trash = /obj/item/trash/plate
	New()
		..()
		reagents.add_reagent("nutriment", 4)
		reagents.add_reagent("berryjuice", 5)
		bitesize = 3

/obj/item/reagent_containers/food/snacks/waffles
	name = "waffles"
	desc = "Mmm, waffles"
	icon_state = "waffles"
	trash = /obj/item/trash/waffles
	filling_color = "#E6DEB5"

	New()
		..()
		reagents.add_reagent("nutriment", 8)
		bitesize = 2

/obj/item/reagent_containers/food/snacks/eggplantparm
	name = "Eggplant Parmigiana"
	desc = "The only good recipe for eggplant."
	icon_state = "eggplantparm"
	trash = /obj/item/trash/plate
	filling_color = "#4D2F5E"

	New()
		..()
		reagents.add_reagent("nutriment", 6)
		bitesize = 2

/obj/item/reagent_containers/food/snacks/soylentgreen
	name = "Soylent Green"
	desc = "Not made of people. Honest." //Totally people.
	icon_state = "soylent_green"
	trash = /obj/item/trash/waffles
	filling_color = "#B8E6B5"

	New()
		..()
		reagents.add_reagent("nutriment", 10)
		bitesize = 2

/obj/item/reagent_containers/food/snacks/soylenviridians
	name = "Soylen Virdians"
	desc = "Not made of people. Honest." //Actually honest for once.
	icon_state = "soylent_yellow"
	trash = /obj/item/trash/waffles
	filling_color = "#E6FA61"

	New()
		..()
		reagents.add_reagent("nutriment", 10)
		bitesize = 2


/obj/item/reagent_containers/food/snacks/meatpie
	name = "Meat-pie"
	icon_state = "meatpie"
	desc = "An old barber recipe, very delicious!"
	trash = /obj/item/trash/plate
	filling_color = "#948051"

	New()
		..()
		reagents.add_reagent("nutriment", 10)
		bitesize = 2

/obj/item/reagent_containers/food/snacks/tofupie
	name = "Tofu-pie"
	icon_state = "meatpie"
	desc = "A delicious tofu pie."
	trash = /obj/item/trash/plate
	filling_color = "#FFFEE0"

	New()
		..()
		reagents.add_reagent("nutriment", 10)
		bitesize = 2

/obj/item/reagent_containers/food/snacks/amanita_pie
	name = "amanita pie"
	desc = "Sweet and tasty poison pie."
	icon_state = "amanita_pie"
	filling_color = "#FFCCCC"

	New()
		..()
		reagents.add_reagent("nutriment", 5)
		reagents.add_reagent("amatoxin", 3)
		reagents.add_reagent("psilocybin", 1)
		bitesize = 3

/obj/item/reagent_containers/food/snacks/plump_pie
	name = "plump pie"
	desc = "I bet you love stuff made out of plump helmets!"
	icon_state = "plump_pie"
	filling_color = "#B8279B"

	New()
		..()
		if(prob(10))
			name = "exceptional plump pie"
			desc = "Microwave is taken by a fey mood! It has cooked an exceptional plump pie!"
			reagents.add_reagent("nutriment", 8)
			reagents.add_reagent("omnizine", 5)
			reagents.add_reagent("dwine", 10)
			bitesize = 2
		else
			reagents.add_reagent("nutriment", 8)
			reagents.add_reagent("dwine", 10)
			bitesize = 2

/obj/item/reagent_containers/food/snacks/xemeatpie
	name = "Xeno-pie"
	icon_state = "xenomeatpie"
	desc = "A delicious meatpie. Probably heretical."
	trash = /obj/item/trash/plate
	filling_color = "#43DE18"

	New()
		..()
		reagents.add_reagent("nutriment", 10)
		bitesize = 2

/obj/item/reagent_containers/food/snacks/wingfangchu
	name = "Wing Fang Chu"
	desc = "A savory dish of alien wing wang in soy."
	icon_state = "wingfangchu"
	trash = /obj/item/trash/snack_bowl
	filling_color = "#43DE18"

	New()
		..()
		reagents.add_reagent("nutriment", 6)
		bitesize = 2


/obj/item/reagent_containers/food/snacks/human/kabob
	name = "-kabob"
	icon_state = "kabob"
	desc = "A human meat, on a stick."
	trash = /obj/item/stack/rods
	filling_color = "#A85340"

	New()
		..()
		reagents.add_reagent("nutriment", 8)
		bitesize = 2

/obj/item/reagent_containers/food/snacks/monkeykabob
	name = "Meat-kabob"
	icon_state = "kabob"
	desc = "Delicious meat, on a stick."
	trash = /obj/item/stack/rods
	filling_color = "#A85340"

	New()
		..()
		reagents.add_reagent("nutriment", 8)
		bitesize = 2

/obj/item/reagent_containers/food/snacks/tofukabob
	name = "Tofu-kabob"
	icon_state = "kabob"
	desc = "Vegan meat, on a stick."
	trash = /obj/item/stack/rods
	filling_color = "#FFFEE0"

	New()
		..()
		reagents.add_reagent("nutriment", 8)
		bitesize = 2

/obj/item/reagent_containers/food/snacks/cubancarp
	name = "Cuban Carp"
	desc = "A grifftastic sandwich that burns your tongue and then leaves it numb!"
	icon_state = "cubancarp"
	trash = /obj/item/trash/plate
	filling_color = "#E9ADFF"

	New()
		..()
		reagents.add_reagent("nutriment", 6)
		reagents.add_reagent("carpotoxin", 3)
		reagents.add_reagent("capsaicin", 3)
		bitesize = 3

/obj/item/reagent_containers/food/snacks/popcorn
	name = "Popcorn"
	desc = "Now let's find some cinema."
	icon_state = "popcorn"
	trash = /obj/item/trash/popcorn
	var/unpopped = 0
	filling_color = "#FFFAD4"

	New()
		..()
		unpopped = rand(1,10)
		reagents.add_reagent("nutriment", 2)
		bitesize = 0.1 //this snack is supposed to be eating during looooong time. And this it not dinner food! --rastaf0
	On_Consume()
		if(prob(unpopped))	//lol ...what's the point?
			usr << "\red You bite down on an un-popped kernel!"
			unpopped = max(0, unpopped-1)
		..()


/obj/item/reagent_containers/food/snacks/sosjerky
	name = "Scaredy's Private Reserve Beef Jerky"
	icon_state = "sosjerky"
	desc = "Beef jerky made from the finest space cows."
	trash = /obj/item/trash/sosjerky
	filling_color = "#631212"

	New()
		..()
		reagents.add_reagent("nutriment", 4)
		bitesize = 2

/obj/item/reagent_containers/food/snacks/no_raisin
	name = "4no Raisins"
	icon_state = "4no_raisins"
	desc = "Best raisins in the universe. Not sure why."
	trash = /obj/item/trash/raisins
	filling_color = "#343834"

	New()
		..()
		reagents.add_reagent("nutriment", 6)

/obj/item/reagent_containers/food/snacks/spacetwinkie
	name = "Space Twinkie"
	icon_state = "space_twinkie"
	desc = "Guaranteed to survive longer then you will."
	filling_color = "#FFE591"

	New()
		..()
		reagents.add_reagent("sugar", 4)
		bitesize = 2

/obj/item/reagent_containers/food/snacks/cheesiehonkers
	name = "Cheesie Honkers"
	icon_state = "cheesie_honkers"
	desc = "Bite sized cheesie snacks that will honk all over your mouth"
	trash = /obj/item/trash/cheesie
	filling_color = "#FFA305"

	New()
		..()
		reagents.add_reagent("nutriment", 4)
		bitesize = 2

/obj/item/reagent_containers/food/snacks/syndicake
	name = "Syndi-Cakes"
	icon_state = "syndi_cakes"
	desc = "An extremely moist snack cake that tastes just as good after being nuked."
	filling_color = "#FF5D05"

	trash = /obj/item/trash/syndi_cakes
	New()
		..()
		reagents.add_reagent("nutriment", 4)
		reagents.add_reagent("omnizine", 5)
		bitesize = 3

/obj/item/reagent_containers/food/snacks/loadedbakedpotato
	name = "Loaded Baked Potato"
	desc = "Totally baked."
	icon_state = "loadedbakedpotato"
	filling_color = "#9C7A68"

	New()
		..()
		reagents.add_reagent("nutriment", 6)
		bitesize = 2

/obj/item/reagent_containers/food/snacks/fries
	name = "Space Fries"
	desc = "AKA: French Fries, Freedom Fries, etc"
	icon_state = "fries"
	trash = /obj/item/trash/plate
	filling_color = "#EDDD00"

	New()
		..()
		reagents.add_reagent("nutriment", 4)
		bitesize = 2

/obj/item/reagent_containers/food/snacks/soydope
	name = "Soy Dope"
	desc = "Dope from a soy."
	icon_state = "soydope"
	trash = /obj/item/trash/plate
	filling_color = "#C4BF76"

	New()
		..()
		reagents.add_reagent("nutriment", 2)
		bitesize = 2

/obj/item/reagent_containers/food/snacks/spagetti
	name = "Spagetti"
	desc = "Now thats a nice pasta!"
	icon_state = "spagetti"
	filling_color = "#EDDD00"

	New()
		..()
		reagents.add_reagent("nutriment", 1)
		bitesize = 1

/obj/item/reagent_containers/food/snacks/cheesyfries
	name = "Cheesy Fries"
	desc = "Fries. Covered in cheese. Duh."
	icon_state = "cheesyfries"
	trash = /obj/item/trash/plate
	filling_color = "#EDDD00"

	New()
		..()
		reagents.add_reagent("nutriment", 6)
		bitesize = 2

/obj/item/reagent_containers/food/snacks/fortunecookie
	name = "Fortune cookie"
	desc = "A true prophecy in each cookie!"
	icon_state = "fortune_cookie"
	filling_color = "#E8E79E"

	New()
		..()
		reagents.add_reagent("nutriment", 3)
		bitesize = 2

/obj/item/reagent_containers/food/snacks/badrecipe
	name = "Burned mess"
	desc = "Someone should be demoted from chef for this."
	icon_state = "badrecipe"
	filling_color = "#211F02"

	New()
		..()
		reagents.add_reagent("????", 30)
		bitesize = 2

/obj/item/reagent_containers/food/snacks/worms
	name = "Worms"
	icon_state = "worm7"
	filling_color = "#211F02"
	New()
		..()
		reagents.add_reagent("????", 30)
		bitesize = 7

/obj/item/reagent_containers/food/snacks/worms/On_Consume()
	..()
	var/totial = bitesize-bitecount
	icon_state = "worm[totial]"

/obj/item/reagent_containers/food/snacks/worms/update_icon()
	icon_state = "worm[bitesize]"

/obj/item/reagent_containers/food/snacks/worms/Crossed(AM as mob|obj)
	if(iscarbon(AM))
		var/mob/living/carbon/M = AM
		if(prob(30))
			M.stumble(1,src)
	else
		return

/obj/item/reagent_containers/food/snacks/deadrat
	name = "rat"
	icon_state = "rat"
	filling_color = "#211F02"

	New()
		..()
		reagents.add_reagent("nutriment", 4)
		reagents.add_reagent("????", 1)
		bitesize = 2


/obj/item/reagent_containers/food/snacks/purryingmaggot
	name = "purrying maggot"
	icon = 'icons/mob/animal.dmi'
	icon_state = "worm_l"
	filling_color = "#211F02"

	New()
		..()
		reagents.add_reagent("nutriment", 2)
		reagents.add_reagent("milk", 2)
		if(prob(40))
			reagents.add_reagent("????", 0.5)
		bitesize = 3

/obj/item/reagent_containers/food/snacks/meatsteak
	name = "Meat steak"
	desc = "A piece of hot spicy meat."
	icon_state = "meatstake"
	trash = /obj/item/trash/plate
	filling_color = "#7A3D11"
	slice_path = /obj/item/reagent_containers/food/snacks/cutlet
	slices_num = 3
	New()
		..()
		reagents.add_reagent("nutriment", 4)
		reagents.add_reagent("sodiumchloride", 1)
		reagents.add_reagent("blackpepper", 1)
		bitesize = 3

/obj/item/reagent_containers/food/snacks/spacylibertyduff
	name = "Spacy Liberty Duff"
	desc = "Jello gelatin, from Alfred Hubbard's cookbook"
	icon_state = "spacylibertyduff"
	trash = /obj/item/trash/snack_bowl
	filling_color = "#42B873"

	New()
		..()
		reagents.add_reagent("nutriment", 6)
		reagents.add_reagent("psilocybin", 6)
		bitesize = 3

/obj/item/reagent_containers/food/snacks/amanitajelly
	name = "Amanita Jelly"
	desc = "Looks curiously toxic"
	icon_state = "amanitajelly"
	trash = /obj/item/trash/snack_bowl
	filling_color = "#ED0758"

	New()
		..()
		reagents.add_reagent("nutriment", 6)
		reagents.add_reagent("amatoxin", 6)
		reagents.add_reagent("psilocybin", 3)
		bitesize = 3

/obj/item/reagent_containers/food/snacks/poppypretzel
	name = "Poppy pretzel"
	desc = "It's all twisted up!"
	icon_state = "poppypretzel"
	bitesize = 2
	filling_color = "#916E36"

	New()
		..()
		reagents.add_reagent("nutriment", 5)
		bitesize = 2


/obj/item/reagent_containers/food/snacks/meatballsoup
	name = "Meatball soup"
	desc = "You've got balls kid, BALLS!"
	icon_state = "meatballsoup"
	trash = /obj/item/trash/snack_bowl
	filling_color = "#785210"

	New()
		..()
		reagents.add_reagent("nutriment", 8)
		reagents.add_reagent("water", 5)
		bitesize = 5

/obj/item/reagent_containers/food/snacks/bloodsoup
	name = "Tomato soup"
	desc = "Smells like copper"
	icon_state = "tomatosoup"
	filling_color = "#FF0000"

	New()
		..()
		reagents.add_reagent("nutriment", 2)
		reagents.add_reagent("blood", 10)
		reagents.add_reagent("water", 5)
		bitesize = 5

/obj/item/reagent_containers/food/snacks/clownstears
	name = "Clown's Tears"
	desc = "Not very funny."
	icon_state = "clownstears"
	filling_color = "#C4FBFF"

	New()
		..()
		reagents.add_reagent("nutriment", 4)
		reagents.add_reagent("banana", 5)
		reagents.add_reagent("water", 10)
		bitesize = 5

/obj/item/reagent_containers/food/snacks/vegetablesoup
	name = "Vegetable soup"
	desc = "A true vegan meal" //TODO
	icon_state = "vegetablesoup"
	trash = /obj/item/trash/snack_bowl
	filling_color = "#AFC4B5"

	New()
		..()
		reagents.add_reagent("nutriment", 8)
		reagents.add_reagent("water", 5)
		bitesize = 5

/obj/item/reagent_containers/food/snacks/nettlesoup
	name = "Nettle soup"
	desc = "To think, the botanist would've beat you to death with one of these."
	icon_state = "nettlesoup"
	trash = /obj/item/trash/snack_bowl
	filling_color = "#AFC4B5"

	New()
		..()
		reagents.add_reagent("nutriment", 8)
		reagents.add_reagent("water", 5)
		reagents.add_reagent("omnizine", 5)
		bitesize = 5

/obj/item/reagent_containers/food/snacks/wishsoup
	name = "Wish Soup"
	desc = "I wish this was soup."
	icon_state = "wishsoup"
	trash = /obj/item/trash/snack_bowl
	filling_color = "#D1F4FF"

	New()
		..()
		reagents.add_reagent("water", 10)
		bitesize = 5
		if(prob(25))
			src.desc = "A wish come true!"
			reagents.add_reagent("nutriment", 8)

/obj/item/reagent_containers/food/snacks/hotchili
	name = "Hot Chili"
	desc = "A five alarm Texan Chili!"
	icon_state = "hotchili"
	trash = /obj/item/trash/snack_bowl
	filling_color = "#FF3C00"

	New()
		..()
		reagents.add_reagent("nutriment", 6)
		reagents.add_reagent("capsaicin", 3)
		reagents.add_reagent("tomatojuice", 2)
		bitesize = 5


/obj/item/reagent_containers/food/snacks/coldchili
	name = "Cold Chili"
	desc = "This slush is barely a liquid!"
	icon_state = "coldchili"
	filling_color = "#2B00FF"

	trash = /obj/item/trash/snack_bowl
	New()
		..()
		reagents.add_reagent("nutriment", 6)
		reagents.add_reagent("frostoil", 3)
		reagents.add_reagent("tomatojuice", 2)
		bitesize = 5

//Go fuck yourself, baycoders
/obj/item/reagent_containers/food/snacks/telebacon
	name = "Tele Bacon"
	desc = "It tastes a little odd but it is still delicious."
	icon_state = "bacon"
	var/obj/item/device/radio/beacon/bacon/baconbeacon
	bitesize = 2
	New()
		..()
		reagents.add_reagent("nutriment", 4)
		baconbeacon = new /obj/item/device/radio/beacon/bacon(src)
	On_Consume()
		if(!reagents.total_volume)
			baconbeacon.loc = usr
			baconbeacon.digest_delay()


/obj/item/reagent_containers/food/snacks/monkeycube
	name = "monkey cube"
	desc = "Just add water!"
	icon_state = "monkeycube"
	bitesize = 12
	filling_color = "#ADAC7F"

	var/wrapped = 0
	var/monkey_type = null

	New()
		..()
		reagents.add_reagent("nutriment",10)

	afterattack(obj/O as obj, mob/user as mob, proximity)
		if(!proximity) return
		if(istype(O,/obj/structure/sink) && !wrapped)
			user << "You place \the [name] under a stream of water..."
			loc = get_turf(O)
			return Expand()
		..()

	attack_self(mob/user as mob)
		if(wrapped)
			Unwrap(user)

	Crossed(A as obj)
		if(istype(A, /obj/effect/effect/water))
			Expand()


	proc/Expand()
		for(var/mob/M in viewers(src,7))
			M << "\red \The [src] expands!"
		if(monkey_type)
			switch(monkey_type)
				if("tajara")
					new /mob/living/carbon/monkey/tajara(get_turf(src))
				if("unathi")
					new /mob/living/carbon/monkey/unathi(get_turf(src))
				if("skrell")
					new /mob/living/carbon/monkey/skrell(get_turf(src))

		else
			new /mob/living/carbon/monkey(get_turf(src))
		qdel(src)

	proc/Unwrap(mob/user as mob)
		icon_state = "monkeycube"
		desc = "Just add water!"
		user << "You unwrap the cube."
		wrapped = 0
		return

/obj/item/reagent_containers/food/snacks/monkeycube/wrapped
	desc = "Still wrapped in some paper."
	icon_state = "monkeycubewrap"
	wrapped = 1


/obj/item/reagent_containers/food/snacks/monkeycube/farwacube
	name = "farwa cube"
	monkey_type ="tajara"
/obj/item/reagent_containers/food/snacks/monkeycube/wrapped/farwacube
	name = "farwa cube"
	monkey_type ="tajara"


/obj/item/reagent_containers/food/snacks/monkeycube/stokcube
	name = "stok cube"
	monkey_type ="unathi"
/obj/item/reagent_containers/food/snacks/monkeycube/wrapped/stokcube
	name = "stok cube"
	monkey_type ="unathi"


/obj/item/reagent_containers/food/snacks/monkeycube/neaeracube
	name = "neaera cube"
	monkey_type ="skrell"
/obj/item/reagent_containers/food/snacks/monkeycube/wrapped/neaeracube
	name = "neaera cube"
	monkey_type ="skrell"


/obj/item/reagent_containers/food/snacks/spellburger
	name = "Spell Burger"
	desc = "This is absolutely Ei Nath."
	icon_state = "spellburger"
	filling_color = "#D505FF"

	New()
		..()
		reagents.add_reagent("nutriment", 6)
		bitesize = 2

/obj/item/reagent_containers/food/snacks/bigbiteburger
	name = "Big Bite Burger"
	desc = "Forget the Big Mac. THIS is the future!"
	icon_state = "bigbiteburger"
	filling_color = "#E3D681"

	New()
		..()
		reagents.add_reagent("nutriment", 14)
		bitesize = 3

/obj/item/reagent_containers/food/snacks/enchiladas
	name = "Enchiladas"
	desc = "Viva La Mexico!"
	icon_state = "enchiladas"
	trash = /obj/item/trash/tray
	filling_color = "#A36A1F"

	New()
		..()
		reagents.add_reagent("nutriment",8)
		reagents.add_reagent("capsaicin", 6)
		bitesize = 4

/obj/item/reagent_containers/food/snacks/monkeysdelight
	name = "monkey's Delight"
	desc = "Eeee Eee!"
	icon_state = "monkeysdelight"
	trash = /obj/item/trash/tray
	filling_color = "#5C3C11"

	New()
		..()
		reagents.add_reagent("nutriment", 10)
		reagents.add_reagent("banana", 5)
		reagents.add_reagent("blackpepper", 1)
		reagents.add_reagent("sodiumchloride", 1)
		bitesize = 6

/obj/item/reagent_containers/food/snacks/baguette
	name = "Baguette"
	desc = "Bon appetit!"
	icon_state = "baguette"
	filling_color = "#E3D796"

	New()
		..()
		reagents.add_reagent("nutriment", 6)
		reagents.add_reagent("blackpepper", 1)
		reagents.add_reagent("sodiumchloride", 1)
		bitesize = 3

/obj/item/reagent_containers/food/snacks/fishandchips
	name = "Fish and Chips"
	desc = "I do say so myself chap."
	icon_state = "fishandchips"
	filling_color = "#E3D796"

	New()
		..()
		reagents.add_reagent("nutriment", 6)
		reagents.add_reagent("carpotoxin", 3)
		bitesize = 3

/obj/item/reagent_containers/food/snacks/sandwich
	name = "Sandwich"
	desc = "A grand creation of meat, cheese, bread, and several leaves of lettuce! Arthur Dent would be proud."
	icon_state = "sandwich"
	trash = /obj/item/trash/plate
	filling_color = "#D9BE29"

	New()
		..()
		reagents.add_reagent("nutriment", 6)
		bitesize = 2

/obj/item/reagent_containers/food/snacks/toastedsandwich
	name = "Toasted Sandwich"
	desc = "Now if you only had a pepper bar."
	icon_state = "toastedsandwich"
	trash = /obj/item/trash/plate
	filling_color = "#D9BE29"

	New()
		..()
		reagents.add_reagent("nutriment", 6)
		reagents.add_reagent("carbon", 2)
		bitesize = 2

/obj/item/reagent_containers/food/snacks/grilledcheese
	name = "Grilled Cheese Sandwich"
	desc = "Goes great with Tomato soup!"
	icon_state = "toastedsandwich"
	trash = /obj/item/trash/plate
	filling_color = "#D9BE29"

	New()
		..()
		reagents.add_reagent("nutriment", 7)
		bitesize = 2

/obj/item/reagent_containers/food/snacks/tomatosoup
	name = "Tomato Soup"
	desc = "Drinking this feels like being a vampire! A tomato vampire..."
	icon_state = "tomatosoup"
	trash = /obj/item/trash/snack_bowl
	filling_color = "#D92929"

	New()
		..()
		reagents.add_reagent("nutriment", 5)
		reagents.add_reagent("tomatojuice", 10)
		bitesize = 3

/obj/item/reagent_containers/food/snacks/rofflewaffles
	name = "Roffle Waffles"
	desc = "Waffles from Roffle. Co."
	icon_state = "rofflewaffles"
	trash = /obj/item/trash/waffles
	filling_color = "#FF00F7"

	New()
		..()
		reagents.add_reagent("nutriment", 8)
		reagents.add_reagent("psilocybin", 8)
		bitesize = 4

/obj/item/reagent_containers/food/snacks/stew
	name = "Stew"
	desc = "A nice and warm stew. Healthy and strong."
	icon_state = "stew"
	filling_color = "#9E673A"

	New()
		..()
		reagents.add_reagent("nutriment", 10)
		reagents.add_reagent("tomatojuice", 5)
		reagents.add_reagent("oculine", 5)
		reagents.add_reagent("water", 5)
		bitesize = 10

/obj/item/reagent_containers/food/snacks/milosoup
	name = "Milosoup"
	desc = "The universes best soup! Yum!!!"
	icon_state = "milosoup"
	trash = /obj/item/trash/snack_bowl
	New()
		..()
		reagents.add_reagent("nutriment", 8)
		reagents.add_reagent("water", 5)
		bitesize = 4

/obj/item/reagent_containers/food/snacks/stewedsoymeat
	name = "Stewed Soy Meat"
	desc = "Even non-vegetarians will LOVE this!"
	icon_state = "stewedsoymeat"
	trash = /obj/item/trash/plate
	New()
		..()
		reagents.add_reagent("nutriment", 8)
		bitesize = 2

/obj/item/reagent_containers/food/snacks/boiledspagetti
	name = "Boiled Spagetti"
	desc = "A plain dish of noodles, this sucks."
	icon_state = "spagettiboiled"
	trash = /obj/item/trash/plate
	filling_color = "#FCEE81"

	New()
		..()
		reagents.add_reagent("nutriment", 2)
		bitesize = 2

/obj/item/reagent_containers/food/snacks/boiledrice
	name = "Boiled Rice"
	desc = "A boring dish of boring rice."
	icon_state = "boiledrice"
	trash = /obj/item/trash/snack_bowl
	filling_color = "#FFFBDB"

	New()
		..()
		reagents.add_reagent("nutriment", 2)
		bitesize = 2

/obj/item/reagent_containers/food/snacks/ricepudding
	name = "Rice Pudding"
	desc = "Where's the Jam!"
	icon_state = "rpudding"
	trash = /obj/item/trash/snack_bowl
	filling_color = "#FFFBDB"

	New()
		..()
		reagents.add_reagent("nutriment", 4)
		bitesize = 2

/obj/item/reagent_containers/food/snacks/pastatomato
	name = "Spagetti"
	desc = "Spaghetti and crushed tomatoes. Just like your abusive father used to make!"
	icon_state = "pastatomato"
	trash = /obj/item/trash/plate
	filling_color = "#DE4545"

	New()
		..()
		reagents.add_reagent("nutriment", 6)
		reagents.add_reagent("tomatojuice", 10)
		bitesize = 4

/obj/item/reagent_containers/food/snacks/meatballspagetti
	name = "Spagetti & Meatballs"
	desc = "Now thats a nic'e meatball!"
	icon_state = "meatballspagetti"
	trash = /obj/item/trash/plate
	filling_color = "#DE4545"

	New()
		..()
		reagents.add_reagent("nutriment", 8)
		bitesize = 2

/obj/item/reagent_containers/food/snacks/spesslaw
	name = "Spesslaw"
	desc = "A lawyers favourite"
	icon_state = "spesslaw"
	filling_color = "#DE4545"

	New()
		..()
		reagents.add_reagent("nutriment", 8)
		bitesize = 2

/obj/item/reagent_containers/food/snacks/sspesslaw
	name = "Sauced Spesslaw"
	desc = "So Itallian"
	icon_state = "sspesslaw"
	filling_color = "#DE4545"

	New()
		..()
		reagents.add_reagent("nutriment", 20)
		bitesize = 6

/obj/item/reagent_containers/food/snacks/poppypretzel
	name = "Poppy Pretzel"
	desc = "A large soft pretzel full of POP!"
	icon_state = "poppypretzel"
	filling_color = "#AB7D2E"

	New()
		..()
		reagents.add_reagent("nutriment", 5)
		bitesize = 2

/obj/item/reagent_containers/food/snacks/carrotfries
	name = "Carrot Fries"
	desc = "Tasty fries from fresh Carrots."
	icon_state = "carrotfries"
	trash = /obj/item/trash/plate
	filling_color = "#FAA005"

	New()
		..()
		reagents.add_reagent("nutriment", 3)
		reagents.add_reagent("oculine", 3)
		bitesize = 2

/obj/item/reagent_containers/food/snacks/superbiteburger
	name = "Super Bite Burger"
	desc = "This is a mountain of a burger. FOOD!"
	icon_state = "superbiteburger"
	filling_color = "#CCA26A"

	New()
		..()
		reagents.add_reagent("nutriment", 40)
		bitesize = 10

/obj/item/reagent_containers/food/snacks/candiedapple
	name = "Candied Apple"
	desc = "An apple coated in sugary sweetness."
	icon_state = "candiedapple"
	filling_color = "#F21873"

	New()
		..()
		reagents.add_reagent("nutriment", 3)
		bitesize = 3

/obj/item/reagent_containers/food/snacks/applepie
	name = "Apple Pie"
	desc = "A pie containing sweet sweet love...or apple."
	icon_state = "applepie"
	filling_color = "#E0EDC5"

	New()
		..()
		reagents.add_reagent("nutriment", 4)
		bitesize = 3


/obj/item/reagent_containers/food/snacks/cherrypie
	name = "Cherry Pie"
	desc = "Taste so good, make a grown man cry."
	icon_state = "cherrypie"
	filling_color = "#FF525A"

	New()
		..()
		reagents.add_reagent("nutriment", 4)
		bitesize = 3

/obj/item/reagent_containers/food/snacks/twobread
	name = "Two Bread"
	desc = "It is very bitter and winy."
	icon_state = "twobread"
	filling_color = "#DBCC9A"

	New()
		..()
		reagents.add_reagent("nutriment", 2)
		bitesize = 3

/obj/item/reagent_containers/food/snacks/jellysandwich
	name = "Jelly Sandwich"
	desc = "You wish you had some peanut butter to go with this..."
	icon_state = "jellysandwich"
	trash = /obj/item/trash/plate
	filling_color = "#9E3A78"

	New()
		..()
		reagents.add_reagent("nutriment", 2)
		bitesize = 3

/obj/item/reagent_containers/food/snacks/jellysandwich/cherry
	New()
		..()
		reagents.add_reagent("cherryjelly", 5)

/obj/item/reagent_containers/food/snacks/mint
	name = "mint"
	desc = "it is only wafer thin."
	icon_state = "mint"
	filling_color = "#F2F2F2"

	New()
		..()
		reagents.add_reagent("minttoxin", 1)
		bitesize = 1

/obj/item/reagent_containers/food/snacks/mushroomsoup
	name = "chantrelle soup"
	desc = "A delicious and hearty mushroom soup."
	icon_state = "mushroomsoup"
	trash = /obj/item/trash/snack_bowl
	filling_color = "#E386BF"

	New()
		..()
		reagents.add_reagent("nutriment", 8)
		bitesize = 3

/obj/item/reagent_containers/food/snacks/plumphelmetbiscuit
	name = "plump helmet biscuit"
	desc = "This is a finely-prepared plump helmet biscuit. The ingredients are exceptionally minced plump helmet, and well-minced dwarven wheat flour."
	icon_state = "phelmbiscuit"
	filling_color = "#CFB4C4"

	New()
		..()
		if(prob(10))
			name = "exceptional plump helmet biscuit"
			desc = "Microwave is taken by a fey mood! It has cooked an exceptional plump helmet biscuit!"
			reagents.add_reagent("nutriment", 8)
			reagents.add_reagent("dwine", 5)
			reagents.add_reagent("omnizine", 5)
			bitesize = 2
		else
			reagents.add_reagent("nutriment", 5)
			reagents.add_reagent("dwine", 5)
			bitesize = 2

/obj/item/reagent_containers/food/snacks/chawanmushi
	name = "chawanmushi"
	desc = "A legendary egg custard that makes friends out of enemies. Probably too hot for a cat to eat."
	icon_state = "chawanmushi"
	trash = /obj/item/trash/snack_bowl
	filling_color = "#F0F2E4"

	New()
		..()
		reagents.add_reagent("nutriment", 5)
		bitesize = 1

/obj/item/reagent_containers/food/snacks/beetsoup
	name = "beet soup"
	desc = "Wait, how do you spell it again..?"
	icon_state = "beetsoup"
	trash = /obj/item/trash/snack_bowl
	filling_color = "#FAC9FF"

	New()
		..()
		switch(rand(1,6))
			if(1)
				name = "borsch"
			if(2)
				name = "bortsch"
			if(3)
				name = "borstch"
			if(4)
				name = "borsh"
			if(5)
				name = "borshch"
			if(6)
				name = "borscht"
		reagents.add_reagent("nutriment", 8)
		bitesize = 2

/obj/item/reagent_containers/food/snacks/tossedsalad
	name = "tossed salad"
	desc = "A proper salad, basic and simple, with little bits of carrot, tomato and apple intermingled. Vegan!"
	icon_state = "herbsalad"
	trash = /obj/item/trash/snack_bowl
	filling_color = "#76B87F"

	New()
		..()
		reagents.add_reagent("nutriment", 8)
		bitesize = 3

/obj/item/reagent_containers/food/snacks/validsalad
	name = "valid salad"
	desc = "It's just a salad of questionable 'herbs' with meatballs and fried potato slices. Nothing suspicious about it."
	icon_state = "validsalad"
	trash = /obj/item/trash/snack_bowl
	filling_color = "#76B87F"

	New()
		..()
		reagents.add_reagent("nutriment", 8)
		bitesize = 3

/obj/item/reagent_containers/food/snacks/appletart
	name = "golden apple streusel tart"
	desc = "A tasty dessert that won't make it through a metal detector."
	icon_state = "gappletart"
	trash = /obj/item/trash/plate
	filling_color = "#FFFF00"

	New()
		..()
		reagents.add_reagent("nutriment", 8)
		reagents.add_reagent("gold", 5)
		bitesize = 3

/////////////////////////////////////////////////Sliceable////////////////////////////////////////
// All the food items that can be sliced into smaller bits like Meatbread and Cheesewheels

// sliceable is just an organization type path, it doesn't have any additional code or variables tied to it.

/obj/item/reagent_containers/food/snacks/sliceable/meatbread
	name = "meatbread loaf"
	desc = "The culinary base of every self-respecting eloquen/tg/entleman."
	icon_state = "meatbread"
	slice_path = /obj/item/reagent_containers/food/snacks/meatbreadslice
	slices_num = 5
	filling_color = "#FF7575"
	New()
		..()
		reagents.add_reagent("nutriment", 30)
		bitesize = 2

/obj/item/reagent_containers/food/snacks/meatbreadslice
	name = "meatbread slice"
	desc = "A slice of delicious meatbread."
	icon_state = "meatbreadslice"
	trash = /obj/item/trash/plate
	filling_color = "#FF7575"
	bitesize = 2

/obj/item/reagent_containers/food/snacks/sliceable/xenomeatbread
	name = "xenomeatbread loaf"
	desc = "The culinary base of every self-respecting eloquen/tg/entleman. Extra Heretical."
	icon_state = "xenomeatbread"
	slice_path = /obj/item/reagent_containers/food/snacks/xenomeatbreadslice
	slices_num = 5
	filling_color = "#8AFF75"
	New()
		..()
		reagents.add_reagent("nutriment", 30)
		bitesize = 2

/obj/item/reagent_containers/food/snacks/xenomeatbreadslice
	name = "xenomeatbread slice"
	desc = "A slice of delicious meatbread. Extra Heretical."
	icon_state = "xenobreadslice"
	trash = /obj/item/trash/plate
	filling_color = "#8AFF75"
	bitesize = 2

/obj/item/reagent_containers/food/snacks/sliceable/bananabread
	name = "Banana-nut bread"
	desc = "A heavenly and filling treat."
	icon_state = "bananabread"
	slice_path = /obj/item/reagent_containers/food/snacks/bananabreadslice
	slices_num = 5
	filling_color = "#EDE5AD"
	New()
		..()
		reagents.add_reagent("banana", 20)
		reagents.add_reagent("nutriment", 20)
		bitesize = 2

/obj/item/reagent_containers/food/snacks/bananabreadslice
	name = "Banana-nut bread slice"
	desc = "A slice of delicious banana bread."
	icon_state = "bananabreadslice"
	trash = /obj/item/trash/plate
	filling_color = "#EDE5AD"
	bitesize = 2

/obj/item/reagent_containers/food/snacks/sliceable/tofubread
	name = "Tofubread"
	icon_state = "Like meatbread but for vegetarians. Not guaranteed to give superpowers."
	icon_state = "tofubread"
	slice_path = /obj/item/reagent_containers/food/snacks/tofubreadslice
	slices_num = 5
	filling_color = "#F7FFE0"
	New()
		..()
		reagents.add_reagent("nutriment", 30)
		bitesize = 2

/obj/item/reagent_containers/food/snacks/tofubreadslice
	name = "Tofubread slice"
	desc = "A slice of delicious tofubread."
	icon_state = "tofubreadslice"
	trash = /obj/item/trash/plate
	filling_color = "#F7FFE0"
	bitesize = 2


/obj/item/reagent_containers/food/snacks/sliceable/carrotcake
	name = "Carrot Cake"
	desc = "A favorite desert of a certain wascally wabbit. Not a lie."
	icon_state = "carrotcake"
	slice_path = /obj/item/reagent_containers/food/snacks/carrotcakeslice
	slices_num = 5
	filling_color = "#FFD675"
	New()
		..()
		reagents.add_reagent("nutriment", 25)
		reagents.add_reagent("oculine", 10)
		bitesize = 2

/obj/item/reagent_containers/food/snacks/carrotcakeslice
	name = "Carrot Cake slice"
	desc = "Carrotty slice of Carrot Cake, carrots are good for your eyes! Also not a lie."
	icon_state = "carrotcake_slice"
	trash = /obj/item/trash/plate
	filling_color = "#FFD675"
	bitesize = 2

/obj/item/reagent_containers/food/snacks/sliceable/braincake
	name = "Brain Cake"
	desc = "A squishy cake-thing."
	icon_state = "braincake"
	slice_path = /obj/item/reagent_containers/food/snacks/braincakeslice
	slices_num = 5
	filling_color = "#E6AEDB"
	New()
		..()
		reagents.add_reagent("nutriment", 25)
		reagents.add_reagent("mannitol", 10)
		bitesize = 2

/obj/item/reagent_containers/food/snacks/braincakeslice
	name = "Brain Cake slice"
	desc = "Lemme tell you something about prions. THEY'RE DELICIOUS."
	icon_state = "braincakeslice"
	trash = /obj/item/trash/plate
	filling_color = "#E6AEDB"
	bitesize = 2

/obj/item/reagent_containers/food/snacks/sliceable/cheesecake
	name = "Cheese Cake"
	desc = "DANGEROUSLY cheesy."
	icon_state = "cheesecake"
	slice_path = /obj/item/reagent_containers/food/snacks/cheesecakeslice
	slices_num = 5
	filling_color = "#FAF7AF"
	New()
		..()
		reagents.add_reagent("nutriment", 25)
		bitesize = 2

/obj/item/reagent_containers/food/snacks/cheesecakeslice
	name = "Cheese Cake slice"
	desc = "Slice of pure cheestisfaction"
	icon_state = "cheesecake_slice"
	trash = /obj/item/trash/plate
	filling_color = "#FAF7AF"
	bitesize = 2

/obj/item/reagent_containers/food/snacks/sliceable/plaincake
	name = "Vanilla Cake"
	desc = "A plain cake, not a lie."
	icon_state = "plaincake"
	slice_path = /obj/item/reagent_containers/food/snacks/plaincakeslice
	slices_num = 5
	filling_color = "#F7EDD5"
	New()
		..()
		reagents.add_reagent("nutriment", 20)

/obj/item/reagent_containers/food/snacks/plaincakeslice
	name = "Vanilla Cake slice"
	desc = "Just a slice of cake, it is enough for everyone."
	icon_state = "plaincake_slice"
	trash = /obj/item/trash/plate
	filling_color = "#F7EDD5"
	bitesize = 2

/obj/item/reagent_containers/food/snacks/sliceable/orangecake
	name = "Orange Cake"
	desc = "A cake with added orange."
	icon_state = "orangecake"
	slice_path = /obj/item/reagent_containers/food/snacks/orangecakeslice
	slices_num = 5
	filling_color = "#FADA8E"
	New()
		..()
		reagents.add_reagent("nutriment", 20)

/obj/item/reagent_containers/food/snacks/orangecakeslice
	name = "Orange Cake slice"
	desc = "Just a slice of cake, it is enough for everyone."
	icon_state = "orangecake_slice"
	trash = /obj/item/trash/plate
	filling_color = "#FADA8E"
	bitesize = 2

/obj/item/reagent_containers/food/snacks/sliceable/limecake
	name = "Lime Cake"
	desc = "A cake with added lime."
	icon_state = "limecake"
	slice_path = /obj/item/reagent_containers/food/snacks/limecakeslice
	slices_num = 5
	filling_color = "#CBFA8E"
	New()
		..()
		reagents.add_reagent("nutriment", 20)

/obj/item/reagent_containers/food/snacks/limecakeslice
	name = "Lime Cake slice"
	desc = "Just a slice of cake, it is enough for everyone."
	icon_state = "limecake_slice"
	trash = /obj/item/trash/plate
	filling_color = "#CBFA8E"
	bitesize = 2

/obj/item/reagent_containers/food/snacks/sliceable/lemoncake
	name = "Lemon Cake"
	desc = "A cake with added lemon."
	icon_state = "lemoncake"
	slice_path = /obj/item/reagent_containers/food/snacks/lemoncakeslice
	slices_num = 5
	filling_color = "#FAFA8E"
	New()
		..()
		reagents.add_reagent("nutriment", 20)

/obj/item/reagent_containers/food/snacks/lemoncakeslice
	name = "Lemon Cake slice"
	desc = "Just a slice of cake, it is enough for everyone."
	icon_state = "lemoncake_slice"
	trash = /obj/item/trash/plate
	filling_color = "#FAFA8E"
	bitesize = 2

/obj/item/reagent_containers/food/snacks/sliceable/chocolatecake
	name = "Chocolate Cake"
	desc = "A cake with added chocolate"
	icon_state = "chocolatecake"
	slice_path = /obj/item/reagent_containers/food/snacks/chocolatecakeslice
	slices_num = 5
	filling_color = "#805930"
	New()
		..()
		reagents.add_reagent("nutriment", 20)

/obj/item/reagent_containers/food/snacks/chocolatecakeslice
	name = "Chocolate Cake slice"
	desc = "Just a slice of cake, it is enough for everyone."
	icon_state = "chocolatecake_slice"
	trash = /obj/item/trash/plate
	filling_color = "#805930"
	bitesize = 2

/obj/item/reagent_containers/food/snacks/sliceable/cheesewheel
	name = "Cheese wheel"
	desc = "A big wheel of delcious Cheddar."
	icon_state = "cheesewheel"
	slice_path = /obj/item/reagent_containers/food/snacks/cheesewedge
	slices_num = 5
	filling_color = "#FFF700"
	New()
		..()
		reagents.add_reagent("nutriment", 20)
		bitesize = 2

/obj/item/reagent_containers/food/snacks/cheesewedge
	name = "Cheese wedge"
	desc = "A wedge of delicious Cheddar. The cheese wheel it was cut from can't have gone far."
	icon_state = "cheesewedge"
	filling_color = "#FFF700"
	bitesize = 2

/obj/item/reagent_containers/food/snacks/sliceable/birthdaycake
	name = "Birthday Cake"
	desc = "Happy Birthday..."
	icon_state = "birthdaycake"
	slice_path = /obj/item/reagent_containers/food/snacks/birthdaycakeslice
	slices_num = 5
	filling_color = "#FFD6D6"
	New()
		..()
		reagents.add_reagent("nutriment", 20)
		reagents.add_reagent("sprinkles", 10)
		bitesize = 3

/obj/item/reagent_containers/food/snacks/birthdaycakeslice
	name = "Birthday Cake slice"
	desc = "A slice of your birthday"
	icon_state = "birthdaycakeslice"
	trash = /obj/item/trash/plate
	filling_color = "#FFD6D6"
	bitesize = 2

/obj/item/reagent_containers/food/snacks/sliceable/bread
	name = "Bread"
	icon_state = "Some plain old Earthen bread."
	icon_state = "bread"
	slice_path = /obj/item/reagent_containers/food/snacks/breadslice
	slices_num = 5
	filling_color = "#FFE396"

	New()
		..()
		reagents.add_reagent("nutriment", 6)
		bitesize = 2

/obj/item/reagent_containers/food/snacks/breadslice
	name = "Bread slice"
	desc = "A slice of home."
	icon_state = "breadslice"
	trash = /obj/item/trash/plate
	filling_color = "#D27332"
	bitesize = 2


/obj/item/reagent_containers/food/snacks/sliceable/creamcheesebread
	name = "Cream Cheese Bread"
	desc = "Yum yum yum!"
	icon_state = "creamcheesebread"
	slice_path = /obj/item/reagent_containers/food/snacks/creamcheesebreadslice
	slices_num = 5
	filling_color = "#FFF896"
	New()
		..()
		reagents.add_reagent("nutriment", 20)
		bitesize = 2

/obj/item/reagent_containers/food/snacks/creamcheesebreadslice
	name = "Cream Cheese Bread slice"
	desc = "A slice of yum!"
	icon_state = "creamcheesebreadslice"
	trash = /obj/item/trash/plate
	filling_color = "#FFF896"
	bitesize = 2


/obj/item/reagent_containers/food/snacks/watermelonslice
	name = "Watermelon Slice"
	desc = "A slice of watery goodness."
	icon_state = "watermelonslice"
	filling_color = "#FF3867"
	bitesize = 2


/obj/item/reagent_containers/food/snacks/sliceable/applecake
	name = "Apple Cake"
	desc = "A cake centred with Apple"
	icon_state = "applecake"
	slice_path = /obj/item/reagent_containers/food/snacks/applecakeslice
	slices_num = 5
	filling_color = "#EBF5B8"
	New()
		..()
		reagents.add_reagent("nutriment", 15)

/obj/item/reagent_containers/food/snacks/applecakeslice
	name = "Apple Cake slice"
	desc = "A slice of heavenly cake."
	icon_state = "applecakeslice"
	trash = /obj/item/trash/plate
	filling_color = "#EBF5B8"
	bitesize = 2

/obj/item/reagent_containers/food/snacks/sliceable/pumpkinpie
	name = "Pumpkin Pie"
	desc = "A delicious treat for the autumn months."
	icon_state = "pumpkinpie"
	slice_path = /obj/item/reagent_containers/food/snacks/pumpkinpieslice
	slices_num = 5
	filling_color = "#F5B951"

	New()
		..()
		reagents.add_reagent("nutriment", 15)

/obj/item/reagent_containers/food/snacks/pumpkinpieslice
	name = "Pumpkin Pie slice"
	desc = "A slice of pumpkin pie, with whipped cream on top. Perfection."
	icon_state = "pumpkinpieslice"
	trash = /obj/item/trash/plate
	filling_color = "#F5B951"
	bitesize = 2

/obj/item/reagent_containers/food/snacks/cracker
	name = "Cracker"
	desc = "It's a salted cracker."
	icon_state = "cracker"
	filling_color = "#F5DEB8"

	New()
		..()
		reagents.add_reagent("nutriment", 1)



/////////////////////////////////////////////////PIZZA////////////////////////////////////////

/obj/item/reagent_containers/food/snacks/sliceable/pizza
	slices_num = 6
	filling_color = "#BAA14C"

/obj/item/reagent_containers/food/snacks/sliceable/pizza/margherita
	name = "Margherita"
	desc = "The most cheezy pizza in galaxy"
	icon_state = "pizzamargherita"
	slice_path = /obj/item/reagent_containers/food/snacks/margheritaslice
	slices_num = 6
	New()
		..()
		reagents.add_reagent("nutriment", 40)
		reagents.add_reagent("tomatojuice", 6)
		bitesize = 2

/obj/item/reagent_containers/food/snacks/margheritaslice
	name = "Margherita slice"
	desc = "A slice of the most cheezy pizza in galaxy"
	icon_state = "pizzamargheritaslice"
	filling_color = "#BAA14C"
	bitesize = 2

/obj/item/reagent_containers/food/snacks/sliceable/pizza/meatpizza
	name = "Meatpizza"
	desc = "" //TODO:
	icon_state = "meatpizza"
	slice_path = /obj/item/reagent_containers/food/snacks/meatpizzaslice
	slices_num = 6
	New()
		..()
		reagents.add_reagent("nutriment", 50)
		reagents.add_reagent("tomatojuice", 6)
		bitesize = 2

/obj/item/reagent_containers/food/snacks/meatpizzaslice
	name = "Meatpizza slice"
	desc = "A slice of " //TODO:
	icon_state = "meatpizzaslice"
	filling_color = "#BAA14C"
	bitesize = 2

/obj/item/reagent_containers/food/snacks/sliceable/pizza/mushroompizza
	name = "Mushroompizza"
	desc = "Very special pizza"
	icon_state = "mushroompizza"
	slice_path = /obj/item/reagent_containers/food/snacks/mushroompizzaslice
	slices_num = 6
	New()
		..()
		reagents.add_reagent("nutriment", 35)
		bitesize = 2

/obj/item/reagent_containers/food/snacks/mushroompizzaslice
	name = "Mushroompizza slice"
	desc = "Maybe it is the last slice of pizza in your life."
	icon_state = "mushroompizzaslice"
	filling_color = "#BAA14C"
	bitesize = 2

/obj/item/reagent_containers/food/snacks/sliceable/pizza/vegetablepizza
	name = "Vegetable pizza"
	desc = "No one of Tomatos Sapiens were harmed during making this pizza"
	icon_state = "vegetablepizza"
	slice_path = /obj/item/reagent_containers/food/snacks/vegetablepizzaslice
	slices_num = 6
	New()
		..()
		reagents.add_reagent("nutriment", 30)
		reagents.add_reagent("tomatojuice", 6)
		reagents.add_reagent("oculine", 12)
		bitesize = 2

/obj/item/reagent_containers/food/snacks/vegetablepizzaslice
	name = "Vegetable pizza slice"
	desc = "A slice of the most green pizza of all pizzas not containing green ingredients "
	icon_state = "vegetablepizzaslice"
	filling_color = "#BAA14C"
	bitesize = 2

/obj/item/pizzabox
	name = "pizza box"
	desc = "A box suited for pizzas."
	icon = 'icons/obj/food.dmi'
	icon_state = "pizzabox1"

	var/open = 0 // Is the box open?
	var/ismessy = 0 // Fancy mess on the lid
	var/obj/item/reagent_containers/food/snacks/sliceable/pizza/pizza // Content pizza
	var/list/boxes = list() // If the boxes are stacked, they come here
	var/boxtag = ""

/obj/item/pizzabox/update_icon()

	overlays = list()

	// Set appropriate description
	if( open && pizza )
		desc = "A box suited for pizzas. It appears to have a [pizza.name] inside."
	else if( boxes.len > 0 )
		desc = "A pile of boxes suited for pizzas. There appears to be [boxes.len + 1] boxes in the pile."

		var/obj/item/pizzabox/topbox = boxes[boxes.len]
		var/toptag = topbox.boxtag
		if( toptag != "" )
			desc = "[desc] The box on top has a tag, it reads: '[toptag]'."
	else
		desc = "A box suited for pizzas."

		if( boxtag != "" )
			desc = "[desc] The box has a tag, it reads: '[boxtag]'."

	// Icon states and overlays
	if( open )
		if( ismessy )
			icon_state = "pizzabox_messy"
		else
			icon_state = "pizzabox_open"

		if( pizza )
			var/image/pizzaimg = image("food.dmi", icon_state = pizza.icon_state)
			pizzaimg.pixel_y = -3
			overlays += pizzaimg

		return
	else
		// Stupid code because byondcode sucks
		var/doimgtag = 0
		if( boxes.len > 0 )
			var/obj/item/pizzabox/topbox = boxes[boxes.len]
			if( topbox.boxtag != "" )
				doimgtag = 1
		else
			if( boxtag != "" )
				doimgtag = 1

		if( doimgtag )
			var/image/tagimg = image("food.dmi", icon_state = "pizzabox_tag")
			tagimg.pixel_y = boxes.len * 3
			overlays += tagimg

	icon_state = "pizzabox[boxes.len+1]"

/obj/item/pizzabox/attack_hand( mob/user as mob )

	if( open && pizza )
		user.put_in_hands( pizza )

		user << "\red You take the [src.pizza] out of the [src]."
		src.pizza = null
		update_icon()
		return

	if( boxes.len > 0 )
		if( user.get_inactive_hand() != src )
			..()
			return

		var/obj/item/pizzabox/box = boxes[boxes.len]
		boxes -= box

		user.put_in_hands( box )
		user << "\red You remove the topmost [src] from your hand."
		box.update_icon()
		update_icon()
		return
	..()

/obj/item/pizzabox/attack_self( mob/user as mob )

	if( boxes.len > 0 )
		return

	open = !open

	if( open && pizza )
		ismessy = 1

	update_icon()

/obj/item/pizzabox/attackby( obj/item/I as obj, mob/user as mob )
	if( istype(I, /obj/item/pizzabox/) )
		var/obj/item/pizzabox/box = I

		if( !box.open && !src.open )
			// Make a list of all boxes to be added
			var/list/boxestoadd = list()
			boxestoadd += box
			for(var/obj/item/pizzabox/i in box.boxes)
				boxestoadd += i

			if( (boxes.len+1) + boxestoadd.len <= 5 )
				user.drop_item()

				box.loc = src
				box.boxes = list() // Clear the box boxes so we don't have boxes inside boxes. - Xzibit
				src.boxes.Add( boxestoadd )

				box.update_icon()
				update_icon()

				user << "\red You put the [box] ontop of the [src]!"
			else
				user << "\red The stack is too high!"
		else
			user << "\red Close the [box] first!"

		return

	if( istype(I, /obj/item/reagent_containers/food/snacks/sliceable/pizza/) ) // Long ass fucking object name

		if( src.open )
			user.drop_item()
			I.loc = src
			src.pizza = I

			update_icon()

			user << "\red You put the [I] in the [src]!"
		else
			user << "\red You try to push the [I] through the lid but it doesn't work!"
		return

	if( istype(I, /obj/item/pen/) )

		if( src.open )
			return

		var/t = input("Enter what you want to add to the tag:", "Write", null, null) as text

		var/obj/item/pizzabox/boxtotagto = src
		if( boxes.len > 0 )
			boxtotagto = boxes[boxes.len]

		boxtotagto.boxtag = copytext("[boxtotagto.boxtag][t]", 1, 30)

		update_icon()
		return
	..()

/obj/item/pizzabox/margherita/New()
	pizza = new /obj/item/reagent_containers/food/snacks/sliceable/pizza/margherita(src)
	boxtag = "Margherita Deluxe"

/obj/item/pizzabox/vegetable/New()
	pizza = new /obj/item/reagent_containers/food/snacks/sliceable/pizza/vegetablepizza(src)
	boxtag = "Gourmet Vegatable"

/obj/item/pizzabox/mushroom/New()
	pizza = new /obj/item/reagent_containers/food/snacks/sliceable/pizza/mushroompizza(src)
	boxtag = "Mushroom Special"

/obj/item/pizzabox/meat/New()
	pizza = new /obj/item/reagent_containers/food/snacks/sliceable/pizza/meatpizza(src)
	boxtag = "Meatlover's Supreme"

/obj/item/reagent_containers/food/snacks/dionaroast
	name = "roast diona"
	desc = "It's like an enormous, leathery carrot. With an eye."
	icon_state = "dionaroast"
	trash = /obj/item/trash/plate
	filling_color = "#75754B"

	New()
		..()
		reagents.add_reagent("nutriment", 6)
		reagents.add_reagent("radium", 2)
		bitesize = 2

/////////////////
////LUNA FOOD////
/////////////////
/obj/item/reagent_containers/food/snacks/rawsticks
	name = "raw potato sticks"
	desc = "Maybe you should cook it first?"
	icon_state = "rawsticks"
	New()
		..()
		reagents.add_reagent("nutriment", 5)
		bitesize = 3

/obj/item/reagent_containers/food/snacks/dough
	name = "dough"
	desc = "A dough."
	icon_state = "dough"
	New()
		..()
		reagents.add_reagent("nutriment", 10)
		bitesize = 3



/obj/item/reagent_containers/food/snacks/flatdough
	name = "flat dough"
	desc = "A flattened dough."
	icon_state = "flat dough"
	slice_path = /obj/item/reagent_containers/food/snacks/doughslice
	slices_num = 3
	New()
		..()
		reagents.add_reagent("nutriment", 10)
		bitesize = 3


/obj/item/reagent_containers/food/snacks/doughslice
	name = "dough slice"
	desc = "Make your magic."
	icon_state = "doughslice"
	New()
		..()
		reagents.add_reagent("nutriment", 3)
		bitesize = 1


/obj/item/reagent_containers/food/snacks/rawcutlet
	name = "raw cutlet"
	desc = "A thin piece of meat."
	icon_state = "rawcutlet"
	New()
		..()
		reagents.add_reagent("nutriment", 5)
		bitesize = 2



/obj/item/reagent_containers/food/snacks/rawmeatball
	name = "raw meatball"
	desc = "A raw meatball."
	icon_state = "rawmeatball"
	New()
		..()
		reagents.add_reagent("nutriment", 5)
		bitesize = 2




///////////////////////////////////////////////////////
//                                                   //
//                       Sauces                      //
//                                                   //
///////////////////////////////////////////////////////

/*obj/item/reagent_containers/food/condiment/ketchup
	name = "ketchup"
	desc = "Goes well with meat."
	icon_state = "ketchup"
	New()
		..()
		reagents.add_reagent("ketchup", 1)
		bitesize = 10*/ //in condiment.dm


///////////////////////////////////////////////////////
//                                                   //
//                      Bakery                       //
//                                                   //
///////////////////////////////////////////////////////

/obj/item/reagent_containers/food/snacks/candycane
	name = "candy cane"
	desc = "Sweet and sticky."
	icon_state = "candycane"
	New()
		..()
		reagents.add_reagent("nutriment", 10)
		bitesize = 3




/obj/item/reagent_containers/food/snacks/pattyapple
	name = "apple patty"
	desc = "Like grandma's."
	icon_state = "pattyapple"
	New()
		..()
		reagents.add_reagent("nutriment", 10)
		bitesize = 3



/obj/item/reagent_containers/food/snacks/bun
	name = "bun"
	desc = "A base for any self-respecting burger."
	icon_state = "bun"
	New()
		..()
		reagents.add_reagent("nutriment", 8)
		bitesize = 3



/obj/item/reagent_containers/food/snacks/flatbread
	name = "flatbread"
	desc = "Bland but filling."
	icon_state = "flatbread"
	New()
		..()
		reagents.add_reagent("nutriment", 8)
		bitesize = 3


/obj/item/reagent_containers/food/snacks/poo
	name = "poo"
	desc = "It's a poo. How disgusting!"
	icon = 'icons/obj/poop.dmi'
	icon_state = "poop2"
	item_state = "poop"
	maybecomeflesh = 1
/obj/item/reagent_containers/food/snacks/poo/New()
	..()
	icon_state = pick("poop1", "poop2", "poop3", "poop4", "poop5", "poop6", "poop7")
	reagents.add_reagent("poo", 10)
	bitesize = 3

/*	proc/poo_splat(atom/target)
		if(reagents.total_volume)
			if(ismob(target))
				src.reagents.reaction(target, TOUCH)
			if(isturf(target))
				src.reagents.reaction(get_turf(target))
			if(isobj(target))
				src.reagents.reaction(target, TOUCH)
		spawn(5) src.reagents.clear_reagents()
		playsound(src.loc, "squish.ogg", 40, 1)
		qdel(src)
*/
/obj/item/reagent_containers/food/snacks/poo/throw_impact(atom/hit_atom)
	..()
	if(istype(hit_atom, /turf/simulated/floor/open))//If it's an open space just fall through it.
		return
	if(reagents.total_volume)
		src.reagents.reaction(get_turf(hit_atom))
	spawn(5) src.reagents.clear_reagents()
	playsound(src.loc, "squish.ogg", 40, 1)
	qdel(src)




///////////////////////////////////////////////////////
//                                                   //
//                    Cooked food                    //
//                                                   //
///////////////////////////////////////////////////////




/obj/item/reagent_containers/food/snacks/sbakedpotato
	name = "sauced potatoes"
	desc = "It smells and tastes great!"
	icon_state = "sbakedpotato"
	New()
		..()
		reagents.add_reagent("nutriment", 10)
		bitesize = 3



/*obj/item/reagent_containers/food/snacks/sspaghetti
	name = "sauced spaghetti"
	desc = "Long and tasty - 'Tomato Noodles'."
	icon_state = "sspaghetti"
	New()
		..()
		reagents.add_reagent("nutriment", 8)
		bitesize = 3*/

/obj/item/reagent_containers/food/snacks/smeatballspagetti
	name = "sauced spaghetti with meatballs"
	desc = "A tasty dinner - 'Spaghetti Terror'."
	icon_state = "smeatspaghetti"
	New()
		..()
		reagents.add_reagent("nutriment", 15)
		bitesize = 5


/obj/item/reagent_containers/food/snacks/somelette
	name = "sauced omelette"
	desc = "A saucy dish - 'Bloody Alien'."
	icon_state = "somelette"
	New()
		..()
		reagents.add_reagent("nutriment", 10)
		bitesize = 3



/obj/item/reagent_containers/food/snacks/ssteak
	name = "sauced steak"
	desc = "A sauced meat steak."
	icon_state = "smeatstake"
	New()
		..()
		reagents.add_reagent("nutriment", 15)
		bitesize = 6


/obj/item/reagent_containers/food/snacks/cutlet
	name = "cutlet"
	desc = "A tasty meat slice - 'Cutlet'."
	icon_state = "cutlet"
	slice_path = /obj/item/reagent_containers/food/snacks/bacon
	slices_num = 1
	New()
		..()
		reagents.add_reagent("nutriment", 10)
		bitesize = 3

/obj/item/reagent_containers/food/snacks/bacon
	name = "bacon strips"
	desc = "It goes good with eggs."
	icon_state = "bacon"
	New()
		..()
		reagents.add_reagent("nutriment", 10)
		bitesize = 3




///////////////////////////////////////////////////////
//                                                   //
//                    Burgers                        //
//                                                   //
///////////////////////////////////////////////////////

/obj/item/reagent_containers/food/snacks/hotdog
	name = "hotdog"
	desc = "Unrelated to dogs."
	icon_state = "hotdog"
	New()
		..()
		reagents.add_reagent("nutriment", 10)
		bitesize = 3


/obj/item/reagent_containers/food/snacks/shotdog
	name = "sauced hotdog"
	desc = "Unrelated to dogs - 'Royal Hotdog'."
	icon_state = "shotdog"
	New()
		..()
		reagents.add_reagent("nutriment", 12)
		bitesize = 3


/obj/item/reagent_containers/food/snacks/sburger
	name = "sauced burger"
	desc = "A fast way to become fat - 'Space Burger'."
	icon_state = "shburger"
	New()
		..()
		reagents.add_reagent("nutriment", 12)
		bitesize = 3



/obj/item/reagent_containers/food/snacks/shamburger
	name = "sauced hamburger"
	desc = "A fast way to become fat - 'Star Hamburger'."
	icon_state = "shburger"
	New()
		..()
		reagents.add_reagent("nutriment", 12)
		bitesize = 3


/obj/item/reagent_containers/food/snacks/taco
	name = "taco"
	desc = "Take a bite!"
	icon_state = "taco"
	New()
		..()
		reagents.add_reagent("nutriment", 10)
		bitesize = 3



///////////////////////////////////////////////////////
//           Cutting other food items .              //
///////////////////////////////////////////////////////


// Potato in potato sticks
/obj/item/reagent_containers/food/snacks/grown/potato/attackby(obj/item/W as obj, mob/user as mob)
	if(istype(W,/obj/item/kitchenknife))
		var/turf/spawnloc = foodloc(user, src)
		new /obj/item/reagent_containers/food/snacks/rawsticks(spawnloc)
		user << "You cut the potato."
		qdel(src)


// Meat into raw cutlets (x3)
/*obj/item/reagent_containers/food/snacks/meat/attackby(obj/item/W as obj, mob/user as mob)
	if(istype(W,/obj/item/kitchen/utensil/knife))
		var/turf/spawnloc = foodloc(user, src)
		new /obj/item/reagent_containers/food/snacks/rawcutlet(spawnloc)
		new /obj/item/reagent_containers/food/snacks/rawcutlet(spawnloc)
		new /obj/item/reagent_containers/food/snacks/rawcutlet(spawnloc)
		user << "You cut the meat into slices."
		qdel(src)*/

// Steak into cutlets (x3)
/*obj/item/reagent_containers/food/snacks/steak/attackby(obj/item/kitchen/utensil/knife/W as obj, mob/user as mob)
	if(istype(W))
		var/turf/spawnloc = foodloc(user, src)
		new /obj/item/reagent_containers/food/snacks/cutlet(spawnloc)
		new /obj/item/reagent_containers/food/snacks/cutlet(spawnloc)
		new /obj/item/reagent_containers/food/snacks/cutlet(spawnloc)
		user << "You cut the steak into slices."
		qdel(src)
		return
	..()*/

// Sauced steak into cutlets (x3)
/*obj/item/reagent_containers/food/snacks/ssteak/attackby(obj/item/W as obj, mob/user as mob)
	if(istype(W,/obj/item/kitchen/utensil/knife))
		var/turf/spawnloc = foodloc(user, src)
		new /obj/item/reagent_containers/food/snacks/cutlet(spawnloc)
		new /obj/item/reagent_containers/food/snacks/cutlet(spawnloc)
		new /obj/item/reagent_containers/food/snacks/cutlet(spawnloc)
		user << "You cut the steak into slices."
		qdel(src)*/

///////////////////////////////////////////////////////
//                                                   //
//                  Combining foods                  //
//                                                   //
///////////////////////////////////////////////////////



// Flour + egg = dough
/obj/item/reagent_containers/food/drinks/flour/attackby(obj/item/W as obj, mob/user as mob)
	if(istype(W,/obj/item/reagent_containers/food/snacks/egg))
		var/turf/spawnloc = foodloc(user, src)
		if(src.reagents.total_volume < 5)
			user << "<span  class='notice'>There's not enough flour left to make a dough.</span>"
			return
		src.reagents.remove_reagent("flour", 5, 1)//Deleting 5 flour from the flour sack.
		new /obj/item/reagent_containers/food/snacks/dough(spawnloc)
		user << "You make a dough."
		qdel(W)

// Dough + rolling pin = flat dough
/obj/item/reagent_containers/food/snacks/dough/attackby(obj/item/W as obj, mob/user as mob)
	if(istype(W,/obj/item/kitchen/rollingpin))
		var/turf/spawnloc = foodloc(user, src)
		new /obj/item/reagent_containers/food/snacks/flatdough(spawnloc)
		user << "You flatten the dough."
		qdel(src)


/obj/item/reagent_containers/food/snacks/bun/attackby(obj/item/W as obj, mob/user as mob)
	// Bun + meatball = burger
	if(istype(W,/obj/item/reagent_containers/food/snacks/faggot))
		var/turf/spawnloc = foodloc(user, src)
		new /obj/item/reagent_containers/food/snacks/monkeyburger(spawnloc)
		user << "You make a burger."
		qdel(W)
		qdel(src)

	// Bun + cutlet = hamburger
	else if(istype(W,/obj/item/reagent_containers/food/snacks/cutlet))
		var/turf/spawnloc = foodloc(user, src)
		new /obj/item/reagent_containers/food/snacks/hamburger(spawnloc)
		user << "You make a hamburger."
		qdel(W)
		qdel(src)

	// Bun + sausage = hotdog
	else if(istype(W,/obj/item/reagent_containers/food/snacks/sausage))
		var/turf/spawnloc = foodloc(user, src)
		new /obj/item/reagent_containers/food/snacks/hotdog(spawnloc)
		user << "You make a hotdog."
		qdel(W)
		qdel(src)

	//Bun + brain = brainburger
	else if(istype(W,/obj/item/reagent_containers/food/snacks/organ/brain))
		var/turf/spawnloc = foodloc(user, src)
		new /obj/item/reagent_containers/food/snacks/brainburger(spawnloc)
		user << "You make a braingurger."
		qdel(W)
		qdel(src)
	//Bun + syntiflesh = hamburger
	else if(istype(W,/obj/item/syntiflesh))
		var/turf/spawnloc = foodloc(user, src)
		new /obj/item/reagent_containers/food/snacks/monkeyburger(spawnloc)
		user << "You make a hamburger."
		qdel(W)
		qdel(src)
	//Bun + xenomeat = xenoburger
	else if(istype(W,/obj/item/reagent_containers/food/snacks/xenomeat))
		var/turf/spawnloc = foodloc(user, src)
		new /obj/item/reagent_containers/food/snacks/xenoburger(spawnloc)
		user << "You make a xenoburger ."
		qdel(W)
		qdel(src)

	//Bun + tofu = tofuburger
	else if(istype(W,/obj/item/reagent_containers/food/snacks/tofu))
		var/turf/spawnloc = foodloc(user, src)
		new /obj/item/reagent_containers/food/snacks/tofuburger(spawnloc)
		user << "You make a tofuburger ."
		qdel(W)
		qdel(src)

	//Bun + ectoplasm = ghostburger
	else if(istype(W,/obj/item/ectoplasm))
		var/turf/spawnloc = foodloc(user, src)
		new /obj/item/reagent_containers/food/snacks/ghostburger(spawnloc)
		user << "You make a ghostburger ."
		qdel(W)
		qdel(src)

	//Bun + clown mask = clownburger
	else if(istype(W,/obj/item/clothing/mask/gas/clown_hat))
		var/turf/spawnloc = foodloc(user, src)
		new /obj/item/reagent_containers/food/snacks/clownburger(spawnloc)
		user << "You make a clownburger ."
		qdel(W)
		qdel(src)

	//Bun + Carpmeat = Fishburger
	else if(istype(W,/obj/item/reagent_containers/food/snacks/carpmeat))
		var/turf/spawnloc = foodloc(user, src)
		new /obj/item/reagent_containers/food/snacks/fishburger(spawnloc)
		user << "You make a fishburger ."
		qdel(W)
		qdel(src)

	//Bun + Robot Head = Roburger
	else if(istype(W,/obj/item/robot_parts/head))
		var/turf/spawnloc = foodloc(user, src)
		new /obj/item/reagent_containers/food/snacks/roburger(spawnloc)
		user << "You make a fishburger ."
		qdel(W)
		qdel(src) //obj/item/reagent_containers/food/snacks/spellburger

	//Bun + Wizard Hat = Spellburger
	else if(istype(W,/obj/item/clothing/head/wizard/fake || /obj/item/clothing/head/wizard/))
		var/turf/spawnloc = foodloc(user, src)
		new /obj/item/reagent_containers/food/snacks/spellburger(spawnloc)
		user << "You make a fishburger ."
		qdel(W)
		qdel(src)



//Burger + Burger Or Hamburger + Hamburger Or Hamburger + Burger = Bib Bite Burger
/obj/item/reagent_containers/food/snacks/monkeyburger/attackby(obj/item/W as obj, mob/user as mob)
	if(istype(W,/obj/item/reagent_containers/food/snacks/monkeyburger))
		var/turf/spawnloc = foodloc(user, src)
		new /obj/item/reagent_containers/food/snacks/bigbiteburger(spawnloc)
		user << "You make a big bite burger!"
		qdel(W)
		qdel(src)
	else if(istype(W,/obj/item/reagent_containers/food/snacks/hamburger))
		var/turf/spawnloc = foodloc(user, src)
		new /obj/item/reagent_containers/food/snacks/bigbiteburger(spawnloc)
		user << "You make a big bite burger!"
		qdel(W)
		qdel(src)

/obj/item/reagent_containers/food/snacks/hamburger/attackby(obj/item/W as obj, mob/user as mob)
	if(istype(W,/obj/item/reagent_containers/food/snacks/monkeyburger))
		var/turf/spawnloc = foodloc(user, src)
		new /obj/item/reagent_containers/food/snacks/bigbiteburger(spawnloc)
		user << "You make a big bite burger!"
		qdel(W)
		qdel(src)
	else if(istype(W,/obj/item/reagent_containers/food/snacks/hamburger))
		var/turf/spawnloc = foodloc(user, src)
		new /obj/item/reagent_containers/food/snacks/bigbiteburger(spawnloc)
		user << "You make a big bite burger!"
		qdel(W)
		qdel(src)

// Sauced spaghetti + meatball = sauced spaghetti with meatballs
/obj/item/reagent_containers/food/snacks/pastatomato/attackby(obj/item/W as obj, mob/user as mob)
	if(istype(W,/obj/item/reagent_containers/food/snacks/faggot))
		var/turf/spawnloc = foodloc(user, src)
		new /obj/item/reagent_containers/food/snacks/smeatballspagetti(spawnloc)
		user << "You add meatballs to sauced spaghetti."
		qdel(W)
		qdel(src)

///////////////////////////////////////////////////////
//                                                   //
//                     Adding sauce.                 //
//                                                   //
///////////////////////////////////////////////////////


// Steak + ketchup
/obj/item/reagent_containers/food/snacks/meatsteak/attackby(obj/item/reagent_containers/food/condiment/ketchup/W as obj, mob/user as mob)
	if(istype(W))
		var/turf/spawnloc = foodloc(user, src)
		if(src.reagents.total_volume < 5)
			user << "<span  class='notice'>There's not enough ketchup left to make a sauced stake.</span>"
			return
		src.reagents.remove_reagent("ketchup", 5, 1)//Deleting 5 flour from the ketchup bottle.
		new /obj/item/reagent_containers/food/snacks/ssteak(spawnloc)
		user << "You put ketchup on the steak."
		qdel(src)
		return
	..()

// Baked potato + ketchup
/obj/item/reagent_containers/food/snacks/loadedbakedpotato/attackby(obj/item/W as obj, mob/user as mob)
	if(istype(W,/obj/item/reagent_containers/food/condiment/ketchup))
		var/turf/spawnloc = foodloc(user, src)
		if(src.reagents.total_volume < 5)
			user << "<span  class='notice'>There's not enough ketchup left to make a sauced potato.</span>"
			return
		src.reagents.remove_reagent("ketchup", 5, 1)//Deleting 5 flour from the ketchup bottle.
		new /obj/item/reagent_containers/food/snacks/sbakedpotato(spawnloc)
		user << "You add ketchup to baked potato."
		qdel(src)

// Spaghetti + ketchup
/obj/item/reagent_containers/food/snacks/boiledspagetti/attackby(obj/item/reagent_containers/food/condiment/ketchup/W as obj, mob/user as mob)
	if(istype(W))
		var/turf/spawnloc = foodloc(user, src)
		new /obj/item/reagent_containers/food/snacks/pastatomato(spawnloc)
		user << "You put ketchup in spaghetti."
		qdel(src)
		return
	..()

// Meatballs & spaghetti + ketchup
/obj/item/reagent_containers/food/snacks/meatspaghetti/attackby(obj/item/W as obj, mob/user as mob)
	if(istype(W,/obj/item/reagent_containers/food/condiment/ketchup))
		var/turf/spawnloc = foodloc(user, src)
		if(src.reagents.total_volume < 5)
			user << "<span  class='notice'>There's not enough ketchup left to make a sauced spagheti with meatballs.</span>"
			return
		src.reagents.remove_reagent("ketcup", 5, 1)//Deleting 5 flour from the ketchup bottle.
		new /obj/item/reagent_containers/food/snacks/smeatballspagetti(spawnloc)
		user << "You put ketchup in meat spaghetti."
		qdel(src)

// Burger + ketchup
/obj/item/reagent_containers/food/snacks/monkeyburger/attackby(obj/item/reagent_containers/food/condiment/ketchup/W as obj, mob/user as mob)
	if(istype(W))
		var/turf/spawnloc = foodloc(user, src)
		if(src.reagents.total_volume < 5)
			user << "<span  class='notice'>There's not enough ketchup left to make a sauced burger.</span>"
			return
		src.reagents.remove_reagent("ketcup", 5, 1)//Deleting 5 flour from the ketchup bottle.
		new /obj/item/reagent_containers/food/snacks/sburger(spawnloc)
		user << "You add ketchup to the burger."
		qdel(src)
		return
	..()

// Hamburger + ketchup
/obj/item/reagent_containers/food/snacks/hamburger/attackby(obj/item/reagent_containers/food/condiment/ketchup/W as obj, mob/user as mob)
	if(istype(W))
		var/turf/spawnloc = foodloc(user, src)
		if(src.reagents.total_volume < 5)
			user << "<span  class='notice'>There's not enough ketchup left to make a sauced hamburger.</span>"
			return
		src.reagents.remove_reagent("ketcup", 5, 1)//Deleting 5 flour from the ketchup bottle.
		new /obj/item/reagent_containers/food/snacks/shamburger(spawnloc)
		user << "You add ketchup to the hamburger."
		qdel(src)
		return
	..()

// Hotdog + ketchup
/obj/item/reagent_containers/food/snacks/hotdog/attackby(obj/item/W as obj, mob/user as mob)
	if(istype(W,/obj/item/reagent_containers/food/condiment/ketchup))
		var/turf/spawnloc = foodloc(user, src)
		if(src.reagents.total_volume < 5)
			user << "<span  class='notice'>There's not enough ketchup left to make a sauced hotdog.</span>"
			return
		src.reagents.remove_reagent("ketcup", 5, 1)//Deleting 5 flour from the ketchup bottle.
		new /obj/item/reagent_containers/food/snacks/shotdog(spawnloc)
		user << "You add ketchup to the hotdog."
		qdel(src)

// omelette + ketchup
/obj/item/reagent_containers/food/snacks/omelette/attackby(obj/item/W as obj, mob/user as mob)
	if(istype(W,/obj/item/reagent_containers/food/condiment/ketchup))
		var/turf/spawnloc = foodloc(user, src)
		if(src.reagents.total_volume < 5)
			user << "<span  class='notice'>There's not enough ketchup left to make a sauced omelette.</span>"
			return
		src.reagents.remove_reagent("ketcup", 5, 1)//Deleting 5 flour from the ketchup bottle.
		new /obj/item/reagent_containers/food/snacks/somelette(spawnloc)
		user << "You add ketchup to the omelette."
		qdel(src)

///////////////////////////////////////////////////////
//                                                   //
//           Bread and sandwich system.              //
//           Stuff goes on top of bread slices!      //
//                                                   //
///////////////////////////////////////////////////////

// *** At first, containers which require a knife to get something from then ***



// the butterpack
/obj/item/reagent_containers/food/snacks/breadsys/butterpack
	name = "Butter pack"
	desc = "A big pack of goodness."
	icon_state = "butterpack"
	slice_path = /obj/item/reagent_containers/food/snacks/breadsys/ontop/butter
	slices_num = 5
	filling_color = "#F3EF7D"
	New()
		..()
		reagents.add_reagent("nutriment", 20)
		bitesize = 2

// the stick of salami
/obj/item/reagent_containers/food/snacks/breadsys/salamistick
	name = "salami stick"
	desc = "Don't choke on this, find a knife."
	icon_state = "salamistick3"
	slice_path = /obj/item/reagent_containers/food/snacks/breadsys/ontop/salami
	slices_num = 5
//	filling_color = "#FFF700"
	New()
		..()
		reagents.add_reagent("nutriment", 20)
		bitesize = 2


// *** Now icons for the stuff which goes on top of the bread slice ***


// a slice of salami
/obj/item/reagent_containers/food/snacks/breadsys/ontop/salami
	name = "salami"
	desc = "A preserved meat."
	icon_state = "salami"
	bitesize = 2


// a slice of butter
/obj/item/reagent_containers/food/snacks/breadsys/ontop/butter
	name = "butter"
	desc = "You need a butter to make sandwiches, right?"
	icon_state = "butter"
	bitesize = 2
