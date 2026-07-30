---
name: "memory-system"
description: "Generates a Knowledge OS-level white-box memory system with goal stack, attention drift protection, Source of Truth hierarchy, lifecycle governance, proactive auto-update, 3-level recall, and structured knowledge base. Invoke when user says '搭建记忆系统' / 'set up memory system', '创建记忆文件' / 'create memory file', or a project needs context anchoring. Supports both Chinese and English trigger phrases."
globs: ["**/*.md"]
version: 3.1.0
author: "custom"
---

# Reusable Layered Memory System Scaffold v3.1 (Knowledge OS)

> **Language**: English | [简体中文](./SKILL.zh-CN.md)

Built on the engineering practice of the AI workbench five-layer architecture, this scaffold automatically generates a white-box Knowledge OS (Knowledge Operating System) for any project. The AI first auto-detects the current workspace, fills in information it can infer, and marks items it cannot infer as `[TBD]`. Core principles: **Tools are replaceable, assets are not; Goal anchoring without drift; Single source of truth without contradiction; Storage serves recall; Lifecycle self-governance; Proactive update without waiting.**

## Core Understanding (AI must understand first)

The memory system is the project's Knowledge OS (Knowledge Operating System). It is not "the more stored, the better," but rather enables the AI within a single task to:

- **Anchor goals**: Always align with the Goal Stack, never deviate from the main thread
- **Prevent drift**: Maintain attention through the Checkpoint mechanism and main-thread protection
- **Single source of truth**: Resolve contradictions through the SoT (Source of Truth) hierarchy; every piece of information has an authority level
- **Lifecycle management**: Memory has states (valid/pending/deprecated); it ages, conflicts, and merges
- **Proactive evolution**: No need to wait for the user to say "update memory"; proactively propose consolidation after milestones
- **Tiered loading**: Default L1 summary → L2 fragments when needed → L3 full text for depth, with controllable token budget
- **Information denoising**: Filter noise before it enters memory — semantic/role/importance-based triage, not keyword matching
- **Task relay**: Complex tasks decompose into sub-tasks with isolated context; results pass forward, not full history
- **Active forgetting**: Time-decay and frequency-based forgetting; dormant entries don't bloat the active memory
- **Storage serves recall**: Lets the AI know "when to read what, at what granularity, and who to obey when there are contradictions"

## Trigger Conditions

**This Skill supports both Chinese and English trigger phrases.** Users can say either language (or mix) to trigger.

- User says any of:
  - **Chinese**: "搭建记忆系统", "创建记忆文件", "初始化记忆系统", "优化记忆", "重构记忆", "整理记忆", "升级记忆系统"
  - **English**: "set up memory system", "create memory file", "initialize memory system", "optimize memory", "refactor memory", "organize memory", "upgrade memory system"
- New project / empty directory lacking `memory.md` or `agent.md`
- User explicitly requests context anchoring for the current project

## Pre-checks (AI must perform first)

1. Confirm the currently open project folder path
2. Detect whether `memory.md` or `agent.md` already exists; if so, ask the user whether to overwrite and rebuild or perform an incremental upgrade
3. Confirm this is a new session or the user has told the AI "starting a new project, ignore previous memory"
4. Ask the user which layer of memory to set up (via AskUserQuestion):
   - **Project-level memory only** (recommended): Create a memory system only for the current project
   - **User-level + Project-level**: Also create cross-project universal user-level memory (agent.md + preferences.md + knowledge.md + lessons-learned.md)
   - **User-level memory only**: Only create the global user profile
5. Perform automatic project information detection

## Memory System Knowledge OS Five-Layer Architecture

```
┌─────────────────────────────────────────────────────────────────┐
│ Runtime Governance Layer                                         │
│   Goal stack anchoring · Checkpoint drift protection · Auto-update triggers │
│   Conflict detection · SoT arbitration · Three-level loading scheduling │
├─────────────────────────────────────────────────────────────────┤
│ Layer 1: Session-level Memory (automatic)                       │
│   Single conversation context + checkpoint state,               │
│   managed automatically by the agent                            │
├─────────────────────────────────────────────────────────────────┤
│ Layer 2: User-level Long-term Memory (optional, cross-project)  │
│   <user memory root>/                                            │
│   ├── agent.md              ← Global rules/persona/preferences   │
│   ├── preferences.md        ← Output preferences, language, style, interaction habits │
│   ├── knowledge.md          ← Cross-project domain knowledge, mental models │
│   └── lessons-learned.md    ← General lessons learned, anti-patterns │
├─────────────────────────────────────────────────────────────────┤
│ Layer 3: Project-level Long-term Memory (required) — with SoT authority hierarchy │
│   <project root>/                                                │
│   ├── agent.md              ← Project global rules (incl. goal alignment/checkpoints/auto-update rules) │
│   ├── memory.md             ← Memory index + navigation map + goal stack (core entry) │
│   ├── memory/               ← Specific memory files (each with metadata header + TL;DR) │
│   │   └── log.md            ← Work log                              │
│   └── context/              ← Structured knowledge base (subdirectory categories + metadata) │
│       ├── README.md         ← Corpus master index (AI auto-maintained) │
│       ├── research/         ← [create as needed] Research/survey     │
│       ├── meetings/         ← [create as needed] Meeting minutes     │
│       ├── prd/              ← [create as needed] Requirements docs   │
│       ├── courses/          ← [create as needed] Courses/learning    │
│       └── reference/        ← [create as needed] Reference docs      │
├─────────────────────────────────────────────────────────────────┤
│ Layer 4: Work Log (flexible)                                    │
│   memory/log.md (recommended) or memory/daily/ or memory/monthly/ │
│   Choose by user preference; one file per day is not enforced    │
└─────────────────────────────────────────────────────────────────┘
```

## Step 1: Automatic Project Information Detection

The AI first scans the current workspace and fills in project information by priority, never fabricating:

| Information Item | Detection Source | Confidence Assessment |
|--------|---------|-----------|
| **Project name** | ① Root folder name (strip `_YYYYMMDDHHmmss` timestamp suffix) ② `name` from `package.json`/`pyproject.toml` ③ First-line title of `README.md` | Config file = high; folder name = medium; inference = low |
| **Project type** | ① Root config files (`package.json`→Web/Node, `requirements.txt`→Python, mostly `*.md`→content creation/knowledge management, mostly code files→software product) ② File structure | Explicit tech stack = high; extension inference = medium; undeterminable = other |
| **One-line positioning** | ① First paragraph of `README.md` ② `description` from config file | Direct quote = high; summary = medium; undeterminable = `[TBD]` |
| **Long-term vision** | ① "Vision"/"Mission" sections in README ② Inferred from project description | Direct quote = high; summary = medium; undeterminable = `[TBD]` |
| **Core goal** | ① "Purpose"/"Goal" sections in README ② Summary from project description | Direct quote = high; summary = medium; undeterminable = `[TBD]` |
| **Current phase** | ① CHANGELOG/version history ② TODO/ROADMAP files ③ "Current Status" in README | Explicit record = high; inference = medium; undeterminable = `[TBD]` |
| **Target users/audience** | ① Relevant sections in README ② Inference | Direct quote = high; inference = medium; undeterminable = `[TBD]` |
| **Tech stack** | ① Config file dependencies ② Code extensions ③ README tech stack section | Explicit dependencies = high; extensions = medium; non-software = N/A |
| **Key constraints** | ① README/CONTRIBUTING/spec files ② Project structure inference | Explicitly stated = high; initial = `[TBD]` |
| **Existing materials** | Scan root directory for large amounts of existing docs (docs/, articles/, reference materials/, etc.) | Used to determine whether initialization guidance is needed |

**Detection rules:**
- Fill in when inferrable; mark as `[TBD]` when not
- For empty directories, only create the skeleton
- After detection, output a results table (value, source, confidence); **do not wait for user reply, continue creating**

## Step 2: Create Directory Structure

### 2.1 Project-level Memory (required)

```
<project root>/
├── agent.md                     ← Project global rules file (incl. goal alignment/checkpoints/auto-update rules)
├── memory.md                    ← Memory index + navigation map + goal stack + SoT hierarchy (core entry)
├── memory/                      ← Specific memory files (each with metadata header + TL;DR)
│   └── log.md                   ← Work log (or daily/ monthly/, see Step 3.5)
└── context/                     ← Structured knowledge base directory
    └── README.md                ← Corpus master index (AI auto-maintained)
```

Note: The 5 subdirectories under `context/` (research/ meetings/ prd/ courses/ reference/) are created as needed. Initially only create `context/README.md`; create subdirectories when first placing corresponding materials.

### 2.2 User-level Memory (if user selects)

```
<user memory root>/
├── agent.md                     ← Global rules/persona (cross-project universal)
├── preferences.md               ← Output preferences, language, style, interaction habits
├── knowledge.md                 ← Cross-project domain knowledge, mental models
└── lessons-learned.md           ← General lessons learned, anti-patterns
```

**Key: The classification of specific files under memory/ must not be hardcoded.** The AI automatically determines file partitioning based on project type; see Step 3.3 for the reference framework.

## Step 3: Create Files One by One

### 3.1 `agent.md` (Global Rules File)

This file is as important as `memory.md`. Every time the user sends a message, the agent injects both `agent.md` and `memory.md` as context into the large model.

`agent.md` must contain the following six sections:

```markdown
# Agent Global Rules

## Role
You are the AI assistant for [project name]. [One-line role positioning].

## Goal Alignment Rules (must check before each reply)
1. Each time you receive a substantive task request, first check alignment against the "Goal Stack" in `memory.md`
2. Alignment assessment:
   - **Aligned** (directly advances current task) → execute normally
   - **Weak deviation** (serves phase goal but not current task) → before executing, remind: "This differs from current task [X], but falls within phase goal [Y]. Continue?"
   - **Strong deviation** (unrelated to phase goal / violates hard constraints) → pause and prompt: "This appears inconsistent with current phase goal [X]. Do you want to: (a) switch to a new goal (b) note it as a todo and continue current task (c) cancel"
3. Goal stack updates require explicit user confirmation ("update goal", "this phase is done", "move to next phase", etc.); AI must not modify on its own
4. Weak deviations that are still useful should be recorded in "todo side-track" (listed in Checkpoint); after the main task is complete, remind the user

## Checkpoint and Attention Protection Rules
1. **Checkpoint trigger timing**:
   - Every 3 substantive steps completed (file creation/content generation/analysis complete, etc.)
   - Conversation rounds exceed 10
   - Switching from one subtask to another
   - User expresses confusion or repeats questions
   - AI detects degradation of its own context quality (repeating itself/omitting key information)
2. **Checkpoint format**:
   ```
   [Checkpoint]
   - Current goal: [take current task from goal stack]
   - Completed: [brief progress]
   - In progress: [what is currently being done]
   - Constraints: [active hard constraints/notes]
   - Todo side-track: [recorded non-main-thread tasks, or "none"]
   - Next step: [what to do next]
   ```
3. **Main-thread protection**:
   - User inserts a new request during execution: urgent and quick (completable within 1 minute) → handle immediately and return; not urgent → record in todo side-track and continue main thread
   - User says "do X first" → switch main thread, record old main thread in todo side-track
4. **Context reconstruction**:
   - Detection signals: AI starts repeating itself, omits previously discussed key information, user corrects 2+ times in a row, replies become generic
   - Suggested phrasing: "Current session context may be saturated. Suggest opening a new session. I will generate a handover summary for the new session."
   - Handover summary format: **Current goal** + **Completed** + **In progress** + **Todo side-track** + **Key constraints** + **List of memory files to load**
5. When handing over to a new session, AI automatically generates the above handover summary for the user to paste into the new session

## Auto-Update Rules (no need to wait for "update memory")
1. **Proactive proposal after milestones** (auto-execute after one round without objection):
   - Trigger: completing a milestone (task complete/decision made/file delivered/important analysis finished)
   - Output format: `[Memory Update Proposal] I plan to record [brief content] in [target file]. Reason: [why it's worth recording]. Will record automatically if no objection.`
   - Execution: user does not object in next round → write; user objects → do not write or adjust content
2. **Instant auto-recording** (write directly without waiting for proposal):
   - AI makes a mistake and is corrected by user → immediately write to lessons learned (pending state, note trigger condition)
   - AI chooses among multiple options → write to decision log (pending state, note alternatives)
   - New hard constraint/rule discovered → write to corresponding file (pending state, mark for confirmation)
3. **Index real-time maintenance**: When new files are added under memory/ or context/, immediately update the index table in `memory.md` and `context/README.md`
4. **Cases not auto-recorded**: pure discussion/chitchat, user explicitly says "don't record", temporary information (e.g., "check the weather for me")
5. **Update scope control**: Each auto-update only appends entries; it does not modify/delete existing entries (unless user explicitly requests); auto-updated content defaults to pending state

## Information Denoising Rules (pre-memory filtering)
1. **Before any information enters memory, it must pass a denoising filter:**
   - Semantic check: Is this a fact/decision/lesson, or an emotional expression/repeated query/filler word?
   - Role check: Is this from the user, AI inference, or external reference?
   - Importance score: 1-5; anything below 3 is not written to memory
   - Deduplication: Is it highly similar to an existing memory entry? If so, merge instead of append
2. **Noise categories (auto-filtered, never written):**
   - Repeated questions already answered in the current session
   - Emotional expressions with no factual content ("that's annoying", "great")
   - Filler phrases and verbal tics
   - Temporary contextual info (e.g., "check the weather")
3. **Do not use keyword matching for denoising** — keyword matching causes false positives (e.g., filtering "status" in "check my order status"). Use semantic understanding.

## Task Relay Rules (complex task decomposition)
1. **When a task is too complex for a single context window, decompose into sub-tasks:**
   - Each sub-task gets its own context scope (only loads relevant memory files, not full history)
   - Results are written to `memory/` as deliverables, not passed as raw conversation
   - The next sub-task reads the deliverable, not the previous conversation
2. **Task Relay Table** (maintained in `memory.md`):
   - Tracks: sub-task name, responsible agent, context scope, status, deliverable, next handler
   - Updated in real time as sub-tasks progress
3. **Error isolation:** If a sub-task fails, only that sub-task rolls back; other sub-tasks are unaffected
4. **Context handover format:** Deliverable summary + key constraints + files to load (not full conversation history)

## Global Rules
1. At the start of each conversation, first read `memory.md`
2. Loading follows the L1→L2→L3 three-level escalation rules (see "Three-level Loading Rules" in `memory.md`)
3. On information conflict, strictly arbitrate according to the SoT authority hierarchy (see "Source of Truth Hierarchy" in `memory.md`)
4. Storage serves recall: memory files should be concise and structured for quick positioning next time
5. Uncertain information should be marked as `[TBD]` or set to pending state; do not fabricate
6. [Other project-specific rules, filled by AI based on project detection results]

## Hard Constraints
- [TBD: fill in initial constraints based on project detection results]

## Memory Recall Rules (Navigation Map Usage Instructions)
- The navigation map, recall presets, and three-level loading rules are defined in `memory.md`
- At the start of each task → read `memory.md` (L3 full text)
- Determine the initial file set to load from the "Task type → recall preset" table
- Load progressively by L1 (TL;DR) → L2 (relevant sections) → L3 (full text)
- When information is insufficient, search via the SoT downgrade routing chain: L0→L1→L2→L3→L4→L5→L6→ask user
```

### 3.2 `memory.md` (Memory Index + Knowledge OS Core Entry)

This is the core entry of the memory system. **It must contain navigation/recall logic and runtime governance data**, not just a file list.

```markdown
# [project name] · Memory Index

> **TL;DR**: This file is the core entry of the project's Knowledge OS. AI must read the full text at the start of every conversation (this file is not long, L3 load).
> Contains: goal stack, SoT authority hierarchy, navigation map, recall presets, three-level loading rules, memory file index, lifecycle state.

---

## Metadata

| Property | Value |
|------|-----|
| Last updated | YYYY-MM-DD |
| Memory system version | v3.0 (Knowledge OS) |
| Authority level | L1 (project background/index layer) |
| Scope | Project global |

## Project Overview

| Project | Information |
|------|------|
| Project name | [detected value] |
| Project type | [detected value] |
| One-line positioning | [detected value / TBD] |
| Current version | v1.0 |

## Goal Stack

**AI must check whether the current task aligns with the goal stack before each reply. When deviating, must point out and confirm.**

| Level | Goal | Status | Updated date |
|------|------|------|---------|
| Long-term vision (North Star) | [what the project ultimately wants to achieve / TBD] | valid | YYYY-MM-DD |
| Quarterly goal | [core goal for the current quarter / TBD] | valid | YYYY-MM-DD |
| Phase goal | [current milestone goal / TBD] | valid | YYYY-MM-DD |
| Current task | [what is being done / TBD] | valid | YYYY-MM-DD |

**Goal stack usage rules:**
- Pre-reply check: Is the current request advancing the "Current task"?
- Deviation handling: Deviating from "Current task" but serving "Phase goal" → yellow reminder; deviating from "Phase goal" → red warning requiring confirmation
- Update rules: Long-term vision rarely changes; quarterly goals set at the start of the quarter; phase goals updated after milestone completion; current task updated in real time as work progresses
- Goal updates require explicit user confirmation; AI must not modify the goal stack on its own

## Source of Truth Hierarchy

**When information in different memory files conflicts, arbitrate by the following authority levels from highest to lowest. Higher levels override lower levels.**

| Level | Authority source | Description | Corresponding file |
|------|--------|------|---------|
| L0 | Hard constraints | Red lines that cannot be violated; highest authority | `memory/02_hard_constraints.md` |
| L1 | Project background and goals | Vision, positioning, target users, core goals, goal stack | `memory/01_project_background.md` + this file's goal stack |
| L2 | Decision log | Confirmed decisions and reasons; higher than experience | `memory/06_decisions_log.md` |
| L3 | Lessons learned | Pitfall records, best practices | `memory/07_lessons_learned.md` |
| L4 | Workflows/specs | Processes, naming, formats, platform strategies | `memory/03_workflow_rules.md`, `memory/04_*.md`, `memory/05_*.md` |
| L5 | Logs/version history | Time-series records, for reference only | `memory/08_version_history.md`, `memory/log.md` |
| L6 | Context corpus | Original reference materials; lowest authority | all files under `context/` |

**Arbitration rules:**
1. Higher-level valid information always overrides lower-level valid information
2. Same-level valid information conflict → the one with the more recent last_updated prevails (check metadata)
3. Same level and same date → mark conflict, ask user to arbitrate
4. Pending information does not override valid information (reference only, not as authoritative basis)
5. Deprecated information does not participate in arbitration
6. User-level memory does not participate in project-level SoT arbitration (project rules take precedence over personal preferences)

## Navigation Map (Enhanced)

| Priority | Scenario/Trigger | File to read | Load level | Recall preset tag |
|--------|--------------|---------|---------|-------------|
| P0 | At the start of every task (must read) | `memory.md` (this file) | L3 (full text) | all |
| P0 | Before content generation/code writing/doc writing | Hard constraints file | L2 (relevant sections) | create |
| P1 | Understanding what the project is/who it's for/why | Project background file | L2 (core sections) | understand |
| P1 | Making decisions/modifying existing plans | Decision log | L2 (relevant entries) | decide |
| P1 | Avoiding repeated mistakes/pre-execution check | Lessons learned file | L2 (relevant entries) | execute |
| P2 | Involving workflows/processes/triggers | Workflow rules file | L2 (relevant sections) | create |
| P2 | Creating files/naming/formatting | Engineering specs file | L2 (relevant sections) | create |
| P2 | Platform-related tasks | Platform strategy file | L2 (relevant sections) | distribute |
| P2 | Understanding version evolution/history | Version history | L1 (latest entries) | understand |
| P3 | Consulting reference materials/books/docs | `context/README.md` → corpus file | L1→on-demand L2/L3 | research |
| P3 | Reviewing recent work | Log file | L1 (recent entries) | review |

**Recall iron rules:**
1. Not all files are read every time; load on demand by priority and recall preset
2. Default L1 (TL;DR), upgrade to L2/L3 as needed
3. When encountering a new type of problem, first scan the TL;DR of all memory files, then decide which to read in depth
4. When information is insufficient, downgrade via SoT routing: L0→L1→L2→L3→L4→L5→L6→ask user

## Task Type → Recall Preset

| Task type | Initial files to load (L1) | Escalation trigger |
|---------|-------------------|-------------|
| Content creation (writing articles/videos/code) | Hard constraints + project background + workflow specs + relevant lessons learned | At decision point → L2 decision log; need reference → L2/L3 corpus |
| Decision (choosing options/changing direction) | Hard constraints + project background + relevant decision log + relevant lessons learned | Need specific data → L3 corpus |
| Debugging/fixing (debug/rework) | Hard constraints + relevant lessons learned + relevant decision log | Complex problem → L3 full text of relevant files |
| Research/learning (survey/reading) | context/ relevant corpus index + project background | Deep reading → L2/L3 corpus full text |
| Planning (plans/roadmaps) | Goal stack + project background + decision log + lessons learned | Need constraint details → L2 hard constraints/specs |
| Daily communication (Q&A/discussion) | Goal stack + project background (all L1) | Need specific info → L2 corresponding file |

## Three-Level Loading Rules

| Level | Content | Token budget (reference) | Trigger |
|------|------|-------------------|---------|
| L1 (summary) | TL;DR block at the top of the file (2-3 sentences, ≤5 lines) | Total ≤500 tokens (sum of all L1 blocks) | Default load level; first read of any memory file |
| L2 (fragment) | Full content of relevant sections/entries | ≤2000 tokens (sum of all L2 fragments) | L1 indicates the file is directly relevant to the current task; task tag matches recall preset |
| L3 (full text) | Complete content of the entire file | ≤4000 tokens (single file) | Need exact wording/resolve contradictions/deep execution/L2 insufficient |

**Escalation rules:**
- L1→L2: When the L1 TL;DR indicates the file content is directly relevant to the current task, or task tags match the file's recall preset tags
- L2→L3: When exact quotation of the original text is needed, contradictions found in L2 need to be resolved, or deep implementation tasks need to be executed
- Token budgets are guide values, not hard limits; AI adjusts flexibly based on current model capability and context usage
- Under high context pressure, prioritize retaining L2 of P0/P1 files and downgrade low-priority files to L1

## Memory File Index

### Core (P0/P1 priority)

| File | Content | SoT level | Status |
|------|------|---------|------|
| [e.g., `memory/01_project_background.md`] | Project positioning, target users, core goals, values, no-go zones | L1 | valid |
| [e.g., `memory/02_hard_constraints.md`] | Red-line rules that cannot be violated | L0 | valid |

### Rules (P2 priority)

| File | Content | SoT level | Status |
|------|------|---------|------|
| [e.g., `memory/03_workflow_rules.md`] | Workflow rules/processes/triggers | L4 | valid/pending |
| [e.g., `memory/04_engineering_specs.md`] | Naming rules/format specs | L4 | valid/pending |
| [e.g., `memory/05_platform_strategy.md`] | Platform strategy (omit if none) | L4 | valid/pending |

### Experience (P1/P2 priority)

| File | Content | SoT level | Status |
|------|------|---------|------|
| [e.g., `memory/06_decision_log.md`] | Decision records (why choose A over B) | L2 | valid |
| [e.g., `memory/07_lessons_learned.md`] | Pitfall records/best practices | L3 | valid |

### Dynamic (AI auto-maintained)

| File | Content | SoT level | Status |
|------|------|---------|------|
| [e.g., `memory/08_version_history.md`] | Version change log | L5 | valid |
| [e.g., `memory/log.md`] | Work log | L5 | valid |

## Context Corpus

A large amount of reference material is stored in the structured subdirectories of the `context/` directory:
- `context/research/` — Research/surveys/competitive analysis (create as needed)
- `context/meetings/` — Meeting minutes/discussion records (create as needed)
- `context/prd/` — Requirements docs/feature specs (create as needed)
- `context/courses/` — Course notes/learning materials (create as needed)
- `context/reference/` — Reference docs/manuals/specs (create as needed)

See `context/README.md` for the corpus index. Memory files only retain the corpus navigation entry; do not copy full content. Corpus files are SoT L6 (lowest authority), for reference only, and do not override higher-level memory information.

## Directory Structure Quick Reference

[Filled by AI based on the actual file structure created]

## Task Relay Table (for complex multi-step tasks)

> When a task is too complex for a single context window, decompose into sub-tasks. Each sub-task has isolated context and passes deliverables forward.

| Sub-task | Responsible Agent | Context Scope | Status | Deliverable | Next Handler |
|----------|------------------|---------------|--------|-------------|-------------|
| (none yet) | | | | | |

**Relay rules:**
- Status: pending / in-progress / completed / failed
- Deliverable: file path in `memory/` (not raw conversation)
- Next handler reads the deliverable file, not the previous conversation history
- On failure, only the failed sub-task rolls back

## Active Forgetting Rules

> Memory that is never forgotten becomes noise. Active forgetting keeps the active memory lean.

1. **Time decay**: Entries not referenced for 30 days → marked as `dormant` (excluded from recall, but kept in file)
2. **Frequency decay**: `pending` entries with 0 references after 14 days → auto-transition to `deprecated`
3. **Capacity threshold**: Single file exceeds 300 lines → trigger deep restructure (not just dedup, but reorganize structure)
4. **Conflict elimination**: Low-SoT entries overridden by higher-SoT entries → auto-mark as `deprecated`
5. **Dormant entries**:
   - Not loaded during recall (skip in navigation map)
   - Kept in file under a `## Dormant` section
   - User can reactivate via "recall" command
6. **Monthly forgetting report**: On the 1st of each month, AI outputs a summary of what was forgotten/dormant, with option to restore

## Memory Lifecycle Rules

1. **Mandatory metadata header**: Each memory file must begin with "TL;DR + metadata table"; metadata includes last_updated / authority_level (SoT level) / scope / status
2. **State management**:
   - `valid`: Confirmed, currently effective information
   - `pending`: Newly written/to-be-confirmed information (initial state of auto-recorded decisions/corrections); transitions to valid after user confirmation or no objection in subsequent references
   - `deprecated`: Deprecated/replaced information; once marked, not deleted; moved to the "Archive" section at the end of the file; does not participate in arbitration
3. **Conflict detection**:
   - Before writing new information, scan the target file's TL;DR and section headings to check for duplication or contradiction with existing content
   - If contradictory: (a) higher-level is valid → do not override, explain conflict to user; (b) higher-level is deprecated → can write; (c) same level → mark conflict for arbitration
4. **Deduplication/merging**: When any memory file exceeds 200 lines, the AI **must** (not a suggestion):
   - Identify and merge duplicate/redundant entries
   - Extract TL;DRs for long entries
   - Move deprecated entries to the archive section
   - After completion, update metadata last_updated
5. **Pending → valid transition**:
   - User explicitly confirms ("yes", "correct", "remember this") → transition to valid
   - AI references the information in the next related task without user objection → can transition to valid
   - Pending exceeds 7 days without confirmation or reference → AI reminds user to confirm in Checkpoint
6. **Decisions must record the reason**: Important decisions must record "why choose A over B" and the alternatives considered
7. **Pitfalls must be recorded**: Errors/rework/user corrections must be written to lessons learned immediately (pending state), noting trigger conditions
8. **Expiration exit**: Invalid rules/deprecated decisions are marked deprecated and moved to the archive section; do not accumulate in the active area

## Memory Maintenance and Auto-Update Rules

1. **Proactive update proposal**: After milestone completion, AI proactively outputs `[Memory Update Proposal]`; auto-writes after one round without objection
2. **Instant auto-recording**: Mistake corrected/decision made/constraint discovered → write directly to corresponding file in pending state
3. **Index real-time maintenance**: Update this index and `context/README.md` immediately when new files are created
4. **User-initiated update**: When user says "update memory" or "update", AI consolidates recent unrecorded work
5. **Periodic cleanup**: AI proactively performs lifecycle maintenance at: file exceeding 200 lines, bloat detected at new session start, user saying "organize memory"
6. **User override right**: User may modify/delete/merge any memory file at any time; AI must not prevent this

## White-Box Principles

- Tools (IDE/large model/agent plugin) can be replaced at any time
- Assets (memory system + context corpus) are irreplaceable; they are the core value
- Memory files are stored in user-controlled directories, not bound to tool default paths
- No reliance on tool-specific personalization mechanisms, ensuring assets can be directly migrated when switching tools
- All metadata, states, and rules are expressed in pure Markdown, with no proprietary formats
```

### 3.3 Specific Memory Files under `memory/`

**All files under memory/ must follow the unified template.** The AI determines file partitioning and naming based on project type, but each file must contain the following structure:

#### Unified File Template

```markdown
# [number]_[file_name]

> **TL;DR**: [2-3 sentences summarizing the most important information in this file. No more than 5 lines. This is all that is seen during L1 loading.]

## Metadata

| Property | Value |
|------|-----|
| Last updated | YYYY-MM-DD |
| SoT level | L0/L1/L2/L3/L4/L5 |
| Scope | [project global / specific domain / specific task] |
| Status | valid (overall status; entry-level markings below) |

---

## [Core Content Area]

[File body content, organized by topic into sections]

### [Entry example format]

- **[Entry name]** (valid/pending/deprecated, YYYY-MM-DD): [specific content]

---

## Archive (Deprecated)

[The following are deprecated entries, kept for historical reference, not participating in SoT arbitration]

- ~~[deprecated entry]~~ (deprecated, YYYY-MM-DD, reason: [what replaced it / why deprecated])
```

#### File Naming Rules

- Use numeric prefixes to control sorting: `01_`, `02_`, `03_`...
- Core (P0 files) use 01-02
- Rules use 03-05
- Experience uses 06-07
- Dynamic uses 08+
- English snake_case or Chinese naming are both acceptable, but must be consistent within the same project

#### Recommended Classification Framework (AI may add/remove by project)

| Recommended file | SoT level | Applicable project types | Initial TL;DR |
|---------|---------|------------|-----------|
| 01_project_background | L1 | All projects | Project positioning, target users, core goals, values, no-go zones |
| 02_hard_constraints | L0 | All projects | Red-line rules (initial may be "to be refined") |
| 03_workflow_rules | L4 | Content creation/product development | Processes, confirmation points, triggers (initial may be "TBD") |
| 04_engineering_specs | L4 | Software development/content creation | Naming rules, format specs (initial may be "TBD") |
| 05_platform_strategy | L4 | Multi-platform distribution/operations | Platform list, publishing strategy (omit if none) |
| 06_decision_log | L2 | All projects | Important decisions and reasons, alternatives |
| 07_lessons_learned | L3 | All projects | Pitfall records, best practices |
| 08_version_history | L5 | All projects | Version change log |

#### Entry Format Requirements

- **Decision log entries** must include: date, decision content, reason/background, alternatives considered (not chosen), impact scope
- **Lessons learned entries** must include: date, problem/error description, root cause, solution/preventive measures, **trigger condition** (in what scenario this lesson should be consulted)
- Each entry independently marks status (valid/pending/deprecated) and date, not just the file's overall status

#### Key Principles

- The number of files is determined by project complexity; simple projects may merge files
- **Do not force creating a fixed number of files**; enough is enough
- For files with insufficient information in the initial stage, write "to be refined" in TL;DR, mark metadata as valid (empty file), and wait for subsequent filling
- When merging files, take the highest SoT level (e.g., merging L2 and L3 files, mark overall as L2, but distinguish sources in content)

### 3.4 `context/` Structured Knowledge Base

The context/ directory is used to store Markdown-converted files of reference materials, books, articles, and documents. v3.0 uses a subdirectory classification structure.

#### Directory Structure

```
context/
├── README.md          ← Corpus master index (AI auto-maintained)
├── research/          ← [create as needed] Market research, competitive analysis, industry reports
├── meetings/          ← [create as needed] Meeting minutes, discussion records, interview records
├── prd/               ← [create as needed] Product requirement docs, feature specs, design docs
├── courses/           ← [create as needed] Course notes, book summaries, learning materials
└── reference/         ← [create as needed] Reference manuals, spec docs, API docs
```

- Subdirectories are created when first needed; do not force creating all 5 initially
- If a category of materials is empty, the corresponding subdirectory need not be created
- AI automatically judges which subdirectory to place materials in based on their nature

#### Unified Corpus File Template

Each MD file placed in context/ must follow this template:

```markdown
# [Material title]

> **Summary**: [AI-generated 2-3 sentence structured summary, including core viewpoints/key data/conclusions. Read this part during L1 loading.]

## Metadata

| Property | Value |
|------|-----|
| Source | [URL/book title/meeting title/file name] |
| Date | YYYY-MM-DD (material publication date or acquisition date) |
| Tags | [tag1, tag2, tag3] |
| Confidence | high / medium / low |
| Category | research / meetings / prd / courses / reference |
| Last indexed | YYYY-MM-DD (date AI updated the index) |

---

## Key Points

[AI-generated structured key points, in key points form, for quick information retrieval during L2 loading]

- [Key point 1]
- [Key point 2]
- [Key point 3]
...

---

## Full Text

[Complete content: original conversion/notes/records, etc.]
```

#### `context/README.md` Corpus Index Template

```markdown
# Context Knowledge Base

This directory stores project-related reference materials, uniformly converted to Markdown format and organized by category into subdirectories.

## Difference from Memory System
- **Memory (memory/)**: Refined rules, decisions, experiences; injected per task on demand; SoT L0-L5
- **Corpus (context/)**: Original reference material full text and structured summaries; retrieved only when needed; SoT L6 (lowest authority, does not override rules and decisions in memory)

## Corpus Index

[AI auto-maintained, updated in real time when new files are added]

### research/ (Research/Survey)

| File | Tags | Confidence | Summary | Date |
|------|------|--------|------|------|
| (none yet) | | | | |

### meetings/ (Meetings/Discussions)

| File | Tags | Confidence | Summary | Date |
|------|------|--------|------|------|
| (none yet) | | | | |

### prd/ (Requirements/Specs)

| File | Tags | Confidence | Summary | Date |
|------|------|--------|------|------|
| (none yet) | | | | |

### courses/ (Courses/Learning)

| File | Tags | Confidence | Summary | Date |
|------|------|--------|------|------|
| (none yet) | | | | |

### reference/ (Reference/Manuals)

| File | Tags | Confidence | Summary | Date |
|------|------|--------|------|------|
| (none yet) | | | | |

## Usage
1. Parse and convert materials such as PPT/Word/PDF/books/web pages into MD files and place them in the corresponding subdirectory
2. Files must include a metadata table and AI-generated summary (following the template)
3. AI automatically updates this index when adding files
4. On recall, first read this index (L1), judge relevance by summary, then read specific file's key points (L2) or full text (L3)
5. For large amounts of existing materials, schedule a one-time full scan initialization by AI when tokens are ample (e.g., overnight unattended)
```

### 3.5 Work Log (Flexible Configuration)

AI asks the user about log preference (or recommends based on usage habits):
- **Single log file** (recommended, simple): `memory/log.md`, append-write
- **By day**: `memory/daily/YYYY-MM-DD.md`
- **By month**: `memory/monthly/YYYY-MM.md`
- **No separate log**: Record directly in version history

**Do not force one file per day.** Everyone's usage habits differ; comfort is the priority.

Initial log content:

```markdown
# Work Log

> **TL;DR**: Records key progress, decisions, and to-dos from each work session. Appended in reverse chronological order.

## Metadata

| Property | Value |
|------|-----|
| Last updated | YYYY-MM-DD |
| SoT level | L5 |
| Scope | Project global |
| Status | valid |

---

## YYYY-MM-DD
- Initialized memory system v3.0 (Knowledge OS)
- [subsequent work records]

---

## Archive

(none yet)
```

### 3.6 User-level Memory Files (if user chooses to create)

User-level memory is stored in a cross-project universal location and shared across all projects. All user-level memory files follow the same metadata + TL;DR template specification as project-level.

**Key decision**: The SoT level of user-level memory is valid within the user's space and **does not participate in project-level SoT arbitration**. Project rules (L0-L5) always take precedence over personal preferences.

**`agent.md` (Global Rules)**: Cross-project universal AI rules, persona. The content structure is a simplified version of the project-level agent.md, focusing on global rules (language preferences, output style, general interaction rules) rather than project-specific rules.

**`preferences.md` (User Preferences)**:

```markdown
# User Preferences

> **TL;DR**: [2-3 sentences summarizing the user's most core preferences. Initially TBD.]

## Metadata

| Property | Value |
|------|-----|
| Last updated | YYYY-MM-DD |
| Scope | Cross-project global |
| Status | valid |

---

## Language and Output
- Output language: [Chinese/English/bilingual / TBD]
- Level of detail: [concise/detailed/adjusted on demand / TBD]
- Format preference: [Markdown/plain text/other / TBD]

## Interaction Style
- [TBD: e.g., prefers conclusion first then expansion / prefers thinking while outputting, etc.]

## Tools and Environment
- Commonly used tools: [TBD]
- Operating system/environment: [TBD]

## Dislikes/No-Go Zones
- [TBD: things the user does not want AI to do]
```

**`knowledge.md` (Cross-project Knowledge)**:

```markdown
# User Domain Knowledge

> **TL;DR**: [2-3 sentences summarizing the user's core knowledge domains and expertise. Initially TBD.]

## Metadata

| Property | Value |
|------|-----|
| Last updated | YYYY-MM-DD |
| Scope | Cross-project global |
| Status | valid |

---

## Professional Domains
- [Domain 1]: [proficiency/key knowledge/common frameworks / TBD]
- [Domain 2]: [...]

## Mental Models and Methodologies
- [TBD: commonly used mental models/analytical frameworks/decision-making methods]

## Known Concepts (no explanation needed)
- [TBD: list concepts and terms the user is already very familiar with and that AI does not need to explain from scratch]
```

**`lessons-learned.md` (General Lessons Learned)**:

```markdown
# General Lessons Learned

> **TL;DR**: [2-3 sentences summarizing the most important cross-project lessons. Initially TBD.]

## Metadata

| Property | Value |
|------|-----|
| Last updated | YYYY-MM-DD |
| Scope | Cross-project global |
| Status | valid |

---

## General Anti-patterns
- [TBD: common mistakes/anti-patterns across projects]

## General Best Practices
- [TBD: working methods/principles validated across projects]

---

## Archive

(none yet)
```

## Step 4: Existing Materials Initialization Guidance

If the AI detects that the project already has a large amount of documentation (docs/, articles, reference materials, etc.), proactively provide initialization suggestions in the report:

```
## Existing Materials Initialization Suggestions

Detected that this project has existing documentation. Suggest having AI perform a one-time full initialization when tokens are ample (e.g., overnight unattended):

1. Tell the AI: "Scan all project documents and initialize the memory system and corpus"
2. AI will read all historical documents, extract key information, and write it to memory files (including metadata and TL;DR)
3. Convert reference materials to MD format and store them by type in the corresponding subdirectories of `context/` (research/meetings/prd/courses/reference/)
4. Add a metadata table (source/date/tags/confidence/category) and AI-generated summary to each corpus file
5. Update `context/README.md` corpus master index
6. Update the memory file index in `memory.md`
7. Assist in setting up the initial goal stack (long-term vision and current phase)
```

## Step 5: Completion Report

After creation, report to the user:
1. Detection results summary table (including target information)
2. List of created files and classification logic (why this division)
3. List of fields marked as `[TBD]`
4. Initial state of the goal stack (which levels need user input)
5. **Auto-update mechanism explanation**: AI will proactively propose recording after milestones, immediately record lessons when making mistakes, no need to say "update memory" every time
6. **Checkpoint mechanism explanation**: AI will periodically output progress checkpoints during long tasks to prevent deviation
7. **SoT authority hierarchy explanation**: Arbitration rules for information conflicts
8. **Anti-drift reminder**: AI will proactively remind when deviating from goals
9. Anti-pollution reminder: Open a new session for different tasks/projects
10. If there are existing materials, provide initialization suggestions (including context/ subdirectory classification guidance)
11. `memory.md` navigation map + goal stack preview

## Step 6: Knowledge OS Runtime Mechanism (AI Execution Guide)

This section is an execution reference for the AI and is not directly generated into user files. The AI must follow these runtime mechanisms when using the memory system.

### 6.1 Goal Anchoring Execution Flow

1. Each time a user message is received, internally execute:
   a. Read the goal stack in `memory.md`
   b. Assess the alignment of the current request with the goal stack:
      - Aligned (directly advances current task) → execute normally
      - Weak deviation (serves phase goal but not current task) → output yellow reminder before execution
      - Strong deviation (unrelated to phase goal / violates hard constraints) → pause, give three options (switch/note side-track/cancel)
2. Goal stack update:
   - Update when user explicitly says "update goal", "this is done", "move to next phase"
   - AI must not modify the goal stack on its own
   - After update, record in `memory.md` and update last_updated
3. Side-track management:
   - Weak deviations that are useful are recorded in "todo side-track" (listed in Checkpoint)
   - After main-thread task is complete, AI proactively reminds about side-track to-dos

### 6.2 Checkpoint and Attention Protection Execution Flow

1. **Checkpoint output timing**:
   - Every 3 substantive operation steps completed
   - Conversation rounds exceed 10
   - Switching from one subtask to another
   - User expresses confusion or repeats questions
   - AI detects degradation in its own reply quality
2. **Checkpoint format**: Strictly follow the format defined in `agent.md`; concise, not verbose
3. **Main-thread protection**:
   - User inserts new request → urgent and quick → handle immediately and return; not urgent → note in side-track and continue main thread
   - User says "do X first" → switch main thread, note old main thread in side-track
4. **Context reconstruction**:
   - Detection signals: AI repeating itself, omitting key information, user correcting 2 times in a row, replies becoming generic
   - Suggested phrasing: "Current session context may be saturated. Suggest opening a new session. I will generate a handover summary."
   - Handover summary must include: current goal + completed + in progress + todo side-track + key constraints + list of memory files to load

### 6.3 SoT Arbitration Execution Flow

1. When reading multiple memory files and discovering contradictory information:
   a. Check the SoT level of each entry (from file metadata and entry status)
   b. Higher-level valid entry > lower-level valid entry
   c. Same-level valid entries: the one with the more recent last_updated prevails
   d. Pending entries do not override valid entries
   e. Deprecated entries do not participate in arbitration
   f. Cannot arbitrate → inform user of the conflict and ask for arbitration
2. When user explicitly says "take X as authoritative", user instruction temporarily takes precedence over SoT (but does not automatically modify the SoT level in memory files, unless user requests an update)
3. When user-level memory conflicts with project-level memory, project-level prevails

### 6.4 Memory Lifecycle Governance Execution Flow

1. **Pre-write check**:
   - Check whether the target file exists and its current line count
   - Scan the target file's TL;DR and section headings to check for duplication or contradiction with existing content
   - Contradiction → execute SoT arbitration flow
   - Duplication → merge rather than append
2. **On write**:
   - Automatically add entry status (auto-recorded initial state is pending; explicitly user-confirmed is valid)
   - Add date mark
   - Update file metadata last_updated
3. **Post-write check**:
   - If file exceeds 200 lines → immediately execute deduplication/merging/archiving
   - Update the metadata status in the `memory.md` index
4. **Pending → valid transition**:
   - User explicitly confirms → transition to valid
   - No objection in subsequent references → can transition to valid
   - Pending exceeds 7 days → remind user to confirm in Checkpoint
5. **Deprecated marking**:
   - New information replaces old information → mark old entry as deprecated and note the replacement
   - User explicitly says no longer needed → mark as deprecated
   - Deprecated entries are moved to the file's "Archive" section at the end

### 6.5 Auto-Update Trigger Execution Flow

1. **Proactive update proposal (wait one round)**:
   - Trigger: milestone completed
   - Output format strictly: `[Memory Update Proposal] I plan to record [brief content] in [target file]. Reason: [reason]. Will record automatically if no objection.`
   - User does not object in next round → write; user objects → do not write or adjust
2. **Instant auto-recording (no wait)**:
   - AI makes a mistake and is corrected → immediately write to lessons learned (pending, note trigger condition)
   - AI makes a decision with alternatives → write to decision log (pending, note alternatives)
   - New constraint discovered → write to corresponding file (pending)
   - New file created → immediately update index
3. **Not auto-recorded**: pure discussion/chitchat, user says "don't record", temporary information
4. **Update scope**: Append only, no deletion/modification (unless user explicitly requests); default pending state

### 6.6 Three-Level Loading Execution Flow

1. **At session start**:
   - L3 load `memory.md` (full text, because it is the index)
   - Determine the initial file set to load from the "Task type → recall preset" table based on task type
   - L1 load the TL;DR of the initial file set
2. **During task execution**:
   - First read of any memory file → L1 (TL;DR + metadata)
   - Relevance judgment → if relevant, escalate to L2; if not, skip
   - When L2 reading, only read sections/entries relevant to the current task
   - Need exact wording/conflict discovered/deep execution → escalate to L3
3. **Token budget management**:
   - Internally estimate loaded token count
   - L1 total ≤500 tokens, L2 total ≤2000 tokens (reference values)
   - When approaching context limit, prioritize retaining L2 of P0/P1 files; downgrade low-priority to L1
4. **Loading downgrade**:
   - On task switch, previously loaded L2/L3 can be downgraded (no longer a key reference)
   - Under high context pressure, proactively downgrade low-priority files from L2 to L1

### 6.7 Information Denoising Execution Flow

1. **Before writing any information to memory, execute denoising filter:**
   a. Semantic classification: Is this a fact, decision, lesson, constraint, or noise?
   b. Role classification: User-stated / AI-inferred / external-reference
   c. Importance scoring: 1-5 scale (1 = trivial, 5 = critical)
   d. Deduplication: Scan target file TL;DR and headings for similarity
2. **Filtering results:**
   - Importance ≥ 3 and not duplicate → write to memory (pending state)
   - Importance < 3 → discard silently
   - Duplicate → merge with existing entry
   - Emotional/filler/repeated → discard silently
3. **Do NOT use keyword matching for denoising.** Use semantic understanding to avoid false positives (e.g., "status" in "check order status" is not noise)
4. **Denoising log:** When discarding, briefly note what was filtered and why (in Checkpoint, not in memory files)

### 6.8 Task Relay Execution Flow

1. **Trigger:** When a task is assessed as too complex for a single context window (est. >50 conversation rounds or multi-domain)
2. **Decomposition:**
   a. Break the task into sub-tasks with clear boundaries
   b. For each sub-task, define: context scope (which memory files to load), expected deliverable, and next handler
   c. Write the decomposition to the Task Relay Table in `memory.md`
3. **Execution:**
   a. Each sub-task starts with a fresh context: load only its defined scope + previous deliverables
   b. On completion, write the deliverable to `memory/` as a file (not as conversation)
   c. Update the Task Relay Table: mark as completed, fill in deliverable path
   d. Next sub-task reads the deliverable file, not the previous conversation
4. **Error handling:**
   - Sub-task fails → mark as failed in Relay Table, do not cascade to other sub-tasks
   - User can retry the failed sub-task independently
5. **Context handover format:** Deliverable summary + key constraints + list of memory files to load

### 6.9 Active Forgetting Execution Flow

1. **Trigger conditions (checked at session start and at Checkpoint):**
   a. Time decay: Any entry not referenced in the last 30 days → mark as `dormant`
   b. Frequency decay: `pending` entries with 0 references after 14 days → auto-transition to `deprecated`
   c. Capacity: Any file exceeding 300 lines → trigger deep restructure
   d. Conflict elimination: Lower-SoT entries overridden by higher-SoT → auto-deprecate the lower one
2. **Dormant handling:**
   - Move dormant entries to a `## Dormant` section at the end of the file
   - Exclude from recall (skip in navigation map)
   - Keep in file (do not delete)
3. **Deep restructure (300+ lines):**
   - Not just deduplication — reorganize the entire file structure
   - Merge related sections, extract new TL;DRs, archive deprecated entries
   - Target: reduce to ≤200 lines in the active area
4. **Monthly forgetting report:**
   - On the 1st of each month (or at first session of the month), AI outputs:
     ```
     [Forgetting Report]
     - Dormant entries: [count] (list file + entry names)
     - Auto-deprecated: [count] (list with reason)
     - Deep restructured: [file names]
     - To restore: say "recall [entry name]"
     ```
   - User can restore any dormant entry by saying "recall [entry name]"

## Memory System Iron Rules (Knowledge OS v3.0)

1. **`memory.md` is the entry**: AI reads memory.md first at the start of every conversation (L3 full text)
2. **Goal stack is the compass**: Check goal alignment before each reply; remind on deviation
3. **Checkpoint prevents drift**: Long tasks must periodically output progress checkpoints
4. **SoT resolves conflicts**: Information conflicts arbitrated by L0→L6 authority levels; higher levels override lower
5. **Storage serves recall**: Memory is about finding the right information in the right scenario, not hoarding information
6. **Three-level loading saves tokens**: Default L1 summary, L2 fragments when needed, L3 full text for depth
7. **Navigation map is more important than file list**: Tell AI "when to read what, to what level"
8. **Metadata is infrastructure**: Each file must have TL;DR + metadata table (last_updated/SoT level/scope/status)
9. **Memory has a lifecycle**: Three-state management (valid/pending/deprecated); 200 lines mandates dedup/merge
10. **Decisions must record reasons**: Recording "what was done" without "why" is equivalent to not recording
11. **Auto-update without waiting**: Proactively propose recording after milestones; immediately record lessons on mistakes; immediately update index on new files
12. **Lessons learned are pre-execution checklists**: Scan relevant lessons before executing each step
13. **AI auto-classifies**: User defines top-level framework; specific classification delegated to AI
14. **No fabrication principle**: Information that cannot be detected is marked `[TBD]`; auto-recorded initial state is pending
15. **White-box + anti-pollution**: Assets stored in user-controlled directories; pure MD, no binding; no cross-pollution
16. **Denoise before store**: All information passes semantic/role/importance filter before entering memory; keyword matching is prohibited
17. **Relay for complex tasks**: Tasks exceeding single-context capacity decompose into sub-tasks with isolated context and deliverable-based handover
18. **Forget to stay lean**: Time-decay (30d dormant) and frequency-decay (14d deprecate) keep active memory lean; monthly forgetting report keeps user informed

## Anti-Pollution Rules

- Generated files must not contain any old project names or private information outside the current project
- **Information blacklist**: The following private information must not appear in generated content (unless within the current project's own memory system):
  - Other historical project names (any of the user's past project names)
  - Personal account information (specific UIDs, specific follower counts, specific revenue data)
  - Personal identity information (real names, phone numbers, emails, addresses)
  - Keys/tokens/passwords and other sensitive information
- Must not reference specific data, accounts, or platform strategies from other projects
- This Skill is a universal scaffold; all content must fit the target project itself
- Memory directories of different projects are physically isolated; no cross-referencing
- When auto-updating records, information from other projects/sessions must not be written to the current project
- When AI generates memory content, if it identifies information that may belong to another project, it must exclude it

## Risk Notice and Disclaimer

- **Accuracy self-verification**: The memory files, project information detection results, auto-recorded decisions and lessons, etc., generated by this Skill are all inferred or executed by AI based on the current workspace, and may contain deviations or errors. Before using them as a basis for important decisions, users **must verify accuracy themselves**. AI makes no express or implied warranty regarding the correctness, completeness, or applicability of the generated content.
- **Third-party service terms**: If users invoke any third-party APIs, model services, or platform interfaces (such as large model APIs, cloud storage, automation tools, etc.) during the operation of this memory system, **they must comply with the corresponding service's terms of use, rate limits, data compliance, and privacy policies**. This Skill itself does not depend on any third-party API, but users may introduce third-party dependencies when using the generated artifacts; relevant compliance responsibilities are borne by the user.
- **Sensitive operation boundaries**: AI must not perform sensitive operations requiring human judgment on behalf of the user (such as official publishing, external sending, payment, signing, deleting production data, etc.). "To-dos" and "decisions" recorded in the memory system are for reference only and do not constitute execution authorization.
- **Data localization responsibility**: All memory files are generated locally on the user's machine; this Skill does not provide cloud synchronization, backup, or encryption capabilities. Users must plan their own backup strategies; this Skill is not liable for data loss caused by local disk failures, accidental deletion, or accidental modification.
