# OTP Homework — Stopwatch (Flutter)

A small, well-structured Stopwatch app built with Flutter + Riverpod.

## Features

- Start / Pause / Reset stopwatch
- Lap recording (lap + total times)
- Lap list with clear action
- Digital + analog clock visualization
- Deterministic time/ticking via abstractions (test-friendly)

---

## Tech stack

- **Flutter** (Material 3)
- **State management**: `flutter_riverpod`
- **Architecture**: feature-based + layered (domain / application / presentation)
- **Testing**: `flutter_test` + Riverpod overrides

---

## Project structure

High-level overview (see `doc/ARCHITECTURE.md` for details):

---

## Getting started

### Requirements

- Flutter SDK (matching your environment)
- Dart SDK: see `pubspec.yaml` (`environment: sdk: ^3.11.0`)

### Install dependencies

- `flutter pub get` (bash)

### Run tests

- `flutter test` (bash)

### Run the app

- `flutter run` (bash)


---

## Design notes

### Time is abstracted for testability

The app does not hardcode `DateTime.now()` everywhere. Instead:

- `nowProvider` provides a `DateTime Function()` (overridable in tests)
- `TickSource` provides a ticking mechanism (real ticker in production, manual ticks in tests)

This enables deterministic tests for “pause freezes time” and similar behaviors.

### Theme colors are centralized

`AppColors` is implemented as a `ThemeExtension`, so UI reads colors via:

- `context.appColors`

This keeps widgets clean and avoids passing color palettes through constructors.

---

## Documentation

- Architecture & data flow: `doc/ARCHITECTURE.md`
- Testing strategy: `doc/TESTING.md`

---

## License

This project is for homework / educational purposes.
