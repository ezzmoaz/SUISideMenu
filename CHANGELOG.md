# Changelog

All notable changes to this project are documented here. The format is based
on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/), and this project
adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [1.0.0] - 2026-06-28

First stable release. Consolidates the `0.x` line into a documented, tested,
SemVer-stable API.

> **Note:** the repository's git history was rewritten on 2026-06-28 to unify
> commit authorship under a single identity. All commit SHAs and the `0.x` tags
> changed. If your package stops resolving, reset SPM caches and re-resolve;
> exact-commit pins must be updated, version-tag pins are unaffected.

### Added
- Public `SideMenuConfiguration` value type and a
  `SideMenu(isOpen:configuration:...)` initializer.
- Community health files: `CONTRIBUTING.md`, `SECURITY.md`.
- `swift-format` configuration.

### Changed
- **Internal restructure.** `SideMenu` is now a thin dispatcher over two
  internal components: `SideMenuDrawer` (overlay) and `SideMenuSplitView`
  (adaptive). No change to the public call site.
- All gesture/geometry math extracted into a pure, unit-tested `SideMenuMath`
  enum. Drag progress, snap thresholds, RTL sign handling, and panel offsets
  are now covered by tests (20 total).
- `SideMenuStyle` no longer carries view logic. The `NavigationSplitView` style
  mapping moved to the view layer: `slideInOver` → `.prominentDetail`,
  `slideInOut` → `.balanced`.

### Removed
- The `swipeable` parameter. Drag-to-open is now governed solely by
  `edgeSwipeWidth` — set it to `0` to disable the gesture.

### Fixed
- Removed a stray `print` that logged on every drag frame.
- Simplified a redundant `scaleEffect` expression in the adaptive path.
- Migrated all `onChange(of:perform:)` calls to the iOS 17 two-parameter form.

## Migration

`swipeable: false` → `edgeSwipeWidth: 0`.

```swift
// before
SideMenu(isOpen: $isOpen, swipeable: isOnDetail ? false : true) { ... } mainView: { ... }

// after
SideMenu(isOpen: $isOpen, edgeSwipeWidth: isOnDetail ? 0 : 24) { ... } mainView: { ... }
```
