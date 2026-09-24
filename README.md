# Enhanced Magic 8 Ball Mobile

A portrait-only mobile experience for **Enhanced Magic 8 Ball** that recreates the ritual of the classic toy without collecting the user’s question.

## Experience

1. The user privately thinks of a yes-or-no question.
2. They press the on-screen **Shake the Ball** button.
3. The button is disabled and reads **Shaking** while the ball rocks in place for one second.
4. A random answer appears in the blue answer window and remains until **Ask Again** is pressed.

The product uses the complete curated saying catalog. It preserves 50% affirmative, 25% noncommittal, and 25% negative outcome selection; sayings do not repeat within an outcome category until that category’s deck is exhausted and automatically reshuffled.

## Requirements

- Dark-only, title-free, single-screen UI with no scrolling.
- No physical-device shake or motion-sensor permission; use only the on-screen button.
- Silent, with no haptics.
- No question input, answer history, analytics, or identifiers.
- Fully offline after initial installation/load; keep the no-repeat deck state locally across visits.
- Reduce Motion reveals the answer immediately.

## Product Materials

- [Product specification](Magic%208%20Ball%20--%20Product%20Spec.md)
- `Magic 8 Ball -- Approved Idle UI Concept.png` — approved idle-state visual reference.

## Status

Product requirements and design direction are complete. Implementation is pending.
