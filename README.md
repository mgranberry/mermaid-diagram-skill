# Mermaid Diagram Skill

A coding agent skill that generates beautiful and practical Mermaid diagrams from natural language descriptions. Not just boxes-and-arrows — diagrams that **argue visually**.

Compatible with any coding agent that supports skills. For agents that read from `.claude/skills/` (like [Claude Code](https://docs.anthropic.com/en/docs/claude-code) and [OpenCode](https://github.com/nicepkg/OpenCode)), just drop it in and go.

## What Makes This Different

- **Diagrams that argue, not display.** Every shape and group mirrors the concept it represents — fan-outs for one-to-many, timelines for sequences, convergence for aggregation. No uniform card grids.
- **Evidence artifacts.** Technical diagrams include real code snippets, actual JSON payloads, and precise protocol event names.
- **Built-in visual validation.** The render pipeline lets the agent see its own output, catch syntax errors, and fix layout issues in a loop before delivering.
- **Brand-customizable.** All styles live in one file (`references/mermaid-theme.md`). Diagrams use `classDef` semantic styles with explicit fill, stroke, and text colors — making them self-contained and readable in both light and dark mode on GitHub, VS Code, Obsidian, or any Mermaid-capable viewer.

## Installation

Clone or download this repo, then copy it into your project's `.claude/skills/` directory:

```bash
git clone https://github.com/coleam00/mermaid-diagram-skill.git
cp -r mermaid-diagram-skill .claude/skills/mermaid-diagram
```

## Setup

Requires Node.js and npm (for npx). No other installs needed — the render pipeline uses `npx --yes @mermaid-js/mermaid-cli` which downloads mermaid-cli ephemerally on first use.

## Usage

Ask your coding agent to create a diagram:

> "Create a Mermaid sequence diagram showing how the AG-UI protocol streams events from an AI agent to a frontend UI"

The skill handles the rest — concept mapping, diagram type selection, layout optimization, rendering, and visual validation.

## Customize

Edit `references/mermaid-theme.md` — the single source of truth for all theming. It contains:
- Dark/light mode color guidelines (ensures diagrams are readable in both themes)
- `classDef` semantic style recipes (trigger, success, error, ai, decision, primary)
- Per-diagram-type support notes

## File Structure

| File | Description |
|------|-------------|
| `SKILL.md` | Design methodology + workflow |
| `README.md` | This file |
| `.gitignore` | Ignores `*.png`, `*.svg`, `node_modules/` |
| `references/render_mermaid.sh` | Renders `.mmd` to PNG via `npx mmdc` |
| `references/mermaid-theme.md` | Brand theming — global colors, semantic `classDef` recipes, diagram-type support (single customization point) |
| `references/syntax-pitfalls.md` | Common syntax errors and `<br>` compatibility matrix |
| `references/types/flowchart.md` | Flowchart syntax reference |
| `references/types/sequence.md` | Sequence diagram syntax reference |
| `references/types/state.md` | State diagram syntax reference |
| `references/types/class.md` | Class diagram syntax reference |
| `references/types/c4.md` | C4 diagram syntax reference |
| `references/types/mindmap.md` | Mindmap syntax reference |
| `references/types/timeline.md` | Timeline syntax reference |
| `references/types/er-diagram.md` | ER diagram syntax reference |
| `references/types/sankey.md` | Sankey diagram syntax reference |
