# Mermaid Diagram Type & Decision Guide

A reference for choosing and implementing the most effective Mermaid diagram types for technical documentation and visual arguments.

---

### PART 1 — Decision Matrix

| Visual Pattern | Best Diagram Type |
|----------------|-------------------|
| Fan-out (one-to-many) | Flowchart |
| Convergence (many-to-one) | Flowchart |
| Sequence of steps / interactions | Sequence Diagram |
| Hierarchy / tree | Mindmap |
| State machine / lifecycle | State Diagram |
| Object structure / relationships | Class Diagram |
| System architecture / context | C4 Diagram |
| Timeline / ordered events | Timeline Diagram |
| Spiral/Cycle (loop) | State Diagram (self-transitions) or Flowchart with back-edge |
| Side-by-side comparison | Parallel subgraphs in Flowchart |
| Data schema / entity relationships | ER Diagram |
| Flow volumes / resource allocation | Sankey Diagram |

---

### PART 2 — Detailed Reference Files

| Type | File |
|------|------|
| Flowchart | `references/types/flowchart.md` |
| Sequence Diagram | `references/types/sequence.md` |
| State Diagram | `references/types/state.md` |
| Class Diagram | `references/types/class.md` |
| C4 Diagram | `references/types/c4.md` |
| Mindmap | `references/types/mindmap.md` |
| Timeline Diagram | `references/types/timeline.md` |
| ER Diagram | `references/types/er-diagram.md` |
| Sankey Diagram | `references/types/sankey.md` |

---

### PART 3 — Layout Optimization — Minimizing Line Crossings

Line crossing is the primary visual quality challenge in auto-generated diagrams. Use these strategies to improve clarity:

1. **Node declaration order matters**: The layout engine assigns ranks based on the order nodes appear in the source. Declare nodes in the expected reading order (top-to-bottom or left-to-right). Earlier declarations occupy higher or leftmost ranks.

2. **Minimize back-edges**: Every edge that flows "backwards" to an earlier node forces a crossing line. For cycles, use State diagrams or isolate the back-edge within a specific subgraph to contain the layout impact.

3. **Group related nodes in source**: Keep nodes that belong in the same subgraph or logical group together in the code. Scattered declarations lead to scattered placement and unnecessary crossings.

4. **Use subgraphs as layout hints**: Wrapping related nodes in a `subgraph` constrains their placement, effectively cordoning off areas to prevent global crossings.

5. **Apply direction per subgraph**: Each subgraph can define its own flow direction (e.g., `direction LR`). Mixing directions can resolve density issues in specific graph sectors.

6. **Reduce fan-out at single nodes**: A single node with many outgoing edges creates a "spider web" effect. Insert an intermediate "dispatcher" or group node to flatten the fan-out.

7. **ER diagram relation ordering**: Declare the entity with the highest connectivity first. Then, declare each related entity immediately following the relation that introduces it.

8. **Sequence diagrams are crossing-free by construction**: Since columns are fixed, crossings are impossible. Optimize by declaring participants in their order of interaction (initiator on the left, primary responder next).

9. **When crossings persist**: Simply switching the global orientation (e.g., changing `graph TD` to `graph LR`) often eliminates most crossings in a complex layout.

---

### PART 4 — Excluded Diagram Types

| Type | Reason Excluded |
|------|-----------------|
| Pie Chart | Simple percentages; lacks structural argument capability |
| Gantt | Specifically for project scheduling, not conceptual mapping |
| Git Graph | Limited to git branch visualization |
| XY Chart | Quantitative data charting rather than structural diagramming |
| User Journey | Overly specific; typically better represented as a Sequence Diagram |

---

For full syntax reference, see [Mermaid documentation](https://mermaid.js.org/intro/).
