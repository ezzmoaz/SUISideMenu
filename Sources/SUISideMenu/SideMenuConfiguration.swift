//
//  SideMenuConfiguration.swift
//  SUISideMenu
//
//  Value type collecting every visual / behavioral knob, with clamping done
//  once at construction. `SideMenu` builds one of these from its convenience
//  initializer, so callers can use either the flat init or pass a fully-formed
//  configuration.
//

import CoreGraphics

public struct SideMenuConfiguration: Equatable, Sendable {

    /// Menu width as a fraction of the container width. Clamped to `0.1...1`.
    public var menuWidth: CGFloat

    /// Drawer transition style.
    public var style: SideMenuStyle

    /// Max blur applied to the main view when open. `slideInOver`/adaptive only.
    public var blur: CGFloat

    /// Min scale applied to the main view when open. Clamped to `0.1...1`.
    public var scale: CGFloat

    /// Max dim opacity over the main view when open. Clamped to `0...1`.
    public var dimValue: CGFloat

    /// Width of the leading-edge drag-to-open zone, in points.
    /// `0` disables drag-to-open entirely (caller drives `isOpen`).
    public var edgeSwipeWidth: CGFloat

    /// Whether to fire impact feedback when the open/closed state commits.
    public var hapticFeedback: Bool

    /// Defer rendering the menu content until first open / drag.
    public var lazyMenu: Bool

    /// On a regular horizontal size class, render as `NavigationSplitView`
    /// instead of an overlay drawer.
    public var adaptive: Bool

    public init(
        menuWidth: CGFloat = 0.6,
        style: SideMenuStyle = .slideInOut,
        blur: CGFloat = 2,
        scale: CGFloat = 1,
        dimValue: CGFloat = 0.2,
        edgeSwipeWidth: CGFloat = 24,
        hapticFeedback: Bool = true,
        lazyMenu: Bool = true,
        adaptive: Bool = false
    ) {
        self.menuWidth = min(max(menuWidth, 0.1), 1)
        self.style = style
        self.blur = max(blur, 0)
        self.scale = min(max(scale, 0.1), 1)
        self.dimValue = min(max(dimValue, 0), 1)
        self.edgeSwipeWidth = max(edgeSwipeWidth, 0)
        self.hapticFeedback = hapticFeedback
        self.lazyMenu = lazyMenu
        self.adaptive = adaptive
    }

    /// Whether drag-to-open is active. Single source of truth — set
    /// `edgeSwipeWidth` to `0` to turn the gesture off.
    var isSwipeEnabled: Bool { edgeSwipeWidth > 0 }
}
