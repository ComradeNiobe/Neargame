/* A function to allow clients to send HTTP POST requests.
	Because world.Export() doesn't support POST yet.
*/
/// ! DO NOT USE THIS. IT DOESN'T WORK AND IT'S BAD.
/world/proc/HttpPost(url, data)
	src << output(list2params(list(url, json_encode(data))), "http_post_browser.browser:post")