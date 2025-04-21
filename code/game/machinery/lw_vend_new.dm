/obj/machinery/lwvend
	var/obols = 8
	var/list/products	= list(list(name = "Lighter", path = /obj/item/flame/lighter, price = 12, code = "lighter"),
	list(name = "Bandages", path = /obj/item/stack/medical/bruise_pack, price = 8, code = "bandages"),
	list(name = "Cigarrete Pack", path = /obj/item/storage/fancy/cigarettes, price = 30, code = "cigpacket"))
	name = "Vendor"
	icon = 'icons/obj/vending.dmi'
	icon_state = "snack"
	anchored = 1
	density = 1
	var/taxes = 1

/obj/machinery/lwvend/New()
	..()
	vending_list.Add(src)

/obj/machinery/lwvend/attackby(obj/item/I as obj, mob/living/carbon/human/user as mob)
	if(istype(I,/obj/item/spacecash))
		src.obols += I:worth
		qdel(I)
		playsound(src.loc, 'sound/effects/coininsert.ogg', 30, 0)



/obj/machinery/lwvend/attack_hand(mob/living/carbon/human/user as mob)
	playsound(src.loc, pick('sound/effects/public1.ogg','sound/effects/public2.ogg','sound/effects/public3.ogg'), 30, 0)
	var/illiterate = FALSE
	if(user.check_perk(/datum/perk/illiterate))
		illiterate = TRUE
	var/dat
	dat += {"<META http-equiv='X-UA-Compatible' content='IE=edge' charset='UTF-8'> <style type='text/css'> @font-face {font-family: Gothic;src: url(gothic.ttf);} @font-face {font-family: Book;src: url(book.ttf);} @font-face {font-family: Hando;src: url(hando.ttf);} @font-face {font-family: Eris;src: url(eris.otf);} @font-face {font-family: Brandon;src: url(brandon.otf);} @font-face {font-family: VRN;src: url(vrn.otf);} @font-face {font-family: NEOM;src: url(neom.otf);} @font-face {font-family: 'PTSansWebRegular';src: url('./PTSANS.woff2') format('woff2');} @font-face {font-family: Type;src: url(type.ttf);} @font-face {font-family: Enlightment;src: url(enlightment.ttf);} @font-face {font-family: Arabic;src: url(arabic.ttf);} @font-face {font-family: Digital;src: url(digital.ttf);} @font-face {font-family: Cond;src: url(cond2.ttf);} @font-face {font-family: Semi;src: url(semi.ttf);} @font-face {font-family: Droser;src: url(Droser.ttf);} .goth {font-family: Gothic, Verdana, sans-serif;} .book {font-family: Book, serif;} .hando {font-family: Hando, Verdana, sans-serif;} .typewriter {font-family: Type, Verdana, sans-serif;} .arabic {font-family: Arabic, serif; font-size:180%;} .droser {font-family: Droser, Verdana, sans-serif;} </style> <style type='text/css'> @charset 'utf-8'; body {font-family: 'PTSansWebRegular';cursor: url('pointer.cur'), auto;} a {text-decoration:none;outline: none;border: none;margin:-1px;} a:focus{outline:none;} a:hover {color:#0d0d0d;background:#505055;outline: none;border: none;} a.active { text-decoration:none; color:#533333;} a.inactive:hover {color:#0d0d0d;background:#bb0000} a.active:hover {color:#bb0000;background:#0f0f0f} a.inactive:hover { text-decoration:none; color:#0d0d0d; background:#bb0000}</style>
	<body background bgColor=#0d0d0d text=#533333 alink=#777777 vlink=#777777 link=#777777>
	<TT><CENTER><b>[src.name]</b></CENTER></TT><br>
	"}
	dat += "<TABLE width=100%><TR><TD><TT><B>Item:</B></TT></TD> <TD><TT><B>Price:</B></TT></TD><TD></TD><TD></TD><TD></TD></TR>"
	for(var/list/L in products)
		var/ProductPrice =  L["price"]
		var/ProductName = L["name"]
		var/path = L["path"]
		var/code = L["code"]

		if(src.taxes)
			ProductPrice = round(ProductPrice + ((ProductPrice / 100) * TaxUponSells))

		var/atom/A = new path()
		if(illiterate)
			dat += "<TR><TD><TT><FONT Color = '836363'><B><BIG>[icon2html(A, user)] [Illiterate(ProductName,100)]</BIG></B></TT></TD> <TD><TT>[ProductPrice]</TT></TD></font></TT></TD> "
		else
			dat += "<TR><TD><TT><FONT Color = '836363'><B><BIG>[icon2html(A, user)] [ProductName]</BIG></B></TT></TD> <TD><TT>[ProductPrice]</TT></TD></font></TT></TD> "
		if(ProductPrice > obols)
			if(illiterate)
				dat += "<TD><TT><font Color = 'red'>[Illiterate("NOT ENOUGH MONEY",100)]</font></TD></TT></TR>"
			else
				dat += "<TD><TT><font Color = 'red'>NOT ENOUGH MONEY</font></TD></TT></TR>"
		else
			if(illiterate)
				dat += "<TD><TT><A href='byond://?src=\ref[src];[code]=1'>[Illiterate("Purchase",100)]</A></TT></TR>"
			else
				dat += "<TD><TT><A href='byond://?src=\ref[src];[code]=1'>Purchase</A></TT></TR>"
		qdel(A)
	if(illiterate)
		dat += "</TABLE><br><TT><b>[Illiterate("Obols Loaded",100)]: [obols]</b><br></TT><BR><TT><A href='byond://?src=\ref[src];change=1'>[Illiterate("Change",100)]</A></TT>"
	else
		dat += "</TABLE><br><TT><b>Obols Loaded: [obols]</b><br></TT><BR><TT><A href='byond://?src=\ref[src];change=1'>Change</A></TT>"

	user << browse(dat, "window=vending;size=575x450")

/obj/machinery/lwvend/Topic(href, href_list)
	if(..())
		return
	var/hrefParsed = splittext(href, ";")[2]

	if(href_list["change"])
		playsound(src.loc, pick('sound/effects/public1.ogg','sound/effects/public2.ogg','sound/effects/public3.ogg'), 30, 0)
		if(src.obols)
			to_chat(usr, "<i>[src] has [src.obols] obols.</i>")
			var/withdraw = input("How much you want to withdraw | There is [src.obols] obols in [src].","[src]",src.obols) as num
			if(!withdraw)
				return
			withdraw = abs(withdraw) //No negative numbers.
			if(withdraw > src.obols)
				to_chat(usr, "There's not enough obols to withdraw that amount!")
			if(withdraw < 0)
				return
			if(withdraw <= src.obols)
				to_chat(usr, "<i>You withdraw [withdraw] from [src].</i>")
				playsound(src.loc, 'sound/effects/coin_m.ogg', 30, 0)
				spawn_money(withdraw,src.loc)
				src.obols -= withdraw
	for(var/list/L in products)
		var/ProductPrice =  L["price"]
		var/newItemPath =  L["path"]
		if("[L["code"]]=1" == hrefParsed)
			if(src.obols < ProductPrice)
				to_chat(usr, "Not enough obols, [ProductPrice] required!")
				return
			if(src.obols >= ProductPrice)
				src.obols -= ProductPrice
				var/atom/newItem = new newItemPath(src.loc)
				newItem.dir = usr.dir
				if(src.taxes)
					supply_shuttle.points += (ProductPrice / 100) * TaxUponSells
				if(istype(newItem, /obj/item/coupon/pusher))
					debt = 0
					for(var/mob/living/carbon/human/H in player_list)
						if(H.job == "Pusher")
							if(H.gender == MALE)
								to_chat(H, "<b>Good boy</b>, your debt has been paid. <i>[debt]</i>")
							else
								to_chat(H, "<b>Good girl</b>, your debt has been paid. <i>[debt]</i>")
var/debt = 1

/obj/machinery/lwvend/onion
	plane = 21
	obols = 66
	taxes = 0
	products = list(
	list(name = "DOB", path = /obj/item/reagent_containers/pill/lifeweb/blotter/DOB, price = 16, code = "DOB"),
	list(name = "Vinici-Us", path = /obj/item/reagent_containers/pill/lifeweb/blotter/vinici_us, price = 8, code = "vinicius"),
	list(name = "JWH-07", path = /obj/item/clothing/mask/cigarette/fakeweed, price = 2, code = "fakeweed"),
	list(name = "Low-Quality Weed", path = /obj/item/clothing/mask/cigarette/cheapweed, price = 6, code = "cheapweed"),
	list(name = "High-Quality Weed", path = /obj/item/clothing/mask/cigarette/weed, price = 16, code = "weed"),
	list(name = "Krokodil", path = /obj/item/reagent_containers/food/snacks/desomorphine, price = 4, code = "heroinlq"),
	list(name = "Heroin", path = /obj/item/reagent_containers/syringe/heroin, price = 8, code = "heroin"),
	list(name = "Morphine", path = /obj/item/reagent_containers/food/snacks/morphine, price = 24, code = "heroinhq"),
	list(name = "A-PVP", path = /obj/item/reagent_containers/food/snacks/apvp, price = 3, code = "apvp"),
	list(name = "Amphetamine", path = /obj/item/reagent_containers/food/snacks/meth, price = 8, code = "amphetamine"),
	list(name = "Cocaine (Hit)", path = /obj/item/reagent_containers/food/snacks/cocaine, price = 16, code = "powder"),
	list(name = "Combat Stimulant #3", path = /obj/item/reagent_containers/pill/lifeweb/stimm, price = 48, code = "cocaine"),
	list(name = "MDMA Bottle", path = /obj/item/storage/pill_bottle/mdma, price = 36, code = "mdmabottle"),
	list(name = "Mice 69 Bottle", path = /obj/item/storage/pill_bottle/mice69, price = 36, code = "micebottle"),
	list(name = "Buffout Pills", path = /obj/item/storage/pill_bottle/buffout, price = 56, code = "buffout"),
	list(name = "Mentats Can", path = /obj/item/storage/pill_bottle/mentats, price = 96, code = "mentats"),
	list(name = "Cigarette Packet", path = /obj/item/storage/fancy/cigarettes, price = 8, code = "cigarettes"),
	list(name = "Condom (S)", path = /obj/item/condom_wrapper/small, price = 4, code = "consmall"),
	list(name = "Condom (M)", path = /obj/item/condom_wrapper/regular, price = 4, code = "conmed"),
	list(name = "Condom (XXL)", path = /obj/item/condom_wrapper/large, price = 4, code = "conlarge"),
	list(name = "Uzi Submachinegun", path = /obj/item/gun/projectile/automatic/mini_uzi, price = 320, code = "uzi"),
	list(name = "Karek Magazine (.380)", path = /obj/item/ammo_magazine/external/uzi380, price = 40, code = "uzi380"),
	list(name = "Sawn-Off Shotgun", path = /obj/item/gun/projectile/newRevolver/duelista/doublebarrel/sawnOff, price = 86, code = "sawnoff"),
	list(name = "Buckshot (3)", path = /obj/item/stack/bullets/buckshot/three, price = 16, code = "buckshot"),
	list(name = "Screamer 23", path = /obj/item/gun/projectile/automatic/pistol/magnum66/screamer23, price = 200, code = "screamer23"),
	list(name = "Magazine (.45)", path = /obj/item/ammo_magazine/external/sm45/pusher/full, price = 32, code = "sm45"),
	list(name = "Mini-Pistol", path = /obj/item/gun/projectile/automatic/pistol/ml23, price = 64, code = "minipistol"),
	list(name = "9mm Magazine", path = /obj/item/ammo_magazine/external/mc9mm, price = 20, code = "mc9mm"),
	list(name = "9mm Baton Magazine", path = /obj/item/ammo_magazine/external/mc9mm, price = 10, code = "mc9mmb"),
	list(name = "Grenade", path = /obj/item/grenade/syndieminibomb/frag, price = 96, code = "grenade"),
	list(name = "Flashbang Grenade", path = /obj/item/grenade/flashbang, price = 126, code = "flashbang"),
	list(name = "Knife", path = /obj/item/kitchen/utensil/knife, price = 8, code = "knife"),
	list(name = "Lockpick", path = /obj/item/lockpick, price = 16, code = "lockpick"),
	list(name = "Fake Golden Obols", path = /obj/item/fakecash/gold/c20, price = 16, code = "fakegold"),
	list(name = "Zippo Lighter", path = /obj/item/flame/lighter/zippo, price = 16, code = "zippo"),
	list(name = "Poison Fruit", path = /obj/item/reagent_containers/food/snacks/grown/apple/poisoned, price = 2, code = "poison"),
	list(name = "Poison Wine", path = /obj/item/reagent_containers/glass/bottle/pwinecheap, price = 8, code = "swine"),
	list(name = "Poison Vintage", path = /obj/item/reagent_containers/glass/bottle/pwine, price = 16, code = "vwine"),
	list(name = "Fetish Clothes (Red)", path = /obj/item/clothing/suit/hooker, price = 8, code = "fetshred"),
	list(name = "Fetish Boots (Red)", path = /obj/item/clothing/shoes/lw/fetish, price = 6, code = "fetish"),
	list(name = "Fetish Clothes (Black)", path = /obj/item/clothing/suit/hooker/domina, price = 16, code = "fetshbl"),
	list(name = "Syringe", path = /obj/item/reagent_containers/syringe, price = 2, code = "syringe"),
	list(name = "Cannabis Seeds", path = /obj/item/seeds/cannabis, price = 10, code = "seed"),
	list(name = "PAY THE DEBT", path = /obj/item/coupon/pusher, price = 16, code = "debt"))
	name = "ONION"
	icon = 'icons/obj/vending.dmi'
	icon_state = "onion"
	anchored = 1
	density = 0

/obj/machinery/lwvend/onion/process()
	if(debt <= 0)
		for(var/mob/living/carbon/human/H in mob_list)
			if(H.job == "Pusher")
				H?.mind.time_to_pay = "good boy."
		for(var/obj/machinery/information_terminal/IM in vending_list)
			IM.despusherize()
		processing_objects.Remove(src)

/obj/machinery/lwvend/onion/New()
	..()
	processing_objects.Add(src)

/obj/machinery/lwvend/sanctuary
	obols = 0
	products	= list(list(name = "Dentrine", path = /obj/item/reagent_containers/pill/lifeweb/dentrine, price = 16, code = "dentrine"),
	list(name = "Condom (S)", path = /obj/item/condom_wrapper/small, price = 8, code = "consmall"),
	list(name = "Condom (M)", path = /obj/item/condom_wrapper/regular, price = 8, code = "conmed"),
	list(name = "Condom (XXL)", path = /obj/item/condom_wrapper/large, price = 8, code = "conlarge"),
	list(name = "Syringe", path = /obj/item/reagent_containers/syringe, price = 4, code = "syringe"),
	list(name = "Bandages", path = /obj/item/stack/medical/bruise_pack, price = 2, code = "bandages"),
	list(name = "Suture", path = /obj/item/surgery_tool/suture, price = 24, code = "suture"),
	list(name = "Syringe (Antibiotic)", path = /obj/item/reagent_containers/syringe/antibiotic, price = 16, code = "antibiotic"))
	name = "Sanctuary Vendor"
	icon = 'icons/obj/vending.dmi'
	icon_state = "snack"
	anchored = 1
	density = 1

/obj/machinery/lwvend/innvend
	obols = 128
	products	= list(list(name = "Eggs", path = /obj/item/storage/fancy/egg_box, price = 8, code = "eggs"),
	list(name = "Milk", path = /obj/item/reagent_containers/food/drinks/milk, price = 4, code = "milk"),
	list(name = "Dough", path = /obj/item/reagent_containers/food/snacks/dough, price = 4, code = "dough"),
	list(name = "Butter", path = /obj/item/reagent_containers/food/snacks/breadsys/butterpack, price = 8, code = "butter"),
	list(name = "Peppermill", path = /obj/item/reagent_containers/food/condiment/peppermill, price = 6, code = "pepper"),
	list(name = "Salt Shaker", path = /obj/item/reagent_containers/food/condiment/saltshaker, price = 6, code = "salt"),
	list(name = "Arelite Meat", path = /obj/item/reagent_containers/food/snacks/meat, price = 16, code = "meat"),
	list(name = "Salami", path = /obj/item/reagent_containers/food/snacks/breadsys/salamistick, price = 32, code = "salami"),
	list(name = "Gahan Malt", path = /obj/item/reagent_containers/glass/bottle/gahanmalt, price = 2, code = "maltbeer"),
	list(name = "Salar Wheat", path = /obj/item/reagent_containers/glass/bottle/beer, price = 4, code = "beer"),
	list(name = "Rahallian Kriek", path = /obj/item/reagent_containers/glass/bottle/rahalkriek, price = 7, code = "rahalbeer"),
	list(name = "Bitter Old Bastard", path = /obj/item/reagent_containers/glass/bottle/bitterbastard, price = 12, code = "bitter"),
	list(name = "Vodka", path = /obj/item/reagent_containers/glass/bottle/vodka, price = 24, code = "vodka"),
	list(name = "Sugarpod Rum", path = /obj/item/reagent_containers/glass/bottle/rum, price = 32, code = "rum"),
	list(name = "Cave Wine", path = /obj/item/reagent_containers/glass/bottle/cwine, price = 40, code = "wine"),
	list(name = "Little Arelitenyok", path = /obj/item/reagent_containers/glass/bottle/swine, price = 96, code = "swine"),
	list(name = "Absinthe", path = /obj/item/reagent_containers/glass/bottle/absinthe, price = 80, code = "absinthe"),
	list(name = "Whiskey", path = /obj/item/reagent_containers/glass/bottle/whiskey, price = 80, code = "whiskey"),
	list(name = "Vermouth", path = /obj/item/reagent_containers/glass/bottle/vermouth, price = 80, code = "vermouth"),
	list(name = "Vintage Wine", path = /obj/item/reagent_containers/glass/bottle/vwine, price = 256, code = "oldwine"))
	name = "Innkeep Vendor"
	icon = 'icons/obj/vending.dmi'
	icon_state = "production"
	anchored = 1
	density = 1

// The bad path UNTOUCHED BY ECONOMY UPDATe

/obj/machinery/lwvend/ultrapriest
	plane = 21
	obols = 40
	taxes = 0
	products = list(
	list(name = "Grenade", path = /obj/item/grenade/syndieminibomb/frag, price = 120, code = "grenade"),
	list(name = "Karek Magazine (.380)", path = /obj/item/ammo_magazine/external/uzi380, price = 35, code = "uzi380"),
	list(name = "Zippo Lighter", path = /obj/item/flame/lighter/zippo, price = 12, code = "zippo"),
	list(name = "Mini-Pistol", path = /obj/item/gun/projectile/automatic/pistol/ml23, price = 130, code = "minipistol"),
	list(name = "Flashbang Grenade", path = /obj/item/grenade/flashbang, price = 130, code = "flashbang"),
	list(name = "9mm Magazine", path = /obj/item/ammo_magazine/external/mc9mm, price = 20, code = "mc9mm"),
	list(name = "9mm Baton Magazine", path = /obj/item/ammo_magazine/external/mc9mm, price = 10, code = "mc9mmb"),
	list(name = "Buffout Pills", path = /obj/item/storage/pill_bottle/buffout, price = 50, code = "buffout"),
	list(name = "Mentats Can", path = /obj/item/storage/pill_bottle/mentats, price = 30, code = "mentats"),
	list(name = "Magazine (.45)", path = /obj/item/ammo_magazine/external/sm45/pusher/full, price = 24, code = "sm45"),
	list(name = "Cigarette Packet", path = /obj/item/storage/fancy/cigarettes, price = 18, code = "cigarettes"),
	list(name = "Dentrine Pill", path = /obj/item/reagent_containers/pill/lifeweb/dentrine, price = 42, code = "dentrine"),
	list(name = "Telescopic Baton", path = /obj/item/melee/telebaton, price = 115, code = "telebaton"),
	list(name = "W93 Mother", path = /obj/item/gun/projectile/automatic/pistol/magnum66/mother, price = 200, code = "mother"),
	list(name = "Advanced Battery", path = /obj/item/cell/crap/leet/noctis, price = 60, code = "noctis"),
	list(name = "Buckshot (3)", path = /obj/item/stack/bullets/buckshot/three, price = 16, code = "buckshot"))
	name = "UL-P X10000"
	icon = 'icons/obj/vending.dmi'
	icon_state = "producer"
	anchored = 1
	density = 0

// NEW START

/obj/machinery/computerVendor
	name = "vendor"
	desc = "A vendor used to buy and sell items."
	icon = 'icons/obj/vending.dmi'
	icon_state = "snack"
	anchored = 1
	density = 1
	var/obols = 1
	var/locked = 1
	var/acceptableJobs = list()

/obj/machinery/computerVendor/New()
	..()
	icon_state = pick("sustom1", "dustom1", "rustom1")

/obj/machinery/computerVendor/smith
	acceptableJobs = list("Armorsmith", "Metalsmith", "Weaponsmith")

/obj/machinery/computerVendor/bookkeeper
	acceptableJobs = list("Docker", "Merchant")

/obj/item/var/priceSet = 0

/obj/machinery/computerVendor/RightClick(mob/living/carbon/human/user as mob)
	if(user.job in acceptableJobs)
		locked = locked ? 0 : 1
		playsound(src.loc, pick('sound/webbers/lw_key.ogg'), rand(30,50), 0)
		to_chat(user, "<span class='baron'><i> I [locked ? "lock" : "unlock"] the [src].</i></span>")
	..()

/obj/machinery/computerVendor/attackby(obj/item/I as obj, mob/living/carbon/human/user as mob)
	if(istype(I,/obj/item/spacecash))
		src.obols += I:worth
		qdel(I)
		playsound(src.loc, 'sound/effects/coininsert.ogg', 30, 0)
		return
	if(istype(I,/obj/item/wrench))
		if(!anchored)
			playsound(src.loc, 'sound/items/Ratchet.ogg', 75, 1)
			src.anchored = 1
			return
		if(anchored)
			playsound(src.loc, 'sound/items/Ratchet.ogg', 75, 1)
			src.anchored = 0
			return
	else
		if(!locked)
			var/howmuchwillitcost = input("How much will it cost?","[src]",20) as num
			if(!howmuchwillitcost)
				return
			howmuchwillitcost = abs(howmuchwillitcost) //No negative numbers or floating points.
			if(howmuchwillitcost < 0)
				to_chat(usr, "That is an invalid amount to price at!")
				message_admins("[usr.client.ckey] just tried to sell an item at a negative amount of obols.")
				return
			user.drop_from_inventory(I)
			contents.Add(I)
			I.priceSet = howmuchwillitcost
			playsound(src.loc, pick('sound/webbers/lw_key.ogg'), rand(30,50), 0)
			to_chat(user, "<span class='baron'><i> I added the [I] to the [src] for [howmuchwillitcost].</i></span>")
			playsound(src.loc, pick('sound/webbers/console_input1.ogg', 'sound/webbers/console_input2.ogg', 'sound/webbers/console_input3.ogg'), 100, 0, -5)

/obj/machinery/computerVendor/attack_hand(mob/living/carbon/human/user as mob)
	if(!locked)
		var/list/listToRemove = list()
		for(var/obj/item/I in src.contents)
			listToRemove.Add(I)
		var/obj/item/whichToRemove = input("What item do i want to remove?", "[src]") in listToRemove
		src.contents -= whichToRemove
		whichToRemove.loc = src.loc
		playsound(src.loc, pick('sound/webbers/console_input1.ogg', 'sound/webbers/console_input2.ogg', 'sound/webbers/console_input3.ogg'), 100, 0, -5)
		return
	playsound(src.loc, pick('sound/effects/public1.ogg','sound/effects/public2.ogg','sound/effects/public3.ogg'), 30, 0)
	var/illiterate = FALSE
	if(user.check_perk(/datum/perk/illiterate))
		illiterate = TRUE
	var/dat
	dat += {"<META http-equiv='X-UA-Compatible' content='IE=edge' charset='UTF-8'> <style type='text/css'> @font-face {font-family: Gothic;src: url(gothic.ttf);} @font-face {font-family: Book;src: url(book.ttf);} @font-face {font-family: Hando;src: url(hando.ttf);} @font-face {font-family: Eris;src: url(eris.otf);} @font-face {font-family: Brandon;src: url(brandon.otf);} @font-face {font-family: VRN;src: url(vrn.otf);} @font-face {font-family: NEOM;src: url(neom.otf);} @font-face {font-family: 'PTSansWebRegular';src: url('./PTSANS.woff2') format('woff2');} @font-face {font-family: Type;src: url(type.ttf);} @font-face {font-family: Enlightment;src: url(enlightment.ttf);} @font-face {font-family: Arabic;src: url(arabic.ttf);} @font-face {font-family: Digital;src: url(digital.ttf);} @font-face {font-family: Cond;src: url(cond2.ttf);} @font-face {font-family: Semi;src: url(semi.ttf);} @font-face {font-family: Droser;src: url(Droser.ttf);} .goth {font-family: Gothic, Verdana, sans-serif;} .book {font-family: Book, serif;} .hando {font-family: Hando, Verdana, sans-serif;} .typewriter {font-family: Type, Verdana, sans-serif;} .arabic {font-family: Arabic, serif; font-size:180%;} .droser {font-family: Droser, Verdana, sans-serif;} </style> <style type='text/css'> @charset 'utf-8'; body {font-family: 'PTSansWebRegular';cursor: url('pointer.cur'), auto;} a {text-decoration:none;outline: none;border: none;margin:-1px;} a:focus{outline:none;} a:hover {color:#0d0d0d;background:#505055;outline: none;border: none;} a.active { text-decoration:none; color:#533333;} a.inactive:hover {color:#0d0d0d;background:#bb0000} a.active:hover {color:#bb0000;background:#0f0f0f} a.inactive:hover { text-decoration:none; color:#0d0d0d; background:#bb0000}</style>
	<body background bgColor=#0d0d0d text=#533333 alink=#777777 vlink=#777777 link=#777777>
	<TT><CENTER><b>[src.name]</b></CENTER></TT><br>
	"}
	dat += "<TABLE width=100%><TR><TD><TT><B>Item:</B></TT></TD> <TD><TT><B>Price:</B></TT></TD><TD></TD><TD></TD><TD></TD></TR>"
	for(var/obj/item/A in contents)
		var/ProductPrice = A.priceSet
		var/ProductName = A.name


		//dat += "<A href='byond://?src=\ref[src];[code]=1'>[ProductName]</A><BR><span class='materials'>[recipeContents]</span><BR><BR>"
		if(illiterate)
			dat += "<TR><TD><TT><FONT Color = '836363'><B><BIG>[icon2html(A, user)] [Illiterate(ProductName,100)]</BIG></B></TT></TD> <TD><TT>[ProductPrice]</TT></TD></font></TT></TD> "
		else
			dat += "<TR><TD><TT><FONT Color = '836363'><B><BIG>[icon2html(A, user)] [ProductName]</BIG></B></TT></TD> <TD><TT>[ProductPrice]</TT></TD></font></TT></TD> "
		if(ProductPrice > obols)
			if(illiterate)
				dat += "<TD><TT><font Color = 'red'>[Illiterate("NOT ENOUGH MONEY",100)]</font></TD></TT></TR>"
			else
				dat += "<TD><TT><font Color = 'red'>NOT ENOUGH MONEY</font></TD></TT></TR>"
		else
			if(illiterate)
				dat += "<TD><TT><A href='byond://?src=\ref[src];code=[A.name]'>[Illiterate("Purchase",100)]</A></TT></TR>"
			else
				dat += "<TD><TT><A href='byond://?src=\ref[src];code=[A.name]'>Purchase</A></TT></TR>"
	if(illiterate)
		dat += "</TABLE><br><TT><b>[Illiterate("Obols Loaded",100)]: [obols]</b><br></TT><BR><TT><A href='byond://?src=\ref[src];change=1'>[Illiterate("Change",100)]</A></TT>"
	else
		dat += "</TABLE><br><TT><b>Obols Loaded: [obols]</b><br></TT><BR><TT><A href='byond://?src=\ref[src];change=1'>Change</A></TT>"

	user << browse(dat, "window=vending;size=575x450")

/obj/machinery/computerVendor/Topic(href, href_list)
	if(..())
		return


	if(href_list["change"])
		playsound(src.loc, pick('sound/effects/public1.ogg','sound/effects/public2.ogg','sound/effects/public3.ogg'), 30, 0)
		if(usr.job in acceptableJobs)
			if(src.obols)
				to_chat(usr, "<i>[src] has [src.obols] obols.</i>")
				var/withdraw = input("How much you want to withdraw | There is [src.obols] obols in [src].","[src]",src.obols) as num
				if(!withdraw)
					return
				withdraw = abs(withdraw) //No negative numbers.
				if(withdraw > src.obols)
					to_chat(usr, "There's not enough obols to withdraw that amount!")
				if(withdraw < 0)
					to_chat(usr, "That is an invalid amount to withdraw!")
					message_admins("[usr.client.ckey] just tried to withdraw a negative amount of obols from a vendor.")
					return
				if(get_dist(usr,src) > 1)
					return
				if(withdraw <= src.obols)
					to_chat(usr, "<i>You withdraw [withdraw] from [src].</i>")
					playsound(src.loc, 'sound/effects/coin_m.ogg', 30, 0)
					spawn_money(withdraw,src.loc)
					src.obols -= withdraw
					playsound(src.loc, pick('sound/webbers/console_input1.ogg', 'sound/webbers/console_input2.ogg', 'sound/webbers/console_input3.ogg'), 100, 0, -5)
		else
			to_chat(usr, "Fnord. You can't.")
	for(var/obj/item/L in contents)
		var/ProductPrice =  L.priceSet

		if(href_list["code"])
			if(src.obols < ProductPrice)
				to_chat(usr, "Not enough obols, [ProductPrice] required!")
				return
			if(src.obols >= ProductPrice && href_list["code"] == L.name)
				contents -= L
				L.loc = src.loc
				playsound(src.loc, pick('sound/webbers/console_input1.ogg', 'sound/webbers/console_input2.ogg', 'sound/webbers/console_input3.ogg'), 100, 0, -5)
				playsound(src.loc, L.drop_sound, 100, 0, -5)
				src.obols -= ProductPrice