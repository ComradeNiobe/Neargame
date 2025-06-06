/datum/hud/proc/human_hud_luna(var/ui_style='icons/mob/screen1_White.dmi', var/ui_color = "#ffffff", var/ui_alpha = 255)

	src.adding = list()
	src.other = list()
	src.hotkeybuttons = list() //These can be disabled for hotkey usersx

	var/obj/screen/using
	var/obj/screen/inventory/inv_box


	using = new /obj/screen/a_intent()
	using.name = "act_intent"
	using.dir = SOUTHWEST
	using.icon = ui_style
	using.icon_state = mymob.a_intent
	using.screen_loc = ui_acti
	using.layer = 20
	adding += using
	src.action_intent = using

	using = new /obj/screen()
	using.name = "mov_intent"
	using.dir = SOUTHWEST
	using.icon = ui_style
	using.icon_state = (mymob.m_intent == "run" ? "running" : "walking")
	using.screen_loc = ui_movi
	using.layer = 20

	src.adding += using
	move_intent = using
/*
	using = new /obj/screen()
	using.name = "att_intent"
	using.dir = SOUTHWEST
	using.icon = ui_style
	using.icon_state = mymob.att_intent
	using.screen_loc = ui_att_int
	using.layer = 20

	src.adding += using
	att_intent = using
*/

	using = new /obj/screen()
	using.name = "drop"
	using.icon = ui_style
	using.icon_state = "act_drop"
	using.screen_loc = ui_dropbutton
	using.layer = 19
	src.hotkeybuttons += using

	inv_box = new /obj/screen/inventory()
	inv_box.name = "i_clothing"
	inv_box.dir = SOUTH
	inv_box.icon = ui_style
	inv_box.slot_id = slot_w_uniform
	inv_box.icon_state = "center"
	inv_box.screen_loc = ui_iclothing
	inv_box.layer = 19
	src.adding += inv_box
	src.all_inv += inv_box

	inv_box = new /obj/screen/inventory()
	inv_box.name = "o_clothing"
	inv_box.dir = SOUTH
	inv_box.icon = ui_style
	inv_box.slot_id = slot_wear_suit
	inv_box.icon_state = "equip"
	inv_box.screen_loc = ui_oclothing
	inv_box.layer = 19
	src.adding += inv_box
	src.all_inv += inv_box

	inv_box = new /obj/screen/inventory()
	inv_box.name = "r_hand"
	inv_box.dir = WEST
	inv_box.icon = ui_style
	inv_box.icon_state = "hand_inactive"
	if(mymob && !mymob.hand)	//This being 0 or null means the right hand is in use
		inv_box.icon_state = "hand_active"
	inv_box.screen_loc = ui_rhand
	inv_box.slot_id = slot_r_hand
	inv_box.layer = 19

	src.r_hand_hud_object = inv_box
	src.adding += inv_box

	inv_box = new /obj/screen/inventory()
	inv_box.name = "l_hand"
	inv_box.dir = EAST
	inv_box.icon = ui_style
	inv_box.icon_state = "hand_inactive"
	if(mymob && mymob.hand)	//This being 1 means the left hand is in use
		inv_box.icon_state = "hand_active"
	inv_box.screen_loc = ui_lhand
	inv_box.slot_id = slot_l_hand
	inv_box.layer = 19
	src.l_hand_hud_object = inv_box
	src.adding += inv_box

	using = new /obj/screen/inventory()
	using.name = "hand"
	using.dir = NORTH
	using.icon = ui_style
	using.icon_state = "hand"
	using.screen_loc = ui_swaphand
	using.layer = 19
	src.swaphands_hud_object = using


	src.adding += using

	inv_box = new /obj/screen/inventory()
	inv_box.name = "id"
	inv_box.dir = NORTH
	inv_box.icon = ui_style
	inv_box.icon_state = "id"
	inv_box.screen_loc = ui_id
	inv_box.slot_id = slot_wear_id
	inv_box.layer = 19
	src.adding += inv_box
	src.all_inv += inv_box

	inv_box = new /obj/screen/inventory()
	inv_box.name = "mask"
	inv_box.dir = NORTH
	inv_box.icon = ui_style
	inv_box.icon_state = "equip"
	inv_box.screen_loc = ui_mask
	inv_box.slot_id = slot_wear_mask
	inv_box.layer = 19
	src.adding += inv_box
	src.all_inv += inv_box

	inv_box = new /obj/screen/inventory()
	inv_box.name = "back"
	inv_box.dir = NORTH
	inv_box.icon = ui_style
	inv_box.icon_state = "back"
	inv_box.screen_loc = ui_back
	inv_box.slot_id = slot_back
	inv_box.layer = 19
	src.adding += inv_box
	src.all_inv += inv_box

	inv_box = new /obj/screen/inventory()
	inv_box.name = "storage1"
	inv_box.icon = ui_style
	inv_box.icon_state = "pocket"
	inv_box.screen_loc = ui_storage1
	inv_box.slot_id = slot_l_store
	inv_box.layer = 19
	src.adding += inv_box
	src.all_inv += inv_box

	inv_box = new /obj/screen/inventory()
	inv_box.name = "storage2"
	inv_box.icon = ui_style
	inv_box.icon_state = "pocket"
	inv_box.screen_loc = ui_storage2
	inv_box.slot_id = slot_r_store
	inv_box.layer = 19
	src.adding += inv_box
	src.all_inv += inv_box

	inv_box = new /obj/screen/inventory()
	inv_box.name = "belt2"
	inv_box.icon = ui_style
	inv_box.dir = 8 //The sprite at dir=8 has the background whereas the others don't.
	inv_box.icon_state = "belt"
	inv_box.screen_loc = ui_sstore1
	inv_box.slot_id = slot_s_store
	inv_box.layer = 19
	src.adding += inv_box
	src.all_inv += inv_box

	inv_box = new /obj/screen/inventory()
	inv_box.name = "wrist_r"
	inv_box.icon = ui_style
	inv_box.dir = 8 //The sprite at dir=8 has the background whereas the others don't.
	inv_box.icon_state = "wrist_r"
	inv_box.screen_loc = ui_wrist_r
	inv_box.slot_id = slot_wrist_r
	inv_box.layer = 19
	src.adding += inv_box
	src.all_inv += inv_box

	inv_box = new /obj/screen/inventory()
	inv_box.name = "wrist_l"
	inv_box.icon = ui_style
	inv_box.dir = 8 //The sprite at dir=8 has the background whereas the others don't.
	inv_box.icon_state = "wrist_l"
	inv_box.screen_loc = ui_wrist_l
	inv_box.slot_id = slot_wrist_l
	inv_box.layer = 19
	src.adding += inv_box
	src.all_inv += inv_box

	inv_box = new /obj/screen/inventory()
	inv_box.name = "amulet"
	inv_box.icon = ui_style
	inv_box.dir = 8 //The sprite at dir=8 has the background whereas the others don't.
	inv_box.icon_state = "amulet"
	inv_box.screen_loc = ui_amulet
	inv_box.slot_id = slot_amulet
	inv_box.layer = 19
	src.adding += inv_box
	src.all_inv += inv_box

	inv_box = new /obj/screen/inventory()
	inv_box.name = "back2"
	inv_box.icon = ui_style
	inv_box.dir = 8 //The sprite at dir=8 has the background whereas the others don't.
	inv_box.icon_state = "back2"
	inv_box.screen_loc = ui_back2
	inv_box.slot_id = slot_back2
	inv_box.layer = 19
	src.adding += inv_box
	src.all_inv += inv_box

	using = new /obj/screen()
	using.name = "resist"
	using.icon = ui_style
	using.icon_state = "act_resist"
	using.screen_loc = ui_resist
	using.layer = 19
	src.hotkeybuttons += using


	src.adding += using

	inv_box = new /obj/screen/inventory()
	inv_box.name = "gloves"
	inv_box.icon = ui_style
	inv_box.icon_state = "gloves"
	inv_box.screen_loc = ui_gloves
	inv_box.slot_id = slot_gloves
	inv_box.layer = 19
	src.adding += inv_box
	src.all_inv += inv_box

	inv_box = new /obj/screen/inventory()
	inv_box.name = "eyes"
	inv_box.icon = ui_style
	inv_box.icon_state = "glasses"
	inv_box.screen_loc = ui_glasses
	inv_box.slot_id = slot_glasses
	inv_box.layer = 19
	src.adding += inv_box
	src.all_inv += inv_box

	inv_box = new /obj/screen/inventory()
	inv_box.name = "l_ear"
	inv_box.icon = ui_style
	inv_box.icon_state = "ears"
	inv_box.screen_loc = ui_l_ear
	inv_box.slot_id = slot_l_ear
	inv_box.layer = 19
	src.adding += inv_box
	src.all_inv += inv_box

	inv_box = new /obj/screen/inventory()
	inv_box.name = "r_ear"
	inv_box.icon = ui_style
	inv_box.icon_state = "ears"
	inv_box.screen_loc = ui_r_ear
	inv_box.slot_id = slot_r_ear
	inv_box.layer = 19
	src.adding += inv_box
	src.all_inv += inv_box

	inv_box = new /obj/screen/inventory()
	inv_box.name = "head"
	inv_box.icon = ui_style
	inv_box.icon_state = "hair"
	inv_box.screen_loc = ui_head
	inv_box.slot_id = slot_head
	inv_box.layer = 19
	src.adding += inv_box
	src.all_inv += inv_box

	inv_box = new /obj/screen/inventory()
	inv_box.name = "shoes"
	inv_box.icon = ui_style
	inv_box.icon_state = "shoes"
	inv_box.screen_loc = ui_shoes
	inv_box.slot_id = slot_shoes
	inv_box.layer = 19
	src.adding += inv_box
	src.all_inv += inv_box

	inv_box = new /obj/screen/inventory()
	inv_box.name = "belt"
	inv_box.icon = ui_style
	inv_box.icon_state = "belt"
	inv_box.screen_loc = ui_belt
	inv_box.slot_id = slot_belt
	inv_box.layer = 19
	src.adding += inv_box
	src.all_inv += inv_box

	mymob.throw_icon = new /obj/screen()
	mymob.throw_icon.icon = ui_style
	mymob.throw_icon.icon_state = "act_throw_off"
	mymob.throw_icon.name = "throw"
	mymob.throw_icon.screen_loc = ui_drop_throw
	mymob.throw_icon.color = ui_color
	mymob.throw_icon.alpha = ui_alpha
	src.hotkeybuttons += mymob.throw_icon
/*
	mymob.oxygen = new /obj/screen()
	mymob.oxygen.icon = ui_style
	mymob.oxygen.icon_state = "oxy0"
	mymob.oxygen.name = "oxygen"
	mymob.oxygen.screen_loc = ui_oxygen
*/
	mymob.pressure = new /obj/screen()
	mymob.pressure.icon = ui_style
	mymob.pressure.icon_state = "pressure0"
	mymob.pressure.name = "pressure"
	mymob.pressure.screen_loc = ui_pressure

	mymob.toxin = new /obj/screen()
	mymob.toxin.icon = ui_style
	mymob.toxin.icon_state = "tox0"
	mymob.toxin.name = "toxin"
	mymob.toxin.screen_loc = null

	mymob.awake = new /obj/screen()
	mymob.awake.icon = ui_style
	mymob.awake.icon_state = "sleep0"
	mymob.awake.name = "awake"
	mymob.awake.screen_loc = ui_awake

	mymob.internals = new /obj/screen()
	mymob.internals.icon = ui_style
	mymob.internals.icon_state = "internal01"
	mymob.internals.name = "internal"
	mymob.internals.screen_loc = ui_internal

	mymob.rest = new /obj/screen()
	mymob.rest.name = "rest"
	mymob.rest.icon = ui_style
	mymob.rest.icon_state = "rest[mymob.resting]"
	mymob.rest.screen_loc = ui_rest
	if (mymob.resting)
		if(mymob?.mind?.changeling)
			mymob.rest.icon_state = "crest1"
		else
			mymob.rest.icon_state = "rest1"
	else
		if(mymob?.mind?.changeling)
			mymob.rest.icon_state = "crest0"
		else
			mymob.rest.icon_state = "rest0"
/*
	mymob.fire = new /obj/screen()
	mymob.fire.icon = ui_style
	mymob.fire.icon_state = "fire0"
	mymob.fire.name = "fire"
	mymob.fire.screen_loc = ui_fire
*/
	mymob.readycd = new /obj/screen()
	mymob.readycd.icon = ui_style
	mymob.readycd.icon_state = "ready000"
	mymob.readycd.name = "cooldown"
	mymob.readycd.screen_loc = ui_fire

	mymob.bodytemp = new /obj/screen()
	mymob.bodytemp.icon = ui_style
	mymob.bodytemp.icon_state = "temp1"
	mymob.bodytemp.name = "body temperature"
	mymob.bodytemp.screen_loc = ui_temp

	mymob.healths = new /obj/screen()
	mymob.healths.icon = ui_style
	mymob.healths.icon_state = "health0"
	mymob.healths.name = "health"
	mymob.healths.screen_loc = ui_health

	mymob.nutrition_icon = new /obj/screen()
	mymob.nutrition_icon.icon = 'icons/life/screen1.dmi'
	mymob.nutrition_icon.icon_state = "hunger1"
	mymob.nutrition_icon.name = "hunger"
	mymob.nutrition_icon.screen_loc = ui_nutrition

	mymob.pullin = new /obj/screen()
	mymob.pullin.icon = ui_style
	mymob.pullin.icon_state = "pull0"
	mymob.pullin.name = "pull"
	mymob.pullin.screen_loc = ui_pull
	src.hotkeybuttons += mymob.pullin

	mymob.actions1 = new /obj/screen()
	mymob.actions1.icon = ui_style
	mymob.actions1.icon_state = "actions"
	mymob.actions1.name = "actions1"
	mymob.actions1.screen_loc = ui_actions1
	src.hotkeybuttons += mymob.actions1

	mymob.moreactions = new /obj/screen()
	mymob.moreactions.icon = ui_style
	mymob.moreactions.icon_state = "moreactions"
	mymob.moreactions.name = "moreactions"
	mymob.moreactions.screen_loc = ui_moreactions
	src.hotkeybuttons += mymob.moreactions

	mymob.blind = new /obj/screen()
	mymob.blind.icon = 'icons/mob/screen1.dmi'
	mymob.blind.icon_state = "blackanimate"
	mymob.blind.name = " "
	mymob.blind.screen_loc = "1,1 to 15,15"
	mymob.blind.mouse_opacity = 0
	mymob.blind.layer = 0

	mymob.damageoverlay = new /obj/screen()
	mymob.damageoverlay.icon = 'icons/mob/screen1_full.dmi'
	mymob.damageoverlay.icon_state = "oxydamageoverlay0"
	mymob.damageoverlay.name = "dmg"
	mymob.damageoverlay.screen_loc = "1,1"
	mymob.damageoverlay.mouse_opacity = 0
	mymob.damageoverlay.layer = 18.1 //The black screen overlay sets layer to 18 to display it, this one has to be just on top.

	mymob.flash = new /obj/screen()
	mymob.flash.icon = ui_style
	mymob.flash.icon_state = "blank"
	mymob.flash.name = "flash"
	mymob.flash.mouse_opacity = 0
	mymob.flash.screen_loc = "1,1 to 15,15"
	mymob.flash.layer = 17

	mymob.pain = new /obj/screen( null )
	mymob.pain.icon = ui_style
	mymob.pain.icon_state = "blank"
	mymob.pain.name = "pain"
	mymob.pain.mouse_opacity = 0
	mymob.pain.screen_loc = "1,1 to 15,15"
	mymob.pain.layer = 17

	mymob.moodscreen = new /obj/screen( null )
	mymob.moodscreen.icon = ui_style
	mymob.moodscreen.icon_state = "dark128"
	mymob.moodscreen.name = "mood"
	mymob.moodscreen.mouse_opacity = 0
	mymob.moodscreen.screen_loc = "1,1 to 15,15"
	mymob.moodscreen.layer = 16.9
	mymob.moodscreen.alpha = 0 //transparente, deixa a mood mudar

	mymob.zone_sel = new /obj/screen/zone_sel( null )
	mymob.zone_sel.icon = 'icons/life/zone_sel.dmi'
	mymob.zone_sel.screen_loc = ui_zonesel
	mymob.zone_sel.overlays.Cut()
	mymob.zone_sel.overlays += image('icons/life/zone_sel.dmi', "[mymob.zone_sel.selecting]")





	mymob.fullscreen_overeffect = new()
	mymob.fullscreen_overeffect.icon = 'icons/misc/fullscreen_fog.dmi'
	mymob.fullscreen_overeffect.icon_state = ""
	mymob.fullscreen_overeffect.screen_loc = "1,1"
	mymob.fullscreen_overeffect.layer = 0
	mymob.fullscreen_overeffect.mouse_opacity = 0
	mymob.fullscreen_overeffect.alpha = 20

	mymob.film_grain2 = new()
	mymob.film_grain2.icon = 'icons/effects/static.dmi'
	mymob.film_grain2.icon_state = "[rand(1,9)]h"
	mymob.film_grain2.screen_loc = ui_entire_screen
	mymob.film_grain2.alpha = 90
	mymob.film_grain2.layer = 0
	mymob.film_grain2.mouse_opacity = 0
	mymob.film_grain2.blend_mode = 4

	mymob.stamina_ui = new /obj/screen()//STAMINA
	mymob.stamina_ui.icon = 'icons/life/screen1.dmi'
	mymob.stamina_ui.icon_state = "stamina0"
	mymob.stamina_ui.name = "stamina"
	mymob.stamina_ui.screen_loc = ui_stamina

	mymob.eye_fix = new /obj/screen()//STAMINA
	mymob.eye_fix.icon = 'icons/life/screen1.dmi'
	mymob.eye_fix.icon_state = "fixed_e0"
	mymob.eye_fix.name = "eyefix"
	mymob.eye_fix.screen_loc = ui_eye_fix

	mymob.cutebuttons = new /obj/screen()//STAMINA
	mymob.cutebuttons.icon = 'icons/life/screen1.dmi'
	mymob.cutebuttons.icon_state = "cutebuttons"
	mymob.cutebuttons.name = "cutebuttons"
	mymob.cutebuttons.screen_loc = ui_cutebuttons


	mymob.combat_mode_icon = new /obj/screen()
	mymob.combat_mode_icon.icon = 'icons/life/screen1.dmi'
	mymob.combat_mode_icon.icon_state = "cmbt0"
	mymob.combat_mode_icon.name = "combat mode"
	mymob.combat_mode_icon.screen_loc = ui_combat_mode

	mymob.sprint_icon = new /obj/screen()
	mymob.sprint_icon.icon = 'icons/life/screen1.dmi'
	mymob.sprint_icon.icon_state = "sprint0"
	mymob.sprint_icon.name = "sprint"
	mymob.sprint_icon.screen_loc = ui_sprint

	mymob.dodge_parry = new /obj/screen()
	mymob.dodge_parry.icon = 'icons/life/screen1.dmi'
	mymob.dodge_parry.icon_state = "dodge1"
	mymob.dodge_parry.name = "dodge parry"
	mymob.dodge_parry.screen_loc = ui_dodge_parry

	mymob.mood_icon = new /obj/screen()
	mymob.mood_icon.name = "mood"
	mymob.mood_icon.icon = 'icons/life/screen1.dmi'
	mymob.mood_icon.icon_state = "pressure3"
	mymob.mood_icon.screen_loc = ui_mood


/*                           nigga?                               */
	mymob.combat_intents = new /obj/screen()
	mymob.combat_intents.icon = 'icons/life/screen1.dmi'
	mymob.combat_intents.icon_state = mymob.combat_intent
	mymob.combat_intents.name = "combat intents"
	mymob.combat_intents.screen_loc = ui_combat_intents

	mymob.combat_popup = new /obj/screen()
	mymob.combat_popup.icon = 'icons/life/screen2.dmi'
	mymob.combat_popup.icon_state = "cstyle"
	mymob.combat_popup.name = "combat popup"


	mymob.surrender = new /obj/screen()
	mymob.surrender.icon = 'icons/life/screen1.dmi'
	mymob.surrender.icon_state = "surrender1"
	mymob.surrender.name = "surrender"
	mymob.surrender.screen_loc = ui_surrender

	mymob.background = new /obj/screen()
	mymob.background.icon = 'icons/life/screen5.dmi'
	mymob.background.name = "background"
	mymob.background.screen_loc = "-2,1"
	mymob.background.layer = 30
/*                           nigga?                               */

/*	//Handle the gun settings buttons
	mymob.gun_setting_icon = new /obj/screen/gun/mode(null)
	if (mymob.client)
		if (mymob.client.gun_mode) // If in aim mode, correct the sprite
			mymob.gun_setting_icon.dir = 2
	for(var/obj/item/gun/G in mymob) // If targeting someone, display other buttons
		if (G.target)
			mymob.item_use_icon = new /obj/screen/gun/item(null)
			if (mymob.client.target_can_click)
				mymob.item_use_icon.dir = 1
			src.adding += mymob.item_use_icon
			mymob.gun_move_icon = new /obj/screen/gun/move(null)
			if (mymob.client.target_can_move)
				mymob.gun_move_icon.dir = 1
				mymob.gun_run_icon = new /obj/screen/gun/run(null)
				if (mymob.client.target_can_run)
					mymob.gun_run_icon.dir = 1
				src.adding += mymob.gun_run_icon
			src.adding += mymob.gun_move_icon
*/
	mymob.fov = new /obj/screen/fov()
	mymob.fov_mask = new /obj/screen/fov_mask()
	mymob.fov_mask_two = new /obj/screen/fov_mask_two()

	var/mob/living/carbon/human/H = mymob
	H.hovertext = new /obj/screen/text/atm
	H.hovertext.maptext = ""
	H.hovertext.maptext_height = 100
	H.hovertext.maptext_width = 480
	H.hovertext.screen_loc = "CENTER-7, CENTER+7"
	var/hoverglow = filter(type = "outline", size = 1, color = "#5e4546", flags = OUTLINE_SQUARE)
	H.hovertext.filters += hoverglow

	mymob.client.screen = null

	mymob.client.screen += list(mymob.fov_mask_two, mymob.fullscreen_overeffect, mymob.fov_mask, mymob.throw_icon, mymob.awake, mymob.zone_sel, mymob.moodscreen, mymob.surrender, mymob.toxin, mymob.bodytemp, mymob.internals, mymob.readycd, mymob.healths, mymob.nutrition_icon, mymob.pullin, mymob.blind, mymob.flash, mymob.damageoverlay, mymob.rest, mymob.pain, mymob.fov, mymob.stamina_ui, mymob.eye_fix, mymob.cutebuttons, mymob.combat_mode_icon, mymob.dodge_parry, mymob.mood_icon, mymob.combat_intents, mymob.combat_popup, mymob.actions1, mymob.sprint_icon, H.hovertext, mymob.background, mymob.film_grain2) //, mymob.hands, mymob.rest, mymob.sleep) //, mymob.mach )
	mymob.ArtemiSHITO += list(mymob.fullscreen_overeffect,mymob.moreactions, mymob.throw_icon, mymob.awake, mymob.surrender, mymob.toxin, mymob.bodytemp, mymob.internals, mymob.fire, mymob.healths, mymob.nutrition_icon, mymob.pullin, mymob.rest, mymob.stamina_ui, mymob.eye_fix, mymob.cutebuttons, mymob.combat_mode_icon, mymob.dodge_parry, mymob.mood_icon, mymob.combat_intents, mymob.combat_popup, mymob.actions1, mymob.sprint_icon, H.hovertext) //, mymob.hands, mymob.rest, mymob.sleep) //, mymob.mach )
	mymob.client.screen += src.adding + src.hotkeybuttons
	if(usr?.hud_used?.other?.len)
		usr?.client?.screen += usr?.hud_used?.other
	inventory_shown = 1

	return


/mob/living/carbon/human/verb/toggle_hotkey_verbs()
	set category = "OOC"
	set name = "Toggle hotkey buttons"
	set desc = "This disables or enables the user interface buttons which can be used with hotkeys."

	if(hud_used.hotkey_ui_hidden)
		client.screen += hud_used.hotkeybuttons
		hud_used.hotkey_ui_hidden = 0
	else
		client.screen -= hud_used.hotkeybuttons
		hud_used.hotkey_ui_hidden = 1


/mob/living/carbon/human/update_action_buttons()
	var/num = 1
	if(!hud_used) return
	if(!client) return

	if(!hud_used.hud_shown)	//Hud toggled to minimal
		return

	client.screen -= hud_used.item_action_list

	hud_used.item_action_list = list()
	for(var/obj/item/I in src)
		if(I.icon_action_button)
			var/obj/screen/item_action/A = new(hud_used)

			//A.icon = 'icons/mob/screen1_action.dmi'
			//A.icon_state = I.icon_action_button
			A.icon = ui_style2icon(client.prefs.UI_style)
			A.icon_state = "template"
			var/image/img = image(I.icon, A, I.icon_state)
			img.pixel_x = 0
			img.pixel_y = 0
			A.overlays += img

			if(I.action_button_name)
				A.name = I.action_button_name
			else
				A.name = "Use [I.name]"
			A.owner = I
			hud_used.item_action_list += A
			switch(num)
				if(1)
					A.screen_loc = ui_action_slot1
				if(2)
					A.screen_loc = ui_action_slot2
				if(3)
					A.screen_loc = ui_action_slot3
				if(4)
					A.screen_loc = ui_action_slot4
				if(5)
					A.screen_loc = ui_action_slot5
					break //5 slots available, so no more can be added.
			num++
	src.client.screen += src.hud_used.item_action_list
