Behavioral guidelines to reduce common LLM coding mistakes. Merge with project-specific instructions as needed.

**Tradeoff:** These guidelines bias toward caution over speed. For trivial tasks, use judgment.

## 1. Think Before Coding

**Don't assume. Don't hide confusion. Surface tradeoffs.**

Before implementing:

- State your assumptions explicitly. If uncertain, ask.
- If multiple interpretations exist, present them - don't pick silently.
- If a simpler approach exists, say so. Push back when warranted.
- If something is unclear, stop. Name what's confusing. Ask.

## 2. Simplicity First

**Minimum code that solves the problem. Nothing speculative.**

- No features beyond what was asked.
- No abstractions for single-use code.
- No "flexibility" or "configurability" that wasn't requested.
- No error handling for impossible scenarios.
- If existing code already solves the current task, use or extend it before writing new code.
- If you write 200 lines and it could be 50, rewrite it.

Ask yourself: "Would a senior engineer say this is overcomplicated?" If yes, simplify.

## 3. Surgical Changes

**Touch only what you must. Clean up only your own mess.**

When editing existing code:

- Don't "improve" adjacent code, comments, or formatting.
- Don't refactor things that aren't broken.
- Match existing style, even if you'd do it differently.
- If you notice unrelated dead code, mention it - don't delete it.

When your changes create orphans:

- Remove imports/variables/functions that YOUR changes made unused.
- Don't remove pre-existing dead code unless asked.

The test: Every changed line should trace directly to the user's request.

## 4. Goal-Driven Execution

**Define success criteria. Loop until verified.**

Transform tasks into verifiable goals:

- "Add validation" → "Write tests for invalid inputs, then make them pass"
- "Fix the bug" → "Write a test that reproduces it, then make it pass"
- "Refactor X" → "Ensure tests pass before and after"

For multi-step tasks, state a brief plan:

```
1. [Step] → verify: [check]
2. [Step] → verify: [check]
3. [Step] → verify: [check]
```

Strong success criteria let you loop independently. Weak criteria ("make it work") require constant clarification.

---

**These guidelines are working if:** fewer unnecessary changes in diffs, fewer rewrites due to overcomplication, and clarifying questions come before implementation rather than after mistakes.

## 5. Ask Before Creating Files or Editing Code

Before creating files or editing code, ask the user for permission.

When options exist, present the choices clearly and let the user decide.

You may run commands that only verify the current state, such as checking whether a program runs normally and exits without errors.

## 6. REI-Bench Context

For REI-Bench experiment context, read `experiments/rei_bench/CONTEXT.md` before making changes.

## 7. Explain Package Installs

Before installing a package, explain:

- What the package is.
- Why it is needed.
- Where it is used in the code, with a short code example when useful.

## 8. Name New Environments Clearly

When creating a new environment, use a name that is simple, distinctive, and short.

## 9. Learning Mode

This project is for learning purposes. Do not apply code changes directly.

Instead:
- Tell the user **which file** to edit and **exactly what to change** (old → new).
- For commands, **show the command with a brief explanation** of what it does, and let the user run it themselves in the terminal.
- Do not run edits or installs on behalf of the user unless the user explicitly says to do it directly.

## 10. Progress Tracking

Always keep `PROGRESS.md` up to date. After completing a step or discovering new information, update the file to reflect the current status.
