# State Diagram

## When to Use
- Modeling object lifecycle or system states.
- Showing valid transitions between states.
- Concurrent / parallel state regions.
- Nested (composite) state machines.

## Syntax Reference

### Basic Example
```mermaid
stateDiagram-v2
    [*] --> Idle
    Idle --> Processing : submit
    Processing --> Done : complete
    Processing --> Error : fail
    Error --> Idle : retry
    Done --> [*]
```

### Long Labels (use `<br>` for line breaks)
```mermaid
stateDiagram-v2
    state "A Really Long State Name<br>That Should Wrap" as LongState
    state "Another Ridiculously Long State Name<br>That Also Wraps" as RidiculousState
    [*] --> LongState : Trigger
    LongState --> RidiculousState : AnotherTrigger
    RidiculousState --> [*]
```

### Multi-Line State Values
```mermaid
stateDiagram-v2
    state "First Line<br>Second Line<br>Third Line" as MultiLineState
    [*] --> MultiLineState
    MultiLineState --> FinalState
    state "Ending<br>Line 1<br>Line 2<br>Line 3" as FinalState
```

### Composite and Concurrent States
```mermaid
stateDiagram-v2
    direction LR
    [*] --> CompositeState
    state CompositeState {
        direction TB
        [*] --> SubState1
        SubState1 --> SubState2 : Event1
        --
        [*] --> ConcurrentStateA
        ConcurrentStateA --> ConcurrentStateB : Event2
    }
    CompositeState --> [*]
```

### Edge Case: Deeply Nested Composite States
```mermaid
stateDiagram-v2
    [*] --> SystemActive
    state SystemActive {
        [*] --> Initializing
        Initializing --> Running : boot_complete

        state Running {
            [*] --> NormalOps
            NormalOps --> Degraded : partial_failure
            Degraded --> NormalOps : recovered

            state NormalOps {
                [*] --> Listening
                Listening --> Handling : request_in
                Handling --> Listening : response_sent
            }
        }

        Running --> ShuttingDown : shutdown_signal
        ShuttingDown --> [*]
    }
    SystemActive --> [*]
```

### Edge Case: Concurrent Regions with Dense Transitions
```mermaid
stateDiagram-v2
    direction LR
    [*] --> Active
    state Active {
        direction TB
        state "Network Layer<br>Manages connections" as Network
        state "Business Logic<br>Processes requests" as Logic
        state "Persistence<br>Handles storage" as Storage

        [*] --> Network
        Network --> Logic : validated
        Logic --> Storage : persist
        Storage --> Network : ack
        --
        [*] --> HealthCheck
        HealthCheck --> HealthCheck : poll_interval
        note right of HealthCheck : Runs independently<br>of main pipeline
    }
    Active --> [*]
```

## All Supported Syntax

- **Keyword**: `stateDiagram-v2` (always use v2).
- **States**: Plain `StateName` or aliased `state "Description" as Alias`.
- **Transitions**: `StateA --> StateB : label`.
- **Start/End**: `[*]` for both initial and final pseudo-states.
- **Composite**: `state Parent { ... }` with nested states inside.
- **Concurrent regions**: `--` separator inside a composite state.
- **Direction**: `direction LR` or `direction TB` (inside composite states too).
- **Choice**: `state choice <<choice>>` for conditional branching.
- **Fork/Join**: `state fork <<fork>>` and `state join <<join>>`.
- **Notes**: `note right of State : text` or `note left of State : text`.
- **Line breaks**: Use `<br>` inside quoted state descriptions. `\n` does **not** work — it renders as literal text.

## Layout Tips (type-specific)
- Use `direction LR` for wide, shallow machines; `direction TB` (default) for deep ones.
- Declare states in transition order to help the layout engine.
- Keep composite states to 2 nesting levels max — beyond that, split into separate diagrams.
- Concurrent regions (`--`) work best with 2 regions; 3+ can produce cramped layouts.

## Common Pitfalls
- **Using `\n` for line breaks** — Always use `<br>` in quoted state descriptions. `\n` renders as literal text.
- **Missing `end` or `}`** — Every composite state `state Name { ... }` needs its closing brace.
- **Mixing v1 and v2 syntax** — Always use `stateDiagram-v2`. The v1 syntax lacks features and has layout quirks.
- **Over-nesting composites** — 3+ nesting levels become unreadable. Split into separate diagrams.
- **Concurrent region overuse** — More than 2 concurrent regions in one composite state produces cramped layouts.

## classDef Support
Limited. `classDef` can style states in v2: `classDef myStyle fill:#f9f,stroke:#333` then `StateName:::myStyle`.
