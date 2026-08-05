# Injects a `<system-reminder>` that tells the model when each prompt was sent.

{
  hookSpecificOutput: {
    hookEventName: "UserPromptSubmit",
    additionalContext: "Message sent at: \(now | strflocaltime("%H:%M:%S %Z"))"
  }
}
