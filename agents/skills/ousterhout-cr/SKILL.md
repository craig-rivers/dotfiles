---
name: ousterhout-cr
description: Reference material — John Ousterhout's "A Philosophy of Software Design" principles for code review and architecture analysis.
user_invocable: false
---

# Ousterhout's "A Philosophy of Software Design" — Key Principles

## Module Depth
A module's interface should be much simpler than its implementation. Deep modules hide complexity behind simple interfaces. Shallow modules (complex interface, little hidden functionality) are a red flag.

## Information Hiding
Each module should encapsulate knowledge that is not needed by other modules. When information leaks across module boundaries, changes ripple unnecessarily.

## Pull Complexity Downward
It's better for a module to handle complexity internally than to push it to callers. If a module can simplify its interface by doing more work internally, it should.

## Change Amplification
A design where a simple change requires modifying many places indicates poor information hiding or missing abstractions.

## Cognitive Load
Code should minimize the amount a developer needs to know to work with it. More conditions, special cases, and implicit dependencies increase cognitive load.

## Interface Design
Interfaces should be designed for the common case. Make the common case simple and the rare case possible. Default values, sensible conventions, and progressive disclosure all help.

## Layer Quality
Each layer of abstraction should provide a meaningful transformation or simplification. Pass-through layers that add no value are complexity without benefit.

## Consistency
Similar things should be done in similar ways. Inconsistency forces developers to learn multiple patterns where one would suffice.

## Error Strategy
Define errors out of existence where possible. Instead of checking for and handling edge cases, design the interface so they can't occur.

## Comments as Design
Comments should describe things that are not obvious from the code — the "why", not the "what". If code needs a comment to explain what it does, consider whether the code could be clearer instead.

## Strategic vs Tactical Programming
Tactical programming focuses on getting the current task done quickly. Strategic programming invests in good design that pays off across many future tasks. Most systems suffer from too much tactical programming.
