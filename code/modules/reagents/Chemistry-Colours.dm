/proc/mix_color_from_reagents(var/list/reagent_list)
	if(!reagent_list || !length(reagent_list))
		return 0

	var/contents = length(reagent_list)
	var/list/weight = new /list(contents)
	var/list/redcolor = new /list(contents)
	var/list/greencolor = new /list(contents)
	var/list/bluecolor = new /list(contents)
	var/i

	//fill the list of weights
	for(i=1; i<=contents; i++)
		var/datum/reagent/re = reagent_list[i]
		var/reagentweight = re.volume
		if(istype(re, /datum/reagent/paint))
			reagentweight *= 20 //Paint colours a mixture twenty times as much
		weight[i] = reagentweight


	//fill the lists of colours
	for(i=1; i<=contents; i++)
		var/datum/reagent/re = reagent_list[i]
		var/hue = re.color
		if(length(hue) != 7)
			return 0
		redcolor[i]=hex2num(copytext(hue,2,4))
		greencolor[i]=hex2num(copytext(hue,4,6))
		bluecolor[i]=hex2num(copytext(hue,6,8))

	//mix all the colors
	var/red = mixOneColor_depreciated(weight,redcolor)
	var/green = mixOneColor_depreciated(weight,greencolor)
	var/blue = mixOneColor_depreciated(weight,bluecolor)

	//assemble all the pieces
	var/finalcolor = "#[red][green][blue]"
	return finalcolor

/proc/mixOneColor_depreciated(var/list/weight, var/list/color)
	if (!weight || !color || length(weight)!=length(color))
		return 0

	var/contents = length(weight)
	var/i

	//normalize weights
	var/listsum = 0
	for(i=1; i<=contents; i++)
		listsum += weight[i]
	for(i=1; i<=contents; i++)
		weight[i] /= listsum

	//mix them
	var/mixedcolor = 0
	for(i=1; i<=contents; i++)
		mixedcolor += weight[i]*color[i]
	mixedcolor = round(mixedcolor)

	//until someone writes a formal proof for this algorithm, let's keep this in
	if(mixedcolor<0x00 || mixedcolor>0xFF)
		return 0

	var/finalcolor = num2hex(mixedcolor)
	while(length(finalcolor)<2)
		finalcolor = text("0[]",finalcolor) //Takes care of leading zeroes
	return finalcolor
