# ER Diagram

## When to Use
- Database schema design and entity relationship mapping.
- Primary/foreign key structures and cardinalities.
- Data modeling and structural documentation of data stores.

## Syntax Reference

### Basic Example
```mermaid
erDiagram
    USER {
        string id PK
        string email
    }
    ORDER {
        string id PK
        string userId FK
    }
    USER ||--o{ ORDER : places
```

### Extended Example (with styling)
```mermaid
erDiagram
    CUSTOMER ||--o{ ORDER : places
    ORDER ||--|{ LINE-ITEM : contains
    CUSTOMER }|..|{ DELIVERY-ADDRESS : uses

    CUSTOMER {
        string name
        string custNumber PK
        string email
    }
    ORDER {
        int orderNumber PK
        string deliveryAddress FK
    }
    LINE-ITEM {
        string productCode
        int quantity
        float price
    }
```

### Edge-Case Examples
#### Highly Connected Entities
```mermaid
erDiagram
    ENTITY1 ||--o{ ENTITY2 : owns
    ENTITY1 ||--o| ENTITY3 : categorizes
    ENTITY1 |o--|| ENTITY4 : "relates to"
    ENTITY2 }o--o{ ENTITY3 : shares
    ENTITY3 }|--o{ ENTITY4 : maps

    ENTITY1 {
        string id PK
        string name
    }
    ENTITY2 {
        int id PK
        int entity1_id FK
    }
    ENTITY3 {
        float value
        int entity2_id FK
    }
    ENTITY4 {
        date creationDate
    }
```

#### Long Relationship Descriptions
ER relationship labels have inconsistent `<br>` support across renderers — works in mmdc CLI but fails in IntelliJ's Mermaid plugin (renders literal `<br>`). Keep labels short and single-line for maximum compatibility.
```mermaid
erDiagram
    PRODUCT ||--o{ CATEGORY : "assigned as sub-class"
    USER ||--o{ PERMISSION : "grants conditionally"

    PRODUCT {
        string id PK
        string label
    }
    CATEGORY {
        string id PK
        string description
    }
    USER {
        string id PK
        string login
    }
    PERMISSION {
        int id PK
        string action
    }
```

## All Supported Syntax

- **Keyword**: `erDiagram`.
- **Entity Block**: `ENTITY { type name [key] }`.
- **Data Types**: `string`, `int`, `float`, `boolean`, `date`, `datetime`.
- **Keys**: `PK` (Primary Key), `FK` (Foreign Key), `UK` (Unique Key).
- **Relationship Syntax**:
    - `||--||` One-to-one
    - `||--o{` One-to-many (zero or more)
    - `||--|{` One-to-many (one or more)
    - `}o--o{` Many-to-many (zero or more)
    - `}|..|{` Many-to-many (one or more)
- **Relationship Style**:
    - `--` Solid line (identifying relationship)
    - `..` Dotted line (non-identifying relationship)
- **Relationship Label**: `ENTITY1 }|--|{ ENTITY2 : "label"`.

## Layout Tips (type-specific)
- Declare the entity with the most relationships first to help the layout engine center it.
- Declare each related entity immediately following the relation that introduces it — this helps the layout engine place connected entities adjacent to each other.
- Chain related entities outward from the center.
- Capitalize entity names by convention to improve readability.
- **Line breaks**: ER relationship labels have inconsistent `<br>` support across renderers (works in mmdc CLI but fails in IntelliJ). Keep labels short and single-line for maximum compatibility. `<br>` works in entity attribute comments but not in entity names. `\n` does **not** work anywhere — it renders as literal text.

## Common Pitfalls
- Cardinality syntax is very specific and can be hard to remember.
- Relation lines can cross frequently; order declarations to minimize this.
- Ensure all foreign keys correctly point to the intended primary keys.

## classDef Support
No.