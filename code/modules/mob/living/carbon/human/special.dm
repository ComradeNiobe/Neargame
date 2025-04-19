/datum/special
	var/name = "Special"
	var/limitations = "Nenhuma"
	var/description = "Descrição"
	var/reward = "Nenhuma"
	var/limitationsen = "None"
	var/descriptionen = "Description"
	var/rewarden = ""
	var/specialitem = null

/datum/special/proc/pick_special()
	var/specials = pick(subtypesof(/datum/special))
	if (specials)
		var/special = new specials
		return special
	else
		warning("There is an error in someone's vice.")

/datum/special/notafraid
	name = "notafraid"
	description = "Você não tem medo de cair porquê você sabe como aterrisar."
	descriptionen = "You're not afraid to fall because you know how to land right."

/datum/special/weed
	name = "weedstrong"
	description = "Maconha te deixa mais forte e mais inteligente."
	descriptionen = "Weed makes your stronger, faster and smarter."

/datum/special/squireheir
	name = "squireheir"
	limitations = "Heir."
	limitationsen = "Heir."
	description = "Você pretende ser o futuro Censor."
	descriptionen = "You pretend to become the future Kraken."

/datum/special/allah
	name = "Allah"
	description = "أنت من أتباع الله الواحد"
	descriptionen = "أنت من أتباع الله الواحد"

/datum/special/comicsans
	name = "comicsans"
	description = "Você tem uma voz desagradável."
	descriptionen = "You have an unpleasant voice."

/datum/special/mayartist
	name = "mayartist"
	descriptionen = "Tonight is your lucky night. You spent a few nights training your painting skills and tonight you might achieve great success."

/datum/special/afraidmed
	name = "afraidmed"
	description = "It's better to die than to be healed like this. You're afraid of doctors and medicine."
	descriptionen = "It's better to die than to be healed like this. You're afraid of doctors and medicine."

/datum/special/bouncer
	name = "bouncer"
	limitations = "Triton. If Pusher is present."
	limitationsen = "Triton. If Pusher is present."
	description = "You're a Bouncer. You despise the law, but love to bring order. You also love your boss-bro Pusher, and you'll crush everyone who dares to disrespect him or his place."
	descriptionen = "You're a Bouncer. You despise the law, but love to bring order. You also love your boss-bro Pusher, and you'll crush everyone who dares to disrespect him or his place."

/datum/special/succubus
	name = "succubus"
	limitations = "Mulheres."
	limitationsen = "Grown-up Females."
	description = "You're a succubus, able to enslave men through your bedroom tricks."
	descriptionen = "You're a succubus, able to enslave men through your bedroom tricks."

/datum/special/gigantism
	name = "gigantism"
	description = "You suffer of Gigantism."
	descriptionen = "You suffer of Gigantism."

/datum/special/weirdgait
	name = "weirdgait"
	description = "You have a weird gait."
	descriptionen = "You have a weird gait."

/datum/special/hardconcentrate
	name = "hardconcentrate"
	description = "Sometimes it's hard for you to concentrate."
	descriptionen = "Sometimes it's hard for you to concentrate."

/datum/special/camodevice
	name = "camodevice"
	description = "Você escondeu um dispositivo de camuflagem."
	descriptionen = "You've hidden a camouflage device."
	specialitem = /obj/item/cloaking_device

/datum/special/childworker
	limitations = "Adultos"
	limitationsen = "Grown-up Males"
	description = "Você passou sua infância trabalhando como um construtor numa obra."
	descriptionen = "You've spent your entire childhood as a worker on a construction site."

/datum/special/michaelshepard
	name = "michaelshepard"
	limitations = "Bums"
	limitationsen = "Bums"
	description = "Michael Shepard"
	descriptionen = "Michael Shepard."

/datum/special/proficientkicker
	description = "Você chuta muito bem."
	descriptionen = "You're a proficient kicker."

/datum/special/hygiene
	name = "hygiene"
	description = "Você é bem fedido."
	descriptionen = "You smell terrible and unable to do anything about it."

/datum/special/blueblood
	name = "blueblood"
	description = "Você vem de uma família nobre no norte, você é de sangue nobre."
	descriptionen = "You come from a noble family from the north, you're noble blood."

/datum/special/silverobols
	name = "silverobol"
	description = "Você escondeu obols de prata em algum lugar para as noites difíceis."
	specialitem = /obj/item/spacecash/silver/c20
	descriptionen = "You've hidden some silver obols in the safest place - just for rainy night."

/datum/special/naturalgenius
	name = "naturalgenius"
	description = "Você é um gênio não reconhecido."
	descriptionen = "You're an unrecognized genius."

/datum/special/naturalwarrior
	name = "naturalwarrior"
	description = "Você é um guerreiro nato."
	descriptionen = "You're a natural born warrior."

/datum/special/goodheart
	name = "goodheart"
	description = " You have a healthy heart."
	descriptionen = "You have a healthy heart."

/datum/special/doublewp
	name = "doublewp"
	description = "Noone could ever stop you. You gain double bonuses with Willpower."
	descriptionen = "Noone could ever stop you. You gain double bonuses with Willpower."

/datum/special/hiddengun
	name = "hiddengun"
	description = "Você tem uma arma escondida em algum lugar."
	descriptionen = "You've hidden a gun somewhere."
	specialitem = /obj/item/gun/projectile/newRevolver/duelista/neoclassic

/datum/special/weirdregurgi
	name = "weirdregurgi"
	description = "Você é obscecado por um sonho estranho em que você é engulido por um regurgitator."
	descriptionen = "You are obsessed with a weird dream where you're caught by a regurgitator."

/datum/special/deathweb
	name = "deathweb"
	description = "You are deathly afraid of the lifeweb. Being put into it would have catastrophic results."
	descriptionen = "You are deathly afraid of the lifeweb. Being put into it would have catastrophic results."

/datum/special/bulletdodger
	name = "bulletdodger"
	description = "Eles te chamam de Bullet Dodger, é difícil de você levar um tiro."
	descriptionen = "They call you the Bullet Dodger. It's harder for you to get shot."

/datum/special/gunnorth
	name = "gunnorth"
	description = "Eles te chamam de pistoleiro mais ágil do sul."
	descriptionen = "They call you the fastest gun in the South."

/datum/special/merchunt
	name = "merchunt"
	description = "Você cometeu uns erros, mercenários vão te caçar."
	descriptionen = "You've made some mistakes. Mercenaries will hunt you down."

/datum/special/oathsilence
	name = "oathsilence"
	limitations = "Pós-Cristão"
	description = "Você fez um voto de silêncio."
	descriptionen = "You gave an oath of silence."

/datum/special/alcoholicsober
	name = "alcoholicsober"
	description = "Você não é um alcoolatra, mas as coisas vão mal quando você está sóbrio."
	descriptionen = "You're not an alcoholic, but work doesn't go well when you're sober.."

/datum/special/looksmart
	name = "looksmart"
	description = "Você não parece inteligente."
	descriptionen = "You don't look smart."

/datum/special/semiteblood
	name = "semiteblood"
	description = "O sangue semita antigo fala em você, permitindo estimar o valor de um item à vontade."
	descriptionen = "Ancient semite blood speaks in you, allowing to estimate an item's value at ease. "

/datum/special/dst
	name = "dst"
	limitations = "Vadias Mulheres."
	limitationsen = "Female Whore."
	description = "Você tem uma DST mortal, transmita para 6 homens, sobreviva."
	descriptionen = "You carry a deadly STD. Give it to 6 lucky men. Survive."
	reward = "10 Cromossomos"
	rewarden = "10 Chromosomes"

/datum/special/unmarriedwoman
	name = "unmarriedwoman"
	limitations = "Mulheres Solteiras"
	limitationsen = "Unmarried women"
	description = "Procure um marido. Escape na Charon ou compre uma passagem para Vinfort."
	descriptionen = "Find a husband. Escape on the Ulysses shuttle or have a ticket to Vinfort."
	reward = "5 Cromossomos"
	rewarden = "5 Chromosomes"

/datum/special/orphanbum
	name = "orphanbum"
	limitations = "Mendigo"
	limitationsen = "Bum"
	description = "Você é agente dos Órfãos, uma organização proscrita. A sociedade pensa que você é um mal puro, que você é pior do que os hereges. Mas você tem apenas boas intenções e no caminho certo para encontrar a verdade - todas as mentiras contra você apenas confirmam isso. Complete sua missão e escape na Charon ou compre uma passagem para Vinfort."
	descriptionen = "You're an Agent of the Orphans, a proscribed organisation. The society thinks that you are a pure evil, that you're worse than heretics. But you have only good intentions and on the right way to finding the truth - all the lies against you just confirm this. Complete your mission, and escape on the Ulysses shuttle or have a ticket to Vinfort."
	reward = "5 Cromossomos"
	rewarden = "5 Chromosomes"

/datum/special/baronsurvive
	name = "baronsurvive"
	limitations = "Triton"
	limitationsen = "Triton"
	description = "Make sure the Baron survives. Survive."
	descriptionen = "Make sure the Baron survives. Survive."
	reward = "2 Cromossomos"
	rewarden = "2 Chromosomes"

/datum/special/amusermany
	name = "amusermany"
	limitations = "Amuser"
	limitationsen = "Amuser"
	description = "Being a new traveller on this path, you should gather experience and good reputation. Survive, and you'll get +1 CHR for every client you serve tonight."
	descriptionen = "Being a new traveller on this path, you should gather experience and good reputation. Survive, and you'll get +1 CHR for every client you serve tonight."
	reward = ""
	rewarden = ""

/datum/special/gloves
	name = "gloves"
	description = "Você tem alguns planos vis. Você teve que comprar luvas para evitar deixar impressões digitais."
	descriptionen = "You have some vile plans. You had to buy gloves to avoid leaving fingerprints."

/datum/special/screamerimmunity
	name = "screamerimmunity"
	description = "You were once badly bitten by a screamer, but you never became one of them."
	descriptionen = "You were once badly bitten by a screamer, but you never became one of them."

/datum/special/screamercurse
	name = "screamercurse"
	description = "A witch has cast a terrible spell on you - When you die, you will surely become a screamer."
	descriptionen = "A witch has cast a terrible spell on you - When you die, you will surely become a screamer."

/datum/special/robusta
	name = "robusta"
	limitations = "Apenas mulheres."
	limitationsen = "Only females."
	description = "Anos de Lutas intensas e treinamento para suportar seu ego obsessivo te deixaram incrivelmente melhor no combate."
	descriptionen = "Years of intense fighting and training to feed your obsessive ego have left you incredibly better in combat."

/datum/special/squireadult
	name = "squireadult"
	limitations = "Squires"
	limitationsen = "Squires"
	description = "What a disgrace! You're a grown up man and still a squire."
	descriptionen = "What a disgrace! You're a grown up man and still a squire."

/datum/special/jesterdecree
	name = "jesterdecree"
	limitations = "Bobo da Corte."
	limitationsen = "Jester."
	description = "Quando o barão não está presente, você faz decretos por ele."
	descriptionen = "When the baron is away, you make decrees for him."

/datum/special/censormagnum
	name = "censormagnum"
	limitations = "Censor."
	limitationsen = "Censor."
	description = "Até um homem forte como você precisa de um ajudante. Você está sendo assistido por uma pistola Magnum 66."
	descriptionen = "Even a strongman like you require a helper. You are being assisted by a Magnum 66 pistol."

/datum/special/archmortus
	name = "archmortus"
	limitations = "Mortus."
	limitationsen = "Mortus."
	description = "Você é o Archmortus. Forte, legal e respeitável, você conseguiu forçar a nobreza a ascender você a este título inexistente."
	descriptionen = "You're the Archmortus. Strong, cool and respectable, you've managed to force the nobility to ascend you to this non-existing title."

/datum/special/novice
	name = "novice"
	description = "A autodisciplina e a cautela fizeram com que você evitasse muitos erros. Você não tem vícios."
	descriptionen = "Self-discipline and caution have made you stay from many mistakes. You have no vices."

/datum/special/grandma
	name = "grandma"
	description = "During your childhood you had to treat your ill grandma. You've learned a lot about medicine and surgery, but your grandma died in terrible pain."
	descriptionen = "During your childhood you had to treat your ill grandma. You've learned a lot about medicine and surgery, but your grandma died in terrible pain."

/datum/special/fragile
	name = "fragile"
	description = "Você é uma coisinha frágil."
	descriptionen = "You are a fragile thing."

/datum/special/scaredark
	name = "scaredark"
	description = "You know what kind of things can lure in the shadows. You cannot stand to be in the dark."
	descriptionen = "You know what kind of things can lure in the shadows. You cannot stand to be in the dark."

/datum/special/youlooksick
	name = "youlooksick"
	description = "You look sick."
	descriptionen = "You look sick."

/datum/special/needhurry
	name = "needhurry"
	description = "No need to hurry. You walk slowly but you don't get tired that much."
	descriptionen = "No need to hurry. You walk slowly but you don't get tired that much."

/datum/special/sailor
	name = "sailor"
	description = "During your childhood, you've met a sailor. He promised to take you on a cruise around the subterranean waters of evergreen. But then he got drunk and pushed you into a toilet pit. Since then, you are deadly afraid of drowning."
	descriptionen = "During your childhood, you've met a sailor. He promised to take you on a cruise around the subterranean waters of evergreen. But then he got drunk and pushed you into a toilet pit. Since then, you are deadly afraid of drowning."

/datum/special/paingain
	name = "paingain"
	description = "Pain has finally transformed into gain. You're in a good physical shape."
	descriptionen = "Pain has finally transformed into gain. You're in a good physical shape."

/datum/special/piercinggaze
	name = "piercinggaze"
	description = "Você viu coisas em que as pessoas não acreditariam. Como resultado, seu olhar penetrante coloca terror em sua alma."
	descriptionen = "You've seen things they people wouldn't believe. As a result, your piercing gaze puts terror into their soul."

/datum/special/perception
	name = "perception"
	description = "You are able to notice little things fast."
	descriptionen = "You are able to notice little things fast."

/datum/special/avantgarde
	name = "avantgarde"
	description = "Your grandfather has enjoyed his experiments with avantgarde perfume. You don't notice the stink anymore."
	descriptionen = "Your grandfather has enjoyed his experiments with avantgarde perfume. You don't notice the stink anymore."

/datum/special/interestingperson
	name = "interestingperson"
	description = "You're an interesting person. -2 and +2 to stats."
	descriptionen = "You're an interesting person. -2 and +2 to stats."

/datum/special/badshape
	name = "badshape"
	description = "You should have been paying more attention to yourself. You're in a bad physical shape."
	descriptionen = "You should have been paying more attention to yourself. You're in a bad physical shape."

/datum/special/wormcrawl
	name = "wormcrawl"
	description = "You are scared of worms and you hate them. No one in the world could make you crawl."
	descriptionen = "You are scared of worms and you hate them. No one in the world could make you crawl."

/datum/special/robustmeister
	name = "robustmeister"
	limitations = "Meister"
	limitationsen = "Meister"
	description = "You're robust enough for a Meister."
	descriptionen = "You're robust enough for a Meister."

/datum/special/maleamuser
	name = "maleamuser"
	limitations = "Amuser."
	limitationsen = "Amuser."
	description = "Thanks to your pretty face and playful character, you've achieved the rank of an Amuser."
	descriptionen = "Thanks to your pretty face and playful character, you've achieved the rank of an Amuser."

/datum/special/little_sherif
	name = "littlesheriff"
	limitations = "Sheriff."
	limitationsen = "Sheriff."
	description = "While you may be young, your just actions and love for the law have given you the opportunity to become Sheriff."
	descriptionen = "While you may be young, your just actions and love for the law have given you the opportunity to become Sheriff."

/datum/special/rich
	name = "rich"
	limitations = "Merchant or Docker."
	limitationsen = "Merchant or Docker."
	description = "You have a task this night, get 5000 obols on merchant's console, and make your dream come true!"
	descriptionen = "You have a task this night, get 5000 obols on merchant's console, and make your dream come true!"
	reward = "10 Cromossomos"
	rewarden = "10 Chromosomes"

/datum/special/rebelsuccessor
	name = "rebelsuccessor"
	limitations = "Adult Successor."
	limitationsen = "Adult Successor."
	description = "You are a rebellious successor. Screw noble customs."
	descriptionen = "You are a rebellious successor. Screw noble customs."

/datum/special/castrated
	name = "castrated"
	limitations = "Adult Males."
	limitationsen = "Adult Males."
	description = "You've lost your manhood."
	descriptionen = "You've lost your manhood."

/datum/special/circusfreak
	name = "circusfreak"
	limitations = "Adults."
	limitationsen = "Adults."
	description = "You were raised by itinerant performers and acrobats. Knife throwing, gymnastics, rope-walking."
	descriptionen = "You were raised by itinerant performers and acrobats. Knife throwing, gymnastics, and rope-walking."

/datum/special/doinked
	name = "doinked"
	limitations = "Females."
	limitationsen = "Females."
	description = "You have something extra."
	descriptionen = "You have something extra."

/mob/living/carbon/human/proc/special_load()
	var/mob/living/carbon/human/H = src
	if(special)
		switch(special)
			if("notafraid")
				//code aqui
				warning("Special: [special] for [ckey ? "CKEY: [ckey]" : "NO CKEY"] does not exist.")
			if("Allah")
				//code aqui
				H.religion = "Allah"
			if("hygiene")
				H.hygiene = -400
				
			if("interestingperson")
				H.my_stats.change_stat(STAT_ST , rand(-2,2))
				H.my_stats.change_stat(STAT_DX , rand(-2,2))
				H.my_stats.change_stat(STAT_HT , rand(-2,2))
				H.my_stats.change_stat(STAT_IN , rand(-2,2))
			if("badshape")
				H.my_stats.change_stat(STAT_HT , -2)
				H.my_stats.change_stat(STAT_ST , -2)
			if("blueblood")
				H.add_event("nobleblood", /datum/happiness_event/noble_blood)
			if("naturalgenius")
				H.my_stats.change_stat(STAT_IN , 5)
				if(check_perk(/datum/perk/illiterate))
					H.perks.Remove(locate(/datum/perk/illiterate) in H.perks)
				H.add_perk(/datum/perk/ref/teaching)
			if("naturalwarrior")
				H.my_stats.change_stat(STAT_ST , 2)
				H.my_stats.change_stat(STAT_HT , 2)
				H.my_stats.change_stat(STAT_DX , 2)
				H.my_skills.add_skill(SKILL_MELEE, 5)
				H.my_skills.add_skill(SKILL_RANGE, 5)
			if("screamerimmunity")
				H.add_perk(/datum/perk/screamerimmunity)
			if("comicsans")
				H.comic_sans = TRUE
			if("robustmeister")
				if(H.job == "Meister")
					H.my_stats.change_stat(STAT_ST , 2)
					H.my_stats.change_stat(STAT_HT , 3)
					H.my_stats.change_stat(STAT_DX , 2)
					H.my_skills.add_skill(SKILL_MELEE, 6)
			if("squireheir")
				if(H.job == "Heir")
					H.my_skills.add_skill(SKILL_MELEE, 4)
					H.my_skills.add_skill(SKILL_RANGE, 4)
					H.my_stats.change_stat(STAT_ST , 2)
					H.equip_to_slot_or_del(new /obj/item/clothing/suit/armor/vest/security/marduk_alt2(H), slot_wear_suit)
			if("michaelshepard")
				if(H.job == "Bum")
					H.real_name = "Michael Shepard"
					H.my_skills.add_skill(SKILL_MELEE, 6)
					H.my_stats.change_stat(STAT_ST , 6)
					H.my_stats.change_stat(STAT_HT , 6)
					H.my_stats.change_stat(STAT_DX , 6)
					H.name = "Michael Shepard"
					H.gender = MALE
					H.job = "Bum"
					H.voice_name = "Michael Shepard"
					H.equip_to_slot_or_del(new /obj/item/clothing/suit/chickensuit(H), slot_wear_suit)
					H.equip_to_slot_or_del(new /obj/item/clothing/mask/chicken(H), slot_wear_mask)
					var/bumweapon = pick("knife","club","limb")
					switch(bumweapon)
						if("knife")
							if(prob(50))
								H.equip_to_slot_or_del(new /obj/item/kitchen/utensil/knife/dagger/copper(H), slot_r_hand)
							else
								H.equip_to_slot_or_del(new /obj/item/kitchen/utensil/knife(H), slot_r_hand)
						if("club")
							H.equip_to_slot_or_del(new /obj/item/melee/classic_baton/woodenclub(H), slot_r_hand)
						if("limb")
							H.equip_to_slot_or_del(new /obj/item/organ/l_leg(H), slot_r_hand)
			if("perception")
				H.my_stats.change_stat(STAT_PR, 5)
			if("paingain")
				H.my_stats.change_stat(STAT_ST, 3)
				H.my_stats.change_stat(STAT_HT, 2)
			if("grandma")
				H.my_skills.add_skill(SKILL_SURG, 12)
				H.my_skills.add_skill(SKILL_MEDIC, 12)
			if("hiddengun")
				H.special_item = pick(/obj/item/gun/projectile/newRevolver/duelista/neoclassic,/obj/item/gun/projectile/automatic/pistol/ml23,/obj/item/gun/projectile/automatic/pistol/ml23/gold, /obj/item/gun/projectile/automatic/pistol/magnum66, /obj/item/gun/projectile/automatic/pistol/magnum66/screamer23, /obj/item/gun/projectile/automatic/pistol/magnum66/mother)
			if("bulletdodger")
				H.my_stats.change_stat(STAT_DX , 3)
				H.name = "[H.real_name] Bullet Dodger"
			if("gunnorth")
				H.my_skills.change_skill(SKILL_RANGE, 17)
			if("goodheart")
				H.my_stats.change_stat(STAT_HT , 3)
			if("alcoholicsober")
				H.vice = "Alcoholic"
			if("oathsilence")
				warning("Special: [special] for [ckey ? "CKEY: [ckey]" : "NO CKEY"] does not exist.")
			if("looksmart")
				H.my_stats.change_stat(STAT_IN , 3)
			if("semiteblood")
				H.add_perk(/datum/perk/ref/value)
			if("dst")
				if(H.job == "Amuser")
					H.contract_disease(new /datum/disease/aids,1,0)
			if("orphanbum")
				if(H.job == "Bum")
					H.my_stats.change_stat(STAT_ST , 2)
					H.my_stats.change_stat(STAT_HT , 2)
					H.my_stats.change_stat(STAT_DX , 2)
					H.my_skills.add_skill(SKILL_MELEE, rand(8,11))
					H.my_skills.add_skill(SKILL_RANGE, rand(8,11))
			if("gloves")
				H.equip_to_slot_or_del(new /obj/item/clothing/gloves/black(H), slot_gloves)
			if("robusta")
				if(H.gender == FEMALE)
					H.my_skills.add_skill(SKILL_MELEE, 2)
					H.my_stats.change_stat(STAT_ST , 3)
					H.my_stats.change_stat(STAT_HT , 2)
					H.virgin = 0
			if("fragile")
				H.my_stats.change_stat(STAT_HT , -4)
			if("doublewp")
				H.add_perk(/datum/perk/heroiceffort)
			if("bouncer")
				var/haspusher = FALSE
				for(var/mob/living/carbon/human/P in mob_list)
					if(P.job == "Pusher")
						haspusher = TRUE
				if(H.job == "Triton" && haspusher == TRUE)
					if(H.wear_suit)
						qdel(H.wear_suit)
					if(H.wrist_r)
						qdel(H.wrist_r)
					if(H.belt)
						qdel(H.belt)
					if(H.r_hand)
						qdel(H.r_hand)
					H.equip_to_slot_or_del(new /obj/item/clothing/suit/storage/redjacket(H), slot_wear_suit)
					H.equip_to_slot_or_del(new /obj/item/melee/classic_baton/woodenclub(H), slot_belt)
					H.equip_to_slot_or_del(new /obj/item/clothing/mask/cigarette/weed(H), slot_r_hand)
					H.equip_to_slot_or_del(new /obj/item/device/radio/headset/bracelet(H), slot_wrist_r)
					H.my_skills.change_skill(SKILL_SWING, rand(1,3))
					H.my_skills.change_skill(SKILL_UNARM, rand(1,3))
					H.assignment = "Bouncer"
					if(wear_id)
						var/obj/item/card/id/R = wear_id
						R.registered_name = real_name
						R.rank = job
						R.assignment = H.assignment
						R.name = "[R.registered_name]'s Ring"
						R.access = list(brothel, amuser)
						qdel(H.wear_id)
						H.equip_to_slot_or_del(R, slot_wear_id)
					for(var/obj/effect/landmark/start/S in landmarks_list)
						if(S.name == "Bouncer")
							H.forceMove(S.loc)
							break
			if("censormagnum")
				
				if(H.job == "Kraken")
					H.equip_to_slot_or_del(new /obj/item/gun/projectile/automatic/pistol/magnum66(H), slot_l_hand)
			if("novice")
				H.vice = null
			if("childworker")
				H.my_skills.change_skill(SKILL_MASON, rand(12,14))
				H.my_skills.change_skill(SKILL_ENGINE, rand(12,14))
			if("succubus")
				if(H.gender == "female")
					H.make_succubi()
			if("gigantism")
				H.Altista()
			if("archmortus")
				if(H.job == "Mortus")
					H.assignment = "Archmortus"
					H.equip_to_slot_or_del(new /obj/item/clothing/mask/plaguedoctor(H), slot_wear_mask)
					H.my_skills.add_skill(SKILL_MELEE, 2)
					H.my_stats.change_stat(STAT_ST , 2)
					H.my_stats.change_stat(STAT_HT , 1)
					H.my_stats.change_stat(STAT_DX , 1)
					H.my_stats.change_stat(STAT_IN , 1)
					for(var/obj/effect/landmark/start/S in landmarks_list)
						if(S.name == "Archmortus")
							H.forceMove(S.loc)
							break
			if("squireadult")
				return
			if("maleamuser")
				if(H.job == "Amuser")
					H.set_species("Femboy")
			if("littlesheriff")
				if(H.job == "Sheriff")
					H.set_species("Child")
					if(H.wear_suit)
						qdel(H.wear_suit)
					if(H.shoes)
						qdel(H.shoes)
					if(H.w_uniform)
						qdel(H.w_uniform)
					if(H.head)
						qdel(H.head)
					if(H.belt)
						qdel(H.belt)
					H.equip_to_slot_or_del(new /obj/item/clothing/under/child_jumpsuit(H), slot_w_uniform)
					H.equip_to_slot_or_del(new /obj/item/clothing/suit/armor/vest/squire(H), slot_wear_suit)
					H.equip_to_slot_or_del(new /obj/item/clothing/shoes/lw/child/shoes(H), slot_shoes)
					H.equip_to_slot_or_del(new /obj/item/gun/projectile/newRevolver/duelista/neoclassic(H), slot_belt)
					H.equip_to_slot_or_del(new /obj/item/ammo_magazine/box/c38(H), slot_r_store)

					H.my_stats.set_stat(STAT_ST, rand(8,9))
					H.my_stats.set_stat(STAT_HT, rand(8,10))

			if("rebelsuccessor")
				if(H.job == "Successor" && H.age >= 18)
					if(H.wear_suit)
						qdel(H.wear_suit)
					if(H.shoes)
						qdel(H.shoes)
					if(H.w_uniform)
						qdel(H.w_uniform)
					if(H.amulet)
						qdel(H.amulet)
					H.equip_to_slot_or_del(new /obj/item/clothing/under/rebelsuccessor(H), slot_w_uniform)
					H.equip_to_slot_or_del(new /obj/item/clothing/head/amulet/collar(H), slot_amulet)
					H.equip_to_slot_or_del(new /obj/item/clothing/shoes/lw/stiletto_shoes(H), slot_shoes)
					H.equip_to_slot_or_del(new /obj/item/clothing/suit/rebelsuccessor(H), slot_wear_suit)
					H.my_skills.add_skill(SKILL_PARTY, rand(12,15))
					H.my_skills.add_skill(SKILL_MELEE, 6)
					H.my_stats.change_stat(STAT_ST , 3)
			if("castrated")
				if(H.age >= 18 && H.gender == MALE)
					H.mutilated_genitals = 1
			if("circusfreak")
				if(H.age >= 18)
					H.my_skills.add_skill(SKILL_MUSIC, 13)
					H.my_skills.add_skill(SKILL_CLIMB, 13)
					H.my_skills.add_skill(SKILL_THROW, 15)
					H.my_stats.change_stat(STAT_DX , 3)
					H.acrobat = 1
			if("doinked")
				if(H.gender == FEMALE)
					H.futa = TRUE
	else
		warning("Special for [ckey ? "CKEY: [ckey]" : "NO CKEY"] did not load.")
