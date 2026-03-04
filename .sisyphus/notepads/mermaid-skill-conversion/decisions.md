
## [2026-03-04] Architecture: Split diagram-type-guide.md into per-type files

**Decision**: The existing `references/diagram-type-guide.md` (combined 260-line file) will be split into:
- `references/diagram-type-guide.md` — kept as the **index only**: decision matrix, layout optimization section, excluded types list
- 9 individual files: `references/types/flowchart.md`, `sequence.md`, `state.md`, `class.md`, `c4.md`, `mindmap.md`, `timeline.md`, `er-diagram.md`, `sankey.md`

**Rationale**: Each type file loads independently in the agent's context window. The agent only loads the specific type it needs — preserving context for diagram content rather than reference boilerplate.

**SKILL.md impact**: The "choose diagram type" step should instruct the agent to:
1. Consult `references/diagram-type-guide.md` (decision matrix) to pick a type
2. Then load the specific `references/types/<type>.md` file for full syntax reference

**Content in existing diagram-type-guide.md**: Already has good per-type sections — extract each into its own file, keep the index lean.
