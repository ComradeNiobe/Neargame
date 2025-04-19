/proc/add_tier_squire()
    var/ckey = input("Enter the donator's ckey", "Farweb")
    if(length(ckey) <= 1 || length(ckey) > 30)
        to_chat(usr, "<span class='highlighttext'>This ckey is invalid.</span>")
        return
    var/DBQuery/queryInsert = dbcon.NewQuery("INSERT INTO tier_squire (ckey) VALUE (\"[ckey(ckey)]\")")
    if(!queryInsert.Execute())
        world.log << queryInsert.ErrorMsg()
        queryInsert.Close()
        return
    tier_squire.Add(ckey(ckey))
    to_chat(usr, "<span class='highlighttext'>[ckey] has been added to the donators list.</span>")

/proc/add_tier_tiamat()
    var/ckey = input("Enter the donator's ckey", "Farweb")
    if(length(ckey) <= 1 || length(ckey) > 30)
        to_chat(usr, "<span class='highlighttext'>This ckey is invalid.</span>")
        return
    var/DBQuery/queryInsert = dbcon.NewQuery("INSERT INTO tier_tiamat (ckey) VALUE (\"[ckey(ckey)]\")")
    if(!queryInsert.Execute())
        world.log << queryInsert.ErrorMsg()
        queryInsert.Close()
        return
    tier_tiamat.Add(ckey(ckey))
    to_chat(usr, "<span class='highlighttext'>[ckey] has been added to the donators list.</span>")

/proc/add_tier_marduk()
    var/ckey = input("Enter the donator's ckey", "Farweb")
    if(length(ckey) <= 1 || length(ckey) > 30)
        to_chat(usr, "<span class='highlighttext'>This ckey is invalid.</span>")
        return
    var/DBQuery/queryInsert = dbcon.NewQuery("INSERT INTO tier_marduk (ckey) VALUE (\"[ckey(ckey)]\")")
    if(!queryInsert.Execute())
        world.log << queryInsert.ErrorMsg()
        queryInsert.Close()
        return
    tier_marduk.Add(ckey(ckey))
    to_chat(usr, "<span class='highlighttext'>[ckey] has been added to the donators list.</span>")

/proc/add_tier_crusader()
    var/ckey = input("Enter the donator's ckey", "Farweb")
    if(length(ckey) <= 1 || length(ckey) > 30)
        to_chat(usr, "<span class='highlighttext'>This ckey is invalid.</span>")
        return
    var/DBQuery/queryInsert = dbcon.NewQuery("INSERT INTO tier_crusader (ckey) VALUE (\"[ckey(ckey)]\")")
    if(!queryInsert.Execute())
        world.log << queryInsert.ErrorMsg()
        queryInsert.Close()
        return
    tier_crusader.Add(ckey(ckey))
    to_chat(usr, "<span class='highlighttext'>[ckey] has been added to the donators list.</span>")

/proc/add_seaspotter()
    var/ckey = input("Enter the donator's ckey", "Nearweb")
    if(length(ckey) <= 1 || length(ckey) > 30)
        to_chat(usr, "<span class='highlighttext'>This ckey is invalid.</span>")
        return
    var/DBQuery/queryInsert = dbcon.NewQuery("INSERT INTO donation_seaspotter (ckey) VALUE (\"[ckey(ckey)]\")")
    if(!queryInsert.Execute())
        world.log << queryInsert.ErrorMsg()
        queryInsert.Close()
        return
    donation_seaspotter.Add(ckey(ckey))
    to_chat(usr, "<span class='highlighttext'>[ckey] has been added to the donators list.</span>")

/proc/add_mercenary()
    var/ckey = input("Enter the donator's ckey", "Nearweb")
    if(length(ckey) <= 1 || length(ckey) > 30)
        to_chat(usr, "<span class='highlighttext'>This ckey is invalid.</span>")
        return
    var/DBQuery/queryInsert = dbcon.NewQuery("INSERT INTO donation_mercenary (ckey) VALUE (\"[ckey(ckey)]\")")
    if(!queryInsert.Execute())
        world.log << queryInsert.ErrorMsg()
        queryInsert.Close()
        return
    donation_mercenary.Add(ckey(ckey))
    to_chat(usr, "<span class='highlighttext'>[ckey] has been added to the donators list.</span>")

/proc/add_reddawn()
    var/ckey = input("Enter the donator's ckey", "Nearweb")
    if(length(ckey) <= 1 || length(ckey) > 30)
        to_chat(usr, "<span class='highlighttext'>This ckey is invalid.</span>")
        return
    var/DBQuery/queryInsert = dbcon.NewQuery("INSERT INTO donation_reddawn (ckey) VALUE (\"[ckey(ckey)]\")")
    if(!queryInsert.Execute())
        world.log << queryInsert.ErrorMsg()
        queryInsert.Close()
        return
    donation_reddawn.Add(ckey(ckey))
    to_chat(usr, "<span class='highlighttext'>[ckey] has been added to the donators list.</span>")

/proc/add_lord()
    var/ckey = input("Enter the donator's ckey", "Nearweb")
    if(length(ckey) <= 1 || length(ckey) > 30)
        to_chat(usr, "<span class='highlighttext'>This ckey is invalid.</span>")
        return
    var/DBQuery/queryInsert = dbcon.NewQuery("INSERT INTO lord (ckey) VALUE (\"[ckey(ckey)]\")")
    if(!queryInsert.Execute())
        world.log << queryInsert.ErrorMsg()
        queryInsert.Close()
        return
    lord.Add(ckey(ckey))
    to_chat(usr, "<span class='highlighttext'>[ckey] has been added to the donators list.</span>")

/proc/add_crusader()
    var/ckey = input("Enter the donator's ckey", "Nearweb")
    if(length(ckey) <= 1 || length(ckey) > 30)
        to_chat(usr, "<span class='highlighttext'>This ckey is invalid.</span>")
        return
    var/DBQuery/queryInsert = dbcon.NewQuery("INSERT INTO donation_crusader (ckey) VALUE (\"[ckey(ckey)]\")")
    if(!queryInsert.Execute())
        world.log << queryInsert.ErrorMsg()
        queryInsert.Close()
        return
    donation_crusader.Add(ckey(ckey))
    to_chat(usr, "<span class='highlighttext'>[ckey] has been added to the donators list.</span>")

/proc/add_monk()
    var/ckey = input("Enter the donator's ckey", "Nearweb")
    if(length(ckey) <= 1 || length(ckey) > 30)
        to_chat(usr, "<span class='highlighttext'>This ckey is invalid.</span>")
        return
    var/DBQuery/queryInsert = dbcon.NewQuery("INSERT INTO donation_monk (ckey) VALUE (\"[ckey(ckey)]\")")
    if(!queryInsert.Execute())
        world.log << queryInsert.ErrorMsg()
        queryInsert.Close()
        return
    donation_monk.Add(ckey(ckey))
    to_chat(usr, "<span class='highlighttext'>[ckey] has been added to the donators list.</span>")

/proc/add_futa()
    var/ckey = input("Enter the donator's ckey", "Nearweb")
    if(length(ckey) <= 1 || length(ckey) > 30)
        to_chat(usr, "<span class='highlighttext'>This ckey is invalid.</span>")
        return
    var/DBQuery/queryInsert = dbcon.NewQuery("INSERT INTO donation_futa (ckey) VALUE (\"[ckey(ckey)]\")")
    if(!queryInsert.Execute())
        world.log << queryInsert.ErrorMsg()
        queryInsert.Close()
        return
    donation_futa.Add(ckey(ckey))
    to_chat(usr, "<span class='highlighttext'>[ckey] has been added to the donators list.</span>")

/proc/add_30cm()
    var/ckey = input("Enter the donator's ckey", "Nearweb")
    if(length(ckey) <= 1 || length(ckey) > 30)
        to_chat(usr, "<span class='highlighttext'>This ckey is invalid.</span>")
        return
    var/DBQuery/queryInsert = dbcon.NewQuery("INSERT INTO donation_30cm (ckey) VALUE (\"[ckey(ckey)]\")")
    if(!queryInsert.Execute())
        world.log << queryInsert.ErrorMsg()
        queryInsert.Close()
        return
    donation_30cm.Add(ckey(ckey))
    to_chat(usr, "<span class='highlighttext'>[ckey] has been added to the donators list.</span>")

/proc/add_trapapoc()
    var/ckey = input("Enter the donator's ckey", "Nearweb")
    if(length(ckey) <= 1 || length(ckey) > 30)
        to_chat(usr, "<span class='highlighttext'>This ckey is invalid.</span>")
        return
    var/DBQuery/queryInsert = dbcon.NewQuery("INSERT INTO donation_trap (ckey) VALUE (\"[ckey(ckey)]\")")
    if(!queryInsert.Execute())
        world.log << queryInsert.ErrorMsg()
        queryInsert.Close()
        return
    donation_trap.Add(ckey(ckey))
    to_chat(usr, "<span class='highlighttext'>[ckey] has been added to the donators list.</span>")

/proc/add_outlaw()
    var/ckey = input("Enter the donator's ckey", "Nearweb")
    if(length(ckey) <= 1 || length(ckey) > 30)
        to_chat(usr, "<span class='highlighttext'>This ckey is invalid.</span>")
        return
    var/DBQuery/queryInsert = dbcon.NewQuery("INSERT INTO donation_outlaw (ckey) VALUE (\"[ckey(ckey)]\")")
    if(!queryInsert.Execute())
        world.log << queryInsert.ErrorMsg()
        queryInsert.Close()
        return
    donation_outlaw.Add(ckey(ckey))
    to_chat(usr, "<span class='highlighttext'>[ckey] has been added to the donators list.</span>")

/proc/add_waterbottle()
    var/ckey = input("Enter the donator's ckey", "Nearweb")
    if(length(ckey) <= 1 || length(ckey) > 30)
        to_chat(usr, "<span class='highlighttext'>This ckey is invalid.</span>")
        return
    var/DBQuery/queryInsert = dbcon.NewQuery("INSERT INTO donation_waterbottle (ckey) VALUE (\"[ckey(ckey)]\")")
    if(!queryInsert.Execute())
        world.log << queryInsert.ErrorMsg()
        queryInsert.Close()
        return
    donation_waterbottle.Add(ckey(ckey))
    to_chat(usr, "<span class='highlighttext'>[ckey] has been added to the donators list.</span>")

/proc/add_luxurydonation()
    var/ckey = input("Enter the donator's ckey", "Nearweb")
    if(length(ckey) <= 1 || length(ckey) > 30)
        to_chat(usr, "<span class='highlighttext'>This ckey is invalid.</span>")
        return
    var/DBQuery/queryInsert = dbcon.NewQuery("INSERT INTO donation_lecheryamulet (ckey) VALUE (\"[ckey(ckey)]\")")
    if(!queryInsert.Execute())
        world.log << queryInsert.ErrorMsg()
        queryInsert.Close()
        return
    donation_lecheryamulet.Add(ckey(ckey))
    to_chat(usr, "<span class='highlighttext'>[ckey] has been added to the donators list.</span>")

/proc/add_customooc()
    var/ckey = input("Enter the donator's ckey", "Nearweb")
    if(length(ckey) <= 1 || length(ckey) > 30)
        to_chat(usr, "<span class='highlighttext'>This ckey is invalid.</span>")
        return
    var/DBQuery/queryInsert = dbcon.NewQuery("INSERT INTO donation_mycolor (ckey) VALUE (\"[ckey(ckey)]\")")
    if(!queryInsert.Execute())
        world.log << queryInsert.ErrorMsg()
        queryInsert.Close()
        return
    donation_mycolor.Add(ckey(ckey))
    to_chat(usr, "<span class='highlighttext'>[ckey] has been added to the donators list.</span>")