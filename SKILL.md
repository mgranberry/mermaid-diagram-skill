---
name: mermaid-diagram
description: Create Mermaid diagram files that make visual arguments. Use when the user wants to visualize workflows, architectures, or concepts.
---

# Mermaid Diagram Creator

Generate `.mmd` files (or fenced ` ```mermaid ` blocks in `.md` files when embedding in docs).

## Reference Files (load as needed)

| File | Load when... |
|------|-------------|
| `references/types/<type>.md` | After choosing diagram type (Step 5). Full syntax, examples, layout tips, line-break rules, and pitfalls for that type. |
| `references/syntax-pitfalls.md` | Render fails or you need to debug syntax. Covers quoting rules, `<br>` compatibility matrix (Section 9), reserved words, and common errors. |
| `references/mermaid-theme.md` | Applying `classDef` semantic styling or customizing colors. Contains the recipe table (trigger, success, error, ai, decision) and per-diagram-type support notes. |
| `references/mermaidConfig.json` | Changing global Mermaid renderer settings (theme variables, font size, etc.). |
| `references/render_mermaid.sh` | The render script. Invoked via bash, not read. See Render & Validate below. |
| `references/diagram-type-guide.md` | Layout optimization deep-dive (Part 3: line-crossing reduction strategies). Consult when layout is poor after initial render. |
| `references/examples/` | Validated `.mmd` examples (`architecture.mmd`, `sequence-api.mmd`). Review for inspiration or to verify your syntax against known-good patterns. |

## Customization

To customize brand styles, edit `references/mermaid-theme.md` and `references/mermaidConfig.json`. These are the single touchpoints. Do not hardcode colors in diagrams unless specifically requested; prefer sourcing values from a per-project configuration.

---

## Core Philosophy

**Diagrams should ARGUE, not DISPLAY.**

A diagram isn't formatted text. It's a visual argument that shows relationships, causality, and flow that words alone can't express. The shape should BE the meaning.

**The Isomorphism Test**: If you removed all text, would the structure alone communicate the concept? If not, redesign.

**The Education Test**: Could someone learn something concrete from this diagram, or does it just label boxes? A good diagram teaches—it shows actual formats, real event names, concrete examples.

---

## Depth Assessment (Do This First)

Before designing, determine what level of detail this diagram needs:

### Simple/Conceptual Diagrams
Use abstract shapes when:
- Explaining a mental model or philosophy
- The audience doesn't need technical specifics
- The concept IS the abstraction (e.g., "separation of concerns")

### Comprehensive/Technical Diagrams
Use concrete examples when:
- Diagramming a real system, protocol, or architecture
- The diagram will be used to teach or explain (e.g., YouTube video)
- The audience needs to understand what things actually look like
- You're showing how multiple technologies integrate

**For technical diagrams, you MUST include evidence artifacts** (see below).

### Audience Density Guide

Match diagram density to the audience and purpose:

| Audience | Node Count | Detail Level | Example |
|----------|-----------|--------------|---------|
| Executive / overview | 5–7 | High-level boxes, no attributes | "Client → API → Database" |
| Technical documentation | 10–15 | Subgraphs, edge labels, evidence artifacts | Architecture with service names + endpoints |
| Deep reference | 15–20, then split | Full attributes, Notes, companion files | Split into Context → Container → Component |

When the same system needs multiple audiences, create separate diagrams — not one diagram that tries to serve everyone.

---

## Research Mandate (For Technical Diagrams)

**Before drawing anything technical, research the actual specifications.**

If you're diagramming a protocol, API, or framework:
1. Look up the actual JSON/data formats
2. Find the real event names, method names, or API endpoints
3. Understand how the pieces actually connect
4. Use real terminology, not generic placeholders

Bad: "Protocol" → "Frontend"
Good: "AG-UI streams events (RUN_STARTED, STATE_DELTA, A2UI_UPDATE)" → "CopilotKit renders via createA2UIMessageRenderer()"

**Research makes diagrams accurate AND educational.**

---

## Evidence Artifacts

Evidence artifacts are concrete examples that prove your diagram is accurate and help viewers learn. Include them in technical diagrams.

**Techniques** (syntax details are in each type-specific reference):
- **Notes** (sequence diagrams) for data payloads and message formats.
- **Multi-line node labels** using `<br>` for concise inline evidence.
- **Subgraph titles** to label regions.
- **Companion .md files** for large payloads or code snippets that won't fit in node text.

The key principle: **show what things actually look like**, not just what they're called.

---

## Multi-Zoom Architecture

Comprehensive diagrams operate at multiple zoom levels simultaneously. Think of it like a map that shows both the country borders AND the street names.

### Level 1: Summary Flow
A simplified overview showing the full pipeline or process at a glance. Often placed at the top or bottom of the diagram.

*Example*: `Input → Processing → Output` or `Client → Server → Database`

### Level 2: Section Boundaries
Labeled regions that group related components. These create visual "rooms" that help viewers understand what belongs together.

*Example*: Grouping by responsibility (Backend / Frontend), by phase (Setup / Execution / Cleanup), or by team (User / System / External)

### Level 3: Detail Inside Sections
Evidence artifacts, code snippets, and concrete examples within each section. This is where the educational value lives.

*Example*: Inside a "Backend" section, you might show the actual API response format, not just a box labeled "API Response"

**For comprehensive diagrams, aim to include all three levels.** The summary gives context, the sections organize, and the details teach.

### Bad vs Good

| Bad (Displaying) | Good (Arguing) |
|------------------|----------------|
| 5 equal boxes with labels | Each concept has a shape that mirrors its behavior |
| Card grid layout | Visual structure matches conceptual structure |
| Icons decorating text | Shapes that ARE the meaning |
| Same container for everything | Distinct visual vocabulary per concept |

### Simple vs Comprehensive (Know Which You Need)

| Simple Diagram | Comprehensive Diagram |
|----------------|----------------------|
| Generic labels: "Input" → "Process" → "Output" | Specific: shows what the input/output actually looks like |
| Named boxes: "API", "Database", "Client" | Named boxes + examples of actual requests/responses |
| "Events" or "Messages" label | Timeline with real event/message names from the spec |
| "UI" or "Dashboard" rectangle | Mockup showing actual UI elements and content |
| ~30 seconds to explain | ~2-3 minutes of teaching content |
| Viewer learns the structure | Viewer learns the structure AND the details |

**Simple diagrams** are fine for abstract concepts, quick overviews, or when the audience already knows the details. **Comprehensive diagrams** are needed for technical architectures, tutorials, educational content, or when you want the diagram itself to teach.

---

## Design Process

### Step 0: Assess Depth Required
Before anything else, determine if this needs to be:
- **Simple/Conceptual**: Abstract shapes, labels, relationships (mental models, philosophies)
- **Comprehensive/Technical**: Concrete examples, code snippets, real data (systems, architectures, tutorials)

**If comprehensive**: Do research first. Look up actual specs, formats, event names, APIs.

### Step 1: Understand Deeply
Read the content. For each concept, ask:
- What does this concept **DO**? (not what IS it)
- What relationships exist between concepts?
- What's the core transformation or flow?
- **What would someone need to SEE to understand this?** (not just read about)

### Step 2: Map Concepts to Patterns
For each concept, find the visual pattern that mirrors its behavior:

| If the concept... | Use this pattern |
|-------------------|------------------|
| Spawns multiple outputs | **Fan-out** (single node, multiple outgoing edges) |
| Combines inputs into one | **Convergence** (multiple nodes into one target) |
| Has hierarchy/nesting | **Tree** (mindmap or subgraph nesting) |
| Is a sequence of steps | **Timeline** (timeline diagram or sequence diagram) |
| Loops or improves continuously | **Spiral/Cycle** (state self-transitions or back-edges) |
| Transforms input to output | **Assembly line** (flowchart pipeline) |
| Compares two things | **Side-by-side** (parallel subgraphs) |
| Separates into phases | **Gap/Break** (subgraph boundaries) |

### Step 3: Ensure Variety
For multi-concept diagrams: **each major concept must use a different visual pattern**. No uniform cards or grids.

### Step 4: Sketch the Flow
Before writing syntax, mentally trace how the eye moves through the diagram. There should be a clear visual story.

### Step 5: Generate Mermaid Syntax
1. Choose diagram type using the Decision Matrix below, then load the per-type reference: open `references/types/<chosen-type>.md` for full syntax.
2. Write the syntax — start with a `%%` comment block naming the diagram type and describing each section.
3. Use meaningful node IDs (not `A`, `B`, `C` — use `authService`, `dbWrite`, `userInput`).
4. Add `classDef` for semantic styling (trigger, success, error, ai, decision) — pull from `references/mermaid-theme.md`.

### Step 6: Render & Validate
Run the render script and validate the output. See the **Render & Validate** section below.

---

## Diagram Type Decision Matrix

Quick lookup: match the visual pattern you need to the best diagram type, then open its reference file.

| Visual Pattern | Best Diagram Type | Reference |
|----------------|-------------------|-----------|
| Fan-out (one-to-many) | Flowchart | `references/types/flowchart.md` |
| Convergence (many-to-one) | Flowchart | `references/types/flowchart.md` |
| Sequence of steps / interactions | Sequence Diagram | `references/types/sequence.md` |
| Hierarchy / tree | Mindmap | `references/types/mindmap.md` |
| State machine / lifecycle | State Diagram | `references/types/state.md` |
| Object structure / relationships | Class Diagram | `references/types/class.md` |
| System architecture / context | C4 Diagram | `references/types/c4.md` |
| Timeline / ordered events | Timeline Diagram | `references/types/timeline.md` |
| Spiral/Cycle (loop) | State Diagram or Flowchart | `references/types/state.md` `references/types/flowchart.md` |
| Side-by-side comparison | Flowchart (parallel subgraphs) | `references/types/flowchart.md` |
| Data schema / entity relationships | ER Diagram | `references/types/er-diagram.md` |
| Flow volumes / resource allocation | Sankey Diagram | `references/types/sankey.md` |

### Excluded Diagram Types

Do **not** use these types — they lack structural argument capability or are too narrowly specialized:

| Type | Reason Excluded |
|------|-----------------|
| Pie Chart | Simple percentages; lacks structural argument capability |
| Gantt | Specifically for project scheduling, not conceptual mapping |
| Git Graph | Limited to git branch visualization |
| XY Chart | Quantitative data charting rather than structural diagramming |
| User Journey | Overly specific; typically better represented as a Sequence Diagram |

---

## Semantic Styling

Use `classDef` for **semantic meaning**, not decoration. See `references/mermaid-theme.md` for the full recipe table and per-diagram-type support notes.

---

## Output Format

- **Default**: Create a `.mmd` file.
- **If embedding**: When the user says "embed", "add to docs", "in README", or the target is a `.md` file → output a fenced ` ```mermaid ` block instead.
- **When in doubt**: `.mmd` file.

---

## Large Diagram Strategy

Mermaid syntax is compact. Focus on readability:
- Use meaningful node IDs (`authService`, not `A`).
- Add `%%` comments for section breaks within the diagram.
- Keep nodes to ~20 max before splitting into multiple diagrams.
- For complex systems: one `.mmd` per layer (Context → Container → Component).
- Break dense subgraphs into separate files with cross-references in prose.

---

## Render & Validate (MANDATORY)

**How to render:**
```bash
bash .claude/skills/mermaid-diagram-skill/references/render_mermaid.sh <path.mmd> [output.png]
```
First run downloads mmdc via npx — may take ~30s.

**The loop:**
1. Write Mermaid syntax.
2. Run render script.
3a. If mmdc fails with a syntax error: read the error message, fix the syntax. Consult `references/syntax-pitfalls.md` for the most common failures (usually: unquoted special chars, wrong keyword, missing `end`).
3b. If mmdc succeeds: view the PNG, assess the layout.
4. If layout is poor: restructure — reorder node/edge declarations to change placement, switch `rankDir` (TD ↔ LR), add or remove subgraphs.
5. Re-render → repeat until the layout communicates the concept cleanly.

**Label quoting rule**: Always use `["label text"]` instead of `[label text]` whenever the label contains parentheses, commas, `@`, `/`, `<`, `>`, or `:`. When in doubt, quote it — `["My label"]` is always safer than `[My label]`. This single rule prevents ~50% of render failures. See `references/syntax-pitfalls.md` for the full list.

**`flowchart` not `graph`**: Always use `flowchart TD` (modern), never `graph TD` (legacy). `graph` lacks subgraph direction support and other modern features.

**`end` is reserved**: A node whose entire label is `end` will be parsed as a block terminator. Always quote it: `B["end"]`.

**You cannot pixel-position elements.** All layout improvements come from:
- **Reordering declarations** — the order nodes and edges appear in source directly influences Mermaid's placement algorithm.
- **Changing `rankDir`** — `TD`, `LR`, `BT`, `RL` — try the orthogonal direction when crossings persist.
- Consider whether hidden lines would be an appropriate fix for the issue.
- **Using subgraphs** — constrain placement of related nodes.
- NOT coordinate adjustments.

**Line crossing reduction** — the primary visual quality challenge in auto-generated diagrams. Key levers: declaration order, `rankDir` switching, subgraph grouping, and fan-out splitting. Each type-specific reference in `references/types/` includes layout tips tailored to that diagram type. See `references/diagram-type-guide.md` Part 3 for the full optimization guide.

**When to stop**: syntax valid, layout communicates the concept, line crossings minimized, no overlapping labels, eye flows correctly through the diagram.

---

## Quality Checklist

**Concept & Depth (check first for technical diagrams):**
1. Research done: looked up actual specs, formats, event names?
2. Evidence artifacts: Notes, multi-line node labels, companion `.md` for large payloads?
3. Multi-zoom: summary flow + section subgraphs + detail labels?
4. Concrete over abstract: real API names, real event names, not generic "Process"?
5. Educational value: could someone learn from this diagram?

**Diagram Design:**
6. Isomorphism Test: does visual structure mirror the concept's behavior?
7. Argument: does the diagram SHOW something text alone couldn't?
8. Variety: does each major concept use a different visual pattern or node shape?
9. Diagram type chosen intentionally (matches the concept's pattern from decision matrix)?
10. Node IDs are readable, not single letters?

**Mermaid-Specific:**
11. `classDef` used for semantic styling (trigger, success, error, ai, decision)?
12. Output format correct (`.mmd` vs fenced block)?
13. No excluded diagram types used? (Excluded: Pie Chart, Gantt, Git Graph, XY Chart, User Journey — see Decision Matrix above)
14. Node/edge declaration order follows reading direction (minimize line crossings)?
15. No single node has 5+ edges without a dispatcher split?
16. Back-edges isolated (cycles handled in State diagram or contained subgraph)?

**Render Validation (mandatory):**
17. Syntax validated: mmdc runs without error?
18. PNG viewed: layout visually inspected?
19. No overlapping labels or crossed text?
20. Eye flows naturally through the diagram?
21. Line crossings minimized (tried reordering + rankDir if needed)?

**Cleanup**
Once a user is happy with the output, remove any temporary output like pngs or mmd files.