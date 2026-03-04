# Class Diagram

## When to Use
- Static structure, data models, and object-oriented design.
- Inheritance, composition, and member definitions.
- Documenting software architecture and class relationships.

## Syntax Reference

### Basic Example
```mermaid
classDiagram
    class User {
        +String email
        +login()
    }
    class Order {
        +String id
        +place()
    }
    User "1" --> "*" Order : places
```

### Extended Example (with styling)
```mermaid
classDiagram
    class Shape {
        <<interface>>
        +draw()
        +getArea() float
    }
    class Circle {
        -float radius
        +Circle(radius)
    }
    class Square {
        -float side
    }

    Shape <|-- Circle : implements
    Shape <|-- Square : implements
    
    class Canvas {
        +List shapes
        +renderAll()
    }
    Canvas *-- Shape : contains
    
    style Shape fill:#f9f,stroke:#333
```

## All Supported Syntax

- **Keyword**: `classDiagram`.
- **Members/Methods**: `+` Public, `-` Private, `#` Protected, `~` Package/Internal. Syntax: `Type name` or `name() Type`.
- **Stereotypes**: `<<interface>>`, `<<abstract>>`, `<<service>>`.
- **Relationship Types**:
    - `<|--` Inheritance
    - `*--` Composition
    - `o--` Aggregation
    - `-->` Association
    - `--` Link (Solid)
    - `..>` Dependency
    - `..|>` Realization
- **Multiplicity**: `"1"`, `"0..1"`, `"1..*"`, `"*"` or `"many"`.
- **Namespaces**: `namespace Name { ... }`.
- **Styling**: `style ClassName fill:#color`.

## Layout Tips (type-specific)
- Declare the most-connected class first to help the layout engine.
- Group subclasses immediately after their superclass to keep the inheritance tree clean.
- Use multiplicity labels to clarify business logic constraints.

## Common Pitfalls
- Relationship syntax is very strict (e.g., `<|--` vs `<--`).
- Auto-layout can become messy with many classes; use namespaces to group them.
- `classDef` is not supported; use `style` for coloring.

## classDef Support
No. Use `style` instead for individual classes.
