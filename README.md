# memory-system-scaffold v3.0 (Knowledge OS)

**Language**: English | [简体中文](./README.zh-CN.md)

An AI Skill that automatically generates a white-box Knowledge OS (Knowledge Operating System)-level layered memory system for any project. Based on the engineering practice of AI workbench five-layer architecture, compatible with all mainstream AI workbenches that support local Skill mechanisms, including TRAE, Cursor, Codex, WorkBuddy, Claude Code. Provides goal anchoring, attention drift protection, Source of Truth arbitration, lifecycle governance, proactive auto-update, 3-level recall, and structured knowledge base.

> **About language versions**: This repo installs the English version of `SKILL.md` by default (loaded by AI). If you prefer AI to use Chinese rules, copy `SKILL.zh-CN.md` and rename it to `SKILL.md` after installation.

---

## 🚀 30-Second Quick Start

### Option A: One-click Install Script (Recommended)

After cloning the repo, run the install script from the repo root:

```bash
# macOS / Linux
./install.sh

# Windows PowerShell
.\install.ps1
```

The script lists all supported AI workbenches (TRAE / Cursor / Codex / Claude Code / WorkBuddy), interactively selects the tool and install mode (project-level / global), and automatically copies required files to the corresponding path.

Parameter mode is also supported:

```bash
./install.sh --tool trae              # install to current project's TRAE
./install.sh --tool cursor --global   # global install to Cursor
./install.sh --help                   # show help
```

### Option B: Manual Copy (No Script Environment)

Copy `SKILL.md` and `README.md` from the `memory-system-scaffold/` folder to the target tool's Skill directory:

- TRAE: `.trae/skills/memory-system-scaffold/`
- Cursor: `.cursor/skills/memory-system-scaffold/`
- Codex: `.codex/skills/memory-system-scaffold/`
- Claude Code: project root (place directly)
- WorkBuddy: `skills/memory-system-scaffold/`

### Trigger Setup

Regardless of the install method, after installation:

Say in AI conversation: `"搭建记忆系统"` ("set up memory system")

The AI will automatically detect project info, ask a few simple questions, and generate all files in 1-2 minutes.

---

## Core Design Philosophy

1. **White-Box Management**: Assets are stored in user-controlled directories, not bound to tool default paths. Tools (IDE/model/agent) can be replaced at any time.
2. **Goal Anchoring, No Drift**: Goal stack (long-term → quarterly → phase → current task) + Checkpoint mechanism prevents AI from deviating in long tasks.
3. **Single Source of Truth, No Contradiction**: SoT (Source of Truth) L0-L6 authority hierarchy automatically arbitrates information conflicts.
4. **Storage Serves Recall**: Memory is not "the more the better". The core is the "navigation map" — telling AI when to read what, at what granularity.
5. **3-Level Loading Saves Tokens**: Default L1 (TL;DR summary) → L2 (relevant fragments) when needed → L3 (full text) for deep tasks.
6. **Lifecycle Self-Governance**: Memory has states (valid/pending/deprecated), ages, conflicts, merges. Forced deduplication at 200 lines.
7. **Proactive Update, No Waiting**: Actively proposes recording after milestones, records lessons immediately on errors, updates index immediately on new files.
8. **AI Auto-Classification**: User defines top-level framework, specific file classification, naming, and content organization are delegated to AI.
9. **Memory vs Corpus Separation**: Refined rules go in `memory/`, large reference materials go in `context/` (structured subdirectories). Memory only keeps entry points.
10. **Zero-Config Out-of-the-Box**: Project info is auto-detected and filled by AI. Undetectable items are marked `[TBD]`.

## v3.0 Top 10 New Features (vs v2.0)

1. **Goal Stack**: Long-term vision → quarterly goal → phase goal → current task, four-layer decomposition. AI auto-checks alignment before each reply, proactively reminds on deviation.
2. **Checkpoint Attention Protection**: Auto-outputs progress checkpoints every 3 steps / 10 rounds in long tasks (goal / completed / in-progress / constraints / side-tracks / next step). Proactively suggests new session + handoff summary when quality drops.
3. **SoT Source of Truth Hierarchy**: L0 hard constraints → L1 project background → L2 decisions → L3 lessons → L4 specs → L5 logs → L6 corpus. 7-level authority auto-arbitrates conflicts.
4. **Memory Lifecycle Governance**: valid/pending/deprecated three-state management, conflict detection, 200-line forced dedup/merge, pending 7-day confirmation reminder, archive area.
5. **Proactive Auto-Update**: `[Memory Update Proposal]` after milestones, waits one round for confirmation; immediate pending write on errors/decisions/new constraints; immediate index maintenance.
6. **3-Level Loading System**: L1 (TL;DR ≤500 tokens) / L2 (relevant fragments ≤2000 tokens) / L3 (full text ≤4000 tokens), with explicit upgrade triggers and token budgets.
7. **Enhanced Navigation Map**: Added priority column (P0-P3) and recall preset tags; 6 task-type → recall preset mappings; SoT degradation routing chain.
8. **Structured Knowledge Base**: `context/` divided into 5 subdirectories (research/meetings/prd/courses/reference). Each corpus file enforces metadata + AI summary + key points extraction. Index auto-maintained.
9. **User-Level Memory Extension**: preferences.md (preferences) / knowledge.md (cross-project knowledge) / lessons-learned.md (general lessons).
10. **Unified File Template**: All memory files enforce TL;DR + metadata table (last_updated / SoT level / scope / status) + status markers + archive area.

## Generated File Structure

### Project-Level Memory (Required)

```
<project root>/
├── agent.md                     ← Project global rules (goal alignment / Checkpoint / auto-update / recall rules)
├── memory.md                    ← Knowledge OS core entry (goal stack + SoT + navigation map + recall presets + 3-level loading + lifecycle)
├── memory/                      ← Specific memory files (each with TL;DR + metadata + status markers)
│   └── log.md                   ← Work log (or daily/ monthly/, by habit)
└── context/                     ← Structured knowledge base
    ├── README.md                ← Corpus master index (AI auto-maintained)
    ├── research/                ← [on-demand] Research / investigation / competitors
    ├── meetings/                ← [on-demand] Meeting notes
    ├── prd/                     ← [on-demand] Requirements docs
    ├── courses/                 ← [on-demand] Courses / learning materials
    └── reference/               ← [on-demand] Reference docs
```

### User-Level Memory (Optional, Cross-Project)

```
<user memory root>/
├── agent.md                     ← Global rules / persona
├── preferences.md               ← Output preferences, language, style, interaction habits
├── knowledge.md                 ← Cross-project domain knowledge, mental models, known concepts
└── lessons-learned.md           ← General lessons learned, anti-patterns
```

## How to Use

### Trigger Phrases

**This Skill supports both Chinese and English.** Say any of the following in conversation to trigger (Chinese and English phrases are equivalent — pick whichever language you're comfortable with):

| Chinese | English | Purpose |
|---------|---------|---------|
| `"搭建记忆系统"` | `"set up memory system"` | Initial setup |
| `"创建记忆文件"` | `"create memory file"` | Initial setup |
| `"初始化记忆系统"` | `"initialize memory system"` | Initial setup |
| `"优化记忆"` | `"optimize memory"` | Refinement |
| `"重构记忆"` | `"refactor memory"` | Refinement |
| `"整理记忆"` | `"organize memory"` | Cleanup |
| `"升级记忆系统"` | `"upgrade memory system"` | Upgrade |

You can also mix languages (e.g., start with Chinese `"搭建记忆系统"` and later use English `"optimize memory"`). The AI treats them as the same intent.

### Initialization

After triggering, the AI will:
1. Automatically detect current workspace project info (name / type / positioning / goals / tech stack, etc.)
2. Ask which memory layer to build (project-level / user-level + project-level / user-level only)
3. Output detection result table
4. Automatically create all files (without waiting for user confirmation)
5. Report creation results, TBD fields, goal stack status, auto-update / Checkpoint / SoT mechanism explanation

### Daily Usage

After generation, your project has a complete Knowledge OS. Here are the most common daily operations (Chinese and English trigger phrases both work):

| What you want | Chinese phrase | English phrase | What AI does |
|---------------|----------------|----------------|--------------|
| **Update goal** | `"更新目标"` / `"这个阶段完成了"` / `"进入下一阶段"` | `"update goal"` / `"this phase is done"` / `"enter next phase"` | Updates corresponding level in goal stack, records change history |
| **Manually update memory** | `"更新记忆"` / `"更新一下"` | `"update memory"` | Sediments recent unrecorded work into corresponding memory files |
| **Organize memory** | `"整理记忆"` / `"清理记忆"` | `"organize memory"` / `"clean memory"` | Deduplicates / merges redundant entries, marks deprecated, refines summaries |
| **Import existing materials** | `"扫描项目所有文档，初始化记忆系统和语料库"` | `"scan all project docs, initialize memory system and corpus"` | Full scan of historical docs, extracts info into memory + corpus |
| **Check progress** | (no need to say, auto-triggered) | (no need to say, auto-triggered) | Auto-outputs Checkpoint every 3 steps / 10 rounds in long tasks |

**Things that happen automatically (you don't need to say):**

- ✅ After milestone completion, AI proactively says `[Memory Update Proposal] ...`, auto-records after your confirmation
- ✅ When AI makes a mistake and you correct it, auto-writes to lessons learned (pending state)
- ✅ When making important decisions, auto-writes to decision log (pending state)
- ✅ Auto-outputs Checkpoint in long tasks to prevent drift
- ✅ Detects context saturation, proactively suggests new session and generates handoff summary
- ✅ Memory files exceeding 200 lines auto-trigger dedup / merge / archive

### Global Install (For All Projects)

If you want all projects to use this Skill, place the folder in the corresponding AI tool's global Skill directory:

- **TRAE**: `~/.trae-cn/builtin/global/skills/`
- **Cursor**: `~/.cursor/skills/`
- **Other tools**: refer to the corresponding tool's global Skill configuration docs

### ❓ FAQ

**Q: I already have some files in my project. Will this Skill overwrite them?**
A: No. Before generating, the Skill checks whether `memory.md` or `agent.md` already exists. If so, it asks whether to overwrite and rebuild or incrementally upgrade.

**Q: Can I generate only some files? E.g., I only want the memory system, not the knowledge base.**
A: Yes. You can tell the AI your needs when triggering, and the AI will generate on demand. Or after generation, you can delete directories you don't need (like `context/`).

**Q: What if generation goes wrong? Can I redo it?**
A: Yes. Just say "重新生成" ("regenerate") or delete the generated files and trigger again. All files are pure Markdown with no hidden state.

**Q: Does this Skill cost money? Any usage limits?**
A: Completely free and open source. You can modify, distribute, and use it for commercial or non-commercial purposes freely. The only limit: don't use it for illegal activities.

**Q: Which AI tools does it support?**
A: Any AI workbench that supports local Skill mechanisms, including TRAE, Cursor, Codex, WorkBuddy, Claude Code, etc. Pure Markdown format, not bound to any tool.

**Q: My project content is sensitive. Will this Skill transmit my data anywhere?**
A: No. All files are generated in your local project directory. The Skill itself contains no network requests or data upload functionality. Your data stays 100% on your own machine.

**Q: What does "pending" status mean? Do I need to manually change it?**
A: pending means "to be confirmed". Content auto-recorded by AI (such as errors, decisions) defaults to pending. When you explicitly say "对" ("yes") / "是的" ("yes") / "记住这个" ("remember this"), it auto-converts to valid. You don't need to manually change it.

**Q: Too many files generated. Can I simplify?**
A: Yes. There are only 3 core files: `agent.md` (rules), `memory.md` (index + navigation), and specific memory files under `memory/`. `context/` (knowledge base) and user-level memory are all optional — delete them if not needed.

## Privacy

This Skill is a generic scaffold and **contains no project-private information**:
- No specific accounts, platform data, or business cases
- No hardcoded project names or personal information
- All content is auto-detected and generated based on the target project
- Generation follows anti-pollution rules, with a built-in information blacklist (prohibiting other project names, personal accounts, identity info, keys, etc.)
- White-box design, all files are directly viewable and editable by users
- Pure Markdown format, no proprietary format lock-in

## Risk Disclaimer

- **Accuracy Self-Verification**: Memory files, project info detection results, auto-recorded decisions and lessons, etc. generated by this Skill are all inferred or executed by AI based on the current workspace, and may contain biases or errors. Before using them as a basis for important decisions, users **must verify accuracy themselves**. This Skill makes no express or implied warranty regarding the correctness, completeness, or suitability of the generated content.
- **Third-Party Service Terms**: If users invoke any third-party APIs, model services, or platform interfaces (such as LLM APIs, cloud storage, automation tools, etc.) during the operation of the memory system, they **must comply with the corresponding service terms, rate limits, data compliance, and privacy policies**. This Skill itself does not depend on any third-party API, but users may introduce third-party dependencies when using the generated artifacts. The corresponding compliance responsibility is borne by the user.
- **Sensitive Operation Boundary**: AI must not perform sensitive operations requiring human judgment on behalf of the user (such as official publishing, outbound sending, payment, signing, deleting production data, etc.). "Todos" and "decisions" recorded in the memory system are for reference only and do not constitute execution authorization.
- **Data Localization Responsibility**: All memory files are generated locally. This Skill does not provide cloud sync, backup, or encryption capabilities. Users must plan their own backup strategies. This Skill is not liable for data loss caused by local disk failure, accidental deletion, or accidental modification.

## Knowledge OS v3.0 Iron Rules (Auto-written into generated memory.md)

1. `memory.md` is the entry: AI reads memory.md first in every conversation (L3 full text)
2. Goal stack is the compass: check goal alignment before each reply, must remind on deviation
3. Checkpoint prevents drift: long tasks must periodically output progress checkpoints
4. SoT resolves conflicts: information conflicts arbitrated by L0→L6 authority hierarchy
5. Storage serves recall: memory is for finding the right info in the right scenario, not for hoarding
6. 3-level loading saves tokens: default L1 summary, upgrade to L2/L3 on demand
7. Navigation map is more important than file list: tells AI "when to read what, to what level"
8. Metadata is infrastructure: every file must have TL;DR + metadata table
9. Memory has lifecycle: valid/pending/deprecated three states, 200-line forced dedup
10. Decisions must record reasons: recording only the result without the why is equivalent to not recording
11. Auto-update doesn't wait: proactively proposes at milestones, records immediately on errors, maintains index immediately
12. Lessons learned are pre-execution checklist: scan relevant lessons before executing each step
13. AI auto-classifies: user defines top-level framework, specific classification delegated to AI
14. No fabrication principle: undetectable info marked `[TBD]`, auto-recorded items start as pending
15. White-box + anti-pollution: assets are self-controlled, pure MD with no binding, no cross-pollution

## Version History

### v3.0.0 — Knowledge OS Upgrade
- **Goal Stack**: Four-layer goal decomposition and auto-alignment check
- **Checkpoint Attention Protection**: Progress checkpoints + mainline protection + context rebuild + handoff summary
- **SoT Source of Truth Hierarchy**: L0-L6 seven-level authority + auto conflict arbitration
- **Lifecycle Governance**: Three-state management / conflict detection / 200-line dedup / pending confirmation / archive
- **Proactive Auto-Update**: Milestone proposals / immediate recording / immediate index maintenance
- **3-Level Loading**: L1/L2/L3 + token budget + upgrade triggers
- **Enhanced Navigation Map**: Priority column + recall presets + degradation routing chain
- **Structured Knowledge Base**: context/ five subdirectories + metadata + AI summary + auto-index
- **User-Level Extension**: preferences.md / knowledge.md / lessons-learned.md
- **Unified Template**: TL;DR + metadata table + status markers + archive area

### v2.0.0 — White-Box Layered Memory
- Four-layer memory architecture (session / user / project / log)
- agent.md + memory.md dual entry
- AI auto-classifies memory files
- Basic navigation map
- memory/ and context/ separation
- "Update memory" trigger phrase

### v1.0.0 — Initial Version
- Basic memory file structure
- Project info auto-detection
- 8 fixed memory files
