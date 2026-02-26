# Architecture

This document explains the structure and data flow of the Stopwatch app.

## Goals

- Clear separation of responsibilities
- Testable business logic (without Flutter widgets)
- Deterministic integration tests (manual time + manual ticks)
- Simple, maintainable feature structure

---

## Layers (Stopwatch feature)

Folder: `lib/features/stopwatch/`

### 1) Domain (`domain/`)

**Pure Dart**, no Flutter dependencies. Contains immutable models:

- `StopwatchState`
    - `isRunning: bool`
    - `elapsed: Duration`
    - `laps: List<Lap>`
- `Lap`
    - `index: int`
    - `lap: Duration` (delta since previous lap)
    - `total: Duration` (total elapsed at lap time)

Principle: Domain types should be boring and predictable.

### 2) Application (`application/`)

Contains business logic and state transitions:

- `StopwatchController` (Riverpod `Notifier<StopwatchState>`)
    - `start(now)`
    - `pause(now)`
    - `tick(now)`
    - `lap(now)`
    - `reset()`
    - `clearLaps()`

Provider wiring:

- `stopwatchProvider` exposes `StopwatchState` and the controller.

Key rule: **The controller is the single source of truth** for stopwatch state.

### 3) Presentation (`presentation/`)

Flutter UI:

- `StopwatchScreen` orchestrates:
    - reading state (`ref.watch(stopwatchProvider)`)
    - calling controller actions (`ref.read(stopwatchProvider.notifier)`)
    - providing tick source (production vs. injected)

Widgets:
- `DigitalClock`: renders formatted elapsed time
- `AnalogClock`: custom painter visualization
- `LapList`: lap list rendering + clear button

---

## Core modules

### `core/time`

Purpose: abstract the “current time” and “tick stream” for testability.

- `nowProvider`: provides `DateTime Function()`
    - Production: `DateTime.now`
    - Tests: overridden with a controlled `now` variable
- `TickSource`: interface for a ticking mechanism
- `TickerTickSource`: real implementation using Flutter’s `Ticker`
- `tickSourceProvider`: a provider that **must be overridden**
    - In production: `StopwatchScreen` supplies a `TickerTickSource`
    - In tests: override with `ManualTickSource`

### `core/theme`

- `AppColors`: `ThemeExtension` holding the app palette
- `ThemeOwn` on `BuildContext`:
    - `context.appColors` to access the palette from widgets

### `core/format`

- `DurationFormat`: formatting utilities for UI (`stopwatch`, `short`)
- Pure Dart → easy to unit-test and reuse

---

## Data flow (runtime)

1. UI calls controller actions (e.g. Start, Pause, Lap)
2. Controller updates immutable `StopwatchState`
3. Widgets rebuild from `ref.watch(stopwatchProvider)`
4. Tick source periodically calls `controller.tick(now)` while running

---

## Data flow (tests)

Widget tests:
- Use `ProviderContainer(overrides: ...)`
- Override:
    - `tickSourceProvider` with `ManualTickSource`
    - `nowProvider` with a deterministic `() => now`
- Emit ticks manually: `manual.emit(now)`

This guarantees stable, fast tests without relying on real time.