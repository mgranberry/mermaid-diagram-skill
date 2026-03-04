# Flowchart

## When to Use
- Logic branching and multi-step processes.
- Complex dependency maps and decision-tree logic.
- Visualizing parallel paths and system workflows.

## Syntax Reference

### Basic Example
```mermaid
graph TD
    Start[Start Process] --> Check{Is Valid?}
    Check -->|Yes| Process[Run Process]
    Check -->|No| End[End]
    Process --> End
```

### Extended Example (with styling)
```mermaid
flowchart LR
    subgraph Input
        direction TB
        A([User Request]) --> B[/Manual Entry/]
    end

    subgraph Core
        direction LR
        C{Validate} -- Success --> D[Processing]
        C -- Fail --> E[[Error Handler]]
    end

    Input --> Core
    D ==> F[(Database)]
    E -.-> G(Notification)

    classDef trigger fill:#fed7aa,stroke:#c2410c,color:#374151
    class A trigger
```

## All Supported Syntax

- **Direction**: `graph TD` (top-down), `graph LR` (left-right), `graph BT` (bottom-top), `graph RL` (right-left).
- **Keyword**: `flowchart` is preferred for modern features.
- **Node Shapes**:
    - `[Rectangle]`
    - `(Rounded)`
    - `([Stadium])`
    - `[[Subroutine]]`
    - `[(Database)]`
    - `((Circle))`
    - `>Flag]`
    - `{Decision}`
    - `{{Hexagon}}`
    - `[/Parallelogram/]`
    - `[\Backslashed\]`
    - `[/Trapezoid\]`
- **Edges**:
    - `-->` Arrow
    - `---` Line
    - `-.->` Dotted arrow
    - `==>` Thick arrow
    - `-- text -->` Arrow with text
    - `---| text |-->` Arrow with text (alternative)
- **Subgraphs**: `subgraph Title` ... `end`. Can include `direction`.
- **Styling**: `classDef className style` and `class nodeID className` or `nodeID:::className`.

## Layout Tips (type-specific)
- Prefer `LR` for wide graphs with many parallel paths to reduce scrolling.
- Use `TD` for sequential, step-by-step processes.
- Use `subgraph` direction to mix layouts (e.g., a `TB` subgraph inside an `LR` graph).

## Common Pitfalls
- Special characters in labels (like `(` or `]`) require quoting: `["Label (text)"]`.
- Do not mix `graph` and `flowchart` keywords in the same block.
- Excessive edge crossings in `TD` graphs can often be fixed by switching to `LR`.

## classDef Support
Yes. Full CSS-like styling for nodes using `classDef`.
