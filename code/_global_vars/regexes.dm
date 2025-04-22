//These are a bunch of regex datums for use /((any|every|no|some|head|foot)where(wolf)?\sand\s)+(\.[\.\s]+\s?where\?)?/i
GLOBAL_GETTER(is_http_protocol, /regex, regex("^https?://"))

GLOBAL_GETTER(is_website, /regex, regex("http|www.|\[a-z0-9_-]+.(com|org|net|mil|edu)+", "i"))
GLOBAL_GETTER(is_email, /regex, regex("\[a-z0-9_-]+@\[a-z0-9_-]+.\[a-z0-9_-]+", "i"))
GLOBAL_GETTER(is_alphanumeric, /regex, regex("\[a-z0-9]+", "i"))
GLOBAL_GETTER(is_punctuation, /regex, regex("\[.!?]+", "i"))
GLOBAL_GETTER(is_color, /regex, regex("^#\[0-9a-fA-F]{6}$"))
GLOBAL_GETTER(is_alpha_color, /regex, regex("^#\[0-9a-fA-F]{8}$"))

//finds text strings recognized as links on discord. Mainly used to stop embedding.
GLOBAL_GETTER(has_discord_embeddable_links, /regex, regex("(https?://\[^\\s|<\]{2,})"))

GLOBAL_GETTER(standard_year, /regex, regex(@"^(?<year>[0-9]{4})"))

//All < and > characters
GLOBAL_GETTER(angular_brackets, /regex, regex(@"[<>]", "g"))

//All characters between < a > inclusive of the bracket
GLOBAL_GETTER(html_tags, /regex, regex(@"<.*?>", "g"))

//All characters forbidden by filenames: ", \, \n, \t, /, ?, %, *, :, |, <, >, ..
GLOBAL_GETTER_PROTECTED(filename_forbidden_chars, /regex, regex(@{""|[\\\n\t/?%*:|<>]|\.\."}, "g"))