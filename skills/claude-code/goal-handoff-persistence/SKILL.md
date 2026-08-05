---
name: goal-handoff-persistence
description: "Use for long-running, multi-stage, research-heavy, risky, or resumable work that could lose critical state or working understanding across context compaction, restarts, sessions, models, or agents. Enforces relevance-filtered transactional checkpoints: task-relevant findings are persisted immediately before more work, unrelated material is discarded, and bounded goal.md/handoff.md snapshots remain sufficient for direct resumption."
---

# Goal + Handoff Persistence

Preserve the minimum sufficient state and working understanding a completely new
agent needs to continue correctly without repeating completed discovery.

`handoff.md` is a mutable resume snapshot. It is not a transcript, operation log,
research notebook, status report, or history of everything that happened.

## File Roles

- `goal.md`: stable objective, acceptance criteria, core constraints, and current
  direction.
- `handoff.md`: current system/task state, active decisions, key artifacts,
  synthesized working understanding, unresolved risks, implementation brief, and
  the single next action.
- `notes/active-research.md`: source-level findings whenever research spans more
  than one bounded batch. It contains only task-relevant current findings,
  supplements but never replaces a sufficient handoff, and is reconciled rather
  than used as a raw reading diary.
- `archive/`: old snapshots retained for selective historical lookup.
- `logs/`: optional detailed evidence only when auditability or exact
  reproduction is genuinely required.

Keep history out of the active resume files unless it still changes what the
successor should do.

## Mandatory Contract

1. **Goal write gate**
   Update `goal.md` only when the user explicitly changes the objective,
   deliverable, scope, core acceptance criteria, or core constraints. Routine
   progress, diagnosis, implementation, verification, and completion do not
   change `goal.md`.

2. **Bounded read gate**
   Before fully reading or writing either file, check byte sizes. `goal.md` must
   not exceed 6,000 bytes and `handoff.md` must not exceed 64,000 bytes. Use
   decimal byte counts. If a file is oversized, follow the Bounded Archive
   Protocol before any full read.

3. **Task relevance gate**
   Persist a finding only when it directly affects the current goal, acceptance
   criteria, diagnosis, implementation, validation, constraint, risk, artifact,
   rollback path, blocker, or next action. Merely interesting, adjacent,
   speculative, raw, or unrelated material is forbidden from `handoff.md`,
   `notes/`, `logs/`, and `archive/` by default.

4. **Bounded research transaction gate**
   Never hold more than one uncheckpointed research/inspection batch in volatile
   context. A batch is one large source or bounded chunk, or at most two sources
   already known to be small. Do not bulk-read or parallel-fetch many substantive
   sources and summarize later.

5. **Immediate persistence barrier**
   Immediately after a read/search/fetch/inspection result, classify every new
   finding before any further substantive tool call. Collapse related relevant
   observations into the minimum actionable synthesis, then make it durable as
   the next operation. Put the current conclusion and next-action implication in
   `handoff.md`; put supporting source-level detail in
   `notes/active-research.md`. If the note contains support a successor needs,
   add or refresh its exact pointer in the handoff in the same checkpoint. A note
   write alone never substitutes for an up-to-date handoff. Until this is
   durable, do not read or search again, run commands, edit code, build, test, or
   start another agent. Unrelated findings must be discarded, not recorded.

6. **Reconciliation gate**
   When resume-critical state or working understanding changes, reconcile the
   existing snapshot. Replace, merge, or delete stale information. Do not append
   an operation record merely because an operation occurred.

7. **Recovery gate**
   After context compaction, session/model/agent change, restart, or suspected
   context loss, first check file sizes, rotate oversized files if needed, then
   read the complete bounded `goal.md` and `handoff.md`. If the handoff points to
   an active research note needed for the next action, read its current bounded
   question/findings/cursor sections. Do not restart broad source reading before
   this recovery step.

8. **No-Reread acceptance gate**
   Before treating the handoff as current, imagine a fresh agent with no chat
   history. It must be able to perform the stated next action from `goal.md` and
   `handoff.md` without repeating the completed research or inspection phase. If
   not, the handoff is incomplete and must be expanded with the missing working
   model, source map, rationale, invariants, or unresolved questions.

9. **Risk gate**
   Before a risky or irreversible mutation, ensure the snapshot contains the
   relevant current state, backup or rollback path, and unresolved risk. Back up
   sensitive state before changing it.

Do not copy this full contract into every task file. A one-line note naming this
skill and the two byte limits is enough.

## Finding Classification

Classify each new finding immediately after its source result returns:

- **A — relevant and new:** it changes or materially supports the current task's
  working model, decision, implementation, validation, risk, or next action.
  Persist it immediately before any other substantive operation.
- **B — relevant but duplicate/superseding:** merge it into the existing current
  finding, replace weaker/older evidence, or make no write when it adds nothing.
  Never append a duplicate chronology.
- **C — unrelated or non-actionable:** it does not affect the current task.
  Discard it. Do not save it “for later” in any task-memory file.

A negative result is relevant only when it rules out a live hypothesis, changes
the plan, or prevents expensive repetition. “Interesting” is not a relevance
criterion.

Classification is per finding; persistence is per synthesis. Combine related A
findings from the batch into the fewest conclusions needed for correct
resumption. Do not create one handoff bullet per source, observation, or tool
result. This compression must preserve every distinct task-relevant implication,
constraint, and evidence dependency. Brevity never permits dropping an A
finding; keep necessary support that cannot be represented losslessly in the
handoff in `notes/active-research.md` and link it from the handoff.

Persist a finding when forgetting it could cause at least one of these outcomes:

- an incorrect or unsafe next action
- loss of a user decision or active constraint
- repetition of expensive or destructive work
- loss of a diagnosis, architecture map, source-derived constraint, or
  implementation rationale
- loss of a required artifact, backup, or rollback path
- concealment of an unresolved blocker, risk, or uncertainty
- inability to resume the task directly

Before writing, require all of these:

1. It directly belongs to the current task and answers a live question or changes
   an actionable conclusion.
2. It is current and new, stronger, or necessary to prevent costly repetition.
3. It can be synthesized as a conclusion rather than copied as raw source output.
4. It is stored at the narrowest useful level: current model in `handoff.md`,
   source-level support in `notes/active-research.md`.
5. Existing related text is reconciled so the write does not create duplication.

If any relevance requirement fails, do not persist the material anywhere in the
task memory.

## Do Not Record By Default

Do not add these to `handoff.md` unless they changed resume-critical state or
working understanding:

- the user merely asked for progress or status
- reading this skill, checking file sizes, or updating the handoff itself
- creating routine task-memory directories
- the bare fact that a file, webpage, search result, tool, or command was read or
  used; record its new actionable conclusion when one exists
- read-only checks that confirmed an already-established conclusion
- failed/no-result probes that did not change diagnosis or next action
- repeated validations of the same conclusion
- transient narration, implementation play-by-play, or chat summaries
- full command output, long rule lists, raw logs, or copied source material
- tangents, adjacent facts, background trivia, or speculative possibilities that
  do not change a live task decision
- completed next steps, resolved risks, and superseded hypotheses

Never create `Completed Operations`, dated update streams, or similar
append-only sections by default.

Do not confuse "do not record the read operation" with "do not record what was
learned." New conclusions that affect diagnosis, implementation, constraints, or
the next action are mandatory handoff content.

## Required Handoff Shape

Use this structure and omit empty sections:

```markdown
# Handoff

## Current Snapshot
- Only current facts needed to understand the live state.
- When discovery has occurred, include a compact Working Understanding or
  Implementation Brief: current model/diagnosis, relevant files/symbols/URLs and
  their significance, intended change and rationale, invariants, and unresolved
  questions.

## Decisions And Constraints
- Active user decisions and constraints that must not be violated.

## Artifacts And Rollback
- Key files, outputs, backups, evidence locations, and rollback paths.

## Open Risks And Uncertainty
- Only unresolved items. Mark uncertain claims explicitly.

## Next Action
1. The single most direct next action.
```

Optimize for minimum sufficient information, not minimum word count. A handoff
is too short when it forces a successor to repeat a completed research or
inspection phase. Prefer one fact per bullet and no nested chronology. Reference
`goal.md` instead of duplicating its objective and constraints.

## Transactional Research Checkpoints

Research and code reading change durable working understanding even when they do
not change files or external state. Process them as bounded transactions.

### Before A Batch

1. Ensure the current research question and source cursor are already durable
   when losing them would cause broad rediscovery.
2. For local text, inspect size before a full read. Treat a source over 20,000
   bytes as large and read it in bounded chunks no larger than about 200 lines or
   20,000 bytes.
3. For webpages, PDFs, logs, and search results, request one bounded page,
   section, range, or query result set. Avoid unbounded fetches and large parallel
   fan-out.
4. Ingest one large source/chunk or at most two sources already known to be small.

### Immediately After A Batch

1. Classify each finding as A, B, or C using the Finding Classification above.
2. Discard C findings.
3. Collapse related A findings into the minimum actionable synthesis; reconcile
   B findings rather than appending.
4. Persist that synthesis immediately. Update `handoff.md` with the current
   conclusion and next-action implication; store only necessary source-level
   support in `notes/active-research.md` and link its exact section from the
   handoff in the same checkpoint.
5. Update the source cursor.
6. Run the No-Reread Test for the knowledge accumulated so far.
7. Only then may another read/search/fetch, command, edit, build, test, or agent
   task begin.

At each durable checkpoint, preserve enough relevant synthesis to make the next
action executable:

- the current diagnosis, model, or conclusion
- the small set of relevant files, symbols, webpages, or evidence paths and why
  each matters
- the intended edit, algorithm, or decision and its rationale
- constraints and invariants the implementation must preserve
- unresolved questions that still block or could change the approach

Do not write "read files A, B, and C." Write what A, B, and C jointly establish.
Before the first implementation edit, create or refresh this implementation
brief even when no mutation has occurred yet.

The invariant is: **there may never be more than one bounded, uncheckpointed
research batch in volatile context.**

### No-Reread Test

Hide the chat history mentally and ask: can a fresh agent perform the exact next
action safely from the current `goal.md` and `handoff.md` alone? It may open a
specific referenced file at the edit location, but it must not need to repeat the
broad investigation, source comparison, or web research just completed.

If the answer is no, do not continue. Add the missing synthesis. This test is the
primary acceptance criterion for the handoff and takes precedence over brevity.

## Reconcile Instead Of Append

Apply these lifecycle rules whenever the snapshot changes:

- New evidence supersedes a hypothesis: replace the hypothesis with the current
  conclusion.
- A risk or blocker is resolved: remove it.
- The next action is completed: replace it with the new single next action.
- Multiple checks support one conclusion: retain only the strongest current
  evidence or one evidence path.
- A path, version, process ID, or system state changes: update the existing fact;
  do not preserve the obsolete value in the active snapshot.
- A rejected hypothesis matters only as a future safety warning: retain one short
  decision line explaining what not to retry. Otherwise delete it.

Deletion of obsolete information is required maintenance, not information loss.
Historical snapshots remain searchable in `archive/` when preservation matters.

## Update Timing

Reconcile `handoff.md` at meaningful state transitions, including:

- a diagnosis or decision changes
- a working model, source map, implementation rationale, or invariant changes
- a coherent research/inspection batch produces actionable understanding
- a mutation changes external or on-disk state
- a new artifact, backup, or rollback point becomes authoritative
- a blocker, risk, or uncertainty appears or is resolved
- the direct next action changes
- a milestone or task phase completes
- before compaction, handoff, pause, or exit when current state is not yet captured

The immediate persistence barrier takes precedence over this milestone list. Do
not wait for a phase transition when a relevant finding already exists only in
volatile context.

For a long-running operation, record intent before launch only when interruption
would leave ambiguous or risky state. Replace that intent with the outcome when
the operation finishes. Do not retain both as permanent history.

## Milestone Rebase

At phase changes such as research to implementation, diagnosis to
implementation, implementation to verification, or verification to user
confirmation, rebuild `handoff.md` as a fresh current snapshot:

1. Preserve the old snapshot in `archive/` only if its history may matter.
2. Re-evaluate every active fact with the Finding Classification.
3. Drop completed operations, stale evidence, resolved branches, and old next
   steps.
4. Keep only current state, active decisions, actionable working understanding,
   authoritative artifacts, unresolved risks, and the new next action.
5. Verify the new snapshot is internally consistent and within 64,000 bytes.

Do not wait for the byte limit before removing stale information.

## Scope Split

Do not turn one handoff into a product, machine, or project encyclopedia. When a
new request no longer advances the current `goal.md`, create a separate durable
task directory. Add a short cross-reference only when the tasks genuinely depend
on each other.

## Research Notes And Optional Logs

For research spanning more than one bounded batch, create
`notes/active-research.md` before the second batch. Keep only task-relevant
current material using this shape:

```markdown
# Active Research
## Current Question
## Current Findings
## Source Map
## Cursor
## Implementation Implication
```

Reconcile this note exactly like the handoff: replace superseded findings,
collapse duplicates, and delete tangents. When the successor needs source-level
support from the note, reference its exact section from the handoff in the same
checkpoint. The handoff must still contain enough synthesis to pass the
No-Reread Test; never make a successor read the entire note merely to discover
the next action.

Create detailed logs only when required for:

- high-risk repair or exact rollback
- user-requested audit history
- reproducible research or evidence chains
- long builds, migrations, or tests whose raw output may be needed later

Store raw commands and outputs in `logs/` and reference the relevant path from
the handoff. Do not move routine verbosity into logs by default.

## Bounded Archive Protocol

Use byte size because it is deterministic and cheap to check.

If `goal.md` exceeds 6,000 bytes or `handoff.md` exceeds 64,000 bytes:

1. Create `archive/` beside the active files.
2. Move the oversized file to a timestamped path such as
   `archive/handoff-20260801-210000.md`.
3. Do not read the oversized archive in full. Inspect bounded head/tail slices,
   headings, and targeted search hits for current state, working understanding,
   source map, intended change, next action, decisions, risks, backups,
   verification, and blockers.
4. Recreate the active file at its original path.
5. For `goal.md`, retain only the current objective, acceptance criteria, core
   constraints, and direction.
6. For `handoff.md`, use the required five-section shape and the Finding
   Classification.
7. State any uncertainty caused by bounded reconstruction instead of inventing
   missing facts.
8. Record the archive path only when a successor may need selective history.

Before a write that would cross a limit, rebase or archive first. Never leave an
active resume file above its limit.

## Initialization

For a qualifying task:

1. Create a durable task directory outside temporary or easily cleaned storage.
2. Create concise `goal.md` and `handoff.md` files using the roles and shape above.
3. Add one short protocol note, for example:
   `Persistence: use goal-handoff-persistence; goal <=6000 bytes; handoff <=64000 bytes.`
4. Do not create `notes/`, `logs/`, `archive/`, or other folders until they are
   needed.

## Final Verification

Before pausing, handing off, or declaring completion:

- check both byte limits
- remove stale or duplicated facts
- verify no task-relevant finding remains only in volatile context
- verify no unrelated, merely interesting, or raw material entered task memory
- run the No-Reread Test; the next action must not require repeating completed
  discovery
- confirm exactly one current next action, or state that no action remains
- classify unresolved items as confirmed issues, acceptable noise, awaiting user
  confirmation, or areas requiring explicit approval
- verify artifact and rollback paths still exist when they are important

Completion should usually make the handoff shorter. Preserve the final result,
remaining risks, rollback information, and still-actionable understanding;
remove the implementation diary.
