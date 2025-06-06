
var/global/BSACooldown = 0
var/global/floorIsLava = 0
var/global/log_adminsay = 1


////////////////////////////////
/proc/message_admins(var/msg)
	msg = "<span class=\"admin\"><span class=\"prefix\">ADMIN LOG:</span> <span class=\"message\">[msg]</span></span>"
	log_adminwarn(msg)
	for(var/client/C in global.admins)
		if(R_ADMIN & C.holder.rights)
			to_chat(C, msg)

/proc/msg_admin_attack(var/text) //Toggleable Attack Messages
	log_attack(text)
	var/rendered = "<span class=\"admin\"><span class=\"prefix\">ATTACK:</span> <span class=\"message\">[text]</span></span>"
	for(var/client/C in global.admins)
		if(R_ADMIN & C.holder.rights)
			if(C.prefs.toggles & CHAT_ATTACKLOGS)
				var/msg = rendered
				to_chat(C, msg)

/proc/admin_notice(var/message, var/rights)
	for(var/mob/M in global.mob_list)
		if(check_rights(rights, 0, M))
			to_chat(M, message)

///////////////////////////////////////////////////////////////////////////////////////////////Panels

/datum/admins/proc/show_player_panel(var/mob/M in mob_list)
	set category = "Admin"
	set name = "Show Player Panel"
	set desc="Edit player (respawn, ban, heal, etc)"

	if(!M)
		to_chat(usr, "You seem to be selecting a mob that doesn't exist anymore.")
		return
	if (!istype(src,/datum/admins))
		src = usr.client.holder
	if (!istype(src,/datum/admins))
		to_chat(usr, "You are not an admin!")
		return

	var/body = "<html><head><title>Options for [M.key]</title></head>"
	body += "<body>Options panel for <b>[M]</b>"
	if(M.client)
		body += " played by <b>[M.client]</b> "
		body += "\[<A href='byond://?src=\ref[src];editrights=show'>[M.client.holder ? M.client.holder.rank : "Player"]</A>\]"

	if(istype(M, /mob/new_player))
		body += " <B>Hasn't Entered Game</B> "
	else
		body += " \[<A href='byond://?src=\ref[src];revive=\ref[M]'>Heal</A>\] "

	body += {"
		<br><br>\[
		<a href='byond://?_src_=vars;Vars=\ref[M]'>VV</a> -
		<a href='byond://?src=\ref[src];traitor=\ref[M]'>TP</a> -
		<a href='byond://?src=\ref[usr];priv_msg=\ref[M]'>PM</a> -
		<a href='byond://?src=\ref[src];subtlemessage=\ref[M]'>SM</a> -
		<a href='byond://?src=\ref[src];adminplayerobservejump=\ref[M]'>JMP</a>\] </b><br>
		<b>Mob type</b> = [M.type]<br><br>
		<A href='byond://?src=\ref[src];boot2=\ref[M]'>Kick</A> |
		<A href='byond://?_src_=holder;warn=[M.ckey]'>Warn</A> |
		<A href='byond://?src=\ref[src];newban=\ref[M]'>Ban</A> |
		<A href='byond://?src=\ref[src];jobban2=\ref[M]'>Jobban</A> |
		<A href='byond://?src=\ref[src];notes=show;mob=\ref[M]'>Notes</A>
	"}

	if(M.client)
		body += "| <A HREF='byond://?src=\ref[src];sendtoprison=\ref[M]'>Prison</A> | "
		var/muted = M.client.prefs.muted
		body += {"<br><b>Mute: </b>
			\[<A href='byond://?src=\ref[src];mute=\ref[M];mute_type=[MUTE_IC]'><font color='[(muted & MUTE_IC)?"red":"blue"]'>IC</font></a> |
			<A href='byond://?src=\ref[src];mute=\ref[M];mute_type=[MUTE_OOC]'><font color='[(muted & MUTE_OOC)?"red":"blue"]'>OOC</font></a> |
			<A href='byond://?src=\ref[src];mute=\ref[M];mute_type=[MUTE_REPORTS]'><font color='[(muted & MUTE_REPORTS)?"red":"blue"]'>REPORTS</font></a> |
			<A href='byond://?src=\ref[src];mute=\ref[M];mute_type=[MUTE_PRAY]'><font color='[(muted & MUTE_PRAY)?"red":"blue"]'>PRAY</font></a> |
			<A href='byond://?src=\ref[src];mute=\ref[M];mute_type=[MUTE_ADMINHELP]'><font color='[(muted & MUTE_ADMINHELP)?"red":"blue"]'>ADMINHELP</font></a> |
			<A href='byond://?src=\ref[src];mute=\ref[M];mute_type=[MUTE_DEADCHAT]'><font color='[(muted & MUTE_DEADCHAT)?"red":"blue"]'>DEADCHAT</font></a>\]
			(<A href='byond://?src=\ref[src];mute=\ref[M];mute_type=[MUTE_ALL]'><font color='[(muted & MUTE_ALL)?"red":"blue"]'>toggle all</font></a>)
		"}

	body += {"<br><br>
		<A href='byond://?src=\ref[src];jumpto=\ref[M]'><b>Jump to</b></A> |
		<A href='byond://?src=\ref[src];getmob=\ref[M]'>Get</A> |
		<A href='byond://?src=\ref[src];sendmob=\ref[M]'>Send To</A>
		<br><br>
		<A href='byond://?src=\ref[src];traitor=\ref[M]'>Traitor panel</A> |
		<A href='byond://?src=\ref[src];narrateto=\ref[M]'>Narrate to</A> |
		<A href='byond://?src=\ref[src];subtlemessage=\ref[M]'>Subtle message</A>
	"}

	if (M.client)
		if(!istype(M, /mob/new_player))
			body += "<br><br>"
			body += "<b>Transformation:</b>"
			body += "<br>"

			//Monkey
			if(ismonkey(M))
				body += "<B>Monkeyized</B> | "
			else
				body += "<A href='byond://?src=\ref[src];monkeyone=\ref[M]'>Monkeyize</A> | "

			//Corgi
			if(iscorgi(M))
				body += "<B>Corgized</B> | "
			else
				body += "<A href='byond://?src=\ref[src];corgione=\ref[M]'>Corgize</A> | "

			//AI / Cyborg
			if(isAI(M))
				body += "<B>Is an AI</B> "
			else if(ishuman(M))
				body += {"<A href='byond://?src=\ref[src];makeai=\ref[M]'>Make AI</A> |
					<A href='byond://?src=\ref[src];makerobot=\ref[M]'>Make Robot</A> |
					<A href='byond://?src=\ref[src];makealien=\ref[M]'>Make Alien</A> |
				"}

			//Simple Animals
			if(isanimal(M))
				body += "<A href='byond://?src=\ref[src];makeanimal=\ref[M]'>Re-Animalize</A> | "
			else
				body += "<A href='byond://?src=\ref[src];makeanimal=\ref[M]'>Animalize</A> | "

			// DNA2 - Admin Hax
			if(iscarbon(M))
				body += "<br><br>"
				body += "<b>DNA Blocks:</b><br><table border='0'><tr><th>&nbsp;</th><th>1</th><th>2</th><th>3</th><th>4</th><th>5</th>"
				var/bname
				for(var/block=1;block<=27;block++)
					if(((block-1)%5)==0)
						body += "</tr><tr><th>[block-1]</th>"
					bname = assigned_blocks[block]
					body += "<td>"
					if(bname)
						var/bstate=M.dna.GetSEState(block)
						var/bcolor="[(bstate)?"#006600":"#ff0000"]"
						body += "<A href='byond://?src=\ref[src];togmutate=\ref[M];block=[block]' style='color:[bcolor];'>[bname]</A><sub>[block]</sub>"
					else
						body += "[block]"
					body+="</td>"
				body += "</tr></table>"

			body += {"<br><br>
				<b>Rudimentary transformation:</b><font size=2><br>These transformations only create a new mob type and copy stuff over. They do not take into account MMIs and similar mob-specific things. The buttons in 'Transformations' are preferred, when possible.</font><br>
				<A href='byond://?src=\ref[src];simplemake=observer;mob=\ref[M]'>Observer</A> |
				\[ Alien: <A href='byond://?src=\ref[src];simplemake=drone;mob=\ref[M]'>Drone</A>,
				<A href='byond://?src=\ref[src];simplemake=hunter;mob=\ref[M]'>Hunter</A>,
				<A href='byond://?src=\ref[src];simplemake=queen;mob=\ref[M]'>Queen</A>,
				<A href='byond://?src=\ref[src];simplemake=sentinel;mob=\ref[M]'>Sentinel</A>,
				<A href='byond://?src=\ref[src];simplemake=larva;mob=\ref[M]'>Larva</A> \]
				<A href='byond://?src=\ref[src];simplemake=human;mob=\ref[M]'>Human</A>
				<A href='byond://?src=\ref[src];simplemake=monkey;mob=\ref[M]'>Monkey</A> |
				<A href='byond://?src=\ref[src];simplemake=robot;mob=\ref[M]'>Cyborg</A> |
				<A href='byond://?src=\ref[src];simplemake=cat;mob=\ref[M]'>Cat</A> |
				<A href='byond://?src=\ref[src];simplemake=runtime;mob=\ref[M]'>Runtime</A> |
				<A href='byond://?src=\ref[src];simplemake=corgi;mob=\ref[M]'>Corgi</A> |
				<A href='byond://?src=\ref[src];simplemake=ian;mob=\ref[M]'>Ian</A> |
				<A href='byond://?src=\ref[src];simplemake=crab;mob=\ref[M]'>Crab</A> |
				<A href='byond://?src=\ref[src];simplemake=coffee;mob=\ref[M]'>Coffee</A> |
				\[ Construct: <A href='byond://?src=\ref[src];simplemake=constructarmoured;mob=\ref[M]'>Armoured</A> ,
				<A href='byond://?src=\ref[src];simplemake=constructbuilder;mob=\ref[M]'>Builder</A> ,
				<A href='byond://?src=\ref[src];simplemake=constructwraith;mob=\ref[M]'>Wraith</A> \]
				<A href='byond://?src=\ref[src];simplemake=shade;mob=\ref[M]'>Shade</A> |
				<br>
			"}

	if (M.client)
		body += {"<br><br>
			<b>Other actions:</b>
			<br>
			<A href='byond://?src=\ref[src];forcespeech=\ref[M]'>Forcesay</A> |
			<A href='byond://?src=\ref[src];tdome1=\ref[M]'>Thunderdome 1</A> |
			<A href='byond://?src=\ref[src];tdome2=\ref[M]'>Thunderdome 2</A> |
			<A href='byond://?src=\ref[src];tdomeadmin=\ref[M]'>Thunderdome Admin</A> |
			<A href='byond://?src=\ref[src];tdomeobserve=\ref[M]'>Thunderdome Observer</A> |
		"}

	body += {"<br>
		</body></html>
	"}

	usr << browse(body, "window=adminplayeropts;size=550x515")


/datum/player_info/var/author // admin who authored the information
/datum/player_info/var/rank //rank of admin who made the notes
/datum/player_info/var/content // text content of the information
/datum/player_info/var/timestamp // Because this is bloody annoying

#define PLAYER_NOTES_ENTRIES_PER_PAGE 50
/datum/admins/proc/PlayerNotes()
	set category = "Admin"
	set name = "Player Notes"
	if (!istype(src,/datum/admins))
		src = usr.client.holder
	if (!istype(src,/datum/admins))
		to_chat(usr, "Error: you are not an admin!")
		return
	PlayerNotesPage(1)

/datum/admins/proc/PlayerNotesPage(page)
	var/dat = "<B>Player notes</B><HR>"
	var/savefile/S=new("data/player_notes.sav")
	var/list/note_keys
	S >> note_keys
	if(!note_keys)
		dat += "No notes found."
	else
		dat += "<table>"
		note_keys = sortList(note_keys)

		// Display the notes on the current page
		var/number_pages = note_keys.len / PLAYER_NOTES_ENTRIES_PER_PAGE
		// Emulate ceil(why does BYOND not have ceil)
		if(number_pages != round(number_pages))
			number_pages = round(number_pages) + 1
		var/page_index = page - 1
		if(page_index < 0 || page_index >= number_pages)
			return

		var/lower_bound = page_index * PLAYER_NOTES_ENTRIES_PER_PAGE + 1
		var/upper_bound = (page_index + 1) * PLAYER_NOTES_ENTRIES_PER_PAGE
		upper_bound = min(upper_bound, note_keys.len)
		for(var/index = lower_bound, index <= upper_bound, index++)
			var/t = note_keys[index]
			dat += "<tr><td><a href='byond://?src=\ref[src];notes=show;ckey=[t]'>[t]</a></td></tr>"

		dat += "</table><br>"

		// Display a footer to select different pages
		for(var/index = 1, index <= number_pages, index++)
			if(index == page)
				dat += "<b>"
			dat += "<a href='byond://?src=\ref[src];notes=list;index=[index]'>[index]</a> "
			if(index == page)
				dat += "</b>"

	usr << browse(dat, "window=player_notes;size=400x400")


/datum/admins/proc/player_has_info(var/key as text)
	var/savefile/info = new("data/player_saves/[copytext(key, 1, 2)]/[key]/info.sav")
	var/list/infos
	info >> infos
	if(!infos || !infos.len) return 0
	else return 1


/datum/admins/proc/show_player_info(var/key as text)
	set category = "Admin"
	set name = "Show Player Info"
	if (!istype(src,/datum/admins))
		src = usr.client.holder
	if (!istype(src,/datum/admins))
		to_chat(usr, "Error: you are not an admin!")
		return
	var/dat = "<html><head><title>Info on [key]</title></head>"
	dat += "<body>"

	var/savefile/info = new("data/player_saves/[copytext(key, 1, 2)]/[key]/info.sav")
	var/list/infos
	info >> infos
	if(!infos)
		dat += "No information found on the given key.<br>"
	else
		var/update_file = 0
		var/i = 0
		for(var/datum/player_info/I in infos)
			i += 1
			if(!I.timestamp)
				I.timestamp = "Pre-4/3/2012"
				update_file = 1
			if(!I.rank)
				I.rank = "N/A"
				update_file = 1
			dat += "<font color=#008800>[I.content]</font> <i>by [I.author] ([I.rank])</i> on <i><font color=blue>[I.timestamp]</i></font> "
			if(I.author == usr.key)
				dat += "<A href='byond://?src=\ref[src];remove_player_info=[key];remove_index=[i]'>Remove</A>"
			dat += "<br><br>"
		if(update_file) info << infos

	dat += "<br>"
	dat += "<A href='byond://?src=\ref[src];add_player_info=[key]'>Add Comment</A><br>"

	dat += "</body></html>"
	usr << browse(dat, "window=adminplayerinfo;size=480x480")



/datum/admins/proc/access_news_network() //MARKER
	set category = "Fun"
	set name = "Access Newscaster Network"
	set desc = "Allows you to view, add and edit news feeds."

	if (!istype(src,/datum/admins))
		src = usr.client.holder
	if (!istype(src,/datum/admins))
		to_chat(usr, "Error: you are not an admin!")
		return
	var/dat
	dat = text("<HEAD><TITLE>Admin Newscaster</TITLE></HEAD><H3>Admin Newscaster Unit</H3>")

	switch(admincaster_screen)
		if(0)
			dat += {"Welcome to the admin newscaster.<BR> Here you can add, edit and censor every newspiece on the network.
				<BR>Feed channels and stories entered through here will be uneditable and handled as official news by the rest of the units.
				<BR>Note that this panel allows full freedom over the news network, there are no constrictions except the few basic ones. Don't break things!</FONT>
			"}
			if(news_network.wanted_issue)
				dat+= "<HR><A href='byond://?src=\ref[src];ac_view_wanted=1'>Read Wanted Issue</A>"

			dat+= {"<HR><BR><A href='byond://?src=\ref[src];ac_create_channel=1'>Create Feed Channel</A>
				<BR><A href='byond://?src=\ref[src];ac_view=1'>View Feed Channels</A>
				<BR><A href='byond://?src=\ref[src];ac_create_feed_story=1'>Submit new Feed story</A>
				<BR><BR><A href='byond://?src=\ref[usr];mach_close=newscaster_main'>Exit</A>
			"}

			var/wanted_already = 0
			if(news_network.wanted_issue)
				wanted_already = 1

			dat+={"<HR><B>Feed Security functions:</B><BR>
				<BR><A href='byond://?src=\ref[src];ac_menu_wanted=1'>[(wanted_already) ? ("Manage") : ("Publish")] \"Wanted\" Issue</A>
				<BR><A href='byond://?src=\ref[src];ac_menu_censor_story=1'>Censor Feed Stories</A>
				<BR><A href='byond://?src=\ref[src];ac_menu_censor_channel=1'>Mark Feed Channel with Nanotrasen D-Notice (disables and locks the channel.</A>
				<BR><HR><A href='byond://?src=\ref[src];ac_set_signature=1'>The newscaster recognises you as:<BR> <FONT COLOR='green'>[src.admincaster_signature]</FONT></A>
			"}
		if(1)
			dat+= "Station Feed Channels<HR>"
			if( isemptylist(news_network.network_channels) )
				dat+="<I>No active channels found...</I>"
			else
				for(var/datum/feed_channel/CHANNEL in news_network.network_channels)
					if(CHANNEL.is_admin_channel)
						dat+="<B><FONT style='BACKGROUND-COLOR: LightGreen'><A href='byond://?src=\ref[src];ac_show_channel=\ref[CHANNEL]'>[CHANNEL.channel_name]</A></FONT></B><BR>"
					else
						dat+="<B><A href='byond://?src=\ref[src];ac_show_channel=\ref[CHANNEL]'>[CHANNEL.channel_name]</A> [(CHANNEL.censored) ? ("<FONT COLOR='red'>***</FONT>") : null]<BR></B>"
			dat+={"<BR><HR><A href='byond://?src=\ref[src];ac_refresh=1'>Refresh</A>
				<BR><A href='byond://?src=\ref[src];ac_setScreen=[0]'>Back</A>
			"}

		if(2)
			dat+={"
				Creating new Feed Channel...
				<HR><B><A href='byond://?src=\ref[src];ac_set_channel_name=1'>Channel Name</A>:</B> [src.admincaster_feed_channel.channel_name]<BR>
				<B><A href='byond://?src=\ref[src];ac_set_signature=1'>Channel Author</A>:</B> <FONT COLOR='green'>[src.admincaster_signature]</FONT><BR>
				<B><A href='byond://?src=\ref[src];ac_set_channel_lock=1'>Will Accept Public Feeds</A>:</B> [(src.admincaster_feed_channel.locked) ? ("NO") : ("YES")]<BR><BR>
				<BR><A href='byond://?src=\ref[src];ac_submit_new_channel=1'>Submit</A><BR><BR><A href='byond://?src=\ref[src];ac_setScreen=[0]'>Cancel</A><BR>
			"}
		if(3)
			dat+={"
				Creating new Feed Message...
				<HR><B><A href='byond://?src=\ref[src];ac_set_channel_receiving=1'>Receiving Channel</A>:</B> [src.admincaster_feed_channel.channel_name]<BR>" //MARK
				<B>Message Author:</B> <FONT COLOR='green'>[src.admincaster_signature]</FONT><BR>
				<B><A href='byond://?src=\ref[src];ac_set_new_message=1'>Message Body</A>:</B> [src.admincaster_feed_message.body] <BR>
				<BR><A href='byond://?src=\ref[src];ac_submit_new_message=1'>Submit</A><BR><BR><A href='byond://?src=\ref[src];ac_setScreen=[0]'>Cancel</A><BR>
			"}
		if(4)
			dat+={"
					Feed story successfully submitted to [src.admincaster_feed_channel.channel_name].<BR><BR>
					<BR><A href='byond://?src=\ref[src];ac_setScreen=[0]'>Return</A><BR>
				"}
		if(5)
			dat+={"
				Feed Channel [src.admincaster_feed_channel.channel_name] created successfully.<BR><BR>
				<BR><A href='byond://?src=\ref[src];ac_setScreen=[0]'>Return</A><BR>
			"}
		if(6)
			dat+="<B><FONT COLOR='maroon'>ERROR: Could not submit Feed story to Network.</B></FONT><HR><BR>"
			if(src.admincaster_feed_channel.channel_name=="")
				dat+="<FONT COLOR='maroon'>Invalid receiving channel name.</FONT><BR>"
			if(src.admincaster_feed_message.body == "" || src.admincaster_feed_message.body == "\[REDACTED\]")
				dat+="<FONT COLOR='maroon'>Invalid message body.</FONT><BR>"
			dat+="<BR><A href='byond://?src=\ref[src];ac_setScreen=[3]'>Return</A><BR>"
		if(7)
			dat+="<B><FONT COLOR='maroon'>ERROR: Could not submit Feed Channel to Network.</B></FONT><HR><BR>"
			if(src.admincaster_feed_channel.channel_name =="" || src.admincaster_feed_channel.channel_name == "\[REDACTED\]")
				dat+="<FONT COLOR='maroon'>Invalid channel name.</FONT><BR>"
			var/check = 0
			for(var/datum/feed_channel/FC in news_network.network_channels)
				if(FC.channel_name == src.admincaster_feed_channel.channel_name)
					check = 1
					break
			if(check)
				dat+="<FONT COLOR='maroon'>Channel name already in use.</FONT><BR>"
			dat+="<BR><A href='byond://?src=\ref[src];ac_setScreen=[2]'>Return</A><BR>"
		if(9)
			dat+="<B>[src.admincaster_feed_channel.channel_name]: </B><FONT SIZE=1>\[created by: <FONT COLOR='maroon'>[src.admincaster_feed_channel.author]</FONT>\]</FONT><HR>"
			if(src.admincaster_feed_channel.censored)
				dat+={"
					<FONT COLOR='red'><B>ATTENTION: </B></FONT>This channel has been deemed as threatening to the welfare of the station, and marked with a Nanotrasen D-Notice.<BR>
					No further feed story additions are allowed while the D-Notice is in effect.</FONT><BR><BR>
				"}
			else
				if( isemptylist(src.admincaster_feed_channel.messages) )
					dat+="<I>No feed messages found in channel...</I><BR>"
				else
					var/i = 0
					for(var/datum/feed_message/MESSAGE in src.admincaster_feed_channel.messages)
						i++
						dat+="-[MESSAGE.body] <BR>"
						if(MESSAGE.img)
							usr << browse_rsc(MESSAGE.img, "tmp_photo[i].png")
							dat+="<img src='tmp_photo[i].png' width = '180'><BR><BR>"
						dat+="<FONT SIZE=1>\[Story by <FONT COLOR='maroon'>[MESSAGE.author]</FONT>\]</FONT><BR>"
			dat+={"
				<BR><HR><A href='byond://?src=\ref[src];ac_refresh=1'>Refresh</A>
				<BR><A href='byond://?src=\ref[src];ac_setScreen=[1]'>Back</A>
			"}
		if(10)
			dat+={"
				<B>Nanotrasen Feed Censorship Tool</B><BR>
				<FONT SIZE=1>NOTE: Due to the nature of news Feeds, total deletion of a Feed Story is not possible.<BR>
				Keep in mind that users attempting to view a censored feed will instead see the \[REDACTED\] tag above it.</FONT>
				<HR>Select Feed channel to get Stories from:<BR>
			"}
			if(isemptylist(news_network.network_channels))
				dat+="<I>No feed channels found active...</I><BR>"
			else
				for(var/datum/feed_channel/CHANNEL in news_network.network_channels)
					dat+="<A href='byond://?src=\ref[src];ac_pick_censor_channel=\ref[CHANNEL]'>[CHANNEL.channel_name]</A> [(CHANNEL.censored) ? ("<FONT COLOR='red'>***</FONT>") : null]<BR>"
			dat+="<BR><A href='byond://?src=\ref[src];ac_setScreen=[0]'>Cancel</A>"
		if(11)
			dat+={"
				<B>Nanotrasen D-Notice Handler</B><HR>
				<FONT SIZE=1>A D-Notice is to be bestowed upon the channel if the handling Authority deems it as harmful for the station's
				morale, integrity or disciplinary behaviour. A D-Notice will render a channel unable to be updated by anyone, without deleting any feed
				stories it might contain at the time. You can lift a D-Notice if you have the required access at any time.</FONT><HR>
			"}
			if(isemptylist(news_network.network_channels))
				dat+="<I>No feed channels found active...</I><BR>"
			else
				for(var/datum/feed_channel/CHANNEL in news_network.network_channels)
					dat+="<A href='byond://?src=\ref[src];ac_pick_d_notice=\ref[CHANNEL]'>[CHANNEL.channel_name]</A> [(CHANNEL.censored) ? ("<FONT COLOR='red'>***</FONT>") : null]<BR>"

			dat+="<BR><A href='byond://?src=\ref[src];ac_setScreen=[0]'>Back</A>"
		if(12)
			dat+={"
				<B>[src.admincaster_feed_channel.channel_name]: </B><FONT SIZE=1>\[ created by: <FONT COLOR='maroon'>[src.admincaster_feed_channel.author]</FONT> \]</FONT><BR>
				<FONT SIZE=2><A href='byond://?src=\ref[src];ac_censor_channel_author=\ref[src.admincaster_feed_channel]'>[(src.admincaster_feed_channel.author=="\[REDACTED\]") ? ("Undo Author censorship") : ("Censor channel Author")]</A></FONT><HR>
			"}
			if( isemptylist(src.admincaster_feed_channel.messages) )
				dat+="<I>No feed messages found in channel...</I><BR>"
			else
				for(var/datum/feed_message/MESSAGE in src.admincaster_feed_channel.messages)
					dat+={"
						-[MESSAGE.body] <BR><FONT SIZE=1>\[Story by <FONT COLOR='maroon'>[MESSAGE.author]</FONT>\]</FONT><BR>
						<FONT SIZE=2><A href='byond://?src=\ref[src];ac_censor_channel_story_body=\ref[MESSAGE]'>[(MESSAGE.body == "\[REDACTED\]") ? ("Undo story censorship") : ("Censor story")]</A>  -  <A href='byond://?src=\ref[src];ac_censor_channel_story_author=\ref[MESSAGE]'>[(MESSAGE.author == "\[REDACTED\]") ? ("Undo Author Censorship") : ("Censor message Author")]</A></FONT><BR>
					"}
			dat+="<BR><A href='byond://?src=\ref[src];ac_setScreen=[10]'>Back</A>"
		if(13)
			dat+={"
				<B>[src.admincaster_feed_channel.channel_name]: </B><FONT SIZE=1>\[ created by: <FONT COLOR='maroon'>[src.admincaster_feed_channel.author]</FONT> \]</FONT><BR>
				Channel messages listed below. If you deem them dangerous to the station, you can <A href='byond://?src=\ref[src];ac_toggle_d_notice=\ref[src.admincaster_feed_channel]'>Bestow a D-Notice upon the channel</A>.<HR>
			"}
			if(src.admincaster_feed_channel.censored)
				dat+={"
					<FONT COLOR='red'><B>ATTENTION: </B></FONT>This channel has been deemed as threatening to the welfare of the station, and marked with a Nanotrasen D-Notice.<BR>
					No further feed story additions are allowed while the D-Notice is in effect.</FONT><BR><BR>
				"}
			else
				if( isemptylist(src.admincaster_feed_channel.messages) )
					dat+="<I>No feed messages found in channel...</I><BR>"
				else
					for(var/datum/feed_message/MESSAGE in src.admincaster_feed_channel.messages)
						dat+="-[MESSAGE.body] <BR><FONT SIZE=1>\[Story by <FONT COLOR='maroon'>[MESSAGE.author]</FONT>\]</FONT><BR>"

			dat+="<BR><A href='byond://?src=\ref[src];ac_setScreen=[11]'>Back</A>"
		if(14)
			dat+="<B>Wanted Issue Handler:</B>"
			var/wanted_already = 0
			var/end_param = 1
			if(news_network.wanted_issue)
				wanted_already = 1
				end_param = 2
			if(wanted_already)
				dat+="<FONT SIZE=2><BR><I>A wanted issue is already in Feed Circulation. You can edit or cancel it below.</FONT></I>"
			dat+={"
				<HR>
				<A href='byond://?src=\ref[src];ac_set_wanted_name=1'>Criminal Name</A>: [src.admincaster_feed_message.author] <BR>
				<A href='byond://?src=\ref[src];ac_set_wanted_desc=1'>Description</A>: [src.admincaster_feed_message.body] <BR>
			"}
			if(wanted_already)
				dat+="<B>Wanted Issue created by:</B><FONT COLOR='green'> [news_network.wanted_issue.backup_author]</FONT><BR>"
			else
				dat+="<B>Wanted Issue will be created under prosecutor:</B><FONT COLOR='green'> [src.admincaster_signature]</FONT><BR>"
			dat+="<BR><A href='byond://?src=\ref[src];ac_submit_wanted=[end_param]'>[(wanted_already) ? ("Edit Issue") : ("Submit")]</A>"
			if(wanted_already)
				dat+="<BR><A href='byond://?src=\ref[src];ac_cancel_wanted=1'>Take down Issue</A>"
			dat+="<BR><A href='byond://?src=\ref[src];ac_setScreen=[0]'>Cancel</A>"
		if(15)
			dat+={"
				<FONT COLOR='green'>Wanted issue for [src.admincaster_feed_message.author] is now in Network Circulation.</FONT><BR><BR>
				<BR><A href='byond://?src=\ref[src];ac_setScreen=[0]'>Return</A><BR>
			"}
		if(16)
			dat+="<B><FONT COLOR='maroon'>ERROR: Wanted Issue rejected by Network.</B></FONT><HR><BR>"
			if(src.admincaster_feed_message.author =="" || src.admincaster_feed_message.author == "\[REDACTED\]")
				dat+="<FONT COLOR='maroon'>Invalid name for person wanted.</FONT><BR>"
			if(src.admincaster_feed_message.body == "" || src.admincaster_feed_message.body == "\[REDACTED\]")
				dat+="<FONT COLOR='maroon'>Invalid description.</FONT><BR>"
			dat+="<BR><A href='byond://?src=\ref[src];ac_setScreen=[0]'>Return</A><BR>"
		if(17)
			dat+={"
				<B>Wanted Issue successfully deleted from Circulation</B><BR>
				<BR><A href='byond://?src=\ref[src];ac_setScreen=[0]'>Return</A><BR>
			"}
		if(18)
			dat+={"
				<B><FONT COLOR ='maroon'>-- STATIONWIDE WANTED ISSUE --</B></FONT><BR><FONT SIZE=2>\[Submitted by: <FONT COLOR='green'>[news_network.wanted_issue.backup_author]</FONT>\]</FONT><HR>
				<B>Criminal</B>: [news_network.wanted_issue.author]<BR>
				<B>Description</B>: [news_network.wanted_issue.body]<BR>
				<B>Photo:</B>:
			"}
			if(news_network.wanted_issue.img)
				usr << browse_rsc(news_network.wanted_issue.img, "tmp_photow.png")
				dat+="<BR><img src='tmp_photow.png' width = '180'>"
			else
				dat+="None"
			dat+="<BR><A href='byond://?src=\ref[src];ac_setScreen=[0]'>Back</A><BR>"
		if(19)
			dat+={"
				<FONT COLOR='green'>Wanted issue for [src.admincaster_feed_message.author] successfully edited.</FONT><BR><BR>
				<BR><A href='byond://?src=\ref[src];ac_setScreen=[0]'>Return</A><BR>
			"}
		else
			dat+="I'm sorry to break your immersion. This shit's bugged. Report this bug to Agouri, polyxenitopalidou@gmail.com"

	//world << "Channelname: [src.admincaster_feed_channel.channel_name] [src.admincaster_feed_channel.author]"
	//world << "Msg: [src.admincaster_feed_message.author] [src.admincaster_feed_message.body]"
	usr << browse(dat, "window=admincaster_main;size=400x600")
	onclose(usr, "admincaster_main")



/datum/admins/proc/Jobbans()
	if(!check_rights(R_BAN))	return

	var/dat = "<B>Job Bans!</B><HR><table>"
	for(var/t in jobban_keylist)
		var/r = t
		if( findtext(r,"##") )
			r = copytext( r, 1, findtext(r,"##") )//removes the description
		dat += text("<tr><td>[t] (<A href='byond://?src=\ref[src];removejobban=[r]'>unban</A>)</td></tr>")
	dat += "</table>"
	usr << browse(dat, "window=ban;size=400x400")

/datum/admins/proc/Game()
	if(!check_rights(0))	return

	var/head = "<style type='text/css'> body {font-family: Times; cursor: url('https://lfwb.ru/Icons/pointer.cur'), auto;} a {text-decoration:none;outline: none;border: none;margin:-1px;} a:focus{outline:none;} a:hover {color:#0d0d0d;background:#505055;outline: none;border: none;} a.active { text-decoration:none; color:#533333;} a.inactive:hover {color:#0d0d0d;background:#bb0000} a.active:hover {color:#bb0000;background:#0f0f0f} a.inactive:hover { text-decoration:none; color:#0d0d0d; background:#bb0000}</style>"
	var/dat = {"
	<body background bgColor=#0d0d0d text=#862525 alink=#777777 vlink=#777777 link=#777777>
		<center><B>Game Panel</B></center><hr>\n
		<A href='byond://?src=\ref[src];c_mode=1'>Change Game Mode</A><br>
		"}
	if(master_mode == "secret")
		dat += "<A href='byond://?src=\ref[src];f_secret=1'>(Force Secret Mode)</A><br>"

	dat += {"
		<BR>
		<A href='byond://?src=\ref[src];create_object=1'>Create Object</A><br>
		<A href='byond://?src=\ref[src];quick_create_object=1'>Quick Create Object</A><br>
		<A href='byond://?src=\ref[src];create_turf=1'>Create Turf</A><br>
		<A href='byond://?src=\ref[src];create_mob=1'>Create Mob</A><br>
		<br><A href='byond://?src=\ref[src];vsc=airflow'>Edit Airflow Settings</A><br>
		<A href='byond://?src=\ref[src];vsc=plasma'>Edit Plasma Settings</A><br>
		<A href='byond://?src=\ref[src];vsc=default'>Choose a default ZAS setting</A><br>
		"}

	usr << browse(HTML_SKELETON_INTERNAL(head, dat), "window=admin2;size=210x280")
	return

/datum/admins/proc/Secrets()
	if(!check_rights(0))	return

	var/dat = "<B>The first rule of adminbuse is: you don't talk about the adminbuse.</B><HR>"

	if(check_rights(R_ADMIN,0))
		dat += {"
			<B>Admin Secrets</B><BR>
			<BR>
			<A href='byond://?src=\ref[src];secretsadmin=list_bombers'>Bombing List</A><BR>
			<A href='byond://?src=\ref[src];secretsadmin=check_antagonist'>Show current traitors and objectives</A><BR>
			<A href='byond://?src=\ref[src];secretsadmin=list_signalers'>Show last [length(lastsignalers)] signalers</A><BR>
			<A href='byond://?src=\ref[src];secretsadmin=list_lawchanges'>Show last [length(lawchanges)] law changes</A><BR>
			<A href='byond://?src=\ref[src];secretsadmin=showailaws'>Show AI Laws</A><BR>
			<A href='byond://?src=\ref[src];secretsadmin=showgm'>Show Game Mode</A><BR>
			<A href='byond://?src=\ref[src];secretsadmin=manifest'>Show Crew Manifest</A><BR>
			<A href='byond://?src=\ref[src];secretsadmin=DNA'>List DNA (Blood)</A><BR>
			<A href='byond://?src=\ref[src];secretsadmin=fingerprints'>List Fingerprints</A><BR><BR>
			<A href='byond://?src=\ref[src];secretsadmin=resetparty'>Reset Lateparties</A><BR><BR>
			<BR>
			"}

	if(check_rights(R_FUN,0))
		dat += {"
			<B>'Random' Events</B><BR>
			<BR>
			<A href='byond://?src=\ref[src];secretsfun=wave'>Spawn a wave of meteors (aka lagocolyptic shower)</A><BR>
			<A href='byond://?src=\ref[src];secretsfun=gravanomalies'>Spawn a gravitational anomaly (aka lagitational anomolag)</A><BR>
			<A href='byond://?src=\ref[src];secretsfun=timeanomalies'>Spawn wormholes</A><BR>
			<A href='byond://?src=\ref[src];secretsfun=goblob'>Spawn blob</A><BR>
			<A href='byond://?src=\ref[src];secretsfun=aliens'>Trigger a Xenomorph infestation</A><BR>
			<A href='byond://?src=\ref[src];secretsfun=borers'>Trigger a Cortical Borer infestation</A><BR>
			<A href='byond://?src=\ref[src];secretsfun=alien_silent'>Spawn an Alien silently</A><BR>
			<A href='byond://?src=\ref[src];secretsfun=spiders'>Trigger a Spider infestation</A><BR>
			<A href='byond://?src=\ref[src];secretsfun=spaceninja'>Send in a space ninja</A><BR>
			<A href='byond://?src=\ref[src];secretsfun=striketeam'>Send in a strike team</A><BR>
			<A href='byond://?src=\ref[src];secretsfun=carp'>Trigger an Carp migration</A><BR>
			<A href='byond://?src=\ref[src];secretsfun=radiation'>Irradiate the station</A><BR>
			<A href='byond://?src=\ref[src];secretsfun=prison_break'>Trigger a Prison Break</A><BR>
			<A href='byond://?src=\ref[src];secretsfun=virus'>Trigger a Virus Outbreak</A><BR>
			<A href='byond://?src=\ref[src];secretsfun=immovable'>Spawn an Immovable Rod</A><BR>
			<A href='byond://?src=\ref[src];secretsfun=lightsout'>Toggle a "lights out" event</A><BR>
			<A href='byond://?src=\ref[src];secretsfun=ionstorm'>Spawn an Ion Storm</A><BR>
			<A href='byond://?src=\ref[src];secretsfun=spacevines'>Spawn Space-Vines</A><BR>
			<A href='byond://?src=\ref[src];secretsfun=comms_blackout'>Trigger a communication blackout</A><BR>
			<BR>
			<B>Fun Secrets</B><BR>
			<BR>
			<A href='byond://?src=\ref[src];secretsfun=sec_clothes'>Remove 'internal' clothing</A><BR>
			<A href='byond://?src=\ref[src];secretsfun=sec_all_clothes'>Remove ALL clothing</A><BR>
			<A href='byond://?src=\ref[src];secretsfun=monkey'>Turn all humans into monkeys</A><BR>
			<A href='byond://?src=\ref[src];secretsfun=sec_classic1'>Remove firesuits, grilles, and pods</A><BR>
			<A href='byond://?src=\ref[src];secretsfun=power'>Make all areas powered</A><BR>
			<A href='byond://?src=\ref[src];secretsfun=unpower'>Make all areas unpowered</A><BR>
			<A href='byond://?src=\ref[src];secretsfun=quickpower'>Power all SMES</A><BR>
			<A href='byond://?src=\ref[src];secretsfun=toggleprisonstatus'>Toggle Prison Shuttle Status(Use with S/R)</A><BR>
			<A href='byond://?src=\ref[src];secretsfun=activateprison'>Send Prison Shuttle</A><BR>
			<A href='byond://?src=\ref[src];secretsfun=deactivateprison'>Return Prison Shuttle</A><BR>
			<A href='byond://?src=\ref[src];secretsfun=prisonwarp'>Warp all Players to Prison</A><BR>
			<A href='byond://?src=\ref[src];secretsfun=tripleAI'>Triple AI mode (needs to be used in the lobby)</A><BR>
			<A href='byond://?src=\ref[src];secretsfun=traitor_all'>Everyone is the traitor</A><BR>
			<A href='byond://?src=\ref[src];secretsfun=onlyone'>There can only be one!</A><BR>
			<A href='byond://?src=\ref[src];secretsfun=flicklights'>Ghost Mode</A><BR>
			<A href='byond://?src=\ref[src];secretsfun=retardify'>Make all players retarded</A><BR>
			<A href='byond://?src=\ref[src];secretsfun=fakeguns'>Make all items look like guns</A><BR>
			<A href='byond://?src=\ref[src];secretsfun=schoolgirl'>Japanese Animes Mode</A><BR>
			<A href='byond://?src=\ref[src];secretsfun=eagles'>Egalitarian Station Mode</A><BR>
			<A href='byond://?src=\ref[src];secretsfun=moveadminshuttle'>Move Administration Shuttle</A><BR>
			<A href='byond://?src=\ref[src];secretsfun=moveferry'>Move Ferry</A><BR>
			<A href='byond://?src=\ref[src];secretsfun=movealienship'>Move Alien Dinghy</A><BR>
			<A href='byond://?src=\ref[src];secretsfun=moveminingshuttle'>Move Mining Shuttle</A><BR>
			<A href='byond://?src=\ref[src];secretsfun=blackout'>Break all lights</A><BR>
			<A href='byond://?src=\ref[src];secretsfun=whiteout'>Fix all lights</A><BR>
			<A href='byond://?src=\ref[src];secretsfun=friendai'>Best Friend AI</A><BR>
			<A href='byond://?src=\ref[src];secretsfun=floorlava'>The floor is lava! (DANGEROUS: extremely lame)</A><BR>
			"}

	if(check_rights(R_SERVER,0))
		dat += "<A href='byond://?src=\ref[src];secretsfun=togglebombcap'>Toggle bomb cap</A><BR>"

	dat += "<BR>"

	if(check_rights(R_DEBUG,0))
		dat += {"
			<B>Security Level Elevated</B><BR>
			<BR>
			<A href='byond://?src=\ref[src];secretscoder=maint_access_engiebrig'>Change all maintenance doors to engie/brig access only</A><BR>
			<A href='byond://?src=\ref[src];secretscoder=maint_access_brig'>Change all maintenance doors to brig access only</A><BR>
			<A href='byond://?src=\ref[src];secretscoder=infinite_sec'>Remove cap on security officers</A><BR>
			<BR>
			<B>Coder Secrets</B><BR>
			<BR>
			<A href='byond://?src=\ref[src];secretsadmin=list_job_debug'>Show Job Debug</A><BR>
			<A href='byond://?src=\ref[src];secretscoder=spawn_objects'>Admin Log</A><BR>
			<BR>
			"}

	usr << browse(dat, "window=secrets")
	return



/////////////////////////////////////////////////////////////////////////////////////////////////admins2.dm merge
//i.e. buttons/verbs


/datum/admins/proc/restart()
	set category = "Server"
	set name = "Restart"
	set desc="Restarts the world"
	if (!usr.client.holder)
		return
	var/confirm = alert("Restart the game world?", "Restart", "Yes", "Cancel")
	if(confirm == "Cancel")
		return
	if(confirm == "Yes")
		to_chat(world, "\red <b>Restarting world!</b> \blue Initiated by [usr.client.holder.fakekey ? "Admin" : usr.key]!")
		log_admin("[key_name(usr)] initiated a reboot.")
		sleep(50)
		world.Reboot()

/datum/admins/proc/announce()
	set category = "Special Verbs"
	set name = "Announce"
	set desc="Announce your desires to the world"
	if(!check_rights(0))	return

	var/message = sanitize(input("Global message to send:", "Admin Announce", null, null) as message)
	if(message)
		if(!check_rights(R_SERVER,0))
			message = sanitize(message)
		to_chat(world, "\blue <b>[usr.client.holder.fakekey ? "Administrator" : usr.key] Announces:</b>\n \t [message]")
		log_admin("Announce: [key_name(usr)] : [message]")

/datum/admins/proc/toggleooc()
	set category = "Server"
	set desc="Globally Toggles OOC"
	set name="Toggle OOC"
	ooc_allowed = !( ooc_allowed )
	if (ooc_allowed)
		to_chat(world, "<B>The OOC channel has been globally enabled!</B>")
	else
		to_chat(world, "<B>The OOC channel has been globally disabled!</B>")
	log_admin("[key_name(usr)] toggled OOC.")
	message_admins("[key_name_admin(usr)] toggled OOC.", 1)

/datum/admins/proc/toggledsay()
	set category = "Server"
	set desc="Globally Toggles DSAY"
	set name="Toggle DSAY"
	dsay_allowed = !( dsay_allowed )
	if (dsay_allowed)
		to_chat(world, "<B>Deadchat has been globally enabled!</B>")
	else
		to_chat(world, "<B>Deadchat has been globally disabled!</B>")
	log_admin("[key_name(usr)] toggled deadchat.")
	message_admins("[key_name_admin(usr)] toggled deadchat.", 1)

/datum/admins/proc/toggleoocdead()
	set category = "Server"
	set desc="Toggle dis bitch"
	set name="Toggle Dead OOC"
	dooc_allowed = !( dooc_allowed )

	log_admin("[key_name(usr)] toggled OOC.")
	message_admins("[key_name_admin(usr)] toggled Dead OOC.", 1)

/datum/admins/proc/toggletraitorscaling()
	set category = "Server"
	set desc="Toggle traitor scaling"
	set name="Toggle Traitor Scaling"
	traitor_scaling = !traitor_scaling
	log_admin("[key_name(usr)] toggled Traitor Scaling to [traitor_scaling].")
	message_admins("[key_name_admin(usr)] toggled Traitor Scaling [traitor_scaling ? "on" : "off"].", 1)

/datum/admins/proc/startnow()
	set category = "Server"
	set desc="Start the round RIGHT NOW"
	set name="Start Now"
	if(!ticker)
		alert("Unable to start the game as it is not set up.")
		return
	if(ticker.current_state == GAME_STATE_PREGAME)
		ticker.force_started = TRUE
		ticker.current_state = GAME_STATE_SETTING_UP
		Master.SetRunLevel(RUNLEVEL_SETUP)
		log_admin("[usr.key] has started the game.")
		message_admins("<font color='blue'>[usr.key] has started the game (master_mode: [master_mode]).</font>")
		return 1
	else
		to_chat(usr, "<font color='red'>Error: Start Now: Game has already started.</font>")
		return 0

/datum/admins/proc/toggleenter()
	set category = "Server"
	set desc="People can't enter"
	set name="Toggle Entering"
	enter_allowed = !( enter_allowed )
	if (!( enter_allowed ))
		to_chat(world, "<B>New players may no longer enter the game.</B>")
	else
		to_chat(world, "<B>New players may now enter the game.</B>")
	log_admin("[key_name(usr)] toggled new player game entering.")
	message_admins("\blue [key_name_admin(usr)] toggled new player game entering.", 1)
	world.update_status()

/datum/admins/proc/toggleAI()
	set category = "Server"
	set desc="People can't be AI"
	set name="Toggle AI"
	config.allow_ai = !( config.allow_ai )
	if (!( config.allow_ai ))
		to_chat(world, "<B>The AI job is no longer chooseable.</B>")
	else
		to_chat(world, "<B>The AI job is chooseable now.</B>")
	log_admin("[key_name(usr)] toggled AI allowed.")
	world.update_status()

/datum/admins/proc/toggleaban()
	set category = "Server"
	set desc="Respawn basically"
	set name="Toggle Respawn"
	abandon_allowed = !( abandon_allowed )
	if (abandon_allowed)
		to_chat(world, "<B>You may now respawn.</B>")
	else
		to_chat(world, "<B>You may no longer respawn :(</B>")
	message_admins("\blue [key_name_admin(usr)] toggled respawn to [abandon_allowed ? "On" : "Off"].", 1)
	log_admin("[key_name(usr)] toggled respawn to [abandon_allowed ? "On" : "Off"].")
	world.update_status()

/datum/admins/proc/toggle_aliens()
	set category = "Server"
	set desc="Toggle alien mobs"
	set name="Toggle Aliens"
	aliens_allowed = !aliens_allowed
	log_admin("[key_name(usr)] toggled Aliens to [aliens_allowed].")
	message_admins("[key_name_admin(usr)] toggled Aliens [aliens_allowed ? "on" : "off"].", 1)

/datum/admins/proc/delay()
	set category = "Server"
	set desc="Delay the game start/end"
	set name="Delay"

	if(!check_rights(R_ADMIN))	return
	if (!ticker || ticker.current_state != GAME_STATE_PREGAME)
		ticker.delay_end = !ticker.delay_end
		log_admin("[key_name(usr)] [ticker.delay_end ? "delayed the round end" : "has made the round end normally"].")
		message_admins("\blue [key_name(usr)] [ticker.delay_end ? "delayed the round end" : "has made the round end normally"].", 1)
		return //alert("Round end delayed", null, null, null, null, null)
	going = !( going )
	if (!( going ))
		to_chat(world, "<span class='highlighttext'>Curses!</span> <span class='horriblestate'>THE ROUND HAS BEEN DELAYED!</span>")
		log_admin("[key_name(usr)] delayed the game.")
	else
		to_chat(world,"<span class='highlighttext'>Thank God!</span> <span class='horriblestate'>The game will start soon!</span>")
		log_admin("[key_name(usr)] removed the delay.")

/datum/admins/proc/adjump()
	set category = "Server"
	set desc="Toggle admin jumping"
	set name="Toggle Jump"
	config.allow_admin_jump = !(config.allow_admin_jump)
	message_admins("\blue Toggled admin jumping to [config.allow_admin_jump].")

/datum/admins/proc/adspawn()
	set category = "Server"
	set desc="Toggle admin spawning"
	set name="Toggle Spawn"
	config.allow_admin_spawning = !(config.allow_admin_spawning)
	message_admins("\blue Toggled admin item spawning to [config.allow_admin_spawning].")

/datum/admins/proc/adrev()
	set category = "Server"
	set desc="Toggle admin revives"
	set name="Toggle Revive"
	config.allow_admin_rev = !(config.allow_admin_rev)
	message_admins("\blue Toggled reviving to [config.allow_admin_rev].")

/datum/admins/proc/immreboot()
	set category = "Server"
	set desc="Reboots the server post haste"
	set name="Immediate Reboot"
	if(!usr.client.holder)	return
	if( alert("Reboot server?",,"Yes","No") == "No")
		return
	to_chat(world, "\red <b>Rebooting world!</b> \blue Initiated by [usr.client.holder.fakekey ? "Admin" : usr.key]!")
	log_admin("[key_name(usr)] initiated an immediate reboot.")
	world.Reboot()

/datum/admins/proc/unprison(var/mob/M in mob_list)
	set category = "Admin"
	set name = "Unprison"
	if (M.z == centcomm_z)
		if (config.allow_admin_jump)
			M.loc = pick(latejoin)
			message_admins("[key_name_admin(usr)] has unprisoned [key_name_admin(M)]", 1)
			log_admin("[key_name(usr)] has unprisoned [key_name(M)]")
		else
			alert("Admin jumping disabled")
	else
		alert("[M.name] is not prisoned.")

/datum/admins/proc/spawn_atom(var/object as text)
	set category = "Debug"
	set desc = "(atom path) Spawn an atom"
	set name = "Spawn"

	if(!check_rights(R_SPAWN))	return

	var/list/types = typesof(/atom)
	var/list/matches = new()

	for(var/path in types)
		if(findtext("[path]", object))
			matches += path

	if(matches.len==0)
		return

	var/chosen
	if(matches.len==1)
		chosen = matches[1]
	else
		chosen = input("Select an atom type", "Spawn Atom", matches[1]) as null|anything in matches
		if(!chosen)
			return

	if(ispath(chosen,/turf))
		var/turf/T = get_turf(usr.loc)
		T.ChangeTurf(chosen)
	else
		new chosen(usr.loc)

	log_admin("[key_name(usr)] spawned [chosen] at ([usr.x],[usr.y],[usr.z])")
	message_admins("[key_name(usr)] spawned [chosen] at ([usr.x],[usr.y],[usr.z])")


/datum/admins/proc/show_traitor_panel(var/mob/M in mob_list)
	set category = "Admin"
	set desc = "Edit mobs's memory and role"
	set name = "Show Traitor Panel"

	if(!istype(M))
		to_chat(usr, "This can only be used on instances of type /mob")
		return
	if(!M.mind)
		to_chat(usr, "This mob has no mind!")
		return

	M.mind.edit_memory()


/datum/admins/proc/toggletintedweldhelmets()
	set category = "Debug"
	set desc="Reduces view range when wearing welding helmets"
	set name="Toggle tinted welding helmes"
	tinted_weldhelh = !( tinted_weldhelh )
	if (tinted_weldhelh)
		to_chat(world, "<B>The tinted_weldhelh has been enabled!</B>")
	else
		to_chat(world, "<B>The tinted_weldhelh has been disabled!</B>")
	log_admin("[key_name(usr)] toggled tinted_weldhelh.")
	message_admins("[key_name_admin(usr)] toggled tinted_weldhelh.", 1)

/datum/admins/proc/toggleguests()
	set category = "Server"
	set desc="Guests can't enter"
	set name="Toggle guests"
	guests_allowed = !( guests_allowed )
	if (!( guests_allowed ))
		to_chat(world, "<B>Guests may no longer enter the game.</B>")
	else
		to_chat(world, "<B>Guests may now enter the game.</B>")
	log_admin("[key_name(usr)] toggled guests game entering [guests_allowed?"":"dis"]allowed.")
	message_admins("\blue [key_name_admin(usr)] toggled guests game entering [guests_allowed?"":"dis"]allowed.", 1)

/client/proc/unjobban_panel()
	set name = "Unjobban Panel"
	set category = "Admin"
	if (src.holder)
		src.holder.unjobbanpanel()
	return

/datum/admins/proc/output_ai_laws()
	var/ai_number = 0
	for(var/mob/living/silicon/S in mob_list)
		ai_number++
		if(isAI(S))
			usr << "<b>AI [key_name(S, usr)]'s laws:</b>"
		else if(isrobot(S))
			var/mob/living/silicon/robot/R = S
			usr << "<b>CYBORG [key_name(S, usr)] [R.connected_ai?"(Slaved to: [R.connected_ai])":"(Independant)"]: laws:</b>"
		else if (ispAI(S))
			usr << "<b>pAI [key_name(S, usr)]'s laws:</b>"
		else
			usr << "<b>SOMETHING SILICON [key_name(S, usr)]'s laws:</b>"

		if (S.laws == null)
			usr << "[key_name(S, usr)]'s laws are null?? Contact a coder."
		else
			S.laws.show_laws(usr)
	if(!ai_number)
		usr << "<b>No AIs located</b>" //Just so you know the thing is actually working and not just ignoring you.

/client/proc/update_mob_sprite(mob/living/carbon/human/H as mob)
	set category = "Admin"
	set name = "Update Mob Sprite"
	set desc = "Should fix any mob sprite update errors."

	if (!holder)
		to_chat(usr, "Only administrators may use this command.")
		return

	if(istype(H))
		H.regenerate_icons()

//
//
//ALL DONE
//*********************************************************************************************************
//TO-DO:
//
//


/**********************Administration Shuttle**************************/

var/admin_shuttle_location = 0 // 0 = centcom 13, 1 = station

proc/move_admin_shuttle()
	var/area/fromArea
	var/area/toArea
	if (admin_shuttle_location == 1)
		fromArea = locate(/area/shuttle/administration/station)
		toArea = locate(/area/shuttle/administration/centcom)
	else
		fromArea = locate(/area/shuttle/administration/centcom)
		toArea = locate(/area/shuttle/administration/station)
	fromArea.move_contents_to(toArea)
	if (admin_shuttle_location)
		admin_shuttle_location = 0
	else
		admin_shuttle_location = 1
	return

/**********************Centcom Ferry**************************/

var/ferry_location = 0 // 0 = centcom , 1 = station

proc/move_ferry()
	var/area/fromArea
	var/area/toArea
	if (ferry_location == 1)
		fromArea = locate(/area/shuttle/transport1/station)
		toArea = locate(/area/shuttle/transport1/centcom)
	else
		fromArea = locate(/area/shuttle/transport1/centcom)
		toArea = locate(/area/shuttle/transport1/station)
	fromArea.move_contents_to(toArea)
	if (ferry_location)
		ferry_location = 0
	else
		ferry_location = 1
	return

/**********************Alien ship**************************/

var/alien_ship_location = 1 // 0 = base , 1 = mine

proc/move_alien_ship()
	var/area/fromArea
	var/area/toArea
	if (alien_ship_location == 1)
		fromArea = locate(/area/shuttle/alien/mine)
		toArea = locate(/area/shuttle/alien/base)
	else
		fromArea = locate(/area/shuttle/alien/base)
		toArea = locate(/area/shuttle/alien/mine)
	fromArea.move_contents_to(toArea)
	if (alien_ship_location)
		alien_ship_location = 0
	else
		alien_ship_location = 1
	return
