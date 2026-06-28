# Contributing to SUISideMenu

Thanks for taking the time to contribute! This document explains how to propose
changes and what to expect.

## Getting set up

This is an **iOS-only** package (it uses UIKit and iOS-only SwiftUI APIs), so
`swift build` on a macOS host won't work — build and test against an iOS
destination:

```bash
git clone https://github.com/ezzmoaz/SUISideMenu
cd SUISideMenu

# Open in Xcode and run the SUISideMenu scheme, or:
xcodebuild -scheme SUISideMenu \
  -destination 'platform=iOS Simulator,name=iPhone 15' test
```

The example app lives in `Example/SUISideMenuExample`. Open its `.xcodeproj` to
run the library in a real app target.

## Before you open a pull request

1. **Open an issue first** for anything beyond a small fix, so we can agree on
   the approach before you invest time.
2. **Add or update tests.** Logic lives in `SideMenuMath` and
   `SideMenuConfiguration` as pure, testable code — new behavior should be
   covered there. Run `swift test` and make sure everything passes.
3. **Keep the public API small.** New configuration belongs on
   `SideMenuConfiguration`, not as another initializer parameter, unless there's
   a strong reason.
4. **Format your code** with `swift-format` (see `.swift-format`):
   `swift format lint --recursive --strict Sources Tests`
5. **Update the docs** — doc comments on public API and the `README` API table.
6. **Add a CHANGELOG entry** under `## [Unreleased]`.

## Commit messages

Write clear, imperative commit subjects ("Fix RTL drag direction", not "fixed
stuff"). Reference the issue number where relevant.

## Code style

- Public types and members carry doc comments.
- Prefer pure functions for anything testable; keep SwiftUI views thin.
- No force-unwraps in library code.
- Match the surrounding code's conventions.

## Reporting bugs

Use the issue template. Include the iOS version, device/simulator, a minimal
reproduction, and what you expected versus what happened.

## License

By contributing, you agree that your contributions are licensed under the
[MIT License](LICENSE).
