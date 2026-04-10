# Contributing

Contributions are welcome. This guide covers how to set up the project, run checks locally, and submit a pull request.

## Development Setup

1. Clone the repository.
2. Install [mise](https://mise.jdx.dev/) and run `mise install` to get the pinned Dart SDK version. Alternatively, install a Dart SDK that satisfies the constraint in `pubspec.yaml` manually.
3. Fetch dependencies:

```sh
dart pub get
```

## Local Verification

Run all of these checks before opening a pull request:

```sh
dart format --output=none --set-exit-if-changed .   # formatting
dart analyze                                          # static analysis
dart test                                             # tests
```

To auto-fix formatting:

```sh
dart format .
```

To run a single test file during development:

```sh
dart test test/device/device_test.dart
```

## Testing Without a Real Device

All unit tests use `FakeCommandSender` (in `test/mocks/fake_command_sender.dart`), an in-memory implementation of `CommandSender` that captures sent commands without opening any real TCP connections. You do not need a Yeelight device to run the test suite.

When adding tests for `Device` behavior, inject `FakeCommandSender` rather than `TCPCommandSender`. Inspect `FakeCommandSender.commands` to assert what was sent.

For discovery tests, `MockRawDatagramSocket` (in `test/mocks/mock_raw_datagram_socket.dart`) is used to simulate UDP responses. Shared test data lives in `test/fixtures/fixtures.dart`.

## Code Guidelines

- Keep the public API stable. Avoid breaking changes unless the change explicitly requires one (see [Breaking Changes](#breaking-changes) below).
- Use `package:` imports everywhere — never relative imports.
- Single quotes for strings, 80-character line limit.
- Prefer small, focused changes over broad refactors.
- Add regression tests for bug fixes, especially around socket and parsing behavior.
- Preserve the current package style and naming conventions.
- Do not add error handling or validation for cases that cannot realistically occur.

## Breaking Changes

A breaking change is anything that requires callers to update their code:

- Removing or renaming a public class, method, getter, or field
- Changing a method signature (parameters, types, return type)
- Changing observable behavior that callers may depend on (e.g. stream events, exception types)

If your change is breaking, bump the **minor** version (e.g. `0.4.0` → `0.5.0`) and document it clearly in `CHANGELOG.md` with a `**BC:**` prefix on the relevant lines.

Non-breaking additions (new methods, new optional parameters) bump the **patch** version.

## Changelog

Update `CHANGELOG.md` with every user-visible change. Follow the existing format:

```
## [x.y.z] - YYYY-MM-DD
* short description of the change [#issue](link) (thanks @contributor)
```

Breaking changes are prefixed with `**BC:**`. Bug fixes should reference the related issue where one exists.

## Pull Requests

- Describe the problem and the change clearly.
- Link related issues when applicable.
- Include any relevant notes about device-specific behavior or environment constraints (e.g. behavior differences between firmware versions or dual-light devices).
- Keep documentation and the changelog in sync when user-facing behavior changes.
- Ensure all three verification commands above pass before requesting review.
