/client
		//////////////////////
		//BLACK MAGIC THINGS//
		//////////////////////
	parent_type = /datum

		////////////////
		//ADMIN THINGS//
		////////////////
	var/datum/admins/holder = null
	var/buildmode		= 0

	var/last_message	= "" //Contains the last message sent by this client - used to protect against copy-paste spamming.
	var/last_message_count = 0 //contins a number of how many times a message identical to last_message was sent.

		/////////
		//OTHER//
		/////////
	var/datum/preferences/prefs = null
	var/move_delay		= 1
	var/moving			= null
	var/adminobs		= null
	var/area			= null
	var/time_died_as_mouse = null //when the client last died as a mouse
	var/work_chosen		= null // ��������� ������ ��������� ��������� ��� ����������� � Lobby
	var/wraith_pain = 0

	var/list/fire = list()

		///////////////
		//SOUND STUFF//
		///////////////
	var/ambience_playing= null
	var/played			= 0

		////////////
		//SECURITY//
		////////////
	var/next_allowed_topic_time = 10
	// comment out the line below when debugging locally to enable the options & messages menu
	control_freak = 4
	var/chromiesex = FALSE

	var/pigReady = FALSE
		////////////////////////////////////
		//things that require the database//
		////////////////////////////////////
	var/player_age = "Requires database"	//So admins know why it isn't working - Used to determine how old the account is - in days.
	var/related_accounts_ip = "Requires database"	//So admins know why it isn't working - Used to determine what other accounts previously logged in from this ip
	var/related_accounts_cid = "Requires database"	//So admins know why it isn't working - Used to determine what other accounts previously logged in from this computer id
	var/married = null
	preload_rsc = 0 // This is 0 so we can set it to an URL once the player logs in and have them download the resources from a different server.
	//preload_rsc = "https://www.dropbox.com/s/kfe9yimm9oi2ooj/MACACHKA.zip?dl=1"
	mouse_pointer_icon='icons/pointer.dmi'
	var/datum/chatOutput/chatOutput
	///Date of byond account creation in ISO 8601 format
	var/account_join_date = null
	var/InvitedBy = null
	var/Country_Code = null
	var/last_song_file = null
	var/DisplayingRolls = FALSE
	var/datum/dbinfo/info = null
	var/authenticated = FALSE