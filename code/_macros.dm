#define DUST_PLANE                 -97
#define SPACE_PLANE                -90


#define sound_to(target, sound)                target << sound
#define to_target(target, payload)            target << (payload)
#define from_target(target, receiver)         target >> (receiver)
#define to_file(handle, value)                to_target(handle, value)
#define to_save(handle, value)                to_target(handle, value) //semantics
#define from_save(handle, target_var)         from_target(handle, target_var)
#define legacy_chat(target, message)          to_target(target, message)
#define to_world(message)                     to_chat(world, message)
#define to_world_log(message)                 to_target(world.log, message)
#define image_to(target, image)               to_target(target, image)
#define show_browser(target, content, title)  to_target(target, browse(content, title))
#define close_browser(target, title)          to_target(target, browse(null, title))
#define send_rsc(target, content, title)      to_target(target, browse_rsc(content, title))
#define send_link(target, url)                to_target(target, link(url))
#define send_output(target, msg, control)     to_target(target, output(msg, control))

// TODO - Baystation has this log to crazy places. For now lets just world.log, but maybe look into it later.
#define log_world(message) world.log << message

#define PRINT_STACK_TRACE(X) get_stack_trace(X, __FILE__, __LINE__)

#define go(message) world << message

#define JOINTEXT(X) jointext(X, null)

#define any2ref(x) "\ref[x]"

//** Text styling macros so you don't have <span class=whateverthefuck>"cum"</span> everywhere **//
#define SPAN_STYLE(S, X) "<span style='[S]'>[X]</span>"

// standard styles
#define SPAN_CLASS(C, X) "<span class='[C]'>[X]</span>"
#define SPAN_ITALIC(X)   SPAN_CLASS("italic",        X)
#define SPAN_BOLD(X)     SPAN_CLASS("bold",          X)
#define SPAN_NOTICE(X)   SPAN_CLASS("notice",        X)
#define SPAN_WARNING(X)  SPAN_CLASS("warning",       X)
#define SPAN_DANGER(X)   SPAN_CLASS("danger",        X)
#define SPAN_OCCULT(X)   SPAN_CLASS("cult",          X)
#define SPAN_MFAUNA(X)   SPAN_CLASS("mfauna",        X)
#define SPAN_SUBTLE(X)   SPAN_CLASS("subtle",        X)
#define SPAN_INFO(X)     SPAN_CLASS("info",          X)
#define SPAN_RED(X)      SPAN_CLASS("redtext",       X)
#define SPAN_ORANGE(X)   SPAN_CLASS("orange",        X)
#define SPAN_YELLOW(X)   SPAN_CLASS("yellow",        X)
#define SPAN_GREEN(X)    SPAN_CLASS("green",         X)
#define SPAN_BLUE(X)     SPAN_CLASS("blue",          X)
#define SPAN_VIOLET(X)   SPAN_CLASS("violet",        X)
#define SPAN_PURPLE(X)   SPAN_CLASS("purple",        X)
#define SPAN_GREY(X)     SPAN_CLASS("grey",          X)
#define SPAN_MAROON(X)   SPAN_CLASS("maroon",        X)
#define SPAN_PINK(X)     SPAN_CLASS("pink",          X)
#define SPAN_PALEPINK(X) SPAN_CLASS("palepink",      X)

// nearweb specific styles - add more as needed
#define SPAN_CBOLD(X)    SPAN_CLASS("combatbold",    X)
#define SPAN_PBOLD(X)    SPAN_CLASS("passivebold",   X)
#define SPAN_COMBAT(X)   SPAN_CLASS("combat",        X)
#define SPAN_CGLOW(X)    SPAN_CLASS("combatglow",    X)
#define SPAN_CMODE(X)    SPAN_CLASS("combatmodes",   X)
#define SPAN_HLTEXT(X)   SPAN_CLASS("highlighttext", X)
#define SPAN_FONDH(X)    SPAN_CLASS("fondheader",    X)
#define SPAN_LEGEND(X)   SPAN_CLASS("legendary",     X)
#define SPAN_LOOM(X)     SPAN_CLASS("loom",          X)
#define SPAN_PASSIVE(X)  SPAN_CLASS("passive",       X)
#define SPAN_EXAMINE(X)  SPAN_CLASS("examine",       X)
#define SPAN_STATUS(X)   SPAN_CLASS("jogtowalk",     X)
#define SPAN_MESSAGES(X) SPAN_CLASS("messages",      X)
#define SPAN_VALUE(X)    SPAN_CLASS("value",         X)
#define SPAN_UDANGER(X)  SPAN_CLASS("userdanger",    X)
#define SPAN_BADMOOD(X)  SPAN_CLASS("badmood",       X)
#define SPAN_BNAME(X)    SPAN_CLASS("bname",         X)

#define SPAN_DREAMER(X)  SPAN_CLASS("dreamershitfuckcomicao1", X)

// placeholders
#define SPAN_GOOD(X)     SPAN_GREEN(X)
#define SPAN_NEUTRAL(X)  SPAN_BLUE(X)
#define SPAN_BAD(X)      SPAN_RED(X)
#define SPAN_HARDSUIT(X) SPAN_BLUE(X)

#define STYLE_SMALLFONTS(X, S, C1) "<span style=\"font-family: 'Small Fonts'; color: [C1]; font-size: [S]px\">[X]</span>"

#define STYLE_SMALLFONTS_OUTLINE(X, S, C1, C2) "<span style=\"font-family: 'Small Fonts'; color: [C1]; -dm-text-outline: 1 [C2]; font-size: [S]px\">[X]</span>"

#define FONT_COLORED(color, text) "<font color='[color]'>[text]</font>"

#define FONT_SMALL(X) "<font size='1'>[X]</font>"

#define FONT_NORMAL(X) "<font size='2'>[X]</font>"

#define FONT_LARGE(X) "<font size='3'>[X]</font>"

#define FONT_HUGE(X) "<font size='4'>[X]</font>"

#define FONT_GIANT(X) "<font size='5'>[X]</font>"