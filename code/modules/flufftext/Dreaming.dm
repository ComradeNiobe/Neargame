mob/living/carbon/proc/dream()
	dreaming = 1
	var/list/dreams = list(
		"Copetti","Gmyza","Crumb","Triton","Ravenheart","Firethorn","Enoch's Gate","Orphan","Cultist","Thanati","Consyte","I need","Terrorism","Run","Cry","Look behind you!","Thanati","Baron","Warlock","SAGE","HELP US","Help us","Enoch","Ballidar Cons","God-King", "Evergreen", "Fool","Night","Enoch","Sherold","Dragon","Mutate","SCREAM!","Hell","Decapitation","Suffer","Ashes","Dust","BURN!","Bleed"
		)
	spawn(0)
		for(var/i = rand(1,4),i > 0, i--)
			var/dream_image = pick(dreams)
			dreams -= dream_image
			to_chat(src, "<san class='passive'> <i>... [dream_image] ...</i></span>")
			if(prob(30))
				src << pick('sound/sweetdreams/dream1.ogg','sound/sweetdreams/dream2.ogg','sound/sweetdreams/dream3.ogg','sound/sweetdreams/dream4.ogg','sound/sweetdreams/dream5.ogg')
			sleep(rand(40,70))
			if(paralysis <= 0)
				dreaming = 0
				return 0
		dreaming = 0
		return 1

mob/living/carbon/proc/handle_dreams()
	if(prob(5) && !dreaming) dream()

mob/living/carbon/var/dreaming = 0