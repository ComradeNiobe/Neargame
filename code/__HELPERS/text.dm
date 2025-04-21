/*
 * Holds procs designed to help with d_filtering text
 * Contains groups:
 *			SQL sanitization
 *			Text sanitization
 *			Text searches
 *			Text modification
 *			Misc
 */


/*
 * SQL sanitization
 */

// Run all strings to be used in an SQL query through this proc first to properly escape out injection attempts.
/proc/sanitizeSQL(t)
	var/sqltext = dbcon.Quote("[t]") // http://www.byond.com/forum/post/2218538
	return copytext(sqltext, 2, -1)

/*
 * Text sanitization
 */

/proc/strip_non_ascii(text)
	var/static/regex/non_ascii_regex = regex(@"[^\x00-\x7F]+", "g")
	return non_ascii_regex.Replace(text, "")

/proc/strip_html_simple(t, limit = MAX_MESSAGE_LEN)
	var/list/strip_chars = list("<",">")
	t = copytext(t,1,limit)
	for(var/char in strip_chars)
		var/index = findtext(t, char)
		while(index)
			t = copytext(t, 1, index) + copytext(t, index+1)
			index = findtext(t, char)
	return t

//This proc strips html properly, remove < > and all text between
//for complete text sanitizing should be used sanitize()
/proc/strip_html_properly(input)
	if(!input)
		return
	var/opentag = 1 //These store the position of < and > respectively.
	var/closetag = 1
	while(1)
		opentag = findtext(input, "<")
		closetag = findtext(input, ">")
		if(closetag && opentag)
			if(closetag < opentag)
				input = copytext(input, (closetag + 1))
			else
				input = copytext(input, 1, opentag) + copytext(input, (closetag + 1))
		else if(closetag || opentag)
			if(opentag)
				input = copytext(input, 1, opentag)
			else
				input = copytext(input, (closetag + 1))
		else
			break

	return input
/**
 * Strip out the special beyond characters for \proper and \improper
 * from text that will be sent to the browser.
 */
#define strip_improper(input_text) replacetext(replacetext(input_text, "\proper", ""), "\improper", "")
var/global/regex/starts_uppercase_regex = regex(@"^[A-Z]")
var/global/regex/starts_lowercase_regex = regex(@"^[a-z]")
#define is_proper(input_text) ((findtext(input_text, "\proper") == 1) || findtext(input_text, starts_uppercase_regex))
#define is_improper(input_text) ((findtext(input_text, "\improper") == 1 || findtext(input_text, starts_lowercase_regex)))

/proc/sanitize_PDA(var/msg)
	var/index = findtext(msg, "�")
	while(index)
		msg = copytext_char(msg, 1, index) + "&#1103;" + copytext_char(msg, index+1)
		index = findtext(msg, "�")
	index = findtext(msg, "&#255;")
	while(index)
		msg = copytext_char(msg, 1, index) + "&#1103;" + copytext_char(msg, index+1)
		index = findtext(msg, "&#255;")
	return msg

//Used for preprocessing entered text
//Added in an additional check to alert players if input is too long
/proc/sanitize(input, max_length = MAX_MESSAGE_LEN, encode = TRUE, trim = TRUE, extra = TRUE, ascii_only = FALSE)
	if(!input)
		return

	if(max_length)
		var/input_length = length_char(input)
		if(input_length > max_length)
			to_chat(usr, SPAN_WARNING("Your message is too long by [input_length - max_length] character\s."))
			return
		input = copytext_char(input, 1, max_length + 1)

	input = strip_improper(input)

	if(extra)
		input = replace_characters(input, list("\n"=" ","\t"=" "))

	if(ascii_only)
		// Some procs work differently depending on unicode/ascii string
		// You should always consider this with any text processing work
		// More: http://www.byond.com/docs/ref/info.html#/{notes}/Unicode
		//       http://www.byond.com/forum/post/2520672
		input = strip_non_ascii(input)
	else
		// Strip Unicode control/space-like chars here exept for line endings (\n,\r) and normal space (0x20)
		// codes from https://www.compart.com/en/unicode/category/
		//            https://en.wikipedia.org/wiki/Whitespace_character#Unicode
		var/static/regex/unicode_control_chars = regex(@"[\u0001-\u0009\u000B\u000C\u000E-\u001F\u007F\u0080-\u009F\u00A0\u1680\u180E\u2000-\u200D\u2028\u2029\u202F\u205F\u2060\u3000\uFEFF]", "g")
		input = unicode_control_chars.Replace(input, "")
		// Allows at most one Unicode combining diacritical mark in a row
		// Codes acquired from https://en.wikipedia.org/wiki/Combining_Diacritical_Marks
		//                     https://en.wikipedia.org/wiki/Combining_Diacritical_Marks_Extended
		//                     https://en.wikipedia.org/wiki/Combining_Diacritical_Marks_Supplement
		//                     https://en.wikipedia.org/wiki/Combining_Diacritical_Marks_for_Symbols
		//                     https://en.wikipedia.org/wiki/Combining_Half_Marks
		var/static/regex/unicode_diacritical_marks = regex(@"([\u0300-\u036F\u1AB0-\u1ACE\u1DC0-\u1DFF\u20D0-\u20F0\uFE20-\uFE2F]){2,}", "g")
		input = unicode_diacritical_marks.Replace(input, "$1")

	if(encode)
		// In addition to processing html, html_encode removes byond formatting codes like "\red", "\i" and other.
		// It is important to avoid double-encode text, it can "break" quotes and some other characters.
		// Also, keep in mind that escaped characters don't work in the interface (window titles, lower left corner of the main window, etc.)
		input = html_encode(input)
	else
		// If not need encode text, simply remove < and >
		// note: we can also remove here byond formatting codes: 0xFF + next byte
		input = replace_characters(input, list("<"=" ", ">"=" "))

	if(trim)
		input = trim(input)

	return input

//Run sanitize(), but remove <, >, " first to prevent displaying them as &gt; &lt; &34; in some places after html_encode().
//Best used for sanitize object names, window titles.
//If you have a problem with sanitize() in chat, when quotes and >, < are displayed as html entities -
//this is a problem of double-encode(when & becomes &amp;), use sanitize() with encode=0, but not the sanitize_safe()!
/proc/sanitize_safe(input, max_length = MAX_MESSAGE_LEN, encode = TRUE, trim = TRUE, extra = TRUE, ascii_only = FALSE)
	return sanitize(replace_characters(input, list(">"=" ","<"=" ", "\""="'")), max_length, encode, trim, extra, ascii_only)

/proc/paranoid_sanitize(t)
	var/regex/alphanum_only = regex("\[^a-zA-Z0-9# ,.?!:;()]", "g")
	return alphanum_only.Replace(t, "#")

/proc/replace_characters(t, list/repl_chars)
	for(var/char in repl_chars)
		t = replacetext(t, char, repl_chars[char])
	return t

/proc/sanitize_uni(var/t,var/list/repl_chars = list("�"="&#255;"))
	for(var/char in repl_chars)
		var/index = findtext(t, char)
		while(index)
			t = copytext_char(t, 1, index) + repl_chars[char] + copytext_char(t, index+1)
			index = findtext(t, char)
	return t

//Returns null if there is any bad text in the string
/proc/reject_bad_text(text, max_length=512)
	if(length(text) > max_length)	return			//message too long
	var/non_whitespace = 0
	for(var/i=1, i<=length(text), i++)
		switch(text2ascii(text,i))
			if(62,60,92,47)	return			//rejects the text if it contains these bad characters: <, >, \ or /
			if(127 to 255)	return			//rejects non-ASCII letters
			if(0 to 31)		return			//more weird stuff
			if(32)			continue		//whitespace
			else			non_whitespace = 1
	if(non_whitespace)		return text		//only accepts the text if it has some non-spaces

// Used to get a sanitized input.
/proc/stripped_input(var/mob/user, var/message = "", var/title = "", var/default = "", var/max_length=MAX_MESSAGE_LEN)
	var/name = input(user, message, title, default)
	return strip_html_simple(name, max_length)

//Filters out undesirable characters from names
/proc/sanitize_name(input, max_length = MAX_NAME_LEN, allow_numbers = 0, force_first_letter_uppercase = TRUE)
	if(!input || length_char(input) > max_length)
		return //Rejects the input if it is null or if it is longer then the max length allowed

	var/number_of_alphanumeric	= 0
	var/last_char_group			= 0
	var/output = ""

	var/char = ""
	var/bytes_length = length(input)
	var/ascii_char
	for(var/i = 1, i <= bytes_length, i += length(char))
		char = input[i]

		ascii_char = text2ascii(char)

		switch(ascii_char) //todo: unicode names?
			// A  .. Z
			if(65 to 90)			//Uppercase Letters
				output += ascii2text(ascii_char)
				number_of_alphanumeric++
				last_char_group = 4

			// a  .. z
			if(97 to 122)			//Lowercase Letters
				if(last_char_group<2 && force_first_letter_uppercase)
					output += ascii2text(ascii_char-32)	//Force uppercase first character
				else
					output += ascii2text(ascii_char)
				number_of_alphanumeric++
				last_char_group = 4

			// 0  .. 9
			if(48 to 57)			//Numbers
				if(!last_char_group)		continue	//suppress at start of string
				if(!allow_numbers)			continue
				output += ascii2text(ascii_char)
				number_of_alphanumeric++
				last_char_group = 3

			// '  -  .
			if(39,45,46)			//Common name punctuation
				if(!last_char_group) continue
				output += ascii2text(ascii_char)
				last_char_group = 2

			// ~   |   @  :  #  $  %  &  *  +
			if(126,124,64,58,35,36,37,38,42,43)			//Other symbols that we'll allow (mainly for AI)
				if(!last_char_group)		continue	//suppress at start of string
				if(!allow_numbers)			continue
				output += ascii2text(ascii_char)
				last_char_group = 2

			//Space
			if(32)
				if(last_char_group <= 1)	continue	//suppress double-spaces and spaces at start of string
				output += ascii2text(ascii_char)
				last_char_group = 1
			else
				return

	if(number_of_alphanumeric < 2)	return		//protects against tiny names like "A" and also names like "' ' ' ' ' ' ' '"

	if(last_char_group == 1)
		output = copytext(output, 1, -1)	//removes the last character (in this case a space)

	return output

//checks text for html tags
//if tag is not in whitelist (var/list/paper_tag_whitelist in global.dm)
//relpaces < with &lt;
/proc/checkhtml(var/t)
	t = html_encode(t)
	var/p = findtext(t,"<",1)
	while (p)	//going through all the tags
		var/start = p++
		var/tag = copytext_char(t,p, p+1)
		if (tag != "/")
			while (reject_bad_text(copytext_char(t, p, p+1), 1))
				tag = copytext_char(t,start, p)
				p++
			tag = copytext_char(t,start+1, p)
			if (!(tag in paper_tag_whitelist))	//if it's unkown tag, disarming it
				t = copytext_char(t,1,start-1) + "&lt;" + copytext_char(t,start+1)
		p = findtext(t,"<",p)
	return t
/*
 * Text searches
 */

//Checks the beginning of a string for a specified sub-string
//Returns the position of the substring or 0 if it was not found
/proc/dd_hasprefix(text, prefix)
	var/start = 1
	var/end = length(prefix) + 1
	return findtext(text, prefix, start, end)

//Checks the beginning of a string for a specified sub-string. This proc is case sensitive
//Returns the position of the substring or 0 if it was not found
/proc/dd_hasprefix_case(text, prefix)
	var/start = 1
	var/end = length(prefix) + 1
	return findtextEx(text, prefix, start, end)

//Checks the end of a string for a specified substring.
//Returns the position of the substring or 0 if it was not found
/proc/dd_hassuffix(text, suffix)
	var/start = length(text) - length(suffix)
	if(start)
		return findtext(text, suffix, start, null)
	return

//Checks the end of a string for a specified substring. This proc is case sensitive
//Returns the position of the substring or 0 if it was not found
/proc/dd_hassuffix_case(text, suffix)
	var/start = length(text) - length(suffix)
	if(start)
		return findtextEx(text, suffix, start, null)

/*
 * Text modification
 */
/proc/replaceText(text, find, replacement)
	return list2text(text2list(text, find), replacement)

/proc/replaceTextEx(text, find, replacement)
	return list2text(text2listEx(text, find), replacement)

//Adds 'u' number of zeros ahead of the text 't'
/proc/add_zero(t, u)
	while (length(t) < u)
		t = "0[t]"
	return t

//Adds 'u' number of spaces ahead of the text 't'
/proc/add_lspace(t, u)
	while(length(t) < u)
		t = " [t]"
	return t

//Adds 'u' number of spaces behind the text 't'
/proc/add_tspace(t, u)
	while(length(t) < u)
		t = "[t] "
	return t

// Returns a string with reserved characters and spaces before the first letter removed
// not work for unicode spaces - you should cleanup them first with sanitize()
/proc/trim_left(text)
	for (var/i = 1 to length(text))
		if (text2ascii(text, i) > 32)
			return copytext(text, i)
	return ""

// Returns a string with reserved characters and spaces after the last letter removed
// not work for unicode spaces - you should cleanup them first with sanitize()
/proc/trim_right(text)
	for (var/i = length(text), i > 0, i--)
		if (text2ascii(text, i) > 32)
			return copytext(text, 1, i + 1)

	return ""

// Returns a string with reserved characters and spaces before the first word and after the last word removed.
// not work for unicode spaces - you should cleanup them first with sanitize()
/proc/trim(text)
	return trim_left(trim_right(text))

//Returns a string with the first element of the string capitalized.
/proc/capitalize(text)
	if(text)
		text = uppertext(text[1]) + copytext(text, 1 + length(text[1]))
	return text

//Returns a string with the first element of the string dcapitalized.
/proc/decapitalize(text)
	if(text)
		text = lowertext(text[1]) + copytext(text, 1 + length(text[1]))
	return text

//Centers text by adding spaces to either side of the string.
/proc/dd_centertext(message, length)
	var/new_message = message
	var/size = length(message)
	var/delta = length - size
	if(size == length)
		return new_message
	if(size > length)
		return copytext_char(new_message, 1, length + 1)
	if(delta == 1)
		return new_message + " "
	if(delta % 2)
		new_message = " " + new_message
		delta--
	var/spaces = add_lspace("",delta/2-1)
	return spaces + new_message + spaces

//Limits the length of the text. Note: MAX_MESSAGE_LEN and MAX_NAME_LEN are widely used for this purpose
/proc/dd_limittext(message, length)
	var/size = length(message)
	if(size <= length)
		return message
	return copytext_char(message, 1, length + 1)


/proc/stringmerge(var/text,var/compare,replace = "*")
//This proc fills in all spaces with the "replace" var (* by default) with whatever
//is in the other string at the same spot (assuming it is not a replace char).
//This is used for fingerprints
	var/newtext = text
	if(length(text) != length(compare))
		return 0
	for(var/i = 1, i < length(text), i++)
		var/a = copytext_char(text,i,i+1)
		var/b = copytext_char(compare,i,i+1)
//if it isn't both the same letter, or if they are both the replacement character
//(no way to know what it was supposed to be)
		if(a != b)
			if(a == replace) //if A is the replacement char
				newtext = copytext_char(newtext,1,i) + b + copytext_char(newtext, i+1)
			else if(b == replace) //if B is the replacement char
				newtext = copytext_char(newtext,1,i) + a + copytext_char(newtext, i+1)
			else //The lists disagree, Uh-oh!
				return 0
	return newtext

/proc/stringpercent(var/text,character = "*")
//This proc returns the number of chars of the string that is the character
//This is used for detective work to determine fingerprint completion.
	if(!text || !character)
		return 0
	var/count = 0
	for(var/i = 1, i <= length(text), i++)
		var/a = copytext_char(text,i,i+1)
		if(a == character)
			count++
	return count

/proc/reverse_text(var/text = "")
	var/new_text = ""
	for(var/i = length(text); i > 0; i--)
		new_text += copytext_char(text, i, i+1)
	return new_text

/proc/upperrustext(text as text)
	var/t = ""
	for(var/i = 1, i <= length(text), i++)
		var/a = text2ascii(text, i)
		if (a > 223)
			t += ascii2text(a - 32)
		else if (a == 184)
			t += ascii2text(168)
		else t += ascii2text(a)
	t = replacetext(t,"&#255;","�")
	return t


/proc/lowerrustext(text as text)
	var/t = ""
	for(var/i = 1, i <= length(text), i++)
		var/a = text2ascii(text, i)
		if (a > 191 && a < 224)
			t += ascii2text(a + 32)
		else if (a == 168)
			t += ascii2text(184)
		else t += ascii2text(a)
	return t

/proc/rhtml_encode(var/msg)
	var/list/c = text2list(msg, "�")
	if(c.len == 1)
		c = text2list(msg, "&#255;")
		if(c.len == 1)
			return html_encode(msg)
	var/out = ""
	var/first = 1
	for(var/text in c)
		if(!first)
			out += "&#255;"
		first = 0
		out += html_encode(text)
	return out

/proc/rhtml_encode_paper(var/msg)
	var/list/c = text2list(msg, "�")
	if(c.len == 1)
		c = text2list(msg, "&#1103;")
		if(c.len == 1)
			return html_encode(msg)
	var/out = ""
	var/first = 1
	for(var/text in c)
		if(!first)
			out += "&#1103;"
		first = 0
		out += html_encode(text)
	return out

/proc/rhtml_decode(var/msg)
	var/list/c = text2list(msg, "�")
	if(c.len == 1)
		c = text2list(msg, "&#255;")
		if(c.len == 1)
			return html_decode(msg)
	var/out = ""
	var/first = 1
	for(var/text in c)
		if(!first)
			out += "&#255;"
		first = 0
		out += html_decode(text)
	return out

/proc/rhtml_decode_paper(var/msg)
	var/list/c = text2list(msg, "�")
	if(c.len == 1)
		c = text2list(msg, "&#1103;")
		if(c.len == 1)
			return html_decode(msg)
	var/out = ""
	var/first = 1
	for(var/text in c)
		if(!first)
			out += "&#1103;"
		first = 0
		out += html_decode(text)
	return out


//Used in preferences' SetFlavorText and human's set_flavor verb
//Previews a string of len or less length
/proc/TextPreview(var/string,var/len=40)
	if(length(string) <= len)
		if(!length(string))
			return "\[...\]"
		else
			return string
	else
		return "[copytext_preserve_html(string, 1, 37)]..."

//alternative copytext() for encoded text, doesn't break html entities (&#34; and other)
/proc/copytext_preserve_html(var/text, var/first, var/last)
	return html_encode(copytext(html_decode(text), first, last))

/proc/sql_sanitize_text(var/text)
	text = replacetext(text, "'", "''")
	text = replacetext(text, ";", "")
	text = replacetext(text, "&", "")
	return text