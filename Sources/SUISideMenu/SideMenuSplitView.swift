//
//  SideMenuSplitView.swift
//  SUISideMenu
//
//  Adaptive implementation: renders the menu as a native NavigationSplitView
//  sidebar on regular size classes. Selected by `SideMenu` when
//  `config.adaptive` is on and the horizontal size class is `.regular`.
//

import SwiftUI

@MainActor
struct SideMenuSplitView<SideMenuContent: View, MainContent: View>: View {
    let config: SideMenuConfiguration
    let sideMenu: SideMenuContent
    let mainView: MainContent
    @Binding var isOpen: Bool

    @State private var columnVisibility: NavigationSplitViewVisibility = .detailOnly

    var body: some View {
        splitView
            .onChange(of: isOpen) { _, newValue in
                columnVisibility = newValue ? .all : .detailOnly
            }
            .onChange(of: columnVisibility) { _, newValue in
                withAnimation {
                    isOpen = (newValue != .detailOnly)
                }
            }
            .onAppear {
                columnVisibility = isOpen ? .all : .detailOnly
            }
    }

    /// The split view with the style mapped from `config.style`.
    /// `slideInOver` → `.prominentDetail` (detail stays on top, overlay feel),
    /// `slideInOut` → `.balanced` (columns share space, push feel).
    @ViewBuilder
    private var splitView: some View {
        switch config.style {
        case .slideInOver:
            base.navigationSplitViewStyle(.prominentDetail)
        case .slideInOut:
            base.navigationSplitViewStyle(.balanced)
        }
    }

    private var base: some View {
        let overlayActive = isOpen && config.dimValue > 0
        return NavigationSplitView(columnVisibility: $columnVisibility) {
            sideMenu
                .toolbar(removing: .sidebarToggle)
        } detail: {
            ZStack(alignment: .topLeading) {
                mainView
                    .accessibilityHidden(isOpen)
                    .blur(radius: isOpen ? config.blur : 0)
                    .scaleEffect(isOpen ? config.scale : 1)

                Color.black.ignoresSafeArea()
                    .opacity(Double(isOpen ? config.dimValue : 0))
                    .allowsHitTesting(overlayActive)
                    .onTapGesture { withAnimation { isOpen = false } }
            }
        }
    }
}
