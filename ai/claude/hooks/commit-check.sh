#!/bin/sh
# Claude Code PreToolUse hook (Bash): an advisory check on `git commit`.
# Blocks only on objective failures; otherwise asks the agent to review the
# commit against the "Simplicity" and "Engineering principles" in AGENTS.md.

input=$(cat)
case "$input" in *commit*) ;; *) exit 0 ;; esac

cmd=$(printf '%s' "$input" | jq -r '.tool_input.command // ""')
printf '%s\n' "$cmd" | grep -Eq '(^|[;&|(] *)git( +-[Cc] +[^ ]+)* +commit( |$)' || exit 0

# The repository the commit runs in: `git -C DIR`, a leading `cd DIR &&`, or the session cwd.
cwd=$(printf '%s' "$input" | jq -r '.cwd // "."')
dir=$(printf '%s\n' "$cmd" | sed -nE 's/.*git +-C +([^ ]+).*/\1/p; s/^ *cd +([^ ;&]+) *&&.*/\1/p' | head -1 | tr -d "\"'")
case "$dir" in
    "") dir=$cwd ;;
    "~"*) dir="$HOME${dir#"~"}" ;;
    /*) ;;
    *) dir="$cwd/$dir" ;;
esac

nl='
'
problems=""

# Small, green commits: every commit passes the project's checks and is signed.
if printf '%s\n' "$cmd" | grep -Eq -- '--no-verify|--no-gpg-sign|commit\.gpgsign=false'; then
    problems="$problems- it skips the commit's checks or signing (--no-verify, --no-gpg-sign or commit.gpgsign=false)$nl"
fi

# Type everything, strictly: no checker escapes in added code (docs may discuss them).
escapes=$(git -C "$dir" diff --cached -U0 -- . ':(exclude)*.md' 2>/dev/null |
    grep '^+' | grep -v '^+++' |
    grep -Eo 'type: *ignore|pyright: *ignore|no[q]a|@ts-[i]gnore|@ts-[e]xpect-error|eslint-[d]isable|no[l]int' |
    sort -u | paste -sd, -)
if [ -n "$escapes" ]; then
    problems="$problems- the staged diff adds checker escapes ($escapes)$nl"
fi

# Commits speak as the author: the message never names the user.
first=$(git -C "$dir" config user.name 2>/dev/null | cut -d' ' -f1)
if [ -n "$first" ] && printf '%s\n' "$cmd" | grep -qw -- "$first"; then
    problems="$problems- the commit message names $first, who is its author$nl"
fi

if [ -n "$problems" ]; then
    jq -n --arg r "Commit check found:$nl${problems}Fix these, or ask the user if one is intended." \
        '{hookSpecificOutput: {hookEventName: "PreToolUse", permissionDecision: "deny", permissionDecisionReason: $r}}'
else
    jq -n --arg c 'Commit check: once this commit lands, review what it records against the "Simplicity" and "Engineering principles" sections of AGENTS.md. When it is clean, say nothing about it. When you find a design-level issue (a second path through the core flow, a mechanism stacked beside the one it replaces, behaviour without a test at an agreed seam), tell the user in one line and leave the code as it is unless they ask.' \
        '{hookSpecificOutput: {hookEventName: "PreToolUse", additionalContext: $c}}'
fi
