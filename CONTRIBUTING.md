# Contribution Standards

This is a quick and dirty set of agreed-upon standards for contributions to the codebase. It is fairly informal at the moment and should be considered liable to change.

---

### Style guide

- No relative pathing, all paths must be absolute.
- No use of `:`, cast the reference to the appropriate type and use `.`.
- No use of `goto` unless you have a really good, exhaustively explained reason.
- Use constants instead of magic numbers or bare strings, when the values are being used in logic.
- Do not comment out code, delete it, version control makes keeping it in the codebase pointless.
- Macros/consts UPPERCASE, types and var names lowercase.
- Use the `/global/` keyword when declaring a globally scoped variable (ie. `var/global/list/foo`).
- Use the `/static/` keyword, rather than `/global/`, when declaring a static member variable that should be static (`/obj/var/static/foo`).
- Use `global.foo` when referencing global variables (rather than just `foo`).

---

### Pull requests
- It's ultimately the responsibility of the person opening the PR to keep it up to date with the codebase and fix any issues found by unit testing or pointed out during review. Reviewers should be open to discussion objections/alternatives either on Discord or in the diff.
- Opening a PR on behalf of someone else is not recommended unless you are willing to see it through even with changes requested, etc. Opening a PR in bad faith or to make a point is not acceptable.

#### Pull request reviews:
- Check for adherence to the above, general code quality (efficiency, good practices, proper use of tools), and content quality (spelling of descs, etc). Not meeting the objective standards means no merge.
- If there's a personal dislike of the PR, post about it for discussion. Maybe have an 'on hold for discussion' label. Try to reach a consensus/compromise. Failing a compromise, a majority maintainer vote will decide.
- First person to review approves the PR, second person to review can merge it. If 24 hours pass with no objections, first person can merge the PR themselves.
- PRs can have a 24 hour grace period applied by maintainers if it seems important for discussion and responses to be involved. Don't merge for the grace period if applied (reviews are fine).

### Footguns
A footgun is a pattern, function, assumption etc. that stands a strong chance to shoot you in the foot. They are documented here for ease of reference by new contributors.

#### List footguns
- Adding lists to lists will actually perform a merge, rather than inserting the list as a new record. If you want to insert a list into a list, you need to either:
    - double-wrap it, ex. `my_list += list(list("some_new_data" = 25))`
    - set the index directly, ex. `my_list[my_list.len] = list("some_new_data" = 25)`
- Using variables and macros as associative list keys have some notable behavior.
    - If declaring an associative list using a macro as a key, in a case where the macro does not exist (due to misspelling, etc.), that macro name will be treated as a string value for the associative list. You can guard against this by wrapping the macro in parens, ex. `list( (MY_MACRO_NAME) = "some_value" )`, which will fail to compile instead in cases where the macro doesn't exist.
    - If a variable is used as the associative key, it *must* be wrapped in parens, or it will be used as a string key.