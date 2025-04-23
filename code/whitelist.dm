#define CKEYWHITELIST "config/ckey_whitelist.txt"

#define PIGPLUS 1
#define COMRADE 2
#define VILLAIN 3
#define FEMSTATIC 4

// TODO: Kill all of these from the game eventually.

// SQUIRE TIER
var/global/list/tier_squire = list()
// TIAMAT TIER
var/global/list/tier_tiamat = list()
// MARDUK TIER
var/global/list/tier_marduk = list()
// CRUSADER TIER
var/global/list/tier_crusader = list()

//** SEASPOTTER MERC **//
var/global/list/donation_seaspotter = list()
//** RED DAWN MERC **//
var/global/list/donation_reddawn = list()
//** MERCENARY **//
var/global/list/donation_mercenary = list()
//** CRUSADER **//
var/global/list/donation_crusader = list()
//** MONK **//
var/global/list/donation_monk = list()
//** FUTA **//
var/global/list/donation_futa = list()
//** MOBILE PHONE **//
var/global/list/donation_mobilephone = list()
//** REMIGRATION **//
var/global/list/donation_remigrator = list()
//** 30CM **//
var/global/list/donation_30cm = list()
//** TRAP **//
var/global/list/donation_trap = list()
//** OUTLAW **//
var/global/list/donation_outlaw = list()
//** ITEMS **//
var/global/list/donation_waterbottle = list()
var/global/list/donation_lecheryamulet = list()
//** OOC COLOR **//
var/global/list/donation_mycolor = list()

//** LORD **//
var/global/list/lord = list()

var/global/list/coolboombox = list()

var/global/list/singer = list()

var/global/list/weeDonator = list()
var/global/list/baliset = list()
var/global/list/black_cloak = list()
var/global/list/bee_queen = list()

var/global/list/patreons = list()

var/global/list/ckeywhitelistweb = list("")

var/global/private_party = FALSE // Dictates whether whitelist is needed to join or not

var/global/list/proxyignore = list()

var/global/list/access_comrade = list("")

var/global/list/access_villain = list("")

var/global/list/femstatic_rank = list("")

var/global/list/access_pigplus = list()

var/global/list/guardianlist = list()

var/global/list/hasinvited = list()

var/global/list/bans = list()

/proc/load_ckey_whitelist()
	ckeywhitelistweb = list()
	var/list/Lines = file2list(CKEYWHITELIST)
	for(var/line in Lines)
		if(!length(line))
			continue

		var/ascii = text2ascii(line,1)

		if(copytext(line,1,2) == "#" || ascii == 9 || ascii == 32)//# space or tab
			continue

		ckeywhitelistweb.Add(ckey(line))

	if(!ckeywhitelistweb.len)
		ckeywhitelistweb = null

/proc/check_ckey_whitelisted(var/ckey)
	return (ckeywhitelistweb && (ckey in ckeywhitelistweb) )

/proc/load_db_whitelist()
	set waitfor = FALSE
	var/DBQuery/query = dbcon.NewQuery("SELECT ckey FROM playersfarweb;")
	if(!query.Execute())
		world.log << query.ErrorMsg()
		return
	while(query.NextRow())
		ckeywhitelistweb.Add(query.item[1])

/proc/load_db_bans()
	set waitfor = FALSE
	var/DBQuery/query = dbcon.NewQuery("SELECT ckey FROM bansfarweb WHERE isbanned = 1;")
	if(!query.Execute())
		world.log << query.ErrorMsg()
		return
	while(query.NextRow())
		bans.Add(query.item[1])

/datum/storyholder
	var/story_number = 1 //So when you boot it up you aren't on 0

var/datum/storyholder/story_holder = new

/proc/get_story_id()
	set waitfor = FALSE
	var/savefile/S = new /savefile("data/game_version.sav")
	story_holder.Read(S)
	story_id = story_holder.story_number


/proc/add_story_id()
	set waitfor = FALSE
	var/savefile/S = new /savefile("data/game_version.sav")
	story_holder.Write(S)

/proc/load_invitations()
	var/list/Lines = file2list("config/invitesystem/hasinvited.txt")
	for(var/line in Lines)
		if(!length(line))
			continue

		var/ascii = text2ascii(line,1)

		if(copytext(line,1,2) == "#" || ascii == 9 || ascii == 32)
			continue

		hasinvited.Add(ckey(line))

/proc/load_comrade_list()
	set waitfor = FALSE
	var/DBQuery/query = dbcon.NewQuery("SELECT ckey FROM access_comrade;")
	if(!query.Execute())
		world.log << query.ErrorMsg()
		return
	while(query.NextRow())
		access_comrade.Add(query.item[1])

/proc/load_pigplus_list()
	set waitfor = FALSE
	var/DBQuery/query = dbcon.NewQuery("SELECT ckey FROM access_pigplus;")
	if(!query.Execute())
		world.log << query.ErrorMsg()
		return
	while(query.NextRow())
		access_pigplus.Add(query.item[1])

/proc/load_villain_list()
	set waitfor = FALSE
	var/DBQuery/query = dbcon.NewQuery("SELECT ckey FROM access_villain;")
	if(!query.Execute())
		world.log << query.ErrorMsg()
		return
	while(query.NextRow())
		access_villain.Add(query.item[1])

/client/proc/load_registered_by()
	set waitfor = FALSE
	var/DBQuery/query = dbcon.NewQuery("SELECT invitedby FROM playersfarweb WHERE ckey = \"[ckey]\";")
	if(!query.Execute())
		world.log << query.ErrorMsg()
		return
	while(query.NextRow())
		InvitedBy = query.item[1]
		//query.Close()
		//return

/proc/has_invited(ckey)
	return (hasinvited && (ckey in hasinvited))

/proc/loadFateLocks()
	if(!config.usefatelocks)
		return
	var/list/fates = job_master.occupations
	var/fatelock_list = file2list("config/fatelocks.txt")
	for(var/L in fatelock_list)
		if(!length(L))				continue
		if(copytext(L,1,2) == "#")	continue

		var/list/List = text2list(L,"+")
		if(!List.len)					continue

		var/temp_fate = ckey(List[1])
		var/datum/job/current_fate
		for(var/datum/job/D in fates)
			var/name = ckey(D.title)
			if(name == temp_fate)
				current_fate = D
				break

		if(!current_fate)
			continue

		for(var/i=2, i<=List.len, i++)
			switch(ckey(List[i]))
				if("pigplus")	current_fate.job_whitelisted |= PIGPLUS
				if("comrade")	current_fate.job_whitelisted |= COMRADE
				if("villain") 	current_fate.job_whitelisted |= VILLAIN
				if("femstatic") current_fate.job_whitelisted |= FEMSTATIC

#undef CKEYWHITELIST

/proc/stickyban(key)
	world.SetConfig("ban",ckey(key),"type=sticky;message=God be saved!;")
/proc/remove_stickyban(key)
	world.SetConfig("ban",ckey(key),null)

