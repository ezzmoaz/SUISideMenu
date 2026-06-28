# SUISideMenu

[![Swift](https://img.shields.io/badge/Swift-5.9-orange.svg?style=flat-square)](https://swift.org)
[![Platform](https://img.shields.io/badge/Platform-iOS%2017%2B-blue.svg?style=flat-square)](https://developer.apple.com/ios/)
[![SPM](https://img.shields.io/badge/SPM-compatible-brightgreen.svg?style=flat-square)](https://swift.org/package-manager/)
[![License](https://img.shields.io/badge/License-MIT-lightgrey.svg?style=flat-square)](LICENSE)

A small, idiomatic SwiftUI side menu container with two slide styles, gesture-driven open/close, accessibility support, full RTL handling, and an optional adaptive `NavigationSplitView` mode for iPad.

> [!IMPORTANT]
> **Repository history was rewritten on 2026-06-28** to unify commit authorship. Every commit SHA changed and the `0.x` tags were re-pointed. If your build stops resolving the package after fetching:
> - **Xcode:** File → Packages → **Reset Package Caches**, then **Resolve Package Versions**.
> - **CLI / CI:** delete `Package.resolved` (and `.build`) and re-resolve.
> - Pinning by an **exact commit SHA**? Update the pin — the old SHAs no longer exist. Pinning by **version tag** keeps working (tags resolve by name).

> If you like SUISideMenu, give it a ★ at the top right of this page.

* [Overview](#overview)
* [Preview](#preview)
* [Requirements](#requirements)
* [Installation](#installation)
* [Usage](#usage)
* [API](#api)
* [Adaptive presentation](#adaptive-presentation)
* [Accessibility](#accessibility)
* [Migrating](#migrating)
* [Contributing](#contributing)
* [Author](#author)
* [License](#license)

## Overview

- Two styles: `slideInOver` and `slideInOut`
- Customisable `menuWidth`, `blur`, `scale`, `dimValue`
- Drag-to-open / drag-to-close with velocity-aware snapping
- `edgeSwipeWidth` controls the leading-edge drag zone; set to `0` to disable drag-to-open
- Adaptive: renders as a `NavigationSplitView` on iPad / regular size classes
- Configure inline or with a reusable `SideMenuConfiguration` value type
- Right-to-left layout handled automatically
- Honours **Reduce Motion**
- Accessibility: side menu marked as modal; the dim overlay is a button labelled "Close menu"
- Pure SwiftUI, no `UIScreen.main.bounds`, no environment-object plumbing, zero dependencies

## Preview

| slideInOver | slideInOut |
| --- | --- |
| ![](https://github.com/ezzmoaz/SUISideMenu/blob/master/Assets/slideInOver.gif) | ![](https://github.com/ezzmoaz/SUISideMenu/blob/master/Assets/slideInOut.gif) |

## Requirements

- Xcode 15+
- Swift 5.9+
- iOS 17+

## Installation

### Swift Package Manager

In Xcode: **File → Add Packages…** and add

```
https://github.com/ezzmoaz/SUISideMenu
```

Or in `Package.swift`:

```swift
.package(url: "https://github.com/ezzmoaz/SUISideMenu", from: "1.0.0"),
```

then add `"SUISideMenu"` to your target's dependencies.

## Usage

```swift
import SwiftUI
import SUISideMenu

struct ContentView: View {
    @State private var isMenuOpen = false

    var body: some View {
        SideMenu(
            isOpen: $isMenuOpen,
            sideMenu: {
                Text("SideMenu")
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .background(Color.red)
            },
            mainView: {
                VStack {
                    Button("Open Menu") {
                        withAnimation { isMenuOpen = true }
                    }
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .background(Color.blue)
            }
        )
    }
}
```

Customised:

```swift
SideMenu(
    isOpen: $isMenuOpen,
    menuWidth: 0.6,            // 0.1 … 1
    menuStyle: .slideInOver,   // .slideInOver | .slideInOut
    blur: 2,                   // ≥ 0  (slideInOver only)
    scale: 1,                  // 0.1 … 1 (slideInOver only)
    dimValue: 0.2,             // 0 … 1
    edgeSwipeWidth: 24,        // leading-edge drag zone width in pt; 0 disables drag-to-open
    hapticFeedback: true,      // impact feedback when state toggles
    lazyMenu: true,            // defer rendering of sideMenu until first open
    adaptive: false,           // use NavigationSplitView on regular size class
    sideMenu: { /* … */ },
    mainView: { /* … */ }
)
```

Or build a reusable `SideMenuConfiguration` and pass it directly:

```swift
let config = SideMenuConfiguration(menuWidth: 0.75, style: .slideInOut, dimValue: 0.3)

SideMenu(isOpen: $isMenuOpen, configuration: config) {
    /* … */
} mainView: {
    /* … */
}
```

## API

| Parameter | Type | Default | Notes |
| --- | --- | --- | --- |
| `isOpen` | `Binding<Bool>` | — | Drives open/close from the caller. |
| `menuWidth` | `CGFloat` | `0.6` | Percentage of container width. Clamped to `0.1…1`. |
| `menuStyle` | `SideMenuStyle` | `.slideInOut` | `.slideInOver` overlays; `.slideInOut` pushes. |
| `blur` | `CGFloat` | `2` | Max blur applied to the main view when open. `slideInOver` only. |
| `scale` | `CGFloat` | `1` | Min scale applied to the main view when open. `slideInOver` only. |
| `dimValue` | `CGFloat` | `0.2` | Max dim opacity over the main view when open. |
| `edgeSwipeWidth` | `CGFloat` | `24` | Width in pt of the leading-edge drag zone. `0` disables drag-to-open (caller must drive `isOpen` from a button). |
| `hapticFeedback` | `Bool` | `true` | Whether to fire `UIImpactFeedbackGenerator` on commit. |
| `lazyMenu` | `Bool` | `true` | When `true`, `sideMenu` is not in the view tree until the first open or drag — defers its `body`, `onAppear`, and `@StateObject` setup. |
| `adaptive` | `Bool` | `false` | When `true` and the horizontal size class is `.regular` (iPad, Mac), the component renders as `NavigationSplitView { sideMenu } detail: { mainView }` instead of a drawer. Compact size class keeps the drawer. |

`menuWidth`, `scale`, and `dimValue` are clamped to their valid ranges at construction, so out-of-range values can't break layout.

### Initializers

`SideMenu` has two equivalent initializers:

- `SideMenu(isOpen:menuWidth:menuStyle:…:sideMenu:mainView:)` — the flat form above.
- `SideMenu(isOpen:configuration:sideMenu:mainView:)` — pass a `SideMenuConfiguration` value.

`SideMenuConfiguration` exposes the same fields as the table above and is `Equatable` / `Sendable`, so you can define reusable presets and share them across screens:

```swift
enum MenuPresets {
    static let standard = SideMenuConfiguration(menuWidth: 0.6, style: .slideInOut)
    static let wide     = SideMenuConfiguration(menuWidth: 0.85, style: .slideInOver, blur: 4)
}

SideMenu(isOpen: $isOpen, configuration: MenuPresets.wide) { … } mainView: { … }
```

## Adaptive presentation

One component, the right pattern on every device. With `adaptive: true`, `SUISideMenu` **fills the gap between iPhone and iPad**: it provides a hand-built drawer where the platform has no native one (iPhone / compact), and steps aside for Apple's native `NavigationSplitView` where the platform does (iPad / regular). You write the screen once and get the idiomatic presentation for each.

| iPad — native split view (`adaptive: true`) |
| --- |
| ![](https://github.com/ezzmoaz/SUISideMenu/blob/master/Assets/ipad.gif) |

You get the native `NavigationSplitView` behaviour **only when both conditions are true**:

1. `adaptive: true` is passed to `SideMenu`, **and**
2. the horizontal size class is `.regular` — i.e. iPad (most layouts), iPad-style multitasking, or Mac.

In every other case — `adaptive: false`, or a compact size class such as iPhone (and iPad in a narrow Slide Over / Split View window) — you get the overlay drawer. The same `sideMenu` and `mainView` content is reused either way, so you write the screen once.

```swift
SideMenu(isOpen: $isOpen, adaptive: true) { … } mainView: { … }
//                        ▲ split view on iPad, drawer on iPhone
```

The library does not impose a selection model; wire your own `@State` into a `List(selection:)` inside `sideMenu` and read it from `mainView`:

```swift
struct AdaptiveShell: View {
    @State private var selection: Item? = .home
    @State private var isOpen = false

    var body: some View {
        SideMenu(isOpen: $isOpen, adaptive: true) {
            List(Item.allCases, selection: $selection) { item in
                NavigationLink(value: item) {
                    Label(item.title, systemImage: item.icon)
                }
            }
        } mainView: {
            DetailView(item: selection)
        }
    }
}
```

Notes:

- Drawer on iPhone, persistent sidebar on iPad — selection state survives size-class flips (rotation, Stage Manager, Slide Over).
- On iPhone the caller adds a hamburger button bound to `isOpen`. On iPad `NavigationSplitView`'s system column-toggle covers it; `isOpen` and edge-swipe are inert.
- The chosen `menuStyle` maps to a split-view style: `.slideInOver` → `.prominentDetail`, `.slideInOut` → `.balanced`.

## Accessibility

- Side menu container carries `.accessibilityAddTraits(.isModal)` when open.
- Dim overlay is hit-testable only while open, exposed as a button with the label `"Close menu"`.
- When the menu is open, the main view is hidden from the accessibility tree; when closed, the menu is hidden.
- Snap animation falls back to a linear curve when **Reduce Motion** is enabled.
- Layout mirrors automatically under RTL (`\.layoutDirection == .rightToLeft`).

## Migrating

### From the `swipeable` parameter

`swipeable` was removed — drag-to-open is governed solely by `edgeSwipeWidth`:

```diff
- SideMenu(isOpen: $isOpen, swipeable: isAtRoot) { ... } mainView: { ... }
+ SideMenu(isOpen: $isOpen, edgeSwipeWidth: isAtRoot ? 24 : 0) { ... } mainView: { ... }
```

### From pre-1.0 versions

Early `0.x` releases required an `EnvironmentObject` (`UIStateModel`) wired up at the scene level. `1.0` replaces it with a plain `Binding<Bool>`.

```diff
- // App / SceneDelegate
- ContentView().environmentObject(UIStateModel())

- // ContentView
- @EnvironmentObject var UIState: UIStateModel
- SideMenu(sideMenu: { ... }, mainView: { ... })
-     .environmentObject(UIStateModel())
+ @State private var isMenuOpen = false
+ SideMenu(isOpen: $isMenuOpen, sideMenu: { ... }, mainView: { ... })

- self.UIState.toggleMenuScreen()
+ withAnimation { isMenuOpen.toggle() }
```

`MenuStyle` is renamed to `SideMenuStyle` to stop colliding with SwiftUI's `MenuStyle` protocol. A deprecated `typealias MenuStyle = SideMenuStyle` is provided for one release.

## Contributing

Contributions are welcome — see [CONTRIBUTING.md](CONTRIBUTING.md) for setup,
tests, and the pull-request checklist. Security reports go to
[SECURITY.md](SECURITY.md).

This is an iOS-only package, so test against an iOS simulator:

```bash
xcodebuild -scheme SUISideMenu \
  -destination 'platform=iOS Simulator,name=iPhone 15' test
```

## Credits

Inspired by [Implementing Snap Carousel in SwiftUI](https://medium.com/flawless-app-stories/implementing-snap-carousel-in-swiftui-3ae084504670).

## Author

Moaz Ezz — moazezz45@gmail.com

## License

SUISideMenu is available under the MIT license. See the [LICENSE](LICENSE) file for more info.
