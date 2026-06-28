//
//  SideMenu.swift
//  SUISideMenu
//
//  Created by Moaz Ezz on 9/20/20.
//  Copyright © 2020 moazezz. All rights reserved.
//
//  Public entry point. Holds configuration + the open binding and dispatches
//  to one of two internal components:
//    - SideMenuSplitView  (adaptive on regular size class)
//    - SideMenuDrawer     (overlay drawer everywhere else)
//

import SwiftUI

@MainActor
public struct SideMenu<SideMenuContent: View, MainContent: View>: View {
    private let config: SideMenuConfiguration
    private let sideMenu: SideMenuContent
    private let mainView: MainContent

    @Binding private var isOpen: Bool
    @Environment(\.horizontalSizeClass) private var horizontalSizeClass

    /// Configuration-based initializer.
    public init(
        isOpen: Binding<Bool>,
        configuration: SideMenuConfiguration,
        @ViewBuilder sideMenu: () -> SideMenuContent,
        @ViewBuilder mainView: () -> MainContent
    ) {
        self._isOpen = isOpen
        self.config = configuration
        self.sideMenu = sideMenu()
        self.mainView = mainView()
    }

    /// Convenience initializer with flat parameters. Values are clamped by
    /// `SideMenuConfiguration`.
    public init(
        isOpen: Binding<Bool>,
        menuWidth: CGFloat = 0.6,
        menuStyle: SideMenuStyle = .slideInOut,
        blur: CGFloat = 2,
        scale: CGFloat = 1,
        dimValue: CGFloat = 0.2,
        edgeSwipeWidth: CGFloat = 24,
        hapticFeedback: Bool = true,
        lazyMenu: Bool = true,
        adaptive: Bool = false,
        @ViewBuilder sideMenu: () -> SideMenuContent,
        @ViewBuilder mainView: () -> MainContent
    ) {
        self.init(
            isOpen: isOpen,
            configuration: SideMenuConfiguration(
                menuWidth: menuWidth,
                style: menuStyle,
                blur: blur,
                scale: scale,
                dimValue: dimValue,
                edgeSwipeWidth: edgeSwipeWidth,
                hapticFeedback: hapticFeedback,
                lazyMenu: lazyMenu,
                adaptive: adaptive
            ),
            sideMenu: sideMenu,
            mainView: mainView
        )
    }

    @ViewBuilder
    public var body: some View {
        if config.adaptive, horizontalSizeClass == .regular {
            SideMenuSplitView(
                config: config,
                sideMenu: sideMenu,
                mainView: mainView,
                isOpen: $isOpen
            )
        } else {
            SideMenuDrawer(
                config: config,
                sideMenu: sideMenu,
                mainView: mainView,
                isOpen: $isOpen
            )
        }
    }

    #if DEBUG
        var configForTesting: SideMenuConfiguration { config }
    #endif
}
