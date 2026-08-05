# Prefixes each assistant message with a timestamp. Messages are streamed
# in chunks, so we only prefix the first one (one timestamp per message).

def dim: "\u001b[2m";
def reset: "\u001b[0m";

select(.index == 0) | {
  hookSpecificOutput: {
    hookEventName: "MessageDisplay",
    displayContent: "\(dim)[\(now | strflocaltime("%H:%M:%S"))]\(reset) \(.delta)"
  }
}
