# Section 1 — How to customize globally
Edit `mermaidConfig.json` to set `themeVariables`. Key variables: `primaryColor`, `secondaryColor`, `tertiaryColor`, `background`, `nodeBorder`, and `fontSize`. This is the single touchpoint for brand-wide color changes.

# Section 2 — Per-diagram overrides with `%%{init: ...}%%`
This overrides `mermaidConfig.json` for a single diagram.
```mermaid
%%{init: {"theme": "default", "themeVariables": {"primaryColor": "#ff6b6b"}}}%%
graph TD
    A --> B
```

# Section 3 — Per-node styling with `classDef` and `class`
Use `classDef` to define a reusable style and `:::` or the `class` keyword to apply it.
```mermaid
classDef myStyle fill:#fed7aa,stroke:#c2410c,color:#374151
A[Start]:::myStyle
class B myStyle
```

# Section 4 — Semantic style recipes
| Concept | Fill | Stroke | Text | classDef line |
| :--- | :--- | :--- | :--- | :--- |
| Start/Trigger | `#fed7aa` | `#c2410c` | `#374151` | `classDef trigger fill:#fed7aa,stroke:#c2410c,color:#374151` |
| End/Success | `#a7f3d0` | `#047857` | `#374151` | `classDef success fill:#a7f3d0,stroke:#047857,color:#374151` |
| Decision | `#fef3c7` | `#b45309` | `#374151` | `classDef decision fill:#fef3c7,stroke:#b45309,color:#374151` |
| AI/LLM | `#ddd6fe` | `#6d28d9` | `#374151` | `classDef ai fill:#ddd6fe,stroke:#6d28d9,color:#374151` |
| Error | `#fecaca` | `#b91c1c` | `#374151` | `classDef error fill:#fecaca,stroke:#b91c1c,color:#374151` |
| Primary/Neutral | `#3b82f6` | `#1e3a5f` | `#ffffff` | `classDef primary fill:#3b82f6,stroke:#1e3a5f,color:#ffffff` |

# Section 5 — Styling by diagram type
- Flowchart: full `classDef` support.
- Sequence: use `participant A` and `box Color Title` for grouping. `classDef` is not applicable.
- State: `classDef` applies to state nodes.
- Class diagram: limited support; use `style` instead of `classDef`.
- C4: use `UpdateElementStyle` for shape styles.
- Mindmap: `classDef` not supported; use `::icon()` or `:::className` (beta).
- ER/Sankey: no `classDef` support.

# Section 6 — Common pitfalls
- Quote special chars in labels: `A["label (with parens)"]`.
- `classDef` names are case-sensitive.
- Diagram type support for `classDef` varies; check Section 5.
- `%%{init}%%` must be the very first line of the diagram.
