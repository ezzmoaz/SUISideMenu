//
//  NavigationExample.swift
//  SUISideMenuExample
//
//  Demonstrates disabling the edge-swipe once a screen is pushed, so the
//  drawer gesture doesn't fight the navigation back-swipe. The whole trick is:
//
//      edgeSwipeWidth: path.isEmpty ? 24 : 0
//
//  When `path` is empty (root) the edge-swipe is on; after a push it's off.
//

import SwiftUI
import SUISideMenu

struct NavigationExample: View {
    @State private var isOpen = false
    @State private var path = NavigationPath()

    var body: some View {
        SideMenu(
            isOpen: $isOpen,
            edgeSwipeWidth: path.isEmpty ? 24 : 0,
            sideMenu: { menu },
            mainView: { content }
        )
    }

    private var menu: some View {
        VStack(spacing: 16) {
            Text("Menu")
                .font(.title3.bold())
            Button("Close Menu") {
                withAnimation { isOpen = false }
            }
            .buttonStyle(.bordered)
            .tint(.white)
            Spacer()
        }
        .padding(.top, 60)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .foregroundStyle(.white)
        .background(Color.red)
    }

    private var content: some View {
        NavigationStack(path: $path) {
            ScreenBody(
                title: "Root",
                badge: "edge-swipe ON",
                badgeColor: .green,
                message: "Swipe from the left edge to open the menu — it's enabled here.\n\nThen push a screen: the edge-swipe turns off so it won't fight the navigation back-swipe.",
                nextLevel: 1,
                onMenu: { withAnimation { isOpen = true } }
            )
            .navigationDestination(for: Int.self) { level in
                ScreenBody(
                    title: "Level \(level)",
                    badge: "edge-swipe OFF",
                    badgeColor: .orange,
                    message: "Edge-swipe is disabled here. Swiping from the left edge performs the navigation back gesture, not the menu.\n\nPop back to the root and it's enabled again.",
                    nextLevel: level + 1,
                    onMenu: nil
                )
            }
        }
    }
}

// MARK: - Shared screen body

private struct ScreenBody: View {
    let title: String
    let badge: String
    let badgeColor: Color
    let message: String
    let nextLevel: Int
    /// Non-nil only on the root, where the hamburger should appear.
    let onMenu: (() -> Void)?

    var body: some View {
        VStack(spacing: 20) {
            Text(badge)
                .font(.caption.bold())
                .padding(.horizontal, 12)
                .padding(.vertical, 6)
                .background(Capsule().fill(badgeColor.opacity(0.2)))
                .foregroundStyle(badgeColor)

            Text(message)
                .multilineTextAlignment(.center)
                .foregroundStyle(.secondary)
                .padding(.horizontal)

            NavigationLink("Push a screen", value: nextLevel)
                .buttonStyle(.borderedProminent)
        }
        .padding()
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.blue.opacity(0.06))
        .navigationTitle(title)
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            if let onMenu {
                ToolbarItem(placement: .topBarLeading) {
                    Button(action: onMenu) {
                        Image(systemName: "line.3.horizontal")
                    }
                }
            }
        }
    }
}

#Preview {
    NavigationExample()
}
