// Segunda tentativa de fazer um sistema para não rodar dbqueries todo login de um cliente.
// Desta vez, as queries só (devem) rodar uma vez por login.

// Second attempt at creating a way to load database info for each client without running dbqueries every single time the same client reconnects.
// This time around, the queries should only run on the first login.

// The lastseen property is intended to only be set once per round.

var/global/list/dbdatums = list()

/datum/dbinfo
	var/reputation
	var/chromosomes
	var/ckey

/datum/dbinfo/New(client/C)
	ckey = C.ckey
	//if(!check_ckey_whitelisted(ckey))
	//	MakeNewUserEntry()
	LoadReputation()

/datum/dbinfo/proc/LoadReputation()
	set waitfor = FALSE
	var/DBQuery/rep = dbcon.NewQuery("SELECT SUM(value) FROM reputation WHERE ckey = \"[ckey]\"")
	if(!rep.Execute())
		world.log << rep.ErrorMsg()
		return
	while(rep.NextRow())
		src.reputation = text2num(rep.item[1])

/datum/chromieholder
	var/chromie_number = 0

/client
	var/datum/chromieholder/chromie_holder = new

/client/New()
	chromie_holder = new
	if(!fexists("data/player_saves/[copytext(ckey, 1, 2)]/[ckey]/chromies.sav"))
		SaveChromies()
	LoadChromies()
	. = ..()

/client/Del() //When they log out.
	SaveChromies()
	return ..()

/client/proc/LoadChromies()
	set waitfor = FALSE
	var/savefile/S = new /savefile("data/player_saves/[copytext(ckey, 1, 2)]/[ckey]/chromies.sav")
	chromie_holder.Read(S)

/client/proc/AdjustChromies(var/value) // use negative values to take away chromosomes
	set waitfor = FALSE
	if(!isnum(value))
		world.log << "Attempted to set chromies for user with an invalid value!"
		return
	chromie_holder.chromie_number += value
	SaveChromies()

/client/proc/SaveChromies()
	set waitfor = FALSE
	var/savefile/S = new /savefile("data/player_saves/[copytext(ckey, 1, 2)]/[ckey]/chromies.sav")
	chromie_holder.Write(S)