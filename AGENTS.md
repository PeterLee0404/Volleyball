# AGENTS.md - Volleyball Jump & Explosive Power LLM Wiki

This repository is a **domain-specialized athletic knowledge base** focusing on **Volleyball Vertical Jump Biomechanics, Stretch-Shortening Cycle (SSC) Kinetics, and Match-Long Power Endurance**.

- **Obsidian**: The IDE & visual graph navigator.
- **LLM Agent**: The compiler, synthesizer, and graph maintainer.
- **Raw PDFs (`raw/`)**: Immutable scientific literature source of truth.
- **Wiki (`wiki/`)**: Compounding markdown knowledge codebase.

---

## 1. Domain Scope: Volleyball Explosive Performance

Every page in this wiki must relate to one or more of these core pillars:
1. **Morphological Foundations**: Muscle architecture (ACSA, Fascicle Length, Pennation Angle) of vastus lateralis, gastrocnemius, hamstrings, and gluteals.
2. **SSC Neuromechanics**: Short-SSC (<188ms: Block jumps, reactive bounds) vs Long-SSC (≥222ms: Spike approach attacks, depth jumps, countermovement jumps).
3. **Kinetic Chain & Trunk Dynamics**: Core stability as a force transmitter (anti-rotation, landing kinematics, valgus prevention).
4. **Bioenergetics & Jump Endurance**: ATP-PCr resynthesis, repeated sprint ability (RSA), and fast-twitch buffering during 200–400 match jumps.
5. **Ergogenic Modulators**: Caffeine, creatine, beta-alanine, nitrates, and redox-balanced recovery.

---

## 2. Directory Structure

```text
.
├── AGENTS.md                 # Compiler specifications and domain taxonomy
├── tools/                    # CLI tooling (linting, graph auditing)
│   └── lint_wiki.py          # Python audit script for broken links & frontmatter
├── raw/                      # IMMUTABLE raw papers, PDFs, notes
└── wiki/                     # LLM-MAINTAINED knowledge graph
    ├── INDEX.md              # Global index with Dataview queries
    ├── LOG.md                # Chronological audit trail
    ├── concepts/             # Physiological & biomechanical mechanisms
    ├── protocols/            # Concrete, actionable training programs
    ├── substances/           # Supplements & ergogenic aids
    ├── entities/             # Researchers, institutions, coaches
    ├── contradictions/       # Scientific debates & context conflicts
    └── synthesis/            # High-level frameworks & periodized blueprints
```

---

## 3. Strict Frontmatter Schema

Every markdown file in `wiki/` must start with:

```yaml
---
title: "Page Title"
category: concepts | protocols | substances | entities | contradictions | synthesis
tags:
  - sport/volleyball
  - ssc/long-ssc # or ssc/short-ssc
  - target/jump-height # or target/jump-endurance
evidence_tier: Tier-1 | Tier-2 | Tier-3 | Mixed
target_adaptations: [Vertical Jump, RFD, Fascicle Length]
last_updated: YYYY-MM-DD
sources:
  - "[[raw/filename.pdf]]"
---
```

### Evidence Tiers
- **Tier-1**: Systematic reviews, meta-analyses, and RCTs on competitive/trained volleyball athletes.
- **Tier-2**: Cross-sectional biomechanical studies (force plates, 3D motion capture, ultrasound), acute markers, or untrained subjects.
- **Tier-3**: High-level coach heuristics and elite athlete observations.
- **Mixed**: Conflicting scientific evidence.

---

## 4. Operational Workflows

### Command: `Ingest raw/<paper.pdf>`
1. **PDF Information Extraction**:
   - Sample profile: Sex, training age, competitive level (collegiate, national, elite).
   - Biomechanical & Physiological metrics: Effect sizes ($g$, $d$), correlation coefficients ($r$), regression models ($R^2$), $p$-values.
   - Specific jump modalities tested: Attack Jump (AJ), CMJ, Squat Jump (SJ), Drop Jump (DJ).
2. **Cross-Referencing & Compiling**:
   - Check existing wiki pages. Update existing concepts instead of creating duplicates.
   - Flag contradictions (e.g., if a new paper claims high leg stiffness improves approach jumps, link to `[[leg-stiffness-short-vs-long-ssc.md]]`).
3. **Update Index & Log**:
   - Add new/modified pages to `wiki/INDEX.md`.
   - Append standardized log entry to `wiki/LOG.md`:
     `## [YYYY-MM-DD] ingest | <Title> -> created/updated: [[page1]], [[page2]]`

### Command: `Query <Question>`
1. Read `wiki/INDEX.md` first to identify target nodes.
2. Formulate answers referencing existing wiki wikilinks `[[filename]]`.
3. If the query produces a novel, high-value training plan or cross-topic synthesis, save it to `wiki/synthesis/<slug>.md` and link it in the index.

### Command: `Lint`
Run `python tools/lint_wiki.py` to identify orphan pages, missing Wikilink targets, and frontmatter syntax errors.
