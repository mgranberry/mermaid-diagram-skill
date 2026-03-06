# Mermaid Theming Reference

This is the **single theming file** for the Mermaid Diagram skill. All brand styling is done through `classDef` semantic styles embedded directly in each diagram. No external config files, no `%%{init}%%` directives — diagrams are fully self-contained and render consistently in any context: GitHub (light and dark mode), VS Code, Obsidian, or the CLI render pipeline.

---

## Section 1 — Dark/light mode compatibility

Diagrams must look correct in **both** light and dark rendering contexts. Different viewers (GitHub, VS Code, Obsidian) apply their own base theme — we cannot control or predict which one the reader will see.

**The rule: every `classDef` MUST set all three properties: `fill`, `stroke`, and `color` (text).** If you omit `color`, the renderer's theme controls the text — and in dark mode, that means white or light text on your pastel fill, which destroys contrast. Because each `classDef` explicitly controls its own fill and text, the contrast depends only on the fill — not the page background. This makes `classDef` styles inherently portable across light and dark modes.

### Color selection guidelines

When choosing or customizing `classDef` colors:

1. **Always set `fill`, `stroke`, AND `color` in every `classDef`.** Never omit `color`. A `classDef` without `color` will inherit the renderer's theme text color, which breaks contrast in dark mode (light text on pastel fill). This is the #1 cause of unreadable diagrams.
2. **Use medium-saturation pastel fills** (not too light, not too dark). Pastels like `#fed7aa`, `#a7f3d0`, `#ddd6fe` are visible against both white and dark backgrounds.
3. **Use dark text (`#374151` or similar) on pastel fills.** Dark grey text on a pastel fill has strong contrast regardless of the surrounding page theme. Aim for at least WCAG AA contrast (4.5:1 ratio between text color and fill).
4. **Use white text only on saturated dark fills** (e.g., white `#ffffff` on `#3b82f6` blue). Avoid white text on pastel fills — it disappears.
5. **Use a stroke color darker than the fill.** This ensures the node boundary is visible on any background. The stroke also helps nodes stand out on dark backgrounds where a pastel fill might otherwise float.
6. **Avoid very light fills** (e.g., `#f0f9ff`, `#fefefe`) — they vanish on white backgrounds and look washed out on dark ones.
7. **Avoid very dark fills** (e.g., `#1e293b`, `#111827`) — they vanish on dark backgrounds.
8. **Do not use `%%{init}%%` themeVariables for branding.** These set the renderer's base palette and conflict with dark mode. Let each renderer handle its own base theme; only style the nodes you care about via `classDef`.

Unstyled nodes (those without any `classDef`) inherit the renderer's default theme, which is already optimized for that renderer's light/dark context. This is fine — don't fight it. But **any node with a custom fill MUST have an explicit text color**.

---

## Section 2 — Semantic style recipes

Use `classDef` to define semantic styles. Apply with `:::` or the `class` keyword.

```mermaid
classDef trigger fill:#fed7aa,stroke:#c2410c,color:#374151
A["Start"]:::trigger
class B trigger
```

### Brand palette

| Concept | Fill | Stroke | Text | classDef line |
| :--- | :--- | :--- | :--- | :--- |
| Start/Trigger | `#fed7aa` | `#c2410c` | `#374151` | `classDef trigger fill:#fed7aa,stroke:#c2410c,color:#374151` |
| End/Success | `#a7f3d0` | `#047857` | `#374151` | `classDef success fill:#a7f3d0,stroke:#047857,color:#374151` |
| Decision | `#fef3c7` | `#b45309` | `#374151` | `classDef decision fill:#fef3c7,stroke:#b45309,color:#374151` |
| AI/LLM | `#ddd6fe` | `#6d28d9` | `#374151` | `classDef ai fill:#ddd6fe,stroke:#6d28d9,color:#374151` |
| Error | `#fecaca` | `#b91c1c` | `#374151` | `classDef error fill:#fecaca,stroke:#b91c1c,color:#374151` |
| Primary/Neutral | `#3b82f6` | `#1e3a5f` | `#ffffff` | `classDef primary fill:#3b82f6,stroke:#1e3a5f,color:#ffffff` |

All recipes follow the dual-mode rules: pastel fills with dark text (except Primary, which uses a saturated fill with white text). These have been tested against both light (`#ffffff`) and dark (`#1e1e2e`) backgrounds.

---

## Section 3 — Diagram type support for `classDef`

Not all diagram types support `classDef`. Know what works before styling:

- **Flowchart**: Full `classDef` support. Primary branding target.
- **Sequence**: `classDef` is **not applicable**. Use `participant A` and `box Color Title` for grouping. When using `box`, choose pastel backgrounds that work in both modes.
- **State**: `classDef` applies to state nodes.
- **Class diagram**: Limited `classDef` support; use `style` instead.
- **C4**: Use `UpdateElementStyle` for shape styles.
- **Mindmap**: `classDef` not supported; use `::icon()` or `:::className` (beta).
- **ER/Sankey**: No `classDef` support.

For diagram types without `classDef` support, unstyled nodes inherit the renderer's default theme — which is already optimized for that renderer's light/dark context.

---

## Section 4 — Common pitfalls

- **Never omit `color` from a `classDef`.** `classDef foo fill:#fed7aa,stroke:#c2410c` (missing `color`) → dark mode renders white text on peach. Always include `color:#374151` (or appropriate text color).
- `classDef` names are case-sensitive.
- Quote special chars in labels: `A["label (with parens)"]`.
- Diagram type support for `classDef` varies — check Section 3.
- Don't mix `classDef` and `%%{init}%%` for the same color concerns — pick one. We pick `classDef`.
