# Testing

This project contains both unit and widget tests.

## Test types

### 1) Unit tests — controller behavior

File: `test/stopwatch_controller_test.dart`

Focus:
- elapsed calculation
- pause/resume semantics
- lap calculations
- reset/clear behavior
- idempotency (calling start twice, etc.)

Why unit tests?
- Fast feedback
- No widget pumping
- Deterministic state transitions

### 2) Widget tests — screen integration

File: `test/stopwatch_widget_test.dart`

Focus:
- UI updates after ticks
- Buttons reflect running/paused state
- Lap appears in list
- Reset clears UI

## How determinism is achieved

### Override "now"

Override `nowProvider` so the app reads time from a controlled variable.

### Override "tick source"

Override `tickSourceProvider` with `ManualTickSource`, then emit ticks directly.
This avoids flaky tests caused by timers/tickers.

## Tips

- Prefer unit tests for business logic.
- Use widget tests for verifying wiring + UI behavior.
- Keep UI formatting in pure Dart helpers (`core/format`) to simplify testing.