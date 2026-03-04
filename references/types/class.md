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

### New Rendered Examples
#### Example 1: Inheritance and Composition
```mermaid
classDiagram
    class Animal {
        +String species
        +eat()
        +sleep()
    }
    class Dog {
        +String breed
    }
    Animal <|-- Dog

    class Car {
        +Engine engine
    }

    Car o-- Engine : has
```

#### Example 2: Multi-line Attributes and Abstract Interfaces
```mermaid
classDiagram
    class AbstractShape {
        +calculateArea()
    }
    AbstractShape <|-- Circle

    class ModernShape {
        <<abstract>>
        +render()
        ~interact()
    }
    Circle --> AbstractShape
```

### Edge-Case Examples
#### Long Labels
```mermaid
classDiagram
    class ClassWithLongName {
        +ThisIsAReallyLongMethodName(param1, param2) ResultType
    }
```

#### Multi-line Attributes
```mermaid
classDiagram
    class MultiLineClass {
        +String attributeOne
        ~ComplexType attributeTwo
        -AnotherTypeWithDetails
    }
```
Note: Line breaks (`<br>`, `<br/>`, `\n`) do **not** work inside class members — they render as literal text. Keep member signatures concise.

#### Relationships with Special Labels
```mermaid
classDiagram
    class Parent {
        +manage()
    }
    class Child {
        +play()
    }
    Parent <|-- Child : "Custom arrow label<br>with wrapped text"
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
- **Line breaks**: `<br>` works in relationship labels (e.g., `Parent <|-- Child : "line1<br>line2"`). Line breaks do **not** work inside class members (attributes/methods) — they render as literal text. `\n` does not work anywhere.

## Common Pitfalls
- Relationship syntax is very strict (e.g., `<|--` vs `<--`).
- Auto-layout can become messy with many classes; use namespaces to group them.
- `classDef` is not supported; use `style` for coloring.

## classDef Support
No. Use `style` instead for individual classes.