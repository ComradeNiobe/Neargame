/client/proc/HttpPost(url, data)
	src << output(list2params(list(url, json_encode(data))), "http_post_browser.browser:post")

/client/Topic(href, href_list, hsrc)
	..()
	switch(href_list["action"])
		if("f12")
			src.helpmenu()
			return
		if("feedback")
			var/list/feedlist = list("Bug","Propose an Idea","Share Impressions","Report Balance Issues","Mistranslations","Possible Abuse","Mapping Flaw","Ideas for New Maps", "Offer an Item Description","(CANCEL)")
			var/bugtype = input("Select Category","[src.key] Feedback") in feedlist
			if(bugtype == "(CANCEL)")
				return
			to_chat(src, check_feedtype(bugtype))
			var/bugreport = sanitize_safe(input("Write, you don't need to follow the template if your category isn't bug related!","Feedback","Problem description:\n\nCircumstances:\n\nSteps to reproduce the bug:")) as message
			if(!bugreport)
				to_chat(src, "<span class='highlighttext'>Invalid input!</span>")
				return
			var/bugreporttext = "**__FEEDBACK__**| [ckey]|*Story [story_id]* \n `[bugtype]`"
			if(bugtype == "Mapping Flaw")
				bugreporttext = "**__FEEDBACK__**| [ckey]|*Story [story_id]* \n`[bugtype]` \n`LOCATION:[usr.x]x, [usr.y]y, [usr.z]z` \n`MAP:[currentmaprotation]`"
			HttpPost(config.webhook,list(content = bugreporttext,username = key))
			spawn(10)
				HttpPost(config.webhook,list(content = bugreport,username = key))
				to_chat(src, "<span class='highlighttext'>Your feedback has been reported. <i>\"[bugreport]\"</i></span>")
				src << 'sound/effects/thanet.ogg'
		if("donos")
			to_chat(src, SPAN_ITALIC("Your report will only be visible to those who participate in the decision-making process."))
			var/donostext = sanitize_safe(input("Enter your report here","DONOS")) as message
			if(!donostext)
				to_chat(src, SPAN_HLTEXT("Invalid input!"))
				return
			var/donostemplate = "**__DONOS__**| [ckey]|*Story [story_id]*"
			HttpPost(config.webhook,list(content = donostemplate,username = key))
			spawn(10)
				HttpPost(config.webhook,list(content = donostext,username = key))
				to_chat(src, SPAN_HLTEXT("Your donos has been sent. \"[donostext]\""))
				src << 'sound/effects/thanet.ogg'
		if("positive")
			to_chat(src, "<i>Your opinion will only be visible to those who participate in the decision-making process.</i>")
			var/chosenkey = sanitize_safe(input("Input a ckey (EXACT USERNAME, CANNOT BE MOB NAME)","[src.key] - Positive Reputation"))
			if(!chosenkey)
				to_chat(src, "<span class='highlighttext'>Invalid Key!</span>")
				return
			var/checkkey = ckey(chosenkey)
			if(src.ckey == checkkey)
				to_chat(src, "<span class='highlighttext'>Fuck you.</span>")
				return
			if(!ckeywhitelistweb.Find(checkkey))
				to_chat(src, "<span class='highlighttext'>This Key does not exist, is banned or invalid!</span>")
				return
			var/feedbackgood = sanitize_safe(input("Negative and positive feedback about the player will be checked when making a decision about him - increasing or decreasing access level, banishing and so on.\n Here you can write both significant situations and the general impression; \n preferably supporting it with examples.\n (For unnaceptable behaviour, use ordinary donoses: they are checked often).","Comrade"))
			if(length(feedbackgood) <= 10 || length(feedbackgood) >= 1024)
				to_chat(src, "<span class='highlighttext'>Reason is too long or too short.</span>")
				return
			var/feedbackgoodtext = "**__FEEDBACK__:** | [chosenkey]| *Positive!*"
			var/endfeedback = "`[feedbackgood]`"
			HttpPost(config.webhook,list(content = feedbackgoodtext,username = key))
			var/DBQuery/feedback_good = dbcon.NewQuery("INSERT INTO reputation (ckey, giver_ckey, value, reason) VALUES (\"[checkkey]\", \"[src.ckey]\", \"1\", \"[feedbackgood]\")")
			spawn(10)
				HttpPost(config.webhook,list(content = endfeedback,username = key))
				if(!feedback_good.Execute())
					world.log << feedback_good.ErrorMsg()
					to_chat(src, "<span class='highlighttext'>Something went wrong. Report it.</span>")
					return
				to_chat(src, "<span class='highlighttext'>Your feedback has been sent. <i>\"[feedbackgood]\"</i></span>")
				src << 'sound/effects/thanet.ogg'
		if ("negative")
			to_chat(src, "<i>Your opinion will only be visible to those who participate in the decision-making process.</i>")
			var/chosenkey = sanitize_safe(input("Input a ckey (EXACT USERNAME, CANNOT BE MOB NAME)","[src.key] - Negative Reputation"))
			if(!chosenkey)
				to_chat(src, "<span class='highlighttext'>Invalid Key!</span>")
				return
			var/checkkey = ckey(chosenkey)
			if(src.ckey == checkkey)
				to_chat(src, "<span class='highlighttext'>Fuck you.</span>")
				return
			if(!ckeywhitelistweb.Find(checkkey))
				to_chat(src, "<span class='highlighttext'>This Key does not exist, is banned or invalid!</span>")
				return
			var/feedbackbad = sanitize_safe(input("Negative and positive feedback about the player will be checked when making a decision about him - increasing or decreasing access level, banishing and so on.\n Here you can write both significant situations and the general impression; \n preferably supporting it with examples.\n (For unnaceptable behaviour, use ordinary donoses: they are checked often).","Enemy"))
			if(length(feedbackbad) <= 10 || length(feedbackbad) >= 1024)
				to_chat(src, "<span class='highlighttext'>Reason is too long or too short.</span>")
				return
			var/feedbackbadtext = "**__FEEDBACK__:** | [chosenkey]| *Negative!*"
			var/endfeedback = "`[feedbackbad]`"
			HttpPost(config.webhook,list(content = feedbackbadtext,username = key))
			var/DBQuery/feedback_bad = dbcon.NewQuery("INSERT INTO reputation (ckey, giver_ckey, value, reason) VALUES (\"[checkkey]\", \"[src.ckey]\", \"-1\", \"[feedbackbad]\")")
			spawn(10)
				HttpPost(config.webhook,list(content = endfeedback,username = key))
				if(!feedback_bad.Execute())
					world.log << feedback_bad.ErrorMsg()
					to_chat(src, "<span class='highlighttext'>Something went wrong. Report it.</span>")
					return
				to_chat(src, "<span class='highlighttext'>Your feedback has been sent. <i>\"[feedbackbad]\"</i></span>")
				src << 'sound/effects/thanet.ogg'
				return

/proc/check_feedtype(var/feedtype)
	switch(feedtype)
		if("Bug")
			return "<span class='jogtowalk'>Include all the relevant information on what caused the bug, where it happened and how to reproduce it.</span>"
		if("Mistranslations")
			return "<span class='jogtowalk'>Include all the relevant information on what caused the bug, where it happened and how to reproduce it.</span>"
		if("Mapping Flaw")
			return "<span class='jogtowalk'>Your current coordinates and the map's name will be added to the report automatically.</span>"
		if("Report Balance Issues")
			return "<span class='jogtowalk'>Requests for increasing Strength or Combat Skills for a role or a gender won't be considered.</span>"
		if("Share Impressions")
			return "<span class='jogtowalk'>You can pour your anger and satisfaction here.</span>"
		if("Possible Abuse")
			return "<span class='jogtowalk'>Include all the relevant information on what and how the exploit is abused.</span>"
		if("Ideas for New Maps")
			return "<span class='jogtowalk'>Reports in these categories are rarely answered, but still always read: Share Impressions, Map Ideas, Item Descriptions.</span>"
		if("Propose an Idea")
			return "<span class='jogtowalk'>Reports in these categories are rarely answered, but still always read: Share Impressions, Map Ideas, Item Descriptions.</span>"
		if("Offer an Item Description")
			return "<span class='jogtowalk'>A decent item lacks description? You can offer your own. Dark and twisted humour is welcome.</span>"

/client/verb/helpmenu()
	set name = ".helpmenu"
	set category = "OOC"
	var/chosenoption = input("Select a command.", "HELP!") in list("(FEEDBACK)","HELP","Recipes","Beliefs","(CANCEL)")
	if(!chosenoption)
		return
	switch(chosenoption)
		if("(FEEDBACK)")
			to_chat(src, "\n<div class='firstdivmood'><div class='moodbox'>\n<span class='graytext'>\[</span><span class='feedback'><a href='byond://?src=\ref[src];action=feedback'>GIVE FEEDBACK</a></span><span class='graytext'>] Use it with care.</span>\n<hr class='linexd'><span class='graytext'><a href='byond://?src=\ref[src];action=donos'>Report Player(s)</a></span>\n<span class='feedback'><a href='byond://?src=\ref[src];action=positive'>Add Positive</a></span>\n<span class='feedback'><a href='byond://?src=\ref[src];action=negative'>Add Negative</a></span>\n<span class='graytextbold'>My reputation</span><span class='graytext'>: [myrepcheck()]</div></div>")

			var/chosenkey = sanitize_safe(input("Input a ckey.","[src.key]"))
			if(!chosenkey)
				to_chat(src, "<span class='highlighttext'>Invalid Key!</span>")
				return
			var/negopos = input("What kind of Feedback do you want to give?", "[chosenkey]") in list("Positive","Negative")
			switch(negopos)
				if("Positive")
					var/feedbackgood = sanitize_safe(input("Why is this player a good player, do they deserve a higher rank?","[chosenkey]"))
					var/feedbackgoodtext = "**__FEEDBACK__:** | [chosenkey]| *Positive!*"
					var/endfeedback = "`[feedbackgood]`"
					HttpPost(config.webhook,list(content = feedbackgoodtext,username = key))
					spawn(10)
						HttpPost(config.webhook,list(content = endfeedback,username = key))
						to_chat(src, "<span class='highlighttext'>Your feedback has been sent. <i>\"[feedbackgood]\"</i></span>")
						src << 'sound/effects/thanet.ogg'
				if("Negative")
					var/feedbackbad = sanitize_safe(input("Why is this player a bad player, do they deserve a punishment?","[chosenkey]"))
					var/feedbackbadtext = "**__FEEDBACK__:** | [chosenkey]| *Negative!*"
					var/endfeedback = "`[feedbackbad]`"
					HttpPost(config.webhook,list(content = feedbackbadtext,username = key))
					spawn(10)
						HttpPost(config.webhook,list(content = endfeedback,username = key))
						to_chat(src, "<span class='highlighttext'>Your feedback has been sent. <i>\"[feedbackbad]\"</i></span>")
						src << 'sound/effects/thanet.ogg'
			return
		if("Report Bug")
			var/bugreport = sanitize_safe(input("Report your bug with details.","[src.key]"))
			if(!bugreport)
				to_chat(src, "<span class='highlighttext'>Invalid input!</span>")
				return
			var/bugreporttext = "**__BUG REPORT__**"
			HttpPost(config.webhook,list(content = bugreporttext,username = key))
			spawn(10)
				HttpPost(config.webhook,list(content = bugreport,username = key))
				to_chat(src, "<span class='highlighttext'>Your bug has been reported. <i>\"[bugreport]\"</i></span>")
				src << 'sound/effects/thanet.ogg'
		if("HELP")
			var/dat = "<META http-equiv='X-UA-Compatible' content='IE=edge' charset='UTF-8'> <style type='text/css'> @font-face {font-family: Gothic;src: url(gothic.ttf);} @font-face {font-family: Book;src: url(book.ttf);} @font-face {font-family: Hando;src: url(hando.ttf);} @font-face {font-family: Eris;src: url(eris.otf);} @font-face {font-family: Brandon;src: url(brandon.otf);} @font-face {font-family: VRN;src: url(vrn.otf);} @font-face {font-family: NEOM;src: url(neom.otf);} @font-face {font-family: 'PTSansWebRegular';src: url('./PTSANS.woff2') format('woff2');} @font-face {font-family: Type;src: url(type.ttf);} @font-face {font-family: Enlightment;src: url(enlightment.ttf);} @font-face {font-family: Arabic;src: url(arabic.ttf);} @font-face {font-family: Digital;src: url(digital.ttf);} @font-face {font-family: Cond;src: url(cond2.ttf);} @font-face {font-family: Semi;src: url(semi.ttf);} @font-face {font-family: Droser;src: url(Droser.ttf);} .goth {font-family: Gothic, Verdana, sans-serif;} .book {font-family: Book, serif;} .hando {font-family: Hando, Verdana, sans-serif;} .typewriter {font-family: Type, Verdana, sans-serif;} .arabic {font-family: Arabic, serif; font-size:180%;} .droser {font-family: Droser, Verdana, sans-serif;} </style> <style type='text/css'> body {font-family: 'PTSANS'; cursor: url('pointer.cur'), auto; padding: 10px; letter-spacing = 0.25; } span.loom { background: #E2E2E2; color: #2f2f2f; letter-spacing = 0.25; font-weight: 700; } span.news { background: #c0c0b9; letter-spacing = 0.35; font-style: italic font-size: 10px; font-family: monospace; } span.bheader { text-transform:uppercase; font-size: 40px; font-family: sans-serif; } table,tr,td { border: 0px; } table { width:100%; } tr { padding: 2px; } tr.text1 { color: #300; background: #eee; } tr.text2 { color: #000; background: #e5e5e0; } span.fondheader { background: #E2E2E2; color: #2f0000; font-weight: 700; } hr { border-color: #333333; } </style> <body background bgColor=#E9E9E9 text=#0d0d13 alink=#777777 vlink=#777777 link=#777777> <style type='text/css'> body { cursor: url('pointer.cur'), auto; animation-name: blinker; animation-duration: 1s; animation-timing-function: linear; animation-iteration-count: infinite; } @keyframes blinker { 0% { opacity: 1.0; } 50% { opacity: 0.7; } 100% { opacity: 1.0; } } </style> <META http-equiv='X-UA-Compatible' content='IE=edge' charset='UTF-8'> <BR><BR><BR><BR><BR><span class='fondheader'> SPEECH </span><BR>Whisper: '+Now we're doomed!'<BR>Custom speech: 'smiles*Now we're doomed!'<BR>Primary radio channel: ';Now we're doomed!'<BR>Dedicated radio channel: ':sNow we're doomed!'<BR>Servants radio channel: ':zNow we're doomed!'<BR><BR><span class='fondheader'> BASIC STUFF </span><BR><BR>Swim Up / Dive: PgUp/PgDn<BR>Toggle Attack Mode: PgDn<BR>Toggle Active Hand: PgUp<BR>Examine: SHIFT+LMB<BR>Point at: CTRL+RMB<BR>Pull: CTRL+LMB<BR>Toggle Combat Mode: INSERT<BR>Repair a Firearm: RMB<BR>Give something: RMB+HELP<BR>Target with a ranged weapon: RMB + HARM<BR>Undress: drag the target onto yourself<BR><BR><span class='fondheader'> WSAD </span><BR>Swap Hands: Space<BR>Combat styles: CTRL+1 ... CTRL+8<BR>Intents: 1 ... 4<BR>Intents #2: SHIFT+1 ... SHIFT+4<BR>Resist: R<BR>Use item: E<BR>Drop item: X<BR>Throw item: C<BR>Talk: T<BR>Grab with both hands: CTRL+Space<BR>Search for danger : CTRL+F<BR>Sneak: CTRL+C<BR>Look up: Q<BR>Fixed eye: G<BR>Combat mode: Z<BR>Stand/Lie down: V<BR>Raise/Unbuckle: CTRL+Q<BR>Dive/Buckle/Sit on a bottle: CTRL+Z<BR>Stop pulling: F<BR>Parry/dodge: `<BR>Blind attack: K<BR>Backwards blind attack: CTRL+K<BR><BR><BR><span class='fondheader'> ADDITIONAL </span><BR>F6: OOC/LOOC<BR>F10: Cancel Camera View<BR>F11: Input Commands<BR>F12: HELP<BR><BR><span class='fondheader'> MEDICAL TRICKS </span><BR><BR>Check pulse: EMPTY HAND + RMB +HELP<BR>Splint: have a stick in the other hand while bandaging<BR>Remove bandages: RMB + GRA<BR>Mouth-to-mouth: LMB + HELP + ZONE:MOUTH<BR>Heart massage: LMB + HELP + ZONE:HEART<BR>Bad things: drag yourself onto a victim<BR>Field Surgery: MMB with a sharp weapon (dangerous)<BR><BR><span class='fondheader'> ADVANCED SECRETS </span><BR>Look at the distance: ALT + RMB.<BR>Advanced climbing: drag yourself to a nearby wall (cling on), then drag yourself to a nearby tile (climb towards it)<BR>Combat styles: CTRL+1 ... CTRL+8<BR>Get rid of bad memories: get drunk and cry with 2 friends.<BR>Advanced attack: RMB+HARM/RMB in COMBAT MODE<BR>Roll up a sleeve: RMB on your clothing<BR>Tear a sleeve off: MMB on your clothing<BR>Spit Out: RMB on BITE<BR>Gaze Around (find enemies and traps): RMB on Fixed Eye<BR>Reset Camera: MMB on Fixed Eye<BR><BR><span class='fondheader'> INTERFACE </span><BR>Fullscreen: CTRL+ENTER<BR>Hide the statusbar: TAB<BR><BR><span class='fondheader'> SPECIAL COMMANDS (F11) </span><BR>retro: old interface (for smaller screens)<BR>sethand : as a Baron, choose someone as a Hand (before round starts)<BR>setspouse : choose someone as your spouse<BR>setfontsize : modify the default font size<BR>brohand : agree to be a Hand (except Merchant and Inquisitor)<BR>showlads : show player keys (after roundend)<BR>squireme : priority of squire assignment<BR>fix64 : x2 resolution instead of stretch<BR>mycolor: choose OOC color (if available)<BR><BR>"
			src << browse(dat, "window=help,size=500x500")
		if("Recipes")
			var/dat = "<META http-equiv='X-UA-Compatible' content='IE=edge' charset='UTF-8'> <style type='text/css'> @font-face {font-family: Gothic;src: url(gothic.ttf);} @font-face {font-family: Book;src: url(book.ttf);} @font-face {font-family: Hando;src: url(hando.ttf);} @font-face {font-family: Eris;src: url(eris.otf);} @font-face {font-family: Brandon;src: url(brandon.otf);} @font-face {font-family: VRN;src: url(vrn.otf);} @font-face {font-family: NEOM;src: url(neom.otf);} @font-face {font-family: 'PTSansWebRegular'; src: url('./PTSANS.woff2') format('woff');} @font-face {font-family: Type;src: url(type.ttf);} @font-face {font-family: Enlightment;src: url(enlightment.ttf);} @font-face {font-family: Arabic;src: url(arabic.ttf);} @font-face {font-family: Digital;src: url(digital.ttf);} @font-face {font-family: Cond;src: url(cond2.ttf);} @font-face {font-family: Semi;src: url(semi.ttf);} @font-face {font-family: Droser;src: url(Droser.ttf);} .goth {font-family: Gothic, Verdana, sans-serif;} .book {font-family: Book, serif;} .hando {font-family: Hando, Verdana, sans-serif;} .typewriter {font-family: Type, Verdana, sans-serif;} .arabic {font-family: Arabic, serif; font-size:180%;} .droser {font-family: Droser, Verdana, sans-serif;} </style> <style type='text/css'> body {font-family: 'PTSansWebRegular';cursor: url('pointer.cur'), auto;} hr { border-color: #333333; } </style>"
			dat += "<body background bgColor=#b7b7b7 text=#0d0d13 alink=#777777 vlink=#777777 link=#777777> <B>KITCHEN</B><BR> <BR>PIE<BR> 2x Dough + 1x Butter + 2x Any Ingredient<BR> <BR><BR>FISH STICKS<BR> 1x Fish + 1x Flour<BR> <BR>PLUMPCAKE<BR> 3x Plump Helmets, 1x Honeycomb<BR> <BR>HONEY MAGGOT<BR> 1x Purring Maggot, 1x Honeycomb<BR> <BR>2x CRACKERS<BR> 1x Dough Slice<BR> <BR>RATBURGER<BR> 1x Rat, 1x Bun<BR> <BR>CHEESERATBURGER<BR> 1x Rat, 1x Bun, 1x Cheese Slice<BR> <BR>SWEET APPLE<BR> 1x Apple, 1x Sugar<BR> <BR>3x BUNS<BR> 1x Dough<BR> <BR>FLATBREAD<BR> 1x Flatdough<BR> <BR>LOAF<BR> 1x Flour, 1x Egg<BR> <BR>CAKE<BR> 2x FLAT DOUGH, 1x Honeycomb or Sugar, 1x Lemon/Orange/Candy/Carrot<BR> <BR>CUTLET<BR> 1x Raw Cutlet<BR> <BR>3x SCHAURMA<BR> 1x Flatbread, 1x Fried Meat, 1x Cabbage<BR> <BR><BR>BAKED POTATO<BR> 1x Potato<BR> <BR>3x PANCAKE<BR> 1x Dough, 1x Butter Slice<BR> <BR>Raw Cutlet<BR> cut meat<BR> <BR>Salt<BR> grind Zhelezniak<BR> <BR>Pepper<BR> grind Korpny<BR> <BR><HR><BR> <B>BOIL:</B><BR> SOAP: Fat+Ash<BR> CHEESE: Otorvyannik Juice + Milk<BR> <BR><HR><BR> <B>Alchemy</B><BR> Cave Wine: 3 Plump Helmet<BR> Scavengers Oil: 1x Krovnik, 2 Podgnilnik.<BR> Grey Honey: Honey 1x, 1x Ashes. |Boil.|<BR> Love Potion: 2 Zhelezniak, 1x Bezglaznik<BR> Bridge of the True Faith: 2 Ovrazhnik, 1x Otorvyannik<BR> Curiorture: 1x Otorvyannik, 1x Slezyak, 1x Barhovik<BR> Voice of Thunder: 1x Slezyak, 1x Zelegrib, 1x Korpny<BR> Smile of the Savior: 2 Slezyak, 1x Ovrazhnik<BR> Flaying potion: 2 Barhovik, 1x Lyutogrib<BR> Sorokoputka: 2 Lyutogrib, 1x Podgnilnik<BR> Dream Beauties: 1x Barhovik, 1x Zhelezniak, 1x Korpny<BR> Berserker's Sweat: 3 Bezglaznik<BR> Sparkling Juice: 2 Otorvyannik, 1x Lyutogrib<BR> Cain's Forgiveness: 3 Lyutogrib<BR> Rotcleaner: 2x Barhovik, 1x Krovnik<BR> Potion Of Impossible Targets: 2x Zelegrib, 1x Krovnik<BR> Potion of Dead Memory: 1x Zelegrib, 2 Bezglaznik<BR> Potion Of Flawless Skin: 1x Bezglaznik, Korpny 1x, 1x Podgnilnik"
			src << browse(dat, "window=recipes,size=500x500")
		if("Beliefs")
			var/dat = "<META http-equiv='X-UA-Compatible' content='IE=edge' charset='UTF-8'> <style type='text/css'> @font-face {font-family: Gothic;src: url(gothic.ttf);} @font-face {font-family: Book;src: url(book.ttf);} @font-face {font-family: Hando;src: url(hando.ttf);} @font-face {font-family: Eris;src: url(eris.otf);} @font-face {font-family: Brandon;src: url(brandon.otf);} @font-face {font-family: VRN;src: url(vrn.otf);} @font-face {font-family: NEOM;src: url(neom.otf);} @font-face {font-family: 'PTSansWebRegular';src: url('./PTSANS.woff2') format('woff2');} @font-face {font-family: Type;src: url(type.ttf);} @font-face {font-family: Enlightment;src: url(enlightment.ttf);} @font-face {font-family: Arabic;src: url(arabic.ttf);} @font-face {font-family: Digital;src: url(digital.ttf);} @font-face {font-family: Cond;src: url(cond2.ttf);} @font-face {font-family: Semi;src: url(semi.ttf);} @font-face {font-family: Droser;src: url(Droser.ttf);} .goth {font-family: Gothic, Verdana, sans-serif;} .book {font-family: Book, serif;} .hando {font-family: Hando, Verdana, sans-serif;} .typewriter {font-family: Type, Verdana, sans-serif;} .arabic {font-family: Arabic, serif; font-size:180%;} .droser {font-family: Droser, Verdana, sans-serif;} </style> <style type='text/css'> body {font-family: 'PTSANS'; cursor: url('pointer.cur'), auto; padding: 10px; letter-spacing = 0.25; } span.loom { background: #E2E2E2; color: #2f2f2f; letter-spacing = 0.25; font-weight: 700; } span.news { background: #c0c0b9; letter-spacing = 0.35; font-style: italic font-size: 10px; font-family: monospace; } span.bheader { text-transform:uppercase; font-size: 40px; font-family: sans-serif; } table,tr,td { border: 0px; } table { width:100%; } tr { padding: 2px; } tr.text1 { color: #300; background: #eee; } tr.text2 { color: #000; background: #e5e5e0; } span.fondheader { background: #E2E2E2; color: #2f0000; font-weight: 700; } hr { border-color: #333333; } </style> <body background bgColor=#E9E9E9 text=#0d0d13 alink=#777777 vlink=#777777 link=#777777> <style type='text/css'> body { cursor: url('pointer.cur'), auto; animation-name: blinker; animation-duration: 1s; animation-timing-function: linear; animation-iteration-count: infinite; } @keyframes blinker { 0% { opacity: 1.0; } 50% { opacity: 0.7; } 100% { opacity: 1.0; } } </style> <META http-equiv='X-UA-Compatible' content='IE=edge' charset='UTF-8'> <TITLE>Faith and Devotion</TITLE><BR><span class='bheader'>Post-Christianity</span><BR><i>God is Hell.</i><BR><span class='fondheader'>The Keys </span><BR><BR><table><tr class='text2'><td> • Nothing has rejected what Nothing was not, and it was a word. The word was GOD. </td></tr><tr class='text1'><td> • By rejecting everything the God was not, He became guilty of the Universe. He did not create skies nor planets, but he casted them like a man casts a shadow. By denying everyone who He wasn't and everything He couldn't be, the Lord became the reason of Angels and the seed of life. </td></tr><tr class='text2'><td> • Angels are anti-image of God. Breeding nothingness, in which His silhouette looms. By multiplying, they've multiplied life, meaning and laws, inventing the good and evil. </td></tr><tr class='text1'><td> • Angels and animals did not know any compassion, but they felt fear and pain - and any pain feels like the world for it's victim. God was unlike them. He felt empathy towards their pain, crushed by it with in a divine torment only He is capable of. </td></tr><tr class='text2'><td> • However strong His agony was, He himself still was the Law. By force, he retracted as many angels, souls and animals as he could back inside, to make them merge with Him. His suffering was lessened as they've dissolved in him and their pain is gone. But being less of himself, he began to drown into Coma. </td></tr><tr class='text1'><td> • Coma is a process that is reverse to Godbirth, a gradual intergrowth of God and Nothing. </td></tr><tr class='text2'><td> • Man is created by angels in the moment of their dissolution in God - he made in His and Their images at the same time. That is why mankind is doomed to be miserable. </td></tr><tr class='text1'><td> • The Appearance of Christ is a gleam of agonizing God's mind. After collecting the pain of his people in himself, Christ has managed to invoke compassion of enormous number of people, so the torture has bypassed the Lord without claiming His senses, making his burden a little less heavy. </td></tr><tr class='text2'><td> • For thousands of years Exoteric christianity has healed God's wounds, but then the teaching has begun to fade out. </td></tr><tr class='text1'><td> • And then new kind of Christs arrived - evil dictators, their fanatics and millions of innocent victims, all together secretly focused in a world-saving conspiracy of pity and compassion. And these Appearances were not the last... </td></tr><tr class='text2'><td> • After death, a man's soul flows into God, and God becomes Hell for him, for the man became the one with the Lord, stuck between the torture and the oblivion. </td></tr><tr class='text1'><td> • We have to save God so he cold save us. If God will continue to consume angels and decay, eventually we'll also become Nothing, simultaneously being the God. This moment of theurgical singularity is more painful and lasts longer than everything that our Lord himself could imagine with His endless mind. </td></tr><tr class='text2'><td> • Prayers, rituals, religious thoughts and living a pious life devoted to God is the way for a man to both separate himself from God-in-Coma and relieve His burden. By saving the Lord and saving himself from the Lord, a man can reach the Exclusion - the blessing of the final non-divinity through un-making his psyche and becomming the Angelic Heaven: a soulless, thoughtless and timeless existence as afterdeath matter. </td></tr><tr class='text1'><td> • The Grey Church priests help the flock by collecting the rot and fat of their souls during confessions, and handing the sins to their ecclesial superiors. The reason for this is forbidden to know. </td></tr></table><BR><BR><BR><span class='bheader'>Thanati</span><BR><i>'Transmutation through Death.'</i><BR><BR><span class='fondheader'>The Keys</span><BR><table><BR><tr class='text2'><td> • Our Multiverse is a bleak and miserable place. Its possibilities are limited and poor even for godlike beings.</td></tr><tr class='text1'><td> • Our Lord Tzchernobog is one of the supreme creatures of the First God, and he showed us the way.</td></tr><tr class='text2'><td> • The Multiverse shall be replaced.</td></tr><tr class='text1'><td> • When the weak Old God created the Universe, he couldn't keep it all in his mind, therefore he created the Living, who were supposed to seal the Order of Things by their faith and conscience.</td></tr><tr class='text2'><td> • A truly new Multiverse cannot exist before Infinity becomes Zero.</td></tr><tr class='text1'><td> • The Moment of Now doesn't exist without the Living.</td></tr><tr class='text2'><td> • Tzchernobog is able to create a far more complicated and marvelous world, where we all shall be reborn.</td></tr><tr class='text1'><td> • To achieve the Great Rebirth, it is necessary for us to destroy the First God by sending Him and all his followers into Oblivion.</td></tr></table><BR><BR><span class='bheader'>Cult of Cons</span><BR><i>'We exist only to serve'</i><BR><BR><span class='fondheader'>The Keys</span><BR><table><tr class='text2'><td> • God sleeps captured in Time, which is nothing but a Trap for him.</td></tr><tr class='text1'><td> • The essence of God is shared among all humanity. The Spark of Him shines inside every human being.</td></tr><tr class='text2'><td> • Any life is priceless. One's happiness and personality mean nothing.</td></tr><tr class='text1'><td> • Every man exist only due to the Spark and his only purpose is to save it through the Time.</td></tr><tr class='text2'><td> • Everything that serves for the survival of humanity is Goodness.</td></tr><tr class='text1'><td> • Any assistance to man that makes his life easier is virtue.</td></tr><tr class='text2'><td> • Any harm made to living body is Pure Evil.</td></tr><tr class='text1'><td> • The Day when God will rise above all and Time will cease to exist, is expected to come after 13 centuries. Humanity must live till that moment in one form or another. </td></tr><tr class='text2'><td> • In that Day all the Sparks will unite into one Endless Fire and this will be the Greatest Goodness.</td></tr></table><BR><BR><span class='bheader'>The Old Ways</span><BR><i>'Build your wings on the way down.'</i><BR><BR><span class='fondheader'>The Keys</span><BR><table><tr class='text2'><td> • Death doesn't stop our existence. When a truly living being reaches death, it's soul goes to the Shadow which is casted by reality.</td></tr><tr class='text1'><td> • In the Shadow - 'world of spirits', divided from the world of living by the Shroud, souls have limited abilities, and their stay is short.</td></tr><tr class='text2'><td> • A strong soul could be reborn in a new material form, but a weak one will surrender. It will descend into a pseudo-reality, thus losing all possibility of return to the real world.</td></tr><tr class='text1'><td> • These pseudo-realities, called Reflections, are creations of souls. Reflections are based on their memories, beliefs and scrappy knowledge of the world they lived in before.</td></tr><tr class='text2'><td> • Every Reflection casts a Shadow like the Original World does, and it is always possible to descend to a deeper Reflection.</td></tr><tr class='text1'><td> • By filling a Reflection with their impressions and thoughts - which are mostly devoted to the death and suffering before it, souls unwittingly make it a dangerous and depressive place. Their hidden fears and superstitions, even the most absurd, become real.</td></tr><tr class='text2'><td> • Memories of the real world are becoming more and more dull with each Descent. Second Reflection is more simplified, scary and unsafe than the First, and so on.</td></tr><tr class='text1'><td> • As for us, we've been dead for long, and we are in the fourth of seven Reflections. We already failed to achieve rebirth through suffering to hold our ground in the Reality and the previous Reflections.</td></tr><tr class='text2'><td> • We must stay in the Fourth Reflections at least: it is a Heaven compared to the next Reflections. There is nothing but emptiness and pure suffering in the Seventh Reflection.</td></tr></table><BR><BR><span class='fondheader'>Dead Gods</span><BR>The strongest of lost souls are called Gods. They managed to stay in the Shadow for aeons, both rejecting resurrection and avoiding the Descent.<BR><BR>Like the quasi-living, Gods are mortal: they slowly leave our Reflection, and with their leaving, the pseudoreality tangles and decays.<BR><BR>After all these millennia, their consciousnesses have become degraded and narrow, absorbed by but one of their aspects, whether it be an emotion or occupation, causing the greatest passion during their last quasi-life. Quasi-living profit by it, pleasing the passion of a god they choose, and gaining his help in reward.<BR><BR><span class='loom'>Veles</span> is the supreme god - but not because of age or strength. Being a sage and a great organizer, he skillfully solves conflicts between other gods and co-ordinates their action, saving their existence by doing so.<BR><span class='loom'>Thoth</span> is the patron of knowledge, crafts and arts. He is burning with inspiration, and he often possesses the quasi-living, forcing them to create fantastic works of art.<BR><span class='loom'>Armok</span>, God of Blood, who is obsessed with violence, cruelty and wicked fun. He is also worshipped as the Creator: he was the first one who reached the Fourth Reflection, laying the foundation of this un-reality by his presence.<BR><span class='loom'>Lir</span> favors those who live in a harmony with Nature, scorning any technologies and feeding themselves on their own by hunting or growing. Lir is the only one who has chosen a completely inhuman form.</td></tr><span class='loom'>Baccus</span>, the Lustful God, Prince of Illusions, The One Who Abides In Orgasm - is a zealot of extreme hedonism, viciousness and amoral behaviour. He rejoices watching sexual perversions becoming true and the euphoric suicide of his drug-using followers.<BR><span class='loom'>Eusoch</span> the Healer, infinitely compassive towards pain of all the quasi-living. He tries his best to delay their Descent.<BR><span class='loom'>Xom</span> is a god of chance and chaos, and he is mad like all those who intentionally become his toy.<BR><span class='loom'>Grosth</span> is the incarnation of all disgusting things one could imagine. Grosth's worshippers are total outcasts, and they are likely to be slain on sight by anyone who recognizes them.<BR><BR><span class='bheader'>Prisoners of Allah</span><BR><i>'Suffer well.'</i><BR><BR><span class='fondheader'>The Keys</span><BR><table><tr class='text2'><td> • Allah is the only god in existence - he is infinite and eternal.</td></tr><tr class='text1'><td> • Everything was created by Allah for his amusement.</td></tr><tr class='text2'><td> • Mankind is Allah's greatest shame, having been ashamed and disgusted by mankind since their creation. Instead of destroying the human race, He chose to allow them to exist, suffering. He feasts on mankind's pain.</td></tr><tr class='text1'><td> • We are all his prisoners.</td></tr><tr class='text2'><td> • Allah takes great delight torturing us - accidents, wars, pain, loss, the breaking of someone's will - all of it pleases him.</td></tr><tr class='text1'><td> • Every prisoner - that is, every man - lives again and again in endless series of rebirth. This is Allah's greatest curse. Any awakened prisoner - one who understands and accepts thing as they are - is doomed. They suffer the worst, endlessly being reborn to suffer in the worst ways imaginable.</td></tr><tr class='text2'><td> • There is only one way to break the cycle: to please Allah and break the will of others, destroying them and their every rebellion and knocking out the remnants of human dignity.</td></tr><tr class='text1'><td> • Those who are lucky to please Allah, will be gifted with a comfort in a garden by his throne, from where one could observe the torment of all other living beings, which is the greatest pleasure ever known.</td></tr></table><BR>"
			src << browse(dat, "window=beliefs,size=500x500")
		if("(CANCEL)")
			return

/client/proc/myrepcheck()
	if(info.reputation == 0 || info.reputation == null)
		return "Neutral"
	if(info.reputation >= 1 && info.reputation < 5)
		return "<font color='green'>Positive</font>"
	if(info.reputation >= 5)
		return "<span class='legendary'>Extremely Positive</span>"
	if(info.reputation <= -1 && info.reputation > -5)
		return "<span class='combat'>Negative</span>"
	if(info.reputation <= -5)
		return "<span class='combatbold'>Extremely Negative</span>"