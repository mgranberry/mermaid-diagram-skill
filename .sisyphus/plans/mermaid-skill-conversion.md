# Plan: Convert Excalidraw Diagram Skill → Mermaid Diagram Skill

## Goal
Convert the existing Excalidraw diagram skill (generates `.excalidraw` JSON) to a Mermaid diagram skill (generates `.mmd` Mermaid syntax). Preserve all format-agnostic design philosophy. Replace all Excalidraw mechanics with Mermaid equivalents. Render pipeline uses `npx --yes @mermaid-js/mermaid-cli` (requires Node/npm, which is used ephemerally via npx — no global install of mmdc needed).

## Key Decisions
- **Render tool**: `npx --yes @mermaid-js/mermaid-cli` — requires Node/npm (tested: Node v24.13.1 + npx 11.8.0 available on this machine); `npx --yes` downloads mmdc ephemerally on first run, no global install needed
- **Supported diagram types**: Flowchart, Sequence, State, Class, C4 Context/Container, Mindmap, Timeline, ER Diagram, Sankey
- **Excluded diagram types**: Pie, Gantt, Git Graph, XY Chart — not suited for "visual arguments"
- **Output format**: Context-dependent — `.mmd` for standalone, fenced ` ```mermaid ` block in `.md` when embedding in docs
- **Styling**: `%%{init: ...}%%` directives + `classDef` system, documented in `references/mermaid-theme.md`
- **Config file**: `references/mermaidConfig.json` — single brand-customization touchpoint (replaces `color-palette.md`)
- **Render loop character**: Unlike Excalidraw (pixel layout bugs), Mermaid loop fixes syntax errors and graph topology for layout quality
- **Directory rename**: `excalidraw-diagram-skill` → `mermaid-diagram-skill` via `git mv`
- **Philosophy sections**: PRESERVE VERBATIM — Core Philosophy, Depth Assessment, Research Mandate, Multi-Zoom Architecture

## Sections to preserve verbatim from SKILL.md
- Core Philosophy (lines 20–30): "Diagrams should ARGUE, not DISPLAY", Isomorphism Test, Education Test
- Depth Assessment (lines 32–50): Simple vs Comprehensive criteria
- Research Mandate (lines 52–68): Look up actual specs before drawing
- Multi-Zoom Architecture concept (lines 98–141): Level 1/2/3 zoom, Bad vs Good table, Simple vs Comprehensive table

## Files Being Changed

| File | Action |
|------|--------|
| `SKILL.md` | **Rewrite** — preserve philosophy (~40%), replace Excalidraw mechanics (~60%) |
| `README.md` | **Rewrite** — new name, new tool, updated setup/usage |
| `.gitignore` | **Replace** — remove Python toolchain, add `node_modules/` |
| `references/color-palette.md` | **Delete** (git rm) |
| `references/element-templates.md` | **Delete** (git rm) |
| `references/json-schema.md` | **Delete** (git rm) |
| `references/render_excalidraw.py` | **Delete** (git rm) |
| `references/render_template.html` | **Delete** (git rm) |
| `references/pyproject.toml` | **Delete** (git rm) |
| `references/mermaid-theme.md` | **Create** — classDef system, semantic styles, %%init%% directives |
| `references/diagram-type-guide.md` | **Create** — when to use which type + syntax reference + pitfalls |
| `references/render_mermaid.sh` | **Create** — wraps `npx --yes @mermaid-js/mermaid-cli`, validates output |
| `references/mermaidConfig.json` | **Create** — theme configuration, single customization touchpoint |

---

## Wave 1 — Directory Rename (no dependencies)

- [ ] **Task 1: Rename skill directory from `excalidraw-diagram-skill` to `mermaid-diagram-skill`**

  Use `git mv` to rename the directory so history is preserved.

  **QA**:
  ```bash
  test -d /Users/mgranber/.claude/skills/mermaid-diagram-skill/references && echo "PASS" || echo "FAIL"
  # Expected: PASS
  ```

---

## Wave 2 — Create/Delete reference files (all depend on Task 1, all independent of each other)

- [ ] **Task 2: Delete all Excalidraw-specific reference files**

  Use `git rm` on each of these files (working directory: `/Users/mgranber/.claude/skills/mermaid-diagram-skill`):
  - `references/color-palette.md`
  - `references/element-templates.md`
  - `references/json-schema.md`
  - `references/render_excalidraw.py`
  - `references/render_template.html`
  - `references/pyproject.toml`

  **QA**:
  ```bash
  ls /Users/mgranber/.claude/skills/mermaid-diagram-skill/references/
  # Expected: directory lists no Excalidraw files (none of the 6 above)
  ```

- [ ] **Task 3: Create `references/render_mermaid.sh`**

  Shell script wrapping `npx --yes @mermaid-js/mermaid-cli`. Requirements:
  - Arguments: `$1` = input file path (`.mmd` or `.md`), `$2` = output path (optional, defaults to input path with `.png` extension)
  - Use `npx --yes @mermaid-js/mermaid-cli` as the invocation (the `--yes` skips the npx install prompt)
  - Pass `-c "$(dirname "$0")/mermaidConfig.json"` to use the config file from the same directory
  - Pass `-i "$1" -o "$2"` for input/output
  - Validate `$1` exists; exit 1 with error message if not
  - Check mmdc exit code; exit 1 with error message if non-zero
  - Verify the output file was created and is non-empty (`test -s "$2"`); exit 1 if not
  - Print the output path on success
  - Make the script executable (`chmod +x`)

  **QA**:
  ```bash
  echo "graph TD; A-->B" > /tmp/skill-test.mmd && bash /Users/mgranber/.claude/skills/mermaid-diagram-skill/references/render_mermaid.sh /tmp/skill-test.mmd /tmp/skill-test.png && test -s /tmp/skill-test.png && echo "PASS" || echo "FAIL"
  # Expected: PASS (mmdc downloads via npx --yes on first run — may take ~30s)
  ```

- [ ] **Task 4: Create `references/mermaidConfig.json`**

  JSON config file for mmdc's `-c` flag. Must be valid JSON. Should include:
  - `"theme": "default"` as the base theme
  - `"themeVariables"` matching the spirit of the old color-palette.md:
    - `primaryColor`: `"#3b82f6"` (blue — was Primary/Neutral fill)
    - `primaryTextColor`: `"#ffffff"`
    - `primaryBorderColor`: `"#1e3a5f"`
    - `secondaryColor`: `"#fed7aa"` (orange — was Start/Trigger fill)
    - `tertiaryColor`: `"#a7f3d0"` (green — was End/Success fill)
    - `background`: `"#ffffff"`
    - `mainBkg`: `"#dbeafe"`
    - `nodeBorder`: `"#1e3a5f"`
    - `clusterBkg`: `"#f0f9ff"`
    - `titleColor`: `"#1e40af"`
    - `edgeLabelBackground`: `"#ffffff"`
    - `fontSize`: `"16px"`

  **QA**:
  ```bash
  python3 -c "import json; d=json.load(open('/Users/mgranber/.claude/skills/mermaid-diagram-skill/references/mermaidConfig.json')); assert 'theme' in d; assert 'themeVariables' in d; print('VALID')"
  # Expected: VALID
  ```

- [ ] **Task 5: Create `references/mermaid-theme.md`**

  Documentation for Mermaid styling — replaces `color-palette.md`. Sections:
  1. **How to customize globally** — edit `mermaidConfig.json`, explain `themeVariables` keys
  2. **How to use `%%{init: ...}%%`** — per-diagram overrides (with example)
  3. **How to use `classDef` and `class`** — per-node styling (with example)
  4. **Semantic style recipes** — a table mapping concept types to classDef definitions:
     - Start/Trigger → orange fill (`#fed7aa`), dark stroke (`#c2410c`)
     - End/Success → green fill (`#a7f3d0`), dark stroke (`#047857`)
     - Decision → yellow fill (`#fef3c7`), amber stroke (`#b45309`)
     - AI/LLM → purple fill (`#ddd6fe`), purple stroke (`#6d28d9`)
     - Error → red fill (`#fecaca`), red stroke (`#b91c1c`)
     - Primary/Neutral → blue fill (`#3b82f6`), dark stroke (`#1e3a5f`)
     - Show as classDef syntax lines: `classDef trigger fill:#fed7aa,stroke:#c2410c,color:#374151`
  5. **Styling by diagram type** — notes on how classDef applies in sequence (participant boxes), state (state fills), C4 (shape styles)
  6. **Common pitfalls** — special characters in labels must be quoted, some diagram types don't support classDef (note which ones)

  Keep concise (~60-80 lines total).

  **QA**:
  ```bash
  test -f /Users/mgranber/.claude/skills/mermaid-diagram-skill/references/mermaid-theme.md && grep -c "classDef" /Users/mgranber/.claude/skills/mermaid-diagram-skill/references/mermaid-theme.md
  # Expected: file exists, classDef count >= 5
  ```

- [ ] **Task 6: Create `references/diagram-type-guide.md`**

  Decision guide + minimal syntax reference for the 9 supported Mermaid diagram types. Structure:

  **Top section**: Decision matrix — maps the Visual Pattern Library patterns from SKILL.md to diagram types:
  - Fan-out (one-to-many) → Flowchart
  - Convergence (many-to-one) → Flowchart
  - Sequence of steps / interactions → Sequence Diagram
  - Hierarchy / tree → Mindmap
  - State machine / lifecycle → State Diagram
  - Object structure / relationships → Class Diagram
  - System architecture / context → C4 Diagram
  - Timeline / ordered events → Timeline Diagram
  - Spiral/Cycle (loop) → State Diagram (with self-transitions) or Flowchart with back-edge
  - Side-by-side comparison → Parallel subgraphs in Flowchart
  - Data schema / entity relationships → ER Diagram
  - Flow volumes / resource allocation → Sankey Diagram

  **Per diagram type** (repeat for each of 9 types — Flowchart, Sequence, State, Class, C4, Mindmap, Timeline, ER Diagram, Sankey):
  - **When to use**: 2-3 bullet points
  - **Minimal syntax example**: 5-15 lines of real Mermaid syntax
  - **Common pitfalls**: 2-3 gotchas (special chars, reserved words, arrow syntax)
  - **classDef support**: Yes/No + note

  **ER Diagram specifics**: Cover `erDiagram` syntax — entity definitions, relationship types (`||--o{`, `}|..|{`, etc.), attribute types. When to use: database schemas, data models, entity relationships in a domain model. Note that ER diagrams are excellent for making "visual arguments" about data structure and domain modeling.

  **Sankey Diagram specifics**: Cover `sankey-beta` syntax — source/target/value CSV-like rows. When to use: showing flow volumes (traffic, money, energy, data throughput), resource allocation, dependency weights. Note that Sankey is one of the most powerful diagram types for arguing about proportional flows — a node with many incoming/outgoing flows tells a story that text cannot.

  **Layout Optimization section** (NEW — applies to all diagram types): A dedicated section on minimizing line crossings, which is the #1 visual quality issue in auto-layout diagrams. Include:
  - **Node declaration order matters**: Mermaid's auto-layout engine assigns ranks based on the order nodes and edges are declared. Nodes declared earlier tend to be placed higher/left. Declare nodes in the order you want them to flow — top-to-bottom or left-to-right in the expected reading order.
  - **Minimize back-edges**: Each edge that flows "backwards" (from a later node to an earlier node) forces the layout engine to route a crossing line. For cycles, prefer using a State diagram or adding a `%% loop back` comment to isolate the back-edge, making the diagram's main flow stay forward-only.
  - **Group related nodes together in source order**: Nodes that will be in the same subgraph should be declared together. Scattered declarations produce scattered placement and more crossings.
  - **Use subgraphs as layout hints**: Wrapping tightly related nodes in a `subgraph` constrains their placement relative to each other, reducing crossings between those nodes and the rest of the graph.
  - **Use `direction` per subgraph**: Each subgraph can have its own `direction TB` or `direction LR`, allowing mixed flow directions that reduce crossings within dense sections.
  - **Reduce fan-out at a single node**: A node with 5+ outgoing edges will produce a "spider web" regardless of ordering. Split it into two logical stages (a dispatcher node → individual handlers) to flatten the fan-out and reduce crossings.
  - **ER diagram relation ordering**: In `erDiagram`, declare the entity with the most relationships first. Then declare each related entity immediately after the relation that introduces it, so the layout walks the graph in a natural chain rather than jumping across the diagram.
  - **Sequence diagrams are crossing-free by construction**: Participant order determines column order. Declare participants explicitly at the top in the order they first meaningfully interact (left = initiator, right = responder). This eliminates all crossing arrows for the common request→response pattern.
  - **When crossings remain after reordering**: If 2-3 crossings persist after reordering, try switching `rankDir` (e.g. `LR` instead of `TB`) — the crossing pattern is often completely different in the orthogonal direction. One orientation often has zero crossings where the other has many.

  **Excluded types section**: Brief list of excluded types with one-line reason:
  - Pie Chart — not suited for visual arguments (just percentages)
  - Gantt — scheduling/timeline, not concept visualization
  - Git Graph — git history only
  - XY Chart — data charting, not diagramming
  - User Journey — too specific, use Sequence Diagram instead

  Keep focused — this is a reference, not a tutorial. Link to official Mermaid docs for full syntax.

  **QA**:
  ```bash
  for type in flowchart sequence state class C4 mindmap timeline erDiagram sankey; do
    count=$(grep -ci "$type" /Users/mgranber/.claude/skills/mermaid-diagram-skill/references/diagram-type-guide.md 2>/dev/null || echo 0)
    echo "$type: $count"
  done
  # Expected: each type appears >= 2 times

  grep -c "crossing\|declaration order\|back-edge" /Users/mgranber/.claude/skills/mermaid-diagram-skill/references/diagram-type-guide.md
  # Expected: >= 3 (line-crossing guidance is present)
  ```

---

## Wave 3 — Rewrite SKILL.md (depends on Tasks 2–6)

- [ ] **Task 7: Rewrite `SKILL.md`**

  The most important task. Rewrite the core skill file. Keep the Excalidraw file open in context for reference. Transform section by section using the following rules:

  ### PRESERVE VERBATIM (copy these sections unchanged):
  - **Core Philosophy** — "Diagrams should ARGUE, not DISPLAY", Isomorphism Test, Education Test
  - **Depth Assessment** — Simple vs Comprehensive criteria, the two context tables
  - **Research Mandate** — "Before drawing anything technical, research the actual specifications", bad/good examples
  - **Multi-Zoom Architecture** — Level 1/2/3 zoom concept, Bad vs Good table, Simple vs Comprehensive table

  ### REWRITE these sections (Mermaid equivalents):

  **Frontmatter**:
  ```
  ---
  name: mermaid-diagram
  description: Create Mermaid diagram files that make visual arguments. Use when the user wants to visualize workflows, architectures, or concepts.
  ---
  ```

  **Title + Intro**: "Mermaid Diagram Creator". Generate `.mmd` files (or fenced ` ```mermaid ` blocks in `.md` files when embedding). Reference `references/mermaid-theme.md` as the single style customization source.

  **Customization section**: Same role as before — edit `references/mermaid-theme.md` and `references/mermaidConfig.json` to customize brand styles.

  **Evidence Artifacts section**: Rewrite for Mermaid's capabilities:
  - **Notes** (sequence diagrams): `Note over A,B: content` for showing data payloads
  - **Node labels with line breaks**: Use `<br/>` in node labels to show multi-line content
  - **Subgraph labels**: Use subgraph titles for section context
  - **Companion `.md` files**: For code-heavy evidence, recommend creating a companion `.md` file with fenced code blocks alongside the `.mmd` diagram
  - Acknowledge Mermaid's limitation: it cannot embed arbitrary code blocks inside nodes the way Excalidraw could with dark rectangles

  **Design Process**: 
  - Steps 0–4: Preserve (assess depth, understand deeply, map to patterns, ensure variety, sketch flow)
  - Step 5: Rewrite → "Generate Mermaid Syntax" — choose diagram type from `references/diagram-type-guide.md` first, then write the syntax. Start with a comment block naming the type and describing each section.
  - Step 6: Rewrite → mmdc render loop (see Render & Validate section)

  **Visual Pattern Library**: Map each pattern to Mermaid. Keep ASCII art sketches where helpful, replace Excalidraw-specific notes with Mermaid type recommendations. For each pattern, add "→ Use: [Diagram Type]".

  **Node Shape Reference** (replaces Shape Meaning section): Mermaid node shapes and when to use them:
  - `[text]` — rectangle: process, action, component
  - `(text)` — rounded: softer process, intermediate step  
  - `((text))` — circle: start/end point, event
  - `{text}` — diamond: decision, condition
  - `([text])` — stadium/pill: external system, service
  - `[[text]]` — subroutine: reusable component
  - `>text]` — asymmetric: note, annotation
  - `{{text}}` — hexagon: preparation step

  **Styling section** (replaces Color as Meaning + Modern Aesthetics): Reference `references/mermaid-theme.md` for semantic `classDef` recipes. Show one example of `classDef` usage in a diagram snippet. Key principle: use `classDef` for semantic meaning, not decoration.

  **Output Format section** (NEW — no Excalidraw equivalent): 
  - Default: create a `.mmd` file
  - If the user says "embed", "add to docs", "in README", or the target is a `.md` file: output a fenced ` ```mermaid ` block instead
  - When in doubt: `.mmd` file

  **Large Diagram Strategy**: Dramatically simplify vs Excalidraw version (which was about 32k token limits). Mermaid syntax is compact (~10-20x smaller). Focus on readability guidance instead: use meaningful node IDs (not `A`, `B`, `C`), add `%%` comments for sections, break complex diagrams into subgraphs, keep nodes to ~20 max before splitting into multiple diagrams.

  **Render & Validate**: Rewrite entirely for mmdc:
  - How to render: `bash .claude/skills/mermaid-diagram-skill/references/render_mermaid.sh <path.mmd> [output.png]`
  - First-time note: first run downloads mmdc via npx, may take ~30s
  - The loop: (1) Write syntax → (2) Run render script → (3a) If mmdc fails: read error, fix syntax → (3b) If mmdc succeeds: view PNG, assess layout → (4) If layout poor: restructure graph topology, reorder node/edge declarations to minimize line crossings, change `rankDir`, use subgraphs for grouping → (5) Re-render → repeat
  - Key difference from Excalidraw: you cannot pixel-position elements. Layout improvements come from restructuring graph structure, **reordering declarations** (the order nodes and edges appear in source directly influences Mermaid's placement algorithm), changing `rankDir` (TB/LR/BT/RL), and using subgraphs — not coordinate adjustments
  - **Line crossing reduction** (the most impactful layout fix): declare nodes in reading order (top→bottom, left→right); minimize back-edges by isolating cycles in subgraphs; declare related nodes together; reduce fan-out at any single node; for ER diagrams, declare the most-connected entity first and chain outward. See `references/diagram-type-guide.md` for per-type guidance.
  - When to stop: syntax valid, layout communicates the concept, line crossings minimized, no overlapping labels, eye flows correctly

  **Quality Checklist**: Rewrite each item for Mermaid. Remove all Excalidraw-specific items. Add:
  - Diagram type chosen intentionally (matches the concept's pattern)
  - Node IDs are readable, not single letters
  - `classDef` used for semantic styling
  - Syntax validated (mmdc runs without error)
  - Output format correct (`.mmd` vs fenced block)
  - No excluded diagram types used
  - Node/edge declaration order follows reading direction (minimize line crossings)
  - No single node has 5+ edges without being split into a dispatch stage
  - Back-edges isolated (cycles handled in State diagram or contained subgraph)

  ### DELETE entirely (no Mermaid equivalent):
  - "Text Rules" (Excalidraw JSON `text` property)
  - "JSON Structure" (Excalidraw JSON wrapper)
  - "Element Templates reference" (was about `references/element-templates.md`)
  - Excalidraw-specific pixel layout principles (roughness, strokeWidth, opacity settings, 200px+ whitespace rules)
  - Section-by-section JSON generation strategy (Excalidraw token limit workaround — not needed for Mermaid)

  **QA**:
  ```bash
  # Philosophy preserved
  grep -c "Isomorphism Test" /Users/mgranber/.claude/skills/mermaid-diagram-skill/SKILL.md  # >= 1
  grep -c "Education Test" /Users/mgranber/.claude/skills/mermaid-diagram-skill/SKILL.md   # >= 1
  grep -c "ARGUE" /Users/mgranber/.claude/skills/mermaid-diagram-skill/SKILL.md            # >= 1
  
  # No Excalidraw references
  grep -ci "excalidraw" /Users/mgranber/.claude/skills/mermaid-diagram-skill/SKILL.md      # == 0
  
  # Mermaid content present
  grep -c "mmdc\|mermaid-cli" /Users/mgranber/.claude/skills/mermaid-diagram-skill/SKILL.md  # >= 1
  grep -c "classDef" /Users/mgranber/.claude/skills/mermaid-diagram-skill/SKILL.md           # >= 2
  grep -c "render_mermaid" /Users/mgranber/.claude/skills/mermaid-diagram-skill/SKILL.md     # >= 1
  
  # Frontmatter correct
  head -4 /Users/mgranber/.claude/skills/mermaid-diagram-skill/SKILL.md | grep -c "name: mermaid-diagram"  # == 1
  ```

---

## Wave 4 — Final files and validation (depends on Task 7)

- [ ] **Task 8: Rewrite `README.md` and update `.gitignore`**

  **README.md** — rewrite completely:
  - Title: "Mermaid Diagram Skill"
  - Description: same purpose, reference Mermaid instead of Excalidraw
  - "What Makes This Different": preserve the key differentiators (argue not display, evidence artifacts, built-in visual validation, brand-customizable) — reframe for Mermaid
  - Installation: same `git clone` + copy pattern; note no Python/uv needed
  - Setup: "Requires Node.js and npm (for npx). No other installs needed — the render pipeline uses `npx --yes @mermaid-js/mermaid-cli` which downloads mermaid-cli ephemerally on first use."
  - Usage: Show a Mermaid-appropriate example prompt
  - Customize: Reference `references/mermaidConfig.json` + `references/mermaid-theme.md`
  - File structure: Updated table reflecting the new files

  **.gitignore** — replace entire content with:
  ```
  *.png
  *.svg
  node_modules/
  ```
  (Remove `.venv/`, `uv.lock`, `__pycache__/` — no longer relevant)

  **QA**:
  ```bash
  grep -ci "excalidraw" /Users/mgranber/.claude/skills/mermaid-diagram-skill/README.md  # == 0
  grep -c "mermaid" /Users/mgranber/.claude/skills/mermaid-diagram-skill/README.md      # >= 5
  grep -c "node_modules" /Users/mgranber/.claude/skills/mermaid-diagram-skill/.gitignore  # == 1
  grep -c "__pycache__" /Users/mgranber/.claude/skills/mermaid-diagram-skill/.gitignore   # == 0
  ```

- [ ] **Task 9: Final validation scan**

  Run comprehensive verification to confirm the conversion is complete and the render pipeline works end-to-end.

  **QA** (run all of these, report results):
  ```bash
  # 1. No excalidraw references in any text file
  find /Users/mgranber/.claude/skills/mermaid-diagram-skill/ \
    \( -name "*.md" -o -name "*.sh" -o -name "*.json" \) \
    | xargs grep -li "excalidraw" 2>/dev/null | wc -l
  # Expected: 0

  # 2. All expected files exist
  for f in SKILL.md README.md .gitignore \
      references/mermaid-theme.md \
      references/diagram-type-guide.md \
      references/render_mermaid.sh \
      references/mermaidConfig.json; do
    test -f "/Users/mgranber/.claude/skills/mermaid-diagram-skill/$f" \
      && echo "EXISTS: $f" || echo "MISSING: $f"
  done
  # Expected: all lines say EXISTS

  # 3. No deleted files remain
  for f in references/color-palette.md \
      references/element-templates.md \
      references/json-schema.md \
      references/render_excalidraw.py \
      references/render_template.html \
      references/pyproject.toml; do
    test -f "/Users/mgranber/.claude/skills/mermaid-diagram-skill/$f" \
      && echo "STILL EXISTS (BAD): $f" || echo "DELETED OK: $f"
  done
  # Expected: all lines say DELETED OK

  # 4. Render pipeline — flowchart smoke test
  echo 'graph TD; A[Start]-->B{Decision}; B-->|Yes|C[End]; B-->|No|A;' > /tmp/flow-test.mmd
  bash /Users/mgranber/.claude/skills/mermaid-diagram-skill/references/render_mermaid.sh \
    /tmp/flow-test.mmd /tmp/flow-test.png
  test -s /tmp/flow-test.png && echo "FLOWCHART RENDER: PASS" || echo "FLOWCHART RENDER: FAIL"

  # 5. Render pipeline — sequence diagram smoke test
  printf 'sequenceDiagram\n    Alice->>Bob: Hello\n    Bob-->>Alice: Hi back' > /tmp/seq-test.mmd
  bash /Users/mgranber/.claude/skills/mermaid-diagram-skill/references/render_mermaid.sh \
    /tmp/seq-test.mmd /tmp/seq-test.png
  test -s /tmp/seq-test.png && echo "SEQUENCE RENDER: PASS" || echo "SEQUENCE RENDER: FAIL"

  # 6. mermaidConfig.json is valid JSON
  python3 -c "import json; json.load(open('/Users/mgranber/.claude/skills/mermaid-diagram-skill/references/mermaidConfig.json')); print('CONFIG JSON: VALID')"

  # 7. SKILL.md frontmatter
  head -4 /Users/mgranber/.claude/skills/mermaid-diagram-skill/SKILL.md | grep "name: mermaid-diagram" \
    && echo "FRONTMATTER: PASS" || echo "FRONTMATTER: FAIL"
  ```

---

## Post-Completion: Commit

After all tasks pass QA, commit the entire conversion:
```bash
cd /Users/mgranber/.claude/skills/mermaid-diagram-skill
git add -A
git commit -m "Convert skill from Excalidraw to Mermaid diagram generation

- Rename directory: excalidraw-diagram-skill → mermaid-diagram-skill
- Replace render pipeline: Python+Playwright → npx @mermaid-js/mermaid-cli shell script
- Replace color-palette.md with mermaid-theme.md (classDef system)
- Add diagram-type-guide.md and mermaidConfig.json
- Rewrite SKILL.md preserving core design philosophy
- Rewrite README.md for Mermaid toolchain
- Delete all Excalidraw-specific reference files"
```
