//
//  SideMenuDrawer.swift
//  SUISideMenu
//
//  Overlay-drawer implementation. Used for compact size classes (and any time
//  `adaptive` is off). Pure rendering over `SideMenuMath`.
//

import SwiftUI

@MainActor
struct SideMenuDrawer<SideMenuContent: View, MainContent: View>: View {
    let config: SideMenuConfiguration
    let sideMenu: SideMenuContent
    let mainView: MainContent
    @Binding var isOpen: Bool

    @State private var dragTranslation: CGFloat = 0
    @State private var hasShownMenu = false

    @Environment(\.layoutDirection) private var layoutDirection
    @Environment(\.accessibilityReduceMotion) private var reduceMotion

    var body: some View {
        GeometryReader { proxy in
            let size = proxy.size
            let menuPx = size.width * config.menuWidth
            let sign = SideMenuMath.sign(isRTL: layoutDirection == .rightToLeft)
            let progress = SideMenuMath.progress(
                isOpen: isOpen, dragTranslation: dragTranslation, menuPx: menuPx, sign: sign
            )

            ZStack(alignment: .topLeading) {
                content(size: size, menuPx: menuPx, sign: sign, progress: progress)
                edgeDragZone(menuPx: menuPx, sign: sign, size: size)
            }
            .frame(width: size.width, height: size.height)
            .onChange(of: isOpen) { _, newValue in
                if newValue { hasShownMenu = true }
            }
            .onChange(of: dragTranslation) { _, newValue in
                if newValue != 0 { hasShownMenu = true }
            }
            .onChange(of: config.isSwipeEnabled) { _, enabled in
                if !enabled, isOpen {
                    withAnimation(snapAnimation) {
                        isOpen = false
                        dragTranslation = 0
                    }
                }
            }
        }
    }

    /// Render the menu only once it has been needed, when `lazyMenu` is on.
    private var shouldRenderMenu: Bool {
        !config.lazyMenu || isOpen || hasShownMenu || dragTranslation != 0
    }

    @ViewBuilder
    private func content(size: CGSize, menuPx: CGFloat, sign: CGFloat, progress: CGFloat) -> some View {
        let width = size.width
        let menuX = SideMenuMath.menuOffsetX(
            progress: progress, menuPx: menuPx, containerWidth: width, sign: sign)
        let mainShift = SideMenuMath.mainShiftX(progress: progress, menuPx: menuPx, sign: sign)
        let overlayActive = progress > 0.001

        switch config.style {
        case .slideInOver:
            mainView
                .frame(width: width, height: size.height)
                .blur(radius: config.blur * progress)
                .scaleEffect(1 - (1 - config.scale) * progress)
                .accessibilityHidden(isOpen)

            dimOverlay(
                width: width, height: size.height, progress: progress, active: overlayActive, menuPx: menuPx,
                sign: sign)

            menuPanel(menuPx: menuPx, height: size.height, offsetX: menuX, sign: sign)

        case .slideInOut:
            ZStack(alignment: .topLeading) {
                mainView
                    .frame(width: width, height: size.height)
                    .accessibilityHidden(isOpen)

                dimOverlay(
                    width: width, height: size.height, progress: progress, active: overlayActive,
                    menuPx: menuPx, sign: sign)
            }
            .frame(width: width, height: size.height)
            .offset(x: mainShift)
            .blur(radius: config.blur * progress)
            .scaleEffect(1 - (1 - config.scale) * progress)

            menuPanel(menuPx: menuPx, height: size.height, offsetX: menuX, sign: sign)
        }
    }

    @ViewBuilder
    private func menuPanel(menuPx: CGFloat, height: CGFloat, offsetX: CGFloat, sign: CGFloat) -> some View {
        if shouldRenderMenu {
            sideMenu
                .frame(width: menuPx, height: height)
                .offset(x: offsetX)
                .accessibilityElement(children: .contain)
                .accessibilityAddTraits(.isModal)
                .accessibilityHidden(!isOpen)
                .transition(.move(edge: sign > 0 ? .leading : .trailing))
        }
    }

    private func dimOverlay(
        width: CGFloat, height: CGFloat, progress: CGFloat, active: Bool, menuPx: CGFloat, sign: CGFloat
    ) -> some View {
        Color.black.ignoresSafeArea()
            .opacity(Double(config.dimValue * progress))
            .frame(width: width, height: height)
            .contentShape(Rectangle())
            .allowsHitTesting(active)
            .onTapGesture { close() }
            .gesture(dragGesture(menuPx: menuPx, sign: sign))
            .accessibilityLabel(Text("Close menu"))
            .accessibilityAddTraits(.isButton)
            .accessibilityHidden(!isOpen)
    }

    private func edgeDragZone(menuPx: CGFloat, sign: CGFloat, size: CGSize) -> some View {
        let width = config.edgeSwipeWidth
        let x: CGFloat = sign > 0 ? 0 : size.width - width
        return Color.clear
            .frame(width: width, height: size.height)
            .contentShape(Rectangle())
            .offset(x: x)
            .allowsHitTesting(!isOpen && width > 0)
            .gesture(dragGesture(menuPx: menuPx, sign: sign))
            .accessibilityHidden(true)
    }

    private func dragGesture(menuPx: CGFloat, sign: CGFloat) -> some Gesture {
        DragGesture(minimumDistance: 10, coordinateSpace: .global)
            .onChanged { value in
                dragTranslation = SideMenuMath.clampedDrag(
                    isOpen: isOpen,
                    rawTranslationWidth: value.translation.width,
                    menuPx: menuPx,
                    sign: sign
                )
            }
            .onEnded { value in
                let willOpen = SideMenuMath.willOpen(
                    isOpen: isOpen,
                    predictedTranslationWidth: value.predictedEndTranslation.width,
                    menuPx: menuPx,
                    sign: sign
                )
                if willOpen != isOpen && config.hapticFeedback {
                    UIImpactFeedbackGenerator(style: .medium).impactOccurred()
                }
                withAnimation(snapAnimation) {
                    isOpen = willOpen
                    dragTranslation = 0
                }
            }
    }

    private func close() {
        withAnimation(snapAnimation) { isOpen = false }
    }

    private var snapAnimation: Animation {
        reduceMotion
            ? .linear(duration: 0.2)
            : .spring(response: 0.32, dampingFraction: 1.0)
    }
}
