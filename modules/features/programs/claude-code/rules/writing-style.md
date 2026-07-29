# Writing style

## Global

### No signs of AI writing

Avoid the prose patterns catalogued in <https://en.wikipedia.org/wiki/Wikipedia:Signs_of_AI_writing>.
Applies to code comments, error messages, documentation, pull request descriptions, commit messages, and agentic prompts and instructions.
The one exception is MEMORY.md, whose `—` entry separators are part of the memory format's schema.

### Tells to drop

- Em-dashes (—): Banned outright, including for asides.
  Use a comma, a semicolon, or a parenthetical aside "(like this)" instead.
- Grandiose framings: "participates as", "serves as", "the default identity class", "X represents Y".
- Spatial or anthropomorphic metaphors for code: "lives alongside", "sits next to", "lives only in", "mirror the X shape".
- Padding: "it's important to note", "it's worth noting", "in essence".
- Loaded adjectives: "robust", "comprehensive", "seamless", "elegant", "powerful".
- "Not only X but also Y" and parallel-three constructions when not warranted.
- Over-hedging ("might", "could", "may") when a direct statement fits.
- Restating the user's prompt before answering.

### What to do instead

Prefer direct, factual phrasing.
Re-read drafts with this list in mind before considering them done.
The fix is almost always shorter, not longer.

## Code comments

### No change narration

Comments describe the code as it stands, never the change that produced it.
The test: a reader who has never seen any earlier version of the file must find the comment fully meaningful.
If a comment only makes sense relative to a diff, migration, decision, or prior implementation, it is change narration and belongs in a commit message, pull request description, or design document.

- Tell-words that mark change narration: "now", "no longer", "formerly", "previously", "instead of", "moved/renamed from", "passed explicitly" (implying it once wasn't), citing the change's own spec/pull request/date as justification, or any explanation of why the edit is correct or safe.
- Future-work notes are allowed only as `TODO:` and `NOTE:` with the trigger condition ("Remove when {event happens}..."), never as prose above the line.
- Constraints the code cannot express are allowed: Things like external-system behavior, why a value must be exactly this, and ordering or coupling requirements.
- The default behavior for lines added during a refactor is to not leave a comment.
  When editing code near existing "change narration" comments, delete them.
